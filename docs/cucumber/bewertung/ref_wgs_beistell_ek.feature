#  Verantwortlich : uo
#
@persistent
Feature: Test Beistellungen mit Wertgutschriften
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

Scenario: Stammdaten

# Projektkostenrechnung einschalten
Given I set the fake date to "3.01.1995"
Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
And I save the current editor

# Artikel anlegen
Given I set the fake date to "4.01.1995"
Given I open an editor "A100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A100             |
   | name      | Artikel A100     |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | vpr       | 100              |
   | lief      | 1                |
   | chimlager | ja               |
   | epr       | 100              |
   | fvhe      | 2                |
   | vhe       | kg               |
And I save the current editor

Given I set the fake date to "5.01.1995"
Given I open an editor "TK100" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
   | such   | TK100             |
   | zptyp  | neutrale Position |
   | name   | Transportkosten   |
   | epr    | 100               |
And I save the current editor

# Bestand fuer Artikel A100
Given I set the fake date to "6.01.1995"
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | A100      |
    | buart     | Zugang    |
    | beleg     | LBU_A100  |
    | beldat    | .         |
    | wert      | 50.0000   |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 100    | F1       |
And I save the current editor


Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "BEWERT"
And I append rows
  | bewverf | bewab             | bewzu         |
  | 2       | Preis des Zugangs | Vorgangspreis |
And I save the current editor

Given I open an editor "E3-bewertverf" from table "(Part):(Product)" with command "UPDATE" for record "E3"
And I set field "ekbewverf" to "2"
And I save the current editor


Scenario: 41 EK mit Beistellung - Bestellung, Lieferschein mit MZ und Charge, Rechnung Gesamtmenge, zwei Teilwertgutschriften

Given I set the fake date to "7.01.1995"
Given I open an editor "TE141" from table "(Part):(Product)" with command "STORE" for record "TE141"
And I set fields
    | such      | TE141                 |
    | namebspr  | Schraube 141          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
    | chverfolgung | Chargenverfolgung                    |
    | chimlager | ja                    |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | E3    | 2         | Lieferantenbeistellung    |
And I save the current editor

Given I set the fake date to "8.01.1995"
Given I create a Lot "CH1" for Product "TE141"
Given I set the fake date to "9.01.1995"
Given I create a Lot "CH2" for Product "TE141"
Given I set the fake date to "10.01.1995"
Given I create a Lot "CH3" for Product "TE141"
Given I set the fake date to "11.01.1995"
Given I create a Lot "CH4" for Product "TE141"

# Bestellung
Given I set the fake date to "12.01.1995"
Given I open an editor "BE-141" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE141   |
    | such   | BE-141   |
    | ebeleg | BE-141   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE141   | 10  | 10    |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge mit 4 MZ, Charge, Rechnung soll aus Bestellung erzeugt werden
Given I set the fake date to "13.01.1995"
Given I open an editor "LS1-ZU-BE141" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE141"
And I set fields
   | nummer | 1EKLS141  |
   | ebeleg | LS1-BE141 |
   | such   | LS1-BE141 |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | charge  |
    | F1     |  1     | !CH1^id |
    | F2     |  2     | !CH2^id |
    | F3     |  3     | !CH3^id |
    | F2     |  4     | !CH4^id |
And I save the current editor
And I switch the current editor to editor "LS1-ZU-BE141"
And I save the current editor






# Erstellen und Buchen Rechnung 1 Gesamtmenge
Given I set the fake date to "14.01.1995"
Given I open an editor "RE1-ZU-BE141" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE141"
And I set fields
    | nummer | 1EKRE141  |
    | ebeleg | RE1-BE141 |
    | such   | RE1-BE141 |
    | ueb    | ja        |
    | vom    | .         |
    | tterm  | .         |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor











# Teilwertgutschrift zu Rechnung 1 erstellen und buchen, fuer CH1 1 Stueck, Preis 10,-
Given I set the fake date to "15.01.1995"
Given I open an editor "WERT-RE1-BE141" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE141"
And I set fields
    | nummer | 1TWGRE1    |
    | such   | EK1TWG141  |
    | ebeleg | EK1TWG141  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     | charge    |
    | 1     | -1    | 10.00     | !CH1^id   |
And I save the current editor







# Teilwertgutschrift 2 zu Rechnung 1 erstellen und buchen, OHNE Charge 10, insgesamt Wert 30,- (wird auf alle restliche Chargen verteilt)
Given I set the fake date to "16.01.1995"
Given I open an editor "WERT-RE1-BE141" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE141"
And I set fields
    | nummer | 1TWG2RE1   |
    | such   | EK2TWG141  |
    | ebeleg | EK2TWG141  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -3    | 10.00     |
And I save the current editor



# ist schon komplett gutgeschrieben

# pauschalisiert gutgeschrieben



Scenario: E3-Beistellteil einkaufen
#----------------------------------------

Given I set the fake date to "17.01.1995"

Given I open an editor "rechnung_fuer_artikel-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-E3 |
    | such4    | R11-E3|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | BEISTE3|
    | budat    | .      |
And I append rows
 | artikel     | mge | preis | tterm | ptext    	 	| platz |
 | EINK        | 200 | 6,00  | +4	 | beist-EINK-F		| F1    |
 | E3          | 500 | 7,00  | +4	 | beist-E3-F2		| F2    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Revaluation


Scenario: 42 EK mit Beistellung - BE, LS, RE, Komplettwertgutschrift, Storno WG, Teilwertgutschrift, Storno TWG, Storno RE

Given I set the fake date to "18.01.1995"
Given I open an editor "TE142" from table "(Part):(Product)" with command "STORE" for record "TE142"
And I set fields
    | such      | TE142                 |
    | namebspr  | Schraube 142          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | EINK  | 2         | Lieferantenbeistellung    |
And I save the current editor

# Bestellung
Given I set the fake date to "19.01.1995"
Given I open an editor "BE-142" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE142   |
    | such   | BE-142   |
    | ebeleg | BE-142   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE142   | 10  | 9     |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge, Rechnung soll aus Bestellung erzeugt werden
Given I set the fake date to "20.01.1995"
Given I open an editor "LS1-ZU-BE142" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE142"
And I set fields
   | nummer | 1EKLS142  |
   | ebeleg | LS1-BE142 |
   | such   | LS1-BE142 |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
And I save the current editor



# Erstellen und Buchen Rechnung 1 Gesamtmenge
Given I set the fake date to "21.01.1995"
Given I open an editor "RE1-ZU-BE142" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE142"
And I set fields
    | nummer | 1EKRE142  |
    | ebeleg | RE1-BE142 |
    | such   | RE1-BE142 |
    | ueb    | ja        |
    | vom    | .         |
    | tterm  | .         |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor



# Komplettwertgutschrift zu Rechnung 1 erstellen und buchen
Given I set the fake date to "22.01.1995"
Given I open an editor "KWG-RE1-BE142" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE142"
And I set fields
    | nummer | 1KWGRE1    |
    | such   | EK1KWG142  |
    | ebeleg | EK1KWG142  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
And I save the current editor

# Storno Komplettwertgutschrift
Given I set the fake date to "23.01.1995"
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE1-BE142"
And I save the current editor

# Teilwertgutschrift 1 zu Rechnung 1 erstellen und buchen
Given I set the fake date to "24.01.1995"
Given I open an editor "TWG-RE1-BE142" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE142"
And I set fields
    | nummer | 1TWG1RE1   |
    | such   | EK1TWG142  |
    | ebeleg | EK1TWG142  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I modify table
    | !row  | mge   | preis     |
    | 1     | -2    | 10.00     |
And I save the current editor




# Storno Teilwertgutschrift
Given I set the fake date to "25.01.1995"
Given I open an editor "STORNO-TWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG-RE1-BE142"
And I save the current editor



# Storno der Rechnung
Given I set the fake date to "26.01.1995"
Given I open an editor "STORNO-RE1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE1-ZU-BE142"
And I save the current editor





Scenario: 43 EK mit Beistellung - BE, LS, RE, Teilwertgutschrift, Storno TWG, Komplettwertgutschrift, Storno WG, Storno RE

Given I set the fake date to "27.01.1995"
Given I open an editor "TE143" from table "(Part):(Product)" with command "STORE" for record "TE143"
And I set fields
    | such      | TE143                 |
    | namebspr  | Schraube 143          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | EINK  | 2         | Lieferantenbeistellung    |
And I save the current editor

# Bestellung
Given I set the fake date to "28.01.1995"
Given I open an editor "BE-143" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE143   |
    | such   | BE-143   |
    | ebeleg | BE-143   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TE143   | 10  | 9     |
And I save the current editor

# Lieferscheine aus Bestellung, Gesamtmenge, Rechnung soll aus Bestellung erzeugt werden
Given I set the fake date to "1.2.1995"
Given I open an editor "LS1-ZU-BE143" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE143"
And I set fields
   | nummer | 1EKLS143  |
   | ebeleg | LS1-BE143 |
   | such   | LS1-BE143 |
   | ueb    | ja        |
   | fakt   | nein      |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "10" in row 1
And I save the current editor



# Erstellen und Buchen Rechnung 1 Gesamtmenge
Given I set the fake date to "2.2.1995"
Given I open an editor "RE1-ZU-BE143" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE143"
And I set fields
    | nummer | 1EKRE143  |
    | ebeleg | RE1-BE143 |
    | such   | RE1-BE143 |
    | ueb    | ja        |
    | vom    | .         |
    | tterm  | .         |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor




# Teilwertgutschrift 1 zu Rechnung 1 erstellen und buchen
Given I set the fake date to "3.2.1995"
Given I open an editor "TWG-RE1-BE143" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE143"
And I set fields
    | nummer | 1TWG1RE1   |
    | such   | EK1TWG143  |
    | ebeleg | EK1TWG143  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I modify table
    | !row  | mge   | preis     |
    | 1     | -2    | 10.00     |
And I save the current editor

# Journaleintrag zur Wertgutschrift

# Storno Teilwertgutschrift
Given I set the fake date to "4.2.1995"
Given I open an editor "STORNO-TWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG-RE1-BE143"
And I save the current editor

# Journal zum Storno der Teilwertgutschrift 1



# Komplettwertgutschrift zu Rechnung 1 erstellen und buchen
Given I set the fake date to "5.2.1995"
Given I open an editor "KWG-RE1-BE143" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE143"
And I set fields
    | nummer | 1KWGRE1    |
    | such   | EK1KWG143  |
    | ebeleg | EK1KWG143  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I press button "komplettieren"
And I save the current editor

# Storno Komplettwertgutschrift
Given I set the fake date to "6.2.1995"
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE1-BE143"
And I save the current editor

# Journal zum Storno der Komplettwertgutschrift



# Storno der Rechnung
Given I set the fake date to "7.2.1995"
Given I open an editor "STORNO-RE1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE1-ZU-BE143"
And I save the current editor





Scenario: 44 EK mit Beistellung - Rechnung mit MZ, ohne Bestellung davor, Komplettwertgutschrift, Storno WG, Teilwertgutschrift

Given I set the fake date to "8.2.1995"
Given I open an editor "TEB44" from table "(Part):(Product)" with command "STORE" for record "TEB44"
And I set fields
    | such      | TEB44                 |
    | namebspr  | Schraube B44          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | E3    | 2         | Lieferantenbeistellung    |
And I save the current editor

# Rechnung mit Lagerbewegung, 3 MZ, ohne Bestellung vorher
Given I set the fake date to "9.2.1995"
Given I open an editor "RE-ZU-TEB44" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 001         |
    | nummer | 1EKREB44    |
    | ebeleg | RE-LB-TEB44 |
    | such   | RE-TEB44    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | ja          |
And I append rows
    | artikel | mge | preis |
    | TEB44   |  6  | 11    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     |  1     |
    | F2     |  2     |
    | F3     |  3     |
And I save the current editor
And I switch the current editor to editor "RE-ZU-TEB44"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
















# Komplettwertgutschrift zu Rechnung erstellen und buchen
Given I set the fake date to "10.2.1995"
Given I open an editor "KWG-RE1-BEB44" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB44"
And I set fields
    | nummer | 1KWGRE1    |
    | such   | EK1KWGB44  |
    | ebeleg | EK1KWGB44  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -6    | 11.00     |
And I save the current editor

# Storno Komplettwertgutschrift
Given I set the fake date to "11.2.1995"
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE1-BEB44"
And I save the current editor




# Teilwertgutschrift zu Rechnung 1 erstellen und buchen
Given I set the fake date to "12.2.1995"
Given I open an editor "TWG-RE1-BEB44" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB44"
And I set fields
    | nummer | 1TWG1RE1   |
    | such   | EK1TWGB44  |
    | ebeleg | EK1TWGB44  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -3    | 4.00      |
And I save the current editor


Scenario: 45 EK mit Beistellung - Rechnung mit MZ, ohne Bestellung davor, Teilwertgutschrift, Storno TWG, Komplettwertgutschrift, Storno WG, Teilwertgutschrift

Given I set the fake date to "13.2.1995"
Given I open an editor "TEB45" from table "(Part):(Product)" with command "STORE" for record "TEB45"
And I set fields
    | such      | TEB45                 |
    | namebspr  | Schraube B45          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | E3    | 2         | Lieferantenbeistellung    |
And I save the current editor

# Rechnung mit Lagerbewegung, 3 MZ, ohne Bestellung vorher
Given I set the fake date to "14.2.1995"
Given I open an editor "RE-ZU-TEB45" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | 001         |
    | nummer | 1EKREB45    |
    | ebeleg | RE-LB-TEB45 |
    | such   | RE-TEB45    |
    | ueb    | ja          |
    | vom    | .           |
    | tterm  | .           |
    | fakt   | ja          |
And I append rows
    | artikel | mge | preis |
    | TEB45   | 15  | 10    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F1     |  10    |
    | F2     |  2     |
    | F3     |  3     |
And I save the current editor
And I switch the current editor to editor "RE-ZU-TEB45"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
















Given I set the fake date to "15.2.1995"
Given I open an editor "TWG1-RE1-BEB45" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB45"
And I set fields
    | nummer | 1TWG1RE1   |
    | such   | EK1TWGB45  |
    | ebeleg | EK1TWGB45  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -3    | 5.00      |
And I save the current editor

# Storno Teilwertgutschrift 1
Given I set the fake date to "16.2.1995"
Given I open an editor "STORNO-TWG1" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG1-RE1-BEB45"
And I save the current editor




# Komplettwertgutschrift zu Rechnung erstellen und buchen
Given I set the fake date to "17.2.1995"
Given I open an editor "KWG-RE1-BEB45" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB45"
And I set fields
    | nummer | 1KWGRE1    |
    | such   | EK1KWGB45  |
    | ebeleg | EK1KWGB45  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -15   | 10.00     |
And I save the current editor

# Storno Komplettwertgutschrift
Given I set the fake date to "18.2.1995"
Given I open an editor "STORNO-KWG" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KWG-RE1-BEB45"
And I save the current editor




# Teilwertgutschrift 2 zu Rechnung 1 erstellen und buchen
Given I set the fake date to "19.2.1995"
Given I open an editor "TWG2-RE1-BEB45" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-TEB45"
And I set fields
    | nummer | 1TWG2RE1   |
    | such   | EKTWG2B45  |
    | ebeleg | EKTWG2B45  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
Then the table has 4 rows
And I modify table
    | !row  | mge   | preis     |
    | 1     | -3    | 5.00      |
And I save the current editor


#------------------------------------------------------------------------------------------------
Scenario: 46 EK mit Beistellung - BE, RE, mehrere Teilwertgutschriften, LS Teilmenge, Storno TWG
#------------------------------------------------------------------------------------------------

# BE---REoLB---TWGS1---TWGS2----TWGS3-----------------TLS-----STWGS3---.... TWGS(beist)-------NB
# (1)  (2)     (3)     (4)      (5)                   (6)      (7)         in Folgeszenario
#              TWGS: in summe 300,- von 2000,-

Given I set the fake date to "20.2.1995"
Given I open an editor "TEB46" from table "(Part):(Product)" with command "STORE" for record "TEB46"
And I set fields
    | such      | TEB46                 |
    | namebspr  | Schraube B46          |
    | vpr       | 15                    |
    | epr       | 10.50                 |
    | bsart     | Fremdbeschaffung      |
    | dispoa    | auftragsbezogen       |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | EINK  | 2         | Lieferantenbeistellung    |
And I save the current editor

# (1) Bestellung
Given I set the fake date to "21.2.1995"
Given I open an editor "BE-146" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | 001      |
    | nummer | 1BE146   |
    | such   | BE-146   |
    | ebeleg | BE-146   |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel | mge | preis |
    | TEB46   | 100 | 18    |
And I save the current editor

# (2) Erstellen und Buchen Rechnung ohne Lagerbewegung, Gesamtmenge
Given I set the fake date to "22.2.1995"
Given I open an editor "RE1-ZU-BE146" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE146"
And I set fields
    | nummer | 1EKRE146  |
    | ebeleg | RE1-BE146 |
    | such   | RE1-BE146 |
    | ueb    | ja        |
    | fakt   | nein      |
    | vom    | .         |
    | tterm  | .         |
And I set field "mge" to "100" in row 1
And I set field "preis" to "20.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# (3) Teilwertgutschrift 1 zu Rechnung 1 erstellen und buchen
Given I set the fake date to "23.2.1995"
Given I open an editor "TWG1-RE1-BE146" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE146"
And I set fields
    | nummer | 1TWG1RE1   |
    | such   | EK1TWG146  |
    | ebeleg | EK1TWG146  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I modify table
    | !row  | mge   | preis     |
    | 1     | -100  | 1.00      |
And I save the current editor


# (4) Teilwertgutschrift 2 zu Rechnung 1 erstellen und buchen
Given I set the fake date to "24.2.1995"
Given I open an editor "TWG2-RE1-BE146" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE146"
And I set fields
    | nummer | 1TWG2RE1   |
    | such   | EK2TWG146  |
    | ebeleg | EK2TWG146  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I modify table
    | !row  | mge   | preis     |
    | 1     | -10   | 10.00     |
And I save the current editor


# (5) Teilwertgutschrift 3 zu Rechnung 1 erstellen und buchen
Given I set the fake date to "25.2.1995"
Given I open an editor "TWG3-RE1-BE146" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-BE146"
And I set fields
    | nummer | 1TWG3RE1   |
    | such   | EK3TWG146  |
    | ebeleg | EK3TWG146  |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I modify table
    | !row  | mge   | preis     |
    | 1     | -50   | 2.00      |
And I save the current editor


# (6) Lieferscheine aus Bestellung, Teilmenge
Given I set the fake date to "26.2.1995"
Given I open an editor "LS1-ZU-BE146" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE146"
And I set fields
   | nummer | 1EKLS146  |
   | ebeleg | LS1-BE146 |
   | such   | LS1-BE146 |
   | ueb    | ja        |
   | vom    | .         |
   | tterm  | .         |
And I set field "mge" to "25" in row 1
And I save the current editor


# (7) Storno Teilwertgutschrift 3
Given I set the fake date to "27.2.1995"
Given I open an editor "STORNO-TWG3" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "TWG3-RE1-BE146"
And I save the current editor


#------------------------------------------------------------------
Scenario: Teilwertgutschrift Beistellteile für alle Vorgänge
#------------------------------------------------------------------
 
Given I set the fake date to "28.2.1995"
Given I open an editor "twgs-beistellteile" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+11-E3"
And I set fields
    | nummer | 11-E3-GS   |
    | such   | WGS-11-E3  |
    | ebeleg | WGS-EINK-E3 |
    | tterm  | .          |
    | budat  | .          |
    | vom    | .          |
    | ueb    | ja         |
And I modify table
    | !row  | mge    |
# Artikel EINK               da Mischpreisbewertung im Abgang, keine Aktualisierung der mengenabhängigen Bewertungen mehr
    | 1     | -100   |
# Artikel E3                 Preis des Zugangs als Abgangsbewertung
    | 2     | -200   |
And I save the current editor


Given I set the fake date to "01.3.1995"
And I run Revaluation
