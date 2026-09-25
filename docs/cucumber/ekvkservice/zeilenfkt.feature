# *****************************************************************************
#  Name           : zeilenfkt.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Test von Zeilenfunktionen im EK/VK.
#                   Das Einfuegen und Loeschen von Zeilen wird unter bestimmten
#                   Vorraussetzungen eingeschraenkt,
#                   z.B. wenn Packmittel beteiligt sind oder Kostenumlagen usw.
#                   (Folgetest als Cucumbertest)
#
# *****************************************************************************
#
@persistent@persistent
Feature: Zeilenfunktionen im Einkauf/Verkauf
Background: Test Zeilenfunktionen
Given I set the fake date to "02.01.1995"

Scenario: Zeile loeschen verboten bei Kommando STORNO
Given I open an editor "RE01" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | RE01   |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | V1      | 10  |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Given I open an editor "RE01S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE01"
# Zeilen loeschen nicht erlaubt
Then deleting the row at position 1 throws the exception "4110"
# Zeilen einfuegen nicht erlaubt
Then creating a new row at position 1 throws the exception "3887"
And I close the current editor


Scenario: Zeile Veraendern in erleditgten Anfragen mit Ablageschutz nicht erlaubt
# in erledigten Anfragen mit Ablageschutz duerfen keine Zeilen an-/eingefuegt werden
Given I open an editor "AN01" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | kunde    | 1      |
   | such     | AN01   |
   | tterm    | .      |
   | vom      | .      |
And I append rows
   | artikel | mge |
   | V1      | 10  |
And I set field "noablage" to "ja"
And I save the current editor
Given I open an editor "AU01" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "AN01"
And I save the current editor
Given I open an editor "AN01U" from table "(Sales):(Quotation)" with command "UPDATE" for record from editor "AN01"
# nicht erlaubt
Then creating a new row at position 1 throws the exception "2687"
# darf nicht geloescht werden
Then deleting the row at position 1 throws the exception "111"
And I set field "noablage" to "nein"
And I create a new row at position 1
And I delete row at position 1
And I save the current editor
Then "(Sales):(Quotation)" with the editor id "AN01" is filed
# Teilweise erledigte Anfrage
Given I open an editor "AN02" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | kunde    | 1      |
   | such     | AN02   |
   | tterm    | .      |
   | vom      | .      |
And I append rows
   | artikel | mge |
   | V1      | 10  |
   | V2      | 5   |
And I set field "noablage" to "ja"
And I save the current editor
Given I open an editor "AU02" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "AN02"
# die Anfrage nur teilweise erledigen
And I delete row at position 2
And I save the current editor
Given I open an editor "AN02U" from table "(Sales):(Quotation)" with command "UPDATE" for record from editor "AN02"
# Bei teilw. erl. Anfrage Zeilenaenderung erlaubt
And I create a new row at position 1
And I delete row at position 1
And I close the current editor
Given I open an editor "AU02B" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "AN02"
# die Anfrage nun komplett erledigen
And I save the current editor
Given I open an editor "AN02U" from table "(Sales):(Quotation)" with command "UPDATE" for record from editor "AN02"
# nicht erlaubt
Then creating a new row at position 1 throws the exception "2687"
# darf nicht geloescht werden
Then deleting the row at position 1 throws the exception "111"
And I set field "noablage" to "nein"
And I create a new row at position 1
And I delete row at position 1
And I save the current editor
Then "(Sales):(Quotation)" with the editor id "AN02" is filed


Scenario: Zeile loeschen verbieten bei unterschiedlichen offenen LMENGE REMGE
#
# AU03 -----> LS03                 AU03
# (10)   \    (10)                 nicht loeschen
# (10)    \   (10)                 loeschen
# (10)     \                       loeschen, nach stornieren der Pos
#           --------> RE03
#                     (8)
#                     (10)
#
Given I open an editor "AU03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | AU03   |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | V1      | 10  |
   | V2      | 10  |
   | V3      | 10  |
And I save the current editor
Given I open an editor "LS03" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU03"
And I set fields
   | such   | LS03   |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I delete row at position 3
And I save the current editor
Given I open an editor "RE03" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU03"
And I set fields
   | such   | RE03   |
   | ueb    | true   |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "8" in row 1
And I set field "mge" to "10" in row 2
And I delete row at position 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Given I open an editor "AU03U" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AU03"
# Loeschen nicht moeglich remge != limge
# Darf nicht geloescht werden
Then deleting the row at position 1 throws the exception "111"
# Loeschen moeglich remge == limge
And I delete row at position 2
# Loeschen nicht moeglich, muss storniert werden
Then deleting the row at position 2 throws the exception "111"
# Wirklich stonrieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 2
And I delete row at position 2
And I save the current editor


Scenario: Zeile nicht loeschbar bei Verweis auf dyn. Kostenverteiler
Given I open an editor "RE04" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | RE04   |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge | kstelle     |
   | V1      | 10  | !dontChange |
   | V2      | 10  |             |
And I press button "dynkst" to open a subeditor for "Kostenverteiler" in row 2
And I append rows
   | kstelle | proz |
   | 101     |60    |
   | 100     |40    |
And I save the current editor
And I close the current editor
And I switch the current editor to editor "RE04"
# Schreibschutz wegen anhaengendem Kostenverteiler
Then deleting the row at position 2 throws the exception "355"
And I delete row at position 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


Scenario: Zeilen aendern bei versendetem Lieferabruf nicht erlaubt
## Vorgangsart Lieferabruf anlegen
Given I open an editor "LFABRUF" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "VORGANGSARTEK"
And I append rows
   | aufzelem | aebez       | aekbez      | aebezeichner |
   | LFABRUF  | Lieferabruf | Lieferabruf | Lieferabruf  |
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor
Given I open an editor "BE05" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS05   |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | V1      | 10  |
   | V2      | 10  |
And I delete row at position 1
And I set field "vorgartaz" to "Lieferabruf"
# Zeilen loeschen oder einfuegen bei versendeten Lieferscheinen nicht erlaubt
Then deleting the row at position 1 throws the exception "6791"
Then creating a new row at position 1 throws the exception "6791"
And I save the current editor


Scenario: Zeilen loeschen verbieten bei hinterlegten Kostenumlage
# Neutrale Zusatzposition anlegen
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "NEUTRAL"
And I set field "such" to "NEUTRAL"
And I set field "namebspr" to "Neutrale Position"
And I set field "zptyp" to "neutrale Position"
And I save the current editor
Given I open an editor "RE06" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | RE06   |
   | ebeleg | RE06   |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge         | pwert       |
   | E1      | 10          | !dontChange |
   | NEUTRAL | !dontChange | 100         |
   | E2      | 10          | !dontChange |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Given I open an editor "RE06U" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE06"
And I press button "kostenuml" to open a subeditor for "KUML" in row 2
And I set fields
   | umlagemeth | Wert |
   | fibuumbuch | ja   |
And I press button "ladetab"
And I delete row at position 2
And I save the current editor
And I switch the current editor to editor "RE06U"
And I delete row at position 3
# Zeile kann auf Grund einer vorhandenen Kostenumlage nicht geloescht werden
Then deleting the row at position 2 throws the exception "1753"
And I save the current editor


Scenario: Zeilen einfuegen bei Packmitteln eingeschraenkt
Given I open an editor "LS07" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | such   | LS07   |
   | ebeleg | LS07   |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | E1      | 10  |
   | E2      | 10  |

# Verschieben der Zeilen ist moeglich
And I move rows "1" to position "2"
And I move rows "2" to position "1"
And I delete row at position 2

And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "PALETTE2" in row 2
And I set field "mge" to "2" in row 2

# Verschieben nicht mehr moeglich, wenn Packmittel vorhanden sind
Then moving rows "1" to position "2" throws the exception "40"
And I save the current editor

Given I open an editor "LS07U" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS07"
# in dieser Zeile nicht erlaubt
Then creating a new row at position 2 throws the exception "2383"
And I close the current editor

Scenario: Zeilen einfuegen bei Packmitteln eingeschraenkt 2
# Zwischen Artikel und Packmittel duerfen Leerzeilen, Naturalrabatte, PRPO's und DELPO's stehen
Given I open an editor "LS08" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | such   | LS08   |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge |
   | V1      | 10  |
   | V2      | 10  |

And I press button "pmneu" in row 1
And I create a new row at position 2
And I set field "artikel" to "BEHAELTER" in row 2
And I set field "mge" to "1" in row 2
And I press button "pmneu" in row 3
And I create a new row at position 4
And I set field "artikel" to "BEHAELTER" in row 4
And I set field "mge" to "1" in row 4

And I create a new row at position 3
# In dieser Zeile nicht erlaubt
Then creating a new row at position 3 throws the exception "2383"
And I save the current editor
