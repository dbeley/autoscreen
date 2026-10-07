#!/usr/bin/env bash
set -eEu -o pipefail
TODAY="$(date +%Y-%m-%d)"
HOSTNAME="$(cat /proc/sys/kernel/hostname)"
DESTINATION_DIR="${AUTOSCREEN_DESTINATION_DIR:-$HOME/Nextcloud/07_Images/01_autoscreen}/$TODAY"
FILENAME_SUFFIX="${AUTOSCREEN_FILENAME_SUFFIX:-}"
FORMAT="${AUTOSCREEN_FORMAT:-png}"
QUALITY="${AUTOSCREEN_QUALITY:-90}"

mkdir -p "$DESTINATION_DIR"
TARGET="${DESTINATION_DIR}/$(date +%Y-%m-%d_%H:%M:%S_%s)_${HOSTNAME}_${FILENAME_SUFFIX}autoscreen"

case "$FORMAT" in
  # grim can write these directly
  png)
    grim "${TARGET}.png"
    ;;
  jpeg)
    grim -t jpeg -q "$QUALITY" "${TARGET}.jpg"
    ;;
  ppm)
    grim -t ppm "${TARGET}.ppm"
    ;;
  # grim cannot emit these: capture to a temporary PNG, then re-encode
  webp | avif | jxl)
    tmp="$(mktemp --suffix=.png)"
    trap 'rm -f "$tmp"' EXIT
    grim "$tmp"
    case "$FORMAT" in
      webp) cwebp -quiet -q "$QUALITY" "$tmp" -o "${TARGET}.webp" ;;
      avif) avifenc -s 6 -q "$QUALITY" "$tmp" "${TARGET}.avif" >/dev/null ;;
      jxl) cjxl "$tmp" "${TARGET}.jxl" -q "$QUALITY" -e 7 ;;
    esac
    ;;
  *)
    echo "autoscreen: unsupported AUTOSCREEN_FORMAT '$FORMAT' (png, jpeg, ppm, webp, avif, jxl)" >&2
    exit 1
    ;;
esac
