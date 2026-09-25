..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : INTRASTATZENTRALE.BB
.. Autor          : cl
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Funktion       :
.. Functionality  :
..
.. Includes       :
..include sk/INTRASTATZENTRALE.MELD
..*****************************************************************************
.set trans -
.type bool xbmark        ? _F|defined(U|xbmark)
.type text xsatznr       ? _F|defined(U|xsatznr)
.type text xdatnr        ? _F|defined(U|xdatnr)
.type GL11 xsteunr       ? _F|defined(U|xsteunr)
.type GL3  xustzus       ? _F|defined(U|xustzus)
.type GL3  xischl        ? _F|defined(U|xischl)
.type text xtkey         ? _F|defined(U|xtkey)
.type text xtselect      ? _F|defined(U|xtselect)
..
.assign M|mark = "(EmptyEntry)"
.copy U|xbmark   = G|FALSE
..
.continue EXPORTIEREN ? _F|empty(M|ediabm)
..
..  Parameter aus EDI-Parameter laden
..  ---------------------------------
..  Abbildungsmodell f~Ar die XML-Onlinemeldung
..
.formula U|xtkey = "IntrastatZentrale"
.formula U|xtselect = "$,,key=" + 'U|xtkey' + ";variable=ediabm;@gruppe=9"
.select ediconfiguration 'U|xtselect'
.assign M|ediabm = H|data ?  G|mehr
..
!EXPORTIEREN
.continue FEHLER1 ?  M|tzeilen = 0
.copy U|xbmark = G|TRUE
..
.. Kopffelder in Zeile vererben
.formula U|xsteunr = M|steunr
.formula U|xustzus = ("000" + M|ustzus) >> 3
.formula U|xischl  = M|ischl
..
!ZEILE: hole nur Zeilen mit tmark = TRUE und einer EDI-Nachricht
.select screen line 'F|formatstr("$,,tmark={1};edinachricht<>`", U|xbmark)'
.continue FEHLER3  ? _G|mehr
.continue MELD
..
!NZEILE
.select screen line
.continue END      ? _G|mehr
.continue MELD
..
!MELD
.formula M|tsteunr  = U|xsteunr
.formula M|tustzus  = U|xustzus
.formula M|tischl   = U|xischl
.input "sk/INTRASTATZENTRALE.MELD"
.continue NZEILE
..
!END
.continue
..
!FEHLER1
.error Keine zu bearbeitenden Tabellenzeilen vorhanden.
.end 1
..
!FEHLER3
.error Keine Zeile zur Meldung markiert oder EDI-Nachricht fehlt.
.end 1
