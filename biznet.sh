#!/bin/bash

# API URLs
login_url="https://mybiznet.biznetform.com/api/login"
request_url="https://mybiznet.biznetform.com/api/getQuota?contractNumber=000000xxxxxx"
bandwith_url="https://mybiznet.biznetform.com/api/getBandwidth?contractNumber=000000xxxxxx"

# Login credentials
username="xxxxxxxxxxxxxx"
password="xxxxxxxxxxxxxx"
login_payload=$(printf '{"username":"%s","password":"%s"}' "$username" "$password")

# File paths to store token and quota for Prometheus
token_file="/tmp/mybiznet_token.txt"
quota_file="/var/lib/prometheus/node-exporter/mybiznet_quota.prom"
quota_dir=$(dirname "$quota_file")

# Ensure the directory exists
if [ ! -d "$quota_dir" ]; then
    echo "Directory $quota_dir does not exist. Creating it..."
    mkdir -p "$quota_dir"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory $quota_dir"
        exit 1
    fi
fi

# Function to login and get a new token
fetch_new_token() {
    echo "Logging in to get a new token..."
    login_response=$(curl -s -X POST "$login_url" -H "Content-Type: application/json" --data "$login_payload")
    echo "Login response: $login_response"

    # Extract token from the response
    token=$(echo "$login_response" | jq -r '.["api-token"]')

    if [ -z "$token" ] || [ "$token" == "null" ]; then
        echo "Error: Failed to retrieve API token. Response: $login_response"
        exit 1
    fi

    # Store the token in a file
    echo "$token" > "$token_file"
    echo "New token saved: $token"
}

# Function to make the quota request with retry logic
fetch_quota_data() {
    token=$(cat "$token_file")
    attempts=0
    max_attempts=5
    success=0

    while [ $attempts -lt $max_attempts ]; do
        response=$(curl -s -w "%{http_code}" -o /tmp/quota_response.json -X GET "$request_url" -H "Api-token: $token")
        response_code="${response: -3}"
        
        response1=$(curl -s -w "%{http_code}" -o /tmp/bandwith_response.json -X GET "$bandwith_url" -H "Api-token: $token")
        response1_code="${response1: -3}"

        # Check if both responses were successful
        if [ "$response_code" == "200" ] && [ "$response1_code" == "200" ]; then
            success=1
            break
        elif [[ "$response_code" =~ ^(000|500|502|503|524)$ || "$response1_code" =~ ^(000|500|502|503|524)$ ]]; then
            echo "Error: Failed to retrieve quota or bandwidth data. HTTP status: $response_code, $response1_code"
            fetch_new_token
            token=$(cat "$token_file")
        else
            echo "Unrecoverable error. HTTP status: $response_code, $response1_code"
            exit 1
        fi

        attempts=$((attempts + 1))
        echo "Retrying... Attempt $attempts of $max_attempts"
    done

    if [ $success -eq 0 ]; then
        echo "Error: Exceeded maximum retry attempts."
        exit 1
    fi

    # Parse the quota data
    main_remaining=$(jq -r '.mainKuota.remainingLimit' /tmp/quota_response.json)
    main_limit=$(jq -r '.mainKuota.limit' /tmp/quota_response.json)
    free_remaining=$(jq -r '.freeKuota.remainingLimit // 0' /tmp/quota_response.json)
    free_limit=$(jq -r '.freeKuota.limit // 0' /tmp/quota_response.json)
    extra_remaining=$(jq -r '.extraKuota.remainingLimit // 0' /tmp/quota_response.json)
    extra_limit=$(jq -r '.extraKuota.limit // 0' /tmp/quota_response.json)
    valid_until=$(jq -r '.mainKuota.mainKuota.validUntil // 0' /tmp/quota_response.json)
    plan_bandwidth=$(jq -r '.data.active.bandwidth // 0' /tmp/bandwith_response.json)
    plan_uom=$(jq -r '.data.active.uom // "Mbps"' /tmp/bandwith_response.json)

    # Handle valid_until properly (with fallback to current date)
    if [ "$valid_until" == "0" ] || [ -z "$valid_until" ]; then
        echo "Warning: valid_until field is null or missing. Setting to 0."
        valid_until_timestamp=0
    else
        valid_until_timestamp=$(date -d "$valid_until" +%s)
    fi

    # Check if bandwidth is in Mbps (or other units)
    if [ "$plan_uom" == "Mbps" ]; then
        speed=$plan_bandwidth
    else
        # If it's not Mbps, you can add logic to convert to Mbps, e.g., for Gbps, etc.
        speed=$plan_bandwidth
    fi

    # Write data to Prometheus format
    cat > "$quota_file" <<EOF
# HELP mybiznet_main_quota_remaining Remaining main quota for mybiznet
# TYPE mybiznet_main_quota_remaining gauge
mybiznet_main_quota_remaining $main_remaining
# HELP mybiznet_main_quota_limit Total main quota for mybiznet
# TYPE mybiznet_main_quota_limit gauge
mybiznet_main_quota_limit $main_limit
# HELP mybiznet_free_quota_remaining Remaining free quota for mybiznet
# TYPE mybiznet_free_quota_remaining gauge
mybiznet_free_quota_remaining $free_remaining
# HELP mybiznet_free_quota_limit Total free quota for mybiznet
# TYPE mybiznet_free_quota_limit gauge
mybiznet_free_quota_limit $free_limit
# HELP mybiznet_extra_quota_remaining Remaining extra quota for mybiznet
# TYPE mybiznet_extra_quota_remaining gauge
mybiznet_extra_quota_remaining $extra_remaining
# HELP mybiznet_extra_quota_limit Total extra quota for mybiznet
# TYPE mybiznet_extra_quota_limit gauge
mybiznet_extra_quota_limit $extra_limit
# HELP mybiznet_quota_valid_until Validity of main quota in UNIX timestamp
# TYPE mybiznet_quota_valid_until gauge
mybiznet_quota_valid_until $valid_until_timestamp
# HELP mybiznet_plan_speed Internet speed from plan in Mbps
# TYPE mybiznet_plan_speed gauge
mybiznet_plan_speed $speed
EOF

    # Output message with date and time
    echo "Quota data successfully written to $quota_file on $(date)"
}

# Initial token retrieval if the file doesn't exist or is empty
if [ ! -f "$token_file" ] || [ -z "$(cat "$token_file")" ]; then
    fetch_new_token
fi

# Fetch quota data
fetch_quota_data
