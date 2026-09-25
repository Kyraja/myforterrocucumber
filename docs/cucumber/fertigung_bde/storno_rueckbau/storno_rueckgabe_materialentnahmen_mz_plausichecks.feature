@persistent
Feature: storno_rueckgabe_materialentnahmen_mz_plausichecks.feature

  Background:
    And I set the fake date to "03.02.1995"


# *******************************************************************************************
#  Name             : storno_rueckgabe_materialentnahmen_mz_plausichecks
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Plausis in der Rückgabe von Material über Materialzuordnung
#                     in der FBuchung
#  Jira-Issue       : FDA-1033
# *******************************************************************************************

  Scenario: P01 Das Feld Verwendung ist in der MZ schreibgeschützt
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch  |
      | M_BAUGRUPPE | 10  | ja     | SCHUTZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCHUTZ_001"
    And I close the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme Rückgabe, verw ist in der MZ schreibgeschützt
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I set field "gmgevorschl" to "-4"
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge |
      | +1   | -4     |
      | +2   | -4     |
    Then field "verw" is not modifiable in row 1
    And I close the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I close the current editor


  Scenario: P02 Es kann keine Charge über MZ zurückgelegt werden, die nicht entnommen wurde
# Charge anlegen
    Given I create a Lot "EINKAUF-1" for Product "EINKAUF-1"

# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | FCHARGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FCHARGE_001"
    And I close the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I save the current editor

# Materialentnahme Rückgabe: Fehler bei der Rückgabe von Chargen, die nicht entnommen wurden
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I set field "gmgevorschl" to "-4"
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | charge        |
      | +1   | -4     | !EINKAUF-1^id |
      | +2   | -4     |               |
    Then saving the current editor throws the exception "4066"
    And I close the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I close the current editor


  Scenario: P03 Eine Rückgabe über MZ kann nicht in einen Behälter mit Status Gesperrt, Rücklieferung oder Geliefert erfolgen
# Behälter erstellen
    Given I create a Container "GELIEFERT" for packaging material "BEHAELTER"
    Given I create a Container "RUECKLIEFERUNG" for packaging material "BEHAELTER"
    Given I open an editor "GESPERRT" from table "(Container):(ContainerShell)" with command "NEW" for record ""
    And I set fields
      | such        | GESPERRT  |
      | packm       | BEHAELTER |
      | behstatusaz | Gesperrt  |
    And I save the current editor

# Behälter in Status Geliefert und Rückgeliefert setzen
    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | beleg   | Behälter1 |
      | beldat  | .         |
      | buart   | Zugang    |
    And I append rows
      | mge | behaelter     |
      | 1   | !GELIEFERT^id |
    And I save the current editor

    Given I open an editor "VK-Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
      | vom   | .       |
      | ueb   | ja      |
    And I append rows
      | artikel   | mge | behaelter     |
      | BAUGRUPPE | 1   | !GELIEFERT^id |
    And I save the current editor
    Then field "behstatusaz" from editor "GELIEFERT" in row 0 has value "Geliefert"

    Given I open an editor "EK-Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | ebeleg | Lieferung1 |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 1   |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "RUECKLIEFERUNG" in row 1
    And I save the current editor

    Given I open an editor "EK-Rücklieferschein" via ID from editor "EK-Lieferschein" from field "id" in row 0 for table "(Purchasing):(PackingSlip)" with command "RETURN"
    And I set fields
      | vom    | .              |
      | ueb    | ja             |
      | ebeleg | Rücklieferung1 |
    And I modify table
      | !row | mge | behaelter          |
      | 1    | -1  | !RUECKLIEFERUNG^id |
    And I save the current editor
    Then field "behstatusaz" from editor "RUECKLIEFERUNG" in row 0 has value "Rücklieferung"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch     |
      | M_BAUGRUPPE | 10  | ja     | BEHAELTER_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEHAELTER_001"
    And I close the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I save the current editor

# Materialrückgabe in Behälter mit Status Gesperrt, Geliefert und Rücklieferung bringt Fehler
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -10                    |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge |
      | +1   | -20    |
    Then setting field "behaelter" to "!GESPERRT^id" in row 1 throws the exception "11072"
    Then setting field "behaelter" to "!GELIEFERT^id" in row 1 throws the exception "8413"
    Then setting field "behaelter" to "!RUECKLIEFERUNG^id" in row 1 throws the exception "8413"
    And I close the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

# Betriebsauftrag abbrechen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEHAELTER_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P04 Eine Rückgabe über MZ kann nicht in einen Behälter mit abweichendem Platz zur MZ erfolgen
# Behälter erstellen
    Given I create a Container "PLATZ_F2" for packaging material "BEHAELTER"

# Behälter in Status Geliefert und Rückgeliefert setzen
    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | beleg   | Behälter1 |
      | beldat  | .         |
      | buart   | Zugang    |
    And I append rows
      | mge | platz2 | behaelter    |
      | 1   | F2     | !PLATZ_F2^id |
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | PLAETZE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "PLAETZE_001"
    And I close the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I save the current editor

# Materialrückgabe in Behälter mit Status Gesperrt, Geliefert und Rücklieferung bringt Fehler
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -10                    |
    And I press button "stlvblad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | +1   | -20    | F1    |
    Then setting field "behaelter" to "!PLATZ_F2^id" in row 1 throws the exception "8334"
    And I close the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

# Betriebsauftrag abbrechen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "PLAETZE_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P05 Eine Rückgabe über MZ auf einen Platz einer anderen Lagergruppe, der nicht in der Ursprungs-MZ war, ist nicht möglich
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "123"

	# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | LAGERGR_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "LAGERGR_001"
    And I close the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I save the current editor

# Materialrückgabe mit Lagerplatz aus anderer Lagergruppe führt zu Fehler
  	# Fehler 4170: Lagergruppen der Materialzuordnungen und des Vorgangs müssen übereinstimmen
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -10                    |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | 1    | -10    | L2F1   |
    Then saving the current editor throws the exception "4170"
    And I set field "lpsuch" to "F1" in row 1
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I close the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "LAGERGR_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: P06 Fehlermeldung beim Speichern von negativen Mengen über Materialzuordnung
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | NEGMAT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor
	
	# Negative Materialentnahme über MZ und mzueb=ja in FBU uebernehmen
	#    1395 de   |Fehler: stornierte Menge größer als ursprünglich zurückgemeldete Menge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=NEGMAT_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I set field "manbu" to "ja" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I set field "zuomge" to "-100" in row 1
    And I set field "mzueb" to "ja"
    Then saving the current editor throws the exception "4066"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
	
	# Betriebsauftrag löschen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NEGMAT_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P07 Rückbau auf abgelegten FV mit Charge (FDA-2784)
# Chargen anlegen
    Given I create a Lot "CH_BG1ZU" for Product "M_BAUGRUPPE2"
    Given I create a Lot "CH_MAT1AB1" for Product "EINKAUF-1"
    Given I create a Lot "CH_MAT1AB2" for Product "EINKAUF-1"
    Given I create a Lot "CH_MAT2AB1" for Product "EINKAUF-2"
    Given I create a Lot "CH_MAT2AB2" for Product "EINKAUF-2"

# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "S-KORR24"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "S-KORR24"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "S-KORR24"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F2" with document "S-KORR24"

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig | bisuch |
      | M_BAUGRUPPE2 | 10  | ja     | CHRB_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über die gesamte Menge mit unterschiedlichen Zu- und Abgangschargen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | CHRB_000 |
      | gmgevorschl | 5        |
      | mgr         | 112      |
      | charge      | CH_BG1ZU |
    And I press button "stllad"
    And I set field "rescharge" to "CH_MAT1AB1" in row 1
    And I set field "rescharge" to "CH_MAT2AB1" in row 2
    And I save the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | CHRB_000 |
      | gmgevorschl | 5        |
      | mgr         | 112      |
      | charge      | CH_BG1ZU |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "CH_MAT1AB2" in row 1
	And I press button for next product
    And I set field "charge" to "CH_MAT2AB2" in row 1
	And I close the current editor
	And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

# Material über AS1 OHNE Zugangscharge entnehmen und wieder zurück legen
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | CHRB_001 |
      | gmgevorschl | 5        |
      | maxofmge    | nein     |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "CH_MAT1AB1" in row 1
	And I close the current editor
	And I switch the current editor to editor "Materialentnahme3"
    And I save the current editor

    Given I open an editor "Materialentnahme4" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | CHRB_001 |
      | gmgevorschl | -5       |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "CH_MAT1AB1" in row 1
	And I close the current editor
	And I switch the current editor to editor "Materialentnahme4"
    And I save the current editor

    Given I open an editor "Materialentnahme5" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | CHRB_001 |
      | gmgevorschl | 5        |
      | maxofmge    | nein     |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "CH_MAT1AB1" in row 1
	And I close the current editor
	And I switch the current editor to editor "Materialentnahme5"
    And I save the current editor

    Given I open an editor "Materialentnahme6" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | CHRB_001 |
      | gmgevorschl | -5       |
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
    And I set field "charge" to "CH_MAT1AB1" in row 1
	And I close the current editor
	And I switch the current editor to editor "Materialentnahme6"
    And I save the current editor

# FV abschliessen
    Given I open an editor "RMALL" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHRB_000;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | mgr    | 112 |
      | gut    | ja  |
      | sofort | ja  |
    And I save the current editor

# Nachbuchen mit Vorlage bebuchter AS erzeugt Diag
    Given I open an editor "NachbuchenRückbau" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=CHRB_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I set field "mge" to "-1" in row 2
    Then saving the current editor throws the exception "1395"
    And I close the current editor

