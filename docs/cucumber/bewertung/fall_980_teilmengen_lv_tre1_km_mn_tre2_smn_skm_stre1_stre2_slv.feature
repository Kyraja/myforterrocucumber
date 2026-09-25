@persistent
Feature: BW2-596 
# Fall 980 mit Teilmengen: LS -	RE (SPED) - Teil-RE1 - KM - MN - Teil-RE2 - SMN- SKM -S Teil-RE1 - S Teil-RE1 - S LS 
# Ursprungsfall 980: EK Bestellung	Lieferschein	Rechnung (SPED)	Rechnung (empfänger)	Kostenumlage	Mengenneubewertung	Storno-Mengenneubewertung	Storno-Kostenumlage	Storno-Rechnung	Storno-Rechnung	Storno-Lieferschein  
Background:
Given I set the fake date to "02.01.2002"
# *****************************************************************************
#  Name           : fall_980_teilmengen_lv_tre1_km_mn_tre2_smn_skm_stre1_stre2_slv.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : wane
#  Funktion       : Tests des Stornos der Kostenumlage in folgender Prozesskette und mit Teilmengen:
#                   EK: LS -	RE (SPED) - Teil-RE1 - KM - MN - Teil-RE2 - SMN- SKM -S Teil-RE1 - S Teil-RE1 - S LS 
#
# *****************************************************************************

Scenario: FALL-980 EK

# Lieferant 1: Währung EUR
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I set field "waehr" to "EUR"
And I save the current editor

# Konto 980-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0980FALL"
And I set field "such" to "FALL-980"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0980"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0980FALL"
And I set field "such" to "FALL-980"
And I set field "bestausekso" to "FALL-980"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "980-FALL"
And I set fields
 | num2      | 980-FALL         |
 | such      | FALL-980         |
 | namebspr  | FALL-980         |
 | bsart     | Fremdbeschaffung |
 | dispoa    | bedarfsbezogen   |
 | lief      | 1                |
 | epr       | 30               |
 | ewaehr    | EUR              |
 | wgruppe   | FALL-980         |
 | erlgrp    | 66               |
 | ekbewverf | 1                |
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "980-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-980" in row 1
And I set field "mge" to "980" in row 1
And I set field "preis" to "980" in row 1
And I set field "kenn" to "FALL-980"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-980" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "980-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "980" in row 1
And I set field "kenn" to "FALL-980"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rechnung1 anlegen
Given I open an editor "rechnung-980-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "980-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1980" in row 1
And I set field "konto" to "58-0980" in row 1
And I set field "kenn" to "FALL-980"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Teil-Rechnung 1 anlegen
Given I open an editor "rechnung-980-2.1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-980"
And I set field "num4" to "980RE2.1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-980"
And I set field "mge" to "500" in row 1
And I set field "preis" to "920" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Kostenumlage erzeugen
Given I open an editor "kostenuml-980" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "980-KM" 
And I set field "pos" to "$,,kopf^nummer=980-RE1;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=980RE2.1;artex=FALL-980;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Mengenneubewertung anlegen
Given I open an editor "mgebewneu-980" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "FALL-980"
And I set field "vorgang" to "$,,artikel=Fall-980;platz=f1;@datenbank=40;@gruppe=4;" in row 1
And I set field "ntbewpr" to "980,980" in row 1
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Teil-Rechnung 2 anlegen
Given I open an editor "rechnung-980-2.2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-980"
And I set field "num4" to "980RE2.2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-980"
And I set field "mge" to "200" in row 1
And I set field "preis" to "600" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Mengenneubewertung storno
Given I open an editor "mgebewneu-980st" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record from editor "mgebewneu-980"
And I set field "such" to "FALL-980ST"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Storno Kostenumlage
Given I open an editor "kostenuml-storno" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenuml-980"
And I set field "num135" to "980-STKM" 
And I save the current editor

# Storno Teil-Rechnung 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung-980-2.2"
And I set field "num4" to "980STRE2"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Storno Teil-Rechnung 1
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung-980-2.1"
And I set field "num4" to "980STRE1"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

#
# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-980"
And I set field "num4" to "980-STLS"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-980" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


