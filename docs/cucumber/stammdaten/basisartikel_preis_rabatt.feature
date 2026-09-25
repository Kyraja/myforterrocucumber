@persistent
Feature: basisartikel_preis_rabatt.feature

  Background:
    And I set the fake date to "01.01.2000"
    Given I enable the flag 39

    Given I'm logged in with password "sy"

# *****************************************************************************
#  Name             : basisartikel_preis_rabatt.feature
#  Autor            : bschiga
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Preis-/Rabattgruppe Basisartikel und Versionen
#
# *****************************************************************************

  Scenario: Versionsnummernvorlage eintragen
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | verskontrnummerkreisvorl | 313 |
    And I save the current editor

# -----------------------------------------------------------------------------
  Scenario: 01 Preisgruppen und Basisartikel anlegen fuer nachfolgende Szenarien
# -----------------------------------------------------------------------------

# Preisgruppe anlegen
    Given I open an editor "PRGR1" from table "(Pricing):(Pricing)" with command "NEW" for record ""
    And I set fields
      | such   | PRGR1 |
      | gltvon | .     |
      | gltbis | +10   |
      | klpg   | 1     |
      | mgeab  | ja    |
    And I delete all rows
    And I append rows
      | mgrenze | mpreis |
      | 1       | 10     |
      | 50      | 8      |
    And I save the current editor

    Given I open an editor "PRGR2" from table "(Pricing):(Pricing)" with command "NEW" for record ""
    And I set fields
      | such   | PRGR2 |
      | gltvon | .     |
      | gltbis | +10   |
      | klpg   | 2     |
      | mgeab  | ja    |
    And I delete all rows
    And I append rows
      | mgrenze | mpreis |
      | 1       | 12     |
      | 50      | 11     |
    And I save the current editor

    Given I open an editor "PRGR3" from table "(Pricing):(Pricing)" with command "NEW" for record ""
    And I set fields
      | such   | PRGR3 |
      | gltvon | .     |
      | gltbis | +10   |
      | klpg   | 3     |
      | mgeab  | ja    |
    And I delete all rows
    And I append rows
      | mgrenze | mpreis |
      | 1       | 15     |
      | 50      | 12     |
    And I save the current editor

# Basisartikel neu anlegen, beim Speichern werden die Preis-/Rabattgruppen mit der Identnummer des Basisartikels gefuellt
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "NEW" for record ""
    And I set fields
      | such     | BASISPRG    |
      | namebspr | Preisgruppe |
    And I save the current editor

# im Basisartikel Preis/Rabattgruppen teilweise aendern, prgrabueb ist nicht gesetzt
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISPRG"
    Then field "prgrabueb" has value "nein"
    And I set fields
      | vprg  | PRGR1   |
      | vrab  | PRGR1   |
      | eprg  | EKLIEF1 |
      | erab  | EKLIEF1 |
      | eprg5 |         |
      | erab5 |         |
    And I save the current editor

# -----------------------------------------------------------------------------
  Scenario: 02 Artikel Neuanlage mit prgrabueb nicht angehakt, werden Preis/Rabattgruppen-Felder mit Identnummer Artikel gefuellt
# -----------------------------------------------------------------------------

# bei Artikel Neuanlage wird die Preisgruppe nicht aus dem Basisartikel vorbelegt, wenn prgrabueb dort nicht angehakt ist
    Given I open an editor "PRG-G01" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such         | PRG-G01                 |
      | namebspr     | Preisgruppe nicht Basis |
      | basisartikel | BASISPRG                |
      | index        | G01                     |
    Then field "prgrabueb" has value "nein"
    Then field "prgrabueb" is not modifiable
# Felder sind leer
    Then fields have values
      | vprg  |  |
      | vrab  |  |
      | prov  |  |
      | eprg  |  |
      | erab  |  |
      | eprg2 |  |
      | erab2 |  |
      | eprg3 |  |
      | erab3 |  |
      | eprg4 |  |
      | erab4 |  |
      | eprg5 |  |
      | erab5 |  |
    And I save the current editor

# Preis-/Rabattgruppen sind gefuellt mit Identnummer des Artikels und sind aenderbar, koennen geleert werden
    Given I open an editor "PRG-G01" from table "(Part):(Product)" with command "UPDATE" for record "PRG-G01"
    Then fields have values
      | vprg  | !PRG-G01^nummer |
      | vrab  | !PRG-G01^nummer |
      | prov  | !PRG-G01^nummer |
      | eprg  | !PRG-G01^nummer |
      | erab  | !PRG-G01^nummer |
      | eprg2 | !PRG-G01^nummer |
      | erab2 | !PRG-G01^nummer |
      | eprg3 | !PRG-G01^nummer |
      | erab3 | !PRG-G01^nummer |
      | eprg4 | !PRG-G01^nummer |
      | erab4 | !PRG-G01^nummer |
      | eprg5 | !PRG-G01^nummer |
      | erab5 | !PRG-G01^nummer |
    Then field "vprg" is modifiable
    Then field "vrab" is modifiable
    Then field "prov" is modifiable
    Then field "eprg" is modifiable
    Then field "erab" is modifiable
    Then field "eprg2" is modifiable
    Then field "erab2" is modifiable
    Then field "eprg3" is modifiable
    Then field "erab3" is modifiable
    Then field "eprg4" is modifiable
    Then field "erab4" is modifiable
    Then field "eprg5" is modifiable
    Then field "erab5" is modifiable
    And I set field "vprg" to "PRGR2"
    And I set field "vrab" to "PRGR2"
    And I set field "prov" to ""
    And I set field "eprg5" to ""
    And I set field "erab5" to ""
    And I save the current editor

# -----------------------------------------------------------------------------
  Scenario: 03 Artikel Neuanlage, Eintrag Basisartikel mit prgrabueb gesetzt, Uebernahme Preis/Rabattgruppen aus Basisartikel
# -----------------------------------------------------------------------------

# im Basisartikel prgrabueb setzen
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISPRG"
    And I set field "prgrabueb" to "ja"
    And I save the current editor

# bei Artikel Neuanlage wird die Preisgruppe aus dem Basisartikel vorbelegt, wenn prgrabueb dort angehakt ist
    Given I open an editor "PRG-G02" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | PRG-G02                      |
      | namebspr | Preisgruppe aus Basisartikel |
    And I set fields
      | basisartikel | BASISPRG |
      | index        | G02      |
    Then field "prgrabueb" has value "ja"
    Then field "prgrabueb" is not modifiable
# Werte aus Basisartikel
    Then fields have values
      | vprg  | !BASISPRG^vprg  |
      | vrab  | !BASISPRG^vrab  |
      | prov  | !BASISPRG^prov  |
      | eprg  | !BASISPRG^eprg  |
      | erab  | !BASISPRG^erab  |
      | eprg2 | !BASISPRG^eprg2 |
      | erab2 | !BASISPRG^erab2 |
      | eprg3 | !BASISPRG^eprg3 |
      | erab3 | !BASISPRG^erab3 |
      | eprg4 | !BASISPRG^eprg4 |
      | erab4 | !BASISPRG^erab4 |
      | eprg5 | !BASISPRG^eprg5 |
      | erab5 | !BASISPRG^erab5 |
    And I save the current editor

# noch mal pruefen dass nach Speichern die Preis/Rabattgruppen erhalten geblieben sind und nicht mit der Identnummer ueberschrieben wurden
    Given I open an editor "PRG-G02" from table "(Part):(Product)" with command "UPDATE" for record "PRG-G02"
# Werte aus Basisartikel
    Then fields have values
      | vprg  | !BASISPRG^vprg  |
      | vrab  | !BASISPRG^vrab  |
      | prov  | !BASISPRG^prov  |
      | eprg  | !BASISPRG^eprg  |
      | erab  | !BASISPRG^erab  |
      | eprg2 | !BASISPRG^eprg2 |
      | erab2 | !BASISPRG^erab2 |
      | eprg3 | !BASISPRG^eprg3 |
      | erab3 | !BASISPRG^erab3 |
      | eprg4 | !BASISPRG^eprg4 |
      | erab4 | !BASISPRG^erab4 |
      | eprg5 | !BASISPRG^eprg5 |
      | erab5 | !BASISPRG^erab5 |
# Felder sind schreibgeschuetzt, wenn prgrabueb angehakt ist
    Then field "prgrabueb" has value "ja"
    Then field "vprg" is not modifiable
    Then field "vrab" is not modifiable
    Then field "prov" is not modifiable
    Then field "eprg" is not modifiable
    Then field "erab" is not modifiable
    Then field "eprg2" is not modifiable
    Then field "erab2" is not modifiable
    Then field "eprg3" is not modifiable
    Then field "erab3" is not modifiable
    Then field "eprg4" is not modifiable
    Then field "erab4" is not modifiable
    Then field "eprg5" is not modifiable
    Then field "erab5" is not modifiable
    And I close the current editor

# -----------------------------------------------------------------------------
  Scenario: 04 Artikel Aendern, Basisartikel mit prgrabueb eintragen uebernimmt Preis/Rabattgruppen aus Basisartikel, weitere Aenderungen im Basisartikel ebenfalls
# -----------------------------------------------------------------------------

# bei Artikel Aendern werden Preis/Rabattgruppen aus dem Basisartikel uebernommen, wenn prgrabueb dort angehakt ist
    Given I open an editor "V3" from table "(Part):(Product)" with command "UPDATE" for record "V3"
    And I set fields
      | basisartikel | BASISPRG |
      | index        | G03      |
    Then field "prgrabueb" has value "ja"
    Then field "prgrabueb" is not modifiable
# Werte aus Basisartikel
    Then fields have values
      | vprg  | !BASISPRG^vprg  |
      | vrab  | !BASISPRG^vrab  |
      | prov  | !BASISPRG^prov  |
      | eprg  | !BASISPRG^eprg  |
      | erab  | !BASISPRG^erab  |
      | eprg2 | !BASISPRG^eprg2 |
      | erab2 | !BASISPRG^erab2 |
      | eprg3 | !BASISPRG^eprg3 |
      | erab3 | !BASISPRG^erab3 |
      | eprg4 | !BASISPRG^eprg4 |
      | erab4 | !BASISPRG^erab4 |
      | eprg5 | !BASISPRG^eprg5 |
      | erab5 | !BASISPRG^erab5 |
    And I save the current editor

# im Basisartikel die Preis/Rabattgruppe aendern
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISPRG"
    And I set field "vprg" to "PRGR2"
    And I set field "vrab" to "PRGR2"
    And I set field "prov" to ""
    And I save the current editor

# pruefen dass im Artikel mit prgrabueb angehakt, die Aenderung aus dem Basisartikel ebenfalls uebernommen wurde
    Given I open an editor "V3" from table "(Part):(Product)" with command "VIEW" for record "V3"
# Werte aus Basisartikel
    Then fields have values
      | vprg  | PRGR2           |
      | vrab  | PRGR2           |
      | prov  |                 |
      | eprg  | !BASISPRG^eprg  |
      | erab  | !BASISPRG^erab  |
      | eprg2 | !BASISPRG^eprg2 |
      | erab2 | !BASISPRG^erab2 |
      | eprg3 | !BASISPRG^eprg3 |
      | erab3 | !BASISPRG^erab3 |
      | eprg4 | !BASISPRG^eprg4 |
      | erab4 | !BASISPRG^erab4 |
      | eprg5 | !BASISPRG^eprg5 |
      | erab5 | !BASISPRG^erab5 |
    And I close the current editor

# Basisartikel wieder entfernen
    Given I open an editor "V3" from table "(Part):(Product)" with command "UPDATE" for record "V3"
    And I set field "basisartikel" to ""
    And I set field "index" to ""
    And I save the current editor

# -----------------------------------------------------------------------------
  Scenario: 05 Basisartikel Aendern prgrabueb auf nein, Aenderung Preis/Rabattgruppen aus Basisartikel werden nicht mehr uebernommen
# -----------------------------------------------------------------------------

# Basisartikel aendern auf prgrabueb nein
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISPRG"
    And I set field "prgrabueb" to "nein"
    And I save the current editor

# im Basisartikel die Preis/Rabattgruppe aendern
    Given I open an editor "BASISPRG_AENDERN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISPRG"
    And I set field "vprg" to "PRGR3"
    And I set field "vrab" to "PRGR3"
    And I set field "prov" to "PRGR3"
    And I save the current editor

# pruefen im Artikel dass Aenderung aus dem Basisartikel nicht mehr uebernommen wurde, Felder wieder schreibbar
    Given I open an editor "PRG-G01" from table "(Part):(Product)" with command "UPDATE" for record "PRG-G01"
    Then field "prgrabueb" has value "nein"
# Werte aus Basisartikel VOR der Aenderung
    Then fields have values
      | vprg  | PRGR2           |
      | vrab  | PRGR2           |
      | prov  |                 |
      | eprg  | !BASISPRG^eprg  |
      | erab  | !BASISPRG^erab  |
      | eprg2 | !BASISPRG^eprg2 |
      | erab2 | !BASISPRG^erab2 |
      | eprg3 | !BASISPRG^eprg3 |
      | erab3 | !BASISPRG^erab3 |
      | eprg4 | !BASISPRG^eprg4 |
      | erab4 | !BASISPRG^erab4 |
      | eprg5 | !BASISPRG^eprg5 |
      | erab5 | !BASISPRG^erab5 |
    Then field "vprg" is modifiable
    Then field "vrab" is modifiable
    Then field "prov" is modifiable
    Then field "eprg" is modifiable
    Then field "erab" is modifiable
    Then field "eprg2" is modifiable
    Then field "erab2" is modifiable
    Then field "eprg3" is modifiable
    Then field "erab3" is modifiable
    Then field "eprg4" is modifiable
    Then field "erab4" is modifiable
    Then field "eprg5" is modifiable
    Then field "erab5" is modifiable
    And I close the current editor

# -----------------------------------------------------------------------------
  Scenario: 06 Artikel Aendern und Basisartikel parallel aendern, Artikel muss zuerst gespeichert werden, Aenderung aus Basisartikel werden danach uebernommen
# -----------------------------------------------------------------------------

# Basisartikel hat prgrabueb auf nein
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISPRG"
    Then field "prgrabueb" has value "nein"
    And I close the current editor

    Given I'm logged in with password "adm"

# Artikel Neuanlage mit Basisartikel ohne prgrabueb
    Given I open an editor "PRG-G03" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such         | PRG-G03                      |
      | namebspr     | Preisgruppe aus Basisartikel |
      | basisartikel | BASISPRG                     |
      | index        | G03                          |
      | vprg         | VKAUSARTIKEL                 |
      | vrab         | VKAUSARTIKEL                 |
      | prov         | VKAUSARTIKEL                 |
      | eprg         | EKAUSARTIKEL                 |
      | erab         | EKAUSARTIKEL                 |
    And I save the current editor

# Artikel Aendern, prgrabueb ist noch auf nein
    Given I open an editor "PRG-G03" from table "(Part):(Product)" with command "UPDATE" for record "PRG-G03"
    Then field "prgrabueb" has value "nein"
    And I set fields
      | prov  |        |
      | eprg2 | LIEF02 |
      | erab2 | LIEF02 |
# Editor offen lassen

    Given I'm logged in with password "sy"

# Basisartikel prgrabueb setzen und Preis/Rabattgruppen anpassen
#And I switch the current editor to editor "BASISPRG" with command "UPDATE"
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISPRG"
    And I set fields
      | prgrabueb | ja     |
      | vprg      | PRGNEU |
      | vrab      | PRGNEU |
      | prov      | PRGNEU |
      | eprg      | PRGNEU |
      | erab      | PRGNEU |
      | eprg2     | PRGNEU |
      | erab2     | PRGNEU |
# Editor offen lassen

    Given I'm logged in with password "adm"

# zurueck zum bereits geoeffneten Editor und den Artikel speichern
    And I switch the current editor to editor "PRG-G03" with command "UPDATE"
    And I save the current editor

    Given I'm logged in with password "sy"

# zurueck zum bereits geoeffneten Editor und den Basisartikel speichern
    And I switch the current editor to editor "BASISPRG" with command "UPDATE"
    And I save the current editor

# pruefen dass beim Speichern die neuen Werte aus dem Basisartikel uebernommen wurden
    Given I open an editor "PRG-G03" from table "(Part):(Product)" with command "VIEW" for record "PRG-G03"
    Then field "prgrabueb" has value "ja"
# neue Werte aus dem Basisartikel wurden uebernommen
    Then fields have values
      | vprg  | PRGNEU          |
      | vrab  | PRGNEU          |
      | prov  | PRGNEU          |
      | eprg  | PRGNEU          |
      | erab  | PRGNEU          |
      | eprg2 | PRGNEU          |
      | erab2 | PRGNEU          |
      | eprg3 | !BASISPRG^eprg3 |
      | erab3 | !BASISPRG^erab3 |
      | eprg4 | !BASISPRG^eprg4 |
      | erab4 | !BASISPRG^erab4 |
      | eprg5 | !BASISPRG^eprg5 |
      | erab5 | !BASISPRG^erab5 |
    And I save the current editor

# -----------------------------------------------------------------------------
  Scenario: 07 prgrabueb im Basisartikel anhaken hat Preis/Rabattgruppen in Artikel zurueckgeschrieben
# -----------------------------------------------------------------------------

# prgrabueb wurde im vorherigen Szenario gesetzt, dadurch wurde auch Artikel PRG-G01 geaendert
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "VIEW" for record "BASISPRG"
    Then field "prgrabueb" has value "ja"
    Then table has values
      | tversion | tindex | tstdvers |
      | PRG-G01  | G01    | ja       |
      | PRG-G02  | G02    | nein     |
      | PRG-G03  | G03    | nein     |
    And I close the current editor

# Preis/Rabattgruppen aus dem Basisartikel werden in den Artikel zurueckgeschrieben, wenn prgrabueb angehakt wird
    Given I open an editor "PRG-G01" from table "(Part):(Product)" with command "UPDATE" for record "PRG-G01"
    Then field "prgrabueb" has value "ja"
# Werte aus Basisartikel
    Then fields have values
      | vprg  | !BASISPRG^vprg  |
      | vrab  | !BASISPRG^vrab  |
      | prov  | !BASISPRG^prov  |
      | eprg  | !BASISPRG^eprg  |
      | erab  | !BASISPRG^erab  |
      | eprg2 | !BASISPRG^eprg2 |
      | erab2 | !BASISPRG^erab2 |
      | eprg3 | !BASISPRG^eprg3 |
      | erab3 | !BASISPRG^erab3 |
      | eprg4 | !BASISPRG^eprg4 |
      | erab4 | !BASISPRG^erab4 |
      | eprg5 | !BASISPRG^eprg5 |
      | erab5 | !BASISPRG^erab5 |
# Felder sind schreibgeschuetzt, wenn prgrabueb angehakt ist
    Then field "vprg" is not modifiable
    Then field "vrab" is not modifiable
    Then field "prov" is not modifiable
    Then field "eprg" is not modifiable
    Then field "erab" is not modifiable
    Then field "eprg2" is not modifiable
    Then field "erab2" is not modifiable
    Then field "eprg3" is not modifiable
    Then field "erab3" is not modifiable
    Then field "eprg4" is not modifiable
    Then field "erab4" is not modifiable
    Then field "eprg5" is not modifiable
    Then field "erab5" is not modifiable
    And I close the current editor

# -----------------------------------------------------------------------------
  Scenario: 08 Beim Kopieren einer Version bleibt Kenner prgrabueb gesetzt und Werte aus Basisartikel uebernommen
# -----------------------------------------------------------------------------

# Artikel kopieren durch den Button "Neue Version anlegen"
    Given I open an editor "PRG-G03" from table "(Part):(Product)" with command "VIEW" for record "PRG-G03"
    And I press button "neuevers" to open a subeditor for "Version"
    Then fields have values
      | basisartikel | BASISPRG |
      | prgrabueb    | ja       |
    And I set fields
      | such  | PRG-G04 |
      | index | G04     |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

# Editor oeffnen um Zugriff auf die Felder zu haben fuer den Verweis im anderen Editor
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "VIEW" for record "BASISPRG"
    And I close the current editor

# pruefen dass die Werte der Preis/Rabattgruppen aus dem Basisartikel uebernommen wurden
    Given I open an editor "PRG-G04" from table "(Part):(Product)" with command "UPDATE" for record "PRG-G04"
    Then fields have values
      | vprg  | !BASISPRG^vprg  |
      | vrab  | !BASISPRG^vrab  |
      | prov  | !BASISPRG^prov  |
      | eprg  | !BASISPRG^eprg  |
      | erab  | !BASISPRG^erab  |
      | eprg2 | !BASISPRG^eprg2 |
      | erab2 | !BASISPRG^erab2 |
      | eprg3 | !BASISPRG^eprg3 |
      | erab3 | !BASISPRG^erab3 |
      | eprg4 | !BASISPRG^eprg4 |
      | erab4 | !BASISPRG^erab4 |
      | eprg5 | !BASISPRG^eprg5 |
      | erab5 | !BASISPRG^erab5 |
# Felder sind schreibgeschuetzt, wenn prgrabueb angehakt ist
    Then field "vprg" is not modifiable
    Then field "vrab" is not modifiable
    Then field "prov" is not modifiable
    Then field "eprg" is not modifiable
    Then field "erab" is not modifiable
    Then field "eprg2" is not modifiable
    Then field "erab2" is not modifiable
    Then field "eprg3" is not modifiable
    Then field "erab3" is not modifiable
    Then field "eprg4" is not modifiable
    Then field "erab4" is not modifiable
    Then field "eprg5" is not modifiable
    Then field "erab5" is not modifiable
    And I close the current editor


    Scenario: 09A ALGE - Preis-/Rabattgruppen werden auch in Lagergruppeneigenschaften uebernommen, wenn diese nachtraeglich angelegt werden

    # Editor oeffnen um Zugriff auf die Felder zu haben fuer den Verweis im anderen Editor
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "VIEW" for record "BASISPRG"
    And I close the current editor

    # Lagergruppeneigenschaften eintragen und pruefen, dass die Preis/Rabattgruppen aus dem bereits vorhandenen Basisartikel uebernommen wurden
    Given I open an editor "PRG-G04" from table "(Part):(Product)" with command "UPDATE" for record "PRG-G04"
    And I press button "alge" to open a subeditor for "Lgruppen"
    And I delete all rows
    And I append rows
        | lgruppe | bsart       | umllg     |
        | BERLIN  | Umlagern    | KARLSRUHE |
    Then table has values
        | eprg            | erab              |
        | !BASISPRG^eprg  | !BASISPRG^erab    |
    Then field "eprg" is not modifiable in row 1
    Then field "erab" is not modifiable in row 1
    Then field "eprg2" is not modifiable in row 1
    Then field "erab2" is not modifiable in row 1
    Then field "eprg3" is not modifiable in row 1
    Then field "erab3" is not modifiable in row 1
    Then field "eprg4" is not modifiable in row 1
    Then field "erab4" is not modifiable in row 1
    Then field "eprg5" is not modifiable in row 1
    Then field "erab5" is not modifiable in row 1
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor


Scenario: 09B ALGE - Preis-/Rabattgruppen werden auch in bereits vorhandene Lagergruppeneigenschaften uebernommen, wenn Basisartikel spaeter eingetragen wird

    # Editor oeffnen um Zugriff auf die Felder zu haben fuer den Verweis im anderen Editor
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "VIEW" for record "BASISPRG"
    And I close the current editor

    # in Artikel ohne Basisartikel Lagergruppeneigenschaften eintragen
    Given I open an editor "EINK" from table "(Part):(Product)" with command "UPDATE" for record "EINK"
    And I press button "alge" to open a subeditor for "Lgruppen"
    And I delete all rows
    And I append rows
        | lgruppe | bsart       | umllg     |
        | BERLIN  | Umlagern    | KARLSRUHE |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    # Basisartikel eintragen, in den bereits vorhandenen Lagergruppeneigenschaften wurde die Preis/Rabattgruppen aus dem Basisartikel uebernommen
    Given I open an editor "EINK" from table "(Part):(Product)" with command "UPDATE" for record "EINK"
    And I set fields
        | basisartikel | BASISPRG |
        | index        | G05      |
    And I press button "alge" to open a subeditor for "Lgruppen"
    Then table has values
        | eprg            | erab              |
        | !BASISPRG^eprg  | !BASISPRG^erab    |
    Then field "eprg" is not modifiable in row 1
    Then field "erab" is not modifiable in row 1
    Then field "eprg2" is not modifiable in row 1
    Then field "erab2" is not modifiable in row 1
    Then field "eprg3" is not modifiable in row 1
    Then field "erab3" is not modifiable in row 1
    Then field "eprg4" is not modifiable in row 1
    Then field "erab4" is not modifiable in row 1
    Then field "eprg5" is not modifiable in row 1
    Then field "erab5" is not modifiable in row 1
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor


Scenario: 09C ALGE - Preis-/Rabattgruppen werden auch in Lagergruppeneigenschaften uebernommen, bei Neuanlage Artikel

    # Editor oeffnen um Zugriff auf die Felder zu haben fuer den Verweis im anderen Editor
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "VIEW" for record "BASISPRG"
    And I close the current editor

    # Artikel neu anlegen und erst ALGE anlegen, dann Basisartikel eintragen, dann speichern
    Given I open an editor "PRG-G06" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
        | such         | PRG-G06                  |
        | namebspr     | ALGE dann Basisartikel   |
    And I press button "alge" to open a subeditor for "Lgruppen"
    And I delete all rows
    And I append rows
        | lgruppe | bsart       | umllg     |
        | BERLIN  | Umlagern    | KARLSRUHE |
    And I save the current subeditor to switch back to the parent editor
    And I set fields
        | basisartikel | BASISPRG             |
        | index        | G06                  |
    And I press button "alge" to open a subeditor for "Lgruppen"
    Then table has values
        | eprg            | erab              |
        | !BASISPRG^eprg  | !BASISPRG^erab    |
    Then field "eprg" is not modifiable in row 1
    Then field "erab" is not modifiable in row 1
    Then field "eprg2" is not modifiable in row 1
    Then field "erab2" is not modifiable in row 1
    Then field "eprg3" is not modifiable in row 1
    Then field "erab3" is not modifiable in row 1
    Then field "eprg4" is not modifiable in row 1
    Then field "erab4" is not modifiable in row 1
    Then field "eprg5" is not modifiable in row 1
    Then field "erab5" is not modifiable in row 1
    And I close the current subeditor to switch back to the parent editor
    And I save the current editor

Scenario: 09D ALGE - Preis-/Rabattgruppen werden auch in Lagergruppeneigenschaften uebernommen, bei spaetere Aenderung im Basisartikel
    # Preis-/Rabattgruppe im Basisartikel aendern
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISPRG"
    And I set fields
        | eprg3     | PRGGANZNEU  |
        | erab3     | PRGGANZNEU  |
    And I save the current editor

    # neue Preis-/Rabattgruppe wurde in die Lagergruppeneigenschaften uebernommen
    Given I open an editor "PRG-G06" from table "(Part):(Product)" with command "VIEW" for record "PRG-G06"
    And I press button "alge" to open a subeditor for "Lgruppen"
    Then field "eprg3" has value "PRGGANZNEU" in row 1
    Then field "erab3" has value "PRGGANZNEU" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


Scenario: 09E ALGE - Preis-/Rabattgruppen werden auch in Lagergruppeneigenschaften uebernommen, bei Neuanlage Artikel

    # Editor oeffnen um Zugriff auf die Felder zu haben fuer den Verweis im anderen Editor
    Given I open an editor "BASISPRG" from table "(Part):(BaseProduct)" with command "VIEW" for record "BASISPRG"
    And I close the current editor

    # Artikel neu anlegen, Basisartikel eintragen und danach ALGE anlegen, dann speichern
    Given I open an editor "PRG-G07" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
        | such         | PRG-G07                  |
        | namebspr     | Basisartikel dann ALGE   |
        | basisartikel | BASISPRG                 |
        | index        | G07                      |
    And I press button "alge" to open a subeditor for "Lgruppen"
    And I delete all rows
    And I append rows
        | lgruppe | bsart       | umllg     |
        | BERLIN  | Umlagern    | KARLSRUHE |
    Then table has values
        | eprg            | erab              |
        | !BASISPRG^eprg  | !BASISPRG^erab    |
    Then field "eprg" is not modifiable in row 1
    Then field "erab" is not modifiable in row 1
    Then field "eprg2" is not modifiable in row 1
    Then field "erab2" is not modifiable in row 1
    Then field "eprg3" is not modifiable in row 1
    Then field "erab3" is not modifiable in row 1
    Then field "eprg4" is not modifiable in row 1
    Then field "erab4" is not modifiable in row 1
    Then field "eprg5" is not modifiable in row 1
    Then field "erab5" is not modifiable in row 1
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor
