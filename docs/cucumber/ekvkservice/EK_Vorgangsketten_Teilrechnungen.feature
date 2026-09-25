Feature: EK_Vorgangsketten_Teilrechnungen
Background: EK_Vorgangsketten_Teilrechnungen.feature
Given I set the fake date to "02.01.2002"
# Given I enable the flag 198

#####################################################################################################################################
# Bewertungsverfahren 6 Preis des Zugangs und Vorgangspreis
# in allen Artikeln
#####################################################################################################################################

@Stammdaten
Scenario: Stammdaten 
# Lagergruppen, Lagerplätze, Lohnfertiger, Beistellung

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
Given I open an editor "mkv-000" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-000"
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
# 
# Die nachfolgenden Fälle dienen der Dokumentatino von Teilrechnungen + Rücklieferscheinen 
# Fall 1800 - 1960
# LS 100x1€  , RE 50x1€ , RLS 30x1€ , GS 30x1€ , RE 50x1,2€
# 
#####################################################################################################################################

@FALL-1800
Scenario: FALL-1800
# Bestellung	Lieferschein	1. Rechnung 	Rücklieferschein	Gutschrift	2. Rechnung

# Konto 1800FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1800FALL"
And I set field "such" to "FALL-1800"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1800FALL"
And I set field "such" to "FALL-1800"
And I set field "bestausekso" to "FALL-1800"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1800-FALL"
And I set field "num2" to "1800-FALL"
And I set field "such" to "FALL-1800"
And I set field "namebspr" to "FALL-1800"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1800"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1800" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1800-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1800" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1800"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1800-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1800" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1800"
And I set field "num4" to "1800-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1800"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1800" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1800-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1800-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1800"
And I set field "num4" to "1800-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1800"
And I set field "mge" to "80" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1800" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1800-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1800" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1800"
And I set field "num4" to "1800-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1800 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1800" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1800-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-1800" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-1800"
And I set field "num4" to "1800-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1800"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1800-GS"
And I close the current editor

#####################################################################################################################################

@FALL-1810
Scenario: FALL-1810
# Bestellung	Lieferschein	1. Rechnung 	2. Rechnung	Rücklieferschein	Gutschrift

# Konto 1810FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1810FALL"
And I set field "such" to "FALL-1810"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1810FALL"
And I set field "such" to "FALL-1810"
And I set field "bestausekso" to "FALL-1810"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1810-FALL"
And I set field "num2" to "1810-FALL"
And I set field "such" to "FALL-1810"
And I set field "namebspr" to "FALL-1810"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1810"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1810" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1810-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1810" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1810"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1810-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1810" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1810"
And I set field "num4" to "1810-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1810"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1810" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1810-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1810-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1810"
And I set field "num4" to "1810-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1810"
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1810" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1810-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-1810-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1810"
And I set field "num4" to "1810-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1810"
And I set field "mge" to "50" in row 1
And I set field "preis" to "1,2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1810" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1810-RE2"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1810" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1810"
And I set field "num4" to "1810-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1810 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1810" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1810-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-1810" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-1810"
And I set field "num4" to "1810-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
#And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1810"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1810-GS"
And I close the current editor

#####################################################################################################################################

@FALL-1820
Scenario: FALL-1820
# Bestellung	Lieferschein	Rücklieferschein	1. Rechnung 	2. Rechnung	Gutschrift

# Konto 1820FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1820FALL"
And I set field "such" to "FALL-1820"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1820FALL"
And I set field "such" to "FALL-1820"
And I set field "bestausekso" to "FALL-1820"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1820-FALL"
And I set field "num2" to "1820-FALL"
And I set field "such" to "FALL-1820"
And I set field "namebspr" to "FALL-1820"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1820"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1820" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1820-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1820" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1820"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1820-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1820" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1820"
And I set field "num4" to "1820-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1820"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1820" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1820-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1820" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1820"
And I set field "num4" to "1820-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1820 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1820" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1820-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1820-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1820"
And I set field "num4" to "1820-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1820"
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1820" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1820-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-1820-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1820"
And I set field "num4" to "1820-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1820"
Then field "mge" has value "50" in row 1
And I set field "mge" to "20" in row 1
And I set field "preis" to "1,2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1820" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1820-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-1830
Scenario: FALL-1830
# Bestellung	Lieferschein	1.Rechnung	2.Rechnung	Rücklieferschein	Gutschrift

# Konto 1830FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1830FALL"
And I set field "such" to "FALL-1830"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1830FALL"
And I set field "such" to "FALL-1830"
And I set field "bestausekso" to "FALL-1830"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1830-FALL"
And I set field "num2" to "1830-FALL"
And I set field "such" to "FALL-1830"
And I set field "namebspr" to "FALL-1830"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1830"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1830" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1830-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1830" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1830"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1830-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1830" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1830"
And I set field "num4" to "1830-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1830"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1830" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1830-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1830" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1830"
And I set field "num4" to "1830-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1830 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1830" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1830-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1830-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1830"
And I set field "num4" to "1830-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1830"
And I set field "mge" to "50" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1830" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1830-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-1830-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1830"
And I set field "num4" to "1830-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1830"
Then field "mge" has value "50" in row 1
# FIXME RE2 preis muss da und geschützt sein 
And I set field "preis" to "1,2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1830" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1830-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-1840
Scenario: FALL-1840
# Bestellung	Lieferschein	1. Rechnung 	Rücklieferschein	2. Rechnung

# Konto 1840FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1840FALL"
And I set field "such" to "FALL-1840"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1840FALL"
And I set field "such" to "FALL-1840"
And I set field "bestausekso" to "FALL-1840"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1840-FALL"
And I set field "num2" to "1840-FALL"
And I set field "such" to "FALL-1840"
And I set field "namebspr" to "FALL-1840"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1840"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1840" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1840-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1840" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1840"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1840-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1840" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1840"
And I set field "num4" to "1840-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1840"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1840" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1840-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1840-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1840"
And I set field "num4" to "1840-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1840"
# FIXME RE nachher preis muss da und geschützt sein
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1840" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1840-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1840" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1840"
And I set field "num4" to "1840-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1840 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1840" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1840-RLS"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-1840-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1840"
And I set field "num4" to "1840-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1840"
Then field "mge" has value "50" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "1,2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1840" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1840-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-1850
Scenario: FALL-1850
# Bestellung	Lieferschein	1. Rechnung 	2. Rechnung	Rücklieferschein

# Konto 1850FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1850FALL"
And I set field "such" to "FALL-1850"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1850FALL"
And I set field "such" to "FALL-1850"
And I set field "bestausekso" to "FALL-1850"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1850-FALL"
And I set field "num2" to "1850-FALL"
And I set field "such" to "FALL-1850"
And I set field "namebspr" to "FALL-1850"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1850"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1850" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1850-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1850" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1850"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1850-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1850" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1850"
And I set field "num4" to "1850-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1850"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1850" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1850-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1850-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1850"
And I set field "num4" to "1850-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1850"
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1850" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1850-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-1850-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1850"
And I set field "num4" to "1850-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1850"
And I set field "mge" to "50" in row 1
And I set field "preis" to "1,2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1850" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1850-RE2"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1850" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1850"
And I set field "num4" to "1850-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1850 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1850" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1850-RLS"
And I close the current editor

# # Gutschrift
# Given I open an editor "gutschrift-1850" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "rls-1850"
# And I set field "num4" to "1850-GS"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "preis" to "1" in row 1
# And I set field "kenn" to "FALL-1850"
# And I save the current editor
# 
# # Ausgabe Gutschrift
# Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1850-GS"
# And I close the current editor

#####################################################################################################################################

@FALL-1860
Scenario: FALL-1860
# Bestellung	Lieferschein	Rücklieferschein	1. Rechnung 	2. Rechnung

# Konto 1860FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1860FALL"
And I set field "such" to "FALL-1860"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1860FALL"
And I set field "such" to "FALL-1860"
And I set field "bestausekso" to "FALL-1860"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1860-FALL"
And I set field "num2" to "1860-FALL"
And I set field "such" to "FALL-1860"
And I set field "namebspr" to "FALL-1860"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1860"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1860" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1860-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1860" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1860"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1860-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1860" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1860"
And I set field "num4" to "1860-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1860"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1860" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1860-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1860" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1860"
And I set field "num4" to "1860-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1860 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1860" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1860-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1860-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1860"
And I set field "num4" to "1860-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1860"
# FIXME RE nachher preis muss da und geschützt sein
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1860" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1860-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-1860-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1860"
And I set field "num4" to "1860-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1860"
Then field "mge" has value "50" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "1,2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1860" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1860-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-1870
Scenario: FALL-1870
# Bestellung	Lieferschein	Rücklieferschein	1. Rechnung 	2. Rechnung


# Konto 1870FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1870FALL"
And I set field "such" to "FALL-1870"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1870FALL"
And I set field "such" to "FALL-1870"
And I set field "bestausekso" to "FALL-1870"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1870-FALL"
And I set field "num2" to "1870-FALL"
And I set field "such" to "FALL-1870"
And I set field "namebspr" to "FALL-1870"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1870"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1870" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1870-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1870" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1870"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1870-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1870" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1870"
And I set field "num4" to "1870-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1870"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1870" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1870-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1870" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1870"
And I set field "num4" to "1870-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1870 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1870" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1870-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1870-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1870"
And I set field "num4" to "1870-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1870"
# FIXME RE nachher preis muss da und geschützt sein
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1870" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1870-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-1870-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1870"
And I set field "num4" to "1870-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1870"
Then field "mge" has value "50" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "1,2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1870" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1870-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-1880
Scenario: FALL-1880
# Bestellung	Lieferschein	1. Rechnung 	Rücklieferschein	Gutschrift

# Konto 1880FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1880FALL"
And I set field "such" to "FALL-1880"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1880FALL"
And I set field "such" to "FALL-1880"
And I set field "bestausekso" to "FALL-1880"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1880-FALL"
And I set field "num2" to "1880-FALL"
And I set field "such" to "FALL-1880"
And I set field "namebspr" to "FALL-1880"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1880"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1880" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1880-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1880" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1880"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1880-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1880" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1880"
And I set field "num4" to "1880-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1880"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1880" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1880-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1880-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1880"
And I set field "num4" to "1880-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1880"
And I set field "mge" to "80" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1880" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1880-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1880" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1880"
And I set field "num4" to "1880-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1880 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1880" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1880-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-1880" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-1880"
And I set field "num4" to "1880-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1880"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1880-GS"
And I close the current editor

# # Rechnung2 anlegen fällt in diesem fall aus
# Given I open an editor "rechnung-1880-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "lieferschein-1880"
# And I set field "num4" to "1880-RE2"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "kenn" to "FALL-1880"
# And I set field "mge" to "50" in row 1
# And I set field "preis" to "1,2" in row 1
# And I save the current editor
# 
# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-1880" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
# 
# # Ausgabe Rechnung
# Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1880-RE2"
# And I close the current editor

#####################################################################################################################################

@FALL-1890
Scenario: FALL-1890
# Bestellung	Lieferschein	1. Rechnung Rücklieferschein	Gutschrift

# Konto 1890FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1890FALL"
And I set field "such" to "FALL-1890"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1890FALL"
And I set field "such" to "FALL-1890"
And I set field "bestausekso" to "FALL-1890"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1890-FALL"
And I set field "num2" to "1890-FALL"
And I set field "such" to "FALL-1890"
And I set field "namebspr" to "FALL-1890"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1890"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1890" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1890-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1890" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1890"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1890-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1890" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1890"
And I set field "num4" to "1890-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1890"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1890" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1890-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1890-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1890"
And I set field "num4" to "1890-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1890"
And I set field "mge" to "80" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1890" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1890-RE1"
And I close the current editor

# # Rechnung2 anlegen fällt in diesem Fall aus
# Given I open an editor "rechnung-1890-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "lieferschein-1890"
# And I set field "num4" to "1890-RE2"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "kenn" to "FALL-1890"
# And I set field "mge" to "50" in row 1
# And I set field "preis" to "1,2" in row 1
# And I save the current editor
# 
# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-1890" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
# 
# # Ausgabe Rechnung
# Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1890-RE2"
# And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1890" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1890"
And I set field "num4" to "1890-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1890 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1890" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1890-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-1890" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-1890"
And I set field "num4" to "1890-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1890"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1890-GS"
And I close the current editor

#####################################################################################################################################

@FALL-1900
Scenario: FALL-1900
# Bestellung	Lieferschein	Rücklieferschein	1. Rechnung  Gutschrift

# Konto 1900FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1900FALL"
And I set field "such" to "FALL-1900"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1900FALL"
And I set field "such" to "FALL-1900"
And I set field "bestausekso" to "FALL-1900"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1900-FALL"
And I set field "num2" to "1900-FALL"
And I set field "such" to "FALL-1900"
And I set field "namebspr" to "FALL-1900"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1900"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1900" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1900-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1900" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1900"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1900-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1900" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1900"
And I set field "num4" to "1900-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1900"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1900" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1900-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1900" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1900"
And I set field "num4" to "1900-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1900 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1900" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1900-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1900-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1900"
And I set field "num4" to "1900-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1900"
Then field "mge" has value "100" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1900" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1900-RE1"
And I close the current editor

#####################################################################################################################################

@FALL-1910
Scenario: FALL-1910
# Bestellung	Lieferschein	Rücklieferschein	1.Rechnung	Gutschrift

# Konto 1910FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1910FALL"
And I set field "such" to "FALL-1910"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1910FALL"
And I set field "such" to "FALL-1910"
And I set field "bestausekso" to "FALL-1910"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1910-FALL"
And I set field "num2" to "1910-FALL"
And I set field "such" to "FALL-1910"
And I set field "namebspr" to "FALL-1910"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1910"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1910" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1910-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1910" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1910"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1910-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1910" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1910"
And I set field "num4" to "1910-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1910"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1910" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1910-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1910" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1910"
And I set field "num4" to "1910-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1910 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1910" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1910-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1910-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1910"
And I set field "num4" to "1910-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1910"
Then field "mge" has value "100" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1910" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1910-RE1"
And I close the current editor

#####################################################################################################################################

@FALL-1920
Scenario: FALL-1920
# Bestellung	Lieferschein	1. Rechnung 

# Konto 1920FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1920FALL"
And I set field "such" to "FALL-1920"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1920FALL"
And I set field "such" to "FALL-1920"
And I set field "bestausekso" to "FALL-1920"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1920-FALL"
And I set field "num2" to "1920-FALL"
And I set field "such" to "FALL-1920"
And I set field "namebspr" to "FALL-1920"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1920"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1920" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1920-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1920" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1920"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1920-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1920" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1920"
And I set field "num4" to "1920-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1920"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1920" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1920-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1920-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1920"
And I set field "num4" to "1920-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1920"
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1920" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1920-RE1"
And I close the current editor

#####################################################################################################################################

@FALL-1930
Scenario: FALL-1930
# Bestellung	Lieferschein	1. Rechnung 	Rücklieferschein


# Konto 1930FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1930FALL"
And I set field "such" to "FALL-1930"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1930FALL"
And I set field "such" to "FALL-1930"
And I set field "bestausekso" to "FALL-1930"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1930-FALL"
And I set field "num2" to "1930-FALL"
And I set field "such" to "FALL-1930"
And I set field "namebspr" to "FALL-1930"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1930"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1930" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1930-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1930" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1930"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1930-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1930" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1930"
And I set field "num4" to "1930-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1930"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1930" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1930-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1930-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1930"
And I set field "num4" to "1930-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1930"
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1930" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1930-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1930" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1930"
And I set field "num4" to "1930-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1930 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1930" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1930-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-1940
Scenario: FALL-1940
# Bestellung	Lieferschein	Rücklieferschein

# Konto 1940FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1940FALL"
And I set field "such" to "FALL-1940"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1940FALL"
And I set field "such" to "FALL-1940"
And I set field "bestausekso" to "FALL-1940"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1940-FALL"
And I set field "num2" to "1940-FALL"
And I set field "such" to "FALL-1940"
And I set field "namebspr" to "FALL-1940"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1940"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1940" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1940-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1940" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1940"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1940-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1940" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1940"
And I set field "num4" to "1940-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1940"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1940" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1940-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1940" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1940"
And I set field "num4" to "1940-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1940 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1940" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1940-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-1950
Scenario: FALL-1950
# Bestellung	Lieferschein	Rücklieferschein	1. Rechnung 

# Konto 1950FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1950FALL"
And I set field "such" to "FALL-1950"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1950FALL"
And I set field "such" to "FALL-1950"
And I set field "bestausekso" to "FALL-1950"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1950-FALL"
And I set field "num2" to "1950-FALL"
And I set field "such" to "FALL-1950"
And I set field "namebspr" to "FALL-1950"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1950"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1950" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1950-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1950" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1950"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1950-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1950" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1950"
And I set field "num4" to "1950-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1950"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1950" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1950-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1950" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1950"
And I set field "num4" to "1950-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1950 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1950" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1950-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1950-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1950"
And I set field "num4" to "1950-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1950"
# FIXME RE nachher preis muss da und geschützt sein
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1950" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1950-RE1"
And I close the current editor

#####################################################################################################################################

@FALL-1960
Scenario: FALL-1960
# Bestellung	Lieferschein	1. Rechnung 	2. Rechnung

# Konto 1960FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1960FALL"
And I set field "such" to "FALL-1960"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1960FALL"
And I set field "such" to "FALL-1960"
And I set field "bestausekso" to "FALL-1960"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1960-FALL"
And I set field "num2" to "1960-FALL"
And I set field "such" to "FALL-1960"
And I set field "namebspr" to "FALL-1960"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-1960"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1960" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1960-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1960" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "kenn" to "FALL-1960"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1960-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1960" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1960"
And I set field "num4" to "1960-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-1960"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1960" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1960-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1960" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1960"
And I set field "num4" to "1960-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-30" in row 1
And I set field "kenn" to "FALL-1960 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1960" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1960-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1960-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1960"
And I set field "num4" to "1960-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1960"
And I set field "mge" to "50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1960" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1960-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-1960-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1960"
And I set field "num4" to "1960-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1960"
Then field "mge" has value "50" in row 1
And I set field "preis" to "1,2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-1960" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1960-RE2"
And I close the current editor

#####################################################################################################################################
# 
# Die nachfolgenden Fälle dienen der Dokumentatino von Teilrechnungen + Rücklieferscheinen 
# Hier ist die Rückliefermenge höher als die 1. Rechnungsmenge
# Fall 2010 - 2060
# LS 55x22€  , RE 20x21€ ,KM, RLS 40x X€ , RE2 35x23€,  (GS 20x21€ + 20x23€) 
# 
#####################################################################################################################################

@FALL-2010
Scenario: FALL-2010
# Bestellung	Lieferschein	1. Rechnung 	Rücklieferschein	2. Rechnung

# Konto 2010FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2010FALL"
And I set field "such" to "FALL-2010"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2010FALL"
And I set field "such" to "FALL-2010"
And I set field "bestausekso" to "FALL-2010"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2010-FALL"
And I set field "num2" to "2010-FALL"
And I set field "such" to "FALL-2010"
And I set field "namebspr" to "FALL-2010"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2010"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2010" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2010-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2010" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2010"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2010-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2010" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2010"
And I set field "num4" to "2010-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2010"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2010" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2010-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2010-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2010"
And I set field "num4" to "2010-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2010"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2010" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2010-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2010" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2010"
And I set field "num4" to "2010-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2010 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2010" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2010-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-2020
Scenario: FALL-2020
# Bestellung	Lieferschein	1. Rechnung 	Rücklieferschein	2. Rechnung	Gutschrift (40x21€)

# Konto 2020FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2020FALL"
And I set field "such" to "FALL-2020"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2020FALL"
And I set field "such" to "FALL-2020"
And I set field "bestausekso" to "FALL-2020"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2020-FALL"
And I set field "num2" to "2020-FALL"
And I set field "such" to "FALL-2020"
And I set field "namebspr" to "FALL-2020"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2020"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2020" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2020-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2020" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2020"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2020-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2020" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2020"
And I set field "num4" to "2020-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2020"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2020" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2020-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2020-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2020"
And I set field "num4" to "2020-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2020"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2020" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2020-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2020" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2020"
And I set field "num4" to "2020-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2020 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2020" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2020-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2020" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2020"
And I set field "num4" to "2020-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "preis" to "21" in row 1
And I set field "kenn" to "FALL-2020"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2020-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2030
Scenario: FALL-2030
# Bestellung	Lieferschein	1. Rechnung 	Rücklieferschein	2. Rechnung	Gutschrift  (20x21€ + 20x23€) 

# Konto 2030FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2030FALL"
And I set field "such" to "FALL-2030"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2030FALL"
And I set field "such" to "FALL-2030"
And I set field "bestausekso" to "FALL-2030"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2030-FALL"
And I set field "num2" to "2030-FALL"
And I set field "such" to "FALL-2030"
And I set field "namebspr" to "FALL-2030"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2030"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2030" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2030-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2030" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2030"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2030-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2030" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2030"
And I set field "num4" to "2030-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2030"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2030" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2030-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2030-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2030"
And I set field "num4" to "2030-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2030"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2030" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2030-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2030" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2030"
And I set field "num4" to "2030-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2030 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2030" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2030-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2030" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2030"
And I set field "num4" to "2030-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "mge" has value "-5" in row 1
## And I set field "preis" to "21" in row 1
#And I set field "beleg" to id from editor "rls-2030"
#And I set field "mge" to "-20" in row 2
## And I set field "preis" to "23" in row 2
And I set field "kenn" to "FALL-2030"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2030-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2040
Scenario: FALL-2040
# Bestellung	Lieferschein	1. Rechnung 	2. Rechnung	Rücklieferschein	Gutschrift  (20x21€ + 20x23€) 

# Konto 2040FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2040FALL"
And I set field "such" to "FALL-2040"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2040FALL"
And I set field "such" to "FALL-2040"
And I set field "bestausekso" to "FALL-2040"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2040-FALL"
And I set field "num2" to "2040-FALL"
And I set field "such" to "FALL-2040"
And I set field "namebspr" to "FALL-2040"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2040"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2040" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2040-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2040" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2040"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2040-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2040" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2040"
And I set field "num4" to "2040-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2040"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2040" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2040-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2040-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2040"
And I set field "num4" to "2040-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2040"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2040" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2040-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2040-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2040"
And I set field "num4" to "2040-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2040"
And I set field "mge" to "35" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2040" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2040-RE2"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2040" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2040"
And I set field "num4" to "2040-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2040 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2040" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2040-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2040" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2040"
And I set field "num4" to "2040-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-20" in row 1
## And I set field "preis" to "21" in row 1
#And I set field "beleg" to id from editor "rls-2040"
#And I set field "mge" to "-20" in row 2
## And I set field "preis" to "23" in row 2
And I set field "kenn" to "FALL-2040"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2040-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2050
Scenario: FALL-2050
# Bestellung	Lieferschein	Rücklieferschein	1. Rechnung 	2. Rechnung	Gutschrift  (20x21€ + 20x23€) 

# Konto 2050FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2050FALL"
And I set field "such" to "FALL-2050"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2050FALL"
And I set field "such" to "FALL-2050"
And I set field "bestausekso" to "FALL-2050"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2050-FALL"
And I set field "num2" to "2050-FALL"
And I set field "such" to "FALL-2050"
And I set field "namebspr" to "FALL-2050"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2050"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2050" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2050-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2050" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2050"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2050-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2050" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2050"
And I set field "num4" to "2050-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2050"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2050" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2050-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2050" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2050"
And I set field "num4" to "2050-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2050 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2050" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2050-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2050-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2050"
And I set field "num4" to "2050-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2050"
Then field "mge" has value "55" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2050" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2050-RE1"
And I close the current editor

#####################################################################################################################################

@FALL-2051
Scenario: FALL-2051
# Bestellung	Lieferschein	Rücklieferschein Rechnung gesamt

# Konto 2051FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2051FALL"
And I set field "such" to "FALL-2051"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2051FALL"
And I set field "such" to "FALL-2051"
And I set field "bestausekso" to "FALL-2051"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2051-FALL"
And I set field "num2" to "2051-FALL"
And I set field "such" to "FALL-2051"
And I set field "namebspr" to "FALL-2051"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2051"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2051" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2051-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2051" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2051"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2051-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2051" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2051"
And I set field "num4" to "2051-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2051"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2051" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2051-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2051" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2051"
And I set field "num4" to "2051-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2051 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2051" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2051-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2051-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2051"
And I set field "num4" to "2051-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2051"
Then field "mge" has value "55" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2051" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2051-RE1"
And I close the current editor

#####################################################################################################################################

@FALL-2052
Scenario: FALL-2052
# Bestellung	Lieferschein Rücklieferschein 1. Rechnung 2. Rechnung Gutschrift  (40x22€) 

# Konto 2052FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2052FALL"
And I set field "such" to "FALL-2052"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2052FALL"
And I set field "such" to "FALL-2052"
And I set field "bestausekso" to "FALL-2052"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2052-FALL"
And I set field "num2" to "2052-FALL"
And I set field "such" to "FALL-2052"
And I set field "namebspr" to "FALL-2052"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2052"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2052" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2052-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2052" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2052"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2052-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2052" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2052"
And I set field "num4" to "2052-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2052"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2052" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2052-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2052" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2052"
And I set field "num4" to "2052-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2052 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2052" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2052-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2052-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2052"
And I set field "num4" to "2052-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2052"
And I set field "mge" to "15" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2052" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2052-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2052-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2052"
And I set field "num4" to "2052-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2052"
Then field "mge" has value "40" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2052" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2052-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2053
Scenario: FALL-2053
# Bestellung	Lieferschein Rücklieferschein 1. Rechnung 2. Rechnung Gutschrift  (40x22€) 

# Konto 2053FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2053FALL"
And I set field "such" to "FALL-2053"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2053FALL"
And I set field "such" to "FALL-2053"
And I set field "bestausekso" to "FALL-2053"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2053-FALL"
And I set field "num2" to "2053-FALL"
And I set field "such" to "FALL-2053"
And I set field "namebspr" to "FALL-2053"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2053"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2053" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2053-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2053" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2053"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2053-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2053" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2053"
And I set field "num4" to "2053-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2053"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2053" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2053-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2053" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2053"
And I set field "num4" to "2053-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2053 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2053" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2053-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2053-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2053"
And I set field "num4" to "2053-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2053"
And I set field "mge" to "15" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2053" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2053-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2053-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2053"
And I set field "num4" to "2053-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2053"
Then field "mge" has value "40" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2053" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2053-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2054
Scenario: FALL-2054
# Bestellung	Lieferschein Rücklieferschein 1. Rechnung 2. Rechnung Gutschrift  (20x21€ + 20x23€) 

# Konto 2054FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2054FALL"
And I set field "such" to "FALL-2054"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2054FALL"
And I set field "such" to "FALL-2054"
And I set field "bestausekso" to "FALL-2054"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2054-FALL"
And I set field "num2" to "2054-FALL"
And I set field "such" to "FALL-2054"
And I set field "namebspr" to "FALL-2054"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2054"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2054" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2054-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2054" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2054"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2054-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2054" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2054"
And I set field "num4" to "2054-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2054"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2054" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2054-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2054" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2054"
And I set field "num4" to "2054-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2054 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2054" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2054-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2054-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2054"
And I set field "num4" to "2054-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2054"
And I set field "mge" to "15" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2054" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2054-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2054-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2054"
And I set field "num4" to "2054-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2054"
Then field "mge" has value "40" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2054" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2054-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2055
Scenario: FALL-2055
# Bestellung	Lieferschein	Rechnung	Rücklieferschein	Gutschrift

# Konto 2055FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2055FALL"
And I set field "such" to "FALL-2055"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2055FALL"
And I set field "such" to "FALL-2055"
And I set field "bestausekso" to "FALL-2055"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2055-FALL"
And I set field "num2" to "2055-FALL"
And I set field "such" to "FALL-2055"
And I set field "namebspr" to "FALL-2055"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2055"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2055" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2055-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2055" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2055"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2055-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2055" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2055"
And I set field "num4" to "2055-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2055"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2055" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2055-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2055-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2055"
And I set field "num4" to "2055-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2055"
And I set field "mge" to "55" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2055" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2055-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2055" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2055"
And I set field "num4" to "2055-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2055 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2055" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2055-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2055" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2055"
And I set field "num4" to "2055-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2055"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2055-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2056
Scenario: FALL-2056
# Bestellung	Lieferschein	Rechnung	Rücklieferschein	Gutschrift

# Konto 2056FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2056FALL"
And I set field "such" to "FALL-2056"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2056FALL"
And I set field "such" to "FALL-2056"
And I set field "bestausekso" to "FALL-2056"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2056-FALL"
And I set field "num2" to "2056-FALL"
And I set field "such" to "FALL-2056"
And I set field "namebspr" to "FALL-2056"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2056"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2056" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2056-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2056" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2056"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2056-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2056" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2056"
And I set field "num4" to "2056-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2056"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2056" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2056-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2056-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2056"
And I set field "num4" to "2056-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2056"
And I set field "mge" to "55" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2056" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2056-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2056" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2056"
And I set field "num4" to "2056-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2056 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2056" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2056-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2056" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2056"
And I set field "num4" to "2056-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2056"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2056-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2057
Scenario: FALL-2057
# Bestellung	Lieferschein	Rechnung	Rücklieferschein	Gutschrift

# Konto 2057FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2057FALL"
And I set field "such" to "FALL-2057"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2057FALL"
And I set field "such" to "FALL-2057"
And I set field "bestausekso" to "FALL-2057"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2057-FALL"
And I set field "num2" to "2057-FALL"
And I set field "such" to "FALL-2057"
And I set field "namebspr" to "FALL-2057"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2057"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2057" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2057-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2057" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2057"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2057-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2057" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2057"
And I set field "num4" to "2057-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2057"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2057" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2057-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2057-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2057"
And I set field "num4" to "2057-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2057"
And I set field "mge" to "55" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2057" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2057-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2057" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2057"
And I set field "num4" to "2057-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2057 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2057" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2057-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2057" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2057"
And I set field "num4" to "2057-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2057"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2057-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2060
Scenario: FALL-2060
# Bestellung	Lieferschein	1. Rechnung 	Rücklieferschein	2. Rechnung	Gutschrift (40x23€)

# Konto 2060FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2060FALL"
And I set field "such" to "FALL-2060"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2060FALL"
And I set field "such" to "FALL-2060"
And I set field "bestausekso" to "FALL-2060"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2060-FALL"
And I set field "num2" to "2060-FALL"
And I set field "such" to "FALL-2060"
And I set field "namebspr" to "FALL-2060"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2060"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2060" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2060-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2060" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2060"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2060-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2060" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2060"
And I set field "num4" to "2060-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2060"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2060" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2060-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2060-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2060"
And I set field "num4" to "2060-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2060"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2060" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2060-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2060" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2060"
And I set field "num4" to "2060-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2060 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2060" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2060-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2060" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2060"
And I set field "num4" to "2060-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2060"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2060-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2074
Scenario: FALL-2074
# Bestellung	Lieferschein Rücklieferschein 1. Rechnung 2. Rechnung Gutschrift  (20x21€ + 20x23€) 

# Konto 2074FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2074FALL"
And I set field "such" to "FALL-2074"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2074FALL"
And I set field "such" to "FALL-2074"
And I set field "bestausekso" to "FALL-2074"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2074-FALL"
And I set field "num2" to "2074-FALL"
And I set field "such" to "FALL-2074"
And I set field "namebspr" to "FALL-2074"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2074"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2074" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2074-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2074" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2074"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2074-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2074" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2074"
And I set field "num4" to "2074-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2074"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2074" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2074-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2074" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2074"
And I set field "num4" to "2074-RLS"
# And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2074 Ruecklieferschein"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-2074" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2074-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2074-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2074"
And I set field "num4" to "2074-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2074"
And I set field "mge" to "15" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2074" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2074-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2074-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2074"
And I set field "num4" to "2074-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2074"
And I set field "mge" to "40" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2074" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2074-RE2"
And I close the current editor


# Rücklieferschein buchen
Given I open an editor "rls2-2074" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "rls-2074"
# And I set field "num4" to "2074-RLS"
And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "mge" to "-40" in row 1
# And I set field "kenn" to "FALL-2074 Ruecklieferschein"
And I save the current editor

# Gutschrift
Given I open an editor "gutschrift-2074" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2074"
And I set field "num4" to "2074-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
#And I set field "mge" to "-40" in row 1
# Fixme GS hier sollten dann 15x20€ 25x23€ erscheinen
#And I set field "preis" to "23" in row 1
#And I set field "beleg" to id from editor "rls-2074"
#And I set field "mge" to "-40" in row 2
#And I set field "preis" to "23" in row 2
And I set field "kenn" to "FALL-2074"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2074-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2075
Scenario: FALL-2075
# Bestellung	Lieferschein Rücklieferschein 1. Rechnung 2. Rechnung Gutschrift  (20x21€ + 20x23€) 

# Konto 2075FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2075FALL"
And I set field "such" to "FALL-2075"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2075FALL"
And I set field "such" to "FALL-2075"
And I set field "bestausekso" to "FALL-2075"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2075-FALL"
And I set field "num2" to "2075-FALL"
And I set field "such" to "FALL-2075"
And I set field "namebspr" to "FALL-2075"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2075"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2075" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2075-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2075" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2075"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2075-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2075" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2075"
And I set field "num4" to "2075-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2075"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2075" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2075-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2075" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2075"
And I set field "num4" to "2075-RLS"
# And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2075 Ruecklieferschein"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-2075" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2075-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2075-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2075"
And I set field "num4" to "2075-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2075"
And I set field "mge" to "15" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2075" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2075-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2075-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2075"
And I set field "num4" to "2075-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2075"
And I set field "mge" to "40" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2075" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2075-RE2"
And I close the current editor

# Rücklieferschein buchen
Given I open an editor "rls2-2075" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "rls-2075"
# And I set field "num4" to "2075-RLS"
And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "mge" to "-40" in row 1
# And I set field "kenn" to "FALL-2075 Ruecklieferschein"
And I save the current editor

# Gutschrift
Given I open an editor "gutschrift-2075" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2075"
And I set field "num4" to "2075-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
#And I set field "mge" to "-15" in row 1
# Fixme GS hier sollten dann 15x20€ 25x23€ erscheinen
#And I set field "preis" to "20" in row 1
#And I set field "beleg" to id from editor "rls-2075"
#And I set field "mge" to "-25" in row 2
#And I set field "preis" to "23" in row 2
And I set field "kenn" to "FALL-2075"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2075-GS"
And I close the current editor

#####################################################################################################################################
# 
# Hier jetzt die Faelle mit fakt = nein 
# Fall 2110 - 2175
# 
#####################################################################################################################################

@FALL-2110
Scenario: FALL-2110
# Bestellung	Lieferschein (fakt = nein)	1. Rechnung 	Rücklieferschein	2. Rechnung

# Konto 2110FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2110FALL"
And I set field "such" to "FALL-2110"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2110FALL"
And I set field "such" to "FALL-2110"
And I set field "bestausekso" to "FALL-2110"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2110-FALL"
And I set field "num2" to "2110-FALL"
And I set field "such" to "FALL-2110"
And I set field "namebspr" to "FALL-2110"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2110"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2110" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2110-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2110" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2110"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2110-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2110" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2110"
And I set field "num4" to "2110-LS"
And I set field "fakt" to "NEIN"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2110"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2110" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2110-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2110-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2110"
And I set field "num4" to "2110-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2110"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2110" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2110-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2110" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2110"
And I set field "num4" to "2110-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2110 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2110" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2110-RLS"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2110-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2110"
And I set field "num4" to "2110-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2110"
And I set field "mge" to "35" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2110" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2110-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2120
Scenario: FALL-2120
# Bestellung	Lieferschein (fakt = nein)	1. Rechnung 	Rücklieferschein	2. Rechnung	Gutschrift (40x21€)

# Konto 2120FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2120FALL"
And I set field "such" to "FALL-2120"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2120FALL"
And I set field "such" to "FALL-2120"
And I set field "bestausekso" to "FALL-2120"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2120-FALL"
And I set field "num2" to "2120-FALL"
And I set field "such" to "FALL-2120"
And I set field "namebspr" to "FALL-2120"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2120"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2120" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2120-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2120" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2120"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2120-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2120" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2120"
And I set field "num4" to "2120-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2120"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2120" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2120-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2120-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2120"
And I set field "num4" to "2120-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2120"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2120" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2120-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2120" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2120"
And I set field "num4" to "2120-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2120 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2120" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2120-RLS"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2120-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2120"
And I set field "num4" to "2120-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2120"
And I set field "mge" to "35" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2120" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2120-RE2"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2120" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2120"
And I set field "num4" to "2120-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2120"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2120-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2130
Scenario: FALL-2130
# Bestellung	Lieferschein (fakt = nein)	1. Rechnung 	Rücklieferschein	2. Rechnung	Gutschrift  (20x21€ + 20x23€) 

# Konto 2130FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2130FALL"
And I set field "such" to "FALL-2130"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2130FALL"
And I set field "such" to "FALL-2130"
And I set field "bestausekso" to "FALL-2130"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2130-FALL"
And I set field "num2" to "2130-FALL"
And I set field "such" to "FALL-2130"
And I set field "namebspr" to "FALL-2130"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2130"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2130" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2130-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2130" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2130"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2130-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2130" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2130"
And I set field "num4" to "2130-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2130"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2130" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2130-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2130-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2130"
And I set field "num4" to "2130-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2130"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2130" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2130-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2130" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2130"
And I set field "num4" to "2130-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2130 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2130" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2130-RLS"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2130-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2130"
And I set field "num4" to "2130-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2130"
And I set field "mge" to "35" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2130" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2130-RE2"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2130" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2130"
And I set field "num4" to "2130-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2130"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2130-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2140
Scenario: FALL-2140
# Bestellung	Lieferschein (fakt = nein)	1. Rechnung 	2. Rechnung	Rücklieferschein	Gutschrift  (20x21€ + 20x23€)  

# Konto 2140FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2140FALL"
And I set field "such" to "FALL-2140"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2140FALL"
And I set field "such" to "FALL-2140"
And I set field "bestausekso" to "FALL-2140"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2140-FALL"
And I set field "num2" to "2140-FALL"
And I set field "such" to "FALL-2140"
And I set field "namebspr" to "FALL-2140"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2140"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2140" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2140-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2140" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2140"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2140-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2140" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2140"
And I set field "num4" to "2140-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2140"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2140" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2140-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2140-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2140"
And I set field "num4" to "2140-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2140"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2140" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2140-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2140-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2140"
And I set field "num4" to "2140-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2140"
And I set field "mge" to "35" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2140" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2140-RE2"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2140" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2140"
And I set field "num4" to "2140-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2140 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2140" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2140-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2140" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2140"
And I set field "num4" to "2140-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2140"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2140-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2150
Scenario: FALL-2150
# Bestellung	Lieferschein (fakt = nein)	Rücklieferschein	1. Rechnung 	2. Rechnung	Gutschrift  (20x21€ + 20x23€) 

# Konto 2150FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2150FALL"
And I set field "such" to "FALL-2150"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2150FALL"
And I set field "such" to "FALL-2150"
And I set field "bestausekso" to "FALL-2150"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2150-FALL"
And I set field "num2" to "2150-FALL"
And I set field "such" to "FALL-2150"
And I set field "namebspr" to "FALL-2150"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2150"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2150" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2150-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2150" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2150"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2150-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2150" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2150"
And I set field "num4" to "2150-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2150"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2150" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2150-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2150" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2150"
And I set field "num4" to "2150-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2150 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2150" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2150-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2150-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2150"
And I set field "num4" to "2150-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2150"
And I set field "mge" to "15" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2150" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2150-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2150-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2150"
And I set field "num4" to "2150-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2150"
And I set field "mge" to "35" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2150" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2150-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2151
Scenario: FALL-2151
# Bestellung	Lieferschein (fakt = nein)	Rücklieferschein	Rechnung 21€

# Konto 2151FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2151FALL"
And I set field "such" to "FALL-2151"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2151FALL"
And I set field "such" to "FALL-2151"
And I set field "bestausekso" to "FALL-2151"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2151-FALL"
And I set field "num2" to "2151-FALL"
And I set field "such" to "FALL-2151"
And I set field "namebspr" to "FALL-2151"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2151"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2151" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2151-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2151" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2151"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2151-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2151" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2151"
And I set field "num4" to "2151-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2151"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2151" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2151-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2151" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2151"
And I set field "num4" to "2151-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2151 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2151" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2151-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2151-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2151"
And I set field "num4" to "2151-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2151"
And I set field "mge" to "15" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2151" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2151-RE1"
And I close the current editor

#####################################################################################################################################

@FALL-2152
Scenario: FALL-2152
# Bestellung	Lieferschein (fakt = nein)	Rücklieferschein	1. RE (ls-rls) preis 22€	1. RE (rls-mge) preis 22€	GS Preis 22€

# Konto 2152FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2152FALL"
And I set field "such" to "FALL-2152"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2152FALL"
And I set field "such" to "FALL-2152"
And I set field "bestausekso" to "FALL-2152"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2152-FALL"
And I set field "num2" to "2152-FALL"
And I set field "such" to "FALL-2152"
And I set field "namebspr" to "FALL-2152"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2152"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2152" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2152-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2152" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2152"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2152-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2152" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2152"
And I set field "num4" to "2152-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2152"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2152" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2152-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2152" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2152"
And I set field "num4" to "2152-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2152 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2152" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2152-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2152-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2152"
And I set field "num4" to "2152-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2152"
And I set field "mge" to "15" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2152" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2152-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2152-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2152"
And I set field "num4" to "2152-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2152"
And I set field "mge" to "40" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2152" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2152-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2153
Scenario: FALL-2153
# Bestellung	Lieferschein (fakt = nein)	Rücklieferschein	1. RE (ls-rls) 20€	2. RE (rls-mge) 23€	GS PREIS? 23€ 

# Konto 2153FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2153FALL"
And I set field "such" to "FALL-2153"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2153FALL"
And I set field "such" to "FALL-2153"
And I set field "bestausekso" to "FALL-2153"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2153-FALL"
And I set field "num2" to "2153-FALL"
And I set field "such" to "FALL-2153"
And I set field "namebspr" to "FALL-2153"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2153"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2153" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2153-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2153" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2153"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2153-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2153" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2153"
And I set field "num4" to "2153-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2153"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2153" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2153-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2153" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2153"
And I set field "num4" to "2153-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2153 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2153" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2153-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2153-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2153"
And I set field "num4" to "2153-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2153"
And I set field "mge" to "15" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2153" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2153-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2153-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2153"
And I set field "num4" to "2153-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2153"
And I set field "mge" to "40" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2153" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2153-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2154
Scenario: FALL-2154
# Bestellung	Lieferschein (fakt = nein)	Rücklieferschein	1. RE (ls-rls) 20€	2. RE (rls-mge) 23€	Gutschrift  (40x23€) 

# Konto 2154FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2154FALL"
And I set field "such" to "FALL-2154"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2154FALL"
And I set field "such" to "FALL-2154"
And I set field "bestausekso" to "FALL-2154"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2154-FALL"
And I set field "num2" to "2154-FALL"
And I set field "such" to "FALL-2154"
And I set field "namebspr" to "FALL-2154"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2154"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2154" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2154-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2154" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2154"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2154-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2154" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2154"
And I set field "num4" to "2154-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2154"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2154" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2154-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2154" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2154"
And I set field "num4" to "2154-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2154 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2154" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2154-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2154-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2154"
And I set field "num4" to "2154-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2154"
And I set field "mge" to "15" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2154" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2154-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2154-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2154"
And I set field "num4" to "2154-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2154"
And I set field "mge" to "40" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2154" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2154-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2155
Scenario: FALL-2155
# Bestellung	Lieferschein (fakt = nein)	Rechnung	Rücklieferschein	Gutschrift 22€	Rechnung 22€

# Konto 2155FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2155FALL"
And I set field "such" to "FALL-2155"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2155FALL"
And I set field "such" to "FALL-2155"
And I set field "bestausekso" to "FALL-2155"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2155-FALL"
And I set field "num2" to "2155-FALL"
And I set field "such" to "FALL-2155"
And I set field "namebspr" to "FALL-2155"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2155"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2155" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2155-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2155" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2155"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2155-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2155" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2155"
And I set field "num4" to "2155-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2155"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2155" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2155-LS"
And I close the current editor

# Rechnung aus Bestellung anlegen (fakt=Nein).
Given I open an editor "rechnung-2155-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2155"
And I set field "num4" to "2155-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2155"
And I set field "mge" to "55" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2155" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2155-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2155" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2155"
And I set field "num4" to "2155-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2155 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2155" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2155-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2155" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2155"
And I set field "num4" to "2155-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2155"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2155-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2156
Scenario: FALL-2156
# Bestellung	Lieferschein (fakt = nein)	Rechnung	Rücklieferschein	Gutschrift 22€	Rechnung 23€

# Konto 2156FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2156FALL"
And I set field "such" to "FALL-2156"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2156FALL"
And I set field "such" to "FALL-2156"
And I set field "bestausekso" to "FALL-2156"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2156-FALL"
And I set field "num2" to "2156-FALL"
And I set field "such" to "FALL-2156"
And I set field "namebspr" to "FALL-2156"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2156"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2156" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2156-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2156" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2156"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2156-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2156" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2156"
And I set field "num4" to "2156-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2156"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2156" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2156-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2156-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2156"
And I set field "num4" to "2156-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2156"
And I set field "mge" to "55" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2156" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2156-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2156" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2156"
And I set field "num4" to "2156-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2156 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2156" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2156-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2156" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2156"
And I set field "num4" to "2156-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2156"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2156-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2157
Scenario: FALL-2157
# Bestellung	Lieferschein (fakt = nein)	Rechnung	Rücklieferschein	Gutschrift 22€	Rechnung 21€

# Konto 2157FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2157FALL"
And I set field "such" to "FALL-2157"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2157FALL"
And I set field "such" to "FALL-2157"
And I set field "bestausekso" to "FALL-2157"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2157-FALL"
And I set field "num2" to "2157-FALL"
And I set field "such" to "FALL-2157"
And I set field "namebspr" to "FALL-2157"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2157"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2157" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2157-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2157" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2157"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2157-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2157" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2157"
And I set field "num4" to "2157-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2157"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2157" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2157-LS"
And I close the current editor

# Rechnung aus Bestellung (fakt = Nein) anlegen
Given I open an editor "rechnung-2157-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2157"
And I set field "num4" to "2157-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2157"
And I set field "mge" to "55" in row 1
# FIXME RE nachher preis muss da und geschützt sein
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2157" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2157-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2157" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2157"
And I set field "num4" to "2157-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2157 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2157" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2157-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2157" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2157"
And I set field "num4" to "2157-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2157"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2157-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2160
Scenario: FALL-2160
# Bestellung	Lieferschein (fakt = nein)	1. Rechnung 	Rücklieferschein	2. Rechnung	Gutschrift (40x23€)

# Konto 2160FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2160FALL"
And I set field "such" to "FALL-2160"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2160FALL"
And I set field "such" to "FALL-2160"
And I set field "bestausekso" to "FALL-2160"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2160-FALL"
And I set field "num2" to "2160-FALL"
And I set field "such" to "FALL-2160"
And I set field "namebspr" to "FALL-2160"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2160"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2160" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2160-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2160" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2160"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2160-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2160" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2160"
And I set field "num4" to "2160-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2160"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2160" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2160-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2160-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2160"
And I set field "num4" to "2160-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2160"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2160" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2160-RE1"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2160" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2160"
And I set field "num4" to "2160-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2160 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2160" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2160-RLS"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2160-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2160"
And I set field "num4" to "2160-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2160"
And I set field "mge" to "35" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2160" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2160-RE2"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2160" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2160"
And I set field "num4" to "2160-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# FIXME so mueeste die GS ca aussehen
# And I set field "preis" to "23" in row 1
And I set field "kenn" to "FALL-2160"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2160-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2174
Scenario: FALL-2174
# Bestellung	Lieferschein (fakt = nein)	Rücklieferschein (ungebucht)	1. RE (ls-rls) 20€	2. RE (rls-mge) 23€	RLS Buchen	Gutschrift  (40x23€)  

# Konto 2174FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2174FALL"
And I set field "such" to "FALL-2174"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2174FALL"
And I set field "such" to "FALL-2174"
And I set field "bestausekso" to "FALL-2174"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2174-FALL"
And I set field "num2" to "2174-FALL"
And I set field "such" to "FALL-2174"
And I set field "namebspr" to "FALL-2174"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2174"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2174" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2174-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2174" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2174"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2174-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2174" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2174"
And I set field "num4" to "2174-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2174"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2174" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2174-LS"
And I close the current editor

# Rücklieferschein anlegen dieser wird hier aber noch nicht gebucht!
Given I open an editor "rls-2174" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2174"
And I set field "num4" to "2174-RLS"
# And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2174 Ruecklieferschein"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-2174" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2174-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2174-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2174"
And I set field "num4" to "2174-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2174"
And I set field "mge" to "15" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2174" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2174-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2174-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2174"
And I set field "num4" to "2174-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2174"
And I set field "mge" to "40" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2174" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2174-RE2"
And I close the current editor


# Rücklieferschein buchen
Given I open an editor "rls2-2174" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "rls-2174"
# And I set field "num4" to "2174-RLS"
And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "mge" to "-40" in row 1
# And I set field "kenn" to "FALL-2174 Ruecklieferschein"
And I save the current editor

# Gutschrift
Given I open an editor "gutschrift-2174" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2174"
And I set field "num4" to "2174-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2174"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2174-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2175
Scenario: FALL-2175
# Bestellung	Lieferschein (fakt = nein)	Rücklieferschein (ungebucht)	1. RE (ls-rls) 20€	2. RE (rls-mge) 23€	RLS Buchen	Gutschrift  (15x20€ 25x23€) 

# Konto 2175FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2175FALL"
And I set field "such" to "FALL-2175"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2175FALL"
And I set field "such" to "FALL-2175"
And I set field "bestausekso" to "FALL-2175"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2175-FALL"
And I set field "num2" to "2175-FALL"
And I set field "such" to "FALL-2175"
And I set field "namebspr" to "FALL-2175"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2175"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2175" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2175-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2175" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2175"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2175-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2175" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2175"
And I set field "num4" to "2175-LS"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2175"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2175" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2175-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2175" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2175"
And I set field "num4" to "2175-RLS"
# And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2175 Ruecklieferschein"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-2175" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2175-RLS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2175-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2175"
And I set field "num4" to "2175-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2175"
And I set field "mge" to "15" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2175" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2175-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2175-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2175"
And I set field "num4" to "2175-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2175"
And I set field "mge" to "40" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2175" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2175-RE2"
And I close the current editor


# Rücklieferschein buchen
Given I open an editor "rls2-2175" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "rls-2175"
# And I set field "num4" to "2175-RLS"
And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "mge" to "-40" in row 1
# And I set field "kenn" to "FALL-2175 Ruecklieferschein"
And I save the current editor

# Gutschrift
Given I open an editor "gutschrift-2175" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2175"
And I set field "num4" to "2175-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2175"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2175-GS"
And I close the current editor

#####################################################################################################################################
# 
# Hier jetzt Vorkasse Rechnungen 
# Fall 2210 - 2250
# 
#####################################################################################################################################

@FALL-2210
Scenario: FALL-2210
# Bestellung	1. Rechnung (fakt = nein) 	Lieferschein   	Rücklieferschein	2. Rechnung

# Konto 2210FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2210FALL"
And I set field "such" to "FALL-2210"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2210FALL"
And I set field "such" to "FALL-2210"
And I set field "bestausekso" to "FALL-2210"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2210-FALL"
And I set field "num2" to "2210-FALL"
And I set field "such" to "FALL-2210"
And I set field "namebspr" to "FALL-2210"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2210"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2210" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2210-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2210" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2210"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2210-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2210-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2210"
And I set field "num4" to "2210-RE1"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2210"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2210" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2210-RE1"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2210" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2210"
And I set field "num4" to "2210-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2210"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2210" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2210-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2210" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2210"
And I set field "num4" to "2210-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2210 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2210" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2210-RLS"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2210-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2210"
And I set field "num4" to "2210-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2210"
And I set field "mge" to "35" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2210" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2210-RE2"
And I close the current editor

#####################################################################################################################################

@FALL-2220
Scenario: FALL-2220
# Bestellung	1. Rechnung (fakt = nein)	Lieferschein   	Rücklieferschein	2. Rechnung	Gutschrift (40x21€)

# Konto 2220FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2220FALL"
And I set field "such" to "FALL-2220"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2220FALL"
And I set field "such" to "FALL-2220"
And I set field "bestausekso" to "FALL-2220"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2220-FALL"
And I set field "num2" to "2220-FALL"
And I set field "such" to "FALL-2220"
And I set field "namebspr" to "FALL-2220"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2220"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2220" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2220-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2220" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2220"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2220-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2220-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2220"
And I set field "num4" to "2220-RE1"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2220"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2220" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2220-RE1"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2220" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2220"
And I set field "num4" to "2220-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2220"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2220" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2220-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2220" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2220"
And I set field "num4" to "2220-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2220 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2220" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2220-RLS"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2220-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2220"
And I set field "num4" to "2220-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2220"
And I set field "mge" to "35" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2220" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2220-RE2"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2220" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2220"
And I set field "num4" to "2220-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2220"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2220-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2230
Scenario: FALL-2230
# Bestellung	1. Rechnung (fakt = nein)	Lieferschein   	Rücklieferschein	2. Rechnung	Gutschrift  (20x21€ + 20x23€) 

# Konto 2230FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2230FALL"
And I set field "such" to "FALL-2230"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2230FALL"
And I set field "such" to "FALL-2230"
And I set field "bestausekso" to "FALL-2230"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2230-FALL"
And I set field "num2" to "2230-FALL"
And I set field "such" to "FALL-2230"
And I set field "namebspr" to "FALL-2230"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2230"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2230" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2230-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2230" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2230"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2230-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2230-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2230"
And I set field "num4" to "2230-RE1"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2230"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2230" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2230-RE1"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2230" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2230"
And I set field "num4" to "2230-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2230"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2230" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2230-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2230" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2230"
And I set field "num4" to "2230-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2230 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2230" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2230-RLS"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2230-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2230"
And I set field "num4" to "2230-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2230"
And I set field "mge" to "35" in row 1
# FIXME RE2 preis muss da und geschützt sein
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2230" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2230-RE2"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2230" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2230"
And I set field "num4" to "2230-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2230"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2230-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2240
Scenario: FALL-2240
# Bestellung	1. Rechnung (fakt = nein)	2. Rechnung	Lieferschein   	Rücklieferschein

# Konto 2240FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2240FALL"
And I set field "such" to "FALL-2240"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2240FALL"
And I set field "such" to "FALL-2240"
And I set field "bestausekso" to "FALL-2240"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2240-FALL"
And I set field "num2" to "2240-FALL"
And I set field "such" to "FALL-2240"
And I set field "namebspr" to "FALL-2240"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2240"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2240" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2240-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2240" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2240"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2240-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2240-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2240"
And I set field "num4" to "2240-RE1"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2240"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2240" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2240-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2240-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2240"
And I set field "num4" to "2240-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2240"
And I set field "mge" to "35" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2240" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2240-RE2"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2240" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2240"
And I set field "num4" to "2240-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2240"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2240" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2240-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2240" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2240"
And I set field "num4" to "2240-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2240 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2240" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2240-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-2250
Scenario: FALL-2250
# Bestellung	1. Rechnung (fakt = nein)	2. Rechnung	Lieferschein   	Rücklieferschein	Gutschrift (40x21€)

# Konto 2250FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2250FALL"
And I set field "such" to "FALL-2250"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2250FALL"
And I set field "such" to "FALL-2250"
And I set field "bestausekso" to "FALL-2250"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2250-FALL"
And I set field "num2" to "2250-FALL"
And I set field "such" to "FALL-2250"
And I set field "namebspr" to "FALL-2250"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2250"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2250" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2250-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2250" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2250"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2250-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2250-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2250"
And I set field "num4" to "2250-RE1"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2250"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2250" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2250-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2250-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2250"
And I set field "num4" to "2250-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2250"
And I set field "mge" to "35" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2250" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2250-RE2"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2250" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2250"
And I set field "num4" to "2250-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2250"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2250" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2250-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2250" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2250"
And I set field "num4" to "2250-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2250 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2250" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2250-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2250" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2250"
And I set field "num4" to "2250-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2250"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2250-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2260
Scenario: FALL-2260
# Bestellung	1. Rechnung (fakt = nein)	2. Rechnung	Lieferschein   	Rücklieferschein	Gutschrift  (20x21€ + 20x23€) 

# Konto 2260FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2260FALL"
And I set field "such" to "FALL-2260"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2260FALL"
And I set field "such" to "FALL-2260"
And I set field "bestausekso" to "FALL-2260"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2260-FALL"
And I set field "num2" to "2260-FALL"
And I set field "such" to "FALL-2260"
And I set field "namebspr" to "FALL-2260"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2260"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2260" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2260-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2260" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2260"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2260-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2260-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2260"
And I set field "num4" to "2260-RE1"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2260"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2260" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2260-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2260-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2260"
And I set field "num4" to "2260-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2260"
And I set field "mge" to "35" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2260" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2260-RE2"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2260" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2260"
And I set field "num4" to "2260-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2260"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2260" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2260-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2260" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2260"
And I set field "num4" to "2260-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2260 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2260" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2260-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2260" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2260"
And I set field "num4" to "2260-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2260"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2260-GS"
And I close the current editor

#####################################################################################################################################

@FALL-2270
Scenario: FALL-2270
# Bestellung	1. Rechnung (fakt = nein)	2. Rechnung	Lieferschein   	Rücklieferschein	Gutschrift  (5x21€ + 35x23€) 

# Konto 2270FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2270FALL"
And I set field "such" to "FALL-2270"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2270FALL"
And I set field "such" to "FALL-2270"
And I set field "bestausekso" to "FALL-2270"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2270-FALL"
And I set field "num2" to "2270-FALL"
And I set field "such" to "FALL-2270"
And I set field "namebspr" to "FALL-2270"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2270"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2270" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2270-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2270" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2270"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2270-BE"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2270-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2270"
And I set field "num4" to "2270-RE1"
And I set field "ueb" to "ja"
And I set field "fakt" to "NEIN"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2270"
And I set field "mge" to "20" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2270" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2270-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2270-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2270"
And I set field "num4" to "2270-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2270"
And I set field "mge" to "35" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2270" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2270-RE2"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2270" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2270"
And I set field "num4" to "2270-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2270"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2270" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+2270-LS"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2270" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2270"
And I set field "num4" to "2270-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "kenn" to "FALL-2270 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2270" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2270-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-2270" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2270"
And I set field "num4" to "2270-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2270"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2270-GS"
And I close the current editor

#####################################################################################################################################

#####################################################################################################################################
# Fall 2510 - 25xx 
# Hier Faelle mit unterschiedlichen Preisen in den Rechnungen und unterschiedlichen Mengen
#####################################################################################################################################

@FALL-2510
Scenario: FALL-2510
# Bestellung	Lieferschein	
# 1. Rechnung 	2. Rechnung	3. Rechnung	4. Rechnung	5. Rechnung	
# Rücklieferschein	
# 1. Gutschrift	2. Gutschrift	3. Gutschrift

# Konto 2510FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2510FALL"
And I set field "such" to "FALL-2510"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2510FALL"
And I set field "such" to "FALL-2510"
And I set field "bestausekso" to "FALL-2510"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2510-FALL"
And I set field "num2" to "2510-FALL"
And I set field "such" to "FALL-2510"
And I set field "namebspr" to "FALL-2510"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2510"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2510" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2510-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2510" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2510"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2510-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2510" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2510"
And I set field "num4" to "2510-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2510"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2510" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2510-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2510-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2510"
And I set field "num4" to "2510-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2510"
And I set field "mge" to "10" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2510" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2510-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2510-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2510"
And I set field "num4" to "2510-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2510"
And I set field "mge" to "10" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2510" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2510-RE2"
And I close the current editor

# Rechnung3 anlegen
Given I open an editor "rechnung-2510-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2510"
And I set field "num4" to "2510-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2510"
And I set field "mge" to "10" in row 1
And I set field "preis" to "25" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2510" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2510-RE3"
And I close the current editor

# Rechnung4 anlegen
Given I open an editor "rechnung-2510-4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2510"
And I set field "num4" to "2510-RE4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2510"
And I set field "mge" to "10" in row 1
And I set field "preis" to "27" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2510" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2510-RE4"
And I close the current editor

# Rechnung5 anlegen
Given I open an editor "rechnung-2510-5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2510"
And I set field "num4" to "2510-RE5"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2510"
And I set field "mge" to "10" in row 1
And I set field "preis" to "29" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2510" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2510-RE5"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2510" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2510"
And I set field "num4" to "2510-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-46" in row 1
And I set field "kenn" to "FALL-2510 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2510" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2510-RLS"
And I close the current editor

# Gutschrift1
Given I open an editor "gutschrift-2510-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2510"
And I set field "num4" to "2510-GS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-1" in row 2
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "kenn" to "FALL-2510"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2510-GS1"
And I close the current editor

# Gutschrift2
Given I open an editor "gutschrift-2510-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2510"
And I set field "num4" to "2510-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-9" in row 1
And I set field "mge" to "-4" in row 2
And I delete row at position 4
And I delete row at position 3
And I set field "kenn" to "FALL-2510"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2510-GS2"
And I close the current editor

# Gutschrift3
Given I open an editor "gutschrift-2510-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2510"
And I set field "num4" to "2510-GS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-6" in row 1
And I set field "mge" to "-9" in row 2
And I delete row at position 3
And I set field "kenn" to "FALL-2510"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2510-GS3"
And I close the current editor

#####################################################################################################################################

@FALL-2515
Scenario: FALL-2515
# Bestellung	Lieferschein	
# 1. Rechnung 2. Rechnung 3. Rechnung 4. Rechnung 5. Rechnung	
# Rücklieferschein	
# 1. Gutschrift	2. Gutschrift	3. Gutschrift

# Konto 2515FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2515FALL"
And I set field "such" to "FALL-2515"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2515FALL"
And I set field "such" to "FALL-2515"
And I set field "bestausekso" to "FALL-2515"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2515-FALL"
And I set field "num2" to "2515-FALL"
And I set field "such" to "FALL-2515"
And I set field "namebspr" to "FALL-2515"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2515"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2515" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2515-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2515" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2515"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2515-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2515" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2515"
And I set field "num4" to "2515-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2515"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2515" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2515-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2515-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2515"
And I set field "num4" to "2515-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2515"
And I set field "mge" to "10" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2515" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2515-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2515-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2515"
And I set field "num4" to "2515-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2515"
And I set field "mge" to "10" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2515" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2515-RE2"
And I close the current editor

# Rechnung3 anlegen
Given I open an editor "rechnung-2515-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2515"
And I set field "num4" to "2515-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2515"
And I set field "mge" to "10" in row 1
And I set field "preis" to "25" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2515" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2515-RE3"
And I close the current editor

# Rechnung4 anlegen
Given I open an editor "rechnung-2515-4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2515"
And I set field "num4" to "2515-RE4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2515"
And I set field "mge" to "10" in row 1
And I set field "preis" to "27" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2515" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2515-RE4"
And I close the current editor

# Rechnung5 anlegen
Given I open an editor "rechnung-2515-5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2515"
And I set field "num4" to "2515-RE5"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2515"
And I set field "mge" to "10" in row 1
And I set field "preis" to "29" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2515" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2515-RE5"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2515" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2515"
And I set field "num4" to "2515-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-46" in row 1
And I set field "kenn" to "FALL-2515 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2515" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2515-RLS"
And I close the current editor

# Gutschrift1
Given I open an editor "gutschrift-2515-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2515"
And I set field "num4" to "2515-GS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-1" in row 2
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "kenn" to "FALL-2515"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2515-GS1"
And I close the current editor

# Gutschrift2
Given I open an editor "gutschrift-2515-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2515"
And I set field "num4" to "2515-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-9" in row 1
And I set field "mge" to "-4" in row 2
And I delete row at position 4
And I delete row at position 3
And I set field "kenn" to "FALL-2515"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2515-GS2"
And I close the current editor

# Gutschrift3
Given I open an editor "gutschrift-2515-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2515"
And I set field "num4" to "2515-GS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-6" in row 1
And I set field "mge" to "-9" in row 2
And I delete row at position 3
And I set field "kenn" to "FALL-2515"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2515-GS3"
And I close the current editor

#####################################################################################################################################

@FALL-2520
Scenario: FALL-2520
# Bestellung	Lieferschein	
# 1. Rechnung 2. Rechnung 3. Rechnung 4. Rechnung 5. Rechnung	
# Rücklieferschein	
# 1. Gutschrift	2. Gutschrift	3. Gutschrift	4. Gutschrift

# Konto 2520FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2520FALL"
And I set field "such" to "FALL-2520"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2520FALL"
And I set field "such" to "FALL-2520"
And I set field "bestausekso" to "FALL-2520"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2520-FALL"
And I set field "num2" to "2520-FALL"
And I set field "such" to "FALL-2520"
And I set field "namebspr" to "FALL-2520"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2520"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2520" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2520-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2520" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "22" in row 1
And I set field "kenn" to "FALL-2520"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2520-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2520" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2520"
And I set field "num4" to "2520-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "55" in row 1
And I set field "kenn" to "FALL-2520"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2520" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2520-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2520-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2520"
And I set field "num4" to "2520-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2520"
And I set field "mge" to "10" in row 1
And I set field "preis" to "21" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2520" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-RE1"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-2520-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2520"
And I set field "num4" to "2520-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2520"
And I set field "mge" to "10" in row 1
And I set field "preis" to "23" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2520" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-RE2"
And I close the current editor

# Rechnung3 anlegen
Given I open an editor "rechnung-2520-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2520"
And I set field "num4" to "2520-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2520"
And I set field "mge" to "10" in row 1
And I set field "preis" to "25" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2520" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-RE3"
And I close the current editor

# Rechnung4 anlegen
Given I open an editor "rechnung-2520-4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2520"
And I set field "num4" to "2520-RE4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2520"
And I set field "mge" to "10" in row 1
And I set field "preis" to "27" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2520" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-RE4"
And I close the current editor

# Rechnung5 anlegen
Given I open an editor "rechnung-2520-5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2520"
And I set field "num4" to "2520-RE5"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2520"
And I set field "mge" to "10" in row 1
And I set field "preis" to "29" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2520" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-RE5"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2520" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2520"
And I set field "num4" to "2520-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-46" in row 1
And I set field "kenn" to "FALL-2520 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2520" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2520-RLS"
And I close the current editor

# Gutschrift1
Given I open an editor "gutschrift-2520-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2520"
And I set field "num4" to "2520-GS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-1" in row 2
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I set field "kenn" to "FALL-2520"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-GS1"
And I close the current editor

# Gutschrift2
Given I open an editor "gutschrift-2520-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2520"
And I set field "num4" to "2520-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-9" in row 1
And I set field "mge" to "-4" in row 2
And I delete row at position 4
And I delete row at position 3
And I set field "kenn" to "FALL-2520"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-GS2"
And I close the current editor

# Gutschrift3
Given I open an editor "gutschrift-2520-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2520"
And I set field "num4" to "2520-GS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-6" in row 1
And I set field "mge" to "-9" in row 2
And I delete row at position 3
And I set field "kenn" to "FALL-2520"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-GS3"
And I close the current editor

# Gutschrift4
Given I open an editor "gutschrift-2520-4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2520"
And I set field "num4" to "2520-GS4"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I set field "kenn" to "FALL-2520"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2520-GS4"
And I close the current editor


#####################################################################################################################################

@FALL-2530
Scenario: FALL-2530
# 2530		Bestellung	3 Lieferscheine a 21Stk	
# 3 Rechnungen 3pos a 3Stk	
# 3pos Rücklieferschein	
# 1. Gutschrift	2. Gutschrift	3. Gutschrift


# Konto 2530FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2530FALL"
And I set field "such" to "FALL-2530"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2530FALL"
And I set field "such" to "FALL-2530"
And I set field "bestausekso" to "FALL-2530"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2530-FALL"
And I set field "num2" to "2530-FALL"
And I set field "such" to "FALL-2530"
And I set field "namebspr" to "FALL-2530"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2530"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2530" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2530-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2530" in row 1
And I set field "mge" to "77" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-2530"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2530-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2530-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2530"
And I set field "num4" to "2530-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "kenn" to "FALL-2530"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2530" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2530-LS1"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2530-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2530"
And I set field "num4" to "2530-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "kenn" to "FALL-2530"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2530" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2530-LS2"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2530-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2530"
And I set field "num4" to "2530-LS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "kenn" to "FALL-2530"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2530" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2530-LS3"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2530-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2530-1"
And I set field "num4" to "2530-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2530"
And I set field "mge" to "5" in row 1
And I set field "preis" to "21" in row 1
And I set field "beleg" to id from editor "lieferschein-2530-2"
And I set field "mge" to "5" in row 3
And I set field "preis" to "22" in row 3
And I set field "beleg" to id from editor "lieferschein-2530-3"
And I set field "mge" to "5" in row 5
And I set field "preis" to "23" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2530" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2530-RE1"
And I close the current editor


# Rechnung anlegen
Given I open an editor "rechnung-2530-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2530-1"
And I set field "num4" to "2530-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2530"
And I set field "mge" to "5" in row 1
And I set field "preis" to "24" in row 1
And I set field "beleg" to id from editor "lieferschein-2530-2"
And I set field "mge" to "5" in row 3
And I set field "preis" to "25" in row 3
And I set field "beleg" to id from editor "lieferschein-2530-3"
And I set field "mge" to "5" in row 5
And I set field "preis" to "26" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2530" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2530-RE2"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2530-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2530-1"
And I set field "num4" to "2530-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2530"
And I set field "mge" to "5" in row 1
And I set field "preis" to "27" in row 1
And I set field "beleg" to id from editor "lieferschein-2530-2"
And I set field "mge" to "5" in row 3
And I set field "preis" to "28" in row 3
And I set field "beleg" to id from editor "lieferschein-2530-3"
And I set field "mge" to "5" in row 5
And I set field "preis" to "29" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2530" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2530-RE3"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2530" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2530-1"
And I set field "num4" to "2530-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-17" in row 1
And I set field "beleg" to id from editor "lieferschein-2530-2"
And I set field "mge" to "-18" in row 3
And I set field "beleg" to id from editor "lieferschein-2530-3"
And I set field "mge" to "-19" in row 5
And I set field "kenn" to "FALL-2530 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2530" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2530-RLS"
And I close the current editor

# Gutschrift1
Given I open an editor "gutschrift-2530-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2530"
And I set field "num4" to "2530-GS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
# max. 1, da 6 gel aber nicht bezahlt - GS Menge zu hoch
Then setting field "mge" to "-2" in row 3 throws the exception "2022"
And I set field "mge" to "-1" in row 3
And I set field "mge" to "-2" in row 5
And I delete row at position 11
And I delete row at position 10
And I delete row at position 9
And I delete row at position 8
And I delete row at position 7
And I delete row at position 6
And I delete row at position 4
And I set field "kenn" to "FALL-2530"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2530-GS1"
And I close the current editor

# Gutschrift2
Given I open an editor "gutschrift-2530-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2530"
And I set field "num4" to "2530-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I delete row at position 8
And I delete row at position 7
And I delete row at position 5
And I delete row at position 3
And I delete row at position 2
And I delete row at position 1
And I set field "mge" to "-2" in row 3
And I set field "kenn" to "FALL-2530"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2530-GS2"
And I close the current editor

# Gutschrift3
Given I open an editor "gutschrift-2530-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2530"
And I set field "num4" to "2530-GS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I delete row at position 6
And I delete row at position 5
And I delete row at position 3
And I delete row at position 2
And I delete row at position 1
And I set field "kenn" to "FALL-2530"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2530-GS3"
And I close the current editor

#####################################################################################################################################

@FALL-2540
Scenario: FALL-2540
# 2540		Bestellung	3 Lieferscheine a 11Stk	
# 3 Rechnungen 3pos a 3Stk	
# 3pos Rücklieferschein	
# 1. Gutschrift	2. Gutschrift	3. Gutschrift

# Konto 2540FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2540FALL"
And I set field "such" to "FALL-2540"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2540FALL"
And I set field "such" to "FALL-2540"
And I set field "bestausekso" to "FALL-2540"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2540-FALL"
And I set field "num2" to "2540-FALL"
And I set field "such" to "FALL-2540"
And I set field "namebspr" to "FALL-2540"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2540"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-2540" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2540-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2540" in row 1
And I set field "mge" to "77" in row 1
And I set field "preis" to "20" in row 1
And I set field "kenn" to "FALL-2540"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2540-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2540-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2540"
And I set field "num4" to "2540-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "kenn" to "FALL-2540"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2540" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2540-LS1"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2540-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2540"
And I set field "num4" to "2540-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "kenn" to "FALL-2540"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2540" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2540-LS2"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2540-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-2540"
And I set field "num4" to "2540-LS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "21" in row 1
And I set field "kenn" to "FALL-2540"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2540" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2540-LS3"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2540-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2540-1"
And I set field "num4" to "2540-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2540"
And I set field "mge" to "5" in row 1
And I set field "preis" to "21" in row 1
And I set field "beleg" to id from editor "lieferschein-2540-2"
And I set field "mge" to "5" in row 3
And I set field "preis" to "22" in row 3
And I set field "beleg" to id from editor "lieferschein-2540-3"
And I set field "mge" to "5" in row 5
And I set field "preis" to "23" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2540" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2540-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2540-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2540-1"
And I set field "num4" to "2540-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2540"
And I set field "mge" to "5" in row 1
And I set field "preis" to "24" in row 1
And I set field "beleg" to id from editor "lieferschein-2540-2"
And I set field "mge" to "5" in row 3
And I set field "preis" to "25" in row 3
And I set field "beleg" to id from editor "lieferschein-2540-3"
And I set field "mge" to "5" in row 5
And I set field "preis" to "26" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2540" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2540-RE2"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2540-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2540-1"
And I set field "num4" to "2540-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2540"
And I set field "mge" to "5" in row 1
And I set field "preis" to "27" in row 1
And I set field "beleg" to id from editor "lieferschein-2540-2"
And I set field "mge" to "5" in row 3
And I set field "preis" to "28" in row 3
And I set field "beleg" to id from editor "lieferschein-2540-3"
And I set field "mge" to "5" in row 5
And I set field "preis" to "29" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2540" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2540-RE3"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-2540" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2540-1"
And I set field "num4" to "2540-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-17" in row 1
And I set field "beleg" to id from editor "lieferschein-2540-2"
And I set field "mge" to "-18" in row 3
And I set field "beleg" to id from editor "lieferschein-2540-3"
And I set field "mge" to "-19" in row 5
And I set field "kenn" to "FALL-2540 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-2540" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2540-RLS"
And I close the current editor

# Gutschrift1
Given I open an editor "gutschrift-2540-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2540"
And I set field "num4" to "2540-GS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
# max. 1, da 6 gel aber nicht bezahlt - GS Menge zu hoch
Then setting field "mge" to "-2" in row 3 throws the exception "2022"
And I set field "mge" to "-1" in row 3
And I set field "mge" to "-2" in row 5
And I delete row at position 11
And I delete row at position 10
And I delete row at position 9
And I delete row at position 8
And I delete row at position 7
And I delete row at position 6
And I delete row at position 4
And I set field "kenn" to "FALL-2540"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2540-GS1"
And I close the current editor

# Gutschrift2
Given I open an editor "gutschrift-2540-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2540"
And I set field "num4" to "2540-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I delete row at position 9
And I delete row at position 8
And I delete row at position 7
And I delete row at position 6
And I delete row at position 3
And I delete row at position 2
And I delete row at position 1
And I set field "kenn" to "FALL-2540"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2540-GS2"
And I close the current editor

# Gutschrift3
Given I open an editor "gutschrift-2540-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-2540"
And I set field "num4" to "2540-GS3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I delete row at position 1
And I set field "kenn" to "FALL-2540"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2540-GS3"
And I close the current editor

#####################################################################################################################################


 
#####################################################################################################################################
# 
# Hier ist dann das ENDE
# 
#  
