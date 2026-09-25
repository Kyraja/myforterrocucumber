# *****************************************************************************************
#  Name           : ist_versteuerung_stammdaten.feature
#  Verantwortlich : wane
#  Funktion       : legt Steuerregeln und Vorgangssteuerregel fuer Ist-Versteuerung an
#                   Stammdaten und Kontierung
#
#        Vorgangstrgl 6000 --> 6020 (ProcessTaxRule)
#        Suchwort "EKIN" --> "EKIN-IST"
#        versteuerungsart = "Ist-Versteuerung"
#        Bezeichnung "Einkauf, Inland, steuerpflichtig/steuerfrei (Ist-Versteuerung)
#
#        ProcessTaxconfiguration - Einfuegen neue Zeile nach Zeile 13
#        ev: Einkauf rechnlaart: Inland bestlaart: Inland vrgstrgl 6020
#        vrgstrglname: Einkauf, Inland, steuerpfl. "Ist-Versteuerung"
#
#        Steuerregel (TaxCode):(AccountTaxRule) 6000 kopieren --> 6020
#        Such: EKINL-IST, Bez: Einkauf, Inland, stpf. (Ist-Versteuerung)
#        steuerzwischenkonto: 14340. FOPS ausschalten, sonst kommt Fehler wg. Zugferd
#
#        TaxCode:AccountTaxRule 7004 Aendern
#        Einfuegen neue Zeile NACH Zeile 3
#        vrgstrgl 6020, strgl 6020
# ****************************************************************************************
@persistant

Feature: Ist_Versteuerung_Stammdaten fuer ref_steuer

Background:


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
And I save the current editor
And I close the current editor

Examples:
|nummer|such    |ev     |versteuerungsart|name                    |stlaart|ustartsp|ustartsf|
|6020  |EKIN-IST|Einkauf|Ist-Versteuerung|Einkauf Ist-Versteuerung|Inland |ja      |ja      |
|5020  |VKIN-IST|Verkauf|Ist-Versteuerung|Verkauf Ist-Versteuerung|Inland |ja      |ja      |
# ================================================================================================

Scenario: Vorgangsteuerkonfiguration anpassen
Given I open an editor "PrcesstaxConf" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
|ev     |rechnlaart|bestlaart|vrgstrgl|istversteuerer|standard|
|Einkauf|Inland    |Inland   |6020    |            ja|    nein|
|Einkauf|Inland    |Inland   |6020    |          nein|    nein|
|Verkauf|Inland    |Inland   |5020    |            ja|    nein|
|Verkauf|Inland    |Inland   |5020    |          nein|    nein|
And I save the current editor
# ================================================================================================

Scenario: Steuerregel updaten

# Einkauf 19%
Given I open an editor "strgle1" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6000"
And I set field "steuerzwischenkonto" to "14340" in row 1
And I set field "steuerzwischenkonto" to "14340" in row 2
And I set field "steuerzwischenkonto" to "14340" in row 3
And I save the current editor

# Einkauf 7%
Given I open an editor "strgle2" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6001"
And I set field "steuerzwischenkonto" to "14341" in row 1
And I save the current editor

# Verkauf
Given I open an editor "strglv1" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "5000"
And I set field "steuerzwischenkonto" to "38160" in row 1
And I set field "steuerzwischenkonto" to "38160" in row 2
And I set field "steuerzwischenkonto" to "38160" in row 3
And I save the current editor
# ================================================================================================

Scenario: Kontensteuerregel updaten
Given I open an editor "kstrgl" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
And I append rows
|vrgstrgl|strgl|
|6020    |6000 |
|6020    |6001 |
And I save the current editor

Given I open an editor "strgl" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7000"
And I append rows
|vrgstrgl|strgl|
|5020    |5000 |
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

