..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : S0179.YTWERT.FX
.. Date           : 02/11/2015
.. Version        : 1.0
.. Author         : RASC
.. Copyright      :
.. Functionality  : FIELD_EXIT <ytwert>
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
.type real U|xrant      ? _F|defined(U|xrant)
.type real U|xrwert     ? _F|defined(U|xrwert)
.type integer U|xiz     ? _F|defined(U|xiz)
..
.continue NOPWERT       ? _M|ybvorlage & M|yposwert = 0
..
.formula M|ysumanz      = 0
.formula M|ysumant      = 0
.formula M|ytanteil     = M|ytwert * 100 / M|yposwert
..
.formula U|xiz          = M|aktzeile
.formula U|xrwert       = 0
.select screen head
!LINES
.select screen line
.continue ELINE         ? _G|mehr
..
.formula U|xrant        = U|xrant + M|ytanteil  ? _M|ytschlussre
.formula U|xrwert       = U|xrwert + M|ytwert  ? _M|ytschlussre
.continue LINES
..
!ELINE
.formula M|ysumanz      = U|xrwert
.formula M|ysumant      = U|xrant
.continue END           ? U|xrwert <= M|yposwert
..
.set trans +
.text U|xttext 'G|bspri' "Die Summe der Zeilen ist > als der Positionswert!"
.set trans -
.error 'U|xttext'
..
.select screen line 'U|xiz'
.continue END           ? _G|mehr
.formula M|yposwert     = M|yposwert - M|ytwert
.formula M|ytanteil     = 0
.formula M|ytwert       = 0
.continue END
..
!NOPWERT
.set trans +
.text U|xttext 'G|bspri' "Der Positionswert ist 0!"
.set trans -
.error 'U|xttext'
.formula M|ytanteil     = 0
.formula M|ytwert       = 0
.continue END
..
!END
.continue
