# *****************************************************************************
#  Name           : kundenanlieferung_vkz.feature
#  Autor          : carue
#  Verantwortlich : carue
#  Kontrolle      : ak
#  Funktion       : Testet Aktualisierung der Verkehrszahlen bei Kundenanlieferung
#                   und Storno der Kundenanlieferung.
#                   Mit und ohne Setzen von neginvkz.
#
# *****************************************************************************
@persistent
Feature: kundenanlieferung_vkz.feature
Background:
Given I set the fake date to "02.01.1995"


Scenario: 00 Stammdaten anlegen (Konsilager, Artikel)
# Konsilager, Konsilagergruppe anlegen
Given I open an editor "Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSILG"
And I set field "such" to "KONSILG"
And I set field "zkonsilg" to "Ja"
And I save the current editor

Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSILAGER"
And I set field "such" to "KONSILAGER"
And I set field "lgruppe" to "KONSILG"
And I save the current editor

# Konsilagerplatz anlegen
Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KONSILP"
And I set field "such" to "KONSILP"
And I set field "lager" to "KONSILAGER"
And I save the current editor

# Lagergruppe mit Lagerplatz: Platz fuer Kundenanlieferung (Konsilager) eintragen
Given I open an editor "LagergruppeKA" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And I set field "vkkundenanlieferung" to "KONSILP"
And I save the current editor


# Neuen Artikel fuer Test anlegen
Given I open an editor "SCHNULLI" from table "(Part):(Product)" with command "STORE" for record "SCHNULLI"
And I set field "such" to "SCHNULLI"
# Umsatzzaehler pruefen - bei Neuanlage sind alle 0
Then field "pzm" has value "0"
Then field "jzu" has value "0"
Then field "pam" has value "0"
Then field "jab" has value "0"
And I save the current editor


Scenario: 01a Kundenanlieferung neu anlegen - ohne Umdrehen der Verkehrszahlen
Given I open an editor "Kdanl_01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "1kdanl"
And I set field "such" to "KANL_01"
And I set field "lsart" to "Kundenanlieferung"
And I set field "ueb" to "ja"
And I append rows
    | artikel  | mge | preis | platz   |
    | SCHNULLI | -10 | 5.00  | KONSILP |
Then field "lsart" has value "Kundenanlieferung"
# Schreibschutz testen - Feld aenderbar bei Kundenanlieferung
Then field "neginvkz" is modifiable in row 1
Then field "neginvkz" has value "nein" in row 1
And I save the current editor

# Verkehrszahlen fuer Artikel pruefen - Zugangszaehler erhoehen
Given I open an editor "SCHNULLI" from table "(Part):(Product)" with command "VIEW" for record from editor "SCHNULLI"
Then field "pzm" has value "10"
Then field "jzu" has value "10"
Then field "pam" has value "0"
Then field "jab" has value "0"
And I close the current editor

# Journaleintrag : Zugang Kundenanlieferung, positive Menge, vkzakt angehakt, neginvkz nicht
Given I open an editor "JournalKdanl_01" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SCHNULLI;detursache==Kundenanlieferung;such==L1KDANL;"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Kundenanlieferung"
Then field "gmge" has value "10"
Then field "mge" has value "10"
Then field "vkzakt" has value "ja"
Then field "neginvkz" has value "nein"
And I close the current editor

# Lagermenge Konsiplatz fuer Artikel Schnulli
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "SCHNULLI" on StorageLocation "KONSILP"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id               | orig^id             | verfdat    | bewmge | bewlj^id            | beworig^id          | bewdat     |
    | 10     | Stück  | !JournalKdanl_01^id | !JournalKdanl_01^id | 02.01.1995 | 10     | !JournalKdanl_01^id | !JournalKdanl_01^id | 02.01.1995 |
And I close the current editor


Scenario: 01b  Kundenanlieferung stornieren - ohne Umdrehen der Verkehrszahlen
Given I open an editor "SKdanl_01" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "Kdanl_01"
And I set field "nummer" to "1skdanl"
Then field "lsart" has value "Storno-Kundenanlieferung"
Then table has values
    | artikel  | mge | preis | platz   | neginvkz |
    | SCHNULLI | 10  | 5.00  | KONSILP | nein     |
# Schreibschutz testen - Feld nicht aenderbar bei Storno-Kundenanlieferung
Then field "neginvkz" is not modifiable in row 1
And I save the current editor

# Verkehrszahlen fuer Artikel pruefen - Zugangszaehler wieder reduzieren
Given I open an editor "SCHNULLI" from table "(Part):(Product)" with command "VIEW" for record from editor "SCHNULLI"
Then field "pzm" has value "0"
Then field "jzu" has value "0"
Then field "pam" has value "0"
Then field "jab" has value "0"
And I close the current editor

# Journaleintrag : Storno-Kundenanlieferung, Zugang, negative Menge, vkzakt angehakt, neginvkz nicht
Given I open an editor "JournalSKdanl_01" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SCHNULLI;detursache==Storno-Kundenanlieferung;such==L1SKDANL;"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Storno-Kundenanlieferung"
Then field "gmge" has value "-10"
Then field "mge" has value "-10"
Then field "vkzakt" has value "ja"
Then field "neginvkz" has value "nein"
Then field "stornolj^id" has value equal to field "id" from editor "JournalKdanl_01"
And I close the current editor

Given I open an editor "JournalKdanl_01" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalKdanl_01"
Then field "storniert" has value "ja"
And I close the current editor

# Lagermenge Konsiplatz fuer Artikel Schnulli
Given I query StorageQuantity for Product "SCHNULLI" on StorageLocation "KONSILP"
Then StorageQuantity is zero
And I close the current editor


Scenario: 02a Kundenanlieferung neu anlegen - mit Umdrehen der Verkehrszahlen
Given I open an editor "Kdanl_02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "2kdanl"
And I set field "such" to "KANL_02"
And I set field "lsart" to "Kundenanlieferung"
And I set field "ueb" to "ja"
And I append rows
    | artikel  | mge | preis | platz   | neginvkz |
    | SCHNULLI | -10 | 5.00  | KONSILP | ja       |
Then field "lsart" has value "Kundenanlieferung"
# Schreibschutz testen - Feld aenderbar bei Kundenanlieferung
Then field "neginvkz" is modifiable in row 1
Then field "neginvkz" has value "ja" in row 1
And I save the current editor

# Verkehrszahlen fuer Artikel pruefen - Abgangszaehler reduzieren
Given I open an editor "SCHNULLI" from table "(Part):(Product)" with command "VIEW" for record from editor "SCHNULLI"
Then field "pzm" has value "0"
Then field "jzu" has value "0"
Then field "pam" has value "-10"
Then field "jab" has value "-10"
And I close the current editor

# Journaleintrag : Zugang Kundenanlieferung, positive Menge, vkzakt und neginvkz angehakt
Given I open an editor "JournalKdanl_02" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SCHNULLI;detursache==Kundenanlieferung;such==L2KDANL;"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Kundenanlieferung"
Then field "gmge" has value "10"
Then field "mge" has value "10"
Then field "vkzakt" has value "ja"
Then field "neginvkz" has value "ja"
And I close the current editor

# Lagermenge Konsiplatz fuer Artikel Schnulli
Given I query "gebmge,gebeinh,lj^id,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat" from StorageQuantity for Product "SCHNULLI" on StorageLocation "KONSILP"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id               | orig^id             | verfdat    | bewmge | bewlj^id            | beworig^id          | bewdat     |
    | 10     | Stück  | !JournalKdanl_02^id | !JournalKdanl_02^id | 02.01.1995 | 10     | !JournalKdanl_02^id | !JournalKdanl_02^id | 02.01.1995 |
And I close the current editor


Scenario: 02b  Kundenanlieferung stornieren - mit Umdrehen der Verkehrszahlen
Given I open an editor "SKdanl_02" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "Kdanl_02"
And I set field "nummer" to "2skdanl"
Then field "lsart" has value "Storno-Kundenanlieferung"
Then field "neginvkz" is not modifiable in row 1
Then table has values
    | artikel  | mge | preis | platz   | neginvkz |
    | SCHNULLI | 10  | 5.00  | KONSILP | ja       |
# Schreibschutz testen - Feld nicht aenderbar bei Storno-Kundenanlieferung
Then field "neginvkz" is not modifiable in row 1
And I save the current editor

# Verkehrszahlen fuer Artikel pruefen - Abgangszaehler wieder erhoehen
Given I open an editor "SCHNULLI" from table "(Part):(Product)" with command "VIEW" for record from editor "SCHNULLI"
Then field "pzm" has value "0"
Then field "jzu" has value "0"
Then field "pam" has value "0"
Then field "jab" has value "0"
And I close the current editor

# Journaleintrag : Storno-Kundenanlieferung, Zugang, negative Menge, vkzakt angehakt, neginvkz nicht
Given I open an editor "JournalSKdanl_02" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SCHNULLI;detursache==Storno-Kundenanlieferung;such==L2SKDANL;"
Then field "buarta" has value "Zugang"
Then field "detursache" has value "Storno-Kundenanlieferung"
Then field "gmge" has value "-10"
Then field "mge" has value "-10"
Then field "vkzakt" has value "ja"
Then field "neginvkz" has value "ja"
Then field "stornolj^id" has value equal to field "id" from editor "JournalKdanl_02"
And I close the current editor

Given I open an editor "JournalKdanl_02" from table "(Journal):(Journal)" with command "VIEW" for record from editor "JournalKdanl_02"
Then field "storniert" has value "ja"
And I close the current editor

# Lagermenge Konsiplatz fuer Artikel Schnulli
Given I query StorageQuantity for Product "SCHNULLI" on StorageLocation "KONSILP"
Then StorageQuantity is zero
And I close the current editor


Scenario: 03 Schreibschutz bei "normalem" Lieferschein testen
Given I open an editor "Lieferschein_03" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "3ls"
And I set field "such" to "LS_03"
And I append rows
    | artikel  | mge | preis | platz   |
    | SCHNULLI | 10  | 5.00  | KONSILP |
Then field "lsart" has value "Lieferschein"
# Schreibschutz testen - Feld nicht aenderbar bei normalem Lieferschein
Then field "neginvkz" is not modifiable in row 1
Then field "neginvkz" has value "nein" in row 1
And I close the current editor



