@persistent
Feature: ein-auslaufsteuerung.feature

# **********************************************************************************
#  Name             : ein-auslaufsteuerung.feature
#  Autor            : lbettendorf
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet Funktionen in der Ein-/Auslaufsteuerung
#  ref              : ref_ein-auslaufsteuerung_cu
#  Stammdaten       : basis_stammdaten.feature
#
# **********************************************************************************

Background:
And I set the fake date to "02.01.95"


Scenario: 01 Nachfolgeartikel wird als Beistellung zur Lohnfertigung doppelt aufgeloest
# FDA-4064

# Einplanung von Auslaufartikeln und Nachfolgeartikeln auf "Gemischt einplanen" setzen
Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "UPDATE" for record "1"
And I set field "auslaufarteinplan" to "Gemischt einplanen"
And I save the current editor

# Datum der Verwendung im Auslaufartikel weiter zurueck setzen
Given I open an editor "EK-AUSLAUF" from table "(Part):(Product)" with command "STORE" for record "EK-AUSLAUF"
And I set field "lbsdatum" to "-50"
And I save the current editor

Given I open an editor "L2OHNFERT" from table "(Part):(Product)" with command "STORE" for record "L2OHNFERT"
And I set fields
    | such      | L2OHNFERT                     |
    | namebspr  | Lohnfertigung zu LOHNF_NACHF  |
    | bsart     | Lohnfertigung                 |
And I save the current editor

Given I open an editor "BG-NACHFOLGER" from table "(Part):(Product)" with command "STORE" for record "BG-NACHFOLGER"
And I set fields
    | such      | BG-NACHFOLGER                 |
    | bsart     | Eigenfertigung                |
And I delete all rows
And I append rows
    | elex          | elanzahl      | lfbeist       |
    | EK-AUSLAUF    | 1             | ja            |
    | L2OHNFERT     | 1             | !dontChange   |
    | A AG-LOHN1    | !dontChange   | !dontChange   |
And I save the current editor

# Lagerbestand EK-AUSLAUF und EK-NACHFOLGER
Given I post a receipt via ManualStockAdjustment for Product "EK-AUSLAUF" and quantity "50" on StorageLocation "F1" with document "Zu1"
Given I post a receipt via ManualStockAdjustment for Product "EK-NACHFOLGER" and quantity "50" on StorageLocation "F1" with document "Zu1"

# Auftrag und Dispo
Given I create a SalesOrder "Auftrag1" for Customer "KUNDE1" with Product "BG-NACHFOLGER" and quantity "100"
And I run Scheduling

Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag1"
Then table has values
    | elem              | rmge  | vart              |
    | BG-NACHFOLGER     | 100   | Eigenfertigung    |
    | A AG-LOHN1        | 100   | Eigenfertigung    |
    | L2OHNFERT         | 100   | Lohnfertigung     |
    | EK-NACHFOLGER     | 50    | Lager             |
    | EK-AUSLAUF        | 50    | Lager             |
And I close the current editor

# Auftrag stornieren
Given I switch the current editor to editor "Auftrag1" with command "UPDATE"
# 191: Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor




Scenario: 02 Restmenge in der Materialentnahme darf für ein Auslaufteil, das noch beschafft werden darf, erhöht werden.
# FDA-6526

# Auslaufteil mit:
Given I open an editor "EK-AUSLAUF" from table "(Part):(Product)" with command "STORE" for record "EK-AUSLAUF"
And I set field "lbsdatum" to "+30"
And I set field "efrist" to "10"
And I press button "kalkul" to open a subeditor for "kalkulieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Auftrag und Dispo
Given I create a SalesOrder "Auftrag1" for Customer "KUNDE1" with Product "BG-EIN_AUSLAUF" and quantity "110"
And I run Scheduling

# Fertigungsvorschlag
Given I open an editor "FV_01" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | BG-EIN_AUSLAUF|
    | lgruppe |               |
And I press button "ladetab"
And I modify table
    | !row |  mfreig |
    | 1    |  ja     |
And I set field "bisuch" to "F101008_" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I set field "manbu" to "ja" in row 2
And I save the current subeditor to switch back to the parent editor
And I press button "freig" to open a subeditor for "BA_freigeben"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# FBU mit Mengenvorschlag und Angabe Kopfcharge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | 1001       |
    | mgr           | 101        |
And I press button "stllad"
And I set field "nlimge" to "250" in row 1
And I save the current editor


Scenario: 03 Mehrstufige Auslauf/Nachfolger-Kette wird in AFL auf Auslaufteil und letzten Nachfolger reduziert und mit anschliessender AFL-Editierung

Given I set the fake date to "02.01.95"

Given I open an editor "ART_NACHF_3" from table "(Part):(Product)" with command "STORE" for record "ART_NACHF_3"
And I set fields
    | such     | ART_NACHF_3 |
    | namebspr | Nachfolger 3 |
    | bsart    | Fremdbeschaffung |
And I save the current editor

Given I open an editor "ART_NACHF_2" from table "(Part):(Product)" with command "STORE" for record "ART_NACHF_2"
And I set fields
    | such             | ART_NACHF_2 |
    | namebspr         | Nachfolger 2 |
    | bsart            | Fremdbeschaffung |
    | nachfolgeartikel | ART_NACHF_3 |
    | lbsdatum         | 31.12.93 |
    | lverwdatum       | 31.12.93 |
    | vgltermin        | Anfangstermin |
And I save the current editor

Given I open an editor "ART_NACHF_1" from table "(Part):(Product)" with command "STORE" for record "ART_NACHF_1"
And I set fields
    | such             | ART_NACHF_1 |
    | namebspr         | Nachfolger 1 |
    | bsart            | Fremdbeschaffung |
And I respond with answer "ja" to the dialog with id "10679"
And I set field "nachfolgeartikel" to "ART_NACHF_2"
And I set fields
    | lbsdatum         | 31.12.92 |
    | lverwdatum       | 31.12.92 |
    | vgltermin        | Anfangstermin |
And I save the current editor

Given I open an editor "ART_AUSLAUF_0" from table "(Part):(Product)" with command "STORE" for record "ART_AUSLAUF_0"
And I set fields
    | such             | ART_AUSLAUF_0 |
    | namebspr         | Auslaufteil 0 |
    | bsart            | Fremdbeschaffung |
And I respond with answer "ja" to the dialog with id "10679"
And I set field "nachfolgeartikel" to "ART_NACHF_1"
And I set fields
    | lbsdatum         | 31.12.92 |
    | lverwdatum       | 31.12.96 |
    | vgltermin        | Anfangstermin |
And I save the current editor

Given I open an editor "ART_EF_MIN20" from table "(Part):(Product)" with command "STORE" for record "ART_EF_MIN20"
And I set fields
    | such     | ART_EF_MIN20 |
    | namebspr | EF mit Auslaufkette |
    | bsart    | Eigenfertigung |
    | dispoa   | bedarfsbezogen |
    | mindest  | 20 |
And I delete all rows
And I append rows
    | elex          | anzahl |
    | ART_AUSLAUF_0 |   1    |
    | A AG1         |   1    |
And I save the current editor

And I run Scheduling

Given I open an editor "FV_AUSLAUFKETTE" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,artikel==ART_EF_MIN20;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row | elem          |
    | 1    | ART_AUSLAUF_0 |
    | 2    | ART_NACHF_3   |
    | 3    | A AG1         |
And I append rows
    | elem          | anzahl |
    | ART_AUSLAUF_0 |   1    |
Then table has values
    | !row | elem          |
    | 1    | ART_AUSLAUF_0 |
    | 2    | ART_NACHF_3   |
    | 3    | A AG1         |
    | 4    | ART_AUSLAUF_0 |
    | 5    | ART_NACHF_3   |
Then field "vorgnachfkenn" is not empty in row 1
Then field "vorgnachfkenn" is not empty in row 2
Then field "vorgnachfkenn" is empty in row 3
Then field "vorgnachfkenn" is not empty in row 4
Then field "vorgnachfkenn" is not empty in row 5
And I save the current editor
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 04 Nach Lieferschein-Storno bleibt der Artikel in Reservierung gleich zur Auftragsposition

Given I set the fake date to "02.01.95"

# Nachfolger anlegen
Given I open an editor "NACHF-STORNO" from table "(Part):(Product)" with command "STORE" for record "NACHF-STORNO"
And I set fields
    | such      | NACHF-STORNO                  |
    | namebspr  | Nachfolger Lieferscheinstorno |
    | bsart     | Fremdbeschaffung              |
And I save the current editor

# Auslaufteil anlegen: nicht mehr verwendbar und nicht mehr beschaffbar
Given I open an editor "AUSL-STORNO" from table "(Part):(Product)" with command "STORE" for record "AUSL-STORNO"
And I set fields
    | such             | AUSL-STORNO                |
    | namebspr         | Auslauf Lieferscheinstorno |
    | bsart            | Fremdbeschaffung           |
    | nachfolgeartikel | NACHF-STORNO               |
    | lbsdatum         | 31.12.94                   |
    | lverwdatum       | 31.12.94                   |
    | vgltermin        | Anfangstermin              |
    | efrist           | 0                          |
And I save the current editor

# Auftrag mit Auslaufteil anlegen
Given I create a SalesOrder "Auftrag2" for Customer "KUNDE1" with Product "AUSL-STORNO" and quantity "10"
# Auftrag liefern und Lieferschein stornieren
And I deliver the SalesOrder "Auftrag2" with PackingSlip "LS-STORNO"

# Disponieren
And I run Scheduling

And I reverse the PackingSlip "LS-STORNO"

# Neu disponieren
And I run Scheduling

# Artikel in Auftragsposition und Reservierung muessen gleich sein
Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "VIEW" for record "Auftrag2"
Then field "artikel" has value "AUSL-STORNO" in row 1
And I close the current editor

Given I open the infosystem ProcurementStatus for position 1 of SalesOrder from editor "Auftrag2"
Then field "elem" has value "AUSL-STORNO" in row !lastRow
And I close the current editor
