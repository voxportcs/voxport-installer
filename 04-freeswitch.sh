#!/bin/bash
set -e

echo "📞 Installing FreeSWITCH..."

# Dependencies
apt update
apt install -y gnupg2 wget lsb-release

# SignalWire FreeSWITCH repo
TOKEN="pat_PUZSaKfJ2sj91UfgwB96NSU9"

apt update && apt install -y curl

wget -O - https://freeswitch.org/fsget | bash -s "$TOKEN" release install

# Enable & start FreeSWITCH
systemctl enable freeswitch
systemctl start freeswitch

# Ensure recordings directory
mkdir -p /var/lib/freeswitch/recordings
chown -R freeswitch:freeswitch /var/lib/freeswitch/recordings

# ESL check
sleep 5
fs_cli -x "status" || true

echo "✅ FreeSWITCH installed & running"
