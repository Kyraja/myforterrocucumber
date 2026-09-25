# ***************************************************************************
#
#  Name      : berechnet_nicht_geliefert_evkonto_leer.feature
#  Datum     : 04.04.2025
#  Autor     : sih
#  Verantwortlich : wane
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - leeres Einkaufskonto
#              Bestellung (Mene 100) - Lieferschein (Menge 5) - Rechnung (Menge 20)
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto "Berechnet, nicht geliefert"; leeres Einkaufskonto
Background:
Given I set the fake date to "02.01.2002"

Scenario: Rechnung

# 01 Bestellung
Given I open an editor "100BE" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 100BE   |
   | lief    | 001fa1  |
And I append rows
   | artikel   | mge |  preis |
   | E1        | 100 |  10,00 |
And I save the current editor

# 02 Lieferschein
Given I open an editor "100LS" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "100BE"
And I set fields
   | nummer | 100LS   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
And I save the current editor

# 03 Rechnung
Given I open an editor "100RE" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "100BE"
And I set fields
   | nummer | 100RE |
   | ueb    | ja      |
   | vom    | .       |
#
Then field "konto" has value "10000" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "zwischenkonto" has value "" in row 1
#
And I set field "mge" to "20" in row 1
#
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "zwischenkonto" has value "36301" in row 1
#
And I set field "mge" to "0" in row 1
# 3561 TX=de   |Das Feld darf nicht geleert werden. Bitte ein gueltiges Konto eintragen.
# 1361 TX=de   |Ungueltiger Feldwert
Then setting field "konto" to "" in row 1 throws the exception "3561"
And I set field "mge" to "20" in row 1
# 
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "zwischenkonto" has value "36301" in row 1
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
# #######################################################################################


Scenario: Lieferschein

# 01 Bestellung
Given I open an editor "200BE" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 200BE   |
   | lief    | 001fa2  |
And I append rows
   | artikel   | mge |  preis |
   | E1        | 100 |  10,00 |
And I save the current editor

# 02 Lieferschein
Given I open an editor "200LS" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "200BE"
And I set fields
   | nummer | 200LS   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "5" in row 1
Then field "konto" has value "10000" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "zwischenkonto" has value "36301" in row 1
#
# 3561 TX=de   |Das Feld darf nicht geleert werden. Bitte ein gueltiges Konto eintragen.
# 1361 TX=de   |Ungueltiger Feldwert
Then setting field "konto" to "" in row 1 throws the exception "3561"
#
Then field "konto" has value "10000" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "zwischenkonto" has value "36301" in row 1
And I save the current editor
# #######################################################################################


Scenario: Vererbung aus der Bestellung

# 01 Bestellung
Given I open an editor "300BE" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 300BE   |
   | lief    | 001fa3  |
And I append rows
   | artikel   | mge |  preis |
   | E1        | 100 |  10,00 |
And I set field "konto" to "" in row 1
Then field "konto" has value "" in row 1
Then field "fixkonto" has value "ja" in row 1
And I save the current editor

# 02 Rechnung
Given I open an editor "300RE" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "300BE"
And I set fields
   | nummer | 300RE   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "55" in row 1
Then field "konto" has value "" in row 1
Then field "vorgangskonto" has value "" in row 1
Then field "zwischenkonto" has value "" in row 1
Then field "fixkonto" has value "ja" in row 1
#
# 4171 |Konto in der Position fehlt, bitte Rechnungsmenge voruebergehend auf 0 setzen und die Fixierung des Kontos entfernen.
And saving the current editor throws the exception "4171"
And I set field "mge" to "0" in row 1
And I set field "fixkonto" to "nein" in row 1
And I set field "mge" to "55" in row 1
Then field "konto" has value "36301" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "vorgangskonto" has value "10000" in row 1
Then field "zwischenkonto" has value "36301" in row 1
#
Then the table has 2 rows
# Steuerzeile loeschen
And I delete row at position 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
# #######################################################################################
