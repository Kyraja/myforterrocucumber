..!interpreter english translate noabbrev
..!meta M|=dfue/EDIEXPORT
..*****************************************************************************
.. FOP-Name       : EDIEXPORT.SENDEN.FP
.. Autor          : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Funktion       : Aenderung der Felder Senden ja/nein bzw. Uebertragungsdatum
.. Functionality  : Change in Fields transmit yes/no or transmit date
...Incluces
..  include dfue/SHIPORDER.SET.EDIPARAMS
..*****************************************************************************
.set trans -
..
.type text   xNieSendenBoxTitel
.type text   xNieSendenBoxText1
.type text   xNieSendenBoxText2
.type text   xNieSendenMenue
.type bool   setdfuesenden
.type gd     setdfuedat
..
.type text xident   ? _F|defined(U|xident)
.type text xtmpfile ? _F|defined(U|xtmpfile)
.type text xtout    ? _F|defined(U|xtout)
.type text xterr    ? _F|defined(U|xterr)
..
.file -tempname U|xtmpfile
.file -tempname U|xtout
.file -tempname U|xterr
..
.set trans +
.formula U|xNieSendenBoxTitel = "Warnung: Deaktivieren des Rechnungs-DFUE"
.formula U|xNieSendenBoxText1 = "Nach Entfernen dieser Markierung wird die Rechnung nicht mit EDI gesendet."
.formula U|xNieSendenBoxText2 = "Betroffene Rechnungen werden mit D.<Benutzerzeichen> gekennzeichnet."
.formula U|xNieSendenMenue = "Warnung: Wollen Sie diese Rechnung endgltig deaktivieren?"
.set trans -
..
..
.. event evaluation
.. ----------- ----- Table Events ----------------------------------------------
.continue SENDEN  ? G|evtartengl = "FIELD_VALIDATION"  & G|evtvar="senden"
.continue SENDAT  ? G|evtartengl = "FIELD_VALIDATION"  & G|evtvar="senddat"
.. ----------- ---------- ---------- -------------------------------------------
.continue END
..
..
..
..  Checkbox "transmit yes/no" changed
..  * invoices
..  * shipping order + linked delivery notes
..
!SENDEN
.. Lieferschein
.continue SHIPORD ?  M|vorart = 25 ; 'M|vorartname(L=":")' = "(PackingSlip)"
.. Auftragsbest„tigung
.continue SENDAB  ?  M|vorart = 23 ; 'M|vorartname(L=":")' = "(SalesOrderConfirmation)"
.. Rechnung
.continue SENDRE  ?  M|vorart =  5 ; 'M|vorartname(L=":")' = "(Invoice)"
.continue END
..
..
!SENDRE
.. unser interaction when disabling edi-invoice
.. no user interaction when edp'ing
.continue SENDRE2 ?  M|senden = true
.continue SENDRE2 ?  G|edp
.box 'U|xNieSendenBoxTitel'
'U|xNieSendenBoxText1'
'U|xNieSendenBoxText2'
.menu 'U|xNieSendenMenue'
'G|true'            >> .continue SENDRE2
'G|false'           >> .continue CANCEL
..
.. false was selected or cancel button was used,
.. restore before-event values
!CANCEL
.error
.end 1
..
.. change transmit yes/no in invoice
.. put brief notice into field "ident"
!SENDRE2
.select screen line 'M|aktzeile'
.. 
.select lock sales filingsystem nowait 'M|tvorgang^id'
.continue NODATA  ? _G|mehr
.. nur Rechnungen
.continue END     ?  H|typ <> reko
.continue NOLOCK  ? _G|gesperrt
.output new 'U|xtmpfile'
.input DATEI.F
#!database=3:24
#!action=modify 
#!charset=eks
.select
.formula U|xident = "D." + G|bzeichen ? _M|senden
.formula U|xident = ""                ?  M|senden
..
id;dfuesenden;ident
'M|tvorgang^id';'M|senden';'U|xident'    
..
.output
.system 'F|formatstr("edpimport.sh -p {1} -I {2} >{3} 2>{4}", G|einmalpw, U|xtmpfile, U|xtout, U|xterr)' background
.continue ERROR   ? _G|mehr
.continue END
..
!SENDAB
.select screen line 'M|aktzeile'
.select lock sales nowait 'M|tvorgang^id'
.continue NODATA  ? _G|mehr
.continue NOLOCK  ? _G|gesperrt
.output new 'U|xtmpfile'
.input DATEI.F
#!database=3:22
#!action=modify
#!charset=eks
.select
id;dfuesenden
'M|tvorgang^id';'M|senden'
.output
.system 'F|formatstr("edpimport.sh -p {1} -I {2} >{3} 2>{4}", G|einmalpw, U|xtmpfile, U|xtout, U|xterr)' background
.continue ERROR   ? _G|mehr
.continue END
..
..
..  Transmit date changed
..  * invoice
..  * shipping order + linked delivery notes
..
!SENDAT
.continue SHIPORD ?  M|vorart = 25 ; 'M|vorartname(L=":")' = "(PackingSlip)"
.continue DATRE  ?  M|vorart =  5 ; 'M|vorartname(L=":")' = "(Invoice)"
.continue END
..
..
!DATRE
.select screen line 'M|aktzeile'
.select lock sales filingsystem nowait 'M|tvorgang^id'
.continue NODATA  ? _G|mehr
.continue END     ?  H|typ <> reko
.continue NOLOCK  ? _G|gesperrt
.output new 'U|xtmpfile'
.input DATEI.F
#!database=3:24
#!action=modify
#!charset=eks
.select
id;dfuedat
'M|tvorgang^id';'M|senddat'
.output
.system 'F|formatstr("edpimport.sh -p {1} -I {2} >{3} 2>{4}", G|einmalpw, U|xtmpfile, U|xtout, U|xterr)' background
.continue ERROR   ? _G|mehr
.continue END
..
!SHIPORD
.continue END ? M|tvorgang^uebdat=M|senddat & M|tvorgang^dfuesenden=M|senden
.copy U|setdfuesenden = M|senden
.copy U|setdfuedat = M|senddat
.select nolock transportcompany nowait 'M|tvorgang^id'
.input "dfue/SHIPORDER.SET.EDIPARAMS"
.continue END
..
..*****************************************************************************
!END
.continue
..
..
!NOLOCK
.error Der Vorgang 'M|tvorgang' kann nicht ge„ndert werden.
.end 1
..
!NODATA
.error Der Vorgang 'M|tvorgang' kann nicht gelesen werden.
.end 1
..
!ERROR
.input 'U|xterr'
.error Žndern der Rechnung gescheitert!
.end 1

