Feature: conf_automotive

# **********************************************************************************
#  Name             : conf_automotive.feature
#  Autor            : pw
#  Verantwortlich   : as
#  Kontrolle        :
#  Funktion         : Test des Konfigschalters (cf)automotive
#
#  Beschreibung     : Testet, ob Schreibschutz der Felder, die abhaengig vom
#                     Konfig-Schalter (cf)automotive sind, richtig sitzt.
#
# **********************************************************************************

  Scenario: 1. Sicherstellen, dass in Konfigsatz (cf)automotive nicht schon gesetzt ist

  Given I query "cfautomotive" from table "(Company):(Configuration)" where "such==KONFIG"
  Then query has values
  | nein |


  Scenario: 2. Erster Durchlauf ohne (cf)automotive

  Given I open an editor "VK-Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
  And I set field "kunde" to "1" in row 0
  # In Ein- und Verkauf
  Then setting field "lztabruf" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "verwschl" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "edllsnr" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "edllsdat" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "edl" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  # Nur im Verkauf
  Then setting field "ursplsnr" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  And I create a new row at the end of the table
  And I set field "artikel" to "V1" in row 1
  And I set field "mge" to "1" in row 1
  # In Ein- und Verkauf
  Then setting field "lsnredl" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "lsdatedl" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "labnr" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  # Nur im Verkauf
  Then setting field "ganr" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "gaedinr" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "fabnr" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "fabdat" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "lztau" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "fabediid" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "labediid" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "fzdiff" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "zefzdiff" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "konstaend" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  # Nur im Einkauf
  Then setting field "edinr" to "" in row 1 throws the exception "Ungültiger Feldname"
  And I close the current editor

  Given I open an editor "EK-Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
  And I set field "lief" to "1" in row 0
  # In Ein- und Verkauf
  Then setting field "lztabruf" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "verwschl" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "edllsnr" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "edllsdat" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "edl" to "" in row 0 throws the exception "Nur mit Automotive-Option nutzbar"
  # Nur im Verkauf
  Then setting field "ursplsnr" to "" in row 0 throws the exception "Ungültiger Feldname"
  And I create a new row at the end of the table
  And I set field "artikel" to "E1" in row 1
  And I set field "mge" to "1" in row 1
  # In Ein- und Verkauf
  Then setting field "lsnredl" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "lsdatedl" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  Then setting field "labnr" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  # Nur im Verkauf
  Then setting field "ganr" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "gaedinr" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "fabnr" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "fabdat" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "lztau" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "fabediid" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "labediid" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "fzdiff" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "zefzdiff" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "konstaend" to "" in row 1 throws the exception "Ungültiger Feldname"
  # Nur im Einkauf
  Then setting field "edinr" to "" in row 1 throws the exception "Nur mit Automotive-Option nutzbar"
  And I close the current editor


  Scenario: 3. Feld (cf)automitive in Konfigsatz setzen

  Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
  And I press button "bsperremand"
  And I set field "automotive" to "ja"
  And I save the current editor
  And I close the current editor


  Scenario: 4. Zweiter Durchlauf mit gesetztem (cf)automotive

  Given I open an editor "VK-Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
  And I set field "kunde" to "1" in row 0
  # In Ein- und Verkauf
  Then field "lztabruf" is modifiable
  Then field "verwschl" is modifiable
  Then field "edllsnr" is modifiable
  Then field "edllsdat" is modifiable
  Then field "edl" is modifiable
  # Nur im Verkauf
  Then field "ursplsnr" is modifiable
  And I create a new row at the end of the table
  And I set field "artikel" to "V1" in row 1
  And I set field "mge" to "1" in row 1
  # In Ein- und Verkauf
  Then field "lsnredl" is modifiable in row 1
  Then field "lsdatedl" is modifiable in row 1
  Then field "labnr" is modifiable in row 1
  # Nur im Verkauf
  Then field "ganr" is modifiable in row 1
  Then field "gaedinr" is modifiable in row 1
  Then field "fabnr" is modifiable in row 1
  Then setting field "fabdat" to "" in row 1 throws the exception "Eintrag ist schreibgeschützt"
  Then setting field "lztau" to "" in row 1 throws the exception "Eintrag ist schreibgeschützt"
  Then field "fabediid" is modifiable in row 1
  Then field "labediid" is modifiable in row 1
  Then field "fzdiff" is modifiable in row 1
  Then field "zefzdiff" is modifiable in row 1
  Then field "konstaend" is modifiable in row 1
  # Nur im Einkauf
  Then setting field "edinr" to "" in row 1 throws the exception "Ungültiger Feldname"
  And I close the current editor

  Given I open an editor "EK-Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
  And I set field "lief" to "1" in row 0
  # In Ein- und Verkauf
  Then field "lztabruf" is modifiable
  Then field "verwschl" is modifiable
  Then field "edllsnr" is modifiable
  Then field "edllsdat" is modifiable
  Then field "edl" is modifiable
  # Nur im Verkauf
  Then setting field "ursplsnr" to "" in row 0 throws the exception "Ungültiger Feldname"
  And I create a new row at the end of the table
  And I set field "artikel" to "E1" in row 1
  And I set field "mge" to "1" in row 1
  # In Ein- und Verkauf
  Then field "lsnredl" is modifiable in row 1
  Then field "lsdatedl" is modifiable in row 1
  Then field "labnr" is modifiable in row 1
  # Nur im Verkauf
  Then setting field "ganr" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "gaedinr" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "fabnr" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "fabdat" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "lztau" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "fabediid" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "labediid" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "fzdiff" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "zefzdiff" to "" in row 1 throws the exception "Ungültiger Feldname"
  Then setting field "konstaend" to "" in row 1 throws the exception "Ungültiger Feldname"
  # Nur im Einkauf
  Then field "edinr" is modifiable in row 1
  And I close the current editor
