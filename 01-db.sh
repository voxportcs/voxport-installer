#!/bin/bash
set -e

echo "🗄️ Installing Database (MariaDB / MySQL compatible)"

DB_NAME="voip_panel"
DB_USER="voipuser"
DB_PASS="RUDRA@4991DJ"

# Install MariaDB
apt install -y mariadb-server mariadb-client
systemctl enable mariadb
systemctl start mariadb

# Secure MariaDB (non-interactive)
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -e "FLUSH PRIVILEGES;"

# Create DB and user
mysql <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

# Schema
mysql -u$DB_USER -p$DB_PASS $DB_NAME <<EOF
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'admin',
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS cdr_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    call_id VARCHAR(64),
    caller VARCHAR(50),
    callee VARCHAR(50),
    duration INT,
    billsec INT,
    disposition VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

# Seed data
mysql -u$DB_USER -p$DB_PASS $DB_NAME <<EOF
INSERT IGNORE INTO roles (name) VALUES ('admin'),('manager'),('user');

INSERT IGNORE INTO users (id, username, password, role, status)
VALUES (1, 'admin', 'admin123', 'admin', 1);

INSERT IGNORE INTO activity_logs (user_id, action)
VALUES (1, 'Initial admin account created');
EOF

echo "✅ Database installed & seeded successfully"
