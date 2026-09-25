..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : EKLAB.TBUVORSCHLAG.BB
.. Author         : fwester
.. Verantwortlich : mh
.. Kontrolle      : cl
.. Functionality  : Opens dialog <(Purchasing)><(Edit)>,(PurchaseOrderSuggestions) 
..*****************************************************************************
..<META M|='ek/EKLAB'>
.set trans -
..
.continue FATAL   ? _G|evtartengl = "BUTTON_BEFORE"
.continue FATAL   ? _G|evtvar = "tbuvorschlag" & _G|evtvar = "tbuvorschlag2"
..
.formula M|tcommand = "<(Purchasing)><(Edit)>,(PurchaseOrderSuggestions)"
.formula M|tcommand = M|tcommand + "? kl= " + 'M|tlief^id' + " | art= " + 'M|tartikel^id' + " | ladetab=" ? _F|empty(M|tbv)
.formula M|tcommand = M|tcommand + "?                            art= " + 'M|tartikel^id' + " | ladetab=" ?  F|empty(M|tbv)
.continue SUBEDIT ? G|evtvar="tbuvorschlag2"
.continue END
..
!SUBEDIT: Open dialog as subeditor
.end 0 'M|tcommand'
..*****************************************************************************
!END
.continue
..*****************************************************************************
!FATAL: Wrong usage
.error -number 1111
.end 1
