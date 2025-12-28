#!/bin/bash
set -e

echo "🚀 Installing VoIP Backend API"

BACKEND_DIR="/opt/voip-backend"
BACKEND_PORT="9000"

# Install Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Create backend directory
mkdir -p $BACKEND_DIR
cd $BACKEND_DIR

# Init project (if not exists)
if [ ! -f package.json ]; then
    npm init -y
fi

# Install dependencies
npm install express mysql2 cors dotenv

# Backend code
cat > index.js <<EOF
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createPool({
  host: 'localhost',
  user: 'voipuser',
  password: 'RUDRA@4991DJ',
  database: 'voip_panel'
});

app.get('/health', (req, res) => {
  res.json({ status: 'OK', service: 'VoIP Backend API' });
});

app.get('/cdr', (req, res) => {
  db.query('SELECT * FROM cdr_logs ORDER BY id DESC LIMIT 50', (err, rows) => {
    if (err) return res.status(500).json(err);
    res.json(rows);
  });
});

app.listen($BACKEND_PORT, () => {
  console.log('Backend API running on port $BACKEND_PORT');
});
EOF

# systemd service
cat > /etc/systemd/system/voip-backend.service <<EOF
[Unit]
Description=VoIP Panel Backend API
After=network.target mariadb.service

[Service]
Type=simple
User=root
WorkingDirectory=$BACKEND_DIR
ExecStart=/usr/bin/node index.js
Restart=always
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

# Enable & start service
systemctl daemon-reload
systemctl enable voip-backend
systemctl restart voip-backend

echo "✅ Backend API installed & running"
