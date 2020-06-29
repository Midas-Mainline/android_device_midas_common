#!/system/bin/sh
mkdir -p /storage/sys/power/
touch /storage/sys/power/state
mount -o bind /storage/sys/power/state /sys/power/state
