#!/usr/bin/env bash
# Az Echo Dot 2 folyamat parancsai egyben. NEM kell egyben lefuttatni:
# lépésenként másold ki, és olvasd el a docs/ leírást. tmux-ban dolgozz.
# A Wi-Fi jelszót és a PSK-t soha ne írd ide.
set -euo pipefail

cd ~/echo/amonet
chmod +x bin/fastboot

# --- 1. Action gomb nyomva + micro USB -> zöld gyűrű ---
./bin/fastboot devices
./bin/fastboot getvar product
./bin/fastboot getvar unlock_status
./bin/fastboot getvar lk_build_desc

# --- 2. Fastbrick (YES, 10 mp után TILOS megszakítani) ---
./fastbrick.sh

# --- 3. TWRP ---
adb devices
adb shell getprop ro.twrp.version
adb shell bcbtool get_active

# --- 4. Mentés ---
adb shell umount /sdcard || true
adb shell umount /data   || true
adb shell umount /cache  || true
mkdir -p ~/echo/backup
for p in mmcblk0boot0 mmcblk0boot1 mmcblk0; do
  adb exec-out "gzip -c /dev/block/$p" > ~/echo/backup/$p.img.gz
done

# --- 5. Fire OS, kétszer (lásd docs/02-fireos.md) ---
FW=update-kindle-biscuit_puffin-NS6574_user_7623_0013121734532.bin
adb shell twrp wipe cache
adb shell twrp wipe data
adb push ~/echo/$FW /sdcard/update.zip
adb shell twrp install /sdcard/update.zip > ~/echo/ota-first.log 2>&1
# adb reboot recovery -> megismétlés -> ota-second.log

# --- 6. EchoLocal ---
cd ~/echo
chmod +x echolocal_linux_x86_64
./echolocal_linux_x86_64 install --name jarvis-dot --reboot
