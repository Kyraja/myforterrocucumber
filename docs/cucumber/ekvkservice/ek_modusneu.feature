# *****************************************************************************************
#  Name           : ek_modusneu.feature
#  Autor          : nkoeninger
#  Verantwortlich : teampss
#  Funktion       : Test fuer das evmodusneu Skip-Feld im Einkauf
#  Beschreibung   :
#  Testet das Skip Feld evmodusneu, das angibt, ob das EV-Objekt im Neuanlagemodus ist.
#  Wenn das EV-Objekt im Neuanlagemodus ist, muss dann den Wert von evmodusneu false sein.
#  Getestet werden alle EV-Objekte mit allen Kommandos.
#
# *****************************************************************************************
#
@persistent
Feature: Test zu Skip-Feld modusneu im Einkauf
Background:
Given I set the fake date to "02.01.1995"

# Objekt                                     | NEW | COPY | STORE | UPDATE | VIEW | DELIVERY | INVOICE | REVERSAL | RELEASE | RETURN |
# -------------------------------------------|-----|------|-------|--------|------|----------|---------|----------|---------|--------|
# (Purchasing):(Request)                     |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    -     |   Ja    |   -    |
# (Purchasing):(PurchaseOrder)               |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    -     |   -     |   -    |
# (Purchasing):(PackingSlip)                 |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    Ja    |   Ja    |    Ja    |   -     |   Ja   |
# (Purchasing):(BlanketOrder)                |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   Ja    |    -     |   Ja    |   -    |
# (Purchasing):(Invoice)                     |  Ja |  Ja  |   Ja  |   Ja   |  Ja  |    -     |   -     |    Ja    |   -     |   -    |
# (Purchasing):(PurchaseOrderSuggestions)    |  Ja |  -   |   -   |   Ja   |  Ja  |    -     |   -     |    -     |   Ja    |   -    |
# (Purchasing):(RelocationSuggestions)       |  Ja |  -   |   -   |   Ja   |  Ja  |    -     |   -     |    -     |   Ja    |   -    |
# (Purchasing):(SubcontractingSuggestions)   |  Ja |  -   |   -   |   Ja   |  Ja  |    -     |   -     |    -     |   Ja    |   -    |

Scenario Outline: Neue Vorgaenge anlegen im Einkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record ""
Then field "modusneu" has value "<modusneu>"
And I set field "lief" to "<lief>"
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
Then field "modusneu" has value "<modusneu>"
And I create a new row at the end of the table
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "artex" to "<artikel>" in row 1
And I set field "mge" to "<mge>" in row 1
Then field "modusneu" has value "<modusneu>" in row 1
And I save the current editor

Examples:
  | Index | such   | kommando | table                         | modusneu | lief  | artikel | mge         |
  | 0     | AN-01  | NEW      | (Purchasing):(Request)        | ja       | 1     | E1      | 377         |
  | 1     | BE-01  | NEW      | (Purchasing):(PurchaseOrder)  | ja       | 1     | E1      | 610         |
  | 2     | LS-01  | NEW      | (Purchasing):(PackingSlip)    | ja       | 1     | E1      | 987         |
  | 3     | RA-01  | NEW      | (Purchasing):(BlanketOrder)   | ja       | 1     | E1      | 2000        |
  | 4     | RE-01  | NEW      | (Purchasing):(Invoice)        | ja       | 1     | TEXT    | !dontChange |
  | 0     | AN-02  | STORE    | (Purchasing):(Request)        | ja       | 1     | E1      | 377         |
  | 1     | BE-02  | STORE    | (Purchasing):(PurchaseOrder)  | ja       | 1     | E1      | 610         |
  | 2     | LS-02  | STORE    | (Purchasing):(PackingSlip)    | ja       | 1     | E1      | 987         |
  | 3     | RA-02  | STORE    | (Purchasing):(BlanketOrder)   | ja       | 1     | E1      | 233         |
  | 4     | RE-02  | STORE    | (Purchasing):(Invoice)        | ja       | 1     | TEXT    | !dontChange |

Scenario Outline: Bestehende Vorgaenge aendern im Einkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<such>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I close the current editor

Examples:
  | Index | such   | kommando | table                         | modusneu  |
  | 0     | AN-02  | UPDATE   | (Purchasing):(Request)        | nein      |
  | 1     | BE-02  | UPDATE   | (Purchasing):(PurchaseOrder)  | nein      |
  | 2     | LS-02  | UPDATE   | (Purchasing):(PackingSlip)    | nein      |
  | 3     | RA-02  | UPDATE   | (Purchasing):(BlanketOrder)   | nein      |
  | 4     | RE-02  | UPDATE   | (Purchasing):(Invoice)        | nein      |

Scenario Outline: Bestehende Vorgaenge kopieren im Einkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                         | modusneu |
  | 0     | AN-03   | AN-01   | COPY     | (Purchasing):(Request)        | ja       |
  | 1     | BE-03   | BE-01   | COPY     | (Purchasing):(PurchaseOrder)  | ja       |
  | 2     | LS-03   | LS-01   | COPY     | (Purchasing):(PackingSlip)    | ja       |
  | 3     | RA-03   | RA-01   | COPY     | (Purchasing):(BlanketOrder)   | ja       |
  | 4     | RE-03   | RE-01   | COPY     | (Purchasing):(Invoice)        | ja       |

Scenario Outline: Bestehende Vorgaenge zeigen im Einkauf

Given I open an editor "<editor>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I close the current editor

Examples:
  | Index | editor  | kommando | table                         | modusneu |
  | 0     | AN-01   | VIEW     | (Purchasing):(Request)        | nein     |
  | 1     | BE-01   | VIEW     | (Purchasing):(PurchaseOrder)  | nein     |
  | 2     | LS-01   | VIEW     | (Purchasing):(PackingSlip)    | nein     |
  | 3     | RA-01   | VIEW     | (Purchasing):(BlanketOrder)   | nein     |
  | 4     | RE-01   | VIEW     | (Purchasing):(Invoice)        | nein     |

Scenario Outline: Bestehende Vorgaenge freigeben im Einkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                        | modusneu |
  | 2     | BE-10   | AN-01   | RELEASE  | (Purchasing):(Request)       | ja       |
  | 3     | BE-11   | RA-01   | RELEASE  | (Purchasing):(BlanketOrder)  | ja       |

Scenario Outline: Bestehende Vorgaenge liefern im Einkauf, Beleg anfuegen

Given I open an editor "<such>" from table "<table>" with command "NEW" for record ""
And I set field "beleg" to id from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
And I save the current editor

Examples:
  | Index | such    | editor  | table                        | modusneu |
  | 2     | BE-12   | AN-02   | (Purchasing):(PurchaseOrder) | ja       |
  | 3     | BE-13   | RA-02   | (Purchasing):(PurchaseOrder) | ja       |

Scenario Outline: Bestehende Vorgaenge liefern im Einkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                         | modusneu |
  | 1     | LS-10   | BE-01   | DELIVERY | (Purchasing):(PurchaseOrder)  | ja       |

Scenario Outline: Bestehende Vorgaenge liefern im Einkauf, Beleg anfuegen

Given I open an editor "<such>" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | modusneu |
  | 1     | LS-11   | BE-02   | ja       |

Scenario: Vorbereitung Rechnung im Einkauf

Given I open an editor "LS-01" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS-01"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LS-02" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS-02"
And I set field "ueb" to "ja"
And I save the current editor

Scenario Outline: Bestehende Vorgaenge fakturieren im Einkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "0" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                         | modusneu |
  | 1     | RE-10   | BE-01   | INVOICE  | (Purchasing):(PurchaseOrder)  | ja       |
  | 2     | RE-11   | LS-01   | INVOICE  | (Purchasing):(PackingSlip)    | ja       |

Scenario Outline: Bestehende Vorgaenge fakturieren im Einkauf, Beleg anfuegen

Given I open an editor "<such>" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "0" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | modusneu |
  | 1     | RE-12   | BE-02   | ja       |
  | 2     | RE-13   | LS-02   | ja       |

Scenario Outline: Bestehende Vorgaenge zurueckliefern im Einkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I press button "offueb" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | kommando | table                       | modusneu |
  | 1     | RLS-10  | LS-01   | RETURN   | (Purchasing):(PackingSlip)  | ja       |

Scenario Outline: Bestehende Vorgaenge zurueckliefern im Einkauf, Beleg anfuegen

Given I open an editor "<such>" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I press button "offueb" in row 1
And I save the current editor

Examples:
  | Index | such    | editor  | modusneu |
  | 1     | RLS-11  | LS-02   | ja       |

Scenario: Vorbereitung Storno im Einkauf

Given I open an editor "RE-10" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE-10"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "RLS-10" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS-10"
And I set field "ueb" to "ja"
And I save the current editor

Scenario Outline: Bestehende Vorgaenge stornieren im Einkauf

Given I open an editor "<such>" from table "<table>" with command "<kommando>" for record from editor "<editor>"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I save the current editor

Examples:
  | Index | editor  | kommando | table                        | modusneu |
  | 1     | RLS-10  | REVERSAL | (Purchasing):(PackingSlip)   | ja       |
  | 2     | RE-10   | REVERSAL | (Purchasing):(Invoice)       | ja       |

Scenario: Vorbereitung Beschaffungsvorschlaege im Einkauf

Given I open an editor "lfert" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
  | such    | LFERT         |
  | namebspr| Lohnfertigung |
  | bsart   | Lohnfertigung |
And I save the current editor

Scenario Outline: Beschaffungsvorschlaege im Einkauf anlegen

Given I open an editor "BV" from table "<table>" with command "<kommando>" for record ""
And I create a new row at the end of the table
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "artikel" to "<artikel>" in row 1
And I set field "lief" to "1" in row 1
And I set field "mge" to "<mge>" in row 1
And I set field "platz" to "<platz>" in row 1
And I set field "lffert" to "<lffert>" in row 1
Then field "modusneu" has value "<modusneu>" in row 1
And I save the current editor

Examples:
  | Index | kommando | table                                     | artikel | mge   | platz       | lffert      | modusneu |
  | 1     | NEW      | (Purchasing):(PurchaseOrderSuggestions)   | E2      | 10    | !dontChange | !dontChange | ja       |
  | 2     | NEW      | (Purchasing):(RelocationSuggestions)      | E2      | 11    | L3F1        | !dontChange | ja       |
  | 3     | UPDATE   | (Purchasing):(SubcontractingSuggestions)  | LFERT   | 12    | !dontChange | V1          | ja       |

Scenario Outline: Beschaffungsvorschlaege im Einkauf aendern

Given I open an editor "BV" from table "<table>" with command "<kommando>" for record ""
And I press button "ladetab"
Then field "modusneu" has value "<modusneu>" in row 1
And I close the current editor

Examples:
  | Index | kommando | table                                     | modusneu |
  | 1     | UPDATE   | (Purchasing):(PurchaseOrderSuggestions)   | nein     |
  | 2     | UPDATE   | (Purchasing):(RelocationSuggestions)      | nein     |
  | 3     | UPDATE   | (Purchasing):(SubcontractingSuggestions)  | nein     |

Scenario Outline: Beschaffungsvorschlaege im Einkauf zeigen

Given I open an editor "BV" from table "<table>" with command "<kommando>" for record ""
And I press button "ladetab"
Then field "modusneu" has value "<modusneu>" in row 1
And I close the current editor

Examples:
  | Index | kommando | table                                     | modusneu |
  | 1     | VIEW     | (Purchasing):(PurchaseOrderSuggestions)   | nein     |
  | 2     | VIEW     | (Purchasing):(RelocationSuggestions)      | nein     |
  | 3     | VIEW     | (Purchasing):(SubcontractingSuggestions)  | nein     |

Scenario Outline: Beschaffungsvorschlaege im Einkauf freigeben

Given I open an editor "BV" from table "<table>" with command "<kommando>" for record ""
And I press button "ladetab"
And I press button "malle"
And I press button "freig" to open a subeditor for "bestellung"
Then field "modusneu" has value "<modusneu>"
Then field "modusneu" has value "<modusneu>" in row 1
And I set field "such" to "<such>"
And I set field "ebeleg" to "<such>"
And I set field "vom" to "."
And I save the current editor
And I switch the current editor to editor "BV"
And I close the current editor

Examples:
  | Index | kommando | table                                     | such   | modusneu |
  | 1     | UPDATE   | (Purchasing):(PurchaseOrderSuggestions)   | BE-20  | ja       |
  | 2     | UPDATE   | (Purchasing):(RelocationSuggestions)      | BE-21  | ja       |
  | 3     | UPDATE   | (Purchasing):(SubcontractingSuggestions)  | BE-22  | ja       |

