#!/bin/bash
set -e

echo "======================================"
echo " VoxportCS VoIP Panel Bootstrap"
echo "======================================"

# Requirements
apt update
apt install -y git curl

# Clone installer repo
INSTALL_DIR="/root/voxport-installer"

if [ -d "$INSTALL_DIR" ]; then
  echo "[*] Installer already exists, updating..."
  cd $INSTALL_DIR
  git pull
else
  git clone https://github.com/voxportcs/voxport-installer.git $INSTALL_DIR
  cd $INSTALL_DIR
fi

# Permissions
chmod +x *.sh

# Run real installer
./install.sh
