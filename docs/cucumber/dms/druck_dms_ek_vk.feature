Feature: DMS in Kombination mit der EK/VK-Kette
# Beim Erstellen von einem Vorgang aus einem VorgÃ¤nger wird die Identnummer bei der Neuanlage beibehalten
Background: druck_dms_ek_vk_drbelegart.feature

Scenario Outline: Belegart bei Stonolieferschein und Ruecklieferung mit Druckjob

Given I open an editor "Original" from table "<editor>" with command "NEW" for record ""
And I set fields
	| nummer | <row> |
	| kl     | 1     |
	| tterm  | .     |
And I append rows
	| artikel | mge | preis |
	| V1      | 5   | 35,45 |
And I set field "ueb" to "<ueb>"
And I save the current editor
And I close the current editor
Given I open an editor "Kopie" from table "<editor>" with command "<command>" for record "<row>"
Then field "drbelegart" has value ""
Then field "dndbelegart" has value ""
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I respond with answer "Yes" to the dialog with id "8955"
And I set fields
	| layout  | <layout>       |
	| drucker | datei          |
	| datname | rmtmp/test.pdf |
And I save the current editor
And I close the current editor

Examples:
| row | editor                     | feld      | command  | layout    | ueb         | new  |
| 001 | (Sales):(PackingSlip)      | rueckdoku | REVERSAL | LSMASTER  | ja          | +001 |
| 002 | (Sales):(PackingSlip)      | rueckdoku | RETURN   | LSMASTER  | ja          | +002 |

# Scenario Outline: Belegart bei Stornorechunng und mit Druckjob
#
# Given I open an editor "Original" from table "<editor>" with command "NEW" for record ""
# And I set fields
# 	| nummer | <row> |
# 	| kl     | 1     |
# 	| tterm  | .     |
# And I append rows
# 	| artikel | mge | preis |
# 	| V1      | 5   | 35,45 |
# And I set field "ueb" to "ja"
# And I respond with answer "Yes" to the dialog with id "4841"
# And I save the current editor
# And I close the current editor
# Given I open an editor "Kopie" from table "<editor>" with command "<command>" for record "+<row>"
# Then field "drbelegart" has value ""
# Then field "dndbelegart" has value ""
# And I press button "budruck2" to open a subeditor for "Druckdialog"
# And I respond with answer "Yes" to the dialog with id "8955"
# And I set fields
# 	| layout  | <layout>       |
# 	| drucker | datei          |
# 	| datname | rmtmp/test.pdf |
# And I save the current editor
#
# Hier fehlt der Example Block - Bitte ergaenzen und Testfall reaktivieren
# Dieser Testfall ist bisher nie gelaufen

Scenario Outline: EK Vorgaenge anlegen
Given I open an editor "Neuanlage" from table "<editor>" with command "NEW" for record ""
And I set fields
	| nummer | <nummer> |
	| kl     | 1        |
	| tterm  | .        |
And I append rows
	| artikel | mge | preis |
	| E1      | 20  | 35,45 |
And I save the current editor
And I close the current editor

Examples:
| row | editor                       | nummer      |
| 001 | (Purchasing):(Request)       | 1110        |
| 002 | (Purchasing):(PurchaseOrder) | 1111        |

Scenario Outline: Vorgangskette EK anlegen, Barcode zuordnen vor dem Speichern
Given I open an editor "Ziel" from table "<quelleditor>" with command "<kommando>" for record "<quelle>"
And I set fields
	| nummer | <nummer>  |
	| such   | C<nummer> |
	| vom    | .         |
And I set field "mge" to "<mge>" in row 1
Then field "drbelegart" has value "<idrbelegart>"
Then field "dndbelegart" has value "<ibelegart>"
And I set fields
	| dndbelegart | <belegartneu> |
	| barcode     | <barcode>     |
	| ueb         | <ueb>         |
And I save the current editor
And I close the current editor
Given I open an editor "Ansicht" from table "<editor>" with command "VIEW" for record "C<nummer>"
Then field "drbelegart" has value "<drbelegart>"
Then field "dndbelegart" has value "<belegart>"
Then field "doku^belegart" has value "<belegartdoku>"
And I close the current editor

Examples:
| row | quelle | nummer | kommando | mge         | barcode  | belegartneu     | idrbelegart     | ibelegart       | drbelegart      | belegart        | belegart        | belegart        | belegartdoku    | quelleditor                 | editor                      | ueb         |
| 001 | 1110   | 2110   | RELEASE  | 5           | 8890022x | !dontChange     | EKBESTELLUNG    | EKAUFTRAGSBEST  | EKBESTELLUNG    | EKAUFTRAGSBEST  | EKAUFTRAGSBEST  | EKAUFTRAGSBEST  | EKAUFTRAGSBEST  | (Purchasing):(Request)      | (Purchasing):(PurchaseOrder)| !dontChange |
| 002 | 1111   | 5111   | DELIVERY | 5           | 8890000x | EKKORRESPONDENZ |                 |                 | EKLIEFERSCHEIN  | EKLIEFERSCHEIN  | EKLIEFERSCHEIN  | EKLIEFERSCHEIN  | EKKORRESPONDENZ | (Purchasing):(PurchaseOrder)| (Purchasing):(PackingSlip)  | !dontChange |
| 003 | 1111   | 2111   | DELIVERY | 5           | 8877000x | !dontChange     |                 |                 | EKLIEFERSCHEIN  | EKLIEFERSCHEIN  | EKLIEFERSCHEIN  | EKLIEFERSCHEIN  | EKLIEFERSCHEIN  | (Purchasing):(PurchaseOrder)| (Purchasing):(PackingSlip)  | ja          |

# Scenario Outline: Rechnung EK anlegen, Barcode zuordnen vor dem Speichern
# Given I open an editor "Ziel" from table "<quelleditor>" with command "<kommando>" for record "<quelle>"
# And I set fields
# 	| nummer | <nummer>  |
# 	| such   | C<nummer> |
#
# Hier fehlt der Example Block - Bitte ergaenzen und Testfall reaktivieren
# Dieser Testfall ist bisher nie gelaufen

Scenario Outline: Vorgangskette EK anlegen, Barcode zuordnen vor dem Speichern
Given I open an editor "Ziel" from table "<quelleditor>" with command "<kommando>" for record "<quelle>"
And I set fields
	| nummer | <nummer>  |
	| such   | C<nummer> |
	| vom    | .         |
	| budat  | 07.01.95  |
And I set field "mge" to "<mge>" in row 1
Then field "drbelegart" has value "<idrbelegart>"
Then field "dndbelegart" has value "<ibelegart>"
And I set fields
	| dndbelegart | <belegartneu> |
	| barcode     | <barcode>     |
And I respond with answer "Yes" to the dialog with id "4841"
And I save the current editor
And I close the current editor
Given I open an editor "Ansicht" from table "<editor>" with command "VIEW" for record "C<nummer>"
Then field "drbelegart" has value "<drbelegart>"
Then field "dndbelegart" has value "<belegart>"
Then field "doku^belegart" has value "<belegartdoku>"
And I close the current editor

Examples:
| row | quelle | nummer | kommando | mge         | barcode  | belegartneu     | idrbelegart     | ibelegart       | drbelegart      | belegart        | belegart        | belegart        | belegartdoku    | quelleditor                 | editor                      | ueb         |
| 001 | 1111   | 3111   | INVOICE  | 5           | 8888000x | !dontChange     |                 |                 | EKRECHNUNG      | EKRECHNUNG      | EKRECHNUNG      | EKRECHNUNG      | EKRECHNUNG      | (Purchasing):(PurchaseOrder)| (Purchasing):(Invoice)      | !dontChange |

Scenario: EK Stornorechunung mit Barcode
Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "C3111"
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor
Given I open an editor "Stronorechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+3111"
And I set field "nummer" to "6111"
Then field "drbelegart" has value ""
Then field "dndbelegart" has value ""
And I set field "barcode" to "8888777x"
And I save the current editor
And I close the current editor
Given I open an editor "Ansicht" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+6111"
Then field "drbelegart" has value "EKSTORNORECHNUNG"
Then field "dndbelegart" has value "EKSTORNORECHNUNG"
Then field "doku^belegart" has value "EKSTORNORECHNUNG"
And I close the current editor

Scenario: Lieferschein kopieren
Given I open an editor "Lieferschein" from table "(Purchasing):(PackingSlip)" with command "COPY" for record "C2111"
Then field "drbelegart" has value "EKLIEFERSCHEIN"
Then field "dndbelegart" has value "EKLIEFERSCHEIN"
Then field "doku" is empty
And I close the current editor

