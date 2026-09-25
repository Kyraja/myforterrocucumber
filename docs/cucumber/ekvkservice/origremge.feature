# *****************************************************************************
#  Name           : origremge.feature
#  Verantwortlich : teampss
#  Funktion       : Test zur Fakturierung der urspruenglichen Rechnungsmenge
#                   nach Ruecklieferungen
#
# *****************************************************************************
#
@persistent
Feature: Fakturierung der urspruenglichen Rechnungsmenge nach Ruecklieferungen
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario Outline: Stammdaten - Artikel
# ----------------------------------------------------------------------------------------------

Given I open an editor "artikel" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "fvhe" to "<fvhe>"
And I set field "vhe" to "<vhe>"
And I save the current editor


Examples:
| such        | namebspr          | vpr  | epr  | bsart            | dispoa          | fvhe | vhe |
| EK-ARTIKEL  | Einkaufsartikel   | 100  | 100  | Fremdbeschaffung | bedarfsbezogen  | 2    | kg  |
| VK-ARTIKEL  | Verkaufsartikel   | 200  | 200  | Eigenfertigung   | auftragsbezogen | 2    | kg  |
| EK-ARTIKEL2 | Einkaufsartikel 2 | 1000 | 10   | Fremdbeschaffung | bedarfsbezogen  | 1    | Stück |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Stammdaten - Dienstleistungen
# ----------------------------------------------------------------------------------------------

Given I open an editor "dienstleistung" from table "(Part):(Service)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I set field "vpe" to "h"
And I set field "vhe" to "h"
And I save the current editor

Examples:
| such        | namebspr  | vpr | epr |
| DL-ANALYSE  | Analyse   | 100 | 100 |
| DL-REPARTUR | Reparatur | 200 | 200 |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Stammdaten - Zusatzpositionen
# ----------------------------------------------------------------------------------------------

Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I set field "le" to "Stück"
And I set field "vpe" to "Stück"
And I set field "vhe" to "Stück"
And I save the current editor

Examples:
| such    | namebspr          | zptyp             | vpr | epr |
| NEPO    | Neutrale Position | Neutrale Position | 100 | 100 |
| AUBEPO  | AU/BE Position    | AU/BE             | 200 | 200 |

# ----------------------------------------------------------------------------------------------
Scenario: Betriebsdaten
# ----------------------------------------------------------------------------------------------

Given I open an editor "Betriebsdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set fields
    | kgskriterium | Nettosumme kleiner null |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS1 (fakt.) - LS2 (fakt.) - RE1 - RE2 - RLS1 - RLS2 - KGS1 - RE3 - KGS2 - KGS3 (Artikelposition)
# ----------------------------------------------------------------------------------------------

#  1BE001 ---------- 1LS001 (fakt.) ------ 1RE001
#  10 St.            5 St.                 5 St. (1)
#       \            | Aktion | remge  |
#        \           |        | 5 St.  |
#         \          | 1      | 0 St.  | (abgelegt)
#          \         | 2      | 0 St.  |
#           \        | 3      | 0 St.  |
#            \       | 4      | 0 St.  |
#             \      | 5      | 0 St.  |
#              \     | 6      | 0 St.  |
#               \    | 7      | 0 St.  |
#                \   | 8      | 0 St.  |
#                 \
#                   ---- 2LS001 (fakt.) ---------- 2RE001
#                        10 St.               \    5 St. (2)
#                        | Aktion | remge  |   \
#                        |        | 10 St. |    \
#                        | 1      | 10 St. |      ------------------------------------- 3RE001
#                        | 2      |  5 St. |                                            5 St. (6)
#                        | 3      |  5 St. |
#                        | 4      |  5 St. |
#                        | 5      |  5 St. |
#                        | 6      |  0 St. | (abgelegt)
#                        | 7      |  0 St. |
#                        | 8      |  0 St. |                               ------------------- 2KGS001
#                             \                                          /                     -1 St. (7)
#                                ------------------------ 1RLS001 -------------- 1KGS001
#                               \                         -3 St. (3)             -2 St. (5)
#                                \                        | Aktion | remge  |
#                                 \                       | 3      |  0 St. | (abgelegt)
#                                  \                      | 4      | -2 St. | (aktiv)
#                                   \                     | 5      |  0 St. | (abgelegt)
#                                    \                    | 6      | -1 St. | (aktiv)
#                                     \                   | 7      |  0 St. | (abgelegt)
#                                      \                  | 8      |  0 St. |
#                                       \
#                                          ------------------- 2RLS001 ------------------------------- 3KGS001
#                                                              -4 St. (4)                              -4 St. (8)
#                                                              | Aktion | remge  |
#                                                              | 4      | -2 St. | (aktiv)
#                                                              | 5      |  0 St. | (abgelegt)
#                                                              | 6      | -4 St. | (aktiv)
#                                                              | 7      | -4 St. |
#                                                              | 8      |  0 St. | (abgelegt)

# Bestellung
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE001 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Lieferschein 1
Given I open an editor "1LS001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE001"
And I set fields
   | nummer | 1LS001 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "5" in row 1
And I save the current editor

# Lieferschein 2 (Ueberbelieferung)
Given I open an editor "2LS001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE001"
And I set fields
   | nummer | 2LS001 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung zu Lieferschein 1
Given I open an editor "1RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS001"
And I set fields
   | nummer | 1RE001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1LS001" is filed

# Rechnung zu Lieferschein 2
Given I open an editor "2RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS001"
And I set fields
   | nummer | 2RE001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2LS001" in row 1 has value "5"

# Ruecklieferschein 1 zu Lieferschein 2
Given I open an editor "1RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS001"
And I set fields
   | nummer | 1RLS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I save the current editor

Then field "remge" from editor "2LS001" in row 1 has value "5"
Then field "remge" from editor "1RLS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS001" is filed

# Ruecklieferschein 2 zu Lieferschein 2
Given I open an editor "2RLS001" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS001"
And I set fields
   | nummer | 2RLS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

Then field "remge" from editor "2LS001" in row 1 has value "5"
Then field "remge" from editor "1RLS001" in row 1 has value "-2"
Then field "remge" from editor "2RLS001" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS001" is not filed

# Kaufm. Gutschrift zu Ruecklieferschein 1
Given I open an editor "1KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS001"
And I set fields
   | nummer | 1KGS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1RLS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS001" is filed
Then field "remge" from editor "2RLS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS001" is filed

# Rechnung zu Lieferschein 2
Given I open an editor "3RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS001"
And I set fields
   | nummer | 3RE001 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2LS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS001" is filed
Then field "remge" from editor "1RLS001" in row 1 has value "-1"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS001" is not filed
Then field "remge" from editor "2RLS001" in row 1 has value "-4"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS001" is not filed

# Kaufm. Gutschrift zu Ruecklieferschein 1
Given I open an editor "2KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS001"
And I set fields
   | nummer | 2KGS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1RLS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS001" is filed

# Kaufm. Gutschrift zu Ruecklieferschein 2
Given I open an editor "3KGS001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2RLS001"
And I set fields
   | nummer | 3KGS001 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2RLS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS001" is filed

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS1 (fakt.) - LS2 (fakt.) - RE1 - RE2 - RLS1 - RLS2 - KGS1 - RE3 - KGS2 - KGS3 (Artikelposition, Stornos)
# ----------------------------------------------------------------------------------------------

#  1BE001 ---------- 1LS001 (fakt.) ------ 1RE001
#  10 St.            5 St.                 5 St.
#       \
#          ------------- 2LS001 (fakt.) ---------- 2RE001
#                        10 St.               \    5 St.
#                          \                   \
#                           \                   \
#                            \                    ------------------------------------- 3RE001
#                             \                                                         5 St.
#                              \
#                               \                                           ------------------- 2KGS001
#                                \                                        /                     -1 St.
#                                   ---------------------- 1RLS001 -------------- 1KGS001
#                                  \                       -3 St.                 -2 St.
#                                   \
#                                      ------------------------ 2RLS001 ------------------------------- 3KGS001
#                                                               -4 St.                                  -4 St.

Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3RE001" throws the exception "2006"
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2RE001" throws the exception "3335"

Given I open an editor "1RE001S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1RE001"
And I set fields
   | nummer | 1RE001S |
And I save the current editor

Given I open an editor "2KGS001S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2KGS001"
And I set fields
   | nummer | 2KGS001S |
And I save the current editor

Given I open an editor "3KGS001S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3KGS001"
And I set fields
   | nummer | 3KGS001S |
And I save the current editor

Given I open an editor "1KGS001S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1KGS001"
And I set fields
   | nummer | 1KGS001S |
And I save the current editor

Then field "remge" from editor "1RLS001" in row 1 has value "-3"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS001" is not filed
Then field "remge" from editor "2RLS001" in row 1 has value "-4"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS001" is not filed

Given I open an editor "3RE001S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3RE001"
And I set fields
   | nummer | 3RE001S |
And I save the current editor

Then field "remge" from editor "2LS001" in row 1 has value "5"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS001" is not filed
Then field "remge" from editor "1RLS001" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS001" is not filed
Then field "remge" from editor "2RLS001" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS001" is not filed

Given I open an editor "2RE001S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2RE001"
And I set fields
   | nummer | 2RE001S |
And I save the current editor

Then field "remge" from editor "2LS001" in row 1 has value "10"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS001" is not filed
Then field "remge" from editor "1RLS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS001" is filed
Then field "remge" from editor "2RLS001" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS001" is filed

Given I open an editor "1RLS001S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS001"
And I set fields
   | nummer | 1RLS001S |
And I save the current editor

Given I open an editor "2RLS001S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "2RLS001"
And I set fields
   | nummer | 2RLS001S |
And I save the current editor

Then field "remge" from editor "2LS001" in row 1 has value "10"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS001" is not filed

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS1 (fakt.) - LS2 (fakt.) - RE1 - RE2 - RLS1 - RLS2 - KGS1 - RE3 - KGS2 - KGS3 (unterschiedliche Einheiten)
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE002 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Lieferschein 1
Given I open an editor "1LS002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE002"
And I set fields
   | nummer | 1LS002 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "5" in row 1
And I save the current editor

# Lieferschein 2 (Ueberbelieferung)
Given I open an editor "2LS002" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE002"
And I set fields
   | nummer | 2LS002 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung zu Lieferschein 1
Given I open an editor "1RE002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS002"
And I set fields
   | nummer | 1RE002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS002" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1LS002" is filed

# Rechnung zu Lieferschein 2
Given I open an editor "2RE002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS002"
And I set fields
   | nummer | 2RE002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2LS002" in row 1 has value "5"

# Ruecklieferschein 1 zu Lieferschein 2
Given I open an editor "1RLS002" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS002"
And I set fields
   | nummer | 1RLS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I save the current editor

Then field "remge" from editor "2LS002" in row 1 has value "5"
Then field "remge" from editor "1RLS002" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS002" is filed

# Ruecklieferschein 2 zu Lieferschein 2
Given I open an editor "2RLS002" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS002"
And I set fields
   | nummer | 2RLS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

Then field "remge" from editor "2LS002" in row 1 has value "5"
Then field "remge" from editor "1RLS002" in row 1 has value "-2"
Then field "remge" from editor "2RLS002" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS002" is not filed

# Kaufm. Gutschrift zu Ruecklieferschein 1
Given I open an editor "1KGS002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS002"
And I set fields
   | nummer | 1KGS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1RLS002" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS002" is filed
Then field "remge" from editor "2RLS002" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS002" is filed

# Rechnung zu Lieferschein 2
Given I open an editor "3RE002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS002"
And I set fields
   | nummer | 3RE002 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "he" to "kg" in row 1
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2LS002" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS002" is filed
Then field "remge" from editor "1RLS002" in row 1 has value "-1"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS002" is not filed
Then field "remge" from editor "2RLS002" in row 1 has value "-4"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS002" is not filed

# Kaufm. Gutschrift zu Ruecklieferschein 1
Given I open an editor "2KGS002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS002"
And I set fields
   | nummer | 2KGS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1RLS002" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS002" is filed

# Kaufm. Gutschrift zu Ruecklieferschein 2
Given I open an editor "3KGS002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2RLS002"
And I set fields
   | nummer | 3KGS002 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2RLS002" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS002" is filed

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS1 (fakt.) - LS2 (fakt.) - RE1 - RE2 - RLS1 - RLS2 - KGS1 - RE3 - KGS2 - KGS3 (AU/BE-Pos und Dienstleistung)
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE003 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | DL-ANALYSE | h     | 10  |
   | AUBEPO     | Stück | 10  |
And I save the current editor

# Lieferschein 1
Given I open an editor "1LS003" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE003"
And I set fields
   | nummer | 1LS003 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I save the current editor

# Lieferschein 2 (Ueberbelieferung)
Given I open an editor "2LS003" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE003"
And I set fields
   | nummer | 2LS003 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I save the current editor

# Rechnung zu Lieferschein 1
Given I open an editor "1RE003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS003"
And I set fields
   | nummer | 1RE003 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS003" in row 1 has value "0"
Then field "remge" from editor "1LS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1LS003" is filed

# Rechnung zu Lieferschein 2
Given I open an editor "2RE003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS003"
And I set fields
   | nummer | 2RE003 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2LS003" in row 1 has value "5"
Then field "remge" from editor "2LS003" in row 2 has value "5"

# Ruecklieferschein 1 zu Lieferschein 2
Given I open an editor "1RLS003" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS003"
And I set fields
   | nummer | 1RLS003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I set field "mge" to "-3" in row 2
And I save the current editor

Then field "remge" from editor "2LS003" in row 1 has value "5"
Then field "remge" from editor "2LS003" in row 2 has value "5"
Then field "remge" from editor "1RLS003" in row 1 has value "0"
Then field "remge" from editor "1RLS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS003" is filed

# Ruecklieferschein 2 zu Lieferschein 2
Given I open an editor "2RLS003" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS003"
And I set fields
   | nummer | 2RLS003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I set field "mge" to "-4" in row 2
And I save the current editor

Then field "remge" from editor "2LS003" in row 1 has value "5"
Then field "remge" from editor "2LS003" in row 2 has value "5"
Then field "remge" from editor "1RLS003" in row 1 has value "-2"
Then field "remge" from editor "1RLS003" in row 2 has value "-2"
Then field "remge" from editor "2RLS003" in row 1 has value "-2"
Then field "remge" from editor "2RLS003" in row 2 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS003" is not filed

# Kaufm. Gutschrift zu Ruecklieferschein 1
Given I open an editor "1KGS003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS003"
And I set fields
   | nummer | 1KGS003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-2" in row 1
And I set field "mge" to "-2" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1RLS003" in row 1 has value "0"
Then field "remge" from editor "1RLS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS003" is filed
Then field "remge" from editor "2RLS003" in row 1 has value "0"
Then field "remge" from editor "2RLS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS003" is filed

# Rechnung zu Lieferschein 2
Given I open an editor "3RE003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS003"
And I set fields
   | nummer | 3RE003 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2LS003" in row 1 has value "0"
Then field "remge" from editor "2LS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS003" is filed
Then field "remge" from editor "1RLS003" in row 1 has value "-1"
Then field "remge" from editor "1RLS003" in row 2 has value "-1"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS003" is not filed
Then field "remge" from editor "2RLS003" in row 1 has value "-4"
Then field "remge" from editor "2RLS003" in row 2 has value "-4"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS003" is not filed

# Kaufm. Gutschrift zu Ruecklieferschein 1
Given I open an editor "2KGS003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS003"
And I set fields
   | nummer | 2KGS003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1RLS003" in row 1 has value "0"
Then field "remge" from editor "1RLS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS003" is filed

# Kaufm. Gutschrift zu Ruecklieferschein 2
Given I open an editor "3KGS003" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2RLS003"
And I set fields
   | nummer | 3KGS003 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I set field "mge" to "-4" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2RLS003" in row 1 has value "0"
Then field "remge" from editor "2RLS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS003" is filed

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS1 (fakt.) - LS2 (fakt.) - RE1 - RE2 - RLS1 - RLS2 - KGS1 - RE3 - KGS2 - KGS3 (AU/BE-Pos und Dienstleistung, Stornos)
# ----------------------------------------------------------------------------------------------

Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3RE003" throws the exception "2006"
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2RE003" throws the exception "3335"

Given I open an editor "1RE003S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1RE003"
And I set fields
   | nummer | 1RE003S |
And I save the current editor

Given I open an editor "2KGS003S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2KGS003"
And I set fields
   | nummer | 2KGS003S |
And I save the current editor

Given I open an editor "3KGS003S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3KGS003"
And I set fields
   | nummer | 3KGS003S |
And I save the current editor

Given I open an editor "1KGS003S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1KGS003"
And I set fields
   | nummer | 1KGS003S |
And I save the current editor

Then field "remge" from editor "1RLS003" in row 1 has value "-3"
Then field "remge" from editor "1RLS003" in row 2 has value "-3"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS003" is not filed
Then field "remge" from editor "2RLS003" in row 1 has value "-4"
Then field "remge" from editor "2RLS003" in row 2 has value "-4"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS003" is not filed

Given I open an editor "3RE003S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3RE003"
And I set fields
   | nummer | 3RE003S |
And I save the current editor

Then field "remge" from editor "2LS003" in row 1 has value "5"
Then field "remge" from editor "2LS003" in row 2 has value "5"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS003" is not filed
Then field "remge" from editor "1RLS003" in row 1 has value "-2"
Then field "remge" from editor "1RLS003" in row 2 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS003" is not filed
Then field "remge" from editor "2RLS003" in row 1 has value "-2"
Then field "remge" from editor "2RLS003" in row 2 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS003" is not filed

Given I open an editor "2RE003S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2RE003"
And I set fields
   | nummer | 2RE003S |
And I save the current editor

Then field "remge" from editor "2LS003" in row 1 has value "10"
Then field "remge" from editor "2LS003" in row 2 has value "10"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS003" is not filed
Then field "remge" from editor "1RLS003" in row 1 has value "0"
Then field "remge" from editor "1RLS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS003" is filed
Then field "remge" from editor "2RLS003" in row 1 has value "0"
Then field "remge" from editor "2RLS003" in row 2 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS003" is filed

Given I open an editor "1RLS003S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS003"
And I set fields
   | nummer | 1RLS003S |
And I save the current editor

Given I open an editor "2RLS003S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "2RLS003"
And I set fields
   | nummer | 2RLS003S |
And I save the current editor

Then field "remge" from editor "2LS003" in row 1 has value "10"
Then field "remge" from editor "2LS003" in row 2 has value "10"
Then "(Purchasing):(PackingSlip)" with the editor id "2LS003" is not filed

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS (fakt.) - RE1 - RLS1 - KGS1 - RE2 (Neutrale Position)
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE004" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE004 |
   | lief   | 1      |
And I append rows
   | artikel | pwert |
   | NEPO    | 100   |
And I save the current editor

# Lieferschein
Given I open an editor "1LS004" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE004"
And I set fields
   | nummer | 1LS004 |
   | vom    | .      |
   | ueb    | ja     |
And I save the current editor

# Rechnung zu Lieferschein
Given I open an editor "1RE004" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS004"
And I set fields
   | nummer | 1RE004 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS004" in row 1 has value "50"
Then "(Purchasing):(PackingSlip)" with the editor id "1LS004" is not filed

# Ruecklieferschein zum Lieferschein
Given I open an editor "1RLS004" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS004"
And I set fields
   | nummer | 1RLS004 |
   | ueb    | ja      |
   | vom    | .       |
And I save the current editor

Then field "remge" from editor "1LS004" in row 1 has value "50"
Then field "remge" from editor "1RLS004" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS004" is filed

# Kaufm. Gutschrift zu Ruecklieferschein
Given I open an editor "1KGS004" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS004"
And I set fields
   | nummer | 1KGS004 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "-50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS004" in row 1 has value "50"
Then field "remge" from editor "1RLS004" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS004" is filed

# Rechnung zu Lieferschein
Given I open an editor "2RE004" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS004"
And I set fields
   | nummer | 2RE004 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1LS004" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1LS004" is filed

# ----------------------------------------------------------------------------------------------
Scenario: BE (fakt.) - LS1 - LS2 - RE1 - RE2 - RLS1 - RLS2 - KGS1 - RE3 - KGS2 - KGS3 (Artikelposition)
# ----------------------------------------------------------------------------------------------

#  1BE005 (fakt.)
#  10 St.
#  | Aktion | remge  |
#  |        | 15 St. |
#  | 1      | 10 St. |
#  | 2      |  5 St. |
#  | 3      |  5 St. |
#  | 4      |  5 St. |
#  | 5      |  5 St. |
#  | 6      |  0 St. |
#  | 7      |  0 St. |
#  | 8      |  0 St. |
#      \
#         ------ 1LS005
#        \       5 St.
#         \
#            ------ 2LS005
#           \        10 St.
#            \        \                                               ------------------- 2KGS005
#             \        \                                            /                     -1 St. (7)
#              \          -------------------------- 1RLS005 -------------- 1KGS005
#               \        \                           -3 St. (3)             -2 St. (5)
#                \        \                          | Aktion | remge  |
#                 \        \                         | 3      |  0 St. | (abgelegt)
#                  \        \                        | 4      | -2 St. | (aktiv)
#                   \        \                       | 5      |  0 St. | (abgelegt)
#                    \        \                      | 6      | -1 St. | (aktiv)
#                     \        \                     | 7      |  0 St. | (abgelegt)
#                      \        \                    | 8      |  0 St. |
#                       \        \
#                        \          --------------------- 2RLS005 ------------------------------- 3KGS005
#                         \                               -4 St. (4)                              -2 St. (8)
#                          \                              | Aktion | remge  |
#                           \                             | 4      | -2 St. | (aktiv)
#                            \                            | 5      |  0 St. | (abgelegt)
#                             \                           | 6      | -4 St. | (aktiv)
#                              \                          | 7      | -4 St. |
#                               \                         | 8      |  0 St. | (abgelegt)
#                                  ------ 1RE005
#                                 \        5 St. (1)
#                                  \
#                                     ------ 2RE005
#                                    \       5 St. (2)
#                                     \
#                                        ---------------------------------------- 3RE005
#                                                                                 5 St. (6)
#

# Bestellung
Given I open an editor "1BE005" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE005 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Lieferschein 1
Given I open an editor "1LS005" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE005"
And I set fields
   | nummer | 1LS005 |
   | vom    | .      |
   | fakt   | nein   |
   | ueb    | ja     |
And I set field "mge" to "5" in row 1
And I save the current editor

# Lieferschein 2 (Ueberbelieferung)
Given I open an editor "2LS005" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE005"
And I set fields
   | nummer | 2LS005 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung 1 zur Bestellung
Given I open an editor "1RE005" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE005"
And I set fields
   | nummer | 1RE005 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2 zur Bestellung
Given I open an editor "2RE005" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE005"
And I set fields
   | nummer | 2RE005 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1BE005" in row 1 has value "5"
Then "(Purchasing):(PurchaseOrder)" with the editor id "1BE005" is not filed

# Ruecklieferschein 1 zu Lieferschein 2
Given I open an editor "1RLS005" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS005"
And I set fields
   | nummer | 1RLS005 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I save the current editor

Then field "remge" from editor "1BE005" in row 1 has value "5"
Then field "remge" from editor "1RLS005" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS005" is filed

# Ruecklieferschein 2 zu Lieferschein 2
Given I open an editor "2RLS005" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS005"
And I set fields
   | nummer | 2RLS005 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

Then field "remge" from editor "1BE005" in row 1 has value "5"
Then field "remge" from editor "1RLS005" in row 1 has value "-2"
Then field "remge" from editor "2RLS005" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS005" is not filed

# Kaufm. Gutschrift zu Ruecklieferschein 1
Given I open an editor "1KGS005" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS005"
And I set fields
   | nummer | 1KGS005 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1RLS005" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS005" is filed
Then field "remge" from editor "2RLS005" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS005" is filed

# Rechnung zur Bestellung
Given I open an editor "3RE005" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE005"
And I set fields
   | nummer | 3RE005 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1BE005" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "1BE005" is filed
Then field "remge" from editor "1RLS005" in row 1 has value "-1"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS005" is not filed
Then field "remge" from editor "2RLS005" in row 1 has value "-4"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS005" is not filed

# Kaufm. Gutschrift zu Ruecklieferschein 1
Given I open an editor "2KGS005" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS005"
And I set fields
   | nummer | 2KGS005 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1RLS005" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS005" is filed

# Kaufm. Gutschrift zu Ruecklieferschein 2
Given I open an editor "3KGS005" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2RLS005"
And I set fields
   | nummer | 3KGS005 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "2RLS005" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS005" is filed

# ----------------------------------------------------------------------------------------------
Scenario: BE (fakt.) - LS1 - LS2 - RE1 - RE2 - RLS1 - RLS2 - KGS1 - RE3 - KGS2 - KGS3 (Artikelposition, Stornos)
# ----------------------------------------------------------------------------------------------

#  1BE005 (fakt.)
#  10 St.
#      \
#         ------ 1LS005
#        \       5 St.
#         \
#            ------ 2LS005
#           \        10 St.
#            \        \                                    ------------------- 2KGS005
#             \        \                                  /                     -1 St.
#              \          ---------------- 1RLS005 -------------- 1KGS005
#               \        \                 -3 St.                 -2 St.
#                \        \
#                 \          --------------------- 2RLS005 ------------------------- 3KGS005
#                  \                               -4 St.                            -2 St.
#                   \
#                    \
#                       ------ 1RE005
#                      \        5 St.
#                       \
#                          ------ 2RE005
#                         \       5 St.
#                          \
#                             ------------------------------------------ 3RE005
#                                                                        5 St.
#

Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1RE005" throws the exception "3335"
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2RE005" throws the exception "3335"
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3RE005" throws the exception "2006"

# Given I open an editor "1RE005S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3RE005"
# And I set fields
#    | nummer | 1RE005S |
# And I save the current editor
#
Then field "remge" from editor "1BE005" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "1BE005" is filed

Given I open an editor "2KGS005S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2KGS005"
And I set fields
   | nummer | 2KGS005S |
And I save the current editor

Given I open an editor "3KGS005S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3KGS005"
And I set fields
   | nummer | 3KGS005S |
And I save the current editor

Given I open an editor "1KGS005S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1KGS005"
And I set fields
   | nummer | 1KGS005S |
And I save the current editor

Then field "remge" from editor "1RLS005" in row 1 has value "-3"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS005" is not filed
Then field "remge" from editor "2RLS005" in row 1 has value "-4"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS005" is not filed

Given I open an editor "2RE005S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "3RE005"
And I set fields
   | nummer | 2RE005S |
And I save the current editor

Then field "remge" from editor "1BE005" in row 1 has value "5"
Then "(Purchasing):(PurchaseOrder)" with the editor id "1BE005" is not filed
Then field "remge" from editor "1RLS005" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS005" is not filed
Then field "remge" from editor "2RLS005" in row 1 has value "-2"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS005" is not filed

Given I open an editor "3RE005S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2RE005"
And I set fields
   | nummer | 3RE005S |
And I save the current editor

Then field "remge" from editor "1BE005" in row 1 has value "10"
Then "(Purchasing):(PurchaseOrder)" with the editor id "1BE005" is not filed
Then field "remge" from editor "1RLS005" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "1RLS005" is filed
Then field "remge" from editor "2RLS005" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "2RLS005" is filed

Given I open an editor "1RLS005S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS005"
And I set fields
   | nummer | 1RLS005S |
And I save the current editor

Given I open an editor "2RLS005S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "2RLS005"
And I set fields
   | nummer | 2RLS005S |
And I save the current editor

Then field "remge" from editor "1BE005" in row 1 has value "10"
Then "(Purchasing):(PurchaseOrder)" with the editor id "1BE005" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: Bestellung - Lieferschein - Ruecklieferschein - Rechnung - KGS - Storno-KGS
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE006" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1      |
   | nummer  | 1BE006 |
   | such    | BE006  |
And I append rows
   | artikel     | mge  |
   | EK-ARTIKEL2 | 100  |
And I save the current editor

# Lieferschein
Given I open an editor "LS006" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE006"
And I set fields
   | nummer | 1LS006  |
   | such   | LS006   |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL006 |
Then the table has 1 rows
And I set field "mge" to "100" in row 1
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS006" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS006"
And I set fields
   | nummer | 1RLS006 |
   | such   | RLS006  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "-50" in row 1
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "RE006" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS006"
And I set fields
   | nummer | 1RE006  |
   | such   | RE006   |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL006 |
Then the table has 1 rows
And I set field "mge" to "100" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kaufmaennische Gutschrift auf Ruecklieferung
Given I open an editor "KGS006" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS006"
And I set fields
   | nummer | 1KGS006 |
   | such   | KGS006  |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL006 |
Then the table has 1 rows
And I set field "mge" to "-50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kaufmaennische Gutschrift stornieren
Given I open an editor "ST_KGS006" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS006"
And I save the current editor

# Ruecklieferschein pruefen
Given I open an editor "RLS006P" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "RLS006"
Then field "ablagef" has value "nein"
Then field "remge" has value "-50" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Restmengenstorno 1  Bestellung - Lieferschein - Ruecklieferschein - Rechnung - Kaufmaennische Gutschrift
# ----------------------------------------------------------------------------------------------
Given I open an editor "BE007" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1      |
   | nummer  | 1BE007 |
   | such    | BE007  |
And I append rows
   | artikel     | mge  |
   | EK-ARTIKEL2 | 100  |
And I save the current editor

# Lieferschein
Given I open an editor "LS007" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE007"
And I set fields
   | nummer | 1LS007  |
   | such   | LS007   |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL007 |
Then the table has 1 rows
And I set field "mge" to "100" in row 1
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS007" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS007"
And I set fields
   | nummer | 1RLS007 |
   | such   | RLS007  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "-50" in row 1
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "RE007" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS007"
And I set fields
   | nummer | 1RE007  |
   | such   | RE007   |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL007 |
Then the table has 1 rows
And I set field "mge" to "80" in row 1
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kaufmaennische Gutschrift auf Ruecklieferung
Given I open an editor "KGS007" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS007"
And I set fields
   | nummer | 1KGS007 |
   | such   | KGS007  |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL007 |
Then the table has 1 rows
Then field "mge" has value "-30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Restmengenstorno 2 Bestellung - Lieferschein - Ruecklieferschein - Rechnung 1 - Rechnung 2 - Kaufmaennische Gutschrift
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE008" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1      |
   | nummer  | 1BE008 |
   | such    | BE008  |
And I append rows
   | artikel     | mge  |
   | EK-ARTIKEL2 | 100  |
And I save the current editor

# Lieferschein
Given I open an editor "LS008" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE008"
And I set fields
   | nummer | 1LS008  |
   | such   | LS008   |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL008 |
Then the table has 1 rows
And I set field "mge" to "100" in row 1
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS008" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS008"
And I set fields
   | nummer | 1RLS008 |
   | such   | RLS008  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 1 rows
And I set field "mge" to "-50" in row 1
And I save the current editor

# Rechnung 1 aus Lieferschein
Given I open an editor "RE008A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS008"
And I set fields
   | nummer | 1RE008A |
   | such   | RE008A  |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL008 |
Then the table has 1 rows
And I set field "mge" to "80" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2 aus Lieferschein
Given I open an editor "RE008B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS008"
And I set fields
   | nummer | 1RE008B |
   | such   | RE008B  |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL008 |
Then the table has 1 rows
And I set field "mge" to "0" in row 1
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Kaufmaennische Gutschrift aus Ruecklieferung
Given I open an editor "KGS008" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS008"
And I set fields
   | nummer | 1KGS008 |
   | such   | KGS008  |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | FALL008 |
Then the table has 1 rows
Then field "mge" has value "-30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Bestellung - Lieferschein - Ruecklieferschein - Rechnung - TWGS
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE009" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1      |
   | nummer  | 1BE009 |
   | such    | BE009  |
And I append rows
   | artikel     | mge         | pwert       |
   | EK-ARTIKEL2 | 100         | !dontChange |
   | AUBEPO      |  50         | !dontChange |
   | NEPO        | !dontChange |      150.00 |
And I save the current editor

# Lieferschein
Given I open an editor "LS009" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE009"
And I set fields
   | nummer | 1LS009  |
   | such   | LS009   |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "50" in row 2
And I set field "pwert" to "150" in row 3
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS009" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS009"
And I set fields
   | nummer | 1RLS009 |
   | such   | RLS009  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "-50" in row 1
And I set field "mge" to "-25" in row 2
And I set field "pwert" to "-75" in row 3
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "RE009" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS009"
And I set fields
   | nummer | 1RE009  |
   | such   | RE009   |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "50" in row 2
And I set field "pwert" to "150" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE009" in row 1 has value "-50"
Then field "remge" from editor "RE009" in row 2 has value "-25"
Then field "remge" from editor "RE009" in row 3 has value "-75"

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RLS009" in row 1 has value "-50"
Then field "remge" from editor "RLS009" in row 2 has value "-25"
Then field "remge" from editor "RLS009" in row 3 has value "-75"

# Teilwertgutschrift
Given I open an editor "TWGS009" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE009"
And I set fields
   | nummer | 1TWG009 |
   | such   | TWG009  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 6 rows
And I press button "komplettieren"
Then field "mge" has value "-50" in row 1
Then field "mge" has value "-25" in row 2
Then field "pwert" has value "-75.00" in row 3
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RLS009" in row 1 has value "-50"
Then field "remge" from editor "RLS009" in row 2 has value "-25"
Then field "remge" from editor "RLS009" in row 3 has value "-75"

# Kaufm. Gutschrift zu Ruecklieferschein
Given I open an editor "1KGS009" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS009"
And I set fields
   | nummer | 1KGS009 |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
Then field "mge" has value "-50" in row 1
Then field "mge" has value "-25" in row 2
Then field "pwert" has value "-75.00" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Bestellung - Lieferschein - Ruecklieferschein - Rechnung A+B+C - TWGS A+B+C
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE010" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1      |
   | nummer  | 1BE010 |
   | such    | BE010  |
And I append rows
   | artikel     | mge         | pwert       |
   | EK-ARTIKEL2 | 100         | !dontChange |
   | DL-ANALYSE  |  9          | !dontChange |
   | TEXT        | !dontChange |      120.00 |
And I save the current editor

# Lieferschein
Given I open an editor "LS010" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE010"
And I set fields
   | nummer | 1LS010  |
   | such   | LS010   |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "9" in row 2
And I set field "pwert" to "120" in row 3
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS010" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS010"
And I set fields
   | nummer | 1RLS010 |
   | such   | RLS010  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "-50" in row 1
And I set field "mge" to "-2" in row 2
And I set field "pwert" to "-55" in row 3
And I save the current editor

# Rechnung A aus Lieferschein
Given I open an editor "RE010A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS010"
And I set fields
   | nummer | 1RE010A |
   | such   | RE010A  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "20" in row 1
And I set field "mge" to "4" in row 2
And I set field "pwert" to "50" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE010A" in row 1 has value "-20"
Then field "remge" from editor "RE010A" in row 2 has value "-4"
Then field "remge" from editor "RE010A" in row 3 has value "-50"

# Rechnung B aus Lieferschein
Given I open an editor "RE010B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS010"
And I set fields
   | nummer | 1RE010B |
   | such   | RE010B  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "40" in row 1
And I set field "preis" to "11" in row 1
And I set field "mge" to "3" in row 2
And I set field "pwert" to "25" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE010B" in row 1 has value "-30"
Then field "remge" from editor "RE010B" in row 2 has value "-3"
Then field "remge" from editor "RE010B" in row 3 has value "-15"

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE010A" in row 1 has value "-20"
Then field "remge" from editor "RE010A" in row 2 has value "-4"
Then field "remge" from editor "RE010A" in row 3 has value "-50"

# Rechnung C aus Lieferschein
Given I open an editor "RE010C" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS010"
And I set fields
   | nummer | 1RE010C |
   | such   | RE010C  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 3 rows
And I set field "mge" to "40" in row 1
And I set field "preis" to "12" in row 1
And I set field "mge" to "2" in row 2
And I set field "pwert" to "45" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE010C" in row 1 has value "0"
Then field "remge" from editor "RE010C" in row 2 has value "0"
Then field "remge" from editor "RE010C" in row 3 has value "0"

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE010A" in row 1 has value "-20"
Then field "remge" from editor "RE010A" in row 2 has value "-4"
Then field "remge" from editor "RE010A" in row 3 has value "-50"

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE010B" in row 1 has value "-30"
Then field "remge" from editor "RE010B" in row 2 has value "-3"
Then field "remge" from editor "RE010B" in row 3 has value "-15"

# Teilwertgutschrift A
Given I open an editor "TWG010A" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE010A"
And I set fields
   | nummer | 1TWG010 |
   | such   | TWG010  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 6 rows
And I press button "komplettieren"
# Soll 0 | 0 | -5
Then field "mge" has value "-20" in row 1
Then field "mge" has value "-4" in row 2
Then field "pwert" has value "-50.00" in row 3
And I close the current editor

# Teilwertgutschrift B
Given I open an editor "TWG010B" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE010B"
And I set fields
   | nummer | 1TWG010B |
   | such   | TWG010B  |
   | ueb    | ja       |
   | vom    | .        |
Then the table has 6 rows
And I press button "komplettieren"
Then field "mge" has value "-30" in row 1
Then field "mge" has value "-3" in row 2
Then field "pwert" has value "-15.00" in row 3
And I save the current editor

# Teilwertgutschrift C nichts mehr gutzuschreiben
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE010C" throws the exception "2620"

# Kaufm. Gutschrift zu Ruecklieferschein
Given I open an editor "KGS010" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS010"
And I set fields
   | nummer | 1KGS010 |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 5 rows
Then field "mge" has value "-10" in row 1
Then field "mge" has value "-40" in row 2
Then field "mge" has value "-2" in row 3
Then field "pwert" has value "-10.00" in row 4
Then field "pwert" has value "-45.00" in row 5
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung mit LG - Ruecklieferung - TWGS
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "RE011" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE011  |
   | kunde  | 1       |
   | such   | RE011   |
   | ueb    | ja      |
   | tterm  | .       |
And I append rows
   | artikel    | mge         | preis       | pwert       |
   | VK-Artikel | 20          | 35          | !dontChange |
   | AUBEPO     |  7          |  5          | !dontChange |
   | DL-ANALYSE |  5          | 20          | !dontChange |
   | TEXT       | !dontChange | !dontChange |       70.00 |
   | NEPO       | !dontChange | !dontChange |      250.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE011" in row 1 has value "-20"
Then field "remge" from editor "RE011" in row 2 has value "-7"
Then field "remge" from editor "RE011" in row 3 has value "-5"
Then field "remge" from editor "RE011" in row 4 has value "-70"
Then field "remge" from editor "RE011" in row 5 has value "-250"

# Wertgutschrift
Given I open an editor "WGS011" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE011"
And I set fields
   | nummer | 1WGS011 |
   | such   | WGS011  |
   | ueb    | ja      |
   | tterm  | .       |
Then the table has 8 rows
And I press button "komplettieren"
Then field "mge" has value "-20" in row 1
Then field "mge" has value "-7" in row 2
Then field "mge" has value "-5" in row 3
Then field "pwert" has value "-70.00" in row 4
Then field "pwert" has value "-250.00" in row 5
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS011" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE011"
And I set fields
   | nummer | 1RLS011 |
   | such   | RLS011  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 5 rows
And I set field "mge" to "-6" in row 1
And I set field "mge" to "-4" in row 2
And I set field "mge" to "-3" in row 3
And I set field "pwert" to "-60" in row 4
And I set field "pwert" to "-135" in row 5
And I save the current editor

# Rechnungskorrektur
Given I open an editor "REK011" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE011"
And I set fields
   | nummer | 1REK011    |
   | such   | REK011     |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I press button "burekorrektur"
And I set field "mge" to "20" in row 1
And I set field "preis" to "40" in row 1
And I set field "mge" to "7" in row 2
And I set field "mge" to "5" in row 3
And I set field "pwert" to "70.00" in row 4
And I set field "pwert" to "250.00" in row 5
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "REK011" in row 1 has value "-14"
Then field "remge" from editor "REK011" in row 2 has value "-3"
Then field "remge" from editor "REK011" in row 3 has value "-2"
Then field "remge" from editor "REK011" in row 4 has value "-10"
Then field "remge" from editor "REK011" in row 5 has value "-115"

Then field "remge" from editor "RLS011" in row 1 has value "-6"
Then field "remge" from editor "RLS011" in row 2 has value "-4"
Then field "remge" from editor "RLS011" in row 3 has value "-3"
Then field "remge" from editor "RLS011" in row 4 has value "-60"
Then field "remge" from editor "RLS011" in row 5 has value "-135"

# Wertgutschrift
Given I open an editor "TWG011" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "REK011"
And I set fields
   | nummer | 1TWG011 |
   | such   | TWG011  |
   | ueb    | ja      |
   | tterm  | .       |
Then the table has 8 rows
And I press button "komplettieren"
Then field "mge" has value "-14" in row 1
Then field "mge" has value "-3" in row 2
Then field "mge" has value "-2" in row 3
Then field "pwert" has value "-10.00" in row 4
Then field "pwert" has value "-115.00" in row 5
And I close the current editor

# Kaufm. Gutschrift zu Ruecklieferschein
Given I open an editor "KGS011" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS011"
And I set fields
   | nummer | 1KGS010 |
   | such   | KGS010  |
   | ueb    | ja      |
   | tterm  | .       |
Then the table has 5 rows
Then field "mge" has value "-6" in row 1
Then field "preis" has value "40.00" in row 1
Then field "mge" has value "-4" in row 2
Then field "mge" has value "-3" in row 3
Then field "pwert" has value "-60.00" in row 4
Then field "pwert" has value "-135.00" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag - Lieferschein A+B - Ruecklieferschein A - Rechnung A - Ruecklieferschein B - Rechnung B - TWGS A+B
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU012" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | nummer  | 1AU012 |
   | such    | AU012  |
And I append rows
   | artikel    | mge         | pwert       |
   | VK-Artikel | 100         | !dontChange |
   | AUBEPO     |  10         | !dontChange |
   | TEXT       | !dontChange |      100.00 |
And I save the current editor

# Lieferschein A
Given I open an editor "LS012A" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU012"
And I set fields
   | nummer | 1LS012A |
   | such   | LS012A  |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
Then the table has 3 rows
And I set field "mge" to "60" in row 1
And I set field "mge" to "6" in row 2
And I set field "pwert" to "60.00" in row 3
And I save the current editor

# Lieferschein B
Given I open an editor "LS012B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU012"
And I set fields
   | nummer | 1LS012B  |
   | such   | LS012B   |
   | ueb    | ja       |
   | vom    | .        |
Then the table has 3 rows
And I set field "mge" to "40" in row 1
And I set field "mge" to "4" in row 2
And I set field "pwert" to "40.00" in row 3
And I save the current editor

# Ruecklieferschein A
Given I open an editor "RLS012A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS012A"
And I set fields
   | nummer | 1RLS012A |
   | such   | RLS012A  |
   | ueb    | ja       |
   | vom    | .        |
Then the table has 3 rows
And I set field "mge" to "-50" in row 1
And I set field "mge" to "-5" in row 2
And I set field "pwert" to "-50.00" in row 3
And I save the current editor

# Rechnung A aus Auftrag
Given I open an editor "RE012A" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU012"
And I set fields
   | nummer | 1RE012A |
   | such   | RE012A  |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
Then the table has 3 rows
And I set field "mge" to "70" in row 1
And I set field "mge" to "7" in row 2
And I set field "pwert" to "70.00" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
# Soll -50, -5, -50
Then field "remge" from editor "RE012A" in row 1 has value "-50"
Then field "ofwert" from editor "RE012A" in row 1 has value "-5000.00"
Then field "remge" from editor "RE012A" in row 2 has value "-5"
Then field "ofwert" from editor "RE012A" in row 2 has value "-1000.00"
Then field "remge" from editor "RE012A" in row 3 has value "-50"
Then field "ofwert" from editor "RE012A" in row 3 has value "-50.00"

Then field "remge" from editor "RLS012A" in row 1 has value "-20"
Then field "remge" from editor "RLS012A" in row 2 has value "-2"
Then field "remge" from editor "RLS012A" in row 3 has value "-20"

# Ruecklieferschein B
Given I open an editor "RLS012B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS012B"
And I set fields
   | nummer | 1RLS012B |
   | such   | RLS012B  |
   | ueb    | ja       |
   | vom    | .        |
Then the table has 3 rows
And I set field "mge" to "-25" in row 1
And I set field "mge" to "-2.5" in row 2
And I set field "pwert" to "-25.00" in row 3
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE012A" in row 1 has value "-25"
Then field "ofwert" from editor "RE012A" in row 1 has value "-2500.00"
Then field "remge" from editor "RE012A" in row 2 has value "-2.5"
Then field "ofwert" from editor "RE012A" in row 2 has value "-500.00"
Then field "remge" from editor "RE012A" in row 3 has value "-25"
Then field "ofwert" from editor "RE012A" in row 3 has value "-25.00"

Then field "remge" from editor "RLS012A" in row 1 has value "-45"
Then field "remge" from editor "RLS012A" in row 2 has value "-4.5"
Then field "remge" from editor "RLS012A" in row 3 has value "-45"

Then field "remge" from editor "RLS012B" in row 1 has value "-25"
Then field "remge" from editor "RLS012B" in row 2 has value "-2.5"
Then field "remge" from editor "RLS012B" in row 3 has value "-25"

# Rechnung B aus Auftrag
Given I open an editor "RE012B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU012"
And I set fields
   | nummer | 1RE012B |
   | such   | RE012B  |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
Then the table has 3 rows
And I set field "mge" to "30" in row 1
And I set field "mge" to "3" in row 2
And I set field "pwert" to "30.00" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE012A" in row 1 has value "-25"
Then field "ofwert" from editor "RE012A" in row 1 has value "-2500.00"
Then field "remge" from editor "RE012A" in row 2 has value "-2.5"
Then field "remge" from editor "RE012A" in row 3 has value "-25"

Then field "remge" from editor "RE012B" in row 1 has value "0"
Then field "remge" from editor "RE012B" in row 2 has value "0"
Then field "remge" from editor "RE012B" in row 3 has value "0"

Then field "remge" from editor "RLS012A" in row 1 has value "-50"
Then field "remge" from editor "RLS012A" in row 2 has value "-5"
Then field "remge" from editor "RLS012A" in row 3 has value "-50"

Then field "remge" from editor "RLS012B" in row 1 has value "-25"
Then field "remge" from editor "RLS012B" in row 2 has value "-2.5"
Then field "remge" from editor "RLS012B" in row 3 has value "-25"

# Teilwertgutschrift A
Given I open an editor "TWG012A" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE012A"
And I set fields
   | nummer | 1TWG012A |
   | such   | TWG012A  |
   | ueb    | ja       |
   | tterm  | .        |
Then the table has 6 rows
And I press button "komplettieren"
# mge fehlt
Then field "mge" has value "-25" in row 1
Then field "mge" has value "-2.5" in row 2
Then field "pwert" has value "-25.00" in row 3
And I close the current editor

# Teilwertgutschrift B nichts mehr gutzuschreiben
Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE012B" throws the exception "2620"

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS - RLS - RE (Typ = Rechnung) - Storno RLS
# ----------------------------------------------------------------------------------------------

#  1BE013 (fakt.)
#  10 St.
#      \
#         ------ 1LS013 (fakt.) ------------- 1RE013
#        \       5 St.                        5 St.
#         \       \
#          \        -------------- 1RLS013 -------------------------------- Storno (nicht erlaubt)
#           \                     -5 St.
#              --------- 2LS013
#             \          5 St.
#              \          \
#               \           --------------------------- 2RLS013 ----------- Storno (nicht erlaubt)
#                \                                     -5 St.
#                 \
#                    -------------------------------------------- 2RE013
#                                                                 5 St.
#

# Bestellung
Given I open an editor "1BE013" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE013 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Lieferschein 1 (fakt = ja)
Given I open an editor "1LS013" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE013"
And I set fields
   | nummer | 1LS013 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "5" in row 1
And I save the current editor

# Lieferschein 2 (fakt = nein)
Given I open an editor "2LS013" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE013"
And I set fields
   | nummer | 2LS013 |
   | vom    | .      |
   | fakt   | nein   |
   | ueb    | ja     |
And I set field "mge" to "5" in row 1
And I save the current editor

# Ruecklieferschein 1 aus Lieferschein 1
Given I open an editor "1RLS013" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS013"
And I set fields
   | nummer | 1RLS013 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Rechnung 1 aus Lieferschein 1
Given I open an editor "1RE013" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS013"
And I set fields
   | nummer | 1RE013 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein 2 aus Lieferschein 2
Given I open an editor "2RLS013" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS013"
And I set fields
   | nummer | 2RLS013 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Rechnung 2 aus Bestellung
Given I open an editor "2RE013" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE013"
And I set fields
   | nummer | 2RE013 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno Ruecklieferschein 1 - nicht erlaubt, erst Rechnung stornieren
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS013" throws the exception "3335"

# Storno Ruecklieferschein 2 - nicht erlaubt, erst Rechnung stornieren
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "2RLS013" throws the exception "3335"

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS - RLS - RE (Typ = Barzahlung) - Storno RLS
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE014" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE014 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Lieferschein
Given I open an editor "1LS014" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE014"
And I set fields
   | nummer | 1LS014 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS014" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS014"
And I set fields
   | nummer | 1RLS014 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE014" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS014"
And I set fields
   | nummer   | 1RE014     |
   | vorganga | Barzahlung |
   | ueb      | ja         |
   | vom      | .          |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno Ruecklieferschein - nicht erlaubt, erst Rechnung stornieren
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS014" throws the exception "3335"

# ----------------------------------------------------------------------------------------------
Scenario: BE - LS - RLS - RE (Typ = Kaufm. Gutschrift) - Storno RLS
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE015" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE015 |
   | lief   | 1      |
And I append rows
   | artikel    | he    | mge |
   | EK-ARTIKEL | Stück | 10  |
And I save the current editor

# Lieferschein
Given I open an editor "1LS015" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1BE015"
And I set fields
   | nummer | 1LS015 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS015" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS015"
And I set fields
   | nummer | 1RLS015 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE015" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS015"
And I set fields
   | nummer   | 1RE015     |
   | ueb      | ja         |
   | vom      | .          |
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 2
And I set field "pwert" to "-2000" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno Ruecklieferschein - nicht erlaubt, erst Rechnung stornieren
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS015" throws the exception "3335"

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag - Lieferschein - Ruecklieferschein A - Rechnung A - Ruecklieferschein B - Rechnung B - TWGS A+B
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU016" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1      |
   | nummer  | 1AU016 |
   | such    | AU016  |
And I append rows
   | artikel    | mge         | pwert       |
   | VK-Artikel |  50         | !dontChange |
   | DL-ANALYSE |   6         | !dontChange |
   | NEPO       | !dontChange |      140.00 |
And I save the current editor

# Lieferschein
Given I open an editor "LS016" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU016"
And I set fields
   | nummer | 1LS016A |
   | such   | LS016A  |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | ja      |
Then the table has 3 rows
And I set field "mge" to "50" in row 1
And I set field "mge" to "6" in row 2
And I set field "pwert" to "140.00" in row 3
And I save the current editor

# Ruecklieferschein A
Given I open an editor "RLS016A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS016"
And I set fields
   | nummer | 1RLS016A |
   | such   | RLS016A  |
   | ueb    | ja       |
   | vom    | .        |
Then the table has 3 rows
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-1" in row 2
And I set field "pwert" to "-60.00" in row 3
And I save the current editor

# Ruecklieferschein B
Given I open an editor "RLS016B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS016"
And I set fields
   | nummer | 1RLS016B |
   | such   | RLS016B  |
   | ueb    | ja       |
   | vom    | .        |
Then the table has 3 rows
And I set field "mge" to "-15" in row 1
And I set field "mge" to "-3.5" in row 2
And I set field "pwert" to "-45.00" in row 3
And I save the current editor

# Rechnung A aus Lieferschein
Given I open an editor "RE016A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS016"
And I set fields
   | nummer | 1RE016A |
   | such   | RE016A  |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
Then the table has 3 rows
And I set field "mge" to "30" in row 1
And I set field "mge" to "3" in row 2
And I set field "pwert" to "120.00" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE016A" in row 1 has value "-25"
Then field "remge" from editor "RE016A" in row 2 has value "-1.5"
Then field "remge" from editor "RE016A" in row 3 has value "-35"

Then field "remge" from editor "RLS016A" in row 1 has value "-5"
Then field "remge" from editor "RLS016A" in row 2 has value "-1"
Then field "remge" from editor "RLS016A" in row 3 has value "-60"

Then field "remge" from editor "RLS016B" in row 1 has value "-5"
Then field "remge" from editor "RLS016B" in row 2 has value "-1.5"
Then field "remge" from editor "RLS016B" in row 3 has value "-45"

# Rechnung B aus Lieferschein
Given I open an editor "RE016B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS016"
And I set fields
   | nummer | 1RE016B |
   | such   | RE016B  |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
Then the table has 3 rows
And I set field "mge" to "10" in row 1
And I set field "mge" to "1" in row 2
And I set field "pwert" to "6.00" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert
Then field "remge" from editor "RE016B" in row 1 has value "0"
Then field "remge" from editor "RE016B" in row 2 has value "0"
Then field "remge" from editor "RE016B" in row 3 has value "0"

Then field "remge" from editor "RE016A" in row 1 has value "-25"
Then field "remge" from editor "RE016A" in row 2 has value "-1.5"
Then field "remge" from editor "RE016A" in row 3 has value "-35"
Then field "ofwert" from editor "RE016A" in row 3 has value "-35.00"

Then field "remge" from editor "RLS016A" in row 1 has value "-10"
Then field "remge" from editor "RLS016A" in row 2 has value "-1"
Then field "remge" from editor "RLS016A" in row 3 has value "-60"

Then field "remge" from editor "RLS016B" in row 1 has value "-15"
Then field "remge" from editor "RLS016B" in row 2 has value "-2.5"
Then field "remge" from editor "RLS016B" in row 3 has value "-45"

# Teilwertgutschrift A
Given I open an editor "TWG016A" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE016A"
And I set fields
   | nummer | 1TWG016A |
   | such   | TWG016A  |
   | ueb    | ja       |
   | tterm  | .        |
Then the table has 6 rows
And I press button "komplettieren"

Then field "mge" has value "-25" in row 1
Then field "mge" has value "-1.5" in row 2
Then field "pwert" has value "-35.00" in row 3
And I close the current editor

Then field "remge" from editor "RE016A" in row 1 has value "-25"
Then field "ofwert" from editor "RE016A" in row 1 has value "-2500.00"
Then field "remge" from editor "RE016A" in row 2 has value "-1.5"
Then field "ofwert" from editor "RE016A" in row 2 has value "-150.00"
Then field "remge" from editor "RE016A" in row 3 has value "-35"
Then field "ofwert" from editor "RE016A" in row 3 has value "-35.00"

Then field "remge" from editor "RLS016A" in row 1 has value "-10"
Then field "remge" from editor "RLS016A" in row 2 has value "-1"
Then field "remge" from editor "RLS016A" in row 3 has value "-60"

# Teilwertgutschrift B nichts mehr gutzuschreiben
Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE016B" throws the exception "2620"

# Kaufm. Gutschrift zu Ruecklieferschein
Given I open an editor "KGS016A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS016A"
And I set fields
   | nummer | 1KGS016A |
   | such   | KGS016A  |
   | ueb    | ja       |
   | tterm  | .        |
Then field "mge" has value "-5" in row 1
Then field "preis" has value "200.00" in row 1
Then field "mge" has value "-5" in row 2
Then field "preis" has value "200.00" in row 2
Then field "mge" has value "-1" in row 3
Then field "pwert" has value "-60.00" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Bestellung - Lieferschein - Rechnung A+B - Ruecklieferschein - Rechnung C - KGS
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE017" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1      |
   | nummer  | 1BE017 |
   | such    | BE017  |
And I append rows
   | artikel     | mge         | pwert       |
   | EK-ARTIKEL2 | 100         | !dontChange |
   | EK-ARTIKEL2 |  50         | !dontChange |
   | DL-ANALYSE  |  9          | !dontChange |
   | TEXT        | !dontChange |      120.00 |
And I save the current editor

# Lieferschein
Given I open an editor "LS017" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE017"
And I set fields
   | nummer | 1LS017  |
   | such   | LS017   |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 4 rows
And I set field "mge" to "100" in row 1
And I set field "mge" to "50" in row 2
And I set field "mge" to "9" in row 3
And I set field "pwert" to "120" in row 4
And I save the current editor

# Rechnung A aus Lieferschein
Given I open an editor "RE017A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS017"
And I set fields
   | nummer | 1RE017A |
   | such   | RE017A  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 4 rows
And I set field "mge" to "20" in row 1
And I set field "mge" to "10" in row 2
And I set field "mge" to "4" in row 3
And I set field "pwert" to "50" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung B aus Lieferschein
Given I open an editor "RE017B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS017"
And I set fields
   | nummer | 1RE017B |
   | such   | RE017B  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 4 rows
And I set field "mge" to "40" in row 1
And I set field "preis" to "11" in row 1
And I set field "mge" to "15" in row 2
And I set field "preis" to "11" in row 2
And I set field "mge" to "3" in row 3
And I set field "pwert" to "25" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein
Given I open an editor "RLS017" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS017"
And I set fields
   | nummer | 1RLS017 |
   | such   | RLS017  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 4 rows
And I set field "mge" to "-75" in row 1
And I set field "mge" to "-30" in row 2
And I set field "mge" to "-6" in row 3
And I set field "pwert" to "-55" in row 4
And I save the current editor

# Gutschreibbare Menge/Wert Soll 0|-5|0|-40
Then field "remge" from editor "RE017A" in row 1 has value "0"
Then field "remge" from editor "RE017A" in row 2 has value "-5"
Then field "remge" from editor "RE017A" in row 3 has value "-3"
Then field "remge" from editor "RE017A" in row 4 has value "-50"

# Gutschreibbare Menge/Wert Soll -25|-15|-3|-25
Then field "remge" from editor "RE017B" in row 1 has value "-25"
Then field "remge" from editor "RE017B" in row 2 has value "-15"
Then field "remge" from editor "RE017B" in row 3 has value "0"
Then field "remge" from editor "RE017B" in row 4 has value "-15"

# Rechnung C aus Lieferschein
Given I open an editor "RE017C" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS017"
And I set fields
   | nummer | 1RE017C |
   | such   | RE017C  |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 4 rows
And I set field "mge" to "40" in row 1
And I set field "preis" to "12" in row 1
And I set field "mge" to "25" in row 2
And I set field "preis" to "12" in row 2
And I set field "mge" to "2" in row 3
And I set field "pwert" to "45" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschreibbare Menge/Wert Soll 0|-5|0|-40
Then field "remge" from editor "RE017A" in row 1 has value "0"
Then field "remge" from editor "RE017A" in row 2 has value "-5"
Then field "remge" from editor "RE017A" in row 3 has value "-3"
Then field "remge" from editor "RE017A" in row 4 has value "-50"

# Gutschreibbare Menge/Wert Soll -25|-15|-3|-25
Then field "remge" from editor "RE017B" in row 1 has value "-25"
Then field "remge" from editor "RE017B" in row 2 has value "-15"
Then field "remge" from editor "RE017B" in row 3 has value "0"
Then field "remge" from editor "RE017B" in row 4 has value "-15"

# Gutschreibbare Menge/Wert Soll 0|0|0|0
Then field "remge" from editor "RE017C" in row 1 has value "0"
Then field "remge" from editor "RE017C" in row 2 has value "0"
Then field "remge" from editor "RE017C" in row 3 has value "0"
Then field "remge" from editor "RE017C" in row 4 has value "0"


# Kaufm. Gutschrift zu Ruecklieferschein
Given I open an editor "KGS017" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS017"
And I set fields
   | nummer | 1KGS017 |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 10 rows
Then field "mge" has value "-20" in row 1
Then field "preis" has value "10.00" in row 1
Then field "mge" has value "-15" in row 2
Then field "preis" has value "11.00" in row 2
Then field "mge" has value "-40" in row 3
Then field "preis" has value "12.00" in row 3
Then field "mge" has value "-5" in row 4
Then field "preis" has value "10.00" in row 4
Then field "mge" has value "-25" in row 5
Then field "preis" has value "12.00" in row 5
Then field "mge" has value "-1" in row 6
Then field "mge" has value "-3" in row 7
Then field "mge" has value "-2" in row 8
Then field "pwert" has value "-10.00" in row 9
Then field "pwert" has value "-45.00" in row 10
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: BE -  RE  (2* AU/BE-Pos positiv und negativ)
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE018" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE018 |
   | lief   | 1      |
   | such   | BE018  |
And I append rows
   | artikel   | he    | mge | lirelev |
   | AUBEPO    | Stück | -3  | nein    |
   | AUBEPO    | Stück |  4  | nein    |
And I save the current editor

# Rechnung aus Bestellung
Given I open an editor "1RE018" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE018"
And I set fields
   | nummer | 1RE018 |
   | such   | RE018  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "2" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1BE018" in row 1 has value "-2"
Then field "remge" from editor "1BE018" in row 2 has value "2"


# ----------------------------------------------------------------------------------------------
Scenario: AU -  RE  (2* AU/BE-Pos positiv und negativ)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU019" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU019 |
   | kunde  | 1      |
   | such   | AU019  |
And I append rows
   | artikel   | he    | mge | lirelev |
   | AUBEPO    | Stück | -3  | nein    |
   | AUBEPO    | Stück |  4  | nein    |
And I save the current editor

# Rechnung aus Auftrag
Given I open an editor "1RE019" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU019"
And I set fields
   | nummer | 1RE019 |
   | such   | RE019  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "2" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "1AU019" in row 1 has value "-2"
Then field "remge" from editor "1AU019" in row 2 has value "2"
