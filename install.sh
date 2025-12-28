#!/bin/bash
set -e

echo "======================================"
echo " VoxportCS VoIP Panel Installer"
echo "======================================"

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

chmod +x $BASE_DIR/*.sh

$BASE_DIR/00-check-os.sh
$BASE_DIR/00-configure.sh
$BASE_DIR/01-db.sh
$BASE_DIR/02-backend.sh
$BASE_DIR/04-freeswitch.sh
$BASE_DIR/03-install-frontend.sh
$BASE_DIR/05-nginx.sh
$BASE_DIR/99-finish.sh
