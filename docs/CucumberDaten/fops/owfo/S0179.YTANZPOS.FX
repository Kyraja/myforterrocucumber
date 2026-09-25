..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : S0179.YTANZPOS.FX
.. Date           : 11/02/2015
.. Version        : 1.0
.. Author         : RASC
.. Copyright      :
.. Functionality  : FIELD_EXIT <ytanzpos>
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
.set trans -
.continue END           ? _G|evtkommd = "neu" & _G|evtkommd = "„ndern"
.continue END           ? F|empty(M|ytanzpos)
..
.assign M|ytkonto       = M|ytanzpos^vkonto^id  ? M|yvorgang^dnr = 3
.assign M|ytkonto       = M|ytanzpos^ekonto^id  ? M|yvorgang^dnr = 4
..
.formula U|xttext       = ""
.set trans +
.text U|xttext 'G|bspri' "Hier sind nur <Neutrale Positionen> erlaubt!"  ? _'M|ytanzpos^zptyp(L="0")'= "(12)"
.text U|xttext 'G|bspri' "Hier sind nur Anzahlungspositionen erlaubt!"   ? _'M|ytanzpos^kategorie(L="0")'= "(68)"
.set trans -
.continue END           ? F|empty(U|xttext)
.error 'U|xttext'
.formula M|ytanzpos     = ""
.formula M|ytkonto      = ""
..
!END
.continue
