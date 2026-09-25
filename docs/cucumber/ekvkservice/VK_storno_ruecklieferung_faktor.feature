Feature: Storno und Ruecklieferungen hier nur Verkauf
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

# Kunde 4 Währung EUR und Zahlungsbedingung
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "4"
And I set field "waehr" to "EUR"
And I set field "zbed" to "201"
And I save the current editor

# Zusatzposition Anzahlung mit richtigen Konten
Given I open an editor "zuspos" from table "(Part):(SupplementaryItem)" with command "STORE" for record "ANZAHLUNG"
And I set field "ekonto" to "07800"
And I set field "vkonto" to "32700"
And I save the current editor

# Konto 32700 mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "STORE" for record "32700"
And I set field "ktostrgl" to "VKINLREGEL"
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

# Konsognations-Lagerplatz - Lohnfertiger disporelevant
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

# Externer Lagerplatz fuer Umlagerungen VK
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "EXTVKUML"
And I set field "such" to "EXTVKUML"
And I set field "namebspr" to "Extern Umlagerungen VK"
And I save the current editor

# Externer Lagerplatz fuer Umlagerungen VK
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "EXTVKUML"
And I set field "such" to "EXTVKUML"
And I set field "namebspr" to "Extern Umlagerungen VK"
And I set field "lgruppe" to "EXTVKUML"
# And I set field "disporel" to "JA"
And I save the current editor

# Externer Lagerplatz fuer Umlagerungen VK
Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "EXTVKUML"
And I set field "such" to "EXTVKUML"
And I set field "namebspr" to "Extern Umlagerungen VK"
And I set field "lager" to "EXTVKUML"
And I save the current editor

######################################

# Lagergruppe Lieferanten Konsignationslagerplatz
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "LBEIST"
And I set field "such" to "LBEIST"
And I set field "namebspr" to "LBEISTertiger"
And I save the current editor

# Konsignationslager Lieferanten Konsignationslagerplatz
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "LBEIST"
And I set field "such" to "LBEIST"
And I set field "namebspr" to "Lieferanten Konsi-platz"
And I set field "lgruppe" to "LBEIST"
And I set field "disporel" to "JA"
And I save the current editor

# Lieferanten Konsignationslagerplatz
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

# Externer Lagerplatz fuer Kundeneigentum
Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KUNDEEIG"
And I set field "such" to "KUNDEEIG"
And I set field "namebspr" to "Kundeneigentum"
And I set field "zkonsilg" to "ja"
And I save the current editor

# Externer Lagerplatz fuer Kundeneigentum
Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KUNDEEIG"
And I set field "such" to "KUNDEEIG"
And I set field "namebspr" to "Kundeneigentum"
And I set field "lgruppe" to "KUNDEEIG"
# And I set field "disporel" to "JA"
And I save the current editor

# Externer Lagerplatz fuer Kundeneigentum
Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KUNDEEIG"
And I set field "such" to "KUNDEEIG"
And I set field "namebspr" to "Kundeneigentum"
And I set field "lager" to "KUNDEEIG"
And I save the current editor

#####################################################################################################################################

@FALL-121
Scenario: FALL-121 VK Lieferschein

# Konto 121-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0121FALL"
And I set field "such" to "FALL-121"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0121FALL"
And I set field "such" to "FALL-121"
And I set field "bestausekso" to "FALL-121"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "121-FALL"
And I set field "num2" to "121-FALL"
And I set field "such" to "FALL-121"
And I set field "namebspr" to "FALL-121"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-121"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-121" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "121-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-121" in row 1
And I set field "mge" to "121" in row 1
And I set field "preis" to "121" in row 1
And I set field "kenn" to "FALL-121"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "121-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-121" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-121"
And I set field "num4" to "121-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "121" in row 1
And I set field "kenn" to "FALL-121"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "121-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-121" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-121"
And I set field "num4" to "121-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "121" in row 1
And I set field "preis" to "121" in row 1
And I set field "kenn" to "FALL-121"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+121-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-121" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "121-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-121" in row 1
And I set field "mge" to "121" in row 1
And I set field "preis" to "121" in row 1
And I set field "kenn" to "FALL-121"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "121-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-121" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-121"
And I set field "num3" to "121-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "121" in row 1
And I set field "kenn" to "FALL-121"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "121-LS"
And I close the current editor

#####################################################################################################################################

@FALL-122
Scenario: FALL-122 Rechnung VK Rechnung (ohne Lager)

# Konto 122-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0122FALL"
And I set field "such" to "FALL-122"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0122FALL"
And I set field "such" to "FALL-122"
And I set field "bestausekso" to "FALL-122"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "122-FALL"
And I set field "num2" to "122-FALL"
And I set field "such" to "FALL-122"
And I set field "namebspr" to "FALL-122"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-122"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-122" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "122-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-122" in row 1
And I set field "mge" to "122" in row 1
And I set field "preis" to "122" in row 1
And I set field "kenn" to "FALL-122"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "122-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-122" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-122"
And I set field "num4" to "122-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "122" in row 1
And I set field "kenn" to "FALL-122"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "122-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-122" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-122"
And I set field "num4" to "122-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "122" in row 1
And I set field "preis" to "122" in row 1
And I set field "kenn" to "FALL-122"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+122-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-122" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "122-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-122" in row 1
And I set field "mge" to "122" in row 1
And I set field "preis" to "122" in row 1
And I set field "kenn" to "FALL-122"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "122-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-122" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-122"
And I set field "num3" to "122-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "122" in row 1
And I set field "kenn" to "FALL-122"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "122-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-122" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-122"
And I set field "num3" to "122-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "122" in row 1
And I set field "kenn" to "FALL-122"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+122-RE"
And I close the current editor

#####################################################################################################################################

@FALL-123
Scenario: FALL-123 Lieferung VK Rechnung mit Lagerbewegung

# Konto 123-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0123FALL"
And I set field "such" to "FALL-123"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0123FALL"
And I set field "such" to "FALL-123"
And I set field "bestausekso" to "FALL-123"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "123-FALL"
And I set field "num2" to "123-FALL"
And I set field "such" to "FALL-123"
And I set field "namebspr" to "FALL-123"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-123"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-123" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "123-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-123" in row 1
And I set field "mge" to "123" in row 1
And I set field "preis" to "123" in row 1
And I set field "kenn" to "FALL-123"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "123-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-123" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-123"
And I set field "num4" to "123-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "123" in row 1
And I set field "kenn" to "FALL-123"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "123-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung123" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-123"
And I set field "num4" to "123-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "123" in row 1
And I set field "preis" to "123" in row 1
And I set field "kenn" to "FALL-123"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+123-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-123" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "123-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-123" in row 1
And I set field "mge" to "123" in row 1
And I set field "preis" to "123" in row 1
And I set field "kenn" to "FALL-123"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "123-AU"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-123" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-123"
And I set field "num3" to "123-RE"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "123" in row 1
And I set field "kenn" to "FALL-123"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+123-RE"
And I close the current editor

#####################################################################################################################################

@FALL-125
Scenario: FALL-125 Lieferung VK Durchgang SET-Artikel

# Konto 125-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0125FALL"
And I set field "such" to "FALL-125"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0125FALL"
And I set field "such" to "FALL-125"
And I set field "bestausekso" to "FALL-125"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "125-FALL-A"
And I set field "num2" to "125-FALL-A"
And I set field "such" to "FALL-125A"
And I set field "namebspr" to "FALL-125A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-125"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "125-FALL-B"
And I set field "num2" to "125-FALL-B"
And I set field "such" to "FALL-125B"
And I set field "namebspr" to "FALL-125B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-125"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "125-FALL-VK"
And I set field "num2" to "125-FALL-VK"
And I set field "such" to "FALL-125VK"
And I set field "namebspr" to "FALL-125VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-125"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-125A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-125B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-125" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "125-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-125A" in row 1
And I set field "mge" to "125" in row 1
And I set field "preis" to "125" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-125B" in row 2
And I set field "mge" to "125" in row 2
And I set field "preis" to "125" in row 2
And I set field "kenn" to "FALL-125"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "125-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-125" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-125"
And I set field "num4" to "125-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "125" in row 1
And I set field "mge" to "125" in row 2
And I set field "kenn" to "FALL-125"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "125-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-125" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-125"
And I set field "num4" to "125-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "125" in row 1
And I set field "preis" to "125" in row 1
And I set field "mge" to "125" in row 2
And I set field "preis" to "125" in row 2
And I set field "kenn" to "FALL-125"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+125-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-125" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "125-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-125VK" in row 1
And I set field "mge" to "125" in row 1
And I set field "preis" to "125" in row 1
And I set field "kenn" to "FALL-125"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "125-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-125" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-125"
And I set field "num3" to "125-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "125" in row 1
And I set field "kenn" to "FALL-125"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "125-LS"
And I close the current editor

#####################################################################################################################################

@FALL-126
Scenario: FALL-126 Neu VK Umlagerungen

# Konto 126-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0126FALL"
And I set field "such" to "FALL-126"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0126FALL"
And I set field "such" to "FALL-126"
And I set field "bestausekso" to "FALL-126"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "126-FALL"
And I set field "num2" to "126-FALL"
And I set field "such" to "FALL-126"
And I set field "namebspr" to "FALL-126"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-126"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-126" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "126-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-126" in row 1
And I set field "mge" to "126" in row 1
And I set field "preis" to "126" in row 1
And I set field "kenn" to "FALL-126"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "126-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-126" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-126"
And I set field "num4" to "126-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "126" in row 1
And I set field "kenn" to "FALL-126"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "126-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-126" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-126"
And I set field "num4" to "126-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "126" in row 1
And I set field "preis" to "126" in row 1
And I set field "kenn" to "FALL-126"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+126-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-126" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "126-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-126" in row 1
And I set field "mge" to "126" in row 1
And I set field "preis" to "126" in row 1
And I set field "kenn" to "FALL-126"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "126-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-126" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-126"
And I set field "num3" to "126-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "126" in row 1
And I set field "kenn" to "FALL-126"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+126-UMLS"
And I close the current editor

#####################################################################################################################################

@FALL-127
Scenario: FALL-127 VK Lieferschein mit Materialzuordnung

# Konto 127-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0127FALL"
And I set field "such" to "FALL-127"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0127FALL"
And I set field "such" to "FALL-127"
And I set field "bestausekso" to "FALL-127"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "127-FALL"
And I set field "num2" to "127-FALL"
And I set field "such" to "FALL-127"
And I set field "namebspr" to "FALL-127"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-127"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-127" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "127-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-127" in row 1
And I set field "mge" to "127" in row 1
And I set field "preis" to "127" in row 1
And I set field "kenn" to "FALL-127"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "127-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-127" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-127"
And I set field "num4" to "127-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "127" in row 1
And I set field "kenn" to "FALL-127"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "30" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "37" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-127"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "127-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-127" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-127"
And I set field "num4" to "127-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "127" in row 1
And I set field "preis" to "127" in row 1
And I set field "kenn" to "FALL-127"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+127-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-127" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "127-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-127" in row 1
And I set field "mge" to "127" in row 1
And I set field "preis" to "127" in row 1
And I set field "kenn" to "FALL-127"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "127-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-127" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-127"
And I set field "num3" to "127-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "127" in row 1
And I set field "kenn" to "FALL-127"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "30" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "37" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-127"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "127-LS"
And I close the current editor

#####################################################################################################################################

@FALL-128
Scenario: FALL-128 Lieferung VK Rechnung mit Lager mit Materialzuordnung

# Konto 128-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0128FALL"
And I set field "such" to "FALL-128"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0128FALL"
And I set field "such" to "FALL-128"
And I set field "bestausekso" to "FALL-128"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "128-FALL"
And I set field "num2" to "128-FALL"
And I set field "such" to "FALL-128"
And I set field "namebspr" to "FALL-128"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-128"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-128" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "128-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-128" in row 1
And I set field "mge" to "128" in row 1
And I set field "preis" to "128" in row 1
And I set field "kenn" to "FALL-128"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "128-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-128" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-128"
And I set field "num4" to "128-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "128" in row 1
And I set field "kenn" to "FALL-128"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "30" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "38" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-128"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "128-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-128" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-128"
And I set field "num4" to "128-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "128" in row 1
And I set field "preis" to "128" in row 1
And I set field "kenn" to "FALL-128"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+128-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-128" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "128-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-128" in row 1
And I set field "mge" to "128" in row 1
And I set field "preis" to "128" in row 1
And I set field "kenn" to "FALL-128"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "128-AU"
And I close the current editor

# Rechnung anlegen
Given I open an editor "Rechnung-128" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-128"
And I set field "num3" to "128-RE"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "128" in row 1
And I set field "kenn" to "FALL-128"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "30" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "38" in row 4
And I save the current editor
And I switch the current editor to editor "Rechnung-128"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+128-RE"
And I close the current editor


#####################################################################################################################################

@FALL-141
Scenario: FALL-141 Lieferung VK Durchgang SET-Artikel, mit indiv. Set-Liste

# Konto 141-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0141FALL"
And I set field "such" to "FALL-141"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0141FALL"
And I set field "such" to "FALL-141"
And I set field "bestausekso" to "FALL-141"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "141-FALL-A"
And I set field "num2" to "141-FALL-A"
And I set field "such" to "FALL-141A"
And I set field "namebspr" to "FALL-141A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-141"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "141-FALL-B"
And I set field "num2" to "141-FALL-B"
And I set field "such" to "FALL-141B"
And I set field "namebspr" to "FALL-141B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-141"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "141-FALL-C"
And I set field "num2" to "141-FALL-C"
And I set field "such" to "FALL-141C"
And I set field "namebspr" to "FALL-141C"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-141"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "141-FALL-VK"
And I set field "num2" to "141-FALL-VK"
And I set field "such" to "FALL-141VK"
And I set field "namebspr" to "FALL-141VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-141"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-141A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-141B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-141" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "141-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-141A" in row 1
And I set field "mge" to "141" in row 1
And I set field "preis" to "141" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-141B" in row 2
And I set field "mge" to "141" in row 2
And I set field "preis" to "141" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-141C" in row 3
And I set field "mge" to "141" in row 3
And I set field "preis" to "141" in row 3
And I set field "kenn" to "FALL-141"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "141-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-141" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-141"
And I set field "num4" to "141-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "141" in row 1
And I set field "mge" to "141" in row 2
And I set field "mge" to "141" in row 3
And I set field "kenn" to "FALL-141"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "141-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-141" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-141"
And I set field "num4" to "141-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "141" in row 1
And I set field "preis" to "141" in row 1
And I set field "mge" to "141" in row 2
And I set field "preis" to "141" in row 2
And I set field "mge" to "141" in row 3
And I set field "preis" to "141" in row 3
And I set field "kenn" to "FALL-141"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+141-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-141" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "141-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-141VK" in row 1
And I set field "mge" to "141" in row 1
And I set field "preis" to "141" in row 1
And I set field "kenn" to "FALL-141"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-141C" in row 3
And I set field "elanzahl" to "0,5" in row 3
And I save the current editor
And I switch the current editor to editor "auftrag-141"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "141-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-141" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-141"
And I set field "num3" to "141-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "141" in row 1
And I set field "kenn" to "FALL-141"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "141-LS"
And I close the current editor

#####################################################################################################################################

@FALL-142
Scenario: FALL-142 Lieferung VK SET in SET

# Konto 142-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0142FALL"
And I set field "such" to "FALL-142"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0142FALL"
And I set field "such" to "FALL-142"
And I set field "bestausekso" to "FALL-142"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "142-FALL-A"
And I set field "num2" to "142-FALL-A"
And I set field "such" to "FALL-142A"
And I set field "namebspr" to "FALL-142A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-142"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "142-FALL-B"
And I set field "num2" to "142-FALL-B"
And I set field "such" to "FALL-142B"
And I set field "namebspr" to "FALL-142B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-142"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "142-FALL-C"
And I set field "num2" to "142-FALL-C"
And I set field "such" to "FALL-142C"
And I set field "namebspr" to "FALL-142C"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-142"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "142-FALL-D"
And I set field "num2" to "142-FALL-D"
And I set field "such" to "FALL-142D"
And I set field "namebspr" to "FALL-142D"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-142"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "142-FALL-E"
And I set field "num2" to "142-FALL-E"
And I set field "such" to "FALL-142E"
And I set field "namebspr" to "FALL-142E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-142"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "142-FALL-SE"
And I set field "num2" to "142-FALL-SE"
And I set field "such" to "FALL-142SE"
And I set field "namebspr" to "FALL-142SET"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-142"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-142A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-142B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "142-FALL-VK"
And I set field "num2" to "142-FALL-VK"
And I set field "such" to "FALL-142VK"
And I set field "namebspr" to "FALL-142VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-142"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-142C" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-142D" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-142" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "142-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-142A" in row 1
And I set field "mge" to "142" in row 1
And I set field "preis" to "142" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-142B" in row 2
And I set field "mge" to "142" in row 2
And I set field "preis" to "142" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-142C" in row 3
And I set field "mge" to "142" in row 3
And I set field "preis" to "142" in row 3
And I create a new row at the end of the table
And I set field "artex" to "FALL-142D" in row 4
And I set field "mge" to "142" in row 4
And I set field "preis" to "142" in row 4
And I create a new row at the end of the table
And I set field "artex" to "FALL-142E" in row 5
And I set field "mge" to "142" in row 5
And I set field "preis" to "142" in row 5
And I set field "kenn" to "FALL-142"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "142-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-142" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-142"
And I set field "num4" to "142-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "142" in row 1
And I set field "mge" to "142" in row 2
And I set field "mge" to "142" in row 3
And I set field "mge" to "142" in row 4
And I set field "mge" to "142" in row 5
And I set field "kenn" to "FALL-142"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "142-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-142" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-142"
And I set field "num4" to "142-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "142" in row 1
And I set field "preis" to "142" in row 1
And I set field "mge" to "142" in row 2
And I set field "preis" to "142" in row 2
And I set field "mge" to "142" in row 3
And I set field "preis" to "142" in row 3
And I set field "mge" to "142" in row 4
And I set field "preis" to "142" in row 4
And I set field "mge" to "142" in row 5
And I set field "preis" to "142" in row 5
And I set field "kenn" to "FALL-142"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+142-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-142" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "142-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-142VK" in row 1
And I set field "mge" to "142" in row 1
And I set field "preis" to "142" in row 1
And I set field "kenn" to "FALL-142"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-142SE" in row 3
# Set wird jetzt aufgeloest
And I respond with answer "Ja" to the dialog with id "1537"
And I set field "elanzahl" to "0,7" in row 3
And I save the current editor
And I switch the current editor to editor "auftrag-142"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "142-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-142" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-142"
And I set field "num3" to "142-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "142" in row 1
And I set field "kenn" to "FALL-142"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "142-LS"
And I close the current editor

#####################################################################################################################################

@FALL-145
Scenario: FALL-145 Neu VK Anzahlungsrechnung

# Konto 145-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0145FALL"
And I set field "such" to "FALL-145"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0145FALL"
And I set field "such" to "FALL-145"
And I set field "bestausekso" to "FALL-145"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "145-FALL"
And I set field "num2" to "145-FALL"
And I set field "such" to "FALL-145"
And I set field "namebspr" to "FALL-145"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-145"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-145" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "145-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-145" in row 1
And I set field "mge" to "145" in row 1
And I set field "preis" to "145" in row 1
And I set field "kenn" to "FALL-145"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "145-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-145" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-145"
And I set field "num4" to "145-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "145" in row 1
And I set field "kenn" to "FALL-145"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "145-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-145" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-145"
And I set field "num4" to "145-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "145" in row 1
And I set field "preis" to "145" in row 1
And I set field "kenn" to "FALL-145"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+145-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-145" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "145-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-145" in row 1
And I set field "mge" to "145" in row 1
And I set field "preis" to "145" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2

And I set field "kenn" to "FALL-145"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "145-AU"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-145" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "auftrag-145"
And I set field "num3" to "145-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-145"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+145-AR"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-145" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-145"
And I set field "num3" to "145-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "145" in row 1
And I set field "kenn" to "FALL-145"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "145-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-145" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-145"
And I set field "num3" to "145-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "145" in row 1
And I set field "kenn" to "FALL-145"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+145-RE"
And I close the current editor

#####################################################################################################################################

@FALL-146
Scenario:  FALL-146 Neu VK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ

# Konto 146-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0146FALL"
And I set field "such" to "FALL-146"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0146FALL"
And I set field "such" to "FALL-146"
And I set field "bestausekso" to "FALL-146"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "146A-FALL"
And I set field "num2" to "146A-FALL"
And I set field "such" to "FALL-146A"
And I set field "namebspr" to "FALL-146A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-146"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "146B-FALL"
And I set field "num2" to "146B-FALL"
And I set field "such" to "FALL-146B"
And I set field "namebspr" to "FALL-146B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-146"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "146V-FALL"
And I set field "num2" to "146V-FALL"
And I set field "such" to "FALL-146V"
And I set field "namebspr" to "FALL-146V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-146"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "146E-FALL"
And I set field "num2" to "146E-FALL"
And I set field "such" to "FALL-146E"
And I set field "namebspr" to "FALL-146E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-146"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "146M-FALL"
And I set field "num2" to "146M-FALL"
And I set field "such" to "FALL-146M"
And I set field "namebspr" to "FALL-146M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-146"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "146R-FALL"
And I set field "num2" to "146R-FALL"
And I set field "such" to "FALL-146R"
And I set field "namebspr" to "FALL-146R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-146"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-146" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "146-AU"

And I create a new row at the end of the table
And I set field "artex" to "FALL-146A" in row 1
And I set field "mge" to "146" in row 1
And I set field "preis" to "146" in row 1
And I set field "verw" to "FALL146A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-146B" in row 2
And I set field "mge" to "146" in row 2
And I set field "preis" to "146" in row 2
And I set field "verw" to "FALL146B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-146V" in row 3
And I set field "mge" to "146" in row 3
And I set field "preis" to "146" in row 3
And I set field "verw" to "FALL146V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-146E" in row 4
And I set field "mge" to "146" in row 4
And I set field "preis" to "146" in row 4
And I set field "verw" to "FALL146E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-146M" in row 5
And I set field "mge" to "146" in row 5
And I set field "preis" to "146" in row 5
And I set field "verw" to "FALL146M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-146R" in row 6
And I set field "mge" to "146" in row 6
And I set field "preis" to "146" in row 6
And I set field "verw" to "FALL146R" in row 6

And I set field "kenn" to "FALL-146"
And I save the current editor

# Dispo starten
# And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-146" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "146-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-146A" in row 1
And I set field "mge" to "146" in row 1
And I set field "preis" to "146" in row 1
And I set field "verw" to "FALL146A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-146B" in row 2
And I set field "mge" to "146" in row 2
And I set field "preis" to "146" in row 2
And I set field "verw" to "FALL146B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-146V" in row 3
And I set field "mge" to "146" in row 3
And I set field "preis" to "146" in row 3
And I set field "verw" to "FALL146V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-146E" in row 4
And I set field "mge" to "146" in row 4
And I set field "preis" to "146" in row 4
And I set field "verw" to "FALL146E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-146M" in row 5
And I set field "mge" to "146" in row 5
And I set field "preis" to "146" in row 5
And I set field "verw" to "FALL146M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-146R" in row 6
And I set field "mge" to "146" in row 6
And I set field "preis" to "146" in row 6
And I set field "verw" to "FALL146R" in row 6

And I set field "kenn" to "FALL-146"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "146-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-146" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-146"
And I set field "num4" to "146-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "146" in row 1
And I set field "mge" to "146" in row 2
And I set field "mge" to "146" in row 3
And I set field "mge" to "146" in row 4
And I set field "mge" to "146" in row 5
And I set field "mge" to "146" in row 6
And I set field "kenn" to "FALL-146"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "146-LS"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-146" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-146"
And I set field "num3" to "146-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "146" in row 1
And I set field "mge" to "146" in row 2
And I set field "mge" to "146" in row 3
And I set field "mge" to "146" in row 4
And I set field "mge" to "146" in row 5
And I set field "mge" to "146" in row 6
And I set field "kenn" to "FALL-146"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "146-LS"
And I close the current editor

#####################################################################################################################################

@FALL-147
Scenario:  FALL-147
# Neu	VK	Lieferschein mit allen Zusatzpositions-Typen

# Konto 0147-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0147FALL"
And I set field "such" to "FALL-0147"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0147-MG"
And I set field "such" to "FALL-0147"
And I set field "bestausekso" to "FALL-0147"
And I save the current editor

# Konto 40147-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40147FAL"
And I set field "such" to "FALL-40147"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0147-PG"
And I set field "such" to "FALL-0147"
And I set field "pgerlo" to "FALL-40147"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "147-FALL-ART"
And I set field "num2" to "147-FALL-ART"
And I set field "such" to "FALL-147-ART"
And I set field "namebspr" to "FALL-147"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "0147-MG"
And I set field "erlgrp" to "0147-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

Scenario Outline: FALL-147-ZP
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
 |147-FALL-L     | FALL-147-L       | FALL-147 LEER                     |                               |               |
 |147-FALL-AS    | FALL-147-AS      | FALL-147 Absatz                   |Absatz                         |               |
 |147-FALL-ES    | FALL-147-ES      | FALL-147 Endsumme                 |Endsumme                       |               |
 |147-FALL-GS    | FALL-147-GS      | FALL-147 Gesamtsumme              |Gesamtsumme                    |               |
 |147-FALL-MB    | FALL-147-MB      | FALL-147 Mindest bwp              |Mindestbestellwertposition     |               |
 |147-FALL-PP    | FALL-147-PP      | FALL-147 Prozentposition          |Prozentposition                |               |
 |147-FALL-ST    | FALL-147-ST      | FALL-147 Seite                    |Seite                          |               |
 |147-FALL-TP    | FALL-147-TP      | FALL-147 Trennposition            |Trennposition                  |               |
 |147-FALL-TX    | FALL-147-TX      | FALL-147 Text                     |Text                           |               |
 |147-FALL-ZS    | FALL-147-ZS      | FALL-147 Zwischensumme            |Zwischensumme                  |               |
 |147-FALL-AUD   | FALL-147-AUD     | FALL-147 AU-BE Pos Kategorie Die  |AU/BE-Position,BV              |Dienstleistung |
 |147-FALL-AUL   | FALL-147-AUL     | FALL-147 AU-BE Pos Kategorie Lee  |AU/BE-Position,BV              |               |
 |147-FALL-MTZ   | FALL-147-MTZ     | FALL-147 Materialzuschlag         |Materialzuschlag               |               |
 |147-FALL-NPA   | FALL-147-NPA     | FALL-147 neutrale Position ANZ    |neutrale Position              |Anzahlung      |
 |147-FALL-NPD   | FALL-147-NPD     | FALL-147 neutrale Position DL     |neutrale Position              |Dienstleistung |
 |147-FALL-NPG   | FALL-147-NPG     | FALL-147 neutrale Position G      |neutrale Position              |Gutschein      |
 |147-FALL-NPL   | FALL-147-NPL     | FALL-147 neutrale Position Leer   |neutrale Position              |               |
 |147-FALL-NSP   | FALL-147-NSP     | FALL-147 Nettosummenposition      |Nettosummenposition            |               |
 |147-FALL-UVI   | FALL-147-UVI     | FALL-147 USt/VSt-Position inkl    |USt/VSt-Position (inklusive)   |               |
 |147-FALL-UVZ   | FALL-147-UVZ     | FALL-147 USt/VSt-Position zuzu    |USt/VSt-Position (zuzüglich)   |               |

Scenario: FALL-147-2
# Bestellung anlegen
Given I open an editor "bestellung-147" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "147-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-147-ART" in row 1
And I set field "mge" to "147" in row 1
And I set field "preis" to "147" in row 1
And I set field "kenn" to "FALL-147"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "147-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-147" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-147"
And I set field "num4" to "147-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "147" in row 1
And I set field "kenn" to "FALL-147"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "147-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-147" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-147"
And I set field "num4" to "147-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "147" in row 1
And I set field "preis" to "147" in row 1
And I set field "kenn" to "FALL-147"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+147-RE"
And I close the current editor

Scenario: FALL-147-AU
# Auftrag anlegen
Given I open an editor "auftrag-147" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
        | kunde        | 1       |
        | num3         | 147-AU  |
        | kenn         | FALL-147|
And I append rows
        | artex         | mge             |  preis             | proz         | pwert           | konto          |
        |147-FALL-ART   | 147             |  147               | !dontChange  | !dontChange     | !dontChange    |
        |147-FALL-L     | !dontChange     |  !dontChange       | !dontChange  | 147             | 40147FAL       |
        |147-FALL-AS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |147-FALL-ES    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |147-FALL-GS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |147-FALL-MB    | !dontChange     |  147               | !dontChange  | !dontChange     | 40147FAL       |
        |147-FALL-PP    | !dontChange     |  !dontChange       | 147          | !dontChange     | 40147FAL       |
        |147-FALL-ST    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |147-FALL-TP    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |147-FALL-TX    | !dontChange     |  !dontChange       | !dontChange  | 147             | 40147FAL       |
        |147-FALL-ZS    | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |147-FALL-AUD   | 147             |  147               | !dontChange  | !dontChange     | 40147FAL       |
        |147-FALL-AUL   | 147             |  147               | !dontChange  | !dontChange     | 40147FAL       |
        |147-FALL-MTZ   | !dontChange     |  147               | !dontChange  | !dontChange     | 40147FAL       |
        |147-FALL-NPA   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 40147FAL       |
        |147-FALL-NPD   | !dontChange     |  !dontChange       | !dontChange  | 147             | 40147FAL       |
        |147-FALL-NPG   | !dontChange     |  !dontChange       | !dontChange  | 147             | 40147FAL       |
        |147-FALL-NPL   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | 40147FAL       |
        |147-FALL-NSP   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
        |147-FALL-UVZ   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
# |19   |147-FALL-UVI   | !dontChange     |  !dontChange       | !dontChange  | !dontChange     | !dontChange    |
And I save the current editor

# Scenario: FALL-147-AUAUS
# Ausgabe Bestellung
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "147-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-147" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-147"
And I set field "num3" to "147-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "147" in row 1
And I set field "kenn" to "FALL-147"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "147-LS"
And I close the current editor

#####################################################################################################################################

@FALL-221
Scenario: FALL-221 Storno VK Lieferschein

# Konto 221-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0221FALL"
And I set field "such" to "FALL-221"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0221FALL"
And I set field "such" to "FALL-221"
And I set field "bestausekso" to "FALL-221"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "221-FALL"
And I set field "num2" to "221-FALL"
And I set field "such" to "FALL-221"
And I set field "namebspr" to "FALL-221"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-221"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-221" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "221-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-221" in row 1
And I set field "mge" to "221" in row 1
And I set field "preis" to "221" in row 1
And I set field "kenn" to "FALL-221"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "221-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-221" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-221"
And I set field "num4" to "221-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "221" in row 1
And I set field "kenn" to "FALL-221"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "221-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-221" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-221"
And I set field "num4" to "221-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "221" in row 1
And I set field "preis" to "221" in row 1
And I set field "kenn" to "FALL-221"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+221-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-221" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "221-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-221" in row 1
And I set field "mge" to "221" in row 1
And I set field "preis" to "221" in row 1
And I set field "kenn" to "FALL-221"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "221-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-221" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-221"
And I set field "num3" to "221-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "221" in row 1
And I set field "kenn" to "FALL-221"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "221-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "221-LS"
And I set field "num3" to "221-STLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+221-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-222
Scenario: FALL-222 Storno VK Rechnung mit Lagerbewegung

# Konto 222-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0222FALL"
And I set field "such" to "FALL-222"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0222FALL"
And I set field "such" to "FALL-222"
And I set field "bestausekso" to "FALL-222"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "222-FALL"
And I set field "num2" to "222-FALL"
And I set field "such" to "FALL-222"
And I set field "namebspr" to "FALL-222"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-222"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-222" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "222-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-222" in row 1
And I set field "mge" to "222" in row 1
And I set field "preis" to "222" in row 1
And I set field "kenn" to "FALL-222"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "222-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-222" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-222"
And I set field "num4" to "222-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "222" in row 1
And I set field "kenn" to "FALL-222"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "222-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-222" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-222"
And I set field "num4" to "222-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "222" in row 1
And I set field "preis" to "222" in row 1
And I set field "kenn" to "FALL-222"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+222-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-222" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "222-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-222" in row 1
And I set field "mge" to "222" in row 1
And I set field "preis" to "222" in row 1
And I set field "kenn" to "FALL-222"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "222-AU"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-222" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-222"
And I set field "num3" to "222-RE"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "222" in row 1
And I set field "kenn" to "FALL-222"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+222-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-222" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+222-RE"
And I set field "num3" to "222-STRE"
And I save the current editor

# Kopieren eines Storno Vorgangs (Rechnung) nicht erlaubt
And opening an editor from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-storno-222" throws the exception "3563"

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+222-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-223
Scenario: FALL-223 Storno VK Rechnung (ohne Lager)

# Konto 223-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0223FALL"
And I set field "such" to "FALL-223"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0223FALL"
And I set field "such" to "FALL-223"
And I set field "bestausekso" to "FALL-223"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "223-FALL"
And I set field "num2" to "223-FALL"
And I set field "such" to "FALL-223"
And I set field "namebspr" to "FALL-223"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-223"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-223" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "223-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-223" in row 1
And I set field "mge" to "223" in row 1
And I set field "preis" to "223" in row 1
And I set field "kenn" to "FALL-223"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "223-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-223" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-223"
And I set field "num4" to "223-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "223" in row 1
And I set field "kenn" to "FALL-223"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "223-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-223" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-223"
And I set field "num4" to "223-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "223" in row 1
And I set field "preis" to "223" in row 1
And I set field "kenn" to "FALL-223"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+223-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-223" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "223-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-223" in row 1
And I set field "mge" to "223" in row 1
And I set field "preis" to "223" in row 1
And I set field "kenn" to "FALL-223"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "223-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-223" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-223"
And I set field "num3" to "223-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "223" in row 1
And I set field "kenn" to "FALL-223"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "223-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-223" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-223"
And I set field "num3" to "223-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "223" in row 1
And I set field "kenn" to "FALL-223"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+223-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "lieferschein" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+223-RE"
And I set field "num3" to "223-STRE"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "lieferschein-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+223-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-225
Scenario: FALL-225 Storno VK Durchgang SET-Artikel

# Konto 225-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0225FALL"
And I set field "such" to "FALL-225"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0225FALL"
And I set field "such" to "FALL-225"
And I set field "bestausekso" to "FALL-225"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "225-FALL-A"
And I set field "num2" to "225-FALL-A"
And I set field "such" to "FALL-225A"
And I set field "namebspr" to "FALL-225A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-225"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "225-FALL-B"
And I set field "num2" to "225-FALL-B"
And I set field "such" to "FALL-225B"
And I set field "namebspr" to "FALL-225B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-225"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "225-FALL-VK"
And I set field "num2" to "225-FALL-VK"
And I set field "such" to "FALL-225VK"
And I set field "namebspr" to "FALL-225VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-225"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-225A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-225B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-225" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "225-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-225A" in row 1
And I set field "mge" to "225" in row 1
And I set field "preis" to "225" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-225B" in row 2
And I set field "mge" to "225" in row 2
And I set field "preis" to "225" in row 2
And I set field "kenn" to "FALL-225"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "225-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-225" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-225"
And I set field "num4" to "225-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "225" in row 1
And I set field "mge" to "225" in row 2
And I set field "kenn" to "FALL-225"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "225-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-225" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-225"
And I set field "num4" to "225-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "225" in row 1
And I set field "preis" to "225" in row 1
And I set field "mge" to "225" in row 2
And I set field "preis" to "225" in row 2
And I set field "kenn" to "FALL-225"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+225-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-225" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "225-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-225VK" in row 1
And I set field "mge" to "225" in row 1
And I set field "preis" to "225" in row 1
And I set field "kenn" to "FALL-225"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "225-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-225" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-225"
And I set field "num3" to "225-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "225" in row 1
And I set field "kenn" to "FALL-225"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "225-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "225-LS"
And I set field "num3" to "225-STLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+225-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-226
Scenario: FALL-226 Storno VK Umlagerungen

# Konto 226-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0226FALL"
And I set field "such" to "FALL-226"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0226FALL"
And I set field "such" to "FALL-226"
And I set field "bestausekso" to "FALL-226"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "226-FALL"
And I set field "num2" to "226-FALL"
And I set field "such" to "FALL-226"
And I set field "namebspr" to "FALL-226"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-226"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-226" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "226-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-226" in row 1
And I set field "mge" to "226" in row 1
And I set field "preis" to "226" in row 1
And I set field "kenn" to "FALL-226"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "226-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-226" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-226"
And I set field "num4" to "226-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "226" in row 1
And I set field "kenn" to "FALL-226"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "226-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-226" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-226"
And I set field "num4" to "226-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "226" in row 1
And I set field "preis" to "226" in row 1
And I set field "kenn" to "FALL-226"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+226-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-226" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "226-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-226" in row 1
And I set field "mge" to "226" in row 1
And I set field "preis" to "226" in row 1
And I set field "kenn" to "FALL-226"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "226-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-226" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-226"
And I set field "num3" to "226-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "226" in row 1
And I set field "kenn" to "FALL-226"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+226-UMLS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+226-UMLS"
And I set field "num3" to "226-SULS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+226-SULS"
And I close the current editor

#####################################################################################################################################

@FALL-227
Scenario: FALL-227 VK Storno Lieferschein mit Materialzuordnung

# Konto 227-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0227FALL"
And I set field "such" to "FALL-227"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0227FALL"
And I set field "such" to "FALL-227"
And I set field "bestausekso" to "FALL-227"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "227-FALL"
And I set field "num2" to "227-FALL"
And I set field "such" to "FALL-227"
And I set field "namebspr" to "FALL-227"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-227"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-227" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "227-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-227" in row 1
And I set field "mge" to "227" in row 1
And I set field "preis" to "227" in row 1
And I set field "kenn" to "FALL-227"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "227-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-227" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-227"
And I set field "num4" to "227-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "227" in row 1
And I set field "kenn" to "FALL-227"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "55" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "55" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "55" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "62" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-227"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "227-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-227" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-227"
And I set field "num4" to "227-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "227" in row 1
And I set field "preis" to "227" in row 1
And I set field "kenn" to "FALL-227"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+227-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-227" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "227-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-227" in row 1
And I set field "mge" to "227" in row 1
And I set field "preis" to "227" in row 1
And I set field "kenn" to "FALL-227"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "227-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-227" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-227"
And I set field "num3" to "227-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "227" in row 1
And I set field "kenn" to "FALL-227"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "55" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "55" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "55" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "62" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-227"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "227-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "227-LS"
And I set field "num3" to "227-STLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+227-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-228
Scenario: FALL-228 Storno VK Rechnung mit Lager mit Materialzuordnung

# Konto 228-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0228FALL"
And I set field "such" to "FALL-228"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0228FALL"
And I set field "such" to "FALL-228"
And I set field "bestausekso" to "FALL-228"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "228-FALL"
And I set field "num2" to "228-FALL"
And I set field "such" to "FALL-228"
And I set field "namebspr" to "FALL-228"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-228"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-228" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "228-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-228" in row 1
And I set field "mge" to "228" in row 1
And I set field "preis" to "228" in row 1
And I set field "kenn" to "FALL-228"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "228-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-228" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-228"
And I set field "num4" to "228-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "228" in row 1
And I set field "kenn" to "FALL-228"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "130" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "38" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-228"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "228-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-228" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-228"
And I set field "num4" to "228-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "228" in row 1
And I set field "preis" to "228" in row 1
And I set field "kenn" to "FALL-228"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+228-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-228" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "228-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-228" in row 1
And I set field "mge" to "228" in row 1
And I set field "preis" to "228" in row 1
And I set field "kenn" to "FALL-228"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "228-AU"
And I close the current editor

# Rechnung anlegen
Given I open an editor "Rechnung-228" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-228"
And I set field "num3" to "228-RE"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "228" in row 1
And I set field "kenn" to "FALL-228"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "130" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "38" in row 4
And I save the current editor
And I switch the current editor to editor "Rechnung-228"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+228-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "lieferschein" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+228-RE"
And I set field "num3" to "228-STRE"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "lieferschein-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+228-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-241
Scenario: FALL-241 Storno VK Lieferschein Durchgang SET-Artikel, mit indiv. Set-Liste

# Konto 241-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0241FALL"
And I set field "such" to "FALL-241"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0241FALL"
And I set field "such" to "FALL-241"
And I set field "bestausekso" to "FALL-241"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "241-FALL-A"
And I set field "num2" to "241-FALL-A"
And I set field "such" to "FALL-241A"
And I set field "namebspr" to "FALL-241A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-241"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "241-FALL-B"
And I set field "num2" to "241-FALL-B"
And I set field "such" to "FALL-241B"
And I set field "namebspr" to "FALL-241B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-241"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "241-FALL-C"
And I set field "num2" to "241-FALL-C"
And I set field "such" to "FALL-241C"
And I set field "namebspr" to "FALL-241C"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-241"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "241-FALL-VK"
And I set field "num2" to "241-FALL-VK"
And I set field "such" to "FALL-241VK"
And I set field "namebspr" to "FALL-241VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-241"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-241A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-241B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-241" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "241-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-241A" in row 1
And I set field "mge" to "241" in row 1
And I set field "preis" to "241" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-241B" in row 2
And I set field "mge" to "241" in row 2
And I set field "preis" to "241" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-241C" in row 3
And I set field "mge" to "241" in row 3
And I set field "preis" to "241" in row 3
And I set field "kenn" to "FALL-241"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "241-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-241" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-241"
And I set field "num4" to "241-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "241" in row 1
And I set field "mge" to "241" in row 2
And I set field "mge" to "241" in row 3
And I set field "kenn" to "FALL-241"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "241-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-241" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-241"
And I set field "num4" to "241-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "241" in row 1
And I set field "preis" to "241" in row 1
And I set field "mge" to "241" in row 2
And I set field "preis" to "241" in row 2
And I set field "mge" to "241" in row 3
And I set field "preis" to "241" in row 3
And I set field "kenn" to "FALL-241"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+241-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-241" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "241-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-241VK" in row 1
And I set field "mge" to "241" in row 1
And I set field "preis" to "241" in row 1
And I set field "kenn" to "FALL-241"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-241C" in row 3
And I set field "elanzahl" to "0,5" in row 3
And I save the current editor
And I switch the current editor to editor "auftrag-241"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "241-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-241" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-241"
And I set field "num3" to "241-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "241" in row 1
And I set field "kenn" to "FALL-241"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "241-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "241-LS"
And I set field "num3" to "241-STLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+241-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-242
Scenario: FALL-242 Storno VK Lieferschein SET in SET

# Konto 242-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0242FALL"
And I set field "such" to "FALL-242"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0242FALL"
And I set field "such" to "FALL-242"
And I set field "bestausekso" to "FALL-242"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "242-FALL-A"
And I set field "num2" to "242-FALL-A"
And I set field "such" to "FALL-242A"
And I set field "namebspr" to "FALL-242A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-242"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "242-FALL-B"
And I set field "num2" to "242-FALL-B"
And I set field "such" to "FALL-242B"
And I set field "namebspr" to "FALL-242B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-242"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "242-FALL-C"
And I set field "num2" to "242-FALL-C"
And I set field "such" to "FALL-242C"
And I set field "namebspr" to "FALL-242C"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-242"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "242-FALL-D"
And I set field "num2" to "242-FALL-D"
And I set field "such" to "FALL-242D"
And I set field "namebspr" to "FALL-242D"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-242"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "242-FALL-E"
And I set field "num2" to "242-FALL-E"
And I set field "such" to "FALL-242E"
And I set field "namebspr" to "FALL-242E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-242"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "242-FALL-SE"
And I set field "num2" to "242-FALL-SE"
And I set field "such" to "FALL-242SE"
And I set field "namebspr" to "FALL-242SET"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-242"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-242A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-242B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "242-FALL-VK"
And I set field "num2" to "242-FALL-VK"
And I set field "such" to "FALL-242VK"
And I set field "namebspr" to "FALL-242VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-242"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-242C" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-242D" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-242" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "242-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-242A" in row 1
And I set field "mge" to "242" in row 1
And I set field "preis" to "242" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-242B" in row 2
And I set field "mge" to "242" in row 2
And I set field "preis" to "242" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-242C" in row 3
And I set field "mge" to "242" in row 3
And I set field "preis" to "242" in row 3
And I create a new row at the end of the table
And I set field "artex" to "FALL-242D" in row 4
And I set field "mge" to "242" in row 4
And I set field "preis" to "242" in row 4
And I create a new row at the end of the table
And I set field "artex" to "FALL-242E" in row 5
And I set field "mge" to "242" in row 5
And I set field "preis" to "242" in row 5
And I set field "kenn" to "FALL-242"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "242-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-242" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-242"
And I set field "num4" to "242-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "242" in row 1
And I set field "mge" to "242" in row 2
And I set field "mge" to "242" in row 3
And I set field "mge" to "242" in row 4
And I set field "mge" to "242" in row 5
And I set field "kenn" to "FALL-242"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "242-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-242" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-242"
And I set field "num4" to "242-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "242" in row 1
And I set field "preis" to "242" in row 1
And I set field "mge" to "242" in row 2
And I set field "preis" to "242" in row 2
And I set field "mge" to "242" in row 3
And I set field "preis" to "242" in row 3
And I set field "mge" to "242" in row 4
And I set field "preis" to "242" in row 4
And I set field "mge" to "242" in row 5
And I set field "preis" to "242" in row 5
And I set field "kenn" to "FALL-242"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+242-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-242" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "242-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-242VK" in row 1
And I set field "mge" to "242" in row 1
And I set field "preis" to "242" in row 1
And I set field "kenn" to "FALL-242"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-242SE" in row 3
# Set wird jetzt aufgeloest
And I respond with answer "Ja" to the dialog with id "1537"
And I set field "elanzahl" to "0,7" in row 3
And I save the current editor
And I switch the current editor to editor "auftrag-242"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "242-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-242" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-242"
And I set field "num3" to "242-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "242" in row 1
And I set field "kenn" to "FALL-242"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "242-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "242-LS"
And I set field "num3" to "242-STLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+242-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-245
Scenario: FALL-245 Storno Vk Anzahlungsrechnung

# Konto 245-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0245FALL"
And I set field "such" to "FALL-245"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0245FALL"
And I set field "such" to "FALL-245"
And I set field "bestausekso" to "FALL-245"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "245-FALL"
And I set field "num2" to "245-FALL"
And I set field "such" to "FALL-245"
And I set field "namebspr" to "FALL-245"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-245"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-245" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "245-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-245" in row 1
And I set field "mge" to "245" in row 1
And I set field "preis" to "245" in row 1
And I set field "kenn" to "FALL-245"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "245-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-245" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-245"
And I set field "num4" to "245-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "245" in row 1
And I set field "kenn" to "FALL-245"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "245-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-245" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-245"
And I set field "num4" to "245-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "245" in row 1
And I set field "preis" to "245" in row 1
And I set field "kenn" to "FALL-245"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+245-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-245" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "245-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-245" in row 1
And I set field "mge" to "245" in row 1
And I set field "preis" to "245" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
And I set field "kenn" to "FALL-245"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "245-AU"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-245" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "auftrag-245"
And I set field "nummer" to "245-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-245"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Anzahlungsrechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+245-AR"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-245" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-245"
And I set field "num3" to "245-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "245" in row 1
And I set field "kenn" to "FALL-245"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "245-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-245" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-245"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-245"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Anzahlungsrechnung nicht erlaubt, da schon verrechnet
Given opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record "+245-AR" throws the exception ""
And I close the current editor

#####################################################################################################################################

@FALL-248
Scenario: FALL-248 Storno Vk Anzahlungsrechnung bezahlt

# Konto 248-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0248FALL"
And I set field "such" to "FALL-248"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0248FALL"
And I set field "such" to "FALL-248"
And I set field "bestausekso" to "FALL-248"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "248-FALL"
And I set field "num2" to "248-FALL"
And I set field "such" to "FALL-248"
And I set field "namebspr" to "FALL-248"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-248"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-248" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "248-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-248" in row 1
And I set field "mge" to "248" in row 1
And I set field "preis" to "248" in row 1
And I set field "kenn" to "FALL-248"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "248-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-248" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-248"
And I set field "num4" to "248-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "248" in row 1
And I set field "kenn" to "FALL-248"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "248-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-248" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-248"
And I set field "num4" to "248-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "248" in row 1
And I set field "preis" to "248" in row 1
And I set field "kenn" to "FALL-248"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+248-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-248" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "248-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-248" in row 1
And I set field "mge" to "248" in row 1
And I set field "preis" to "248" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
And I set field "kenn" to "FALL-248"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "248-AU"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-248" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "auftrag-248"
And I set field "nummer" to "248-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-248"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+248-AR"
And I close the current editor

# Anzahlungsrechnung bezahlen
Given I open an editor "op-zahlen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "nummer" to "248-OP"
And I set field "beleg" to "248-OP"
And I set field "gkonto" to "18100"
And I create a new row at the end of the table
And I set field "op" to "$,,rechn=3 +248-AR" in row 1
And I set field "opzabetr" to "1160" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-248" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-248"
And I set field "num3" to "248-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "248" in row 1
And I set field "kenn" to "FALL-248"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "248-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-248" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-248"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-248"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Storno Anzahlung nicht moeglich, weil bereits bezahlt
Given opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record "+248-AR" throws the exception ""
And I close the current editor

#####################################################################################################################################

@FALL-246
Scenario:  FALL-246 Storno VK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ

# Konto 246-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0246FALL"
And I set field "such" to "FALL-246"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0246FALL"
And I set field "such" to "FALL-246"
And I set field "bestausekso" to "FALL-246"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "246A-FALL"
And I set field "num2" to "246A-FALL"
And I set field "such" to "FALL-246A"
And I set field "namebspr" to "FALL-246A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-246"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "246B-FALL"
And I set field "num2" to "246B-FALL"
And I set field "such" to "FALL-246B"
And I set field "namebspr" to "FALL-246B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-246"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "246V-FALL"
And I set field "num2" to "246V-FALL"
And I set field "such" to "FALL-246V"
And I set field "namebspr" to "FALL-246V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-246"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "246E-FALL"
And I set field "num2" to "246E-FALL"
And I set field "such" to "FALL-246E"
And I set field "namebspr" to "FALL-246E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-246"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "246M-FALL"
And I set field "num2" to "246M-FALL"
And I set field "such" to "FALL-246M"
And I set field "namebspr" to "FALL-246M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-246"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "246R-FALL"
And I set field "num2" to "246R-FALL"
And I set field "such" to "FALL-246R"
And I set field "namebspr" to "FALL-246R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-246"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-246" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "246-AU"

And I create a new row at the end of the table
And I set field "artex" to "FALL-246A" in row 1
And I set field "mge" to "246" in row 1
And I set field "preis" to "246" in row 1
And I set field "verw" to "FALL246A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-246B" in row 2
And I set field "mge" to "246" in row 2
And I set field "preis" to "246" in row 2
And I set field "verw" to "FALL246B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-246V" in row 3
And I set field "mge" to "246" in row 3
And I set field "preis" to "246" in row 3
And I set field "verw" to "FALL246V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-246E" in row 4
And I set field "mge" to "246" in row 4
And I set field "preis" to "246" in row 4
And I set field "verw" to "FALL246E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-246M" in row 5
And I set field "mge" to "246" in row 5
And I set field "preis" to "246" in row 5
And I set field "verw" to "FALL246M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-246R" in row 6
And I set field "mge" to "246" in row 6
And I set field "preis" to "246" in row 6
And I set field "verw" to "FALL246R" in row 6

And I set field "kenn" to "FALL-246"
And I save the current editor

# Dispo starten
And I run Scheduling

# Bestellung anlegen
Given I open an editor "bestellung-246" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "246-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-246A" in row 1
And I set field "mge" to "246" in row 1
And I set field "preis" to "246" in row 1
And I set field "verw" to "FALL246A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-246B" in row 2
And I set field "mge" to "246" in row 2
And I set field "preis" to "246" in row 2
And I set field "verw" to "FALL246B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-246V" in row 3
And I set field "mge" to "246" in row 3
And I set field "preis" to "246" in row 3
And I set field "verw" to "FALL246V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-246E" in row 4
And I set field "mge" to "246" in row 4
And I set field "preis" to "246" in row 4
And I set field "verw" to "FALL246E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-246M" in row 5
And I set field "mge" to "246" in row 5
And I set field "preis" to "246" in row 5
And I set field "verw" to "FALL246M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-246R" in row 6
And I set field "mge" to "246" in row 6
And I set field "preis" to "246" in row 6
And I set field "verw" to "FALL246R" in row 6

And I set field "kenn" to "FALL-246"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "246-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-246" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-246"
And I set field "num4" to "246-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "246" in row 1
And I set field "mge" to "246" in row 2
And I set field "mge" to "246" in row 3
And I set field "mge" to "246" in row 4
And I set field "mge" to "246" in row 5
And I set field "mge" to "246" in row 6
And I set field "kenn" to "FALL-246"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "246-LS"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-246" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-246"
And I set field "num3" to "246-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "246" in row 1
And I set field "mge" to "246" in row 2
And I set field "mge" to "246" in row 3
And I set field "mge" to "246" in row 4
And I set field "mge" to "246" in row 5
And I set field "mge" to "246" in row 6
And I set field "kenn" to "FALL-246"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "246-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "246-LS"
And I set field "num3" to "246-SLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+246-SLS"
And I close the current editor

#####################################################################################################################################

@FALL-321
Scenario: FALL-321 Rücklieferung VK Lieferschein

# Konto 321-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0321FALL"
And I set field "such" to "FALL-321"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0321FALL"
And I set field "such" to "FALL-321"
And I set field "bestausekso" to "FALL-321"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "321-FALL"
And I set field "num2" to "321-FALL"
And I set field "such" to "FALL-321"
And I set field "namebspr" to "FALL-321"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-321"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-321" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "321-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-321" in row 1
And I set field "mge" to "321" in row 1
And I set field "preis" to "321" in row 1
And I set field "kenn" to "FALL-321"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "321-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-321" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-321"
And I set field "num4" to "321-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "321" in row 1
And I set field "kenn" to "FALL-321"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "321-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-321" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-321"
And I set field "num4" to "321-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "321" in row 1
And I set field "preis" to "321" in row 1
And I set field "kenn" to "FALL-321"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+321-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-321" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "321-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-321" in row 1
And I set field "mge" to "321" in row 1
And I set field "preis" to "321" in row 1
And I set field "kenn" to "FALL-321"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "321-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-321" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-321"
And I set field "num3" to "321-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "321" in row 1
And I set field "kenn" to "FALL-321"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "321-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-321" from table "(Sales):(PackingSlip)" with command "RETURN" for record "321-LS"
And I set field "num3" to "321-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "kunde" is not modifiable
Then field "kl2" is not modifiable
Then field "kunde3" is not modifiable
Then field "vstaat" is modifiable
And I set field "preis" to "321" in row 1
And I set field "proz" to "0" in row 1
And I set field "pwert" to "-9951" in row 1
And I set field "fixpwert" to "ja" in row 1
And I set field "artprg" to "0321-FALL" in row 1
And I set field "artrab" to "0321-FALL" in row 1
And I set field "konddat" to "+3" in row 1
And I set field "lehe" to "1" in row 1
And I set field "pehe" to "1" in row 1
And I set field "konto" to "44000" in row 1
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-321 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+321-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-322
Scenario: FALL-322 Rücklieferung VK Rechnung mit Lagerbewegung

# Konto 322-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0322FALL"
And I set field "such" to "FALL-322"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0322FALL"
And I set field "such" to "FALL-322"
And I set field "bestausekso" to "FALL-322"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "322-FALL"
And I set field "num2" to "322-FALL"
And I set field "such" to "FALL-322"
And I set field "namebspr" to "FALL-322"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-322"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-322" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "322-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-322" in row 1
And I set field "mge" to "322" in row 1
And I set field "preis" to "322" in row 1
And I set field "kenn" to "FALL-322"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "322-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-322" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-322"
And I set field "num4" to "322-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "322" in row 1
And I set field "kenn" to "FALL-322"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "322-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-322" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-322"
And I set field "num4" to "322-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "322" in row 1
And I set field "preis" to "322" in row 1
And I set field "kenn" to "FALL-322"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+322-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-322" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "322-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-322" in row 1
And I set field "mge" to "322" in row 1
And I set field "preis" to "322" in row 1
And I set field "kenn" to "FALL-322"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "322-AU"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-322" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-322"
And I set field "num3" to "322-RE"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "322" in row 1
And I set field "kenn" to "FALL-322"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+322-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-322" from table "(Sales):(Invoice)" with command "RETURN" for record "+322-RE"
And I set field "num3" to "322-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-322 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "322-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-325
Scenario: FALL-325 Rücklieferschein VK Durchgang SET-Artikel

# Konto 325-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0325FALL"
And I set field "such" to "FALL-325"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0325FALL"
And I set field "such" to "FALL-325"
And I set field "bestausekso" to "FALL-325"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "325-FALL-A"
And I set field "num2" to "325-FALL-A"
And I set field "such" to "FALL-325A"
And I set field "namebspr" to "FALL-325A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-325"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "325-FALL-B"
And I set field "num2" to "325-FALL-B"
And I set field "such" to "FALL-325B"
And I set field "namebspr" to "FALL-325B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-325"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "325-FALL-VK"
And I set field "num2" to "325-FALL-VK"
And I set field "such" to "FALL-325VK"
And I set field "namebspr" to "FALL-325VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-325"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-325A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-325B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-325" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "325-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-325A" in row 1
And I set field "mge" to "325" in row 1
And I set field "preis" to "325" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-325B" in row 2
And I set field "mge" to "325" in row 2
And I set field "preis" to "325" in row 2
And I set field "kenn" to "FALL-325"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "325-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-325" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-325"
And I set field "num4" to "325-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "325" in row 1
And I set field "mge" to "325" in row 2
And I set field "kenn" to "FALL-325"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "325-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-325" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-325"
And I set field "num4" to "325-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "325" in row 1
And I set field "preis" to "325" in row 1
And I set field "mge" to "325" in row 2
And I set field "preis" to "325" in row 2
And I set field "kenn" to "FALL-325"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+325-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-325" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "325-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-325VK" in row 1
And I set field "mge" to "325" in row 1
And I set field "preis" to "325" in row 1
And I set field "kenn" to "FALL-325"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "325-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-325" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-325"
And I set field "num3" to "325-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "325" in row 1
And I set field "kenn" to "FALL-325"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "325-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-325" from table "(Sales):(PackingSlip)" with command "RETURN" for record "325-LS"
And I set field "num3" to "325-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-325 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+325-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-326
Scenario: FALL-326 Rücklieferung VK Umlagerungen

# Konto 326-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0326FALL"
And I set field "such" to "FALL-326"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0326FALL"
And I set field "such" to "FALL-326"
And I set field "bestausekso" to "FALL-326"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "326-FALL"
And I set field "num2" to "326-FALL"
And I set field "such" to "FALL-326"
And I set field "namebspr" to "FALL-326"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-326"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-326" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "326-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-326" in row 1
And I set field "mge" to "326" in row 1
And I set field "preis" to "326" in row 1
And I set field "kenn" to "FALL-326"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "326-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-326" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-326"
And I set field "num4" to "326-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "326" in row 1
And I set field "kenn" to "FALL-326"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "326-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-326" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-326"
And I set field "num4" to "326-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "326" in row 1
And I set field "preis" to "326" in row 1
And I set field "kenn" to "FALL-326"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+326-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-326" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "326-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-326" in row 1
And I set field "mge" to "326" in row 1
And I set field "preis" to "326" in row 1
And I set field "kenn" to "FALL-326"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "326-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-326" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-326"
And I set field "num3" to "326-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "326" in row 1
And I set field "kenn" to "FALL-326"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+326-UMLS"
And I close the current editor

# Ruecklieferung von Umlagerungslieferscheinen nicht mehr erlaubt.
Given opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-326" throws the exception "1525"

#####################################################################################################################################

@FALL-327
Scenario: FALL-327 Rücklieferung VK Lieferschein mit Materialzuordnung

# Konto 327-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0327FALL"
And I set field "such" to "FALL-327"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0327FALL"
And I set field "such" to "FALL-327"
And I set field "bestausekso" to "FALL-327"
And I save the current editor


# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "327-FALL"
And I set field "num2" to "327-FALL"
And I set field "such" to "FALL-327"
And I set field "namebspr" to "FALL-327"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-327"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-327" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "327-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-327" in row 1
And I set field "mge" to "327" in row 1
And I set field "preis" to "327" in row 1
And I set field "kenn" to "FALL-327"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "327-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-327" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-327"
And I set field "num4" to "327-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "327" in row 1
And I set field "kenn" to "FALL-327"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "230" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "37" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-327"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "327-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-327" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-327"
And I set field "num4" to "327-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "327" in row 1
And I set field "preis" to "327" in row 1
And I set field "kenn" to "FALL-327"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+327-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-327" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "327-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-327" in row 1
And I set field "mge" to "327" in row 1
And I set field "preis" to "327" in row 1
And I set field "kenn" to "FALL-327"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "327-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-327" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-327"
And I set field "num3" to "327-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "327" in row 1
And I set field "kenn" to "FALL-327"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "230" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "37" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-327"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "327-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-327" from table "(Sales):(PackingSlip)" with command "RETURN" for record "327-LS"
And I set field "num3" to "327-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-131" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-327 Ruecklieferschein"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "-30" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "-30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "-30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "-41" in row 4
And I save the current editor
And I switch the current editor to editor "rls-327"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+327-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-341
Scenario: FALL-341 Rücklieferung VK Lieferschein Durchgang SET-Artikel, mit indiv. Set-Liste

# Konto 341-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0341FALL"
And I set field "such" to "FALL-341"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0341FALL"
And I set field "such" to "FALL-341"
And I set field "bestausekso" to "FALL-341"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "341-FALL-A"
And I set field "num2" to "341-FALL-A"
And I set field "such" to "FALL-341A"
And I set field "namebspr" to "FALL-341A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-341"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "341-FALL-B"
And I set field "num2" to "341-FALL-B"
And I set field "such" to "FALL-341B"
And I set field "namebspr" to "FALL-341B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-341"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "341-FALL-C"
And I set field "num2" to "341-FALL-C"
And I set field "such" to "FALL-341C"
And I set field "namebspr" to "FALL-341C"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-341"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "341-FALL-VK"
And I set field "num2" to "341-FALL-VK"
And I set field "such" to "FALL-341VK"
And I set field "namebspr" to "FALL-341VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-341"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-341A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-341B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-341" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "341-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-341A" in row 1
And I set field "mge" to "341" in row 1
And I set field "preis" to "341" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-341B" in row 2
And I set field "mge" to "341" in row 2
And I set field "preis" to "341" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-341C" in row 3
And I set field "mge" to "341" in row 3
And I set field "preis" to "341" in row 3
And I set field "kenn" to "FALL-341"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "341-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-341" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-341"
And I set field "num4" to "341-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "341" in row 1
And I set field "mge" to "341" in row 2
And I set field "mge" to "341" in row 3
And I set field "kenn" to "FALL-341"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "341-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-341" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-341"
And I set field "num4" to "341-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "341" in row 1
And I set field "preis" to "341" in row 1
And I set field "mge" to "341" in row 2
And I set field "preis" to "341" in row 2
And I set field "mge" to "341" in row 3
And I set field "preis" to "341" in row 3
And I set field "kenn" to "FALL-341"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+341-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-341" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "341-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-341VK" in row 1
And I set field "mge" to "341" in row 1
And I set field "preis" to "341" in row 1
And I set field "kenn" to "FALL-341"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-341C" in row 3
And I set field "elanzahl" to "0,5" in row 3
And I save the current editor
And I switch the current editor to editor "auftrag-341"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "341-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-341" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-341"
And I set field "num3" to "341-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "341" in row 1
And I set field "kenn" to "FALL-341"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "341-LS"
And I close the current editor

# Rücklieferung Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "RETURN" for record "341-LS"
And I set field "num3" to "341-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-341 Ruecklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+341-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-342
Scenario: FALL-342 Rücklieferung VK Lieferschein SET in SET

# Konto 342-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0342FALL"
And I set field "such" to "FALL-342"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0342FALL"
And I set field "such" to "FALL-342"
And I set field "bestausekso" to "FALL-342"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "342-FALL-A"
And I set field "num2" to "342-FALL-A"
And I set field "such" to "FALL-342A"
And I set field "namebspr" to "FALL-342A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-342"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "342-FALL-B"
And I set field "num2" to "342-FALL-B"
And I set field "such" to "FALL-342B"
And I set field "namebspr" to "FALL-342B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-342"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "342-FALL-C"
And I set field "num2" to "342-FALL-C"
And I set field "such" to "FALL-342C"
And I set field "namebspr" to "FALL-342C"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-342"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "342-FALL-D"
And I set field "num2" to "342-FALL-D"
And I set field "such" to "FALL-342D"
And I set field "namebspr" to "FALL-342D"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-342"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "342-FALL-E"
And I set field "num2" to "342-FALL-E"
And I set field "such" to "FALL-342E"
And I set field "namebspr" to "FALL-342E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-342"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "342-FALL-SE"
And I set field "num2" to "342-FALL-SE"
And I set field "such" to "FALL-342SE"
And I set field "namebspr" to "FALL-342SET"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-342"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-342A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-342B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "342-FALL-VK"
And I set field "num2" to "342-FALL-VK"
And I set field "such" to "FALL-342VK"
And I set field "namebspr" to "FALL-342VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-342"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-342C" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-342D" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-342" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "342-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-342A" in row 1
And I set field "mge" to "342" in row 1
And I set field "preis" to "342" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-342B" in row 2
And I set field "mge" to "342" in row 2
And I set field "preis" to "342" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-342C" in row 3
And I set field "mge" to "342" in row 3
And I set field "preis" to "342" in row 3
And I create a new row at the end of the table
And I set field "artex" to "FALL-342D" in row 4
And I set field "mge" to "342" in row 4
And I set field "preis" to "342" in row 4
And I create a new row at the end of the table
And I set field "artex" to "FALL-342E" in row 5
And I set field "mge" to "342" in row 5
And I set field "preis" to "342" in row 5
And I set field "kenn" to "FALL-342"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "342-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-342" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-342"
And I set field "num4" to "342-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "342" in row 1
And I set field "mge" to "342" in row 2
And I set field "mge" to "342" in row 3
And I set field "mge" to "342" in row 4
And I set field "mge" to "342" in row 5
And I set field "kenn" to "FALL-342"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "342-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-342" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-342"
And I set field "num4" to "342-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "342" in row 1
And I set field "preis" to "342" in row 1
And I set field "mge" to "342" in row 2
And I set field "preis" to "342" in row 2
And I set field "mge" to "342" in row 3
And I set field "preis" to "342" in row 3
And I set field "mge" to "342" in row 4
And I set field "preis" to "342" in row 4
And I set field "mge" to "342" in row 5
And I set field "preis" to "342" in row 5
And I set field "kenn" to "FALL-342"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+342-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-342" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "342-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-342VK" in row 1
And I set field "mge" to "342" in row 1
And I set field "preis" to "342" in row 1
And I set field "kenn" to "FALL-342"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-342SE" in row 3
# Set wird jetzt aufgeloest
And I respond with answer "Ja" to the dialog with id "1537"
And I set field "elanzahl" to "0,7" in row 3
And I save the current editor
And I switch the current editor to editor "auftrag-342"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "342-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-342" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-342"
And I set field "num3" to "342-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "342" in row 1
And I set field "kenn" to "FALL-342"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "342-LS"
And I close the current editor

# Rücklieferung Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "RETURN" for record "342-LS"
And I set field "num3" to "342-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-342 Ruecklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+342-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-346
Scenario:  FALL-346 Rücklieferschein VK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ

# Konto 346-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0346FALL"
And I set field "such" to "FALL-346"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0346FALL"
And I set field "such" to "FALL-346"
And I set field "bestausekso" to "FALL-346"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "346A-FALL"
And I set field "num2" to "346A-FALL"
And I set field "such" to "FALL-346A"
And I set field "namebspr" to "FALL-346A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-346"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "346B-FALL"
And I set field "num2" to "346B-FALL"
And I set field "such" to "FALL-346B"
And I set field "namebspr" to "FALL-346B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-346"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "346V-FALL"
And I set field "num2" to "346V-FALL"
And I set field "such" to "FALL-346V"
And I set field "namebspr" to "FALL-346V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-346"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "346E-FALL"
And I set field "num2" to "346E-FALL"
And I set field "such" to "FALL-346E"
And I set field "namebspr" to "FALL-346E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-346"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "346M-FALL"
And I set field "num2" to "346M-FALL"
And I set field "such" to "FALL-346M"
And I set field "namebspr" to "FALL-346M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-346"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "346R-FALL"
And I set field "num2" to "346R-FALL"
And I set field "such" to "FALL-346R"
And I set field "namebspr" to "FALL-346R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-346"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor


# Auftrag anlegen
Given I open an editor "auftrag-346" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "346-AU"

And I create a new row at the end of the table
And I set field "artex" to "FALL-346A" in row 1
And I set field "mge" to "346" in row 1
And I set field "preis" to "346" in row 1
And I set field "verw" to "FALL346A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-346B" in row 2
And I set field "mge" to "346" in row 2
And I set field "preis" to "346" in row 2
And I set field "verw" to "FALL346B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-346V" in row 3
And I set field "mge" to "346" in row 3
And I set field "preis" to "346" in row 3
And I set field "verw" to "FALL346V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-346E" in row 4
And I set field "mge" to "346" in row 4
And I set field "preis" to "346" in row 4
And I set field "verw" to "FALL346E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-346M" in row 5
And I set field "mge" to "346" in row 5
And I set field "preis" to "346" in row 5
And I set field "verw" to "FALL346M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-346R" in row 6
And I set field "mge" to "346" in row 6
And I set field "preis" to "346" in row 6
And I set field "verw" to "FALL346R" in row 6

And I set field "kenn" to "FALL-346"
And I save the current editor

# # Dispo starten
#And I run Scheduling


# Bestellung anlegen
Given I open an editor "bestellung-346" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "346-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-346A" in row 1
And I set field "mge" to "346" in row 1
And I set field "preis" to "346" in row 1
And I set field "verw" to "FALL346A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-346B" in row 2
And I set field "mge" to "346" in row 2
And I set field "preis" to "346" in row 2
And I set field "verw" to "FALL346B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-346V" in row 3
And I set field "mge" to "346" in row 3
And I set field "preis" to "346" in row 3
And I set field "verw" to "FALL346V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-346E" in row 4
And I set field "mge" to "346" in row 4
And I set field "preis" to "346" in row 4
And I set field "verw" to "FALL346E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-346M" in row 5
And I set field "mge" to "346" in row 5
And I set field "preis" to "346" in row 5
And I set field "verw" to "FALL346M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-346R" in row 6
And I set field "mge" to "346" in row 6
And I set field "preis" to "346" in row 6
And I set field "verw" to "FALL346R" in row 6

And I set field "kenn" to "FALL-346"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "346-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-346" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-346"
And I set field "num4" to "346-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "346" in row 1
And I set field "mge" to "346" in row 2
And I set field "mge" to "346" in row 3
And I set field "mge" to "346" in row 4
And I set field "mge" to "346" in row 5
And I set field "mge" to "346" in row 6
And I set field "kenn" to "FALL-346"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "346-LS"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-346" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-346"
And I set field "num3" to "346-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "346" in row 1
And I set field "mge" to "346" in row 2
And I set field "mge" to "346" in row 3
And I set field "mge" to "346" in row 4
And I set field "mge" to "346" in row 5
And I set field "mge" to "346" in row 6
And I set field "kenn" to "FALL-346"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "346-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-346" from table "(Sales):(PackingSlip)" with command "RETURN" for record "346-LS"
And I set field "num3" to "346-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "mge" to "-31" in row 2
And I set field "mge" to "-31" in row 3
And I set field "mge" to "-31" in row 4
And I set field "mge" to "-31" in row 5
And I set field "mge" to "-31" in row 6
And I set field "kenn" to "FALL-346 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+346-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-347
Scenario:  FALL-347 Rücklieferschein VK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ ohne Verwendung ans lager

# Konto 347-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0347FALL"
And I set field "such" to "FALL-347"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0347FALL"
And I set field "such" to "FALL-347"
And I set field "bestausekso" to "FALL-347"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "347A-FALL"
And I set field "num2" to "347A-FALL"
And I set field "such" to "FALL-347A"
And I set field "namebspr" to "FALL-347A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-347"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "347B-FALL"
And I set field "num2" to "347B-FALL"
And I set field "such" to "FALL-347B"
And I set field "namebspr" to "FALL-347B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-347"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "347V-FALL"
And I set field "num2" to "347V-FALL"
And I set field "such" to "FALL-347V"
And I set field "namebspr" to "FALL-347V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-347"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "347E-FALL"
And I set field "num2" to "347E-FALL"
And I set field "such" to "FALL-347E"
And I set field "namebspr" to "FALL-347E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-347"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "347M-FALL"
And I set field "num2" to "347M-FALL"
And I set field "such" to "FALL-347M"
And I set field "namebspr" to "FALL-347M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-347"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "347R-FALL"
And I set field "num2" to "347R-FALL"
And I set field "such" to "FALL-347R"
And I set field "namebspr" to "FALL-347R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-347"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor


# Auftrag anlegen
Given I open an editor "auftrag-347" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "347-AU"

And I create a new row at the end of the table
And I set field "artex" to "FALL-347A" in row 1
And I set field "mge" to "347" in row 1
And I set field "preis" to "347" in row 1
And I set field "verw" to "FALL347A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-347B" in row 2
And I set field "mge" to "347" in row 2
And I set field "preis" to "347" in row 2
And I set field "verw" to "FALL347B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-347V" in row 3
And I set field "mge" to "347" in row 3
And I set field "preis" to "347" in row 3
And I set field "verw" to "FALL347V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-347E" in row 4
And I set field "mge" to "347" in row 4
And I set field "preis" to "347" in row 4
And I set field "verw" to "FALL347E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-347M" in row 5
And I set field "mge" to "347" in row 5
And I set field "preis" to "347" in row 5
And I set field "verw" to "FALL347M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-347R" in row 6
And I set field "mge" to "347" in row 6
And I set field "preis" to "347" in row 6
And I set field "verw" to "FALL347R" in row 6

And I set field "kenn" to "FALL-347"
And I save the current editor

# # Dispo starten
# And I run Scheduling


# Bestellung anlegen
Given I open an editor "bestellung-347" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "347-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-347A" in row 1
And I set field "mge" to "347" in row 1
And I set field "preis" to "347" in row 1
And I set field "verw" to "FALL347A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-347B" in row 2
And I set field "mge" to "347" in row 2
And I set field "preis" to "347" in row 2
And I set field "verw" to "FALL347B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-347V" in row 3
And I set field "mge" to "347" in row 3
And I set field "preis" to "347" in row 3
And I set field "verw" to "FALL347V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-347E" in row 4
And I set field "mge" to "347" in row 4
And I set field "preis" to "347" in row 4
And I set field "verw" to "FALL347E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-347M" in row 5
And I set field "mge" to "347" in row 5
And I set field "preis" to "347" in row 5
And I set field "verw" to "FALL347M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-347R" in row 6
And I set field "mge" to "347" in row 6
And I set field "preis" to "347" in row 6
And I set field "verw" to "FALL347R" in row 6

And I set field "kenn" to "FALL-347"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "347-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-347" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-347"
And I set field "num4" to "347-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "347" in row 1
And I set field "mge" to "347" in row 2
And I set field "mge" to "347" in row 3
And I set field "mge" to "347" in row 4
And I set field "mge" to "347" in row 5
And I set field "mge" to "347" in row 6
And I set field "kenn" to "FALL-347"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "347-LS"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-347" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-347"
And I set field "num3" to "347-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "347" in row 1
And I set field "mge" to "347" in row 2
And I set field "mge" to "347" in row 3
And I set field "mge" to "347" in row 4
And I set field "mge" to "347" in row 5
And I set field "mge" to "347" in row 6
And I set field "kenn" to "FALL-347"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "347-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-347" from table "(Sales):(PackingSlip)" with command "RETURN" for record "347-LS"
And I set field "num3" to "347-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "mge" to "-31" in row 2
And I set field "mge" to "-31" in row 3
And I set field "mge" to "-31" in row 4
And I set field "mge" to "-31" in row 5
And I set field "mge" to "-31" in row 6
And I set field "kenn" to "FALL-347 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+347-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-348
Scenario:  FALL-348 Rücklieferschein VK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ auf anderen lagerplatz

# Konto 348-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0348FALL"
And I set field "such" to "FALL-348"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0348FALL"
And I set field "such" to "FALL-348"
And I set field "bestausekso" to "FALL-348"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "348A-FALL"
And I set field "num2" to "348A-FALL"
And I set field "such" to "FALL-348A"
And I set field "namebspr" to "FALL-348A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-348"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "348B-FALL"
And I set field "num2" to "348B-FALL"
And I set field "such" to "FALL-348B"
And I set field "namebspr" to "FALL-348B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-348"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "348V-FALL"
And I set field "num2" to "348V-FALL"
And I set field "such" to "FALL-348V"
And I set field "namebspr" to "FALL-348V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-348"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "348E-FALL"
And I set field "num2" to "348E-FALL"
And I set field "such" to "FALL-348E"
And I set field "namebspr" to "FALL-348E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-348"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "348M-FALL"
And I set field "num2" to "348M-FALL"
And I set field "such" to "FALL-348M"
And I set field "namebspr" to "FALL-348M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-348"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "348R-FALL"
And I set field "num2" to "348R-FALL"
And I set field "such" to "FALL-348R"
And I set field "namebspr" to "FALL-348R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-348"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor


# Auftrag anlegen
Given I open an editor "auftrag-348" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "348-AU"

And I create a new row at the end of the table
And I set field "artex" to "FALL-348A" in row 1
And I set field "mge" to "348" in row 1
And I set field "preis" to "348" in row 1
And I set field "verw" to "FALL348A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-348B" in row 2
And I set field "mge" to "348" in row 2
And I set field "preis" to "348" in row 2
And I set field "verw" to "FALL348B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-348V" in row 3
And I set field "mge" to "348" in row 3
And I set field "preis" to "348" in row 3
And I set field "verw" to "FALL348V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-348E" in row 4
And I set field "mge" to "348" in row 4
And I set field "preis" to "348" in row 4
And I set field "verw" to "FALL348E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-348M" in row 5
And I set field "mge" to "348" in row 5
And I set field "preis" to "348" in row 5
And I set field "verw" to "FALL348M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-348R" in row 6
And I set field "mge" to "348" in row 6
And I set field "preis" to "348" in row 6
And I set field "verw" to "FALL348R" in row 6

And I set field "kenn" to "FALL-348"
And I save the current editor

# # Dispo starten
# And I run Scheduling


# Bestellung anlegen
Given I open an editor "bestellung-348" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "348-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-348A" in row 1
And I set field "mge" to "348" in row 1
And I set field "preis" to "348" in row 1
And I set field "verw" to "FALL348A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-348B" in row 2
And I set field "mge" to "348" in row 2
And I set field "preis" to "348" in row 2
And I set field "verw" to "FALL348B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-348V" in row 3
And I set field "mge" to "348" in row 3
And I set field "preis" to "348" in row 3
And I set field "verw" to "FALL348V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-348E" in row 4
And I set field "mge" to "348" in row 4
And I set field "preis" to "348" in row 4
And I set field "verw" to "FALL348E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-348M" in row 5
And I set field "mge" to "348" in row 5
And I set field "preis" to "348" in row 5
And I set field "verw" to "FALL348M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-348R" in row 6
And I set field "mge" to "348" in row 6
And I set field "preis" to "348" in row 6
And I set field "verw" to "FALL348R" in row 6

And I set field "kenn" to "FALL-348"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "348-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-348" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-348"
And I set field "num4" to "348-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "348" in row 1
And I set field "mge" to "348" in row 2
And I set field "mge" to "348" in row 3
And I set field "mge" to "348" in row 4
And I set field "mge" to "348" in row 5
And I set field "mge" to "348" in row 6
And I set field "kenn" to "FALL-348"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "348-LS"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-348" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-348"
And I set field "num3" to "348-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "348" in row 1
And I set field "mge" to "348" in row 2
And I set field "mge" to "348" in row 3
And I set field "mge" to "348" in row 4
And I set field "mge" to "348" in row 5
And I set field "mge" to "348" in row 6
And I set field "kenn" to "FALL-348"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "348-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-348" from table "(Sales):(PackingSlip)" with command "RETURN" for record "348-LS"
And I set field "num3" to "348-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F2" in row 1
And I set field "mge" to "-31" in row 2
And I set field "platz" to "F2" in row 2
And I set field "mge" to "-31" in row 3
And I set field "platz" to "F2" in row 3
And I set field "mge" to "-31" in row 4
And I set field "platz" to "F2" in row 4
And I set field "mge" to "-31" in row 5
And I set field "platz" to "F2" in row 5
And I set field "mge" to "-31" in row 6
And I set field "platz" to "F2" in row 6
And I set field "kenn" to "FALL-348 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+348-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-349
Scenario:  FALL-349 Rücklieferschein VK Lieferschein mit allen Dispo-Artikel-Varianten mit Dispo-MZ auf anderen lagerplatz ohne Verwendung ans lager

# Konto 349-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0349FALL"
And I set field "such" to "FALL-349"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0349FALL"
And I set field "such" to "FALL-349"
And I set field "bestausekso" to "FALL-349"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "349A-FALL"
And I set field "num2" to "349A-FALL"
And I set field "such" to "FALL-349A"
And I set field "namebspr" to "FALL-349A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "auftragsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-349"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "349B-FALL"
And I set field "num2" to "349B-FALL"
And I set field "such" to "FALL-349B"
And I set field "namebspr" to "FALL-349B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-349"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "349V-FALL"
And I set field "num2" to "349V-FALL"
And I set field "such" to "FALL-349V"
And I set field "namebspr" to "FALL-349V"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "variantenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-349"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "349E-FALL"
And I set field "num2" to "349E-FALL"
And I set field "such" to "FALL-349E"
And I set field "namebspr" to "FALL-349E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "(ExtendedRequirementRelated)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-349"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "349M-FALL"
And I set field "num2" to "349M-FALL"
And I set field "such" to "FALL-349M"
And I set field "namebspr" to "FALL-349M"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "mindestbestandsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-349"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "349R-FALL"
And I set field "num2" to "349R-FALL"
And I set field "such" to "FALL-349R"
And I set field "namebspr" to "FALL-349R"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "restmengenbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-349"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor


# Auftrag anlegen
Given I open an editor "auftrag-349" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "349-AU"

And I create a new row at the end of the table
And I set field "artex" to "FALL-349A" in row 1
And I set field "mge" to "349" in row 1
And I set field "preis" to "349" in row 1
And I set field "verw" to "FALL349A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-349B" in row 2
And I set field "mge" to "349" in row 2
And I set field "preis" to "349" in row 2
And I set field "verw" to "FALL349B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-349V" in row 3
And I set field "mge" to "349" in row 3
And I set field "preis" to "349" in row 3
And I set field "verw" to "FALL349V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-349E" in row 4
And I set field "mge" to "349" in row 4
And I set field "preis" to "349" in row 4
And I set field "verw" to "FALL349E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-349M" in row 5
And I set field "mge" to "349" in row 5
And I set field "preis" to "349" in row 5
And I set field "verw" to "FALL349M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-349R" in row 6
And I set field "mge" to "349" in row 6
And I set field "preis" to "349" in row 6
And I set field "verw" to "FALL349R" in row 6

And I set field "kenn" to "FALL-349"
And I save the current editor

# # Dispo starten
# And I run Scheduling


# Bestellung anlegen
Given I open an editor "bestellung-349" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "349-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-349A" in row 1
And I set field "mge" to "349" in row 1
And I set field "preis" to "349" in row 1
And I set field "verw" to "FALL349A" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-349B" in row 2
And I set field "mge" to "349" in row 2
And I set field "preis" to "349" in row 2
And I set field "verw" to "FALL349B" in row 2

And I create a new row at the end of the table
And I set field "artex" to "FALL-349V" in row 3
And I set field "mge" to "349" in row 3
And I set field "preis" to "349" in row 3
And I set field "verw" to "FALL349V" in row 3

And I create a new row at the end of the table
And I set field "artex" to "FALL-349E" in row 4
And I set field "mge" to "349" in row 4
And I set field "preis" to "349" in row 4
And I set field "verw" to "FALL349E" in row 4

And I create a new row at the end of the table
And I set field "artex" to "FALL-349M" in row 5
And I set field "mge" to "349" in row 5
And I set field "preis" to "349" in row 5
And I set field "verw" to "FALL349M" in row 5

And I create a new row at the end of the table
And I set field "artex" to "FALL-349R" in row 6
And I set field "mge" to "349" in row 6
And I set field "preis" to "349" in row 6
And I set field "verw" to "FALL349R" in row 6

And I set field "kenn" to "FALL-349"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "349-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-349" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-349"
And I set field "num4" to "349-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "349" in row 1
And I set field "mge" to "349" in row 2
And I set field "mge" to "349" in row 3
And I set field "mge" to "349" in row 4
And I set field "mge" to "349" in row 5
And I set field "mge" to "349" in row 6
And I set field "kenn" to "FALL-349"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "349-LS"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-349" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-349"
And I set field "num3" to "349-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "349" in row 1
And I set field "mge" to "349" in row 2
And I set field "mge" to "349" in row 3
And I set field "mge" to "349" in row 4
And I set field "mge" to "349" in row 5
And I set field "mge" to "349" in row 6
And I set field "kenn" to "FALL-349"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "349-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-349" from table "(Sales):(PackingSlip)" with command "RETURN" for record "349-LS"
And I set field "num3" to "349-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F2" in row 1
And I set field "mge" to "-31" in row 2
And I set field "platz" to "F2" in row 2
And I set field "mge" to "-31" in row 3
And I set field "platz" to "F2" in row 3
And I set field "mge" to "-31" in row 4
And I set field "platz" to "F2" in row 4
And I set field "mge" to "-31" in row 5
And I set field "platz" to "F2" in row 5
And I set field "mge" to "-31" in row 6
And I set field "platz" to "F2" in row 6
And I set field "kenn" to "FALL-349 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+349-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-351
Scenario: FALL-351 Rücklieferung VK Nach Rechnung

# Konto 351-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0351FALL"
And I set field "such" to "FALL-351"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0351FALL"
And I set field "such" to "FALL-351"
And I set field "bestausekso" to "FALL-351"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "351-FALL"
And I set field "num2" to "351-FALL"
And I set field "such" to "FALL-351"
And I set field "namebspr" to "FALL-351"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-351"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-351" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "351-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-351" in row 1
And I set field "mge" to "351" in row 1
And I set field "preis" to "351" in row 1
And I set field "kenn" to "FALL-351"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "351-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-351" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-351"
And I set field "num4" to "351-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "351" in row 1
And I set field "kenn" to "FALL-351"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "351-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-351" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-351"
And I set field "num4" to "351-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "351" in row 1
And I set field "preis" to "351" in row 1
And I set field "kenn" to "FALL-351"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+351-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-351" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "351-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-351" in row 1
And I set field "mge" to "351" in row 1
And I set field "preis" to "351" in row 1
And I set field "kenn" to "FALL-351"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "351-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-351" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-351"
And I set field "num3" to "351-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "351" in row 1
And I set field "kenn" to "FALL-351"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "351-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-351" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-351"
And I set field "num3" to "351-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "351" in row 1
And I set field "kenn" to "FALL-351"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+351-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-351" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+351-LS"
And I set field "num3" to "351-RULS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-158" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-351 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "351-RULS"
And I close the current editor

#####################################################################################################################################

@FALL-363
Scenario: FALL-363 Rücklieferung VK	Bleibt Kundeneigentum, wir lagern es auf externer Konsi Lagergruppe ein

# Konto 363-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0363FALL"
And I set field "such" to "FALL-363"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0363FALL"
And I set field "such" to "FALL-363"
And I set field "bestausekso" to "FALL-363"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "363-FALL"
And I set field "num2" to "363-FALL"
And I set field "such" to "FALL-363"
And I set field "namebspr" to "FALL-363"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-363"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-363" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "363-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-363" in row 1
And I set field "mge" to "363" in row 1
And I set field "preis" to "363" in row 1
And I set field "kenn" to "FALL-363"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "363-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-363" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-363"
And I set field "num4" to "363-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "363" in row 1
And I set field "kenn" to "FALL-363"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "363-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-363" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-363"
And I set field "num4" to "363-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "363" in row 1
And I set field "preis" to "363" in row 1
And I set field "kenn" to "FALL-363"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+363-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-363" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "363-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-363" in row 1
And I set field "mge" to "363" in row 1
And I set field "preis" to "363" in row 1
And I set field "kenn" to "FALL-363"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "363-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-363" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-363"
And I set field "num3" to "363-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "363" in row 1
And I set field "kenn" to "FALL-363"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "363-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-363" from table "(Sales):(PackingSlip)" with command "RETURN" for record "363-LS"
And I set field "num3" to "363-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "preis" to "363" in row 1
And I set field "platz" to "KUNDEEIG" in row 1
And I set field "kenn" to "FALL-363 Rücklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+363-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-421
Scenario: FALL-421 Gutschrift VK Rechnung

# Konto 421-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0421FALL"
And I set field "such" to "FALL-421"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0421FALL"
And I set field "such" to "FALL-421"
And I set field "bestausekso" to "FALL-421"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "421-FALL"
And I set field "num2" to "421-FALL"
And I set field "such" to "FALL-421"
And I set field "namebspr" to "FALL-421"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-421"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-421" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "421-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-421" in row 1
And I set field "mge" to "421" in row 1
And I set field "preis" to "421" in row 1
And I set field "kenn" to "FALL-421"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "421-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-421" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-421"
And I set field "num4" to "421-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "421" in row 1
And I set field "kenn" to "FALL-421"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "421-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-421" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-421"
And I set field "num4" to "421-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "421" in row 1
And I set field "preis" to "421" in row 1
And I set field "kenn" to "FALL-421"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+421-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-421" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "421-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-421" in row 1
And I set field "mge" to "421" in row 1
And I set field "preis" to "421" in row 1
And I set field "kenn" to "FALL-421"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "421-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-421" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-421"
And I set field "num3" to "421-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "421" in row 1
And I set field "kenn" to "FALL-421"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "421-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-421" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-421"
And I set field "num3" to "421-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "421" in row 1
And I set field "kenn" to "FALL-421"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+421-RE"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "Rechnung-421" from table "(Sales):(Invoice)" with command "COPY" for record "+421-RE"
And I set field "num3" to "421-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "fakt" to "NEIN"
And I set field "mge" to "421" in row 1
And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-421"
# And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+421-GS"
And I close the current editor

#####################################################################################################################################

@FALL-424
Scenario: FALL-424 Storno VK Gutschrift

# Konto 424-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0424FALL"
And I set field "such" to "FALL-424"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0424FALL"
And I set field "such" to "FALL-424"
And I set field "bestausekso" to "FALL-424"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "424-FALL"
And I set field "num2" to "424-FALL"
And I set field "such" to "FALL-424"
And I set field "namebspr" to "FALL-424"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-424"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-424" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "424-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-424" in row 1
And I set field "mge" to "424" in row 1
And I set field "preis" to "424" in row 1
And I set field "kenn" to "FALL-424"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "424-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-424" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-424"
And I set field "num4" to "424-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "424" in row 1
And I set field "kenn" to "FALL-424"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "424-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-424" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-424"
And I set field "num4" to "424-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "424" in row 1
And I set field "preis" to "424" in row 1
And I set field "kenn" to "FALL-424"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+424-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-424" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "424-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-424" in row 1
And I set field "mge" to "424" in row 1
And I set field "preis" to "424" in row 1
And I set field "kenn" to "FALL-424"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "424-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-424" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-424"
And I set field "num3" to "424-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "424" in row 1
And I set field "kenn" to "FALL-424"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "424-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-424" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-424"
And I set field "num3" to "424-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "424" in row 1
And I set field "kenn" to "FALL-424"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+424-RE"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "Rechnung-424" from table "(Sales):(Invoice)" with command "COPY" for record "+424-RE"
And I set field "num3" to "424-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "fakt" to "NEIN"
And I set field "mge" to "424" in row 1
And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-424"
# And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+424-GS"
And I close the current editor

# Storno Gutschrift
Given I open an editor "Rechnung-424" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+424-GS"
And I set field "num3" to "424-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+424-SGS"
And I close the current editor

#####################################################################################################################################

@FALL-425
Scenario: FALL-425 Gutschrift VK zu Rücklieferung

# Konto 425-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0425FALL"
And I set field "such" to "FALL-425"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0425FALL"
And I set field "such" to "FALL-425"
And I set field "bestausekso" to "FALL-425"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "425-FALL"
And I set field "num2" to "425-FALL"
And I set field "such" to "FALL-425"
And I set field "namebspr" to "FALL-425"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-425"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-425" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "425-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-425" in row 1
And I set field "mge" to "425" in row 1
And I set field "preis" to "425" in row 1
And I set field "kenn" to "FALL-425"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "425-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-425" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-425"
And I set field "num4" to "425-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "425" in row 1
And I set field "kenn" to "FALL-425"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "425-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-425" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-425"
And I set field "num4" to "425-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "425" in row 1
And I set field "preis" to "425" in row 1
And I set field "kenn" to "FALL-425"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+425-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-425" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "425-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-425" in row 1
And I set field "mge" to "425" in row 1
And I set field "preis" to "425" in row 1
And I set field "kenn" to "FALL-425"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "425-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-425" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-425"
And I set field "num3" to "425-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "425" in row 1
And I set field "kenn" to "FALL-425"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "425-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-425" from table "(Sales):(PackingSlip)" with command "RETURN" for record "425-LS"
And I set field "num3" to "425-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-425 Ruecklieferschein"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+425-RLS"
And I close the current editor

# Rechnung anlegen aus Lieferschein
Given I open an editor "rechnung1-425" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-425"
And I set field "num3" to "425-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Keine Ueberberechnung moeglich
And I set field "mge" to "394" in row 1
And I set field "preis" to "425" in row 1
And I set field "kenn" to "FALL-425"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+425-RE"
And I close the current editor

#####################################################################################################################################

@FALL-445
Scenario: FALL-445 Neu VK Anzahlungsrechnung

# Konto 445-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0445FALL"
And I set field "such" to "FALL-445"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0445FALL"
And I set field "such" to "FALL-445"
And I set field "bestausekso" to "FALL-445"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "445-FALL"
And I set field "num2" to "445-FALL"
And I set field "such" to "FALL-445"
And I set field "namebspr" to "FALL-445"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-445"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-445" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "445-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-445" in row 1
And I set field "mge" to "445" in row 1
And I set field "preis" to "445" in row 1
And I set field "kenn" to "FALL-445"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "445-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-445" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-445"
And I set field "num4" to "445-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "445" in row 1
And I set field "kenn" to "FALL-445"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "445-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-445" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-445"
And I set field "num4" to "445-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "445" in row 1
And I set field "preis" to "445" in row 1
And I set field "kenn" to "FALL-445"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+445-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-445" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "445-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-445" in row 1
And I set field "mge" to "445" in row 1
And I set field "preis" to "445" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2

And I set field "kenn" to "FALL-445"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "445-AU"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "rechnung-445" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "auftrag-445"
And I set field "num3" to "445-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-445"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+445-AR"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-445" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-445"
And I set field "num3" to "445-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "445" in row 1
And I set field "kenn" to "FALL-445"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "445-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-445" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-445"
And I set field "num3" to "445-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "445" in row 1
And I set field "kenn" to "FALL-445"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+445-RE"
And I close the current editor

# Gutschrift zu Anzahlungsrechnung erstellen
Given I open an editor "Gutschrift" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "auftrag-445"
And I set field "num3" to "445-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-445"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+445-GS"
And I close the current editor

#####################################################################################################################################

@FALL-451
Scenario: FALL-451 Rücklieferung VK Nach Rechnung

# Konto 451-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0451FALL"
And I set field "such" to "FALL-451"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0451FALL"
And I set field "such" to "FALL-451"
And I set field "bestausekso" to "FALL-451"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "451-FALL"
And I set field "num2" to "451-FALL"
And I set field "such" to "FALL-451"
And I set field "namebspr" to "FALL-451"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-451"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-451" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "451-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-451" in row 1
And I set field "mge" to "451" in row 1
And I set field "preis" to "451" in row 1
And I set field "kenn" to "FALL-451"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "451-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-451" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-451"
And I set field "num4" to "451-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "451" in row 1
And I set field "kenn" to "FALL-451"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "451-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-451" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-451"
And I set field "num4" to "451-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "451" in row 1
And I set field "preis" to "451" in row 1
And I set field "kenn" to "FALL-451"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+451-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-451" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "451-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-451" in row 1
And I set field "mge" to "451" in row 1
And I set field "preis" to "451" in row 1
And I set field "kenn" to "FALL-451"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "451-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-451" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-451"
And I set field "num3" to "451-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "451" in row 1
And I set field "kenn" to "FALL-451"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "451-LS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-451" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-451"
And I set field "num3" to "451-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "451" in row 1
And I set field "kenn" to "FALL-451"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+451-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-451" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+451-LS"
And I set field "num3" to "451-RULS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-158" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-451 Ruecklieferschein"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "451-RULS"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "Rechnung-451" from table "(Sales):(Invoice)" with command "COPY" for record "451-RULS"
And I set field "num3" to "451-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "451" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-451"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+451-GS"
And I close the current editor

#####################################################################################################################################

@FALL-521
Scenario: FALL-521 Storno Rücklieferung VK Lieferschein

# Konto 521-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0521FALL"
And I set field "such" to "FALL-521"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0521FALL"
And I set field "such" to "FALL-521"
And I set field "bestausekso" to "FALL-521"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "521-FALL"
And I set field "num2" to "521-FALL"
And I set field "such" to "FALL-521"
And I set field "namebspr" to "FALL-521"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-521"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-521" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "521-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-521" in row 1
And I set field "mge" to "521" in row 1
And I set field "preis" to "521" in row 1
And I set field "kenn" to "FALL-521"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "521-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-521" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-521"
And I set field "num4" to "521-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "521" in row 1
And I set field "kenn" to "FALL-521"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "521-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-521" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-521"
And I set field "num4" to "521-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "521" in row 1
And I set field "preis" to "521" in row 1
And I set field "kenn" to "FALL-521"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+521-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-521" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "521-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-521" in row 1
And I set field "mge" to "521" in row 1
And I set field "preis" to "521" in row 1
And I set field "kenn" to "FALL-521"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "521-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-521" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-521"
And I set field "num3" to "521-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "521" in row 1
And I set field "kenn" to "FALL-521"
And I save the current editor

# Materialkostenverbuchung
Given I open an editor "mkv-521" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-521"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
# And I set field "labudat" to "01.01.95"
And I press button "kosvor"
#And I press button "kosbu"
And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "521-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-521" from table "(Sales):(PackingSlip)" with command "RETURN" for record "521-LS"
And I set field "num3" to "521-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-521 Ruecklieferschein"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+521-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+521-RLS"
And I set field "num3" to "521-SRLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+521-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-522
Scenario: FALL-522 Storno Rücklieferung VK Rechnung mit Lagerbewegung

# Konto 522-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0522FALL"
And I set field "such" to "FALL-522"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0522FALL"
And I set field "such" to "FALL-522"
And I set field "bestausekso" to "FALL-522"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "522-FALL"
And I set field "num2" to "522-FALL"
And I set field "such" to "FALL-522"
And I set field "namebspr" to "FALL-522"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-522"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-522" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "522-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-522" in row 1
And I set field "mge" to "522" in row 1
And I set field "preis" to "522" in row 1
And I set field "kenn" to "FALL-522"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "522-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-522" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-522"
And I set field "num4" to "522-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "522" in row 1
And I set field "kenn" to "FALL-522"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "522-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-522" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-522"
And I set field "num4" to "522-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "522" in row 1
And I set field "preis" to "522" in row 1
And I set field "kenn" to "FALL-522"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+522-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-522" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "522-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-522" in row 1
And I set field "mge" to "522" in row 1
And I set field "preis" to "522" in row 1
And I set field "kenn" to "FALL-522"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "522-AU"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-522" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-522"
And I set field "num3" to "522-RE"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "522" in row 1
And I set field "kenn" to "FALL-522"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+522-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-522" from table "(Sales):(Invoice)" with command "RETURN" for record "+522-RE"
And I set field "num3" to "522-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-522 Ruecklieferschein"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "522-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "522-RLS"
And I set field "num3" to "522-SRLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+522-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-526
Scenario: FALL-526 Storno Rücklieferung VK Umlagerungen

# Konto 526-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0526FALL"
And I set field "such" to "FALL-526"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0526FALL"
And I set field "such" to "FALL-526"
And I set field "bestausekso" to "FALL-526"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "526-FALL"
And I set field "num2" to "526-FALL"
And I set field "such" to "FALL-526"
And I set field "namebspr" to "FALL-526"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-526"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-526" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "526-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-526" in row 1
And I set field "mge" to "526" in row 1
And I set field "preis" to "526" in row 1
And I set field "kenn" to "FALL-526"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "526-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-526" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-526"
And I set field "num4" to "526-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "526" in row 1
And I set field "kenn" to "FALL-526"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "526-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-526" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-526"
And I set field "num4" to "526-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "526" in row 1
And I set field "preis" to "526" in row 1
And I set field "kenn" to "FALL-526"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+526-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-526" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "526-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-526" in row 1
And I set field "mge" to "526" in row 1
And I set field "preis" to "526" in row 1
And I set field "kenn" to "FALL-526"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "526-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-526" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-526"
And I set field "num3" to "526-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "526" in row 1
And I set field "kenn" to "FALL-526"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+526-UMLS"
And I close the current editor

# Ruecklieferung von Umlagerungslieferscheinen nicht mehr erlaubt.
Given opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-526" throws the exception "1525"

#####################################################################################################################################

@FALL-527
Scenario: FALL-527 Storno Rücklieferung VK Lieferschein mit Materialzuordnung
# Platz		Zugang	LS		RLS		Storno	Summe Platz
# F1		230		230		-30		30		0
# F2		130		30		-30		30		100
# F3		130		30		-30		30		100
# F4		37		37		-41		41		0
#
# Summe		527		327		-131	131		200


# Konto 527-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0527FALL"
And I set field "such" to "FALL-527"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0527FALL"
And I set field "such" to "FALL-527"
And I set field "bestausekso" to "FALL-527"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "527-FALL"
And I set field "num2" to "527-FALL"
And I set field "such" to "FALL-527"
And I set field "namebspr" to "FALL-527"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-527"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-527" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "527-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-527" in row 1
And I set field "mge" to "527" in row 1
And I set field "preis" to "527" in row 1
And I set field "kenn" to "FALL-527"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "527-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-527" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-527"
And I set field "num4" to "527-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "527" in row 1
And I set field "kenn" to "FALL-527"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "230" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "130" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "130" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "37" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-527"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "527-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-527" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-527"
And I set field "num4" to "527-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "527" in row 1
And I set field "preis" to "527" in row 1
And I set field "kenn" to "FALL-527"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+527-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-527" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "527-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-527" in row 1
And I set field "mge" to "527" in row 1
And I set field "preis" to "527" in row 1
And I set field "kenn" to "FALL-527"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "527-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-527" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-527"
And I set field "num3" to "527-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "527" in row 1
And I set field "kenn" to "FALL-527"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "230" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "37" in row 4
And I save the current editor
And I switch the current editor to editor "lieferschein-527"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "527-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-527" from table "(Sales):(PackingSlip)" with command "RETURN" for record "527-LS"
And I set field "num3" to "527-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-131" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-527 Ruecklieferschein"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "-30" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F2" in row 2
And I set field "zuomge" to "-30" in row 2
And I create a new row at the end of the table
And I set field "lpsuch" to "F3" in row 3
And I set field "zuomge" to "-30" in row 3
And I create a new row at the end of the table
And I set field "lpsuch" to "F4" in row 4
And I set field "zuomge" to "-41" in row 4
And I save the current editor
And I switch the current editor to editor "rls-527"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+527-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+527-RLS"
And I set field "num3" to "527-SRLS"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+527-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-541
Scenario: FALL-541 Storno Rücklieferung VK Lieferschein Durchgang SET-Artikel, mit indiv. Set-Liste

# Konto 541-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0541FALL"
And I set field "such" to "FALL-541"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0541FALL"
And I set field "such" to "FALL-541"
And I set field "bestausekso" to "FALL-541"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "541-FALL-A"
And I set field "num2" to "541-FALL-A"
And I set field "such" to "FALL-541A"
And I set field "namebspr" to "FALL-541A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-541"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "541-FALL-B"
And I set field "num2" to "541-FALL-B"
And I set field "such" to "FALL-541B"
And I set field "namebspr" to "FALL-541B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-541"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "541-FALL-C"
And I set field "num2" to "541-FALL-C"
And I set field "such" to "FALL-541C"
And I set field "namebspr" to "FALL-541C"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-541"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "541-FALL-VK"
And I set field "num2" to "541-FALL-VK"
And I set field "such" to "FALL-541VK"
And I set field "namebspr" to "FALL-541VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-541"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-541A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-541B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-541" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "541-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-541A" in row 1
And I set field "mge" to "541" in row 1
And I set field "preis" to "541" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-541B" in row 2
And I set field "mge" to "541" in row 2
And I set field "preis" to "541" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-541C" in row 3
And I set field "mge" to "541" in row 3
And I set field "preis" to "541" in row 3
And I set field "kenn" to "FALL-541"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "541-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-541" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-541"
And I set field "num4" to "541-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "541" in row 1
And I set field "mge" to "541" in row 2
And I set field "mge" to "541" in row 3
And I set field "kenn" to "FALL-541"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "541-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-541" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-541"
And I set field "num4" to "541-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "541" in row 1
And I set field "preis" to "541" in row 1
And I set field "mge" to "541" in row 2
And I set field "preis" to "541" in row 2
And I set field "mge" to "541" in row 3
And I set field "preis" to "541" in row 3
And I set field "kenn" to "FALL-541"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+541-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-541" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "541-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-541VK" in row 1
And I set field "mge" to "541" in row 1
And I set field "preis" to "541" in row 1
And I set field "kenn" to "FALL-541"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-541C" in row 3
And I set field "elanzahl" to "0,5" in row 3
And I save the current editor
And I switch the current editor to editor "auftrag-541"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "541-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-541" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-541"
And I set field "num3" to "541-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "541" in row 1
And I set field "kenn" to "FALL-541"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "541-LS"
And I close the current editor

# Rücklieferung Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "RETURN" for record "541-LS"
And I set field "num3" to "541-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-541 Ruecklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+541-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+541-RLS"
And I set field "num3" to "541-SRLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+541-SRLS"
And I close the current editor


#####################################################################################################################################

@FALL-542
Scenario: FALL-542 Storno Rücklieferung VK Lieferschein SET in SET

# Konto 542-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0542FALL"
And I set field "such" to "FALL-542"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0542FALL"
And I set field "such" to "FALL-542"
And I set field "bestausekso" to "FALL-542"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "542-FALL-A"
And I set field "num2" to "542-FALL-A"
And I set field "such" to "FALL-542A"
And I set field "namebspr" to "FALL-542A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-542"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "542-FALL-B"
And I set field "num2" to "542-FALL-B"
And I set field "such" to "FALL-542B"
And I set field "namebspr" to "FALL-542B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-542"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "542-FALL-C"
And I set field "num2" to "542-FALL-C"
And I set field "such" to "FALL-542C"
And I set field "namebspr" to "FALL-542C"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-542"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "542-FALL-D"
And I set field "num2" to "542-FALL-D"
And I set field "such" to "FALL-542D"
And I set field "namebspr" to "FALL-542D"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-542"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "542-FALL-E"
And I set field "num2" to "542-FALL-E"
And I set field "such" to "FALL-542E"
And I set field "namebspr" to "FALL-542E"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-542"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "542-FALL-SE"
And I set field "num2" to "542-FALL-SE"
And I set field "such" to "FALL-542SE"
And I set field "namebspr" to "FALL-542SET"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-542"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-542A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-542B" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "542-FALL-VK"
And I set field "num2" to "542-FALL-VK"
And I set field "such" to "FALL-542VK"
And I set field "namebspr" to "FALL-542VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "eart" to "(UsingBOM)"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-542"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-542C" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-542D" in row 2
And I set field "anzahl" to "1" in row 2
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-542" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "542-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-542A" in row 1
And I set field "mge" to "542" in row 1
And I set field "preis" to "542" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-542B" in row 2
And I set field "mge" to "542" in row 2
And I set field "preis" to "542" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-542C" in row 3
And I set field "mge" to "542" in row 3
And I set field "preis" to "542" in row 3
And I create a new row at the end of the table
And I set field "artex" to "FALL-542D" in row 4
And I set field "mge" to "542" in row 4
And I set field "preis" to "542" in row 4
And I create a new row at the end of the table
And I set field "artex" to "FALL-542E" in row 5
And I set field "mge" to "542" in row 5
And I set field "preis" to "542" in row 5
And I set field "kenn" to "FALL-542"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "542-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-542" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-542"
And I set field "num4" to "542-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "542" in row 1
And I set field "mge" to "542" in row 2
And I set field "mge" to "542" in row 3
And I set field "mge" to "542" in row 4
And I set field "mge" to "542" in row 5
And I set field "kenn" to "FALL-542"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "542-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-542" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-542"
And I set field "num4" to "542-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "542" in row 1
And I set field "preis" to "542" in row 1
And I set field "mge" to "542" in row 2
And I set field "preis" to "542" in row 2
And I set field "mge" to "542" in row 3
And I set field "preis" to "542" in row 3
And I set field "mge" to "542" in row 4
And I set field "preis" to "542" in row 4
And I set field "mge" to "542" in row 5
And I set field "preis" to "542" in row 5
And I set field "kenn" to "FALL-542"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+542-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-542" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "542-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-542VK" in row 1
And I set field "mge" to "542" in row 1
And I set field "preis" to "542" in row 1
And I set field "kenn" to "FALL-542"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-542SE" in row 3
# Set wird jetzt aufgeloest
And I respond with answer "Ja" to the dialog with id "1537"
And I set field "elanzahl" to "0,7" in row 3
And I save the current editor
And I switch the current editor to editor "auftrag-542"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "542-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-542" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-542"
And I set field "num3" to "542-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "542" in row 1
And I set field "kenn" to "FALL-542"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "542-LS"
And I close the current editor

# Rücklieferung Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "RETURN" for record "542-LS"
And I set field "num3" to "542-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-542 Ruecklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+542-RLS"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+542-RLS"
And I set field "num3" to "542-SRLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+542-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-720
Scenario: FALL-720 SET + Koppelprodukt	VK	Lieferschein

# Konto 720-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0720FALL"
And I set field "such" to "FALL-720"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0720FALL"
And I set field "such" to "FALL-720"
And I set field "bestausekso" to "FALL-720"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "720-FALL-A"
And I set field "num2" to "720-FALL-A"
And I set field "such" to "FALL-720A"
And I set field "namebspr" to "FALL-720A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-720"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "720-FALL-B"
And I set field "num2" to "720-FALL-B"
And I set field "such" to "FALL-720B"
And I set field "namebspr" to "FALL-720B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-720"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "720-FALL-KP"
And I set field "num2" to "720-FALL-KP"
And I set field "such" to "FALL-720KP"
And I set field "namebspr" to "FALL-720KP Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-720"
And I set field "erlgrp" to "66"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "720"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "720-FALL-VK"
And I set field "num2" to "720-FALL-VK"
And I set field "such" to "FALL-720VK"
And I set field "namebspr" to "FALL-720VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "eart" to "(UsingBOM)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-720"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-720A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-720B" in row 2
And I set field "anzahl" to "1" in row 2
# Hier jetzt das Koppelprodukt
And I create a new row at the end of the table
And I set field "elex" to "FALL-720KP" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "kompeig" to "Koppel" in row 3
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-720" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "720-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-720A" in row 1
And I set field "mge" to "720" in row 1
And I set field "preis" to "720" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-720B" in row 2
And I set field "mge" to "720" in row 2
And I set field "preis" to "720" in row 2
And I set field "kenn" to "FALL-720"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "720-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-720" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-720"
And I set field "num4" to "720-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "720" in row 1
And I set field "mge" to "720" in row 2
And I set field "kenn" to "FALL-720"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "720-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-720" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-720"
And I set field "num4" to "720-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "720" in row 1
And I set field "preis" to "720" in row 1
And I set field "mge" to "720" in row 2
And I set field "preis" to "720" in row 2
And I set field "kenn" to "FALL-720"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+720-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-720" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "720-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-720VK" in row 1
And I set field "mge" to "720" in row 1
And I set field "preis" to "720" in row 1
And I set field "kenn" to "FALL-720"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "720-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-720" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-720"
And I set field "num3" to "720-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "720" in row 1
And I set field "kenn" to "FALL-720"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "720-LS"
And I close the current editor

#####################################################################################################################################

@FALL-721
Scenario: FALL-721 SET + Koppelprodukt	VK	Rücklieferschein

# Konto 721-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0721FALL"
And I set field "such" to "FALL-721"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0721FALL"
And I set field "such" to "FALL-721"
And I set field "bestausekso" to "FALL-721"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "721-FALL-A"
And I set field "num2" to "721-FALL-A"
And I set field "such" to "FALL-721A"
And I set field "namebspr" to "FALL-721A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-721"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "721-FALL-B"
And I set field "num2" to "721-FALL-B"
And I set field "such" to "FALL-721B"
And I set field "namebspr" to "FALL-721B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-721"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "721-FALL-KP"
And I set field "num2" to "721-FALL-KP"
And I set field "such" to "FALL-721KP"
And I set field "namebspr" to "FALL-721KP Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-721"
And I set field "erlgrp" to "66"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "721"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "721-FALL-VK"
And I set field "num2" to "721-FALL-VK"
And I set field "such" to "FALL-721VK"
And I set field "namebspr" to "FALL-721VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "eart" to "(UsingBOM)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-721"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-721A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-721B" in row 2
And I set field "anzahl" to "1" in row 2
# Hier jetzt das Koppelprodukt
And I create a new row at the end of the table
And I set field "elex" to "FALL-721KP" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "kompeig" to "Koppel" in row 3
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-721" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "721-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-721A" in row 1
And I set field "mge" to "721" in row 1
And I set field "preis" to "721" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-721B" in row 2
And I set field "mge" to "721" in row 2
And I set field "preis" to "721" in row 2
And I set field "kenn" to "FALL-721"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "721-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-721" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-721"
And I set field "num4" to "721-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "721" in row 1
And I set field "mge" to "721" in row 2
And I set field "kenn" to "FALL-721"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "721-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-721" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-721"
And I set field "num4" to "721-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "721" in row 1
And I set field "preis" to "721" in row 1
And I set field "mge" to "721" in row 2
And I set field "preis" to "721" in row 2
And I set field "kenn" to "FALL-721"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+721-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-721" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "721-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-721VK" in row 1
And I set field "mge" to "721" in row 1
And I set field "preis" to "721" in row 1
And I set field "kenn" to "FALL-721"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "721-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-721" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-721"
And I set field "num3" to "721-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "721" in row 1
And I set field "kenn" to "FALL-721"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "721-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-721" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-721"
And I set field "num3" to "721-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-721 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+721-RLS"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

#####################################################################################################################################

@FALL-722
Scenario: FALL-722 SET + Koppelprodukt	VK	Storno-Lieferschein

# Konto 722-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0722FALL"
And I set field "such" to "FALL-722"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0722FALL"
And I set field "such" to "FALL-722"
And I set field "bestausekso" to "FALL-722"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "722-FALL-A"
And I set field "num2" to "722-FALL-A"
And I set field "such" to "FALL-722A"
And I set field "namebspr" to "FALL-722A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-722"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "722-FALL-B"
And I set field "num2" to "722-FALL-B"
And I set field "such" to "FALL-722B"
And I set field "namebspr" to "FALL-722B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-722"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "722-FALL-KP"
And I set field "num2" to "722-FALL-KP"
And I set field "such" to "FALL-722KP"
And I set field "namebspr" to "FALL-722KP Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-722"
And I set field "erlgrp" to "66"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "722"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "722-FALL-VK"
And I set field "num2" to "722-FALL-VK"
And I set field "such" to "FALL-722VK"
And I set field "namebspr" to "FALL-722VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "eart" to "(UsingBOM)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-722"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-722A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-722B" in row 2
And I set field "anzahl" to "1" in row 2
# Hier jetzt das Koppelprodukt
And I create a new row at the end of the table
And I set field "elex" to "FALL-722KP" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "kompeig" to "Koppel" in row 3
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-722" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "722-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-722A" in row 1
And I set field "mge" to "722" in row 1
And I set field "preis" to "722" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-722B" in row 2
And I set field "mge" to "722" in row 2
And I set field "preis" to "722" in row 2
And I set field "kenn" to "FALL-722"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "722-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-722" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-722"
And I set field "num4" to "722-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "722" in row 1
And I set field "mge" to "722" in row 2
And I set field "kenn" to "FALL-722"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "722-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-722" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-722"
And I set field "num4" to "722-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "722" in row 1
And I set field "preis" to "722" in row 1
And I set field "mge" to "722" in row 2
And I set field "preis" to "722" in row 2
And I set field "kenn" to "FALL-722"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+722-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-722" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "722-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-722VK" in row 1
And I set field "mge" to "722" in row 1
And I set field "preis" to "722" in row 1
And I set field "kenn" to "FALL-722"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "722-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-722" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-722"
And I set field "num3" to "722-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "722" in row 1
And I set field "kenn" to "FALL-722"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "722-LS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-722"
And I set field "num3" to "722-STLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+722-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-723
Scenario: FALL-723 SET + Koppelprodukt	VK	Storno-Rücklieferschein

# Konto 723-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0723FALL"
And I set field "such" to "FALL-723"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0723FALL"
And I set field "such" to "FALL-723"
And I set field "bestausekso" to "FALL-723"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "723-FALL-A"
And I set field "num2" to "723-FALL-A"
And I set field "such" to "FALL-723A"
And I set field "namebspr" to "FALL-723A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-723"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "723-FALL-B"
And I set field "num2" to "723-FALL-B"
And I set field "such" to "FALL-723B"
And I set field "namebspr" to "FALL-723B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-723"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "723-FALL-KP"
And I set field "num2" to "723-FALL-KP"
And I set field "such" to "FALL-723KP"
And I set field "namebspr" to "FALL-723KP Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-723"
And I set field "erlgrp" to "66"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "723"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "723-FALL-VK"
And I set field "num2" to "723-FALL-VK"
And I set field "such" to "FALL-723VK"
And I set field "namebspr" to "FALL-723VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "eart" to "(UsingBOM)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-723"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-723A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-723B" in row 2
And I set field "anzahl" to "1" in row 2
# Hier jetzt das Koppelprodukt
And I create a new row at the end of the table
And I set field "elex" to "FALL-723KP" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "kompeig" to "Koppel" in row 3
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-723" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "723-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-723A" in row 1
And I set field "mge" to "723" in row 1
And I set field "preis" to "723" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-723B" in row 2
And I set field "mge" to "723" in row 2
And I set field "preis" to "723" in row 2
And I set field "kenn" to "FALL-723"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "723-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-723" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-723"
And I set field "num4" to "723-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "723" in row 1
And I set field "mge" to "723" in row 2
And I set field "kenn" to "FALL-723"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "723-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-723" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-723"
And I set field "num4" to "723-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "723" in row 1
And I set field "preis" to "723" in row 1
And I set field "mge" to "723" in row 2
And I set field "preis" to "723" in row 2
And I set field "kenn" to "FALL-723"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+723-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-723" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "723-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-723VK" in row 1
And I set field "mge" to "723" in row 1
And I set field "preis" to "723" in row 1
And I set field "kenn" to "FALL-723"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "723-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-723" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-723"
And I set field "num3" to "723-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "723" in row 1
And I set field "kenn" to "FALL-723"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "723-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-723" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-723"
And I set field "num3" to "723-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-723 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+723-RLS"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Storno Rücklieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-723"
And I set field "num3" to "723-SRLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+723-SRLS"
And I close the current editor

#####################################################################################################################################

@FALL-724
Scenario: FALL-724 SET + Koppelprodukt	VK	Rechnung mit Lagerbewegung

# Konto 724-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0724FALL"
And I set field "such" to "FALL-724"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0724FALL"
And I set field "such" to "FALL-724"
And I set field "bestausekso" to "FALL-724"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "724-FALL-A"
And I set field "num2" to "724-FALL-A"
And I set field "such" to "FALL-724A"
And I set field "namebspr" to "FALL-724A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-724"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "724-FALL-B"
And I set field "num2" to "724-FALL-B"
And I set field "such" to "FALL-724B"
And I set field "namebspr" to "FALL-724B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-724"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "724-FALL-KP"
And I set field "num2" to "724-FALL-KP"
And I set field "such" to "FALL-724KP"
And I set field "namebspr" to "FALL-724KP Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-724"
And I set field "erlgrp" to "66"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "724"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "724-FALL-VK"
And I set field "num2" to "724-FALL-VK"
And I set field "such" to "FALL-724VK"
And I set field "namebspr" to "FALL-724VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "eart" to "(UsingBOM)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-724"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-724A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-724B" in row 2
And I set field "anzahl" to "1" in row 2
# Hier jetzt das Koppelprodukt
And I create a new row at the end of the table
And I set field "elex" to "FALL-724KP" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "kompeig" to "Koppel" in row 3
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-724" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "724-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-724A" in row 1
And I set field "mge" to "724" in row 1
And I set field "preis" to "724" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-724B" in row 2
And I set field "mge" to "724" in row 2
And I set field "preis" to "724" in row 2
And I set field "kenn" to "FALL-724"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "724-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-724" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-724"
And I set field "num4" to "724-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "724" in row 1
And I set field "mge" to "724" in row 2
And I set field "kenn" to "FALL-724"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "724-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-724" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-724"
And I set field "num4" to "724-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "724" in row 1
And I set field "preis" to "724" in row 1
And I set field "mge" to "724" in row 2
And I set field "preis" to "724" in row 2
And I set field "kenn" to "FALL-724"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+724-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-724" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "724-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-724VK" in row 1
And I set field "mge" to "724" in row 1
And I set field "preis" to "724" in row 1
And I set field "kenn" to "FALL-724"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "724-AU"
And I close the current editor

# Rechnung zu Auftrag anlegen
Given I open an editor "Rechnung-724" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-724"
And I set field "num3" to "724-RE"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "724" in row 1
And I set field "kenn" to "FALL-724"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+724-RE"
And I close the current editor

#####################################################################################################################################

@FALL-725
Scenario: FALL-725 SET + Koppelprodukt	VK	Storno Rechnung mit Lagerbewegung

# Konto 725-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0725FALL"
And I set field "such" to "FALL-725"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0725FALL"
And I set field "such" to "FALL-725"
And I set field "bestausekso" to "FALL-725"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "725-FALL-A"
And I set field "num2" to "725-FALL-A"
And I set field "such" to "FALL-725A"
And I set field "namebspr" to "FALL-725A"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-725"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "725-FALL-B"
And I set field "num2" to "725-FALL-B"
And I set field "such" to "FALL-725B"
And I set field "namebspr" to "FALL-725B"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-725"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "725-FALL-KP"
And I set field "num2" to "725-FALL-KP"
And I set field "such" to "FALL-725KP"
And I set field "namebspr" to "FALL-725KP Koppelprodukt"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-725"
And I set field "erlgrp" to "66"
# Bewertungsverfahren hier auf "Planpreis
And I set field "ekbewverf" to "3"
And I set field "planpr1" to "725"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "725-FALL-VK"
And I set field "num2" to "725-FALL-VK"
And I set field "such" to "FALL-725VK"
And I set field "namebspr" to "FALL-725VK"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "eart" to "(UsingBOM)"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
# And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-725"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I set field "elex" to "FALL-725A" in row 1
And I set field "anzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "FALL-725B" in row 2
And I set field "anzahl" to "1" in row 2
# Hier jetzt das Koppelprodukt
And I create a new row at the end of the table
And I set field "elex" to "FALL-725KP" in row 3
And I set field "anzahl" to "1" in row 3
And I set field "kompeig" to "Koppel" in row 3
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-725" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "725-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-725A" in row 1
And I set field "mge" to "725" in row 1
And I set field "preis" to "725" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-725B" in row 2
And I set field "mge" to "725" in row 2
And I set field "preis" to "725" in row 2
And I set field "kenn" to "FALL-725"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "725-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-725" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-725"
And I set field "num4" to "725-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "725" in row 1
And I set field "mge" to "725" in row 2
And I set field "kenn" to "FALL-725"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "725-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-725" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-725"
And I set field "num4" to "725-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "725" in row 1
And I set field "preis" to "725" in row 1
And I set field "mge" to "725" in row 2
And I set field "preis" to "725" in row 2
And I set field "kenn" to "FALL-725"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+725-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-725" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "725-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-725VK" in row 1
And I set field "mge" to "725" in row 1
And I set field "preis" to "725" in row 1
And I set field "kenn" to "FALL-725"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "725-AU"
And I close the current editor

# Rechnung zu Auftrag anlegen
Given I open an editor "Rechnung-725" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-725"
And I set field "num3" to "725-RE"
And I set field "ueb" to "ja"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "725" in row 1
And I set field "kenn" to "FALL-725"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+725-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-725" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+725-RE"
And I set field "num3" to "725-SRE"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+725-SRE"
And I close the current editor

#####################################################################################################################################

@FALL-759
Scenario:  FALL-759 EK-VK Kommissionslieferschein Verkauf von Lieferantenkonsignation

# Konto 759-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0759FALL"
And I set field "such" to "FALL-759"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0759FALL"
And I set field "such" to "FALL-759"
And I set field "bestausekso" to "FALL-759"
And I save the current editor


# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "759-FALL"
And I set field "num2" to "759-FALL"
And I set field "such" to "FALL-759"
And I set field "namebspr" to "FALL-759"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "KONSILIE"
And I set field "wgruppe" to "FALL-759"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-759" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "KONSILIE"
And I set field "num4" to "759-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-759" in row 1
And I set field "mge" to "759" in row 1
And I set field "preis" to "759" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-759"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "759-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-759" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-759"
And I set field "num4" to "759-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "759" in row 1
And I set field "rerelev" to "NEIN" in row 1
And I set field "kenn" to "FALL-759"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+759-LS"
And I close the current editor

# VK Umlagerung Lieferschein anlegen
Given I open an editor "lieferschein-759" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "759-VULS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I create a new row at the end of the table
And I set field "artex" to "FALL-759" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "mge" to "353" in row 1
And I set field "kenn" to "FALL-759"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+759-VULS"
And I close the current editor

#####################################################################################################################################

@FALL-769
Scenario:  FALL-769 Storno EK-VK Kommissionslieferschein Verkauf von Lieferantenkonsignation

# Konto 769-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0769FALL"
And I set field "such" to "FALL-769"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0769FALL"
And I set field "such" to "FALL-769"
And I set field "bestausekso" to "FALL-769"
And I save the current editor


# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "769-FALL"
And I set field "num2" to "769-FALL"
And I set field "such" to "FALL-769"
And I set field "namebspr" to "FALL-769"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "KONSILIE"
And I set field "wgruppe" to "FALL-769"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-769" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "KONSILIE"
And I set field "num4" to "769-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-769" in row 1
And I set field "mge" to "769" in row 1
And I set field "preis" to "769" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "kenn" to "FALL-769"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "769-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-769" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-769"
And I set field "num4" to "769-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "769" in row 1
And I set field "rerelev" to "NEIN" in row 1
And I set field "kenn" to "FALL-769"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+769-LS"
And I close the current editor

# VK Umlagerung Lieferschein anlegen
Given I open an editor "lieferschein-769" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "769-VULS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I create a new row at the end of the table
And I set field "artex" to "FALL-769" in row 1
And I set field "platz" to "LKONSI" in row 1
And I set field "mge" to "353" in row 1
And I set field "kenn" to "FALL-769"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+769-VULS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+769-VULS"
And I set field "num3" to "769-STLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+769-STLS"
And I close the current editor

#####################################################################################################################################

@FALL-771
Scenario: FALL-771 Neu VK Kunden Konsi Umlagerung

# Konto 771-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0771FALL"
And I set field "such" to "FALL-771"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0771FALL"
And I set field "such" to "FALL-771"
And I set field "bestausekso" to "FALL-771"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "771-FALL"
And I set field "num2" to "771-FALL"
And I set field "such" to "FALL-771"
And I set field "namebspr" to "FALL-771"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-771"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-771" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "771-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-771" in row 1
And I set field "mge" to "771" in row 1
And I set field "preis" to "771" in row 1
And I set field "kenn" to "FALL-771"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "771-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-771" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-771"
And I set field "num4" to "771-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "771" in row 1
And I set field "kenn" to "FALL-771"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "771-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-771" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-771"
And I set field "num4" to "771-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "771" in row 1
And I set field "preis" to "771" in row 1
And I set field "kenn" to "FALL-771"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+771-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-771" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "771-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-771" in row 1
And I set field "mge" to "771" in row 1
And I set field "preis" to "771" in row 1
And I set field "kenn" to "FALL-771"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "771-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-771" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-771"
And I set field "num3" to "771-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "771" in row 1
And I set field "kenn" to "FALL-771"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+771-UMLS"
And I close the current editor

#####################################################################################################################################

@FALL-772
Scenario: FALL-772 Neu VK Kunden Konsi Entnahme

# Konto 772-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0772FALL"
And I set field "such" to "FALL-772"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0772FALL"
And I set field "such" to "FALL-772"
And I set field "bestausekso" to "FALL-772"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "772-FALL"
And I set field "num2" to "772-FALL"
And I set field "such" to "FALL-772"
And I set field "namebspr" to "FALL-772"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-772"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-772" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "772-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-772" in row 1
And I set field "mge" to "772" in row 1
And I set field "preis" to "772" in row 1
And I set field "kenn" to "FALL-772"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "772-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-772" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-772"
And I set field "num4" to "772-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "772" in row 1
And I set field "kenn" to "FALL-772"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "772-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-772" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-772"
And I set field "num4" to "772-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "772" in row 1
And I set field "preis" to "772" in row 1
And I set field "kenn" to "FALL-772"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+772-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-772" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "772-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-772" in row 1
And I set field "mge" to "772" in row 1
And I set field "preis" to "772" in row 1
And I set field "kenn" to "FALL-772"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "772-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-772" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-772"
And I set field "num3" to "772-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "772" in row 1
And I set field "kenn" to "FALL-772"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+772-UMLS"
And I close the current editor

# VK Entnahme Lieferschein anlegen
Given I open an editor "lieferschein-772" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "772-VELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-772" in row 1
And I set field "platz" to "EXTVKUML" in row 1
And I set field "mge" to "352" in row 1
And I set field "kenn" to "FALL-772"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "772-VELS"
And I close the current editor

#####################################################################################################################################

@FALL-773
Scenario: FALL-773 Neu VK Kunden Konsi Rechnung zu Entnahme

# Konto 773-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0773FALL"
And I set field "such" to "FALL-773"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0773FALL"
And I set field "such" to "FALL-773"
And I set field "bestausekso" to "FALL-773"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "773-FALL"
And I set field "num2" to "773-FALL"
And I set field "such" to "FALL-773"
And I set field "namebspr" to "FALL-773"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-773"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-773" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "773-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-773" in row 1
And I set field "mge" to "773" in row 1
And I set field "preis" to "773" in row 1
And I set field "kenn" to "FALL-773"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "773-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-773" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-773"
And I set field "num4" to "773-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "773" in row 1
And I set field "kenn" to "FALL-773"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "773-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-773" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-773"
And I set field "num4" to "773-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "773" in row 1
And I set field "preis" to "773" in row 1
And I set field "kenn" to "FALL-773"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+773-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-773" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "773-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-773" in row 1
And I set field "mge" to "773" in row 1
And I set field "preis" to "773" in row 1
And I set field "kenn" to "FALL-773"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "773-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-773" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-773"
And I set field "num3" to "773-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "773" in row 1
And I set field "kenn" to "FALL-773"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+773-UMLS"
And I close the current editor

# VK Entnahme Lieferschein anlegen
Given I open an editor "lieferschein-773" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "773-VELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-773" in row 1
And I set field "platz" to "EXTVKUML" in row 1
And I set field "mge" to "353" in row 1
And I set field "kenn" to "FALL-773"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "773-VELS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-773" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-773"
And I set field "num3" to "773-RE"
And I set field "ueb" to "ja"
# And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "353" in row 1
And I set field "preis" to "773" in row 1
And I set field "kenn" to "FALL-773"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+773-RE"
And I close the current editor

#####################################################################################################################################

@FALL-781
Scenario: FALL-781 Storno VK Kunden Konsi Umlagerung

# Konto 781-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0781FALL"
And I set field "such" to "FALL-781"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0781FALL"
And I set field "such" to "FALL-781"
And I set field "bestausekso" to "FALL-781"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "781-FALL"
And I set field "num2" to "781-FALL"
And I set field "such" to "FALL-781"
And I set field "namebspr" to "FALL-781"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-781"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-781" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "781-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-781" in row 1
And I set field "mge" to "781" in row 1
And I set field "preis" to "781" in row 1
And I set field "kenn" to "FALL-781"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "781-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-781" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-781"
And I set field "num4" to "781-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "781" in row 1
And I set field "kenn" to "FALL-781"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "781-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-781" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-781"
And I set field "num4" to "781-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "781" in row 1
And I set field "preis" to "781" in row 1
And I set field "kenn" to "FALL-781"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+781-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-781" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "781-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-781" in row 1
And I set field "mge" to "781" in row 1
And I set field "preis" to "781" in row 1
And I set field "kenn" to "FALL-781"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "781-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-781" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-781"
And I set field "num3" to "781-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "781" in row 1
And I set field "kenn" to "FALL-781"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+781-UMLS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+781-UMLS"
And I set field "num3" to "781-SULS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+781-SULS"
And I close the current editor

#####################################################################################################################################

@FALL-782
Scenario: FALL-782 Storno VK Kunden Konsi Entnahme

# Konto 782-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0782FALL"
And I set field "such" to "FALL-782"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0782FALL"
And I set field "such" to "FALL-782"
And I set field "bestausekso" to "FALL-782"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "782-FALL"
And I set field "num2" to "782-FALL"
And I set field "such" to "FALL-782"
And I set field "namebspr" to "FALL-782"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-782"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-782" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "782-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-782" in row 1
And I set field "mge" to "782" in row 1
And I set field "preis" to "782" in row 1
And I set field "kenn" to "FALL-782"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "782-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-782" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-782"
And I set field "num4" to "782-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "782" in row 1
And I set field "kenn" to "FALL-782"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "782-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-782" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-782"
And I set field "num4" to "782-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "782" in row 1
And I set field "preis" to "782" in row 1
And I set field "kenn" to "FALL-782"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+782-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-782" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "782-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-782" in row 1
And I set field "mge" to "782" in row 1
And I set field "preis" to "782" in row 1
And I set field "kenn" to "FALL-782"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "782-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-782" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-782"
And I set field "num3" to "782-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "782" in row 1
And I set field "kenn" to "FALL-782"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+782-UMLS"
And I close the current editor

# VK Entnahme Lieferschein anlegen
Given I open an editor "lieferschein-782" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "782-VELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-782" in row 1
And I set field "platz" to "EXTVKUML" in row 1
And I set field "mge" to "352" in row 1
And I set field "kenn" to "FALL-782"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "782-VELS"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "782-VELS"
And I set field "num3" to "782-SELS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+782-SELS"
And I close the current editor

#####################################################################################################################################

@FALL-783
Scenario: FALL-783 Storno VK Kunden Konsi Rechnung zu Entnahme

# Konto 783-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0783FALL"
And I set field "such" to "FALL-783"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0783FALL"
And I set field "such" to "FALL-783"
And I set field "bestausekso" to "FALL-783"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "783-FALL"
And I set field "num2" to "783-FALL"
And I set field "such" to "FALL-783"
And I set field "namebspr" to "FALL-783"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-783"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-783" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "783-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-783" in row 1
And I set field "mge" to "783" in row 1
And I set field "preis" to "783" in row 1
And I set field "kenn" to "FALL-783"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "783-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-783" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-783"
And I set field "num4" to "783-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "783" in row 1
And I set field "kenn" to "FALL-783"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "783-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-783" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-783"
And I set field "num4" to "783-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "783" in row 1
And I set field "preis" to "783" in row 1
And I set field "kenn" to "FALL-783"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+783-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-783" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "783-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-783" in row 1
And I set field "mge" to "783" in row 1
And I set field "preis" to "783" in row 1
And I set field "kenn" to "FALL-783"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "783-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-783" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-783"
And I set field "num3" to "783-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "783" in row 1
And I set field "kenn" to "FALL-783"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+783-UMLS"
And I close the current editor

# VK Entnahme Lieferschein anlegen
Given I open an editor "lieferschein-783" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "783-VELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-783" in row 1
And I set field "platz" to "EXTVKUML" in row 1
And I set field "mge" to "353" in row 1
And I set field "kenn" to "FALL-783"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "783-VELS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-783" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-783"
And I set field "num3" to "783-RE"
And I set field "ueb" to "ja"
# And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "353" in row 1
And I set field "preis" to "783" in row 1
And I set field "kenn" to "FALL-783"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+783-RE"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-783" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+783-RE"
And I set field "num3" to "783-SRE"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+783-SRE"
And I close the current editor

#####################################################################################################################################

@FALL-791
Scenario: FALL-791 Rücklieferung VK Kunden Konsi Umlagerung

# Konto 791-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0791FALL"
And I set field "such" to "FALL-791"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0791FALL"
And I set field "such" to "FALL-791"
And I set field "bestausekso" to "FALL-791"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "791-FALL"
And I set field "num2" to "791-FALL"
And I set field "such" to "FALL-791"
And I set field "namebspr" to "FALL-791"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-791"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-791" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "791-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-791" in row 1
And I set field "mge" to "791" in row 1
And I set field "preis" to "791" in row 1
And I set field "kenn" to "FALL-791"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "791-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-791" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-791"
And I set field "num4" to "791-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "791" in row 1
And I set field "kenn" to "FALL-791"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "791-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-791" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-791"
And I set field "num4" to "791-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "791" in row 1
And I set field "preis" to "791" in row 1
And I set field "kenn" to "FALL-791"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+791-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-791" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "791-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-791" in row 1
And I set field "mge" to "791" in row 1
And I set field "preis" to "791" in row 1
And I set field "kenn" to "FALL-791"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "791-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-791" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-791"
And I set field "num3" to "791-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "791" in row 1
And I set field "kenn" to "FALL-791"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+791-UMLS"
And I close the current editor

# Ruecklieferung von Umlagerungslieferscheinen nicht mehr erlaubt.
Given opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-791" throws the exception "1525"

#####################################################################################################################################

@FALL-792
Scenario: FALL-792 Rücklieferung VK Kunden Konsi Entnahme

# Konto 792-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0792FALL"
And I set field "such" to "FALL-792"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0792FALL"
And I set field "such" to "FALL-792"
And I set field "bestausekso" to "FALL-792"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "792-FALL"
And I set field "num2" to "792-FALL"
And I set field "such" to "FALL-792"
And I set field "namebspr" to "FALL-792"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-792"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-792" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "792-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-792" in row 1
And I set field "mge" to "792" in row 1
And I set field "preis" to "792" in row 1
And I set field "kenn" to "FALL-792"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "792-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-792" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-792"
And I set field "num4" to "792-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "792" in row 1
And I set field "kenn" to "FALL-792"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "792-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-792" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-792"
And I set field "num4" to "792-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "792" in row 1
And I set field "preis" to "792" in row 1
And I set field "kenn" to "FALL-792"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+792-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-792" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "792-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-792" in row 1
And I set field "mge" to "792" in row 1
And I set field "preis" to "792" in row 1
And I set field "kenn" to "FALL-792"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "792-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-792" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-792"
And I set field "num3" to "792-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "792" in row 1
And I set field "kenn" to "FALL-792"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+792-UMLS"
And I close the current editor

# VK Entnahme Lieferschein anlegen
Given I open an editor "lieferschein-792" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "792-VELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-792" in row 1
And I set field "platz" to "EXTVKUML" in row 1
And I set field "mge" to "352" in row 1
And I set field "kenn" to "FALL-792"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "792-VELS"
And I close the current editor

# Rücklieferung Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "RETURN" for record "792-VELS"
And I set field "num3" to "792-RELS"
And I set field "ueb" to "ja"
And I set field "mge" to "-206" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+792-RELS"
And I close the current editor

#####################################################################################################################################

@FALL-793
Scenario: FALL-793 Rücklieferung VK Kunden Konsi Rechnung zu Entnahme

# Konto 793-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0793FALL"
And I set field "such" to "FALL-793"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0793FALL"
And I set field "such" to "FALL-793"
And I set field "bestausekso" to "FALL-793"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "793-FALL"
And I set field "num2" to "793-FALL"
And I set field "such" to "FALL-793"
And I set field "namebspr" to "FALL-793"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "fvhle" to "2"
And I set field "fvple" to "2"
And I set field "fehle" to "2"
And I set field "feple" to "2"
And I set field "le" to "kg"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-793"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-793" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "793-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-793" in row 1
And I set field "mge" to "793" in row 1
And I set field "preis" to "793" in row 1
And I set field "kenn" to "FALL-793"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "793-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-793" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-793"
And I set field "num4" to "793-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "793" in row 1
And I set field "kenn" to "FALL-793"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "793-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-793" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-793"
And I set field "num4" to "793-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "793" in row 1
And I set field "preis" to "793" in row 1
And I set field "kenn" to "FALL-793"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+793-RE"
And I close the current editor

# Auftrag anlegen
Given I open an editor "auftrag-793" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "793-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-793" in row 1
And I set field "mge" to "793" in row 1
And I set field "preis" to "793" in row 1
And I set field "kenn" to "FALL-793"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "bestellung-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record "793-AU"
And I close the current editor

# Lieferschein zu Auftrag anlegen
Given I open an editor "lieferschein-793" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-793"
And I set field "num3" to "793-UMLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "umplatz" to "EXTVKUML"
And I set field "mge" to "793" in row 1
And I set field "kenn" to "FALL-793"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+793-UMLS"
And I close the current editor

# VK Entnahme Lieferschein anlegen
Given I open an editor "lieferschein-793" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "793-VELS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-793" in row 1
And I set field "platz" to "EXTVKUML" in row 1
And I set field "mge" to "353" in row 1
And I set field "kenn" to "FALL-793"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "793-VELS"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "Rechnung-793" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-793"
And I set field "num3" to "793-RE"
And I set field "ueb" to "ja"
# And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "mge" to "353" in row 1
And I set field "preis" to "793" in row 1
And I set field "kenn" to "FALL-793"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+793-RE"
And I close the current editor

# Rücklieferung Entnahme
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+793-VELS"
And I set field "num3" to "793-RLS"
And I set field "ueb" to "ja"
And I set field "mge" to "-207" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferung Entnahme
Given I open an editor "Entnahme-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "793-RLS"
And I close the current editor

#####################################################################################################################################

#
# Hier ist dann das ENDE
#
#
