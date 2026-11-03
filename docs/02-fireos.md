# 2. Mentés és Fire OS telepítés

## 2.1 Teljes mentés (kötelező)

Előbb unmount:

```bash
adb shell umount /sdcard
adb shell umount /data
adb shell umount /cache
adb shell cat /proc/mounts
```

Mentés gzip-pel a gépre:

```bash
mkdir -p ~/echo/backup
adb exec-out "gzip -c /dev/block/mmcblk0boot0" > ~/echo/backup/mmcblk0boot0.img.gz
adb exec-out "gzip -c /dev/block/mmcblk0boot1" > ~/echo/backup/mmcblk0boot1.img.gz
adb exec-out "gzip -c /dev/block/mmcblk0"      > ~/echo/backup/mmcblk0.img.gz
```

Ellenőrzés (méret + hash a gépen és az eszközön ugyanaz kell legyen):

```bash
gunzip -c ~/echo/backup/mmcblk0.img.gz | wc -c
gunzip -c ~/echo/backup/mmcblk0.img.gz | sha256sum
adb shell sha256sum /dev/block/mmcblk0
```

Nálam: 3 909 091 328 bájt, ~6 perc, a gz 279 MB. A mentést tárold biztonságos helyen, **ne tedd GitHubra** (eszközspecifikus adatokat tartalmaz).

## 2.2 Fire OS

Fájl: `update-kindle-biscuit_puffin-NS6574_user_7623_0013121734532.bin`
SHA-256: `64ab6d2dd85f8093abdd62c275d229c7e9fdd68e4d46892b48bdbd1d100d46d8`

(A letöltési URL az Amazon CDN-en van, a pontos linket az amonet szál tartalmazza.)

### Első telepítés

```bash
adb shell twrp wipe cache
adb shell twrp wipe data
adb push update-kindle-biscuit_puffin-NS6574_user_7623_0013121734532.bin /sdcard/update.zip
adb shell sha256sum /sdcard/update.zip           # egyezzen a fenti hash-sel
adb shell twrp install /sdcard/update.zip > ~/echo/ota-first.log 2>&1
grep -i "inactive slot" ~/echo/ota-first.log
```

A TWRP magától átbillenti az aktív slotot. **Ne futtass kézzel `bcbtool set_active`-ot.**

### Második telepítés (a másik slotra)

```bash
adb reboot recovery
# várd meg a fehér gyűrűt
adb shell bcbtool get_active
adb push update-kindle-...bin /sdcard/update.zip
adb shell twrp install /sdcard/update.zip > ~/echo/ota-second.log 2>&1
grep -i "inactive slot" ~/echo/ota-second.log
```

### Ellenőrzés

Mindkét slotra: `ro.build.id=NS6574`, incremental `0013121734532`, SDK 25.

Következő: [03-echolocal.md](03-echolocal.md)
