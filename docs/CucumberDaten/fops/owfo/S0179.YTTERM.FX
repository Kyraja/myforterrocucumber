..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : S0179.YTTERM.FX
.. Date           : 02/12/2015
.. Version        : 1.0
.. Author         : RASC
.. Copyright      :
.. Functionality  : FIELD_EXIT <ytterm>
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
.continue END           ? M|ybvorlage
.continue END           ? _F|empty(M|ytrechn)
.continue END           ? F|empty(M|ytaufgabe) & F|empty(M|ytplanz)
.continue END           ? F|empty(M|ytterm)
..
.continue PLANZ         ? F|empty(M|ytaufgabe)
..
!AUFG
.continue PLANZ         ? M|ytaufgabe^ablagef
..
.output NEW 'U|xtedp'
.input DATEI.F
# Aufgabe nach Termin„nderung updaten
#!database=86
#!group=6
#!action=update
id;start;end;
'M|ytaufgabe^id';'M|ytterm';'M|ytterm';
.output
.formula U|xtcmd        = "edpimport.sh -o SHOWNOTES=0 -o SHOWTEXT=0 -P -I " + U|xtedp
.formula U|xtcmd        = U|xtcmd + " >" + U|xtout + " 2>" + U|xterr
.system 'U|xtcmd' PASSWORD background
..
.continue PLANZ         ? F|filesize(U|xterr) = 0
....edi -READONLY 'U|xterr'
..
!PLANZ
.continue END           ? F|empty(M|ytplanz)
..
.output NEW 'U|xtedp'
.input DATEI.F
# Planzahlung nach Termin„nderung updaten
#!database=141
#!group=1
#!action=update
id;termin;
'M|ytplanz^id';'M|ytterm';
.output
.formula U|xtcmd        = "edpimport.sh -P -I " + U|xtedp
.formula U|xtcmd        = U|xtcmd + " >" + U|xtout + " 2>" + U|xterr
.system 'U|xtcmd' PASSWORD background
..
.continue END
..
!END
.continue

