# *****************************************************************************************
#  Name           : ref_strgl_ist.feature xxxx
#  Autor          : rem
#  Verantwortlich : 
#  Funktion       : legt Steuerregeln und Vorgangssteuerregel für Ist-Versteuerung an
#                   Stammdaten 1. Prototyp ref_Ist_Versteuerung_Stamm
#                   und Kontierung
#
#        Vorgangstrgl 6000 --> 6009 (ProcessTaxRule)
#        Suchwort "EKIN" --> "EKIN-IST"
#        versteuerungsart = "Ist-Versteuerung"
#        Bezeichnung "Einkauf, Inland, steuerpflichtig/steuerfrei (Ist-Versteuerung)
#
#        ProcessTaxconfiguration - Einfügen neue Zeile nach Zeile 13
#        ev: Einkauf rechnlaart: Inland bestlaart: Inland vrgstrgl 6009
#        vrgstrglname: Einkauf, Inland, steuerpfl. "Ist-Versteuerung"
#
#        Steuerregel (TaxCode):(AccountTaxRule) 6000 kopieren --> 6009
#        Such: EKINL-IST, Bez: Einkauf, Inland, stpf. (Ist-Versteuerung)
#        steuerzwischenkonto: 14340. FOPS ausschalten, sonst kommt Fehler wg. Zugferd
#
#        TaxCode:AccountTaxRule 7004 Ändern
#        Einfügen neue Zeile NACH Zeile 3
#        vrgstrgl 6009, strgl 6009
#        Updates in den Stammdatenzum schneller Testen (02.03.26) 
#        ABS-30639 - Konten-Steuerregel des Skontokontos 57365 um Zwischenkonto eintragen
#        ABS-27977 - Zwischenkonto auf kv-rel setzen
# ****************************************************************************************
@persistant

Feature: Ist_Versteuerung_Stammdaten

Background:
Given I set the fake date to "31.12.2022"

Scenario Outline: Vorgangsteuerregel anlegen
Given I open an editor "vorgstrgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "NEW" for record ""
And I set fields
    | num156|<nummer>                   |
    |   such|<such>                     |
    |     ev|<ev>                       |
    |versteuerungsart|<versteuerungsart>|
    |namebspr|<name>                    |
    | stlaart|<stlaart>                 |
    |ustartsp|<ustartsp>                |
    |ustartsf|<ustartsf>                |
And I save the current editor
And I close the current editor

Examples:
|nummer|such    |ev     |versteuerungsart|name                    |stlaart|ustartsp|ustartsf|
|6009  |EKIN-IST|Einkauf|Ist-Versteuerung|Einkauf Ist-Versteuerung|Inland |ja      |ja      |
|5009  |VKIN-IST|Verkauf|Ist-Versteuerung|Verkauf Ist-Versteuerung|Inland |ja      |ja      |

Scenario: Vorgangsteuerkonfiguration anpassen
Given I open an editor "PrcesstaxConf" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
|ev       |rechnlaart|bestlaart|vrgstrgl|istversteuerer|
|Einkauf  |Inland    |Inland   |6009    |ja            |
|Verkauf  |Inland    |Inland   |5009    |ja            |
And I save the current editor

Scenario: Zwischenkonto_kv_rel
Given I open an editor "Zwischenkonto" from table "(Account):(Account)" with command "UPDATE" for record "14340"
And I set field "kvrel" to "ja"
And I save the current editor
And I close the current editor

Scenario: Steuerregel Einkauf 19% updat14340en
Given I open an editor "strgle1" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6000"
And I set field "steuerzwischenkonto" to "14340" in row 1
And I save the current editor


Scenario: Steuerregel Einkauf 7% updaten
Given I open an editor "strgle2" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "6001"
And I set field "steuerzwischenkonto" to "14341" in row 1
And I save the current editor


Scenario: Steuerregel Verkauf updaten
Given I open an editor "strglv1" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "5000"
And I set field "steuerzwischenkonto" to "38160" in row 1
And I save the current editor


Scenario: Kontensteuerregeln upaten
Given I open an editor "kstrgl" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7004"
And I append rows
|vrgstrgl|strgl|
|6009    |6000 |
|6009    |6001 |
And I save the current editor

Scenario: 19_Skonto-Kontensteuerregel upaten
Given I open an editor "kstrgl_19" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "EKINSTPF-1"
And I append rows
|vrgstrgl|strgl|
|6009    |6000 |
And I save the current editor

Scenario: 7_Skonto-Kontensteuerregel upaten
Given I open an editor "kstrgl_7" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "EKINSTPF-2"
And I append rows
|vrgstrgl|strgl|
|6009    |6001 |
And I save the current editor

Given I open an editor "strgl" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "VKIN-81"
And I append rows
|   vrgstrgl|    strgl|
|      5009 |    5000 |
And I save the current editor
And I close the current editor
  
Scenario: Bankverbindungen anlegen
Given I open an editor "Bank" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set field "konto" to "14600"
And I set field "bank" to "1"
And I set field "iban" to "DE44701500000904171782"
And I save the current editor
And I close the current editor

Given I open an editor "BankLieferant" from table "(BankData):(BankDetails)" with command "NEW" for record ""
And I set field "konto" to "L 1"
And I set field "bank" to "1"
And I set field "iban" to "DE44701500000904171782"
And I save the current editor
And I close the current editor

Given I open an editor "Geldtransit" from table "(Account):(Account)" with command "UPDATE" for record "14600"
And I set field "bverb" to id from editor "Bank"
And I save the current editor
And I close the current editor

Given I open an editor "L 1" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I set field "bverb" to id from editor "BankLieferant"
And I save the current editor
And I close the current editor






