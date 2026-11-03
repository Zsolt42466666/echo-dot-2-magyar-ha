# Echo Dot 2 → magyar HA hangszatellit: teljes útmutató

> ⚠️ **Brick-veszély.** A `fastbrick.sh` 10 mp-es türelmi ideje után **semmilyen körülmények között ne szakítsd meg**. Előbb mentés, utána bármi. Mindenért magad felelsz.

## 0. Letöltések

| Mi | Honnan | Ellenőrzés |
|---|---|---|
| amonet-biscuit v2.0.1 (Rortiz2) | XDA szál (botvédett: böngészőből töltsd le, majd `scp` a Linux gépre) | méret: 73 550 504 bájt |
| Fire OS NS6574 (7623) | `https://d1s31zyz7dcc2d.cloudfront.net/2026/8/3/f49aaff7-dd63-4d9c-9e9a-c17498267de5/update-kindle-biscuit_puffin-NS6574_user_7623_0013121734532.bin` | SHA-256: `64ab6d2dd85f8093abdd62c275d229c7e9fdd68e4d46892b48bdbd1d100d46d8` |
| EchoLocal 0.0.8 | `https://github.com/ygelfand/echolocal/releases/download/0.0.8/echolocal_linux_x86_64` | SHA-256: `a350601761bc52ef865eba63b7117e6a63315c9541a780bd1f6d6984b7bde396` |

Az amonet csomagot és a Fire OS képet a repo **nem** tartalmazza (az Amazon szoftvere, illetve a szerző munkája; a méret is nagy; az amonet szerzője az XDA szálban javít, ezért mindig onnan töltsd le a frisset).

Letöltés után ellenőrizd: `sha256sum <fájl>`.

---

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
| Fire OS NS6574 (7623) | Amazon CDN, lásd [02-fireos.md] |
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

---

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

---

# 3. EchoLocal telepítés

Verzió: **0.0.8** (stabil). A 0.0.9-et kerüld: 3 mp-nél hosszabb válasznál összeomlik ([issue #118](https://github.com/ygelfand/echolocal/issues/118)).

SHA-256 (`echolocal_linux_x86_64`): `a350601761bc52ef865eba63b7117e6a63315c9541a780bd1f6d6984b7bde396`

```bash
cd ~/echo
curl -LO https://github.com/ygelfand/echolocal/releases/download/0.0.8/echolocal_linux_x86_64
sha256sum echolocal_linux_x86_64
chmod +x echolocal_linux_x86_64
```

Az eszköz legyen az adb-n elérhető (Fire OS fut vagy TWRP, lásd az EchoLocal README-t).

```bash
./echolocal_linux_x86_64 install --name jarvis-dot --reboot
```

- A Wi-Fi hálózatot a telepítő promptban választod ki
- **A jelszót csak a terminálba gépeld**, ne parancssori argumentumba, ne chatbe, ne issue-ba
- A végén kiír egy **PSK**-t (encryption key), ezt kell majd a HA ESPHome párosításnál megadni. Ne publikáld.
- Ha a végén ilyen jön: `service is stopping 10s after ctl.stop`, az ártalmatlan időtúllépés, futtasd újra a telepítőt.

Az eszköz ezután ESPHome-eszközként jelentkezik, TCP 6053-on.

---

# 4. Home Assistant: párosítás és magyar Assist pipeline

## 4.1 ESPHome párosítás

*Beállítások → Eszközök → ESPHome → Hozzáadás* → `<ECHO_IP>:6053` → add meg az `echolocal install` végén kiírt PSK-t (titkosított kapcsolat).

- Eszköznév: `jarvis-dot` (ebből lesz az entitás-előtag `jarvis_dot_`), terület szerint rendezd (nálam Ebédlő)
- ~43 entitás jön létre: wake word választó, asszisztens választó, mikrofon gain, némítás, újraindítás gomb, stb.
- Adj fix IP-t (DHCP foglalás). Routercsere után a Dot is elveszhet.

## 4.2 Magyar Assist pipeline

*Beállítások → Hangasszisztensek → Asszisztens hozzáadása*

| Mező | Érték |
|---|---|
| Nyelv | Magyar |
| Beszédfelismerés (STT) | Home Assistant Cloud, `hu-HU` |
| Beszélgetési ágens | Google Generative AI Conversation, `gemini-2.5-flash` |
| Helyi parancsok előnyben | **bekapcsolva** (`prefer_local_intents`) |
| Szövegfelolvasás (TTS) | Home Assistant Cloud, `NoemiNeural` (női) vagy `TamasNeural` (férfi) |

Az eszközön: `select.jarvis_dot_asszisztens` → ez az asszisztens.

Miért ez a kombináció:
- A helyi intentek (lámpa, kapcsoló, stb.) azonnal és ingyen mennek, az LLM csak azt kapja, amit a helyi egyezés nem talált el. Ettől lesz a szabad magyar beszéd is használható.
- A beépített HA-parancsmegfeleltetés magyarul túl merev. Az LLM fallback ezt oldja meg.
- STT-nek a Google saját STT-jét is kipróbáltam; a HA Cloud hu-HU gyorsabb és stabilabb volt.

> **Nabu Casa előfizetés nélkül:** STT-nek Wyoming/faster-whisper (magyar modell), TTS-nek Piper vagy más helyi motor jöhet. **Ezt én nem teszteltem.** A magyar minőség és a sebesség eltérhet, főleg gyenge szerveren.

## 4.3 Wake word és hangbeállítások

| Entitás | Érték |
|---|---|
| `select.jarvis_dot_ebreszto_szo` | **Okay Nabu** |
| Mikrofon mixelés | Delay and sum |
| Mikrofon gain | 20 |
| Wake érzékenység | 0.75 (második asszisztensnél 0.85) |
| Bluetooth proxy | ki |
| Minimum CPU magok | 2 (load ~6 normális, ne ijedj meg) |

Miért nem "Jarvis": lásd a 6. fejezetet.

## 4.4 Éjszakai újraindítás

Naponta 04:00-kor újraindítja a Dotot: [ha/automations/echo_dot_ejszakai_ujrainditas.yaml](ha/automations/echo_dot_ejszakai_ujrainditas.yaml)

---

# 5. Gemini utasítás és entitás-exposure

Itt dől el, hogy a Dot hasznos vagy veszélyes.

## 5.1 Mit tegyél az utasításba (instructions)

Az ágens beállításánál az utasítás szövegébe ezek kellenek (saját szavaiddal, magyarul):

1. **Személyiség és hossz:** röviden, magyarul, természetesen válaszol (a TTS miatt 1-3 mondat).
2. **Terület-szabály:** "kapcsold fel az ebédlőt" = csak az ott lévő **lámpák**, semmi más.
3. **Tiltás:** soha ne nyúljon a mikrofonhoz, némításhoz vagy a Dot saját entitásaihoz.
4. **Kényes eszközök:** kapu, zár, fagyasztó csak akkor, ha név szerint, kifejezetten kérik.
5. **Script-válasz:** ha egy script szöveget ad vissza, azt szóról szóra mondja el.

Minta (rövidítve, igazítsd a saját házadhoz):

```
Magyarul beszélsz, röviden és természetesen válaszolsz, mert a válaszodat hangosan felolvassák.
Ha egy helyiséget kérnek ("kapcsold fel az ebédlőt"), csak az ott lévő lámpákat kapcsold, mást ne.
Soha ne nyúlj a mikrofonhoz, a némításhoz vagy a hangsatellit saját entitásaihoz.
A kaput, zárat és fagyasztót csak akkor kezeld, ha név szerint kérik.
Ha egy script szöveges összefoglalót ad vissza, azt szóról szóra olvasd fel.
```

## 5.2 Exposure: csak azt add át, amit hangról is akarsz

*Beállítások → Hangasszisztensek → Elérhetővé tett entitások.*

Nálam kikerült:

- kamerák autofokusz / IR / ablaktörlő kapcsolói
- browser_mod entitások
- duplikált media playerek
- "összes be / összes ki" jelenetek
- **a Dot saját entitásai** (`jarvis_dot_*`)
- nagy fogyasztók (3,6 kW-os fűtés)
- szoba nem-lámpa entitásai

**Miért:** a Gemini a "kapcsold fel az ebédlőt"-et egész területre értelmezte, és egyszer lenémította a Dot saját mikrofonját. Ha túl sok entitást látja, hibázik. Plusz az exposed lista adja a prompt hosszát, tehát a költséget és a sebességet is.

## 5.3 Gemini kvóta

A gemini-2.5-flash ingyenes szintjén napi 20 kérés van modellenként. Egy aktív hangasszisztens ezt gyorsan elhasználja, és `429 ... exceeded your current quota` hibát kapsz. Ellenőrizd a használt API-kulcs projektjének kvótáit a Google AI Studióban. A legtöbb parancs (lámpa, kapcsoló) helyben fut, tehát az LLM csak a maradékot kapja.

## 5.4 Gemini válaszidő

- Kapcsold ki vagy csökkentsd a "thinking" költségvetést, ha a beállítás elérhető (gyorsabb, olcsóbb)
- Kevesebb exposed entitás = rövidebb prompt = gyorsabb válasz

---

# 6. Miért lett Jarvisból Okay Nabu

EchoLocal wake word-ként a "Hey Jarvis" és az "Okay Nabu" (meg a többi microWakeWord modell) között lehet választani.

## Jarvis

- Szebb név, de megbízhatatlan: nálam ~10 cm-ről is csak másodjára hallotta meg
- A hangsávon a zaj (konyha, TV) sokszor elnyelte

## Okay Nabu

- Hosszabb, jobban elkülönülő hangalak, lényegesen megbízhatóbb
- Kicsit túl is reagál (néha olyanra is, ami nem neki szólt), ezen az érzékenység csökkentésével lehet csiszolni
- Ha "Jarvis"-nak akarod hívni, az **ágens személyiségében** hívhatod így; a wake word marad Nabu

## Más wake word nincs?

Az EchoLocal 0.0.8-ban nincs szabadon választható magyar wake word, csak az előre betanított modellek. Saját modell (microWakeWord) tanítható, de az külön projekt.

## Beállítás

`select.jarvis_dot_ebreszto_szo` → **Okay Nabu**. Az érzékenységet (0.75) a környezetedhez igazítsd.

---

# 7. Hangvezérelt kiosk (HP t520)

"Okay Nabu, mutasd a szennyvíztartályt / gázórát / az otthonom / a kamerákat": a kiosk átvált az adott dashboardra, a Dot pedig felolvassa az összefoglalót.

## A minta

1. **HA script** `browser_mod.navigate`-tel a kiosk böngészőre (`browser_id`: a saját browser_mod azonosítód). A `popup` nálam nem renderel, a `navigate` igen.
2. **`variables`**: a felolvasandó szöveg Jinja sablonból. Egy `variables:` blokkon belül csak olyat használhatsz, ami előbb van deklarálva, ezért kell két külön blokk.
3. **`stop` + `response_variable`**: így a script szöveget ad vissza az ágensnek.
4. A script `description`-je: *"A válaszban kapott összefoglalót mondd el szóról szóra, semmit ne hagyj ki."*
5. A scriptet tedd elérhetővé a hangasszisztensnek (exposure), és adj neki **aliasokat** ("tartály", "gázóra", "otthon", "kamerák").

Minta scriptek: [ha/scripts/](ha/scripts/). Dashboardok: [ha/dashboards/](ha/dashboards/) (`kiosk_mode`: fejléc és oldalsáv elrejtve).

## Gyakori buktatók

- A kiosk browser_mode-ja kiesik, ha a böngésző profilban a **Háttérkapcsolatok felfüggesztése** be van kapcsolva: kapcsold ki.
- Törölt local storage = új browser ID.
- Az egy mondatban többféle parancs ("kapcsold fel és mutasd") néha összezavarja az ágenst: tartsd a parancsot egyszerűnek.

---

# 8. Hibák és megoldások

| Tünet | Ok / megoldás |
|---|---|
| Fastboot helyett normál boot (kék/sárga gyűrű, beszéd) | Action gombot **bedugás előtt** és közben tartsd; fekete USB 2.0 port közvetlenül a gépen |
| Eszköz nem látszik | ModemManager `inactive`? Másik kábel/port? |
| SSH megszakad munka közben | Mindent tmuxban futtass: `tmux attach -t echo` |
| Parancs a Windows cmd-ben nem megy | Linuxos SSH ablakba kell; cmd-ben jobb klikk = beillesztés |
| `service is stopping 10s after ctl.stop` | Ártalmatlan, futtasd újra az `echolocal install`-t |
| EchoLocal összeomlik hosszú válasznál | 0.0.9-es bug ([#118](https://github.com/ygelfand/echolocal/issues/118)), maradj 0.0.8-on |
| Gemini `429 ... quota` | Ingyenes szint limitje; ellenőrizd a kulcs projektjének kvótáit |
| LLM egész területet kapcsol | Szűkítsd az exposure-t, tedd az utasításba a terület-szabályt |
| A Dot lenémította magát | Vedd ki a Dot saját entitásait az Assistból |
| Wake word megbízhatatlan | Okay Nabu, állítsd az érzékenységet |
| A script válaszát nem olvassa fel | `description`: "szó szerint olvasd fel"; `stop` + `response_variable` |
| HA: változó használata deklaráció előtt | Külön `variables:` blokkok egymás után |
| A Dot lassú / nagy load | CPU load ~6 normális; minimum CPU magok 2, Bluetooth proxy ki |

## Visszaút

Csak a mentésből: TWRP-ből `mmcblk0.img.gz` visszaírása. Ezért a 2. fejezet mentése kihagyhatatlan.

---

## 9. Az SSH parancsok egyben

Lépésenként másold, ne egyben futtasd.

```bash
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
```


## Kreditek

- **Rortiz2**: amonet-biscuit (XDA)
- **ygelfand**: [EchoLocal](https://github.com/ygelfand/echolocal)
- **HuskerMinion**: [techo5-dot](https://github.com/HuskerMinion/techo5-dot)
- Home Assistant, ESPHome, Nabu Casa
