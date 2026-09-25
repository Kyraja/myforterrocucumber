# **********************************************************************************
#  Name             : abrufpos_anhaengen_edi_fab.feature
#  Verantwortlich   : as
#  Kontrolle        : teampss
#  Funktion         : Testet Feinabrufe mit der Option 'Abrufpositionen anhaengen'
# **********************************************************************************

@persistent
Feature: EDI-Feinabrufe mit der Option 'Abrufpositionen anhaengen'

Background:
And I set the fake date to "07.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: Kundenkontakt anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "EDISB-PA" from table "(Customer):(CustomerContact)" with command "COPY" for record "EDISB-13"
And I set field "such" to "EDISB-PA"
And I set field "name" to "EDI-SB fuer Kunde 227503, FAB Abrufpos. anh."
And I set field "werk" to "22PA"
And I set field "ablstelle" to "APA"
And I save the current editor

Given I open an editor "EDISB-PA" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "EDISB-PA"
And I press button "edinfo" to open a subeditor for "EDI-Nachricht"
And I append rows
    | edinachraz  | ieabmodell | abmodell | erlaubt | protokoll | abrufakt |
    | Lieferabruf | 4010       | 4011     | ja      | VDA       | nein     |
    | Feinabruf   | 4020       | 4021     | ja      | VDA       | ja       |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rahmenauftrag anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "1RA001" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | nummer      | 1RA001   |
    | kunde       | EDISB-PA |
    | verwschl    | 11       |
    | abschlnr    | 42       |
And I append rows
    | artikel     | mge  |
    | EDIART-4    | 1000 |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Lieferabruf verarbeiten
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen    | 1RA001    |
    | einfzahl  | 0         |
    | zekunde   | SB-13     |
    | verwschl  | 11        |
    | labruf    | LAB_RA001 |
    | labrufd   | .         |
And I delete all rows
And I append rows
    | termint   | menge |
    | +5        | 200   |
    | +10       | 300   |
    | +15       | 500   |
And I press button "daterz"
And I close the current editor

Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4010"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-PA" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# EDI-Verarbeitung pruefen
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=LAB_RA001"
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
Then field "ftext" is empty
And I close the current editor

# Auftrag pruefen
Given I open an editor "BEDISB-PA" from table "(Sales):(SalesOrder)" with command "VIEW" for search criteria "$,,such=BEDISB-PA;lztabnr=LAB_RA001"
Then table has values
    | abruftyp   | mge    | zrahmen  |
    | LAB        | 200    | 1RA001   |
    | LAB        | 300    | 1RA001   |
    | LAB        | 500    | 1RA001   |
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Feinabruf fuer erste Lieferabrufposition, Eingangsfortschrittszahl = 0
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen    | 1RA001      |
    | kbfab     | ja          |
    | einfzahl  | 0           |
    | zekunde   | SB-13       |
    | labruf    | FAB_RA001_1 |
    | labrufd   | .           |
And I delete all rows
And I append rows
    | termint   | menge |
    | +5        | 200   |
And I press button "daterz"
And I close the current editor

Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4020"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-PA" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# EDI-Verarbeitung pruefen
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=FAB_RA001_1"
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
Then field "ftext" is empty
And I close the current editor

# Auftrag pruefen
Given I open an editor "BEDISB-PA" from table "(Sales):(SalesOrder)" with command "VIEW" for search criteria "$,,such=BEDISB-PA;lztabnr=FAB_RA001_1"
Then table has values
    | abruftyp   | mge    | zrahmen  |
    | FAB        | 200    | 1RA001   |
    | LAB        | 300    | 1RA001   |
    | LAB        | 500    | 1RA001   |
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Feinabruf fuer erste Lieferabrufposition liefern
# ----------------------------------------------------------------------------------------------

Given I open an editor "1LS001" from table "(Sales):(SalesOrder)" with command "DELIVERY" for search criteria "$,,such=BEDISB-PA;lztabnr=FAB_RA001_1"
And I set fields
    | nummer  | 1LS001 |
    | vom     |  .     |
    | ueb     | ja     |
And I set field "mge" to "200" in row 1
And I set field "dfuesenden" to "nein"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Feinabruf fuer zweite Lieferabrufposition, Eingangsfortschrittszahl = 0
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen    | 1RA001      |
    | kbfab     | ja          |
    | einfzahl  | 0           |
    | zekunde   | SB-13       |
    | labruf    | FAB_RA001_2 |
    | labrufd   | .           |
And I delete all rows
And I append rows
    | termint   | menge |
    | +10       | 300   |
And I press button "daterz"
And I close the current editor

Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4020"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-PA" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# EDI-Verarbeitung pruefen
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=FAB_RA001_2"
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
Then field "ftext" is empty
And I close the current editor

# Auftrag pruefen
Given I open an editor "BEDISB-PA" from table "(Sales):(SalesOrder)" with command "VIEW" for search criteria "$,,such=BEDISB-PA;lztabnr=FAB_RA001_2"
Then table has values
    | abruftyp   | mge    | zrahmen  |
    | FAB        | 300    | 1RA001   |
    | LAB        | 500    | 1RA001   |
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Feinabruf fuer zweite Lieferabrufposition liefern
# ----------------------------------------------------------------------------------------------

Given I open an editor "1LS002" from table "(Sales):(SalesOrder)" with command "DELIVERY" for search criteria "$,,such=BEDISB-PA;lztabnr=FAB_RA001_2"
And I set fields
    | nummer  | 1LS002 |
    | vom     |  .     |
    | ueb     | ja     |
And I set field "mge" to "300" in row 1
And I set field "dfuesenden" to "nein"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Feinabruf fuer dritte Lieferabrufposition, Eingangsfortschrittszahl = Liefermenge
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen    | 1RA001      |
    | kbfab     | ja          |
    | einfzahl  | 500         |
    | zekunde   | SB-13       |
    | labruf    | FAB_RA001_3 |
    | labrufd   | .           |
And I delete all rows
And I append rows
    | termint   | menge |
    | +15       | 500   |
And I press button "daterz"
And I close the current editor

Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4020"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-PA" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=FAB_RA001_3"
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
Then field "ftext" is empty
And I close the current editor

# Auftrag pruefen
# FEHLER: Gelieferte Feinabrufpositionen erscheinen wieder
Given I open an editor "BEDISB-PA" from table "(Sales):(SalesOrder)" with command "VIEW" for search criteria "$,,such=BEDISB-PA;lztabnr=FAB_RA001_3"
Then table has values
    | abruftyp   | mge    | zrahmen  |
    | FAB        | 200    | 1RA001   |
    | FAB        | 300    | 1RA001   |
    | FAB        | 500    | 1RA001   |
And I close the current editor
