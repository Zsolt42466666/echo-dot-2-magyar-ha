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

Csak a mentésből: TWRP-ből `mmcblk0.img.gz` visszaírása. Ezért a [2. fejezet](02-fireos.md) mentése kihagyhatatlan.
