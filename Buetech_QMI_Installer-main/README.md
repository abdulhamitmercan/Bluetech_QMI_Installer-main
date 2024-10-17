# Bluetech_QMI_Installer
QMI (wwan0) interface installer for providing internet connection using Quectel modules.

## Before installing the library for GSM module
First, update your system and install the required libraries:
`sudo apt update && sudo apt install libqmi-utils udhcpc`

## Download the QMI installation script

`wget https://raw.githubusercontent.com/abdulhamitmercan/Bluetech_QMI_Installer-main/refs/heads/main/Buetech_QMI_Installer-main/qmi_install.sh`
`+x qmi_install.sh`
`./qmi_install.sh`

## Download and run the auto-connect script to enable automatic connection
`wget https://raw.githubusercontent.com/abdulhamitmercan/Bluetech_QMI_Installer-main/refs/heads/main/Buetech_QMI_Installer-main/install_auto_connect.sh`
`+x install_auto_connect.sh`
`./install_auto_connect.sh`

Once the installation is completed.
default APN is `"internet"` 

your Raspberry Pi will reboot.
After the reboot,you can use custom APN, username, and password 




## How to Reconnect Using Custom APN, Username, and Password

This script allows you to pass parameters such as APN, username, and password to a bash script (`qmi_reconnect.sh`) to attempt a connection.

### Prerequisites
- A bash script located at `/usr/src/qmi_reconnect.sh`.
- The script should accept three arguments: APN, Username, and Password.

### Script Example

```python
import subprocess

# Parameters passed from outside
apn = "my_custom_apn"          # You can specify your APN here
username = "my_username"       # Specify your username here
password = "my_password"       # Specify your password here

# Running the bash script with APN, username, and password as arguments
try:
    # Pass APN, username, and password as arguments
    subprocess.run(["/usr/src/qmi_reconnect.sh", apn, username, password], check=True)
    print(f"Connection attempt with APN '{apn}', Username '{username}', and Password '{password}'.")
except subprocess.CalledProcessError as e:
    print(f"An error occurred: {e}")