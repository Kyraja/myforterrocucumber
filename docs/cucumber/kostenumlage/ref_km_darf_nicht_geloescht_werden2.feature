# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Funktion       : 
# *****************************************************************************
#
@persistent@persistent
Feature: Zeilenlöschung im Einkauf
Background: Test Zeilenfunktionen
Given I set the fake date to "02.01.2002"


# ------------------------------------------------------------------------------------------
Scenario: Neutrale Zusatzposition anlegen
# ------------------------------------------------------------------------------------------
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "NEUTRAL"
And I set field "such" to "NEUTRAL"
And I set field "namebspr" to "Neutrale Position"
And I set field "zptyp" to "neutrale Position"
And I save the current editor

# ------------------------------------------------------------------------------------------
Scenario: Zeilen loeschen verbieten bei hinterlegten Kostenumlage
# ------------------------------------------------------------------------------------------
Given I open an editor "BE06" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1546 |
   | lief   | 1      |
   | such   | BE06   |
   | ebeleg | BE06   |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge         | pwert       |
   | E1      | 10          | !dontChange |
   | NEUTRAL | !dontChange | 100         |
   | E2      | 10          | !dontChange |
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "BE06U" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE06"
And I press button "kostenuml" to open a subeditor for "KUML" in row 2
And I set fields
   | such       | BE06KM |
   | umlagemeth | Wert |
   | fibuumbuch | ja   |
And I press button "ladetab"
And I delete row at position 2
And I save the current editor


And I switch the current editor to editor "BE06U"
Then deleting the row at position 2 throws the exception "111"
# Wollen Sie diese Position wirklich stornieren?
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "s" in row 2
Then deleting the row at position 2 throws the exception "1753"
And I save the current editor

Given I open an editor "BE06KMCHECK" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "BE06KM"
Then field "kopf" has value "1546"
Then field "artikel" has value "E1" in row 1
Then field "mge" has value "10" in row 1
Then field "betr" has value "51.13" in row 1
And I close the current editor

# Hier direkte Löschung der Kostenumlage.
# Nur in der Bestellung muss die Kostenumlage vorab, so manuell, gelöscht werden, damit die
# EK-Position (= ihre Kostenquelle) auch gelöscht werden kann (im LS und i.d. RE läuft das besser, vgl. unten) 
Given I open an editor "BE06KMDEL" from table "(CostDistribution):(CostDistribution)" with command "DELETE" for record "BE06KM"
# wirklich löschen?
And I respond with answer "Ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "BE06UKM2" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE06"
And I delete row at position 2
And I save the current editor


Given I open an editor "BE06CHECK" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE06"
Then field "nummer" has value "1546"
Then the table has 2 rows
# die ehemalige neutrale Position (NEUTRAL) als Kostenquelle muß hier gelöscht sein:
Then field "artikel" has value "E1" in row 1
Then field "artikel" has value "E2" in row 2
And I close the current editor

# ------------------------------------------------------------------------------------------
Scenario: Zeilen loeschen verbieten bei hinterlegter Kostenumlage im neuen Liefschein
# ------------------------------------------------------------------------------------------
Given I open an editor "LS07KM" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 78754 |
   | lief   | 1    |
   | such   | LS07KM |
   | ebeleg | LS07KM |
   | tterm  | .    |
   | vom    | .    |
And I append rows
   | artikel | mge         | pwert       |
   | E1      | 12          | !dontChange |
   | NEUTRAL | !dontChange | 90          |
   | E2      | 6           | !dontChange |
And I save the current editor

Given I open an editor "LS07UKM" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS07KM"
And I press button "kostenuml" to open a subeditor for "KUMLLS" in row 2
And I set fields
   | umlagemeth | Wert |
   | fibuumbuch | ja   |
And I press button "ladetab"
And I delete row at position 2
And I save the current editor

And I switch the current editor to editor "LS07UKM"
Then deleting the row at position 2 throws the exception "1753"
And I set field "status" to "s" in row 2
And I respond with answer "Ja" to the dialog with id "1482"
And I delete row at position 2
And I save the current editor

Given I open an editor "LS07CHECK" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "LS07KM"
Then field "nummer" has value "78754"
Then the table has 2 rows
# die ehemalige neutrale Position (NEUTRAL) als Kostenquelle muß hier gelöscht sein:
Then field "artikel" has value "E1" in row 1
Then field "artikel" has value "E2" in row 2
And I close the current editor

# ------------------------------------------------------------------------------------------
Scenario: Zeilen loeschen verbieten bei hinterlegter Kostenumlage in neuer Rechnung
# ------------------------------------------------------------------------------------------
Given I open an editor "RE07KM" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 2467 |
   | lief   | 1    |
   | such   | RE07KM |
   | ebeleg | RE07KM |
   | tterm  | .    |
   | vom    | .    |
And I append rows
   | artikel | mge         | pwert       |
   | E1      | 15          | !dontChange |
   | NEUTRAL | !dontChange | 70          |
   | E2      | 3           | !dontChange |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "RE07UKM" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE07KM"
And I press button "kostenuml" to open a subeditor for "KUMLRE" in row 2
And I set fields
   | umlagemeth | Wert |
   | fibuumbuch | ja   |
And I press button "ladetab"
And I delete row at position 2
And I save the current editor

And I switch the current editor to editor "RE07UKM"
Then deleting the row at position 2 throws the exception "1753"
And I set field "status" to "s" in row 2
And I respond with answer "Ja" to the dialog with id "1482"
And I delete row at position 2
And I save the current editor

Given I open an editor "RE07CHECK" from table "(Purchasing):(Invoice)" with command "VIEW" for record "RE07KM"
Then field "nummer" has value "2467"
# zeilen mit nettosumme etc.
Then the table has 5 rows
# die ehemalige neutrale Position (NEUTRAL) als Kostenquelle muß hier gelöscht sein:
Then field "artikel" has value "E1" in row 1
Then field "artikel" has value "E2" in row 2
Then field "artikel" has value "NS." in row 3
And I close the current editor
