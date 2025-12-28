#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$BASE_DIR/config.env"

echo "======================================"
echo " VoxportCS Initial Configuration"
echo "======================================"

read -p "Admin username [admin]: " ADMIN_USER < /dev/tty
ADMIN_USER=${ADMIN_USER:-admin}

read -s -p "Admin password: " ADMIN_PASS < /dev/tty
echo

read -s -p "Database password for voipuser: " DB_PASS < /dev/tty
echo

read -p "Domain or Server IP: " DOMAIN < /dev/tty
read -p "SignalWire FreeSWITCH TOKEN: " FS_TOKEN < /dev/tty

cat > "$CONFIG" <<EOF
ADMIN_USER=$ADMIN_USER
ADMIN_PASS=$ADMIN_PASS

DB_NAME=voip_panel
DB_USER=voipuser
DB_PASS=$DB_PASS

DOMAIN=$DOMAIN
FS_TOKEN=$FS_TOKEN
EOF

chmod 600 "$CONFIG"

echo "✅ Configuration saved at $CONFIG"
