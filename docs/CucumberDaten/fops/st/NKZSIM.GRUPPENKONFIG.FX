..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : NKZSIM.GRUPPENKONFIG.FX
.. Author         : fhil
.. Verantwortlich : lei
.. Functionality  :
..*****************************************************************************
..
.set trans -
..
.continue END ? F|empty(M|gruppenkonfig)
..
.assign M|startnkz = M|gruppenkonfig^nkzuordnung
.assign M|nzieldn = M|gruppenkonfig^dbnr
.assign M|referenzobjekt = ""
..
!END
.continue
