..!interpreter english translate noabbrev
..<META M|='dfue/FOPANALYZER' > 
..*****************************************************************************
.. Name           : FOPANALYZER.START.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      : carue
.. Functionality  : start button before event, checks permissions
..*****************************************************************************
.set trans - 
..
.make screen line --
.. 
.type bool stdVerzErlaubt
.type bool indVerzErlaubt
.. 
.copy U|stdVerzErlaubt = G|false
.copy U|indVerzErlaubt = G|false 
.. 
.select permission 'M|karb^id' 
.continue ENDARB ?_G|mehr
!NEXT                            
.select line
.continue ENDARB ?_G|mehr
.copy U|stdVerzErlaubt = G|true ? M|kstdverz=H|verz
.copy U|indVerzErlaubt = G|true ? M|kindivverz=H|verz
.continue NEXT
!ENDARB
.select -
.. 
.continue NOSTD ? _U|stdVerzErlaubt
.continue NOIND ? _U|indVerzErlaubt
..
..*****************************************************************************
!END
.continue
.. 
.. 
!NOSTD
.error Das Verzeichnis 'M|kstdverz' ist kein zul„ssiger Arbeitsbereich.
.end 1
.. 
!NOIND
.error Das Verzeichnis 'M|kindivverz' ist kein zul„ssiger Arbeitsbereich.
.end 1 
