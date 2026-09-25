..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : S0179.SV
.. Date           : 02/12/2015
.. Version        : 1.0
.. Author         : RASC
.. Copyright      :
.. Functionality  : SCREEN_VALIDATE
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
.type GD   U|xdate      ? _F|defined(U|xdate)
..
.set trans -
.continue END           ? _G|evtart = "maskpruef"
.continue END           ? M|ybvorlage
.continue END           ? _G|evtkommd = "neu" & _G|evtkommd = "Ñndern"
..
!LINES
.select screen line
.continue END           ? _G|mehr
..
.continue LINES         ? M|ytschlussre
.continue LINES         ? M|ytstorno
..
.continue NOTERM        ? (_F|empty(M|ytaufgabe) ; _F|empty(M|ytplanz)) & F|empty(M|ytterm)
..
.formula U|xdate        = M|ytterm      ? M|aktzeile = 1
.continue LINES                         ? M|aktzeile = 1
..
.continue ERROR         ? _(M|ytterm > U|xdate)
.formula U|xdate        = M|ytterm
..
.continue LINES
..
!NOTERM
.cursor ytterm 'M|aktzeile'
.set trans +
.text U|xttext 'G|bspri' "Sie mÅssen in allen Zeilen einen Termin eintragen, wenn schon Aufgaben vorhanden sind!"
.set trans -
.error 'U|xttext'
.end 1
..
!ERROR
.cursor ytterm 'M|aktzeile'
.set trans +
.text U|xttext 'G|bspri' "Das Datum der Anzahlungspositionen ist nicht aufsteigend!"
.set trans -
.error 'U|xttext'
.end 1
..
!END
.continue
