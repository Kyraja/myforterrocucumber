..!interpreter german translate noabbrev
..*****************************************************************************
.. Name           : FV.FREIGEBEN.WOCHE.FX
.. Date           : 02.07.14
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
.art GD xdatum                           ? F|defined( U|xdatum )      = G|False
..
..
.formel U|xdatum     = M|woche
..
.formel M|startdatum = U|xdatum - 2
.formel M|dienstag   = U|xdatum - 1
.formel M|mittwoch   = U|xdatum
.formel M|donnerstag = U|xdatum + 1
.formel M|enddatum   = U|xdatum + 2
..
.weiter
