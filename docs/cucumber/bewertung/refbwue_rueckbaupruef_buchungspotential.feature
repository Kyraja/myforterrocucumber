# *****************************************************************************
#  Name             : 
#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : Testet Plausis beim R…kbau UND ue-Werte
#
# *****************************************************************************

@persistent
Feature: ue_rueckbaupruef_buchungspotential

Background: 
Given I set the fake date to "03.02.2002"

Scenario: uE Buchung auf fuer 50000er konto
Given I open an editor "Konto50000" from table "(Account):(Account)" with command "UPDATE" for record "50000"
And I set field "hkost" to "ja"
And I save the current editor

Scenario: Mengen und Preise bereitstellen
Given I set the fake date to "07.02.2002"
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | E1 |
    | buart     | Zugang    | 
    | beleg     | mge-preis | 
    | wert      | 45        | 
    | beldat    | .         | 
And I delete all rows
And I append rows
    | mge	| platz2 |
    | 50 	| F1     |
And I save the current editor

Scenario: 01 Rückbau ohne Fertigungszeiten jedoch mit Sonderkosten 
#--------------------------------------------------------------------
Given I set the fake date to "07.02.2002"

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel|netmge| bisuch            |kstelle| mfreig	|
	| BG1	 |   10 | RUECKB_EINSEITIG_ | KTR2	| ja		|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# R…kmeldung auf ersten Arbeitsgang
Given I open an editor "R…kmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_EINSEITIG_001"
And I set field "sofort" to "1"
And I set field "gutmge" to "4" in row 1
And I save the current editor

# R…kmeldung auf zweiten Arbeitsgang
Given I open an editor "R…kmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_EINSEITIG_002"
And I set field "sofort" to "1"
And I set field "gutmge" to "6" in row 1
And I save the current editor

# Betriebsauftrag abschließen
Given I open an editor "R…kmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_EINSEITIG_002"
And I set fields
	| sofort	| ja	|
	| gut		| ja	|
	| mgr		| 112	|
And I save the current editor

# R…kbau, nur der gesamten gutmenge als nachbuchung, kein Rueckbau der entnahmemenge(n). einseitiger Rückbau 
# alle uE-Werte des BAs, auch Fertigungszeiten, müssen im ue verworfen werden!

# der in dieser Version behobene Fehler ist im Vorgängercommit dieser Datei an d. Stelle noch beschrieben...

# Beachte hier die besondere Schwierigkeit der richtigen Selektion für die Nachmeldung.
# Es muss die Rückmeldung mit der Gutmenge 6 kopiert werden, 
# damit die gesamte Gutmenge von 10 Stk. (alleine) abgebaut werden darf. 

# Hinweis (aus Vorgängerstand ~6/24, aktuell nicht gegengeprüft, ob das noch so ist):
# Andere Rückmeldungen funktionieren hier nicht, aber ohne jegliche Fehlermeldung. 
# Erst wenn man dort auch Entnahmemenge zurückgibt funktionieren diese (meint: speichern sie überhaupt).

# Der Rückbau führt in Bewertungsketten NICHT zum Verwerfen aller uE-Werte des Betr.auftrages (bwueverwerfen),
# sondern zur Reduzierung der Bewertungsmenge um die Rückbaumenge - hier auf Menge 0 in den Zugangsbewertungen 11 und 12, 
# die an die jeweilige Bewertungskette angehängt werden (Rückbaufunktionalität). Lt. Artur OK so.

# Also beim Abbruch eines BAs werden die vorhandenen uE-Werte expliziert ausgenullt, das passiert hier aber nicht!
# Dass ein solcher inkonsistener Rückbau erfolgt liegt hier in der Verantwortung des Anwenders und dass er so erfolgen kann, 
# in der Zuständigkeit der Fertigung/MPS. 

Given I open an editor "R…kbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for record "$,,nummer==1001002;gutmge==6;typ=Rückmeldung;@sort=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
And I set field "gutmge" to "-10" in row 1
And I save the current editor


Scenario: 01 Rückbau MIT Fertigungszeiten und Sonderkosten 
#----------------------------------------------------------
Given I set the fake date to "07.02.2002"

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel|netmge| bisuch                     |kstelle| mfreig	|
	| BG1	 |    10| RUECKB_GESAMT_UE_VERW_ | KTR2	| ja		|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# R…kmeldung auf ersten Arbeitsgang
Given I open an editor "R…kmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_GESAMT_UE_VERW_001"
And I set field "sofort" to "1"
And I set field "mzeit" to "1"
And I set field "gutmge" to "2" in row 1
And I save the current editor

# R…kmeldung auf zweiten Arbeitsgang
Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_GESAMT_UE_VERW_002"
And I set field "sofort" to "1"
And I set field "mzeit" to "3"
And I set field "gutmge" to "8" in row 1
And I save the current editor

# Betriebsauftrag abschließen
Given I open an editor "R…kmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKB_GESAMT_UE_VERW_002"
And I set fields
	| sofort	| ja	|
	| gut		| ja	|
	| mgr		| 112	|
    | lgr       | 1     |
    | bzeit     | 2     |
And I save the current editor

# Rückbau der gesamten mengen des BAs als Nachbuchung möglich. 
# alle uE-Werte des BAs, auch Fertigungszeiten, müssen im ue verworfen werden

Given I open an editor "Rückbau" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
# Given I open an editor "R…kbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for record "$,,nummer==1002002;gutmge==5;typ=Rückmeldung;@sort=Rückmeldung;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
And I set field "gutmge" to "-10" in row 1
And I set field "mge" to "-2" in row 2
And I save the current editor
