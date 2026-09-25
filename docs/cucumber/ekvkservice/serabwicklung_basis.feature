# *****************************************************************************
#  Name           : Tests fuer Serviceabwicklung. Teil 1
#  Autor          : nkoeninger
#  Verantwortlich : teampss
#  Funktion       : Cucumberscript zum Test ref_serabwicklung
#  Beschreibung   : Tests fuer Serviceabwicklung. Teil 1
#
# *****************************************************************************
#
@persistent
Feature: Serviceabwicklung1
Background:
Given I set the fake date to "02.01.1995"

Scenario Outline: Testdaten: Chargen
Given I open an editor "<editor>" from table "(Lots):(Lots)" with command "STORE" for record "<such>"
And I set fields
	| such   | <such>    |
	| exnum  | <exnum>   |
	| artikel| <artikel> |
And I save the current editor

Examples:
	| editor        | such          | exnum        | artikel      |
	| SN7542698-01  | SN7542698-01  | SN7542698-01 | F248-Tractor |
	| SN7542698-02  | SN7542698-02  | SN7542698-02 | F248-Tractor |
	| SN7542698-03  | SN7542698-03  | SN7542698-03 |              |
	| SN7542698-04  | SN7542698-04  | SN7542698-04 |              |

Scenario: Testdaten anlegen: Artikel, Serviceprodukte, Fuer Bestand sorgen
Given I open an editor "BESRV1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| ebeleg | BESRV1 |
	| lief   | 1      |
	| such   | BESRV1 |
	| vom    | .      |
And I append rows
	| artikel | mge | platz | charge |
	| e1      | 50  | f2    | CH-E1  |
And I save the current editor

Given I open an editor "LSSRV1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESRV1"
And I set fields
	| ebeleg  | LSSRV1 |
	| ueb     | ja     |
	| such    | LSSRV1 |
	| vom     | .      |
And I create a new row at the end of the table
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "BESRV2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
#And I set field "num" to "2"
And I set fields
	| ebeleg | BESRV2   |
	| lief   | 1        |
	| such   | BESRV2   |
	| vom    | .        |
And I append rows
	| artikel | mge | platz | charge |
	| e3      | 50  | f2    | CH-E3  |
And I save the current editor

Given I open an editor "LSSRV2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BESRV2"
#And I set field "num" to "2l"
And I set fields
	| ebeleg | LSSRV2   |
	| ueb    | ja       |
	| such   | LSSRV2   |
	| vom    | .        |
And I create a new row at the end of the table
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
And I set fields
	| vfolge      | FIFO      |
	| such        | BG1       |
	| serpflicht  | ja        |
	| dispoa      | Varianten |
And I set field "tnwpflicht" to "ja" in row 1
And I set field "elex" to "eink" in row 2
And I set field "elanzahl" to "1" in row 2
And I set field "tersatzt" to "ja" in row 2
And I save the current editor

Given I open an editor "V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set fields
	| such        | V1        |
	| serpflicht  | ja        |
	| dispoa      | Varianten |
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tserarchiv" to "ja" in row 3
And I save the current editor

Given I open an editor "F248-TRACTOR" from table "(Part):(Product)" with command "UPDATE" for record "F248-TRACTOR"
And I press button "wartdl" to open a subeditor for "Wartung/Diensleistung"
And I create a new row at the end of the table
And I set field "einsart" to "Wartung" in row 1
And I set field "dienstl" to "Oelwechsel_g" in row 1
And I set field "dienstl" to " " in row 1
And I set field "dienstl" to "Oelwechsel_g" in row 1
And I set field "intervall" to "50000" in row 1
And I set field "inteinh" to "km" in row 1

And I append rows
	| einsart | dienstl      | intervall | inteinh |
	| Wartung | Oelwechsel_m | 10000     | km      |
	| Wartung | Oelwechsel_m | 70000     | km      |
And I save the current editor
And I switch the current editor to editor "F248-TRACTOR"
And I press button "wartdl" to open a subeditor for "Wartung/Diensleistung"
And I delete row at position 1
And I save the current editor
And I switch the current editor to editor "F248-TRACTOR"
And I save the current editor

Given I open an editor "SCHUMI" from table "(Customer):(Customer)" with command "NEW" for record "1"
And I set fields
	| such    | SCHUMI             |
	| name    | Michael Schumacher |
	| ans     | Michael Schumacher |
	| nort    | Kerpen             |
	| plz     | 54578              |
	| kontakt | Corina             |
And I save the current editor

Given I open an editor "Rolf-SCH " from table "(Customer):(CustomerContact)" with command "NEW" for record ""
And I set fields
	| such    | Rolf-SCH           |
	| firma   | SCHUMI             |
	| ans     | Rolf Schumacher    |
	| nort    | Kerpen             |
	| plz     | 54578              |
	| name    | Rolf Schumacher    |

#Rolf-SCHUMI Maximal 8 Zeichen erlaubt. Text zu lang
And I save the current editor

Given I open an editor "Corina-S" from table "(Customer):(CustomerContact)" with command "NEW" for record ""
And I set fields
	| such    | Corina-S           |
	| firma   | SCHUMI             |
	| ans     | Corina Schumacher  |
	| nort    | Kerpen             |
	| plz     | 54578              |
	| name    | Corina Schumacher  |
	| kontakt | Michael            |
And I save the current editor

Given I open an editor "EIN_KUNDENGERAET" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
	| such        | EIN_KUNDENGERAET |
	| nummer      | 9999999          |
	| name        | ein Kundengeraet |
	| artikel     | F248-Tractor     |
	| serprodtyp  | Kundenger        |
And I save the current editor

Given I open an editor "SP8888" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
	| such        | SP8888            |
	| nummer      | 8888888           |
	| name        | E2 Serviceprodukt |
	| artikel     | E2                |
	| serprodtyp  | Kundenge          |
And I save the current editor

Given I open an editor "F248-SCHUMI" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
	| such     | F248-SCHUMI                                       |
	| name     | Service F248-Tractor                              |
	| artikel  | F248-Tractor                                      |
	| kkontakt | Corina                                            |
	| tkontakt | Rolf                                              |
	| foto     | \\\\lurchi\lurchi\bheim2\bau\eks\tractor_F248.jpg |
And I save the current editor

Given I open an editor "GETRIEBE185-F248" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set fields
	| such        | GETRIEBE185-F248         |
	| name        | Service F248-GETRIEBE185 |
	| artikel     | GETRIEBE185              |
	| charge      | CH-GETRIEBE              |
And I save the current editor

Given I open an editor "ch-getriebe185-12" from table "(Part):(Product)" with command "UPDATE" for record "getriebe185"
And I set field "chimlager" to "ja"
And I save the current editor

Given I open an editor "Charge" from table "(Lots):(Lots)" with command "NEW" for record ""
#And I set field "nummer" to "12"
And I set fields
	| such        | ch-getriebe185-12 |
	| chname      | ch-getriebe185-12 |
	| exnum       | ch-getriebe18-12  |
	| artikel     | getriebe185       |
And I save the current editor

Given I open an editor "AGSCHU1A" from table "(Sales):(Quotation)" with command "NEW" for record ""
#num 1A
And I set fields
	| kunde        | SCHUMI   |
	| such         | AGSCHU1A |
And I append rows
	| artikel 	   | mge      | serprod |
	| F248-Tractor | 1        | 1       |
And I save the current editor

Given I open an editor "AUSCHU1" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "AGSCHU1A"
And I set fields
	| dispoaubez   | ja       |
   #| nummer       | 1        |
	| such         | AUSCHU1  |
And I set field "charge" to "5" in row 1
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
And I set field "charge" to "8" in row 2
And I save the current editor
And I switch the current editor to editor "AUSCHU1"
And I save the current editor

#Disposition starten
And I run Scheduling

Given I open an editor "LS1L" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AUSCHU1"
And I set fields
	| such         | LS1L     |
	| nummer       | 1l       |
	| ueb          | ja       |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "SRRV1" from table "(ServiceProduct):(ServiceProduct)" with command "UPDATE" for record "1"
And I set fields
	| ans          | Michael Schumacher Junior |
	| str          | Boxengasse 1              |
	| nort         | Kerpen Kerpen             |
	| plz          | 56578                     |
And I save the current editor

Given I open an editor "EK1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| num          | 884590 |
	| lief         | 1      |
	| such         | EK1    |
	| ueb          | ja     |
	| budat        | 2.1.95 |
	| vom          | 4.1.95 |
And I append rows
	| artikel      | mge    | preis |
	| TEST         | 4      | 20    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rueckmeldebeleg erfassen
Given I open an editor "FV1" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "GETRIEBE185"
And I press button "ladetab"
And I set field "serpflicht" to "ja" in row 1
And I set field "serprod" to "GETRIEBE185-F248" in row 1
And I save the current editor

# Rueckmeldebeleg erfassen
Given I open an editor "FV2" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "F248-TRACTOR"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "Auswahlfreigeben"
And I close the current editor
And I switch the current editor to editor "FV2"
And I save the current editor

# Rueckmeldebeleg erfassen
Given I open an editor "FV3" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "GETRIEBE185"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "absteig" to open a subeditor for "Fertigungslsite" in row 1
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "FV3"
And I press button "freig" to open a subeditor for "Auswahlfreigeben"
And I close the current editor
And I switch the current editor to editor "FV3"
And I save the current editor

# Rueckmeldebeleg erfassen
Given I open an editor "FV4" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "LENKUNGM830"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "Auswahlfreigeben"
And I close the current editor
And I switch the current editor to editor "FV4"
And I save the current editor

Given I open an editor "FV1001" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "1001"
And I press button "absteig" to open a subeditor for "Fertigungsliste1"
# Charge in MZ setzen (Kann nur in MZ gesetzt werden, wenn bereits MZs existieren)
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
And I append rows
	| charge |
	| 50     |
And I save the current editor
And I switch the current editor to editor "Fertigungsliste1"
And I save the current editor
And I switch the current editor to editor "FV1001"
And I save the current editor

# Rueckmeldebeleg erfassen
Given I open an editor "FV1003" from table "(Workorder):(CompletionConfirmations)" with command "DONE" for record ""
And I set fields
| barmex | 1003 |
| mgr    | 101  |
| sofort | ja   |
And I press button "ueber" in row 1
And I append rows
	| artikel  | mge | charge |
	| schraube | 23  | CH-10  |
And I save the current editor

Given I open an editor "FV1002" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "1002"
And I press button "absteig" to open a subeditor for "Fertigungsliste2"
And I create a new row at position 1
And I set field "elex" to "test" in row 1
And I set field "elanzahl" to "0" in row 1
And I set field "nwpflicht" to "ja" in row 1
And I set field "manbu" to "ja" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "ME1002" for tip command "(WOIssue)" and arguments ""
And I set field "auftrag" to "1002"
And I set field "mgr" to "101"
And I press button "stllad"
And I set field "bumge" to "2" in row 1
And I create a new row at the end of the table
And I set field "bumge" to "0" in row 2
And I set field "rescharge" to "CH-11" in row 3
And I create a new row at position 6
And I set field "elex" to "Schraub" in row 6
And I set field "bumge" to "19" in row 6
And I append rows
	| elex  | bumge |
	| E2    | 13    |
And I save the current editor


