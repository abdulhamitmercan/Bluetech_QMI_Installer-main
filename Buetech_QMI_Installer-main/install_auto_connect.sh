#!/bin/sh

# APN bilgisi almak için kullanıcıdan input al
echo "What is the APN?"
read carrierapn

# Dosyaları kendi GitHub deposundan indir
wget --no-check-certificate https://raw.githubusercontent.com/abdulhamitmercan/Bluetech_QMI_Installer-main/refs/heads/main/Buetech_QMI_Installer-main/reconnect_service -O qmi_reconnect.service
wget --no-check-certificate https://raw.githubusercontent.com/abdulhamitmercan/Bluetech_QMI_Installer-main/refs/heads/main/Buetech_QMI_Installer-main/reconnect_sh -O qmi_reconnect.sh

# APN yerine kullanıcının girdiği APN'yi koy
sed -i "s/#APN/$carrierapn/" qmi_reconnect.sh

# Dosyaları doğru yerlere taşı
sudo mv qmi_reconnect.sh /usr/src/
sudo mv qmi_reconnect.service /etc/systemd/system/

# Sistem servisini yeniden yükle ve başlat
sudo systemctl daemon-reload
sudo systemctl start qmi_reconnect.service
sudo systemctl enable qmi_reconnect.service

# İşlem tamamlandı mesajı
echo "DONE"
