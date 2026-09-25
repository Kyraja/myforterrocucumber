Feature: VK_Vorgangsketten
Background: VK_Vorgangsketten.feature
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

@FALL-0010
Scenario: FALL-0010
# VK Auftrag

# Konto 0010-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0010FALL"
And I set field "such" to "FALL-0010"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0010-MG"
And I set field "such" to "FALL-0010"
And I set field "bestausekso" to "FALL-0010"
And I save the current editor

# Konto 40010-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40010FAL"
And I set field "such" to "FALL-40010"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0010-PG"
And I set field "such" to "FALL-0010"
And I set field "pgerlo" to "FALL-40010"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0010-FALL"
And I set field "num2" to "0010-FALL"
And I set field "such" to "FALL-0010"
And I set field "namebspr" to "FALL-0010"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0010-MG"
And I set field "erlgrp" to "0010-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0010" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0010-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0010" in row 1
And I set field "mge" to "0010" in row 1
And I set field "preis" to "0010" in row 1
And I set field "kenn" to "FALL-0010"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0010" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0010-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0010" in row 1
And I set field "mge" to "0010" in row 1
And I set field "preis" to "0010" in row 1
And I set field "kenn" to "FALL-0010"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0010"
And I close the current editor

#####################################################################################################################################

@FALL-0020
Scenario: FALL-0020
# VK Lieferschein

# Konto 0020-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0020FALL"
And I set field "such" to "FALL-0020"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0020-MG"
And I set field "such" to "FALL-0020"
And I set field "bestausekso" to "FALL-0020"
And I save the current editor

# Konto 40020-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40020FAL"
And I set field "such" to "FALL-40020"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0020-PG"
And I set field "such" to "FALL-0020"
And I set field "pgerlo" to "FALL-40020"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0020-FALL"
And I set field "num2" to "0020-FALL"
And I set field "such" to "FALL-0020"
And I set field "namebspr" to "FALL-0020"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0020-MG"
And I set field "erlgrp" to "0020-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0020" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0020-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0020" in row 1
And I set field "mge" to "0020" in row 1
And I set field "preis" to "0020" in row 1
And I set field "kenn" to "FALL-0020"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0020" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0020-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0020" in row 1
And I set field "mge" to "0020" in row 1
And I set field "preis" to "0020" in row 1
And I set field "kenn" to "FALL-0020"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0020"
And I close the current editor

#####################################################################################################################################

@FALL-0030
Scenario: FALL-0030
# VK Lieferschein "Rechnung aus Lieferschein" nein

# Konto 0030-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0030FALL"
And I set field "such" to "FALL-0030"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0030-MG"
And I set field "such" to "FALL-0030"
And I set field "bestausekso" to "FALL-0030"
And I save the current editor

# Konto 40030-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40030FAL"
And I set field "such" to "FALL-40030"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0030-PG"
And I set field "such" to "FALL-0030"
And I set field "pgerlo" to "FALL-40030"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0030-FALL"
And I set field "num2" to "0030-FALL"
And I set field "such" to "FALL-0030"
And I set field "namebspr" to "FALL-0030"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0030-MG"
And I set field "erlgrp" to "0030-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0030" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0030-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0030" in row 1
And I set field "mge" to "0030" in row 1
And I set field "preis" to "0030" in row 1
And I set field "kenn" to "FALL-0030"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0030" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0030-LS"
And setting field "fakt" to "nein" throws the exception "203"
And I close the current editor

#####################################################################################################################################

@FALL-0040
Scenario: FALL-0040
# VK Rechnung mit Lager

# Konto 0040-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0040FALL"
And I set field "such" to "FALL-0040"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0040-MG"
And I set field "such" to "FALL-0040"
And I set field "bestausekso" to "FALL-0040"
And I save the current editor

# Konto 40040-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40040FAL"
And I set field "such" to "FALL-40040"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0040-PG"
And I set field "such" to "FALL-0040"
And I set field "pgerlo" to "FALL-40040"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0040-FALL"
And I set field "num2" to "0040-FALL"
And I set field "such" to "FALL-0040"
And I set field "namebspr" to "FALL-0040"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0040-MG"
And I set field "erlgrp" to "0040-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0040" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0040-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0040" in row 1
And I set field "mge" to "0040" in row 1
And I set field "preis" to "0040" in row 1
And I set field "kenn" to "FALL-0040"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0040" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0040-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0040" in row 1
And I set field "mge" to "0040" in row 1
And I set field "preis" to "0040" in row 1
And I set field "kenn" to "FALL-0040"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0040"
And I close the current editor

#####################################################################################################################################

@FALL-0050
Scenario: FALL-0050
# VK Rechnung ohne Lager

# Konto 0050-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0050FALL"
And I set field "such" to "FALL-0050"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0050-MG"
And I set field "such" to "FALL-0050"
And I set field "bestausekso" to "FALL-0050"
And I save the current editor

# Konto 40050-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40050FAL"
And I set field "such" to "FALL-40050"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0050-PG"
And I set field "such" to "FALL-0050"
And I set field "pgerlo" to "FALL-40050"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0050-FALL"
And I set field "num2" to "0050-FALL"
And I set field "such" to "FALL-0050"
And I set field "namebspr" to "FALL-0050"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0050-MG"
And I set field "erlgrp" to "0050-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0050" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0050-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0050" in row 1
And I set field "mge" to "0050" in row 1
And I set field "preis" to "0050" in row 1
And I set field "kenn" to "FALL-0050"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0050" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0050-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0050" in row 1
And I set field "mge" to "0050" in row 1
And I set field "preis" to "0050" in row 1
And I set field "kenn" to "FALL-0050"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0050"
And I close the current editor

#####################################################################################################################################

@FALL-0060
Scenario: FALL-0060
# VK Gutschrift ohne Lager

# Konto 0060-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0060FALL"
And I set field "such" to "FALL-0060"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0060-MG"
And I set field "such" to "FALL-0060"
And I set field "bestausekso" to "FALL-0060"
And I save the current editor

# Konto 40060-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40060FAL"
And I set field "such" to "FALL-40060"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0060-PG"
And I set field "such" to "FALL-0060"
And I set field "pgerlo" to "FALL-40060"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0060-FALL"
And I set field "num2" to "0060-FALL"
And I set field "such" to "FALL-0060"
And I set field "namebspr" to "FALL-0060"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0060-MG"
And I set field "erlgrp" to "0060-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0060" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0060-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0060" in row 1
And I set field "mge" to "0060" in row 1
And I set field "preis" to "0060" in row 1
And I set field "kenn" to "FALL-0060"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0060" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0060-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0060" in row 1
And I set field "mge" to "0060" in row 1
And I set field "preis" to "-0060" in row 1
And I set field "kenn" to "FALL-0060"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0060"
And I close the current editor

#####################################################################################################################################

@FALL-0100
Scenario: FALL-0100
# VK Auftrag Lieferschein

# Konto 0100-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0100FALL"
And I set field "such" to "FALL-0100"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0100-MG"
And I set field "such" to "FALL-0100"
And I set field "bestausekso" to "FALL-0100"
And I save the current editor

# Konto 40100-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40100FAL"
And I set field "such" to "FALL-40100"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0100-PG"
And I set field "such" to "FALL-0100"
And I set field "pgerlo" to "FALL-40100"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0100-FALL"
And I set field "num2" to "0100-FALL"
And I set field "such" to "FALL-0100"
And I set field "namebspr" to "FALL-0100"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0100-MG"
And I set field "erlgrp" to "0100-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0100" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0100-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0100" in row 1
And I set field "mge" to "0100" in row 1
And I set field "preis" to "0100" in row 1
And I set field "kenn" to "FALL-0100"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0100" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0100-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0100" in row 1
And I set field "mge" to "0100" in row 1
And I set field "preis" to "0100" in row 1
And I set field "kenn" to "FALL-0100"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0100"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0100" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0100"
And I set field "num3" to "0100-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0100" in row 1
And I set field "kenn" to "FALL-0100"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0100"
And I close the current editor

#####################################################################################################################################

@FALL-0110
Scenario: FALL-0110
# VK Auftrag Lieferschein Storno-Lieferschein

# Konto 0110-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0110FALL"
And I set field "such" to "FALL-0110"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0110-MG"
And I set field "such" to "FALL-0110"
And I set field "bestausekso" to "FALL-0110"
And I save the current editor

# Konto 40110-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40110FAL"
And I set field "such" to "FALL-40110"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0110-PG"
And I set field "such" to "FALL-0110"
And I set field "pgerlo" to "FALL-40110"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0110-FALL"
And I set field "num2" to "0110-FALL"
And I set field "such" to "FALL-0110"
And I set field "namebspr" to "FALL-0110"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0110-MG"
And I set field "erlgrp" to "0110-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0110" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0110-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0110" in row 1
And I set field "mge" to "0110" in row 1
And I set field "preis" to "0110" in row 1
And I set field "kenn" to "FALL-0110"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0110" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0110-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0110" in row 1
And I set field "mge" to "0110" in row 1
And I set field "preis" to "0110" in row 1
And I set field "kenn" to "FALL-0110"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0110"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0110" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0110"
And I set field "num3" to "0110-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0110" in row 1
And I set field "kenn" to "FALL-0110"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0110"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0110" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0110"
And I set field "num3" to "0110-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0110"
And I close the current editor

#####################################################################################################################################

@FALL-0120
Scenario: FALL-0120
# VK Auftrag Lieferschein Storno-Lieferschein Lieferschein

# Konto 0120-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0120FALL"
And I set field "such" to "FALL-0120"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0120-MG"
And I set field "such" to "FALL-0120"
And I set field "bestausekso" to "FALL-0120"
And I save the current editor

# Konto 40120-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40120FAL"
And I set field "such" to "FALL-40120"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0120-PG"
And I set field "such" to "FALL-0120"
And I set field "pgerlo" to "FALL-40120"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0120-FALL"
And I set field "num2" to "0120-FALL"
And I set field "such" to "FALL-0120"
And I set field "namebspr" to "FALL-0120"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0120-MG"
And I set field "erlgrp" to "0120-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0120" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0120-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0120" in row 1
And I set field "mge" to "0120" in row 1
And I set field "preis" to "0120" in row 1
And I set field "kenn" to "FALL-0120"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0120" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0120-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0120" in row 1
And I set field "mge" to "0120" in row 1
And I set field "preis" to "0120" in row 1
And I set field "kenn" to "FALL-0120"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0120"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0120" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0120"
And I set field "num3" to "0120-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0120" in row 1
And I set field "kenn" to "FALL-0120"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0120"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0120" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0120"
And I set field "num3" to "0120-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0120"
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein2-0120" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0120"
And I set field "num3" to "0120-LS2"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0120" in row 1
And I set field "kenn" to "FALL-0120"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein2-0120"
And I close the current editor

#####################################################################################################################################

@FALL-0130
Scenario: FALL-0130
# VK Auftrag Lieferschein Storno-Lieferschein Rechnung ohne Lager

# Konto 0130-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0130FALL"
And I set field "such" to "FALL-0130"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0130-MG"
And I set field "such" to "FALL-0130"
And I set field "bestausekso" to "FALL-0130"
And I save the current editor

# Konto 40130-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40130FAL"
And I set field "such" to "FALL-40130"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0130-PG"
And I set field "such" to "FALL-0130"
And I set field "pgerlo" to "FALL-40130"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0130-FALL"
And I set field "num2" to "0130-FALL"
And I set field "such" to "FALL-0130"
And I set field "namebspr" to "FALL-0130"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0130-MG"
And I set field "erlgrp" to "0130-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0130" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0130-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0130" in row 1
And I set field "mge" to "0130" in row 1
And I set field "preis" to "0130" in row 1
And I set field "kenn" to "FALL-0130"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0130" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0130-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0130" in row 1
And I set field "mge" to "0130" in row 1
And I set field "preis" to "0130" in row 1
And I set field "kenn" to "FALL-0130"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0130"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0130" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0130"
And I set field "num3" to "0130-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0130" in row 1
And I set field "kenn" to "FALL-0130"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0130"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0130" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0130"
And I set field "num3" to "0130-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0130"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0130" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0130"
And I set field "kunde" to "1"
And I set field "num3" to "0130-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0130" in row 1
And I set field "preis" to "0130" in row 1
And I set field "kenn" to "FALL-0130"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0130"
And I close the current editor

#####################################################################################################################################

@FALL-0140
Scenario: FALL-0140
# VK Auftrag Lieferschein Storno-Lieferschein Rechnung mit Lager

# Konto 0140-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0140FALL"
And I set field "such" to "FALL-0140"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0140-MG"
And I set field "such" to "FALL-0140"
And I set field "bestausekso" to "FALL-0140"
And I save the current editor

# Konto 40140-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40140FAL"
And I set field "such" to "FALL-40140"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0140-PG"
And I set field "such" to "FALL-0140"
And I set field "pgerlo" to "FALL-40140"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0140-FALL"
And I set field "num2" to "0140-FALL"
And I set field "such" to "FALL-0140"
And I set field "namebspr" to "FALL-0140"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0140-MG"
And I set field "erlgrp" to "0140-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0140" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0140-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0140" in row 1
And I set field "mge" to "0140" in row 1
And I set field "preis" to "0140" in row 1
And I set field "kenn" to "FALL-0140"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0140" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0140-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0140" in row 1
And I set field "mge" to "0140" in row 1
And I set field "preis" to "0140" in row 1
And I set field "kenn" to "FALL-0140"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0140"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0140" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0140"
And I set field "num3" to "0140-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0140" in row 1
And I set field "kenn" to "FALL-0140"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0140"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0140" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0140"
And I set field "num3" to "0140-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0140"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0140" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0140"
And I set field "kunde" to "1"
And I set field "num3" to "0140-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0140" in row 1
And I set field "preis" to "0140" in row 1
And I set field "kenn" to "FALL-0140"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0140"
And I close the current editor

#####################################################################################################################################

@FALL-0150
Scenario: FALL-0150
# VK Auftrag Lieferschein Rechnung ohne Lager

# Konto 0150-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0150FALL"
And I set field "such" to "FALL-0150"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0150-MG"
And I set field "such" to "FALL-0150"
And I set field "bestausekso" to "FALL-0150"
And I save the current editor

# Konto 40150-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40150FAL"
And I set field "such" to "FALL-40150"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0150-PG"
And I set field "such" to "FALL-0150"
And I set field "pgerlo" to "FALL-40150"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0150-FALL"
And I set field "num2" to "0150-FALL"
And I set field "such" to "FALL-0150"
And I set field "namebspr" to "FALL-0150"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0150-MG"
And I set field "erlgrp" to "0150-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0150" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0150-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0150" in row 1
And I set field "mge" to "0150" in row 1
And I set field "preis" to "0150" in row 1
And I set field "kenn" to "FALL-0150"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0150" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0150-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0150" in row 1
And I set field "mge" to "0150" in row 1
And I set field "preis" to "0150" in row 1
And I set field "kenn" to "FALL-0150"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0150"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0150" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0150"
And I set field "num3" to "0150-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0150" in row 1
And I set field "kenn" to "FALL-0150"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0150"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0150" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0150"
And I set field "kunde" to "1"
And I set field "num3" to "0150-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0150" in row 1
And I set field "preis" to "0150" in row 1
And I set field "kenn" to "FALL-0150"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0150"
And I close the current editor

#####################################################################################################################################

@FALL-0160
Scenario: FALL-0160
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager

# Konto 0160-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0160FALL"
And I set field "such" to "FALL-0160"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0160-MG"
And I set field "such" to "FALL-0160"
And I set field "bestausekso" to "FALL-0160"
And I save the current editor

# Konto 40160-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40160FAL"
And I set field "such" to "FALL-40160"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0160-PG"
And I set field "such" to "FALL-0160"
And I set field "pgerlo" to "FALL-40160"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0160-FALL"
And I set field "num2" to "0160-FALL"
And I set field "such" to "FALL-0160"
And I set field "namebspr" to "FALL-0160"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0160-MG"
And I set field "erlgrp" to "0160-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0160" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0160-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0160" in row 1
And I set field "mge" to "0160" in row 1
And I set field "preis" to "0160" in row 1
And I set field "kenn" to "FALL-0160"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0160" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0160-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0160" in row 1
And I set field "mge" to "0160" in row 1
And I set field "preis" to "0160" in row 1
And I set field "kenn" to "FALL-0160"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0160"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0160" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0160"
And I set field "num3" to "0160-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0160" in row 1
And I set field "kenn" to "FALL-0160"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0160"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0160" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0160"
And I set field "kunde" to "1"
And I set field "num3" to "0160-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0160" in row 1
And I set field "preis" to "0160" in row 1
And I set field "kenn" to "FALL-0160"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0160"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0160" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0160"
And I set field "num3" to "0160-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0160"
And I close the current editor

#####################################################################################################################################

@FALL-0170
Scenario: FALL-0170
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rechnung ohne Lagerbewegung

# Konto 0170-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0170FALL"
And I set field "such" to "FALL-0170"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0170-MG"
And I set field "such" to "FALL-0170"
And I set field "bestausekso" to "FALL-0170"
And I save the current editor

# Konto 40170-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40170FAL"
And I set field "such" to "FALL-40170"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0170-PG"
And I set field "such" to "FALL-0170"
And I set field "pgerlo" to "FALL-40170"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0170-FALL"
And I set field "num2" to "0170-FALL"
And I set field "such" to "FALL-0170"
And I set field "namebspr" to "FALL-0170"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0170-MG"
And I set field "erlgrp" to "0170-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0170" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0170-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0170" in row 1
And I set field "mge" to "0170" in row 1
And I set field "preis" to "0170" in row 1
And I set field "kenn" to "FALL-0170"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0170" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0170-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0170" in row 1
And I set field "mge" to "0170" in row 1
And I set field "preis" to "0170" in row 1
And I set field "kenn" to "FALL-0170"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0170"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0170" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0170"
And I set field "num3" to "0170-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0170" in row 1
And I set field "kenn" to "FALL-0170"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0170"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0170" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0170"
And I set field "kunde" to "1"
And I set field "num3" to "0170-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0170" in row 1
And I set field "preis" to "0170" in row 1
And I set field "kenn" to "FALL-0170"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0170"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0170" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0170"
And I set field "num3" to "0170-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0170"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "Rechnung2-0170" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0170"
And I set field "kunde" to "1"
And I set field "num3" to "0170-RE2"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0170" in row 1
And I set field "preis" to "0170" in row 1
And I set field "kenn" to "FALL-0170"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Rechnung2-0170"
And I close the current editor

#####################################################################################################################################

@FALL-0180
Scenario: FALL-0180
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Storno-Lieferschein

# Konto 0180-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0180FALL"
And I set field "such" to "FALL-0180"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0180-MG"
And I set field "such" to "FALL-0180"
And I set field "bestausekso" to "FALL-0180"
And I save the current editor

# Konto 40180-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40180FAL"
And I set field "such" to "FALL-40180"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0180-PG"
And I set field "such" to "FALL-0180"
And I set field "pgerlo" to "FALL-40180"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0180-FALL"
And I set field "num2" to "0180-FALL"
And I set field "such" to "FALL-0180"
And I set field "namebspr" to "FALL-0180"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0180-MG"
And I set field "erlgrp" to "0180-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0180" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0180-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0180" in row 1
And I set field "mge" to "0180" in row 1
And I set field "preis" to "0180" in row 1
And I set field "kenn" to "FALL-0180"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0180" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0180-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0180" in row 1
And I set field "mge" to "0180" in row 1
And I set field "preis" to "0180" in row 1
And I set field "kenn" to "FALL-0180"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0180"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0180" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0180"
And I set field "num3" to "0180-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0180" in row 1
And I set field "kenn" to "FALL-0180"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0180"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0180" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0180"
And I set field "kunde" to "1"
And I set field "num3" to "0180-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0180" in row 1
And I set field "preis" to "0180" in row 1
And I set field "kenn" to "FALL-0180"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0180"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0180" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0180"
And I set field "num3" to "0180-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0180"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0180" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0180"
And I set field "num3" to "0180-SLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0180"
And I close the current editor

#####################################################################################################################################

@FALL-0190
Scenario: FALL-0190
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Storno-Lieferschein Lieferschein

# Konto 0190-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0190FALL"
And I set field "such" to "FALL-0190"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0190-MG"
And I set field "such" to "FALL-0190"
And I set field "bestausekso" to "FALL-0190"
And I save the current editor

# Konto 40190-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40190FAL"
And I set field "such" to "FALL-40190"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0190-PG"
And I set field "such" to "FALL-0190"
And I set field "pgerlo" to "FALL-40190"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0190-FALL"
And I set field "num2" to "0190-FALL"
And I set field "such" to "FALL-0190"
And I set field "namebspr" to "FALL-0190"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0190-MG"
And I set field "erlgrp" to "0190-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0190" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0190-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0190" in row 1
And I set field "mge" to "0190" in row 1
And I set field "preis" to "0190" in row 1
And I set field "kenn" to "FALL-0190"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0190" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0190-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0190" in row 1
And I set field "mge" to "0190" in row 1
And I set field "preis" to "0190" in row 1
And I set field "kenn" to "FALL-0190"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0190"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0190" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0190"
And I set field "num3" to "0190-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0190" in row 1
And I set field "kenn" to "FALL-0190"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0190"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0190" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0190"
And I set field "kunde" to "1"
And I set field "num3" to "0190-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0190" in row 1
And I set field "preis" to "0190" in row 1
And I set field "kenn" to "FALL-0190"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0190"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0190" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0190"
And I set field "num3" to "0190-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0190"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0190" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0190"
And I set field "num3" to "0190-SLS"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0190"
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein2-0190" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0190"
And I set field "num3" to "0190-LS2"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0190" in row 1
And I set field "kenn" to "FALL-0190"
And I save the current editor

# Ausgabe Lieferschein2
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein2-0190"
And I close the current editor

#####################################################################################################################################

@FALL-0200
Scenario: FALL-0200
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein

# Konto 0200-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0200FALL"
And I set field "such" to "FALL-0200"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0200-MG"
And I set field "such" to "FALL-0200"
And I set field "bestausekso" to "FALL-0200"
And I save the current editor

# Konto 40200-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40200FAL"
And I set field "such" to "FALL-40200"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0200-PG"
And I set field "such" to "FALL-0200"
And I set field "pgerlo" to "FALL-40200"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0200-FALL"
And I set field "num2" to "0200-FALL"
And I set field "such" to "FALL-0200"
And I set field "namebspr" to "FALL-0200"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0200-MG"
And I set field "erlgrp" to "0200-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0200" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0200-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0200" in row 1
And I set field "mge" to "0200" in row 1
And I set field "preis" to "0200" in row 1
And I set field "kenn" to "FALL-0200"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0200" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0200-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0200" in row 1
And I set field "mge" to "0200" in row 1
And I set field "preis" to "0200" in row 1
And I set field "kenn" to "FALL-0200"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0200"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0200" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0200"
And I set field "num3" to "0200-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0200" in row 1
And I set field "kenn" to "FALL-0200"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0200"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0200" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0200"
And I set field "kunde" to "1"
And I set field "num3" to "0200-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0200" in row 1
And I set field "preis" to "0200" in row 1
And I set field "kenn" to "FALL-0200"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0200"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0200" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0200"
And I set field "num3" to "0200-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0200 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0200"
And I close the current editor

#####################################################################################################################################

@FALL-0210
Scenario: FALL-0210
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein

# Konto 0210-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0210FALL"
And I set field "such" to "FALL-0210"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0210-MG"
And I set field "such" to "FALL-0210"
And I set field "bestausekso" to "FALL-0210"
And I save the current editor

# Konto 40210-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40210FAL"
And I set field "such" to "FALL-40210"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0210-PG"
And I set field "such" to "FALL-0210"
And I set field "pgerlo" to "FALL-40210"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0210-FALL"
And I set field "num2" to "0210-FALL"
And I set field "such" to "FALL-0210"
And I set field "namebspr" to "FALL-0210"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0210-MG"
And I set field "erlgrp" to "0210-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0210" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0210-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0210" in row 1
And I set field "mge" to "0210" in row 1
And I set field "preis" to "0210" in row 1
And I set field "kenn" to "FALL-0210"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0210" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0210-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0210" in row 1
And I set field "mge" to "0210" in row 1
And I set field "preis" to "0210" in row 1
And I set field "kenn" to "FALL-0210"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0210"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0210" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0210"
And I set field "num3" to "0210-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0210" in row 1
And I set field "kenn" to "FALL-0210"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0210"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0210" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0210"
And I set field "kunde" to "1"
And I set field "num3" to "0210-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0210" in row 1
And I set field "preis" to "0210" in row 1
And I set field "kenn" to "FALL-0210"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0210"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0210" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0210"
And I set field "num3" to "0210-RLS"
And I set field "vom" to "."
Then field "kunde" is not modifiable
Then field "kl2" is not modifiable
Then field "kunde3" is not modifiable
Then field "vstaat" is modifiable
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "proz" to "0" in row 1
And I set field "pwert" to "-6510" in row 1
And I set field "fixpwert" to "ja" in row 1
And I set field "artprg" to "0210-FALL" in row 1
And I set field "artrab" to "0210-FALL" in row 1
And I set field "konddat" to "+3" in row 1
And I set field "lehe" to "1" in row 1
And I set field "pehe" to "1" in row 1
And I set field "konto" to "40210FAL" in row 1
And I set field "kenn" to "FALL-0210 Ruecklieferschein"
And I save the current editor

Given I open an editor "rls-0210-aendern" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "0210-RLS"
And I set field "ueb" to "ja"
Then field "kunde" is not modifiable
Then field "kl2" is not modifiable
Then field "kunde3" is not modifiable
Then field "vstaat" is modifiable
Then the table has 1 rows
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "proz" to "0" in row 1
And I set field "pwert" to "-6510" in row 1
And I set field "fixpwert" to "ja" in row 1
And I set field "artprg" to "0210-FALL" in row 1
And I set field "artrab" to "0210-FALL" in row 1
And I set field "konddat" to "+3" in row 1
And I set field "lehe" to "1" in row 1
And I set field "pehe" to "1" in row 1
And I set field "konto" to "40210FAL" in row 1
And I set field "kenn" to "FALL-0210 Ruecklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0210-aendern"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0210" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0210"
And I set field "num3" to "0210-GS"
And I set field "vom" to "."
Then field "kunde" is not modifiable
Then field "kl2" is not modifiable
Then field "kunde3" is not modifiable
Then field "vstaat" is modifiable
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0210" in row 1
And I set field "preis" to "210" in row 1
And I set field "proz" to "0" in row 1
And I set field "pwert" to "-6510" in row 1
And I set field "fixpwert" to "ja" in row 1
And I set field "artprg" to "0210-FALL" in row 1
And I set field "artrab" to "0210-FALL" in row 1
And I set field "konddat" to "+3" in row 1
And I set field "lehe" to "1" in row 1
And I set field "pehe" to "1" in row 1
Then field "zrahmen" is not modifiable in row 1
And I set field "zignrahmen" to "nein" in row 1
Then field "konto" is modifiable in row 1
And I set field "kenn" to "FALL-0210"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Kaufm. Gutschrift aendern
Given I open an editor "gutschrift-0210" from table "(Sales):(Invoice)" with command "UPDATE" for record "0210-GS"
And I set field "ueb" to "ja"
Then field "kl" is not modifiable
Then field "kl2" is not modifiable
Then field "vstaat" is modifiable
Then field "warenempf" is not modifiable
Then the table has 4 rows
And I set field "preis" to "210" in row 1
And I set field "proz" to "0" in row 1
And I set field "pwert" to "-6510" in row 1
And I set field "fixpwert" to "ja" in row 1
And I set field "artprg" to "0210-FALL" in row 1
And I set field "artrab" to "0210-FALL" in row 1
And I set field "konddat" to "+3" in row 1
And I set field "lehe" to "1" in row 1
And I set field "pehe" to "1" in row 1
Then field "zrahmen" is not modifiable in row 1
And I set field "zignrahmen" to "nein" in row 1
Then field "konto" is modifiable in row 1
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0210"
And I close the current editor

#####################################################################################################################################

@FALL-0220
Scenario: FALL-0220
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift

# Konto 0220-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0220FALL"
And I set field "such" to "FALL-0220"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0220-MG"
And I set field "such" to "FALL-0220"
And I set field "bestausekso" to "FALL-0220"
And I save the current editor

# Konto 40220-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40220FAL"
And I set field "such" to "FALL-40220"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0220-PG"
And I set field "such" to "FALL-0220"
And I set field "pgerlo" to "FALL-40220"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0220-FALL"
And I set field "num2" to "0220-FALL"
And I set field "such" to "FALL-0220"
And I set field "namebspr" to "FALL-0220"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0220-MG"
And I set field "erlgrp" to "0220-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0220" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0220-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0220" in row 1
And I set field "mge" to "0220" in row 1
And I set field "preis" to "0220" in row 1
And I set field "kenn" to "FALL-0220"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0220" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0220-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0220" in row 1
And I set field "mge" to "0220" in row 1
And I set field "preis" to "0220" in row 1
And I set field "kenn" to "FALL-0220"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0220"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0220" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0220"
And I set field "num3" to "0220-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0220" in row 1
And I set field "kenn" to "FALL-0220"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0220"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0220" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0220"
And I set field "kunde" to "1"
And I set field "num3" to "0220-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0220" in row 1
And I set field "preis" to "0220" in row 1
And I set field "kenn" to "FALL-0220"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0220"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0220" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0220"
And I set field "num3" to "0220-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0220 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0220"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0220" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0220"
And I set field "num3" to "0220-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0220" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0220"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0220"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0220" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0220"
And I set field "num3" to "0220-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0220"
And I close the current editor

#####################################################################################################################################

@FALL-0230
Scenario: FALL-0230
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein

# Konto 0230-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0230FALL"
And I set field "such" to "FALL-0230"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0230-MG"
And I set field "such" to "FALL-0230"
And I set field "bestausekso" to "FALL-0230"
And I save the current editor

# Konto 40230-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40230FAL"
And I set field "such" to "FALL-40230"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0230-PG"
And I set field "such" to "FALL-0230"
And I set field "pgerlo" to "FALL-40230"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0230-FALL"
And I set field "num2" to "0230-FALL"
And I set field "such" to "FALL-0230"
And I set field "namebspr" to "FALL-0230"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0230-MG"
And I set field "erlgrp" to "0230-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0230" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0230-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0230" in row 1
And I set field "mge" to "0230" in row 1
And I set field "preis" to "0230" in row 1
And I set field "kenn" to "FALL-0230"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0230" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0230-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0230" in row 1
And I set field "mge" to "0230" in row 1
And I set field "preis" to "0230" in row 1
And I set field "kenn" to "FALL-0230"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0230"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0230" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0230"
And I set field "num3" to "0230-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0230" in row 1
And I set field "kenn" to "FALL-0230"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0230"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0230" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0230"
And I set field "kunde" to "1"
And I set field "num3" to "0230-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0230" in row 1
And I set field "preis" to "0230" in row 1
And I set field "kenn" to "FALL-0230"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0230"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0230" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0230"
And I set field "num3" to "0230-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0230 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0230"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0230" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0230"
And I set field "num3" to "0230-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0230" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0230"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0230"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0230" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0230"
And I set field "num3" to "0230-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0230"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0230" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0230"
And I set field "num3" to "0230-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0230"
And I close the current editor

#####################################################################################################################################

@FALL-0240
Scenario: FALL-0240
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Rücklieferschein

# Konto 0240-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0240FALL"
And I set field "such" to "FALL-0240"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0240-MG"
And I set field "such" to "FALL-0240"
And I set field "bestausekso" to "FALL-0240"
And I save the current editor

# Konto 40240-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40240FAL"
And I set field "such" to "FALL-40240"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0240-PG"
And I set field "such" to "FALL-0240"
And I set field "pgerlo" to "FALL-40240"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0240-FALL"
And I set field "num2" to "0240-FALL"
And I set field "such" to "FALL-0240"
And I set field "namebspr" to "FALL-0240"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0240-MG"
And I set field "erlgrp" to "0240-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0240" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0240-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0240" in row 1
And I set field "mge" to "0240" in row 1
And I set field "preis" to "0240" in row 1
And I set field "kenn" to "FALL-0240"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0240" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0240-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0240" in row 1
And I set field "mge" to "0240" in row 1
And I set field "preis" to "0240" in row 1
And I set field "kenn" to "FALL-0240"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0240"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0240" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0240"
And I set field "num3" to "0240-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0240" in row 1
And I set field "kenn" to "FALL-0240"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0240"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0240" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0240"
And I set field "kunde" to "1"
And I set field "num3" to "0240-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0240" in row 1
And I set field "preis" to "0240" in row 1
And I set field "kenn" to "FALL-0240"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0240"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0240" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0240"
And I set field "num3" to "0240-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0240 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0240"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0240" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0240"
And I set field "num3" to "0240-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0240" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0240"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0240"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0240" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0240"
And I set field "num3" to "0240-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0240"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0240" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0240"
And I set field "num3" to "0240-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0240"
And I close the current editor

# Rücklieferschein2 anlegen
Given I open an editor "Ruecklieferschein2-0240" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0240"
And I set field "num3" to "0240-RL2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0240 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein 2
Given I open an editor "Ruecklieferschein2-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein2-0240"
And I close the current editor

#####################################################################################################################################

@FALL-0250
Scenario: FALL-0250
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno-Rechnung

# Konto 0250-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0250FALL"
And I set field "such" to "FALL-0250"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0250-MG"
And I set field "such" to "FALL-0250"
And I set field "bestausekso" to "FALL-0250"
And I save the current editor

# Konto 40250-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40250FAL"
And I set field "such" to "FALL-40250"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0250-PG"
And I set field "such" to "FALL-0250"
And I set field "pgerlo" to "FALL-40250"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0250-FALL"
And I set field "num2" to "0250-FALL"
And I set field "such" to "FALL-0250"
And I set field "namebspr" to "FALL-0250"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0250-MG"
And I set field "erlgrp" to "0250-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0250" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0250-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0250" in row 1
And I set field "mge" to "0250" in row 1
And I set field "preis" to "0250" in row 1
And I set field "kenn" to "FALL-0250"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0250" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0250-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0250" in row 1
And I set field "mge" to "0250" in row 1
And I set field "preis" to "0250" in row 1
And I set field "kenn" to "FALL-0250"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0250"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0250" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0250"
And I set field "num3" to "0250-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0250" in row 1
And I set field "kenn" to "FALL-0250"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0250"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0250" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0250"
And I set field "kunde" to "1"
And I set field "num3" to "0250-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0250" in row 1
And I set field "preis" to "0250" in row 1
And I set field "kenn" to "FALL-0250"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0250"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0250" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0250"
And I set field "num3" to "0250-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0250 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0250"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0250" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0250"
And I set field "num3" to "0250-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0250" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0250"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0250"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0250" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0250"
And I set field "num3" to "0250-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0250"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0250" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0250"
And I set field "num3" to "0250-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rls-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0250"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0250" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0250"
And I set field "num3" to "0250-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0250"
And I close the current editor

#####################################################################################################################################

@FALL-0260
Scenario: FALL-0260
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein
# Storno-Rechnung Storno-Lieferschein

# Konto 0260-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0260FALL"
And I set field "such" to "FALL-0260"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0260-MG"
And I set field "such" to "FALL-0260"
And I set field "bestausekso" to "FALL-0260"
And I save the current editor

# Konto 40260-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40260FAL"
And I set field "such" to "FALL-40260"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0260-PG"
And I set field "such" to "FALL-0260"
And I set field "pgerlo" to "FALL-40260"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0260-FALL"
And I set field "num2" to "0260-FALL"
And I set field "such" to "FALL-0260"
And I set field "namebspr" to "FALL-0260"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0260-MG"
And I set field "erlgrp" to "0260-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0260" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0260-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0260" in row 1
And I set field "mge" to "0260" in row 1
And I set field "preis" to "0260" in row 1
And I set field "kenn" to "FALL-0260"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0260" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0260-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0260" in row 1
And I set field "mge" to "0260" in row 1
And I set field "preis" to "0260" in row 1
And I set field "kenn" to "FALL-0260"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0260"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0260" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0260"
And I set field "num3" to "0260-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0260" in row 1
And I set field "kenn" to "FALL-0260"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0260"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0260" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0260"
And I set field "kunde" to "1"
And I set field "num3" to "0260-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0260" in row 1
And I set field "preis" to "0260" in row 1
And I set field "kenn" to "FALL-0260"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0260"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0260" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0260"
And I set field "num3" to "0260-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0260 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0260"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0260" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0260"
And I set field "num3" to "0260-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0260" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0260"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0260"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0260" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0260"
And I set field "num3" to "0260-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0260"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0260" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0260"
And I set field "num3" to "0260-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rls-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0260"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0260" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0260"
And I set field "num3" to "0260-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0260"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0260" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0260"
And I set field "num3" to "0260-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0260"
And I close the current editor

#####################################################################################################################################

@FALL-0270
Scenario: FALL-0270
# VK	Auftrag	Lieferschein	Rechnung ohne Lager	Rücklieferschein	Gutschrift	Storno-Gutschrift	Gutschrift

# Konto 0270-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0270FALL"
And I set field "such" to "FALL-0270"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0270-MG"
And I set field "such" to "FALL-0270"
And I set field "bestausekso" to "FALL-0270"
And I save the current editor

# Konto 40270-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40270FAL"
And I set field "such" to "FALL-40270"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0270-PG"
And I set field "such" to "FALL-0270"
And I set field "pgerlo" to "FALL-40270"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0270-FALL"
And I set field "num2" to "0270-FALL"
And I set field "such" to "FALL-0270"
And I set field "namebspr" to "FALL-0270"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0270-MG"
And I set field "erlgrp" to "0270-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0270" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0270-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0270" in row 1
And I set field "mge" to "0270" in row 1
And I set field "preis" to "0270" in row 1
And I set field "kenn" to "FALL-0270"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0270" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0270-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0270" in row 1
And I set field "mge" to "0270" in row 1
And I set field "preis" to "0270" in row 1
And I set field "kenn" to "FALL-0270"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0270"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0270" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0270"
And I set field "num3" to "0270-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0270" in row 1
And I set field "kenn" to "FALL-0270"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0270"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0270" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0270"
And I set field "kunde" to "1"
And I set field "num3" to "0270-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0270" in row 1
And I set field "preis" to "0270" in row 1
And I set field "kenn" to "FALL-0270"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0270"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0270" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0270"
And I set field "num3" to "0270-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0270 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0270"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0270" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0270"
And I set field "num3" to "0270-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0270" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0270"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0270"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0270" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0270"
And I set field "num3" to "0270-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0270"
And I close the current editor

# Gutschrift2 anlegen
Given I open an editor "Gutschrift2-0270" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0270"
And I set field "num3" to "0270-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0270" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0270"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift2
Given I open an editor "Gutschrift2-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift2-0270"
And I close the current editor

#####################################################################################################################################

@FALL-0280
Scenario: FALL-0280
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein

# Konto 0280-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0280FALL"
And I set field "such" to "FALL-0280"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0280-MG"
And I set field "such" to "FALL-0280"
And I set field "bestausekso" to "FALL-0280"
And I save the current editor

# Konto 40280-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40280FAL"
And I set field "such" to "FALL-40280"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0280-PG"
And I set field "such" to "FALL-0280"
And I set field "pgerlo" to "FALL-40280"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0280-FALL"
And I set field "num2" to "0280-FALL"
And I set field "such" to "FALL-0280"
And I set field "namebspr" to "FALL-0280"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0280-MG"
And I set field "erlgrp" to "0280-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0280" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0280-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0280" in row 1
And I set field "mge" to "0280" in row 1
And I set field "preis" to "0280" in row 1
And I set field "kenn" to "FALL-0280"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0280" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0280-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0280" in row 1
And I set field "mge" to "0280" in row 1
And I set field "preis" to "0280" in row 1
And I set field "kenn" to "FALL-0280"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0280"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0280" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0280"
And I set field "num3" to "0280-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0280" in row 1
And I set field "kenn" to "FALL-0280"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0280"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0280" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0280"
And I set field "kunde" to "1"
And I set field "num3" to "0280-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0280" in row 1
And I set field "preis" to "0280" in row 1
And I set field "kenn" to "FALL-0280"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0280"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0280" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0280"
And I set field "num3" to "0280-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0280 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0280"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0280" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0280"
And I set field "num3" to "0280-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0280"
And I close the current editor

#####################################################################################################################################

@FALL-0290
Scenario: FALL-0290
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein Storno-Lieferschein

# Konto 0290-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0290FALL"
And I set field "such" to "FALL-0290"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0290-MG"
And I set field "such" to "FALL-0290"
And I set field "bestausekso" to "FALL-0290"
And I save the current editor

# Konto 40290-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40290FAL"
And I set field "such" to "FALL-40290"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0290-PG"
And I set field "such" to "FALL-0290"
And I set field "pgerlo" to "FALL-40290"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0290-FALL"
And I set field "num2" to "0290-FALL"
And I set field "such" to "FALL-0290"
And I set field "namebspr" to "FALL-0290"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0290-MG"
And I set field "erlgrp" to "0290-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0290" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0290-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0290" in row 1
And I set field "mge" to "0290" in row 1
And I set field "preis" to "0290" in row 1
And I set field "kenn" to "FALL-0290"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0290" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0290-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0290" in row 1
And I set field "mge" to "0290" in row 1
And I set field "preis" to "0290" in row 1
And I set field "kenn" to "FALL-0290"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0290"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0290" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0290"
And I set field "num3" to "0290-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0290" in row 1
And I set field "kenn" to "FALL-0290"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0290"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0290" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0290"
And I set field "kunde" to "1"
And I set field "num3" to "0290-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0290" in row 1
And I set field "preis" to "0290" in row 1
And I set field "kenn" to "FALL-0290"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0290"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0290" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0290"
And I set field "num3" to "0290-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0290 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0290"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0290" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0290"
And I set field "num3" to "0290-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0290"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0290" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0290"
And I set field "num3" to "0290-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0290"
And I close the current editor

#####################################################################################################################################

@FALL-0300
Scenario: FALL-0300
# VK Auftrag Lieferschein Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein Storno-Lieferschein

# Konto 0300-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0300FALL"
And I set field "such" to "FALL-0300"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0300-MG"
And I set field "such" to "FALL-0300"
And I set field "bestausekso" to "FALL-0300"
And I save the current editor

# Konto 40300-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40300FAL"
And I set field "such" to "FALL-40300"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0300-PG"
And I set field "such" to "FALL-0300"
And I set field "pgerlo" to "FALL-40300"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0300-FALL"
And I set field "num2" to "0300-FALL"
And I set field "such" to "FALL-0300"
And I set field "namebspr" to "FALL-0300"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0300-MG"
And I set field "erlgrp" to "0300-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0300" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0300-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0300" in row 1
And I set field "mge" to "0300" in row 1
And I set field "preis" to "0300" in row 1
And I set field "kenn" to "FALL-0300"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0300" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0300-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0300" in row 1
And I set field "mge" to "0300" in row 1
And I set field "preis" to "0300" in row 1
And I set field "kenn" to "FALL-0300"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0300"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0300" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0300"
And I set field "num3" to "0300-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0300" in row 1
And I set field "kenn" to "FALL-0300"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0300"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0300" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0300"
And I set field "kunde" to "1"
And I set field "num3" to "0300-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0300" in row 1
And I set field "preis" to "0300" in row 1
And I set field "kenn" to "FALL-0300"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0300"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0300" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0300"
And I set field "num3" to "0300-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0300 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0300"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0300" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0300"
And I set field "num3" to "0300-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0300"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0300" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0300"
And I set field "num3" to "0300-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0300"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-st-0300" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0300"
And I set field "num3" to "0300-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+0300-SLS"
And I close the current editor

#####################################################################################################################################

@FALL-0310
Scenario: FALL-0310
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein

# Konto 0310-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0310FALL"
And I set field "such" to "FALL-0310"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0310-MG"
And I set field "such" to "FALL-0310"
And I set field "bestausekso" to "FALL-0310"
And I save the current editor

# Konto 40310-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40310FAL"
And I set field "such" to "FALL-40310"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0310-PG"
And I set field "such" to "FALL-0310"
And I set field "pgerlo" to "FALL-40310"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0310-FALL"
And I set field "num2" to "0310-FALL"
And I set field "such" to "FALL-0310"
And I set field "namebspr" to "FALL-0310"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0310-MG"
And I set field "erlgrp" to "0310-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0310" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0310-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0310" in row 1
And I set field "mge" to "0310" in row 1
And I set field "preis" to "0310" in row 1
And I set field "kenn" to "FALL-0310"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0310" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0310-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0310" in row 1
And I set field "mge" to "0310" in row 1
And I set field "preis" to "0310" in row 1
And I set field "kenn" to "FALL-0310"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0310"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0310" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0310"
And I set field "num3" to "0310-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0310" in row 1
And I set field "kenn" to "FALL-0310"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0310"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0310" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0310"
And I set field "kunde" to "1"
And I set field "num3" to "0310-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0310" in row 1
And I set field "preis" to "0310" in row 1
And I set field "kenn" to "FALL-0310"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0310"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0310" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0310"
And I set field "num3" to "0310-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0310"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0310" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0310"
And I set field "num3" to "0310-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0310 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0310"
And I close the current editor

#####################################################################################################################################

@FALL-0320
Scenario: FALL-0320
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift

# Konto 0320-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0320FALL"
And I set field "such" to "FALL-0320"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0320-MG"
And I set field "such" to "FALL-0320"
And I set field "bestausekso" to "FALL-0320"
And I save the current editor

# Konto 40320-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40320FAL"
And I set field "such" to "FALL-40320"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0320-PG"
And I set field "such" to "FALL-0320"
And I set field "pgerlo" to "FALL-40320"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0320-FALL"
And I set field "num2" to "0320-FALL"
And I set field "such" to "FALL-0320"
And I set field "namebspr" to "FALL-0320"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0320-MG"
And I set field "erlgrp" to "0320-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0320" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0320-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0320" in row 1
And I set field "mge" to "0320" in row 1
And I set field "preis" to "0320" in row 1
And I set field "kenn" to "FALL-0320"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0320" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0320-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0320" in row 1
And I set field "mge" to "0320" in row 1
And I set field "preis" to "0320" in row 1
And I set field "kenn" to "FALL-0320"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0320"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0320" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0320"
And I set field "num3" to "0320-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0320" in row 1
And I set field "kenn" to "FALL-0320"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0320"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0320" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0320"
And I set field "kunde" to "1"
And I set field "num3" to "0320-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0320" in row 1
And I set field "preis" to "0320" in row 1
And I set field "kenn" to "FALL-0320"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0320"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0320" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0320"
And I set field "num3" to "0320-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0320 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0320"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0320" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0320"
And I set field "num3" to "0320-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0320" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0320"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0320"
And I close the current editor

# Storno Rechnung
Given opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0320" throws the exception "2006"
# Fehler: Diese Rechnung wurde bereits in einer kaufmaennischen Gutschrift verrechnet.

#####################################################################################################################################

@FALL-0330
Scenario: FALL-0330
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift

# Konto 0330-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0330FALL"
And I set field "such" to "FALL-0330"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0330-MG"
And I set field "such" to "FALL-0330"
And I set field "bestausekso" to "FALL-0330"
And I save the current editor

# Konto 40330-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40330FAL"
And I set field "such" to "FALL-40330"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0330-PG"
And I set field "such" to "FALL-0330"
And I set field "pgerlo" to "FALL-40330"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0330-FALL"
And I set field "num2" to "0330-FALL"
And I set field "such" to "FALL-0330"
And I set field "namebspr" to "FALL-0330"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0330-MG"
And I set field "erlgrp" to "0330-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0330" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0330-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0330" in row 1
And I set field "mge" to "0330" in row 1
And I set field "preis" to "0330" in row 1
And I set field "kenn" to "FALL-0330"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0330" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0330-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0330" in row 1
And I set field "mge" to "0330" in row 1
And I set field "preis" to "0330" in row 1
And I set field "kenn" to "FALL-0330"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0330"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0330" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0330"
And I set field "num3" to "0330-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0330" in row 1
And I set field "kenn" to "FALL-0330"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0330"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0330" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0330"
And I set field "kunde" to "1"
And I set field "num3" to "0330-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0330" in row 1
And I set field "preis" to "0330" in row 1
And I set field "kenn" to "FALL-0330"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0330"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0330" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0330"
And I set field "num3" to "0330-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0330 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0330"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0330" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0330"
And I set field "num3" to "0330-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0330" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0330"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0330"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0330" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0330"
And I set field "num3" to "0330-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0330"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0330" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0330"
And I set field "num3" to "0330-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0330"
And I close the current editor

#####################################################################################################################################

@FALL-0340
Scenario: FALL-0340
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein

# Konto 0340-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0340FALL"
And I set field "such" to "FALL-0340"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0340-MG"
And I set field "such" to "FALL-0340"
And I set field "bestausekso" to "FALL-0340"
And I save the current editor

# Konto 40340-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40340FAL"
And I set field "such" to "FALL-40340"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0340-PG"
And I set field "such" to "FALL-0340"
And I set field "pgerlo" to "FALL-40340"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0340-FALL"
And I set field "num2" to "0340-FALL"
And I set field "such" to "FALL-0340"
And I set field "namebspr" to "FALL-0340"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0340-MG"
And I set field "erlgrp" to "0340-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0340" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0340-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0340" in row 1
And I set field "mge" to "0340" in row 1
And I set field "preis" to "0340" in row 1
And I set field "kenn" to "FALL-0340"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0340" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0340-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0340" in row 1
And I set field "mge" to "0340" in row 1
And I set field "preis" to "0340" in row 1
And I set field "kenn" to "FALL-0340"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0340"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0340" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0340"
And I set field "num3" to "0340-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0340" in row 1
And I set field "kenn" to "FALL-0340"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0340"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0340" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0340"
And I set field "kunde" to "1"
And I set field "num3" to "0340-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0340" in row 1
And I set field "preis" to "0340" in row 1
And I set field "kenn" to "FALL-0340"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0340"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0340" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0340"
And I set field "num3" to "0340-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0340 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0340"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0340" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0340"
And I set field "num3" to "0340-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0340" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0340"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0340"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0340" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0340"
And I set field "num3" to "0340-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0340"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0340" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0340"
And I set field "num3" to "0340-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0340"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0340" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0340"
And I set field "num3" to "0340-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0340"
And I close the current editor

#####################################################################################################################################

@FALL-0350
Scenario: FALL-0350
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Rücklieferschein

# Konto 0350-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0350FALL"
And I set field "such" to "FALL-0350"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0350-MG"
And I set field "such" to "FALL-0350"
And I set field "bestausekso" to "FALL-0350"
And I save the current editor

# Konto 40350-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40350FAL"
And I set field "such" to "FALL-40350"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0350-PG"
And I set field "such" to "FALL-0350"
And I set field "pgerlo" to "FALL-40350"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0350-FALL"
And I set field "num2" to "0350-FALL"
And I set field "such" to "FALL-0350"
And I set field "namebspr" to "FALL-0350"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0350-MG"
And I set field "erlgrp" to "0350-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0350" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0350-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0350" in row 1
And I set field "mge" to "0350" in row 1
And I set field "preis" to "0350" in row 1
And I set field "kenn" to "FALL-0350"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0350" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0350-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0350" in row 1
And I set field "mge" to "0350" in row 1
And I set field "preis" to "0350" in row 1
And I set field "kenn" to "FALL-0350"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0350"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0350" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0350"
And I set field "num3" to "0350-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0350" in row 1
And I set field "kenn" to "FALL-0350"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0350"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0350" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0350"
And I set field "kunde" to "1"
And I set field "num3" to "0350-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0350" in row 1
And I set field "preis" to "0350" in row 1
And I set field "kenn" to "FALL-0350"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0350"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0350" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0350"
And I set field "num3" to "0350-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0350 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0350"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0350" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0350"
And I set field "num3" to "0350-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0350" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0350"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0350"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0350" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0350"
And I set field "num3" to "0350-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0350"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0350" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0350"
And I set field "num3" to "0350-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0350"
And I close the current editor

# Rücklieferschein2 anlegen
Given I open an editor "Ruecklieferschein2-0350" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0350"
And I set field "num3" to "0350-RL2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0350 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "Rücklieferschein2-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein2-0350"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0350" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0350"
And I set field "num3" to "0350-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0350"
And I close the current editor

#####################################################################################################################################

@FALL-0360
Scenario: FALL-0360
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno-Lieferschein

# Konto 0360-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0360FALL"
And I set field "such" to "FALL-0360"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0360-MG"
And I set field "such" to "FALL-0360"
And I set field "bestausekso" to "FALL-0360"
And I save the current editor

# Konto 40360-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40360FAL"
And I set field "such" to "FALL-40360"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0360-PG"
And I set field "such" to "FALL-0360"
And I set field "pgerlo" to "FALL-40360"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0360-FALL"
And I set field "num2" to "0360-FALL"
And I set field "such" to "FALL-0360"
And I set field "namebspr" to "FALL-0360"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0360-MG"
And I set field "erlgrp" to "0360-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0360" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0360-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0360" in row 1
And I set field "mge" to "0360" in row 1
And I set field "preis" to "0360" in row 1
And I set field "kenn" to "FALL-0360"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0360" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0360-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0360" in row 1
And I set field "mge" to "0360" in row 1
And I set field "preis" to "0360" in row 1
And I set field "kenn" to "FALL-0360"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0360"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0360" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0360"
And I set field "num3" to "0360-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0360" in row 1
And I set field "kenn" to "FALL-0360"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0360"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0360" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0360"
And I set field "kunde" to "1"
And I set field "num3" to "0360-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0360" in row 1
And I set field "preis" to "0360" in row 1
And I set field "kenn" to "FALL-0360"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0360"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0360" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0360"
And I set field "num3" to "0360-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0360 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0360"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0360" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0360"
And I set field "num3" to "0360-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0360" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0360"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0360"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0360" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0360"
And I set field "num3" to "0360-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0360"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0360" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0360"
And I set field "num3" to "0360-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0360"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0360" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0360"
And I set field "num3" to "0360-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0360"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0360" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0360"
And I set field "num3" to "0360-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0360"
And I close the current editor

#####################################################################################################################################

@FALL-0370
Scenario: FALL-0370
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Gutschrift

# Konto 0370-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0370FALL"
And I set field "such" to "FALL-0370"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0370-MG"
And I set field "such" to "FALL-0370"
And I set field "bestausekso" to "FALL-0370"
And I save the current editor

# Konto 40370-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40370FAL"
And I set field "such" to "FALL-40370"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0370-PG"
And I set field "such" to "FALL-0370"
And I set field "pgerlo" to "FALL-40370"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0370-FALL"
And I set field "num2" to "0370-FALL"
And I set field "such" to "FALL-0370"
And I set field "namebspr" to "FALL-0370"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0370-MG"
And I set field "erlgrp" to "0370-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0370" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0370-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0370" in row 1
And I set field "mge" to "0370" in row 1
And I set field "preis" to "0370" in row 1
And I set field "kenn" to "FALL-0370"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0370" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0370-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0370" in row 1
And I set field "mge" to "0370" in row 1
And I set field "preis" to "0370" in row 1
And I set field "kenn" to "FALL-0370"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0370"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0370" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0370"
And I set field "num3" to "0370-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0370" in row 1
And I set field "kenn" to "FALL-0370"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0370"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0370" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0370"
And I set field "kunde" to "1"
And I set field "num3" to "0370-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0370" in row 1
And I set field "preis" to "0370" in row 1
And I set field "kenn" to "FALL-0370"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0370"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0370" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0370"
And I set field "num3" to "0370-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0370 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0370"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0370" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0370"
And I set field "num3" to "0370-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0370" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0370"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0370"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0370" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0370"
And I set field "num3" to "0370-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0370"
And I close the current editor

# Gutschrift2 anlegen
Given I open an editor "Gutschrift2-0370" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0370"
And I set field "num3" to "0370-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0370" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0370"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift2-0370"
And I close the current editor

# Storno Rechnung
Given opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0370" throws the exception "2006"
# Fehler: Diese Rechnung wurde bereits in einer kaufmaennischen Gutschrift verrechnet.

#####################################################################################################################################

@FALL-0380
Scenario: FALL-0380
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein

# Konto 0380-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0380FALL"
And I set field "such" to "FALL-0380"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0380-MG"
And I set field "such" to "FALL-0380"
And I set field "bestausekso" to "FALL-0380"
And I save the current editor

# Konto 40380-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40380FAL"
And I set field "such" to "FALL-40380"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0380-PG"
And I set field "such" to "FALL-0380"
And I set field "pgerlo" to "FALL-40380"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0380-FALL"
And I set field "num2" to "0380-FALL"
And I set field "such" to "FALL-0380"
And I set field "namebspr" to "FALL-0380"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0380-MG"
And I set field "erlgrp" to "0380-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0380" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0380-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0380" in row 1
And I set field "mge" to "0380" in row 1
And I set field "preis" to "0380" in row 1
And I set field "kenn" to "FALL-0380"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0380" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0380-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0380" in row 1
And I set field "mge" to "0380" in row 1
And I set field "preis" to "0380" in row 1
And I set field "kenn" to "FALL-0380"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0380"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0380" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0380"
And I set field "num3" to "0380-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0380" in row 1
And I set field "kenn" to "FALL-0380"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0380"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0380" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0380"
And I set field "kunde" to "1"
And I set field "num3" to "0380-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0380" in row 1
And I set field "preis" to "0380" in row 1
And I set field "kenn" to "FALL-0380"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0380"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0380" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0380"
And I set field "num3" to "0380-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0380"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0380" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0380"
And I set field "num3" to "0380-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0380 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0380"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0380" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0380"
And I set field "num3" to "0380-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0380"
And I close the current editor

#####################################################################################################################################

@FALL-0390
Scenario: FALL-0390
# VK Auftrag Lieferschein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein Storno-Lieferschein

# Konto 0390-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0390FALL"
And I set field "such" to "FALL-0390"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0390-MG"
And I set field "such" to "FALL-0390"
And I set field "bestausekso" to "FALL-0390"
And I save the current editor

# Konto 40390-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40390FAL"
And I set field "such" to "FALL-40390"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0390-PG"
And I set field "such" to "FALL-0390"
And I set field "pgerlo" to "FALL-40390"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0390-FALL"
And I set field "num2" to "0390-FALL"
And I set field "such" to "FALL-0390"
And I set field "namebspr" to "FALL-0390"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0390-MG"
And I set field "erlgrp" to "0390-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0390" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0390-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0390" in row 1
And I set field "mge" to "0390" in row 1
And I set field "preis" to "0390" in row 1
And I set field "kenn" to "FALL-0390"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0390" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0390-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0390" in row 1
And I set field "mge" to "0390" in row 1
And I set field "preis" to "0390" in row 1
And I set field "kenn" to "FALL-0390"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0390"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0390" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0390"
And I set field "num3" to "0390-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0390" in row 1
And I set field "kenn" to "FALL-0390"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0390"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0390" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0390"
And I set field "kunde" to "1"
And I set field "num3" to "0390-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0390" in row 1
And I set field "preis" to "0390" in row 1
And I set field "kenn" to "FALL-0390"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0390"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0390" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0390"
And I set field "num3" to "0390-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0390"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0390" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0390"
And I set field "num3" to "0390-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0390 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "rls-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0390"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0390" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0390"
And I set field "num3" to "0390-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0390"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0390" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0390"
And I set field "num3" to "0390-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0390"
And I close the current editor

#####################################################################################################################################

@FALL-0400
Scenario: FALL-0400
# VK Auftrag Lieferschein Rechnung ohne Lager Gutschrift

# Konto 0400-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0400FALL"
And I set field "such" to "FALL-0400"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0400-MG"
And I set field "such" to "FALL-0400"
And I set field "bestausekso" to "FALL-0400"
And I save the current editor

# Konto 40400-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40400FAL"
And I set field "such" to "FALL-40400"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0400-PG"
And I set field "such" to "FALL-0400"
And I set field "pgerlo" to "FALL-40400"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0400-FALL"
And I set field "num2" to "0400-FALL"
And I set field "such" to "FALL-0400"
And I set field "namebspr" to "FALL-0400"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0400-MG"
And I set field "erlgrp" to "0400-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0400" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0400-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0400" in row 1
And I set field "mge" to "0400" in row 1
And I set field "preis" to "0400" in row 1
And I set field "kenn" to "FALL-0400"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0400" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0400-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0400" in row 1
And I set field "mge" to "0400" in row 1
And I set field "preis" to "0400" in row 1
And I set field "kenn" to "FALL-0400"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0400"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0400" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0400"
And I set field "num3" to "0400-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0400" in row 1
And I set field "kenn" to "FALL-0400"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0400"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0400" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0400"
And I set field "kunde" to "1"
And I set field "num3" to "0400-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0400" in row 1
And I set field "preis" to "0400" in row 1
And I set field "kenn" to "FALL-0400"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0400"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0400" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-0400"
And I set field "num3" to "0400-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
# And I set field "artex" to "FALL-0400" in row 1
And I set field "mge" to "0400" in row 1
And I set field "preis" to "-0400" in row 1
And I set field "kenn" to "FALL-0400"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0400"
And I close the current editor

#####################################################################################################################################

@FALL-0410
Scenario: FALL-0410
# VK Auftrag Lieferschein Rechnung ohne Lager Gutschrift Storno-Gutschrift

# Konto 0410-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0410FALL"
And I set field "such" to "FALL-0410"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0410-MG"
And I set field "such" to "FALL-0410"
And I set field "bestausekso" to "FALL-0410"
And I save the current editor

# Konto 40410-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40410FAL"
And I set field "such" to "FALL-40410"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0410-PG"
And I set field "such" to "FALL-0410"
And I set field "pgerlo" to "FALL-40410"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0410-FALL"
And I set field "num2" to "0410-FALL"
And I set field "such" to "FALL-0410"
And I set field "namebspr" to "FALL-0410"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0410-MG"
And I set field "erlgrp" to "0410-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0410" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0410-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0410" in row 1
And I set field "mge" to "0410" in row 1
And I set field "preis" to "0410" in row 1
And I set field "kenn" to "FALL-0410"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0410" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0410-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0410" in row 1
And I set field "mge" to "0410" in row 1
And I set field "preis" to "0410" in row 1
And I set field "kenn" to "FALL-0410"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0410"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0410" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0410"
And I set field "num3" to "0410-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0410" in row 1
And I set field "kenn" to "FALL-0410"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0410"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0410" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0410"
And I set field "kunde" to "1"
And I set field "num3" to "0410-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0410" in row 1
And I set field "preis" to "0410" in row 1
And I set field "kenn" to "FALL-0410"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0410"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0410" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-0410"
And I set field "num3" to "0410-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
# And I set field "artex" to "FALL-0410" in row 1
And I set field "mge" to "0410" in row 1
And I set field "preis" to "-0410" in row 1
And I set field "kenn" to "FALL-0410"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0410"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0410" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0410"
And I set field "num3" to "0410-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0410"
And I close the current editor

#####################################################################################################################################

@FALL-0415
Scenario: FALL-0415
# VK  Auftrag  Lieferschein  Rechnung ohne Lager  Gutschrift mit ZP  Storno-Gutschrift

# Konto 0415-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0415FALL"
And I set field "such" to "FALL-0415"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0415-MG"
And I set field "such" to "FALL-0415"
And I set field "bestausekso" to "FALL-0415"
And I save the current editor

# Konto 40415-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40415FAL"
And I set field "such" to "FALL-40415"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0415-PG"
And I set field "such" to "FALL-0415"
And I set field "pgerlo" to "FALL-40415"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0415-FALL"
And I set field "num2" to "0415-FALL"
And I set field "such" to "FALL-0415"
And I set field "namebspr" to "FALL-0415"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0415-MG"
And I set field "erlgrp" to "0415-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0415" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0415-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0415" in row 1
And I set field "mge" to "0415" in row 1
And I set field "preis" to "0415" in row 1
And I set field "kenn" to "FALL-0415"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0415" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0415-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0415" in row 1
And I set field "mge" to "0415" in row 1
And I set field "preis" to "0415" in row 1
And I set field "kenn" to "FALL-0415"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0415"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0415" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0415"
And I set field "num3" to "0415-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0415" in row 1
And I set field "kenn" to "FALL-0415"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0415"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0415" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0415"
And I set field "kunde" to "1"
And I set field "num3" to "0415-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0415" in row 1
And I set field "preis" to "0415" in row 1
And I set field "kenn" to "FALL-0415"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0415"
And I close the current editor

# Gutschrift mit ZP anlegen
Given I open an editor "gutschrift-0415" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rechnung-0415"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "fakt" has value "nein"
And I set field "num3" to "0415-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-415" in row 1
And I set field "preis" to "0" in row 1
And I create a new row at position 2
And I set field "artex" to "TEXT" in row 2
Then field "pwert" is not modifiable in row 2
And I set field "kenn" to "FALL-0415"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0415"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0415" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0415"
And I set field "num3" to "0415-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0415"
And I close the current editor

#####################################################################################################################################

@FALL-0420
Scenario: FALL-0420
# VK Auftrag Lieferschein Rechnung ohne Lager Gutschrift Storno-Gutschrift Storno-Rechnung ohne Lager

# Konto 0420-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0420FALL"
And I set field "such" to "FALL-0420"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0420-MG"
And I set field "such" to "FALL-0420"
And I set field "bestausekso" to "FALL-0420"
And I save the current editor

# Konto 40420-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40420FAL"
And I set field "such" to "FALL-40420"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0420-PG"
And I set field "such" to "FALL-0420"
And I set field "pgerlo" to "FALL-40420"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0420-FALL"
And I set field "num2" to "0420-FALL"
And I set field "such" to "FALL-0420"
And I set field "namebspr" to "FALL-0420"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0420-MG"
And I set field "erlgrp" to "0420-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0420" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0420-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0420" in row 1
And I set field "mge" to "0420" in row 1
And I set field "preis" to "0420" in row 1
And I set field "kenn" to "FALL-0420"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0420" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0420-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0420" in row 1
And I set field "mge" to "0420" in row 1
And I set field "preis" to "0420" in row 1
And I set field "kenn" to "FALL-0420"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0420"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0420" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0420"
And I set field "num3" to "0420-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0420" in row 1
And I set field "kenn" to "FALL-0420"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0420"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0420" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0420"
And I set field "kunde" to "1"
And I set field "num3" to "0420-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0420" in row 1
And I set field "preis" to "0420" in row 1
And I set field "kenn" to "FALL-0420"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0420"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0420" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-0420"
And I set field "num3" to "0420-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
# And I set field "artex" to "FALL-0420" in row 1
And I set field "mge" to "0420" in row 1
And I set field "preis" to "-0420" in row 1
And I set field "kenn" to "FALL-0420"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0420"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0420" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0420"
And I set field "num3" to "0420-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0420"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0420" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0420"
And I set field "num3" to "0420-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0420"
And I close the current editor

#####################################################################################################################################

@FALL-0430
Scenario: FALL-0430
# VK Auftrag Lieferschein Rechnung ohne Lager Gutschrift Storno-Gutschrift Storno-Rechnung ohne Lager Storno-Lieferschein

# Konto 0430-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0430FALL"
And I set field "such" to "FALL-0430"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0430-MG"
And I set field "such" to "FALL-0430"
And I set field "bestausekso" to "FALL-0430"
And I save the current editor

# Konto 40430-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40430FAL"
And I set field "such" to "FALL-40430"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0430-PG"
And I set field "such" to "FALL-0430"
And I set field "pgerlo" to "FALL-40430"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0430-FALL"
And I set field "num2" to "0430-FALL"
And I set field "such" to "FALL-0430"
And I set field "namebspr" to "FALL-0430"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0430-MG"
And I set field "erlgrp" to "0430-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0430" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0430-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0430" in row 1
And I set field "mge" to "0430" in row 1
And I set field "preis" to "0430" in row 1
And I set field "kenn" to "FALL-0430"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0430" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0430-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0430" in row 1
And I set field "mge" to "0430" in row 1
And I set field "preis" to "0430" in row 1
And I set field "kenn" to "FALL-0430"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0430"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0430" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0430"
And I set field "num3" to "0430-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0430" in row 1
And I set field "kenn" to "FALL-0430"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0430"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0430" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-0430"
And I set field "kunde" to "1"
And I set field "num3" to "0430-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0430" in row 1
And I set field "preis" to "0430" in row 1
And I set field "kenn" to "FALL-0430"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0430"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0430" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-0430"
And I set field "num3" to "0430-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
# And I set field "artex" to "FALL-0430" in row 1
And I set field "mge" to "0430" in row 1
And I set field "preis" to "-0430" in row 1
And I set field "kenn" to "FALL-0430"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0430"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0430" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0430"
And I set field "num3" to "0430-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0430"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0430" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0430"
And I set field "num3" to "0430-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0430"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0430" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0430"
And I set field "num3" to "0430-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0430"
And I close the current editor

#####################################################################################################################################

@FALL-0440
Scenario: FALL-0440
# VK Auftrag Lieferschein Rücklieferschein

# Konto 0440-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0440FALL"
And I set field "such" to "FALL-0440"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0440-MG"
And I set field "such" to "FALL-0440"
And I set field "bestausekso" to "FALL-0440"
And I save the current editor

# Konto 40440-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40440FAL"
And I set field "such" to "FALL-40440"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0440-PG"
And I set field "such" to "FALL-0440"
And I set field "pgerlo" to "FALL-40440"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0440-FALL"
And I set field "num2" to "0440-FALL"
And I set field "such" to "FALL-0440"
And I set field "namebspr" to "FALL-0440"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0440-MG"
And I set field "erlgrp" to "0440-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0440" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0440-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0440" in row 1
And I set field "mge" to "0440" in row 1
And I set field "preis" to "0440" in row 1
And I set field "kenn" to "FALL-0440"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0440" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0440-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0440" in row 1
And I set field "mge" to "0440" in row 1
And I set field "preis" to "0440" in row 1
And I set field "kenn" to "FALL-0440"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0440"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0440" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0440"
And I set field "num3" to "0440-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0440" in row 1
And I set field "kenn" to "FALL-0440"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0440"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0440" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0440"
And I set field "num3" to "0440-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0440 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0440"
And I close the current editor

#####################################################################################################################################

@FALL-0450
Scenario: FALL-0450
# VK Auftrag Lieferschein Rücklieferschein Gutschrift

# Konto 0450-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0450FALL"
And I set field "such" to "FALL-0450"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0450-MG"
And I set field "such" to "FALL-0450"
And I set field "bestausekso" to "FALL-0450"
And I save the current editor

# Konto 40450-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40450FAL"
And I set field "such" to "FALL-40450"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0450-PG"
And I set field "such" to "FALL-0450"
And I set field "pgerlo" to "FALL-40450"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0450-FALL"
And I set field "num2" to "0450-FALL"
And I set field "such" to "FALL-0450"
And I set field "namebspr" to "FALL-0450"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0450-MG"
And I set field "erlgrp" to "0450-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0450" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0450-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0450" in row 1
And I set field "mge" to "0450" in row 1
And I set field "preis" to "0450" in row 1
And I set field "kenn" to "FALL-0450"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0450" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0450-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0450" in row 1
And I set field "mge" to "0450" in row 1
And I set field "preis" to "0450" in row 1
And I set field "kenn" to "FALL-0450"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0450"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0450" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0450"
And I set field "num3" to "0450-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0450" in row 1
And I set field "kenn" to "FALL-0450"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0450"
And I close the current editor

# Rechnung anlegen aus Lieferschein
Given I open an editor "rechnung-0450" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-0450"
And I set field "kunde" to "1"
And I set field "num3" to "0450-RE"
And I set field "ueb" to "ja"
And I set field "mge" to "450" in row 1
And I set field "preis" to "0450" in row 1
And I set field "kenn" to "FALL-0450"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0450-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0450" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0450"
And I set field "num3" to "0450-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0450 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0450"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0450" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0450"
And I set field "num3" to "0450-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0450" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0450"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0450"
And I close the current editor

#####################################################################################################################################

@FALL-0460
Scenario: FALL-0460
# VK Auftrag Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift

# Konto 0460-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0460FALL"
And I set field "such" to "FALL-0460"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0460-MG"
And I set field "such" to "FALL-0460"
And I set field "bestausekso" to "FALL-0460"
And I save the current editor

# Konto 40460-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40460FAL"
And I set field "such" to "FALL-40460"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0460-PG"
And I set field "such" to "FALL-0460"
And I set field "pgerlo" to "FALL-40460"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0460-FALL"
And I set field "num2" to "0460-FALL"
And I set field "such" to "FALL-0460"
And I set field "namebspr" to "FALL-0460"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0460-MG"
And I set field "erlgrp" to "0460-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0460" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0460-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0460" in row 1
And I set field "mge" to "0460" in row 1
And I set field "preis" to "0460" in row 1
And I set field "kenn" to "FALL-0460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0460" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0460-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0460" in row 1
And I set field "mge" to "0460" in row 1
And I set field "preis" to "0460" in row 1
And I set field "kenn" to "FALL-0460"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0460"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0460" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0460"
And I set field "num3" to "0460-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0460" in row 1
And I set field "kenn" to "FALL-0460"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0460"
And I close the current editor

# Rechnung anlegen aus Lieferschein
Given I open an editor "rechnung-0460" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-0460"
And I set field "kunde" to "1"
And I set field "num3" to "0460-RE"
And I set field "ueb" to "ja"
And I set field "mge" to "460" in row 1
And I set field "preis" to "0460" in row 1
And I set field "kenn" to "FALL-0460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0460-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0460" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0460"
And I set field "num3" to "0460-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0460 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0460"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0460" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0460"
And I set field "num3" to "0460-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0460" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0460"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0460"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0460" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0460"
And I set field "num3" to "0460-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0460"
And I close the current editor

#####################################################################################################################################

@FALL-0470
Scenario: FALL-0470
# VK Auftrag Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein

# Konto 0470-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0470FALL"
And I set field "such" to "FALL-0470"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0470-MG"
And I set field "such" to "FALL-0470"
And I set field "bestausekso" to "FALL-0470"
And I save the current editor

# Konto 40470-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40470FAL"
And I set field "such" to "FALL-40470"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0470-PG"
And I set field "such" to "FALL-0470"
And I set field "pgerlo" to "FALL-40470"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0470-FALL"
And I set field "num2" to "0470-FALL"
And I set field "such" to "FALL-0470"
And I set field "namebspr" to "FALL-0470"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0470-MG"
And I set field "erlgrp" to "0470-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0470" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0470-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0470" in row 1
And I set field "mge" to "0470" in row 1
And I set field "preis" to "0470" in row 1
And I set field "kenn" to "FALL-0470"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0470" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0470-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0470" in row 1
And I set field "mge" to "0470" in row 1
And I set field "preis" to "0470" in row 1
And I set field "kenn" to "FALL-0470"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0470"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0470" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0470"
And I set field "num3" to "0470-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0470" in row 1
And I set field "kenn" to "FALL-0470"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0470"
And I close the current editor

# Rechnung anlegen aus Lieferschein
Given I open an editor "rechnung-0470" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-0470"
And I set field "kunde" to "1"
And I set field "num3" to "0470-RE"
And I set field "ueb" to "ja"
And I set field "mge" to "470" in row 1
And I set field "preis" to "0470" in row 1
And I set field "kenn" to "FALL-0470"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0470-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0470" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0470"
And I set field "num3" to "0470-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0470 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0470"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0470" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0470"
And I set field "num3" to "0470-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0470" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0470"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0470"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0470" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0470"
And I set field "num3" to "0470-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0470"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0470" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0470"
And I set field "num3" to "0470-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0470"
And I close the current editor

#####################################################################################################################################

@FALL-0480
Scenario: FALL-0480
# VK Auftrag Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Rücklieferschein

# Konto 0480-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0480FALL"
And I set field "such" to "FALL-0480"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0480-MG"
And I set field "such" to "FALL-0480"
And I set field "bestausekso" to "FALL-0480"
And I save the current editor

# Konto 40480-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40480FAL"
And I set field "such" to "FALL-40480"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0480-PG"
And I set field "such" to "FALL-0480"
And I set field "pgerlo" to "FALL-40480"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0480-FALL"
And I set field "num2" to "0480-FALL"
And I set field "such" to "FALL-0480"
And I set field "namebspr" to "FALL-0480"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0480-MG"
And I set field "erlgrp" to "0480-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0480" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0480-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0480" in row 1
And I set field "mge" to "0480" in row 1
And I set field "preis" to "0480" in row 1
And I set field "kenn" to "FALL-0480"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0480" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0480-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0480" in row 1
And I set field "mge" to "0480" in row 1
And I set field "preis" to "0480" in row 1
And I set field "kenn" to "FALL-0480"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0480"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0480" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0480"
And I set field "num3" to "0480-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0480" in row 1
And I set field "kenn" to "FALL-0480"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0480"
And I close the current editor

# Rechnung anlegen aus Lieferschein
Given I open an editor "rechnung-0480" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-0480"
And I set field "kunde" to "1"
And I set field "num3" to "0480-RE"
And I set field "ueb" to "ja"
And I set field "mge" to "480" in row 1
And I set field "preis" to "0480" in row 1
And I set field "kenn" to "FALL-0480"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0480-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0480" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0480"
And I set field "num3" to "0480-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0480 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0480"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0480" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0480"
And I set field "num3" to "0480-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0480" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0480"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0480"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0480" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0480"
And I set field "num3" to "0480-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0480"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0480" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0480"
And I set field "num3" to "0480-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0480"
And I close the current editor

# Rücklieferschein2 anlegen
Given I open an editor "Ruecklieferschein2-0480" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0480"
And I set field "num3" to "0480-RL2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0480 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein2-0480"
And I close the current editor

#####################################################################################################################################

@FALL-0490
Scenario: FALL-0490
# VK Auftrag Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno-Lieferschein

# Konto 0490-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0490FALL"
And I set field "such" to "FALL-0490"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0490-MG"
And I set field "such" to "FALL-0490"
And I set field "bestausekso" to "FALL-0490"
And I save the current editor

# Konto 40490-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40490FAL"
And I set field "such" to "FALL-40490"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0490-PG"
And I set field "such" to "FALL-0490"
And I set field "pgerlo" to "FALL-40490"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0490-FALL"
And I set field "num2" to "0490-FALL"
And I set field "such" to "FALL-0490"
And I set field "namebspr" to "FALL-0490"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0490-MG"
And I set field "erlgrp" to "0490-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0490" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0490-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0490" in row 1
And I set field "mge" to "0490" in row 1
And I set field "preis" to "0490" in row 1
And I set field "kenn" to "FALL-0490"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0490" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0490-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0490" in row 1
And I set field "mge" to "0490" in row 1
And I set field "preis" to "0490" in row 1
And I set field "kenn" to "FALL-0490"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0490"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0490" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0490"
And I set field "num3" to "0490-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0490" in row 1
And I set field "kenn" to "FALL-0490"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0490"
And I close the current editor

# Rechnung anlegen aus Lieferschein
Given I open an editor "rechnung-0490" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-0490"
And I set field "kunde" to "1"
And I set field "num3" to "0490-RE"
And I set field "ueb" to "ja"
And I set field "mge" to "490" in row 1
And I set field "preis" to "0490" in row 1
And I set field "kenn" to "FALL-0490"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0490-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0490" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0490"
And I set field "num3" to "0490-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0490 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0490"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0490" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0490"
And I set field "num3" to "0490-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0490" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0490"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0490"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0490" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0490"
And I set field "num3" to "0490-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0490"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0490" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0490"
And I set field "num3" to "0490-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0490"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0490" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0490"
And I set field "num3" to "0490-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0490"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0490" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0490"
And I set field "num3" to "0490-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0490"
And I close the current editor

#####################################################################################################################################

@FALL-0500
Scenario: FALL-0500
# VK Auftrag Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift Gutschrift

# Konto 0500-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0500FALL"
And I set field "such" to "FALL-0500"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0500-MG"
And I set field "such" to "FALL-0500"
And I set field "bestausekso" to "FALL-0500"
And I save the current editor

# Konto 40500-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40500FAL"
And I set field "such" to "FALL-40500"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0500-PG"
And I set field "such" to "FALL-0500"
And I set field "pgerlo" to "FALL-40500"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0500-FALL"
And I set field "num2" to "0500-FALL"
And I set field "such" to "FALL-0500"
And I set field "namebspr" to "FALL-0500"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0500-MG"
And I set field "erlgrp" to "0500-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0500" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0500-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0500" in row 1
And I set field "mge" to "0500" in row 1
And I set field "preis" to "0500" in row 1
And I set field "kenn" to "FALL-0500"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0500" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0500-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0500" in row 1
And I set field "mge" to "500" in row 1
And I set field "preis" to "0500" in row 1
And I set field "kenn" to "FALL-0500"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0500"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0500" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0500"
And I set field "num3" to "0500-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0500" in row 1
And I set field "kenn" to "FALL-0500"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0500"
And I close the current editor

# Rechnung anlegen aus Lieferschein
Given I open an editor "rechnung-0500" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-0500"
And I set field "num3" to "0500-RE"
And I set field "ueb" to "ja"
And I set field "mge" to "500" in row 1
And I set field "preis" to "0500" in row 1
And I set field "kenn" to "FALL-0500"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0500-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0500" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0500"
And I set field "num3" to "0500-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0500 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0500"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0500" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0500"
And I set field "num3" to "0500-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0500" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0500"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0500"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0500" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0500"
And I set field "num3" to "0500-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0500"
And I close the current editor

# Gutschrift2 anlegen
Given I open an editor "Gutschrift2-0500" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0500"
And I set field "num3" to "0500-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0500" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0500"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift2
Given I open an editor "Gutschrift2-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift2-0500"
And I close the current editor

#####################################################################################################################################

@FALL-0510
Scenario: FALL-0510
# VK Auftrag Lieferschein Rücklieferschein Storno-Rücklieferschein

# Konto 0510-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0510FALL"
And I set field "such" to "FALL-0510"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0510-MG"
And I set field "such" to "FALL-0510"
And I set field "bestausekso" to "FALL-0510"
And I save the current editor

# Konto 40510-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40510FAL"
And I set field "such" to "FALL-40510"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0510-PG"
And I set field "such" to "FALL-0510"
And I set field "pgerlo" to "FALL-40510"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0510-FALL"
And I set field "num2" to "0510-FALL"
And I set field "such" to "FALL-0510"
And I set field "namebspr" to "FALL-0510"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0510-MG"
And I set field "erlgrp" to "0510-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0510" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0510-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0510" in row 1
And I set field "mge" to "0510" in row 1
And I set field "preis" to "0510" in row 1
And I set field "kenn" to "FALL-0510"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0510" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0510-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0510" in row 1
And I set field "mge" to "0510" in row 1
And I set field "preis" to "0510" in row 1
And I set field "kenn" to "FALL-0510"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0510"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0510" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0510"
And I set field "num3" to "0510-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0510" in row 1
And I set field "kenn" to "FALL-0510"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0510"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0510" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0510"
And I set field "num3" to "0510-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0510 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0510"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0510" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0510"
And I set field "num3" to "0510-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0510"
And I close the current editor

#####################################################################################################################################

@FALL-0520
Scenario: FALL-0520
# VK Auftrag Lieferschein Rücklieferschein Storno-Rücklieferschein Storno-Lieferschein

# Konto 0520-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0520FALL"
And I set field "such" to "FALL-0520"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0520-MG"
And I set field "such" to "FALL-0520"
And I set field "bestausekso" to "FALL-0520"
And I save the current editor

# Konto 40520-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40520FAL"
And I set field "such" to "FALL-40520"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0520-PG"
And I set field "such" to "FALL-0520"
And I set field "pgerlo" to "FALL-40520"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0520-FALL"
And I set field "num2" to "0520-FALL"
And I set field "such" to "FALL-0520"
And I set field "namebspr" to "FALL-0520"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0520-MG"
And I set field "erlgrp" to "0520-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0520" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0520-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0520" in row 1
And I set field "mge" to "0520" in row 1
And I set field "preis" to "0520" in row 1
And I set field "kenn" to "FALL-0520"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0520" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0520-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0520" in row 1
And I set field "mge" to "0520" in row 1
And I set field "preis" to "0520" in row 1
And I set field "kenn" to "FALL-0520"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0520"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0520" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0520"
And I set field "num3" to "0520-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0520" in row 1
And I set field "kenn" to "FALL-0520"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0520"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0520" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0520"
And I set field "num3" to "0520-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0520 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0520"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0520" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0520"
And I set field "num3" to "0520-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0520"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0520" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0520"
And I set field "num3" to "0520-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0520"
And I close the current editor

#####################################################################################################################################

@FALL-0530
Scenario: FALL-0530
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein

# Konto 0530-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0530FALL"
And I set field "such" to "FALL-0530"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0530-MG"
And I set field "such" to "FALL-0530"
And I set field "bestausekso" to "FALL-0530"
And I save the current editor

# Konto 40530-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40530FAL"
And I set field "such" to "FALL-40530"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0530-PG"
And I set field "such" to "FALL-0530"
And I set field "pgerlo" to "FALL-40530"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0530-FALL"
And I set field "num2" to "0530-FALL"
And I set field "such" to "FALL-0530"
And I set field "namebspr" to "FALL-0530"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0530-MG"
And I set field "erlgrp" to "0530-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0530" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0530-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0530" in row 1
And I set field "mge" to "0530" in row 1
And I set field "preis" to "0530" in row 1
And I set field "kenn" to "FALL-0530"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0530" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0530-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0530" in row 1
And I set field "mge" to "0530" in row 1
And I set field "preis" to "0530" in row 1
And I set field "kenn" to "FALL-0530"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0530"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0530" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0530"
And I set field "num3" to "0530-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0530" in row 1
And I set field "kenn" to "FALL-0530"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0530"
And I close the current editor

#####################################################################################################################################

@FALL-0540
Scenario: FALL-0540
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager

# Konto 0540-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0540FALL"
And I set field "such" to "FALL-0540"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0540-MG"
And I set field "such" to "FALL-0540"
And I set field "bestausekso" to "FALL-0540"
And I save the current editor

# Konto 40540-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40540FAL"
And I set field "such" to "FALL-40540"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0540-PG"
And I set field "such" to "FALL-0540"
And I set field "pgerlo" to "FALL-40540"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0540-FALL"
And I set field "num2" to "0540-FALL"
And I set field "such" to "FALL-0540"
And I set field "namebspr" to "FALL-0540"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0540-MG"
And I set field "erlgrp" to "0540-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0540" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0540-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0540" in row 1
And I set field "mge" to "0540" in row 1
And I set field "preis" to "0540" in row 1
And I set field "kenn" to "FALL-0540"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0540" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0540-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0540" in row 1
And I set field "mge" to "0540" in row 1
And I set field "preis" to "0540" in row 1
And I set field "kenn" to "FALL-0540"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0540"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0540" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0540"
And I set field "num3" to "0540-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0540" in row 1
And I set field "kenn" to "FALL-0540"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0540"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0540" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0540"
And I set field "kunde" to "1"
And I set field "num3" to "0540-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0540" in row 1
And I set field "preis" to "0540" in row 1
And I set field "kenn" to "FALL-0540"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0540"
And I close the current editor

#####################################################################################################################################

@FALL-0550
Scenario: FALL-0550
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager

# Konto 0550-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0550FALL"
And I set field "such" to "FALL-0550"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0550-MG"
And I set field "such" to "FALL-0550"
And I set field "bestausekso" to "FALL-0550"
And I save the current editor

# Konto 40550-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40550FAL"
And I set field "such" to "FALL-40550"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0550-PG"
And I set field "such" to "FALL-0550"
And I set field "pgerlo" to "FALL-40550"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0550-FALL"
And I set field "num2" to "0550-FALL"
And I set field "such" to "FALL-0550"
And I set field "namebspr" to "FALL-0550"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0550-MG"
And I set field "erlgrp" to "0550-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0550" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0550-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0550" in row 1
And I set field "mge" to "0550" in row 1
And I set field "preis" to "0550" in row 1
And I set field "kenn" to "FALL-0550"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0550" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0550-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0550" in row 1
And I set field "mge" to "0550" in row 1
And I set field "preis" to "0550" in row 1
And I set field "kenn" to "FALL-0550"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0550"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0550" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0550"
And I set field "num3" to "0550-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0550" in row 1
And I set field "kenn" to "FALL-0550"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0550"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0550" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0550"
And I set field "kunde" to "1"
And I set field "num3" to "0550-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0550" in row 1
And I set field "preis" to "0550" in row 1
And I set field "kenn" to "FALL-0550"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0550"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0550" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0550"
And I set field "num3" to "0550-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0550"
And I close the current editor

#####################################################################################################################################

@FALL-0560
Scenario: FALL-0560
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rechnung ohne Lagerbewegung

# Konto 0560-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0560FALL"
And I set field "such" to "FALL-0560"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0560-MG"
And I set field "such" to "FALL-0560"
And I set field "bestausekso" to "FALL-0560"
And I save the current editor

# Konto 40560-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40560FAL"
And I set field "such" to "FALL-40560"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0560-PG"
And I set field "such" to "FALL-0560"
And I set field "pgerlo" to "FALL-40560"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0560-FALL"
And I set field "num2" to "0560-FALL"
And I set field "such" to "FALL-0560"
And I set field "namebspr" to "FALL-0560"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0560-MG"
And I set field "erlgrp" to "0560-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0560" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0560-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0560" in row 1
And I set field "mge" to "0560" in row 1
And I set field "preis" to "0560" in row 1
And I set field "kenn" to "FALL-0560"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0560" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0560-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0560" in row 1
And I set field "mge" to "0560" in row 1
And I set field "preis" to "0560" in row 1
And I set field "kenn" to "FALL-0560"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0560"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0560" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0560"
And I set field "num3" to "0560-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0560" in row 1
And I set field "kenn" to "FALL-0560"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0560"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0560" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0560"
And I set field "kunde" to "1"
And I set field "num3" to "0560-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0560" in row 1
And I set field "preis" to "0560" in row 1
And I set field "kenn" to "FALL-0560"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0560"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0560" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0560"
And I set field "num3" to "0560-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0560"
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "Rechnung2-0560" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0560"
And I set field "kunde" to "1"
And I set field "num3" to "0560-RE2"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0560" in row 1
And I set field "preis" to "0560" in row 1
And I set field "kenn" to "FALL-0560"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung2
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Rechnung2-0560"
And I close the current editor

#####################################################################################################################################

@FALL-0570
Scenario: FALL-0570
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Storno-Lieferschein

# Konto 0570-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0570FALL"
And I set field "such" to "FALL-0570"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0570-MG"
And I set field "such" to "FALL-0570"
And I set field "bestausekso" to "FALL-0570"
And I save the current editor

# Konto 40570-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40570FAL"
And I set field "such" to "FALL-40570"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0570-PG"
And I set field "such" to "FALL-0570"
And I set field "pgerlo" to "FALL-40570"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0570-FALL"
And I set field "num2" to "0570-FALL"
And I set field "such" to "FALL-0570"
And I set field "namebspr" to "FALL-0570"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0570-MG"
And I set field "erlgrp" to "0570-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0570" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0570-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0570" in row 1
And I set field "mge" to "0570" in row 1
And I set field "preis" to "0570" in row 1
And I set field "kenn" to "FALL-0570"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0570" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0570-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0570" in row 1
And I set field "mge" to "0570" in row 1
And I set field "preis" to "0570" in row 1
And I set field "kenn" to "FALL-0570"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0570"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0570" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0570"
And I set field "num3" to "0570-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0570" in row 1
And I set field "kenn" to "FALL-0570"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0570"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0570" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0570"
And I set field "kunde" to "1"
And I set field "num3" to "0570-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0570" in row 1
And I set field "preis" to "0570" in row 1
And I set field "kenn" to "FALL-0570"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0570"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0570" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0570"
And I set field "num3" to "0570-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0570"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0570" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0570"
And I set field "num3" to "0570-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0570"
And I close the current editor

#####################################################################################################################################

@FALL-0580
Scenario: FALL-0580
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager
# Storno-Rechnung ohne Lager Storno-Lieferschein Lieferschein

# Konto 0580-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0580FALL"
And I set field "such" to "FALL-0580"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0580-MG"
And I set field "such" to "FALL-0580"
And I set field "bestausekso" to "FALL-0580"
And I save the current editor

# Konto 40580-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40580FAL"
And I set field "such" to "FALL-40580"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0580-PG"
And I set field "such" to "FALL-0580"
And I set field "pgerlo" to "FALL-40580"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0580-FALL"
And I set field "num2" to "0580-FALL"
And I set field "such" to "FALL-0580"
And I set field "namebspr" to "FALL-0580"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0580-MG"
And I set field "erlgrp" to "0580-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0580" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0580-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0580" in row 1
And I set field "mge" to "0580" in row 1
And I set field "preis" to "0580" in row 1
And I set field "kenn" to "FALL-0580"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0580" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0580-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0580" in row 1
And I set field "mge" to "0580" in row 1
And I set field "preis" to "0580" in row 1
And I set field "kenn" to "FALL-0580"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0580"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0580" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0580"
And I set field "num3" to "0580-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0580" in row 1
And I set field "kenn" to "FALL-0580"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0580"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0580" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0580"
And I set field "kunde" to "1"
And I set field "num3" to "0580-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0580" in row 1
And I set field "preis" to "0580" in row 1
And I set field "kenn" to "FALL-0580"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0580"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0580" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0580"
And I set field "num3" to "0580-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0580"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0580" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0580"
And I set field "num3" to "0580-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0580"
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein2-0580" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0580"
And I set field "num3" to "0580-LS2"
# Wir wollen eine Rechnung zum Lieferschein machen, daher hier fakt = nein
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0580" in row 1
And I set field "kenn" to "FALL-0580"
And I save the current editor

# Ausgabe Lieferschein2
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein2-0580"
And I close the current editor

#####################################################################################################################################

@FALL-0590
Scenario: FALL-0590
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein

# Konto 0590-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0590FALL"
And I set field "such" to "FALL-0590"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0590-MG"
And I set field "such" to "FALL-0590"
And I set field "bestausekso" to "FALL-0590"
And I save the current editor

# Konto 40590-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40590FAL"
And I set field "such" to "FALL-40590"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0590-PG"
And I set field "such" to "FALL-0590"
And I set field "pgerlo" to "FALL-40590"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0590-FALL"
And I set field "num2" to "0590-FALL"
And I set field "such" to "FALL-0590"
And I set field "namebspr" to "FALL-0590"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0590-MG"
And I set field "erlgrp" to "0590-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0590" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0590-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0590" in row 1
And I set field "mge" to "0590" in row 1
And I set field "preis" to "0590" in row 1
And I set field "kenn" to "FALL-0590"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0590" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0590-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0590" in row 1
And I set field "mge" to "0590" in row 1
And I set field "preis" to "0590" in row 1
And I set field "kenn" to "FALL-0590"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0590"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0590" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0590"
And I set field "num3" to "0590-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0590" in row 1
And I set field "kenn" to "FALL-0590"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0590"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0590" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0590"
And I set field "kunde" to "1"
And I set field "num3" to "0590-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0590" in row 1
And I set field "preis" to "0590" in row 1
And I set field "kenn" to "FALL-0590"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0590"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0590" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0590"
And I set field "num3" to "0590-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0590 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0590"
And I close the current editor

#####################################################################################################################################

@FALL-0600
Scenario: FALL-0600
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Gutschrift

# Konto 0600-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0600FALL"
And I set field "such" to "FALL-0600"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0600-MG"
And I set field "such" to "FALL-0600"
And I set field "bestausekso" to "FALL-0600"
And I save the current editor

# Konto 40600-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40600FAL"
And I set field "such" to "FALL-40600"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0600-PG"
And I set field "such" to "FALL-0600"
And I set field "pgerlo" to "FALL-40600"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0600-FALL"
And I set field "num2" to "0600-FALL"
And I set field "such" to "FALL-0600"
And I set field "namebspr" to "FALL-0600"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0600-MG"
And I set field "erlgrp" to "0600-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0600" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0600-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0600" in row 1
And I set field "mge" to "0600" in row 1
And I set field "preis" to "0600" in row 1
And I set field "kenn" to "FALL-0600"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0600" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0600-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0600" in row 1
And I set field "mge" to "0600" in row 1
And I set field "preis" to "0600" in row 1
And I set field "kenn" to "FALL-0600"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0600"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0600" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0600"
And I set field "num3" to "0600-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0600" in row 1
And I set field "kenn" to "FALL-0600"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0600"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0600" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0600"
And I set field "kunde" to "1"
And I set field "num3" to "0600-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0600" in row 1
And I set field "preis" to "0600" in row 1
And I set field "kenn" to "FALL-0600"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0600"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0600" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0600"
And I set field "num3" to "0600-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0600 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0600"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0600" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0600"
And I set field "num3" to "0600-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0600" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0600"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0600"
And I close the current editor

#####################################################################################################################################

@FALL-0610
Scenario: FALL-0610
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift

# Konto 0610-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0610FALL"
And I set field "such" to "FALL-0610"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0610-MG"
And I set field "such" to "FALL-0610"
And I set field "bestausekso" to "FALL-0610"
And I save the current editor

# Konto 40610-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40610FAL"
And I set field "such" to "FALL-40610"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0610-PG"
And I set field "such" to "FALL-0610"
And I set field "pgerlo" to "FALL-40610"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0610-FALL"
And I set field "num2" to "0610-FALL"
And I set field "such" to "FALL-0610"
And I set field "namebspr" to "FALL-0610"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0610-MG"
And I set field "erlgrp" to "0610-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0610" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0610-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0610" in row 1
And I set field "mge" to "0610" in row 1
And I set field "preis" to "0610" in row 1
And I set field "kenn" to "FALL-0610"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0610" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0610-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0610" in row 1
And I set field "mge" to "0610" in row 1
And I set field "preis" to "0610" in row 1
And I set field "kenn" to "FALL-0610"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0610"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0610" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0610"
And I set field "num3" to "0610-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0610" in row 1
And I set field "kenn" to "FALL-0610"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0610"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0610" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0610"
And I set field "kunde" to "1"
And I set field "num3" to "0610-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0610" in row 1
And I set field "preis" to "0610" in row 1
And I set field "kenn" to "FALL-0610"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0610"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0610" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0610"
And I set field "num3" to "0610-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0610 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0610"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0610" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0610"
And I set field "num3" to "0610-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0610" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0610"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0610"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0610" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0610"
And I set field "num3" to "0610-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0610"
And I close the current editor

#####################################################################################################################################

@FALL-0620
Scenario: FALL-0620
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein

# Konto 0620-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0620FALL"
And I set field "such" to "FALL-0620"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0620-MG"
And I set field "such" to "FALL-0620"
And I set field "bestausekso" to "FALL-0620"
And I save the current editor

# Konto 40620-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40620FAL"
And I set field "such" to "FALL-40620"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0620-PG"
And I set field "such" to "FALL-0620"
And I set field "pgerlo" to "FALL-40620"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0620-FALL"
And I set field "num2" to "0620-FALL"
And I set field "such" to "FALL-0620"
And I set field "namebspr" to "FALL-0620"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0620-MG"
And I set field "erlgrp" to "0620-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0620" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0620-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0620" in row 1
And I set field "mge" to "0620" in row 1
And I set field "preis" to "0620" in row 1
And I set field "kenn" to "FALL-0620"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0620" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0620-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0620" in row 1
And I set field "mge" to "0620" in row 1
And I set field "preis" to "0620" in row 1
And I set field "kenn" to "FALL-0620"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0620"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0620" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0620"
And I set field "num3" to "0620-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0620" in row 1
And I set field "kenn" to "FALL-0620"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0620"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0620" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0620"
And I set field "kunde" to "1"
And I set field "num3" to "0620-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0620" in row 1
And I set field "preis" to "0620" in row 1
And I set field "kenn" to "FALL-0620"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0620"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0620" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0620"
And I set field "num3" to "0620-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0620 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0620"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0620" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0620"
And I set field "num3" to "0620-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0620" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0620"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0620"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0620" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0620"
And I set field "num3" to "0620-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0620"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0620" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0620"
And I set field "num3" to "0620-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0620"
And I close the current editor

#####################################################################################################################################

@FALL-0630
Scenario: FALL-0630
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Rücklieferschein

# Konto 0630-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0630FALL"
And I set field "such" to "FALL-0630"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0630-MG"
And I set field "such" to "FALL-0630"
And I set field "bestausekso" to "FALL-0630"
And I save the current editor

# Konto 40630-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40630FAL"
And I set field "such" to "FALL-40630"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0630-PG"
And I set field "such" to "FALL-0630"
And I set field "pgerlo" to "FALL-40630"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0630-FALL"
And I set field "num2" to "0630-FALL"
And I set field "such" to "FALL-0630"
And I set field "namebspr" to "FALL-0630"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0630-MG"
And I set field "erlgrp" to "0630-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0630" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0630-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0630" in row 1
And I set field "mge" to "0630" in row 1
And I set field "preis" to "0630" in row 1
And I set field "kenn" to "FALL-0630"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0630" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0630-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0630" in row 1
And I set field "mge" to "0630" in row 1
And I set field "preis" to "0630" in row 1
And I set field "kenn" to "FALL-0630"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0630"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0630" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0630"
And I set field "num3" to "0630-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0630" in row 1
And I set field "kenn" to "FALL-0630"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0630"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0630" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0630"
And I set field "kunde" to "1"
And I set field "num3" to "0630-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0630" in row 1
And I set field "preis" to "0630" in row 1
And I set field "kenn" to "FALL-0630"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0630"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0630" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0630"
And I set field "num3" to "0630-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0630 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0630"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0630" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0630"
And I set field "num3" to "0630-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0630" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0630"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0630"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0630" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0630"
And I set field "num3" to "0630-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0630"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0630" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0630"
And I set field "num3" to "0630-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0630"
And I close the current editor

# Rücklieferschein2 anlegen
Given I open an editor "Ruecklieferschein2-0630" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0630"
And I set field "num3" to "0630-RL2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0630 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein2-0630"
And I close the current editor

#####################################################################################################################################

@FALL-0640
Scenario: FALL-0640
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno Rechnung ohne Lager

# Konto 0640-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0640FALL"
And I set field "such" to "FALL-0640"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0640-MG"
And I set field "such" to "FALL-0640"
And I set field "bestausekso" to "FALL-0640"
And I save the current editor

# Konto 40640-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40640FAL"
And I set field "such" to "FALL-40640"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0640-PG"
And I set field "such" to "FALL-0640"
And I set field "pgerlo" to "FALL-40640"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0640-FALL"
And I set field "num2" to "0640-FALL"
And I set field "such" to "FALL-0640"
And I set field "namebspr" to "FALL-0640"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0640-MG"
And I set field "erlgrp" to "0640-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0640" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0640-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0640" in row 1
And I set field "mge" to "0640" in row 1
And I set field "preis" to "0640" in row 1
And I set field "kenn" to "FALL-0640"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0640" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0640-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0640" in row 1
And I set field "mge" to "0640" in row 1
And I set field "preis" to "0640" in row 1
And I set field "kenn" to "FALL-0640"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0640"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0640" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0640"
And I set field "num3" to "0640-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0640" in row 1
And I set field "kenn" to "FALL-0640"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0640"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0640" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0640"
And I set field "kunde" to "1"
And I set field "num3" to "0640-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0640" in row 1
And I set field "preis" to "0640" in row 1
And I set field "kenn" to "FALL-0640"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0640"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0640" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0640"
And I set field "num3" to "0640-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0640 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0640"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0640" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0640"
And I set field "num3" to "0640-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0640" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0640"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0640"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0640" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0640"
And I set field "num3" to "0640-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0640"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0640" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0640"
And I set field "num3" to "0640-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0640"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0640" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0640"
And I set field "num3" to "0640-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0640"
And I close the current editor

#####################################################################################################################################

@FALL-0650
Scenario: FALL-0650
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno Rechnung ohne Lager Storno-Lieferschein

# Konto 0650-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0650FALL"
And I set field "such" to "FALL-0650"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0650-MG"
And I set field "such" to "FALL-0650"
And I set field "bestausekso" to "FALL-0650"
And I save the current editor

# Konto 40650-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40650FAL"
And I set field "such" to "FALL-40650"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0650-PG"
And I set field "such" to "FALL-0650"
And I set field "pgerlo" to "FALL-40650"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0650-FALL"
And I set field "num2" to "0650-FALL"
And I set field "such" to "FALL-0650"
And I set field "namebspr" to "FALL-0650"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0650-MG"
And I set field "erlgrp" to "0650-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0650" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0650-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0650" in row 1
And I set field "mge" to "0650" in row 1
And I set field "preis" to "0650" in row 1
And I set field "kenn" to "FALL-0650"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0650" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0650-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0650" in row 1
And I set field "mge" to "0650" in row 1
And I set field "preis" to "0650" in row 1
And I set field "kenn" to "FALL-0650"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0650"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0650" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0650"
And I set field "num3" to "0650-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0650" in row 1
And I set field "kenn" to "FALL-0650"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0650"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0650" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0650"
And I set field "kunde" to "1"
And I set field "num3" to "0650-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0650" in row 1
And I set field "preis" to "0650" in row 1
And I set field "kenn" to "FALL-0650"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0650"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0650" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0650"
And I set field "num3" to "0650-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0650 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0650"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0650" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0650"
And I set field "num3" to "0650-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0650" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0650"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0650"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0650" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0650"
And I set field "num3" to "0650-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0650"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0650" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0650"
And I set field "num3" to "0650-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0650"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0650" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0650"
And I set field "num3" to "0650-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0650"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0650" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0650"
And I set field "num3" to "0650-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0650"
And I close the current editor

#####################################################################################################################################

@FALL-0660
Scenario: FALL-0660
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Gutschrift

# Konto 0660-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0660FALL"
And I set field "such" to "FALL-0660"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0660-MG"
And I set field "such" to "FALL-0660"
And I set field "bestausekso" to "FALL-0660"
And I save the current editor

# Konto 40660-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40660FAL"
And I set field "such" to "FALL-40660"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0660-PG"
And I set field "such" to "FALL-0660"
And I set field "pgerlo" to "FALL-40660"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0660-FALL"
And I set field "num2" to "0660-FALL"
And I set field "such" to "FALL-0660"
And I set field "namebspr" to "FALL-0660"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0660-MG"
And I set field "erlgrp" to "0660-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0660" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0660-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0660" in row 1
And I set field "mge" to "0660" in row 1
And I set field "preis" to "0660" in row 1
And I set field "kenn" to "FALL-0660"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0660" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0660-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0660" in row 1
And I set field "mge" to "0660" in row 1
And I set field "preis" to "0660" in row 1
And I set field "kenn" to "FALL-0660"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0660"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0660" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0660"
And I set field "num3" to "0660-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0660" in row 1
And I set field "kenn" to "FALL-0660"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0660"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0660" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0660"
And I set field "kunde" to "1"
And I set field "num3" to "0660-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0660" in row 1
And I set field "preis" to "0660" in row 1
And I set field "kenn" to "FALL-0660"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0660"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0660" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0660"
And I set field "num3" to "0660-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0660 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0660"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0660" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0660"
And I set field "num3" to "0660-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0660" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0660"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0660"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0660" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0660"
And I set field "num3" to "0660-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0660"
And I close the current editor

# # Gutschrift2 anlegen
# Given I open an editor "Gutschrift2-0660" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0660"
# And I set field "num3" to "0660-GS2"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# # And I set field "fakt" to "NEIN"
# # And I set field "mge" to "0660" in row 1
# # And I set field "preis" to "-10" in row 1
# And I set field "kenn" to "FALL-0660"
# And I respond with answer "JA" to the dialog with id "4841"
# And I save the current editor
#
# # Ausgabe Gutschrift
# Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift2-0660"
# And I close the current editor

#####################################################################################################################################

@FALL-0670
Scenario: FALL-0670
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein

# Konto 0670-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0670FALL"
And I set field "such" to "FALL-0670"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0670-MG"
And I set field "such" to "FALL-0670"
And I set field "bestausekso" to "FALL-0670"
And I save the current editor

# Konto 40670-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40670FAL"
And I set field "such" to "FALL-40670"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0670-PG"
And I set field "such" to "FALL-0670"
And I set field "pgerlo" to "FALL-40670"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0670-FALL"
And I set field "num2" to "0670-FALL"
And I set field "such" to "FALL-0670"
And I set field "namebspr" to "FALL-0670"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0670-MG"
And I set field "erlgrp" to "0670-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0670" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0670-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0670" in row 1
And I set field "mge" to "0670" in row 1
And I set field "preis" to "0670" in row 1
And I set field "kenn" to "FALL-0670"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0670" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0670-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0670" in row 1
And I set field "mge" to "0670" in row 1
And I set field "preis" to "0670" in row 1
And I set field "kenn" to "FALL-0670"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0670"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0670" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0670"
And I set field "num3" to "0670-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0670" in row 1
And I set field "kenn" to "FALL-0670"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0670"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0670" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0670"
And I set field "kunde" to "1"
And I set field "num3" to "0670-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0670" in row 1
And I set field "preis" to "0670" in row 1
And I set field "kenn" to "FALL-0670"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0670"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0670" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0670"
And I set field "num3" to "0670-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0670 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0670"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0670" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0670"
And I set field "num3" to "0670-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0670"
And I close the current editor

#####################################################################################################################################

@FALL-0675
Scenario: FALL-0675
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein Storno-Rechnung

# Konto 0675-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0675FALL"
And I set field "such" to "FALL-0675"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0675-MG"
And I set field "such" to "FALL-0675"
And I set field "bestausekso" to "FALL-0675"
And I save the current editor

# Konto 40675-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40675FAL"
And I set field "such" to "FALL-40675"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0675-PG"
And I set field "such" to "FALL-0675"
And I set field "pgerlo" to "FALL-40675"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0675-FALL"
And I set field "num2" to "0675-FALL"
And I set field "such" to "FALL-0675"
And I set field "namebspr" to "FALL-0675"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0675-MG"
And I set field "erlgrp" to "0675-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0675" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0675-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0675" in row 1
And I set field "mge" to "0675" in row 1
And I set field "preis" to "0675" in row 1
And I set field "kenn" to "FALL-0675"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0675" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0675-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0675" in row 1
And I set field "mge" to "0675" in row 1
And I set field "preis" to "0675" in row 1
And I set field "kenn" to "FALL-0675"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0675"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0675" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0675"
And I set field "num3" to "0675-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0675" in row 1
And I set field "kenn" to "FALL-0675"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0675"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0675" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0675"
And I set field "kunde" to "1"
And I set field "num3" to "0675-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0675" in row 1
And I set field "preis" to "0675" in row 1
And I set field "kenn" to "FALL-0675"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0675"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0675" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0675"
And I set field "num3" to "0675-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0675 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0675"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0675" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0675"
And I set field "num3" to "0675-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0675"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0675" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0675"
And I set field "num3" to "0675-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0675"
And I close the current editor

#####################################################################################################################################

@FALL-0680
Scenario: FALL-0680
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein Storno-Rechnung Storno-Lieferschein

# Konto 0680-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0680FALL"
And I set field "such" to "FALL-0680"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0680-MG"
And I set field "such" to "FALL-0680"
And I set field "bestausekso" to "FALL-0680"
And I save the current editor

# Konto 40680-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40680FAL"
And I set field "such" to "FALL-40680"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0680-PG"
And I set field "such" to "FALL-0680"
And I set field "pgerlo" to "FALL-40680"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0680-FALL"
And I set field "num2" to "0680-FALL"
And I set field "such" to "FALL-0680"
And I set field "namebspr" to "FALL-0680"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0680-MG"
And I set field "erlgrp" to "0680-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0680" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0680-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0680" in row 1
And I set field "mge" to "0680" in row 1
And I set field "preis" to "0680" in row 1
And I set field "kenn" to "FALL-0680"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0680" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0680-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0680" in row 1
And I set field "mge" to "0680" in row 1
And I set field "preis" to "0680" in row 1
And I set field "kenn" to "FALL-0680"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0680"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0680" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0680"
And I set field "num3" to "0680-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0680" in row 1
And I set field "kenn" to "FALL-0680"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0680"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0680" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0680"
And I set field "kunde" to "1"
And I set field "num3" to "0680-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0680" in row 1
And I set field "preis" to "0680" in row 1
And I set field "kenn" to "FALL-0680"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0680"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0680" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0680"
And I set field "num3" to "0680-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0680 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0680"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0680" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0680"
And I set field "num3" to "0680-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0680"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0680" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0680"
And I set field "num3" to "0680-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0680"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0680" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0680"
And I set field "num3" to "0680-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0680"
And I close the current editor

#####################################################################################################################################

@FALL-0690
Scenario: FALL-0690
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein

# Konto 0690-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0690FALL"
And I set field "such" to "FALL-0690"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0690-MG"
And I set field "such" to "FALL-0690"
And I set field "bestausekso" to "FALL-0690"
And I save the current editor

# Konto 40690-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40690FAL"
And I set field "such" to "FALL-40690"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0690-PG"
And I set field "such" to "FALL-0690"
And I set field "pgerlo" to "FALL-40690"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0690-FALL"
And I set field "num2" to "0690-FALL"
And I set field "such" to "FALL-0690"
And I set field "namebspr" to "FALL-0690"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0690-MG"
And I set field "erlgrp" to "0690-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0690" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0690-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0690" in row 1
And I set field "mge" to "0690" in row 1
And I set field "preis" to "0690" in row 1
And I set field "kenn" to "FALL-0690"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0690" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0690-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0690" in row 1
And I set field "mge" to "0690" in row 1
And I set field "preis" to "0690" in row 1
And I set field "kenn" to "FALL-0690"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0690"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0690" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0690"
And I set field "num3" to "0690-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0690" in row 1
And I set field "kenn" to "FALL-0690"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0690"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0690" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0690"
And I set field "kunde" to "1"
And I set field "num3" to "0690-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0690" in row 1
And I set field "preis" to "0690" in row 1
And I set field "kenn" to "FALL-0690"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0690"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0690" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0690"
And I set field "num3" to "0690-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0690"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0690" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0690"
And I set field "num3" to "0690-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0690 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0690"
And I close the current editor

#####################################################################################################################################

@FALL-0700
Scenario: FALL-0700
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift

# Konto 0700-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0700FALL"
And I set field "such" to "FALL-0700"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0700-MG"
And I set field "such" to "FALL-0700"
And I set field "bestausekso" to "FALL-0700"
And I save the current editor

# Konto 40700-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40700FAL"
And I set field "such" to "FALL-40700"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0700-PG"
And I set field "such" to "FALL-0700"
And I set field "pgerlo" to "FALL-40700"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0700-FALL"
And I set field "num2" to "0700-FALL"
And I set field "such" to "FALL-0700"
And I set field "namebspr" to "FALL-0700"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0700-MG"
And I set field "erlgrp" to "0700-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0700" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0700-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0700" in row 1
And I set field "mge" to "0700" in row 1
And I set field "preis" to "0700" in row 1
And I set field "kenn" to "FALL-0700"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0700" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0700-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0700" in row 1
And I set field "mge" to "0700" in row 1
And I set field "preis" to "0700" in row 1
And I set field "kenn" to "FALL-0700"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0700"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0700" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0700"
And I set field "num3" to "0700-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0700" in row 1
And I set field "kenn" to "FALL-0700"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0700"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0700" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0700"
And I set field "kunde" to "1"
And I set field "num3" to "0700-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0700" in row 1
And I set field "preis" to "0700" in row 1
And I set field "kenn" to "FALL-0700"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0700"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0700" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0700"
And I set field "num3" to "0700-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0700 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0700"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0700" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0700"
And I set field "num3" to "0700-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0700" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0700"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0700"
And I close the current editor

# Storno Rechnung
Given opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0700" throws the exception "2006"
# Fehler: Diese Rechnung wurde bereits in einer kaufmaennischen Gutschrift verrechnet.

#####################################################################################################################################

@FALL-0710
Scenario: FALL-0710
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift

# Konto 0710-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0710FALL"
And I set field "such" to "FALL-0710"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0710-MG"
And I set field "such" to "FALL-0710"
And I set field "bestausekso" to "FALL-0710"
And I save the current editor

# Konto 40710-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40710FAL"
And I set field "such" to "FALL-40710"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0710-PG"
And I set field "such" to "FALL-0710"
And I set field "pgerlo" to "FALL-40710"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0710-FALL"
And I set field "num2" to "0710-FALL"
And I set field "such" to "FALL-0710"
And I set field "namebspr" to "FALL-0710"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0710-MG"
And I set field "erlgrp" to "0710-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0710" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0710-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0710" in row 1
And I set field "mge" to "0710" in row 1
And I set field "preis" to "0710" in row 1
And I set field "kenn" to "FALL-0710"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0710" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0710-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0710" in row 1
And I set field "mge" to "0710" in row 1
And I set field "preis" to "0710" in row 1
And I set field "kenn" to "FALL-0710"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0710"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0710" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0710"
And I set field "num3" to "0710-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0710" in row 1
And I set field "kenn" to "FALL-0710"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0710"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0710" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0710"
And I set field "kunde" to "1"
And I set field "num3" to "0710-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0710" in row 1
And I set field "preis" to "0710" in row 1
And I set field "kenn" to "FALL-0710"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0710"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0710" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0710"
And I set field "num3" to "0710-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0710 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0710"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0710" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0710"
And I set field "num3" to "0710-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0710" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0710"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0710"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0710" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0710"
And I set field "num3" to "0710-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0710"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0710" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0710"
And I set field "num3" to "0710-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0710"
And I close the current editor

#####################################################################################################################################

@FALL-0720
Scenario: FALL-0720
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein

# Konto 0720-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0720FALL"
And I set field "such" to "FALL-0720"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0720-MG"
And I set field "such" to "FALL-0720"
And I set field "bestausekso" to "FALL-0720"
And I save the current editor

# Konto 40720-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40720FAL"
And I set field "such" to "FALL-40720"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0720-PG"
And I set field "such" to "FALL-0720"
And I set field "pgerlo" to "FALL-40720"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0720-FALL"
And I set field "num2" to "0720-FALL"
And I set field "such" to "FALL-0720"
And I set field "namebspr" to "FALL-0720"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0720-MG"
And I set field "erlgrp" to "0720-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0720" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0720-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0720" in row 1
And I set field "mge" to "0720" in row 1
And I set field "preis" to "0720" in row 1
And I set field "kenn" to "FALL-0720"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0720" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0720-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0720" in row 1
And I set field "mge" to "0720" in row 1
And I set field "preis" to "0720" in row 1
And I set field "kenn" to "FALL-0720"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0720"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0720" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0720"
And I set field "num3" to "0720-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0720" in row 1
And I set field "kenn" to "FALL-0720"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0720"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0720" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0720"
And I set field "kunde" to "1"
And I set field "num3" to "0720-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0720" in row 1
And I set field "preis" to "0720" in row 1
And I set field "kenn" to "FALL-0720"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0720"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0720" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0720"
And I set field "num3" to "0720-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0720 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0720"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0720" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0720"
And I set field "num3" to "0720-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0720" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0720"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0720"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0720" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0720"
And I set field "num3" to "0720-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0720"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0720" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0720"
And I set field "num3" to "0720-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0720"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0720" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0720"
And I set field "num3" to "0720-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0720"
And I close the current editor

#####################################################################################################################################

@FALL-0730
Scenario: FALL-0730
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Rücklieferschein

# Konto 0730-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0730FALL"
And I set field "such" to "FALL-0730"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0730-MG"
And I set field "such" to "FALL-0730"
And I set field "bestausekso" to "FALL-0730"
And I save the current editor

# Konto 40730-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40730FAL"
And I set field "such" to "FALL-40730"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0730-PG"
And I set field "such" to "FALL-0730"
And I set field "pgerlo" to "FALL-40730"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0730-FALL"
And I set field "num2" to "0730-FALL"
And I set field "such" to "FALL-0730"
And I set field "namebspr" to "FALL-0730"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0730-MG"
And I set field "erlgrp" to "0730-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0730" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0730-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0730" in row 1
And I set field "mge" to "0730" in row 1
And I set field "preis" to "0730" in row 1
And I set field "kenn" to "FALL-0730"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0730" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0730-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0730" in row 1
And I set field "mge" to "0730" in row 1
And I set field "preis" to "0730" in row 1
And I set field "kenn" to "FALL-0730"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0730"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0730" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0730"
And I set field "num3" to "0730-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0730" in row 1
And I set field "kenn" to "FALL-0730"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0730"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0730" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0730"
And I set field "kunde" to "1"
And I set field "num3" to "0730-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0730" in row 1
And I set field "preis" to "0730" in row 1
And I set field "kenn" to "FALL-0730"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0730"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0730" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0730"
And I set field "num3" to "0730-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0730 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0730"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0730" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0730"
And I set field "num3" to "0730-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0730" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0730"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0730"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0730" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0730"
And I set field "num3" to "0730-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0730"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0730" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0730"
And I set field "num3" to "0730-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0730"
And I close the current editor

# Rücklieferschein2 anlegen
Given I open an editor "Ruecklieferschein2-0730" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0730"
And I set field "num3" to "0730-RL2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0730 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein2-0730"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0730" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0730"
And I set field "num3" to "0730-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0730"
And I close the current editor

#####################################################################################################################################

@FALL-0740
Scenario: FALL-0740
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno-Lieferschein

# Konto 0740-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0740FALL"
And I set field "such" to "FALL-0740"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0740-MG"
And I set field "such" to "FALL-0740"
And I set field "bestausekso" to "FALL-0740"
And I save the current editor

# Konto 40740-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40740FAL"
And I set field "such" to "FALL-40740"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0740-PG"
And I set field "such" to "FALL-0740"
And I set field "pgerlo" to "FALL-40740"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0740-FALL"
And I set field "num2" to "0740-FALL"
And I set field "such" to "FALL-0740"
And I set field "namebspr" to "FALL-0740"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0740-MG"
And I set field "erlgrp" to "0740-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0740" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0740-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0740" in row 1
And I set field "mge" to "0740" in row 1
And I set field "preis" to "0740" in row 1
And I set field "kenn" to "FALL-0740"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0740" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0740-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0740" in row 1
And I set field "mge" to "0740" in row 1
And I set field "preis" to "0740" in row 1
And I set field "kenn" to "FALL-0740"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0740"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0740" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0740"
And I set field "num3" to "0740-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0740" in row 1
And I set field "kenn" to "FALL-0740"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0740"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0740" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0740"
And I set field "kunde" to "1"
And I set field "num3" to "0740-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0740" in row 1
And I set field "preis" to "0740" in row 1
And I set field "kenn" to "FALL-0740"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0740"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0740" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0740"
And I set field "num3" to "0740-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0740 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0740"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0740" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0740"
And I set field "num3" to "0740-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0740" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0740"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0740"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0740" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0740"
And I set field "num3" to "0740-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0740"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0740" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0740"
And I set field "num3" to "0740-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0740"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0740" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0740"
And I set field "num3" to "0740-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0740"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0740" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0740"
And I set field "num3" to "0740-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0740"
And I close the current editor

#####################################################################################################################################

@FALL-0750
Scenario: FALL-0750
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager
# Rücklieferschein Gutschrift Storno-Gutschrift Gutschrift

# Konto 0750-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0750FALL"
And I set field "such" to "FALL-0750"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0750-MG"
And I set field "such" to "FALL-0750"
And I set field "bestausekso" to "FALL-0750"
And I save the current editor

# Konto 40750-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40750FAL"
And I set field "such" to "FALL-40750"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0750-PG"
And I set field "such" to "FALL-0750"
And I set field "pgerlo" to "FALL-40750"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0750-FALL"
And I set field "num2" to "0750-FALL"
And I set field "such" to "FALL-0750"
And I set field "namebspr" to "FALL-0750"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0750-MG"
And I set field "erlgrp" to "0750-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0750" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0750-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0750" in row 1
And I set field "mge" to "0750" in row 1
And I set field "preis" to "0750" in row 1
And I set field "kenn" to "FALL-0750"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0750" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0750-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0750" in row 1
And I set field "mge" to "0750" in row 1
And I set field "preis" to "0750" in row 1
And I set field "kenn" to "FALL-0750"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0750"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0750" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0750"
And I set field "num3" to "0750-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0750" in row 1
And I set field "kenn" to "FALL-0750"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0750"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0750" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0750"
And I set field "kunde" to "1"
And I set field "num3" to "0750-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0750" in row 1
And I set field "preis" to "0750" in row 1
And I set field "kenn" to "FALL-0750"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0750"
And I close the current editor


# Rücklieferschein anlegen
Given I open an editor "rls-0750" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0750"
And I set field "num3" to "0750-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0750 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0750"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0750" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0750"
And I set field "num3" to "0750-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0750" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0750"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0750"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0750" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0750"
And I set field "num3" to "0750-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0750"
And I close the current editor

# Gutschrift2 anlegen
Given I open an editor "Gutschrift2-0750" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0750"
And I set field "num3" to "0750-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0750" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0750"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift2
Given I open an editor "Gutschrift2-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift2-0750"
And I close the current editor

# Storno Rechnung
Given opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0750" throws the exception "2006"
# Fehler: Diese Rechnung wurde bereits in einer kaufmaennischen Gutschrift verrechnet.

#####################################################################################################################################

@FALL-0760
Scenario: FALL-0760
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein

# Konto 0760-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0760FALL"
And I set field "such" to "FALL-0760"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0760-MG"
And I set field "such" to "FALL-0760"
And I set field "bestausekso" to "FALL-0760"
And I save the current editor

# Konto 40760-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40760FAL"
And I set field "such" to "FALL-40760"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0760-PG"
And I set field "such" to "FALL-0760"
And I set field "pgerlo" to "FALL-40760"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0760-FALL"
And I set field "num2" to "0760-FALL"
And I set field "such" to "FALL-0760"
And I set field "namebspr" to "FALL-0760"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0760-MG"
And I set field "erlgrp" to "0760-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0760" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0760-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0760" in row 1
And I set field "mge" to "0760" in row 1
And I set field "preis" to "0760" in row 1
And I set field "kenn" to "FALL-0760"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0760" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0760-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0760" in row 1
And I set field "mge" to "0760" in row 1
And I set field "preis" to "0760" in row 1
And I set field "kenn" to "FALL-0760"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0760"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0760" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0760"
And I set field "num3" to "0760-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0760" in row 1
And I set field "kenn" to "FALL-0760"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0760"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0760" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0760"
And I set field "kunde" to "1"
And I set field "num3" to "0760-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0760" in row 1
And I set field "preis" to "0760" in row 1
And I set field "kenn" to "FALL-0760"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0760"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0760" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0760"
And I set field "num3" to "0760-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0760"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0760" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0760"
And I set field "num3" to "0760-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0760 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0760"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0760" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0760"
And I set field "num3" to "0760-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0760"
And I close the current editor

#####################################################################################################################################

@FALL-0770
Scenario: FALL-0770
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Storno-Rechnung ohne Lager Rücklieferschein Storno-Rücklieferschein Storno-Lieferschein

# Konto 0770-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0770FALL"
And I set field "such" to "FALL-0770"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0770-MG"
And I set field "such" to "FALL-0770"
And I set field "bestausekso" to "FALL-0770"
And I save the current editor

# Konto 40770-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40770FAL"
And I set field "such" to "FALL-40770"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0770-PG"
And I set field "such" to "FALL-0770"
And I set field "pgerlo" to "FALL-40770"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0770-FALL"
And I set field "num2" to "0770-FALL"
And I set field "such" to "FALL-0770"
And I set field "namebspr" to "FALL-0770"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0770-MG"
And I set field "erlgrp" to "0770-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0770" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0770-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0770" in row 1
And I set field "mge" to "0770" in row 1
And I set field "preis" to "0770" in row 1
And I set field "kenn" to "FALL-0770"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0770" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0770-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0770" in row 1
And I set field "mge" to "0770" in row 1
And I set field "preis" to "0770" in row 1
And I set field "kenn" to "FALL-0770"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0770"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0770" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0770"
And I set field "num3" to "0770-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0770" in row 1
And I set field "kenn" to "FALL-0770"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0770"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0770" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0770"
And I set field "kunde" to "1"
And I set field "num3" to "0770-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0770" in row 1
And I set field "preis" to "0770" in row 1
And I set field "kenn" to "FALL-0770"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0770"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0770" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0770"
And I set field "num3" to "0770-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0770"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0770" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0770"
And I set field "num3" to "0770-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0770 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0770"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0770" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0770"
And I set field "num3" to "0770-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0770"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0770" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0770"
And I set field "num3" to "0770-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0770"
And I close the current editor

#####################################################################################################################################

@FALL-0780
Scenario: FALL-0780
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Gutschrift

# Konto 0780-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0780FALL"
And I set field "such" to "FALL-0780"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0780-MG"
And I set field "such" to "FALL-0780"
And I set field "bestausekso" to "FALL-0780"
And I save the current editor

# Konto 40780-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40780FAL"
And I set field "such" to "FALL-40780"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0780-PG"
And I set field "such" to "FALL-0780"
And I set field "pgerlo" to "FALL-40780"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0780-FALL"
And I set field "num2" to "0780-FALL"
And I set field "such" to "FALL-0780"
And I set field "namebspr" to "FALL-0780"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0780-MG"
And I set field "erlgrp" to "0780-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0780" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0780-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0780" in row 1
And I set field "mge" to "0780" in row 1
And I set field "preis" to "0780" in row 1
And I set field "kenn" to "FALL-0780"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0780" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0780-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0780" in row 1
And I set field "mge" to "0780" in row 1
And I set field "preis" to "0780" in row 1
And I set field "kenn" to "FALL-0780"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0780"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0780" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0780"
And I set field "num3" to "0780-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0780" in row 1
And I set field "kenn" to "FALL-0780"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0780"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0780" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0780"
And I set field "kunde" to "1"
And I set field "num3" to "0780-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0780" in row 1
And I set field "preis" to "0780" in row 1
And I set field "kenn" to "FALL-0780"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0780"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0780" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-0780"
And I set field "num3" to "0780-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
# And I set field "artex" to "FALL-0780" in row 1
And I set field "mge" to "0780" in row 1
And I set field "preis" to "-0780" in row 1
And I set field "kenn" to "FALL-0780"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0780"
And I close the current editor

#####################################################################################################################################

@FALL-0790
Scenario: FALL-0790
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Gutschrift Storno-Gutschrift

# Konto 0790-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0790FALL"
And I set field "such" to "FALL-0790"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0790-MG"
And I set field "such" to "FALL-0790"
And I set field "bestausekso" to "FALL-0790"
And I save the current editor

# Konto 40790-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40790FAL"
And I set field "such" to "FALL-40790"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0790-PG"
And I set field "such" to "FALL-0790"
And I set field "pgerlo" to "FALL-40790"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0790-FALL"
And I set field "num2" to "0790-FALL"
And I set field "such" to "FALL-0790"
And I set field "namebspr" to "FALL-0790"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0790-MG"
And I set field "erlgrp" to "0790-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0790" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0790-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0790" in row 1
And I set field "mge" to "0790" in row 1
And I set field "preis" to "0790" in row 1
And I set field "kenn" to "FALL-0790"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0790" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0790-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0790" in row 1
And I set field "mge" to "0790" in row 1
And I set field "preis" to "0790" in row 1
And I set field "kenn" to "FALL-0790"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0790"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0790" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0790"
And I set field "num3" to "0790-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0790" in row 1
And I set field "kenn" to "FALL-0790"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0790"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0790" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0790"
And I set field "kunde" to "1"
And I set field "num3" to "0790-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0790" in row 1
And I set field "preis" to "0790" in row 1
And I set field "kenn" to "FALL-0790"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0790"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0790" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-0790"
And I set field "num3" to "0790-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
# And I set field "artex" to "FALL-0790" in row 1
And I set field "mge" to "0790" in row 1
And I set field "preis" to "-0790" in row 1
And I set field "kenn" to "FALL-0790"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0790"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0790" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0790"
And I set field "num3" to "0790-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0790"
And I close the current editor

#####################################################################################################################################

@FALL-0800
Scenario: FALL-0800
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Gutschrift Storno-Gutschrift Storno-Rechnung ohne Lager

# Konto 0800-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0800FALL"
And I set field "such" to "FALL-0800"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0800-MG"
And I set field "such" to "FALL-0800"
And I set field "bestausekso" to "FALL-0800"
And I save the current editor

# Konto 40800-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40800FAL"
And I set field "such" to "FALL-40800"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0800-PG"
And I set field "such" to "FALL-0800"
And I set field "pgerlo" to "FALL-40800"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0800-FALL"
And I set field "num2" to "0800-FALL"
And I set field "such" to "FALL-0800"
And I set field "namebspr" to "FALL-0800"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0800-MG"
And I set field "erlgrp" to "0800-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0800" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0800-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0800" in row 1
And I set field "mge" to "0800" in row 1
And I set field "preis" to "0800" in row 1
And I set field "kenn" to "FALL-0800"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0800" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0800-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0800" in row 1
And I set field "mge" to "0800" in row 1
And I set field "preis" to "0800" in row 1
And I set field "kenn" to "FALL-0800"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0800"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0800" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0800"
And I set field "num3" to "0800-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0800" in row 1
And I set field "kenn" to "FALL-0800"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0800"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0800" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0800"
And I set field "kunde" to "1"
And I set field "num3" to "0800-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0800" in row 1
And I set field "preis" to "0800" in row 1
And I set field "kenn" to "FALL-0800"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0800"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0800" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-0800"
And I set field "num3" to "0800-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
# And I set field "artex" to "FALL-0800" in row 1
And I set field "mge" to "0800" in row 1
And I set field "preis" to "-0800" in row 1
And I set field "kenn" to "FALL-0800"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0800"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0800" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0800"
And I set field "num3" to "0800-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0800"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0800" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0800"
And I set field "num3" to "0800-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0800"
And I close the current editor

#####################################################################################################################################

@FALL-0810
Scenario: FALL-0810
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rechnung ohne Lager Gutschrift Storno-Gutschrift Storno-Rechnung ohne Lager Storno-Lieferschein


# Konto 0810-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0810FALL"
And I set field "such" to "FALL-0810"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0810-MG"
And I set field "such" to "FALL-0810"
And I set field "bestausekso" to "FALL-0810"
And I save the current editor

# Konto 40810-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40810FAL"
And I set field "such" to "FALL-40810"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0810-PG"
And I set field "such" to "FALL-0810"
And I set field "pgerlo" to "FALL-40810"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0810-FALL"
And I set field "num2" to "0810-FALL"
And I set field "such" to "FALL-0810"
And I set field "namebspr" to "FALL-0810"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0810-MG"
And I set field "erlgrp" to "0810-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0810" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0810-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0810" in row 1
And I set field "mge" to "0810" in row 1
And I set field "preis" to "0810" in row 1
And I set field "kenn" to "FALL-0810"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0810" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0810-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0810" in row 1
And I set field "mge" to "0810" in row 1
And I set field "preis" to "0810" in row 1
And I set field "kenn" to "FALL-0810"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0810"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0810" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0810"
And I set field "num3" to "0810-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0810" in row 1
And I set field "kenn" to "FALL-0810"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0810"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0810" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0810"
And I set field "kunde" to "1"
And I set field "num3" to "0810-RE"
# And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0810" in row 1
And I set field "preis" to "0810" in row 1
And I set field "kenn" to "FALL-0810"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0810"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0810" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rechnung-0810"
And I set field "num3" to "0810-GS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
# And I set field "artex" to "FALL-0810" in row 1
And I set field "mge" to "0810" in row 1
And I set field "preis" to "-0810" in row 1
And I set field "kenn" to "FALL-0810"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0810"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0810" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0810"
And I set field "num3" to "0810-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0810"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0810" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0810"
And I set field "num3" to "0810-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0810"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0810" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0810"
And I set field "num3" to "0810-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0810"
And I close the current editor

#####################################################################################################################################

@FALL-0820
Scenario: FALL-0820
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Storno-Lieferschein


# Konto 0820-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0820FALL"
And I set field "such" to "FALL-0820"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0820-MG"
And I set field "such" to "FALL-0820"
And I set field "bestausekso" to "FALL-0820"
And I save the current editor

# Konto 40820-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40820FAL"
And I set field "such" to "FALL-40820"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0820-PG"
And I set field "such" to "FALL-0820"
And I set field "pgerlo" to "FALL-40820"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0820-FALL"
And I set field "num2" to "0820-FALL"
And I set field "such" to "FALL-0820"
And I set field "namebspr" to "FALL-0820"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0820-MG"
And I set field "erlgrp" to "0820-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0820" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0820-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0820" in row 1
And I set field "mge" to "0820" in row 1
And I set field "preis" to "0820" in row 1
And I set field "kenn" to "FALL-0820"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0820" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0820-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0820" in row 1
And I set field "mge" to "0820" in row 1
And I set field "preis" to "0820" in row 1
And I set field "kenn" to "FALL-0820"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0820"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0820" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0820"
And I set field "num3" to "0820-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0820" in row 1
And I set field "kenn" to "FALL-0820"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0820"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0820" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0820"
And I set field "num3" to "0820-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0820"
And I close the current editor

#####################################################################################################################################

@FALL-0830
Scenario: FALL-0830
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein


# Konto 0830-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0830FALL"
And I set field "such" to "FALL-0830"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0830-MG"
And I set field "such" to "FALL-0830"
And I set field "bestausekso" to "FALL-0830"
And I save the current editor

# Konto 40830-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40830FAL"
And I set field "such" to "FALL-40830"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0830-PG"
And I set field "such" to "FALL-0830"
And I set field "pgerlo" to "FALL-40830"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0830-FALL"
And I set field "num2" to "0830-FALL"
And I set field "such" to "FALL-0830"
And I set field "namebspr" to "FALL-0830"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0830-MG"
And I set field "erlgrp" to "0830-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-083" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0830-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0830" in row 1
And I set field "mge" to "0830" in row 1
And I set field "preis" to "0830" in row 1
And I set field "kenn" to "FALL-0830"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0830" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0830-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0830" in row 1
And I set field "mge" to "0830" in row 1
And I set field "preis" to "0830" in row 1
And I set field "kenn" to "FALL-0830"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0830"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0830" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0830"
And I set field "num3" to "0830-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0830" in row 1
And I set field "kenn" to "FALL-0830"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0830"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0830" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0830"
And I set field "num3" to "0830-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0830 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0830"
And I close the current editor

#####################################################################################################################################

@FALL-0840
Scenario: FALL-0840
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Gutschrift

# Konto 0840-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0840FALL"
And I set field "such" to "FALL-0840"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0840-MG"
And I set field "such" to "FALL-0840"
And I set field "bestausekso" to "FALL-0840"
And I save the current editor

# Konto 40840-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40840FAL"
And I set field "such" to "FALL-40840"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0840-PG"
And I set field "such" to "FALL-0840"
And I set field "pgerlo" to "FALL-40840"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0840-FALL"
And I set field "num2" to "0840-FALL"
And I set field "such" to "FALL-0840"
And I set field "namebspr" to "FALL-0840"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0840-MG"
And I set field "erlgrp" to "0840-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0840" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0840-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0840" in row 1
And I set field "mge" to "0840" in row 1
And I set field "preis" to "0840" in row 1
And I set field "kenn" to "FALL-0840"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0840" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0840-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0840" in row 1
And I set field "mge" to "0840" in row 1
And I set field "preis" to "0840" in row 1
And I set field "kenn" to "FALL-0840"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0840"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0840" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0840"
And I set field "num3" to "0840-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0840" in row 1
And I set field "kenn" to "FALL-0840"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0840"
And I close the current editor

# Rechnung anlegen aus Auftrag
Given I open an editor "rechnung-0840" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0840"
And I set field "kunde" to "1"
And I set field "num3" to "0840-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0840" in row 1
And I set field "preis" to "0840" in row 1
And I set field "kenn" to "FALL-0840"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0840-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0840" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0840"
And I set field "num3" to "0840-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0840 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0840"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0840" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0840"
And I set field "num3" to "0840-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0840" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0840"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0840"
And I close the current editor

#####################################################################################################################################

@FALL-0850
Scenario: FALL-0850
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Gutschrift Storno-Gutschrift

# Konto 0850-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0850FALL"
And I set field "such" to "FALL-0850"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0850-MG"
And I set field "such" to "FALL-0850"
And I set field "bestausekso" to "FALL-0850"
And I save the current editor

# Konto 40850-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40850FAL"
And I set field "such" to "FALL-40850"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0850-PG"
And I set field "such" to "FALL-0850"
And I set field "pgerlo" to "FALL-40850"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0850-FALL"
And I set field "num2" to "0850-FALL"
And I set field "such" to "FALL-0850"
And I set field "namebspr" to "FALL-0850"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0850-MG"
And I set field "erlgrp" to "0850-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0850" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0850-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0850" in row 1
And I set field "mge" to "0850" in row 1
And I set field "preis" to "0850" in row 1
And I set field "kenn" to "FALL-0850"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0850" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0850-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0850" in row 1
And I set field "mge" to "0850" in row 1
And I set field "preis" to "0850" in row 1
And I set field "kenn" to "FALL-0850"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0850"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0850" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0850"
And I set field "num3" to "0850-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0850" in row 1
And I set field "kenn" to "FALL-0850"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0850"
And I close the current editor

# Rechnung anlegen aus Auftrag
Given I open an editor "rechnung-0850" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0850"
And I set field "kunde" to "1"
And I set field "num3" to "0850-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0850" in row 1
And I set field "preis" to "0850" in row 1
And I set field "kenn" to "FALL-0850"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0850-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0850" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0850"
And I set field "num3" to "0850-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0850 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0850"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0850" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0850"
And I set field "num3" to "0850-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0850" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0850"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0850"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0850" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0850"
And I set field "num3" to "0850-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0850"
And I close the current editor

#####################################################################################################################################

@FALL-0860
Scenario: FALL-0860
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein

# Konto 0860-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0860FALL"
And I set field "such" to "FALL-0860"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0860-MG"
And I set field "such" to "FALL-0860"
And I set field "bestausekso" to "FALL-0860"
And I save the current editor

# Konto 40860-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40860FAL"
And I set field "such" to "FALL-40860"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0860-PG"
And I set field "such" to "FALL-0860"
And I set field "pgerlo" to "FALL-40860"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0860-FALL"
And I set field "num2" to "0860-FALL"
And I set field "such" to "FALL-0860"
And I set field "namebspr" to "FALL-0860"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0860-MG"
And I set field "erlgrp" to "0860-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0860" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0860-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0860" in row 1
And I set field "mge" to "0860" in row 1
And I set field "preis" to "0860" in row 1
And I set field "kenn" to "FALL-0860"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0860" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0860-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0860" in row 1
And I set field "mge" to "0860" in row 1
And I set field "preis" to "0860" in row 1
And I set field "kenn" to "FALL-0860"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0860"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0860" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0860"
And I set field "num3" to "0860-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0860" in row 1
And I set field "kenn" to "FALL-0860"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0860"
And I close the current editor

# Rechnung anlegen aus Auftrag
Given I open an editor "rechnung-0860" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0860"
And I set field "kunde" to "1"
And I set field "num3" to "0860-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0860" in row 1
And I set field "preis" to "0860" in row 1
And I set field "kenn" to "FALL-0860"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0860-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0860" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0860"
And I set field "num3" to "0860-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0860 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0860"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0860" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0860"
And I set field "num3" to "0860-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0860" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0860"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0860"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0860" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0860"
And I set field "num3" to "0860-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0860"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0860" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0860"
And I set field "num3" to "0860-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0860"
And I close the current editor

#####################################################################################################################################

@FALL-0870
Scenario: FALL-0870
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Rücklieferschein

# Konto 0870-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0870FALL"
And I set field "such" to "FALL-0870"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0870-MG"
And I set field "such" to "FALL-0870"
And I set field "bestausekso" to "FALL-0870"
And I save the current editor

# Konto 40870-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40870FAL"
And I set field "such" to "FALL-40870"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0870-PG"
And I set field "such" to "FALL-0870"
And I set field "pgerlo" to "FALL-40870"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0870-FALL"
And I set field "num2" to "0870-FALL"
And I set field "such" to "FALL-0870"
And I set field "namebspr" to "FALL-0870"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0870-MG"
And I set field "erlgrp" to "0870-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0870" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0870-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0870" in row 1
And I set field "mge" to "0870" in row 1
And I set field "preis" to "0870" in row 1
And I set field "kenn" to "FALL-0870"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0870" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0870-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0870" in row 1
And I set field "mge" to "0870" in row 1
And I set field "preis" to "0870" in row 1
And I set field "kenn" to "FALL-0870"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0870"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0870" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0870"
And I set field "num3" to "0870-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0870" in row 1
And I set field "kenn" to "FALL-0870"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0870"
And I close the current editor

# Rechnung anlegen aus Auftrag
Given I open an editor "rechnung-0870" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0870"
And I set field "kunde" to "1"
And I set field "num3" to "0870-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0870" in row 1
And I set field "preis" to "0870" in row 1
And I set field "kenn" to "FALL-0870"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0870-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0870" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0870"
And I set field "num3" to "0870-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0870 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0870"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0870" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0870"
And I set field "num3" to "0870-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0870" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0870"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0870"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0870" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0870"
And I set field "num3" to "0870-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0870"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0870" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0870"
And I set field "num3" to "0870-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0870"
And I close the current editor

# Rücklieferschein2 anlegen
Given I open an editor "Ruecklieferschein2-0870" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0870"
And I set field "num3" to "0870-RL2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0870 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein22
Given I open an editor "lieferschein2-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein2-0870"
And I close the current editor

#####################################################################################################################################

@FALL-0880
Scenario: FALL-0880
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno-Lieferschein

# Konto 0880-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0880FALL"
And I set field "such" to "FALL-0880"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0880-MG"
And I set field "such" to "FALL-0880"
And I set field "bestausekso" to "FALL-0880"
And I save the current editor

# Konto 40880-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40880FAL"
And I set field "such" to "FALL-40880"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0880-PG"
And I set field "such" to "FALL-0880"
And I set field "pgerlo" to "FALL-40880"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0880-FALL"
And I set field "num2" to "0880-FALL"
And I set field "such" to "FALL-0880"
And I set field "namebspr" to "FALL-0880"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0880-MG"
And I set field "erlgrp" to "0880-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0880" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0880-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0880" in row 1
And I set field "mge" to "0880" in row 1
And I set field "preis" to "0880" in row 1
And I set field "kenn" to "FALL-0880"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0880" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0880-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0880" in row 1
And I set field "mge" to "0880" in row 1
And I set field "preis" to "0880" in row 1
And I set field "kenn" to "FALL-0880"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0880"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0880" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0880"
And I set field "num3" to "0880-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0880" in row 1
And I set field "kenn" to "FALL-0880"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0880"
And I close the current editor

# Rechnung anlegen aus Auftrag
Given I open an editor "rechnung-0880" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0880"
And I set field "kunde" to "1"
And I set field "num3" to "0880-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0880" in row 1
And I set field "preis" to "0880" in row 1
And I set field "kenn" to "FALL-0880"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0880-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0880" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0880"
And I set field "num3" to "0880-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0880 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0880"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0880" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0880"
And I set field "num3" to "0880-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0880" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0880"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0880"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0880" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0880"
And I set field "num3" to "0880-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0880"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0880" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0880"
And I set field "num3" to "0880-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0880"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0880" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0880"
And I set field "num3" to "0880-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0880"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0880" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0880"
And I set field "num3" to "0880-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0880"
And I close the current editor

#####################################################################################################################################

@FALL-0890
Scenario: FALL-0890
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Gutschrift Storno-Gutschrift Gutschrift

# Konto 0890-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0890FALL"
And I set field "such" to "FALL-0890"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0890-MG"
And I set field "such" to "FALL-0890"
And I set field "bestausekso" to "FALL-0890"
And I save the current editor

# Konto 40890-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40890FAL"
And I set field "such" to "FALL-40890"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0890-PG"
And I set field "such" to "FALL-0890"
And I set field "pgerlo" to "FALL-40890"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0890-FALL"
And I set field "num2" to "0890-FALL"
And I set field "such" to "FALL-0890"
And I set field "namebspr" to "FALL-0890"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0890-MG"
And I set field "erlgrp" to "0890-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0890" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0890-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0890" in row 1
And I set field "mge" to "0890" in row 1
And I set field "preis" to "0890" in row 1
And I set field "kenn" to "FALL-0890"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0890" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0890-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0890" in row 1
And I set field "mge" to "0890" in row 1
And I set field "preis" to "0890" in row 1
And I set field "kenn" to "FALL-0890"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0890"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0890" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0890"
And I set field "num3" to "0890-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0890" in row 1
And I set field "kenn" to "FALL-0890"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0890"
And I close the current editor

# Rechnung anlegen aus Auftrag
Given I open an editor "rechnung-0890" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0890"
And I set field "kunde" to "1"
And I set field "num3" to "0890-RE"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0890" in row 1
And I set field "preis" to "0890" in row 1
And I set field "kenn" to "FALL-0890"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+0890-RE"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0890" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0890"
And I set field "num3" to "0890-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0890 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0890"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0890" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0890"
And I set field "num3" to "0890-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0890" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0890"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0890"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0890" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0890"
And I set field "num3" to "0890-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0890"
And I close the current editor

# Gutschrift2 anlegen
Given I open an editor "Gutschrift2-0890" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0890"
And I set field "num3" to "0890-GS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0890" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0890"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift2
Given I open an editor "Gutschrift2-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift2-0890"
And I close the current editor

#####################################################################################################################################

@FALL-0900
Scenario: FALL-0900
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Storno-Rücklieferschein

# Konto 0900-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0900FALL"
And I set field "such" to "FALL-0900"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0900-MG"
And I set field "such" to "FALL-0900"
And I set field "bestausekso" to "FALL-0900"
And I save the current editor

# Konto 40900-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40900FAL"
And I set field "such" to "FALL-40900"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0900-PG"
And I set field "such" to "FALL-0900"
And I set field "pgerlo" to "FALL-40900"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0900-FALL"
And I set field "num2" to "0900-FALL"
And I set field "such" to "FALL-0900"
And I set field "namebspr" to "FALL-0900"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0900-MG"
And I set field "erlgrp" to "0900-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0900" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0900-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0900" in row 1
And I set field "mge" to "0900" in row 1
And I set field "preis" to "0900" in row 1
And I set field "kenn" to "FALL-0900"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0900" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0900-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0900" in row 1
And I set field "mge" to "0900" in row 1
And I set field "preis" to "0900" in row 1
And I set field "kenn" to "FALL-0900"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0900"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0900" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0900"
And I set field "num3" to "0900-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0900" in row 1
And I set field "kenn" to "FALL-0900"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0900"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0900" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0900"
And I set field "num3" to "0900-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0900 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0900"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0900" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0900"
And I set field "num3" to "0900-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0900"
And I close the current editor

#####################################################################################################################################

@FALL-0910
Scenario: FALL-0910
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Storno-Rücklieferschein Storno-Lieferschein

# Konto 0910-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0910FALL"
And I set field "such" to "FALL-0910"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0910-MG"
And I set field "such" to "FALL-0910"
And I set field "bestausekso" to "FALL-0910"
And I save the current editor

# Konto 40910-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40910FAL"
And I set field "such" to "FALL-40910"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0910-PG"
And I set field "such" to "FALL-0910"
And I set field "pgerlo" to "FALL-40910"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0910-FALL"
And I set field "num2" to "0910-FALL"
And I set field "such" to "FALL-0910"
And I set field "namebspr" to "FALL-0910"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0910-MG"
And I set field "erlgrp" to "0910-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0910" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0910-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0910" in row 1
And I set field "mge" to "0910" in row 1
And I set field "preis" to "0910" in row 1
And I set field "kenn" to "FALL-0910"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0910" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0910-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0910" in row 1
And I set field "mge" to "0910" in row 1
And I set field "preis" to "0910" in row 1
And I set field "kenn" to "FALL-0910"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0910"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0910" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0910"
And I set field "num3" to "0910-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0910" in row 1
And I set field "kenn" to "FALL-0910"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0910"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0910" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0910"
And I set field "num3" to "0910-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0910 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0910"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0910" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0910"
And I set field "num3" to "0910-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0910"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-0910" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0910"
And I set field "num3" to "0910-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0910"
And I close the current editor

#####################################################################################################################################

@FALL-0915
Scenario: FALL-0915
# VK Auftrag Lieferschein "Rechnung aus Lieferschein" nein Rücklieferschein Storno-Lieferschein

# Konto 0915-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0915FALL"
And I set field "such" to "FALL-0915"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0915-MG"
And I set field "such" to "FALL-0915"
And I set field "bestausekso" to "FALL-0915"
And I save the current editor

# Konto 40915-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40915FAL"
And I set field "such" to "FALL-40915"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0915-PG"
And I set field "such" to "FALL-0915"
And I set field "pgerlo" to "FALL-40915"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0915-FALL"
And I set field "num2" to "0915-FALL"
And I set field "such" to "FALL-0915"
And I set field "namebspr" to "FALL-0915"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0915-MG"
And I set field "erlgrp" to "0915-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0915" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0915-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0915" in row 1
And I set field "mge" to "0915" in row 1
And I set field "preis" to "0915" in row 1
And I set field "kenn" to "FALL-0915"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0915" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0915-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0915" in row 1
And I set field "mge" to "0915" in row 1
And I set field "preis" to "0915" in row 1
And I set field "kenn" to "FALL-0915"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0915"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0915" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0915"
And I set field "num3" to "0915-LS"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0915" in row 1
And I set field "kenn" to "FALL-0915"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0915"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0915" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0915"
And I set field "num3" to "0915-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0915 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0915"
And I close the current editor

# Storno Lieferschein geht nicht mehr
And opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0915" throws the exception "1582"

# # Storno Lieferschein
# Given I open an editor "lieferschein-storno-0915" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-0915"
# And I set field "num3" to "0915-SLS"
# And I save the current editor
#
# # Ausgabe Storno Lieferschein
# Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-0915"
# And I close the current editor
#
#

#####################################################################################################################################

@FALL-0920
Scenario: FALL-0920
# VK Auftrag Rechnung ohne Lager

# Konto 0920-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0920FALL"
And I set field "such" to "FALL-0920"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0920-MG"
And I set field "such" to "FALL-0920"
And I set field "bestausekso" to "FALL-0920"
And I save the current editor

# Konto 40920-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40920FAL"
And I set field "such" to "FALL-40920"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0920-PG"
And I set field "such" to "FALL-0920"
And I set field "pgerlo" to "FALL-40920"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0920-FALL"
And I set field "num2" to "0920-FALL"
And I set field "such" to "FALL-0920"
And I set field "namebspr" to "FALL-0920"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0920-MG"
And I set field "erlgrp" to "0920-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0920" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0920-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0920" in row 1
And I set field "mge" to "0920" in row 1
And I set field "preis" to "0920" in row 1
And I set field "kenn" to "FALL-0920"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0920" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0920-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0920" in row 1
And I set field "mge" to "0920" in row 1
And I set field "preis" to "0920" in row 1
And I set field "kenn" to "FALL-0920"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0920"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0920" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0920"
And I set field "kunde" to "1"
And I set field "num3" to "0920-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0920" in row 1
And I set field "preis" to "0920" in row 1
And I set field "kenn" to "FALL-0920"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0920"
And I close the current editor

#####################################################################################################################################

@FALL-0930
Scenario: FALL-0930
# VK Auftrag Rechnung ohne Lager Storno-Rechnung ohne Lager

# Konto 0930-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0930FALL"
And I set field "such" to "FALL-0930"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0930-MG"
And I set field "such" to "FALL-0930"
And I set field "bestausekso" to "FALL-0930"
And I save the current editor

# Konto 40930-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40930FAL"
And I set field "such" to "FALL-40930"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0930-PG"
And I set field "such" to "FALL-0930"
And I set field "pgerlo" to "FALL-40930"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0930-FALL"
And I set field "num2" to "0930-FALL"
And I set field "such" to "FALL-0930"
And I set field "namebspr" to "FALL-0930"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0930-MG"
And I set field "erlgrp" to "0930-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0930" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0930-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0930" in row 1
And I set field "mge" to "0930" in row 1
And I set field "preis" to "0930" in row 1
And I set field "kenn" to "FALL-0930"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0930" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0930-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0930" in row 1
And I set field "mge" to "0930" in row 1
And I set field "preis" to "0930" in row 1
And I set field "kenn" to "FALL-0930"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0930"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0930" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0930"
And I set field "kunde" to "1"
And I set field "num3" to "0930-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0930" in row 1
And I set field "preis" to "0930" in row 1
And I set field "kenn" to "FALL-0930"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0930"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-0930" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-0930"
And I set field "num3" to "0930-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-0930"
And I close the current editor

#####################################################################################################################################

@FALL-0940
Scenario: FALL-0940
# VK Auftrag Rechnung ohne Lager Lieferschein

# Konto 0940-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0940FALL"
And I set field "such" to "FALL-0940"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0940-MG"
And I set field "such" to "FALL-0940"
And I set field "bestausekso" to "FALL-0940"
And I save the current editor

# Konto 40940-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40940FAL"
And I set field "such" to "FALL-40940"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0940-PG"
And I set field "such" to "FALL-0940"
And I set field "pgerlo" to "FALL-40940"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0940-FALL"
And I set field "num2" to "0940-FALL"
And I set field "such" to "FALL-0940"
And I set field "namebspr" to "FALL-0940"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0940-MG"
And I set field "erlgrp" to "0940-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0940" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0940-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0940" in row 1
And I set field "mge" to "0940" in row 1
And I set field "preis" to "0940" in row 1
And I set field "kenn" to "FALL-0940"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0940" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0940-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0940" in row 1
And I set field "mge" to "0940" in row 1
And I set field "preis" to "0940" in row 1
And I set field "kenn" to "FALL-0940"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0940"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0940" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0940"
And I set field "kunde" to "1"
And I set field "num3" to "0940-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0940" in row 1
And I set field "preis" to "0940" in row 1
And I set field "kenn" to "FALL-0940"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0940"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0940" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0940"
And I set field "num3" to "0940-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0940" in row 1
And I set field "kenn" to "FALL-0940"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0940"
And I close the current editor

#####################################################################################################################################

@FALL-0950
Scenario: FALL-0950
# VK Auftrag Rechnung ohne Lager Lieferschein Rücklieferschein

# Konto 0950-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0950FALL"
And I set field "such" to "FALL-0950"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0950-MG"
And I set field "such" to "FALL-0950"
And I set field "bestausekso" to "FALL-0950"
And I save the current editor

# Konto 40950-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40950FAL"
And I set field "such" to "FALL-40950"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0950-PG"
And I set field "such" to "FALL-0950"
And I set field "pgerlo" to "FALL-40950"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0950-FALL"
And I set field "num2" to "0950-FALL"
And I set field "such" to "FALL-0950"
And I set field "namebspr" to "FALL-0950"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0950-MG"
And I set field "erlgrp" to "0950-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0950" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0950-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0950" in row 1
And I set field "mge" to "0950" in row 1
And I set field "preis" to "0950" in row 1
And I set field "kenn" to "FALL-0950"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0950" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0950-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0950" in row 1
And I set field "mge" to "0950" in row 1
And I set field "preis" to "0950" in row 1
And I set field "kenn" to "FALL-0950"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0950"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0950" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0950"
And I set field "kunde" to "1"
And I set field "num3" to "0950-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0950" in row 1
And I set field "preis" to "0950" in row 1
And I set field "kenn" to "FALL-0950"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0950"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0950" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0950"
And I set field "num3" to "0950-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0950" in row 1
And I set field "kenn" to "FALL-0950"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0950"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0950" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0950"
And I set field "num3" to "0950-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0950 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0950"
And I close the current editor

#####################################################################################################################################

@FALL-0960
Scenario: FALL-0960
# VK Auftrag Rechnung ohne Lager Lieferschein Rücklieferschein Gutschrift

# Konto 0960-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0960FALL"
And I set field "such" to "FALL-0960"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0960-MG"
And I set field "such" to "FALL-0960"
And I set field "bestausekso" to "FALL-0960"
And I save the current editor

# Konto 40960-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40960FAL"
And I set field "such" to "FALL-40960"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0960-PG"
And I set field "such" to "FALL-0960"
And I set field "pgerlo" to "FALL-40960"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0960-FALL"
And I set field "num2" to "0960-FALL"
And I set field "such" to "FALL-0960"
And I set field "namebspr" to "FALL-0960"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0960-MG"
And I set field "erlgrp" to "0960-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0960" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0960-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0960" in row 1
And I set field "mge" to "0960" in row 1
And I set field "preis" to "0960" in row 1
And I set field "kenn" to "FALL-0960"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0960" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0960-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0960" in row 1
And I set field "mge" to "0960" in row 1
And I set field "preis" to "0960" in row 1
And I set field "kenn" to "FALL-0960"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0960"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0960" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0960"
And I set field "kunde" to "1"
And I set field "num3" to "0960-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0960" in row 1
And I set field "preis" to "0960" in row 1
And I set field "kenn" to "FALL-0960"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0960"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0960" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0960"
And I set field "num3" to "0960-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0960" in row 1
And I set field "kenn" to "FALL-0960"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0960"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0960" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0960"
And I set field "num3" to "0960-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0960 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0960"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0960" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0960"
And I set field "num3" to "0960-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0960" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0960"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0960"
And I close the current editor

#####################################################################################################################################

@FALL-0970
Scenario: FALL-0970
# VK Auftrag Rechnung ohne Lager Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift

# Konto 0970-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0970FALL"
And I set field "such" to "FALL-0970"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0970-MG"
And I set field "such" to "FALL-0970"
And I set field "bestausekso" to "FALL-0970"
And I save the current editor

# Konto 40970-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40970FAL"
And I set field "such" to "FALL-40970"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0970-PG"
And I set field "such" to "FALL-0970"
And I set field "pgerlo" to "FALL-40970"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0970-FALL"
And I set field "num2" to "0970-FALL"
And I set field "such" to "FALL-0970"
And I set field "namebspr" to "FALL-0970"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0970-MG"
And I set field "erlgrp" to "0970-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0970" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0970-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0970" in row 1
And I set field "mge" to "0970" in row 1
And I set field "preis" to "0970" in row 1
And I set field "kenn" to "FALL-0970"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0970" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0970-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0970" in row 1
And I set field "mge" to "0970" in row 1
And I set field "preis" to "0970" in row 1
And I set field "kenn" to "FALL-0970"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0970"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0970" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0970"
And I set field "kunde" to "1"
And I set field "num3" to "0970-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0970" in row 1
And I set field "preis" to "0970" in row 1
And I set field "kenn" to "FALL-0970"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0970"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0970" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0970"
And I set field "num3" to "0970-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0970" in row 1
And I set field "kenn" to "FALL-0970"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0970"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0970" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0970"
And I set field "num3" to "0970-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0970 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0970"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0970" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0970"
And I set field "num3" to "0970-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0970" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0970"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0970"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0970" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0970"
And I set field "num3" to "0970-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0970"
And I close the current editor

#####################################################################################################################################

@FALL-0980
Scenario: FALL-0980
# VK Auftrag Rechnung ohne Lager Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein

# Konto 0980-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0980FALL"
And I set field "such" to "FALL-0980"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0980-MG"
And I set field "such" to "FALL-0980"
And I set field "bestausekso" to "FALL-0980"
And I save the current editor

# Konto 40980-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40980FAL"
And I set field "such" to "FALL-40980"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0980-PG"
And I set field "such" to "FALL-0980"
And I set field "pgerlo" to "FALL-40980"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0980-FALL"
And I set field "num2" to "0980-FALL"
And I set field "such" to "FALL-0980"
And I set field "namebspr" to "FALL-0980"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0980-MG"
And I set field "erlgrp" to "0980-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0980" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0980-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0980" in row 1
And I set field "mge" to "0980" in row 1
And I set field "preis" to "0980" in row 1
And I set field "kenn" to "FALL-0980"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0980" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0980-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0980" in row 1
And I set field "mge" to "0980" in row 1
And I set field "preis" to "0980" in row 1
And I set field "kenn" to "FALL-0980"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0980"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0980" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0980"
And I set field "kunde" to "1"
And I set field "num3" to "0980-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0980" in row 1
And I set field "preis" to "0980" in row 1
And I set field "kenn" to "FALL-0980"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0980"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0980" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0980"
And I set field "num3" to "0980-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0980" in row 1
And I set field "kenn" to "FALL-0980"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0980"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0980" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0980"
And I set field "num3" to "0980-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0980 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0980"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0980" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0980"
And I set field "num3" to "0980-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0980" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0980"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0980"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0980" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0980"
And I set field "num3" to "0980-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0980"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0980" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0980"
And I set field "num3" to "0980-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0980"
And I close the current editor

#####################################################################################################################################

@FALL-0990
Scenario: FALL-0990
# VK Auftrag Rechnung ohne Lager Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Rücklieferschein

# Konto 0990-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0990FALL"
And I set field "such" to "FALL-0990"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0990-MG"
And I set field "such" to "FALL-0990"
And I set field "bestausekso" to "FALL-0990"
And I save the current editor

# Konto 40990-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "40990FAL"
And I set field "such" to "FALL-40990"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "0990-PG"
And I set field "such" to "FALL-0990"
And I set field "pgerlo" to "FALL-40990"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "0990-FALL"
And I set field "num2" to "0990-FALL"
And I set field "such" to "FALL-0990"
And I set field "namebspr" to "FALL-0990"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "0990-MG"
And I set field "erlgrp" to "0990-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0990" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0990-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-0990" in row 1
And I set field "mge" to "0990" in row 1
And I set field "preis" to "0990" in row 1
And I set field "kenn" to "FALL-0990"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-0990" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "0990-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-0990" in row 1
And I set field "mge" to "0990" in row 1
And I set field "preis" to "0990" in row 1
And I set field "kenn" to "FALL-0990"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-0990"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-0990" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-0990"
And I set field "kunde" to "1"
And I set field "num3" to "0990-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0990" in row 1
And I set field "preis" to "0990" in row 1
And I set field "kenn" to "FALL-0990"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-0990"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-0990" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-0990"
And I set field "num3" to "0990-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "0990" in row 1
And I set field "kenn" to "FALL-0990"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-0990"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-0990" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0990"
And I set field "num3" to "0990-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0990 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-0990"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-0990" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-0990"
And I set field "num3" to "0990-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "0990" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-0990"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-0990"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-0990" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-0990"
And I set field "num3" to "0990-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-0990"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-0990" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-0990"
And I set field "num3" to "0990-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-0990"
And I close the current editor

# Rücklieferschein2 anlegen
Given I open an editor "Ruecklieferschein2-0990" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-0990"
And I set field "num3" to "0990-RL2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-0990 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein 2
Given I open an editor "Ruecklieferschein2-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein2-0990"
And I close the current editor

#####################################################################################################################################

@FALL-1000
Scenario: FALL-1000
# VK Auftrag Rechnung ohne Lager Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno-Lieferschein

# Konto 1000-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1000FALL"
And I set field "such" to "FALL-1000"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1000-MG"
And I set field "such" to "FALL-1000"
And I set field "bestausekso" to "FALL-1000"
And I save the current editor

# Konto 41000-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41000FAL"
And I set field "such" to "FALL-41000"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1000-PG"
And I set field "such" to "FALL-1000"
And I set field "pgerlo" to "FALL-41000"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1000-FALL"
And I set field "num2" to "1000-FALL"
And I set field "such" to "FALL-1000"
And I set field "namebspr" to "FALL-1000"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1000-MG"
And I set field "erlgrp" to "1000-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1000" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1000-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-1000" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "1000" in row 1
And I set field "kenn" to "FALL-1000"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-1000" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1000-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1000" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "1000" in row 1
And I set field "kenn" to "FALL-1000"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-1000"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1000" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-1000"
And I set field "kunde" to "1"
And I set field "num3" to "1000-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1000" in row 1
And I set field "preis" to "1000" in row 1
And I set field "kenn" to "FALL-1000"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-1000"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-1000" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-1000"
And I set field "num3" to "1000-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1000" in row 1
And I set field "kenn" to "FALL-1000"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-1000"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1000" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1000"
And I set field "num3" to "1000-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-1000 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-1000"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-1000" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-1000"
And I set field "num3" to "1000-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "1000" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-1000"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-1000"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-1000" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-1000"
And I set field "num3" to "1000-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-1000"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-1000" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-1000"
And I set field "num3" to "1000-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-1000"
And I close the current editor

# Storno Lieferschein geht nicht
And opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-1000" throws the exception "1582"

#####################################################################################################################################

@FALL-1005
Scenario: FALL-1005
# VK Auftrag Rechnung ohne Lager Lieferschein Rücklieferschein Gutschrift Storno-Gutschrift Storno-Rücklieferschein Storno-Lieferschein

# Konto 1005-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1005FALL"
And I set field "such" to "FALL-1005"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1005-MG"
And I set field "such" to "FALL-1005"
And I set field "bestausekso" to "FALL-1005"
And I save the current editor

# Konto 41005-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41005FAL"
And I set field "such" to "FALL-41005"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1005-PG"
And I set field "such" to "FALL-1005"
And I set field "pgerlo" to "FALL-41005"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1005-FALL"
And I set field "num2" to "1005-FALL"
And I set field "such" to "FALL-1005"
And I set field "namebspr" to "FALL-1005"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1005-MG"
And I set field "erlgrp" to "1005-PG"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1005" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1005-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-1005" in row 1
And I set field "mge" to "1005" in row 1
And I set field "preis" to "1005" in row 1
And I set field "kenn" to "FALL-1005"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "auftrag-1005" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1005-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1005" in row 1
And I set field "mge" to "1005" in row 1
And I set field "preis" to "1005" in row 1
And I set field "kenn" to "FALL-1005"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "auftrag-1005"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-1005" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-1005"
And I set field "kunde" to "1"
And I set field "num3" to "1005-RE"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1005" in row 1
And I set field "preis" to "1005" in row 1
And I set field "kenn" to "FALL-1005"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-1005"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-1005" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-1005"
And I set field "num3" to "1005-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1005" in row 1
And I set field "kenn" to "FALL-1005"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-1005"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-1005" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1005"
And I set field "num3" to "1005-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-1005 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-1005"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "gutschrift-1005" from table "(Sales):(Invoice)" with command "COPY" for record from editor "rls-1005"
And I set field "num3" to "1005-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "NEIN"
# And I set field "mge" to "1005" in row 1
# And I set field "preis" to "-10" in row 1
And I set field "kenn" to "FALL-1005"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-1005"
And I close the current editor

# Storno Gutschrift
Given I open an editor "gutschrift-storno-1005" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "gutschrift-1005"
And I set field "num3" to "1005-SGS"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "gutschrift-storno-1005"
And I close the current editor

# Storno Rücklieferschein
Given I open an editor "rls-storno-1005" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "rls-1005"
And I set field "num3" to "1005-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "rls-storno-1005"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-1005" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-1005"
And I set field "num3" to "1005-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-1005"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-1005" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-1005"
And I set field "num3" to "1005-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-1005"
And I close the current editor

#####################################################################################################################################


# Final noch mal eine Materialkostenverbuchung

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-740" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


#####################################################################################################################################
#
# Hier ist dann das ENDE
#
#
