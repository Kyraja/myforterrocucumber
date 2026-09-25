..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : EDINFAKT.BF
.. Datum          : 24.05.2007
.. Version        : 2007r3n00
.. Autor          : mh
.. Verantwortlich : mh
.. Kontrolle      : cl
.. Funktion       : Nachbearbeitung des Berichts
..
.. Schnittstelle (Parameter und ihre Bedeutung)
..   verwendet Arrayparameter (arg.i)          : nein
..   verwendet Namensparameter (xpname=wert)   : nein
..
.. Ablauf         : Berichtsfuss EFOP
..
.. Functionality  : can be used to process data at end of evaluation
..
.. Interface (arguments and their meaning)
..   uses array argument (arg.i)           : no
..   uses name argument  (xpname=value)    : no
..
.. Program flow   : report footer efop
...Includes       :
..*****************************************************************************
.set trans -
..
.input "dfue/EDINFAKT.KBUPRUEFEN.BN"      ?  M|kbsofortprue
.input "dfue/EDINFAKT.KBUZEILEN.BN"       ?  M|kbsofortzeil
..*****************************************************************************
!END
.continue
