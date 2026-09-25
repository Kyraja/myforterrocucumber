@persistent
Feature: storno_bde_prozesstests.feature

  Background:
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : storno_bde_prozesstests.feature
#  Autor            : lschneider
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Testet den Storno von BDE-Objekten
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

    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA2"
    And I set fields
      | such  | BDE_MA2 |
      | splan | 301     |
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


# BDE-Objekt ist noch nicht übertragen

  Scenario: A Löschen eines nicht übertragenen BDE-Objekt
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch    | mfreig |
      | B_BAUGRUPPE2 | 10     | LOESCHEN_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsschein für Arbeitsscheinnummer öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "LOESCHEN_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "LOESCHEN_002"
    And I close the current editor

	# Kurzläufer und Auftragszeit
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 1    |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:00 |
      | enddat  | .     |
      | endzeit | 10:45 |
      | istmge  | 1     |
    And I save the current editor

	# BDE-Objekte über Kommando löschen, BDE-Belege sind nicht mehr vorhanden
	# Fehlermeldung: 1582 Ungültige Objektangabe
    And I switch the current editor to editor "Kurzläufer" with command "DELETE"
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

    And I switch the current editor to editor "Auftragszeit" with command "DELETE"
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

    Then opening an editor from table "(PDC):(ShortProductionOrder)" with command "VIEW" for record from editor "Kurzläufer" throws the exception "1582"
    And I close the current editor

    Then opening an editor from table "(PDC):(OrderTime)" with command "VIEW" for record from editor "Auftragszeit" throws the exception "1582"
    And I close the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "BA_Abschluss_A" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LOESCHEN_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor



# Rückmeldung ist noch nicht übertragen

  Scenario: B Nicht übertragenes BDE-Objekt stornieren
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch  | mfreig |
      | B_BAUGRUPPE2 | 10     | OHNERM_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "OHNERM_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "OHNERM_002"
    And I close the current editor

	# Kurzläufer und Auftragszeit erstellen, Auftragszeit übertragen, ungebuchte Rückmeldungen entstehen
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 1    |
    And I save the current editor

    Given I switch the current editor to editor "Kurzläufer" with command "TRANSFER"
    And I save the current editor

    Given I open an editor "Rückmeldung_Kurzl" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "OHNERM_001"
    Then field "bdeobjekt^id" has value "!Kurzläufer^id"
    And I close the current editor
    Then field "rm^id" from editor "Kurzläufer" in row 0 has value "!Rückmeldung_Kurzl^id"

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:00 |
      | enddat  | .     |
      | endzeit | 10:45 |
      | istmge  | 1     |
      | bem     | Hallo |
    And I save the current editor

    Given I switch the current editor to editor "Auftragszeit" with command "TRANSFER"
    And I save the current editor

    Given I open an editor "Rückmeldung_Auftr" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "OHNERM_002"
    Then field "bdeobjekt^id" has value "!Auftragszeit^id"
    Then field "bdebem" has value "!Auftragszeit^bem"
    And I close the current editor
    Then field "rm^id" from editor "Auftragszeit" in row 0 has value "!Rückmeldung_Auftr^id"
	
	# Storno der BDE-Objekte löscht die Rückmeldung und leert den Verweis auf die Rückmekdung im BDE-Objekt
    Given I open an editor "Kurzläufer_STORNO" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    And I save the current editor
    Then field "rm" from editor "Kurzläufer" in row 0 has value ""

    Given I open an editor "Auftragszeit_STORNO" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    And I save the current editor
    Then field "rm" from editor "Auftragszeit" in row 0 has value ""

	# Ungebuchte Rückmeldungen wurden gelöscht
    Given I query "barmex" from table "(Workorder):(CompletionConfirmations)" where "such=OHNERM_001"
    Then query has no hits

    Given I query "barmex" from table "(Workorder):(CompletionConfirmations)" where "such=OHNERM_002"
    Then query has no hits

	# Betriebsauftrag abschließen
    Given I open an editor "BA_Abschluss_B" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OHNERM_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor



# Rückmeldung ist bereits übertragen

  Scenario: C Stornieren von BDE-Objekten storniert auch die entstandenen Rückmeldungen
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig |
      | B_BAUGRUPPE2 | 10     | STORNO1_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNO1_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNO1_002"
    And I close the current editor

	# Kurzläufer und Auftragszeit erstellen, Auftragszeit übertragen, ungebuchte Rückmeldungen entstehen
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 6:00 |
      | istmge  | 1    |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Rückmeldung_Kurzl" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNO1_001;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor

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

    Given I open an editor "Rückmeldung_Auftr" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNO1_002;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor

	# Storno der BDE-Objekte storniert die Rückmeldungen, Verweise bleiben erhalten
    Given I open an editor "Auftragszeit_STORNO" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    And I save the current editor
    Then field "typa279" from editor "Rückmeldung_Auftr" in row 0 has value "Stornierte Rückmeldung"
    Then field "bdeobjekt^id" from editor "Rückmeldung_Auftr" in row 0 has value "!Auftragszeit^id"
    Then field "rm^id" from editor "Auftragszeit" in row 0 has value "!Rückmeldung_Auftr^id"

    Given I open an editor "Kurzläufer_STORNO" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    And I save the current editor
    Then field "typa279" from editor "Rückmeldung_Kurzl" in row 0 has value "Stornierte Rückmeldung"
    Then field "bdeobjekt^id" from editor "Rückmeldung_Kurzl" in row 0 has value "!Kurzläufer^id"
    Then field "rm^id" from editor "Kurzläufer" in row 0 has value "!Rückmeldung_Kurzl^id"

	# Betriebsauftrag abschließen
    Given I open an editor "BA_Abschluss_C" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNO1_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: D Stornieren von BDE-Objekten löscht auch die ungebuchten, entstandenen Zeit-Rückmeldungen
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig |
      | B_BAUGRUPPE2 | 10     | STORNOZ_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Arbeitsscheine für Arbeitsscheinnummern öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNOZ_001"
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNOZ_002"
    And I close the current editor

	# Kurzläufer und Auftragszeit erstellen, Auftragszeit übertragen, ungebuchte Rückmeldungen entstehen
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 7:00 |
      | istzeit | 0,55 |
      | mzeit   | 0,44 |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "Arbeitsschein2"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 11:00 |
      | enddat  | .     |
      | endzeit | 11:45 |
      | sofort  | ja    |
    And I save the current editor

	# Storno der BDE-Objekte storniert die Rückmeldungen, Verweise bleiben erhalten
    Given I open an editor "Kurzläufer_STORNO" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    And I save the current editor

    Given I open an editor "Zeitbuchung_Kurzl" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOZ_001;mzeit=0,44;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung" in row 0
#	Then field "bdeobjekt^id" from editor "Zeitbuchung_Kurzl" in row 0 has value "!Kurzläufer^id"        <--- Feld ist nicht in der Skip-Gruppe
#	Then field "rm^id" from editor "Kurzläufer" in row 0 has value "!Zeitbuchung_Kurzl^id"               <--- Kann nicht geprüft werden, weil Objekt jetzt in der Skip-Gruppe steht
    And I close the current editor


    Given I open an editor "Auftragszeit_STORNO" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    And I save the current editor
    Given I open an editor "Zeitbuchung_Auftr" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=STORNOZ_002;bzeit=0,75;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung" in row 0
#	Then field "bdeobjekt^id" from editor "Zeitbuchung_Auftr" in row 0 has value "!Auftragszeit^id"     <--- s.o. 
#	Then field "rm^id" from editor "Auftragszeit" in row 0 has value "!Zeitbuchung_Auftr^id"            <--- s.o.
    And I close the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "BA_Abschluss_D" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZ_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: E Stornieren von BDE-Objekten löscht auch die entstandenen, ungebuchten Rückmeldungen
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig |
      | B_BAUGRUPPE2 | 10     | RMLOE_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Kurzläufer erstellen und anschliessend übertragen, ungebuchte Rückmeldung entsteht
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "RMLOE_001"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 6:00 |
      | istmge  | 1    |
    And I save the current editor
    Then field "rm" from editor "Kurzläufer1" is empty

    Given I switch the current editor to editor "Kurzläufer1" with command "TRANSFER"
    And I save the current editor
    Then field "rm" from editor "Kurzläufer1" is not empty

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RMLOE_000"
    Then field "nrm" has value "1"
    And I close the current editor

    # Kurzläufer stornieren, die ungebuchte RM wird gelöscht
    Given I open an editor "Kurzläufer1_STORNO" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer1"
    Then field "typa332" has value "Storno-Auftragszeit"
    And I save the current editor
    Then field "typa332" from editor "Kurzläufer1" in row 0 has value "Stornierte Auftragszeit"
    Then field "rm" from editor "Kurzläufer1" is empty

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RMLOE_000"
    Then field "nrm" has value "0"
    And I close the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "BA_Abschluss_E" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RMLOE_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

  Scenario: F.a Maskenprüf-FOP erzeugen und an Maske 44 (RM) hängen
	# Maskenprüf-FOP an Maske 44 hängen, damit RM nicht gebucht werden kann
	Given I execute shell command "echo \'.end 2 ? M|typ=6\' > ERROREXIT.FOP"
	Given I execute shell command "mv fop.txt fop.txt.bak"
	Given I execute shell command "mv fop.m44.ueber.txt fop.txt"

  Scenario: F.b Löschen einer gebuchten Storno-BDE löscht auch die entstandene, ungebuchte Rückmeldungen
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig |
      | B_BAUGRUPPE2 | 11     | BDELOE_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Kurzläufer erstellen und anschliessend übertragen, ungebuchte Rückmeldung entsteht
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "BDELOE_001"
    And I set fields
      | anfdat  | .               |
      | anfzeit | 6:30            |
      | istmge  | 2               |
      | erbtext1| RM_NICHT_BUCHEN |
      | sofort  | ja              |
    And I save the current editor

    # Kurzläufer stornieren, RM kann aufgrund Maskenpruef-FOP nicht gebucht werden
    Given I open an editor "Kurzläufer1_STORNO" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer1"
    Then field "typa332" has value "Storno-Auftragszeit"
    And I set field "bem" to "RM_NICHT_BUCHEN"
    And I save the current editor
    Then field "typa332" from editor "Kurzläufer1" in row 0 has value "Stornierte Auftragszeit"
    Then field "rm" from editor "Kurzläufer1" is not empty

	# Löschen der ungebuchten RM gibt Fehlermeldung -> BDE muss gelöscht werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "DELETE" for search criteria "$,,such=BDELOE_001;@richtung=rückwärts;@ablageart=lebendig;@maxordtreffer=1" throws the exception "1819"

	# Storno-BDE mit ungebuchter RM löschen
	Given I open an editor "Kurzläufer1_DELETE" from table "(PDC):(ShortProductionOrder)" with command "DELETE" for record from editor "Kurzläufer1_STORNO"
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

	# Stornierten BDE Satz prüfen: Typ wird wieder zur "Auftragszeit", Feld "stornopartnervorg" ist leer
    Given I open an editor "Kurzläufer1_PRÜF" from table "(PDC):(ShortProductionOrder)" with command "VIEW" for record from editor "Kurzläufer1"
    Then field "typa332" has value "Auftragszeit"
    Then field "stornopartnervorg" is empty
    And I close the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "BA_Abschluss_E" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDELOE_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

  Scenario: F.c alte fop.txt wieder restaurieren
	# Urzustand fop.txt wieder herstellen
	Given I execute shell command "mv fop.txt fop.m44.ueber.txt"
	Given I execute shell command "mv fop.txt.bak fop.txt"

  Scenario: G Kopieren einer Storno-BDE löscht auch den Verweis auf den Stornopartnervorgang
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig |
      | B_BAUGRUPPE2 | 12     | STRNCP_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Kurzläufer erstellen und übertragen
    Given I open an editor "Kurzl" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "STRNCP_001"
    And I set fields
      | anfdat  | .            |
      | anfzeit | 6:33         |
      | istmge  | 3            |
      | erbtext1| STRNCP_RM1   |
      | sofort  | ja           |
    And I save the current editor

    # Kurzläufer stornieren
    Given I open an editor "Kurzl_STORNO" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzl"
    Then field "typa332" has value "Storno-Auftragszeit"
    And I set field "bem" to "STRNCP_RM2"
    And I save the current editor
    Then field "typa332" from editor "Kurzl" in row 0 has value "Stornierte Auftragszeit"
    Then field "rm" from editor "Kurzl" is not empty

    # Stornierten Kurzläufer kopieren
    Given I open an editor "cp_stornierten_Kurzl" from table "(PDC):(ShortProductionOrder)" with command "COPY" for record from editor "Kurzl"
    Then field "stornopartnervorg" is empty
    And I close the current editor

    # Storno-Kurzläufer kopieren
    Given I open an editor "cp_storno_Kurzl" from table "(PDC):(ShortProductionOrder)" with command "COPY" for record from editor "Kurzl_STORNO"
    Then field "stornopartnervorg" is empty
    And I close the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "BA_Abschluss_G" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STRNCP_002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  # Diagnosemeldungen
  Scenario: DIAG1 Auftragszeit erfassen, wenn es bereits einen stornierten Kurzläufer gibt (Diag beim holen des Schichtplans)
	# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch | mfreig |
      | B_BAUGRUPPE2 | 10     | DIAG1_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

	# Kurzläufer erstellen, übertragen und wieder stornieren
    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA2"
    And I set field "asma" to "DIAG1_001"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 7:31 |
      | istzeit | 0,52 |
      | mzeit   | 0,43 |
      | sofort  | ja   |
    And I save the current editor

    Given I open an editor "Kurzläufer_STORNO" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer"
    And I save the current editor

    # Auftragszeit anlegen. Beim Eintragen von anfdat/anfzeit kommt es zur Diag
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA2"
    And I set field "asma" to "DIAG1_001"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 8:31 |
      | enddat  | .    |
      | endzeit | 9:33 |
      | sofort  | ja   |
    And I save the current editor

	# Betriebsauftrag abschließen
    Given I open an editor "BA_Abschluss_D" from table "(Workorder):(WorkOrders)" with command "DONE" for record "DIAG1_000"
    And I set fields
      | mgr    | 101|
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
