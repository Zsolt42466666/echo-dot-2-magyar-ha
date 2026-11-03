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

Következő: [04-homeassistant.md](04-homeassistant.md)
