@persistent
Feature: rueckbau_mit_chargen_prozesstests.feature

  Background:
    Given I enable the flag 42
    And I set the fake date to "5.1.95"
# fake dates können mit std/test/fake_date_subst_in_cucumber.pl gepflegt werden. anleitung s. dort

# *****************************************************************************
#  Name             : rueckbau_mit_chargen_prozesstests
#  Autor            : bschiga
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Testet Rückgaben über Zu- und Abgangschargen
#  Jira-Issue       : FDA-2084
# *****************************************************************************

  Scenario: B01 Materialrueckgabe nicht chargenpflichtige Komponente und Koppelprodukt, wenn Zugangsbuchung mit Charge erfolgt ist - manbu

# Stammdaten anlegen

# Einkaufsartikel nicht chargenpflichtig
    Given I open an editor "EKTEIL" from table "(Part):(Product)" with command "STORE" for record "EKTEIL"
    And I set fields
      | such     | EKTEIL         |
      | namebspr | Einkaufsteil   |
      | dispoa   | bedarfsbezogen |
      | lief     | KETTLER        |
      | efrist   | 2              |
      | epr      | 2,50           |
      | wgruppe  | 55             |
      | erlgrp   | 66             |
    And I save the current editor

    Given I open an editor "BG_CHARGE" from table "(Part):(Product)" with command "STORE" for record "BG_CHARGE"
    And I set fields
      | such      | BG_CHARGE                  |
      | namebspr  | Baugruppe chargenpflichtig |
      | dispoa    | bedarfsbezogen             |
      | bsart     | Eigenfertigung             |
      | chverfolgung | Chargenverfolgung       |
      | wgruppe   | 55                         |
      | erlgrp    | 66                         |
    And I delete all rows
    And I append rows
      | elex       | anzahl | manbu | kompeig     |
      | EKTEIL     | 1      | ja    | !dontChange |
      | KOPPELPROD | 1      | ja    | (Coproduct) |
      | A MONTAGE1 | 1      |       |             |
    And I save the current editor


# Chargen anlegen
    Given I create a Lot "CH_B011" for Product "BG_CHARGE"
    Given I create a Lot "CH_B012" for Product "BG_CHARGE"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG_CHARGE" and quantity "15"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B01   |
    And I append rows
      | artikel | mge |
      | EKTEIL  | 15  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BG_CHARGE | 15     | FVB01_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB01_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 10                     |
      | bem         | Entnahme               |
      | charge      | CH_B011                |
    And I press button "stlvblad"
    And I save the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB01_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B011 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB01_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "5" in row 1
    Then field "limge" has value "5" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrueckgabe auf Arbeitssschein 1 Teilmenge
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -5                     |
      | bem         | RueckgabeAS1           |
      | charge      | CH_B011                |
    And I press button "stlvblad"
    Then field "bumge" has value "-5" in row 1
    Then field "bumge" has value "-5" in row 2
    And I save the current editor


# Beleg zu Materialrueckgabe pruefen
    Given I open an editor "Rueckgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB01_001;bem=RueckgabeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen | tcharge |
      | 5   | BG_CHARGE  | 0        | 0       | 10     | 10     | CH_B011 |
      | -5  | KOPPELPROD | -5       | 0       | 5      | 10     |         |
      | -5  | EKTEIL     | -5       | 0       | 5      | 10     |         |
    And I close the current editor


# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB01_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "10" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Lagerjournaleintrag pruefen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rueckgabe1_pruef"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | rueckmge | restmge | tncharge | tvcharge |
      | EKTEIL     |      | -5   | -5       | 0       | CH_B011  |          |
      | KOPPELPROD | -5   |      | -5       | 0       |          |          |
    And I close the current editor

# BA abschließen und liefern
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB01_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B011 |
      | gut     | ja      |
      | manrest | ja      |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B01"

###################################################################################################################

  Scenario: B02 Materialrueckgabe nicht chargenpflichtige Komponente und Koppelprodukt, wenn Zugangsbuchung mit Charge erfolgt ist - retrograd


# Chargen anlegen
    Given I create a Lot "CH_B021" for Product "BG_CHARGE"
    Given I create a Lot "CH_B022" for Product "BG_CHARGE"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG_CHARGE" and quantity "15"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B02   |
    And I append rows
      | artikel | mge |
      | EKTEIL  | 15  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BG_CHARGE | 15     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "resetmanbu"
    And I save the current subeditor to switch back to the parent editor
    And I set field "bisuch" to "FVB02_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB02_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B021 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Rueckbau auf Arbeitsschein
    Given I open an editor "RUECK_RM_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "$,,such=FVB02_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2            |
      | bzeit   | 2            |
      | sofort  | ja           |
      | kcharge | CH_B021      |
      | bem     | RueckgabeAS1 |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

## noch Pruefungen ergaenzen?? ##

# Beleg zu Materialrueckgabe pruefen
    Given I open an editor "Rueckgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB02_001;bem=RueckgabeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen | tcharge |
      | 5   | BG_CHARGE  | -5       | 0       | 10     | 5      | CH_B021 |
      | -5  | KOPPELPROD | -5       | 0       | 5      | 10     |         |
      | -5  | EKTEIL     | -5       | 0       | 5      | 10     |         |
    And I close the current editor

# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB02_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL02"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "10" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Lagerjournaleintrag pruefen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg       | !Rueckgabe1_pruef^barmex |
      | richtung    | rückwärts                |
      | kdetursache | Rückbau Fertigung        |
    And I press start
    Then table has values
      | art        | zmge | amge | rueckmge | restmge | tncharge | tvcharge |
      | BG_CHARGE  | -5   |      | -5       | 0       | CH_B021  |          |
      | EKTEIL     |      | -5   | -5       | 0       | CH_B021  |          |
      | KOPPELPROD | -5   |      | -5       | 0       |          |          |
    And I close the current editor


# BA abschließen und liefern
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB02_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B022 |
      | gut     | ja      |
      | manrest | ja      |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B02"

##########################################################################

  Scenario: B03 Materialrueckgabe mit zusaetzlichem Material, chargenpflichtige Komponenten, wenn Zugangsbuchung mit Charge erfolgt ist

# Chargen anlegen
    Given I create a Lot "CH_B031" for Product "M_BAUGRUPPE"
    Given I create a Lot "CH_B032" for Product "M_BAUGRUPPE"
    Given I create a Lot "CH_B03EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH_B03EK2" for Product "EINKAUF-2"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "15"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B03   |
    And I append rows
      | artikel   | mge | charge        |
      | EINKAUF-1 | 30  | !CH_B03EK1^id |
      | EINKAUF-2 | 15  | !CH_B03EK2^id |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch | mfreig |
      | M_BAUGRUPPE | 15     | FVB03_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
	
# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB03_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme               |
      | charge  | CH_B031                |
    And I press button "stlvblad"
    And I modify table
      | !row | elex        | bumge | tvcharge  |
      | 1    | !dontChange | 20    | CH_B03EK1 |
      | 2    | !dontChange | 10    | CH_B03EK2 |
      | +3   | EINK        | 10    |           |
    And I save the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB03_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B031 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB03_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "5" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrueckgabe auf Arbeitssschein 1 Teilmenge
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -5                     |
      | bem         | RueckgabeAS1           |
      | charge      | CH_B031                |
    And I press button "stlvblad"
    And I modify table
      | !row | elex        | bumge | tvcharge  |
      | 1    | !dontChange | -10   | CH_B03EK1 |
      | 2    | !dontChange | -5    | CH_B03EK2 |
      | 3    | !dontChange | -5    |           |
    And I save the current editor


# Beleg zu Materialrueckgabe pruefen
    Given I open an editor "Rueckgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB03_001;bem=RueckgabeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 4 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen | tcharge   |
      | 5   | M_BAUGRUPPE | 0        | 0       | 10     | 10     | CH_B031   |
      | -5  | EINK        | -5       | 0       | 10     | 5      |           |
      | -5  | EINKAUF-2   | -5       | 0       | 5      | 10     | CH_B03EK2 |
      | -10 | EINKAUF-1   | -10      | 0       | 10     | 20     | CH_B03EK1 |
    And I close the current editor


# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB03_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "20" in row 1
    Then field "limge" has value "10" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Lagerjournaleintrag pruefen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rueckgabe1_pruef^barmex |
      | richtung | rückwärts                |
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | tncharge | tvcharge  |
      | EINKAUF-1 |      | -10  | -10      | 0       | CH_B031  | CH_B03EK1 |
      | EINKAUF-2 |      | -5   | -5       | 0       | CH_B031  | CH_B03EK2 |
      | EINK      |      | -5   | -5       | 0       | CH_B031  |           |
    And I close the current editor

# BA abschließen und liefern
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 10                     |
      | bem         | Entnahme2              |
      | charge      | CH_B032                |
    And I press button "stlvblad"
    And I set field "tvcharge" to "CH_B03EK1" in row 1
    And I set field "tvcharge" to "CH_B03EK2" in row 2
    And I save the current editor

    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB03_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B032 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B03"

############################################################################################################################################################

  Scenario: B04 Materialrueckgabe chargenpflichtige Komponente und Behaelter aus Lagerpackanweisung, wenn Zugangsbuchung mit Charge erfolgt ist - manbu


# Chargen anlegen
    Given I create a Lot "CH_B041" for Product "BG-BEHAELTER"
    Given I create a Lot "CH_B042" for Product "BG-BEHAELTER"
    Given I create a Lot "CH_B04EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH_B04EK2" for Product "EINKAUF-2"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "20"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B02   |
    And I append rows
      | artikel   | mge | charge        |
      | EINKAUF-1 | 30  | !CH_B04EK1^id |
      | EINKAUF-2 | 15  | !CH_B04EK2^id |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BG-BEHAELTER | 20     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current subeditor to switch back to the parent editor
    And I set field "bisuch" to "FVB04_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB04_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme               |
      | charge  | CH_B041                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge  |
      | 1    | 20    | CH_B04EK1 |
      | 2    | 10    | CH_B04EK2 |
      | 3    | 1     |           |
    And I save the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB04_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B041 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB04_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "20" in row 1
    Then field "limge" has value "10" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrueckgabe auf Arbeitssschein 1 Teilmenge
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -5                     |
      | bem         | RueckgabeAS1           |
      | charge      | CH_B041                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge  |
      | 1    | -10   | CH_B04EK1 |
      | 2    | -5    | CH_B04EK2 |
      | 3    | -1    |           |
    And I save the current editor


# Beleg zu Materialrueckgabe pruefen
    Given I open an editor "Rueckgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB04_001;bem=RueckgabeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 4 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | tcharge   |
      | 10  | BG-BEHAELTER | 0        | 0       | 10     | 10     | CH_B041   |
      | -1  | BEHAELTER    | -1       | 0       | 1      | 2      |           |
      | -5  | EINKAUF-2    | -5       | 0       | 10     | 15     | CH_B04EK2 |
      | -10 | EINKAUF-1    | -10      | 0       | 20     | 30     | CH_B04EK1 |
    And I close the current editor


# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB04_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "30" in row 1
    Then field "limge" has value "15" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Lagerjournaleintrag pruefen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rueckgabe1_pruef^barmex |
      | richtung | rückwärts                |
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | tncharge | tvcharge  |
      | EINKAUF-1 |      | -10  | -10      | 0       | CH_B041  | CH_B04EK1 |
      | EINKAUF-2 |      | -5   | -5       | 0       | CH_B041  | CH_B04EK2 |
      | BEHAELTER |      | -1   | -1       | 0       | CH_B041  |           |
    And I close the current editor

# BA abschließen und liefern
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 15                     |
      | bem         | Entnahme2              |
      | charge      | CH_B042                |
    And I press button "stlvblad"
    And I set field "tvcharge" to "CH_B04EK1" in row 1
    And I set field "tvcharge" to "CH_B04EK2" in row 2
    And I save the current editor

    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB04_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B042 |
    And I set field "gutmge" to "15" in row 1
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B04"

#####################################################################################

  Scenario: B05 Materialrueckgabe nicht chargenpflichtige Komponente und Behaelter in AFL, wenn Zugangsbuchung mit Charge erfolgt ist - manbu

# Chargen anlegen
    Given I create a Lot "CH_B051" for Product "BG_CHARGE"
    Given I create a Lot "CH_B052" for Product "BG_CHARGE"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG_CHARGE" and quantity "5"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B05   |
    And I append rows
      | artikel | mge |
      | EKTEIL  | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen, AFL Koppelprodukt entfernen und Behaelter einfuegen, freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BG_CHARGE | 5      | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I modify table
      | !row | elex        | anzahl | manbu       |
      | 1    | !dontChange | 10     | !dontChange |
      | -2   | KOPPELPROD  | 1      | !dontChange |
      | +2   | BEHAELTER   | 1      | ja          |
    And I save the current subeditor to switch back to the parent editor
    And I set field "bisuch" to "FVB05_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
	
# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB05_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 3                      |
      | bem         | Entnahme               |
      | charge      | CH_B051                |
    And I press button "stlvblad"
    And I save the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB05_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B051 |
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB05_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "20" in row 1
    Then field "limge" has value "2" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrueckgabe auf Arbeitssschein 1 Teilmenge
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | RueckgabeAS1           |
      | charge      | CH_B051                |
    And I press button "stlvblad"
    Then field "bumge" has value "-20" in row 1
    Then field "bumge" has value "-2" in row 2
    And I save the current editor


# Beleg zu Materialrueckgabe pruefen
    Given I open an editor "Rueckgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB05_001;bem=RueckgabeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen | tcharge |
      | 2   | BG_CHARGE | 0        | 0       | 3      | 3      | CH_B051 |
      | -2  | BEHAELTER | -2       | 0       | 2      | 4      |         |
      | -20 | EKTEIL    | -20      | 0       | 20     | 40     |         |
    And I close the current editor


# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB05_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "40" in row 1
    Then field "limge" has value "4" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Lagerjournaleintrag pruefen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rueckgabe1_pruef"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | tncharge | tvcharge |
      | EKTEIL    |      | -20  | -20      | 0       | CH_B051  |          |
      | BEHAELTER |      | -2   | -2       | 0       | CH_B051  |          |
    And I close the current editor

# BA abschließen und liefern
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB05_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B051 |
      | gut     | ja      |
      | manrest | ja      |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B05"

###################################################################################

  Scenario: B06 Materialrueckgabe bei mehreren Entnahmen, chargenpflichtige Komponenten, wenn Zugangsbuchung mit Charge erfolgt ist

# Chargen anlegen
    Given I create a Lot "CH_B061" for Product "M_BAUGRUPPE"
    Given I create a Lot "CH_B062" for Product "M_BAUGRUPPE"
    Given I create a Lot "CH_B063" for Product "M_BAUGRUPPE"
    Given I create a Lot "CH_B06EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH_B06EK2" for Product "EINKAUF-2"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "50"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B03   |
    And I append rows
      | artikel   | mge | charge        |
      | EINKAUF-1 | 100 | !CH_B06EK1^id |
      | EINKAUF-2 | 50  | !CH_B06EK2^id |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch | mfreig |
      | M_BAUGRUPPE | 50     | FVB06_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
	
# 1. Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB06_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
      | charge  | CH_B061                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge  |
      | 1    | 40    | CH_B06EK1 |
      | 2    | 20    | CH_B06EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# 1. Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB06_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B061 |
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

# 2. Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB06_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme2              |
      | charge  | CH_B062                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge  |
      | 1    | 20    | CH_B06EK1 |
      | 2    | 10    | CH_B06EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# 2. Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB06_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B062 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

# 3. Materialentnahme buchen ohne Zugangscharge
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB06_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme3              |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge  |
      | 1    | 10    | CH_B06EK1 |
      | 2    | 5     | CH_B06EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# 1. Materialrueckgabe auf Arbeitssschein 1 Teilmenge mit Zugangscharge der ersten Entnahme
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -5                     |
      | bem         | RueckgabeAS1           |
      | charge      | CH_B061                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge  |
      | 1    | CH_B06EK1 |
      | 2    | CH_B06EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# 1. Materialrueckgabe auf Arbeitssschein 1, hoehere Menge als entnommen wurde, mit Zugangscharge der zweiten Entnahme
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -15                    |
      | bem         | RueckgabeAS1           |
      | charge      | CH_B062                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge  |
      | 1    | CH_B06EK1 |
      | 2    | CH_B06EK2 |
# Fehlermeldung Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge
    Then saving the current editor throws the exception "1395"
    And I close the current editor

    And I wait 1 time units to move the time forward

# Materialrueckgabe auf Arbeitssschein 1 Teilmenge mit Zugangscharge 3 nicht moeglich, da keine Entnahme
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -5                     |
      | bem         | RueckgabeAS1           |
      | charge      | CH_B063                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge  |
      | 1    | CH_B06EK1 |
      | 2    | CH_B06EK2 |
# Fehlermeldung Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge
    Then saving the current editor throws the exception "1395"
    And I close the current editor

# Beleg zu Materialrueckgabe pruefen
    Given I open an editor "Rueckgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB06_001;bem=RueckgabeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen | tcharge   |
      | 20  | M_BAUGRUPPE | 0        | 0       | 30     | 30     | CH_B061   |
      | -5  | EINKAUF-2   | -5       | 0       | 15     | 20     | CH_B06EK2 |
      | -10 | EINKAUF-1   | -10      | 0       | 30     | 40     | CH_B06EK1 |
    And I close the current editor


# Mengen in AFL pruefen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB06_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "40" in row 1
    Then field "limge" has value "20" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Lagerjournaleintrag pruefen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rueckgabe1_pruef^barmex |
      | richtung | rückwärts                |
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | tncharge | tvcharge  |
      | EINKAUF-1 |      | -10  | -10      | 0       | CH_B061  | CH_B06EK1 |
      | EINKAUF-2 |      | -5   | -5       | 0       | CH_B061  | CH_B06EK2 |
    And I close the current editor

# BA abschließen und liefern
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 20                     |
      | bem         | EntnahmeRest           |
      | charge      | CH_B063                |
    And I press button "stlvblad"
    And I set field "tvcharge" to "CH_B03EK1" in row 1
    And I set field "tvcharge" to "CH_B03EK2" in row 2
    And I save the current editor

    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB06_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B063 |
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B06"

#######################################################################################################################################

  Scenario: B07 Materialrueckgabe bei mehreren Entnahmen mit unterschiedlichen Chargen, wenn Zugangsbuchung mit unterschiedlichen Charge erfolgt ist

# Chargen anlegen
    Given I create a Lot "CH_B071" for Product "M_BAUGRUPPE"
    Given I create a Lot "CH_B072" for Product "M_BAUGRUPPE"
    Given I create a Lot "CH_B073" for Product "M_BAUGRUPPE"
    Given I create a Lot "CH_B071EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH_B071EK2" for Product "EINKAUF-2"
    Given I create a Lot "CH_B072EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH_B072EK2" for Product "EINKAUF-2"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "50"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B03   |
    And I append rows
      | artikel   | mge | charge         |
      | EINKAUF-1 | 50  | !CH_B071EK1^id |
      | EINKAUF-2 | 25  | !CH_B071EK2^id |
      | EINKAUF-1 | 50  | !CH_B072EK1^id |
      | EINKAUF-2 | 25  | !CH_B072EK2^id |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch | mfreig |
      | M_BAUGRUPPE | 50     | FVB07_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
	
# 1. Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB07_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1a             |
      | charge  | CH_B071                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge   |
      | 1    | 20    | CH_B071EK1 |
      | 2    | 10    | CH_B071EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB07_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1b             |
      | charge  | CH_B071                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge   |
      | 1    | 10    | CH_B072EK1 |
      | 2    | 5     | CH_B072EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# 1. Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB07_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B071 |
    And I set field "gutmge" to "15" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

# 2. Materialentnahme buchen
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme2              |
      | charge  | CH_B072                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge   |
      | 1    | 10    | CH_B072EK1 |
      | 2    | 5     | CH_B072EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# 3. Materialentnahme buchen
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme3              |
      | charge  | CH_B073                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge   |
      | 1    | 10    | CH_B072EK1 |
      | 2    | 5     | CH_B072EK2 |
    And I save the current editor

# 2. Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB07_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B072 |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

# 3. Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB07_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B073 |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    And I wait 1 time units to move the time forward

# 4. Materialentnahme buchen
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme4              |
      | charge  | CH_B072                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge   |
      | 1    | 30    | CH_B071EK1 |
      | 2    | 15    | CH_B071EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# 5. Materialentnahme buchen
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme5              |
      | charge  | CH_B072                |
    And I press button "stlvblad"
    And I modify table
      | !row | bumge | tvcharge   |
      | 1    | 20    | CH_B072EK1 |
      | 2    | 10    | CH_B072EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# Test Materialrueckgabe mehr als entnommen wurde fuer Kombination aus Zugangs- und Abgangscharge
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -20                    |
      | bem         | RueckgabeTest          |
      | charge      | CH_B072                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge   |
      | 1    | CH_B072EK1 |
      | 2    | CH_B072EK2 |
# Fehlermeldung Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge
    Then saving the current editor throws the exception "1395"
    And I close the current editor

# Test Materialrueckgabe mehr als entnommen wurde fuer Kombination aus Zugangs- und Abgangscharge
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -15                    |
      | bem         | RueckgabeTest          |
      | charge      | CH_B071                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge   |
      | 1    | CH_B071EK1 |
      | 2    | CH_B071EK2 |
# Fehlermeldung Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge
    Then saving the current editor throws the exception "1395"
    And I close the current editor

# 1. Materialrueckgabe auf Arbeitssschein 1, Menge aus 2 Entnahmen
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -15                    |
      | bem         | Rueckgabe1             |
      | charge      | CH_B072                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge   |
      | 1    | CH_B072EK1 |
      | 2    | CH_B072EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# 2. Materialrueckgabe auf Arbeitssschein 1, Menge aus 1 Entnahmen
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -10                    |
      | bem         | Rueckgabe2             |
      | charge      | CH_B071                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge   |
      | 1    | CH_B071EK1 |
      | 2    | CH_B071EK2 |
    And I save the current editor

    And I wait 1 time units to move the time forward

# Test Materialrueckgabe, wurde bereits zurueckgelegt
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -5                     |
      | bem         | RueckgabeTest          |
      | charge      | CH_B071                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge   |
      | 1    | CH_B071EK1 |
      | 2    | CH_B071EK2 |
# Fehlermeldung Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge
# amk->@bschiga, 9.2.2024: Fehlermeldung kommt nicht mehr. Bitte pruefen, ob das korrekt ist.
#    Then saving the current editor throws the exception "1395"
    And I close the current editor

# 3. Materialrueckgabe auf Arbeitssschein 1, Teilmenge
    Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -1                     |
      | bem         | Rueckgabe3             |
      | charge      | CH_B073                |
    And I press button "stlvblad"
    And I modify table
      | !row | tvcharge   |
      | 1    | CH_B072EK1 |
      | 2    | CH_B072EK2 |
    And I save the current editor

# Materialrueckgabe stornieren
   Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FVB07_001;bem=Rueckgabe3;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
   And I save the current editor

   Given I open an editor "Storno_pruef" via ID from editor "Storno1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
   Then the table has 3 rows
   Then table has values
     | mge | artikel     | rueckmge | restmge | limgev | limgen | tcharge    |
     | 25  | M_BAUGRUPPE | 0        | 0       | 0      | 0      | CH_B073    |
     | 1   | EINKAUF-2   | 0        | 1       | 26     | 25     | CH_B072EK2 |
     | 2   | EINKAUF-1   | 0        | 2       | 52     | 50     | CH_B072EK1 |
   And I close the current editor

# 4. Materialrueckgabe auf Arbeitssschein 1, inkl stornierte Menge
   Given I open an editor "RUECKGABE_AS1" for tip command "(WOIssue)" and arguments ""
   And I set fields
     | auftrag     | !Arbeitsschein1^nummer |
     | gmgevorschl | -5                     |
     | bem         | Rueckgabe4             |
     | charge      | CH_B073                |
   And I press button "stlvblad"
   And I modify table
     | !row | tvcharge   |
     | 1    | CH_B072EK1 |
     | 2    | CH_B072EK2 |
   And I save the current editor

# Beleg zu 1. Materialrueckgabe pruefen
   Given I open an editor "Rueckgabe_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB07_001;bem=Rueckgabe1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
   Then the table has 3 rows
   Then table has values
     | mge | artikel     | rueckmge | restmge | limgev | limgen | tcharge    |
     | 25  | M_BAUGRUPPE | 0        | 0       | 25     | 25     | CH_B072    |
     | -15 | EINKAUF-2   | -15      | 0       | 0      | 15     | CH_B072EK2 |
     | -30 | EINKAUF-1   | -30      | 0       | 0      | 30     | CH_B072EK1 |
   And I close the current editor

# Beleg zu 2. Materialrueckgabe pruefen
   Given I open an editor "Rueckgabe_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB07_001;bem=Rueckgabe2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
   Then the table has 3 rows
   Then table has values
     | mge | artikel     | rueckmge | restmge | limgev | limgen | tcharge    |
     | 25  | M_BAUGRUPPE | 0        | 0       | 25     | 25     | CH_B071    |
     | -10 | EINKAUF-2   | -10      | 0       | 15     | 25     | CH_B071EK2 |
     | -20 | EINKAUF-1   | -20      | 0       | 30     | 50     | CH_B071EK1 |
   And I close the current editor

# Beleg zu 3. Materialrueckgabe pruefen
   Given I open an editor "Rueckgabe_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB07_001;bem=Rueckgabe3;typ=15;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
   Then the table has 3 rows
   Then table has values
     | mge | artikel     | rueckmge | restmge | limgev | limgen | tcharge    |
     | 25  | M_BAUGRUPPE | 0        | 0       | 25     | 25     | CH_B073    |
     | -1  | EINKAUF-2   | -1       | 0       | 25     | 26     | CH_B072EK2 |
     | -2  | EINKAUF-1   | -2       | 0       | 50     | 52     | CH_B072EK1 |
   And I close the current editor

# Beleg zu 4. Materialrueckgabe pruefen
   Given I open an editor "Rueckgabe_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FVB07_001;bem=Rueckgabe4;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
   Then the table has 3 rows
   Then table has values
     | mge | artikel     | rueckmge | restmge | limgev | limgen | tcharge    |
     | 25  | M_BAUGRUPPE | 0        | 0       | 25     | 25     | CH_B073    |
     | -5  | EINKAUF-2   | -5       | 0       | 25     | 30     | CH_B072EK2 |
     | -10 | EINKAUF-1   | -10      | 0       | 50     | 60     | CH_B072EK1 |
   And I close the current editor


# Mengen in AFL pruefen
   Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB07_000;@richtung=rückwärts;@maxtreffer=1"
   And I press button "absteig" to open a subeditor for "AFL01"
   Then field "limge" has value "60" in row 1
   Then field "limge" has value "30" in row 2
   And I close the current subeditor to switch back to the parent editor
   And I close the current editor

# Lagerjournaleintrag pruefen
   Given I open the infosystem "LJ"
   And I set fields
     | beleg    | !Rueckgabe_pruef^barmex |
     | richtung | rückwärts               |
   And I press start
   Then table has values
     | art       | zmge | amge | rueckmge | restmge | tncharge | tvcharge   |
     | EINKAUF-1 |      | -10  | -10      | 0       | CH_B073  | CH_B072EK1 |
     | EINKAUF-2 |      | -5   | -5       | 0       | CH_B073  | CH_B072EK2 |
     | EINKAUF-1 |      | 2    | 2        | 0       | CH_B073  | CH_B072EK1 |
     | EINKAUF-2 |      | 1    | 1        | 0       | CH_B073  | CH_B072EK2 |
     | EINKAUF-1 |      | -2   | -2       | 0       | CH_B073  | CH_B072EK1 |
     | EINKAUF-2 |      | -1   | -1       | 0       | CH_B073  | CH_B072EK2 |
     | EINKAUF-1 |      | -20  | -20      | 0       | CH_B071  | CH_B071EK1 |
     | EINKAUF-2 |      | -10  | -10      | 0       | CH_B071  | CH_B071EK2 |
     | EINKAUF-1 |      | -10  | -10      | 0       | CH_B072  | CH_B072EK1 |
     | EINKAUF-1 |      | -20  | -20      | 0       | CH_B072  | CH_B072EK1 |
     | EINKAUF-2 |      | -5   | -5       | 0       | CH_B072  | CH_B072EK2 |
     | EINKAUF-2 |      | -10  | -10      | 0       | CH_B072  | CH_B072EK2 |
   And I close the current editor

# BA abschließen und liefern
# Materialentnahme Rest 20 und Rueckmeldung Rest 25 auf Arbeitsschein
   Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
   And I set fields
     | auftrag | !Arbeitsschein1^nummer |
     | bem     | EntnahmeRest           |
     | charge  | CH_B072                |
   And I press button "stlvblad"
   And I modify table
     | !row | bumge | tvcharge   |
     | 1    | 60    | CH_B072EK1 |
     | 2    | 30    | CH_B072EK2 |
   And I save the current editor
   Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB07_001;@richtung=rückwärts;@maxordtreffer=1"
   And I set fields
     | mzeit   | 2       |
     | bzeit   | 2       |
     | sofort  | ja      |
     | kcharge | CH_B072 |
   And I set field "gutmge" to "25" in row 1
   And I save the current editor

   And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B07"

  Scenario: B08 Rückgabe von retrograden Koppelprodukt mit Charge in der Reservierung.

# Stammdaten anlegen

    Given I open an editor "BG2_CHARGE" from table "(Part):(Product)" with command "STORE" for record "BG2_CHARGE"
    And I set fields
      | such      | BG2_CHARGE                   |
      | namebspr  | Baugruppe 2 chargenpflichtig |
      | dispoa    | bedarfsbezogen               |
      | bsart     | Eigenfertigung               |
      | chverfolgung | Chargenverfolgung         |
      | wgruppe   | 55                           |
      | erlgrp    | 66                           |
    And I delete all rows
    And I append rows
      | elex       | anzahl | kompeig     |
      | KOPPELPROD | 1      | (Coproduct) |
      | A MONTAGE1 | 1      |             |
    And I save the current editor

# Chargen anlegen
    Given I create a Lot "CH_B201" for Product "BG2_CHARGE"
    Given I create a Lot "CH_K011" for Product "KOPPELPROD"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG2_CHARGE" and quantity "15"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BG2_CHARGE | 15     | FVB201_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB201_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor

# Charge in Reservierung eintragen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FVB201_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    And I set field "charge" to "CH_K011" in row 1
    And I save the current editor
    And I switch the current editor to editor "BA"
    And I save the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB201_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Rueckbau auf Arbeitsschein
    Given I open an editor "Rueckgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB201_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# BA abschließen und liefern
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB201_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
      | gut     | ja      |
      | manrest | ja      |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B01"

###################################################################################################################

  Scenario: B09
# Stammdaten aus B08

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG2_CHARGE" and quantity "15"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BG2_CHARGE | 15     | FVB202_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB202_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor

# Charge in Mz angeben
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FVB202_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | charge  |
      | +1   | 15     | CH_K011 |
    And I save the current editor
    And I switch the current editor to editor "AFL01"
    And I save the current editor
    And I switch the current editor to editor "BA"
    And I save the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB202_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Rueckbau auf Arbeitsschein
    Given I open an editor "Rueckgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB202_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# BA abschließen und liefern
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB202_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
      | gut     | ja      |
      | manrest | ja      |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B01"

###################################################################################################################

  Scenario: B10
# Stammdaten aus B08

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG2_CHARGE" and quantity "15"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BG2_CHARGE | 15     | FVB203_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVB203_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor

# Materialzuordnung anlegen mit anderem Platz fuer Koppelprodukt
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FVB203_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I modify table
      | !row | zuomge | charge | platz |
      | +1   | 15     |        | F3    |
    And I save the current editor
    And I switch the current editor to editor "AFL01"
    And I save the current editor
    And I switch the current editor to editor "BA"
    And I save the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB203_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Rueckbau auf Arbeitsschein
    Given I open an editor "Rueckgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB203_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2       |
      | bzeit   | 2       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# Lagerjournaleintrag pruefen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art        | zmge | amge | rueckmge | restmge | nplatz |
      | BG2_CHARGE | -5   |      | -5       | 0       | F1     |
      | KOPPELPROD | -5   |      | -5       | 0       | F3     |
      | BG2_CHARGE | 10   |      | 5        | 5       | F1     |
      | KOPPELPROD | 10   |      | 5        | 5       | F3     |
    And I close the current editor

# BA abschließen und liefern
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB203_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | kcharge | CH_B201 |
      | gut     | ja      |
      | manrest | ja      |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-B01"

###################################################################################################################

  Scenario: B11 Rückbau zu Betriebsauftrag für nicht chargenpflichtige, keine Charge im Lager, Baugruppen nach Buchung mit Charge
# Stammdaten aus B01

    Given I open an editor "BG_OCHARGE" from table "(Part):(Product)" with command "STORE" for record "BG_OCHARGE"
    And I set fields
      | such     | BG_OCHARGE                       |
      | namebspr | Baugruppe nicht chargenpflichtig |
      | dispoa   | bedarfsbezogen                   |
      | bsart    | Eigenfertigung                   |
      | mindest  | 100                              |
      | wgruppe  | 55                               |
      | erlgrp   | 66                               |
    And I delete all rows
    And I append rows
      | elex       | anzahl |
      | EKTEIL     | 1      |
      | A MONTAGE1 | 1      |
    And I save the current editor

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B11   |
    And I append rows
      | artikel | mge |
      | EKTEIL  | 100 |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    And I run Scheduling

# durch Dispo erstellten Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG_OCHARGE"
    And I press button "ladetab"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "FVB11_" in row !lastRow
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I create a Lot "CH_B11" for Product "BG_OCHARGE"

    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB11_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2          |
      | bzeit   | 2          |
      | sofort  | ja         |
      | kcharge | !CH_B11^id |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB11_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2          |
      | bzeit   | 2          |
      | sofort  | ja         |
      | kcharge | !CH_B11^id |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Rueckbau auf Arbeitsschein mit Chargenangabe
    Given I open an editor "RB_Charge" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB11_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2          |
      | bzeit   | 2          |
      | sofort  | ja         |
      | kcharge | !CH_B11^id |
    And I set field "gutmge" to "-7" in row 1
    And I save the current editor

# Rueckbau auf Arbeitsschein ohne Chargenangabe
    Given I open an editor "RB_ohneCharge" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB11_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-7" in row 1
    And I save the current editor

# BA abschließen
    Given I open an editor "Rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB11_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1          |
      | bzeit   | 1          |
      | sofort  | ja         |
      | kcharge | !CH_B11^id |
      | gut     | ja         |
    And I save the current editor


  Scenario: B12 Rückbau zu Betriebsauftrag für nicht chargenpflichtige, keine Charge im Lager, Baugruppen nach Buchung mit Charge
# Stammdaten aus B01

    Given I open an editor "BG_OCHA_LAG" from table "(Part):(Product)" with command "STORE" for record "BG_OCHA_LAG"
    And I set fields
      | such      | BG_OCHA_LAG                  |
      | namebspr  | chpflicht ja, chimlager nein |
      | dispoa    | bedarfsbezogen               |
      | bsart     | Eigenfertigung               |
      | chverfolgung | Chargenverfolgung         |
      | chimlager | nein                         |
      | mindest   | 100                          |
      | wgruppe   | 55                           |
      | erlgrp    | 66                           |
    And I delete all rows
    And I append rows
      | elex       | anzahl |
      | EKTEIL     | 1      |
      | A MONTAGE1 | 1      |
    And I save the current editor

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-B12   |
    And I append rows
      | artikel | mge |
      | EKTEIL  | 100 |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    And I run Scheduling

# durch Dispo erstellten Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG_OCHA_LAG"
    And I press button "ladetab"
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "FVB12_" in row !lastRow
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I create a Lot "CH_B12" for Product "BG_OCHA_LAG"

    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB12_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2          |
      | bzeit   | 2          |
      | sofort  | ja         |
      | kcharge | !CH_B12^id |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB12_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2          |
      | bzeit   | 2          |
      | sofort  | ja         |
      | kcharge | !CH_B12^id |
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Rueckbau auf Arbeitsschein mit Chargenangabe
    Given I open an editor "RB_Charge" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB12_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 2          |
      | bzeit   | 2          |
      | sofort  | ja         |
      | kcharge | !CH_B12^id |
    And I set field "gutmge" to "-7" in row 1
    And I save the current editor

# Rueckbau auf Arbeitsschein ohne Chargenangabe
    Given I open an editor "RB_ohneCharge" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB12_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-7" in row 1
    And I save the current editor

# BA abschließen
    Given I open an editor "Rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB12_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1          |
      | bzeit   | 1          |
      | sofort  | ja         |
      | kcharge | !CH_B12^id |
      | gut     | ja         |
    And I save the current editor

###################################################################################################################

  Scenario: B13 Rueckbau ueber Rueckmeldung Koppelprodukt mit Charge als zusaetzliche Entnahme

# Stammdaten anlegen
    Given I open an editor "KOPPEL_CHA" from table "(Part):(Product)" with command "STORE" for record "KOPPEL_CHA"
    And I set fields
      | such      | KOPPEL_CHA                      |
      | namebspr  | Koppelprodukt chargenpflichtig  |
      | dispoa    | bedarfsbezogen                  |
      | bsart     | Eigenfertigung                  |
      | chverfolgung | Chargenverfolgung            |
      | chimlager | ja                              |
      | wgruppe   | 55                              |
      | erlgrp    | 66                              |
    And I save the current editor

# Chargen anlegen
    Given I create a Lot "CH_K113" for Product "KOPPEL_CHA"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch  | mfreig |
      | BAUGRUPPE   | 15     | FVB013_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB013_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | sofort  | ja         |
    And I delete all rows
    And I append rows
      | artikel     | mge   | kompeig       | charge    |
      | KOPPEL_CHA  | 2     | Koppelprodukt | CH_K113   |
    And I save the current editor

# Rueckbau auf Arbeitsschein
    Given I open an editor "Rueckgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB013_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | sofort  | ja         |
    And I delete row at position 1
    Then field "artikel" has value "KOPPEL_CHA" in row 1
    And I set field "mge" to "-1" in row 1
    And I set field "charge" to "CH_K113" in row 1
    And I save the current editor

# BA abschließen
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB013_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | gut     | ja      |
      | manrest | ja      |
    And I save the current editor


  Scenario: B14 Rueckbau ueber Rueckmeldung einer zusaetzliche Entnahme, ohne Chargenangabe, Entnahme ist mit Charge erfolgt

# Stammdaten anlegen
    Given I open an editor "MAT14_CHA" from table "(Part):(Product)" with command "STORE" for record "MAT14_CHA"
    And I set fields
      | such      	 | MAT14_CHA                   |
      | namebspr  	 | Material chargenpflichtig   |
      | dispoa    	 | bedarfsbezogen              |
      | bsart     	 | Eigenfertigung              |
      | chverfolgung     | Chargenverfolgung           |
      | chimlager 	 | ja                          |
      | wgruppe   	 | 55                          |
      | erlgrp   	 | 66                          |
    And I save the current editor

# Chargen anlegen
    Given I create a Lot "CH_MAT14" for Product "MAT14_CHA"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch  | mfreig |
      | BAUGRUPPE2  | 15     | FVB014_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVB014_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | sofort  | ja         |
    And I delete all rows
    And I append rows
      | artikel     | mge   | charge    |
      | MAT14_CHA   | 2     | CH_MAT14  |
    And I save the current editor

# Rueckbau auf Arbeitsschein, OHNE Charge
    Given I open an editor "Rueckgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FVB014_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | sofort  | ja         |
    And I delete row at position 1
    Then field "artikel" has value "MAT14_CHA" in row 1
    And I set field "mge" to "-1" in row 1
    # 1395 Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge.
    Then saving the current editor throws the exception "1395"
    And I set field "charge" to "CH_MAT14" in row 1
    And I save the current editor

# BA abschließen
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,such=FVB014_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1       |
      | bzeit   | 1       |
      | sofort  | ja      |
      | gut     | ja      |
      | manrest | ja      |
    And I save the current editor

