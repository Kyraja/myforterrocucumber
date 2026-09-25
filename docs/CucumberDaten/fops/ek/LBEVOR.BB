..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : LBEVOR.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  :
..*****************************************************************************
.set trans -
..
.type text  xtsel       ? _F|defined(U|xtsel)
..
.continue BUTTON  ? G|evtartengl="BUTTON_BEFORE" & G|evtvar="angefragt2"
.continue FATAL
..
!BUTTON
.continue ERROR02 ? F|empty(M|angefragt)
.formula U|xtsel = "<(Purchasing)> " + 'M|vorgang^id' + " <(View)>,(PurchaseOrderSuggestions) ? 1:angefragtbu= | [invisible]=1"
.end 0 'U|xtsel'
..*****************************************************************************
..
!FATAL
.error -number 1111
.end 1
..
!ERROR02
.error -line 0 -field M|angefragt -message Es gibt noch keine Anfragen zum Bestellvorschlag.
.end 1
