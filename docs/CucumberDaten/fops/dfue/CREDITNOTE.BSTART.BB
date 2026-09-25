..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : CREDITNOTE.BSTART.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      : 
.. Functionality  : Validate required arguments before start button activity.
..*****************************************************************************
..!meta M|=dfue/CREDITNOTE
.set trans -
..
.continue END ? F|empty(M|kedi)
.continue NOCRED ? 'M|kedi^edinachraz(L=":")'<>"(CreditNote)"
.. 
.make screen line --
..
..*****************************************************************************
!END
.continue
..
..
!NOCRED
.cursor kedi 0
.error Das ist keine Gutschriftenanzeige!
.end 1
