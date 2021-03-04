#!/usr/bin/env bash
set -eEu -o pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)"
TODAY="$(date +%Y-%m-%d)"
DESTINATION_DIR="$HOME/autoscreen/$TODAY"

mkdir -p "$DESTINATION_DIR"
maim -m 10 "$DESTINATION_DIR/autoscreen_$(date +%s).png"
