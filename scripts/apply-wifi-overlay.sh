#!/usr/bin/env bash
set -Eeuo pipefail
DEVICE_TREE=${1:?device tree path required}
OVERLAY=${2:?overlay path required}

[[ -d "$DEVICE_TREE" ]] || { echo "Missing device tree: $DEVICE_TREE" >&2; exit 2; }
[[ -d "$OVERLAY" ]] || { echo "Missing Wi-Fi overlay: $OVERLAY" >&2; exit 2; }

# Deliberately refuses proprietary blobs in Git. Supply only redistributable configs/scripts.
if find "$OVERLAY" -type f \( -name '*.so' -o -name '*.ko' -o -name '*.bin' -o -name '*.mbn' \) | grep -q .; then
  echo "Binary/proprietary Wi-Fi blobs are not accepted by this overlay script." >&2
  exit 3
fi

rsync -a --checksum "$OVERLAY/" "$DEVICE_TREE/"
echo "Applied Wi-Fi overlay to $DEVICE_TREE"
