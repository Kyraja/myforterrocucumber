..!interpreter english translate noabbrev
..!meta M|=dfue/PRICAT
..*****************************************************************************
.. Name           : PRICAT.LESPPROT.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  :
..*****************************************************************************
.set trans - 
..
.continue NOFILE ?  F|empty(M|dateiname)
.continue NOFILE ? _F|fileexists(M|dateiname)
.continue NOFILE ?  F|isdir(M|dateiname)
..
.continue NOPROT ?  F|empty(M|pprot)
.continue NOPROT ? _F|fileexists(M|pprot)
.continue NOPROT ?  F|isdir(M|pprot)
..
.type text x1
.type text xart
.type text xartvor
.type text xacode
.type text xalt
.type text xneu
.. 
.formula U|xartvor = ""
..
.left 1
.right 299
..
.input DRUCKER
.input BLANKO.F
..
.set trans +
Datum: 'G|datum   '                           Seite: 'G|seite'
Bearbeiter: 'G|bzeichen '
Kunde: 'M|kunde     '        Alter PRICAT-Datensatz: 'M|idprialt'

 PROTOKOLL Artikelpreisliste
         (EDIFACT-PRICAT)

.set trans -
!HOL
.select from 'M|pprot' x1^
.continue ENDPROT ? _G|mehr
.formula U|xart = ((((U|x1>>"#")>>"#")>>"#")>>"#") << "#"  ? U|x1<<3="ART"
.formula U|xacode = (U|x1>>"#")<<"#"                       ? U|x1<<3="ART"
..
.set trans +
?Artikel: 'U|xart'  Actionscode: 3 ('M|aktgeaendert')       ? U|x1<<3="ART" & U|xart<>U|xartvor & _(U|xacode="1" ; U|xacode="4" ; U|xacode="2")
?Artikel: 'U|xart'  Actionscode: 1 ('M|aktaddiert')         ? U|x1<<3="ART" & U|xart<>U|xartvor &   U|xacode="1" & U|xart<>""
?Artikel: 'U|xart'  Actionscode: 4 ('M|aktkeineaenderung')  ? U|x1<<3="ART" & U|xart<>U|xartvor &   U|xacode="4"
?Artikel: 'U|xart'  Actionscode: 2 ('M|aktgeloescht')       ? U|x1<<3="ART" & U|xart<>U|xartvor &   U|xacode="2"
..
.formula xalt = x1>>"<"                             ? U|x1<<1="<"
.formula xneu = x1>>">"                             ? U|x1<<1=">"
?ALT    : 'U|xalt'                                  ? U|x1<<1="<"
?NEU    : 'U|xneu'                                  ? U|x1<<1=">"
.set trans -
..
.formula U|xartvor = U|xart
.continue HOL
!ENDPROT
..
..*****************************************************************************
!END
.continue
.. 
.. 
!NOPROT
.error Es wurde keine Protokolldatei erstellt!
.end 1
..
!NOFILE
.error Es wurde keine Artikelpreisliste erstellt!
.end 1
