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

Miért nem "Jarvis": lásd [06-wake-word.md](06-wake-word.md).

## 4.4 Éjszakai újraindítás

Naponta 04:00-kor újraindítja a Dotot: [../ha/automations/echo_dot_ejszakai_ujrainditas.yaml](../ha/automations/echo_dot_ejszakai_ujrainditas.yaml)

Következő: [05-gemini-es-exposure.md](05-gemini-es-exposure.md)
