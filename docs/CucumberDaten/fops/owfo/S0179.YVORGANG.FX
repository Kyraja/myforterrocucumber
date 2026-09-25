..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : S0179.YVORGANG.FX
.. Date           : 02/11/2015
.. Version        : 1.0
.. Author         : RASC
.. Copyright      :
.. Functionality  : FIELD_EXIT <yvorgang>
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
.type text U|xtsel      ? _F|defined(U|xtsel)
..
.set trans -
..
.continue END           ? _G|evtkommd = "neu" & _G|evtkommd = "„ndern"
..
.input S0179.REINIT
..
.select screen head
.continue END           ? F|empty(M|yvorgang)
..
.formula U|xtsel        = "$,@database=41;@group=0;yvorgid=="+'M|yvorgang^id'
.load 0 nolock object 'U|xtsel'
.continue ERRDOUBL      ? G|mehr
..
.formula M|such         = M|yvorgang^such
.formula M|yvorgid      = 'M|yvorgang^id'
.assign  M|ykuli        = M|yvorgang^kunde      ? M|yvorgang^dnr = 3
.assign  M|ykuli        = M|yvorgang^kunde      ? M|yvorgang^dnr = 4
.formula M|yklname      = M|ykuli^name
.formula M|yposwert     = M|yvorgang^sumnetto
.copy    M|ywaehr       = M|yvorgang^land
.assign  M|yprojekt     = M|yvorgang^kprojekt
.assign  M|yprjmpproj   = M|yvorgang^yprjmproj  ? F|defined(M|yvorgang^yprjmproj)
..
.continue ELINE         ? M|tzeilen = 0
.continue LINES         ? M|yposwert <> 0
..
.set trans +
.text U|xttext 'G|bspri' = "Der gew„hlte Vorgang hat keinen Wert"
.set trans -
.error 'U|xttext'
.continue END
..
!LINES
.select screen line
.continue END           ? _G|mehr
..
.formula M|ytschlussre  = G|true        ? M|aktzeile = M|tzeilen
.protect ytanzpos 'M|aktzeile'          ? M|ytschlussre
..
.continue LINES         ? M|ytanteil    = 0
.formula M|ytwert       = M|yposwert / 100 * M|ytanteil
.continue LINES
..
!ELINE
.continue END           ? M|tzeilen > 0
.make screen line +o
.formula M|ytereignis   = "Anzahlung"
.formula M|ytschlag     = "Anzahlung"
.formula M|ytanteil     = 100
.formula M|ytwert       = M|yposwert
.make screen line +o
.formula M|ytereignis   = "Schlussrechnung"
.formula M|ytschlag     = "Schlussrechnung"
.formula M|ytanteil     = 100
.formula M|ytwert       = M|yposwert
.formula M|ytschlussre  = G|true
.protect ytterm     'M|aktzeile'
.protect ytanzpos   'M|aktzeile'
.protect ytanteil   'M|aktzeile'
.protect ytwert     'M|aktzeile'
....protect ytprjmvorg 'M|aktzeile'
....protect ytbuprjmv  'M|aktzeile'
....protect ytbuaufg   'M|aktzeile'
.protect ytbuplz    'M|aktzeile'
.protect ytburech   'M|aktzeile'
.continue END
..
!ERRDOUBL
.set trans +
.text U|xttext 'G|bspri' "Zum gew„hlten Vorgang existiert bereits ein Zahlungsplan!"
.set trans -
.error 'U|xttext'
.formula M|yvorgang     = ""
.continue END
..
!END
.continue






