# *****************************************************************************
#  Name             : ref_fe_storno_bewertungssicht_01_man_lbu.feature
#  Autor            : wane
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : Testet Prozesse Storno einer Lagerbuchung
#
# *****************************************************************************
@persistent
Feature: Storno Lagerbuchung (Bewertung)
Background: Test von Stornos in der Fertigung
Given I set the fake date to "07.01.2002"


Scenario Outline: 01 Storno einer LBuchung (Abgang, Zugang, Umbuchung) mit Verbuchung; Testumgebung 1-3

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "<case>" with Price "10.13" in the Area "<area>"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "<case>" in the Area "<area>"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "<case>" in the Area "<area>"

# EK-Rechnung verbuchen
Given I create an invoice for the Test Case "<case>" with Quantity "<case>" per Price "10.57" to the PurchasingPackingSlip in the Area "<area>"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "<case>" in the Area "<area>"

# Lagerbuchungen buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel   | <artikel> |
    | buart     | <buart>   |
    | beleg     | <beleg>   |
    | beldat    | .         |
And I modify table
    | mge   | platz     | platz2    | !row  |
    | 10    | <platz>   | <platz2>  | +1    |
And I save the current editor


# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "<bewertung>"
Then field "nachfolger" is empty
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "<case>" in the Area "<area>" with Command Revalue

# Lagerbuchungen stornieren
Given I open an editor "LbuchungSt" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"
Then field "buart" has value "<buart>"
Then table has values
	| mge	| platz		| platz2	| 
	| -10	| <platz>	| <platz2>	|
And I save the current editor

# LJ pruefen, zweite Zeile nur fuer Umbuchung relevant
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values
    | amge      | zmge      | nplatz    | vplatz    | detursache                 | !row  |
    | <amge1>   | <zmge>    | <platz2>  | <vplatz1> | <detursache>               | 1     |
    | <amge2>   |           |           | <vplatz2> | Storno manuelle Umbuchung  | <row> |
Then field "storniert" has value "ja" in row <stornorow>
Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row <stornorow>
And I close the current editor


# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "<case>" in the Area "<area>" with Command Revalue


Examples:
| buart     | artikel | case | area | beleg     | platz         | platz2        | vplatz1       | vplatz2       | amge1 | zmge  | amge2         | row           | stornorow | detursache                   | bewertung |
| Zugang    | 0efall1 | 10   | 1    | LB01-Z    | !dontChange   | F1            | !dontChange   | F1            |       | -10   | !dontChange   | !dontChange   | 2         | Storno manuelle Lagerbuchung | $,,detursache=Manueller Zugang;artikel=0efall1;@richtung=rückwärts;@maxtreffer=1   |
| Abgang    | 0efall2 | 11   | 2    | LB01-A    | F1            | !dontChange   | F1            | !dontChange   |  -10  |       | !dontChange   | !dontChange   | 2         | Storno manuelle Lagerbuchung | $,,detursache=Manueller Abgang;artikel=0efall2;@richtung=rückwärts;@maxtreffer=1   |
| Umbuchung | 0efall3 | 12   | 3    | LB01-U    | F1            | F2            | !dontChange   | F1            |       | -10   | -10           | 2             | 3         | Storno manuelle Umbuchung    | $,,detursache=Manuelle Umbuchung;artikel=0efall3;@richtung=rückwärts;@maxtreffer=1 |
###########################################################################################################


Scenario: 07 Storno einer LBuchung mit Jokerbestand mit Verbuchung; Testumgebung 4

Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "0efall4"
And I set fields
    | dispoa    | auftragsbezogen |
    | efrist    | 2               |
    | epr       | 25              |
    | chimlager | ja              |
    | chverfolgung | Chargenverfolgung              |
And I save the current editor

# Bestellung anlegen
Given I create an PurchaseOrder for the Test Case "200" with Price "121.12" in the Area "4"

# Lieferschein zu Bestellung anlegen
Given I create a PurchasingPackingSlip for the Test Case "200" in the Area "4"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "4"

# EK-Rechnung verbuchen
Given I create an invoice for the Test Case "200" with Quantity "200" per Price "200.01" to the PurchasingPackingSlip in the Area "4"

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "4"

# Verkaufsrechnung mit Lagerbewegung
Given I open an editor "vk-rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "200-RE"
And I set field "kunde" to "001fa4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-BW200"
And I create a new row at the end of the table
And I set field "artikel" to "0efall4" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "233.33" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "4"

# Lagerbuchungen buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel   | 0efall4   |
    | buart     | Zugang    |
    | beleg     | Zugang06  |
    | beldat    | .         |
And I append rows
    | mge   | verw          | platz2    | 
    | 10    |               | F1        |
    | 10    | Zugangsverw2  | F1        | 
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "4" with Command Revalue

# Lagerbuchungen buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel   | 0efall4   |
    | buart     | Abgang    |
    | beleg     | Abgang06  |
    | beldat    | .         |
And I append rows
    | mge   | verw          | platz | 
    | 20    | Zugangsverw2  | F1    |
And I save the current editor


# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "4" with Command Revalue

# Lagerbuchungen stornieren
Given I open an editor "LbuchungSt" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "Abgang06"
Then field "buart" has value "Abgang"
Then table has values
    | mge   | verw          | platz |
    | -20   | Zugangsverw2  | F1    |
And I save the current editor

# stornierter manueller Abgang einfuegen
# LJ pruefen
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "Abgang06"
And I press start
Then table has values   
    | amge      | verw          | verwla        | detursache                    |
    | -10       | Zugangsverw2  |               | Storno manuelle Lagerbuchung  |
    | -10       | Zugangsverw2  | Zugangsverw2  | Storno manuelle Lagerbuchung  |
Then table has values
    | !row  | storniert |
    | 3     | ja        |
    | 4     | ja        |
Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
And I close the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "200" in the Area "4" with Command Revalue

# Bewertung hat Nachfolger bekommen
# Step Bewertung
