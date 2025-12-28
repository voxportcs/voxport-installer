#!/bin/bash
set -e

echo "[*] Checking OS compatibility..."

if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run installer as root"
  exit 1
fi

if [ ! -f /etc/os-release ]; then
  echo "[ERROR] Cannot detect OS"
  exit 1
fi

. /etc/os-release

if [[ "$ID" != "debian" || "$VERSION_ID" != "12" ]]; then
  echo "[ERROR] Unsupported OS: $PRETTY_NAME"
  echo "This installer supports Debian 12 only"
  exit 1
fi

echo "[OK] Debian 12 detected"
