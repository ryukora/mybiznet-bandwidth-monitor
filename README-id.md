[English](https://github.com/ryukora/mybiznet-bandwidth-prometheus) | **Indonesia**

# MyBiznet Bandwidth Prometheus
Mengscrape data dari aplikasi MyBiznet (app.biznet.id) ke Prometheus -> Grafana.

Projek ini memudahkan monitor penggunaan bandwidth dari aplikasi MyBiznet (app.biznet.id) dengan mengintegrasikannya dengan Prometheus dan Grafana. 
Integrasi itu membolehkan pengguna menggambarkan penggunaan bandwidth melalui dashboard Grafana, memberikan pandangan tentang corak penggunaan internet mereka.

![gZC85XF](https://i.imgur.com/gZC85XF.png)

## Gambaran Keseluruhan Persediaan

- Mengscrape Data dengan Script Shell
  > Script shell (biznet.sh) digunakan untuk mengekstrak data bandwidth dari aplikasi MyBiznet. Script ini boleh dijadualkan untuk dijalankan pada selang masa yang tetap menggunakan cron, memastikan pengumpulan data berterusan.

- Integrasi Prometheus
  > Prometheus dikonfigurasikan untuk mengscrape data yang dikumpul oleh script shell. Metric yang discrape disimpan dalam pangkalan database masa Prometheus, menjadikannya tersedia untuk pertanyaan dan analisis.

- Dashboard Grafana
  > Template Grafana yang siap pakai (Biznet-Home-Quota.json) disediakan untuk menggambarkan data bandwidth. Pengguna boleh mengimport template ini ke dalam contoh Grafana mereka untuk mendapatkan akses segera kepada representasikan visual penggunaan bandwidth mereka.

# Tutorial

## Crontab (Jalankan Script Automatis)
1. Lewati https://crontab.guru/
2. Buat folder ``mkdir /root/{Nama apa saja yang mau inginkan}, contoh: /root/script``
3. Letakkan script dari shell script, Save & Apply.
4. Lakukan ``chmod a+rx (ke file anda), contoh: /root/boot/script``
5. Buka ``crontab -e``
6. Masukkan ``@reboot /bin/bash (to your file), example: /root/boot/script``. Save & Apply.
7. Selesai.

## Import ke Grafana dengan Template
1. Download [template di sini](https://github.com/ryukora/mybiznet-bandwidth-prometheus/raw/refs/heads/main/Biznet-Home-Quota.json).
2. Buka Dashboard Grafana.
3. Tambahkan New, lalu Import.
4. Upload di (Upload the dashboard JSON file) dan letakkan apa saja dalam folder yang di inginkan.
5. Ganti UID jika perlu.
6. Import.
7. Selesai.
