# *****************************************************************************
#  Name             : kasb_storno_001_ek_vk.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : testet kaufm. GS und 'Wert'-GS
#
#
# *****************************************************************************

@persistent
Feature: STORNO und Kassenbuch
Background: Auswirkung von Storno im EK/VK und sonst auf Kassenbuch
Given I set the fake date to "07.02.2002"

@FALL-Einkauf1
Scenario: BE-RE-SRE

# eine Bestellung fuer Artikel anlegen
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001"
And I set field "nummer" to "300-BE"
And I set field "erfwaehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "10.00" in row 1
And I save the current editor


# Rechnung (Barzahlung) + verbuchen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "30RE"
And I set field "vorganga" to "Barzahlung"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kassenbuch pruefen
Given I open an editor "Kassenbuch" from table "(CashBook):(CashBook)" with command "VIEW" for record "1"
Then field "beinn" has value "0.00" in row !lastRow
Then field "bausg" has value "348.00" in row !lastRow
Then field "kassenbestand" has value "-333.00" in row !lastRow
Then field "isbestkorr" has value "ja" in row !lastRow
And I close the current editor

# Barrechnung stornieren
Given I open an editor "rechn-storno1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+30RE"
Then I set field "nummer" to "30SRE"
And I save the current editor
And I close the current editor

# Kassenbuch pruefen
Given I open an editor "Kassenbuch" from table "(CashBook):(CashBook)" with command "VIEW" for record "1"
Then field "beinn" has value "0.00" in row !lastRow
Then field "bausg" has value "-348.00" in row !lastRow
Then field "kassenbestand" has value "15.00" in row !lastRow
Then field "isbestkorr" has value "ja" in row !lastRow
And I close the current editor
#####################################################################################################################################

@FALL-Verkauf1
Scenario: AU-RE-SRE

# Auftrag anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "kunde" to "001"
And I set field "nummer" to "300-BE"
And I set field "waehr" to "EUR"
And I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "50.00" in row 1
And I save the current editor

# Rechnung (Barzahlung) + verbuchen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "nummer" to "30RE"
And I set field "vorganga" to "Barzahlung"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kassenbuch pruefen
Given I open an editor "Kassenbuch" from table "(CashBook):(CashBook)" with command "VIEW" for record "1"
Then field "beinn" has value "2900.00" in row !lastRow
Then field "bausg" has value "0.00" in row !lastRow
Then field "kassenbestand" has value "2915.00" in row !lastRow
Then field "isbestkorr" has value "ja" in row !lastRow
And I close the current editor

# Barrechnung stornieren
Given I open an editor "rechn-storno1" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+30RE"
Then I set field "nummer" to "30SRE"
And I save the current editor
And I close the current editor

# Kassenbuch pruefen
Given I open an editor "Kassenbuch" from table "(CashBook):(CashBook)" with command "VIEW" for record "1"
Then field "beinn" has value "-2900.00" in row !lastRow
Then field "bausg" has value "0.00" in row !lastRow
Then field "kassenbestand" has value "15.00" in row !lastRow
Then field "isbestkorr" has value "ja" in row !lastRow
And I close the current editor
#####################################################################################################################################



