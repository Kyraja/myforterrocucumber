..!interpreter english translate noabbrev
..*****************************************************************************
..  FOP-Name       : PRODLIST.RB
..  Version        :
..  Autor          : cl
..  Verantwortlich : tiwe
..  Kontrolle      : cl
..  Funktion       : Infosystem, Liste der FertigungsvorschlÑge
..                   RÅckbau
..  Ablauf         :
..*****************************************************************************
.set trans -
.type text xtkomm ? _F|defined(U|xtkomm)
..
.continue AKTU ? G|evtartengl = "BUTTON_AFTER" & G|evtvar = "burueck2"
.continue AKTU ? G|evtartengl = "BUTTON_AFTER" & G|evtvar = "tzeit2"
.continue ZEIT ? G|evtartengl = "BUTTON_AFTER" & G|evtvar = "buzeit"
..
!RUECKBAU
.continue BOX1    ? F|empty(M|burueck)
.continue         ? F|empty(M|order)
.continue FERTIG  ? F|empty(M|barm)
..
!AENDERN
.formula U|xtkomm = "<(Object)>"+M|barm^id+"<(Edit)>"
.command -wait 'U|xtkomm'
.continue AKTU
..
!FERTIG
.continue FEHLER ? _M|breterlaub
.formula U|xtkomm = "<(Workorder)>"+M|order^id+"<(Return)>"
.command -wait 'U|xtkomm'
.continue AKTU
..
!ZEIT
.continue ? F|empty(M|buzeit)
.formula U|xtkomm = "(TimeEntry)"+ " ? barmex=" + M|order^nummer
.command -wait 'U|xtkomm'
.continue AKTU
..
!AKTU: Tabelle leeren
.input "is/TABLEEREN"
.continue NAECHST          ?  _F|empty(M|kba)
.continue HOLE
..
!NAECHST
.continue BALEEREN         ? F|empty(M|kba)
.select add M|kba
.continue BALEEREN         ? _G|mehr
.select -
.continue HOLE
..
!BALEEREN: BA und M|select leeren
.formula M|kba    = ""
.formula M|select = ""
.continue
..
!HOLE: Tabelle aktualisieren / neu aufbauen
.input "is/HOL.LISTE"
.continue
..
!BOX1
.box
RÅckbau nicht mîglich.
.continue
..
!FEHLER
.error Ein RÅckbau ist nicht erlaubt.
.end 1
