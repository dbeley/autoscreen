#!/usr/bin/env bash
set -eEu -o pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)"
TODAY="$(date +%Y-%m-%d)"
HOSTNAME="$(cat /proc/sys/kernel/hostname)"
DESTINATION_DIR="${AUTOSCREEN_DESTINATION_DIR:-$HOME/Nextcloud/07_Images/01_autoscreen}/$TODAY"
FILENAME_SUFFIX="${AUTOSCREEN_FILENAME_SUFFIX:-}"

mkdir -p "$DESTINATION_DIR"
grim "${DESTINATION_DIR}/$(date +%Y-%m-%d_%H:%M:%S_%s)_${HOSTNAME}_${FILENAME_SUFFIX}autoscreen.png"
