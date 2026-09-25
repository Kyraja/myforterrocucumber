..!interpreter english translate noabbrev
..!meta M|=dfue/PRICAT
..*****************************************************************************
.. Name           : PRICAT.PRICATPRUEFEN.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  :
...Includes       :
..  include dfue/PRICAT.FILES
..  include dfue/DFUE.GET.PROTOK
..*****************************************************************************
.set trans -
..
.. Clear previous edi numbers
.formula M|edinr = ""
.formula M|idprialt = "" 
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
.type integer xDFUEproto
.type text xintedi
.type text xextedi
..
.. Check if PRICAT is active an get latest transmit number
.formula U|xedinachr = "2116"
.input "DFUE.GET.PROTOK"
.continue NOPROT ? _U|xediaktiv
.continue NOPROT ?  F|empty(U|xDFUEproto)
..
.formula U|xintedi = "PRICAT.IHSS" ? F|empty(U|xintedi)
.formula M|intedi = U|xintedi
.assign M|idprialt = 'F|formatstr("$,,;@gruppe=0;edinachr=2116;nummer=={1}", U|xextedi)' ? _F|empty(U|xextedi)
.. 
.. Incomplete data in edinfo object?
.assign M|idprialt = 'F|formatstr("$,,;@gruppe=0;edinachr=2116;idkundeab=={1};@ordnung=erfass.(Backwards)", M|kunde^nummer)' ?  F|empty(M|idprialt)
.assign M|uebnrprialt = M|idprialt^uebnr ? F|empty(M|uebnrprialt)
.formula M|uebnrprialt = "0" ? F|empty(M|uebnrprialt)
..
.. Initialize file names
.input "PRICAT.FILES"
..
.select -
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
