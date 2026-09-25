..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : KDINFO.NEUOBJ.BB
.. Autor          : fwester
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  : Defines a dialog to create new objects.
.. Program flow   : Before button efop
..*****************************************************************************
.set trans -
..
.. Declarations
.type text xtmenzeil1
.type text xtmenzeil2
.type text xtmenzeil3
.type text xtmenzeil4
.type text xtmenzeil5
.type text xtmenzeil6
.type text xtmenzeil7
.type text xtmenzeil8
.type text xtmenzeil9
.type text xtmenzeil10
.type text xtmenzeil11
.type text xtmenzeil12
.type text xtmenzeil13
.type text xtcmd
.type text xtmenutxt
..
.. Initializations
.formula U|xtcmd = ""
.formula M|auswahl = ""
.set trans +
.formula U|xtmenutxt = "Objekt neu"
.formula U|xtmenzeil1 = "Aufgabe"
.formula U|xtmenzeil2 = "Angebot" ? F|defined(M|kbkdinfo)
.formula U|xtmenzeil2 = "Anfrage" ? F|defined(M|kblfinfo)
.formula U|xtmenzeil3 = "Auftrag" ? F|defined(M|kbkdinfo)
.formula U|xtmenzeil3 = "Bestellung" ? F|defined(M|kblfinfo)
.formula U|xtmenzeil4 = "Kunde" ? F|defined(M|kbkdinfo)
.formula U|xtmenzeil4 = "Lieferant" ? F|defined(M|kblfinfo)
.formula U|xtmenzeil5 = "Lieferschein"
.formula U|xtmenzeil6 = "Projekt"
.formula U|xtmenzeil7 = "Rahmenauftrag"
.formula U|xtmenzeil8 = "Rechnung"
.formula U|xtmenzeil9 = "Kundenkontakt" ? F|defined(M|kbkdinfo)
.formula U|xtmenzeil9 = "Lieferantenkontakt" ? F|defined(M|kblfinfo)
.formula U|xtmenzeil10 = "Speditionsauftrag"
.formula U|xtmenzeil11 = "Interessent"
.formula U|xtmenzeil12 = "Interessentenkontakt"
.formula U|xtmenzeil13 = "Chance"
.set trans -
..
.continue LFINFO ? F|defined(M|kblfinfo)
.continue KDINFO ? F|defined(M|kbkdinfo)
.continue FATAL
..
!LFINFO: Create menue for LFINFO
.continue ERROR1 ? _(F|cmdpermitted(86,14) ; F|cmdpermitted(4,14) ; F|cmdpermitted(1,14))
.menu 'U|xtmenutxt'
?'U|xtmenzeil1' >> .formula M|auswahl = U|xtmenzeil1 ? F|cmdpermitted(86,14,, 6)
?'U|xtmenzeil2' >> .formula M|auswahl = U|xtmenzeil2 ? F|cmdpermitted( 4,14,,21)
?'U|xtmenzeil3' >> .formula M|auswahl = U|xtmenzeil3 ? F|cmdpermitted( 4,14,,22)
?'U|xtmenzeil4' >> .formula M|auswahl = U|xtmenzeil4 ? F|cmdpermitted( 1,14,, 1)
?'U|xtmenzeil5' >> .formula M|auswahl = U|xtmenzeil5 ? F|cmdpermitted( 4,14,,23)
?'U|xtmenzeil6' >> .formula M|auswahl = U|xtmenzeil6 ? F|cmdpermitted(86,14,, 5)
?'U|xtmenzeil7' >> .formula M|auswahl = U|xtmenzeil7 ? F|cmdpermitted( 4,14,,20)
?'U|xtmenzeil8' >> .formula M|auswahl = U|xtmenzeil8 ? F|cmdpermitted( 4,14,,24)
?'U|xtmenzeil9' >> .formula M|auswahl = U|xtmenzeil9 ? F|cmdpermitted( 1,14,, 2)
.continue ANALYZE ? G|menue > 0
.continue CANCEL
..
!KDINFO: Create menue for KDINFO
.continue ALLITEM ? M|knumkusa^gruppe = 0 ; M|knumkusa^gruppe = 1 ; M|knumkusa^gruppe = 2
.continue PROSPEC ? M|knumkusa^gruppe = 6 ; M|knumkusa^gruppe = 7
.continue FATAL
..
!ALLITEM: All items allowed
.continue ERROR1 ? _(F|cmdpermitted(86,14) ; F|cmdpermitted(3,14) ; F|cmdpermitted(0,14) ; F|cmdpermitted(55,14))
.menu 'U|xtmenutxt'
?'U|xtmenzeil1'  >> .formula M|auswahl = U|xtmenzeil1  ? F|cmdpermitted(86,14,, 6)
?'U|xtmenzeil13' >> .formula M|auswahl = U|xtmenzeil13 ? F|cmdpermitted( 3,14,,30)
?'U|xtmenzeil2'  >> .formula M|auswahl = U|xtmenzeil2  ? F|cmdpermitted( 3,14,,21)
?'U|xtmenzeil3'  >> .formula M|auswahl = U|xtmenzeil3  ? F|cmdpermitted( 3,14,,22)
?'U|xtmenzeil4'  >> .formula M|auswahl = U|xtmenzeil4  ? F|cmdpermitted( 0,14,, 1)
?'U|xtmenzeil5'  >> .formula M|auswahl = U|xtmenzeil5  ? F|cmdpermitted( 3,14,,23)
?'U|xtmenzeil6'  >> .formula M|auswahl = U|xtmenzeil6  ? F|cmdpermitted(86,14,, 5)
?'U|xtmenzeil7'  >> .formula M|auswahl = U|xtmenzeil7  ? F|cmdpermitted( 3,14,,20)
?'U|xtmenzeil8'  >> .formula M|auswahl = U|xtmenzeil8  ? F|cmdpermitted( 3,14,,24)
?'U|xtmenzeil9'  >> .formula M|auswahl = U|xtmenzeil9  ? F|cmdpermitted( 0,14,, 2)
?'U|xtmenzeil10' >> .formula M|auswahl = U|xtmenzeil10 ? F|cmdpermitted(55,14,, 1)
?'U|xtmenzeil11' >> .formula M|auswahl = U|xtmenzeil11 ? F|cmdpermitted( 0,14,, 6)
?'U|xtmenzeil12' >> .formula M|auswahl = U|xtmenzeil12 ? F|cmdpermitted( 0,14,, 7)
.continue ANALYZE ? G|menue > 0
.continue CANCEL
..
!PROSPEC: Create menue for prospective customers
.continue ERROR1 ? _(F|cmdpermitted(86,14) ; F|cmdpermitted(3,14) ; F|cmdpermitted(0,14))
.menu 'U|xtmenutxt'
?'U|xtmenzeil1'  >> .formula M|auswahl = U|xtmenzeil1  ? F|cmdpermitted(86,14,, 6)
?'U|xtmenzeil13' >> .formula M|auswahl = U|xtmenzeil13 ? F|cmdpermitted( 3,14,,30)
?'U|xtmenzeil2'  >> .formula M|auswahl = U|xtmenzeil2  ? F|cmdpermitted( 3,14,,21)
?'U|xtmenzeil4'  >> .formula M|auswahl = U|xtmenzeil4  ? F|cmdpermitted( 0,14,, 1)
?'U|xtmenzeil6'  >> .formula M|auswahl = U|xtmenzeil6  ? F|cmdpermitted(86,14,, 5)
?'U|xtmenzeil9'  >> .formula M|auswahl = U|xtmenzeil9  ? F|cmdpermitted( 0,14,, 2)
?'U|xtmenzeil11' >> .formula M|auswahl = U|xtmenzeil11 ? F|cmdpermitted( 0,14,, 6)
?'U|xtmenzeil12' >> .formula M|auswahl = U|xtmenzeil12 ? F|cmdpermitted( 0,14,, 7)
.continue ANALYZE ? G|menue > 0
.continue CANCEL
..
!ANALYZE: Analyze choice and prepare ERP command
.continue CANCEL ? F|empty(M|auswahl)
.continue PROCESS ? M|auswahl = U|xtmenzeil1 ; M|auswahl = U|xtmenzeil6
.continue PURSALE ? M|auswahl = U|xtmenzeil2 ; M|auswahl = U|xtmenzeil3 ; M|auswahl = U|xtmenzeil5 ; M|auswahl = U|xtmenzeil7 ; M|auswahl = U|xtmenzeil8 ; M|auswahl = U|xtmenzeil13
.continue SHIPPIN ? M|auswahl = U|xtmenzeil10
.continue CUSSUPP ? M|auswahl = U|xtmenzeil4 ; M|auswahl = U|xtmenzeil9 ; M|auswahl = U|xtmenzeil11 ;  M|auswahl = U|xtmenzeil12
.continue FATAL
..
!PROCESS: processes
.formula U|xtcmd = "<(Transaction)><(New)>," + M|auswahl
.formula U|xtcmd = U|xtcmd + "? ursache = " + M|knumkusa^id
.continue COMMAND
..
!PURSALE: purchasing or sales
.continue PURCHAS ? F|defined(M|kblfinfo)
.continue SALES ? F|defined(M|kbkdinfo)
.continue FATAL
..
!PURCHAS: purchasing
.formula U|xtcmd = "<(Purchasing)><(New)>," + M|auswahl
.continue COMMAND ? F|empty(M|knumkusa)
.formula U|xtcmd = U|xtcmd + "? lief = " + M|knumkusa^id
.continue COMMAND
..
!SALES
.formula U|xtcmd = "<(Sales)><(New)>," + M|auswahl
.continue COMMAND ? F|empty(M|knumkusa)
..weiter PROTIVE ? M|knumkusa^gruppe = 6 ; M|knumkusa^gruppe = 7
.formula U|xtcmd = U|xtcmd + "? kunde = " + M|knumkusa^id
.continue COMMAND
..
!PROTIVE: only offers allowed for prospective customers
.continue FATAL ? M|auswahl <> U|xtmenzeil2
.formula U|xtcmd = U|xtcmd + "? kunde = " + M|knumkusa^id
.continue COMMAND
..
!SHIPPIN: shipping document
.formula U|xtcmd = "<(ShipOrder)><(New)>"
.continue COMMAND ? F|empty(M|knumkusa)
.formula U|xtcmd = U|xtcmd + "? kunde = " + M|knumkusa^id
.continue COMMAND
..
!CUSSUPP: customer or supplier
.continue CUSTOM ? F|defined(M|kbkdinfo)
.continue SUPPLY ? F|defined(M|kblfinfo)
.continue FATAL
..
!CUSTOM
.formula U|xtcmd = "<(Customer)><(New)>," + M|auswahl
.continue COMMAND ? F|empty(M|knumkusa)
.continue COMMAND ? M|auswahl = U|xtmenzeil4 ; M|auswahl = U|xtmenzeil11
.continue COMMAND ? M|auswahl = U|xtmenzeil9 & M|knumkusa^gruppe = 6
.continue COMMAND ? M|auswahl = U|xtmenzeil12 & M|knumkusa^gruppe = 1
.formula U|xtcmd = U|xtcmd + "? firma = " + M|knumkusa^id
.continue COMMAND
..
!SUPPLY
.formula U|xtcmd = "<(Vendor)><(New)>," + M|auswahl
.continue COMMAND ? F|empty(M|knumkusa)
.continue COMMAND ? M|auswahl = U|xtmenzeil4
.formula U|xtcmd = U|xtcmd + "? firma = " + M|knumkusa^id
.continue COMMAND
..
!COMMAND
.end 0 'U|xtcmd'
..*****************************************************************************
!FATAL
.error(1111)
.end 1
..
!CANCEL: Supress core message and cancel action
.error
.end 1
..
..
!ERROR1
.error -message Es sind dem Bediener keine Neuanlagen durch diesen Button erlaubt!
.end 1
