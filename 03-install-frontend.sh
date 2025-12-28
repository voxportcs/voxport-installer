#!/bin/bash
set -e

echo "[*] Installing VoxportCS Frontend..."

WEB_ROOT="/var/www/voip-panel"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)/frontend"

if [ ! -d "$SRC_DIR" ]; then
  echo "[ERROR] Frontend source not found in installer repo"
  echo "Expected: $SRC_DIR"
  exit 1
fi

mkdir -p $WEB_ROOT
cp -r "$SRC_DIR/"* "$WEB_ROOT/"

chown -R www-data:www-data $WEB_ROOT
chmod -R 755 $WEB_ROOT

echo "[OK] Frontend installed at $WEB_ROOT"
