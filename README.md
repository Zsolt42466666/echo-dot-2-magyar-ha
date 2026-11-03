# Echo Dot 2 → magyar nyelvű Home Assistant hangszatellit

Egy használt **Echo Dot 2. gen (RS03QR, „biscuit", MT8163)** teljes átalakítása: bootloader-unlock (amonet), Fire OS 6, majd **EchoLocal** firmware, végül magyar Assist pipeline (STT → helyi intentek → Gemini → TTS) és hangvezérelt kiosk.

Vinteden 9000 Ft volt. Rohadt mázli, hogy sikerült megvenni.

> ⚠️ **Brick-veszély.** A `fastbrick.sh` 10 mp-es türelmi ideje után **semmilyen körülmények között ne szakítsd meg**. Előbb mentés, utána bármi. Mindenért magad felelsz.

## Végeredmény

- Wake word: **Okay Nabu**
- STT: HA Cloud `hu-HU`
- Először helyi HA intentek, ha az nem találja el, Gemini (`gemini-2.5-flash`)
- TTS: HA Cloud `NoemiNeural` / `TamasNeural`
- "Mutasd az otthonom / gázórát / tartályt / kamerákat": a kiosk vált, a Dot felolvassa az összefoglalót

## Fejezetek

| # | Fájl | Tartalom |
|---|---|---|
| 1 | [docs/01-unlock.md](docs/01-unlock.md) | Előkészítés, amonet, fastbrick, TWRP |
| 2 | [docs/02-fireos.md](docs/02-fireos.md) | Teljes mentés + Fire OS mindkét slotra |
| 3 | [docs/03-echolocal.md](docs/03-echolocal.md) | EchoLocal telepítés SSH-ról |
| 4 | [docs/04-homeassistant.md](docs/04-homeassistant.md) | Párosítás, magyar pipeline, hangbeállítások |
| 5 | [docs/05-gemini-es-exposure.md](docs/05-gemini-es-exposure.md) | Utasítás, entitás-exposure, kvóta |
| 6 | [docs/06-wake-word.md](docs/06-wake-word.md) | Miért Okay Nabu, nem Jarvis |
| 7 | [docs/07-kiosk-hangvezerles.md](docs/07-kiosk-hangvezerles.md) | Hangvezérelt kiosk |
| 8 | [docs/08-hibak.md](docs/08-hibak.md) | Hibák, megoldások, visszaút |
| – | [scripts/install.sh](scripts/install.sh) | Az SSH parancsok egyben (lépésenként másold!) |
| – | [ha/](ha/) | Scriptek, dashboardok, éjszakai újraindítás |

## Mi kell hozzá

- Echo Dot 2. gen (**nem** a 3.!), micro USB kábel
- Linux gép (nálam HP t520, Debian), **fekete USB 2.0 port közvetlenül**, tmux
- Home Assistant, Nabu Casa (STT/TTS), Gemini API-kulcs
- Türelem (a Dot Wi-Fi-t, ModemManager-t és a gombkombinációkat egyaránt utálja)

## Nem teszteltem

- Nabu Casa nélküli setup (Whisper + Piper)
- TECHO5 (alternatív OS): csak említés, nem telepítettem
- Echo Dot 3. gen: nincs rá firmware-út

## Kreditek

- **Rortiz2**: amonet-biscuit (XDA)
- **ygelfand**: [EchoLocal](https://github.com/ygelfand/echolocal)
- **HuskerMinion**: [techo5-dot](https://github.com/HuskerMinion/techo5-dot)
- Home Assistant, ESPHome, Nabu Casa

A repo csak dokumentáció. Az amonet csomagot és a Fire OS képet **nem** tartalmazza, azokat a saját forrásukból töltsd le.

## Licenc

Dokumentáció: CC BY 4.0. Garancia nincs.
