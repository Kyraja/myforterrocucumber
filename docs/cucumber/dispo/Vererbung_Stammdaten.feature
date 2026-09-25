@persistent
Feature: Vererbung_Stammdaten.feature

# **********************************************************************************
#  Name             : Vererbung_Stammdaten.feature
#  Autor            : bschiga
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet Vererbung von Stammdaten in Vorgaenge
#  ref              : ref_dispo_vererbung_stammdaten_cu
#
# **********************************************************************************
# verwendete Stammdaten: basis_stammdaten.feature

Background:
Given I set the fake date to "09.01.1995"

Scenario: K001 Vorbereitung fuer individuelle Vererbungskonfigurationen testen

# individuelle Konfigurationslisten aus der Standardliste erstellen
Given I open an editor "Konfig0" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "COPY" for record "STANDARDLISTE"
And I set fields
    | such      | GARNIXVERERBEN                    |
    | namebspr  | Vererbungskonfig keine Vererbung  |
And I save the current editor

# Vererbungsliste ohne Vererbung erstellen, diese auch als Kopiervorlage verwenden
Given I open the infosystem "SCHEDCONF"
And I set field "konfigliste" to "GARNIXVERERBEN"
And I press start
And I press button "update"
And I press start
Then field "taktiv" has value "nein" in all rows
And I close the current editor

Given I open an editor "Konfig1" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "COPY" for record "GARNIXVERERBEN"
And I set fields
    | such      | ARTIKELVERERBKONF             |
    | namebspr  | Vererbungskonfig nur Artikel  |
And I save the current editor

Given I open an editor "Konfig2" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "COPY" for record "GARNIXVERERBEN"
And I set fields
    | such      | PRODKONFIGVERERB_STD                      |
    | namebspr  | Vererbungskonfig Artikelkonfig Standard   |
And I save the current editor

Given I open an editor "Konfig3" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "COPY" for record "GARNIXVERERBEN"
And I set fields
    | such      | PRODKONFIGVERERB_EK               |
    | namebspr  | Vererbungskonfig Artikelkonfig EK |
And I save the current editor

Given I open an editor "Konfig4" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "COPY" for record "GARNIXVERERBEN"
And I set fields
    | such      | PRODKONFIGVERERB_FE               |
    | namebspr  | Vererbungskonfig Artikelkonfig FE |
And I save the current editor

Given I open an editor "Konfig5" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "COPY" for record "GARNIXVERERBEN"
And I set fields
    | such      | BASISARTIKELVERERB            |
    | namebspr  | Vererbungskonfig Basisartikel |
And I save the current editor

# fuer jede Konfigurationsliste die Vererbung der gewuenschten Felder einstellen
Given I open the infosystem "SCHEDCONF"
And I set field "konfigliste" to "STANDARDLISTE"
And I press start
Then field "taktiv" has value "nein" in all rows
And I modify table
    | !row                      | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='DISPOA'           | ja           | ja            | ja            | !dontChange   |
    | tsuch=='ABPLATZ'          | ja           | ja            | ja            | !dontChange   |
    | tsuch=='ZUPLATZ'          | ja           | ja            | ja            | !dontChange   |
    | tsuch=='LIEF'             | ja           | ja            | !dontChange   | !dontChange   |
And I press button "update"
# vererbende Felder fuer bestimmten Artikel einstellen
And I set field "konfigliste" to "ARTIKELVERERBKONF"
And I press start
And I modify table
    | !row                      | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='LIEF'             | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='RUNDUNG'          | ja           | ja            | !dontChange   | !dontChange   |
And I press button "update"
# vererbende Felder fuer Artikelkonfiguration einstellen
And I set field "konfigliste" to "PRODKONFIGVERERB_STD"
And I press start
And I modify table
    | !row                      | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='DISPOA'           | ja           | ja            | ja            | !dontChange   |
And I press button "update"
And I set field "konfigliste" to "PRODKONFIGVERERB_EK"
And I press start
And I modify table
    | !row                      | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='DISPOA'           | ja           | ja            | ja            | !dontChange   |
    | tsuch=='LIEF'             | ja           | ja            | !dontChange   | !dontChange   |
And I press button "update"
And I set field "konfigliste" to "PRODKONFIGVERERB_FE"
And I press start
And I modify table
    | !row                      | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='DISPOA'           | ja           | ja            | ja            | !dontChange   |
    | tsuch=='FVERLUST'         | ja           | !dontChange   | !dontChange   | ja            |
And I press button "update"
# vererbende Felder fuer Basisartikel einstellen
And I set field "konfigliste" to "BASISARTIKELVERERB"
And I press start
And I modify table
    | !row                      | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='DISPOA'           | ja           | ja            | !dontChange   | !dontChange   |
And I press button "update"
And I close the current editor

# in Standard-Artikelkonfigurationen eine Vererbungskonfiguration eintragen
Given I open an editor "ProdKonfigSTD" from table "(Part):(ProductConfiguration)" with command "UPDATE" for record "STD_PRODUCTCONF"
And I set fields
    | konfigliste   | PRODKONFIGVERERB_STD  |
And I save the current editor

# Artikelkonfigurationen anlegen
Given I open an editor "ProdKonfig1" from table "(Part):(ProductConfiguration)" with command "COPY" for record "STD_PRODUCTCONF"
And I set fields
    | such          | PRODCONF_EK               |
    | namebspr      | Artikelkonfig EK-Artikel  |
    | konfigliste   | PRODKONFIGVERERB_EK       |
And I save the current editor

Given I open an editor "ProdKonfig2" from table "(Part):(ProductConfiguration)" with command "COPY" for record "STD_PRODUCTCONF"
And I set fields
    | such          | PRODCONF_FE                       |
    | namebspr      | Artikelkonfig Fertiguns-Artikel   |
    | konfigliste   | PRODKONFIGVERERB_FE               |
And I save the current editor

# Basisartikel anlegen
Given I open an editor "BASISKONFIG" from table "(Part):(BaseProduct)" with command "STORE" for record "BASISKONFIG"
And I set field "such" to "BASISKONFIG"
And I set field "konfigliste" to "BASISARTIKELVERERB"
And I save the current editor

# Artikel anlegen
Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | TEILKONF          |
    | konfigliste   | ARTIKELVERERBKONF |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | bedarfsbezogen    |
    | lief          | TEST              |
    | abplatz       | F2                |
And I save the current editor

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | TEILOHNE          |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | bedarfsbezogen    |
    | lief          | TEST              |
    | abplatz       | F2                |
And I save the current editor

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | TEILBASISKONF     |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | bedarfsbezogen    |
    | lief          | TEST              |
    | abplatz       | F2                |
    | basisartikel  | BASISKONFIG       |
    | index         | K01               |
And I save the current editor

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | TEILPRODCONF      |
    | artkonf       | PRODCONF_EK       |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | bedarfsbezogen    |
    | lief          | TEST              |
    | abplatz       | F2                |
And I save the current editor

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | TEILGARNIX        |
    | konfigliste   | GARNIXVERERBEN    |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | bedarfsbezogen    |
    | lief          | TEST              |
    | zuplatz       | F1                |
    | abplatz       | F1                |
And I save the current editor

Given I create a SalesOrder "KONFIG1" for Customer "KUNDE1" with Product "TEILKONF" and quantity "50"
Given I create a SalesOrder "KONFIG2" for Customer "KUNDE1" with Product "TEILOHNE" and quantity "50"
Given I create a SalesOrder "KONFIG3" for Customer "KUNDE1" with Product "TEILBASISKONF" and quantity "50"
Given I create a SalesOrder "KONFIG4" for Customer "KUNDE1" with Product "TEILPRODCONF" and quantity "50"
Given I create a SalesOrder "KONFIG5" for Customer "KUNDE1" with Product "TEILGARNIX" and quantity "50"

And I run Scheduling


Scenario: K01 Artikel mit eingetragener Vererbungskonfiguration

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILKONF"
And I press button "ladetab"
Then table has values
    | dispoa            | lief^such |
    | bedarfsbezogen    | TEST      |
And I close the current editor

# Vererbungskonfiguration des Artikels greift, lief wird vererbt, dispoa wird nicht vererbt
Given I open an editor "TEILKONF" from table "(Part):(Product)" with command "UPDATE" for record "TEILKONF"
And I set fields
    | dispoa   | erweitert bedarfsbezogen |
    | lief     | LIEFER1                  |
And I save the current editor

And I run Scheduling

# pruefen dass der Lieferant in den Bestellvorschlag vererbt wurde, dispoa nicht
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILKONF"
And I press button "ladetab"
Then table has values
    | dispoa            | lief^such |
    | bedarfsbezogen    | LIEFER1   |
And I close the current editor

# pruefen dass die dispoa bedarfsbezogen geblieben ist
Given I open an editor "KONFIG1" from table "(Sales):(SalesOrder)" with command "VIEW" for record "KONFIG1"
Then field "eres^dispoa" has value "bedarfsbezogen" in row 1
And I close the current editor

# Auftrag stornieren, damit Bedarf weg ist, Artikel wird in anderem Scenario noch verwendet
Given I open an editor "KONFIG1" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "KONFIG1"
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor


Scenario: K02 Artikel mit eingetragener Artikelkonfiguration, in der eine individuelle Vererbungskonfiguration hinterlegt ist

# dispoa wird vererbt
Given I open an editor "TEILPRODCONF" from table "(Part):(Product)" with command "UPDATE" for record "TEILPRODCONF"
And I set fields
    | dispoa        | auftragsbezogen   |
And I save the current editor

And I run Scheduling

# pruefen dass der Bestellvorschlag noch vorhanden ist und die dispoa sich geaendert hat
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILPRODCONF"
And I press button "ladetab"
Then table has values
    | dispoa            |
    | auftragsbezogen   |
And I close the current editor

# pruefen dass die dispoa sich geaendert hat
Given I open an editor "KONFIG4" from table "(Sales):(SalesOrder)" with command "VIEW" for record "KONFIG4"
Then field "eres^dispoa" has value "auftragsbezogen" in row 1
And I close the current editor


Scenario: K03 Artikel mit Basisartikel, der eine individuelle Vererbungskonfiguration hat

# bsart wird vererbt, dispoa nicht
Given I open an editor "TEILBASISKONF" from table "(Part):(Product)" with command "UPDATE" for record "TEILBASISKONF"
And I set fields
    | bsart         | Eigenfertigung    |
    | dispoa        | auftragsbezogen   |
And I save the current editor

And I run Scheduling

# pruefen, dass kein BV mehr vorhanden
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILBASISKONF"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

# pruefen dass FV mit dispo auftragsbezogen entstanden ist
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILBASISKONF"
And I press button "ladetab"
Then table has values
    | dispoa            |
    | auftragsbezogen   |
And I close the current editor


Scenario: K04 Vererbung aus Standardartikelkonfiguration, die eine individuelle Vererbungskonfiguration eingetragen hat

# Teil ohne konfigliste und ohne artkonf => Standardartikelkonfiguration greift und die dort eingetragene konfigliste
Given I open an editor "TEILOHNE" from table "(Part):(Product)" with command "UPDATE" for record "TEILOHNE"
And I set fields
    | bsart         | Eigenfertigung            |
    | dispoa        | erweitert bedarfsbezogen  |
    | abplatz       | F3                        |
And I save the current editor

And I run Scheduling

# es gibt einen Fertigungsvorschlag, abplatz ist nicht im FV
Given I open an editor "BV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILOHNE"
And I press button "ladetab"
Then table has values
    | dispoa                    |
    | erweitert bedarfsbezogen  |
And I close the current editor

# es gibt keinen Bestellvorschlag mehr
Given I open an editor "FV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILOHNE"
Then the table has 0 rows
And I close the current editor

# im Auftrag pruefen dass die dispoa sich geaendert hat und der abplatz nicht
Given I open an editor "KONFIG2" from table "(Sales):(SalesOrder)" with command "VIEW" for record "KONFIG2"
Then table has values
    | artikel^such  | platz | eres^platz    | eres^dispoa               |
    | TEILOHNE      | F2    | F2            | erweitert bedarfsbezogen  |
And I close the current editor


Scenario: K05 Test fuer Artikel mit individueller Vererbungskonfiguration die nichts vererbt
# in der Standardartikelkonfiguration ist eine Vererbungsliste hinterlegt, fuer den Artikel soll aber gar nichts vererbt werden

Given I open an editor "TEILGARNIX" from table "(Part):(Product)" with command "UPDATE" for record "TEILGARNIX"
Then field "konfigliste" has value "GARNIXVERERBEN"
And I set fields
    | dispoa        | auftragsbezogen   |
    | zuplatz       | F3                |
    | abplatz       | F3                |
    | lief          | TEST              |
And I save the current editor

And I run Scheduling

# es gibt immer noch einen Bestellvorschlag, zuplatz, dispo und lief wurden NICHT veraendert
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILGARNIX"
And I press button "ladetab"
Then table has values
    | dispoa            | lief^such | platz |
    | bedarfsbezogen    | TEST      | F1    |
And I close the current editor

# es gibt keinen Fertigungsvorschlag
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILGARNIX"
Then the table has 0 rows
And I close the current editor

# im Auftrag pruefen dass die dispoa und der platz sich nicht geaendert haben
Given I open an editor "KONFIG5" from table "(Sales):(SalesOrder)" with command "VIEW" for record "KONFIG5"
Then table has values
    | artikel^such  | platz | eres^platz    | eres^dispoa       |
    | TEILGARNIX    | F1    | F1            | bedarfsbezogen    |
And I close the current editor


Scenario: K06 Test fuer Standardvererbungskonfiguration

# aus Standardartikelkonfiguration die konfigliste rausnehmen, die Standardvererbungskonfiguration greift jetzt
Given I open an editor "ProdKonfigSTD" from table "(Part):(ProductConfiguration)" with command "UPDATE" for record "STD_PRODUCTCONF"
And I set field "konfigliste" to ""
And I save the current editor

Given I open an editor "TEILOHNE" from table "(Part):(Product)" with command "UPDATE" for record "TEILOHNE"
And I set fields
    | bsart         | Fremdbeschaffung  |
    | dispoa        | bedarfsbezogen    |
    | zuplatz       | F1                |
    | lief          | TEST              |
And I save the current editor

And I run Scheduling

# es gibt wieder einen Bestellvorschlag, zuplatz, dispo und lief wurden vererbt
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILOHNE"
And I press button "ladetab"
Then table has values
    | dispoa            | lief^such | platz |
    | bedarfsbezogen    | TEST      | F1    |
And I close the current editor

Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILOHNE"
Then the table has 0 rows
And I close the current editor

# im Auftrag pruefen dass die dispoa sich geaendert hat
Given I open an editor "KONFIG2" from table "(Sales):(SalesOrder)" with command "VIEW" for record "KONFIG2"
Then field "eres^dispoa" has value "bedarfsbezogen" in row 1
And I close the current editor


Scenario: K07 Artikel mit abgelegter Artikelkonfiguration kann nicht gespeichert werden

# Artikelkonfiguration kann abgelegt werden, auch wenn sie in einem Artikel eingetragen ist
Given I open an editor "PRODCONF_EK" from table "(Part):(ProductConfiguration)" with command "DELETE" for record "PRODCONF_EK"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Then "(Part):(ProductConfiguration)" with the editor id "PRODCONF_EK" is filed

# Artikel kann nicht gespeichert werden, wenn eine abgelegte Artikelkonfiguration eingetragen ist
Given I open an editor "TEILPRODCONF" from table "(Part):(Product)" with command "UPDATE" for record "TEILPRODCONF"
Then field "artkonf" has value "+PRODCONF_EK"
And I set field "dispoa" to "bedarfsbezogen"
# 852 Ungültige Artikelkonfiguration.
Then saving the current editor throws the exception "852"
And I set field "artkonf" to ""
And I respond with answer "ja" to the dialog with id "Dispositionsparameter wurden verändert: Alle Einplanungen werden neu durchgerechnet. O.K.?"
And I save the current editor


Scenario: K08 Artikel mit abgelegter Vererbungskonfiguration kann nicht gespeichert werden

Given I create a SalesOrder "K08" for Customer "KUNDE1" with Product "TEILKONF" and quantity "22,22"

Given I open an editor "TEILKONF" from table "(Part):(Product)" with command "UPDATE" for record "TEILKONF"
Then field "konfigliste" has value "ARTIKELVERERBKONF"
And I set field "rundung" to "1"
And I save the current editor

And I run Scheduling

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILKONF"
And I press button "ladetab"
Then field "rundung" has value "1" in row 1
Then field "mge" has value "23" in row 1
And I close the current editor

# Vererbungskonfiguration kann abgelegt werden, auch wenn sie in einem Artikel eingetragen ist
Given I open an editor "ARTIKELVERERBKONF" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "DELETE" for record "ARTIKELVERERBKONF"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Then "(SchedulingConfiguration):(ListsConfigInheritance)" with the editor id "ARTIKELVERERBKONF" is filed

# Artikel kann nicht gespeichert werden, wenn eine abgelegte Vererbungskonfiguration eingetragen ist
Given I open an editor "TEILKONF" from table "(Part):(Product)" with command "UPDATE" for record "TEILKONF"
Then field "konfigliste" has value "+ARTIKELVERERBKONF"
And I set field "rundung" to "10"
And I set field "dispoa" to "auftragsbezogen"
# 853 Ungültige Konfigurationsliste.
Then saving the current editor throws the exception "853"
And I set field "konfigliste" to ""
And I save the current editor

And I run Scheduling

# rundung wird nicht mehr vererbt, dispoa wurde vererbt aus der Standardvererbungsliste
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILKONF"
And I press button "ladetab"
Then field "rundung" has value "1" in row 1
Then field "mge" has value "23" in row 1
Then field "dispoa" has value "auftragsbezogen" in row 1
And I close the current editor


Scenario: K09 Artikel mit Artikelkonfiguration, die eine abgelegte Vererbungskonfiguration enthaelt, wird mit Standardvererbung vererbt

Given I open an editor "TEILPRODCONF" from table "(Part):(Product)" with command "COPY" for record "TEILPRODCONF"
And I set fields
    | such          | TEILPRODCONF_DEL  |
    | artkonf       | PRODCONF_FE       |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | bedarfsbezogen    |
    | lief          | TEST              |
    | mindest       | 50                |
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such          | BG2               |
    | bsart         | Eigenfertigung    |
And I delete all rows
And I append rows
    | elex              | elanzahl    |
    | TEILPRODCONF_DEL  | 1           |
    | A AG2             | !dontChange |
And I save the current editor

Given I open an editor "TEILPRODCONF_DEL" from table "(Part):(Product)" with command "UPDATE" for record "TEILPRODCONF_DEL"
And I set field "fverlust" to "10"
And I save the current editor

And I run Scheduling

Given I open an editor "BG2" from table "(Part):(Product)" with command "VIEW" for record "BG2"
Then field "elex" has value "TEILPRODCONF_DEL" in row 1
Then field "pverlust" has value "10" in row 1
And I close the current editor

Given I open an editor "PRODKONFIGVERERB_FE" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "DELETE" for record "PRODKONFIGVERERB_FE"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "PRODCONF_FE" from table "(Part):(ProductConfiguration)" with command "VIEW" for record "PRODCONF_FE"
Then field "konfigliste" has value "+PRODKONFIGVERERB_FE"
And I close the current editor

Given I open an editor "TEILPRODCONF_DEL" from table "(Part):(Product)" with command "UPDATE" for record "TEILPRODCONF_DEL"
Then field "artkonf" has value "PRODCONF_FE"
And I set field "fverlust" to "25"
And I set field "lief" to "LIEFER1"
And I save the current editor

And I run Scheduling

# fverlust wird nicht mehr vererbt aus PRODKONFIGVERERB_FE
Given I open an editor "BG2" from table "(Part):(Product)" with command "VIEW" for record "BG2"
Then field "elex" has value "TEILPRODCONF_DEL" in row 1
Then field "pverlust" has value "10" in row 1
And I close the current editor

# lief wurde vererbt aus Standardvererbungskonfiguration
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "TEILPRODCONF_DEL"
And I press button "ladetab"
Then field "lief^such" has value "LIEFER1" in row 1
And I close the current editor


Scenario: K10 Basisartikel mit abgelegter Vererbungskonfiguration kann nicht gespeichert werden

Given I open an editor "BASISARTIKELVERERB" from table "(SchedulingConfiguration):(ListsConfigInheritance)" with command "DELETE" for record "BASISARTIKELVERERB"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Then "(SchedulingConfiguration):(ListsConfigInheritance)" with the editor id "BASISARTIKELVERERB" is filed

# Basisartikel kann nicht gespeichert werden, abgelegte konfigliste muss entfernt werden
Given I open an editor "BASISKONFIG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISKONFIG"
Then field "konfigliste" has value "+BASISARTIKELVERERB"
And I set field "ebetreuer" to "TEST"
# 853 Ungültige Konfigurationsliste.
Then saving the current editor throws the exception "853"
And I set field "konfigliste" to ""
And I save the current editor
Then field "ebetreuer" has value "TEST"
And I close the current editor


Scenario: Vorbereitung fuer alle weiteren Tests mit Standardvererbungskonfiguration, gewuenschte Felder einstellen

# bei Konfiguration aus V-02-01 und V-39-03 mit gleichem Suchwort, werden die Felder in beiden Konfigurationen gesetzt
Given I open the infosystem "SCHEDCONF"
And I press start
And I modify table
    | !row                      | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='MVERLUST'         | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='RUNDUNG'          | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='DISPOA'           | ja           | ja            | ja            | !dontChange   |
    | tsuch=='ABPLATZ'          | ja           | ja            | ja            | !dontChange   |
    | tsuch=='ZUPLATZ'          | ja           | ja            | ja            | !dontChange   |
    | tsuch=='NACHFOLGEARTIKEL' | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='FLISTESTD'        | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='ANZAHL'           | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='LIEF'             | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='EFRIST'           | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='VORLAUF'          | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='FVERLUST'         | ja           | !dontChange   | !dontChange   | ja            |
    | tsuch=='MANBUSTD'         | ja           | !dontChange   | !dontChange   | ja            |
    | tsuch=='CHARGENREINSTD'   | ja           | !dontChange   | !dontChange   | ja            |
    | tsuch=='CHARGENREIN'      | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='EBETREUER'        | ja           | ja            | ja            | !dontChange   |
    | tsuch=='FBETREUER'        | ja           | ja            | ja            | !dontChange   |
And I press button "update"
And I close the current editor

Given I open the infosystem "SCHEDCONF"
And I set field "dbgruppe" to "V-39-03"
And I press start
And I modify table
    | !row              | taktiv       | tnichtfixvorg | tfixvorg      | tinfl         |
    | tsuch=='LIEF'     | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='EFRIST'   | ja           | ja            | !dontChange   | !dontChange   |
    | tsuch=='VORLAUF'  | ja           | ja            | !dontChange   | !dontChange   |
And I press button "update"
And I close the current editor


Scenario: Vorbereitung Artikel anlegen

Given I open an editor "BG-LZID" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such    | BG-LZID         |
    | bsart   | Eigenfertigung  |
And I append rows
    | elex        | elanzahl    |
    | EK1-BEDARF  | 1           |
    | EK1-BEDARF  | 2           |
    | A AG2       | !dontChange |
And I save the current editor
And I switch the current editor to editor "BG-LZID" with command "VIEW"
Then field "lzid" has value "3"
Then table has values
    | tzid  | !row  |
    | 1     | 1     |
    | 2     | 2     |
    | 3     | 3     |
And I close the current editor

Given I open an editor "VARIANTENBEZOGEN" from table "(Part):(Product)" with command "STORE" for record "VARIANTENBEZOGEN"
And I set fields
    | such    | VARIANTENBEZOGEN    |
    | bsart   | Eigenfertigung      |
    | dispoa  | variantenbezogen    |
And I delete all rows
And I append rows
    | elex        | elanzahl    |
    | EINK        | 1           |
    | BAUT        | 2           |
    | A AG1       | !dontChange |
And I save the current editor

Given I open an editor "BG-FLISTESTD" from table "(Part):(Product)" with command "STORE" for record "BG-FLISTESTD"
And I set fields
    | such      | BG-FLISTESTD    |
    | bsart     | Eigenfertigung  |
And I delete all rows
And I append rows
    | elex        | elanzahl    |
    | EK1-BEDARF  | 1           |
    | A AG1       | !dontChange |
    | EK2-BEDARF  | 1           |
    | A AG2       | !dontChange |
And I save the current editor

#############################################################
Scenario: A01 mverlust im Artikel aendern und im Bestellvorschlag pruefen

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such     | EINK2 |
And I save the current editor

Given I create a SalesOrder "MVERLUST" for Customer "KUNDE1" with Product "EINK2" and quantity "200"

And I run Scheduling

# eine Teilmenge des Bestellvorschlags zur Bestellung freigeben
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EINK2;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
Then the table has 1 rows
Then table has values
    | mge       | pverlust  | netlimge  | fix   |
    | 200       | 0         |  200      | nein  |
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-A01"
And I set field "mge" to "100" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# Dispo laufen lassen, damit fuer die restliche Menge ein neuer Bestellvorschlag angelegt wird
And I run Scheduling

Given I open an editor "EINK2" from table "(Part):(Product)" with command "UPDATE" for record "EINK2"
And I set fields
    | mverlust   | 10 |
And I save the current editor

And I run Scheduling

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for search criteria "$,,artikel==EINK2;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
Then the table has 1 rows
Then table has values
    | mge       | pverlust  | netlimge  | fix   |
    | 111.111   | 10        |  100      | nein  |
And I close the current editor


Scenario: A01a mverlust im Artikel aendern und im Bestellvorschlag pruefen, maxbsmge 100 und minbsmge 25 gesetzt

Given I open an editor "EK-BEDARF_MIX" from table "(Part):(Product)" with command "UPDATE" for record "EK-BEDARF_MIX"
And I set fields
    | dispoa    | erweitert bedarfsbezogen  |
And I save the current editor

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | mge   | verw      |
    | EK-BEDARF_MIX | 50    | mverlust  |
And I save the current editor

Given I open an editor "EK-BEDARF_MIX" from table "(Part):(Product)" with command "UPDATE" for record "EK-BEDARF_MIX"
And I set fields
    | mverlust   | 10 |
And I save the current editor

And I run Scheduling

# in manuell angelegten fixierten Bestellvorschlag wird mverlust nicht in pverlust vererbt
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for search criteria "$,,artikel==EK-BEDARF_MIX;fix==ja;verw==mverlust;@richtung=vorwärts;@maxordtreffer=1"
Then the table has 1 rows
Then field "pverlust" has value "0" in row 1
And I close the current editor

# in unfixierten Bestellvorschlag (von Dispo angelegt wegen Mindestbestand) wird mverlust in pverlust vererbt und es wurde ein weiterer BV erstellt
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for search criteria "$,,artikel==EK-BEDARF_MIX;fix==nein;@richtung=vorwärts;@maxordtreffer=1"
Then the table has 2 rows
Then table has values
    | mge   | pverlust  | netlimge  | fix   |
    | 100   | 10        |  90       | nein  |
    |  25   | 10        |  22.5     | nein  |
And I close the current editor


Scenario: A02 Abgangsplatz wird in den Auftrag vererbt, wenn es bisher der Standardplatz war

Given I create a SalesOrder "ABPLATZ_1" for Customer "KUNDE1" with Product "EK2-BEDARF" and quantity "50"
Given I create a SalesOrder "ABPLATZ_2" for Customer "KUNDE1" with Product "EK2-BEDARF" and quantity "20"

Given I open an editor "ABPLATZ_1" from table "(Sales):(SalesOrder)" with command "VIEW" for record "ABPLATZ_1"
Then field "platz" has value "F1" in row 1
Then field "eres^platz" has value "F1" in row 1
And I close the current editor

# Vorgang fixieren
Given I open an editor "ABPLATZ_2" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "ABPLATZ_2"
Then field "platz" has value "F1" in row 1
Then field "eres^platz" has value "F1" in row 1
And I set field "fix" to "ja" in row 1
And I save the current editor

Given I open an editor "EK2-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK2-BEDARF"
And I set fields
    | abplatz   | F3 |
And I save the current editor

And I run Scheduling

Given I open an editor "ABPLATZ_1" from table "(Sales):(SalesOrder)" with command "VIEW" for record "ABPLATZ_1"
Then field "platz" has value "F3" in row 1
Then field "eres^platz" has value "F3" in row 1
And I close the current editor

Given I open an editor "ABPLATZ_2" from table "(Sales):(SalesOrder)" with command "VIEW" for record "ABPLATZ_2"
Then field "platz" has value "F3" in row 1
Then field "eres^platz" has value "F3" in row 1
And I close the current editor


Scenario: A02a Abgangsplatz wird nicht in den Auftrag vererbt, wenn er vom Standardplatz abweicht

Given I open an editor "ABPLATZ_1" from table "(Sales):(SalesOrder)" with command "VIEW" for record "ABPLATZ_1"
Then field "platz" has value "F3" in row 1
And I close the current editor

# Platz im Auftrag abweichend vom Standardplatz
Given I open an editor "ABPLATZ_2" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "ABPLATZ_2"
And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "EK2-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK2-BEDARF"
And I set fields
    | abplatz   | F2 |
And I save the current editor

And I run Scheduling

Given I open an editor "ABPLATZ_1" from table "(Sales):(SalesOrder)" with command "VIEW" for record "ABPLATZ_1"
Then field "platz" has value "F2" in row 1
And I close the current editor

Given I open an editor "ABPLATZ_2" from table "(Sales):(SalesOrder)" with command "VIEW" for record "ABPLATZ_2"
Then field "platz" has value "F1" in row 1
And I close the current editor


Scenario: A02b Abgangsplatz wird nicht vererbt in gebuchte noch nicht berechnete Lieferscheine oder Rechnung mit Lagerbewegung

Given I open an editor "LS-ABPLATZ_1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "ABPLATZ_1"
And I set fields
   | such   | LS_A02B |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "1" in row 1
Then field "platz" has value "F2" in row 1
And I save the current editor

Given I open an editor "RE-ABPLATZ_1" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "ABPLATZ_1"
And I set fields
   | such   | RE_A02B |
   | ueb    | ja      |
   | fakt   | ja      |
   | vom    | .       |
And I set field "mge" to "1" in row 1
And I set field "preis" to "2" in row 1
Then field "platz" has value "F2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "EK2-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK2-BEDARF"
And I set fields
    | abplatz   | F4 |
And I save the current editor

And I run Scheduling

Given I open an editor "LS_A02B" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS-ABPLATZ_1"
Then field "platz" has value "F2" in row 1
And I close the current editor

Given I open an editor "RE_A02B" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE-ABPLATZ_1"
Then field "platz" has value "F2" in row 1
And I close the current editor


Scenario: A02c Abgangsplatz wird nicht in den Auftrag vererbt, wenn Auftrag in externer Lagergruppe und im Artikel der interne Platz geaendert wird

Given I open an editor "EXTERNLG1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1    |
    | such  | EXTERNLG1 |
And I append rows
    | artikel | mge | platz   |
    | V2      | 10  | L3F1    |
And I save the current editor

Given I open an editor "EK-LAGERGRUPPE" from table "(Part):(Product)" with command "UPDATE" for record "EK-LAGERGRUPPE"
And I set fields
    | abplatz   | F3 |
And I save the current editor

And I run Scheduling

# Platz aus externer Lagergruppe bleibt erhalten
Given I open an editor "EXTERNLG1" from table "(Sales):(SalesOrder)" with command "VIEW" for record "EXTERNLG1"
Then field "platz" has value "L3F1" in row 1
And I close the current editor


Scenario: A03 Zugangsplatz vererben, wenn es vorher der Standardplatz war

# neuen EK-Artikel anlegen
Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such      | EK-ZUPLATZ       |
    | dispoa    | auftragsbezogen  |
And I save the current editor

Given I open an editor "ZUPLATZ1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1    |
    | such  | ZUPLATZ1  |
And I append rows
    | artikel    | mge | platz  | fix     | verw              |
    | EK-ZUPLATZ | 10  | F1     | ja      | Platz vererben    |
    | EK-ZUPLATZ | 15  | F1     | nein    | Platz vererben    |
    | EK-ZUPLATZ | 20  | F2     | nein    | nicht vererben    |
And I save the current editor

And I run Scheduling

# einen Bestellvorschlag fixieren
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-ZUPLATZ;mge==10;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "fix" to "ja" in row 1
And I save the current editor

# Teilmenge zur Bestellung freigeben, mit Standardplatz
Given I open an editor "BV_EXT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-ZUPLATZ;mge==15;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-A03"
And I set field "mge" to "10" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Teilmenge zur Bestellung freigeben, abweichend vom Standardplatz
Given I open an editor "BV_EXT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-ZUPLATZ;mge==20;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-A03_2"
And I set field "mge" to "1" in row 1
And I set field "platz" to "F4" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

# bei einem Bestellvorschlag platz aendern
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-ZUPLATZ;mge==19;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "platz" to "F2" in row 1
And I save the current editor

# Teilmenge liefern mit Lieferschein
Given I open an editor "LS-A03" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE-A03"
And I set fields
   | such   | LS-A03 |
   | ebeleg | LS-A03 |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "3" in row 1
And I save the current editor

# Teilmenge liefern mit Rechnung mit Lagerbewegung
Given I open an editor "RE-A03" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE-A03"
And I set fields
   | such   | RE-A03 |
   | ebeleg | RE-A03 |
   | ueb    | ja     |
   | fakt   | ja     |
   | vom    | .      |
And I set field "mge" to "1" in row 1
Then field "platz" has value "F1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Scheduling

Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-ZUPLATZ"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then table has values
    | mge   | fix   | platz |
    | 10    | ja    | F1    |
    |  5    | nein  | F1    |
    | 19    | nein  | F2    |
And I close the current editor

# zuplatz aendern
Given I open an editor "EK-ZUPLATZ" from table "(Part):(Product)" with command "UPDATE" for record "EK-ZUPLATZ"
And I set field "zuplatz" to "F3"
And I save the current editor

And I run Scheduling

Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-ZUPLATZ"
And I press button "ladetab"
Then table has values
    | mge   | fix   | platz |
    | 10    | ja    | F3    |
    |  5    | nein  | F3    |
    | 19    | nein  | F2    |
And I close the current editor

Given I open an editor "BE-A03" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE-A03"
Then table has values
    | limge | platz     |
    |  6    | F3        |
And I close the current editor
# nicht vererben wenn der Platz vorher nicht der Standardplatz war
Given I open an editor "BE-A03_2" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE-A03_2"
Then table has values
    | limge | platz     |
    |  1    | F4        |
And I close the current editor

# wird nicht in gebuchte, nicht berechnete Lieferscheine vererbt
Given I open an editor "LS-A03" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS-A03"
Then table has values
    | mge   | platz     |
    |  3    | F1        |
And I close the current editor

# wird nicht in gebuchte Rechnungen mit Lagerbewegung vererbt
Given I open an editor "RE-A03" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE-A03"
Then table has values
    | mge   | platz     |
    |  1    | F1        |
And I close the current editor


Scenario: A03a Baugruppe mit Koppelprodukt, Zugangsplatz vererben

Given I open an editor "EK-ZUPLATZ" from table "(Part):(Product)" with command "UPDATE" for record "EK-ZUPLATZ"
And I set field "zuplatz" to "F1"
And I save the current editor

Given I open an editor "KOPPELPROD" from table "(Part):(Product)" with command "UPDATE" for record "KOPPELPROD"
And I set field "zuplatz" to "F1"
And I save the current editor

Given I open an editor "BAUT" from table "(Part):(Product)" with command "COPY" for record "BAUT"
And I set fields
    | such     | BG-ZUPLATZ      |
    | dispoa   | auftragsbezogen |
And I modify table
    | !row  | elem          | elanzahl  | kompeig       |
    | +1    | EK-ZUPLATZ    | 1         |               |
    | +2    | KOPPELPROD    | 1         | Koppelprodukt |
And I save the current editor

Given I open an editor "ZUPLATZ2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1    |
    | such  | ZUPLATZ2  |
And I append rows
    | artikel    | mge | platz  | fix     | verw              |
    | BG-ZUPLATZ | 10  | F1     | ja      | Platz vererben    |
    | BG-ZUPLATZ | 15  | F1     | nein    | Platz vererben    |
    | BG-ZUPLATZ | 20  | F2     | nein    | nicht vererben    |
And I save the current editor

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel     | netmge    | verw      |
    | BG-ZUPLATZ  | 2         | manuell   |
And I save the current editor

And I run Scheduling

Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BG-ZUPLATZ;mge==10;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem       | platz  |
    | 1     | EK-ZUPLATZ | F1     |
    | 2     | KOPPELPROD | F1     |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Zugangsplatz Koppelprodukt ändern in der Reservierung (AFL des FV)
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,artikel==BG-ZUPLATZ;mge==15;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem       | platz  |
    | 1     | EK-ZUPLATZ | F1     |
    | 2     | KOPPELPROD | F1     |
And I set field "platz" to "F2" in row 2
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Zugangsplatz Fertigteil ändern im Fertigungsvorschlag
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,artikel==BG-ZUPLATZ;mge==20;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "platz" to "F2"
And I save the current editor

Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BG-ZUPLATZ;mge==2;fix==ja;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem       | platz  |
    | 1     | EK-ZUPLATZ | F1     |
    | 2     | KOPPELPROD | F1     |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "EK-ZUPLATZ" from table "(Part):(Product)" with command "UPDATE" for record "EK-ZUPLATZ"
And I set field "zuplatz" to "F3"
And I save the current editor

Given I open an editor "KOPPELPROD" from table "(Part):(Product)" with command "UPDATE" for record "KOPPELPROD"
And I set field "zuplatz" to "F3"
And I save the current editor

Given I open an editor "BG-ZUPLATZ" from table "(Part):(Product)" with command "UPDATE" for record "BG-ZUPLATZ"
And I set field "zuplatz" to "F4"
And I save the current editor

And I run Scheduling

# bei EK-ZUPLATZ ist es der Abgangsplatz, bei KOPPELPROD ist es der Zugangsplatz in der AFL, also der Reservierung
# auch Vererbung in fixierten Fertigungsvorschlag, wenn es vorher der Standardplatz war
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BG-ZUPLATZ;mge==2;fix==ja;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem       | platz  |
    | 1     | EK-ZUPLATZ | F1     |
    | 2     | KOPPELPROD | F3     |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# wird in unfixierten Fertigungsvorschlag vererbt, wenn es vorher der Standardplatz war
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BG-ZUPLATZ;mge==10;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem       | platz  |
    | 1     | EK-ZUPLATZ | F1     |
    | 2     | KOPPELPROD | F3     |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# wird nicht vererbt wenn der Zugangsplatz vorher nicht der Standardplatz war
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BG-ZUPLATZ;mge==15;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem       | platz  |
    | 1     | EK-ZUPLATZ | F1     |
    | 2     | KOPPELPROD | F2     |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Zugangsplatz Fertigteil wird vererbt, wenn es vorher der Standardplatz war
Given I open an editor "BV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-ZUPLATZ"
And I press button "ladetab"
Then table has values
    | mge   | fix   | platz |
    |  2    | ja    | F4    |
    | 10    | nein  | F4    |
    | 15    | nein  | F4    |
    | 20    | nein  | F2    |
And I close the current editor


Scenario: A04 frei


Scenario: A05 Dispoart im Artikel aendern und in EK-Bestellung, Bestellvorschlag und VK-Auftrag pruefen, fixiert und unfixiert

Given I create a SalesOrder "DISPOA_1" for Customer "KUNDE1" with Product "EK1-BEDARF" and quantity "50"
Given I create a SalesOrder "DISPOA_2" for Customer "KUNDE1" with Product "EK1-BEDARF" and quantity "20"

# Vorgang fixieren
Given I open an editor "DISPOA_2" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "DISPOA_2"
And I set field "fix" to "ja" in row 1
And I save the current editor

And I run Scheduling

# einen der Bestellvorschlaege freigeben
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK1-BEDARF"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-A05"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BE-A05" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE-A05"
Then field "dispoa" has value "bedarfsbezogen" in row 1
And I close the current editor

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK1-BEDARF"
And I press button "ladetab"
Then field "dispoa" has value "bedarfsbezogen" in row 1
And I close the current editor

Given I open an editor "EK1-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK1-BEDARF"
And I set fields
    | dispoa   | auftragsbezogen |
And I save the current editor

And I run Scheduling

Given I open an editor "BE-A05" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE-A05"
Then field "dispoa" has value "auftragsbezogen" in row 1
And I close the current editor

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK1-BEDARF"
And I press button "ladetab"
Then field "dispoa" has value "auftragsbezogen" in row 1
And I close the current editor

Given I open an editor "DISPOA_1" from table "(Sales):(SalesOrder)" with command "VIEW" for record "DISPOA_1"
Then field "eres^dispoa" has value "auftragsbezogen" in row 1
And I close the current editor

Given I open an editor "DISPOA_2" from table "(Sales):(SalesOrder)" with command "VIEW" for record "DISPOA_2"
Then field "fix" has value "ja" in row 1
Then field "eres^dispoa" has value "auftragsbezogen" in row 1
And I close the current editor


Scenario: A05a dispoa variantenbezogen aendern wird nicht vererbt

Given I create a SalesOrder "DISPOA_B" for Customer "KUNDE1" with Product "BG-BEDARF" and quantity "50"

Given I open an editor "DISPOA_B" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "DISPOA_B"
Then field "eres^dispoa" has value "bedarfsbezogen" in row 1
And I set field "verw" to "aus Auftrag" in row 1
And I save the current editor

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel    | netmge    | verw       |
    | BG-BEDARF | 10        | manuell    |
And I save the current editor

And I run Scheduling

# es gibt 2 Fertigungsvorschlaege mit dispoart bedarfsbezogen, einer manuell angelegt und einer durch die Dispo erzeugt
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-BEDARF"
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | mge   | fix   | verw           | dispoa           |
    | 10    | ja    | manuell        | bedarfsbezogen   |
    | 40    | nein  |                | bedarfsbezogen   |
And I close the current editor

Given I open an editor "BG-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "BG-BEDARF"
And I set fields
    | dispoa   | auftragsbezogen |
And I save the current editor

And I run Scheduling

# geaenderte dispoart wurde in den Auftrag vererbt
Given I open an editor "DISPOA_B" from table "(Sales):(SalesOrder)" with command "VIEW" for record "DISPOA_B"
Then field "eres^dispoa" has value "auftragsbezogen" in row 1
And I close the current editor

# beide Fertigungsvorschlaege, einer manuell angelegt und einer durch die Dispo erzeugt, haben jetzt dispoa auftragsbezogen
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-BEDARF"
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | mge   | fix   | verw           | dispoa            |
    | 10    | ja    | manuell        | auftragsbezogen   |
    | 50    | nein  | aus Auftrag    | auftragsbezogen   |
And I close the current editor

Given I open an editor "BG-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "BG-BEDARF"
And I set fields
    | dispoa   | variantenbezogen |
And I save the current editor

And I run Scheduling

# dispo variantenbezogen wird nicht vererbt, im Auftrag und in den Fertigungsvorschlaegen bleibt auftragsbezogen
Given I open an editor "DISPOA_B" from table "(Sales):(SalesOrder)" with command "VIEW" for record "DISPOA_B"
Then field "eres^dispoa" has value "auftragsbezogen" in row 1
And I close the current editor

# beide Fertigungsvorschlaege, einer manuell angelegt und einer durch die Dispo erzeugt, haben jetzt dispoa auftragsbezogen
Given I open an editor "FV_BEDARF" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-BEDARF"
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | mge   | fix   | verw          | dispoa            |
    | 10    | ja    | manuell       | auftragsbezogen   |
    | 50    | nein  | aus Auftrag   | auftragsbezogen   |
And I close the current editor

Given I create a SalesOrder "DISPOA_V" for Customer "KUNDE1" with Product "BG-BEDARF" and quantity "10"

Given I open an editor "DISPOA_V" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "DISPOA_V"
Then field "eres^dispoa" has value "variantenbezogen" in row 1
And I set field "verw" to "variante" in row 1
And I save the current editor

Given I open an editor "FV_BEDARF" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-BEDARF"
And I press button "ladetab"
Then the table has 3 rows
Then table has values
    | mge   | fix   | verw          | dispoa            |
    | 10    | ja    | manuell       | auftragsbezogen   |
    | 10    | nein  | variante      | variantenbezogen  |
    | 50    | nein  | aus Auftrag   | auftragsbezogen   |
And I close the current editor

Given I open an editor "BG-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "BG-BEDARF"
And I set fields
    | dispoa   | bedarfsbezogen |
And I save the current editor

And I run Scheduling

# wenn von variantenbezogen auf andere Dispoart umgestellt wird, dann wird nicht vererbt, auch nicht in die Vorgaenge die andere Dispoart haben
Given I open an editor "FV_BEDARF" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-BEDARF"
And I press button "ladetab"
Then the table has 3 rows
Then table has values
    | mge   | fix   | verw          | dispoa           |
    | 10    | ja    | manuell       | auftragsbezogen  |
    | 10    | nein  | variante      | variantenbezogen |
    | 50    | nein  | aus Auftrag   | auftragsbezogen  |
And I close the current editor


Scenario: A05b Aenderungen an variantenbezogenen Artikeln werden nicht in den Auftrag oder den FV vererbt, wenn der Fertigartikel variantenbezogen ist

Given I create a SalesOrder "VARIANTE" for Customer "KUNDE1" with Product "VARIANTENBEZOGEN" and quantity "10"

And I run Scheduling

Given I open an editor "VARIANTENBEZOGEN" from table "(Part):(Product)" with command "UPDATE" for record "VARIANTENBEZOGEN"
And I set field "anzahl" to "2" in row 1
And I save the current editor

And I run Scheduling

# Aenderung wird nicht in die AFL vererbt
Given I open an editor "VARIANTE" from table "(Sales):(SalesOrder)" with command "VIEW" for record "VARIANTE"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "anzahl" has value "1" in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Aenderung wird nicht in den bereits vorhandenen Fertigungsvorschlag vererbt und es wird kein neuer Fertigungsvorschlag erzeugt
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "VARIANTENBEZOGEN"
And I press button "ladetab"
#Then the table has 1 rows
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "anzahl" has value "1" in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: A06 Rundungsfaktor im Artikel aendern, im Bestellvorschlag, der Bestellung und im VK-Auftrag die Reservierung pruefen, fixiert und unfixiert

Given I open an editor "RUNDUNG" from table "(Part):(Product)" with command "STORE" for record "RUNDUNG"
And I set fields
    | such      | RUNDUNG           |
    | bsart     | Fremdbeschaffung  |
    | dispoa    | auftragsbezogen   |
    | lief      | TEST              |
    | rundung   | 0                 |
And I save the current editor

Given I open an editor "RUNDFIX" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1    |
    | such  | RUNDFIX   |
And I append rows
    | artikel  | mge     | verw    | fix |
    | RUNDUNG  | 20,25   | fixiert | ja  |
And I save the current editor

Given I open an editor "RUNDUNFIX" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1     |
    | such  | RUNDUNFIX  |
And I append rows
    | artikel  | mge     | verw      | fix   |
    | RUNDUNG  | 50,123  | unfixiert | nein  |
And I save the current editor

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel    | mge       | verw      |
    | RUNDUNG    | 10,567    | manuell   |
And I save the current editor

And I run Scheduling

# einen der Bestellvorschlaege zur Bestellung freigeben, Teilmenge
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==RUNDUNG;fix==nein;mge=20.25;@richtung=rueckwaerts;@maxordtreffer=1"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-A06"
And I set field "mge" to "10,125" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Anfrage anlegen
Given I open an editor "100AN" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "100AN"
And I create a new row at the end of the table
And I set field "artikel" to "RUNDUNG" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor
And I close the current editor


Given I open an editor "RUNDUNG" from table "(Part):(Product)" with command "UPDATE" for record "RUNDUNG"
And I set fields
    | lief      | 001 |
And I save the current editor


And I run Scheduling

# in die Anfrage wird nicht vererbt
Given I open an editor "ANF-1KV" from table "(Purchasing):(Request)" with command "VIEW" for record "100AN"
Then field "kl" has value "1" in row 1
And I close the current editor


Given I open an editor "RUNDUNG" from table "(Part):(Product)" with command "UPDATE" for record "RUNDUNG"
And I set fields
    | rundung   | 0,5 |
And I save the current editor


And I run Scheduling

# in fixierten Vorgang wird nicht vererbt
Given I open an editor "RUNDFIX" from table "(Sales):(SalesOrder)" with command "VIEW" for record "RUNDFIX"
Then field "fix" has value "ja" in row 1
Then field "eres^rundung" has value "0" in row 1
Then field "eres^mge" has value "20.25" in row 1
And I close the current editor

# in unfixierten Vorgang wird vererbt, Reservierung
Given I open an editor "RUNDUNFIX" from table "(Sales):(SalesOrder)" with command "VIEW" for record "RUNDUNFIX"
Then field "fix" has value "nein" in row 1
Then field "eres^rundung" has value "0.5" in row 1
Then field "eres^mge" has value "50.5" in row 1
And I close the current editor

## Menge in der Bestellung wird NICHT geändert
Given I open an editor "BE-A06" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE-A06"
Then field "rundung" has value "0" in row 1
Then field "mge" has value "10.125" in row 1
Then field "kl" has value "1" in row 1
And I close the current editor

# in unfixierten Bestellvorschlag wird vererbt bzw. neu gezogen
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "RUNDUNG"
And I press button "ladetab"
Then the table has 3 rows
Then table has values
    | !row                  | mge       | fix   |
    | $,,verw==fixiert      | 10.5      | nein  |
    | $,,verw==unfixiert    | 50.5      | nein  |
    | $,,verw==manuell      | 10.567    | ja    |
And I close the current editor


Scenario: A07 lief, efrist und vorlauf im Artikel aendern und in Bestellvorschlag pruefen, unfixiert vererben und fixiert nicht
#Given I set the fake date to "09.01.95"
Given I open an editor "EK-ERWBEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK-ERWBEDARF"
And I set fields
    | mindest   | 50 |
    | maxbsmge  | 50 |
Then field "lief^such" has value "LIEFER1"
And I save the current editor

Given I create a SalesOrder "LIEF" for Customer "KUNDE1" with Product "EK-ERWBEDARF" and quantity "20"

And I run Scheduling

# einen Bestellvorschlag fixieren
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-ERWBEDARF;mge==20;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "fix" to "ja" in row 1
And I set field "fixterm" to "ja" in row 1
And I save the current editor

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-ERWBEDARF"
And I press button "ladetab"
Then table has values
    | !row          | mge   | lief^such |
    | $,,fix==ja    | 20    | LIEFER1   |
    | $,,fix==nein  | 50    | LIEFER1   |
And I close the current editor

Given I open an editor "EK-ERWBEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK-ERWBEDARF"
And I set fields
    | lief   | TEST |
And I save the current editor

And I run Scheduling

Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-ERWBEDARF"
And I press button "ladetab"
Then table has values
    | !row          | mge   | lief^such |
    | $,,fix==ja    | 20    | LIEFER1   |
    | $,,fix==nein  | 50    | TEST      |
And I close the current editor

# Fixierung aufheben
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-ERWBEDARF;fix==ja;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "fix" to "nein" in row 1
And I save the current editor

# efrist und vorlauf von Erstlieferant TEST aendern
Given I open an editor "EK-ERWBEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK-ERWBEDARF"
And I set fields
    | efrist   | 1 |
    | vorlauf  | 0 |
And I save the current editor

And I run Scheduling

# efrist und vorlauf wird nur vererbt, wenn der Lieferant passt
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-ERWBEDARF"
And I press button "ladetab"
Then table has values
# mit fake date 09.01.95
    | !row                  | fix   | mge   | lzeit | vorlauf   | wtsterm   | wtrterm   |
    | $,,lief^such==TEST    | nein  | 50    | 1     | 0         | 02.01.95  | 03.01.95  |
    | $,,lief^such==LIEFER1 | nein  | 20    | 3     | 3         | 03.01.95  | 09.01.95  |
And I close the current editor


Scenario: A08 flistestd im Artikel aendern und im Fertigungsvorschlag und Auftrag pruefen

Given I open an editor "ALTERNATIVFL" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
And I set fields
    | such          | ALTERNATIVFL  |
    | artikel       | BG-FLISTESTD  |
    | lgruppe       | KARLSRUHE     |
And I delete all rows
And I append rows
    | elex          | elanzahl      |
    | EK3-BEDARF    | 1             |
    | A AG1         | 1             |
And I save the current editor

Given I create a SalesOrder "FLISTESTD" for Customer "KUNDE1" with Product "BG-FLISTESTD" and quantity "10"

And I run Scheduling

Given I open an editor "FLISTESTD" from table "(Sales):(SalesOrder)" with command "VIEW" for record "FLISTESTD"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "flistestd" has value "STANDARD"
And the table has 4 rows
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-FLISTESTD"
And I press button "ladetab"
Then the table has 1 rows
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "flistestd" has value "STANDARD"
And the table has 4 rows
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BG-FLISTESTD" from table "(Part):(Product)" with command "UPDATE" for record "BG-FLISTESTD"
And I set field "flistestd" to "ALTERNATIVFL"
And I save the current editor
Then field "flistestd" has value "ALTERNATIVFL"
Then the table has 2 rows

And I run Scheduling

Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-FLISTESTD"
And I press button "ladetab"
Then the table has 1 rows
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "flistestd" has value "ALTERNATIVFL"
Then the table has 2 rows
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "FLISTESTD" from table "(Sales):(SalesOrder)" with command "VIEW" for record "FLISTESTD"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "flistestd" has value "ALTERNATIVFL"
Then the table has 2 rows
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "STANDARD" from table "(ProductionList):(ProductionList)" with command "UPDATE" for search criteria "$,,artikel==BG-FLISTESTD;such==STANDARD;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "flistestd" to "ja"
And I save the current editor

Given I open an editor "ALTERNATIVFL" from table "(ProductionList):(ProductionList)" with command "UPDATE" for record "ALTERNATIVFL"
Then field "flistestd" has value "nein"
And I save the current editor

And I run Scheduling

Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-FLISTESTD"
And I press button "ladetab"
Then the table has 1 rows
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "flistestd^id" has value "!STANDARD^id"
Then the table has 4 rows
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "FLISTESTD" from table "(Sales):(SalesOrder)" with command "VIEW" for record "FLISTESTD"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "flistestd^id" has value "!STANDARD^id"
Then the table has 4 rows
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: A09 Baugruppe mit Auslaufteil, Nachfolger aendern, nicht in fixierten Fertigungsvorschlag vererben

Given I open an editor "EK-AUSLAUF" from table "(Part):(Product)" with command "UPDATE" for record "EK-AUSLAUF"
And I set fields
    | lbsdatum     | -1 |
    | lverwdatum   | -1 |
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such     | BGNACHF |
    | losgr    | 0       |
And I modify table
    | !row  | elem          | elanzahl  |
    | +1    | EK-AUSLAUF    | 1         |
And I save the current editor

Given I create a SalesOrder "BGNACHF" for Customer "KUNDE1" with Product "BGNACHF" and quantity "100"

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | verw      |
    | BGNACHF   | 100       | auslauf   |
And I save the current editor

And I run Scheduling

Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BGNACHF;verw==`;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem          | relevant  | einplan   |
    | 1     | EK-AUSLAUF    | nein      | nein      |
    | 2     | EK-NACHFOLGER | ja        | ja        |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BGNACHF;verw==auslauf;fix==ja;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem          | relevant  | einplan   |
    | 1     | EK-AUSLAUF    | nein      | nein      |
    | 2     | EK-NACHFOLGER | ja        | ja        |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "EK-AUSLAUF" from table "(Part):(Product)" with command "UPDATE" for record "EK-AUSLAUF"
And I set field "nachfolgeartikel" to "TEST"
And I save the current editor

And I run Scheduling

# keine Vererbung in fixierten Fertigungsvorschlag
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BGNACHF;verw==auslauf;fix==ja;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem          | relevant  | einplan   |
    | 1     | EK-AUSLAUF    | nein      | nein      |
    | 2     | EK-NACHFOLGER | ja        | ja        |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# neuer Nachfolger wird in unfixierten Fertigungsvorschlag vererbt
Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BGNACHF;verw==`;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL"
Then table has values
    | !row  | elem          | relevant  | einplan   |
    | 1     | EK-AUSLAUF    | nein      | nein      |
    | 2     | TEST          | ja        | ja        |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: A10 manbustd und fverlust in Fertigungslisten vererben, manbustd nicht bei Beistellungen

Given I open an editor "V3" from table "(Part):(Product)" with command "VIEW" for record "V3"
Then table has values
    | !row          | elem  | manbu | pverlust  |
    | $,,elem==E2   | E2    | nein  | 0         |
And I close the current editor

Given I open an editor "FLISTE" from table "(ProductionList):(ProductionList)" with command "COPY" for search criteria "$,,artikel==V3;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "such" to "V3KOPIE"
Then table has values
    | !row          | elem  | manbu | pverlust  |
    | $,,elem==E2   | E2    | nein  | 0         |
And I save the current editor

Given I open an editor "EK-BEISTELL" from table "(Part):(Product)" with command "UPDATE" for record "EK-BEISTELL"
And I modify table
    | !row  | elem  | elanzahl | bua                    |
    | +1    | E2    | 2        | Lieferantenbeistellung |
Then field "manbu" has value "nein" in row 1
And I save the current editor

Given I open an editor "E2" from table "(Part):(Product)" with command "UPDATE" for record "E2"
And I set fields
    | manbustd  | ja    |
    | fverlust  | 10    |
And I save the current editor

And I run Scheduling

Given I open an editor "V3" from table "(Part):(Product)" with command "VIEW" for record "V3"
Then table has values
    | !row          | elem  | manbu | pverlust  |
    | $,,elem==E2   | E2    | ja    | 10        |
And I close the current editor

Given I open an editor "STANDARD" from table "(ProductionList):(ProductionList)" with command "VIEW" for search criteria "$,,artikel==V3;such==STANDARD;@richtung=rueckwaerts;@maxordtreffer=1"
Then table has values
    | !row          | elem  | manbu | pverlust  |
    | $,,elem==E2   | E2    | ja    | 10        |
And I close the current editor

Given I open an editor "V3KOPIE" from table "(ProductionList):(ProductionList)" with command "VIEW" for search criteria "$,,artikel==V3;such==V3KOPIE;@richtung=rueckwaerts;@maxordtreffer=1"
Then table has values
    | !row          | elem  | manbu | pverlust  |
    | $,,elem==E2   | E2    | ja    | 10        |
And I close the current editor

# manbu wird nicht vererbt, fverlust wird in pverlust vererbt
Given I open an editor "EK-BEISTELL" from table "(Part):(Product)" with command "VIEW" for record "EK-BEISTELL"
Then table has values
    | !row  | elem  | elanzahl | bua                    | manbu | pverlust  |
    |  1    | E2    | 2        | Lieferantenbeistellung | nein  | 10        |
And I close the current editor

Given I open an editor "STANDARD" from table "(ProductionList):(ProductionList)" with command "VIEW" for search criteria "$,,artikel==EK-BEISTELL;@richtung=rueckwaerts;@maxordtreffer=1"
Then table has values
    | !row  | elem  | elanzahl | bua                    | manbu | pverlust  |
    |  1    | E2    | 2        | Lieferantenbeistellung | nein  | 10        |
And I save the current editor

Given I open an editor "E2" from table "(Part):(Product)" with command "UPDATE" for record "E2"
And I set fields
    | manbustd  | nein  |
    | fverlust  |  0    |
And I save the current editor

And I run Scheduling

Given I open an editor "V3" from table "(Part):(Product)" with command "VIEW" for record "V3"
Then table has values
    | !row          | elem  | manbu | pverlust  |
    | $,,elem==E2   | E2    | nein  | 0         |
And I close the current editor

Given I open an editor "STANDARD" from table "(ProductionList):(ProductionList)" with command "VIEW" for search criteria "$,,artikel==V3;@richtung=rueckwaerts;@maxordtreffer=1"
Then table has values
    | !row          | elem  | manbu | pverlust  |
    | $,,elem==E2   | E2    | nein  | 0         |
And I close the current editor

@A11
#Scenario: A11 chargenreinstd in Fertigungslisten und offene Vorgaenge vererben
#
#Given I open an editor "E3" from table "(Part):(Product)" with command "COPY" for record "E3"
#And I set fields
#    | such              | E3CHARGE          |
#    | chverfolgung      | Chargenverfolgung |
#Then field "chargenreinstd" has value "nein"
#And I save the current editor
#
#Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
#And I set fields
#    | such              | BG1_E3CHARGE      |
#    | chverfolgung      | Chargenverfolgung |
#    | chargenreinstd    | ja                |
#And I modify table
#    | !row  | elem      |
#    | +1    | E3CHARGE  |
#Then field "chargenrein" has value "nein" in row 1
#And I save the current editor
#
#Given I open an editor "BG1_E3CHARGE" from table "(Part):(Product)" with command "COPY" for record "BG1_E3CHARGE"
#And I set fields
#    | such              | BG2_E3CHARGE      |
#    | chverfolgung      | Chargenverfolgung |
#    | chargenreinstd    | ja                |
#    | mindest           | 50                |
#Then table has values
#    | !row              | elem      | chargenrein   |
#    | $,,elem==E3CHARGE | E3CHARGE  | nein          |
#And I save the current editor
#
#Given I create a SalesOrder "BG1_E3CHA" for Customer "KUNDE1" with Product "BG1_E3CHARGE" and quantity "10"
#
#And I run Scheduling
#
#Given I open an editor "BG1_E3CHA" from table "(Sales):(SalesOrder)" with command "VIEW" for record "BG1_E3CHA"
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "nein" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#
#Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "artikel" to "BG1_E3CHARGE"
#And I press button "ladetab"
#Then the table has 2 rows
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "nein" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "artikel" to "BG2_E3CHARGE"
#And I press button "ladetab"
#Then the table has 1 rows
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "nein" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#
#Given I open an editor "FLISTE" from table "(ProductionList):(ProductionList)" with command "COPY" for search criteria "$,,artikel==BG2_E3CHARGE;@richtung=rueckwaerts;@maxordtreffer=1"
#And I set field "such" to "BG2_E3CHARGE_KOPIE"
#Then table has values
#    | !row              | elem      | chargenrein   |
#    | $,,elem==E3CHARGE | E3CHARGE  | nein          |
#And I save the current editor
#
#Given I open an editor "E3CHARGE" from table "(Part):(Product)" with command "UPDATE" for record "E3CHARGE"
#And I set field "chargenreinstd" to "ja"
#And I save the current editor
#
#And I run Scheduling
#
#Given I open an editor "BG1_E3CHARGE" from table "(Part):(Product)" with command "VIEW" for record "BG1_E3CHARGE"
#Then table has values
#    | !row              | elem      | chargenrein   |
#    | $,,elem==E3CHARGE | E3CHARGE  | ja            |
#And I close the current editor
#
#Given I open an editor "BG2_E3CHARGE" from table "(Part):(Product)" with command "VIEW" for record "BG2_E3CHARGE"
#Then table has values
#    | !row              | elem      | chargenrein   |
#    | $,,elem==E3CHARGE | E3CHARGE  | ja            |
#And I close the current editor
#
#Given I open an editor "STANDARD" from table "(ProductionList):(ProductionList)" with command "VIEW" for search criteria "$,,artikel==BG2_E3CHARGE;such==STANDARD;@richtung=rueckwaerts;@maxordtreffer=1"
#Then table has values
#    | !row              | elem      | chargenrein   |
#    | $,,elem==E3CHARGE | E3CHARGE  | ja            |
#And I close the current editor
#
#Given I open an editor "BG2_E3CHARGE_KOPIE" from table "(ProductionList):(ProductionList)" with command "VIEW" for search criteria "$,,artikel==BG2_E3CHARGE;such==BG2_E3CHARGE_KOPIE;@richtung=rueckwaerts;@maxordtreffer=1"
#Then table has values
#    | !row              | elem      | chargenrein   |
#    | $,,elem==E3CHARGE | E3CHARGE  | ja            |
#And I close the current editor
#
#Given I open an editor "BG1_E3CHA" from table "(Sales):(SalesOrder)" with command "VIEW" for record "BG1_E3CHA"
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "ja" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#
#Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "artikel" to "BG1_E3CHARGE"
#And I press button "ladetab"
#Then the table has 2 rows
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "ja" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "artikel" to "BG2_E3CHARGE"
#And I press button "ladetab"
#Then the table has 1 rows
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "ja" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#
## chargenreinstd wieder auf nein setzen im Artikel
#Given I open an editor "E3CHARGE" from table "(Part):(Product)" with command "UPDATE" for record "E3CHARGE"
#And I set field "chargenreinstd" to "nein"
#And I save the current editor
#
#And I run Scheduling
#
#Given I open an editor "BG1_E3CHA" from table "(Sales):(SalesOrder)" with command "VIEW" for record "BG1_E3CHA"
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "nein" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#
## nur in der FL der Baugruppe chargenrein auf ja setzen
#Given I open an editor "BG1_E3CHARGE" from table "(Part):(Product)" with command "UPDATE" for record "BG1_E3CHARGE"
#Then field "elem" has value "E3CHARGE" in row 1
#And I set field "chargenrein" to "ja" in row 1
#And I save the current editor
#
#And I run Scheduling
#
## nur fuer BG1_E3CHARGE wurde in der AFL-Zeile chargenrein=ja gesetzt, bei BG2_E3CHARGE nicht
#Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "artikel" to "BG1_E3CHARGE"
#And I press button "ladetab"
#Then the table has 2 rows
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "ja" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#Given I open an editor "FV01" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
#And I set field "artikel" to "BG2_E3CHARGE"
#And I press button "ladetab"
#Then the table has 1 rows
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "nein" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#
## AFL-Zeile im Auftrag wurde ebenfalls geaendert
#Given I open an editor "BG1_E3CHA" from table "(Sales):(SalesOrder)" with command "VIEW" for record "BG1_E3CHA"
#And I press button "absteig" to open a subeditor for "AFL" in row 1
#Then field "chargenrein" has value "ja" in row 1
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor


Scenario: A12 Disponent im Artikel aendern und in Bestellvorschlag und EK-Bestellung pruefen, fixiert und unfixiert

Given I open an editor "EK1-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK1-BEDARF"
And I set fields
    | ebetreuer | KARL  |
    | mindest   | 1000  |
And I save the current editor

And I run Scheduling

# einen Bestellvorschlag manuell erstellen, der ist dann fixiert
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | mge   |
    | EK1-BEDARF    | 55    |
And I save the current editor

Given I open an editor "EKBE_A12" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | TEST       |
    | such | EKBE_A12   |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan |
    | EK1-BEDARF    | 250 | ja      |
And I save the current editor

Given I open an editor "EK1-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK1-BEDARF"
And I set fields
    | ebetreuer | MEIER |
And I save the current editor

And I run Scheduling

Given I open an editor "EKBE_A12" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "EKBE_A12"
Then field "betreuer^such" has value "MEIER" in row 1
And I close the current editor

Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK1-BEDARF"
And I press button "ladetab"
Then field "betreuer^such" has value "MEIER" in row 1
Then field "betreuer^such" has value "MEIER" in row 2
And I close the current editor

Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK1-BEDARF"
And I press button "ladetab"
And I set field "mge" to "0" in row 1
And I save the current editor


Scenario: A13 Disponent Fertigung im Artikel aendern und im Fertigungsvorschlag und BA pruefen, fixiert und unfixiert

Given I open an editor "BG-AUFTRAG" from table "(Part):(Product)" with command "UPDATE" for record "BG-AUFTRAG"
And I set fields
    | fbetreuer | KARL  |
    | mindest   | 1000  |
And I save the current editor

And I run Scheduling

# einen Fertigungsvorschlag manuell erstellen, der ist dann fixiert
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge    |
    | BG-AUFTRAG    | 55        |
And I save the current editor

Given I open an editor "BG-AUFTRAG" from table "(Part):(Product)" with command "UPDATE" for record "BG-AUFTRAG"
And I set fields
    | fbetreuer | MEIER |
And I save the current editor

And I run Scheduling

Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BG-AUFTRAG"
And I press button "ladetab"
Then field "betreuer^such" has value "MEIER" in row 1
Then field "betreuer^such" has value "MEIER" in row 2
And I close the current editor

Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BG-AUFTRAG"
And I press button "ladetab"
And I modify table
    | !row          | netmge    |
    | netmge=='55'  | 0         |
And I save the current editor


Scenario: L01 Lagergruppeneigenschaften aendern und in fixierte und unfixierte Vorgaenge vererben

# neuen Artikel mit Lagergruppeneigenschaften anlegen
Given I open an editor "EK-LAGERGRUPPE" from table "(Part):(Product)" with command "COPY" for record "EK-LAGERGRUPPE"
And I set fields
    | such      | EK-LAGERGRUPPE2   |
    | dispoa    | bedarfsbezogen    |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | lief  | efrist    | vorlauf   | bsart             | dispoa           | zuplatz    | abplatz   |
    | BERLIN    | TEST  | 20        | 5         | Fremdbeschaffung  | bedarfsbezogen   | L3F1       | L3F1      |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "L3F3"
And I set fields
    | such     | L3F3     |
    | lager    | L3       |
And I save the current editor

Given I open an editor "EXTERNLG2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1    |
    | such  | EXTERNLG2 |
And I append rows
    | artikel         | mge | platz   | fix     | verw              |
    | EK-LAGERGRUPPE2 | 10  | L3F1    | ja      | Platz vererben    |
    | EK-LAGERGRUPPE2 | 15  | L3F1    | nein    | Platz vererben    |
    | EK-LAGERGRUPPE2 | 20  | L3F2    | nein    | Platz nicht ver   |
    | EK-LAGERGRUPPE2 | 25  | F1      | nein    | nicht vererben    |
And I save the current editor

And I run Scheduling

# einen Bestellvorschlag fixieren
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-LAGERGRUPPE2;mge==10;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "fix" to "ja" in row 1
And I save the current editor

# bei einem Bestellvorschlag platz aendern
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-LAGERGRUPPE2;mge==20;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "platz" to "L3F2" in row 1
And I save the current editor

# Teilmenge zur Bestellung freigeben
Given I open an editor "BV_EXT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-LAGERGRUPPE2;mge==15;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-L01"
And I set field "mge" to "10" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE2"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 4 rows
Then table has values
    | lgruppe   | mge   | fix   | platz   | dispoa          |
    | BERLIN    | 10    | ja    | L3F1    | bedarfsbezogen  |
    | BERLIN    | 20    | nein  | L3F2    | bedarfsbezogen  |
    | KARLSRUHE | 25    | nein  | F1      | bedarfsbezogen  |
    | BERLIN    |  5    | nein  | L3F1    | bedarfsbezogen  |
And I close the current editor

# Lagergruppeneigenschaften aendern, dispoa, abplatz, zuplatz
Given I open an editor "EK-LAGERGRUPP2E" from table "(Part):(Product)" with command "UPDATE" for record "EK-LAGERGRUPPE2"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I modify table
    | !row  | dispoa            | zuplatz    | abplatz   |
    | 1     | auftragsbezogen   | L3F3       | L3F3      |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# dispoa wird in Zeilen 1-3 vererbt, Platz nur wenn es bisher der Standardplatz der externen Lagergruppe war
Given I open an editor "EXTERNLG2" from table "(Sales):(SalesOrder)" with command "VIEW" for record "EXTERNLG2"
Then table has values
    | artikel^such    | mge | platz   | eres^platz    | fix     | verw               | eres^dispoa     |
    | EK-LAGERGRUPPE2 | 10  | L3F3    | L3F3          | ja      | Platz vererben     | auftragsbezogen |
    | EK-LAGERGRUPPE2 | 15  | L3F3    | L3F3          | nein    | Platz vererben     | auftragsbezogen |
    | EK-LAGERGRUPPE2 | 20  | L3F2    | L3F2          | nein    | Platz nicht ver    | auftragsbezogen |
    | EK-LAGERGRUPPE2 | 25  | F1      | F1            | nein    | nicht vererben     | bedarfsbezogen  |
And I close the current editor

Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE2"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 4 rows
Then table has values
    | lgruppe   | mge   | fix   | platz   | dispoa          |
    | BERLIN    | 10    | ja    | L3F3    | auftragsbezogen |
    | BERLIN    | 20    | nein  | L3F2    | auftragsbezogen |
    | KARLSRUHE | 25    | nein  | F1      | bedarfsbezogen  |
    | BERLIN    |  5    | nein  | L3F3    | auftragsbezogen |
And I close the current editor

Given I open an editor "BE-L01" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE-L01"
Then table has values
    | mge   | platz     | dispoa            |
    | 10    | L3F3      | auftragsbezogen   |
And I close the current editor


Scenario: L02 Lagergruppeneigenschaften aendern

Given I open an editor "EK-LAGERGRUPPE" from table "(Part):(Product)" with command "UPDATE" for record "EK-LAGERGRUPPE"
And I set field "dispoa" to "auftragsbezogen"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I modify table
    | !row  | lief  | efrist    | vorlauf   | bsart             | dispoa            |
    | 1     |       |           |           | Eigenfertigung    | auftragsbezogen   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "AUF_INT" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST    |
And I append rows
    | artikel          | mge   | platz   | verw   |
    | EK-LAGERGRUPPE   | 10    | F1      | intern |
And I save the current editor

Given I open an editor "AUF_EXT" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST    |
And I append rows
    | artikel          | mge   | platz   | verw   |
    | EK-LAGERGRUPPE   | 15    | L3F1    | extern |
And I save the current editor

And I run Scheduling

# es wurde 1 Fertigungsvorschlag erstellt, externe Lagergruppe 15 Stueck
Given I open an editor "FV_INT_EXT" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 0 rows
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | verw      |
    | BERLIN    | 15    | nein  | extern    |
And I close the current editor

# es wurde 1 Bestellvorschlag erstellt, interne Lagergruppe 10 Stueck
Given I open an editor "BV_INT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | lief^such | lzeit | vorlauf   | verw      |
    | KARLSRUHE | 10    | nein  | LIEFER1   | 5     | 5         | intern    |
And I close the current editor

# Lagergruppeneigenschaften aendern, von Eigenfertigung auf Fremdbeschaffung
Given I open an editor "EK-LAGERGRUPPE" from table "(Part):(Product)" with command "UPDATE" for record "EK-LAGERGRUPPE"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I modify table
    | !row  | lief  | efrist    | vorlauf   | bsart             |
    | 1     | TEST  | 20        | 3         | Fremdbeschaffung  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Fertigungsvorschlag fuer externe Lagergruppe wurde geloescht
Given I open an editor "FV_INT_EXT" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 0 rows
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

# in der externen Lagergruppe wurde ein Bestellvorschlag fuer Lieferant TEST erstellt, BV interne Lagergruppe bleibt wie bisher
Given I open an editor "BV_EXT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | lief^such | lzeit | vorlauf   | verw      |
    | BERLIN    | 15    | nein  | TEST      | 20    | 3         | extern    |
And I close the current editor

Given I open an editor "BV_INT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | lief^such | lzeit | vorlauf   | verw      |
    | KARLSRUHE | 10    | nein  | LIEFER1   | 5     | 5         | intern    |
And I close the current editor

# Teilmenge zur Bestellung freigeben
Given I open an editor "BV_EXT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-L02"
And I set field "mge" to "10" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# Dispo laufen lassen, damit fuer die restliche Menge ein neuer Bestellvorschlag angelegt wird
And I run Scheduling

# Lagergruppeneigenschaften aendern, efrist und vorlauf - fuer lief einen weiteren Testfall
Given I open an editor "EK-LAGERGRUPPE" from table "(Part):(Product)" with command "UPDATE" for record "EK-LAGERGRUPPE"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I modify table
    | !row  | efrist    | vorlauf   |
    | 1     | 50        | 10        |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

Given I open an editor "BV_EXT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | lief^such | lzeit | vorlauf   | verw      |
    | BERLIN    |  5    | nein  | TEST      | 50    | 10        | extern    |
And I close the current editor

# in Bestellung wird das nicht vererbt
Given I open an editor "BE-L02" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE-L02"
Then table has values
    | lzeit | vorlauf   |
    | 20    |  3        |
And I close the current editor


# FDA-4359
Scenario: L03 Lagergruppeneigenschaften neu anlegen, Umlagerungsvorschlag wird geloescht

Given I open an editor "AUF_INT" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST    |
And I append rows
    | artikel       | mge   | platz   | verw   |
    | VK1-AUFTRAG   | 10    | F1      | intern |
And I save the current editor

Given I open an editor "AUF_EXT" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST    |
And I append rows
    | artikel       | mge   | platz   | verw   |
    | VK1-AUFTRAG   | 15    | L3F1    | extern |
And I save the current editor

And I run Scheduling

# es wurden 2 Fertigungsvorschlaege erstellt, interne Lagergruppe 10 Stueck und 15 Stueck und 1 Umlagerungsvorschlag intern nach extern
Given I open an editor "FV_INT_EXT" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "VK1-AUFTRAG"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | lgruppe   | mge   | fix   | verw      | dispoa            |
    | KARLSRUHE | 10    | nein  | intern    | auftragsbezogen   |
    | KARLSRUHE | 15    | nein  | extern    | auftragsbezogen   |
And I close the current editor

Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "VK1-AUFTRAG"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | mge   | fix   | verw      | dispoa            |
    | KARLSRUHE | BERLIN    | 15    | nein  | extern    | auftragsbezogen   |
And I close the current editor

Given I open an editor "VK1-AUFTRAG" from table "(Part):(Product)" with command "UPDATE" for record "VK1-AUFTRAG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | lief  | efrist    | vorlauf   | bsart             | dispoa                    |
    | BERLIN    | TEST  | 20        | 5         | Fremdbeschaffung  | erweitert bedarfsbezogen  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Fertigungsvorschlag fuer internen Lagergruppe bleibt erhalten, FV fuer Umlagerung externen Lagergruppe wurde geloescht
Given I open an editor "FV_INT_EXT" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "VK1-AUFTRAG"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 0 rows
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | verw      | dispoa            |
    | KARLSRUHE | 10    | nein  | intern    | auftragsbezogen   |
And I close the current editor

# Umlagerungsvorschlag wurde geloescht
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "VK1-AUFTRAG"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

# in der externen Lagergruppe wurde ein Bestellvorschlag fuer Lieferant TEST erstellt
Given I open an editor "BV_EXT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "VK1-AUFTRAG"
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | lief^such  | lzeit | vorlauf   | verw      | dispoa                    |
    | BERLIN    | 15    | nein  | TEST       | 20    | 5         |           | erweitert bedarfsbezogen  |
And I close the current editor


Scenario: L04 Lagergruppeneigenschaften loeschen

Given I open an editor "ALGE_LOESCH" from table "(Part):(Product)" with command "STORE" for record "ALGE_LOESCH"
And I set fields
    | such      | ALGE_LOESCH       |
    | dispoa    | auftragsbezogen   |
    | bsart     | Fremdbeschaffung  |
    | lief      | LIEFER1           |
    | efrist    | 5                 |
    | vorlauf   | 5                 |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | lief  | efrist    | vorlauf   | bsart             | dispoa            |
    | BERLIN    |       |           |           | Eigenfertigung    | auftragsbezogen   |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "AUF_INT" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST  |
And I append rows
    | artikel       | mge   | platz   | verw   |
    | ALGE_LOESCH   | 10    | F1      | intern |
And I save the current editor

Given I open an editor "AUF_EXT" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST  |
And I append rows
    | artikel       | mge   | platz   | verw   |
    | ALGE_LOESCH   | 15    | L3F1    | extern |
And I save the current editor

And I run Scheduling

# es wurde 1 Fertigungsvorschlag erstellt, externe Lagergruppe 15 Stueck
Given I open an editor "FV_INT_EXT" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "ALGE_LOESCH"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 0 rows
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | verw      |
    | BERLIN    | 15    | nein  | extern    |
And I close the current editor

# es wurde 1 Bestellvorschlag erstellt, interne Lagergruppe 10 Stueck
Given I open an editor "BV_INT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "ALGE_LOESCH"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | lief^such | lzeit | vorlauf   | verw      |
    | KARLSRUHE | 10    | nein  | LIEFER1   | 5     | 5         | intern    |
And I close the current editor

# Lagergruppeneigenschaften loeschen
Given I open an editor "ALGE_LOESCH" from table "(Part):(Product)" with command "UPDATE" for record "ALGE_LOESCH"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Fertigungsvorschlag fuer externe Lagergruppe wurde geloescht
Given I open an editor "FV_INT_EXT" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "ALGE_LOESCH"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 0 rows
And I set field "lgruppe" to "BERLIN"
And I press button "ladetab"
Then the table has 0 rows
And I close the current editor

# in der internen Lagergruppe wurde ein weiterer Bestellvorschlag erstellt
Given I open an editor "BV_INT" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "ALGE_LOESCH"
And I set field "lgruppe" to "KARLSRUHE"
And I press button "ladetab"
Then the table has 2 rows
Then table has values
    | lgruppe   | mge   | fix   | lief^such | lzeit | vorlauf   | verw      |
    | KARLSRUHE | 10    | nein  | LIEFER1   | 5     | 5         | intern    |
    | KARLSRUHE | 15    | nein  | LIEFER1   | 5     | 5         | extern    |
And I close the current editor

# es wurde ein Umlagerungsvorschlag erstellt
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "ALGE_LOESCH"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | mge   | fix   | verw      |
    | KARLSRUHE | BERLIN    | 15    | nein  | extern    |
And I close the current editor


#FDA-4281: Vererbung kann ausgeschaltet werden
Scenario: A01NV mverlust im Artikel aendern und im Bestellvorschlag pruefen - keine Vererbung!

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such     | EINK2NV |
And I save the current editor

Given I create a SalesOrder "MVERLUST" for Customer "KUNDE1" with Product "EINK2NV" and quantity "300"

And I run Scheduling

# eine Teilmenge des Bestellvorschlags zur Bestellung freigeben
Given I open an editor "BV01NV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EINK2NV;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
Then the table has 1 rows
Then table has values
    | mge       | pverlust  | netlimge  | fix   |
    | 300       | 0         |  300      | nein  |
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE-B01NV"
And I set field "mge" to "100" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# Dispo laufen lassen, damit fuer die restliche Menge ein neuer Bestellvorschlag angelegt wird
And I run Scheduling

Given I open an editor "EINK2NV" from table "(Part):(Product)" with command "UPDATE" for record "EINK2"
And I set fields
    | mverlust     | 30 |
    | vererbungaus | ja |
And I save the current editor

And I run Scheduling

Given I open an editor "BV01NV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for search criteria "$,,artikel==EINK2NV;fix==nein;@richtung=rueckwaerts;@maxordtreffer=1"
Then the table has 1 rows
Then table has values
    | mge       | pverlust  | netlimge  | fix   |
    | 200       | 0         |  200      | nein  |
And I close the current editor


Scenario: L01NV Lagergruppeneigenschaften aendern und in fixierte und unfixierte Vorgaenge vererben

# neuen Artikel mit Lagergruppeneigenschaften anlegen
Given I open an editor "EK-LAGERGRUPPENV" from table "(Part):(Product)" with command "COPY" for record "EK-LAGERGRUPPE"
And I set fields
    | such      | EK-LAGERGRUPPE2NV   |
    | dispoa    | bedarfsbezogen      |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | lief  | efrist    | vorlauf   | bsart             | dispoa           | zuplatz    | abplatz   |
    | BERLIN    | TEST  | 20        | 5         | Fremdbeschaffung  | bedarfsbezogen   | L3F1       | L3F1      |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "EXTERNLG2NV" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1   |
    | such  | EXTLG2NV |
And I append rows
    | artikel           | mge | platz   | fix     | verw              |
    | EK-LAGERGRUPPE2NV | 55  | L3F1    | nein    | nicht vererben    |
And I save the current editor

And I run Scheduling


# bei einem Bestellvorschlag platz aendern
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-LAGERGRUPPE2NV;mge==55;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "platz" to "L3F2" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE2NV"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | platz   | dispoa          |
    | BERLIN    | 55    | nein  | L3F2    | bedarfsbezogen  |
And I close the current editor

# Lagergruppeneigenschaften aendern, dispoa, abplatz, zuplatz
Given I open an editor "EK-LAGERGRUPP2ENV" from table "(Part):(Product)" with command "UPDATE" for record "EK-LAGERGRUPPE2NV"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I modify table
    | !row  | dispoa            | zuplatz    | abplatz   | vererbungaus |
    | 1     | auftragsbezogen   | L3F3       | L3F3      | ja           |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# dispoa wird in Zeilen 1-3 vererbt, Platz nur wenn es bisher der Standardplatz der externen Lagergruppe war
Given I open an editor "EXTERNLG2NV" from table "(Sales):(SalesOrder)" with command "VIEW" for record "EXTLG2NV"
Then table has values
    | artikel^such      | mge | platz   | eres^platz    | fix     | verw               | eres^dispoa     |
    | EK-LAGERGRUPPE2NV | 55  | L3F1    | L3F1          | nein    | nicht vererben     | bedarfsbezogen |
And I close the current editor




Scenario: L02NX Lagergruppeneigenschaften aendern und danach loeschen und wieder anlegen

# neuen Artikel mit Lagergruppeneigenschaften anlegen
Given I open an editor "EK-LAGERGRUPPELOE" from table "(Part):(Product)" with command "COPY" for record "EK-LAGERGRUPPE"
And I set fields
    | such      | EK-LAGERGRUPPELOE   |
    | dispoa    | bedarfsbezogen      |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | lief  | efrist    | vorlauf   | bsart             | dispoa           | zuplatz    | abplatz   |
    | BERLIN    | TEST  | 20        | 5         | Fremdbeschaffung  | bedarfsbezogen   | L3F1       | L3F1      |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "EXTERNLG2NV" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1   |
    | such  | EXTLG3NV |
And I append rows
    | artikel           | mge | platz   | fix     | verw              |
    | EK-LAGERGRUPPELOE | 55  | L3F1    | nein    | vererben          |
And I save the current editor

And I run Scheduling


# bei einem Bestellvorschlag platz aendern
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for search criteria "$,,artikel==EK-LAGERGRUPPELOE;mge==55;@richtung=rueckwaerts;@maxordtreffer=1"
And I set field "platz" to "L3F2" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "EK-LAGERGRUPPELOE"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | lgruppe   | mge   | fix   | platz   | dispoa          |
    | BERLIN    | 55    | nein  | L3F2    | bedarfsbezogen  |
And I close the current editor

# Lagergruppeneigenschaften aendern, dispoa, abplatz, zuplatz
Given I open an editor "EK-LAGERGRUPPELOE" from table "(Part):(Product)" with command "UPDATE" for record "EK-LAGERGRUPPELOE"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I modify table
    | !row  | dispoa            | zuplatz    | abplatz   |
    | 1     | auftragsbezogen   | L3F3       | L3F3      |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lagergruppeneigenschaften loeschen und neu anlegen
Given I open an editor "EK-LAGERGRUPPELOE" from table "(Part):(Product)" with command "UPDATE" for record "EK-LAGERGRUPPELOE"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | lief  | efrist    | vorlauf   | bsart             | dispoa           | zuplatz    | abplatz   |
    | BERLIN    | TEST  | 20        | 5         | Fremdbeschaffung  | bedarfsbezogen   | L3F3       | L3F3      |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling
# dispoa läuft ohne Diagnosemeldung


Scenario: ART01 Artikelkonfiguration mit unterschiedlicher Bindungsfrist

# Artikelkonfigurationen anlegen
Given I open an editor "ProdKonfigBF" from table "(Part):(ProductConfiguration)" with command "COPY" for record "STD_PRODUCTCONF"
And I set fields
    | such          | PRODCONF_BF                   |
    | namebspr      | Artikelkonfig Bindungsfrist   |
    | bindung       | 30                            |
And I save the current editor

Given I open an editor "STD_PRODUCTCONF" from table "(Part):(ProductConfiguration)" with command "UPDATE" for record "STD_PRODUCTCONF"
And I set field "bindung" to "200"
And I respond with answer "ja" to the dialog with id "Dispositionsparameter wurden verändert: Alle Einplanungen werden neu durchgerechnet. O.K.?"
And I save the current editor

# Artikel anlegen mit Standardartikelkonfiguration
Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | EK_BINDUNG        |
    | artkonf       | STD_PRODUCTCONF   |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | bedarfsbezogen    |
    | lief          | TEST              |
    | efrist        | 80                |
    | mindest       | 20                |
And I save the current editor

Given I create a SalesOrder "AUF1" for Customer "TEST" with Product "EK_BINDUNG" and quantity "30"

And I run Scheduling

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EK_BINDUNG"
And I press start
Then field "badatum" has value "04.05.1995"
Then field "bindung" has value "200"
Then field "hinweis" is empty
And I close the current editor

Given I open an editor "EK_BINDUNG" from table "(Part):(Product)" with command "UPDATE" for record "EK_BINDUNG"
And I set fields
    | artkonf       | PRODCONF_BF   |
And I respond with answer "ja" to the dialog with id "Dispositionsparameter wurden verändert: Alle Einplanungen werden neu durchgerechnet. O.K.?"
And I save the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EK_BINDUNG"
And I press start
Then field "bindung" has value "30"
Then field "hinweis" is not empty
And I close the current editor

And I run Scheduling

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EK_BINDUNG"
And I press start
Then field "badatum" has value "08.02.1995"
Then field "bindung" has value "30"
Then field "hinweis" is empty
And I close the current editor

Given I open an editor "EK_BINDUNG" from table "(Part):(Product)" with command "UPDATE" for record "EK_BINDUNG"
And I set field "artkonf" to ""
And I respond with answer "ja" to the dialog with id "Dispositionsparameter wurden verändert: Alle Einplanungen werden neu durchgerechnet. O.K.?"
And I save the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EK_BINDUNG"
And I press start
Then field "bindung" has value "200"
Then field "hinweis" is not empty
And I close the current editor


Scenario: ART02 Artikelkonfigurationen mit unterschiedlichen Standardlagereinheiten

# Artikelkonfigurationen anlegen Einheit kg
Given I open an editor "ProdKonfigEinheitKG" from table "(Part):(ProductConfiguration)" with command "COPY" for record "STD_PRODUCTCONF"
And I set fields
    | such          | PRODCONF_EINHEIT_KG       |
    | namebspr      | Artikelkonfig Einheit kg  |
    | stdeinheit    | kg                        |
And I save the current editor

# Artikelkonfigurationen anlegen ohne Einheit
Given I open an editor "ProdKonfigEinheitLeer" from table "(Part):(ProductConfiguration)" with command "COPY" for record "STD_PRODUCTCONF"
And I set fields
    | such          | PRODCONF_EINHEIT_LEER         |
    | namebspr      | Artikelkonfig Einheit leer    |
Then field "stdeinheit" is empty
And I save the current editor

Given I open an editor "STD_PRODUCTCONF" from table "(Part):(ProductConfiguration)" with command "VIEW" for record "STD_PRODUCTCONF"
Then field "stdeinheit" is empty
And I close the current editor

# Artikel NEU anlegen mit Standardartikelkonfiguration
Given I open an editor "EINHEIT_STD" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such          | EINHEIT_STD       |
    | artkonf       | STD_PRODUCTCONF   |
Then field "le" has value "Stück"
And I save the current editor

Given I open an editor "STD_PRODUCTCONF" from table "(Part):(ProductConfiguration)" with command "UPDATE" for record "STD_PRODUCTCONF"
And I set field "stdeinheit" to "m"
And I save the current editor

# Artikel NEU anlegen mit individueller Artikelkonfiguration kg
Given I open an editor "EINHEIT_KG" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such          | EINHEIT_KG            |
    | artkonf       | PRODCONF_EINHEIT_KG   |
Then field "le" has value "kg"
And I save the current editor

# Artikel NEU anlegen mit individueller Artikelkonfiguration Einheit leer, Einheit aus Standardartikelkonfiguration
Given I open an editor "EINHEIT_PRODCONF_LEER" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such          | EINHEIT_PRODCONF_LEER |
    | artkonf       | PRODCONF_EINHEIT_LEER |
Then field "le" has value "m"
And I save the current editor
