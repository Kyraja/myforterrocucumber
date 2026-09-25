..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : HISTORYLOAD.QFILE40.BB
.. Date           : 19.02.15
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
.continue
.type text xtsel
.formula U|xtsel = "$,,nummer=;@gruppe=1;"
.select file40 'U|xtsel'
.continue END ? G|mehr
.continue
!END
.box
Daten sind schon angelegt !!
.end 10
