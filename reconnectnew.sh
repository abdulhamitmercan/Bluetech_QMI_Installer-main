#!/bin/sh
# https://github.com/abdulhamitmercan

# Dışarıdan gelen APN, kullanıcı adı ve şifreyi al, eğer verilmeyen bir parametre varsa varsayılan değer kullan
APN="${1:-internet}"
USERNAME="${2:-default_user}"
PASSWORD="${3:-default_pass}"

# /etc/resolv.conf dosyasını değiştirilmez hale getirme
sudo chattr +i /etc/resolv.conf

while true; do
    # Ping ile bağlantıyı kontrol et
    ping -I wwan0 -c 1 8.8.8.8

    # Eğer bağlantı başarılıysa
    if [ $? -eq 0 ]; then
        echo "Connection up, reconnect not required..."
    else
        echo "Connection down, reconnecting..."

        # Modemi online moda geçir
        mode=$(sudo qmicli -d /dev/cdc-wdm0 --dms-get-operating-mode)
        if [[ "$mode" != *"online"* ]]; then
            echo "Modem is offline, switching to online mode..."
            sudo qmicli -d /dev/cdc-wdm0 --dms-set-operating-mode='online'
        else
            echo "Modem is already in online mode."
        fi

        # WWAN0 interface
        echo "Configuring WWAN0 interface..."
        sudo ip link set wwan0 down
        echo 'Y' | sudo tee /sys/class/net/wwan0/qmi/raw_ip
        sudo ip link set wwan0 up

        # Veri formatını kontrol et
        echo "Checking data format..."
        sudo qmicli -d /dev/cdc-wdm0 --wda-get-data-format

        # Mobil bağlantıyı başlat
        echo "Starting mobile connection..."
        sudo qmicli -p -d /dev/cdc-wdm0 \
            --device-open-net='net-raw-ip|net-no-qos-header' \
            --wds-start-network="apn='$APN',username='$USERNAME',password='$PASSWORD',ip-type=4" \
            --client-no-release-cid

        # IP adresini al
        echo "Getting IP addresses and default routes..."

        # UdHCPC çalışıyor mu kontrol et
        if ! pgrep -x "udhcpc" > /dev/null; then
            echo "Starting udhcpc..."
            sudo udhcpc -q -f -i wwan0
        else
            echo "udhcpc is already running."
        fi

        # Servis kontrolü
        echo "Checking qmi_reconnect service..."
        if ! sudo systemctl is-active --quiet qmi_reconnect.service; then
            echo "qmi_reconnect service stopped. Restarting..."
            sudo systemctl start qmi_reconnect.service
        else
            echo "qmi_reconnect service is running."
        fi
    fi

    # 10 saniye bekle
    sleep 10
done

# Kilidi kaldırmak için (isteğe bağlı)
# sudo chattr -i /etc/resolv.conf
