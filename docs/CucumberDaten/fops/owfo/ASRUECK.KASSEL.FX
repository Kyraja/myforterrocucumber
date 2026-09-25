..!interpreter german translate noabbrev
..*****************************************************************************
.. Name           : ASRUECK.KASSEL.FX
.. Date           : 05.12.14
.. Version        : 2014r3n02
.. Author         : chbo
.. Copyright      : (c) 2014 SABA International
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
..
.formel M|alle     = G|False
.formel M|augsburg = G|False
.formel M|int      = "INTGROUP"
.formel M|ext      = ""
..
.schutz -RESET -FELD M|int 0
.schutz -GESCHUETZT -FELD M|ext 0
..
.weiter
