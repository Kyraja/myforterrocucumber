# *****************************************************************************************
#  Name           : ist_versteuerung_ausland_001_stammdaten.feature
#  Verantwortlich : wane
#  Funktion       : legt Steuerregeln und Vorgangssteuerregel fuer Ist-Versteuerung an
#                   Stammdaten und Kontierung
#
# ****************************************************************************************
@persistant

Feature: Ist_Versteuerung_Stammdaten fuer ref_steuer_ist_versteuerung_ausland_cu

Background:


Scenario: Konten ergaenzen

Given I open an editor "steuerkonto" from table "(Account):(Account)" with command "COPY" for record "38060"
And I set field "num5" to "38060CH"
And I set field "such5" to "ERLOESE-SCHWEIZ"
And I set field "name" to "Erloese Schweiz, Ist-Versteuerer"
And I set field "steuersts" to "50"
And I save the current editor
And I close the current editor

Given I open an editor "steuerkonto" from table "(Account):(Account)" with command "COPY" for record "38160"
And I set field "num5" to "38160CH"
And I set field "such5" to "STEUER-SCHWEIZ"
And I set field "name" to "Steuerkonto Schweiz"
And I set field "steuersts" to "50"
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "38060CH"
And I close the current editor

Given I open an editor "steuerkonto" from table "(Account):(Account)" with command "VIEW" for record "38160CH"
And I close the current editor
# ================================================================================================

Scenario Outline: Vorgangsteuerregel anlegen


Given I open an editor "vorgstrgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "NEW" for record ""
And I set fields
    |num156          |<nummer>          |
    |such            |<such>            |
    |ev              |<ev>              |
    |versteuerungsart|<versteuerungsart>|
    |namebspr        |<name>            |
    |stlaart         |<stlaart>         |
    |ustartsp        |<ustartsp>        |
    |ustartsf        |<ustartsf>        |
    |ustland         |<ustland>         |
And I save the current editor
And I close the current editor

Examples:
|nummer|such             |ev     |versteuerungsart |name                    |stlaart|ustartsp|ustartsf|ustland    |
|5020  |VKIN-IST         |Verkauf|Ist-Versteuerung |Verkauf Ist-Versteuerung|Inland |ja      |ja      |DEUTSCHLAND|
|5030  |VKIN-IST-SCHWEIZ |Verkauf|Ist-Versteuerung |Verkauf Ist-Versteuerung|Inland |ja      |ja      |SCHWEIZ    |
|5040  |VKIN-Soll-SCHWEIZ|Verkauf|Soll-Versteuerung|Verkauf Ist-Versteuerung|Inland |ja      |ja      |SCHWEIZ    |
#
|6020  |EKIN-IST         |Einkauf|Ist-Versteuerung |Einkauf Ist-Versteuerung|Inland |ja      |ja      |DEUTSCHLAND|
|6030  |EKIN-IST-SCHWEIZ |Einkauf|Ist-Versteuerung |Einkauf Ist-Versteuerung|Inland |ja      |ja      |SCHWEIZ    |
|6040  |EKIN-Soll-SCHWEIZ|Einkauf|Soll-Versteuerung|Einkauf Ist-Versteuerung|Inland |ja      |ja      |SCHWEIZ    |
# ==================================================================================================================

Scenario: Vorgangsteuerkonfiguration anpassen
Given I open an editor "PrcesstaxConf" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
|ev     |rechnlaart|bestlaart|vrgstrgl|istversteuerer|standard|
|Einkauf|Inland    |Inland   |6020    |            ja|    nein|
|Einkauf|Inland    |Inland   |6020    |          nein|    nein|
|Einkauf|Inland    |Inland   |6030    |            ja|    nein|
|Einkauf|Inland    |Inland   |6040    |          nein|    nein|
|Verkauf|Inland    |Inland   |5020    |            ja|    nein|
|Verkauf|Inland    |Inland   |5020    |          nein|    nein|
|Verkauf|Inland    |Inland   |5030    |            ja|    nein|
|Verkauf|Inland    |Inland   |5030    |          nein|    nein|
|Verkauf|Inland    |Inland   |5040    |            ja|    nein|
|Verkauf|Inland    |Inland   |5040    |          nein|    nein|
And I save the current editor


Given I open an editor "PrcesstaxConf2" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
|ev     |rechnland|bestland|vrgstrgl|istversteuerer|standard|
|Verkauf|Schweiz  |Schweiz |5030    |          nein|      ja|
And I save the current editor
# ================================================================================================

Scenario: Steuerregel ergaenzen

# Einkauf 19%
Given I open an editor "strgle1" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6000"
And I set field "steuerzwischenkonto" to "14340" in row 1
And I save the current editor

# Einkauf 7%
Given I open an editor "strgle2" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6001"
And I set field "steuerzwischenkonto" to "14341" in row 1
And I save the current editor

# Verkauf
Given I open an editor "strglv1" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "5000"
And I set field "steuerzwischenkonto" to "38160" in row 1
And I save the current editor

Given I open an editor "strglv2" from table "(TaxCode):(TaxRule)" with command "NEW" for record ""
And I set field "num58" to "5550CH"
And I set field "such58" to "VK5550CH"
And I set field "ev" to "Verkauf"
And I set field "stlaart" to "Inland"
And I set field "ustland" to "SCHWEIZ"
And I set field "ustart" to "steuerpflichtig"
And I delete all rows
And I set field "sts" to "50"
And I press button "ladestpertab"
And I set field "ktoustpos" to "81ch" in row 1
And I set field "sktoustpos" to "81ch" in row 1
And I set field "vkstustpos" to "581ch" in row 1
And I set field "vstkonto" to "38060CH" in row 1
And I set field "steuerzwischenkonto" to "38160CH" in row 1
And I save the current editor
And I close the current editor
# ================================================================================================

Scenario: Kontensteuerregel ergaenzen

Given I open an editor "kstrgl1" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
And I append rows
|vrgstrgl|strgl|
|6020    |6000 |
|6020    |6001 |
And I save the current editor

Given I open an editor "kstrgl2" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7000"
And I append rows
|vrgstrgl|strgl|
|5020    |5000 |
And I save the current editor
And I close the current editor

Given I open an editor "kstrgl3" from table "(TaxCode):(AccountTaxRule)" with command "NEW" for record ""
And I set field "num58" to "41500CH"
And I set field "such58" to "SCHWEIZ"
And I set field "ev" to "Verkauf"
And I set field "ustland" to "SCHWEIZ"
And I append rows
|vrgstrgl|strgl |
|5030    |5550CH|
|5040    |5550CH|
And I save the current editor
And I close the current editor
# ================================================================================================

Scenario: Lieferanten updaten

Given I open an editor "lief" from table "(Vendor):(Vendor)" with command "UPDATE" for record "001"
# "Ist-Versteuerung"-Vorgangssteuerregel
And I set field "vrgstrgl" to "6020"
And I save the current editor
And I close the current editor
# ================================================================================================

Scenario: Kunden updaten

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "003"
# "Ist-Versteuerung"-Vorgangssteuerregel
And I set field "vrgstrgl" to "5020"
And I save the current editor
And I close the current editor
# ================================================================================================

Scenario: Konten ergaenzen

Given I open an editor "umsatzkonto" from table "(Account):(Account)" with command "COPY" for record "41500"
And I set field "num5" to "41500CH"
And I set field "such5" to "Umsaetze-SCHWEIZ"
And I set field "name" to "Umsaetze Schweiz"
And I set field "ktostrgl" to "41500CH"

And I save the current editor
And I close the current editor
# ================================================================================================

Scenario: Vorgangskontotausch ergaenzen

Given I open an editor "konto" from table "(ProcessAccountChange):(ProcessAccountChangeHead)" with command "UPDATE" for record "44000"
And I append rows
|vrgstrgl|konto  |
|5030    |41500CH|
|5040    |41500CH|
And I save the current editor
And I close the current editor
# ================================================================================================

