..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : CREATECONTACCOUNT.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      :
.. Functionality  :
..*****************************************************************************
.set trans -
.type bool xbmark        ? _F|defined(U|xbmark)
..
.assign M|mark     = "(0)"
.copy U|xbmark   = G|FALSE
..
.continue END      ? M|tzeilen = 0
.continue MARK     ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "selall"
.continue DEMARK   ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "deselall"
..
!MARK
.copy U|xbmark = G|TRUE
.assign M|mark   = "(43)"
.input "is/TAB.MARK"
.continue END
..
!DEMARK
.copy U|xbmark = G|FALSE
.assign M|mark   = "(45)"
.input "is/TAB.MARK"
..
..*****************************************************************************
!END
.continue
