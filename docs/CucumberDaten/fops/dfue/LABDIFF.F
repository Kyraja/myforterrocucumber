..!interpreter english translate
..*****************************************************************************
..
..  Name      : LABDIFF.F
..  Datum     : 03/10/1999
..  Vers.     : 1.0
..  Autor     : Matthias Schr”der, alltrotec© GmbH
..  Verantwortlich    : mh
..
..  Funktion  : Differenzreport VDA-Lieferabruf FORMATIEREN
..
..*****************************************************************************
.tablerecord
.continue BILD ?  geraet = ""
.continue S1   ?  geraet = "S1"
.continue S2   ?  geraet = "S2"
.continue S3   ?  geraet = "S3"
.continue S4   ?  geraet = "S4"
.continue S5   ?  geraet = "S5"
.continue S6   ?  geraet = "S6"
.continue S7   ?  geraet = "S7"
.continue S8   ?  geraet = "S8"
.continue S9   ?  geraet = "S9"
.continue S10  ?  geraet = "S10"
.continue S11  ?  geraet = "S11"
.continue S12  ?  geraet = "S12"
.continue S12  ?  geraet = "S13"
.continue S12  ?  geraet = "S14"
.continue S12  ?  geraet = "S15"
.continue A    ?  geraet = "A"
..weiter FAX  ?  geraet = "F1"
.continue WIN  ?  geraet = "W"
.output terminal
*******************************************************************************

                  Ger„t nicht definiert
                Nur S1 bis S12, A, W m”glich

*******************************************************************************
.end

Blankopapier, Breite 129 Zeichen + Lochrand
-------------------------------------------
Normalschrift:
linker Rand                 13   mm
128 Zeichen (mit 10 cpi) = 325.2 mm
rechter Rand                 6.8 mm
                           --------
                           345   mm (Breites Papier)

Kleinschrift:
linker Rand                    8   mm
128 Zeichen (mit 16.7 cpi) = 194.7 mm
rechter Rand                   7.3 mm
                             --------
                             210   mm (Normales Endlospapier)

!BILD:   *** Bildschirm ***
.left 1
.right 210
.length 72
.vtab 1 68 9 20
.view sg.klein
.continue

!S1:     *** Systemdrucker 1 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 3 68 9 20
.print sg.klein
.continue

!S2:     *** Systemdrucker 2 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S3:     *** Systemdrucker 3 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S4:     *** Systemdrucker 4 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S5:     *** Systemdrucker 5 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S6:     *** Systemdrucker 6 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S7:     *** Systemdrucker 7 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S8:     *** Systemdrucker 8 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S9:     *** Systemdrucker 9 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S10:    *** Systemdrucker 10 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S11:    *** Systemdrucker 11 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!S12:    *** Systemdrucker 12 ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!A:      *** Arbeitsplatzdrucker ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.print sg.klein
.continue

!FAX:    *** FAX ***
.left  16 mm
.right 200 mm
.length 65
.vtab 1 63
.print sg.klein
.continue

!WIN:    *** Windows ***
.left  15 mm
.right 210 mm
.length 72
.vtab 1 72
.continue
