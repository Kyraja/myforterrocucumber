..!interpreter english translate noabbrev
..!meta M|=dfue/PRICAT
..*****************************************************************************
.. Name           : PRICAT.PRICAT.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  : Initialize pricat export.
...Includes       :
..  include dfue/DFUE.GET.PROTOK
..*****************************************************************************
.set trans -
..
.. Must have at least one row with a product
.select screen line "$,,;art<>`"
.continue NOPROD ? _G|mehr
..
.. Missing required argument
.continue NOCUST ? F|empty(M|kunde)
..
..!meta H|=P0:1
.select customer 'M|kunde^id'
..
.. Fields for DFUE.GET.PROTOK
.type P109:2 xedinachr
.type bool xediaktiv
..
.. Check if PRICAT is active an get latest transmit number
.formula U|xedinachr = "2116"
.input "DFUE.GET.PROTOK"
.continue NOPROT ? _U|xediaktiv
..
.. Initialize file names
.continue ERROR ? F|empty(M|intedi) ; F|empty(M|dateiname)
..
..*****************************************************************************
!END
.continue
..
..
!NOPROD
.error Es wurde kein Artikel geladen!
.end 1
..
!NOCUST
.error Geben Sie einen Kunden ein!
.end 1
..
!NOPROT
.error Das Versenden der Artikelpreisliste ist nicht aktiv.
.end 1
..
!ERROR
.error Vor dem Erstellen einer neuen Artikepreisliste muss zuerst die alte Artikelpreisliste geprÅft werden.
.end 1
