#!/usr/bin/env bash
set -eEu -o pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)"
TODAY="$(date +%Y-%m-%d)"
# HOSTNAME="$(cat /proc/sys/kernel/hostname)"
HOSTNAME="MeLE"
DESTINATION_DIR="$HOME/Nextcloud/07_Images/01_autoscreen/$TODAY"

mkdir -p "$DESTINATION_DIR"
grim "${DESTINATION_DIR}/${HOSTNAME}_autoscreen_$(date +%Y-%m-%d_%H:%M:%S_%s).png"
