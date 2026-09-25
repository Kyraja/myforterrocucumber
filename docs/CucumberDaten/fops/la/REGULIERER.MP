..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : la/REGULIERER.MP
.. Autor          : ok
.. Verantwortlich : mh
.. Kontrolle      :
.. Funktion       : Eingetragene Zeilen wieder in die Datei schreiben
..
..#KOR#EDI-MODUL#DATUM#éNDERUNGS-INDEX#MitarbeiterkÅrzel#
..#KOR#EDI##0#ok#
..*****************************************************************************
.set trans -
..
.type text xname ? _F|defined(U|xname)
..
.end  ? F|empty(M|regul)
.formula U|xname = "la/REGULIERER" + 'M|regul' + ".DTR"
.continue AUSG ? F|filenotempty(U|xname)
..
.box Meldung
FÅr den Regulierer 'M|regul' sind keine Daten vorhanden!
.end
..
!AUSG
.continue        ? M|blad
.continue FEHLER ? M|tzeilen = 0 & _M|blad
.output new 'U|xname'
.input "DATEI.F"
..
.set trans +
######    Datei mit Informationen vom Regulierer XY
######    verwaltete Kundenwerke
######    mit bestimmten Werten fÅr:
######
######    - Identnummer des Kunden bei ABAS
######    - Werk des Kunden
######    - Abladestelle des Kunden
# Kunden-Sachbearbeiter   # Kunde # Kundenname # Werk # Abladestelle # Kommentar
.set trans -
.continue WEITER
..
!WEITER
.select screen line
.continue ENDE   ? _G|mehr
'M|kdsach'#'M|kunde'#'M|kdname'#'M|werk'#'M|ablade'#'M|kommentar'#
.continue WEITER
..
!ENDE
.output terminal
.continue
..
!FEHLER
.error -message Vorsicht! Keine Daten wurden gespeichert!
.end 1
