# Xiaomi 10S (thyme) OrangeFox GitHub Actions builder

This repository provides a reproducible GitHub Actions workflow for building an **unofficial,
temporary-test-first** OrangeFox/TWRP recovery for Xiaomi 10S (`thyme`). It does not claim
that the referenced old TWRP tree is directly compatible with OrangeFox 12.1, nor that Wi-Fi
works without a proper device-tree port and matching vendor components.

## Runner requirements

Use a self-hosted Ubuntu 22.04 runner labeled:

```text
self-hosted, linux, x64, orangefox
```

Recommended minimums:

- 16 GB RAM, 32 GB preferred
- 160 GB free SSD
- 8 CPU threads
- Java 11
- no root build user; passwordless sudo only for package installation

The workflow intentionally stops when free space is below 120 GiB.

## Before first run

1. Fork/create a repository and copy these files into it.
2. Prepare a real `fox_12.1`-compatible device tree for `device/xiaomi/thyme`.
3. Ensure its `AndroidProducts.mk` exports the selected lunch target, normally
   `twrp_thyme-eng` or `omni_thyme-eng`.
4. Add the `orangefox` label to the self-hosted runner.
5. Open **Actions > Build OrangeFox for Xiaomi 10S (thyme) > Run workflow**.
6. Enter your device-tree repository and branch.

## Outputs

A successful run uploads:

- `recovery.img` or `boot.img`, depending on tree layout
- optional `OrangeFox*.zip`
- `SHA256SUMS.txt`
- pinned repo manifest
- device-tree commit
- full build log and ccache statistics

Artifacts are retained for 30 days.

## Safe test procedure

First confirm the phone reports `thyme`, back up the current boot/vendor_boot/dtbo images
from the exact installed firmware, and test only with:

```bash
fastboot boot recovery.img
```

Do not run `fastboot flash boot`, `fastboot flash recovery`, or `fastboot flash vendor_boot`
until the image has passed display, touch, USB ADB, decryption, MTP, OTG, slot, and reboot tests.

## Wi-Fi status

The workflow can apply a source overlay, but it cannot invent the matching Qualcomm WLAN
firmware or legally redistribute proprietary vendor blobs. Wi-Fi should be developed in stages:

1. Confirm `wlan0` exists and firmware loads without an error in `dmesg`.
2. Confirm `wpa_supplicant`, `wpa_cli`, `iw`, required libraries, and DHCP are present.
3. Connect to a private WPA2 test network and obtain an IP.
4. Start TCP ADB manually, test, and stop it again.

Example manual TCP ADB commands inside a trusted private LAN:

```sh
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```

Disable it after testing:

```sh
setprop service.adb.tcp.port -1
stop adbd
start adbd
```

## Reproducibility and recovery

Each run records the exact manifest, device-tree commit, inputs, output hashes, and logs.
Never overwrite old known-good artifacts. Tag tested versions and retain the matching source
commit and stock firmware images.
