..!interpreter english translate
..*****************************************************************************
..
..  FOP-Name       : vk/FOP.106.MP
..  Datum          : 01.02.2005
..  Version        :
..  Autor          : ok
..  Verantwortlich : mh
..  Kontrolle      : cl
..
..  Funktion       : Packanweisung, Maske EinheitenprÅfung
..
..#KOR#EDI-MODUL#DATUM#éNDERUNGS-INDEX#MitarbeiterkÅrzel#
..*****************************************************************************
..
..  include
..
.set trans -
..
..Variablendeklaration
..-----------------------------------------------------------------------------
..
.type integer xiz xiz2 xiz3 xiz4 xiz5
..-----------------------------------------------------------------------------
.. Kopfteil
..-----------------------------------------------------------------------------
..
.formula xiz  = 0
.formula xiz2 = 0
.formula xiz3 = 0
.formula xiz4 = 0
.formula xiz5 = 0
..
.select screen header
.set reference +
.continue ENDE ? M|tzeilen = 0
..
!LOOP.ZEILE
.select screen  line
.continue PRKE      ? _mehr
.. Kleinste Einheit Mussfeld und nicht mehrfach
.formula xiz  = xiz  + 1 ?  M|schl="(1)"
.."Ebene" u "Mindestmenge" ausgefÅllt bei "kleinster Einheit" u "Standardverpackung"
.formula xiz2 = xiz2 + 1 ? (M|schl="(1)" ; M|schl="(3)")  & (M|ebene=0 ; M|minebene=0)
.."kleinste Einheit" nur in erster Zeile
.formula xiz3 = xiz3 + 1 ?  M|schl="(1)"  & M|aktzeile=1
.."Anzahl" u "Mindestmenge" ausgefÅllt bei "kleinster Einheit"
.formula xiz4 = xiz4 + 1 ?  M|schl="(1)"  & (M|anzahl=0 ; M|minebene=0)
.. Ebene n. kleiner als Mindestebene
.formula xiz5 = xiz5 + 1 ?  M|ebene < M|minebene
.continue LOOP.ZEILE
..
..
!PRKE
.continue BOX  ? xiz   = 0
.continue BOX2 ? xiz   > 1
.continue BOX3 ? xiz2  > 0
.continue BOX4 ? xiz3  = 0
.continue BOX5 ? xiz4  > 0
.continue BOX6 ? xiz5  > 0
.continue ENDE
..
!BOX
.box
SchlÅssel "kleinste Einheit" muss eingetragen werden!
.continue FEHLER
..
!BOX2
.box
SchlÅssel "kleinste Einheit" darf nicht mehrfach vorkommen!
.continue FEHLER
..
!BOX3
.box
Bei SchlÅssel "kleinste Einheit" und "Standardverpackung" mÅssen die Felder Ebene und Mindestmenge ausgefÅllt sein!
.continue FEHLER
..
!BOX4
.box
SchlÅssel "kleinste Einheit" nur in erster Zeile erlaubt!
.continue FEHLER
..
!BOX5
.box
Bei SchlÅssel "kleinste Einheit" mÅssen die Felder Anzahl und Mindestmenge ausgefÅllt sein!
.continue FEHLER
..
!BOX6
.box
Ebene darf nicht kleiner sein als Mindestebene!
.continue FEHLER
..
!FEHLER
.error
.end 1
..
!ENDE
.set reference +
.continue
