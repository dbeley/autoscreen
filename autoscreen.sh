#!/usr/bin/env bash
set -eEu -o pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P)"

maim "autoscreen_$(date +%s).png"
