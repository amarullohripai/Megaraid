#!/bin/bash

set -e

echo "================================="
echo " MegaCli Automatic Installer"
echo "================================="

# Detect package manager

if command -v dnf >/dev/null 2>&1; then
PKG="dnf"
else
PKG="yum"
fi

echo "[1/6] Installing dependencies..."

$PKG install -y wget unzip smartmontools sg3_utils

$PKG install -y ncurses-compat-libs || true

echo "[2/6] Downloading MegaCli..."

wget -O /tmp/MegaCli-8.07.14-1.noarch.rpm https://raw.githubusercontent.com/amarullohripai/Megaraid/main/MegaCli-8.07.14-1.noarch.rpm

echo "[3/6] Verifying RPM..."

file /tmp/MegaCli-8.07.14-1.noarch.rpm

echo "[4/6] Installing MegaCli..."

rpm -Uvh --force /tmp/MegaCli-8.07.14-1.noarch.rpm

echo "[5/6] Configuring alias..."

if ! grep -q "MegaCli64" ~/.bashrc; then
echo 'alias MegaCli64=/opt/MegaRAID/MegaCli/MegaCli64' >> ~/.bashrc
fi
source ~/.bashrc

echo "[6/6] Displaying RAID Information..."

/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL | grep -e '^Enclosure Device ID:' -e '^Slot Number:' -e '^Raw Size:' -e '^Firmware state:' -e 'PD Type:' -e 'Inquiry Data:'

echo ""
echo "================================="
echo " Installation Complete"
echo "================================="
