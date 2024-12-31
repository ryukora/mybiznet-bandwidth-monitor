# MyBiznet Bandwidth Prometheus
Scraping data from app MyBiznet (app.biznet.id) to Prometheus -> Grafana.

This project facilitates monitoring bandwidth usage from the MyBiznet application (app.biznet.id) by integrating it with Prometheus and Grafana. The integration enables users to visualize their bandwidth consumption through Grafana dashboards, providing insights into their internet usage patterns.

![gZC85XF](https://i.imgur.com/gZC85XF.png)

# Crontab Tutorial (Run Automatic Scripts)
1. Visit https://crontab.guru/
2. Make a folder ``mkdir /root/{name anything you want}, example: /root/script``
3. Put the script from the shell script, Save & Apply.
4. Do ``chmod a+rx (to your file), for example: /root/boot/script``
5. Open ``crontab -e``
6. Insert ``@reboot /bin/bash (to your file), example: /root/boot/script``. Save & Apply.
7. Done.

# Import to Grafana with Template
1. Download [this template here](https://github.com/ryukora/mybiznet-bandwidth-prometheus/raw/refs/heads/main/Biznet-Home-Quota.json).
2. Open the Grafana Dashboard.
3. Add New, then Import.
4. Upload the dashboard JSON file and put anything in your desired folder.
5. Change UID if necessary.
6. Import.
7. Done.
