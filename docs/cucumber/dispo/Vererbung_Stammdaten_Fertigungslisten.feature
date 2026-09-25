@persistent
Feature: Vererbung_Stammdaten_Fertigungslisten.feature

# **********************************************************************************
#  Name             : Vererbung_Stammdaten_Fertigungslisten.feature
#  Autor            : lbettendorf
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet Vererbung von Stammdaten aus der FL in Beschaffungen
#  ref              : ref_dispo_vererbung_stammdaten_cu
#  Stammdaten       : basis_stammdaten.feature
#
# **********************************************************************************


Background:
Given I set the fake date to "10.01.95"



@testvorbereitung
Scenario: Konfiguration Felder fuer Fertigungsliste setzen

Given I open the infosystem "SCHEDCONF"
And I set field "dbgruppe" to "V-128-01"
And I press start
And I modify table
    | !row                  | taktiv       | tnichtfixvorg |
    | tsuch=='PVERLUST'     | ja           | ja            |
    | tsuch=='ANZAHL'       | ja           | ja            |
    | tsuch=='AMGE'         | ja           | ja            |
    | tsuch=='LGE'          | ja           | ja            |
    | tsuch=='ELLME'        | ja           | ja            |
    | tsuch=='BREITE'       | ja           | ja            |
    | tsuch=='ELBME'        | ja           | ja            |
    | tsuch=='PZEIT'        | ja           | ja            |
    | tsuch=='PZEITEINH'    | ja           | ja            |
    | tsuch=='TLZEIT'       | ja           | ja            |
    | tsuch=='TLZEITEINH'   | ja           | ja            |
    | tsuch=='NUTZEN'       | ja           | ja            |
    | tsuch=='MANBU'        | ja           | ja            |
    | tsuch=='FLISTESTD'    | ja           | ja            |
    | tsuch=='ROWDELETE'    | ja           | ja            |
    | tsuch=='ROWINSERT'    | ja           | ja            |
    | tsuch=='MGR'          | ja           | ja            |
    | tsuch=='GRGR'         | ja           | ja            |
    | tsuch=='GRGRRUESTEN'  | ja           | ja            |
    | tsuch=='LGR'          | ja           | ja            |
    | tsuch=='LGRRUESTEN'   | ja           | ja            |
And I press button "update"
And I save the current editor

# Konfiguration fuer Felder Arbeitsgang setzen
Given I open the infosystem "SCHEDCONF"
And I set field "dbgruppe" to "V-07-00"
And I press start
And I modify table
    | !row                  | taktiv       | tinfl |
    | tsuch=='TR'           | ja           | ja    |
    | tsuch=='ZR'           | ja           | ja    |
    | tsuch=='TE'           | ja           | ja    |
    | tsuch=='ZE'           | ja           | ja    |
    | tsuch=='PZEIT'        | ja           | ja    |
    | tsuch=='PZEITEINH'    | ja           | ja    |
    | tsuch=='TLZEIT'       | ja           | ja    |
    | tsuch=='TLZEITEINH'   | ja           | ja    |
    | tsuch=='MGR'          | ja           | ja    |
    | tsuch=='GRGR'         | ja           | ja    |
    | tsuch=='GRGRRUESTEN'  | ja           | ja    |
    | tsuch=='LGR'          | ja           | ja    |
    | tsuch=='LGRRUESTEN'   | ja           | ja    |
And I press button "update"
And I save the current editor

@testvorbereitung
Scenario: Daten anlegen

Given I open an editor "E2K-EINHEITEN" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
    | such  | E2K-EINHEITEN |
    | fvhe  | 5             |
    | vhe   | kg            |
    | fvpe  | 5             |
    | vpe   | kg            |
    | le    | Paar          |
And I save the current editor

Given I open an editor "B2G-UNTERBG" from table "(Part):(Product)" with command "COPY" for record "BG-UNTERBG"
And I set fields
    | such      | B2G-UNTERBG   |
    | mindest   | 100           |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe   | bsart             | mindest |
  | BERLIN    | Eigenfertigung    | 100     |
And I save the current subeditor to switch back to the parent editor
And I modify table
    | !row  | elex          | lge           | breite        | elanzahl  | manbu         | pzeit | pzeiteinh     | tlzeit    | tlzeiteinh    |
    | +1    | E2K-EINHEITEN | 300           | 200           | 1         | ja            | 0     | !dontChange   | 1         | Arbeitstage   |
    | 2     | EK2-BEDARF    | !dontChange   | !dontChange   | 1         |               | 0     | !dontChange   | 0         | !dontChange   |
    | 3     | A AG-LOHN1    | 20            | 10            | 1         | !dontChange   | 5     | Stunden       | 1         | Arbeitstage   |
    | 4     | BG-BEDARF     | !dontChange   | !dontChange   | 1         |               | 1     | Kalendertage  | 0         | !dontChange   |
    | 5     | A AG-LOHN2    | 30            | 15            | 1         | !dontChange   | 0     | !dontChange   | 0         | !dontChange   |
Then table has values
    | !row  | elex          | lge   | ellme | breite    | elbme | elanzahl  | manbu | pzeit | pzeiteinh     | tlzeit    | tlzeiteinh    |
    | 1     | E2K-EINHEITEN | 300   | cm    | 200       | cm    | 1         | ja    | 0     |               | 1         | Arbeitstage   |
    | 2     | EK2-BEDARF    |       |       |           |       | 1         | nein  | 0     |               | 0         |               |
    | 3     | A AG-LOHN1    | 20    | min   | 10        | min   | 1         | nein  | 5     | Stunden       | 1         | Arbeitstage   |
    | 4     | BG-BEDARF     |       |       |           |       | 1         | nein  | 1     | Kalendertage  | 0         |               |
    | 5     | A AG-LOHN2    | 30    | min   | 15        | min   | 1         | nein  | 0     |               | 0         |               |
And I save the current editor

Given I create a SalesOrder "Auftrag1" for Customer "KUNDE1" with Product "B2G-UNTERBG" and quantity "20"
And I run Scheduling


Scenario: 01 Felder für Artikel in FL aendern anzahl, lge, ellme, breite, elbme, nutzen, manbu

# Dispo hat FV erstellt, um Auftrag1 und Mindestbestand für B2G-UNTERBG zu decken
# Aendern der genannten Felder in der FL des Artikels

Given I open an editor "B2G-UNTERBG" from table "(Part):(Product)" with command "UPDATE" for record "B2G-UNTERBG"
And I modify table
    | !row  | lge           | breite        | elanzahl  | nutzen        |
    | 1     | 350           | 250           | 1         | !dontChange   |
    | 2     | !dontChange   | !dontChange   | 2         | 2             |
And I save the current editor
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   | elanzahl  | nutzen    | manbu |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         | 0         | ja    |
    | 2     | EK2-BEDARF    |       |       |           |       | 2         | 2         | nein  |
    | 3     | A AG-LOHN1    | 20    | min   | 10        | min   | 1         | 0         | nein  |
    | 4     | BG-BEDARF     |       |       |           |       | 1         | 0         | nein  |
    | 5     | A AG-LOHN2    | 30    | min   | 15        | min   | 1         | 0         | nein  |
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   | elanzahl  | nutzen    | manbu |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         | 0         | ja    |
    | 2     | EK2-BEDARF    |       |       |           |       | 2         | 2         | nein  |
    | 3     | A AG-LOHN1    | 20    | min   | 10        | min   | 1         | 0         | nein  |
    | 4     | BG-BEDARF     |       |       |           |       | 1         | 0         | nein  |
    | 5     | A AG-LOHN2    | 30    | min   | 15        | min   | 1         | 0         | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 02 Felder im Arbeitsgang in FL aendern lge, ellme, breite, elbme

Given I open an editor "B2G-UNTERBG" from table "(Part):(Product)" with command "UPDATE" for record "B2G-UNTERBG"
And I modify table
    | !row  | lge   | ellme         | breite    | elbme         |
    | 3     | 25    | !dontChange   | 600       | s             |
    | 5     | 0.5   | h             | 20        | !dontChange   |
Then field "elbme" has value "s" in row 3
And I save the current editor
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    |
    | 2     | EK2-BEDARF    |       |       |           |       |
    | 3     | A AG-LOHN1    | 25    | min   | 600       | s     |
    | 4     | BG-BEDARF     |       |       |           |       |
    | 5     | A AG-LOHN2    | 0.5   | h     | 20        | min   |
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    |
    | 2     | EK2-BEDARF    |       |       |           |       |
    | 3     | A AG-LOHN1    | 25    | min   | 600       | s     |
    | 4     | BG-BEDARF     |       |       |           |       |
    | 5     | A AG-LOHN2    | 0.5   | h     | 20        | min   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 03 Felder in FL aendern pverlust, amge

# Felder in Artikel aendern, Arbeitsgang und bei Artikel
Given I open an editor "B2G-UNTERBG" from table "(Part):(Product)" with command "UPDATE" for record "B2G-UNTERBG"
And I modify table
    | !row  | pverlust      | amge          |
    | 1     | 30            | !dontChange   |
    | 2     | !dontChange   | 5             |
    | 3     | !dontChange   | 25            |
    | 5     | 20            | !dontChange   |
And I save the current editor
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | elanzahl  | nutzen    | gmge  | le    | pverlust  | amge  |
    | 1     | E2K-EINHEITEN | 1         | 0         | 625   | Paar  | 30        | 0     |
    | 2     | EK2-BEDARF    | 2         | 2         | 55    | Stück | 0         | 5     |
    | 3     | A AG-LOHN1    | 1         | 0         | 8.75  | h     | 0         | 25    |
    | 4     | BG-BEDARF     | 1         | 0         | 25    | Stück | 0         | 0     |
    | 5     | A AG-LOHN2    | 1         | 0         | 8.83  | h     | 20        | 0     |
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then table has values
    | !row  | elex          | elanzahl  | nutzen    | gmge  | le    | pverlust  | amge  |
    | 1     | E2K-EINHEITEN | 1         | 0         | 1875  | Paar  | 30        | 0     |
    | 2     | EK2-BEDARF    | 2         | 2         | 155   | Stück | 0         | 5     |
    | 3     | A AG-LOHN1    | 1         | 0         | 25.42 | h     | 0         | 25    |
    | 4     | BG-BEDARF     | 1         | 0         | 125   | Stück | 0         | 0     |
    | 5     | A AG-LOHN2    | 1         | 0         | 42.17 | h     | 20        | 0     |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 04 Felder in FL aendern pzeit, pzeiteinh, tlzeit, tlzeiteinh

# Aenderungen zu pverlust und amge auf 0 setzen, Puffer-, Transport- und Liegezeiten mit Einheiten aendern
# alle Zeiten reduzieren
Given I open an editor "B2G-UNTERBG" from table "(Part):(Product)" with command "UPDATE" for record "B2G-UNTERBG"
And I modify table
    | !row  | pverlust      | amge          | pzeit | pzeiteinh     | tlzeit    | tlzeiteinh        |
    | 1     |  0            | !dontChange   |       | !dontChange   | 3         | Arbeitsstunden    |
    | 2     | !dontChange   | 0             |       | !dontChange   |           | !dontChange       |
    | 3     | !dontChange   | 0             | 0     | !dontChange   | 0         | !dontChange       |
    | 4     | !dontChange   | !dontChange   | 1     | Kalendertage  |           | !dontChange       |
    | 5     | 0             | !dontChange   |       | !dontChange   |           | !dontChange       |
And I save the current editor
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | pzeit | pzeiteinh     | tlzeit    | tlzeiteinh        | wtsterm   | wtterm    |
    | 1     | E2K-EINHEITEN | 0     |               | 3         | Arbeitsstunden    | 16.01.95  | 16.01.95  |
    | 2     | EK2-BEDARF    | 0     |               | 0         |                   | 17.01.95  | 17.01.95  |
    | 3     | A AG-LOHN1    | 0     | Stunden       | 0         | Arbeitstage       | 17.01.95  | 18.01.95  |
    | 4     | BG-BEDARF     | 1     | Kalendertage  | 0         |                   | 18.01.95  | 18.01.95  |
    | 5     | A AG-LOHN2    | 0     |               | 0         |                   | 19.01.95  | 23.01.95  |
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then table has values
    | !row  | elex          | pzeit | pzeiteinh     | tlzeit    | tlzeiteinh        | wtsterm   | wtterm    |
    | 1     | E2K-EINHEITEN | 0     |               | 3         | Arbeitsstunden    | 19.01.95  | 19.01.95  |
    | 2     | EK2-BEDARF    | 0     |               | 0         |                   | 20.01.95  | 20.01.95  |
    | 3     | A AG-LOHN1    | 0     | Stunden       | 0         | Arbeitstage       | 20.01.95  | 27.01.95  |
    | 4     | BG-BEDARF     | 1     | Kalendertage  | 0         |                   | 30.01.95  | 30.01.95  |
    | 5     | A AG-LOHN2    | 0     |               | 0         |                   | 31.01.95  | 15.02.95  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# alle Zeiten erhoehen und hinzufuegen
Given I switch the current editor to editor "B2G-UNTERBG" with command "UPDATE"
And I modify table
    | !row  | pzeit         | pzeiteinh     | tlzeit        | tlzeiteinh        |
    | 1     | !dontChange   | !dontChange   | 3             | Arbeitstage       |
    | 2     | !dontChange   | !dontChange   | !dontChange   | !dontChange       |
    | 3     | 12            | Stunden       | 1             | Arbeitstage       |
    | 4     | 1             | Kalendertage  | 3             | Arbeitstage       |
And I save the current editor
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | pzeit | pzeiteinh     | tlzeit    | tlzeiteinh        | wtsterm   | wtterm    |
    | 1     | E2K-EINHEITEN | 0     |               | 3         | Arbeitstage       | 16.01.95  | 16.01.95  |
    | 2     | EK2-BEDARF    | 0     |               | 0         |                   | 19.01.95  | 19.01.95  |
    | 3     | A AG-LOHN1    | 12    | Stunden       | 1         | Arbeitstage       | 20.01.95  | 23.01.95  |
    | 4     | BG-BEDARF     | 1     | Kalendertage  | 3         | Arbeitstage       | 24.01.95  | 24.01.95  |
    | 5     | A AG-LOHN2    | 0     |               | 0         |                   | 30.01.95  | 01.02.95  |
And I close the current subeditor to switch back to the parent editor                
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2      
Then table has values                                                                
    | !row  | elex          | pzeit | pzeiteinh     | tlzeit    | tlzeiteinh        | wtsterm   | wtterm    |
    | 1     | E2K-EINHEITEN | 0     |               | 3         | Arbeitstage       | 16.01.95  | 16.01.95  |
    | 2     | EK2-BEDARF    | 0     |               | 0         |                   | 19.01.95  | 19.01.95  |
    | 3     | A AG-LOHN1    | 12    | Stunden       | 1         | Arbeitstage       | 19.01.95  | 26.01.95  |
    | 4     | BG-BEDARF     | 1     | Kalendertage  | 3         | Arbeitstage       | 30.01.95  | 30.01.95  |
    | 5     | A AG-LOHN2    | 0     |               | 0         |                   | 03.02.95  | 20.02.95  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 05 Standardfertigungsliste aendern

# Alternative FL fuer B2G-UNTERBG anlegen
Given I open an editor "FL2-UNTERBG" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
And I set fields
    | such      | FL2-UNTERBG       |
    | artikel   | B2G-UNTERBG       |
    | bsart     | Eigenfertigung    |
    | flistestd | ja                |
    | lgruppe   | KARLSRUHE         |
And I append rows
    | elex          | lge           | breite        | elanzahl  |
    | EK1-BEDARF    | !dontChange   | !dontChange   | 1         |
    | EK2-BEDARF    | !dontChange   | !dontChange   | 1         |
    | A AG-LOHN1    | 20            | 10            | 1         |
And I save the current editor

And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then field "flistestd" has value "FL2-UNTERBG"
Then the table has 3 rows
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then field "flistestd" has value "FL2-UNTERBG"
Then the table has 3 rows
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I switch the current editor to editor "B2G-UNTERBG" with command "UPDATE"
And I set field "flistestd" to "STANDARD"
And I save the current editor
Then field "flistestd" has value "STANDARD"
Then the table has 5 rows
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then field "flistestd" has value "STANDARD"
Then the table has 5 rows
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then field "flistestd" has value "STANDARD"
Then the table has 5 rows
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 06 Zeilen in FL loeschen und hinzufuegen, pruefen der tzid

# Zeile hinzufuegen mit dem gleichen Material, ein neues Material, ein neuer Arbeitsgang
Given I open an editor "B2G-UNTERBG" from table "(Part):(Product)" with command "UPDATE" for record "B2G-UNTERBG"
And I modify table
    | !row  | elex          | lge           | ellme         | breite        | elbme         | elanzahl  |
    | +1    | EK1-BEDARF    | !dontChange   | !dontChange   | !dontChange   | !dontChange   | 1         |
    | +4    | EK2-BEDARF    | !dontChange   | !dontChange   | !dontChange   | !dontChange   | 1         |
    | +6    | A AG-LOHN3    | 10            | min           | 15            | min           | 1         |
And I save the current editor
Then table has values
    | !row  | elex          | lge   | ellme | breite    | elbme | elanzahl  | tzid  |
    | 1     | EK1-BEDARF    |       |       |           |       | 1         | 6     |
    | 2     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         | 5     |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         | 1     |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         | 7     |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         | 2     |
    | 6     | A AG-LOHN3    | 10    | min   | 15        | min   | 1         | 8     |
    | 7     | BG-BEDARF     |       |       |           |       | 1         | 3     |
    | 8     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         | 4     |
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   | elanzahl  | flzid |
    | 1     | EK1-BEDARF    |       |       |           |       | 1         | 6     |
    | 2     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         | 5     |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         | 1     |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         | 7     |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         | 2     |
    | 6     | A AG-LOHN3    | 10    | min   | 15        | min   | 1         | 8     |
    | 7     | BG-BEDARF     |       |       |           |       | 1         | 3     |
    | 8     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         | 4     |
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   | elanzahl  | flzid |
    | 1     | EK1-BEDARF    |       |       |           |       | 1         | 6     |
    | 2     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         | 5     |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         | 1     |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         | 7     |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         | 2     |
    | 6     | A AG-LOHN3    | 10    | min   | 15        | min   | 1         | 8     |
    | 7     | BG-BEDARF     |       |       |           |       | 1         | 3     |
    | 8     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         | 4     |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Zeilen loeschen und ein hinzufuegen
Given I open an editor "B2G-UNTERBG" from table "(Part):(Product)" with command "UPDATE" for record "B2G-UNTERBG"
And I modify table
    | !row  | elex          | lge           | lme           | breite        | bme           | elanzahl  |
    | -1    | EK1-BEDARF    |               |               |               |               |           |
    | -5    | A AG-LOHN3    |               |               |               |               |           |
    | +2    | EK1-BEDARF    | !dontChange   | !dontChange   | !dontChange   | !dontChange   | 1         |
And I save the current editor
Then table has values
    | !row  | elex          | lge   | ellme | breite    | elbme | elanzahl  | tzid  |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         | 5     |
    | 2     | EK1-BEDARF    |       |       |           |       | 1         | 9     |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         | 1     |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         | 7     |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         | 2     |
    | 6     | BG-BEDARF     |       |       |           |       | 1         | 3     |
    | 7     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         | 4     |
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   | elanzahl  | flzid |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         | 5     |
    | 2     | EK1-BEDARF    |       |       |           |       | 1         | 9     |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         | 1     |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         | 7     |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         | 2     |
    | 6     | BG-BEDARF     |       |       |           |       | 1         | 3     |
    | 7     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         | 4     |
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   | elanzahl  | flzid |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         | 5     |
    | 2     | EK1-BEDARF    |       |       |           |       | 1         | 9     |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         | 1     |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         | 7     |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         | 2     |
    | 6     | BG-BEDARF     |       |       |           |       | 1         | 3     |
    | 7     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         | 4     |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 07 Zwei Zeilen mit gleichen Artikeln, eine Zeile wird geaendert

Given I switch the current editor to editor "B2G-UNTERBG" with command "UPDATE"
And I set field "elanzahl" to "5" in row 4
And I save the current editor
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | elanzahl  |
    | 1     | E2K-EINHEITEN | 1         |
    | 2     | EK1-BEDARF    | 1         |
    | 3     | EK2-BEDARF    | 2         |
    | 4     | EK2-BEDARF    | 5         |
    | 5     | A AG-LOHN1    | 1         |
    | 6     | BG-BEDARF     | 1         |
    | 7     | A AG-LOHN2    | 1         |
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then table has values
    | !row  | elex          | elanzahl  |
    | 1     | E2K-EINHEITEN | 1         |
    | 2     | EK1-BEDARF    | 1         |
    | 3     | EK2-BEDARF    | 2         |
    | 4     | EK2-BEDARF    | 5         |
    | 5     | A AG-LOHN1    | 1         |
    | 6     | BG-BEDARF     | 1         |
    | 7     | A AG-LOHN2    | 1         |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "B2G-UNTERBG" from table "(Part):(Product)" with command "UPDATE" for record "B2G-UNTERBG"
And I set field "elanzahl" to "1" in row 4
And I save the current editor
Then table has values
    | !row  | elex          | lge   | ellme | breite    | elbme | elanzahl  |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         |
    | 2     | EK1-BEDARF    |       |       |           |       | 1         |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         |
    | 6     | BG-BEDARF     |       |       |           |       | 1         |
    | 7     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         |
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   | elanzahl  |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         |
    | 2     | EK1-BEDARF    |       |       |           |       | 1         |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         |
    | 6     | BG-BEDARF     |       |       |           |       | 1         |
    | 7     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         |
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
Then table has values
    | !row  | elex          | lge   | lme   | breite    | bme   | elanzahl  |
    | 1     | E2K-EINHEITEN | 350   | cm    | 250       | cm    | 1         |
    | 2     | EK1-BEDARF    |       |       |           |       | 1         |
    | 3     | EK2-BEDARF    |       |       |           |       | 2         |
    | 4     | EK2-BEDARF    |       |       |           |       | 1         |
    | 5     | A AG-LOHN1    | 25    | min   | 600       | s     | 1         |
    | 6     | BG-BEDARF     |       |       |           |       | 1         |
    | 7     | A AG-LOHN2    | 0.5   | h     | 20        | min   | 1         |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 08 Felder in Unterbaugruppe aendern anzahl, lge, ellme, breite, elbme, nutzen, manbu

# Zeile einfügen, bestehende Zeilen ändern, Zeile löschen und neue hinzufügen
Given I open an editor "BG-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "BG-BEDARF"
And I modify table
    | !row      | elex          | lge           | ellme         | breite        | elbme         | elanzahl      |
    | +1        | EK2-BEDARF    | !dontChange   | !dontChange   | !dontChange   | !dontChange   | 1             |
    | 2         | !dontChange   | !dontChange   | !dontChange   | !dontChange   | !dontChange   | 5             |
    | -3        |               |               |               |               |               |               |
    | 3         | !dontChange   | 0.5           | h             | !dontChange   | !dontChange   | !dontChange   |
    | +4        | A AG1         | !dontChange   | !dontChange   | !dontChange   | !dontChange   | 1             |
And I save the current editor
Then table has values
    | !row      | elex          | lge           | ellme         | breite        | elbme         | elanzahl      |
    | 1         | EK2-BEDARF    |               |               |               |               | 1             |
    | 2         | EK1-BEDARF    |               |               |               |               | 5             |
    | 3         | A AG-LOHN2    | 0.5           | h             | 15            | min           | 1             |
    | 4         | A AG1         | 20            | min           | 10            | min           | 1             |
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
And I descend to a lower level of the BOM in row 6
Then table has values
    | !row      | elex          | lge           | lme           | breite        | bme           | elanzahl      |
    | 1         | EK2-BEDARF    |               |               |               |               | 1             |
    | 2         | EK1-BEDARF    |               |               |               |               | 5             |
    | 3         | A AG-LOHN2    | 0.5           | h             | 15            | min           | 1             |
    | 4         | A AG1         | 20            | min           | 10            | min           | 1             |
And I close the current editor
And I switch the current editor to editor "fvor"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
And I descend to a lower level of the BOM in row 6
Then table has values
    | !row      | elex          | lge           | lme           | breite        | bme           | elanzahl      |
    | 1         | EK2-BEDARF    |               |               |               |               | 1             |
    | 2         | EK1-BEDARF    |               |               |               |               | 5             |
    | 3         | A AG-LOHN2    | 0.5           | h             | 15            | min           | 1             |
    | 4         | A AG1         | 20            | min           | 10            | min           | 1             |
And I close the current editor
And I switch the current editor to editor "fvor"
And I close the current editor


Scenario: 09 Standardfertigungsliste in Unterbaugruppe aendern

# Alternative FL fuer BG-BEDARF anlegen
Given I open an editor "BG-ALTERNATIVE" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
And I set fields
    | such      | BG-ALTERNATIVE    |
    | artikel   | BG-BEDARF         |
    | bsart     | Eigenfertigung    |
    | flistestd | ja                |
    | lgruppe   | KARLSRUHE         |
And I append rows
    | elex    | elanzahl  |
    | E2      | 1         |
    | E3      | 1         |
    | A AG1   | 1         |
And I save the current editor
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
And I descend to a lower level of the BOM in row 6
Then field "flistestd" has value "BG-ALTERNATIVE"
Then the table has 3 rows
And I close the current editor
And I switch the current editor to editor "fvor"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
And I descend to a lower level of the BOM in row 6
Then field "flistestd" has value "BG-ALTERNATIVE"
Then the table has 3 rows
And I close the current editor
And I switch the current editor to editor "fvor"
And I close the current editor

And I switch the current editor to editor "BG-BEDARF" with command "UPDATE"
And I set field "flistestd" to "STANDARD"
And I save the current editor
Then field "flistestd" has value "STANDARD"
#Then the table has 4 rows
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
And I descend to a lower level of the BOM in row 6
Then field "flistestd" has value "STANDARD"
#Then the table has 5 rows
And I close the current editor
And I switch the current editor to editor "fvor"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
And I descend to a lower level of the BOM in row 6
Then field "flistestd" has value "STANDARD"
#Then the table has 5 rows
And I close the current editor
And I switch the current editor to editor "fvor"
And I close the current editor


Scenario: 10 Fertigungsliste in Lagergruppeneigenschaften aendern

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then field "flistestd" has value "STANDARD"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "FL-BERLIN" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
And I set fields
    | such      | FL-BERLIN         |
    | artikel   | B2G-UNTERBG       |
    | bsart     | Eigenfertigung    |
    | flistestd | ja                |
    | lgruppe   | BERLIN            |
And I append rows
    | elex          | lge           | breite        | elanzahl  |
    | EK1-BEDARF    | !dontChange   | !dontChange   | 1         |
    | EK2-BEDARF    | !dontChange   | !dontChange   | 1         |
    | A AG-LOHN1    | 20            | 10            | 1         |
And I save the current editor
And I run Scheduling

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "B2G-UNTERBG"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 1
Then field "flistestd" has value "FL-BERLIN"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

#### Szenarien fuer Felder aus Arbeitsgang ####

Scenario: A01 Felder im Objekt Arbeitsgang aendern und vererben in Fertigungsliste

Given I open an editor "AG4" from table "(Operation):(Operation)" with command "UPDATE" for record "AG4"
And I set fields
    | tr            | 10            |
    | zr            | min           |
    | te            | 30            |
    | ze            | min           |
    | pzeit         | 0             |
    | pzeiteinh     | Arbeitstage   |
    | tlzeit        | 1             |
    | tlzeiteinh    | Stunden       |
And I save the current editor

Given I open an editor "V3" from table "(Part):(Product)" with command "UPDATE" for record "V3"
And I append rows
    | elem  |
    | A AG4 |
Then table has values
    | !row        | elem  | lge | ellme  | breite   | elbme    | pzeit    | pzeiteinh   | tlzeit    | tlzeiteinh    |
    | !lastRow    | A AG4 | 10  | min    |    30    | min      | 0        | Arbeitstage | 1         | Stunden       |
And I save the current editor

Given I open an editor "AG4" from table "(Operation):(Operation)" with command "UPDATE" for record "AG4"
And I set fields
    | tr            | 1             |
    | zr            | h             |
    | te            | 111           |
    | ze            | s             |
    | pzeit         | 1             |
    | pzeiteinh     | Stunden       |
    | tlzeit        | 2             |
    | tlzeiteinh    | Kalendertage  |
And I save the current editor

And I run Scheduling

Given I open an editor "V3" from table "(Part):(Product)" with command "VIEW" for record "V3"
Then table has values
    | !row        | elem  | lge | ellme  | breite   | elbme    | pzeit    | pzeiteinh | tlzeit    | tlzeiteinh    |
    | !lastRow    | A AG4 | 1   | h      |   111    | s        | 1        | Stunden   | 2         | Kalendertage  |
And I close the current editor


Scenario: A02 Felder im Objekt Arbeitsgang aendern und vererben in Fertigungsliste sowie offene Vorgaenge

Given I open an editor "AG1" from table "(Operation):(Operation)" with command "COPY" for record "AG1"
And I set fields
    | such          | AGA02     |
    | mgr           | 111       |
    | grgr          | 1         |
    | grgrruesten   | 2         |
    | lgr           | 3         |
    | lgrruesten    | 1         |
And I save the current editor

Given I open an editor "V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set fields
    | mindest   | 15    |
    | maxbsmge  |  8    |
And I append rows
    | elem      |
    | A AGA02   |
Then table has values
    | !row      | elem      | mgr | grgr  | grgrruesten   | lgr | lgrruesten    |
    | !lastRow  | A AGA02   | 111 | 1     | 2             | 3   | 1             |
And I save the current editor

# Dispo um Fertigungsvorschlaege fuer Mindestbestand zu erzeugen
And I run Scheduling

# einen der Fertigungsvorschlaege fixieren
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,artikel==V1;mge==7;@richtung=rückwärts;@maxordtreffer=1"
And I set field "fix" to "ja"
And I save the current editor

Given I open an editor "AGA02" from table "(Operation):(Operation)" with command "UPDATE" for record "AGA02"
And I set fields
    | mgr           | 102       |
    | grgr          | 2         |
    | grgrruesten   | 3         |
    | lgr           | 2         |
    | lgrruesten    | 3         |
And I save the current editor

And I run Scheduling

Given I open an editor "V1" from table "(Part):(Product)" with command "VIEW" for record "V1"
Then table has values
    | !row      | elem      | mgr | grgr  | grgrruesten   | lgr | lgrruesten    |
    | !lastRow  | A AGA02   | 102 | 2     | 3             | 2   | 3             |
And I save the current editor

# wurde nur in unfixierten Vorgang vererbt
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==V1;mge==8;fix==nein;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row      | elem      | mgr | grgr  | grgrruesten   | lgr | lgrruesten    |
    | !lastRow  | A AGA02   | 102 | 2     | 3             | 2   | 3             |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# in fixierten Vorgang nicht vererbt
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==V1;mge==7;fix==ja;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row      | elem      | mgr | grgr  | grgrruesten   | lgr | lgrruesten    |
    | !lastRow  | A AGA02   | 111 | 1     | 2             | 3   | 1             |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

