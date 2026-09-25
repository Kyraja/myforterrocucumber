..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : CHANGECURRENCY.YLAND.FX
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
.formula M|ycurr        = ""
.formula M|yrate        = ""
.formula M|yown         = ""
.formula M|ycalc        = 0
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
!DATE
.continue END           ? F|empty(M|yland)
.continue NOLAND        ? _'M|yland^typ(L="0")'="(76)"
.continue NOSELF        ? 'M|yland' = 'M|ybetr^lainland'
..
.continue END           ? F|empty(M|ydate)
.input owfb/CHANGECURRENCY.YDATE.FX
.continue END
..
!NOLAND
.error "Das ist kein Land!"
.formula M|yland        = ""
.continue END
..
!NOSELF
.error "Das eigene Land ist nicht zul„ssig!"
.formula M|yland        = ""
.continue END
..
!END
.continue
