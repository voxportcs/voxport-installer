#!/bin/bash
set -e

echo "[*] Installing VoxportCS Frontend..."

WEB_ROOT="/var/www/voip-panel"

# Create directories
mkdir -p $WEB_ROOT
mkdir -p $WEB_ROOT/assets/{css,js,images,fonts}
mkdir -p $WEB_ROOT/modules

# If frontend source exists (local dev copy)
if [ -d "/root/frontend" ]; then
  echo "[*] Copying frontend from /root/frontend"
  rsync -av /root/frontend/ $WEB_ROOT/
else
  echo "[WARN] /root/frontend not found"
  echo "Make sure index.html, login.html, assets/, modules/ exist"
fi

# Permissions
chown -R www-data:www-data $WEB_ROOT
chmod -R 755 $WEB_ROOT

echo "[OK] Frontend installed at $WEB_ROOT"
