#!/bin/sh

echo "Getting diagnostic data from device\r\n"

UNIVERSAL_TIME=$(date -u +%Y/%m/%d-%H:%M:%S)
SYSTEM_TIME=$(date +%Y/%m/%d-%H:%M:%S)
KERNEL_VER=$(uname -r)
UNAME=$(uname -a)

IFCONFIG=$(ifconfig)
IFCONFIG_FILE="./data/ifconfig.command"

LSUSB=$(lsusb)
LSUSB_FILE="./data/lsusb.command"

LIST_PACKAGES=$(apt list --installed)
LIST_PACKAGES_FILE="./data/installed_packages"

LIST_DEV=$(ls -la /dev)
LIST_DEV_FILE="./data/dev.content"

SYSTEMCTL_UNITS=$(systemctl list-units)
SYSTEMCTL_UNITS_FILE="./data/systemctl.units"

ETC_HOSTS=$(cat /etc/hosts)
ETC_HOSTS_FILE="./data/etc_hosts.content"

echo "$IFCONFIG">$IFCONFIG_FILE
echo "$LSUSB">$LSUSB_FILE
echo "$LIST_PACKAGES">$LIST_PACKAGES_FILE
echo "$LIST_DEV">$LIST_DEV_FILE
echo "$SYSTEMCTL_UNITS">$SYSTEMCTL_UNITS_FILE
echo "$ETC_HOSTS">$ETC_HOSTS_FILE

# Create json with metadata
cat > ./data/config.json <<EOF
{
  "time": {
    "local": "$SYSTEM_TIME",
    "universal": "$UNIVERSAL_TIME"
  },
  "kernel": "$KERNEL_VER",
  "uname": "$UNAME",
  "files": [
    {
      "command": "ifconfig",
      "name": "$IFCONFIG_FILE",
      "label": "Network devices"
    },
    {
      "command": "lsusb",
      "name": "$LSUSB_FILE",
      "label": "USB devices"
    },
    {
      "command": "apt list --installed",
      "name": "$LIST_PACKAGES_FILE",
      "label": "Installed packages"
    },
    {
      "command": "ifconfig",
      "name": "$LIST_DEV_FILE",
      "label": "/dev directory"
    },
    {
      "command": "systemctl list-units",
      "name": "$SYSTEMCTL_UNITS_FILE",
      "label": "Systemctl units"
    },
    {
      "command": "cat /etc/hosts",
      "name": "$ETC_HOSTS_FILE",
      "label": "Hosts"
    }
  ]
}
EOF

echo "Compressing data to data.tar.gz"
tar -zcf data.tar.gz data
echo "Please send the file with problem description to support@husarion.com"

# Cleanup
rm -rf data/
