..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : EKZENTRALE.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  :
..*****************************************************************************
.type text    xtcom       ? _F|defined(U|xtcom)
..
.set trans -
..
.continue T2RELEASE    ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "trelease2"
.continue T2POST       ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "tpost2"
.continue ERROR1
..
!T2POST
.continue ERROR2   ? _F|empty(M|tpart)
.continue ERROR2   ?  M|tpost = ""
.continue OEFFNEN  ? _M|ttrans^uebertr
.continue WARNUNG
..
!OEFFNEN: Vorgang ”ffnen
.formula U|xtcom = "<(Purchasing)>" + 'M|ttrans^id' + "<(View)>"
.continue END
..
!WARNUNG
.formula U|xtcom = "<(Purchasing)>" + 'M|ttrans^id' + "<(Edit)>?ueb=yes"
.continue END
..
!T2RELEASE
.continue ERROR ? _F|empty(M|tpart)
.continue ERROR ?  M|ttrans^typ = 5
.continue ERROR ?  M|ttrans^typ = 4 & F|empty(M|trelease)
.continue ERROR ?  M|ttrans^ablagef
.continue ERROR ?  M|ttrans^uebertr
..
.formula U|xtcom = "<(Purchasing)>"
.formula U|xtcom = U|xtcom + M|ttrans^id + "<(Release)>"  ? M|ttrans^typ = 1
.formula U|xtcom = U|xtcom + M|ttrans^id + "<(Release)>"  ? M|ttrans^typ = 2
.formula U|xtcom = U|xtcom + M|ttrans^id + "<(Delivery)>" ? M|ttrans^typ = 3 & _M|brerelease
.formula U|xtcom = U|xtcom + M|ttrans^id + "<(Invoice)>"  ? M|ttrans^typ = 3 &  M|brerelease
.formula U|xtcom = U|xtcom + M|ttrans^id + "<(Invoice)>"  ? M|ttrans^typ = 4
.continue END
..
!ERROR
.error Freigeben hier nicht m”glich.
.end 1
..
!ERROR1
.error Kein passendes Event gefunden.
.end 1
..
!ERROR2
.error Vorgang zeigen, „ndern und buchen hier nicht m”glich.
.end 1
..
..*****************************************************************************
.. Muss als letzter Eintrag im FOP stehen
!END: .command -wait 'U|xtcom'
.end 0 'U|xtcom'
