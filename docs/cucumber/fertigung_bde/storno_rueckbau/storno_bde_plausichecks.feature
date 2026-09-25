@persistent
Feature: storno_bde_plausichecks.feature

  Background:
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : storno_bde_plausichecks.feature
#  Autor            : lschneider
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Testet Plausibilitaeten beim Storno von BDE-Objekten
#  Jira-Issue       : FDA-412
# *****************************************************************************

  Scenario: 00 Benötigte Daten anlegen
	# Mitarbeiter anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA1"
    And I set fields
      | such  | BDE_MA1 |
      | splan | 303     |
      | lohn  | 1       |
    And I save the current editor

	# Personalzeit anlegen
    Given I open an editor "Personalzeit1" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA1;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to "BDE_MA1"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor


  Scenario: A Durch Auftragszeit oder Kurzläufer entstandene Rückmeldung hat den Verweis auf das BDE-Objekt
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch      | mfreig |
      | B_BAUGRUPPE2 | 10     | BDEVERWEIS_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDEVERWEIS_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDEVERWEIS_002"
    And I close the current editor

	# Kurzläufer und Verweise prüfen
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 1    |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Rückmeldung_Kurzl" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEVERWEIS_001;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    Then field "bdeobjekt^id" has value equal to field "id" from editor "Kurzläufer"
    And I close the current editor
    Then field "rm^id" from editor "Kurzläufer" in row 0 has value "!Rückmeldung_Kurzl^id"

	# Auftragszeit erstellen und übertragen, VerweisE prüfen
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:00 |
      | enddat  | .     |
      | endzeit | 10:45 |
      | istmge  | 1     |
      | sofort  | ja    |
    And I save the current editor

    Given I open an editor "Rückmeldung_Auftr" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDEVERWEIS_002;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    Then field "barmex" has value equal to field "nummer" from editor "Arbeitsschein2"
    Then field "bdeobjekt^id" has value equal to field "id" from editor "Auftragszeit"
    And I close the current editor
    Then field "rm^id" from editor "Auftragszeit" in row 0 has value "!Rückmeldung_Auftr^id"

	# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDEVERWEIS_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: B Typen werden in Storno-BDE-Belegen und stornierten BDE-Belegen entsprechend gesetzt
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch | mfreig |
      | B_BAUGRUPPE2 | 10     | TYPEN_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "TYPEN_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "TYPEN_002"
    And I close the current editor

  	# Kurzläufer erstellen, Auftragszeit erstellen
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 3    |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | enddat  | .    |
      | endzeit | 9:45 |
      | istmge  | 3    |
      | sofort  | ja   |
    And I save the current editor

  	# Storno der BDE-Objekte, Prüfung der Typen
    Given I open an editor "Storno_Auftragszeit" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    Then field "typ" has value "Storno-Auftragszeit"
    And I save the current editor
    Then field "typ" from editor "Auftragszeit" in row 0 has value "Stornierte Auftragszeit"

    Given I open an editor "Storno_Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    Then field "typ" has value "Storno-Auftragszeit"
    And I save the current editor
    Then field "typ" from editor "Kurzläufer" in row 0 has value "Stornierte Auftragszeit"

  	# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYPEN_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: C Rückmeldung kann nicht direkt storniert werden, wenn sie durch eine Auftragszeit oder Kurzläufer entstanden ist
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch      | mfreig |
      | B_BAUGRUPPE2 | 10     | STORNOFEHL_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNOFEHL_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNOFEHL_002"
    And I close the current editor

	# Kurzläufer erstellen, Storno der Rückmeldung führt zu Fehlermeldung
	# Fehlermeldung: Bitte über Auftragszeit/ Kurzläufer stornieren.
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 1    |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Rückmeldung_Kurzl" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOFEHL_001;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor

    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung_Kurzl" throws the exception "10917"
    And I close the current editor

	# Auftragszeit erstellen und übertragen, Storno der Rückmeldung führt zu Fehlermeldung
    # Fehlermeldung: 10917 de   |Die Rückmeldung kann nur durch stornieren des BDE-Satzes storniert werden.
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:00 |
      | enddat  | .     |
      | endzeit | 10:45 |
      | istmge  | 1     |
      | sofort  | ja    |
    And I save the current editor

    Given I open an editor "Rückmeldung_Auftr" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOFEHL_001;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor

    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung_Auftr" throws the exception "10917"
    And I close the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOFEHL_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: D BDE-Objekt kann nicht storniert werden, wenn auf die Rückmeldung bereits ein Rückbau gebucht wurde
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch     | mfreig |
      | B_BAUGRUPPE2 | 10     | BDERUECK1_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDERUECK1_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDERUECK1_002"
    And I close the current editor

	# Rückmeldung und Rückbau über Kurzläufer und Auftragszeit erstellen
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 3    |
      | sofort  | ja   |
    And I save the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Kurzläufer_RUECK" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:30 |
      | istmge  | -1   |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:00 |
      | enddat  | .     |
      | endzeit | 10:45 |
      | istmge  | 3     |
      | sofort  | ja    |
    And I save the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Auftragszeit_RUECK" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:45 |
      | enddat  | .     |
      | endzeit | 11:00 |
      | istmge  | -1    |
      | sofort  | ja    |
    And I save the current editor

	# Storno der BDE-Objekte führt zu Fehlermeldungen
    Then opening an editor from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer" throws the exception "2620"
    And I close the current editor

    Then opening an editor from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit" throws the exception "2620"
    And I close the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDERUECK1_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: E Ein BDE-Objekt kann nicht noch einmal storniert werden, ein storniertes BDE-Objekt kann nicht storniert werden
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch     | mfreig |
      | B_BAUGRUPPE2 | 10     | BDESTORNO_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDESTORNO_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDESTORNO_002"
    And I close the current editor

	# Kurzläufer erstellen, Auftragszeit erstellen
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 3    |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | enddat  | .    |
      | endzeit | 9:45 |
      | istmge  | 3    |
      | sofort  | ja   |
    And I save the current editor

	# Storno der BDE-Objekte
    Given I open an editor "Storno_Auftragszeit" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    And I save the current editor

    Given I open an editor "Storno_Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    And I save the current editor

	# Storno der Storno-BDE-Belege und stornierten Belege nicht möglich
	# Fehlermeldung: 1582 Ungültige Objektangabe
    Then opening an editor from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Storno_Kurzläufer" throws the exception "1582"
    And I close the current editor

    Then opening an editor from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Storno_Auftragszeit" throws the exception "1582"
    And I close the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDESTORNO_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: F Für einen angelegten FV kann das BDE-Objekt nicht mehr storniert werden
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch     | mfreig |
      | B_BAUGRUPPE2 | 10     | ABLAGEBDE_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ABLAGEBDE_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ABLAGEBDE_002"
    And I close the current editor

	# Kurzläufer erstellen, Auftragszeit erstellen
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 5    |
      | sofort  | ja   |
    And I save the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Kurzläufer2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:30 |
      | istmge  | 5    |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Auftragszeit1" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:00 |
      | enddat  | .     |
      | endzeit | 10:15 |
      | istmge  | 5     |
      | sofort  | ja    |
    And I save the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Auftragszeit2" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:15 |
      | enddat  | .     |
      | endzeit | 10:45 |
      | istmge  | 5     |
      | sofort  | ja    |
    And I save the current editor

	# Storno der BDE-Objekte nicht möglich
	# Fehlermeldung: Bitte über Rückmeldung stornieren.
    Then opening an editor from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer1" throws the exception "2620"
    And I close the current editor

    Then opening an editor from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit1" throws the exception "2620"
    And I close the current editor


  Scenario: G Eine Rückmeldung, die an einem BDE-Objekt hängt, kann nicht gelöscht werden.
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch    | mfreig |
      | BAUGRUPPE2 | 10     | RMLOESCH_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RMLOESCH_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RMLOESCH_002"
    And I close the current editor

	# Kurzläufer und Auftragszeit erstellen und übertragen, Rückmeldungen bleiben aber ungebucht
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 8:00 |
      | istmge  | 2    |
    And I save the current editor

    Given I switch the current editor to editor "Kurzläufer1" with command "TRANSFER"
    And I save the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Auftragszeit1" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | enddat  | .    |
      | endzeit | 9:15 |
      | istmge  | 2    |
    And I save the current editor

    Given I switch the current editor to editor "Auftragszeit1" with command "TRANSFER"
    And I save the current editor

    # Ungebuchte Rückmeldungen löschen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "RMLOESCH_001"
    Then field "ablagef" has value "nein"
    And I close the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "RMLOESCH_002"
    Then field "ablagef" has value "nein"
    And I close the current editor

    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "DELETE" for record from editor "Rückmeldung1" throws the exception "10899"
    And I close the current editor

    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "DELETE" for record from editor "Rückmeldung2" throws the exception "10899"
    And I close the current editor


  Scenario: H BG mit 3 AG: Rückmeldungen auf AG1 - AG3 erzeugen, nicht übertragen. Buchen von BDE auf BA bringt Fehler.
    # Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig |
      | BAUGRUPPE3   | 10     | BABUCH_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    # Kurzläufer auf AG1 erstellen
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "BABUCH_001"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 6:00 |
      | istmge  | 1    |
    And I save the current editor

    # Kurzläufer auf AG2 erstellen
    Given I open an editor "Kurzläufer2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "BABUCH_002"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 7:00 |
      | istmge  | 1    |
    And I save the current editor

    # Kurzläufer auf AG3 erstellen
    Given I open an editor "Kurzläufer3" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "BABUCH_003"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 8:00 |
      | istmge  | 1    |
    And I save the current editor

     # Kurzläufer auf BA erstellen
    Given I open an editor "Kurzläufer4" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "BABUCH_000"
    And I set fields
      | mgr     | 101  |
      | anfdat  | .    |
      | anfzeit | 8:00 |
      | istmge  | 1    |
    And I save the current editor

    # Kurzläufer auf AG1 übertragen, ungebuchte Rückmeldungen entsteht
    Given I switch the current editor to editor "Kurzläufer1" with command "TRANSFER"
    And I save the current editor

    # Kurzläufer auf AG2 übertragen, ungebuchte Rückmeldungen entsteht
    Given I switch the current editor to editor "Kurzläufer2" with command "TRANSFER"
    And I save the current editor

    # Kurzläufer auf AG3 übertragen, ungebuchte Rückmeldungen entsteht
    Given I switch the current editor to editor "Kurzläufer3" with command "TRANSFER"
    And I save the current editor

    # Kurzläufer auf BA übertragen -> Fehlermeldung wg. ungebuchter RM auf AG3
    Given I switch the current editor to editor "Kurzläufer4" with command "TRANSFER"
    Then saving the current editor throws the exception "8808"
    And I close the current editor


  Scenario: I BG mit 3 AG: Rückmeldungen auf AG1 - AG3 erzeugen und buchen. Stornieren von Kurzläufer auf AG1 und AG2 bringt Fehler.
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch    | mfreig |
      | BAUGRUPPE3   | 10     | RMREIHE_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    # Kurzläufer auf AG1 erstellen und buchen, gebuchte Rückmeldungen entsteht
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "RMREIHE_001"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 6:00 |
      | istmge  | 1    |
      | sofort  | ja   |
    And I save the current editor

    # Kurzläufer auf AG2 erstellen und buchen, gebuchte Rückmeldungen entsteht
    Given I open an editor "Kurzläufer2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "RMREIHE_002"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 7:00 |
      | istmge  | 1    |
      | sofort  | ja   |
    And I save the current editor

    # Kurzläufer auf AG3 erstellen und buchen, gebuchte Rückmeldungen entsteht
    Given I open an editor "Kurzläufer3" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "RMREIHE_003"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 8:00 |
      | istmge  | 1    |
      | sofort  | ja   |
    And I save the current editor

    # Storno des BDE-Objekts auf AG1 bringt Fehler
    Then opening an editor from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer1" throws the exception "9503"

    # Storno des BDE-Objekts auf AG2 bringt Fehler
    Then opening an editor from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer2" throws the exception "9503"

    # Storno des BDE-Objekts auf AG3 ist erlaubt
    Given I open an editor "Storno_Kurzläufer3" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer3"
    Then field "typ" has value "Storno-Auftragszeit"
    And I save the current editor
    Then field "typ" from editor "Kurzläufer3" in row 0 has value "Stornierte Auftragszeit"


  Scenario: J Beim Kopieren von Storno-BDE-Belegen muss der Typ neu initialisiert werden
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig |
      | B_BAUGRUPPE2 | 11     | STRNTYP_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

  	# Kurzläufer erstellen, Auftragszeit erstellen
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set fields
      | asma    | STRNTYP_001 |
      | anfdat  | .           |
      | anfzeit | 9:01        |
      | istmge  | 4           |
      | sofort  | ja          |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set fields
      | asma    | STRNTYP_002 |
      | anfdat  | .           |
      | anfzeit | 9:02        |
      | enddat  | .           |
      | endzeit | 9:46        |
      | istmge  | 4           |
      | sofort  | ja          |
    And I save the current editor

  	# Storno der BDE-Objekte, Prüfung der Typen
    Given I open an editor "Storno_Auftragszeit" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    Then field "typ" has value "Storno-Auftragszeit"
    And I save the current editor
    Then field "typ" from editor "Auftragszeit" in row 0 has value "Stornierte Auftragszeit"

    Given I open an editor "Storno_Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    Then field "typ" has value "Storno-Auftragszeit"
    And I save the current editor
    Then field "typ" from editor "Kurzläufer" in row 0 has value "Stornierte Auftragszeit"

  	# Kopieren der BDE-Objekte, Prüfung der Typen, Objekte werden nicht gespeichert
    Given I open an editor "Kopie_Kurzläufer_Storno" from table "(PDC):(ShortProductionOrder)" with command "COPY" for record from editor "Storno_Kurzläufer"
    Then field "typ" has value "Auftragszeit"
    And I close the current editor

    Given I open an editor "Kopie_Auftragszeit_Storno" from table "(PDC):(OrderTime)" with command "COPY" for record from editor "Storno_Auftragszeit"
    Then field "typ" has value "Auftragszeit"
    And I close the current editor

    Given I open an editor "Kopie_Kurzläufer_storniert" from table "(PDC):(ShortProductionOrder)" with command "COPY" for record from editor "Kurzläufer"
    Then field "typ" has value "Auftragszeit"
    And I close the current editor

    Given I open an editor "Kopie_Auftragszeit_storniert" from table "(PDC):(OrderTime)" with command "COPY" for record from editor "Auftragszeit"
    Then field "typ" has value "Auftragszeit"
    And I close the current editor

  	# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STRNTYP_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
