..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : CHANGECURRENCY.YCURR.FX
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
.formula M|yrate        = ""
.formula M|yland        = ""
.formula M|yown         = ""
..
.select screen line
!LINES
.continue DATE          ? _G|mehr
..
.formula M|ytimport     = ""
.formula M|yterror      = ""
.select screen line
.continue LINES         ? G|mehr
..
.continue END           ? F|empty(M|ydate)
..
.input owfb/CHANGECURRENCY.YDATE.FX
..
!END
.continue
