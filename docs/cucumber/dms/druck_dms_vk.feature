Feature: VK_Vorgaenge
Background: druck_dms_VK_vk_drbelegart.feature
Given I set the fake date to "02.01.2002"

Scenario: DMS in der Konfiguration aktivieren
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "habel" to "1"
And I save the current editor

Scenario: DMS Einstellungen in den Betriebsdaten setzen
Given I open an editor "konfiguration" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set fields
	| searchkuli    | 1 |
	| searchartikel | 1 |
And I save the current editor

Scenario: Webauftrag anlegen

Given I open an editor "neu anlegen" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set field "nummer" to "034-WA"
And I set field "vom" to "."
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artex" to "E1" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor

Scenario Outline: Anzahlung und Barzahlung anlegen

Given I open an editor "neu anlegen" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| nummer   | <nummer>   |
	| vom      | .          |
	| kunde    | 1          |
	| vorganga | <vorganga> |
And I append rows
	| artex |
	| text  |
And I save the current editor

Given I open an editor "neu anlegen" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| nummer   | <nummer_storniert> |
	| vom      | .                  |
	| kunde    | 1                  |
	| vorganga | <vorganga>         |
And I append rows
	| artex |
	| text  |
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "stornieren" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+<nummer_storniert>"
And I set field "nummer" to "<nummer_storno>"
And I save the current editor

Examples:
| row | nummer   | vorganga   | nummer_storniert | nummer_storno |
| 001 | 013-ARE  | Anzahlung  | 014-ARE          | 015-ARS       |
| 002 | 023-BRE  | Barzahlung | 024-BRE          | 025-BRS       |

Scenario Outline: dms-Felder pruefen

Given I open an editor "zeigen" from table "<editor>" with command "VIEW" for record "<nummer>"
Then field "drbelegart^such" has value "<drbelegart>"
Then field "drbelegart^extnummer" has value "<extnummer>"
Then field "dndbelegart^such" has value "<dndbelegart>"
Then field "<feldname>" has value "<azlwert>"
And I press button "dokuz"
Then message "<hlnk>" was displayed
And I close the current editor

Examples:
| row | nummer    | editor                     | drbelegart           |extnummer| dndbelegart          | feldname | azlwert                              | hlnk                |
| 001 | 0010-AU   | (Sales):(SalesOrder)       | VKAUFTRAGSBEST       | 215     | VKBESTELLUNG         | lsart    |                                      | @VKAufNr=0010-AU    |
| 002 | 0020-LS   | (Sales):(PackingSlip)      | VKLIEFERSCHEIN       | 230     | VKKORRESPONDENZ      | lsart    | Lieferschein                         | @VKLiefNr=0020-LS   |
| 003 | +0110-LS  | (Sales):(PackingSlip)      | VKSLIEFERSCHEIN      | 230     | VKKORRESPONDENZ      | lsart    | Stornierter Lieferschein             | @VKLiefNr=0110-LS   |
| 004 | +0110-SLS | (Sales):(PackingSlip)      | VKLIEFERSTORNO       | 232     | VKKORRESPONDENZ      | lsart    | Storno-Lieferschein                  | @VKSLSNr=0110-SLS   |
| 005 | 0200-RLS  | (Sales):(PackingSlip)      | VKRUECKNAHME         | 231     | VKKORRESPONDENZ      | lsart    | Rücklieferschein                     | @VKRLSNr=0200-RLS   |
| 006 | +0230-RLS | (Sales):(PackingSlip)      | VKSRUECKLIEFER       | 231     | VKKORRESPONDENZ      | lsart    | Stornierter Rücklieferschein         | @VKRLSNr=0230-RLS   |
| 007 | +0230-SRL | (Sales):(PackingSlip)      | VKRUECKLIEFERSTORNO  | 233     | VKKORRESPONDENZ      | lsart    | Storno-Rücklieferschein              | @VKSRLSNr=0230-SRL  |
| 008 | 1510-KDA  | (Sales):(PackingSlip)      | VKKUNDENANLIEFERUNG  | 280     | VKKUNDENANLIEFERUNG  | lsart    | Kundenanlieferung                    | @VKKLSNr=1510-KDA   |
| 009 | +1520-KDA | (Sales):(PackingSlip)      | VKSKUNDENANLIEFERUNG | 280     | VKSKUNDENANLIEFERUNG | lsart    | Stornierte Kundenanlieferung         | @VKKLSNr=1520-KDA   |
| 010 | +1520-SKD | (Sales):(PackingSlip)      | VKKUNDENLIEFERSTORNO | 282     | VKKUNDENLIEFERSTORNO | lsart    | Storno-Kundenanlieferung             | @VKSKLSNr=1520-SKD  |
| 011 | +0040-RE  | (Sales):(Invoice)          | VKRECHNUNG           | 235     | VKKORRESPONDENZ      | vorganga | Rechnung                             | @VKRechNr=0040-RE   |
| 012 | +0060-GS  | (Sales):(Invoice)          | VKGUTSCHRIFT         | 240     | VKKORRESPONDENZ      | vorganga | Kaufmännische Gutschrift             | @VKRechNr=0060-GS   |
| 013 | +0160-RE  | (Sales):(Invoice)          | VKSRECHNUNG          | 235     | VKKORRESPONDENZ      | vorganga | Stornierte Rechnung                  | @VKRechNr=0160-RE   |
| 014 | +0160-SRE | (Sales):(Invoice)          | VKSTORNORECHNUNG     | 239     | VKKORRESPONDENZ      | vorganga | Storno-Rechnung                      | @VKSReNr=0160-SRE   |
| 015 | +0220-GS  | (Sales):(Invoice)          | VKSGUTSCHRIFT        | 240     | VKKORRESPONDENZ      | vorganga | Stornierte kaufmännische Gutschrift  | @VKRechNr=0220-GS   |
| 016 | +0220-SGS | (Sales):(Invoice)          | VKSTORNOGUTSCHRIFT   | 243     | VKKORRESPONDENZ      | vorganga | Storno kaufmännische Gutschrift      | @VKSGsNr=0220-SGS   |
| 017 | 013-ARE   | (Sales):(Invoice)          | VKANZAHLUNG          | 238     | VKKORRESPONDENZ      | vorganga | Anzahlung                            | @VKAReNr=013-ARE    |
| 018 | +014-ARE  | (Sales):(Invoice)          | VKSANZAHLUNG         | 238     | VKKORRESPONDENZ      | vorganga | Stornierte Anzahlung                 | @VKAReNr=014-ARE    |
| 019 | +015-ARS  | (Sales):(Invoice)          | VKSTORNOANZAHLUNG    | 239     | VKKORRESPONDENZ      | vorganga | Storno-Anzahlung                     | @VKSReNr=015-ARS    |
| 020 | 023-BRE   | (Sales):(Invoice)          | VKBARZAHLUNG         | 235     | VKKORRESPONDENZ      | vorganga | Barzahlung                           | @VKRechNr=023-BRE   |
| 021 | +024-BRE  | (Sales):(Invoice)          | VKSBARZAHLUNG        | 235     | VKKORRESPONDENZ      | vorganga | Stornierte Barzahlung                | @VKRechNr=024-BRE   |
| 022 | +025-BRS  | (Sales):(Invoice)          | VKSTORNOBARZAHLUNG   | 239     | VKKORRESPONDENZ      | vorganga | Storno-Barzahlung                    | @VKSReNr=025-BRS    |
| 023 | 1         | (Customer):(Customer)      |                      |         | VKKUNDEKORRESP       | nummer   | 1                                    | @KuLiNr=1 @KuLiKZ=K |
| 024 | 034-WA    | (Sales):(WebOrder)         | VKWEBAUFTRAGSBEST    | 214     | VKWEBBESTELLUNG      | lsart    |                                      | @VKWAufNr=034-WA    |

Scenario Outline: Layout MASTER und LSMASTER drucken
Given I open an editor "drucken" from table "<editor>" with command "VIEW" for record "<nummer>"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
And I save the current editor
And I switch the current editor to editor "drucken"
And I close the current editor

Examples:
| row | nummer    | editor                     | layout   |
| 001 | 0010-AU   | (Sales):(SalesOrder)       | MASTER   |
| 002 | 0020-LS   | (Sales):(PackingSlip)      | LSMASTER |
| 003 | +0110-LS  | (Sales):(PackingSlip)      | LSMASTER |
| 004 | +0110-SLS | (Sales):(PackingSlip)      | LSMASTER |
| 005 | 0200-RLS  | (Sales):(PackingSlip)      | LSMASTER |
| 006 | +0230-RLS | (Sales):(PackingSlip)      | LSMASTER |
| 007 | +0230-SRL | (Sales):(PackingSlip)      | LSMASTER |
| 008 | 1510-KDA  | (Sales):(PackingSlip)      | LSMASTER |
| 009 | +1520-KDA | (Sales):(PackingSlip)      | LSMASTER |
| 010 | +1520-SKD | (Sales):(PackingSlip)      | LSMASTER |
| 011 | +0040-RE  | (Sales):(Invoice)          | MASTER   |
| 012 | +0060-GS  | (Sales):(Invoice)          | MASTER   |
| 013 | +0160-RE  | (Sales):(Invoice)          | MASTER   |
| 014 | +0160-SRE | (Sales):(Invoice)          | MASTER   |
| 015 | +0220-GS  | (Sales):(Invoice)          | MASTER   |
| 016 | +0220-SGS | (Sales):(Invoice)          | MASTER   |
| 017 | 013-ARE   | (Sales):(Invoice)          | MASTER   |
| 018 | +014-ARE  | (Sales):(Invoice)          | MASTER   |
| 019 | +015-ARS  | (Sales):(Invoice)          | MASTER   |
| 020 | 023-BRE   | (Sales):(Invoice)          | MASTER   |
| 021 | +024-BRE  | (Sales):(Invoice)          | MASTER   |
| 022 | +025-BRS  | (Sales):(Invoice)          | MASTER   |

Scenario Outline: Dokumentverweis pruefen
Given I open an editor "verweis" from table "<editor>" with command "VIEW" for record "<nummer>"
Then field "<feld>^vorgang" is not empty
Then field "<barcodefeld>" is <barcode>
And I close the current editor

Examples:
| row | nummer    | editor                     | feld      | barcodefeld | barcode   |
| 001 | 0010-AU   | (Sales):(SalesOrder)       | doku      | barcode     | empty     |
| 002 | 0020-LS   | (Sales):(PackingSlip)      | rueckdoku | rueckbarcode| not empty |
| 003 | +0110-LS  | (Sales):(PackingSlip)      | rueckdoku | rueckbarcode| not empty |
| 004 | +0110-SLS | (Sales):(PackingSlip)      | rueckdoku | rueckbarcode| not empty |
| 005 | 0200-RLS  | (Sales):(PackingSlip)      | rueckdoku | rueckbarcode| not empty |
| 006 | +0230-RLS | (Sales):(PackingSlip)      | rueckdoku | rueckbarcode| not empty |
| 007 | +0230-SRL | (Sales):(PackingSlip)      | doku      | barcode     | empty     |
| 008 | 1510-KDA  | (Sales):(PackingSlip)      | doku      | barcode     | empty     |
| 009 | +1520-KDA | (Sales):(PackingSlip)      | doku      | barcode     | empty     |
| 010 | +1520-SKD | (Sales):(PackingSlip)      | doku      | barcode     | empty     |
| 011 | +0040-RE  | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 012 | +0060-GS  | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 013 | +0160-RE  | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 014 | +0160-SRE | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 015 | +0220-GS  | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 016 | +0220-SGS | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 017 | 013-ARE   | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 018 | +014-ARE  | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 019 | +015-ARS  | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 020 | 023-BRE   | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 021 | +024-BRE  | (Sales):(Invoice)          | doku      | barcode     | empty     |
| 022 | +025-BRS  | (Sales):(Invoice)          | doku      | barcode     | empty     |
