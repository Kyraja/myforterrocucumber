..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : NKZSIM.STARTNKZ.FX
.. Author         : fhil
.. Verantwortlich : lei
.. Kontrolle      : ba
.. Functionality  :
..*****************************************************************************
..
.set trans -
..
.continue END ? F|empty(M|startnkz)
.copy M|zieldn = M|startnkz^zieldn
.input "is/TABLEEREN" 
..
!END
.continue
