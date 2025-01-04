# **English** | [Indonesia](https://github.com/ryukora/mybiznet-bandwidth-prometheus/blob/main/README-id.md)

# MyBiznet Bandwidth Monitor
Scraping data from app MyBiznet (app.biznet.id) to Prometheus -> Grafana.

This project facilitates monitoring bandwidth usage from the MyBiznet application (app.biznet.id) by integrating it with Prometheus and Grafana. The integration enables users to visualize their bandwidth consumption through Grafana dashboards, providing insights into their internet usage patterns.

![gZC85XF](https://i.imgur.com/gZC85XF.png)

## Setup Overview

- Data Scraping with Shell Script
  > A shell script (biznet.sh) is employed to extract bandwidth data from the MyBiznet application. This script can be scheduled to run at regular intervals using cron, ensuring continuous data collection.

- Prometheus Integration
  > Prometheus is configured to scrape the data collected by the shell script. The scraped metrics are stored in Prometheus's time-series database, making them available for querying and analysis.

- Grafana Dashboard
  > A pre-built Grafana dashboard template (Biznet-Home-Quota.json) is provided for visualizing the bandwidth data. Users can import this template into their Grafana instance to gain immediate access to visual representations of their bandwidth usage.

# Tutorials

## Crontab (Run Automatic Scripts)
1. Visit https://crontab.guru/
2. Make a folder ``mkdir /root/{name anything you want}, example: /root/script``
3. Put the script from the [shell script](https://raw.githubusercontent.com/ryukora/mybiznet-bandwidth-prometheus/refs/heads/main/biznet.sh), Save & Apply.
4. Do ``chmod a+rx (to your file), for example: /root/boot/script``
5. Open ``crontab -e``
6. Insert ``@reboot /bin/bash (to your file), example: /root/boot/script``. Save & Apply.
7. Done.

## Import to Grafana with Template
1. Download [this template here](https://github.com/ryukora/mybiznet-bandwidth-prometheus/raw/refs/heads/main/Biznet-Home-Quota.json).
2. Open the Grafana Dashboard.
3. Add New, then Import.
4. Upload the dashboard JSON file and put anything in your desired folder.
5. Change UID if necessary.
6. Import.
7. Done.
