@persistent
Feature: storno_rueckgabe_materialentnahmen_plausichecks.feature

  Background:
    And I set the fake date to "03.02.1995"


# *****************************************************************************
#  Name             : storno_rueckgabe_materialentnahmen_plausichecks
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet den Storno von Materialrückgaben über die
#                     Materialentnahme
#  Jira-Issue       : FDA-1031
# *****************************************************************************

  Scenario: 01 In einer Storno Materialrückgabe sind alle Felder zu Mengen-, Artikel und Datumsangaben schreibgeschützt
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch   | mfreig |
      | M_BAUGRUPPE | 10     | PROTECT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und -rückgabe
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=PROTECT_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=PROTECT_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "-5"
    And I press button "stlvblad"
    And I save the current editor

# Schreibschutz auf Feldern in Storno-Materialentnahme prüfen
    Given I open an editor "Storno1_Rückgabe" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=PROTECT_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | sofort | ja |
      | manrm  | ja |
    Then field "sofort" is not modifiable
    Then field "artikel" is not modifiable in row 1
    Then field "mge" is not modifiable in row 1
    Then field "status" is empty in row 1
    Then field "gut" is not modifiable
    Then field "mgereduzieren" is not modifiable
    Then field "mzeit" is not modifiable
    Then field "bzeit" is not modifiable
    Then field "manrest" is not modifiable
    Then field "stornorest" is not modifiable
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROTECT_001"
    And I set fields
      | gut     | ja |
      | sofort  | ja |
      | manrest | ja |
    And I save the current editor


  Scenario: 02 Die Felder Bemerkungen im Kopf und Text zur Buchung in der Zeile sind in der Storno Materialrückgabe beschreibbar und werden vererbt
    Given I set the fake date to "06.02.1995"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch  | mfreig |
      | M_BAUGRUPPE | 10     | BEMERK_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und -rückgabe
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=BEMERK_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=BEMERK_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "-5"
    And I press button "stlvblad"
    And I set field "ljtext1" to "Erbtext EINKAUF-1" in row 1
    And I save the current editor

# Materialrückgabe stornieren, Schreibschutz auf Feldern prüfen
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BEMERK_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" is modifiable
    Then field "erbtext1" has value "Erbtext EINKAUF-1" in row 3
    And I set field "erbtext1" to "Storno Erbtext EINKAUF-2" in row 2
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "adatum" to "."
    And I set field "richtung" to "rückwärts"
    And I press start
    Then field "erbtext1" has value "Erbtext EINKAUF-1" in row 1
    Then field "erbtext1" has value "Storno Erbtext EINKAUF-2" in row 2
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEMERK_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 03 Eine Storno Materialrückgabe hat den Typ Storno-Rückbau auf Betriebsauftrag und kennt den Originalbeleg, die stornierte Materialrückgabe erhält den Typ Stornierter Rückbau auf Betriebsauftrag
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch | mfreig |
      | M_BAUGRUPPE | 10     | TYPEN_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und -rückgabe
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=TYPEN_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=TYPEN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "-5"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=TYPEN_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe stornieren, Typen in Belegen prüfen
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "typa279" has value "Storno-Rückbau auf Betriebsauftrag"
    Then field "manrm" has value "ja"
    Then field "stornopartnervorg^nummer" has value equal to field "barmex" from editor "Materialrückgabe1"
    And I save the current editor

    And I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then field "typa279" has value "Stornierter Rückbau auf Betriebsauftrag"
    Then field "manrm" has value "ja"
    Then field "stornopartnervorg^nummer" has value equal to field "barmex" from editor "Storno1_Rückgabe"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYPEN_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 04 In einer Storno Materialrückgabe haben die Mengen das gegenteilige Vorzeichen zum Originalbeleg
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BG-KOPPEL | 10     | VORZEICHEN_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und -rückgabe
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=VORZEICHEN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I set field "manbu" to "ja" in row 1
    And I set field "manbu" to "ja" in row 2
    And I save the current editor

    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=VORZEICHEN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I set field "gmgevorschl" to "-5"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=VORZEICHEN_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe stornieren, gegenteilige Vorzeichen prüfen
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then the table has 3 rows
    Then field "mge" has value "10" in row 2
    Then field "mge" has value "5" in row 3
    Then field "kompeig" has value "Koppelprodukt" in row 3
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "VORZEICHEN_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 05 Eine stornierte Materialrückgabe kann nicht noch einmal storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | STORNOZWEI_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und -rückgabe
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=STORNOZWEI_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=STORNOZWEI_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "-5"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOZWEI_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe stornieren
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Materialrückgabe erneut stornieren
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialrückgabe1" throws the exception "1582"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZWEI_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 06 Eine Storno Materialrückgabe kann nicht storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch      | mfreig |
      | M_BAUGRUPPE | 10     | NOCHSTORNO_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=NOCHSTORNO_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=NOCHSTORNO_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "-5"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=NOCHSTORNO_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe stornieren
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno-Materialrückgabe erneut stornieren
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Storno1_Rückgabe" throws the exception "1582"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NOCHSTORNO_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "ja"
    And I save the current editor

