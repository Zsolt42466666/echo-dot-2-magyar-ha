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

Következő: [07-kiosk-hangvezerles.md](07-kiosk-hangvezerles.md)
