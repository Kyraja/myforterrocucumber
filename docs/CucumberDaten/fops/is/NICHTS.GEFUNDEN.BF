..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : NICHTS.GEFUNDEN.BF
.. Autor          : fwester
.. Verantwortlich : fwester
.. Kontrolle      : cl
.. Funktion       : Gibt "Nichts gefunden"-Hinweis, bei leerer Tabelle im Puffer M.
.. Functionality  : Gives a note "Nothing found" while table in buffer M is empty.
..*****************************************************************************
.set trans -
..
.continue END ? M|tzeilen > 0
.continue END ? G|edp
..
.note Keine passenden Daten gefunden
..*****************************************************************************
!END
.continue
