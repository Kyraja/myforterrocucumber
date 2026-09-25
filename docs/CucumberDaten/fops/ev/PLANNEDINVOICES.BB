..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : PLANNEDINVOICES.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  :
..*****************************************************************************
.set trans -
.type text     xtcmd        ? _F|defined(U|xtcmd)
..
!ANZAHLUNG
.continue ERROR   ? F|empty(M|evpos)
.continue EINKAUF ? M|einkauf
.formula U|xtcmd = "<(Sales)> <(New)>, (Invoice) ? vorganga=(Downpayment) | beleg=" + 'M|evpos^id'
.continue COMMAND
..
!EINKAUF
.formula U|xtcmd = "<(Purchasing)> <(New)>, (Invoice) ? vorganga=(Downpayment) | beleg=" + 'M|evpos^id'
..
!COMMAND
.continue ANZAHLUNG ? G|evtartengl = "BUTTON_AFTER" & G|evtvar = "buanzerstellen"
.continue END
..
..*****************************************************************************
!ERROR
.error Anzahlung erstellen nicht m”glich.
.end 1
..
!ERROR1
.error Keine Fakturaplanposition vorhanden.
.end 1
..
!END
.end 0 'U|xtcmd'
