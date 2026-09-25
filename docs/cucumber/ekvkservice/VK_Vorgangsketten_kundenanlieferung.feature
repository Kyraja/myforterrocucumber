Feature: VK_Vorgangsketten_Kundenanlieferung
Background: VK_Vorgangsketten_Kundenanlieferung.feature
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

#####################################################################################################################################

Scenario: Testdaten (Stammdaten) anlegen - Konsignationslagerplatz
# Konsilager, Konsilagergruppe anlegen
Given I open an editor "Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSILG"
And I set field "such" to "KONSILG"
And I set field "zkonsilg" to "Ja"
And I save the current editor

Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSILAGER"
And I set field "such" to "KONSILAGER"
And I set field "lgruppe" to "KONSILG"
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KONSILP"
And I set field "such" to "KONSILP"
And I set field "lager" to "KONSILAGER"
And I save the current editor

# Lagergruppe mit Lagerplatz: Platz fuer Kundenanlieferung (Konsilager) eintragen
Given I open an editor "LagergruppeKA" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And I set field "vkkundenanlieferung" to "KONSILP"
And I save the current editor

#####################################################################################################################################

@FALL-1500
Scenario: FALL-1500	VK	Kundenanlieferung Neu

# Konto 1500-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1500FALL"
And I set field "such" to "FALL-1500"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1500-MG"
And I set field "such" to "FALL-1500"
And I set field "bestausekso" to "FALL-1500"
And I save the current editor

# Konto 41500-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41500FAL"
And I set field "such" to "FALL-41500"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1500-PG"
And I set field "such" to "FALL-1500"
And I set field "pgerlo" to "FALL-41500"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1500-FALL"
And I set field "num2" to "1500-FALL"
And I set field "such" to "FALL-1500"
And I set field "namebspr" to "FALL-1500"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1500-MG"
And I set field "erlgrp" to "1500-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Kundenanlieferung Neu ohne Vorgaenger
Given I open an editor "Kundenanlieferung-1500" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1500-KDA"
And I set field "lsart" to "Kundenanlieferung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1500" in row 1
And I set field "mge" to "-1500" in row 1
And I set field "preis" to "1500" in row 1
And I set field "kenn" to "FALL-1500"
Then field "lsart" has value "Kundenanlieferung"
And I save the current editor

# Ausgabe Kundenanlieferung
Given I open an editor "Kundenanlieferung-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Kundenanlieferung-1500"
And I close the current editor

#####################################################################################################################################

@FALL-1510
Scenario: FALL-1510	VK	Auftrag Kundenanlieferung

# Konto 1510-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1510FALL"
And I set field "such" to "FALL-1510"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1510-MG"
And I set field "such" to "FALL-1510"
And I set field "bestausekso" to "FALL-1510"
And I save the current editor

# Konto 41510-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41510FAL"
And I set field "such" to "FALL-41510"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1510-PG"
And I set field "such" to "FALL-1510"
And I set field "pgerlo" to "FALL-41510"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1510-FALL"
And I set field "num2" to "1510-FALL"
And I set field "such" to "FALL-1510"
And I set field "namebspr" to "FALL-1510"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1510-MG"
And I set field "erlgrp" to "1510-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Auftrag anlegen
Given I open an editor "Auftrag-1510" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1510-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1510" in row 1
And I set field "mge" to "-1510" in row 1
And I set field "preis" to "1510" in row 1
And I set field "kenn" to "FALL-1510"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "Auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "Auftrag-1510"
And I close the current editor

# Kundenanlieferung
Given I open an editor "Kundenanlieferung-1510" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "Auftrag-1510"
And I set field "num3" to "1510-KDA"
And I set field "ueb" to "ja"
And I set field "mge" to "-1510" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ausgabe Kundenanlieferung
Given I open an editor "Kundenanlieferung-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Kundenanlieferung-1510"
And I close the current editor

#####################################################################################################################################

@FALL-1520
Scenario: FALL-1520	VK	Auftrag	Kundenanlieferung	Storno-Kundenanlieferung

# Konto 1520-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1520FALL"
And I set field "such" to "FALL-1520"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1520-MG"
And I set field "such" to "FALL-1520"
And I set field "bestausekso" to "FALL-1520"
And I save the current editor

# Konto 41520-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41520FAL"
And I set field "such" to "FALL-41520"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1520-PG"
And I set field "such" to "FALL-1520"
And I set field "pgerlo" to "FALL-41520"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1520-FALL"
And I set field "num2" to "1520-FALL"
And I set field "such" to "FALL-1520"
And I set field "namebspr" to "FALL-1520"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1520-MG"
And I set field "erlgrp" to "1520-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Auftrag anlegen
Given I open an editor "Auftrag-1520" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1520-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1520" in row 1
And I set field "mge" to "-1520" in row 1
And I set field "preis" to "1520" in row 1
And I set field "kenn" to "FALL-1520"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "Auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "Auftrag-1520"
And I close the current editor

# Kundenanlieferung
Given I open an editor "Kundenanlieferung-1520" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "Auftrag-1520"
And I set field "num3" to "1520-KDA"
And I set field "ueb" to "ja"
And I set field "mge" to "-1520" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ausgabe Kundenanlieferung
Given I open an editor "Kundenanlieferung-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Kundenanlieferung-1520"
And I close the current editor

# Storno Kundenanlieferung
Given I open an editor "kundenanlieferung-storno-1520" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "Kundenanlieferung-1520"
And I set field "num3" to "1520-SKD"
And I save the current editor

# Ausgabe Storno Kundenanlieferung
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "kundenanlieferung-storno-1520" 
And I close the current editor

#####################################################################################################################################

@FALL-1530
Scenario: FALL-1530	VK	Auftrag	Kundenanlieferung	Gutschrift

# Konto 1530-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1530FALL"
And I set field "such" to "FALL-1530"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1530-MG"
And I set field "such" to "FALL-1530"
And I set field "bestausekso" to "FALL-1530"
And I save the current editor

# Konto 41530-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41530FAL"
And I set field "such" to "FALL-41530"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1530-PG"
And I set field "such" to "FALL-1530"
And I set field "pgerlo" to "FALL-41530"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1530-FALL"
And I set field "num2" to "1530-FALL"
And I set field "such" to "FALL-1530"
And I set field "namebspr" to "FALL-1530"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1530-MG"
And I set field "erlgrp" to "1530-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Auftrag anlegen
Given I open an editor "Auftrag-1530" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1530-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1530" in row 1
And I set field "mge" to "-1530" in row 1
And I set field "preis" to "1530" in row 1
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
And I set field "kenn" to "FALL-1530"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "Auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "Auftrag-1530"
And I close the current editor

# Anzahlungsrechnung erstellen
Given I open an editor "Rechnung-1530" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "(Downpayment)"
And I set field "beleg" to id from editor "Auftrag-1530"
And I set field "nummer" to "1530-AR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "pwert" to "1000" in row 1
And I set field "kenn" to "FALL-1530"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+1530-AR"
And I close the current editor

# Anzahlungsrechnung bezahlen
Given I open an editor "op-zahlen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "nummer" to "1530-OP"
And I set field "beleg" to "1530-OP"
And I set field "gkonto" to "18100"
And I create a new row at the end of the table
And I set field "op" to "$,,rechn=3 +1530-AR" in row 1
And I set field "opzabetr" to "1160" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

# Kundenanlieferung
Given I open an editor "Kundenanlieferung-1530" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "Auftrag-1530"
And I set field "num3" to "1530-KDA"
And I set field "ueb" to "ja"
And I set field "mge" to "-1530" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ausgabe Kundenanlieferung
Given I open an editor "Kundenanlieferung-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Kundenanlieferung-1530"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "Gutschrift-1530" from table "(Sales):(Invoice)" with command "COPY" for record from editor "Kundenanlieferung-1530"
And I set field "num3" to "1530-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-1530"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "Gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift-1530"
And I close the current editor

# Storno Anzahlung nicht moeglich, weil bereits bezahlt
Given opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record "+1530-AR" throws the exception ""
And I close the current editor
 
#####################################################################################################################################

@FALL-1540
Scenario: FALL-1540	VK	Auftrag	Lieferschein	Kundenanlieferung

# Konto 1540-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1540FALL"
And I set field "such" to "FALL-1540"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1540-MG"
And I set field "such" to "FALL-1540"
And I set field "bestausekso" to "FALL-1540"
And I save the current editor

# Konto 41540-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41540FAL"
And I set field "such" to "FALL-41540"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1540-PG"
And I set field "such" to "FALL-1540"
And I set field "pgerlo" to "FALL-41540"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1540-FALL"
And I set field "num2" to "1540-FALL-VK"
And I set field "such" to "FALL-1540-VK"
And I set field "namebspr" to "FALL-1540 Verkaufsartikel"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1540-MG"
And I set field "erlgrp" to "1540-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1540-FALL"
And I set field "num2" to "1540-FALL-KDA"
And I set field "such" to "FALL-1540-KDA"
And I set field "namebspr" to "FALL-1540 Kundenanlieferung"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1540-MG"
And I set field "erlgrp" to "1540-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1540-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-1540-VK" in row 1
And I set field "mge" to "1540" in row 1
And I set field "preis" to "1540" in row 1
And I set field "kenn" to "FALL-1540"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "Auftrag-1540" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1540-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1540-VK" in row 1
And I set field "mge" to "1540" in row 1
And I set field "preis" to "1540" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-1540-KDA" in row 2
And I set field "mge" to "-1540" in row 2
And I set field "preis" to "1540" in row 2
And I set field "kenn" to "FALL-1540"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "Auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "Auftrag-1540"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "Lieferschein-1540" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "Auftrag-1540"
And I set field "num3" to "1540-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1540" in row 1
And I set field "kenn" to "FALL-1540"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Lieferschein-1540"
And I close the current editor

# Kundenanlieferung
Given I open an editor "Kundenanlieferung-1540" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "Auftrag-1540"
And I set field "num3" to "1540-KDA"
And I set field "ueb" to "ja"
And I set field "mge" to "-1540" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ausgabe Kundenanlieferung
Given I open an editor "Kundenanlieferung-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Kundenanlieferung-1540"
And I close the current editor

#####################################################################################################################################

@FALL-1550
Scenario: FALL-1550	VK	Auftrag	Lieferschein	Kundenanlieferung zum Auftrag	Rechnung gemischt

# Konto 1550-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1550FALL"
And I set field "such" to "FALL-1550"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1550-MG"
And I set field "such" to "FALL-1550"
And I set field "bestausekso" to "FALL-1550"
And I save the current editor

# Konto 41550-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41550FAL"
And I set field "such" to "FALL-41550"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1550-PG"
And I set field "such" to "FALL-1550"
And I set field "pgerlo" to "FALL-41550"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1550-FALL"
And I set field "num2" to "1550-FALL-VK"
And I set field "such" to "FALL-1550-VK"
And I set field "namebspr" to "FALL-1550 Verkaufsartikel"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1550-MG"
And I set field "erlgrp" to "1550-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1550-FALL"
And I set field "num2" to "1550-FALL-KDA"
And I set field "such" to "FALL-1550-KDA"
And I set field "namebspr" to "FALL-1550 Kundenanlieferung"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1550-MG"
And I set field "erlgrp" to "1550-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1550-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-1550-VK" in row 1
And I set field "mge" to "1550" in row 1
And I set field "preis" to "1550" in row 1
And I set field "kenn" to "FALL-1550"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Auftrag anlegen
Given I open an editor "Auftrag-1550" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1550-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1550-VK" in row 1
And I set field "mge" to "1550" in row 1
And I set field "preis" to "1550" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-1550-KDA" in row 2
And I set field "mge" to "-1550" in row 2
And I set field "preis" to "1550" in row 2
And I set field "kenn" to "FALL-1550"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "Auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "Auftrag-1550"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "Lieferschein-1550" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "Auftrag-1550"
And I set field "num3" to "1550-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1550" in row 1
And I set field "kenn" to "FALL-1550"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Lieferschein-1550"
And I close the current editor

# Kundenanlieferung
Given I open an editor "Kundenanlieferung-1550" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "Auftrag-1550"
And I set field "num3" to "1550-KDA"
And I set field "ueb" to "ja"
And I set field "mge" to "-1550" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ausgabe Kundenanlieferung
Given I open an editor "Kundenanlieferung-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Kundenanlieferung-1550"
And I close the current editor

# Rechnung anlegen
Given I open an editor "Rechnung-1550" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "Lieferschein-1550"
And I set field "beleg" to id from editor "Kundenanlieferung-1550"
And I set field "num3" to "1550-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "fakt" is not modifiable
And I set field "kenn" to "FALL-1550"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Rechnung-1550"
And I close the current editor
 
#####################################################################################################################################

@FALL-1560
Scenario: FALL-1560	VK	Auftrag pos + neg	Lieferschein	Rücklieferschein + Kundenanlieferung

# Konto 1560-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1560FALL"
And I set field "such" to "FALL-1560"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1560-MG"
And I set field "such" to "FALL-1560"
And I set field "bestausekso" to "FALL-1560"
And I save the current editor

# Konto 41560-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41560FAL"
And I set field "such" to "FALL-41560"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1560-PG"
And I set field "such" to "FALL-1560"
And I set field "pgerlo" to "FALL-41560"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1560-FALL"
And I set field "num2" to "1560-FALL-VK"
And I set field "such" to "FALL-1560-VK"
And I set field "namebspr" to "FALL-1560 Verkaufsartikel"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1560-MG"
And I set field "erlgrp" to "1560-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1560-FALL"
And I set field "num2" to "1560-FALL-KDA"
And I set field "such" to "FALL-1560-KDA"
And I set field "namebspr" to "FALL-1560 Kundenanlieferung"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1560-MG"
And I set field "erlgrp" to "1560-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1560-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-1560-VK" in row 1
And I set field "mge" to "1560" in row 1
And I set field "preis" to "1560" in row 1
And I set field "kenn" to "FALL-1560"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "Auftrag-1560" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1560-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1560-VK" in row 1
And I set field "mge" to "1560" in row 1
And I set field "preis" to "1560" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-1560-KDA" in row 2
And I set field "mge" to "-1560" in row 2
And I set field "preis" to "1560" in row 2
And I set field "kenn" to "FALL-1560"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "Auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "Auftrag-1560"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "Lieferschein-1560" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "Auftrag-1560"
And I set field "num3" to "1560-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1560" in row 1
And I set field "kenn" to "FALL-1560"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Lieferschein-1560"
And I close the current editor

# Rücklieferschein mit Kundenanlieferung anlegen
Given I open an editor "Ruecklieferschein-1560" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein-1560"
And I set field "num3" to "1560-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And setting field "beleg" in row 0 to "id" from editor "Auftrag-1560" in row 0 throws the exception "4615"
And I close the current editor

Given I open an editor "Kundenanlieferung-1560" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "num3" to "1560-KDA"
And I set field "beleg" to id from editor "Auftrag-1560"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1560" in row 1
And I set field "platz" to "KONSILP" in row 1
And setting field "beleg" in row 0 to "id" from editor "Lieferschein-1560" in row 0 throws the exception "4615"
And I close the current editor

#####################################################################################################################################

@FALL-1570
Scenario: FALL-1570	VK	Auftrag pos + neg	Lieferschein	Rücklieferschein	Kundenanlieferung	Rechnung RLS + KDA

# Konto 1570-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1570FALL"
And I set field "such" to "FALL-1570"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1570-MG"
And I set field "such" to "FALL-1570"
And I set field "bestausekso" to "FALL-1570"
And I save the current editor

# Konto 41570-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41570FAL"
And I set field "such" to "FALL-41570"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1570-PG"
And I set field "such" to "FALL-1570"
And I set field "pgerlo" to "FALL-41570"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1570-FALL"
And I set field "num2" to "1570-FALL-VK"
And I set field "such" to "FALL-1570-VK"
And I set field "namebspr" to "FALL-1570 Verkaufsartikel"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1570-MG"
And I set field "erlgrp" to "1570-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1570-FALL"
And I set field "num2" to "1570-FALL-KDA"
And I set field "such" to "FALL-1570-KDA"
And I set field "namebspr" to "FALL-1570 Kundenanlieferung"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1570-MG"
And I set field "erlgrp" to "1570-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1570-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-1570-VK" in row 1
And I set field "mge" to "1570" in row 1
And I set field "preis" to "1570" in row 1
And I set field "kenn" to "FALL-1570"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "Auftrag-1570" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1570-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1570-VK" in row 1
And I set field "mge" to "1570" in row 1
And I set field "preis" to "1570" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-1570-KDA" in row 2
And I set field "mge" to "-1570" in row 2
And I set field "preis" to "1570" in row 2
And I set field "kenn" to "FALL-1570"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "Auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "Auftrag-1570"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "Lieferschein-1570" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "Auftrag-1570"
And I set field "num3" to "1570-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1570" in row 1
And I set field "kenn" to "FALL-1570"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Lieferschein-1570"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "Ruecklieferschein-1570" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein-1570"
And I set field "num3" to "1570-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-1570 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein 
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-1570"
And I close the current editor
 
# Kundenanlieferung
Given I open an editor "Kundenanlieferung-1570" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "Auftrag-1570"
And I set field "num3" to "1570-KDA"
And I set field "ueb" to "ja"
And I set field "mge" to "-1570" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ausgabe Kundenanlieferung
Given I open an editor "Kundenanlieferung-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Kundenanlieferung-1570"
And I close the current editor

# # Rechnung anlegen
Given I open an editor "Rechnung-1570" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "Ruecklieferschein-1570"
And I set field "beleg" to id from editor "Kundenanlieferung-1570"
And I set field "num3" to "1570-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1570" in row 3
And I set field "kenn" to "FALL-1570"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Rechnung-1570"
And I close the current editor
 
#####################################################################################################################################

@FALL-1580
Scenario: FALL-1580	VK	Auftrag pos + neg	Lieferschein	Rücklieferschein	Kundenanlieferung	Rechnung LS + RLS + KDA

# Konto 1580-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "1580FALL"
And I set field "such" to "FALL-1580"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "1580-MG"
And I set field "such" to "FALL-1580"
And I set field "bestausekso" to "FALL-1580"
And I save the current editor

# Konto 41580-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "41580FAL"
And I set field "such" to "FALL-41580"
And I set field "ktostrgl" to "VKINLREGEL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(ProductGroup)" with command "COPY" for record "66"
And I set field "nummer" to "1580-PG"
And I set field "such" to "FALL-1580"
And I set field "pgerlo" to "FALL-41580"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1580-FALL"
And I set field "num2" to "1580-FALL-VK"
And I set field "such" to "FALL-1580-VK"
And I set field "namebspr" to "FALL-1580 Verkaufsartikel"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1580-MG"
And I set field "erlgrp" to "1580-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1580-FALL"
And I set field "num2" to "1580-FALL-KDA"
And I set field "such" to "FALL-1580-KDA"
And I set field "namebspr" to "FALL-1580 Kundenanlieferung"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "1580-MG"
And I set field "erlgrp" to "1580-PG"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1580-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "FALL-1580-VK" in row 1
And I set field "mge" to "1580" in row 1
And I set field "preis" to "1580" in row 1
And I set field "kenn" to "FALL-1580"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag anlegen
Given I open an editor "Auftrag-1580" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "num3" to "1580-AU"
And I create a new row at the end of the table
And I set field "artex" to "FALL-1580-VK" in row 1
And I set field "mge" to "1580" in row 1
And I set field "preis" to "1580" in row 1

And I create a new row at the end of the table
And I set field "artex" to "FALL-1580-KDA" in row 2
And I set field "mge" to "-1580" in row 2
And I set field "preis" to "1580" in row 2
And I set field "kenn" to "FALL-1580"
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "Auftrag-view" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "Auftrag-1580"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "Lieferschein-1580" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "Auftrag-1580"
And I set field "num3" to "1580-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "1580" in row 1
And I set field "kenn" to "FALL-1580"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Lieferschein-1580"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "Ruecklieferschein-1580" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Lieferschein-1580"
And I set field "num3" to "1580-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-1580 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein 
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-1580"
And I close the current editor
 
# Kundenanlieferung
Given I open an editor "Kundenanlieferung-1580" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "lsart" to "Kundenanlieferung"
And I set field "beleg" to id from editor "Auftrag-1580"
And I set field "num3" to "1580-KDA"
And I set field "ueb" to "ja"
And I set field "mge" to "-1580" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ausgabe Kundenanlieferung
Given I open an editor "Kundenanlieferung-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Kundenanlieferung-1580"
And I close the current editor

# Rechnung anlegen
Given I open an editor "Rechnung-1580" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "Lieferschein-1580"
And I set field "beleg" to id from editor "Ruecklieferschein-1580"
Then field "mge" has value "1580" in row 1
And I set field "beleg" to id from editor "Kundenanlieferung-1580"
And I set field "num3" to "1580-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "fakt" is not modifiable
And I set field "kenn" to "FALL-1580"
And I respond with answer "JA" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Rechnung-1580"
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
