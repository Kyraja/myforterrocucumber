..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : PRODLIST.BB
.. Author         : cl
.. Verantwortlich : tiwe
.. Kontrolle      : cl 
.. Functionality  : Button-Vor-FOP fÅr ".command -wait"-Aufrufe
..*****************************************************************************
.type text xtkomm ? _F|defined(U|xtkomm)
..
.set trans -
.continue RUECKB    ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "burueck2"
.continue COMP      ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "comp2"
.continue UEBER     ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "buchen2"
.continue FVANLEGEN ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "bufvanlegen2"
.continue ZEIT      ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "buzeit2"
.continue ERROR
..
!ZEIT
.continue ERROR9 ? F|empty(M|buzeitz)
.formula U|xtkomm = "(TimeEntry)"+ " ? barmex=" + M|order^nummer
.continue END
..
!FVANLEGEN
.continue FV     ? F|empty(M|kart)
.continue ERROR5 ? M|kart^gruppe <> 1
.continue ERROR6 ? F|equals(M|kart^bsart, "(Subcontracting)")
..
!FV: Fertigungsvorschlag anlegen
.formula U|xtkomm = "<(Purchasing)> <(New)>,(WorkOrderSuggestions)"
.continue END                    ? F|empty(M|kart)
.formula U|xtkomm = U|xtkomm + " ? [insert]=1|1:artex="+'M|kart'
.continue END 
..
!UEBER
.continue ERROR4  ? F|empty(M|buchenz)
.continue ERROR4  ? F|empty(M|order)
..
.formula U|xtkomm = "<(Workorder)>"+M|order^id+"<(Transfer)>"
.continue END
..
!RUECKB
.continue ERROR7  ? F|empty(M|burueck)
.continue ERROR7  ? F|empty(M|order)
.continue RETURN  ? F|empty(M|barm)
..
.formula U|xtkomm = "<(Object)>"+M|barm^id+"<(Edit)>"
.continue END
..
!RETURN
.continue ERROR8 ? _M|breterlaub
.formula U|xtkomm = "<(Workorder)>"+M|order^id+"<(Return)>"
.continue END
..
!COMP
.continue ERROR1  ? F|empty(M|compz)
.continue ERROR2  ? M|compz = M|lbdez
.continue ERROR1  ? F|empty(M|order)
.continue FERTIG  ? F|empty(M|barm)
..
!AENDERN
.formula U|xtkomm = "<(Object)>"+M|barm^id+"<(Edit)>"
.continue END
..
!FERTIG
.continue ERROR3 ? _M|brmerlaub
.formula U|xtkomm = "<(Workorder)>"+M|order^id+"<(Done)>"
.continue END
..
!ERROR 
.error Kein passendes Event gefunden.
.end 1
..
!ERROR1
.error RÅckmeldung nicht mîglich.
.end 1
..
!ERROR2
.error Vor dem RÅckmelden erst offenen BDE-Datensatz zu diesem BA/AS Åbertragen.
.end 1
..
!ERROR3
.error Eine RÅckmeldung ist nicht erlaubt.
.end 1
..
!ERROR4
.error Buchen nicht mîglich.
.end 1
..
!ERROR5
.error Es kînnen nur FertigungsvorschlÑge fÅr Artikel angelegt werden.
.end 1
..
!ERROR6
.error FÅr Artikel mit der Beschaffungsart Lohnfertigung kann kein Fertigungsvorschlag angelegt werden.
.end 1
..
!ERROR7
.error RÅckbau nicht mîglich.
.end 1
..
!ERROR8
.error Ein RÅckbau ist nicht erlaubt.
.end 1
..
!ERROR9
.error Zeitbuchung nicht mîglich.
.end 1
..*****************************************************************************
!END
.end 0 'U|xtkomm'

