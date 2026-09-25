..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : S0179.YTBUPRJMV.BB
.. Date           : 02/12/2015
.. Version        : 1.0
.. Author         : RASC
.. Copyright      :
.. Functionality  : BUTTON_BEFORE <ytbuprjmv>
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
.continue END           ? _F|empty(M|yprjmpproj)
.set trans +
.text U|xttext 'G|bspri' "Der Zahlungsplan verweist nicht auf ein Projekt!"
.set trans -
.error 'U|xttext'
.end 1

