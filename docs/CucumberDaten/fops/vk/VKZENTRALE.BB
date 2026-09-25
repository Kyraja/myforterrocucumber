..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : VKZENTRALE.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  :
..*****************************************************************************
.set trans -
.type text    xtcom       ? _F|defined(U|xtcom)
..
.continue T2RELEASE    ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "trelease2"
.continue T2POST       ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "tpost2"
.continue T2SHIPPING   ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "ttypversand2"
.continue ERROR3
..
!T2SHIPPING: Versandplanung îffnen (zeigen-Modus)
.continue ERROR4 ? F|empty(M|tversand)
.formula U|xtcom = "<(ShippingPlanning)>" + 'M|tversand^id' + "<(View)>"
.continue END
..
!T2POST
.continue ERROR2     ? _F|empty(M|tpart)
.continue ERROR2     ?  M|tpost = ""
.continue OEFFNEN    ? _M|ttrans^uebertr
.continue WARNUNG    ?  F|empty(M|tshort)
..
.box Hinweis
Lagerbestand ist geringer als die Liefermenge!
Bitte vor dem Freigeben ÅberprÅfen!
..
!WARNUNG
.formula U|xtcom = "<(Sales)>" +'M|ttrans^id'+"<(Edit)>?ueb=yes"
.continue END
..
!OEFFNEN: Vorgang îffnen
.formula U|xtcom = "<(Sales)>"+'M|ttrans^id'+"<(View)>"
.continue END
..
!T2RELEASE
.continue ERROR1     ? _F|empty(M|tpart)
.continue ERROR1     ?  M|ttrans^typ = 5
.continue ERROR1     ?  M|ttrans^typ = 4 & F|empty(M|trelease)
.continue ERROR1     ?  M|ttrans^ablagen
.continue ERROR1     ?  M|ttrans^uebertr
.continue ERROR1     ?  M|ttrans^typ = 31 & M|ttrans^vsperre
..
.formula U|xtcom = "<(Sales)>"
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Release)>"  ? M|ttrans^typ = 1
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Release)>"  ? M|ttrans^typ = 36
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Release)>"  ? M|ttrans^typ = 2
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Delivery)>" ? M|ttrans^typ = 3 & _M|brerelease
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 3 &  M|brerelease
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 4
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Release)>"  ? M|ttrans^typ = 31
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Release)>"  ? M|ttrans^typ = 33
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Delivery)>" ? M|ttrans^typ = 34 & _M|brerelease
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 34 &  M|brerelease
.formula U|xtcom = U|xtcom + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 35
.continue END
..
!ERROR1
.error Freigeben hier nicht mîglich.
.end 1
..
!ERROR2
.error Vorgang zeigen, Ñndern und buchen hier nicht mîglich.
.end 1
..
!ERROR3
.error Kein passendes Event gefunden.
.end 1
..
!ERROR4
.error Keine Versandplanung mîglich.
.end 1
..
..*****************************************************************************
.. Muss als letzter Eintrag im FOP stehen
!END: .command -wait 'U|xtcom'
.end 0 'U|xtcom'

