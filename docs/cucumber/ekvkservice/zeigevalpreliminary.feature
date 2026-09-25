# *****************************************************************************
#  Name           : wertgutschrift.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teaminfosysteme
#  Funktion       : Testet IS VALPRELIMINARY fuer Rechnungen mit Lagerbewegung
#                   und Teil-Rechnungskorrekturen nach 100%-Wertgutschriften
#
# *****************************************************************************
#
@persistent
Feature: Wertgutschriften
Background:
Given I set the fake date to "05.01.1995"
Given I set saved value "REF_FILE" to "MF.VALPRELIMINARY.CU.REF"
Given I set saved value "Feldliste" to "tartikel,tmge,tbewpr,vom,wertgut,rekorrektur,kvorgang"


# EINKAUF #
Scenario: Infosystem VALPRELIMINARY das 1. mal aufrufen.
Given I open the infosystem "VALPRELIMINARY"
And I set field "reunvollst" to "ja"
And I set field "stichtag" to "05.01.1995"
And I set field "einkauf" to "ja"
And I press start
Then the table has 63 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

# VERKAUF #
Scenario: Infosystem VALPRELIMINARY das 2. mal aufrufen.
Given I open the infosystem "VALPRELIMINARY"
And I set field "reunvollst" to "ja"
And I set field "stichtag" to "05.01.1995"
And I set field "verkauf" to "ja"
And I press start
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

# Rechnungskorrektur erzeugen Einkauf
Scenario: 1. Rechnungskorrektur aus Re buchen -> E +4REK001E
Given I open an editor "REKORR1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+1RE065"
And I set fields
    | such   | REK001E     |
    | nummer | 4REK001E    |
    | tterm  | .           |
    | budat  | .           |
    | vom    | .           |
    | ueb    | ja          |
And I press button "burekorrektur"
Then the table has 9 rows
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "9" in row 1
And I save the current editor

Scenario: 2. Rechnungskorrektur aus Re buchen -> E +4REK002E
Given I open an editor "REKORR2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+1RE065"
And I set fields
    | such   | REK002E     |
    | nummer | 4REK002E    |
    | tterm  | .           |
    | budat  | .           |
    | vom    | .           |
    | ueb    | ja          |
And I press button "burekorrektur"
Then the table has 9 rows
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "2" in row 1
And I set field "preis" to "9,5" in row 1
And I save the current editor

# EINKAUF #
Scenario: Infosystem VALPRELIMINARY das 3. mal aufrufen für Einkauf. 2 Rechnungskorrekturzeilen zusätzlich
Given I open the infosystem "VALPRELIMINARY"
And I set field "reunvollst" to "ja"
And I set field "stichtag" to "05.01.1995"
And I set field "einkauf" to "ja"
And I press start
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

# Rechnungskorrekturen erzeugen Verkauf
Scenario: 1. Rechnungskorrektur aus Re buchen -> +4REK001
Given I open an editor "REKORR3" from table "(Sales):(Invoice)" with command "INVOICE" for record "+400053"
And I set fields
    | such   | REK001     |
    | nummer | 4REK001    |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I press button "burekorrektur"
Then the table has 8 rows
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "4" in row 1
And I set field "preis" to "19" in row 1
And I save the current editor

# VERKAUF #
Scenario: Infosystem VALPRELIMINARY das 4. mal aufrufen. 1 Rechnungskorrekturzeile zusätzlich
Given I open the infosystem "VALPRELIMINARY"
And I set field "reunvollst" to "ja"
And I set field "stichtag" to "05.01.1995"
And I set field "verkauf" to "ja"
And I press start
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
#And I close the current editor
