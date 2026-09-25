@persistent
Feature: basisartikel_fertigung_kalkulation.feature

  Background:
    And I set the fake date to "01.01.2000"

    Given I'm logged in with password "sy"

# *****************************************************************************
#  Name             : basisartikel_fertigung_kalkulation.feature
#  Autor            : bschiga
#  Verantwortlich   : drpf
#  Kontrolle        : lbettendorf
#  Funktion         : Testet Basisartikel in Fertigungsliste, Zählliste und
#					: Kalkulation
#
# *****************************************************************************

## verwendet Daten die in basisartikel.feature angelegt wurden
## bspw. BAS_AUF, BAS-PLAN, BAS_AUSL, BAS-AENDERN


  Scenario: Fertigungsvorschlag neu anlegen für Basisartikel

# FV für Basisartikel mit Standardversion, da mehrere Versionen vorhanden, wird artikel nicht gefüllt
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "basisartikel" to "BAS_AUF" in row 1
    Then field "artikel" is empty in row 1
# 2382 de      |Bitte Artikel eintragen
    Then saving the current editor throws the exception "2382"
    And I set field "artikel" to "FE2-AUFTRAG" in row 1
    And I set field "netmge" to "10" in row 1
    And I save the current editor

# FV für Basisartikel mit mehreren Versionen, Version die nicht Standard ist kann eingetragen werden
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "basisartikel" to "BAS_AUF" in row 1
# Der Artikel ist keine Version des Basisartikels BAS_AUF
    Then setting field "artikel" to "FE1-BEDARF" in row 1 throws the exception "1361"
    And I set field "artikel" to "FE1-AUFTRAG" in row 1
    And I set field "netmge" to "10" in row 1
    And I save the current editor

# #### Auskommentiert, da mit dem neuen Framework Zeilen, in denen nur Skipfelder belegt sind, gelöscht werden !!! ####
# TODO amk: Wenn Framework korrigiert ist, Kommentar entfernen
# # FV für Basisartikel mit mehreren Versionen, ohne Standardversion
#     Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
#     And I create a new row at the end of the table
#     And I set field "basisartikel" to "BAS-PLAN" in row 1
#     Then field "artikel" is empty in row 1
# # 2382 de      |Bitte Artikel eintragen
#     Then saving the current editor throws the exception "2382"
#     And I set field "artikel" to "PLAN-E01" in row 1
#     And I set field "netmge" to "10" in row 1
#     And I save the current editor

# FV für Basisartikel mit nur einer Versionen, die nicht Standardversion ist, Version wird übernommen, da eindeutig ist
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "basisartikel" to "BAS_AUSL" in row 1
    Then field "artikel" has value "V_AUSLAUF" in row 1
    And I set field "netmge" to "10" in row 1
    And I save the current editor


  Scenario: Fertigungsvorschlag für Baugruppe, dann absteigen in Fertigungsliste und Basisartikel eintragen

# FV Neu und in die Fertigungsliste Basisartikel eintragen
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "artikel" to "BAUT" in row 1
    And I set field "netmge" to "10" in row 1
    And I save the current editor

    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BAUT"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I create a new row at the end of the table
# Basisartikel mit mehreren Versionen und Standardversion
    And I set field "basisartikel" to "BAS_AUF" in row !lastRow
# 60 de      |Bitte Teil eintragen
    Then saving the current editor throws the exception "60"
    And I set field "elex" to "FE2-AUFTRAG" in row !lastRow
    And I set field "elanzahl" to "1" in row !lastRow
    And I create a new row at the end of the table
# Basisartikel mit mehreren Versionen ohne Standardversion
    And I set field "basisartikel" to "BAS-PLAN" in row !lastRow
# 60 de      |Bitte Teil eintragen
    Then saving the current editor throws the exception "60"
    And I set field "elex" to "PLAN-E01" in row !lastRow
    And I set field "elanzahl" to "1" in row !lastRow
    And I create a new row at the end of the table
# Basisartikel mit nur einer Versionen, die nicht Standardversion ist, Version wird übernommen, da eindeutig ist
    And I set field "basisartikel" to "BAS_AUSL" in row !lastRow
    Then field "elex" has value "V_AUSLAUF" in row !lastRow
    And I set field "elanzahl" to "1" in row !lastRow
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor


  Scenario: Baugruppe mit Fertigungsliste nur Basisartikel eintragen, elex leer, AFL auflösen

    Given I open an editor "BGNURBASIS" from table "(Part):(Product)" with command "STORE" for record "BGNURBASIS"
    And I set fields
      | such     | BGNURBASIS                    |
      | namebspr | FL mit Basisartikel ohne elem |
      | bsart    | Eigenfertigung                |
      | mindest  | 50                            |
    And I delete all rows
    And I append rows
      | tbasisartikel | elex  | elanzahl |
      | BAS_BED       |       | 1        |
      |               | E3    | 1        |
      |               | A AG1 | 1        |
    And I save the current editor

    And I run Scheduling

# FE2-BEDARF ist Standardversion
    Given I open an editor "FE2-BEDARF" from table "(Part):(Product)" with command "VIEW" for record "FE2-BEDARF"
    Then fields have values
      | basisartikel | BAS_BED |
      | stdvers      | ja      |
    And I close the current editor

# FV durch Dispo angelegt, in AFL ist elem gefüllt mit Standardversion
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BGNURBASIS"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "elex" has value "FE2-BEDARF" in row 1
    Then field "limge" has value "50" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


  Scenario: Fertigungsvorschlag Neu für Artikel mit Basisartikel, Disponent wird aus Artikel oder Basisartikel übernommen

    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | basisartikel | artikel  | netmge |
      | BAS-AENDERN  | AENDERN1 | 5      |
    And I save the current editor

    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "AENDERN1"
    And I press button "ladetab"
    Then field "betreuer^such" has value "KARL" in row 1
    And I close the current editor

    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "UPDATE" for record "AENDERN1"
    And I set field "fbetreuer" to "MEIER"
    And I save the current editor

    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | basisartikel | artikel  | netmge |
      | BAS-AENDERN  | AENDERN1 | 15     |
    And I save the current editor

    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "AENDERN1"
    And I press button "ladetab"
    Then field "betreuer^such" has value "KARL" in row 1
    Then field "betreuer^such" has value "MEIER" in row 2
    And I close the current editor

  Scenario: Fertigungsvorschlag durch Dispo erstellt für Baugruppe mit Basisartikel, Disponent wird übernommen

    Given I open an editor "BGFBETREUER" from table "(Part):(Product)" with command "STORE" for record "BGFBETREUER"
    And I set fields
      | such      | BGFBETREUER              |
      | namebspr  | Baugruppe Disponent Fert |
      | bsart     | Eigenfertigung           |
      | mindest   | 50                       |
      | fbetreuer | TEST                     |
    And I delete all rows
    And I append rows
      | tbasisartikel | elex  | elanzahl |
      | BAS-AENDERN   |       | 1        |
      |               | E3    | 1        |
      |               | A AG1 | 1        |
    And I save the current editor

    And I run Scheduling

    Given I open an editor "BAS-AENDERN" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-AENDERN"
    Then field "fbetreuer" has value "KARL"
    And I close the current editor

    Given I open an editor "AENDERN3" from table "(Part):(Product)" with command "VIEW" for record "AENDERN3"
    Then field "fbetreuer" has value ""
    And I close the current editor

    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "AENDERN3"
    And I press button "ladetab"
# Disponent wurde aus Basisartikel übernommen
    Then field "betreuer^such" has value "KARL" in row 1
    And I close the current editor

# Mindestbestand erhöhen, damit weiterer FV erstellt wird
    Given I open an editor "BGFBETREUER" from table "(Part):(Product)" with command "UPDATE" for record "BGFBETREUER"
    And I set fields
      | mindest  | 100 |
      | maxbsmge | 50  |
    And I save the current editor

    Given I open an editor "AENDERN3" from table "(Part):(Product)" with command "UPDATE" for record "AENDERN3"
    And I set field "fbetreuer" to "MEIER"
    And I save the current editor

    And I run Scheduling

    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "AENDERN3"
    And I press button "ladetab"
# Disponent wurde aus Basisartikel übernommen
    Then field "betreuer^such" has value "KARL" in row 1
# Disponent wurde aus Artikel übernommen
    Then field "betreuer^such" has value "MEIER" in row 2
    And I close the current editor


  Scenario: Fertigungsvorschlag Neu und freigeben, dann die Fertigungsliste ändern und Basisartikel eintragen

# Fertigungsvorschlag manuell anlegen für Baugruppe, in der FL ist ein Basisartikel und elem leer
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BGNURBASIS | 10     | FE1AUF_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "FV"
    And I save the current editor

# neue Zeile in der AFL und Basisartikel eintragen, Version muss eingetragen werden
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FE1AUF_000"
    And I press button "absteig" to open a subeditor for "AFL"
    And I delete row at position 1
    And I create a new row at position 1
    And I set field "basisartikel" to "BAS_AUF" in row 1
# 60 de      |Bitte Teil eintragen
    Then saving the current editor throws the exception "60"
    And I set field "elex" to "FE1-AUFTRAG" in row 1
    And I set field "elanzahl" to "1" in row 1
    And I save the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | mfreig |
      | BGNURBASIS | 10     | AUSL_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "FV"
    And I save the current editor

# neue Zeile in der AFL und Basisartikel eintragen, Version wird gezogen, wenn es nur eine gibt
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUSL_000"
    And I press button "absteig" to open a subeditor for "AFL"
    And I delete row at position 1
    And I create a new row at position 1
    And I set field "basisartikel" to "BAS_AUSL" in row 1
    Then field "elex" has value "V_AUSLAUF" in row 1
    And I set field "elanzahl" to "1" in row 1
    And I save the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I save the current editor


  Scenario: Zählliste neu, Basisartikel und Version müssen eingetragen werden

# Bestand zubuchen für Versionen
    And I post a receipt via ManualStockAdjustment for Product "FE1-AUFTRAG" and quantity "10" on StorageLocation "F1" with document "MANLBU01"
    And I post a receipt via ManualStockAdjustment for Product "FE2-AUFTRAG" and quantity "5" on StorageLocation "F1" with document "MANLBU02"
    And I post a receipt via ManualStockAdjustment for Product "V_AUSLAUF" and quantity "1" on StorageLocation "F1" with document "MANLBU02"

# Zählliste neu und Basisartikel eintragen, mehrere Versionen eines Basisartikels auf der Zählliste möglich
    Given I open an editor "ZL_BASISARTIKEL" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
    And I set field "such" to "BASISARTIKEL"
    And I delete all rows
    And I create a new row at position 1
    And I set field "basisartikel" to "BAS_AUF" in row 1
# 2382  Bitte Artikel eintragen
    Then saving the current editor throws the exception "2382"
    And I set field "artikel" to "FE1-AUFTRAG" in row 1
    And I set field "platz" to "F1" in row 1
    And I create a new row at position 2
    And I set field "basisartikel" to "BAS_AUF" in row 2
    And I set field "platz" to "F1" in row 2
# 2382  Bitte Artikel eintragen
    Then saving the current editor throws the exception "2382"
    And I set field "artikel" to "FE2-AUFTRAG" in row 2
    And I create a new row at position 3
    And I set field "basisartikel" to "BAS_AUSL" in row 3
# artikel wird automatisch gefüllt, weil nur eine Version vorhanden
    Then field "artikel" has value "V_AUSLAUF" in row 3
    And I set field "platz" to "F1" in row 3
    And I save the current editor

# Zaehlliste loeschen
    Given I open an editor "ZL_LOESCH" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DELETE" for record "BASISARTIKEL"
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

  Scenario: Kalkulation im Artikel, Kalkulationsblatt kopieren und neue Zeile mit Basisartikel

# Artikel kalkulieren, der in FL nur basisartikel gefüllt hat, KBlatt muss dann mit dem Standard angelegt werden

# FE2-BEDARF ist Standardversion
    Given I open an editor "FE2-BEDARF" from table "(Part):(Product)" with command "VIEW" for record "FE2-BEDARF"
    Then fields have values
      | basisartikel | BAS_BED |
      | stdvers      | ja      |
    And I close the current editor

    Given I open an editor "BGNURBASIS" from table "(Part):(Product)" with command "UPDATE" for record "BGNURBASIS"
# Prüfen: in der FL nur Basisartikel gefüllt, elem leer
    Then table has values
      | tbasisartikel | elem |
      | BAS_BED       |      |
    And I press button "kalkul" to open a subeditor for "Kblatt"
    Then table has values
      | tbasisartikel | elem       | menge | efehler |
      | BAS_BED       | FE2-BEDARF | 1     | nein    |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# KBlatt kopieren, Zeile zufügen basisartikel eintragen, version wird gefüllt wenn eindeutig, sonst bleibt elem leer und kann nicht gespeichert werden

    Given I open an editor "BGNURBASIS" from table "(Part):(Product)" with command "UPDATE" for record "BGNURBASIS"
    And I press button "kblatt" to open a subeditor for "Kblatt"
    And I press button "kopieren" to open a subeditor for "Kblattkopieren"
    And I create a new row at the end of the table
    And I set field "tbasisartikel" to "BAS_AUSL" in row !lastRow
# elem ist gefüllt, weil eindeutig
    Then field "elem" has value "V_AUSLAUF" in row !lastRow
    Then field "menge" has value "1" in row !lastRow
    And I set field "ekart" to "MK" in row !lastRow
    And I create a new row at the end of the table
    And I set field "tbasisartikel" to "BAS_AUF" in row !lastRow
# 2382  Bitte Artikel eintragen
# ergibt jetzt eine Leerzeile die nicht mehr beruecksichtigt wird. Kann nicht mehr passieren
#   Then saving the current editor throws the exception "2382"
#   And I set field "elem" to "FE1-AUFTRAG" in row !lastRow
#   Then field "menge" has value "1" in row !lastRow
#   And I set field "ekart" to "MK" in row !lastRow
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

