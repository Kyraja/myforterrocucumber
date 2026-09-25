..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : PDMCENTER.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : mh
.. Functionality  :
..*****************************************************************************
.set trans -                   
..
.continue MARK      ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "selall"
.continue DEMARK    ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "deselall"
.continue END
..
!MARK
.assign M|mark = "(SelectAll)"
.input "is/TAB.MARK"
.continue END
..
!DEMARK
.assign M|mark = "(DeselectAll)"
.input "is/TAB.MARK"
..
..*****************************************************************************
!END
.continue
