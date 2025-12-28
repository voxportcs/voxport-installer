#!/bin/bash
set -e

CONFIG="/root/installer/config.env"

echo "======================================"
echo " VoxportCS Initial Configuration"
echo "======================================"

read -p "Admin username [admin]: " ADMIN_USER
ADMIN_USER=${ADMIN_USER:-admin}

read -s -p "Admin password: " ADMIN_PASS
echo ""

read -s -p "Database password for voipuser: " DB_PASS
echo ""

read -p "Domain or Server IP: " DOMAIN

read -p "SignalWire FreeSWITCH TOKEN: " FS_TOKEN

cat > $CONFIG <<EOF
ADMIN_USER=$ADMIN_USER
ADMIN_PASS=$ADMIN_PASS

DB_NAME=voip_panel
DB_USER=voipuser
DB_PASS=$DB_PASS

DOMAIN=$DOMAIN
FS_TOKEN=$FS_TOKEN
EOF

chmod 600 $CONFIG

echo "✅ Configuration saved"
