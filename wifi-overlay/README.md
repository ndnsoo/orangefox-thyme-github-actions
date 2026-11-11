# Wi-Fi overlay placeholder

This folder is intentionally empty except for documentation. Put only source-controlled,
redistributable device-tree changes here, such as init `.rc` fragments, product makefile
entries, recovery UI scripts, or SELinux source.

Do not commit proprietary Xiaomi/Qualcomm firmware or vendor libraries. Extract those from
your own matching Android 12 firmware during local development, then reference them through
a private vendor tree or a lawful build input.

A functional Recovery Wi-Fi port normally needs all of the following to match the running kernel:

- `wlan0` created by the kernel/CNSS driver
- matching Qualcomm WLAN firmware and board data
- `wpa_supplicant`, `wpa_cli`, `iw`, and DHCP client
- all required shared libraries
- `/vendor` and firmware partitions mounted early enough
- init services, permissions, device nodes, and SELinux rules

Keep TCP ADB disabled by default. Start it manually only after Wi-Fi has an IP address.
