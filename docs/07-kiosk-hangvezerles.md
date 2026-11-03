# 7. Hangvezérelt kiosk (HP t520)

"Okay Nabu, mutasd a szennyvíztartályt / gázórát / az otthonom / a kamerákat": a kiosk átvált az adott dashboardra, a Dot pedig felolvassa az összefoglalót.

## A minta

1. **HA script** `browser_mod.navigate`-tel a kiosk böngészőre (`browser_id`: a saját browser_mod azonosítód). A `popup` nálam nem renderel, a `navigate` igen.
2. **`variables`**: a felolvasandó szöveg Jinja sablonból. Egy `variables:` blokkon belül csak olyat használhatsz, ami előbb van deklarálva, ezért kell két külön blokk.
3. **`stop` + `response_variable`**: így a script szöveget ad vissza az ágensnek.
4. A script `description`-je: *"A válaszban kapott összefoglalót mondd el szóról szóra, semmit ne hagyj ki."*
5. A scriptet tedd elérhetővé a hangasszisztensnek (exposure), és adj neki **aliasokat** ("tartály", "gázóra", "otthon", "kamerák").

Minta scriptek: [../ha/scripts/](../ha/scripts/). Dashboardok: [../ha/dashboards/](../ha/dashboards/) (`kiosk_mode`: fejléc és oldalsáv elrejtve).

## Gyakori buktatók

- A kiosk browser_mode-ja kiesik, ha a böngésző profilban a **Háttérkapcsolatok felfüggesztése** be van kapcsolva: kapcsold ki.
- Törölt local storage = új browser ID.
- Az egy mondatban többféle parancs ("kapcsold fel és mutasd") néha összezavarja az ágenst: tartsd a parancsot egyszerűnek.
