..!interpreter english translate noabbrev
..!meta M|=dfue/EDICOLINVOICEPRINT
..*****************************************************************************
.. Name           : EDICOLINVOICEPRINT.BSTART.BB
.. Autor          : mh
.. Verantwortlich : mh
.. Kontrolle      : dsch
.. Functionality  : Start button - button before event
..*****************************************************************************
.set trans -
..
.continue NOARGS ? F|empty(M|kedi)
.continue NOINVOI ? 'M|kedi^edinachraz(L=":")'<>"(Invoice)"
..
.make screen line --
..
..*****************************************************************************
!END
.continue
..
..
!NOARGS
.cursor kedi 0
.error Bitte geben Sie eine EDI-Nachricht ein!
.end 1
..
!NOINVOI
.cursor kedi 0
.error Das ist keine EDI-Rechnung!
.end 1

