..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : NKZSIM.REFERENZOBJEKT.FX
.. Author         : fhil
.. Verantwortlich : lei
.. Kontrolle      : ba
.. Functionality  :
..*****************************************************************************
..
.set trans -
..
.type text U|xsel ? _F|defined(U|xsel)
..
.continue END ? F|empty(M|referenzobjekt)
..
.assign M|nzieldn = M|referenzobjekt^dnr
..
.assign U|xsel = "$,,dbnr=" + 'M|referenzobjekt^dnr' +";gruppennummer=" + 'M|referenzobjekt^objgruppe'
..
.load 0 group "181:2" 'U|xsel'
..
.continue END ? _G|mehr
..
.assign M|gruppenkonfig = 0|nummer
.assign M|startnkz = 0|nkzuordnung
..
!END
.continue
