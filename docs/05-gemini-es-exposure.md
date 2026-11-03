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

Következő: [06-wake-word.md](06-wake-word.md)
