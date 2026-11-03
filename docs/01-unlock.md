# 1. Előkészítés és unlock (amonet)

## Amit használtam

- Echo Dot 2. gen (RS03QR), micro USB kábel
- Debian gép (HP t520), SSH-n keresztül elérve, **tmux-ban dolgozva** (az SSH megszakadhat, a tmux megvédi a munkát)
- A **fekete USB 2.0 port közvetlenül a gépen** (hub, USB 3 kék port: gondok)

## Csomagok

```bash
su -
apt install -y adb unzip curl python3 tmux
exit

mkdir -p ~/echo && cd ~/echo
tmux new -s echo
```

> Az indulásnál megjelenő `rgb:0c0c/...` színkód-szemét a tmuxban ártalmatlan.

ModemManager ne fusson (zavarja a Preloader USB-t):

```bash
systemctl is-active ModemManager   # "inactive" kell
```

## Letöltések

| Mi | Honnan |
|---|---|
| amonet-biscuit v2.0.1 | XDA szál (Rortiz2). Botvédett, böngészőből töltsd le, majd `scp` a gépre. 73 550 504 bájt |
| Fire OS NS6574 (7623) | Amazon CDN, lásd [02-fireos.md](02-fireos.md) |
| EchoLocal 0.0.8 | GitHub release |

```bash
cd ~/echo
unzip amonet-biscuit-v2.0.1.zip      # -> ~/echo/amonet
cd amonet
chmod +x bin/fastboot
```

## Boot módok

| Gomb a bedugáskor | Mód | Gyűrű |
|---|---|---|
| Action | stock fastboot | zöld |
| Mute | Preloader USBDL | – |
| Vol Up | TWRP | fehér |
| Vol Down | hacked fastboot | szivárvány |

## Ellenőrzés fastbootban

**Tartsd nyomva az Action gombot, mielőtt és míg bedugod a micro USB-t.** Ha kék/sárga gyűrű és beszéd jön, normál boot volt, próbáld újra.

```bash
./bin/fastboot devices
./bin/fastboot getvar product
./bin/fastboot getvar unlock_status
./bin/fastboot getvar lk_build_desc
```

Az enyémen az LK: `63cb91b-20221007_072309`, ehhez a `fastbrick-20221007.img` payload való. Egy későbbi LK build (`41fb3ce-20221007_151724`) esetén a `profile.sh`-ba IMAP-sor kell, olvasd el a szálat.

```bash
cat profile.sh
echo $TMUX                  # nem lehet üres: tmuxban vagy
systemctl is-active ModemManager
```

## Fastbrick

```bash
./fastbrick.sh
```

- `YES`-t kér
- a 10 mp-es türelmi idő **után ne szakítsd meg**
- a vége: **fehér gyűrű = TWRP**

```bash
adb devices
adb shell id
adb shell getprop ro.twrp.version      # 3.7.0_9-0
adb shell bcbtool get_active
```

Következő: [02-fireos.md](02-fireos.md)
