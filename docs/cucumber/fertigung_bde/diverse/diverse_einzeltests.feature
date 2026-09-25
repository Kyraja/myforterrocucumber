@persistent
Feature: diverse_einzeltests.feature

#Background:
#Given I set the fake date to "17.01.1995"

# *****************************************************************************
#  Name             : diverse_einzeltests
#  Autor            : lschneider
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Diverse Einzeltests im Bereich Fertigung
#  Jira-Issue       : FDA-4066
#  ref              : ref_fe_diverse_einzeltests_cu
#
# *****************************************************************************

# FDA-4066
  Scenario: 01 Stand und Bearbeiter im Betriebsauftrag und Arbeitsschein aktualisieren bei Aenderungen an FV oder RES

    Given I set the fake date to "10.01.1995"

    Given I create a work order "WODATUM1" for Product "BG-BEDARF" with quantity "10" and search word "DATUM1"

    Given I set the fake date to "17.01.1995"

# Datum im FV aendern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-BEDARF"
    And I press button "ladetab"
    And I set field "tterm" to "+10" in row 1
    And I save the current editor

    Given I open an editor "BADATUM1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "DATUM1000"
    Then field "stand" contains value "17.01.1995"
    And I close the current editor

    Given I set the fake date to "27.01.1995"

# Datum und Freigabemenge in Reservierung aendern
    Given I open an editor "RMDATUM1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "DATUM1001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

    Given I open an editor "FVDATUM1" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK1-BEDARF;limge=7;@richtung=rueckwaerts;@maxtreffer=1"
    And I set field "bwtterm" to "+20"
    And I set fields
      | bwtterm | +20 |
    And I save the current editor

    And I switch the current editor to editor "BADATUM1" with command "VIEW"
    Then field "stand" contains value "27.01.1995"
    And I close the current editor

#FDA-5105
  Scenario: 02 Berechnung der Reduktionsgrenze, wenn in der AFL Packmittel stehen
  
  # Fertigungsvorschlag anlegen und freigeben
  Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
  And I append rows
    | artikel       | netmge    | bisuch    | mfreig    |
    | VK2-BEDARF    | 100       | REDGR_    | ja        |
  And I press button "freig" to open a subeditor for "BA_freigeben"
  And I close the current editor
  And I switch the current editor to editor "fvor"
  And I save the current editor
  
  
# Packmittel über die Materialentnahme entnehmen
  Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
  And I set field "auftrag" to "REDGR_002"
  And I set field "gmgevorschl" to "1"
  And I set field "bem" to "FBU-REDGR"
  And I press button "stllad"
  And I save the current editor
  
  
# Reduktionsgrenze und Gesamt-/Offene und Freigabemenge prüfen
  Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=REDGR_000;@richtung=rückwärts;@maxordtreffer=1"
  And I press button "absteig" to open a subeditor for "AFL36"
  Then field "netbgmge" has value "100"
  Then field "netblimge" has value "100"
  Then field "netbfrgmge" has value "100"
  Then field "minfrgmge" has value "0"
  And I close the current subeditor to switch back to the parent editor
  And I close the current editor


# FDA-5378
  Scenario: 03 Ueberentnahme von manuellem Material erhoeht die Reduktionsgrenze nicht ueber die Freigabemenge

  # Fertigungsvorschlag anlegen und freigeben
  Given I open an editor "FV03" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
  And I append rows
    | artikel       | netmge    | mfreig    |
    | VK2-BEDARF    | 100       | ja        |
  And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
  And I press button "setmanbu"
  And I save the current editor
  And I switch the current editor to editor "FV03"
  And I set field "bisuch" to "REDGRFRG_" in row 1
  And I press button "freig" to open a subeditor for "BA_freigeben"
  And I close the current editor
  And I switch the current editor to editor "FV03"
  And I save the current editor

# ueber Materialentnahme hoehere Menge entnehmen, als im FV
  Given I open an editor "FBU1" for tip command "Fbuchung" and arguments ""
  And I set field "auftrag" to "REDGRFRG_001"
  And I set field "bem" to "FBU-REDGRFRG"
  And I press button "stlvblad"
  Then field "bumge" has value "100" in row 1
  And I set field "bumge" to "105" in row 1
  And I save the current editor

# Reduktionsgrenze und Gesamt-/Offene und Freigabemenge prüfen
  Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=REDGRFRG_000;@richtung=rückwärts;@maxordtreffer=1"
  And I press button "absteig" to open a subeditor for "AFL03"
  Then field "netbgmge" has value "100"
  Then field "netblimge" has value "100"
  Then field "netbfrgmge" has value "100"
  Then field "minfrgmge" has value "100"
  And I close the current subeditor to switch back to the parent editor
  And I close the current editor

# Materialrueckgabe, nur die Menge, der Ueberentnahme
  Given I open an editor "FBU1" for tip command "Fbuchung" and arguments ""
  And I set field "auftrag" to "REDGRFRG_001"
  And I set field "gmgevorschl" to "-5"
  And I set field "bem" to "FBU-REDGRFRG"
  And I press button "stlvblad"
  And I save the current editor

# Reduktionsgrenze hat sich nicht veraendert
  Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=REDGRFRG_000;@richtung=rückwärts;@maxordtreffer=1"
  And I press button "absteig" to open a subeditor for "AFL03"
  Then field "netbgmge" has value "100"
  Then field "netblimge" has value "100"
  Then field "netbfrgmge" has value "100"
  Then field "minfrgmge" has value "100"
  And I close the current subeditor to switch back to the parent editor
  And I close the current editor

# weitere Materialrueckgabe, insgesamt mehr als die Ueberentnahme
  Given I open an editor "FBU1" for tip command "Fbuchung" and arguments ""
  And I set field "auftrag" to "REDGRFRG_001"
  And I set field "gmgevorschl" to "-10"
  And I set field "bem" to "FBU-REDGRFRG"
  And I press button "stlvblad"
  And I save the current editor

# Reduktionsgrenze hat sich um 10 reduziert
  Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=REDGRFRG_000;@richtung=rückwärts;@maxordtreffer=1"
  And I press button "absteig" to open a subeditor for "AFL03"
  Then field "netbgmge" has value "100"
  Then field "netblimge" has value "100"
  Then field "netbfrgmge" has value "100"
  Then field "minfrgmge" has value "90"
  And I close the current subeditor to switch back to the parent editor
  And I close the current editor


Scenario: 04 Rundungsfaktor wird bei Ermittlung Reduktionsgrenze beruecksichtigt

  Given I open an editor "EK1-BEDARF" from table "(Part):(Product)" with command "COPY" for record "EK1-BEDARF"
  And I set fields
    | such      | EK1-M |
    | le        | m     |
    | rundung   | 10    |
  And I save the current editor

  Given I open an editor "BG04" from table "(Part):(Product)" with command "STORE" for record "BG04"
  And I set fields
    | dispoa   | bedarfsbezogen             |
    | bsart    | Eigenfertigung             |
    | such     | BG04_RUND                  |
    | namebspr | Baugruppe Material Rundung |
  And I modify table
    | !row | elex         | elanzahl | manbu        |
    | +1   | EK1-M        | 1,37     | ja           |
    | +2   | EK1-BEDARF   | 1        | ja           |
    | +3   | A AG-LOHN1   | 1        | !dontChange  |
  And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
  Given I open an editor "FV04" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
  And I append rows
    | artikel   | netmge    | bisuch        | mfreig    |
    | BG04      | 100       | REDGRRUND_    | ja        |
  And I press button "freig" to open a subeditor for "BA_freigeben"
  And I close the current editor
  And I switch the current editor to editor "FV04"
  And I save the current editor

# ueber Materialentnahme hoehere Menge entnehmen, als im FV
  Given I open an editor "FBU1" for tip command "Fbuchung" and arguments ""
  And I set field "auftrag" to "REDGRRUND_001"
  And I set field "bem" to "FBU-REDGRRUND"
  And I press button "stlvblad"
  Then field "bumge" has value "140" in row 1
  And I set field "bumge" to "150" in row 1
  And I save the current editor

# Reduktionsgrenze und Gesamt-/Offene und Freigabemenge prüfen
  Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=REDGRRUND_000;@richtung=rückwärts;@maxordtreffer=1"
  And I press button "absteig" to open a subeditor for "AFL03"
  Then field "netbgmge" has value "100"
  Then field "netblimge" has value "100"
  Then field "netbfrgmge" has value "100"
  Then field "minfrgmge" has value "100"
  And I close the current subeditor to switch back to the parent editor
  And I close the current editor

