Feature: LMB_Lagergruppeneigenschaften.feature

# **********************************************************************************
#  Name             : LMB_Lagergruppeneigenschaften.feature
#  Autor            : bschiga
#  Verantwortlich   : bschiga
#  Kontrolle        : cl
#  Funktion         : Testet externe Lagergruppen im Infosystem Mindestbestandsliste
#  ref              : ref_la_infosys_lmb_cu
# **********************************************************************************

Background:
Given I set the fake date to "07.01.1995"

Scenario: Artikel mit Lagergruppeneigenschaften anlegen

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG_EXT_FERT"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | bsart          |
    | HONGKONG  | Eigenfertigung |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "BG_EXT_FERT" from table "(Part):(Product)" with command "VIEW" for record "BG_EXT_FERT"
And I close the current editor

Given I open an editor "FL" via ID from editor "BG_EXT_FERT" from field "flistestd" in row 0 for table "(ProductionList):(ProductionList)" with command "COPY"
And I set field "such" to "EXT_HK"
And I set field "artikel" to "BG_EXT_FERT"
And I set field "lgruppe" to "HONGKONG"
And I set field "flistestd" to "nein"
And I append rows
    | elex      | elanzahl     | breite | elbme |
    | A AG1     | 1            | 3600   | min   |
And I save the current editor

Given I open an editor "BG_EXT_FERT" from table "(Part):(Product)" with command "UPDATE" for record "BG_EXT_FERT"
And I press button "kalkul" to open a subeditor for "Kalkulation"
And I save the current subeditor to switch back to the parent editor
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I press button "kalkul" to open a subeditor for "Kalkulation" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I switch the current editor to editor "BG_EXT_FERT"
And I save the current editor

# externe Lagergruppe mit bsart Umlagern
Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG_EXT_UML"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | bsart     | umllg     |
    | BERLIN    | Umlagern  | KARLSRUHE |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Umlagerungseigenschaften von KARLSRUHE nach BERLIN anlegen
Given I open an editor "UMLEIG_KA_B" from table "(Warehouse):(RelocationProperties)" with command "NEW" for record ""
And I set field "lgruppe" to "KARLSRUHE"
And I append rows
    | lgziel    | tlzeit    | tlzeiteinh    | spedit    | mittel    |
    | BERLIN    | 2         | Arbeitstage   | TEST      | LKW       |
And I save the current editor

Given I open an editor "BG_EXT_UML" from table "(Part):(Product)" with command "UPDATE" for record "BG_EXT_UML"
And I press button "kalkul" to open a subeditor for "Kalkulation"
And I save the current subeditor to switch back to the parent editor
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I press button "kalkul" to open a subeditor for "Kalkulation" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I switch the current editor to editor "BG_EXT_UML"
And I save the current editor

# externe Lagergruppe mit bsart Fremdbeschaffung
Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG_EXT_FREMDB"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | bsart             | lief  | efrist    |
    | HONGKONG  | Fremdbeschaffung  | TEST  | 25        |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "BG_EXT_FREMDB" from table "(Part):(Product)" with command "UPDATE" for record "BG_EXT_FREMDB"
And I press button "kalkul" to open a subeditor for "Kalkulation"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open the infosystem "LMB"
And I set field "kartvon" to "BG_EXT_FREMDB"
And I set field "kartbis" to "BG_EXT_FREMDB"
And I set field "klgruppe" to "HONGKONG"
And I press start
Then table has values
    | artikel       | wbz   | bsart             |
    | BG_EXT_FREMDB | 25    | Fremdbeschaffung  |
And I set field "kartvon" to "BG_EXT_FERT"
And I set field "kartbis" to "BG_EXT_FERT"
And I set field "klgruppe" to "HONGKONG"
And I press start
Then table has values
    | artikel       | wbz   | bsart             |
    | BG_EXT_FERT   | 6     | Eigenfertigung    |
And I set field "kartvon" to "BG_EXT_UML"
And I set field "kartbis" to "BG_EXT_UML"
And I set field "klgruppe" to "BERLIN"
And I set field "bumlagern" to "ja"
And I press start
Then table has values
    | artikel       | wbz   | bsart     |
    | BG_EXT_UML    | 15    | Umlagern  |
And I set field "klgruppe" to "KARLSRUHE"
And I press start
Then table has values
    | artikel       | wbz   | bsart             |
    | BG_EXT_UML    | 13    | Eigenfertigung    |
And I close the current editor

Given I open an editor "EXT_HK" from table "(ProductionList):(ProductionList)" with command "UPDATE" for record "EXT_HK"
And I set field "flistestd" to "ja"
And I save the current editor

Given I open an editor "BG_EXT_FERT" from table "(Part):(Product)" with command "UPDATE" for record "BG_EXT_FERT"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I press button "kalkul" to open a subeditor for "Kalkulation" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I switch the current editor to editor "BG_EXT_FERT"
And I save the current editor

Given I open the infosystem "LMB"
And I set field "kartvon" to "BG_EXT_FERT"
And I set field "kartbis" to "BG_EXT_FERT"
And I set field "klgruppe" to "HONGKONG"
And I press start
Then table has values
    | artikel       | wbz   | bsart             |
    | BG_EXT_FERT   | 26    | Eigenfertigung    |
And I close the current editor

Given I open an editor "KB_EXT_FERT_HK" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,herkunft=BG_EXT_FERT;lgruppe=HONGKONG;flistestd=EXT_HK;typ=(StandardPreliminaryCostingOfProduct);@ablageart=(Active)"
And I close the current editor

Given I open an editor "KB_EXT_UML_B" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,herkunft=BG_EXT_UML;lgruppe=BERLIN;typ=(StandardPreliminaryCostingOfProduct);@ablageart=(Active)"
And I close the current editor

Given I open an editor "KB_EXT_UML_KA" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,herkunft=BG_EXT_UML;lgruppe==KARLSRUHE;typ=(StandardPreliminaryCostingOfProduct);@ablageart=(Active)"
And I close the current editor

Given I open an editor "KB_EXT_FERT_KA" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,herkunft=BG_EXT_FERT;lgruppe==KARLSRUHE;typ=(StandardPreliminaryCostingOfProduct);@ablageart=(Active)"
And I close the current editor

Given I open an editor "KB_EXT_FREMDB_KA" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,herkunft=BG_EXT_FREMDB;lgruppe==KARLSRUHE;typ=(StandardPreliminaryCostingOfProduct);@ablageart=(Active)"
And I close the current editor

Given I open the infosystem "LMB"
And I set field "kartvon" to "BG_EXT_FERT"
And I set field "kartbis" to "BG_EXT_UML"
And I set field "klgruppe" to "HONGKONG"
And I set field "bumlagern" to "ja"
And I press start
Then table has values
    | artikel       | wbz   | bsart             | flistestd^id  | kblatt^id             |
    | BG_EXT_FERT   | 26    | Eigenfertigung    | !EXT_HK^id    | !KB_EXT_FERT_HK^id    |
    | BG_EXT_FREMDB | 25    | Fremdbeschaffung  | (0,0,0)       | (0,0,0)               |
    | BG_EXT_UML    | 13    | Umlagern          | (0,0,0)       | !KB_EXT_UML_KA^id     |
And I set field "klgruppe" to "BERLIN"
And I press start
Then table has values
    | artikel       | wbz   | bsart             | flistestd     | kblatt^id             |
    | BG_EXT_FERT   | 13    | Umlagern          |               | !KB_EXT_FERT_KA^id    |
    | BG_EXT_FREMDB | 13    | Umlagern          |               | !KB_EXT_FREMDB_KA^id  |
    | BG_EXT_UML    | 15    | Umlagern          | STANDARD      | !KB_EXT_UML_B^id      |
And I close the current editor


Scenario: Artikel neu anlegen, ohne kalkulieren, danach Fertigungsliste anlegen

# Artikel neu anlegen, ohne zu kalkulieren
Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG_NEU"
And I set field "bsart" to "Eigenfertigung"
And I delete all rows
And I save the current editor

Given I open the infosystem "LMB"
And I set field "kartvon" to "BG_NEU"
And I set field "kartbis" to "BG_NEU"
And I set field "klgruppe" to "KARLSRUHE"
And I press start
Then table has values
    | artikel   | wbz   | bsart             | flistestd^id      | kblatt^id             |
    | BG_NEU    | 0     | Eigenfertigung    | (0,0,0)           | (0,0,0)               |
And I close the current editor

# Fertigungsliste im Artikel anlegen, nicht kalkulieren
Given I open an editor "BG_NEU" from table "(Part):(Product)" with command "UPDATE" for record "BG_NEU"
And I append rows
    | elex    | anzahl  |
    | BAUT    | 1       |
    | A AG1   | 1       |
And I save the current editor

Given I open an editor "FL_BG_NEU" from table "(ProductionList):(ProductionList)" with command "UPDATE" for search criteria "$,,artikel=BG_NEU;lgruppe=KARLSRUHE;@ablageart=(Active)"
And I set field "such" to "FL_BG_NEU"
And I save the current editor

Given I open the infosystem "LMB"
And I set field "kartvon" to "BG_NEU"
And I set field "kartbis" to "BG_NEU"
And I set field "klgruppe" to "KARLSRUHE"
And I press start
Then table has values
    | artikel   | wbz   | bsart             | flistestd^id      | kblatt^id             |
    | BG_NEU    | 0     | Eigenfertigung    | !FL_BG_NEU^id     | (0,0,0)               |
And I close the current editor

Given I open an editor "BG_NEU" from table "(Part):(Product)" with command "UPDATE" for record "BG_NEU"
And I press button "kalkul" to open a subeditor for "Kalkulation"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "KB_BG_NEU" from table "(CostingSheet):(CostingSheet)" with command "VIEW" for search criteria "$,,herkunft=BG_NEU;lgruppe=KARLSRUHE;typ=(StandardPreliminaryCostingOfProduct);stand<>`;@ablageart=(Active)"
And I close the current editor

Given I open the infosystem "LMB"
And I set field "kartvon" to "BG_NEU"
And I set field "kartbis" to "BG_NEU"
And I set field "klgruppe" to "KARLSRUHE"
And I press start
Then table has values
    | artikel   | wbz   | bsart             | flistestd^id      | kblatt^id     |
    | BG_NEU    | 5     | Eigenfertigung    | !FL_BG_NEU^id     | !KB_BG_NEU^id |
And I close the current editor


Scenario: Neue Standardfertigungsliste interne Lagergruppe

Given I open the infosystem "LMB"
And I set field "kartvon" to "BG_EXT_FERT"
And I set field "kartbis" to "BG_EXT_FERT"
And I set field "klgruppe" to "BERLIN"
And I press start
Then the table has 0 rows
And I set field "bumlagern" to "ja"
And I press start
Then table has values
    | artikel       | wbz   | bsart     |
    | BG_EXT_FERT   | 13    | Umlagern  |
And I close the current editor

# neue Standardfertigungsliste fuer interne Lagergruppe anlegen
Given I open an editor "BG_EXT_FERT" from table "(Part):(Product)" with command "VIEW" for record "BG_EXT_FERT"
And I close the current editor

Given I open an editor "FL" via ID from editor "BG_EXT_FERT" from field "flistestd" in row 0 for table "(ProductionList):(ProductionList)" with command "COPY"
And I set field "such" to "INT_KA_NEU"
Then field "artikel" has value "BG_EXT_FERT"
Then field "lgruppe" has value "KARLSRUHE"
And I set field "flistestd" to "ja"
And I append rows
    | elex    | anzahl  |
    | BAUT    | 1       |
    | A AG1   | 1       |
And I save the current editor

Given I open an editor "BG_EXT_FERT" from table "(Part):(Product)" with command "UPDATE" for record "BG_EXT_FERT"
And I press button "kalkul" to open a subeditor for "Kalkulation"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open the infosystem "LMB"
And I set field "kartvon" to "BG_EXT_FERT"
And I set field "kartbis" to "BG_EXT_FERT"
And I set field "klgruppe" to "BERLIN"
And I set field "bumlagern" to "ja"
And I press start
Then table has values
    | artikel       | wbz   | bsart     |
    | BG_EXT_FERT   | 16    | Umlagern  |
And I close the current editor
