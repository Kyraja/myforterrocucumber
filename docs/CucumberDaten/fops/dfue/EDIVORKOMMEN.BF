..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : PEDINACHRICHTEN.BF
.. Autor          : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Funktion       :
.. Functionality  :
..*****************************************************************************
.set trans -
..
.. only count, if check box for counting is marked
.continue END ? _M|kbedivorkommen
..
..
.type integer xihor
.type integer xiver
.type integer ximax
.type integer ximed
.type integer ximin
.type integer xigruen
..
.formula U|ximax = M|kanzalle
..
.select screen header
!NSPARK
.select screen line
.continue ESPARK  ? _G|mehr
.. possible data elements: sum all mgs types, sum 1 msg type, 6x status [error, in progress, new/new, new/ok, history, deactivated]
.. spread across 5 display options
..  * horizontal bar:   in progress   "error"
..  * vertical bar:                    error, in progress
..  * max background:   sum all msg types
..  * med background:   sum 1 msg type = error, in progress, new/new, new/ok, history, deactivated
..  * min background:   sum "ok"       = error, in progress, new/new
.formula U|xihor = M|tanzfehler
.formula U|xiver = M|tanzfehler + M|tanzinarbeit
.formula U|ximin = U|xiver + M|tanzneuoffen
.formula U|ximed = U|xiver + M|tanzneuoffen + M|tanzneuerledigt + M|tanzhistorie + M|tanzdeaktiviert
.. test
.formula U|xihor = "0"
.formula U|xiver = "0"
.formula U|ximin = M|tanzfehler
.formula U|ximed = M|tanzfehler + M|tanzinarbeit
.formula U|ximax = U|ximed + M|tanzneuoffen
.formula U|xigruen = U|ximax + M|tanzneuerledigt + M|tanzhistorie
.formula M|tanzsparkdata = "[" + 'U|xihor' + "," + 'U|xiver' + "," + 'M|kanzalle' + "," + 'U|xigruen' + "," + 'U|ximax' + "," + 'U|ximed' + "," + 'U|ximin' + "]"
.continue NSPARK
!ESPARK
..
..*****************************************************************************
!END
.continue
