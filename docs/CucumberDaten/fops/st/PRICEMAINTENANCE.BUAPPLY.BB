..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : PRICEMAINTENANCE.BUAPPLY.BB
.. Author         : fwester
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  : Validates mask input items before applying.
.. Gives an error message in two cases:
.. 1st Type is discount but no target item is specified.
.. 2nd Type is price but no target item is specified.
..*****************************************************************************
.set trans -
..
.type bool apply2header
.type bool apply2table
..
.continue PRICE   ? _M|ktyprabatt
..
.. Discount items
.copy U|apply2header = G|false
.copy U|apply2table = M|setsurcharge
.continue ERROR01 ?  _U|apply2header & _U|apply2table
.continue END
..
!PRICE: Price items
.copy U|apply2header = M|setpreprodprice ; M|setnewpreprodprice ; M|setunitprice ; M|setnewunitprice
.copy U|apply2table = M|setscaledprice ; M|setnewscaledprice
.continue ERROR02 ? _U|apply2header & _U|apply2table
..*****************************************************************************
!END
.continue
..*****************************************************************************
..
!ERROR01: No matching item specified!
.error -line 0 -field M|setsurcharge -message Bitte geben Sie mindestens eine zu pflegende Rabatteigenschaft vor!
.end 1
..
!ERROR02: No matching item specified!
.error -line 0 -field M|setscaledprice -message Bitte geben Sie mindestens eine zu pflegende Preiseigenschaft vor!
.end 1
