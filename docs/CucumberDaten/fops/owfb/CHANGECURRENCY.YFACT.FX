..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : CHANGECURRENCY.YFACT.FX
.. Date           : 04.03.15
.. Version        : 2015r2n04
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
..
..*****************************************************************************
.type text U|xttext     ? _F|defined(U|xttext)
..
!EMPTY
.select screen line
.continue FACT          ? _G|mehr
..
.formula M|ytimport     = ""
.continue EMPTY
..
!FACT
.continue       ? M|yfact >= 0 & M|yfact <= 2
..
.set trans +
.text U|xttext 'G|bspri' Dieser Rundungsfaktor ist nicht erlaubt
.set trans -
.error 'U|xttext'!
.formula M|yfact = 0
.continue
