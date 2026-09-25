Feature: Storno und Ruecklieferungen hier nur Einkauf
Background:
Given I set the fake date to "02.01.2002"
# Given I enable the flag 198

#####################################################################################################################################
# Bewertungsverfahren 6 Preis des Zugangs und Vorgangspreis
# in allen Artikeln
#####################################################################################################################################

@Stammdaten
Scenario: Stammdaten Lagergruppen, Lagerplätze, Lohnfertiger, Beistellung

# Lieferant 1 Währung EUR
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "1"
And I set field "waehr" to "EUR"
And I save the current editor

# Kunde 1 Währung EUR
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "1"
And I set field "waehr" to "EUR"
And I save the current editor

# Konto 11840 mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "STORE" for record "11840"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Lagergruppe Lohnfertiger
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "LOHNF"
And I set field "such" to "LOHNF"
And I set field "namebspr" to "Lohnfertiger"
And I save the current editor

# Konsignationslager Lohnfertiger
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "LOHNF"
And I set field "such" to "LOHNF"
And I set field "namebspr" to "Lohnfertiger"
And I set field "lgruppe" to "LOHNF"
And I set field "disporel" to "JA"
And I save the current editor

# Konsignations-Lagerplatz - Lohnfertiger disporelevant
Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "LOHNF"
And I set field "such" to "LOHNF"
And I set field "namebspr" to "Lohnfertiger"
And I set field "lager" to "LOHNF"
And I save the current editor

# Lohnfertiger
Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "LOHNFERT"
And I set field "such" to "LOHNFERT"
And I set field "namebspr" to "Lohnfertiger"
And I set field "konsi" to "LOHNF"
And I save the current editor

######################################

# Externer Lagerplatz fuer EK Ruecklieferungen
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "EXTERRUE"
And I set field "such" to "EXTERRUE"
And I set field "namebspr" to "Extern Ruecklieferungen EK"
And I save the current editor

# Externer Lagerplatz fuer EK Ruecklieferungen
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "EXTERRUE"
And I set field "such" to "EXTERRUE"
And I set field "namebspr" to "Extern Ruecklieferungen EK"
And I set field "lgruppe" to "EXTERRUE"
# And I set field "disporel" to "JA"
And I save the current editor

# Externer Lagerplatz fuer EK Ruecklieferungen
Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "EXTERRUE"
And I set field "such" to "EXTERRUE"
And I set field "namebspr" to "Extern Ruecklieferungen EK"
And I set field "lager" to "EXTERRUE"
And I save the current editor

######################################

# Lagergruppe Lieferanten Lagerplatz
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "LBEIST"
And I set field "such" to "LBEIST"
And I set field "namebspr" to "LBEISTertiger"
# And I set field "zkonsilg" to "JA"
And I save the current editor

# Konsignationslager Lieferanten Lagerplatz
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "LBEIST"
And I set field "such" to "LBEIST"
And I set field "namebspr" to "Lieferanten Konsi-platz"
And I set field "lgruppe" to "LBEIST"
And I set field "disporel" to "JA"
And I save the current editor

# Lieferanten Lagerplatz
Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "LBEIST"
And I set field "such" to "LBEIST"
And I set field "namebspr" to "Lieferanten Konsi-platz"
And I set field "lager" to "LBEIST"
And I save the current editor

# Lieferant fuer Beistellung
Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "BEISTELL"
And I set field "such" to "BEISTELL"
And I set field "namebspr" to "Lieferanten Konsi-platz"
And I set field "konsi" to "LBEIST"
And I save the current editor

######################################

# Hier jetzt der echt Konsignationslagerplatz und ein lieferant dazu
# Lagergruppe Lieferanten Konsignationslagerplatz
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "LKONSI"
And I set field "such" to "LKONSI"
And I set field "namebspr" to "Lieferanten LAGRP"
And I set field "zkonsilg" to "JA"
And I save the current editor

# Konsignationslager Lieferanten Konsignationslagerplatz
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "LKONSI"
And I set field "such" to "LKONSI"
And I set field "namebspr" to "Lieferanten Konsi-platz"
And I set field "lgruppe" to "LKONSI"
And I set field "disporel" to "JA"
And I save the current editor

# Lieferanten Konsignationslagerplatz
Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "LKONSI"
And I set field "such" to "LKONSI"
And I set field "namebspr" to "Lieferanten Konsi-platz"
And I set field "lager" to "LKONSI"
And I save the current editor

# Lieferant fuer Beistellung
Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "KONSILIE"
And I set field "such" to "KONSILIE"
And I set field "namebspr" to "Lieferanten Konsi-platz"
And I set field "konsi" to "LKONSI"
And I save the current editor

#####################################################################################################################################

# Initiale Materialkostenverbuchung fuer die Startdatum Frage
Given I open an editor "mkv-020" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-020"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
# And I set field "labudat" to "01.01.95"
And I press button "kosvor"
#And I press button "kosbu"
# 5567 ist nur das Fragewort Weiter?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND, DIE HIER ANGEZEIGT WERDEN MUESSEN!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
And I respond with answer "yes" to the dialog with id "5567"
And I save the current editor

#####################################################################################################################################

@FALL-111
Scenario:  FALL-111 EK	Lieferschein

# Konto 111-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0111FALL"
And I set field "such" to "FALL-111"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0111FALL"
And I set field "such" to "FALL-111"
And I set field "bestausekso" to "FALL-111"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "111-FALL"
And I set field "num2" to "111-FALL"
And I set field "such" to "FALL-111"
And I set field "namebspr" to "FALL-111"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-111"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-111" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "111-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-111" in row 1
And I set field "mge" to "111" in row 1
And I set field "preis" to "111" in row 1
And I set field "kenn" to "FALL-111"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "111-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-111" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-111"
And I set field "num4" to "111-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "111" in row 1
And I set field "kenn" to "FALL-111"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "111-LS"
And I close the current editor

#####################################################################################################################################

@FALL-112
Scenario: FALL-112 EK Rechnung ohne Lager

# Konto 112-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0112FALL"
And I set field "such" to "FALL-112"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0112FALL"
And I set field "such" to "FALL-112"
And I set field "bestausekso" to "FALL-112"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "112-FALL"
And I set field "num2" to "112-FALL"
And I set field "such" to "FALL-112"
And I set field "namebspr" to "FALL-112"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-112"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-112" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "112-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-112" in row 1
And I set field "mge" to "112" in row 1
And I set field "preis" to "112" in row 1
And I set field "kenn" to "FALL-112"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "112-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-112" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-112"
And I set field "num4" to "112-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "112" in row 1
And I set field "kenn" to "FALL-112"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "112-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-112" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-112"
And I set field "num4" to "112-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "112" in row 1
And I set field "preis" to "112" in row 1
And I set field "kenn" to "FALL-112"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+112-RE"
And I close the current editor

#####################################################################################################################################

@FALL-113
@persistent
Scenario: FALL-113 EK Rechnung mit Lagerbewegung

# Konto 113-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0113FALL"
And I set field "such" to "FALL-113"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0113FALL"
And I set field "such" to "FALL-113"
And I set field "bestausekso" to "FALL-113"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "113-FALL"
And I set field "num2" to "113-FALL"
And I set field "such" to "FALL-113"
And I set field "namebspr" to "FALL-113"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-113"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-113" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "113-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-113" in row 1
And I set field "mge" to "113" in row 1
And I set field "preis" to "113" in row 1
And I set field "kenn" to "FALL-113"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "113-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-113" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-113"
And I set field "num4" to "113-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "113" in row 1
And I set field "preis" to "113" in row 1
And I set field "kenn" to "FALL-113"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+113-RE"
And I close the current editor

#####################################################################################################################################

@FALL-114
Scenario: FALL-114 EK Lieferung Lohnfertigung

# Konto 114-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0114FALL"
And I set field "such" to "FALL-114"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0114FALL"
And I set field "such" to "FALL-114"
And I set field "bestausekso" to "FALL-114"
And I save the current editor

# Kaufteil FALL-114-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "114-FALL-EK"
And I set field "num2" to "111-FALL-EK"
And I set field "such" to "FALL-114-EK"
And I set field "namebspr" to "Fall 114 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-114"
And I save the current editor

# Lohnfertigung FALL-114-LOH
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "114-FALL-LOH"
And I set field "num2" to "114-FALL-LOH"
And I set field "such" to "FALL-114-LOH"
And I set field "namebspr" to "Fall 114 Lohnfertigung"
And I set field "bsart" to "Lohnfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "LOHNFERT"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# And I set field "elex" to "FALL-114-EK" in row 1
# And I set field "anzahl" to "1" in row 1
# And I set field "bu" to "Lieferantenbeistellung" in row 1
And I set field "ekbewverf" to "6"
And I save the current editor

# Verkaufsteil FALL-114-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "114-FALL-VK"
And I set field "num2" to "114-FALL-VK"
And I set field "such" to "FALL-114-VK"
And I set field "namebspr" to "Fall 114 Verkaufsteil"
And I set field "bsart" to "Eigenfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-114"
And I set field "elex" to "FALL-114-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-114-LOH" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "" in row 2
And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "breite" to "15" in row 3
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-114" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "114-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-114-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-114"
And I save the current editor

# Dispo starten
And I run Scheduling
# Bestellung anlegen
Given I open an editor "bestellung-114" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "114-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-114-EK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
And I set field "kenn" to "FALL-114 Kaufteil"
And I save the current editor

# # Ausgabe Bestellung
# Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "114-BEEK"
# And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-114" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-114"
And I set field "num4" to "114-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "3,30" in row 1
And I set field "kenn" to "FALL-114 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+114-REEK"
And I close the current editor

# Umlagerung Beistellung an Lohnfertiger
And  I open an editor "Umlagern-114" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "LOHNFERT"
And I set field "num4" to "114-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "F1"
And I set field "kenn" to "FALL-114 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-114-EK" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "LOHNF" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+114-UML"
And I close the current editor

# Lohnfertigungsvorschlag freigeben
Given I open an editor "lohv-114" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FALL-114-LOH"
And I press button "ladetab"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "bestellung-loh-114"
And I set field "nummer" to "114-BELO"
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-114"
And I save the current editor
And I switch the current editor to editor "lohv-114"
And I close the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "114-BELO"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-114" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-loh-114"
And I set field "num4" to "114-LSLO"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "kenn" to "FALL-114"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "114-LSLO"
And I close the current editor

#####################################################################################################################################

@FALL-115
Scenario: FALL-115 Neu EK Beistellungen Wir stellen dem Lieferanten etwas bei

# Konto 115-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0115FALL"
And I set field "such" to "FALL-115"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0115FALL"
And I set field "such" to "FALL-115"
And I set field "bestausekso" to "FALL-115"
And I save the current editor

# Kaufteil FALL-115-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "115-FALL-EK"
And I set field "num2" to "115-FALL-EK"
And I set field "such" to "FALL-115-EK"
And I set field "namebspr" to "Fall 115 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-115"
And I save the current editor

# Verkaufsteil FALL-115-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "115-FALL-VK"
And I set field "num2" to "115-FALL-VK"
And I set field "such" to "FALL-115-VK"
And I set field "namebspr" to "Fall 115 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-115"
And I set field "elex" to "FALL-115-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-115" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "115-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-115-VK" in row 1
And I set field "mge" to "115" in row 1
And I set field "preis" to "115" in row 1
And I set field "kenn" to "FALL-115"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-115" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "115-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-115-EK" in row 1
And I set field "mge" to "115" in row 1
And I set field "preis" to "115" in row 1
And I set field "kenn" to "FALL-115 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "115-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-115" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-115"
And I set field "num4" to "115-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "115" in row 1
And I set field "preis" to "115" in row 1
And I set field "kenn" to "FALL-115 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+115-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-115-2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "115-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-115-VK" in row 1
And I set field "mge" to "115" in row 1
And I set field "preis" to "115" in row 1
And I set field "kenn" to "FALL-115 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-115" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "115-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern-115" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "115-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-115 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-115-EK" in row 1
And I set field "mge" to "115" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "115-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-115" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-115-2"
And I set field "num4" to "115-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "115" in row 1
And I set field "kenn" to "FALL-115"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "115-LSEK"
And I close the current editor

#####################################################################################################################################

@FALL-116
Scenario: FALL-116 Neu EK Umlagerungen

# Konto 116-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0116FALL"
And I set field "such" to "FALL-116"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0116FALL"
And I set field "such" to "FALL-116"
And I set field "bestausekso" to "FALL-116"
And I save the current editor

# Umlagerungsteil FALL-116
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "116-FALL"
And I set field "num2" to "116-FALL"
And I set field "such" to "FALL-116"
And I set field "namebspr" to "FALL-116 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-116"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-116" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "116-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-116" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-116"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-116" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "116-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-116" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-116"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "116-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-116" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-116"
And I set field "num4" to "116-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-116"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "116-LSUM"
And I close the current editor

# Umlagerung
And  I open an editor "Umlagern-116" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "116-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-116 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-116" in row 1
And I set field "mge" to "50" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F1" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "umlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "116-UML"
And I close the current editor

#####################################################################################################################################

@FALL-117
Scenario: FALL-117 Kostenumlage auf Lieferschein

# Konto 117-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0117FALL"
And I set field "such" to "FALL-117"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0117FALL"
And I set field "such" to "FALL-117"
And I set field "bestausekso" to "FALL-117"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "117-FALL"
And I set field "num2" to "117-FALL"
And I set field "such" to "FALL-117"
And I set field "namebspr" to "FALL-117"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-117"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-117" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "117-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-117" in row 1
And I set field "mge" to "117" in row 1
And I set field "preis" to "117" in row 1
And I set field "kenn" to "FALL-117"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "117-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-117" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-117"
And I set field "num4" to "117-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "117" in row 1
And I set field "kenn" to "FALL-117"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "117-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-117" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "117-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "117" in row 1
And I set field "konto" to "FALL-117" in row 1
And I set field "kenn" to "FALL-117"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-117" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "117-KM"
And I set field "pos" to "$,,kopf^nummer=117-RE;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=117-LS;artex=FALL-117;@gruppe=2;@datenbank=4;" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+117-KM"
And I close the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+117-RE"
And I close the current editor

#####################################################################################################################################

@FALL-118
Scenario: FALL-118 Kostenumlage auf Rechnung

# Konto 118-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0118FALL"
And I set field "such" to "FALL-118"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0118FALL"
And I set field "such" to "FALL-118"
And I set field "bestausekso" to "FALL-118"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "118-FALL"
And I set field "num2" to "118-FALL"
And I set field "such" to "FALL-118"
And I set field "namebspr" to "FALL-118"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-118"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-118" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "118-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-118" in row 1
And I set field "mge" to "118" in row 1
And I set field "preis" to "118" in row 1
And I set field "kenn" to "FALL-118"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "118-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-118" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-118"
And I set field "num4" to "118-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "118" in row 1
And I set field "kenn" to "FALL-118"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "118-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-118" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-118"
And I set field "num4" to "118-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "118" in row 1
And I set field "preis" to "118" in row 1
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 2
And I set field "pwert" to "117" in row 2
And I set field "konto" to "FALL-118" in row 2
And I set field "kenn" to "FALL-118"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-118" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "118-KM"
And I set field "pos" to "$,,kopf^nummer=118-RE;art=TEXT;@ablageart=(Filed)"
And I press button "ladetab"
And I set field "umlagemeth" to "Wert"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+118-KM"
And I close the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+118-RE"
And I close the current editor

#####################################################################################################################################

@FALL-119
Scenario: FALL-119 Neu EK Rechnung zur Umlagerung Einkauf

# Konto 119-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0119FALL"
And I set field "such" to "FALL-119"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0119FALL"
And I set field "such" to "FALL-119"
And I set field "bestausekso" to "FALL-119"
And I save the current editor

# Umlagerungsteil FALL-119
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "119-FALL"
And I set field "num2" to "119-FALL"
And I set field "such" to "FALL-119"
And I set field "namebspr" to "FALL-119 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-119"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-119" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "119-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-119" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-119"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-119" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "119-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-119" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-119"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "119-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-119" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-119"
And I set field "num4" to "119-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-119"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "119-LSUM"
And I close the current editor

# Umlagerung
And  I open an editor "Umlagern119" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "119-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-119 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-119" in row 1
And I set field "mge" to "50" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F1" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "umlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "119-UML"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-119" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "Umlagern119"
And I set field "num4" to "119-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "preis" to "9,90" in row 1
And I set field "kenn" to "FALL-119 Umlagerung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+119-REEK"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

#####################################################################################################################################

@FALL-131
Scenario: FALL-131 Neu EK Umlagerungsrechnung mit Lagerbewegung

# Konto 131-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0131FALL"
And I set field "such" to "FALL-131"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0131FALL"
And I set field "such" to "FALL-131"
And I set field "bestausekso" to "FALL-131"
And I save the current editor

# Umlagerungsteil FALL-131
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "131-FALL"
And I set field "num2" to "131-FALL"
And I set field "such" to "FALL-131"
And I set field "namebspr" to "FALL-131 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-131"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-131" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "131-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-131" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-131"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-131" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "131-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-131" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-131"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "131-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-131" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-131"
And I set field "num4" to "131-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-131"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Umlagerung
And  I open an editor "Umlagern131" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "131-REUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "fakt" to "ja"
And I set field "kenn" to "FALL-131 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-131" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "9,90" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+131-REUM"
And I close the current editor

#####################################################################################################################################

@FALL-132
Scenario: FALL-132 BE, RE (ohne Lager), LS

# Konto 132-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0132FALL"
And I set field "such" to "FALL-132"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0132FALL"
And I set field "such" to "FALL-132"
And I set field "bestausekso" to "FALL-132"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "132-FALL"
And I set field "num2" to "132-FALL"
And I set field "such" to "FALL-132"
And I set field "namebspr" to "FALL-132"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-132"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-132" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "132-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-132" in row 1
And I set field "mge" to "132" in row 1
And I set field "preis" to "132" in row 1
And I set field "kenn" to "FALL-132"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "132-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-132" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-132"
And I set field "num4" to "132-RE"
And I set field "fakt" to "NEIN"
And I set field "ueb" to "ja"
And I set field "vom" to "."
#
And I set field "konto" to "11840" in row 1
Then field "fixkonto" has value "ja" in row 1
#
And I set field "mge" to "132" in row 1
And I set field "preis" to "132" in row 1
#
Then field "konto" has value "36301" in row 1
Then field "vorgangskonto" has value "11840" in row 1
Then field "fixvorgangskonto" has value "ja" in row 1
#
And I set field "kenn" to "FALL-132"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+132-RE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-132" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-132"
And I set field "num4" to "132-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "132" in row 1
And I set field "kenn" to "FALL-132"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+132-LS"
And I close the current editor

# Ausgleich des Anzahlungs-Kontos
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "FALL-132"
And I set field "beleg" to "FALL-132"
And I create a new row at the end of the table
And I set field "konto" to "11840" in row 1
And I set field "ewhbetr" to "17424" in row 1
And I create a new row at the end of the table
And I set field "konto" to "FALL-132" in row 2
And I set field "ewsbetr" to "17424" in row 2
And I respond with answer "JA" to the dialog with id "583"
And I save the current editor

# AB 11.09.2018
# Jetzt gibt es aber eine Differenz zwischen Lagerbestand Bewertung und Konto
#

#####################################################################################################################################

@FALL-133
Scenario: FALL-133 Neu EK Rechnung zur Umlagerung und Lieferschein

# Konto 133-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0133FALL"
And I set field "such" to "FALL-133"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0133FALL"
And I set field "such" to "FALL-133"
And I set field "bestausekso" to "FALL-133"
And I save the current editor

# Umlagerungsteil FALL-133
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "133-FALL"
And I set field "num2" to "133-FALL"
And I set field "such" to "FALL-133"
And I set field "namebspr" to "FALL-133 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-133"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-133" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "133-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-133" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-133"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-133" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "133-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-133" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-133"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "133-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-133" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-133"
And I set field "num4" to "133-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-133"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "133-LSUM"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-133" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-133"
And I set field "num4" to "133-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "preis" to "7,70" in row 1
And I set field "kenn" to "FALL-133 Rechnung Einkauf"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+133-REEK"
And I close the current editor

# Umlagerung
And  I open an editor "Umlagern133" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "133-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-133 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-133" in row 1
And I set field "mge" to "50" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F1" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "umlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "133-UML"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-133" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "Umlagern133"
And I set field "num4" to "133-REUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "preis" to "9,90" in row 1
And I set field "kenn" to "FALL-133 Rechnung zu Umlagerung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+133-REEK"
And I close the current editor

#####################################################################################################################################

@FALL-134
Scenario: FALL-134 Storno EK Rechnung mit Kostenverteiler

# Konto 134-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0134FALL"
And I set field "such" to "FALL-134"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0134FALL"
And I set field "such" to "FALL-134"
And I set field "bestausekso" to "FALL-134"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "134-FALL"
And I set field "num2" to "134-FALL"
And I set field "such" to "FALL-134"
And I set field "namebspr" to "FALL-134"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-134"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Zusatzposition VERPACKUNG
Given I open an editor "zusatzp" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "134-VERP"
And I set field "such" to "VERP-134"
And I set field "name" to "Verpakungskosten"
And I save the current editor

# Kostenstellen anlegen
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "134A-FAL"
And I set field "such" to "Fall-134A"
And I set field "name" to "Fall 134 Kostenstelle A"
And I save the current editor
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "134B-FAL"
And I set field "such" to "Fall-134B"
And I set field "name" to "Fall 134 Kostenstelle B"
And I save the current editor

# Kostenverteiler anlegen
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I delete all rows
And I set field "nummer" to "134-KV"
And I set field "such" to "Fall-134"
And I create a new row at the end of the table
And I set field "kstelle" to "134A-FAL" in row 1
And I set field "proz" to "41" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "134B-FAL" in row 2
And I set field "proz" to "59" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-134" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "134-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-134" in row 1
And I set field "mge" to "134" in row 1
And I set field "preis" to "134" in row 1
And I set field "kenn" to "FALL-134"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "134-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-134" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-134"
And I set field "num4" to "134-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "134" in row 1
And I set field "kenn" to "FALL-134"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "134-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-134" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-134"
And I set field "num4" to "134-RE"
And I set field "vom" to "."
And I set field "mge" to "134" in row 1
And I set field "preis" to "134" in row 1
And I create a new row at the end of the table
And I set field "artex" to "134-VERP" in row 2
And I set field "pwert" to "1134" in row 2
And I set field "kstelle" to "134-KV" in row 2
# And I press button "dynkst" to open a subeditor for "Kostenverteiler"
# And I switch the current editor to editor "rechnung-134"
And I set field "ueb" to "ja"
And I set field "kenn" to "FALL-134"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+134-RE"
And I close the current editor

#####################################################################################################################################

@FALL-135
Scenario: FALL-135 Neu EK Anzahlungsrechnung

# Konto 135-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0135FALL"
And I set field "such" to "FALL-135"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0135FALL"
And I set field "such" to "FALL-135"
And I set field "bestausekso" to "FALL-135"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "135-FALL"
And I set field "num2" to "135-FALL"
And I set field "such" to "FALL-135"
And I set field "namebspr" to "FALL-135"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-135"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-135" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "135-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-135" in row 1
And I set field "mge" to "135" in row 1
And I set field "preis" to "135" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
And I set field "kenn" to "FALL-135"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "135-BE"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-135" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "bestellung-135"
And I set field "num4" to "135-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-135"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+135-AR"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-135" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-135"
And I set field "num4" to "135-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "135" in row 1
And I set field "kenn" to "FALL-135"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "135-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-135" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-135"
And I set field "num4" to "135-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "135" in row 1
And I set field "preis" to "135" in row 1
And I set field "kenn" to "FALL-135"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+135-RE"
And I close the current editor

#####################################################################################################################################

@FALL-136
Scenario:  FALL-136 Neu EK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ

# Konto 136-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0136FALL"
And I set field "such" to "FALL-136"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0136FALL"
And I set field "such" to "FALL-136"
And I set field "bestausekso" to "FALL-136"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "136A-FALL"
And I set field "num2" to "136A-FALL"
And I set field "such" to "FALL-136A"
And I set field "namebspr" to "FALL-136A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-136"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "136B-FALL"
And I set field "num2" to "136B-FALL"
And I set field "such" to "FALL-136B"
And I set field "namebspr" to "FALL-136B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-136"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "136V-FALL"
And I set field "num2" to "136V-FALL"
And I set field "such" to "FALL-136V"
And I set field "namebspr" to "FALL-136V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-136"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "136E-FALL"
And I set field "num2" to "136E-FALL"
And I set field "such" to "FALL-136E"
And I set field "namebspr" to "FALL-136E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-136"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "136M-FALL"
And I set field "num2" to "136M-FALL"
And I set field "such" to "FALL-136M"
And I set field "namebspr" to "FALL-136M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-136"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "136R-FALL"
And I set field "num2" to "136R-FALL"
And I set field "such" to "FALL-136R"
And I set field "namebspr" to "FALL-136R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-136"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-136" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "136-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-136A" in row 1
And I set field "mge" to "136" in row 1
And I set field "preis" to "136" in row 1
And I set field "verw" to "FALL136A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-136B" in row 2
And I set field "mge" to "136" in row 2
And I set field "preis" to "136" in row 2
And I set field "verw" to "FALL136B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-136V" in row 3
And I set field "mge" to "136" in row 3
And I set field "preis" to "136" in row 3
And I set field "verw" to "FALL136V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-136E" in row 4
And I set field "mge" to "136" in row 4
And I set field "preis" to "136" in row 4
And I set field "verw" to "FALL136E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-136M" in row 5
And I set field "mge" to "136" in row 5
And I set field "preis" to "136" in row 5
And I set field "verw" to "FALL136M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-136R" in row 6
And I set field "mge" to "136" in row 6
And I set field "preis" to "136" in row 6
And I set field "verw" to "FALL136R" in row 6

And I set field "kenn" to "FALL-136"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "136-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-136" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-136"
And I set field "num4" to "136-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "136" in row 1
And I set field "mge" to "136" in row 2
And I set field "mge" to "136" in row 3
And I set field "mge" to "136" in row 4
And I set field "mge" to "136" in row 5
And I set field "mge" to "136" in row 6
And I set field "kenn" to "FALL-136"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "136-LS"
And I close the current editor

#####################################################################################################################################

@FALL-137
Scenario:  FALL-137
# Neu	EK	Lieferschein mit allen Zusatzpositions-Typen

# Konto 137-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0137FALL"
And I set field "such" to "FALL-137"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0137FALL"
And I set field "such" to "FALL-137"
And I set field "bestausekso" to "FALL-137"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "137-FALL-ART"
And I set field "num2" to "137-FALL-ART"
And I set field "such" to "FALL-137-ART"
And I set field "namebspr" to "FALL-137"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-137"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

Scenario Outline: FALL-137-ZP
# Zusatzpositionen
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such2>"
And I set field "num2" to "<num2>"
And I set field "such" to "<such2>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "kategorie" to "<kategorie>"
And I save the current editor

Examples:
 |num2           | such2            | namebspr                          |zptyp                          |kategorie      |
 |137-FALL-L     | FALL-137-L       | FALL-137 LEER                     |                               |               |
 |137-FALL-AS    | FALL-137-AS      | FALL-137 Absatz                   |Absatz                         |               |
 |137-FALL-ES    | FALL-137-ES      | FALL-137 Endsumme                 |Endsumme                       |               |
 |137-FALL-GS    | FALL-137-GS      | FALL-137 Gesamtsumme              |Gesamtsumme                    |               |
 |137-FALL-MB    | FALL-137-MB      | FALL-137 Mindest bwp              |Mindestbestellwertposition     |               |
 |137-FALL-PP    | FALL-137-PP      | FALL-137 Prozentposition          |Prozentposition                |               |
 |137-FALL-ST    | FALL-137-ST      | FALL-137 Seite                    |Seite                          |               |
 |137-FALL-TP    | FALL-137-TP      | FALL-137 Trennposition            |Trennposition                  |               |
 |137-FALL-TX    | FALL-137-TX      | FALL-137 Text                     |Text                           |               |
 |137-FALL-ZS    | FALL-137-ZS      | FALL-137 Zwischensumme            |Zwischensumme                  |               |
 |137-FALL-AUD   | FALL-137-AUD     | FALL-137 AU-BE Pos Kategorie Die  |AU/BE-Position,BV              |Dienstleistung |
 |137-FALL-AUL   | FALL-137-AUL     | FALL-137 AU-BE Pos Kategorie Lee  |AU/BE-Position,BV              |               |
 |137-FALL-MTZ   | FALL-137-MTZ     | FALL-137 Materialzuschlag         |Materialzuschlag               |               |
 |137-FALL-NPA   | FALL-137-NPA     | FALL-137 neutrale Position ANZ    |neutrale Position              |Anzahlung      |
 |137-FALL-NPD   | FALL-137-NPD     | FALL-137 neutrale Position DL     |neutrale Position              |Dienstleistung |
 |137-FALL-NPG   | FALL-137-NPG     | FALL-137 neutrale Position G      |neutrale Position              |Gutschein      |
 |137-FALL-NPL   | FALL-137-NPL     | FALL-137 neutrale Position Leer   |neutrale Position              |               |
 |137-FALL-NSP   | FALL-137-NSP     | FALL-137 Nettosummenposition      |Nettosummenposition            |               |
 |137-FALL-UVI   | FALL-137-UVI     | FALL-137 USt/VSt-Position inkl    |USt/VSt-Position (inklusive)   |               |
 |137-FALL-UVZ   | FALL-137-UVZ     | FALL-137 USt/VSt-Position zuzu    |USt/VSt-Position (zuzüglich)   |               |

Scenario: FALL-137-BE
# Bestellung anlegen
Given I open an editor "bestellung-137" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
        | lief         | 1       |
        | num4         | 137-BE  |
        | kenn         | FALL-137|
And I append rows
        | artex         | mge             |  preis             | proz         | pwert           | konto          |
        |137-FALL-ART   | 137             |  137               | !dontChange  | !dontChange     | 0137FALL       |
        |137-FALL-L     | !dontChange     |  !dontChange       | !dontChange  | 137             | 0137FALL       |
        |137-FALL-AS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |137-FALL-ES    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |137-FALL-GS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |137-FALL-MB    | !dontChange     |  137               | !dontChange  | !dontChange     | 0137FALL       |
        |137-FALL-PP    | !dontChange     |  !dontChange       | 137          | !dontChange     | 0137FALL       |
        |137-FALL-ST    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |137-FALL-TP    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |137-FALL-TX    | !dontChange     |  !dontChange       | !dontChange  | 137             | 0137FALL       |
        |137-FALL-ZS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |137-FALL-AUD   | 137             |  137               | !dontChange  | !dontChange     | 0137FALL       |
        |137-FALL-AUL   | 137             |  137               | !dontChange  | !dontChange     | 0137FALL       |
        |137-FALL-MTZ   | !dontChange     |  137               | !dontChange  | !dontChange     | 0137FALL       |
        |137-FALL-NPA   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 0137FALL       |
        |137-FALL-NPD   | !dontChange     |  !dontChange       | !dontChange  | 137             | 0137FALL       |
        |137-FALL-NPG   | !dontChange     |  !dontChange       | !dontChange  | 137             | 0137FALL       |
        |137-FALL-NPL   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 0137FALL       |
        |137-FALL-NSP   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |137-FALL-UVZ   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
# |19   |137-FALL-UVI   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
And I save the current editor

# Scenario: FALL-137-BEAUS
# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "137-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-137" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-137"
And I set field "num4" to "137-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "137" in row 1
And I set field "kenn" to "FALL-137"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "137-LS"
And I close the current editor

#####################################################################################################################################

@FALL-177
Scenario: FALL-177 Storno EK Umgelegte Rechnung an der eine Kostenumlage hängt

# Konto 177-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0177FALL"
And I set field "such" to "FALL-177"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0177FALL"
And I set field "such" to "FALL-177"
And I set field "bestausekso" to "FALL-177"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "177-FALL"
And I set field "num2" to "177-FALL"
And I set field "such" to "FALL-177"
And I set field "namebspr" to "FALL-177"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-177"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-177" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "177-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-177" in row 1
And I set field "mge" to "177" in row 1
And I set field "preis" to "177" in row 1
And I set field "kenn" to "FALL-177"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "177-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-177" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-177"
And I set field "num4" to "177-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "177" in row 1
And I set field "kenn" to "FALL-177"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "177-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-177" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "177-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1770" in row 1
And I set field "konto" to "FALL-177" in row 1
And I set field "kenn" to "FALL-177"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Kostenumlage erzeugen
Given I open an editor "kostenuml-177" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "177-KM"
And I set field "pos" to "$,,kopf^nummer=177-RE;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=177-LS;artex=FALL-177;@gruppe=2;@datenbank=4;" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+117-KM"
And I close the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+177-RE"
And I close the current editor

# Kostenumlage stornieren
Given I open an editor "kostenuml2" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+177-KM"
And I set field "num135" to "177-STKM"
And I save the current editor

# Storno Rechnung
Given I open an editor "rechnung-177" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+177-RE"
And I set field "num4" to "177-STRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+177-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-188
Scenario: FALL-188 Storno EK des Lieferscheins, auf den eine Kostenumlage zeigt

# Konto 188-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0188FALL"
And I set field "such" to "FALL-188"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0188FALL"
And I set field "such" to "FALL-188"
And I set field "bestausekso" to "FALL-188"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "188-FALL"
And I set field "num2" to "188-FALL"
And I set field "such" to "FALL-188"
And I set field "namebspr" to "FALL-188"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-188"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-188" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "188-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-188" in row 1
And I set field "mge" to "188" in row 1
And I set field "preis" to "188" in row 1
And I set field "kenn" to "FALL-188"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "188-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-188" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-188"
And I set field "num4" to "188-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "188" in row 1
And I set field "kenn" to "FALL-188"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "188-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-188" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "188-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "188" in row 1
And I set field "konto" to "FALL-188" in row 1
And I set field "kenn" to "FALL-188"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-188" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "188-KM"
And I set field "pos" to "$,,kopf^nummer=188-RE;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=188-LS;artex=FALL-188;@gruppe=2;@datenbank=4;" in row 1
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+188-KM"
And I close the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+188-RE"
And I close the current editor

# Lieferschein kann wegen der Kostenumlage "188-KM"  nicht storniert werden. Bitte zuerst dieses Objekt stornieren.
# Storno Lieferschein auch nicht erlaubt
And opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-188" throws the exception "3335"

#####################################################################################################################################

@FALL-199
Scenario: FALL-199 Storno EK der Rechnung, auf die eine Kostenumlage zeigt

# Konto 199-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0199FALL"
And I set field "such" to "FALL-199"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0199FALL"
And I set field "such" to "FALL-199"
And I set field "bestausekso" to "FALL-199"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "199-FALL"
And I set field "num2" to "199-FALL"
And I set field "such" to "FALL-199"
And I set field "namebspr" to "FALL-199"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-199"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-199" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "199-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-199" in row 1
And I set field "mge" to "199" in row 1
And I set field "preis" to "199" in row 1
And I set field "kenn" to "FALL-199"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "199-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-199" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-199"
And I set field "num4" to "199-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "199" in row 1
And I set field "kenn" to "FALL-199"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "199-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-199" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-199"
And I set field "num4" to "199-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-199"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rechnung fur Kostenumlage anlegen
Given I open an editor "rechnung-199" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "199-REKM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "199" in row 1
And I set field "konto" to "FALL-199" in row 1
And I set field "kenn" to "FALL-199"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Kostenumlage erzeugen
Given I open an editor "kostenuml-199" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "199-KM"
And I set field "pos" to "$,,kopf^nummer=199-REKM;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=199-RE;artex=FALL-199;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+199-KM"
And I close the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+199-RE"
And I close the current editor

# Kostenumlage muesste storniert werden müssen
# Storno Rechnung
And opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+199-RE" throws the exception "3335"
And I close the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

#####################################################################################################################################

@FALL-211
Scenario:  FALL-211 Storno EK Lieferschein

# Konto 211-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0211FALL"
And I set field "such" to "FALL-211"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0211FALL"
And I set field "such" to "FALL-211"
And I set field "bestausekso" to "FALL-211"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "211-FALL"
And I set field "num2" to "211-FALL"
And I set field "such" to "FALL-211"
And I set field "namebspr" to "FALL-211"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-211"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-211" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "211-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-211" in row 1
And I set field "mge" to "211" in row 1
And I set field "preis" to "211" in row 1
And I set field "kenn" to "FALL-211"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "211-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-211" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-211"
And I set field "num4" to "211-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "211" in row 1
And I set field "kenn" to "FALL-211"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "211-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "211-LS"
And I set field "num4" to "211-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+211-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-212
Scenario: FALL-212 Storno EK Rechnung mit Lagerbewegung

# Konto 212-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0212FALL"
And I set field "such" to "FALL-212"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0212FALL"
And I set field "such" to "FALL-212"
And I set field "bestausekso" to "FALL-212"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "212-FALL"
And I set field "num2" to "212-FALL"
And I set field "such" to "FALL-212"
And I set field "namebspr" to "FALL-212"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-212"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-212" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "212-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-212" in row 1
And I set field "mge" to "212" in row 1
And I set field "preis" to "212" in row 1
And I set field "kenn" to "FALL-212"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "212-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-212" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-212"
And I set field "num4" to "212-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "212" in row 1
And I set field "preis" to "212" in row 1
And I set field "kenn" to "FALL-212"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+212-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-212" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+212-RE"
And I set field "num4" to "212-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+212-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-213
Scenario: FALL-213 Storno EK Rechnung (ohne Lager)

# Konto 213-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0213FALL"
And I set field "such" to "FALL-213"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0213FALL"
And I set field "such" to "FALL-213"
And I set field "bestausekso" to "FALL-213"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "213-FALL"
And I set field "num2" to "213-FALL"
And I set field "such" to "FALL-213"
And I set field "namebspr" to "FALL-213"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-213"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-213" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "213-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-213" in row 1
And I set field "mge" to "213" in row 1
And I set field "preis" to "213" in row 1
And I set field "kenn" to "FALL-213"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "213-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-213" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-213"
And I set field "num4" to "213-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "213" in row 1
And I set field "kenn" to "FALL-213"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "213-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-213" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-213"
And I set field "num4" to "213-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "213" in row 1
And I set field "preis" to "213" in row 1
And I set field "kenn" to "FALL-213"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+213-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-213" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+213-RE"
And I set field "num4" to "213-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+213-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-224
Scenario: FALL-224 Storno EK Rechnung (ohne Lager)

# Konto 224-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0224FALL"
And I set field "such" to "FALL-224"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0224FALL"
And I set field "such" to "FALL-224"
And I set field "bestausekso" to "FALL-224"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "224-FALL"
And I set field "num2" to "224-FALL"
And I set field "such" to "FALL-224"
And I set field "namebspr" to "FALL-224"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-224"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-224" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "224-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-224" in row 1
And I set field "mge" to "224" in row 1
And I set field "preis" to "224" in row 1
And I set field "kenn" to "FALL-224"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "224-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-224" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-224"
And I set field "num4" to "224-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "224" in row 1
And I set field "kenn" to "FALL-224"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "224-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-224" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-224"
And I set field "num4" to "224-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "224" in row 1
And I set field "preis" to "2240" in row 1
And I set field "kenn" to "FALL-224"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+224-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-224" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+224-RE"
And I set field "num4" to "224-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+224-STRE"
And I close the current editor

# Neue Rechnung anlegen
Given I open an editor "rechnung-224" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-224"
And I set field "num4" to "224-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "224" in row 1
And I set field "preis" to "224" in row 1
And I set field "kenn" to "FALL-224"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+224-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-214
Scenario: FALL-214 Storno EK Lieferung Lohnfertigung

# Konto 214-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0214FALL"
And I set field "such" to "FALL-214"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0214FALL"
And I set field "such" to "FALL-214"
And I set field "bestausekso" to "FALL-214"
And I save the current editor

# Kaufteil FALL-214-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "214-FALL-EK"
And I set field "num2" to "214-FALL-EK"
And I set field "such" to "FALL-214-EK"
And I set field "namebspr" to "Fall 214 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-214"
And I save the current editor

# Lohnfertigung FALL-214-LOH
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "214-FALL-LOH"
And I set field "num2" to "214-FALL-LOH"
And I set field "such" to "FALL-214-LOH"
And I set field "namebspr" to "Fall 214 Lohnfertigung"
And I set field "bsart" to "Lohnfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "LOHNFERT"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
# And I set field "elex" to "FALL-214-EK" in row 1
# And I set field "anzahl" to "1" in row 1
# And I set field "bu" to "Lieferantenbeistellung" in row 1
And I save the current editor

# Verkaufsteil FALL-214-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "214-FALL-VK"
And I set field "num2" to "214-FALL-VK"
And I set field "such" to "FALL-214-VK"
And I set field "namebspr" to "Fall 214 Verkaufsteil"
And I set field "bsart" to "Eigenfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-214"
And I set field "elex" to "FALL-214-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-214-LOH" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "" in row 2
And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "breite" to "15" in row 3
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-214" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "214-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-214-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-214"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-214" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "214-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-214-EK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
And I set field "kenn" to "FALL-214 Kaufteil"
And I save the current editor

# # Ausgabe Bestellung
# Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "214-BEEK"
# And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-214" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-214"
And I set field "num4" to "214-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "3,30" in row 1
And I set field "kenn" to "FALL-214 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+214-REEK"
And I close the current editor

# Umlagerung Beistellung an Lohnfertiger
And  I open an editor "Umlagern214" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "LOHNFERT"
And I set field "num4" to "214-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "F1"
And I set field "kenn" to "FALL-214 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-214-EK" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "LOHNF" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+214-UML"
And I close the current editor

# Lohnfertigungsvorschlag freigeben
Given I open an editor "lohv-214" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FALL-214-LOH"
And I press button "ladetab"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "bestellung-loh-214"
And I set field "nummer" to "214-BELO"
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-214"
And I save the current editor
And I switch the current editor to editor "lohv-214"
And I close the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "214-BELO"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-214" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-loh-214"
And I set field "num4" to "214-LSLO"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "kenn" to "FALL-214"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "214-LSLO"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "214-LSLO"
And I set field "num4" to "214-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+214-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-215
Scenario: FALL-215 Storno EK Beistellungen Wir stellen dem Lieferanten etwas bei

# Konto 215-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0215FALL"
And I set field "such" to "FALL-215"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0215FALL"
And I set field "such" to "FALL-215"
And I set field "bestausekso" to "FALL-215"
And I save the current editor

# Kaufteil FALL-215-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "215-FALL-EK"
And I set field "num2" to "215-FALL-EK"
And I set field "such" to "FALL-215-EK"
And I set field "namebspr" to "Fall 215 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-215"
And I save the current editor

# Verkaufsteil FALL-215-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "215-FALL-VK"
And I set field "num2" to "215-FALL-VK"
And I set field "such" to "FALL-215-VK"
And I set field "namebspr" to "Fall 215 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-215"
And I set field "elex" to "FALL-215-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-215" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "215-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-215-VK" in row 1
And I set field "mge" to "215" in row 1
And I set field "preis" to "215" in row 1
And I set field "kenn" to "FALL-215"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-215" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "215-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-215-EK" in row 1
And I set field "mge" to "215" in row 1
And I set field "preis" to "215" in row 1
And I set field "kenn" to "FALL-215 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "215-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-215" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-215"
And I set field "num4" to "215-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "215" in row 1
And I set field "preis" to "215" in row 1
And I set field "kenn" to "FALL-215 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+215-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-215" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "215-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-215-VK" in row 1
And I set field "mge" to "215" in row 1
And I set field "preis" to "215" in row 1
And I set field "kenn" to "FALL-215 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-215" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "215-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern215" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "215-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-215 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-215-EK" in row 1
And I set field "mge" to "215" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "215-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-215" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-215"
And I set field "num4" to "215-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "215" in row 1
And I set field "kenn" to "FALL-215"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "215-LSEK"
And I close the current editor

# Storno Umlagerung
Given I open an editor "stUmlagerung" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-215"
And I set field "num4" to "215-STLS"
And I save the current editor

# Ausgabe Storno Umlagerung
Given I open an editor "stUmlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+215-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-216
Scenario: FALL-216 Storno EK Umlagerungen

# Konto 216-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0216FALL"
And I set field "such" to "FALL-216"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0216FALL"
And I set field "such" to "FALL-216"
And I set field "bestausekso" to "FALL-216"
And I save the current editor

# Umlagerungsteil FALL-216
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "216-FALL"
And I set field "num2" to "216-FALL"
And I set field "such" to "FALL-216"
And I set field "namebspr" to "FALL-216 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-216"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-216" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "216-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-216" in row 1
And I set field "mge" to "216" in row 1
And I set field "preis" to "432" in row 1
And I set field "kenn" to "FALL-216"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-216" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "216-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-216" in row 1
And I set field "mge" to "216" in row 1
And I set field "preis" to "216" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-216"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "216-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-216" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-216"
And I set field "num4" to "216-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "216" in row 1
And I set field "kenn" to "FALL-216"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "216-LSUM"
And I close the current editor

# Umlagerung
And  I open an editor "Umlagern216" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "216-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-216 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-216" in row 1
And I set field "mge" to "216" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "umlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "216-UML"
And I close the current editor

# Storno Umlagerung
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "216-UML"
And I set field "num4" to "216-STUM"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+216-STUM"
And I close the current editor

#####################################################################################################################################

@FALL-217
Scenario:  FALL-217 Storno EK Lieferschein mit Materialzuordnung

# Konto 217-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0217FALL"
And I set field "such" to "FALL-217"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0217FALL"
And I set field "such" to "FALL-217"
And I set field "bestausekso" to "FALL-217"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "217-FALL"
And I set field "num2" to "217-FALL"
And I set field "such" to "FALL-217"
And I set field "namebspr" to "FALL-217"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-217"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-217"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-217" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "217-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-217" in row 1
And I set field "mge" to "217" in row 1
And I set field "preis" to "217" in row 1
And I set field "kenn" to "FALL-217"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "217-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-217" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-217"
And I set field "num4" to "217-LS"
# And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "217" in row 1
And I set field "kenn" to "FALL-217"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "55" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "45" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "57" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "60" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-217"
And I set field "ueb" to "JA"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "217-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "217-LS"
And I set field "num4" to "217-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+217-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-218
@persistent
Scenario: FALL-218 Storno EK Rechnung mit Lager mit Materialzuordnung

# Konto 218-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0218FALL"
And I set field "such" to "FALL-218"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0218FALL"
And I set field "such" to "FALL-218"
And I set field "bestausekso" to "FALL-218"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "218-FALL"
And I set field "num2" to "218-FALL"
And I set field "such" to "FALL-218"
And I set field "namebspr" to "FALL-218"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-218"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-218"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-218" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "218-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-218" in row 1
And I set field "mge" to "218" in row 1
And I set field "preis" to "218" in row 1
And I set field "kenn" to "FALL-218"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "218-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-218" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-218"
And I set field "num4" to "218-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "218" in row 1
And I set field "preis" to "218" in row 1
And I set field "kenn" to "FALL-218"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "55" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "45" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "58" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "60" in row 4
And I save the current editor
And I switch the current editor to editor "rechnung-218"
And I set field "ueb" to "JA"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+218-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "Rechnung-218" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+218-RE"
And I set field "num4" to "218-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+218-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-219
Scenario: FALL-219 Storno EK Umlagerungsrechnung Einkauf

# Konto 219-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0219FALL"
And I set field "such" to "FALL-219"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0219FALL"
And I set field "such" to "FALL-219"
And I set field "bestausekso" to "FALL-219"
And I save the current editor

# Umlagerungsteil FALL-219
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "219-FALL"
And I set field "num2" to "219-FALL"
And I set field "such" to "FALL-219"
And I set field "namebspr" to "FALL-219 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "219"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-219"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-219" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "219-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-219" in row 1
And I set field "mge" to "219" in row 1
And I set field "preis" to "219" in row 1
And I set field "kenn" to "FALL-219"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-219" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "219-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-219" in row 1
And I set field "mge" to "219" in row 1
And I set field "preis" to "219" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-219"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "219-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-219" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-219"
And I set field "num4" to "219-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "219" in row 1
And I set field "kenn" to "FALL-219"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "219-LS"
And I close the current editor

# Umlagerung
And  I open an editor "Umlagern219" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "219-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-219 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-219" in row 1
And I set field "mge" to "219" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "umlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "219-UML"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-219" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "Umlagern219"
And I set field "num4" to "219-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "219" in row 1
And I set field "preis" to "9,90" in row 1
And I set field "kenn" to "FALL-219 Umlagerung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+219-REEK"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-219" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+219-REEK"
And I set field "num4" to "219-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+219-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-231
Scenario: FALL-231 Rücklieferung EK Umlagerungsrechnung mit Lagerbewegung Einkauf

# Konto 231-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0231FALL"
And I set field "such" to "FALL-231"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0231FALL"
And I set field "such" to "FALL-231"
And I set field "bestausekso" to "FALL-231"
And I save the current editor

# Umlagerungsteil FALL-231
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "231-FALL"
And I set field "num2" to "231-FALL"
And I set field "such" to "FALL-231"
And I set field "namebspr" to "FALL-231 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-231"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-231" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "231-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-231" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-231"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-231" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "231-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-231" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-231"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "231-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-231" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-231"
And I set field "num4" to "231-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-231"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Umlagerung
And  I open an editor "Umlagern231" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "231-REUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "fakt" to "ja"
And I set field "kenn" to "FALL-231 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-231" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "9,90" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "abplatz" to "F1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+231-REUM"
And I close the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Storno Rechnung
Given I open an editor "rechnung-231" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+231-REUM"
And I set field "num4" to "231-STRU"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+231-STRU"
And I close the current editor

#####################################################################################################################################

@FALL-232
Scenario: FALL-232 Storno EK BE, RE (ohne Lager), LS, Storno LS

# Konto 232-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0232FALL"
And I set field "such" to "FALL-232"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0232FALL"
And I set field "such" to "FALL-232"
And I set field "bestausekso" to "FALL-232"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "232-FALL"
And I set field "num2" to "232-FALL"
And I set field "such" to "FALL-232"
And I set field "namebspr" to "FALL-232"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-232"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-232"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-232" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "232-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-232" in row 1
And I set field "mge" to "232" in row 1
And I set field "preis" to "232" in row 1
And I set field "kenn" to "FALL-232"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "232-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-232" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-232"
And I set field "num4" to "232-RE"
And I set field "fakt" to "NEIN"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "232" in row 1
And I set field "preis" to "232" in row 1
# And I set field "konto" to "11840" in row 1
And I set field "kenn" to "FALL-232"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+232-RE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-232" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-232"
And I set field "num4" to "232-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "232" in row 1
And I set field "kenn" to "FALL-232"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+232-LS"
And I close the current editor

# Storno Rechnung
Given I open an editor "Rechnung-232" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+232-RE"
And I set field "num4" to "232-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rechnung
Given I open an editor "Rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+232-STRE"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+232-LS"
And I set field "num4" to "232-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+232-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-233
Scenario: FALL-233 Storno EK BE, RE (ohne Lager), LS, Storno RE

# Konto 233-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0233FALL"
And I set field "such" to "FALL-233"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0233FALL"
And I set field "such" to "FALL-233"
And I set field "bestausekso" to "FALL-233"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "233-FALL"
And I set field "num2" to "233-FALL"
And I set field "such" to "FALL-233"
And I set field "namebspr" to "FALL-233"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-233"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-233"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-233" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "233-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-233" in row 1
And I set field "mge" to "233" in row 1
And I set field "preis" to "233" in row 1
And I set field "kenn" to "FALL-233"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "233-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-233" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-233"
And I set field "num4" to "233-RE"
And I set field "fakt" to "NEIN"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "233" in row 1
And I set field "preis" to "233" in row 1
And I set field "kenn" to "FALL-233"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+233-RE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-233" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-233"
And I set field "num4" to "233-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "233" in row 1
And I set field "kenn" to "FALL-233"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+233-LS"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-233" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+233-RE"
And I set field "num4" to "233-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+233-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-234
Scenario: FALL-234 Storno EK Rechnung mit Kostenverteiler

# Konto 234-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0234FALL"
And I set field "such" to "FALL-234"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0234FALL"
And I set field "such" to "FALL-234"
And I set field "bestausekso" to "FALL-234"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "234-FALL"
And I set field "num2" to "234-FALL"
And I set field "such" to "FALL-234"
And I set field "namebspr" to "FALL-234"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-234"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-234"
# Maybe more
And I save the current editor

# Zusatzposition VERPACKUNG
Given I open an editor "zusatzp" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "234-VERP"
And I set field "such" to "VERP-234"
And I set field "name" to "Verpakungskosten"
And I save the current editor

# Kostenstellen anlegen
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "234A-FAL"
And I set field "such" to "Fall-234A"
And I set field "name" to "Fall 234 Kostenstelle A"
And I save the current editor
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "234B-FAL"
And I set field "such" to "Fall-234B"
And I set field "name" to "Fall 234 Kostenstelle B"
And I save the current editor

# Kostenverteiler anlegen
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I delete all rows
And I set field "nummer" to "234-KV"
And I set field "such" to "Fall-234"
And I create a new row at the end of the table
And I set field "kstelle" to "234A-FAL" in row 1
And I set field "proz" to "41" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "234B-FAL" in row 2
And I set field "proz" to "59" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-234" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "234-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-234" in row 1
And I set field "mge" to "234" in row 1
And I set field "preis" to "234" in row 1
And I set field "kenn" to "FALL-234"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "234-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-234" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-234"
And I set field "num4" to "234-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "234" in row 1
And I set field "kenn" to "FALL-234"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "234-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-234" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-234"
And I set field "num4" to "234-RE"
And I set field "vom" to "."
And I set field "mge" to "234" in row 1
And I set field "preis" to "234" in row 1
And I create a new row at the end of the table
And I set field "artex" to "234-VERP" in row 2
And I set field "pwert" to "10234" in row 2
And I set field "kstelle" to "234-KV" in row 2
# And I press button "dynkst" to open a subeditor for "Kostenverteiler"
# And I switch the current editor to editor "rechnung-234"
And I set field "ueb" to "ja"
And I set field "kenn" to "FALL-234"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+234-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-234" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+234-RE"
And I set field "num4" to "234-STRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+234-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-235
Scenario: FALL-235 Storno EK Anzahlungsrechnung

# Konto 235-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0235FALL"
And I set field "such" to "FALL-235"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0235FALL"
And I set field "such" to "FALL-235"
And I set field "bestausekso" to "FALL-235"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "235-FALL"
And I set field "num2" to "235-FALL"
And I set field "such" to "FALL-235"
And I set field "namebspr" to "FALL-235"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-235"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-235"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-235" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "235-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-235" in row 1
And I set field "mge" to "235" in row 1
And I set field "preis" to "235" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
And I set field "kenn" to "FALL-235"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "235-BE"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-235" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "bestellung-235"
And I set field "num4" to "235-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-235"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+235-AR"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-235" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-235"
And I set field "num4" to "235-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "235" in row 1
And I set field "kenn" to "FALL-235"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "235-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-235" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-235"
And I set field "num4" to "235-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-235"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Anzahlungsrechnung nicht erlaubt, da Anzahlung schon verrechnet
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+235-AR" throws the exception ""
And I close the current editor

#####################################################################################################################################

@FALL-238
Scenario: FALL-238 Storno EK Anzahlungsrechnung bezahlt

# Konto 238-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0238FALL"
And I set field "such" to "FALL-238"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0238FALL"
And I set field "such" to "FALL-238"
And I set field "bestausekso" to "FALL-238"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "238-FALL"
And I set field "num2" to "238-FALL"
And I set field "such" to "FALL-238"
And I set field "namebspr" to "FALL-238"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-238"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-238"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-238" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "238-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-238" in row 1
And I set field "mge" to "238" in row 1
And I set field "preis" to "238" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
And I set field "kenn" to "FALL-238"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "238-BE"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-238" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "bestellung-238"
And I set field "num4" to "238-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-238"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+238-AR"
And I close the current editor

# Anzahlungsrechnung bezahlen
Given I open an editor "op-zahlen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "nummer" to "238-OP"
And I set field "beleg" to "238-OP"
And I set field "gkonto" to "18100"
And I create a new row at the end of the table
And I set field "op" to "$,,rechn=4 +238-AR" in row 1
And I set field "opzabetr" to "1160" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-238" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-238"
And I set field "num4" to "238-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "238" in row 1
And I set field "kenn" to "FALL-238"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "238-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-238" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-238"
And I set field "num4" to "238-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-238"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Anzahlung nicht moeglich, weil bereits bezahlt
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+238-AR" throws the exception ""
And I close the current editor

#####################################################################################################################################

@FALL-236
Scenario:  FALL-236 Storno EK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ

# Konto 236-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0236FALL"
And I set field "such" to "FALL-236"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0236FALL"
And I set field "such" to "FALL-236"
And I set field "bestausekso" to "FALL-236"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "236A-FALL"
And I set field "num2" to "236A-FALL"
And I set field "such" to "FALL-236A"
And I set field "namebspr" to "FALL-236A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-236"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "236B-FALL"
And I set field "num2" to "236B-FALL"
And I set field "such" to "FALL-236B"
And I set field "namebspr" to "FALL-236B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-236"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "236V-FALL"
And I set field "num2" to "236V-FALL"
And I set field "such" to "FALL-236V"
And I set field "namebspr" to "FALL-236V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-236"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "236E-FALL"
And I set field "num2" to "236E-FALL"
And I set field "such" to "FALL-236E"
And I set field "namebspr" to "FALL-236E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-236"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "236M-FALL"
And I set field "num2" to "236M-FALL"
And I set field "such" to "FALL-236M"
And I set field "namebspr" to "FALL-236M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-236"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "236R-FALL"
And I set field "num2" to "236R-FALL"
And I set field "such" to "FALL-236R"
And I set field "namebspr" to "FALL-236R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-236"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-236" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "236-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-236A" in row 1
And I set field "mge" to "236" in row 1
And I set field "preis" to "236" in row 1
And I set field "verw" to "FALL236A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-236B" in row 2
And I set field "mge" to "236" in row 2
And I set field "preis" to "236" in row 2
And I set field "verw" to "FALL236B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-236V" in row 3
And I set field "mge" to "236" in row 3
And I set field "preis" to "236" in row 3
And I set field "verw" to "FALL236V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-236E" in row 4
And I set field "mge" to "236" in row 4
And I set field "preis" to "236" in row 4
And I set field "verw" to "FALL236E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-236M" in row 5
And I set field "mge" to "236" in row 5
And I set field "preis" to "236" in row 5
And I set field "verw" to "FALL236M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-236R" in row 6
And I set field "mge" to "236" in row 6
And I set field "preis" to "236" in row 6
And I set field "verw" to "FALL236R" in row 6

And I set field "kenn" to "FALL-236"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "236-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-236" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-236"
And I set field "num4" to "236-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "236" in row 1
And I set field "mge" to "236" in row 2
And I set field "mge" to "236" in row 3
And I set field "mge" to "236" in row 4
And I set field "mge" to "236" in row 5
And I set field "mge" to "236" in row 6
And I set field "kenn" to "FALL-236"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "236-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "236-LS"
And I set field "num4" to "236-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+236-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-237
Scenario:  FALL-237
# Storno	EK	Lieferschein mit allen Zusatzpositions-Typen

# Konto 237-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0237FALL"
And I set field "such" to "FALL-237"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0237FALL"
And I set field "such" to "FALL-237"
And I set field "bestausekso" to "FALL-237"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "237-FALL-ART"
And I set field "num2" to "237-FALL-ART"
And I set field "such" to "FALL-237-ART"
And I set field "namebspr" to "FALL-237"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-237"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

Scenario Outline: FALL-237-ZP
# Zusatzpositionen
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such2>"
And I set field "num2" to "<num2>"
And I set field "such" to "<such2>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "kategorie" to "<kategorie>"
And I save the current editor

Examples:
 |num2           | such2            | namebspr                          |zptyp                          |kategorie      |
 |237-FALL-L     | FALL-237-L       | FALL-237 LEER                     |                               |               |
 |237-FALL-AS    | FALL-237-AS      | FALL-237 Absatz                   |Absatz                         |               |
 |237-FALL-ES    | FALL-237-ES      | FALL-237 Endsumme                 |Endsumme                       |               |
 |237-FALL-GS    | FALL-237-GS      | FALL-237 Gesamtsumme              |Gesamtsumme                    |               |
 |237-FALL-MB    | FALL-237-MB      | FALL-237 Mindest bwp              |Mindestbestellwertposition     |               |
 |237-FALL-PP    | FALL-237-PP      | FALL-237 Prozentposition          |Prozentposition                |               |
 |237-FALL-ST    | FALL-237-ST      | FALL-237 Seite                    |Seite                          |               |
 |237-FALL-TP    | FALL-237-TP      | FALL-237 Trennposition            |Trennposition                  |               |
 |237-FALL-TX    | FALL-237-TX      | FALL-237 Text                     |Text                           |               |
 |237-FALL-ZS    | FALL-237-ZS      | FALL-237 Zwischensumme            |Zwischensumme                  |               |
 |237-FALL-AUD   | FALL-237-AUD     | FALL-237 AU-BE Pos Kategorie Die  |AU/BE-Position,BV              |Dienstleistung |
 |237-FALL-AUL   | FALL-237-AUL     | FALL-237 AU-BE Pos Kategorie Lee  |AU/BE-Position,BV              |               |
 |237-FALL-MTZ   | FALL-237-MTZ     | FALL-237 Materialzuschlag         |Materialzuschlag               |               |
 |237-FALL-NPA   | FALL-237-NPA     | FALL-237 neutrale Position ANZ    |neutrale Position              |Anzahlung      |
 |237-FALL-NPD   | FALL-237-NPD     | FALL-237 neutrale Position DL     |neutrale Position              |Dienstleistung |
 |237-FALL-NPG   | FALL-237-NPG     | FALL-237 neutrale Position G      |neutrale Position              |Gutschein      |
 |237-FALL-NPL   | FALL-237-NPL     | FALL-237 neutrale Position Leer   |neutrale Position              |               |
 |237-FALL-NSP   | FALL-237-NSP     | FALL-237 Nettosummenposition      |Nettosummenposition            |               |
 |237-FALL-UVI   | FALL-237-UVI     | FALL-237 USt/VSt-Position inkl    |USt/VSt-Position (inklusive)   |               |
 |237-FALL-UVZ   | FALL-237-UVZ     | FALL-237 USt/VSt-Position zuzu    |USt/VSt-Position (zuzüglich)   |               |

Scenario: FALL-237-BE
# Bestellung anlegen
Given I open an editor "bestellung-237" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
        | lief         | 1       |
        | num4         | 237-BE  |
        | kenn         | FALL-237|
And I append rows
        | artex         | mge             |  preis             | proz         | pwert           | konto          |
        |237-FALL-ART   | 237             |  237               | !dontChange  | !dontChange     | 0237FALL       |
        |237-FALL-L     | !dontChange     |  !dontChange       | !dontChange  | 237             | 0237FALL       |
        |237-FALL-AS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |237-FALL-ES    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |237-FALL-GS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |237-FALL-MB    | !dontChange     |  237               | !dontChange  | !dontChange     | 0237FALL       |
        |237-FALL-PP    | !dontChange     |  !dontChange       | 237          | !dontChange     | 0237FALL       |
        |237-FALL-ST    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |237-FALL-TP    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |237-FALL-TX    | !dontChange     |  !dontChange       | !dontChange  | 237             | 0237FALL       |
        |237-FALL-ZS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |237-FALL-AUD   | 237             |  237               | !dontChange  | !dontChange     | 0237FALL       |
        |237-FALL-AUL   | 237             |  237               | !dontChange  | !dontChange     | 0237FALL       |
        |237-FALL-MTZ   | !dontChange     |  237               | !dontChange  | !dontChange     | 0237FALL       |
        |237-FALL-NPA   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 0237FALL       |
        |237-FALL-NPD   | !dontChange     |  !dontChange       | !dontChange  | 237             | 0237FALL       |
        |237-FALL-NPG   | !dontChange     |  !dontChange       | !dontChange  | 237             | 0237FALL       |
        |237-FALL-NPL   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 0237FALL       |
        |237-FALL-NSP   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |237-FALL-UVZ   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
# |19   |237-FALL-UVI   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
And I save the current editor

# Scenario: FALL-237-BEAUS
# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "237-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-237" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-237"
And I set field "num4" to "237-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "237" in row 1
And I set field "kenn" to "FALL-237"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "237-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-237"
And I set field "num4" to "237-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+237-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-311
@persistent
Scenario: FALL-311 Rücklieferung EK Lieferschein

# Konto 311-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0311FALL"
And I set field "such" to "FALL-311"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0311FALL"
And I set field "such" to "FALL-311"
And I set field "bestausekso" to "FALL-311"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "311-FALL"
And I set field "num2" to "311-FALL"
And I set field "such" to "FALL-311"
And I set field "namebspr" to "FALL-311"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-311"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-311" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "311-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-311" in row 1
And I set field "mge" to "311" in row 1
And I set field "preis" to "311" in row 1
And I set field "kenn" to "FALL-311"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "311-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-311" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-311"
And I set field "num4" to "311-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "311" in row 1
And I set field "kenn" to "FALL-311"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "311-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-311" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "311-LS"
And I set field "num4" to "311-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-311 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+311-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-312
Scenario: FALL-312 EK Rücklieferung	Rechnung (Gutschrift) mit Lagerbewegung

# Konto 312-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0312FALL"
And I set field "such" to "FALL-312"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0312FALL"
And I set field "such" to "FALL-312"
And I set field "bestausekso" to "FALL-312"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "312-FALL"
And I set field "num2" to "312-FALL"
And I set field "such" to "FALL-312"
And I set field "namebspr" to "FALL-312"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-312"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-312" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "312-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-312" in row 1
And I set field "mge" to "312" in row 1
And I set field "preis" to "312" in row 1
And I set field "kenn" to "FALL-312"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "312-BE"
And I close the current editor

# FIXME geht nicht mehr, da Fehlermeldung nicht beantwortet
# # Rechnung anlegen
# Given I open an editor "rechnung-312" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "bestellung-312"
# And I set field "num4" to "312-RE"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And setting field "mge" to "-312" in row 1 throws an exception
# And I respond with answer "OK" to the dialog with id ""
# And I close the current editor
# And I set field "preis" to "312" in row 1
# And I set field "kenn" to "FALL-312"
# And I respond with answer "Ja" to the dialog with id "4841"
# And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# # Ausgabe Rechnung
# Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+312-RE"
# And I close the current editor

#####################################################################################################################################

@FALL-314
Scenario: FALL-314 Rücklieferung EK Lieferung Lohnfertigung

# Konto 314-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0314FALL"
And I set field "such" to "FALL-314"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0314FALL"
And I set field "such" to "FALL-314"
And I set field "bestausekso" to "FALL-314"
And I save the current editor

# Kaufteil FALL-314-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "314-FALL-EK"
And I set field "num2" to "314-FALL-EK"
And I set field "such" to "FALL-314-EK"
And I set field "namebspr" to "Fall 314 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-314"
And I save the current editor

# Lohnfertigung FALL-314-LOH
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "314-FALL-LOH"
And I set field "num2" to "314-FALL-LOH"
And I set field "such" to "FALL-314-LOH"
And I set field "namebspr" to "Fall 314 Lohnfertigung"
And I set field "bsart" to "Lohnfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "LOHNFERT"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-314"
And I save the current editor

# Verkaufsteil FALL-314-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "314-FALL-VK"
And I set field "num2" to "314-FALL-VK"
And I set field "such" to "FALL-314-VK"
And I set field "namebspr" to "Fall 314 Verkaufsteil"
And I set field "bsart" to "Eigenfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-314"
And I set field "elex" to "FALL-314-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-314-LOH" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "" in row 2
And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "breite" to "15" in row 3
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-314" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "314-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-314-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-314"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-314" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "314-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-314-EK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
And I set field "kenn" to "FALL-314 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "314-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-314" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-314"
And I set field "num4" to "314-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "3,30" in row 1
And I set field "kenn" to "FALL-314 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+314-REEK"
And I close the current editor

# Umlagerung Beistellung an Lohnfertiger
And  I open an editor "Umlagern314" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "LOHNFERT"
And I set field "num4" to "314-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "F1"
And I set field "kenn" to "FALL-314 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-314-EK" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "LOHNF" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+314-UML"
And I close the current editor

# Lohnfertigungsvorschlag freigeben
Given I open an editor "lohv-314" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FALL-314-LOH"
And I press button "ladetab"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "bestellung-loh-314"
And I set field "nummer" to "314-BELO"
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-314"
And I save the current editor
And I switch the current editor to editor "lohv-314"
And I close the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "314-BELO"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-314" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-loh-314"
And I set field "num4" to "314-LSLO"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "kenn" to "FALL-314"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "314-LSLO"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-314" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "314-LSLO"
And I set field "num4" to "314-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I set field "kenn" to "FALL-314 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+314-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-315
Scenario: FALL-315 Rücklieferung EK Beistellungen Wir stellen dem Lieferanten etwas bei

# Konto 315-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0315FALL"
And I set field "such" to "FALL-315"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0315FALL"
And I set field "such" to "FALL-315"
And I set field "bestausekso" to "FALL-315"
And I save the current editor

# Kaufteil FALL-315-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "315-FALL-EK"
And I set field "num2" to "315-FALL-EK"
And I set field "such" to "FALL-315-EK"
And I set field "namebspr" to "Fall 315 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-315"
And I save the current editor

# Verkaufsteil FALL-315-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "315-FALL-VK"
And I set field "num2" to "315-FALL-VK"
And I set field "such" to "FALL-315-VK"
And I set field "namebspr" to "Fall 315 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-315"
And I set field "elex" to "FALL-315-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-315" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "315-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-315-VK" in row 1
And I set field "mge" to "315" in row 1
And I set field "preis" to "315" in row 1
And I set field "kenn" to "FALL-315"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-315" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "315-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-315-EK" in row 1
And I set field "mge" to "315" in row 1
And I set field "preis" to "315" in row 1
And I set field "kenn" to "FALL-315 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "315-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-315" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-315"
And I set field "num4" to "315-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "315" in row 1
And I set field "preis" to "315" in row 1
And I set field "kenn" to "FALL-315 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+315-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-315" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "315-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-315-VK" in row 1
And I set field "mge" to "315" in row 1
And I set field "preis" to "315" in row 1
And I set field "kenn" to "FALL-315 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-315" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "315-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern315" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "315-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-315 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-315-EK" in row 1
And I set field "mge" to "315" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "315-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-315" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-315"
And I set field "num4" to "315-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "315" in row 1
And I set field "kenn" to "FALL-315"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "315-LSEK"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-315" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-315"
And I set field "num4" to "315-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-315 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+315-RLS"
And I close the current editor

#####################################################################################################################################

# @FALL-316
# Scenario: FALL-316 Rücklieferung EK Umlagerungen von Hongkong nach Karlsruhe

# Konto 316-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0316FALL"
And I set field "such" to "FALL-316"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0316FALL"
And I set field "such" to "FALL-316"
And I set field "bestausekso" to "FALL-316"
And I save the current editor

# Umlagerungsteil FALL-316
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "316-FALL"
And I set field "num2" to "316-FALL"
And I set field "such" to "FALL-316"
And I set field "namebspr" to "FALL-316 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-316"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-316" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "316-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-316" in row 1
And I set field "mge" to "316" in row 1
And I set field "preis" to "632" in row 1
And I set field "kenn" to "FALL-316"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-316" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "316-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-316" in row 1
And I set field "mge" to "316" in row 1
And I set field "preis" to "316" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-316"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "316-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-316" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-316"
And I set field "num4" to "316-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "316" in row 1
And I set field "kenn" to "FALL-316"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "316-LS"
And I close the current editor

# Umlagerung von Hongkong nach Karlsruhe
And  I open an editor "Umlagern316" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "316-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-316 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-316" in row 1
And I set field "mge" to "316" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "umlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "316-LSUM"
And I close the current editor

# Ruecklieferung von Umlagerungslieferscheinen nicht mehr erlaubt.
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "Umlagern316" throws the exception "1525"

#####################################################################################################################################

@FALL-317
Scenario:  FALL-317 Rücklieferung EK Lieferschein mit Materialzuordnung

# Konto 317-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0317FALL"
And I set field "such" to "FALL-317"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0317FALL"
And I set field "such" to "FALL-317"
And I set field "bestausekso" to "FALL-317"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "317-FALL"
And I set field "num2" to "317-FALL"
And I set field "such" to "FALL-317"
And I set field "namebspr" to "FALL-317"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-317"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-317" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "317-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-317" in row 1
And I set field "mge" to "317" in row 1
And I set field "preis" to "317" in row 1
And I set field "kenn" to "FALL-317"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "317-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-317" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-317"
And I set field "num4" to "317-LS"
# And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "317" in row 1
And I set field "kenn" to "FALL-317"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "150" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "57" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "50" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "60" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-317"
And I set field "ueb" to "JA"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "317-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-317" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "317-LS"
And I set field "num4" to "317-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-217" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "-50" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "-57" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "-50" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "-60" in row 4
And I save the current editor
And I switch the current editor to editor "rls-317"
And I set field "kenn" to "FALL-317 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-317"
And I close the current editor


#####################################################################################################################################

@FALL-331
Scenario: FALL-331
# Rücklieferung EK Umlagerungsrechnung mit Lagerbewegung Einkauf

# Konto 331-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0331FALL"
And I set field "such" to "FALL-331"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0331FALL"
And I set field "such" to "FALL-331"
And I set field "bestausekso" to "FALL-331"
And I save the current editor

# Umlagerungsteil FALL-331
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "331-FALL"
And I set field "num2" to "331-FALL"
And I set field "such" to "FALL-331"
And I set field "namebspr" to "FALL-331 Umlagerungsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "umllg" to "HONGKONG"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I create a new row at the end of the table
And I set field "lgruppe" to "HONGKONG" in row 1
And I set field "bsart" to "Fremdbeschaffung" in row 1
And I set field "dispoa" to "auftragsbezogen" in row 1
And I save the current editor
And I switch the current editor to editor "artikel"
And I set field "bsart" to "Umlagern"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-331"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-331" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "331-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-331" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-331"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-331" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "331-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-331" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-331"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "331-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-331" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-331"
And I set field "num4" to "331-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-331"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Umlagerungsrechnung
And  I open an editor "Umlagern-RE-331" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "331-REUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "fakt" to "ja"
And I set field "kenn" to "FALL-331 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-331" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "9,90" in row 1
And I set field "platz" to "F1" in row 1
And I set field "abplatz" to "L2F1" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+331-REUM"
And I close the current editor

# Ruecklieferung Umlagerungs-Rechnung
And opening an editor from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "Umlagern-RE-331" throws the exception "1525"

#####################################################################################################################################

@FALL-336
Scenario:  FALL-336
# Rücklieferschein EK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ

# Konto 336-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0336FALL"
And I set field "such" to "FALL-336"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0336FALL"
And I set field "such" to "FALL-336"
And I set field "bestausekso" to "FALL-336"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "336A-FALL"
And I set field "num2" to "336A-FALL"
And I set field "such" to "FALL-336A"
And I set field "namebspr" to "FALL-336A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-336"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "336B-FALL"
And I set field "num2" to "336B-FALL"
And I set field "such" to "FALL-336B"
And I set field "namebspr" to "FALL-336B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-336"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "336V-FALL"
And I set field "num2" to "336V-FALL"
And I set field "such" to "FALL-336V"
And I set field "namebspr" to "FALL-336V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-336"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "336E-FALL"
And I set field "num2" to "336E-FALL"
And I set field "such" to "FALL-336E"
And I set field "namebspr" to "FALL-336E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-336"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "336M-FALL"
And I set field "num2" to "336M-FALL"
And I set field "such" to "FALL-336M"
And I set field "namebspr" to "FALL-336M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-336"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "336R-FALL"
And I set field "num2" to "336R-FALL"
And I set field "such" to "FALL-336R"
And I set field "namebspr" to "FALL-336R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-336"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-336" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "336-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-336A" in row 1
And I set field "mge" to "336" in row 1
And I set field "preis" to "336" in row 1
And I set field "verw" to "FALL336A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-336B" in row 2
And I set field "mge" to "336" in row 2
And I set field "preis" to "336" in row 2
And I set field "verw" to "FALL336B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-336V" in row 3
And I set field "mge" to "336" in row 3
And I set field "preis" to "336" in row 3
And I set field "verw" to "FALL336V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-336E" in row 4
And I set field "mge" to "336" in row 4
And I set field "preis" to "336" in row 4
And I set field "verw" to "FALL336E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-336M" in row 5
And I set field "mge" to "336" in row 5
And I set field "preis" to "336" in row 5
And I set field "verw" to "FALL336M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-336R" in row 6
And I set field "mge" to "336" in row 6
And I set field "preis" to "336" in row 6
And I set field "verw" to "FALL336R" in row 6

And I set field "kenn" to "FALL-336"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "336-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-336" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-336"
And I set field "num4" to "336-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "336" in row 1
And I set field "mge" to "336" in row 2
And I set field "mge" to "336" in row 3
And I set field "mge" to "336" in row 4
And I set field "mge" to "336" in row 5
And I set field "mge" to "336" in row 6
And I set field "kenn" to "FALL-336"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "336-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-336" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "336-LS"
And I set field "num4" to "336-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "mge" to "-31" in row 2
And I set field "mge" to "-31" in row 3
And I set field "mge" to "-31" in row 4
And I set field "mge" to "-31" in row 5
And I set field "mge" to "-31" in row 6
# And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-336 Ruecklieferschein"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+336-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-337
Scenario:  FALL-337
# Rücklieferung	EK	Lieferschein mit allen Zusatzpositions-Typen

# Konto 337-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0337FALL"
And I set field "such" to "FALL-337"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0337FALL"
And I set field "such" to "FALL-337"
And I set field "bestausekso" to "FALL-337"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "337-FALL-ART"
And I set field "num2" to "337-FALL-ART"
And I set field "such" to "FALL-337-ART"
And I set field "namebspr" to "FALL-337"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-337"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

Scenario Outline: FALL-337-ZP
# Zusatzpositionen
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such2>"
And I set field "num2" to "<num2>"
And I set field "such" to "<such2>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "kategorie" to "<kategorie>"
And I save the current editor

Examples:
 |num2           | such2            | namebspr                          |zptyp                          |kategorie      |
 |337-FALL-L     | FALL-337-L       | FALL-337 LEER                     |                               |               |
 |337-FALL-AS    | FALL-337-AS      | FALL-337 Absatz                   |Absatz                         |               |
 |337-FALL-ES    | FALL-337-ES      | FALL-337 Endsumme                 |Endsumme                       |               |
 |337-FALL-GS    | FALL-337-GS      | FALL-337 Gesamtsumme              |Gesamtsumme                    |               |
 |337-FALL-MB    | FALL-337-MB      | FALL-337 Mindest bwp              |Mindestbestellwertposition     |               |
 |337-FALL-PP    | FALL-337-PP      | FALL-337 Prozentposition          |Prozentposition                |               |
 |337-FALL-ST    | FALL-337-ST      | FALL-337 Seite                    |Seite                          |               |
 |337-FALL-TP    | FALL-337-TP      | FALL-337 Trennposition            |Trennposition                  |               |
 |337-FALL-TX    | FALL-337-TX      | FALL-337 Text                     |Text                           |               |
 |337-FALL-ZS    | FALL-337-ZS      | FALL-337 Zwischensumme            |Zwischensumme                  |               |
 |337-FALL-AUD   | FALL-337-AUD     | FALL-337 AU-BE Pos Kategorie Die  |AU/BE-Position,BV              |Dienstleistung |
 |337-FALL-AUL   | FALL-337-AUL     | FALL-337 AU-BE Pos Kategorie Lee  |AU/BE-Position,BV              |               |
 |337-FALL-MTZ   | FALL-337-MTZ     | FALL-337 Materialzuschlag         |Materialzuschlag               |               |
 |337-FALL-NPA   | FALL-337-NPA     | FALL-337 neutrale Position ANZ    |neutrale Position              |Anzahlung      |
 |337-FALL-NPD   | FALL-337-NPD     | FALL-337 neutrale Position DL     |neutrale Position              |Dienstleistung |
 |337-FALL-NPG   | FALL-337-NPG     | FALL-337 neutrale Position G      |neutrale Position              |Gutschein      |
 |337-FALL-NPL   | FALL-337-NPL     | FALL-337 neutrale Position Leer   |neutrale Position              |               |
 |337-FALL-NSP   | FALL-337-NSP     | FALL-337 Nettosummenposition      |Nettosummenposition            |               |
 |337-FALL-UVI   | FALL-337-UVI     | FALL-337 USt/VSt-Position inkl    |USt/VSt-Position (inklusive)   |               |
 |337-FALL-UVZ   | FALL-337-UVZ     | FALL-337 USt/VSt-Position zuzu    |USt/VSt-Position (zuzüglich)   |               |

Scenario: FALL-337-BE
# Bestellung anlegen
Given I open an editor "bestellung-337" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
        | lief         | 1       |
        | num4         | 337-BE  |
        | kenn         | FALL-337|
And I append rows
        | artex         | mge             |  preis             | proz         | pwert           | konto          |
        |337-FALL-ART   | 337             |  337               | !dontChange  | !dontChange     | 0337FALL       |
        |337-FALL-L     | !dontChange     |  !dontChange       | !dontChange  | 337             | 0337FALL       |
        |337-FALL-AS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |337-FALL-ES    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |337-FALL-GS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |337-FALL-MB    | !dontChange     |  337               | !dontChange  | !dontChange     | 0337FALL       |
        |337-FALL-PP    | !dontChange     |  !dontChange       | 337          | !dontChange     | 0337FALL       |
        |337-FALL-ST    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |337-FALL-TP    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |337-FALL-TX    | !dontChange     |  !dontChange       | !dontChange  | 337             | 0337FALL       |
        |337-FALL-ZS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |337-FALL-AUD   | 337             |  337               | !dontChange  | !dontChange     | 0337FALL       |
        |337-FALL-AUL   | 337             |  337               | !dontChange  | !dontChange     | 0337FALL       |
        |337-FALL-MTZ   | !dontChange     |  337               | !dontChange  | !dontChange     | 0337FALL       |
        |337-FALL-NPA   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 0337FALL       |
        |337-FALL-NPD   | !dontChange     |  !dontChange       | !dontChange  | 337             | 0337FALL       |
        |337-FALL-NPG   | !dontChange     |  !dontChange       | !dontChange  | 337             | 0337FALL       |
        |337-FALL-NPL   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 0337FALL       |
        |337-FALL-NSP   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |337-FALL-UVZ   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
# |19   |337-FALL-UVI   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
And I save the current editor

# Scenario: FALL-337-BEAUS
# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "337-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-337" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-337"
And I set field "num4" to "337-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "337" in row 1
And I set field "kenn" to "FALL-337"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "337-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-337" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-337"
And I set field "num4" to "337-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-337 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+337-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-338
Scenario: FALL-338 Rücklieferung EK nach Rechnung

# Konto 338-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0338FALL"
And I set field "such" to "FALL-338"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0338FALL"
And I set field "such" to "FALL-338"
And I set field "bestausekso" to "FALL-338"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "338-FALL"
And I set field "num2" to "338-FALL"
And I set field "such" to "FALL-338"
And I set field "namebspr" to "FALL-338"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-338"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-338" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "338-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-338" in row 1
And I set field "mge" to "338" in row 1
And I set field "preis" to "338" in row 1
And I set field "kenn" to "FALL-338"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "338-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-338" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-338"
And I set field "num4" to "338-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "338" in row 1
And I set field "kenn" to "FALL-338"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "338-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-338" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-338"
And I set field "num4" to "338-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "338" in row 1
And I set field "preis" to "338" in row 1
And I set field "kenn" to "FALL-338"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+338-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-338" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+338-LS"
And I set field "num4" to "338-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-338 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-338"
And I close the current editor

#####################################################################################################################################

@FALL-361
@persistent
Scenario: FALL-361 Rücklieferung EK Fremdeigentum geht wieder zurück

# Konto 361-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0361FALL"
And I set field "such" to "FALL-361"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0361FALL"
And I set field "such" to "FALL-361"
And I set field "bestausekso" to "FALL-361"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "361-FALL"
And I set field "num2" to "361-FALL"
And I set field "such" to "FALL-361"
And I set field "namebspr" to "FALL-361"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-361"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-361" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "361-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-361" in row 1
And I set field "mge" to "361" in row 1
And I set field "preis" to "361" in row 1
And I set field "kenn" to "FALL-361"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "361-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-361" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-361"
And I set field "num4" to "361-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "361" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-361"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "361-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-361" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "361-LS"
And I set field "num4" to "361-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-361 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+361-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-362
@persistent
Scenario: FALL-362 Rücklieferung EK Eigentum wird zur nachbesserung umgelagert

# Konto 362-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0362FALL"
And I set field "such" to "FALL-362"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0362FALL"
And I set field "such" to "FALL-362"
And I set field "bestausekso" to "FALL-362"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "362-FALL"
And I set field "num2" to "362-FALL"
And I set field "such" to "FALL-362"
And I set field "namebspr" to "FALL-362"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-362"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-362" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "362-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-362" in row 1
And I set field "mge" to "362" in row 1
And I set field "preis" to "362" in row 1
And I set field "kenn" to "FALL-362"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "362-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-362" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-362"
And I set field "num4" to "362-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "362" in row 1
And I set field "kenn" to "FALL-362"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "362-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-362" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "362-LS"
And I set field "num4" to "362-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Ruecklieferschein als Umlagerung nicht moeglich. Muss ueber einen neuen Umlagerlieferschein abgebildet werden.
Then setting field "umplatz" to "EXTERRUE" throws the exception ""
And I close the current editor

# Umlagerlieferschein anlegen: intern -> externer Platz des Lieferanten
Given I open an editor "rls-362" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "362-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-362" in row 1
And I set field "mge" to "31" in row 1
And I set field "platz" to "EXTERRUE" in row 1
And I set field "umplatz" to "F1"
And I set field "kenn" to "FALL-362 Umlagerlieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerlieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+362-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-411
Scenario: FALL-411 Gutschrift EK Rechnung

# Konto 411-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0411FALL"
And I set field "such" to "FALL-411"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0411FALL"
And I set field "such" to "FALL-411"
And I set field "bestausekso" to "FALL-411"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "411-FALL"
And I set field "num2" to "411-FALL"
And I set field "such" to "FALL-411"
And I set field "namebspr" to "FALL-411"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-411"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-411" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "411-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-411" in row 1
And I set field "mge" to "411" in row 1
And I set field "preis" to "411" in row 1
And I set field "kenn" to "FALL-411"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "411-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-411" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-411"
And I set field "num4" to "411-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "411" in row 1
And I set field "kenn" to "FALL-411"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "411-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-411" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-411"
And I set field "num4" to "411-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "411" in row 1
And I set field "preis" to "411" in row 1
And I set field "kenn" to "FALL-411"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+411-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-411" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+411-LS"
And I set field "num4" to "411-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-41" in row 1
And I set field "kenn" to "FALL-411"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rück Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "411-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-411" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-411"
And I set field "num4" to "411-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "preis" to "41" in row 1
And I set field "kenn" to "FALL-411"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+411-GS"
And I close the current editor

#####################################################################################################################################

@FALL-412
Scenario: FALL-412 Gutschrift EK Rechnung mit Lagerbewegung

# Konto 412-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0412FALL"
And I set field "such" to "FALL-412"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0412FALL"
And I set field "such" to "FALL-412"
And I set field "bestausekso" to "FALL-412"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "412-FALL"
And I set field "num2" to "412-FALL"
And I set field "such" to "FALL-412"
And I set field "namebspr" to "FALL-412"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-412"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-412" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "412-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-412" in row 1
And I set field "mge" to "412" in row 1
And I set field "preis" to "412" in row 1
And I set field "kenn" to "FALL-412"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "412-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-412" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-412"
And I set field "num4" to "412-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "412" in row 1
And I set field "kenn" to "FALL-412"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "412-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-412" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-412"
And I set field "num4" to "412-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "412" in row 1
And I set field "preis" to "412" in row 1
And I set field "kenn" to "FALL-412"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+412-RE"
And I close the current editor

# Gutschrift mit Lagerbewegung nicht mehr erlaubt
Given I open an editor "gutschrift-412" from table "(Purchasing):(Invoice)" with command "COPY" for record "+412-RE"
And I set field "fakt" to "ja"
And I set field "preis" to "-412,00" in row 1
Then saving the current editor throws the exception ""


#####################################################################################################################################

@FALL-413
Scenario: FALL-413 Storno Gutschrift EK Rechnung mit Lagerbewegung

# Konto 413-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0413FALL"
And I set field "such" to "FALL-413"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0413FALL"
And I set field "such" to "FALL-413"
And I set field "bestausekso" to "FALL-413"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "413-FALL"
And I set field "num2" to "413-FALL"
And I set field "such" to "FALL-413"
And I set field "namebspr" to "FALL-413"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-413"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-413" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "413-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-413" in row 1
And I set field "mge" to "413" in row 1
And I set field "preis" to "413" in row 1
And I set field "kenn" to "FALL-413"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "413-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-413" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-413"
And I set field "num4" to "413-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "413" in row 1
And I set field "kenn" to "FALL-413"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "413-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-413" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-413"
And I set field "num4" to "413-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "413" in row 1
And I set field "preis" to "413" in row 1
And I set field "kenn" to "FALL-413"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+413-RE"
And I close the current editor

#####################################################################################################################################

@FALL-414
Scenario: FALL-414 Storno EK Gutschrift

# Konto 414-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0414FALL"
And I set field "such" to "FALL-414"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0414FALL"
And I set field "such" to "FALL-414"
And I set field "bestausekso" to "FALL-414"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "414-FALL"
And I set field "num2" to "414-FALL"
And I set field "such" to "FALL-414"
And I set field "namebspr" to "FALL-414"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-414"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-414" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "414-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-414" in row 1
And I set field "mge" to "414" in row 1
And I set field "preis" to "414" in row 1
And I set field "kenn" to "FALL-414"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "414-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-414" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-414"
And I set field "num4" to "414-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "414" in row 1
And I set field "kenn" to "FALL-414"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "414-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-414" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-414"
And I set field "num4" to "414-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "414" in row 1
And I set field "preis" to "414" in row 1
And I set field "kenn" to "FALL-414"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+414-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-414" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+414-LS"
And I set field "num4" to "414-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-207" in row 1
And I set field "kenn" to "FALL-414"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rück Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "414-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-414" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-414"
And I set field "num4" to "414-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "preis" to "41" in row 1
And I set field "kenn" to "FALL-414"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+414-GS"
And I close the current editor

# Storno Gutschrift
Given I open an editor "rechnung-414" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+414-GS"
And I set field "num4" to "414-STGS"
And I save the current editor

# Ausgabe Storno Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+414-STGS"
And I close the current editor


#####################################################################################################################################

@FALL-415
@persistent
Scenario: FALL-415 Gutschrift EK zu Rücklieferung ohne Rechnung

# Konto 415-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0415FALL"
And I set field "such" to "FALL-415"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0415FALL"
And I set field "such" to "FALL-415"
And I set field "bestausekso" to "FALL-415"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "415-FALL"
And I set field "num2" to "415-FALL"
And I set field "such" to "FALL-415"
And I set field "namebspr" to "FALL-415"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-415"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-415" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "415-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-415" in row 1
And I set field "mge" to "415" in row 1
And I set field "preis" to "415" in row 1
And I set field "kenn" to "FALL-415"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "415-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-415" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-415"
And I set field "num4" to "415-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "415" in row 1
And I set field "kenn" to "FALL-415"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "415-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-415" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-415"
And I set field "num4" to "415-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-415"
And I set field "mge" to "350" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-415" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+415-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-415" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "415-LS"
And I set field "num4" to "415-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-96" in row 1
And I set field "kenn" to "FALL-415 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-415"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-415" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-415"
And I set field "num4" to "415-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
# And I set field "preis" to "415" in row 1
And I set field "kenn" to "FALL-415"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+415-GS"
And I close the current editor

#####################################################################################################################################

@FALL-416
@persistent
Scenario: FALL-416 Gutschrift EK zu Rücklieferung ohne Rechnung mit Differenz (LS / GS) ohne Kostenumlage

# Konto 416-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0416FALL"
And I set field "such" to "FALL-416"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0416FALL"
And I set field "such" to "FALL-416"
And I set field "bestausekso" to "FALL-416"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "416-FALL"
And I set field "num2" to "416-FALL"
And I set field "such" to "FALL-416"
And I set field "namebspr" to "FALL-416"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-416"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-416" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "416-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-416" in row 1
And I set field "mge" to "416" in row 1
And I set field "preis" to "416" in row 1
And I set field "kenn" to "FALL-416"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "416-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-416" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-416"
And I set field "num4" to "416-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "416" in row 1
And I set field "kenn" to "FALL-416"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "416-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-416" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-416"
And I set field "num4" to "416-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-416"
And I set field "mge" to "350" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-416" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+416-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-416" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "416-LS"
And I set field "num4" to "416-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-97" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-416 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "416-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-416" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-416"
And I set field "num4" to "416-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
# And I set field "preis" to "222" in row 1
And I set field "kenn" to "FALL-416"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+416-GS"
And I close the current editor

#####################################################################################################################################

@FALL-417
@persistent
Scenario: FALL-417 Gutschrift EK zu Rücklieferung ohne Rechnung mit Differenz (LS / GS) mit Kostenumlage

# Konto 417-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0417FALL"
And I set field "such" to "FALL-417"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0417FALL"
And I set field "such" to "FALL-417"
And I set field "bestausekso" to "FALL-417"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "417-FALL"
And I set field "num2" to "417-FALL"
And I set field "such" to "FALL-417"
And I set field "namebspr" to "FALL-417"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-417"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-417" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "417-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-417" in row 1
And I set field "mge" to "417" in row 1
And I set field "preis" to "417" in row 1
And I set field "kenn" to "FALL-417"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "417-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-417" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-417"
And I set field "num4" to "417-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "417" in row 1
And I set field "kenn" to "FALL-417"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "417-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-417" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-417"
And I set field "num4" to "417-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-417"
And I set field "mge" to "350" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-417" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+417-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-417" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "417-LS"
And I set field "num4" to "417-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-98" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-417 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "417-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-417" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-417"
And I set field "num4" to "417-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
# And I set field "preis" to "417" in row 1
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 2
And I set field "konto" to "FALL-417" in row 2
And I set field "pwert" to "-5777" in row 2
And I set field "kenn" to "FALL-417"
And I respond with answer "Ja" to the dialog with id "4970"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-417" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "417-KM"
And I set field "pos" to "$,,kopf^nummer=417-GS;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=417-LS;artex=FALL-417;@gruppe=2;@datenbank=4" in row 1
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+417-KM"
And I close the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+417-GS"
And I close the current editor

#####################################################################################################################################

@FALL-420
@persistent
Scenario: FALL-420 Gutschrift EK zu Rücklieferung ohne Rechnung mit Differenz (LS / GS) mit Kostenumlage

# Konto 420-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0420FALL"
And I set field "such" to "FALL-420"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0420FALL"
And I set field "such" to "FALL-420"
And I set field "bestausekso" to "FALL-420"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "420-FALL"
And I set field "num2" to "420-FALL"
And I set field "such" to "FALL-420"
And I set field "namebspr" to "FALL-420"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-420"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-420" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "420-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-420" in row 1
And I set field "mge" to "420" in row 1
And I set field "preis" to "420" in row 1
And I set field "kenn" to "FALL-420"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "420-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-420" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-420"
And I set field "num4" to "420-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "420" in row 1
And I set field "kenn" to "FALL-420"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "420-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-420" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-420"
And I set field "num4" to "420-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-420"
And I set field "mge" to "350" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-420" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+420-RE1"
And I close the current editor


# Rücklieferschein anlegen
Given I open an editor "rls-420" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "420-LS"
And I set field "num4" to "420-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-101" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-420 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# DIE MKV wird in diesem FALL genau Weg gelassen.
# # Materialkostenverbuchung
# Given I open an editor "mkv-111" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
# And I set field "such" to "FALL-111"
# And I set field "kosart" to "Verbuchung Lagerbestand"
# And I set field "adat" to "."
# And I set field "edat" to "."
# # And I set field "labudat" to "01.01.95"
# And I press button "kosvor"
# #And I press button "kosbu"
# And I respond with answer "JA" to the dialog with id "2324"
# And I save the current editor

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "420-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-420" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-420"
And I set field "num4" to "420-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
# And I set field "preis" to "420" in row 1
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 2
And I set field "konto" to "FALL-420" in row 2
And I set field "pwert" to "-6420" in row 2
And I set field "kenn" to "FALL-420"
And I respond with answer "Ja" to the dialog with id "4970"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-420" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "420-KM"
And I set field "pos" to "$,,kopf^nummer=420-GS;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=420-LS;artex=FALL-420;@gruppe=2;@datenbank=4" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+420-KM"
And I close the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+420-GS"
And I close the current editor

#####################################################################################################################################

@FALL-441
Scenario: FALL-441 Gutschrift EK zu Rücklieferung

# Konto 441-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0441FALL"
And I set field "such" to "FALL-441"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0441FALL"
And I set field "such" to "FALL-441"
And I set field "bestausekso" to "FALL-441"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "441-FALL"
And I set field "num2" to "441-FALL"
And I set field "such" to "FALL-441"
And I set field "namebspr" to "FALL-441"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-441"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-441" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "441-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-441" in row 1
And I set field "mge" to "441" in row 1
And I set field "preis" to "441" in row 1
And I set field "kenn" to "FALL-441"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "441-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-441" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-441"
And I set field "num4" to "441-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "441" in row 1
And I set field "kenn" to "FALL-441"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "441-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-441" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-441"
And I set field "num4" to "441-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "441" in row 1
And I set field "preis" to "441" in row 1
And I set field "kenn" to "FALL-441"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+441-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-441" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+441-LS"
And I set field "num4" to "441-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-441 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-441"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-441" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-441"
And I set field "num4" to "441-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
# And I set field "preis" to "441" in row 1
And I set field "kenn" to "FALL-441"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+441-GS"
And I close the current editor

#####################################################################################################################################

@FALL-418
Scenario: FALL-418 Gutschrift EK mit Kostenumlage

# Konto 418-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0418FALL"
And I set field "such" to "FALL-418"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0418FALL"
And I set field "such" to "FALL-418"
And I set field "bestausekso" to "FALL-418"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "418-FALL"
And I set field "num2" to "418-FALL"
And I set field "such" to "FALL-418"
And I set field "namebspr" to "FALL-418"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-418"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-418" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "418-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-418" in row 1
And I set field "mge" to "418" in row 1
And I set field "preis" to "418" in row 1
And I set field "kenn" to "FALL-418"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "418-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-418" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-418"
And I set field "num4" to "418-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "418" in row 1
And I set field "kenn" to "FALL-418"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "418-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-418" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-418"
And I set field "num4" to "418-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "418" in row 1
And I set field "preis" to "418" in row 1
And I set field "kenn" to "FALL-418"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+418-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-418" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+418-LS"
And I set field "num4" to "418-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-41" in row 1
And I set field "kenn" to "FALL-418"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rück Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "418-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-418" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-418"
And I set field "num4" to "418-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "preis" is not modifiable in row 1
Then field "proz" is not modifiable in row 1
Then field "fixpwert" is not modifiable in row 1
Then field "aprg" is not modifiable in row 1
Then field "arab" is not modifiable in row 1
Then field "konddat" is not modifiable in row 1
Then field "lehe" is not modifiable in row 1
Then field "pehe" is not modifiable in row 1
Then field "zrahmen" is not modifiable in row 1
Then field "zignrahmen" is not modifiable in row 1
Then field "konto" is not modifiable in row 1
And I set field "kenn" to "FALL-418"
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 2
And I set field "pwert" to "-418" in row 2
And I set field "konto" to "FALL-418" in row 2
And I set field "kenn" to "FALL-418"
And I respond with answer "Ja" to the dialog with id "4970"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Kostenumlage erzeugen
Given I open an editor "kostenuml-418" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "418-KM"
And I set field "pos" to "$,,kopf^nummer=418-GS;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=418-GS;artex=FALL-418;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+418-KM"
And I close the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+418-GS"
And I close the current editor

#####################################################################################################################################

@FALL-419
Scenario: FALL-419 Storno EK Gutschrift mit Kostenumlage

# Konto 419-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0419FALL"
And I set field "such" to "FALL-419"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0419FALL"
And I set field "such" to "FALL-419"
And I set field "bestausekso" to "FALL-419"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "419-FALL"
And I set field "num2" to "419-FALL"
And I set field "such" to "FALL-419"
And I set field "namebspr" to "FALL-419"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-419"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-419" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "419-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-419" in row 1
And I set field "mge" to "419" in row 1
And I set field "preis" to "419" in row 1
And I set field "kenn" to "FALL-419"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "419-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-419" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-419"
And I set field "num4" to "419-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "419" in row 1
And I set field "kenn" to "FALL-419"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "419-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-419" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-419"
And I set field "num4" to "419-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "419" in row 1
And I set field "preis" to "419" in row 1
And I set field "kenn" to "FALL-419"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+419-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-419" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+419-LS"
And I set field "num4" to "419-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-41" in row 1
And I set field "kenn" to "FALL-419"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rück Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "419-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-419" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-419"
And I set field "num4" to "419-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "preis" is not modifiable in row 1
Then field "proz" is not modifiable in row 1
Then field "fixpwert" is not modifiable in row 1
Then field "aprg" is not modifiable in row 1
Then field "arab" is not modifiable in row 1
Then field "konddat" is not modifiable in row 1
Then field "lehe" is not modifiable in row 1
Then field "pehe" is not modifiable in row 1
Then field "zrahmen" is not modifiable in row 1
Then field "zignrahmen" is not modifiable in row 1
Then field "konto" is not modifiable in row 1
And I set field "kenn" to "FALL-419"
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 2
And I set field "pwert" to "-419" in row 2
And I set field "konto" to "FALL-419" in row 2
And I set field "kenn" to "FALL-419"
And I respond with answer "Ja" to the dialog with id "4970"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Kostenumlage erzeugen
Given I open an editor "kostenuml-419" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "419-KM"
And I set field "pos" to "$,,kopf^nummer=419-GS;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=419-GS;artex=FALL-419;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+419-KM"
And I close the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+419-GS"
And I close the current editor

# Storno Gutschrift (alles in einer) geht so nicht mehr
And opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-419" throws the exception "3335"

#####################################################################################################################################

@FALL-426
Scenario: FALL-426
# Storno	EK	Kostenumlage in GS

# Konto 426-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0426FALL"
And I set field "such" to "FALL-426"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0426FALL"
And I set field "such" to "FALL-426"
And I set field "bestausekso" to "FALL-426"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "426-FALL"
And I set field "num2" to "426-FALL"
And I set field "such" to "FALL-426"
And I set field "namebspr" to "FALL-426"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-426"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-426" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "426-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-426" in row 1
And I set field "mge" to "426" in row 1
And I set field "preis" to "426" in row 1
And I set field "kenn" to "FALL-426"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "426-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-426" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-426"
And I set field "num4" to "426-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "426" in row 1
And I set field "kenn" to "FALL-426"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "426-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-426" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-426"
And I set field "num4" to "426-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "426" in row 1
And I set field "preis" to "426" in row 1
And I set field "kenn" to "FALL-426"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+426-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-426" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+426-LS"
And I set field "num4" to "426-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-41" in row 1
And I set field "kenn" to "FALL-426"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rück Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "426-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-426" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-426"
And I set field "num4" to "426-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "preis" is not modifiable in row 1
Then field "proz" is not modifiable in row 1
Then field "fixpwert" is not modifiable in row 1
Then field "aprg" is not modifiable in row 1
Then field "arab" is not modifiable in row 1
Then field "konddat" is not modifiable in row 1
Then field "lehe" is not modifiable in row 1
Then field "pehe" is not modifiable in row 1
Then field "zrahmen" is not modifiable in row 1
Then field "zignrahmen" is not modifiable in row 1
Then field "konto" is not modifiable in row 1
And I set field "kenn" to "FALL-426"
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 2
And I set field "pwert" to "-426" in row 2
And I set field "konto" to "FALL-426" in row 2
And I set field "kenn" to "FALL-426"
And I respond with answer "Ja" to the dialog with id "4970"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Kostenumlage erzeugen
Given I open an editor "kostenuml-426" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "426-KM"
And I set field "pos" to "$,,kopf^nummer=426-GS;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=426-GS;artex=FALL-426;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+426-KM"
And I close the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+426-GS"
And I close the current editor

# Kostenumlage stornieren
Given I open an editor "kostenum-storno-426" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenuml-426"
And I set field "num135" to "426-STKM"
And I save the current editor

# Ausgabe Storno Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+426-STKM"
And I close the current editor

#####################################################################################################################################

@FALL-427
Scenario: FALL-427
# Storno	EK	Gutschrift	nach 426

# Konto 427-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0427FALL"
And I set field "such" to "FALL-427"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0427FALL"
And I set field "such" to "FALL-427"
And I set field "bestausekso" to "FALL-427"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "427-FALL"
And I set field "num2" to "427-FALL"
And I set field "such" to "FALL-427"
And I set field "namebspr" to "FALL-427"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-427"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-427" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "427-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-427" in row 1
And I set field "mge" to "427" in row 1
And I set field "preis" to "427" in row 1
And I set field "kenn" to "FALL-427"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "427-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-427" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-427"
And I set field "num4" to "427-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "427" in row 1
And I set field "kenn" to "FALL-427"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "427-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-427" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-427"
And I set field "num4" to "427-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "427" in row 1
And I set field "preis" to "427" in row 1
And I set field "kenn" to "FALL-427"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+427-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-427" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+427-LS"
And I set field "num4" to "427-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-41" in row 1
And I set field "kenn" to "FALL-427"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rück Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "427-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-427" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-427"
And I set field "num4" to "427-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "preis" is not modifiable in row 1
Then field "proz" is not modifiable in row 1
Then field "fixpwert" is not modifiable in row 1
Then field "aprg" is not modifiable in row 1
Then field "arab" is not modifiable in row 1
Then field "konddat" is not modifiable in row 1
Then field "lehe" is not modifiable in row 1
Then field "pehe" is not modifiable in row 1
Then field "zrahmen" is not modifiable in row 1
Then field "zignrahmen" is not modifiable in row 1
Then field "konto" is not modifiable in row 1
And I set field "kenn" to "FALL-427"
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 2
And I set field "pwert" to "-427" in row 2
And I set field "konto" to "FALL-427" in row 2
And I set field "kenn" to "FALL-427"
And I respond with answer "Ja" to the dialog with id "4970"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Kostenumlage erzeugen
Given I open an editor "kostenuml-427" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "427-KM"
And I set field "pos" to "$,,kopf^nummer=427-GS;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=427-GS;artex=FALL-427;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+427-KM"
And I close the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+427-GS"
And I close the current editor

# Kostenumlage stornieren
Given I open an editor "kostenum-storno-427" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenuml-427"
And I set field "num135" to "427-STKM"
And I save the current editor

# Ausgabe Storno Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+427-STKM"
And I close the current editor

Given I open an editor "rechnung-427" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+427-GS"
And I set field "num4" to "427-STGS"
And I save the current editor

# Ausgabe Storno Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+427-STGS"
And I close the current editor

#####################################################################################################################################

@FALL-435
Scenario: FALL-435 Gutschrift EK zu Anzahlungsrechnung

# Konto 435-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0435FALL"
And I set field "such" to "FALL-435"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0435FALL"
And I set field "such" to "FALL-435"
And I set field "bestausekso" to "FALL-435"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "435-FALL"
And I set field "num2" to "435-FALL"
And I set field "such" to "FALL-435"
And I set field "namebspr" to "FALL-435"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-435"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-435" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "435-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-435" in row 1
And I set field "mge" to "435" in row 1
And I set field "preis" to "435" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
And I set field "kenn" to "FALL-435"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "435-BE"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-435" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "bestellung-435"
And I set field "num4" to "435-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-435"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+435-AR"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-435" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-435"
And I set field "num4" to "435-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "435" in row 1
And I set field "kenn" to "FALL-435"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "435-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-435" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-435"
And I set field "num4" to "435-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "435" in row 1
And I set field "preis" to "435" in row 1
And I set field "kenn" to "FALL-435"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+435-RE"
And I close the current editor

# Anzahlungs-Gutschrift erstellen
Given I open an editor "rechnung-435" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "bestellung-435"
And I set field "num4" to "435-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "-900" in row 1
And I set field "kenn" to "FALL-435"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+435-AR"
And I close the current editor

#####################################################################################################################################

@FALL-460
Scenario: FALL-460
# BE>LS>RE>RLS>GS	mit unterschiedlichen Preisen

# Konto 460-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0460FALL"
And I set field "such" to "FALL-460"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0460FALL"
And I set field "such" to "FALL-460"
And I set field "bestausekso" to "FALL-460"
And I save the current editor
#NIO

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "460-FALL"
And I set field "num2" to "460-FALL"
And I set field "such" to "FALL-460"
And I set field "namebspr" to "FALL-460"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-460"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-460" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "460-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-460" in row 1
And I set field "mge" to "460" in row 1
And I set field "preis" to "460,46" in row 1
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-460" in row 2
And I set field "mge" to "460" in row 2
And I set field "preis" to "460,92" in row 2
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-460" in row 3
And I set field "mge" to "460" in row 3
And I set field "preis" to "460,23" in row 3
#
And I set field "kenn" to "FALL-460"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "460-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-460" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-460"
And I set field "num4" to "460-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "460" in row 1
#
And I set field "mge" to "230" in row 3
#
And I set field "kenn" to "FALL-460"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-460" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "460-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-460" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-460"
And I set field "num4" to "460-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "280" in row 1
And I set field "preis" to "460,41" in row 1
#
And I set field "mge" to "130" in row 2
And I set field "preis" to "520,01" in row 2
#
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-460" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+460-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-460" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-460"
And I set field "num4" to "460-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-321" in row 1
And I set field "kenn" to "FALL-460 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "460-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-460" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-460"
And I set field "num4" to "460-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "mge" to "-460" in row 1
# And I set field "preis" to "460" in row 1
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+460-GS"
And I close the current editor

#####################################################################################################################################

@FALL-465
Scenario: FALL-465
# BE>LS>RLS>RE>GS	mit unterschiedlichen Preisen

# Konto 465-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0465FALL"
And I set field "such" to "FALL-465"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0465FALL"
And I set field "such" to "FALL-465"
And I set field "bestausekso" to "FALL-465"
And I save the current editor
#NIO

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "465-FALL"
And I set field "num2" to "465-FALL"
And I set field "such" to "FALL-465"
And I set field "namebspr" to "FALL-465"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-465"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-465" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "465-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-465" in row 1
And I set field "mge" to "465" in row 1
And I set field "preis" to "465,46" in row 1
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-465" in row 2
And I set field "mge" to "465" in row 2
And I set field "preis" to "465,92" in row 2
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-465" in row 3
And I set field "mge" to "465" in row 3
And I set field "preis" to "465,23" in row 3
#
And I set field "kenn" to "FALL-465"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "465-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-465" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-465"
And I set field "num4" to "465-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "465" in row 1
#
And I set field "mge" to "230" in row 3
#
And I set field "kenn" to "FALL-465"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-465" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "465-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-465" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-465"
And I set field "num4" to "465-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-321" in row 1
And I set field "kenn" to "FALL-465 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+465-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-465" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-465"
And I set field "num4" to "465-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Keine Ueberberechnung moeglich
And I set field "mge" to "144" in row 1
And I set field "preis" to "465,41" in row 1
#
And I set field "mge" to "130" in row 2
And I set field "preis" to "520,01" in row 2
#
And I set field "kenn" to "FALL-465"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-465" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+465-RE"
And I close the current editor

#####################################################################################################################################

@FALL-470
Scenario: FALL-470
# BE>LS>RLS>GS>RE	mit unterschiedlichen Preisen

# Konto 470-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0470FALL"
And I set field "such" to "FALL-470"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0470FALL"
And I set field "such" to "FALL-470"
And I set field "bestausekso" to "FALL-470"
And I save the current editor
#NIO

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "470-FALL"
And I set field "num2" to "470-FALL"
And I set field "such" to "FALL-470"
And I set field "namebspr" to "FALL-470"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-470"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-470" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "470-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-470" in row 1
And I set field "mge" to "470" in row 1
And I set field "preis" to "470,46" in row 1
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-470" in row 2
And I set field "mge" to "470" in row 2
And I set field "preis" to "470,92" in row 2
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-470" in row 3
And I set field "mge" to "470" in row 3
And I set field "preis" to "470,23" in row 3
#
And I set field "kenn" to "FALL-470"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "470-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-470" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-470"
And I set field "num4" to "470-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "470" in row 1
#
And I set field "mge" to "230" in row 3
#
And I set field "kenn" to "FALL-470"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-470" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "470-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-470" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-470"
And I set field "num4" to "470-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "280" in row 1
And I set field "preis" to "470,41" in row 1
#
And I set field "mge" to "130" in row 2
And I set field "preis" to "520,01" in row 2
#
And I set field "kenn" to "FALL-470"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-470" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+470-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-470" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-470"
And I set field "num4" to "470-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-321" in row 1
And I set field "kenn" to "FALL-470 Ruecklieferschein"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "470-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-470" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-470"
And I set field "num4" to "470-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "mge" to "-470" in row 1
# And I set field "preis" to "470" in row 1
And I set field "kenn" to "FALL-470"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+470-GS"
And I close the current editor

#####################################################################################################################################

@FALL-511
@persistent
Scenario: FALL-511 Storno Rücklieferung	EK	Lieferschein

# Konto 511-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0511FALL"
And I set field "such" to "FALL-511"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0511FALL"
And I set field "such" to "FALL-511"
And I set field "bestausekso" to "FALL-511"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "511-FALL"
And I set field "num2" to "511-FALL"
And I set field "such" to "FALL-511"
And I set field "namebspr" to "FALL-511"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-511"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-511" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "511-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-511" in row 1
And I set field "mge" to "511" in row 1
And I set field "preis" to "511" in row 1
And I set field "kenn" to "FALL-511"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "511-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-511" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-511"
And I set field "num4" to "511-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "511" in row 1
And I set field "kenn" to "FALL-511"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "511-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-511" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "511-LS"
And I set field "num4" to "511-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-511 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-511"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "lieferschein-511" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "rls-511"
And I set field "num4" to "511-SRLS"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+511-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-514
Scenario: FALL-514 Storno Rücklieferung EK Beistellungen Wir stellen dem Lieferanten etwas bei

# Konto 514-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0514FALL"
And I set field "such" to "FALL-514"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0514FALL"
And I set field "such" to "FALL-514"
And I set field "bestausekso" to "FALL-514"
And I save the current editor

# Kaufteil FALL-514-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "514-FALL-EK"
And I set field "num2" to "514-FALL-EK"
And I set field "such" to "FALL-514-EK"
And I set field "namebspr" to "Fall 514 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-514"
And I save the current editor

# Verkaufsteil FALL-514-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "514-FALL-VK"
And I set field "num2" to "514-FALL-VK"
And I set field "such" to "FALL-514-VK"
And I set field "namebspr" to "Fall 514 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-514"
And I set field "elex" to "FALL-514-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-514" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "514-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-514-VK" in row 1
And I set field "mge" to "514" in row 1
And I set field "preis" to "514" in row 1
And I set field "kenn" to "FALL-514"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-514" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "514-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-514-EK" in row 1
And I set field "mge" to "514" in row 1
And I set field "preis" to "514" in row 1
And I set field "kenn" to "FALL-514 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "514-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-514" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-514"
And I set field "num4" to "514-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "514" in row 1
And I set field "preis" to "514" in row 1
And I set field "kenn" to "FALL-514 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+514-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-514" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "514-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-514-VK" in row 1
And I set field "mge" to "514" in row 1
And I set field "preis" to "514" in row 1
And I set field "kenn" to "FALL-514 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-514" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "514-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern514" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "514-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-514 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-514-EK" in row 1
And I set field "mge" to "514" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "514-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-514" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-514"
And I set field "num4" to "514-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "514" in row 1
And I set field "kenn" to "FALL-514"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "514-LSEK"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-514" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-514"
And I set field "num4" to "514-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-514 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+514-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "st-lieferschein-514" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "rls-514"
And I set field "num4" to "514-SRLS"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+514-SRLS"
And I close the current editor

#####################################################################################################################################

# @FALL-531
# Scenario: FALL-531
# Storno Rücklieferung EK Umlagerungsrechnung mit Lagerbewegung Einkauf
# Gibt es so nicht

#####################################################################################################################################

@FALL-537
Scenario:  FALL-537
# Storno Rücklieferung	EK	Lieferschein mit allen Zusatzpositions-Typen

# Konto 537-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0537FALL"
And I set field "such" to "FALL-537"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0537FALL"
And I set field "such" to "FALL-537"
And I set field "bestausekso" to "FALL-537"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "537-FALL-ART"
And I set field "num2" to "537-FALL-ART"
And I set field "such" to "FALL-537-ART"
And I set field "namebspr" to "FALL-537"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-537"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

Scenario Outline: FALL-537-ZP
# Zusatzpositionen
Given I open an editor "zusatzposition" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such2>"
And I set field "num2" to "<num2>"
And I set field "such" to "<such2>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "kategorie" to "<kategorie>"
And I save the current editor

Examples:
 |num2           | such2            | namebspr                          |zptyp                          |kategorie      |
 |537-FALL-L     | FALL-537-L       | FALL-537 LEER                     |                               |               |
 |537-FALL-AS    | FALL-537-AS      | FALL-537 Absatz                   |Absatz                         |               |
 |537-FALL-ES    | FALL-537-ES      | FALL-537 Endsumme                 |Endsumme                       |               |
 |537-FALL-GS    | FALL-537-GS      | FALL-537 Gesamtsumme              |Gesamtsumme                    |               |
 |537-FALL-MB    | FALL-537-MB      | FALL-537 Mindest bwp              |Mindestbestellwertposition     |               |
 |537-FALL-PP    | FALL-537-PP      | FALL-537 Prozentposition          |Prozentposition                |               |
 |537-FALL-ST    | FALL-537-ST      | FALL-537 Seite                    |Seite                          |               |
 |537-FALL-TP    | FALL-537-TP      | FALL-537 Trennposition            |Trennposition                  |               |
 |537-FALL-TX    | FALL-537-TX      | FALL-537 Text                     |Text                           |               |
 |537-FALL-ZS    | FALL-537-ZS      | FALL-537 Zwischensumme            |Zwischensumme                  |               |
 |537-FALL-AUD   | FALL-537-AUD     | FALL-537 AU-BE Pos Kategorie Die  |AU/BE-Position,BV              |Dienstleistung |
 |537-FALL-AUL   | FALL-537-AUL     | FALL-537 AU-BE Pos Kategorie Lee  |AU/BE-Position,BV              |               |
 |537-FALL-MTZ   | FALL-537-MTZ     | FALL-537 Materialzuschlag         |Materialzuschlag               |               |
 |537-FALL-NPA   | FALL-537-NPA     | FALL-537 neutrale Position ANZ    |neutrale Position              |Anzahlung      |
 |537-FALL-NPD   | FALL-537-NPD     | FALL-537 neutrale Position DL     |neutrale Position              |Dienstleistung |
 |537-FALL-NPG   | FALL-537-NPG     | FALL-537 neutrale Position G      |neutrale Position              |Gutschein      |
 |537-FALL-NPL   | FALL-537-NPL     | FALL-537 neutrale Position Leer   |neutrale Position              |               |
 |537-FALL-NSP   | FALL-537-NSP     | FALL-537 Nettosummenposition      |Nettosummenposition            |               |
 |537-FALL-UVI   | FALL-537-UVI     | FALL-537 USt/VSt-Position inkl    |USt/VSt-Position (inklusive)   |               |
 |537-FALL-UVZ   | FALL-537-UVZ     | FALL-537 USt/VSt-Position zuzu    |USt/VSt-Position (zuzüglich)   |               |

Scenario: FALL-537-BE
# Bestellung anlegen
Given I open an editor "bestellung-537" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
        | lief         | 1       |
        | num4         | 537-BE  |
        | kenn         | FALL-537|
And I append rows
        | artex         | mge             |  preis             | proz         | pwert           | konto          |
        |537-FALL-ART   | 537             |  537               | !dontChange  | !dontChange     | 0537FALL       |
        |537-FALL-L     | !dontChange     |  !dontChange       | !dontChange  | 537             | 0537FALL       |
        |537-FALL-AS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |537-FALL-ES    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |537-FALL-GS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |537-FALL-MB    | !dontChange     |  537               | !dontChange  | !dontChange     | 0537FALL       |
        |537-FALL-PP    | !dontChange     |  !dontChange       | 537          | !dontChange     | 0537FALL       |
        |537-FALL-ST    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |537-FALL-TP    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |537-FALL-TX    | !dontChange     |  !dontChange       | !dontChange  | 537             | 0537FALL       |
        |537-FALL-ZS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |537-FALL-AUD   | 537             |  537               | !dontChange  | !dontChange     | 0537FALL       |
        |537-FALL-AUL   | 537             |  537               | !dontChange  | !dontChange     | 0537FALL       |
        |537-FALL-MTZ   | !dontChange     |  537               | !dontChange  | !dontChange     | 0537FALL       |
        |537-FALL-NPA   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 0537FALL       |
        |537-FALL-NPD   | !dontChange     |  !dontChange       | !dontChange  | 537             | 0537FALL       |
        |537-FALL-NPG   | !dontChange     |  !dontChange       | !dontChange  | 537             | 0537FALL       |
        |537-FALL-NPL   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 0537FALL       |
        |537-FALL-NSP   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |537-FALL-UVZ   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
# |19   |537-FALL-UVI   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
And I save the current editor

# Scenario: FALL-537-BEAUS
# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "537-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-537" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-537"
And I set field "num4" to "537-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "537" in row 1
And I set field "kenn" to "FALL-537"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "537-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-537" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-537"
And I set field "num4" to "537-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-537 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+537-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "lieferschein-537" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "rls-537"
And I set field "num4" to "537-SRLS"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+537-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-704
Scenario: FALL-704 EK Rechnung auf Lagermenge die nicht mehr da ist

# Konto 704-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0704FALL"
And I set field "such" to "FALL-704"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0704FALL"
And I set field "such" to "FALL-704"
And I set field "bestausekso" to "FALL-704"
And I save the current editor

# Achtung Es bleiben 2 Stück unberechnet!

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "704-FALL"
And I set field "num2" to "704-FALL"
And I set field "such" to "FALL-704"
And I set field "namebspr" to "FALL-704"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-704"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-704"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-704" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "704-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-704" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-704"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "704-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-704" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-704"
And I set field "num4" to "704-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "kenn" to "FALL-704"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "704-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-704" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "704-LS"
And I set field "num4" to "704-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I set field "kenn" to "FALL-704"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+704-RLS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-704" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-704"
And I set field "num4" to "704-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Keine Ueberberechnung moeglich
And I set field "mge" to "7" in row 1
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-704"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+704-RE"
And I close the current editor

#####################################################################################################################################

@FALL-705
Scenario: FALL-705 EK Rechnung auf Lagermenge die nicht mehr da ist

# Konto 705-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0705FALL"
And I set field "such" to "FALL-705"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0705FALL"
And I set field "such" to "FALL-705"
And I set field "bestausekso" to "FALL-705"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "705-FALL"
And I set field "num2" to "705-FALL"
And I set field "such" to "FALL-705"
And I set field "namebspr" to "FALL-705"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-705"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-705"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-705" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "705-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-705" in row 1
And I set field "mge" to "705" in row 1
And I set field "preis" to "705" in row 1
And I set field "kenn" to "FALL-705"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "705-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-705" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-705"
And I set field "num4" to "705-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "705" in row 1
And I set field "kenn" to "FALL-705"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "705-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-705" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "705-LS"
And I set field "num4" to "705-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-100" in row 1
And I set field "kenn" to "FALL-705"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+705-RLS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-705" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-705"
And I set field "num4" to "705-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Keine Ueberberechnung moeglich
And I set field "mge" to "605" in row 1
And I set field "preis" to "705" in row 1
And I set field "kenn" to "FALL-705"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+705-RE"
And I close the current editor

#####################################################################################################################################

@FALL-708
Scenario: FALL-708 Umlagerung EK Lieferschein mit AFL

# Konto 708-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0708FALL"
And I set field "such" to "FALL-708"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0708FALL"
And I set field "such" to "FALL-708"
And I set field "bestausekso" to "FALL-708"
And I save the current editor

# Kaufteil FALL-708-EK1
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "708-FALL-EK1"
And I set field "num2" to "708-FALL-EK1"
And I set field "such" to "FALL-708-EK1"
And I set field "namebspr" to "Fall 708 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-708"
And I save the current editor

# Kaufteil FALL-708-EK2
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "708-FALL-EK2"
And I set field "num2" to "708-FALL-EK2"
And I set field "such" to "FALL-708-EK2"
And I set field "namebspr" to "Fall 708 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-708"
And I save the current editor

# Verkaufsteil FALL-708
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "708-FALL"
And I set field "num2" to "708-FALL-VK"
And I set field "such" to "FALL-708-VK"
And I set field "namebspr" to "FALL-708 Verkaufsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "bsart" to "Eigenfertigung"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-708"
And I set field "elex" to "FALL-708-EK1" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-708-EK2" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1

And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "15" in row 2
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-708" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "708-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-708-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-708"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-708" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "708-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-708-EK1" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "F1" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-708-EK2" in row 2
And I set field "mge" to "50" in row 2
And I set field "preis" to "5" in row 2
And I set field "platz" to "F1" in row 2
And I set field "kenn" to "FALL-708"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "708-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-708" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-708"
And I set field "num4" to "708-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "mge" to "50" in row 2
And I set field "kenn" to "FALL-708"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "708-LS"
And I close the current editor

# Bestellung anlegen
Given I open an editor "bestellung2-708" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "708-BE2"
And I set field "bsart" to "Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-708-VK" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "abplatz" to "F1" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-708"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I delete all rows
And I create a new row at the end of the table
And I set field "elex" to "FALL-708-EK1" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-708-EK2" in row 2
And I set field "elanzahl" to "1" in row 2
And I save the current editor
And I switch the current editor to editor "bestellung2-708"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-708" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung2-708"
And I set field "num4" to "708-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-708"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "umlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "708-LSUM"
And I close the current editor

#####################################################################################################################################

@FALL-709
Scenario: FALL-709 Umlagerung EK Lieferschein mit AFL

# Konto 709-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0709FALL"
And I set field "such" to "FALL-709"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0709FALL"
And I set field "such" to "FALL-709"
And I set field "bestausekso" to "FALL-709"
And I save the current editor


# Kaufteil FALL-709-EK1
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "709-FALL-EK1"
And I set field "num2" to "709-FALL-EK1"
And I set field "such" to "FALL-709-EK1"
And I set field "namebspr" to "Fall 709 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-709"
And I save the current editor

# Kaufteil FALL-709-EK2
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "709-FALL-EK2"
And I set field "num2" to "709-FALL-EK2"
And I set field "such" to "FALL-709-EK2"
And I set field "namebspr" to "Fall 709 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-709"
And I save the current editor

# Verkaufsteil FALL-709
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "709-FALL"
And I set field "num2" to "709-FALL-VK"
And I set field "such" to "FALL-709-VK"
And I set field "namebspr" to "FALL-709 Verkaufsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "bsart" to "Eigenfertigung"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-709"
And I set field "elex" to "FALL-709-EK1" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-709-EK2" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1

And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "15" in row 2
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-709" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "709-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-709-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-709"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-709" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "709-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-709-EK1" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "F1" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-709-EK2" in row 2
And I set field "mge" to "50" in row 2
And I set field "preis" to "5" in row 2
And I set field "platz" to "F1" in row 2
And I set field "kenn" to "FALL-709"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "709-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-709" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-709"
And I set field "num4" to "709-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "mge" to "50" in row 2
And I set field "kenn" to "FALL-709"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "709-LS"
And I close the current editor

# Bestellung anlegen
Given I open an editor "bestellung2-709" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "709-BE2"
And I set field "bsart" to "Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-709-VK" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "abplatz" to "F1" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-709"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I delete all rows
And I create a new row at the end of the table
And I set field "elex" to "FALL-709-EK1" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-709-EK2" in row 2
And I set field "elanzahl" to "1" in row 2
And I save the current editor
And I switch the current editor to editor "bestellung2-709"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein2-709" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung2-709"
And I set field "num4" to "709-LSUM"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-709"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "umlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "709-LSUM"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-709" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein2-709"
And I set field "num4" to "709-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Keine Ueberberechnung moeglich
And I set field "mge" to "50" in row 1
And I set field "preis" to "709" in row 1
And I set field "kenn" to "FALL-709"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "lieferschein-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+709-RE"
And I close the current editor

#####################################################################################################################################

@FALL-710
Scenario: FALL-710 Umlagerung EK Lieferschein mit AFL

# Konto 710-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0710FALL"
And I set field "such" to "FALL-710"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0710FALL"
And I set field "such" to "FALL-710"
And I set field "bestausekso" to "FALL-710"
And I save the current editor

# Kaufteil FALL-710-EK1
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "710-FALL-EK1"
And I set field "num2" to "710-FALL-EK1"
And I set field "such" to "FALL-710-EK1"
And I set field "namebspr" to "Fall 710 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-710"
And I save the current editor

# Kaufteil FALL-710-EK2
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "710-FALL-EK2"
And I set field "num2" to "710-FALL-EK2"
And I set field "such" to "FALL-710-EK2"
And I set field "namebspr" to "Fall 710 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-710"
And I save the current editor

# Verkaufsteil FALL-710
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "710-FALL-VK"
And I set field "num2" to "710-FALL-VK"
And I set field "such" to "FALL-710-VK"
And I set field "namebspr" to "FALL-710 Verkaufsteil"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "bsart" to "Eigenfertigung"
And I set field "eart" to "(UsingBOM)"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-710"
And I set field "elex" to "FALL-710-EK1" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-710-EK2" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "lfbeist" to "1" in row 2
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-710" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "710-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-710-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "platz" to "L2F1" in row 1
And I set field "kenn" to "FALL-710"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-710" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "710-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-710-EK1" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "5" in row 1
And I set field "platz" to "F1" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-710-EK2" in row 2
And I set field "mge" to "50" in row 2
And I set field "preis" to "5" in row 2
And I set field "platz" to "F1" in row 2
And I set field "kenn" to "FALL-710"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "710-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-710" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-710"
And I set field "num4" to "710-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "mge" to "50" in row 2
And I set field "kenn" to "FALL-710"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "710-LS"
And I close the current editor

# Bestellung anlegen
Given I open an editor "bestellung2-710" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "710-BE2"
And I set field "bsart" to "Umlagern"
And I create a new row at the end of the table

#  Setartikel und Pseudobaugruppen sind im Zugang nicht erlaubt.
And setting field "artex" to "FALL-710-VK" in row 1 throws the exception "1674"
And I close the current editor

#####################################################################################################################################

@FALL-712
Scenario: FALL-712 Neu EK Anzahlungsrechnung Fehler beim Aendern der Vorgangssteuerregel bzw. Fixierung

# Konto 712-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0712FALL"
And I set field "such" to "FALL-712"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0712FALL"
And I set field "such" to "FALL-712"
And I set field "bestausekso" to "FALL-712"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "712-FALL"
And I set field "num2" to "712-FALL"
And I set field "such" to "FALL-712"
And I set field "namebspr" to "FALL-712"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-712"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-712" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "712-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-712" in row 1
And I set field "mge" to "712" in row 1
And I set field "preis" to "712" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
And I set field "kenn" to "FALL-712"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "712-BE"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-anz" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "bestellung-712"
And I set field "num4" to "712-AR"
And I set field "vom" to "."
And I set field "ueb" to "nein"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-712"
And I set field "vrgstrgl" to "EKINFREI"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "712-AR"
And I close the current editor

# Anzahlungsrechnung korrigieren
Given I open an editor "rechnung-712" from table "(Purchasing):(Invoice)" with command "STORE" for record from editor "rechnung-anz"
And I set field "vorganga" to "(Downpayment)"
And I set field "fixvrgstrgl" to "nein"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+712-AR"
And I close the current editor

#####################################################################################################################################

@FALL-713
Scenario: FALL-713 Koppelprodukt Beistellung Neu (wie 115)

# Konto 713-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0713FALL"
And I set field "such" to "FALL-713"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0713FALL"
And I set field "such" to "FALL-713"
And I set field "bestausekso" to "FALL-713"
And I save the current editor

# Kaufteil FALL-713-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "713-FALL-EK"
And I set field "num2" to "713-FALL-EK"
And I set field "such" to "FALL-713-EK"
And I set field "namebspr" to "Fall 713 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-713"
And I save the current editor

# Koppelprodukt
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "713-FALL-KP"
And I set field "num2" to "713-FALL-KP"
And I set field "such" to "FALL-713-KP"
And I set field "namebspr" to "Fall 713 Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "7,13"
And I set field "wgruppe" to "FALL-713"
And I save the current editor

# Verkaufsteil FALL-713-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "713-FALL-VK"
And I set field "num2" to "713-FALL-VK"
And I set field "such" to "FALL-713-VK"
And I set field "namebspr" to "Fall 713 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-713"
And I set field "elex" to "FALL-713-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
#
And I create a new row at the end of the table
And I set field "elex" to "713-FALL-KP" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-713" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "713-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-713-VK" in row 1
And I set field "mge" to "713" in row 1
And I set field "preis" to "713" in row 1
And I set field "kenn" to "FALL-713"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-713" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "713-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-713-EK" in row 1
And I set field "mge" to "713" in row 1
And I set field "preis" to "713" in row 1
And I set field "kenn" to "FALL-713 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "713-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-713" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-713"
And I set field "num4" to "713-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "713" in row 1
And I set field "preis" to "713" in row 1
And I set field "kenn" to "FALL-713 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+713-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-713" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "713-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-713-VK" in row 1
And I set field "mge" to "713" in row 1
And I set field "preis" to "713" in row 1
And I set field "kenn" to "FALL-713 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-713" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "713-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern713" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "713-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-713 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-713-EK" in row 1
And I set field "mge" to "713" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "713-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-713" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-713"
And I set field "num4" to "713-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "713" in row 1
And I set field "kenn" to "FALL-713"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "713-LSEK"
And I close the current editor

#####################################################################################################################################

@FALL-714
Scenario: FALL-714 Koppelprodukt Beistellung Storno (wie 215)

# Konto 714-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0714FALL"
And I set field "such" to "FALL-714"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0714FALL"
And I set field "such" to "FALL-714"
And I set field "bestausekso" to "FALL-714"
And I save the current editor

# Kaufteil FALL-714-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "714-FALL-EK"
And I set field "num2" to "714-FALL-EK"
And I set field "such" to "FALL-714-EK"
And I set field "namebspr" to "Fall 714 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-714"
And I save the current editor

# Koppelprodukt
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "714-FALL-KP"
And I set field "num2" to "714-FALL-KP"
And I set field "such" to "FALL-714-KP"
And I set field "namebspr" to "Fall 714 Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "7,14"
And I set field "wgruppe" to "FALL-714"
And I save the current editor

# Verkaufsteil FALL-714-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "714-FALL-VK"
And I set field "num2" to "714-FALL-VK"
And I set field "such" to "FALL-714-VK"
And I set field "namebspr" to "Fall 714 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-714"
And I set field "elex" to "FALL-714-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
#
And I create a new row at the end of the table
And I set field "elex" to "714-FALL-KP" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-714" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "714-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-714-VK" in row 1
And I set field "mge" to "714" in row 1
And I set field "preis" to "714" in row 1
And I set field "kenn" to "FALL-714"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-714" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "714-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-714-EK" in row 1
And I set field "mge" to "714" in row 1
And I set field "preis" to "714" in row 1
And I set field "kenn" to "FALL-714 Kaufteil"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "714-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-714" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-714"
And I set field "num4" to "714-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "714" in row 1
And I set field "preis" to "714" in row 1
And I set field "kenn" to "FALL-714 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+714-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-714" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "714-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-714-VK" in row 1
And I set field "mge" to "714" in row 1
And I set field "preis" to "714" in row 1
And I set field "kenn" to "FALL-714 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-714" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "714-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern714" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "714-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-714 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-714-EK" in row 1
And I set field "mge" to "714" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "714-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-714" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-714"
And I set field "num4" to "714-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "714" in row 1
And I set field "kenn" to "FALL-714"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "714-LSEK"
And I close the current editor

# Storno Umlagerung
Given I open an editor "stUmlagerung" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-714"
And I set field "num4" to "714-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Umlagerung
Given I open an editor "stUmlagerung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+714-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-715
Scenario: FALL-715 Koppelprodukt Beistellung Rücklieferschein (wie 315)

# Konto 715-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0715FALL"
And I set field "such" to "FALL-715"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0715FALL"
And I set field "such" to "FALL-715"
And I set field "bestausekso" to "FALL-715"
And I save the current editor

# Kaufteil FALL-715-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "715-FALL-EK"
And I set field "num2" to "715-FALL-EK"
And I set field "such" to "FALL-715-EK"
And I set field "namebspr" to "Fall 715 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-715"
And I save the current editor

# Koppelprodukt
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "715-FALL-KP"
And I set field "num2" to "715-FALL-KP"
And I set field "such" to "FALL-715-KP"
And I set field "namebspr" to "Fall 715 Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "7,15"
And I set field "wgruppe" to "FALL-715"
And I save the current editor

# Verkaufsteil FALL-715-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "715-FALL-VK"
And I set field "num2" to "715-FALL-VK"
And I set field "such" to "FALL-715-VK"
And I set field "namebspr" to "Fall 715 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-715"
And I set field "elex" to "FALL-715-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
#
And I create a new row at the end of the table
And I set field "elex" to "715-FALL-KP" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-715" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "715-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-715-VK" in row 1
And I set field "mge" to "715" in row 1
And I set field "preis" to "715" in row 1
And I set field "kenn" to "FALL-715"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-715" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "715-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-715-EK" in row 1
And I set field "mge" to "715" in row 1
And I set field "preis" to "715" in row 1
And I set field "kenn" to "FALL-715 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "715-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-715" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-715"
And I set field "num4" to "715-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "715" in row 1
And I set field "preis" to "715" in row 1
And I set field "kenn" to "FALL-715 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+715-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-715" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "715-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-715-VK" in row 1
And I set field "mge" to "715" in row 1
And I set field "preis" to "715" in row 1
And I set field "kenn" to "FALL-715 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-715" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "715-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern715" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "715-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-715 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-715-EK" in row 1
And I set field "mge" to "715" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "715-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-715" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-715"
And I set field "num4" to "715-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "715" in row 1
And I set field "kenn" to "FALL-715"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "715-LSEK"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-715" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-715"
And I set field "num4" to "715-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-715 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+715-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-716
Scenario: FALL-716 Koppelprodukt Beistellung Storno Rücklieferschein (wie 514)

# Konto 716-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0716FALL"
And I set field "such" to "FALL-716"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0716FALL"
And I set field "such" to "FALL-716"
And I set field "bestausekso" to "FALL-716"
And I save the current editor

# Kaufteil FALL-716-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "716-FALL-EK"
And I set field "num2" to "716-FALL-EK"
And I set field "such" to "FALL-716-EK"
And I set field "namebspr" to "Fall 716 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-716"
And I save the current editor

# Koppelprodukt
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "716-FALL-KP"
And I set field "num2" to "716-FALL-KP"
And I set field "such" to "FALL-716-KP"
And I set field "namebspr" to "Fall 716 Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "7,16"
And I set field "wgruppe" to "FALL-716"
And I save the current editor

# Verkaufsteil FALL-716-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "716-FALL-VK"
And I set field "num2" to "716-FALL-VK"
And I set field "such" to "FALL-716-VK"
And I set field "namebspr" to "Fall 716 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-716"
And I set field "elex" to "FALL-716-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
#
And I create a new row at the end of the table
And I set field "elex" to "716-FALL-KP" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-716" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "716-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-716-VK" in row 1
And I set field "mge" to "716" in row 1
And I set field "preis" to "716" in row 1
And I set field "kenn" to "FALL-716"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-716" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "716-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-716-EK" in row 1
And I set field "mge" to "716" in row 1
And I set field "preis" to "716" in row 1
And I set field "kenn" to "FALL-716 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "716-BEEK"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rechnung anlegen
Given I open an editor "rechnung-716" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-716"
And I set field "num4" to "716-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "716" in row 1
And I set field "preis" to "716" in row 1
And I set field "kenn" to "FALL-716 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+716-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-716" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "716-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-716-VK" in row 1
And I set field "mge" to "716" in row 1
And I set field "preis" to "716" in row 1
And I set field "kenn" to "FALL-716 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-716" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "716-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern716" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "716-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-716 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-716-EK" in row 1
And I set field "mge" to "716" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "716-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-716" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-716"
And I set field "num4" to "716-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "716" in row 1
And I set field "kenn" to "FALL-716"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "716-LSEK"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-716" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-716"
And I set field "num4" to "716-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-716 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+716-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "st-lieferschein-716" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "rls-716"
And I set field "num4" to "716-SRLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+716-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-717
Scenario: FALL-717 Koppelprodukt nach 713 eine manuelle Umlagerung der Koppelprodukte ins interne Lager über einen EK Umlagerungs Lieferschein

# Konto 717-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0717FALL"
And I set field "such" to "FALL-717"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0717FALL"
And I set field "such" to "FALL-717"
And I set field "bestausekso" to "FALL-717"
And I save the current editor

# Kaufteil FALL-717-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "717-FALL-EK"
And I set field "num2" to "717-FALL-EK"
And I set field "such" to "FALL-717-EK"
And I set field "namebspr" to "Fall 717 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-717"
And I save the current editor

# Koppelprodukt
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "717-FALL-KP"
And I set field "num2" to "717-FALL-KP"
And I set field "such" to "FALL-717-KP"
And I set field "namebspr" to "Fall 717 Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "7,13"
And I set field "wgruppe" to "FALL-717"
And I save the current editor

# Verkaufsteil FALL-717-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "717-FALL-VK"
And I set field "num2" to "717-FALL-VK"
And I set field "such" to "FALL-717-VK"
And I set field "namebspr" to "Fall 717 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-717"
And I set field "elex" to "FALL-717-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
#
And I create a new row at the end of the table
And I set field "elex" to "717-FALL-KP" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-717" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "717-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-717-VK" in row 1
And I set field "mge" to "717" in row 1
And I set field "preis" to "717" in row 1
And I set field "kenn" to "FALL-717"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-717" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "717-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-717-EK" in row 1
And I set field "mge" to "717" in row 1
And I set field "preis" to "717" in row 1
And I set field "kenn" to "FALL-717 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "717-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-717" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-717"
And I set field "num4" to "717-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "717" in row 1
And I set field "preis" to "717" in row 1
And I set field "kenn" to "FALL-717 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+717-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-717" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "717-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-717-VK" in row 1
And I set field "mge" to "717" in row 1
And I set field "preis" to "717" in row 1
And I set field "kenn" to "FALL-717 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-717" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "717-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern717" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "717-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-717 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-717-EK" in row 1
And I set field "mge" to "717" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "717-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-717" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-717"
And I set field "num4" to "717-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "717" in row 1
And I set field "kenn" to "FALL-717"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "717-LSEK"
And I close the current editor

# Umlagerung Koppelprodukt ins interne Lager
And  I open an editor "Umlagern717" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "717-UML2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-717 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-717-KP" in row 1
And I set field "mge" to "717" in row 1
And I set field "abplatz" to "LBEIST" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "717-UML2"
And I close the current editor

#####################################################################################################################################

@FALL-718
Scenario: FALL-718 Koppelprodukt wie 715 ohne STL buchen

# Konto 718-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0718FALL"
And I set field "such" to "FALL-718"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0718FALL"
And I set field "such" to "FALL-718"
And I set field "bestausekso" to "FALL-718"
And I save the current editor

# Kaufteil FALL-718-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "718-FALL-EK"
And I set field "num2" to "718-FALL-EK"
And I set field "such" to "FALL-718-EK"
And I set field "namebspr" to "Fall 718 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-718"
And I save the current editor

# Koppelprodukt
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "718-FALL-KP"
And I set field "num2" to "718-FALL-KP"
And I set field "such" to "FALL-718-KP"
And I set field "namebspr" to "Fall 718 Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "7,15"
And I set field "wgruppe" to "FALL-718"
And I save the current editor

# Verkaufsteil FALL-718-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "718-FALL-VK"
And I set field "num2" to "718-FALL-VK"
And I set field "such" to "FALL-718-VK"
And I set field "namebspr" to "Fall 718 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-718"
And I set field "elex" to "FALL-718-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
#
And I create a new row at the end of the table
And I set field "elex" to "718-FALL-KP" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-718" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "718-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-718-VK" in row 1
And I set field "mge" to "718" in row 1
And I set field "preis" to "718" in row 1
And I set field "kenn" to "FALL-718"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-718" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "718-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-718-EK" in row 1
And I set field "mge" to "718" in row 1
And I set field "preis" to "718" in row 1
And I set field "kenn" to "FALL-718 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "718-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-718" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-718"
And I set field "num4" to "718-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "718" in row 1
And I set field "preis" to "718" in row 1
And I set field "kenn" to "FALL-718 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+718-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-718" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "718-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-718-VK" in row 1
And I set field "mge" to "718" in row 1
And I set field "preis" to "718" in row 1
And I set field "kenn" to "FALL-718 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-718" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "718-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern718" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "718-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-718 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-718-EK" in row 1
And I set field "mge" to "718" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "718-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-718" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-718"
And I set field "num4" to "718-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "718" in row 1
And I set field "kenn" to "FALL-718"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "718-LSEK"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-718" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-718"
And I set field "num4" to "718-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
#
# Hier die Stückliste nicht buchen
And I set field "stl" to "NEIN" in row 1
#
And I set field "kenn" to "FALL-718 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+718-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-719
Scenario: FALL-719 Koppelprodukt wie 716 ohne STL buchen

# Konto 719-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0719FALL"
And I set field "such" to "FALL-719"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0719FALL"
And I set field "such" to "FALL-719"
And I set field "bestausekso" to "FALL-719"
And I save the current editor

# Kaufteil FALL-719-EK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "719-FALL-EK"
And I set field "num2" to "719-FALL-EK"
And I set field "such" to "FALL-719-EK"
And I set field "namebspr" to "Fall 719 Einkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-719"
And I save the current editor

# Koppelprodukt
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "719-FALL-KP"
And I set field "num2" to "719-FALL-KP"
And I set field "such" to "FALL-719-KP"
And I set field "namebspr" to "Fall 719 Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "7,16"
And I set field "wgruppe" to "FALL-719"
And I save the current editor

# Verkaufsteil FALL-719-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "719-FALL-VK"
And I set field "num2" to "719-FALL-VK"
And I set field "such" to "FALL-719-VK"
And I set field "namebspr" to "Fall 719 Verkaufsteil"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "BEISTELL"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-719"
And I set field "elex" to "FALL-719-EK" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
#
And I create a new row at the end of the table
And I set field "elex" to "719-FALL-KP" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-719" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "719-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-719-VK" in row 1
And I set field "mge" to "719" in row 1
And I set field "preis" to "719" in row 1
And I set field "kenn" to "FALL-719"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-719" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "719-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-719-EK" in row 1
And I set field "mge" to "719" in row 1
And I set field "preis" to "719" in row 1
And I set field "kenn" to "FALL-719 Kaufteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "719-BEEK"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-719" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-719"
And I set field "num4" to "719-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "719" in row 1
And I set field "preis" to "719" in row 1
And I set field "kenn" to "FALL-719 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+719-REEK"
And I close the current editor

# Bestellung fuer Verkaufsteil anlegen
Given I open an editor "bestellung-719" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "BEISTELL"
And I set field "num4" to "719-BEVK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-719-VK" in row 1
And I set field "mge" to "719" in row 1
And I set field "preis" to "719" in row 1
And I set field "kenn" to "FALL-719 Verkaufsteil"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-719" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "719-BEVK"
And I close the current editor

# Dispo starten
And I run Scheduling

# Umlagerung Beistellung an Lieferant
And  I open an editor "Umlagern719" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "BEISTELL"
And I set field "num4" to "719-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-719 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-719-EK" in row 1
And I set field "mge" to "719" in row 1
And I set field "platz" to "LBEIST" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "719-UML"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-719" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-719"
And I set field "num4" to "719-LSEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "719" in row 1
And I set field "kenn" to "FALL-719"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "719-LSEK"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-719" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-719"
And I set field "num4" to "719-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
#
# Hier die Stückliste nicht buchen
And I set field "stl" to "NEIN" in row 1
#
And I set field "kenn" to "FALL-719 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+719-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "st-lieferschein-719" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "rls-719"
And I set field "num4" to "719-SRLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+719-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-730
Scenario: FALL-730 Lohnfertigung mit Lieferanten-Beistellung mit Koppelprodukt	EK 	Lieferung

# Konto 730-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0730FALL"
And I set field "such" to "FALL-730"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0730FALL"
And I set field "such" to "FALL-730"
And I set field "bestausekso" to "FALL-730"
And I save the current editor

# Kaufteil FALL-730-EK1 (Beistellteil zur Lohnfertigung)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "730-FALL-EK1"
And I set field "num2" to "730-FALL-EK1"
And I set field "such" to "FALL-730-EK1"
And I set field "namebspr" to "Fall 730 EK Beistell zu Lohnf"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-730"
And I save the current editor

# Kaufteil FALL-730-EK2 (Beistellteil zum Verkaufsteil)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "730-FALL-EK2"
And I set field "num2" to "730-FALL-EK2"
And I set field "such" to "FALL-730-EK2"
And I set field "namebspr" to "Fall 730 EK Beistell zu Vk"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-730"
And I save the current editor

# Koppelprodukt (zur Lohnfertigung)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "730-FALL-KP1"
And I set field "num2" to "730-FALL-KP1"
And I set field "such" to "FALL-730-KP1"
And I set field "namebspr" to "Fall 730 Koppelprod zu Lohnf"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "730"
And I set field "wgruppe" to "FALL-730"
And I save the current editor

# Koppelprodukt (zum Beitellteil)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "730-FALL-KP2"
And I set field "num2" to "730-FALL-KP2"
And I set field "such" to "FALL-730-KP2"
And I set field "namebspr" to "Fall 730 Koppelprod zu Beistell"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "730"
And I set field "wgruppe" to "FALL-730"
And I save the current editor

# Lohnfertigung FALL-730-LOH
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "730-FALL-LOH"
And I set field "num2" to "730-FALL-LOH"
And I set field "such" to "FALL-730-LOH"
And I set field "namebspr" to "Fall 730 Lohnfertigung"
And I set field "bsart" to "Lohnfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "LOHNFERT"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I create a new row at the end of the table
And I set field "elex" to "FALL-730-EK1" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "730-FALL-KP1" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I set field "ekbewverf" to "6"
And I save the current editor

# Verkaufsteil FALL-730-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "730-FALL-VK"
And I set field "num2" to "730-FALL-VK"
And I set field "such" to "FALL-730-VK"
And I set field "namebspr" to "Fall 730 Verkaufsteil"
And I set field "bsart" to "Eigenfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-730"
And I set field "elex" to "FALL-730-EK2" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-730-KP2" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "lfbeist" to "1" in row 2
And I create a new row at the end of the table
And I set field "elex" to "FALL-730-LOH" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "breite" to "" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 4
And I set field "anzahl" to "1" in row 4
And I set field "breite" to "15" in row 4
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-730" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "730-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-730-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-730"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-730" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "730-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-730-EK1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-730-EK2" in row 2
And I set field "mge" to "10" in row 2
And I set field "preis" to "5" in row 2
And I set field "kenn" to "FALL-730 Kaufteile"
And I save the current editor

# # Ausgabe Bestellung
# Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "730-BEEK"
# And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-730" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-730"
And I set field "num4" to "730-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "3,30" in row 1
And I set field "mge" to "10" in row 2
And I set field "preis" to "5,30" in row 2
And I set field "kenn" to "FALL-730 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+730-REEK"
And I close the current editor

# Umlagerung Beistellung an Lohnfertiger
And  I open an editor "Umlagern730" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "LOHNFERT"
And I set field "num4" to "730-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "F1"
And I set field "kenn" to "FALL-730 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-730-EK1" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "LOHNF" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-730-EK2" in row 2
And I set field "mge" to "10" in row 2
And I set field "platz" to "LOHNF" in row 2
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+730-UML"
And I close the current editor

# Lohnfertigungsvorschlag freigeben
Given I open an editor "lohv-730" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FALL-730-LOH"
And I press button "ladetab"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "bestellung-loh"
And I set field "nummer" to "730-BELO"
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-730"
And I save the current editor
# And I close the current editor
And I switch the current editor to editor "lohv-730"
And I close the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "730-BELO"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-730" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-loh"
And I set field "num4" to "730-LSLO"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "kenn" to "FALL-730"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "730-LSLO"
And I close the current editor

#####################################################################################################################################

@FALL-731
Scenario: FALL-731 Lohnfertigung mit Lieferanten-Beistellung mit Koppelprodukt	EK 	Storno Lieferschein

# Konto 731-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0731FALL"
And I set field "such" to "FALL-731"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0731FALL"
And I set field "such" to "FALL-731"
And I set field "bestausekso" to "FALL-731"
And I save the current editor

# Kaufteil FALL-731-EK1 (Beistellteil zur Lohnfertigung)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "731-FALL-EK1"
And I set field "num2" to "731-FALL-EK1"
And I set field "such" to "FALL-731-EK1"
And I set field "namebspr" to "Fall 731 EK Beistell zu Lohnf"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-731"
And I save the current editor

# Kaufteil FALL-731-EK2 (Beistellteil zum Verkaufsteil)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "731-FALL-EK2"
And I set field "num2" to "731-FALL-EK2"
And I set field "such" to "FALL-731-EK2"
And I set field "namebspr" to "Fall 731 EK Beistell zu Vk"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-731"
And I save the current editor

# Koppelprodukt (zur Lohnfertigung)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "731-FALL-KP1"
And I set field "num2" to "731-FALL-KP1"
And I set field "such" to "FALL-731-KP1"
And I set field "namebspr" to "Fall 731 Koppelprod zu Lohnf"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "731"
And I set field "wgruppe" to "FALL-731"
And I save the current editor

# Koppelprodukt (zum Beitellteil)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "731-FALL-KP2"
And I set field "num2" to "731-FALL-KP2"
And I set field "such" to "FALL-731-KP2"
And I set field "namebspr" to "Fall 731 Koppelprod zu Beistell"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "731"
And I set field "wgruppe" to "FALL-731"
And I save the current editor

# Lohnfertigung FALL-731-LOH
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "731-FALL-LOH"
And I set field "num2" to "731-FALL-LOH"
And I set field "such" to "FALL-731-LOH"
And I set field "namebspr" to "Fall 731 Lohnfertigung"
And I set field "bsart" to "Lohnfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "LOHNFERT"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I create a new row at the end of the table
And I set field "elex" to "FALL-731-EK1" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "731-FALL-KP1" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I set field "ekbewverf" to "6"
And I save the current editor

# Verkaufsteil FALL-731-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "731-FALL-VK"
And I set field "num2" to "731-FALL-VK"
And I set field "such" to "FALL-731-VK"
And I set field "namebspr" to "Fall 731 Verkaufsteil"
And I set field "bsart" to "Eigenfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-731"
And I set field "elex" to "FALL-731-EK2" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-731-KP2" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "lfbeist" to "1" in row 2
And I create a new row at the end of the table
And I set field "elex" to "FALL-731-LOH" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "breite" to "" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 4
And I set field "anzahl" to "1" in row 4
And I set field "breite" to "15" in row 4
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-731" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "731-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-731-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-731"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-731" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "731-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-731-EK1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-731-EK2" in row 2
And I set field "mge" to "10" in row 2
And I set field "preis" to "5" in row 2
And I set field "kenn" to "FALL-731 Kaufteile"
And I save the current editor

# # Ausgabe Bestellung
# Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "731-BEEK"
# And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-731" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-731"
And I set field "num4" to "731-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "3,30" in row 1
And I set field "mge" to "10" in row 2
And I set field "preis" to "5,30" in row 2
And I set field "kenn" to "FALL-731 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+731-REEK"
And I close the current editor

# Umlagerung Beistellung an Lohnfertiger
And  I open an editor "Umlagern731" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "LOHNFERT"
And I set field "num4" to "731-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "F1"
And I set field "kenn" to "FALL-731 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-731-EK1" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "LOHNF" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-731-EK2" in row 2
And I set field "mge" to "10" in row 2
And I set field "platz" to "LOHNF" in row 2
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+731-UML"
And I close the current editor

# Lohnfertigungsvorschlag freigeben
Given I open an editor "lohv-731" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FALL-731-LOH"
And I press button "ladetab"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "bestellung-loh"
And I set field "nummer" to "731-BELO"
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-731"
And I save the current editor
# And I close the current editor
And I switch the current editor to editor "lohv-731"
And I close the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "731-BELO"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-731" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-loh"
And I set field "num4" to "731-LSLO"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "kenn" to "FALL-731"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "731-LSLO"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "731-LSLO"
And I set field "num4" to "731-STLS"
And I save the current editor

# Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+731-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-732
Scenario: FALL-732 Lohnfertigung mit Lieferanten-Beistellung mit Koppelprodukt	EK 	Rücklieferschein

# Konto 732-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0732FALL"
And I set field "such" to "FALL-732"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0732FALL"
And I set field "such" to "FALL-732"
And I set field "bestausekso" to "FALL-732"
And I save the current editor

# Kaufteil FALL-732-EK1 (Beistellteil zur Lohnfertigung)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "732-FALL-EK1"
And I set field "num2" to "732-FALL-EK1"
And I set field "such" to "FALL-732-EK1"
And I set field "namebspr" to "Fall 732 EK Beistell zu Lohnf"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-732"
And I save the current editor

# Kaufteil FALL-732-EK2 (Beistellteil zum Verkaufsteil)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "732-FALL-EK2"
And I set field "num2" to "732-FALL-EK2"
And I set field "such" to "FALL-732-EK2"
And I set field "namebspr" to "Fall 732 EK Beistell zu Vk"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-732"
And I save the current editor

# Koppelprodukt (zur Lohnfertigung)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "732-FALL-KP1"
And I set field "num2" to "732-FALL-KP1"
And I set field "such" to "FALL-732-KP1"
And I set field "namebspr" to "Fall 732 Koppelprod zu Lohnf"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "732"
And I set field "wgruppe" to "FALL-732"
And I save the current editor

# Koppelprodukt (zum Beitellteil)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "732-FALL-KP2"
And I set field "num2" to "732-FALL-KP2"
And I set field "such" to "FALL-732-KP2"
And I set field "namebspr" to "Fall 732 Koppelprod zu Beistell"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "732"
And I set field "wgruppe" to "FALL-732"
And I save the current editor

# Lohnfertigung FALL-732-LOH
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "732-FALL-LOH"
And I set field "num2" to "732-FALL-LOH"
And I set field "such" to "FALL-732-LOH"
And I set field "namebspr" to "Fall 732 Lohnfertigung"
And I set field "bsart" to "Lohnfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "LOHNFERT"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I create a new row at the end of the table
And I set field "elex" to "FALL-732-EK1" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "732-FALL-KP1" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I set field "ekbewverf" to "6"
And I save the current editor

# Verkaufsteil FALL-732-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "732-FALL-VK"
And I set field "num2" to "732-FALL-VK"
And I set field "such" to "FALL-732-VK"
And I set field "namebspr" to "Fall 732 Verkaufsteil"
And I set field "bsart" to "Eigenfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-732"
And I set field "elex" to "FALL-732-EK2" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-732-KP2" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "lfbeist" to "1" in row 2
And I create a new row at the end of the table
And I set field "elex" to "FALL-732-LOH" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "breite" to "" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 4
And I set field "anzahl" to "1" in row 4
And I set field "breite" to "15" in row 4
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-732" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "732-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-732-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-732"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-732" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "732-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-732-EK1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-732-EK2" in row 2
And I set field "mge" to "10" in row 2
And I set field "preis" to "5" in row 2
And I set field "kenn" to "FALL-732 Kaufteile"
And I save the current editor

# # Ausgabe Bestellung
# Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "732-BEEK"
# And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-732" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-732"
And I set field "num4" to "732-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "3,30" in row 1
And I set field "mge" to "10" in row 2
And I set field "preis" to "5,30" in row 2
And I set field "kenn" to "FALL-732 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+732-REEK"
And I close the current editor

# Umlagerung Beistellung an Lohnfertiger
And  I open an editor "Umlagern732" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "LOHNFERT"
And I set field "num4" to "732-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "F1"
And I set field "kenn" to "FALL-732 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-732-EK1" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "LOHNF" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-732-EK2" in row 2
And I set field "mge" to "10" in row 2
And I set field "platz" to "LOHNF" in row 2
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+732-UML"
And I close the current editor

# Lohnfertigungsvorschlag freigeben
Given I open an editor "lohv-732" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FALL-732-LOH"
And I press button "ladetab"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "bestellung-loh"
And I set field "nummer" to "732-BELO"
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-732"
And I save the current editor
# And I close the current editor
And I switch the current editor to editor "lohv-732"
And I close the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "732-BELO"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-732" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-loh"
And I set field "num4" to "732-LSLO"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "kenn" to "FALL-732"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "732-LSLO"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-732" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "732-LSLO"
And I set field "num4" to "732-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I set field "kenn" to "FALL-732 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-732"
And I close the current editor

#####################################################################################################################################

@FALL-733
Scenario: FALL-733 Lohnfertigung mit Lieferanten-Beistellung mit Koppelprodukt	EK 	Storno Rücklieferschein

# Konto 733-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0733FALL"
And I set field "such" to "FALL-733"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0733FALL"
And I set field "such" to "FALL-733"
And I set field "bestausekso" to "FALL-733"
And I save the current editor

# Kaufteil FALL-733-EK1 (Beistellteil zur Lohnfertigung)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "733-FALL-EK1"
And I set field "num2" to "733-FALL-EK1"
And I set field "such" to "FALL-733-EK1"
And I set field "namebspr" to "Fall 733 EK Beistell zu Lohnf"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-733"
And I save the current editor

# Kaufteil FALL-733-EK2 (Beistellteil zum Verkaufsteil)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "733-FALL-EK2"
And I set field "num2" to "733-FALL-EK2"
And I set field "such" to "FALL-733-EK2"
And I set field "namebspr" to "Fall 733 EK Beistell zu Vk"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-733"
And I save the current editor

# Koppelprodukt (zur Lohnfertigung)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "733-FALL-KP1"
And I set field "num2" to "733-FALL-KP1"
And I set field "such" to "FALL-733-KP1"
And I set field "namebspr" to "Fall 733 Koppelprod zu Lohnf"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "733"
And I set field "wgruppe" to "FALL-733"
And I save the current editor

# Koppelprodukt (zum Beitellteil)
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "733-FALL-KP2"
And I set field "num2" to "733-FALL-KP2"
And I set field "such" to "FALL-733-KP2"
And I set field "namebspr" to "Fall 733 Koppelprod zu Beistell"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "efrist" to "2"
And I set field "epr" to "3"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "733"
And I set field "wgruppe" to "FALL-733"
And I save the current editor

# Lohnfertigung FALL-733-LOH
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "733-FALL-LOH"
And I set field "num2" to "733-FALL-LOH"
And I set field "such" to "FALL-733-LOH"
And I set field "namebspr" to "Fall 733 Lohnfertigung"
And I set field "bsart" to "Lohnfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "LOHNFERT"
And I set field "efrist" to "2"
And I set field "epr" to "3"
And I create a new row at the end of the table
And I set field "elex" to "FALL-733-EK1" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I create a new row at the end of the table
And I set field "elex" to "733-FALL-KP1" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "bua" to "Lieferantenbeistellung" in row 2
#
And I set field "ekbewverf" to "6"
And I save the current editor

# Verkaufsteil FALL-733-VK
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "733-FALL-VK"
And I set field "num2" to "733-FALL-VK"
And I set field "such" to "FALL-733-VK"
And I set field "namebspr" to "Fall 733 Verkaufsteil"
And I set field "bsart" to "Eigenfertigung"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-733"
And I set field "elex" to "FALL-733-EK2" in row 1
And I set field "anzahl" to "1" in row 1
And I set field "breite" to "0" in row 1
And I set field "lfbeist" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-733-KP2" in row 2
And I set field "kompeig" to "Koppel" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "breite" to "0" in row 2
And I set field "lfbeist" to "1" in row 2
And I create a new row at the end of the table
And I set field "elex" to "FALL-733-LOH" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "breite" to "" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A 122" in row 4
And I set field "anzahl" to "1" in row 4
And I set field "breite" to "15" in row 4
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-733" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "733-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-733-VK" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "kenn" to "FALL-733"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-733" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "733-BEEK"
And I create a new row at the end of the table
And I set field "artex" to "FALL-733-EK1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "3" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-733-EK2" in row 2
And I set field "mge" to "10" in row 2
And I set field "preis" to "5" in row 2
And I set field "kenn" to "FALL-733 Kaufteile"
And I save the current editor

# # Ausgabe Bestellung
# Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "733-BEEK"
# And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-733" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-733"
And I set field "num4" to "733-REEK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "3,30" in row 1
And I set field "mge" to "10" in row 2
And I set field "preis" to "5,30" in row 2
And I set field "kenn" to "FALL-733 Kaufteil"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+733-REEK"
And I close the current editor

# Umlagerung Beistellung an Lohnfertiger
And  I open an editor "Umlagern733" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "LOHNFERT"
And I set field "num4" to "733-UML"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "F1"
And I set field "kenn" to "FALL-733 Umlagern"
And I create a new row at the end of the table
And I set field "artex" to "FALL-733-EK1" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "LOHNF" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-733-EK2" in row 2
And I set field "mge" to "10" in row 2
And I set field "platz" to "LOHNF" in row 2
And I save the current editor

# Ausgabe Umlagerung
Given I open an editor "bestellung-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+733-UML"
And I close the current editor

# Lohnfertigungsvorschlag freigeben
Given I open an editor "lohv-733" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "FALL-733-LOH"
And I press button "ladetab"
Then the table has 1 rows
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "bestellung-loh"
And I set field "nummer" to "733-BELO"
And I set field "preis" to "5" in row 1
And I set field "kenn" to "FALL-733"
And I save the current editor
# And I close the current editor
And I switch the current editor to editor "lohv-733"
And I close the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "733-BELO"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-733" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-loh"
And I set field "num4" to "733-LSLO"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "kenn" to "FALL-733"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "733-LSLO"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-733" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "733-LSLO"
And I set field "num4" to "733-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-3" in row 1
And I set field "kenn" to "FALL-733 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-733"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "rls-733"
And I set field "num4" to "733-STRL"
And I save the current editor

# Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+733-STRL"
And I close the current editor

#####################################################################################################################################

@FALL-751
Scenario:  FALL-751 EK	Lieferantenkonsignation Anlieferavis

# Konto 751-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0751FALL"
And I set field "such" to "FALL-751"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0751FALL"
And I set field "such" to "FALL-751"
And I set field "bestausekso" to "FALL-751"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "751-FALL"
And I set field "num2" to "751-FALL"
And I set field "such" to "FALL-751"
And I set field "namebspr" to "FALL-751"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "KONSILIE"
And I set field "wgruppe" to "FALL-751"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-751"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-751" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "KONSILIE"
And I set field "num4" to "751-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-751" in row 1
And I set field "mge" to "751" in row 1
And I set field "preis" to "751" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-751"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "751-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-751" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-751"
And I set field "num4" to "751-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "751" in row 1
And I set field "rerelev" to "NEIN" in row 1
And I set field "kenn" to "FALL-751"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+751-LS"
And I close the current editor

#####################################################################################################################################

@FALL-752
Scenario:  FALL-752 EK	Lieferantenkonsignation Entnahme

# Konto 752-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0752FALL"
And I set field "such" to "FALL-752"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0752FALL"
And I set field "such" to "FALL-752"
And I set field "bestausekso" to "FALL-752"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "752-FALL"
And I set field "num2" to "752-FALL"
And I set field "such" to "FALL-752"
And I set field "namebspr" to "FALL-752"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "KONSILIE"
And I set field "wgruppe" to "FALL-752"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-752"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-752" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "KONSILIE"
And I set field "num4" to "752-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-752" in row 1
And I set field "mge" to "752" in row 1
And I set field "preis" to "752" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-752"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "752-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-752" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-752"
And I set field "num4" to "752-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "752" in row 1
And I set field "rerelev" to "NEIN" in row 1
And I set field "kenn" to "FALL-752"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+752-LS"
And I close the current editor

# Entnahme Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-752" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "752-ELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-752" in row 1
And I set field "abplatz" to "LKONSI" in row 1
And I set field "mge" to "152" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-752"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "752-ELS"
And I close the current editor

#####################################################################################################################################

@FALL-753
Scenario:  FALL-753 EK	Lieferantenkonsignation Rechnung

# Konto 753-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0753FALL"
And I set field "such" to "FALL-753"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0753FALL"
And I set field "such" to "FALL-753"
And I set field "bestausekso" to "FALL-753"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "753-FALL"
And I set field "num2" to "753-FALL"
And I set field "such" to "FALL-753"
And I set field "namebspr" to "FALL-753"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "KONSILIE"
And I set field "wgruppe" to "FALL-753"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-753"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-753" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "KONSILIE"
And I set field "num4" to "753-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-753" in row 1
And I set field "mge" to "753" in row 1
And I set field "preis" to "753" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-753"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "753-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-753" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-753"
And I set field "num4" to "753-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "753" in row 1
And I set field "rerelev" to "NEIN" in row 1
And I set field "kenn" to "FALL-753"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+753-LS"
And I close the current editor

# Entnahme Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-753" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "753-ELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-753" in row 1
And I set field "abplatz" to "LKONSI" in row 1
And I set field "mge" to "152" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-753"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "753-ELS"
And I close the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rechnung anlegen
Given I open an editor "rechnung-753" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-753"
And I set field "num4" to "753-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "152" in row 1
And I set field "preis" to "753" in row 1
And I set field "kenn" to "FALL-753"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "lieferschein-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+753-RE"
And I close the current editor


#####################################################################################################################################

@FALL-761
Scenario:  FALL-761 Storno EK Lieferantenkonsignation Anlieferavis

# Konto 761-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0761FALL"
And I set field "such" to "FALL-761"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0761FALL"
And I set field "such" to "FALL-761"
And I set field "bestausekso" to "FALL-761"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "761-FALL"
And I set field "num2" to "761-FALL"
And I set field "such" to "FALL-761"
And I set field "namebspr" to "FALL-761"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "KONSILIE"
And I set field "wgruppe" to "FALL-761"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-761"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-761" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "KONSILIE"
And I set field "num4" to "761-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-761" in row 1
And I set field "mge" to "761" in row 1
And I set field "preis" to "761" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-761"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "761-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-761" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-761"
And I set field "num4" to "761-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "761" in row 1
And I set field "rerelev" to "NEIN" in row 1
And I set field "kenn" to "FALL-761"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+761-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+761-LS"
And I set field "num4" to "761-STLS"
And I save the current editor

# Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+761-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-762
Scenario:  FALL-762 Storno EK Lieferantenkonsignation Entnahme

# Konto 762-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0762FALL"
And I set field "such" to "FALL-762"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0762FALL"
And I set field "such" to "FALL-762"
And I set field "bestausekso" to "FALL-762"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "762-FALL"
And I set field "num2" to "762-FALL"
And I set field "such" to "FALL-762"
And I set field "namebspr" to "FALL-762"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "KONSILIE"
And I set field "wgruppe" to "FALL-762"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-762"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-762" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "KONSILIE"
And I set field "num4" to "762-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-762" in row 1
And I set field "mge" to "762" in row 1
And I set field "preis" to "762" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-762"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "762-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-762" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-762"
And I set field "num4" to "762-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "762" in row 1
And I set field "rerelev" to "NEIN" in row 1
And I set field "kenn" to "FALL-762"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+762-LS"
And I close the current editor

# Entnahme Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-762" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "762-ELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-762" in row 1
And I set field "abplatz" to "LKONSI" in row 1
And I set field "mge" to "152" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-762"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "762-ELS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "762-ELS"
And I set field "num4" to "762-SELS"
And I save the current editor

# Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+762-SELS"
And I close the current editor

#####################################################################################################################################

@FALL-763
Scenario:  FALL-763 Storno EK Lieferantenkonsignation Rechnung

# Konto 763-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0763FALL"
And I set field "such" to "FALL-763"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0763FALL"
And I set field "such" to "FALL-763"
And I set field "bestausekso" to "FALL-763"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "763-FALL"
And I set field "num2" to "763-FALL"
And I set field "such" to "FALL-763"
And I set field "namebspr" to "FALL-763"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "KONSILIE"
And I set field "wgruppe" to "FALL-763"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-763"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-763" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "KONSILIE"
And I set field "num4" to "763-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-763" in row 1
And I set field "mge" to "763" in row 1
And I set field "preis" to "763" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-763"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "763-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-763" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-763"
And I set field "num4" to "763-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "763" in row 1
And I set field "rerelev" to "NEIN" in row 1
And I set field "kenn" to "FALL-763"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+763-LS"
And I close the current editor

# Entnahme Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-763" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "num4" to "763-ELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-763" in row 1
And I set field "abplatz" to "LKONSI" in row 1
And I set field "mge" to "152" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-763"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "763-ELS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-763" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-763"
And I set field "num4" to "763-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "152" in row 1
And I set field "preis" to "763" in row 1
And I set field "kenn" to "FALL-763"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "lieferschein-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+763-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "Rechnung-763" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+763-RE"
And I set field "num4" to "763-SRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+763-SRE"
And I close the current editor

#####################################################################################################################################

@FALL-801
Scenario: FALL-801 Mengenneubewertung eines Lagerbestands

# Konto 801-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0801FALL"
And I set field "such" to "FALL-801"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0801FALL"
And I set field "such" to "FALL-801"
And I set field "bestausekso" to "FALL-801"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "801-FALL"
And I set field "num2" to "801-FALL"
And I set field "such" to "FALL-801"
And I set field "namebspr" to "FALL-801"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-801"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-801"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-801" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "801-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-801" in row 1
And I set field "mge" to "801" in row 1
And I set field "preis" to "801" in row 1
And I set field "kenn" to "FALL-801"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "801-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-801" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-801"
And I set field "num4" to "801-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "801" in row 1
And I set field "kenn" to "FALL-801"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "801-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-801" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-801"
And I set field "num4" to "801-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "801" in row 1
And I set field "preis" to "801" in row 1
And I set field "kenn" to "FALL-801"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+801-RE"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-801" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0801FALL"
And I set field "such" to "FALL-801"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-801;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-801"
And I close the current editor

#####################################################################################################################################

@FALL-802
Scenario: FALL-802 Storno EK Rechnung Storno nach Mengenneubewertung

# Konto 802-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0802FALL"
And I set field "such" to "FALL-802"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0802FALL"
And I set field "such" to "FALL-802"
And I set field "bestausekso" to "FALL-802"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "802-FALL"
And I set field "num2" to "802-FALL"
And I set field "such" to "FALL-802"
And I set field "namebspr" to "FALL-802"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-802"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-802"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-802" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "802-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-802" in row 1
And I set field "mge" to "802" in row 1
And I set field "preis" to "802" in row 1
And I set field "kenn" to "FALL-802"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "802-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-802" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-802"
And I set field "num4" to "802-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "802" in row 1
And I set field "kenn" to "FALL-802"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "802-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-802" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-802"
And I set field "num4" to "802-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "802" in row 1
And I set field "preis" to "802" in row 1
And I set field "kenn" to "FALL-802"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+802-RE"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-802" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0802FALL"
And I set field "such" to "FALL-802"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-802;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-802"
And I close the current editor

# Storno Rechnung nicht mehr erlaubt
And opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung-802" throws the exception "3335"

#####################################################################################################################################

@FALL-803
Scenario: FALL-803 Storno EK Lieferschein nach Storno EK Rechnung Storno nach Mengenneubewertung

# Konto 803-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0803FALL"
And I set field "such" to "FALL-803"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0803FALL"
And I set field "such" to "FALL-803"
And I set field "bestausekso" to "FALL-803"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "803-FALL"
And I set field "num2" to "803-FALL"
And I set field "such" to "FALL-803"
And I set field "namebspr" to "FALL-803"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-803"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-803"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-803" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "803-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-803" in row 1
And I set field "mge" to "803" in row 1
And I set field "preis" to "803" in row 1
And I set field "kenn" to "FALL-803"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "803-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-803" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-803"
And I set field "num4" to "803-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "803" in row 1
And I set field "kenn" to "FALL-803"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "803-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-803" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-803"
And I set field "num4" to "803-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "803" in row 1
And I set field "preis" to "803" in row 1
And I set field "kenn" to "FALL-803"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+803-RE"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-803" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0803FALL"
And I set field "such" to "FALL-803"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-803;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-803"
And I close the current editor

# Storno Rechnung nicht mehr erlaubt
And opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung-803" throws the exception "3335"

# Storno Lieferschein auch nicht erlaubt
And opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-803" throws the exception "3335"


#####################################################################################################################################

@FALL-804
Scenario: FALL-804 EK Storno der Mengenneubewertung

# Konto 804-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0804FALL"
And I set field "such" to "FALL-804"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0804FALL"
And I set field "such" to "FALL-804"
And I set field "bestausekso" to "FALL-804"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "804-FALL"
And I set field "num2" to "804-FALL"
And I set field "such" to "FALL-804"
And I set field "namebspr" to "FALL-804"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-804"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-804"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-804" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "804-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-804" in row 1
And I set field "mge" to "804" in row 1
And I set field "preis" to "804" in row 1
And I set field "kenn" to "FALL-804"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "804-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-804" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-804"
And I set field "num4" to "804-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "804" in row 1
And I set field "kenn" to "FALL-804"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "804-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-804" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-804"
And I set field "num4" to "804-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "804" in row 1
And I set field "preis" to "804" in row 1
And I set field "kenn" to "FALL-804"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+804-RE"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-804" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0804FALL"
And I set field "such" to "FALL-804"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-804;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-804"
And I close the current editor

# Storno Mengenneubewertung
Given I open an editor "mgebewneu-804" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+FALL-804"
And I set field "nummer" to "0804ST"
And I set field "such" to "FALL-804S"
# And I create a new row at the end of the table
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-804S"
And I close the current editor

#####################################################################################################################################

@FALL-805
Scenario: FALL-805 (Storno) EK Neue Rechnung nach dem Storno

# Konto 805-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0805FALL"
And I set field "such" to "FALL-805"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0805FALL"
And I set field "such" to "FALL-805"
And I set field "bestausekso" to "FALL-805"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "805-FALL"
And I set field "num2" to "805-FALL"
And I set field "such" to "FALL-805"
And I set field "namebspr" to "FALL-805"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-805"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-805"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-805" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "805-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-805" in row 1
And I set field "mge" to "805" in row 1
And I set field "preis" to "805" in row 1
And I set field "kenn" to "FALL-805"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "805-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-805" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-805"
And I set field "num4" to "805-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "805" in row 1
And I set field "kenn" to "FALL-805"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "805-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-805" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-805"
And I set field "num4" to "805-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "805" in row 1
And I set field "preis" to "805" in row 1
And I set field "kenn" to "FALL-805"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+805-RE"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-805" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0805FALL"
And I set field "such" to "FALL-805"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-805;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-805"
And I close the current editor

# Storno Mengenneubewertung
Given I open an editor "mgebewneu-805" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+FALL-805"
And I set field "nummer" to "0805ST"
And I set field "such" to "FALL-805S"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-805S"
And I close the current editor

# Storno Rechnung
Given I open an editor "Rechnung-805" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung-805"
And I set field "num4" to "805-SRE"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+805-SRE"
And I close the current editor

# Rechnung 2 anlegen
Given I open an editor "rechnung-805-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-805"
And I set field "num4" to "805-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "805" in row 1
And I set field "preis" to "401" in row 1
And I set field "kenn" to "FALL-805"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung 2
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+805-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-806
Scenario: FALL-806 Neu EK Mengenneubewertung zu EK Lieferschein

# Konto 806-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0806FALL"
And I set field "such" to "FALL-806"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0806FALL"
And I set field "such" to "FALL-806"
And I set field "bestausekso" to "FALL-806"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "806-FALL"
And I set field "num2" to "806-FALL"
And I set field "such" to "FALL-806"
And I set field "namebspr" to "FALL-806"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-806"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-806"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-806" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "806-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-806" in row 1
And I set field "mge" to "806" in row 1
And I set field "preis" to "806" in row 1
And I set field "kenn" to "FALL-806"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "806-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-806" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-806"
And I set field "num4" to "806-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "806" in row 1
And I set field "kenn" to "FALL-806"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "806-LS"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-806" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0806FALL"
And I set field "such" to "FALL-806"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-806;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-806"
And I close the current editor

#####################################################################################################################################

@FALL-807
Scenario: FALL-807 Storno EK Mengenneubewertung

# Konto 807-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0807FALL"
And I set field "such" to "FALL-807"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0807FALL"
And I set field "such" to "FALL-807"
And I set field "bestausekso" to "FALL-807"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "807-FALL"
And I set field "num2" to "807-FALL"
And I set field "such" to "FALL-807"
And I set field "namebspr" to "FALL-807"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-807"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-807"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-807" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "807-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-807" in row 1
And I set field "mge" to "807" in row 1
And I set field "preis" to "807" in row 1
And I set field "kenn" to "FALL-807"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "807-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-807" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-807"
And I set field "num4" to "807-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "807" in row 1
And I set field "kenn" to "FALL-807"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "807-LS"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-807" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0807FALL"
And I set field "such" to "FALL-807"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-807;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-807"
And I close the current editor

# Storno Mengenneubewertung
Given I open an editor "mgebewneu-807" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+FALL-807"
And I set field "nummer" to "0807ST"
And I set field "such" to "FALL-807S"
# And I create a new row at the end of the table
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-807S"
And I close the current editor

#####################################################################################################################################

@FALL-808
Scenario: FALL-808 Neu EK Rechnung nach Mengenneubewertung

# Konto 808-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0808FALL"
And I set field "such" to "FALL-808"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0808FALL"
And I set field "such" to "FALL-808"
And I set field "bestausekso" to "FALL-808"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "808-FALL"
And I set field "num2" to "808-FALL"
And I set field "such" to "FALL-808"
And I set field "namebspr" to "FALL-808"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-808"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-808"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-808" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "808-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-808" in row 1
And I set field "mge" to "808" in row 1
And I set field "preis" to "808" in row 1
And I set field "kenn" to "FALL-808"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "808-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-808" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-808"
And I set field "num4" to "808-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "808" in row 1
And I set field "kenn" to "FALL-808"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "808-LS"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-808" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0808FALL"
And I set field "such" to "FALL-808"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-808;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-808"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-808" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-808"
And I set field "num4" to "808-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "808" in row 1
And I set field "preis" to "808" in row 1
And I set field "kenn" to "FALL-808"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+808-RE"
And I close the current editor

#####################################################################################################################################

@FALL-809
Scenario: FALL-809 EK Storno der Rechnung nach Mengenneubewertung

# Konto 809-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0809FALL"
And I set field "such" to "FALL-809"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0809FALL"
And I set field "such" to "FALL-809"
And I set field "bestausekso" to "FALL-809"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "809-FALL"
And I set field "num2" to "809-FALL"
And I set field "such" to "FALL-809"
And I set field "namebspr" to "FALL-809"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-809"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-809"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-809" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "809-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-809" in row 1
And I set field "mge" to "809" in row 1
And I set field "preis" to "809" in row 1
And I set field "kenn" to "FALL-809"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "809-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-809" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-809"
And I set field "num4" to "809-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "809" in row 1
And I set field "kenn" to "FALL-809"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "809-LS"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-809" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0809FALL"
And I set field "such" to "FALL-809"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-809;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-809"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-809" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-809"
And I set field "num4" to "809-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "809" in row 1
And I set field "preis" to "809" in row 1
And I set field "kenn" to "FALL-809"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+809-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-809" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+809-RE"
And I set field "num4" to "809-STRE"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+809-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-810
Scenario: FALL-810 Storno EK der Mengenneubewertung

# Konto 810-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0810FALL"
And I set field "such" to "FALL-810"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0810FALL"
And I set field "such" to "FALL-810"
And I set field "bestausekso" to "FALL-810"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "810-FALL"
And I set field "num2" to "810-FALL"
And I set field "such" to "FALL-810"
And I set field "namebspr" to "FALL-810"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-810"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-810"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-810" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "810-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-810" in row 1
And I set field "mge" to "810" in row 1
And I set field "preis" to "810" in row 1
And I set field "kenn" to "FALL-810"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "810-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-810" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-810"
And I set field "num4" to "810-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "810" in row 1
And I set field "kenn" to "FALL-810"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "810-LS"
And I close the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-810" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "nummer" to "0810FALL"
And I set field "such" to "FALL-810"
# And I create a new row at the end of the table
And I set field "vorgang" to "$,,artikel=Fall-810;platz=f1;@datei=40;@gruppe=4;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "500,1234" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Mengenneubewertung
Given I open an editor "mgebewneu-view" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+FALL-810"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-810" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-810"
And I set field "num4" to "810-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "810" in row 1
And I set field "preis" to "810" in row 1
And I set field "kenn" to "FALL-810"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+810-RE"
And I close the current editor

# 10.04.2019
# Auskommentiert wegen DIAG
# # Storno Mengenneubewertung
# Given I open an editor "mgebewneu-810" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+FALL-810"
# And I set field "nummer" to "0810ST"
# And I set field "such" to "FALL-810S"
# # And I create a new row at the end of the table
# And I save the current editor

#####################################################################################################################################

@FALL-811
@persistent
Scenario: FALL-811 Kostenfreier Ersatz Original Ware EK Lieferschein

# Konto 811-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0811FALL"
And I set field "such" to "FALL-811"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0811FALL"
And I set field "such" to "FALL-811"
And I set field "bestausekso" to "FALL-811"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "811-FALL"
And I set field "num2" to "811-FALL"
And I set field "such" to "FALL-811"
And I set field "namebspr" to "FALL-811"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-811"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-811"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-811" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "811-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-811" in row 1
And I set field "mge" to "811" in row 1
And I set field "preis" to "811" in row 1
And I set field "kenn" to "FALL-811"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "811-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-811" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-811"
And I set field "num4" to "811-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "811" in row 1
And I set field "kenn" to "FALL-811"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "811-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-811" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "811-LS"
And I set field "num4" to "811-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-51" in row 1
And I set field "kenn" to "FALL-811 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-811"
And I close the current editor

# Ersatz-Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein2-811" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-811"
And I set field "num4" to "811-ELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "rerelev" to "NEIN" in row 1
And I set field "mge" to "31" in row 1
And I set field "kenn" to "FALL-811"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Ersatz-Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+811-ELS"
And I close the current editor

#####################################################################################################################################

@FALL-812
@persistent
Scenario: FALL-812 Gutschrift EK zu Rücklieferung

# Konto 812-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0812FALL"
And I set field "such" to "FALL-812"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0812FALL"
And I set field "such" to "FALL-812"
And I set field "bestausekso" to "FALL-812"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "812-FALL"
And I set field "num2" to "812-FALL"
And I set field "such" to "FALL-812"
And I set field "namebspr" to "FALL-812"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-812"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "wgruppe" to "FALL-812"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-812" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "812-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-812" in row 1
And I set field "mge" to "812" in row 1
And I set field "preis" to "812" in row 1
And I set field "kenn" to "FALL-812"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "812-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-812" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-812"
And I set field "num4" to "812-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "812" in row 1
And I set field "kenn" to "FALL-812"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "812-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-812" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-812"
And I set field "num4" to "812-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-812"
And I set field "mge" to "750" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-812" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+812-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-812" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "812-LS"
And I set field "num4" to "812-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-93" in row 1
And I set field "kenn" to "FALL-812 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "rls-812"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-812" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-812"
And I set field "num4" to "812-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
# And I set field "preis" to "812" in row 1
And I set field "kenn" to "FALL-812"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+812-GS"
And I close the current editor

# Ersatz-Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein2-812" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-812"
And I set field "num4" to "812-ELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "rerelev" to "NEIN" in row 1
And I set field "mge" to "31" in row 1
And I set field "platz" to "LBEIST" in row 1
#
# Die Rückgelieferte Menge ist noch nicht gutgeschrieben worden, gehört daher noch uns
# Die Ersatzlieferung gehört daher noch dem Lieferanten
And I set field "kenn" to "FALL-812"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Ersatz-Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+812-ELS"
And I close the current editor

#####################################################################################################################################

#
# Hier ist dann das ENDE
#
#
