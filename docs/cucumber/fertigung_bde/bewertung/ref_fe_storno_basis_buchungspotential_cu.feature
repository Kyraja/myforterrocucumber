# *****************************************************************************
#  Autor            : lschneider
#  Verantwortlich   : uo
#  Kontrolle        : wane
# *****************************************************************************
# die ursprünglichen feature-dateien von lschneider wurden auf die erforderlichen
# scenarien gekürzt, nov./2019

@persistent
Feature: Bewertungsketten für uE-Buchungspotentialprüfung aufbauen

Background:
And I set the fake date to "03.02.1995"

Scenario Outline: 01 A Fertigartikel, die auf unterschiedliche Lagerplätze gebucht wurden, werden nach Storno wieder zurückgebucht
# Material zubuchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| <artikel>	|
	| beleg		| 01		|
	| beldat	| .			|
	| buart		| Zugang	|
And I append rows
	| mge	| 
	| <mge>	|
And I save the current editor

Examples:
| artikel	| mge	|
| EINKAUF-1	| 20	|
| EINKAUF-2	| 10	|

Scenario: 06 Komponenten aus MZ kann über Storno-Rückmeldung in einen gesperrten Behälter zurückgelegt werden Status geht auf leer
# Bestände korrigieren, Auftrag erstellen
Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "X1"



# ******* DIESES SCENARIO WIRD BENÖTIGT DAMIT IN DER BESTANDKORREKTUR MIT SUCHWORT LBK0-BG-02 (lj) 
#         MINDESTENS 2 ZEILEN ENTSTEHEN, DENN IM NACHFOLGERTEST "POTENIAL" WIRD ZEILE 2 BENÖTIGT.

Scenario: 01 In einer Storno-Rückmeldung sind alle Felder zu Mengen-, Zeit- und Artikelangaben schreibgeschützt
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel	| netmge	| bisuch	| mfreig	|
	| BAUGRUPPE	| 10		| SCHUTZ_	| ja		|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHUTZ_001"
And I set field "sofort" to "1"
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Erste Rückmeldung stornieren, Schreibschutz auf Feldern prüfen
And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
Then fields have values
	| sofort	| ja	|
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

# Rückmeldung zweiter Arbeitsgang, Betriebsauftrag abschließen
Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHUTZ_001"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I save the current editor


Scenario: 11 Wurden über die Rückmeldung Restmengen storniert, werden diese bei einem Storno nicht wieder erhöht
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel		| netmge	| mfreig	|
	| BAUGRUPPE2	| 10		| ja		|
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I set field "manbu" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "fvor"
And I set field "bisuch" to "RESTMENGE_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Teil-Rückmeldung auf ersten Arbeitsgang, Restmengen stornieren
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RESTMENGE_001"
And I set field "gutmge" to "5" in row 1
And I set field "stornorest" to "ja"
And I set field "sofort" to "1"
And I save the current editor

# Erste Rückmeldung stornieren
And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
And I save the current editor

# Offene Menge in AFL prüfen und BA abschließen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RESTMENGE_000"
And I press button "absteig" to open a subeditor for "AFL_pruef"
Then field "limge" has value "0" in row 1
Then field "limge" has value "10" in row 2
And I close the current editor
And I switch the current editor to editor "Betriebsauftrag"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor



# FDA-980: Typ im Storno-Beleg wird falsch gesetzt (Zeile 579)
Scenario: A03 Durch den Storno auf einen abgelegten FV werden die Belegtypen korrekt gesetzt
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel	| netmge	| bisuch	| mfreig	|
	| BAUGRUPPE	| 10		| TYPA_		| ja		|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYPA_001"
And I set field "sofort" to "1"
And I set field "gutmge" to "5" in row 1
And I save the current editor
And I wait 1 time units to move the time forward

Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYPA_001"
And I set field "sofort" to "1"
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Erste Rückmeldung stornieren, Typen prüfen: Storno-Rückmeldung auf abeglegten FV und stornierte Rückmeldung
Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
Then field "typa279" has value "Storno-Rückmeldung auf abgelegten Fertigungsvorschlag"
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1"
And I save the current editor
Then field "typa279" from editor "Rückmeldung1" in row 0 has value "Stornierte Rückmeldung"

# Nachbuchen auf abgelegten FV
Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
And I set field "gutmge" to "5" in row 1
Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
And I save the current editor

# Nachgebuchte Rückmeldung stornieren, Typen prüfen: Storno-Rückmeldung auf abeglegten FV und stornierte Rückmeldung auf abgelegten FV
Given I open an editor "Storno2" via ID from editor "Rückmeldung3" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
Then field "typa279" has value "Storno-Rückmeldung auf abgelegten Fertigungsvorschlag"
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung3"
And I save the current editor
Then field "typa279" from editor "Rückmeldung3" in row 0 has value "Stornierte Rückmeldung auf abgelegten Fertigungsvorschlag"















Scenario: 01 Storno einer Rückmeldung über die gesamte Gutemenge, Teile retrograd entnommen
# Bestand auf 0 korrigieren
Given I set StorageQuantity to zero for Product "BAUGRUPPE2" on StorageLocation "F1"
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel		| netmge	| bisuch	| mfreig	| binoloe	|
	| BAUGRUPPE2	| 10		| RETRO_	| ja		| ja		|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETRO_001"
And I set fields
	| sofort	| 1		|
	| bzeit		| 1,5	|
	| mzeit		| 1,5	|
	| gut		| 1		| 
And I save the current editor

# Bewertung Rückmeldung1
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE2;detursache=`;@richtung=rückwärts;@maxtreffer=1"
Then field "ppsrefid" has value equal to field "id" from editor "Rückmeldung1"
And I close the current editor

# Erste Rückmeldung stornieren
Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# Offene Mengen Material und Arbeitsgänge prüfen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RETRO_000"
Then fields have values
	| mge		| 10	|
	| rgutmge	| 0		|
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
	| limge	| gmge	|
	| 20	| 20	|
	| 10	| 1.75	|
	| 10	| 10	|
	| 10	| 1.25	|
And I close the current editor
And I switch the current editor to editor "Betriebsauftrag"
And I set field "noloesch" to "nein"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor


Scenario: 02 Storno einer Teil-Rückmeldung, Teile retrograd entnommen
# Bestand auf 0 korrigieren
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-02"
# Fertigungsvorschlag anlegen und freigeben


Scenario: 03 Storno einer Rückmeldung über die gesamte Gutemenge, Teile manuell entnommen
# Bestandskorrektur
Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
And I set fields
	| artikel	| M_BAUGRUPPE	|
	| beleg		| B_03			|
	| beldat	| .				|
And I set field "platz" to "F1" in row 1
And I modify table
	| !row			| mge	|
	| platz=='F1'	| 0		| 
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel		| netmge	| mfreig	| bisuch	| binoloe	|
	| M_BAUGRUPPE	| 10		| ja		| MANBU_	| ja		|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Betriebsauftrag aufrufen für BA-Nummer
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MANBU_000"
Then field "nummer" is not empty
And I close the current editor

# Materialentnahme für Betriebsauftrag
Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "nummer" from editor "Betriebsauftrag"
And I press button "stllad"
And I set field "mgr" to "112"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANBU_001"
And I set field "gut" to "1"
And I set field "bzeit" to "1,5"
And I set field "mzeit" to "1,5"
And I set field "sofort" to "1"
And I save the current editor


# Erste Rückmeldung stornieren
Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0


# Betriebsauftrag abschließen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MANBU_000"
Then field "mge" has value "10"
Then field "rgutmge" has value "0"
And I press button "absteig" to open a subeditor for "AFL"
Then field "limge" has value "0" in row 1
Then field "limge" has value "0" in row 2
Then field "gmge" has value "1.25" in row 3
Then field "limge" has value "10" in row 3
And I close the current editor
And I switch the current editor to editor "Betriebsauftrag"
And I set field "noloesch" to "nein"
And I respond with answer "JA" to the dialog with id "1483"
And I set field "status" to "s"
And I save the current editor


Scenario: 06 Storno einer Rückmeldung mit Zeitmeldung und gesamter Gutmenge
# Bestandskorrektur
Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
And I set fields
	| artikel	| BAUGRUPPE2	|
	| beleg		| B_06			|
	| beldat	| .				|
And I set field "platz" to "F1" in row 1
And I modify table
	| !row			| mge	|
	| platz=='F1'	| 0		| 
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel		| netmge	| bisuch	| mfreig	| binoloe	|
	| BAUGRUPPE2	| 10		| ZEITMGE_	| ja		| ja		|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor


# Zeit-Rückmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZEITMGE_001"
And I set field "gut" to "ja"
And I set field "mzeit" in row 0 to "vzeit" from editor "Rückmeldung1" in row 0
And I set field "bzeit" in row 0 to "vzeit" from editor "Rückmeldung1" in row 0
And I set field "sofort" to "1"
And I save the current editor


# Rückmeldung stornieren
Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
Then field "mzeit" has value "-1.75"
Then field "bzeit" has value "-1.75"
Then field "gutmge" has value "-10" in row 1
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0


# Betriebsauftrag abschließen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITMGE_000"
And I set field "noloesch" to "nein"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor


# ********* zu diesem scenario besteht eine querabhängigkeit, es könnte nur mit weiterer 
#           analyse entfernt werden 
Scenario: 07 Fertigartikel mit Charge und Verwendung werden nach Storno vom Lager abgebucht
# Bestand auf 0 korrigieren
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "BK0-BG-07"
# Chargen anlegen
Given I open an editor "Charge" from table "(Lots):(Lots)" with command "STORE" for record "CHARGE_R"
And I set fields
	| such		| CHARGE_R	|
	| exnum		| 11833		|
	| artikel	| BAUGRUPPE	|
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde		| RADSHOP|
And I append rows
	| artikel	| mge	| charge	|
	| BAUGRUPPE	| 10	| CHARGE_R	|
And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste" in row 1
And I save the current editor
And I switch the current editor to editor "auftrag"
And I save the current editor

And I run Scheduling

# Fertigungsvorschlag freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BAUGRUPPE"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row !lastRow
And I set field "bisuch" to "CHVERW_" in row !lastRow
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVERW_001"
And I set fields
	| kcharge	| CHARGE_R	|
	| sofort	| 1			|
And I set field "bem" in row 0 to "verw" from editor "auftrag" in row 1
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Erste Rückmeldung stornieren
Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0


# Betriebsauftrag und Auftrag abschließen
Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHVERW_000"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I set field "mgr" to "112"
And I save the current editor

And I switch the current editor to editor "auftrag" with command "DELIVERY"
And I set field "mge" to "10" in row 1
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 20 Gebuchte Sonderkosten werden bei einem Storno einer Rückmeldung storniert und in der nächsten Rückmeldung erneut gebucht
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel	| netmge	| bisuch	| mfreig	|
	| BAUGRUPPE | 10		| SONDERK_	| ja		|
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SONDERK_001"
And I set fields
	| sofort	| ja	|
	| skostfix	| 100	|
	| skostvar	| 70	|
And I set field "erbtext1" to "SONDERK_001" in row 1
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Erste Rückmeldung stornieren
Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1" in row 0

# erneut Rückmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SONDERK_001"
And I set fields
	| sofort	| ja	|
	| skostfix	| 100	|
	| skostvar	| 70	|
And I set field "erbtext1" to "SONDERK_001" in row 1
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Betriebsauftrag abschließen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SONDERK_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor
