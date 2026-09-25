..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : EVKETTE.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  :
..*****************************************************************************
.type text    xtcom       ? _F|defined(U|xtcom)
..
.set trans -
.continue T2POST       ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "tpost2"
.continue ERROR1
..
!T2POST
.continue ERROR2  ?  F|empty(M|tvorgang)
.continue ERROR2  ?  M|tpost = ""
.formula U|xtcom = "<(Sales)>" + 'M|tvorgang^id' + "<(Edit)>?ueb=yes"       ? M|tvorgang^dnr = 3 & M|tpost = M|post
.formula U|xtcom = "<(Sales)>" + 'M|tvorgang^id' + "<(View)>"               ? M|tvorgang^dnr = 3 & M|tpost = M|show
.formula U|xtcom = "<(Purchasing)>" + 'M|tvorgang^id' + "<(Edit)>?ueb=yes"  ? M|tvorgang^dnr = 4 & M|tpost = M|post
.formula U|xtcom = "<(Purchasing)>" + 'M|tvorgang^id' + "<(View)>"          ? M|tvorgang^dnr = 4 & M|tpost = M|show
.continue END
..
!ERROR1
.error Kein passendes Event gefunden.
.end 1
..
!ERROR2
.error Vorgang zeigen oder bearbeiten und buchen nicht m”glich.
.end 1
..
..*****************************************************************************
.. Muss als letzter Eintrag im FOP stehen
!END:  .command -wait 'U|xtcom'
.end 0 'U|xtcom'

