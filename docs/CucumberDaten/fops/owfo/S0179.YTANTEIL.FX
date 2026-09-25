..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : S0179.YTANTEIl.FX
.. Date           : 02/11/2015
.. Version        : 1.0
.. Author         : RASC
.. Copyright      :
.. Functionality  : FIELD_EXIT <ytanteil>
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
.type text U|xtcmd      ? _F|defined(U|xtcmd)
.type text U|xtedp      ? _F|defined(U|xtedp)
.type text U|xtout      ? _F|defined(U|xtout)
.type text U|xterr      ? _F|defined(U|xterr)
.type text U|xtref      ? _F|defined(U|xtref)
.type real U|xrant      ? _F|defined(U|xrant)
.type real U|xrwert     ? _F|defined(U|xrwert)
.type integer U|xiz     ? _F|defined(U|xiz)
..
.file -TEMPNAME U|xtedp
.file -TEMPNAME U|xtout
.file -TEMPNAME U|xterr
.continue NOPWERT       ? _M|ybvorlage & M|yposwert = 0
..
.formula M|ysumanz      = 0
.formula M|ysumant      = 0
.formula M|ytwert       = M|yposwert / 100 * M|ytanteil
..
.formula U|xiz          = M|aktzeile
.formula U|xrant        = 0
.select screen head
!LINES
.select screen line
.continue ELINE         ? _G|mehr
..
.formula U|xrant        = U|xrant + M|ytanteil  ? _M|ytschlussre
.formula U|xrwert       = U|xrwert + M|ytwert  ? _M|ytschlussre
..
.continue LINES         ? F|empty(M|ytplzid) & F|empty(M|ytplanz)
..
.output NEW 'U|xtedp'
.input DATEI.F
# Planzahlung nach Wert„nderung updaten
#!database=141
#!group=1
?#!action=update                ? M|ytwert > 0
?#!action=delete                ? M|ytwert = 0
?id;zabetr;                     ? M|ytwert > 0
?id;                            ? M|ytwert = 0
?'M|ytplanz^id';'M|ytwert';     ? M|ytwert > 0
?'M|ytplanz^id'                 ? M|ytwert = 0
.output
.formula U|xtcmd        = "edpimport.sh -P -I " + U|xtedp
.formula U|xtcmd        = U|xtcmd + " >" + U|xtout + " 2>" + U|xterr
.system 'U|xtcmd' PASSWORD background
..
.formula M|ytplbetr     = M|ytwert
.continue LINES         ? M|ytwert > 0
..
.formula M|ytplanz       = ""
.formula M|ytplzid      = ""
.formula M|ytplbetr     = 0
.continue LINES
..
!ELINE
.formula M|ysumant      = U|xrant
.formula M|ysumanz      = U|xrwert
.continue END           ? U|xrant <= 100
..
.set trans +
.text U|xttext 'G|bspri' "Die Summe der Anteile ist > 100!"
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
