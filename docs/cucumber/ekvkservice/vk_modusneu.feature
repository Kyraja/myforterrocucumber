# *****************************************************************************************
#  Name           : vk_modusneu.feature
#  Autor          : nkoeninger
#  Verantwortlich : teampss
#  Funktion       : Test fuer das evmodusneu Skip-Feld im Verkauf
#  Beschreibung   :
#  Testet das Skip Feld evmodusneu, das angibt, ob das EV-Objekt im Neuanlagemodus ist.
#  Wenn das EV-Objekt im Neuanlagemodus ist, muss dann den Wert von evmodusneu false sein.
#  Getestet werden alle EV-Objekte mit allen Kommandos.
#
# *****************************************************************************************
#
@persistent
Feature: Test zu Skip-Feld modusneu im Verkauf
Background:
Given I set the fake date to "02.01.1995"

# Objekt                       | NEW | COPY | STORE | UPDATE | VIEW | DELIVERY | INVOICE | REVERSAL | RELEASE | RETURN |
# -----------------------------|-----|------|-------|--------|------|----------|---------|----------|---------|--------|
# (Sales):(Opportunity)        |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    -     |   Ja    |   -    |
# (Sales):(Quotation)          |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    -     |   Ja    |   -    |
# (Sales):(SalesOrder)         |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    Ja    |   Ja    |    -     |   -     |   -    |
# (Sales):(PackingSlip)        |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   Ja    |    Ja    |   -     |   Ja   |
# (Sales):(Invoice)            |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    Ja    |   -     |   -    |
# (Sales):(BlanketOrder)       |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    -     |   Ja    |   -    |
# (Sales):(WebOrder)           |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    -     |   Ja    |   -    |
# (Sales):(ServiceQuotation)   |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    -     |   -     |   -    |
# (Sales):(ServiceOrder)       |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    Ja    |   Ja    |    -     |   -     |   -    |
# (Sales):(RepairOrder)        |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    Ja    |   Ja    |    -     |   -     |   -    |

Scenario Outline: Neue Vorgaenge anlegen im Verkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record ""
Then field "modusneu" has value "<modusneu>"
And I set field "kunde" to "<kunde>"
And I set field "such" to "<such>"
And I set field "vom" to "."
And I set field "tterm" to "<tterm>"
Then field "modusneu" has value "<modusneu>"
And I create a new row at the end of the table
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "artex" to "<artikel>" in row 1
And I set field "mge" to "<mge>" in row 1
Then field "modusneu" has value "<modusneu>" in row 1
And I save the current editor

Examples:
  |  Index | such    | kommando | table                       | modusneu | kunde  | artikel | mge         | tterm       |
  |  0     | CH-01   | NEW      | (Sales):(Opportunity)       | ja       | 1      | V1      | 89          | !dontChange |
  |  1     | AN-01   | NEW      | (Sales):(Quotation)         | ja       | 1      | V1      | 2           | !dontChange |
  |  2     | AU-01   | NEW      | (Sales):(SalesOrder)        | ja       | 1      | V1      | 3           | !dontChange |
  |  3     | LS-01   | NEW      | (Sales):(PackingSlip)       | ja       | 1      | V1      | 5           | !dontChange |
  |  4     | RE-01   | NEW      | (Sales):(Invoice)           | ja       | 1      | E2      | 8           | .           |
  |  5     | RA-01   | NEW      | (Sales):(BlanketOrder)      | ja       | 1      | V1      | 100         | !dontChange |
  |  6     | WA-01   | NEW      | (Sales):(WebOrder)          | ja       | 1      | V1      | 13          | !dontChange |
  |  7     | SN-01   | NEW      | (Sales):(ServiceQuotation)  | ja       | 1      | V1      | 21          | !dontChange |
  |  8     | SA-01   | NEW      | (Sales):(ServiceOrder)      | ja       | 1      | V1      | 34          | !dontChange |
  |  9     | RP-01   | NEW      | (Sales):(RepairOrder)       | ja       | 1      | V1      | !dontChange | !dontChange |
  |  10    | CH-02   | STORE    | (Sales):(Opportunity)       | ja       | 1      | V1      | 89          | !dontChange |
  |  11    | AN-02   | STORE    | (Sales):(Quotation)         | ja       | 1      | V1      | 2           | !dontChange |
  |  12    | AU-02   | STORE    | (Sales):(SalesOrder)        | ja       | 1      | V1      | 3           | !dontChange |
  |  13    | LS-02   | STORE    | (Sales):(PackingSlip)       | ja       | 1      | V1      | 5           | !dontChange |
  |  14    | RE-02   | STORE    | (Sales):(Invoice)           | ja       | 1      | E2      | 8           | .           |
  |  15    | RA-02   | STORE    | (Sales):(BlanketOrder)      | ja       | 1      | V1      | 100         | !dontChange |
  |  16    | WA-02   | STORE    | (Sales):(WebOrder)          | ja       | 1      | V1      | 13          | !dontChange |
  |  17    | SN-02   | STORE    | (Sales):(ServiceQuotation)  | ja       | 1      | V1      | 21          | !dontChange |
  |  18    | SA-02   | STORE    | (Sales):(ServiceOrder)      | ja       | 1      | V1      | 34          | !dontChange |
  |  19    | RP-02   | STORE    | (Sales):(RepairOrder)       | ja       | 1      | V1      | !dontChange | !dontChange |

Scenario Outline: Bestehende Vorgaenge aendern im Verkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<such>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I close the current editor

Examples:
  | Index | such    | kommando | table                       | modusneu |
  | 0     | CH-02   | UPDATE   | (Sales):(Opportunity)       | nein     |
  | 1     | AN-02   | UPDATE   | (Sales):(Quotation)         | nein     |
  | 2     | AU-02   | UPDATE   | (Sales):(SalesOrder)        | nein     |
  | 3     | LS-02   | UPDATE   | (Sales):(PackingSlip)       | nein     |
  | 4     | RE-02   | UPDATE   | (Sales):(Invoice)           | nein     |
  | 5     | RA-02   | UPDATE   | (Sales):(BlanketOrder)      | nein     |
  | 6     | WA-02   | UPDATE   | (Sales):(WebOrder)          | nein     |
  | 7     | SN-02   | UPDATE   | (Sales):(ServiceQuotation)  | nein     |
  | 8     | SA-02   | UPDATE   | (Sales):(ServiceOrder)      | nein     |
  | 9     | RP-02   | UPDATE   | (Sales):(RepairOrder)       | nein     |

Scenario Outline: Bestehende Vorgaenge kopieren im Verkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "tterm" to "<tterm>"
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                       | modusneu | tterm       |
  | 0     | CH-03   | CH-01   | COPY     | (Sales):(Opportunity)       | ja       | !dontChange |
  | 1     | AN-03   | AN-01   | COPY     | (Sales):(Quotation)         | ja       | !dontChange |
  | 2     | AU-03   | AU-01   | COPY     | (Sales):(SalesOrder)        | ja       | !dontChange |
  | 3     | LS-03   | LS-01   | COPY     | (Sales):(PackingSlip)       | ja       | !dontChange |
  | 4     | RE-03   | RE-01   | COPY     | (Sales):(Invoice)           | ja       | .           |
  | 5     | RA-03   | RA-01   | COPY     | (Sales):(BlanketOrder)      | ja       | !dontChange |
  | 6     | WA-03   | WA-01   | COPY     | (Sales):(WebOrder)          | ja       | !dontChange |
  | 6     | SN-03   | SN-01   | COPY     | (Sales):(ServiceQuotation)  | ja       | !dontChange |
  | 7     | SA-03   | SA-01   | COPY     | (Sales):(ServiceOrder)      | ja       | !dontChange |
  | 9     | RP-03   | RP-01   | COPY     | (Sales):(RepairOrder)       | ja       | !dontChange |

Scenario Outline: Bestehende Vorgaenge zeigen im Verkauf

Given I open an editor "<editor>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I close the current editor

Examples:
  | Index | editor  | kommando | table                       | modusneu |
  | 0     | CH-01   | VIEW     | (Sales):(Opportunity)       | nein     |
  | 1     | AN-01   | VIEW     | (Sales):(Quotation)         | nein     |
  | 2     | AU-01   | VIEW     | (Sales):(SalesOrder)        | nein     |
  | 3     | LS-01   | VIEW     | (Sales):(PackingSlip)       | nein     |
  | 4     | RE-01   | VIEW     | (Sales):(Invoice)           | nein     |
  | 5     | RA-01   | VIEW     | (Sales):(BlanketOrder)      | nein     |
  | 6     | WA-01   | VIEW     | (Sales):(WebOrder)          | nein     |
  | 7     | SN-01   | VIEW     | (Sales):(ServiceQuotation)  | nein     |
  | 8     | SA-01   | VIEW     | (Sales):(ServiceOrder)      | nein     |
  | 9     | RP-01   | VIEW     | (Sales):(RepairOrder)       | nein     |

Scenario Outline: Bestehende Vorgaenge freigeben im Verkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                       | modusneu |
  | 1     | AN-10   | CH-01   | RELEASE  | (Sales):(Opportunity)       | ja       |
  | 2     | AU-11   | AN-01   | RELEASE  | (Sales):(Quotation)         | ja       |
  | 3     | AU-12   | RA-01   | RELEASE  | (Sales):(BlanketOrder)      | ja       |
  | 4     | AU-13   | WA-01   | RELEASE  | (Sales):(WebOrder)          | ja       |

Scenario Outline: Bestehende Vorgaenge freigeben im Verkauf, Beleg anfuegen

Given I open an editor "<such>" from table "<table>" with command "NEW" for record ""
And I set field "beleg" to id from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I save the current editor

Examples:
  | Index | such    | editor  | table                | modusneu |
  | 1     | AN-14   | CH-02   | (Sales):(Quotation)  | ja       |
  | 2     | AU-15   | AN-02   | (Sales):(SalesOrder) | ja       |
  | 3     | AU-16   | RA-02   | (Sales):(SalesOrder) | ja       |
  | 4     | AU-17   | WA-02   | (Sales):(SalesOrder) | ja       |

Scenario Outline: Bestehende Vorgaenge liefern im Verkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I press button "offueb" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                       | modusneu |
  | 1     | LS-10   | AU-01   | DELIVERY | (Sales):(SalesOrder)        | ja       |
  | 2     | LS-11   | SA-01   | DELIVERY | (Sales):(ServiceOrder)      | ja       |

Scenario Outline: Bestehende Vorgaenge liefern im Verkauf, Beleg anfuegen

Given I open an editor "<such>" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I press button "offueb" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | modusneu |
  | 1     | LS-12   | AU-02   | ja       |
  | 2     | LS-13   | SA-02   | ja       |

Scenario: Bestehende Vorgaenge liefern im Verkauf, Reparaturauftrag

Given I open an editor "konsi-lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSI"
And I set field "such" to "KONSI"
And I set field "namebspr" to "Konsignationslagergruppe"
And I set field "zkonsilg" to "ja"
And I save the current editor

Given I open an editor "konsi-lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSI"
And I set field "such" to "KONSI"
And I set field "namebspr" to "Konsignationslager"
And I set field "lgruppe" to "KONSI"
And I save the current editor

Given I open an editor "konsi-lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KONSI"
And I set field "such" to "KONSI"
And I set field "namebspr" to "Konsignationslagerplatz"
And I set field "lager" to "KONSI"
And I save the current editor

Given I open an editor "RP-01" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "RP-01"
And I press button "repzug" to open a subeditor for "LS-14"
Then field "modusneu" has value "ja"
Then field "modusneu" has value "ja" in row 1
And I set field "such" to "LS-14"
And I set field "platz" to "KONSI" in row 1
And I save the current editor
And I switch the current editor to editor "RP-01"
And I save the current editor

Scenario: Vorbereitung Rechnung im Verkauf

Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "dl-analyse"
And I set field "such" to "dl-analyse"
And I set field "namebspr" to "Anlayse"
And I set field "vpr" to "50.00"
And I save the current editor

Given I open an editor "RP-01" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "RP-01"
And I create a new row at the end of the table
And I set field "artikel" to "dl-analyse" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

Given I open an editor "RP-02" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "RP-02"
And I create a new row at the end of the table
And I set field "artikel" to "dl-analyse" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

Given I open an editor "LS-01" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS-01"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LS-02" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS-02"
And I set field "ueb" to "ja"
And I save the current editor

Scenario Outline: Bestehende Vorgaenge fakturieren im Verkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "tterm" to "."
And I press button "offueb" in row 1
And I set field "preis" to "0" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                       | modusneu |
  | 1     | RE-10   | AU-01   | INVOICE  | (Sales):(SalesOrder)        | ja       |
  | 2     | RE-11   | SA-01   | INVOICE  | (Sales):(ServiceOrder)      | ja       |
  | 3     | RE-12   | RP-01   | INVOICE  | (Sales):(RepairOrder)       | ja       |
  | 4     | RE-13   | LS-01   | INVOICE  | (Sales):(PackingSlip)       | ja       |

Scenario Outline: Bestehende Vorgaenge fakturieren im Verkauf, Beleg anfuegen

Given I open an editor "<such>" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "tterm" to "."
And I press button "offueb" in row 1
And I set field "preis" to "0" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | modusneu |
  | 1     | RE-14   | AU-02   | ja       |
  | 2     | RE-15   | SA-02   | ja       |
  | 3     | RE-16   | RP-02   | ja       |
  | 4     | RE-17   | LS-02   | ja       |

Scenario Outline: Bestehende Vorgaenge zurueckliefern im Verkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I press button "offueb" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                       | modusneu |
  | 1     | RLS-10  | LS-01   | RETURN   | (Sales):(PackingSlip)       | ja       |

Scenario Outline: Bestehende Vorgaenge zurueckliefern im Verkauf, Beleg anfuegen

Given I open an editor "<such>" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I press button "offueb" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | modusneu |
  | 1     | RLS-11  | LS-02   | ja       |

Scenario: Vorbereitung Storno im Verkauf

Given I open an editor "RE-10" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE-10"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS-10" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS-10"
And I set field "ueb" to "ja"
And I save the current editor

Scenario Outline: Bestehende Vorgaenge stornieren im Verkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I save the current editor

Examples:
  | Index | editor  | kommando | table                   | modusneu |
  | 1     | RLS-10  | REVERSAL | (Sales):(PackingSlip)   | ja       |
  | 2     | RE-10   | REVERSAL | (Sales):(Invoice)       | ja       |

