..!interpreter german translate noabbrev
..*****************************************************************************
.. Name           : JPLANUNG.ARTIKEL.GMGE.FX
.. Date           : 12.06.15
.. Version        : 2015r4n01p03
.. Author         : si/dr
.. Copyright      : (c) 2015 SABA International
.. Functionality  :
..
.. Interface (arguments and their meaning)
..    uses array argument (arg.i)           : no
..    uses name argument  (xpname=value)    : no
..
..    Argument     meaning
..    -------------------------------------------------------------------------
..
.. Program flow   :
...Includes       :
..*****************************************************************************
...
.fo m|epreis = m|artikel^vpr * m|artikel^vpehe
..
..  Wert errechnen
..
..
.fo m|gwert     =  m|gmge * m|epreis
.fo m|smge01b13 =  m|gmge
...
.. Prozentwerte errechnen
..
.fo m|mge01 = m|gmge * m|prmge01 / 100
.fo m|mge02 = m|gmge * m|prmge02 / 100
.fo m|mge03 = m|gmge * m|prmge03 / 100
.fo m|mge04 = m|gmge * m|prmge04 / 100
.fo m|mge05 = m|gmge * m|prmge05 / 100
.fo m|mge06 = m|gmge * m|prmge06 / 100
.fo m|mge07 = m|gmge * m|prmge07 / 100
.fo m|mge08 = m|gmge * m|prmge08 / 100
.fo m|mge09 = m|gmge * m|prmge09 / 100
.fo m|mge10 = m|gmge * m|prmge10 / 100
.fo m|mge11 = m|gmge * m|prmge11 / 100
.fo m|mge12 = m|gmge * m|prmge12 / 100
.fo m|mge13 = m|gmge * m|prmge13 / 100
..
... Gesamtsumme errechnen
.hol maske kopf
.fo m|planumsatz = 0
!MZ:
.hol maske zeile
.weiter EMZ ? _ mehr 
.fo m|planumsatz = m|planumsatz + m|gwert
.hol maske zeile
.. jede zweite Zeile verwenden  1. Zeile šlanwert, 2. Zeile Istwert
.weiter MZ

!EMZ:
.weiter


.weiter
