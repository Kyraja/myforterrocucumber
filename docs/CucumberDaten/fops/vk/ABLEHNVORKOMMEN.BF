..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : ABLEHNVORKOMMEN.ME
.. Autor          : fwester
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Funktion       : Initialisiert den Maskenpuffer.
.. Functionality  : Initializes buffer of mask.
..*****************************************************************************
.set trans -
..
.continue NOTHING ? F|empty(M|absvorkommen) ; _M|zeigrelativ
.select screen header
..
.. Calculate realtive occurences in header
.formula M|relvorkommen = 100.00
.formula M|rellebendig = F|round((M|abslebendig * 100) / M|absvorkommen, 2)
.formula M|relabgelegt = F|round((M|absabgelegt * 100) / M|absvorkommen, 2)
.formula M|relabgelehnt = F|round((M|absabgelehnt * 100) / M|absvorkommen, 2)
.formula M|relaktiv = F|round((M|absaktiv * 100) / M|absvorkommen, 2)
.continue FILED ? F|empty(M|abslebendig)
.formula M|relvolllebendig = 100.00
.formula M|rellebaktiv = F|round((M|abslebaktiv * 100) / M|abslebendig, 2)
.formula M|rellebabgelehnt = F|round((M|abslebabgelehnt * 100) / M|abslebendig, 2)
..
!FILED
.continue ACTIVE ? F|empty(M|absabgelegt)
.formula M|relvollabgelegt = 100.00
.assign M|relablaktiv = F|round((M|absablaktiv * 100) / M|absabgelegt, 2)
.assign M|relablabgelehnt = F|round((M|absablabgelehnt * 100) / M|absabgelegt, 2)
..
!ACTIVE
.continue REJECT ? F|empty(M|absaktiv)
.formula M|relvollaktiv = 100.00
.assign M|relaktlebendig = F|round((M|absaktlebendig * 100) / M|absaktiv, 2)
.assign M|relaktabgelegt = F|round((M|absaktabgelegt * 100) / M|absaktiv, 2)
..
!REJECT
.continue NEXTROW ? F|empty(M|absabgelehnt)
.formula M|relvollabgelehnt = 100.00
.assign M|relabglebendig = F|round((M|absabglebendig * 100) / M|absabgelehnt, 2)
.assign M|relabgabgelegt = F|round((M|absabgabgelegt * 100) / M|absabgelehnt, 2)
..
!NEXTROW
.select screen line
.continue END ? _G|mehr
..
.. Calculate relative occurences in table
.formula M|trelvorkommen = F|round((M|tabsvorkommen * 100) / M|absvorkommen, 2)
.continue NEXTROW
..
!NOTHING: Nothing found
.input "is/NICHTS.GEFUNDEN.BF"
..*****************************************************************************
!END
.continue
