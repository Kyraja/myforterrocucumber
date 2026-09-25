Feature: EK_Vorgaenge
Background: druck_dms_ek_vk_drbelegart.feature
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

Scenario Outline: Anzahlung und Barzahlung anlegen

Given I open an editor "neu anlegen" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| nummer   | <nummer>   |
	| vom      | .          |
	| lief     | 200        |
	| vorganga | <vorganga> |
And I append rows
	| artex |
	| text  |
And I save the current editor

Given I open an editor "neu anlegen" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| nummer   | <nummer_storniert> |
	| vom      | .                  |
	| lief     | 200                |
	| vorganga | <vorganga>         |
And I append rows
	| artex |
	| text  |
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "stornieren" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+<nummer_storniert>"
And I set field "nummer" to "<nummer_storno>"
And I save the current editor

Examples:
| row | nummer   | vorganga   | nummer_storniert | nummer_storno |
| 001 | 013-ARE  | Anzahlung  | 014-ARE          | 015-ARS       |
| 002 | 023-BRE  | Barzahlung | 024-BRE          | 025-BRS       |

Scenario Outline: dms Felder pruefen

Given I open an editor "zeigen" from table "<editor>" with command "VIEW" for record "<nummer>"
Then field "drbelegart^such" has value "<drbelegart>"
Then field "drbelegart^extnummer" has value "<extnummer>"
Then field "dndbelegart^such" has value "<dndbelegart>"
Then field "<feldname>" has value "<azlwert>"
And I press button "dokuz"
Then message "<hlnk>" was displayed
And I close the current editor

Examples:
| row | nummer    | editor                          | drbelegart           |extnummer| dndbelegart          | feldname | azlwert                             | hlnk              |
#| 000 | 1122      | (Purchasing):(Request)          | EKANFRAGE            | 110     | EKKORRESPONDENZ      | lsart    |                                     | @KuLiNr=1 @EKAnfNr=010-BE   |
| 001 | 010-BE    | (Purchasing):(PurchaseOrder)    | EKBESTELLUNG         | 110     | EKAUFTRAGSBEST       | lsart    |                                     | @KuLiNr=1 @EKBestNr=010-BE   |
| 002 | 011-LS    | (Purchasing):(PackingSlip)      | EKLIEFERSCHEIN       | 125     | EKLIEFERSCHEIN       | lsart    | Lieferschein                        | @KuLiNr=1 @EKLiefNr=011-LS   |
| 003 | +030-LS   | (Purchasing):(PackingSlip)      | EKSLIEFERSCHEIN      | 125     | EKSLIEFERSCHEIN      | lsart    | Stornierter Lieferschein            | @KuLiNr=1 @EKLiefNr=030-LS   |
| 004 | +030-STLS | (Purchasing):(PackingSlip)      | EKLIEFERSTORNO       | 127     | EKLIEFERSTORNO       | lsart    | Storno-Lieferschein                 | @KuLiNr=1 @EKSLSNr=030-STLS  |
| 005 | +100-RLS  | (Purchasing):(PackingSlip)      | EKRUECKLIEFER        | 126     | EKRUECKLIEFER        | lsart    | Rücklieferschein                    | @KuLiNr=1 @EKRLSNr=100-RLS   |
| 006 | +115-RLS  | (Purchasing):(PackingSlip)      | EKSRUECKLIEFER       | 126     | EKSRUECKLIEFER       | lsart    | Stornierter Rücklieferschein        | @KuLiNr=1 @EKRLSNr=115-RLS   |
| 007 | +115-STRL | (Purchasing):(PackingSlip)      | EKRUECKLIEFERSTORNO  | 128     | EKRUECKLIEFERSTORNO  | lsart    | Storno-Rücklieferschein             | @KuLiNr=1 @EKSRLSNr=115-STRL |
| 008 | +012-RE   | (Purchasing):(Invoice)          | EKRECHNUNG           | 130     | EKRECHNUNG           | vorganga | Rechnung                            | @KuLiNr=1 @EKRechNr=012-RE   |
| 009 | +014-GS   | (Purchasing):(Invoice)          | EKGUTSCHRIFT         | 140     | EKGUTSCHRIFT         | vorganga | Kaufmännische Gutschrift            | @KuLiNr=1 @EKRechNr=014-GS   |
| 010 | +070-RE   | (Purchasing):(Invoice)          | EKSRECHNUNG          | 130     | EKSRECHNUNG          | vorganga | Stornierte Rechnung                 | @KuLiNr=1 @EKRechNr=070-RE   |
| 011 | +070-STRE | (Purchasing):(Invoice)          | EKSTORNORECHNUNG     | 136     | EKSTORNORECHNUNG     | vorganga | Storno-Rechnung                     | @KuLiNr=1 @EKSReNr=070-STRE  |
| 012 | +197-GS   | (Purchasing):(Invoice)          | EKSGUTSCHRIFT        | 140     | EKSGUTSCHRIFT        | vorganga | Stornierte kaufmännische Gutschrift | @KuLiNr=1 @EKRechNr=197-GS   |
| 013 | +197-STGS | (Purchasing):(Invoice)          | EKSTORNOGUTSCHRIFT   | 137     | EKSTORNOGUTSCHRIFT   | vorganga | Storno kaufmännische Gutschrift     | @KuLiNr=1 @EKSGsNr=197-STGS  |
| 014 | 013-ARE   | (Purchasing):(Invoice)          | EKANZAHLUNG          | 132     | EKANZAHLUNG          | vorganga | Anzahlung                           | @KuLiNr=1 @EKAReNr=013-ARE   |
| 015 | +014-ARE  | (Purchasing):(Invoice)          | EKSANZAHLUNG         | 132     | EKSANZAHLUNG         | vorganga | Stornierte Anzahlung                | @KuLiNr=1 @EKAReNr=014-ARE   |
| 016 | +015-ARS  | (Purchasing):(Invoice)          | EKSTORNOANZAHLUNG    | 136     | EKSTORNOANZAHLUNG    | vorganga | Storno-Anzahlung                    | @KuLiNr=1 @EKSReNr=015-ARS   |
| 017 | 023-BRE   | (Purchasing):(Invoice)          | EKBARZAHLUNG         | 130     | EKBARZAHLUNG         | vorganga | Barzahlung                          | @KuLiNr=1 @EKRechNr=023-BRE  |
| 018 | +024-BRE  | (Purchasing):(Invoice)          | EKSBARZAHLUNG        | 130     | EKSBARZAHLUNG        | vorganga | Stornierte Barzahlung               | @KuLiNr=1 @EKRechNr=024-BRE  |
| 019 | +025-BRS  | (Purchasing):(Invoice)          | EKSTORNOBARZAHLUNG   | 136     | EKSTORNOBARZAHLUNG   | vorganga | Storno-Barzahlung                   | @KuLiNr=1 @EKSReNr=025-BRS   |
| 020 | 1         | (Vendor):(Vendor)               |                      |         | EKLIEFERKORR         | nummer   | 1                                   | @KuLiNr=1 @KuLiKZ=L          |
| 021 | 010-FALL  | (Part):(Product)                | PRODINFO             | 400     | PRODINFO             | such     | FALL-010                            | @ArtNr=010-FALL              |

Scenario Outline: Layout MASTER und LSMASTER drucken
Given I open an editor "drucken" from table "<editor>" with command "VIEW" for record "<nummer>"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
And I save the current editor
And I switch the current editor to editor "drucken"
And I close the current editor

Examples:
| row | nummer    | editor                          | layout   |
#| 000 | 1122      | (Purchasing):(Request)          | MASTER   |
| 001 | 010-BE    | (Purchasing):(PurchaseOrder)    | MASTER   |
| 002 | 011-LS    | (Purchasing):(PackingSlip)      | LSMASTER |
| 003 | +030-LS   | (Purchasing):(PackingSlip)      | LSMASTER |
| 004 | +030-STLS | (Purchasing):(PackingSlip)      | LSMASTER |
| 005 | +100-RLS  | (Purchasing):(PackingSlip)      | LSMASTER |
| 006 | +115-RLS  | (Purchasing):(PackingSlip)      | LSMASTER |
| 007 | +115-STRL | (Purchasing):(PackingSlip)      | LSMASTER |
| 008 | +012-RE   | (Purchasing):(Invoice)          | MASTER   |
| 009 | +014-GS   | (Purchasing):(Invoice)          | MASTER   |
| 010 | +070-RE   | (Purchasing):(Invoice)          | MASTER   |
| 011 | +070-STRE | (Purchasing):(Invoice)          | MASTER   |
| 012 | +197-GS   | (Purchasing):(Invoice)          | MASTER   |
| 013 | +197-STGS | (Purchasing):(Invoice)          | MASTER   |
| 014 | 013-ARE   | (Purchasing):(Invoice)          | MASTER   |
| 015 | +014-ARE  | (Purchasing):(Invoice)          | MASTER   |
| 016 | +015-ARS  | (Purchasing):(Invoice)          | MASTER   |
| 017 | 023-BRE   | (Purchasing):(Invoice)          | MASTER   |
| 018 | +024-BRE  | (Purchasing):(Invoice)          | MASTER   |
| 019 | +025-BRS  | (Purchasing):(Invoice)          | MASTER   |

Scenario Outline: Dokumentverweis pruefen
Given I open an editor "verweis" from table "<editor>" with command "VIEW" for record "<nummer>"
Then field "<feld>^vorgang" is not empty
Then field "<barcodefeld>" is <barcode>
And I close the current editor

Examples:
| row | nummer    | editor                          | feld      | barcodefeld | barcode   |
#| 000 | 1122      | (Purchasing):(Request)          | doku      | barcode     | empty     |
| 001 | 010-BE    | (Purchasing):(PurchaseOrder)    | doku      | barcode     | empty     |
| 002 | 011-LS    | (Purchasing):(PackingSlip)      | doku      | barcode     | empty     |
| 003 | +030-LS   | (Purchasing):(PackingSlip)      | doku      | barcode     | empty     |
| 004 | +030-STLS | (Purchasing):(PackingSlip)      | doku      | barcode     | empty     |
| 005 | +100-RLS  | (Purchasing):(PackingSlip)      | doku      | barcode     | empty     |
| 006 | +115-RLS  | (Purchasing):(PackingSlip)      | doku      | barcode     | empty     |
| 007 | +115-STRL | (Purchasing):(PackingSlip)      | doku      | barcode     | empty     |
| 008 | +012-RE   | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 009 | +014-GS   | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 010 | +070-RE   | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 011 | +070-STRE | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 012 | +197-GS   | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 013 | +197-STGS | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 014 | 013-ARE   | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 015 | +014-ARE  | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 016 | +015-ARS  | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 017 | 023-BRE   | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 018 | +024-BRE  | (Purchasing):(Invoice)          | doku      | barcode     | empty     |
| 019 | +025-BRS  | (Purchasing):(Invoice)          | doku      | barcode     | empty     |

