# *****************************************************************************
#  Name           : intrastatzentrale_wgs.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teaminfosysteme
#  Funktion       : Cucumber Tests fuer Intrastatzentrale mit Wertgutschriften
#
# *****************************************************************************
#
@persistent
Feature: Wertgutschrift und Rechnungskorrektur fuer EK und VK zu gemeldeten Rechnungen
Background:
Given I set the fake date to "02.02.2002"
Given I set saved value "REF_FILE" to "SK.INTRASTATZENTRALE.WGS2.CU.REF"
Given I set saved value "Feldliste1" to "vorgang,edinachricht"

Scenario: Infosystem INTRASTATZENTRALE aufrufen mit Meldenummer 6
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.1.2002"
And I set field "datumbis" to "28.2.2002"
And I set field "bgemeldet" to "ja"
And I set field "intra" to "6"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: Infosystem INTRASTATZENTRALE aufrufen mit Meldenummer 3
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.1.2002"
And I set field "datumbis" to "28.2.2002"
And I set field "bgemeldet" to "ja"
And I set field "intra" to "3"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
# Verkauf
#########
#Fall 2: Rechnung, auf die sich die Wertgutschrift bezieht, ist bereits gemeldet
#########
#Fall 2a: Wurde die Rechnung gemeldet (V +0INT0005) Gibt es eine 100% Wertgutschrift aber noch keine Rechnungskorrektur, darf die WGS nicht angezeigt werden!
#########

Scenario: 1. Komplettwertgutschrift zu Rechnung erstellen und buchen -> +4WGS005
Given I open an editor "WGS1" from table "(Sales):(Invoice)" with command "INVOICE" for record "+0INT0005"
And I set fields
    | such   | WGS005     |
    | nummer | 4WGS005    |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "komplettieren"
Then the table has 9 rows
Then table has values
    | mge   | preis       | pwert      |
    | -1    | 116.05      | -116.05    |
    | -2    | 117.19      | -234.38    |
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE 3. Mal aufrufen. Es gibt nichts zu melden.
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.2002"
And I set field "datumbis" to "28.2.2002"
Then pressing button "bstart" in row 0 throws the exception "3981"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
#Fall 2b_1: Wurde die Rechnung (Re mit fakt=true) gemeldet (V +0INT0002) und es wurde eine 100% Wertgutschrift und eine RE-Korrektur erstellt, muss die Wertgutschrift und die Rechnungskorrektur gemeldet werden.
#########
Scenario: 2. 100% Wertgutschrift zu Rechnung2 erstellen und buchen -> +4WGS002
Given I open an editor "WGS2" from table "(Sales):(Invoice)" with command "INVOICE" for record "+0INT0002"
And I set field "such" to "WGS002"
And I set field "nummer" to "4WGS002"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I press button "komplettieren"
And I save the current editor

Scenario: 1. Rechnungskorrektur aus Re buchen -> +4REK002
Given I open an editor "REKORR1" from table "(Sales):(Invoice)" with command "INVOICE" for record "+0INT0002"
And I set fields
    | such   | REK002      |
    | nummer | 4REK002     |
    | tterm  | .           |
    | budat  | .           |
    | vom    | .           |
    | ueb    | ja          |
And I press button "burekorrektur"
Then the table has 7 rows
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "100" in row 1
Then field "rekorrektur" has value "ja" in row 2
And I set field "mge" to "2" in row 2
And I set field "preis" to "100" in row 2
And I save the current editor

Scenario: INTRASTATZENTRALE das 4. Mal aufrufen. Es erscheint die WGS und die Rechnungskorrektur im Infosystem
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.2002"
And I set field "datumbis" to "28.2.2002"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

###########
#Fall 2b_2: Wurde die Rechnung (Re mit fakt=false -> RE aus LS) gemeldet und es wurde eine 100% Wertgutschrift und eine RE-Korrektur erstellt, muss die Wertgutschrift und die Rechnungskorrektur gemeldet werden.
###########
Scenario: 100% Wertgutschrift zu Rechnung erstellen und buchen -> +4WGS0001
Given I open an editor "WGS2" from table "(Sales):(Invoice)" with command "INVOICE" for record "+0IRG0001"
And I set field "such" to "WGS0001"
And I set field "nummer" to "4WGS0001"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I press button "komplettieren"
And I save the current editor

Scenario: Rechnungskorrektur aus LS anlegen und buchen ->V +0IRG0001
Given I open an editor "REKORR1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "0INL0001"
And I set fields
    | such   | REK0001     |
    | nummer | 4REK0001    |
    | tterm  | .           |
    | budat  | .           |
    | vom    | .           |
    | ueb    | ja          |
Then the table has 6 rows
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "100" in row 1
Then field "rekorrektur" has value "ja" in row 2
And I set field "mge" to "2" in row 2
And I set field "preis" to "100" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: INTRASTATZENTRALE das 5. Mal aufrufen. Es erscheinen die WGS und die Rechnungskorrekturen aus Fall 2b_1 und 2b_2 im Infosystem
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.2002"
And I set field "datumbis" to "28.2.2002"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
#Fall 2c: Wurde eine Rechnung gemeldet (V +0INT0007) und es wurde eine Teilwertgutschrift erstellt, darf die TWG nicht erscheinen
#########
Scenario: 1. Teil-Wertgutschrift zu Re erstellen und buchen -> +4TWG007
Given I open an editor "TWGS1" from table "(Sales):(Invoice)" with command "INVOICE" for record "+0INT0007"
And I set field "such" to "TWGS007"
And I set field "nummer" to "4TWG007"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-2" in row 2
And I set field "mge" to "-1" in row 3
And I set field "mge" to "-1" in row 4
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE das 6. Mal aufrufen. Es erscheinen nur die vier vorigen Vorgaenge
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.2002"
And I set field "datumbis" to "28.2.2002"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
# Einkauf
#########

Scenario: Infosystem INTRASTATZENTRALE das 7. mal aufgerufen
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.1.2002"
And I set field "datumbis" to "31.1.2002"
And I set field "bgemeldet" to "ja"
And I set field "intra" to "6"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
#Fall 2a: Wurde die Rechnung gemeldet (E +0INT0003) Gibt es eine 100% Wertgutschrift aber noch keine Rechnungskorrektur, darf die WGS nicht angezeigt werden!
#########

Scenario: 1. Komplettwertgutschrift zu Rechnung erstellen und buchen -> E +4WGS003
Given I open an editor "WGS1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+0INT0003"
And I set fields
    | such   | WGS003E    |
    | nummer | 4WGS003E   |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "komplettieren"
Then the table has 9 rows
Then table has values
    | mge   | preis       | pwert      |
    | -1    | 120.00      | -120.00    |
    | -2    | 120.00      | -240.00    |
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE 8. mal aufrufen. Nur die vier Vorgaenge aus dem Verkauf erscheinen
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.2002"
And I set field "datumbis" to "28.2.2002"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
#Fall 2b: Wurde die Rechnung gemeldet (E +0INT0004) und es wurde eine 100% Wertgutschrift und eine RE-Korrektur erstellt, muss die Wertgutschrift und die Rechnungskorrektur gemeldet werden.
#########

Scenario: 2. Komplettwertgutschrift zu Rechnung erstellen und buchen -> E +4WGS004
Given I open an editor "WGS2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+0INT0004"
And I set field "such" to "WGS004E"
And I set field "nummer" to "4WGS004E"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I press button "komplettieren"
And I save the current editor

Scenario: 1. Rechnungskorrektur aus Re buchen -> E +4REK004
Given I open an editor "REKORR1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+0INT0004"
And I set fields
    | such   | REK004E     |
    | nummer | 4REK004E    |
    | tterm  | .           |
    | budat  | .           |
    | vom    | .           |
    | ueb    | ja          |
And I press button "burekorrektur"
Then the table has 9 rows
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "100" in row 1
Then field "rekorrektur" has value "ja" in row 2
And I set field "mge" to "2" in row 2
And I set field "preis" to "100" in row 2
And I save the current editor

Scenario: INTRASTATZENTRALE das 9. mal aufrufen. Es erscheint die WGS 4WGS004E und die Rechnungskorrektur 4REK004E im Infosystem
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.2002"
And I set field "datumbis" to "28.2.2002"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#########
#Fall 2c: Wurde eine Rechnung gemeldet (E +0INT0005) und es wurde eine Teilwertgutschrift erstellt, darf die TWG nicht erscheinen
#########
Scenario: 1. Teil-Wertgutschrift zu Re erstellen und buchen -> +4TWG007
Given I open an editor "TWGS1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+0INT0005"
And I set field "such" to "TWGS005E"
And I set field "nummer" to "4TWG005E"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "budat" to "."
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-2" in row 2
And I set field "mge" to "-1" in row 3
And I set field "mge" to "-1" in row 4
And I save the current editor

Scenario: Infosystem INTRASTATZENTRALE das 10. mal aufrufen. Es erscheinen nur die sechs vorigen Vorgaenge
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.2.2002"
And I set field "datumbis" to "28.2.2002"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

#######################################################################################################################
Scenario: Infosystem INTRASTATZENTRALE 11. mal aufrufen mit Meldenummer 6
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.1.2002"
And I set field "datumbis" to "28.2.2002"
And I set field "bgemeldet" to "ja"
And I set field "intra" to "6"
And I press start
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: Infosystem INTRASTATZENTRALE 12. mal aufrufen mit Meldenummer 3
Given I open the infosystem "INTRASTATZENTRALE"
And I set field "datumvon" to "1.1.2002"
And I set field "datumbis" to "28.2.2002"
And I set field "bgemeldet" to "ja"
And I set field "intra" to "3"
And I press start
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I close the current editor
