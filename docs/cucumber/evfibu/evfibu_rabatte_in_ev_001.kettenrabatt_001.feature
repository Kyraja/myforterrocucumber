# *****************************************************************************
#  Name             : evfibu_rabatte_in_ev_001.kettenrabatt_001.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : teampss
#  Funktion         : Test der Kontierung von Preisfindungspositionen im EK/VK
#
# *****************************************************************************

@persistent
Feature: evfibu_rabatte_in_ev_001.kettenrabatt_001.feature
Background:
Given I set the fake date to "01.07.2002"

@FALL-Stammdaten
Scenario: Stammdaten

Given I open an editor "rabatt" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
   | nummer  | 001             |
   | typ     | Verkauf Rabatte |
   | separat | ja              |
   | kettrab | ja              |
   | klpg    | 001             |
   | mgeab   | ja              |
And I append rows
   | mproz |
   | -55   |
And I save the current editor

Given I open an editor "rabatt" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
   | nummer  | 002             |
   | typ     | Einkauf Rabatte |
   | separat | ja              |
   | kettrab | ja              |
   | klpg    | 001             |
   | mgeab   | ja              |
And I append rows
   | mproz |
   | -25   |
And I save the current editor

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "001"
And I set field "prg" to "001"
And I set field "rab" to "001"
And I save the current editor

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "001"
And I set field "prg" to "001"
And I set field "rab" to "002"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10000a"
And I save the current editor

Given I open an editor "pgruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "66a"
And I set field "pgerlo" to "45100"
And I set field "pgkst" to "100"
And I save the current editor

Given I open an editor "wgruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "55a"
And I set field "bestausekso" to "10000a"
And I set field "bestausfert" to "10000a"
And I set field "wgkst" to "100"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "erlgrp" to "66a"
And I set field "wgruppe" to "55a"
And I set field "lief" to "001"
And I set field "epr" to "10"
And I save the current editor

###################################################################################################

@FALL-BE-LS-RE
Scenario: Einkauf; BE-LS-RE -> ueber Beleg anfuegen

Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "100" in row 1
And I set field "intrarel" to "nein" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 10000a |         | 1000.00 | nein     | nein       | nein     |
   | 10000a |         | -250.00 | nein     | nein       | nein     |
And I save the current editor

# Bestellung in Lieferschein ueberfuehren
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "vom" to "."
And I set field "num" to "100ls"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 10000a |         | 1000.00 | nein     | nein       | ja       |
   | 10000a |         | -250.00 | nein     | nein       | ja       |
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein"
And I set field "num" to "100re"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 10000a |         | 1000.00 | nein     | nein       | ja       |
   | 10000a |         | -250.00 | nein     | nein       | ja       |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

###################################################################################################

@FALL-AU-LS-RE
Scenario: Verkauf; AU-LS-RE -> ueber Beleg anfuegen

Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "20" in row 1
And I set field "intrarel" to "nein" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 45100  | 100     | 978.00  | nein     | nein       | nein     |
   | 45100  | 100     | -537.90 | nein     | nein       | nein     |
And I save the current editor

# Auftrag in Lieferschein ueberfuehren
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 45100  | 100     | 978.00  | nein     | nein       | ja       |
   | 45100  | 100     | -537.90 | nein     | nein       | ja       |
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 45100  | 100     | 978.00  | nein     | nein       | ja       |
   | 45100  | 100     | -537.90 | nein     | nein       | ja       |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

###################################################################################################

@FALL-AU-RE
Scenario: Verkauf; AU-RE -> ueber Beleg anfuegen

Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "20" in row 1
And I set field "intrarel" to "nein" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 45100  | 100     | 978.00  | nein     | nein       | nein     |
   | 45100  | 100     | -537.90 | nein     | nein       | nein     |
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 45100  | 100     | 978.00  | nein     | nein       | ja       |
   | 45100  | 100     | -537.90 | nein     | nein       | ja       |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

###################################################################################################

@FALL-AU-RE
Scenario: Verkauf; AU-RE -> aus Vorgang

Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "6000a"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "20" in row 1
And I set field "intrarel" to "nein" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 45100  | 100     | 978.00  | nein     | nein       | nein     |
   | 45100  | 100     | -537.90 | nein     | nein       | nein     |
And I save the current editor

# Lieferschein in Rechnung ueberfuehren
Given I open an editor "rechnung2" from table "(Sales):(Invoice)" with command "NEW" for record "6000a"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then table has values
   | konto  | kstelle | pwert   | fixkonto | fixkstelle | fixpwert |
   | 45100  | 100     | 978.00  | nein     | nein       | ja       |
   | 45100  | 100     | -537.90 | nein     | nein       | ja       |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


###################################################################################################

@FALL-VK-RE-FIXKONTO
Scenario: Verkauf; RE -> Konto in Rabattpositionen wird nicht fixiert

# Rabatt anlegen
Given I open an editor "vk_rabatt" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
    | such    | vk_rabatt       |
    | typ     | Verkauf Rabatte |
    | artpg   | 301             |
    | klpg    | 1               |
    | separat | ja              |
    | mgeab   | ja              |
And I delete all rows
And I append rows
    | mgrenze | mproz |
    | 1       | -10   |
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde   | 1                           |
    | kl2     | 1                           |
    | betreff | Rechnung mit Rabattposition |
    | zbed    | 200                         |
And I create a new row at the end of the table
And I set field "artex" to "301" in row 1
And I set field "mge" to "10" in row 1
Then the table has 2 rows
Then field "konto" has value "44000" in row 2
And I set field "konto" to "43000" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "konto" has value "43000" in row 2
Then field "fixkonto" has value "ja" in row 2
# Konto aendern
And I set field "konto" to "44000" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "konto" has value "44000" in row 2
Then field "fixkonto" has value "ja" in row 2
# Konto aendern
And I set field "konto" to "43000" in row 1
Then field "konto" has value "43000" in row 2
Then field "fixkonto" has value "ja" in row 2
And I set field "budat" to "+2"
Then field "konto" has value "43000" in row 1
Then field "konto" has value "43000" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

###################################################################################################

@FALL-EK-RE-FIXKONTO
Scenario: Verkauf; RE -> Konto in Rabattpositionen wird nicht fixiert

# Rabatt anlegen
Given I open an editor "ek_rabatt" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
    | such    | ek_rabatt       |
    | typ     | Einkauf Rabatte |
    | artpg   | 201             |
    | klpg    | 1               |
    | separat | ja              |
    | mgeab   | ja              |
And I delete all rows
And I append rows
    | mgrenze | mproz |
    | 1       | -10   |
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief    | 1                           |
    | vom     | .                           |
    | ebeleg  | 100000                      |
    | betreff | Rechnung mit Rabattposition |
    | zbed    | 200                         |
And I create a new row at the end of the table
And I set field "artex" to "201" in row 1
And I set field "mge" to "10" in row 1
Then the table has 2 rows
Then field "konto" has value "10000" in row 2
And I set field "konto" to "10001" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "konto" has value "10001" in row 2
Then field "fixkonto" has value "ja" in row 2
# Konto aendern
And I set field "konto" to "10000" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "konto" has value "10000" in row 2
Then field "fixkonto" has value "ja" in row 2
# Konto aendern
And I set field "konto" to "10001" in row 1
Then field "konto" has value "10001" in row 2
Then field "fixkonto" has value "ja" in row 2
And I set field "budat" to "+2"
Then field "konto" has value "10001" in row 1
Then field "konto" has value "10001" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
