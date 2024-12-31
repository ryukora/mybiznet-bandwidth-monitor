# MyBiznet Bandwidth Prometheus
Scraping data from app MyBiznet (app.biznet.id) to Prometheus -> Grafana

# Crontab Tutorial (Run Automatic Scripts)
1. Visit https://crontab.guru/
2. Make a folder ``mkdir /root/{name anything you want}, example: /root/script``
3. Put the script from the shell script, Save & Apply.
4. Do chmod a+rx (to your file), for example: /root/boot/script
5. Open ``crontab -e``
6. Insert ``@reboot /bin/bash (to your file), example: /root/boot/script``. Save & Apply.
7. Done
