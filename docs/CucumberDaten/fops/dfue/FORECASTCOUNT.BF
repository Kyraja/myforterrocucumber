..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : FORECASTCOUNT.BF
.. Autor          : mh
.. Verantwortlich : mh
.. Kontrolle      : carue
.. Functionality  : Report footer: find max count
..*****************************************************************************
.set trans -
..
.. Texts shown in business app
.type text xterror
.type text xtearlywarning
.type text xtbacklog
.type text xtimmediaterequirement
..
.set trans +
.formula U|xterror = "Fehlerhafte Verarbeitung"
.formula U|xtearlywarning = "Frhwarnsystem-Meldungen"
.formula U|xtbacklog = "Rckst„nde"
.formula U|xtimmediaterequirement = "Sofortbedarfe"
.set trans -
..
.. Max count?
.copy M|kmaxanzahl = 0
.copy M|kmaxanzahl = M|kanzfehler       ?  M|kanzfehler > M|kmaxanzahl
.copy M|kmaxanzahl = M|kanzrueckstand   ?  M|kanzrueckstand > M|kmaxanzahl
.copy M|kmaxanzahl = M|kanzsofortbedarf ?  M|kanzsofortbedarf > M|kmaxanzahl
.copy M|kmaxanzahl = M|kanzfruehwarnung ?  M|kanzfruehwarnung > M|kmaxanzahl
..
.. Fill table if counting all forecasts
.continue ECOUNTER  ? _M|kbzaehlen
.make screen line +O
.formula M|tstatus = U|xterror
.copy M|tanzahl = M|kanzfehler
.make screen line +O
.formula M|tstatus = U|xtbacklog
.copy M|tanzahl = M|kanzrueckstand
.make screen line +O
.formula M|tstatus = U|xtimmediaterequirement
.copy M|tanzahl = M|kanzsofortbedarf
.make screen line +O
.formula M|tstatus = U|xtearlywarning
.copy M|tanzahl = M|kanzfruehwarnung
!ECOUNTER
..
..*****************************************************************************
!END
.continue
