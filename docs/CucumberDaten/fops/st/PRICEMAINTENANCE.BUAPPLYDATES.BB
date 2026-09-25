..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : PRICEMAINTENANCE.BUAPPLYDATES.BB
.. Author         : fwester
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  : Validates "Conditions valid from - until" presettings.
..*****************************************************************************
.set trans -
..
.. Dates must match
.continue END ? F|empty(M|datavalidfrom) ; F|empty(M|datavaliduntil)
.continue ERROR01 ? M|datavalidfrom > M|datavaliduntil
..*****************************************************************************
!END
.continue
..*****************************************************************************
..
!ERROR01: Dates did not match!
.error -line 0 -field M|datavalidfrom -message Das Anfangsdatum des Gltigkeitsbereichs darf nicht jnger als Enddatum sein!
.end 1
