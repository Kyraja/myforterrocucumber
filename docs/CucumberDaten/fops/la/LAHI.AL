..!interpreter english translate noabbrev
.. ---------------------------------------------------------
.. FOP-Name             : LAHI.AL
.. Autor                : ns
.. Verantwortlich       : tiwe
.. Kontrolle            : cl
.. Funktion             : Infosystem -> LAHI
.. ---------------------------------------------------------
.. L„ger werden aufgeklappt
.. ---------------------------------------------------------
.set trans -
..
.load 1 warehouse 'F|formatstr("$,,lgruppe={1};@gruppe=1.2;@ablageart=(Active);@ordnung=such", 0|id)'
!LADEDATEN
.continue END ? _G|mehr
..
.make screen line +O
.formula M|tbaumstufe    = 2
..
.. +/- Lager - Handling
.load 9 location 'F|formatstr("$,,lager={1};@gruppe=1;@ablageart=(Active);@ordnung=such", 1|id)'
.formula M|tbaumstat     = ""  ? _G|mehr
.formula M|tbaumstat     = "-" ? M|kopfstufe =  2 & G|mehr
.formula M|tbaumstat     = "+" ? M|kopfstufe <> 2 & G|mehr
.load 9
..
.formula M|tbaumtext     = 1|sucherw
.assign M|tlager      = 1|id
..
.input "la/LAHI.LG"
.input "la/LAHI.LL"
..
.. Lagerplatz / Lagerpl„tze darstellen
.input "la/LAHI.AP"          ? M|kopfstufe = 2
..
.load 1 warehouse
.continue LADEDATEN
.. ---------------------------------------------------------
!END
.continue
