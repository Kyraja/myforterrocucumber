..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : SERVICECENTER.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : mh
.. Functionality  : Button-vor-FOP fÅr die webgui um .command -wait zu ersetzen
..*****************************************************************************
.set trans -
.type text xtcom ? _F|defined(U|xtcom)
..
.continue RELEASE  ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "trelease2"
.continue POST     ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "tpost2"
.continue NEW      ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "new"
.continue ERROR
..
!NEW: Serviceangebot, Serviceauftrag, Reparaturauftrag neu anlegen
.continue ERROR3 ? F|empty(M|selvorgang) ; F|equals(M|selvorgang, "(CostEstimate)") ; F|equals(M|selvorgang, "(Invoice)") ; F|equals(M|selvorgang, "(PackingSlip)")
.formula U|xtcom = "<(Sales)><(New)>,"+M|selvorgang + "  ? kunde=" + M|kunde^id + "| vserprod=" + M|service^id
.command -parallel 'U|xtcom'
.continue END
..
!POST
.continue ERROR2   ? _F|empty(M|tpart)
.continue ERROR2   ?  F|empty(M|tpost)
.formula U|xtcom = F|formatstr("<(ServiceRequest)>{1}<(Edit)>", M|ttrans^id)  ?  M|ttrans^dnr = 122
.continue OEFFNEN    ? _M|ttrans^uebertr
.continue NOWARNUNG  ?  F|empty(M|tshort)
.box Hinweis
Lagerbestand ist geringer als die Liefermenge!
Bitte vor dem Freigeben ÅberprÅfen!
..
!NOWARNUNG
.formula U|xtcom = F|formatstr("<(Sales)>{1}<(Edit)> ? ueb=(Yes)", M|ttrans^id)      ? M|ttrans^dnr = 3
.formula U|xtcom = F|formatstr("<(Purchasing)>{1}<(Edit)> ? ueb=(Yes)", M|ttrans^id) ? M|ttrans^dnr = 4
.continue END
..
!OEFFNEN: Vorgang îffnen
.formula U|xtcom = F|formatstr("<(Sales)>{1}<(View)" , M|ttrans^id)      ? M|ttrans^dnr = 3
.formula U|xtcom = F|formatstr("<(Purchasing)>{1}<(View)>", M|ttrans^id) ? M|ttrans^dnr = 4
.continue END
..
!RELEASE
.continue ERROR1 ?  F|empty(M|trelease)
.continue ERROR1 ? _F|empty(M|tpart)
.continue ERROR1 ?  M|ttrans^typ = 5
.continue ERROR1 ?  M|ttrans^typ = 4 & _M|ttrans^faktura
.continue ERROR1 ?  M|ttrans^ablagen
.continue ERROR1 ?  M|ttrans^uebertr
.continue ERROR1 ?  M|ttrans^typ = 31 & M|ttrans^vsperre
..
.continue VERKAUF  ? M|ttrans^dnr = 3
.formula U|xtcom = "<(Purchasing)>" + 'M|ttrans^id' + "<(Delivery)>"  ? M|ttrans^typ = 3 & _M|brerelease
.formula U|xtcom = "<(Purchasing)>" + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 3 &  M|brerelease
.formula U|xtcom = "<(Purchasing)>" + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 4
.continue KOMMANDO
..
!VERKAUF
.formula U|xtcom = "<(Sales)>" + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 4
.formula U|xtcom = "<(Sales)>" + 'M|ttrans^id' + "<(Release)>"  ? M|ttrans^typ = 33
.formula U|xtcom = "<(Sales)>" + 'M|ttrans^id' + "<(Delivery)>"  ? M|ttrans^typ = 34 & _M|brerelease
.formula U|xtcom = "<(Sales)>" + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 34 &  M|brerelease
.formula U|xtcom = "<(Sales)>" + 'M|ttrans^id' + "<(Invoice)>"  ? M|ttrans^typ = 35 &  M|brerelease
.formula U|xtcom = "<(Sales)>" + 'M|ttrans^id' + "<(Edit)>" ? M|ttrans^typ = 35 & _M|brerelease
.continue END
..
!ERROR1
.error Freigabe nicht mîglich.
.end 1
..
!ERROR2
.error Vorgang bearbeiten, zeigen, buchen nicht mîglich.
.end 1
..
!ERROR3
.error Nur fÅr Serviceangebot, Serviceauftrag und Reparaturauftrag mîglich!
.end 1
..
!ERROR
.error
.end 1
..*****************************************************************************
!END
.end 0 'U|xtcom'
