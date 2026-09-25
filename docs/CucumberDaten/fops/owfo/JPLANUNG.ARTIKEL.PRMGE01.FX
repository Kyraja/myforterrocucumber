..!interpreter german translate noabbrev
..*****************************************************************************
.. Name           : JPLANUNG.ARTIKEL.PRMGE01.FX
.. Date           : 19.08.15
.. Version        : 2015r4n01p03
.. Author         : fw
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
..
..*****************************************************************************
.art int  xiz
..
..
.fo xiz = evtzeile
.hol maske zeile 'evtzeile'
.. Prozentsumme ermitteln (muss 100 sein)
.fo m|prmgesumme = 0
.fo m|prmgesumme = m|prmgesumme + m|prmge01
.fo m|prmgesumme = m|prmgesumme + m|prmge02
.fo m|prmgesumme = m|prmgesumme + m|prmge03
.fo m|prmgesumme = m|prmgesumme + m|prmge04
.fo m|prmgesumme = m|prmgesumme + m|prmge05
.fo m|prmgesumme = m|prmgesumme + m|prmge06
.fo m|prmgesumme = m|prmgesumme + m|prmge07
.fo m|prmgesumme = m|prmgesumme + m|prmge08
.fo m|prmgesumme = m|prmgesumme + m|prmge09
.fo m|prmgesumme = m|prmgesumme + m|prmge10
.fo m|prmgesumme = m|prmgesumme + m|prmge11
.fo m|prmgesumme = m|prmgesumme + m|prmge12
.fo m|prmgesumme = m|prmgesumme + m|prmge13
..
.farbe -HINTERGRUND 0 255 0 prmgesumme 'xiz'  
.farbe -HINTERGRUND 255 0 0 prmgesumme 'xiz' ? m|prmgesumme <> 100
..
.. Monatsmenge aus Prozent und Jahresmenge ermitteln
..
.fo m|mge01      = m|gmge * m|prmge01 / 100
.fo m|mge02      = m|gmge * m|prmge02 / 100
.fo m|mge03      = m|gmge * m|prmge03 / 100
.fo m|mge04      = m|gmge * m|prmge04 / 100
.fo m|mge05      = m|gmge * m|prmge05 / 100
.fo m|mge06      = m|gmge * m|prmge06 / 100
.fo m|mge07      = m|gmge * m|prmge07 / 100
.fo m|mge08      = m|gmge * m|prmge08 / 100
.fo m|mge09      = m|gmge * m|prmge09 / 100
.fo m|mge10      = m|gmge * m|prmge10 / 100
.fo m|mge11      = m|gmge * m|prmge11 / 100
.fo m|mge12      = m|gmge * m|prmge12 / 100
.fo m|mge13      = m|gmge * m|prmge13 / 100
..
.. Gesamtmenge ermitteln
..
.fo m|smge01b13 = 0
.fo m|smge01b13 = m|smge01b13  + m|mge01
.fo m|smge01b13 = m|smge01b13  + m|mge02
.fo m|smge01b13 = m|smge01b13  + m|mge03
.fo m|smge01b13 = m|smge01b13  + m|mge04
.fo m|smge01b13 = m|smge01b13  + m|mge05
.fo m|smge01b13 = m|smge01b13  + m|mge06
.fo m|smge01b13 = m|smge01b13  + m|mge07
.fo m|smge01b13 = m|smge01b13  + m|mge08
.fo m|smge01b13 = m|smge01b13  + m|mge09
.fo m|smge01b13 = m|smge01b13  + m|mge10
.fo m|smge01b13 = m|smge01b13  + m|mge11
.fo m|smge01b13 = m|smge01b13  + m|mge12
.fo m|smge01b13 = m|smge01b13  + m|mge13
..
.weiter
