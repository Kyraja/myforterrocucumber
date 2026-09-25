..!interpreter german translate noabbrev
..*****************************************************************************
.. Name           : FV.FREIGEBEN.WOCHE.FX
.. Date           : 02.07.14
.. Version        : 2014r3n02
.. Author         : andre
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
.art GD xdatum
.fo xdatum = m|woche
.fo m|startdatum = xdatum - 2
.fo m|endedatum = xdatum + 2
.ende
