..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : NKLIST.BSTART.BB
.. Author         : fhil
.. Verantwortlich : lei
.. Kontrolle      : ba
.. Functionality  : List of number ranges for database
..*****************************************************************************
..
.set trans -
..
.formula M|select = "$,,"
.formula M|select = M|select + "nzieldn=" + 'M|nzieldn'
.formula M|select = M|select + ";@gruppe=1;@order=untererrand;@order=obererrand"
..
.make screen line --
..*****************************************************************************
!END
.continue

