#!/bin/bash
set -e

echo "[*] Installing & configuring Nginx..."

apt update
apt install -y nginx

SITE_CONF="/etc/nginx/sites-available/voip-panel"
SITE_LINK="/etc/nginx/sites-enabled/voip-panel"

cat > $SITE_CONF <<'EOF'
server {
    listen 80;
    server_name _;

    root /var/www/voip-panel;
    index index.html login.html;

    access_log /var/log/nginx/voip-panel.access.log;
    error_log  /var/log/nginx/voip-panel.error.log;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /modules/ {
        try_files $uri =404;
    }

    location /assets/ {
        expires 30d;
        access_log off;
    }

    location /recordings/ {
        internal;
        alias /var/lib/freeswitch/recordings/;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

# Disable default site
rm -f /etc/nginx/sites-enabled/default

# Enable our site
ln -sf $SITE_CONF $SITE_LINK

# Test and reload
nginx -t
systemctl reload nginx

echo "[OK] Nginx configured for VoxportCS"
