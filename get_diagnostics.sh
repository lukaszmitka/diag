#!/bin/sh

echo "Getting diagnostic data from device"
echo "This script will gather only system configuration data, it will not gather any personal data or any of your project files."
 
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

rm -rf data/
mkdir data

echo "$IFCONFIG">$IFCONFIG_FILE
echo "$LSUSB">$LSUSB_FILE
echo "$LIST_PACKAGES">$LIST_PACKAGES_FILE
echo "$LIST_DEV">$LIST_DEV_FILE
echo "$SYSTEMCTL_UNITS">$SYSTEMCTL_UNITS_FILE
echo "$ETC_HOSTS">$ETC_HOSTS_FILE

UDEV_RULES='"folder": [{
    "id": "udev_rules", 
    "label": "Udev rules",
    "file": ['
FILE_ID=$((0))
for FILENAME in /etc/udev/rules.d/*.rules; do
    NAME=${FILENAME##*/}
    cp $FILENAME ./data/$NAME
    # echo "$FILENAME with name: $NAME"
    UDEV_RULES="$UDEV_RULES { \"name\": \"./data/$NAME\", \"id\": \"udev_$FILE_ID\", \"label\": \"$NAME\" },"
    FILE_ID=$((FILE_ID+1))
done
# echo $UDEV_RULES
UDEV_RULES="${UDEV_RULES%?}"
# echo "${UDEV_RULES: : -1}"
UDEV_RULES="$UDEV_RULES]}]"

# Create json with metadata
cat > ./data/config.json <<EOF
{
  "time": {
    "local": "$SYSTEM_TIME",
    "universal": "$UNIVERSAL_TIME"
  },
  "kernel": "$KERNEL_VER",
  "uname": "$UNAME",
  "file": [
    {
      "id": "menu_01",  
      "command": "ifconfig",
      "name": "$IFCONFIG_FILE",
      "label": "Network devices"
    },
    {
      "id": "menu_02",  
      "command": "lsusb",
      "name": "$LSUSB_FILE",
      "label": "USB devices"
    },
    {
      "id": "menu_03",  
      "command": "apt list --installed",
      "name": "$LIST_PACKAGES_FILE",
      "label": "Installed packages"
    },
    {
      "id": "menu_04",  
      "command": "ifconfig",
      "name": "$LIST_DEV_FILE",
      "label": "/dev directory"
    },
    {
      "id": "menu_05",  
      "command": "systemctl list-units",
      "name": "$SYSTEMCTL_UNITS_FILE",
      "label": "Systemctl units"
    },
    {
      "id": "menu_06",  
      "command": "cat /etc/hosts",
      "name": "$ETC_HOSTS_FILE",
      "label": "Hosts"
    }
  ],
  $UDEV_RULES
}
EOF

echo "Compressing data to data.tar.gz"
tar -zcf data.tar.gz data
echo "Please send the file along with problem description to support@husarion.com"

# Cleanup
rm -rf data/
