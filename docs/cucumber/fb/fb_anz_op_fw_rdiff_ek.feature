# *****************************************************************************
#  Name             : fb_anz_op_fw_rdiff_ek.feature
#  Autor            : jeffler
#  Verantwortlich   : hc
#  Kontrolle        : 
#  Funktion         : Test des Verhaltens bei Kurs-/Rundungsdifferenzen 
#                      bei OPs aus Rechnung und OPs aus Anzahlungsrechnung im Einkauf
#
# *****************************************************************************
@persistent

Feature: fb_rewe-3830_ek
Background: Zahlungsverkehr

Given I set the fake date to "10.02.2023"

Scenario: Vorgangssteuerregel für EU 0 anlegen und in Konfig eintragen

Given I open an editor "vrgstrgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "COPY" for record "VKEUFREI"
And I set field "such" to "EKEUFREI"
And I set field "ev" to "Einkauf"
And I set field "namebspr" to "Einkauf, EU-Staat, steuerfrei"
And I set field "zmrel" to "nein"
And I set field "zmustid" to ""
And I save the current editor
And I close the current editor

Given I open an editor "vrgstrglkonf" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
|     ev|rechnlaart|bestlaart|vrgstrgl|
|Einkauf|  EU-Staat| EU-Staat|EKEUFREI|
And I save the current editor
And I close the current editor

Scenario: Steuerregel und Kontensteuerregel für EU 0 anlegen

Given I open an editor "strgl" from table "(TaxCode):(TaxRule)" with command "NEW" for record ""
And I set fields
|such   |  EKEUNULL|
|ev     |   Einkauf|
|stlaart|  EU-Staat|
|ustart |steuerfrei|
|sts    |         0|
And I append rows
|sts|budatstper|stdatstper|
|  0| STS0-PER1| STS0-PER1|
And I save the current editor
And I close the current editor

Given I open an editor "kstrgl" from table "(TaxCode):(AccountTaxRule)" with command "NEW" for record ""
And I set field "such" to "EKEUFREI-0"
And I set field "ev" to "Einkauf"
And I append rows
|vrgstrgl|   strgl|
|EKEUFREI|EKEUNULL|
And I save the current editor
And I close the current editor

Scenario: Kontensteuerregel für Inland 0 aktualisieren

Given I open an editor "kstrgl" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "7006"
And I set field "vrgstrgl" to "EKINFREI" in row 1
And I save the current editor
And I close the current editor


Scenario Outline: Konten für Vorgangskontentausch vorbereiten/anlegen

Given I open an editor "acc<i>" from table "(Account):(Account)" with command "COPY" for record "<record>"
And I set field "nummer" to "<nummer>"
And I set field "ktostrgl" to "<kstrgl>"
And I save the current editor
And I close the current editor

Examples:

|i|record| nummer|    kstrgl|
|1| 57300|57300-1|EKEUFREI-0|
|2| 10001|10001-1|EKEUFREI-0|
|3| 10001|  10003|EKINFREI-0|
|4| 11861|11861-1|EKEUFREI-0|
|5| 11861|  11863|EKINFREI-0|

Scenario: Steuerregel aktualisieren

Given I open an editor "strgl" from table "(TaxCode):(TaxRule)" with command "UPDATE" for record "EKEUNULL"
And I set field "skkto" to "57300-1" in row 1
And I save the current editor
And I close the current editor

Scenario Outline: Konten in Vorgangskontentausch eintragen

Given I open an editor "pac<i>" from table "(ProcessAccountChange):(ProcessAccountChange)" with command "UPDATE" for record "<record>"
Then the table has 2 rows
Then field "konto" has value "<ko1alt>" in row 1
And I set field "vrgstrgl" to "<vstrgl1>" in row 1
And I set field "konto" to "<ko1neu>" in row 1
Then field "konto" has value "<ko2>" in row 2
And I create a new row at the end of the table
And I set field "vrgstrgl" to "<vstrgl3>" in row 3
And I set field "konto" to "<ko3>" in row 3
And I save the current editor
And I close the current editor

Examples:

|i|record|ko1alt| vstrgl1| ko1neu|  ko2| vstrgl3|  ko3|
|1| 10000| 10001|EKEUFREI|10001-1|10002|EKINFREI|10003|
|2| 11860| 11861|EKEUFREI|11861-1|11862|EKINFREI|11863|

Scenario: Lieferanten anlegen

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set field "such" to "DIEB"
And I set field "namebspr" to "Dietrich Ernst Bootsbau"
And I set field "ans" to "Dietrich Ernst"
And I set field "str" to "Nebenstraße 42"
And I set field "plz" to "22345"
And I set field "nort" to "Meppen Nord"
And I set field "staat" to "GROSSBRITANNIEN"
Then field "laarta" has value "Ausland"
And I set field "waehr" to "GBP"
And I set field "vrgstrgl" to "EKAUSFREI"
And I set field "zbed" to "PROZ2"
And I save the current editor
And I close the current editor

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set field "such" to "TIM"
And I set field "namebspr" to "Thorsten Insbruck Maschinenbau"
And I set field "ans" to "Thorsten Insbruck"
And I set field "str" to "Seitenstraße 42"
And I set field "plz" to "32345"
And I set field "nort" to "Meppen West"
And I set field "staat" to "SCHWEDEN"
Then field "laarta" has value "EU-Staat"
And I set field "waehr" to "SEK"
And I set field "vrgstrgl" to "EKEUFREI"
And I set field "zbed" to "PROZ2"
And I save the current editor
And I close the current editor

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "COPY" for record "TIM"
And I set field "such" to "TIMUS"
And I set field "namebspr" to "Thorsten Insbruck Maschinenbau US"
And I set field "staat" to "USA"
Then field "laarta" has value "Ausland"
And I set field "waehr" to "USD"
And I set field "vrgstrgl" to "EKAUSFREI"
And I set field "zbed" to "PROZ2"
And I save the current editor
And I close the current editor

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "COPY" for record "TIMUS"
And I set field "such" to "TIMUSUEB"
And I save the current editor
And I close the current editor

Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "COPY" for record "DIEB"
And I set field "such" to "DIEBDE"
And I set field "namebspr" to "Dietrich Ernst Bootsbau CH"
And I set field "staat" to "DEUTSCHLAND"
Then field "laarta" has value "Inland"
And I set field "waehr" to "EUR"
And I set field "vrgstrgl" to "EKINFREI"
And I set field "zbed" to "PROZ2"
And I save the current editor
And I close the current editor

Scenario: OP umbuchen - OP Währung ist Fremdwährung, Buchungswährung ist Inlandswährung

# Anfrage für Anzahlungsrechnung erfassen
Given I open an editor "anfr1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    |nummer|600001-1|
    |vom   |10.02.23|
    |lief  |    DIEB|
Then field "vstaat" has value "GROSSBRITANNIEN"
And I create a new row at the end of the table
And I set field "Artikel" to "EKTeilGBP" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "Artikel" to "ANZ" in row 2
And I save the current editor
And I close the current editor

# Anzahlungsrechnung erfassen und buchen
Given I open an editor "EKRech" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to "600001-1"
And I press button "bureabschluss"
And I set field "num" to "1.5"
Then field "vrgstrgl" has value "EKAUSFREI"
Then field "erfwaehr" has value "GBP"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
Then the table has 1 rows
And I set field "pwert" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-23262.56" in row 1
And I set field "vom" to "10.02.23"
And I set field "budat" to "10.02.23"
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung erfassen und buchen
Given I open an editor "EKRech" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num" to "2.5"
And I set field "lief" to "DIEB"
Then field "zbed^such" has value "PROZ2"
Then field "vrgstrgl" has value "EKAUSFREI"
Then field "erfwaehr" has value "GBP"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
And I create a new row at the end of the table
And I set field "artikel" to "EKTeilGBP" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-1" in row 1
And I set field "vom" to "10.02.23"
And I set field "budat" to "10.02.23"
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Geldtransitkonto für sonstige Zahlung anlegen
Given I open an editor "gtk" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "7201-1"
And I set field "such" to "GTK"
And I set field "namebspr" to "Geldtransitkonto"
And I set field "karta" to "Geldtransitkonto"
And I set field "oprel" to "ja"
And I set field "zaform" to "Sonstige"
And I save the current editor
And I close the current editor

# OP umbuchen
Given I open an editor "umbuch" from table "(OIProcessing):(OtherPayments)" with command "NEW" for record ""
And I set field "zaeinaus" to "Zahlungsausgang"
And I set field "gkonto" to "7201-1"
And I set field "beleg" to "1510"
And I set field "beldat" to "10.02.23"
And I set field "kbudat" to "10.02.23"
And I create a new row at the end of the table
And I set field "konto" to "l dieb" in row 1
And I press button "topladen" in row 1
Then the table has 2 rows
And I press button "tueber" in row 1
Then field "opzabetr" has value "22797.31" in row 1
Then field "kursdiff" has value "-0.01" in row 1
Then field "sumkursdiff" has value "-0.01"
Then field "kokursdiff" has value "-0.01"
And I set field "skstelle" to "100" in row 1
And I set field "kursdiffkst" to "100" in row 1
And I press button "tueber" in row 2
Then field "opzabetr" has value "22797.31" in row 2
Then field "kursdiff" has value "-0.01" in row 2
Then field "sumkursdiff" has value "-0.02"
Then field "kokursdiff" has value "-0.02"
And I set field "skstelle" to "100" in row 2
And I set field "kursdiffkst" to "100" in row 2
# 588 : Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario: OP verrechnen - OP-Währung ist Fremdwährung, Buchungswährung ist Inlandswährung

# Anfrage für Anzahlungsrechnung erfassen
Given I open an editor "anfr2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    |nummer|600002-1|
    |vom   |10.02.23|
    |lief  |    DIEB|
Then field "vstaat" has value "GROSSBRITANNIEN"
And I create a new row at the end of the table
And I set field "Artikel" to "EKTeilGBP" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "Artikel" to "ANZ" in row 2
And I save the current editor
And I close the current editor

# Anzahlungsrechnung erfassen und buchen
Given I open an editor "EKRech" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "600002-1"
And I press button "bureabschluss"
And I set field "vorganga" to "Anzahlung"
And I set field "num" to "3.5"
Then field "vrgstrgl" has value "EKAUSFREI"
Then field "erfwaehr" has value "GBP"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
Then the table has 1 rows
And I set field "pwert" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-23262.56" in row 1
And I set field "vom" to "10.02.23"
And I set field "budat" to "10.02.23"
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Finanzbuchung für Lieferanten in Fremwährung erfassen -> OP für Verrechnung entsteht
Given I open an editor "fibu" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "erfwaehr" to "GBP"
Then field "iwbu" has value "EUR"
Then field "ewekurs" has value "1.150298"
And I set field "beldat" to "10.02.23"
And I set field "budat" to "10.02.23"
And I append rows
| konto| ewsbetr| ewhbetr|
|l dieb|23262,56|    0,00|
| 18100|    0,00|23262,56|
# 1941 : Buchung o.k., Automatische Belegnummer?
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Finanzbuchung erfassen (um später Skontobetrag zu verrechnen und die Verrechnungsbeträge auf 0.00 zu bekommen, ohne die für die Rundungsdifferenz notwendigen Werte zu verlieren)
Given I open an editor "fibu" from table "(Entry):(Entry)" with command "NEW" for record ""
Then field "erfwaehr" has value "EUR"
And I set field "beldat" to "10.02.23"
And I set field "budat" to "10.02.23"
And I append rows
| konto|ewsbetr|ewhbetr|
|l dieb|   0,00| 535,18|
| 16000| 535,18|   0,00|
# 1941 : Buchung o.k., Automatische Belegnummer?
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Verrechnungskonto anlegen
Given I open an editor "verrkto" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "18555-1"
And I set field "such" to "verrechkto"
And I set field "namebspr" to "Verrechnungskonto"
And I set field "karta" to "Verrechnungskonto"
And I save the current editor
And I close the current editor

# OPs verrechnen 
Given I open an editor "verrech" from table "(OIProcessing):(SettleOutstandingItems)" with command "NEW" for record ""
And I set field "verrkonto" to "18555-1"
And I set field "beleg" to "400050"
And I set field "beldat" to "10.02.23"
And I set field "kbudat" to "10.02.23"
And I set field "kwaehr" to "GBP"
And I create a new row at the end of the table
And I set field "konto" to "l dieb" in row 1
And I press button "topladen" in row 1
Then the table has 3 rows
Then field "ofbetr" has value "23262.56" in row 1
And I press button "tueber" in row 1
Then field "sksatz" has value "2" in row 1
Then field "opzabetr" has value "22797.31" in row 1
Then field "skbetr" has value "465.25" in row 1
And I set field "sksatz" to "0" in row 2
Then field "opzabetr" has value "23262.56" in row 2
And I set field "sksatz" to "0" in row 3
Then field "opzabetr" has value "465.25" in row 3
Then field "kursdiff" has value "-0.01" in row 1
Then field "kursdiff" has value "0.00" in row 2
Then field "kursdiff" has value "0.00" in row 3
Then field "suzabetr" has value "0.00" in row 0
Then field "sumkursdiff" has value "0.01" in row 0
Then field "subudm" has value "-0.01" in row 0
Then field "kozabetr" has value "0.00" in row 0
And I set field "skstelle" to "100" in row 1
And I set field "kursdiffkst" to "100" in row 1
# 588 : Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario Outline: OPs ausbuchen

# Auftrag für Anzahlungsrechnung erfassen
Given I open an editor "best<nr>" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    |nummer|<beleg>|
    |vom   |  <vom>|
    |lief  | <lief>|
Then field "vstaat" has value "<vstaat>"
Then field "ewekurs" has value "<ewekurs1>" in row 0
And I create a new row at the end of the table
And I set field "Artikel" to "<artikel>" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "Artikel" to "ANZ" in row 2
And I save the current editor
And I close the current editor

# Anzahlungsrechnungen erzeugen und buchen
Given I open an editor "EKRech<nr>" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to "<beleg>"
And I press button "bureabschluss" in row 0
Then field "vrgstrgl" has value "<vrgstrgl>"
Then field "erfwaehr" has value "<waehr>"
Then field "ewekurs" has value "<ewekurs1>"
Then field "iwbu" has value "EUR"
Then the table has 1 rows
And I set field "pwert" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-23262.56" in row 1
And I set field "vom" to "<vom>"
And I set field "vdat" to "<vom>"
And I set field "budat" to "<vom>"
And I set field "num" to "6.9" in row 0
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung erzeugen und buchen 
Given I open an editor "EKRech<nr>" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "<lief>"
Then field "zbed^such" has value "PROZ2"
Then field "vrgstrgl" has value "<vrgstrgl>"
Then field "erfwaehr" has value "<waehr>"
Then field "ewekurs" has value "<ewekurs1>"
Then field "iwbu" has value "EUR"
And I create a new row at the end of the table
And I set field "artikel" to "<artikel>" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-1" in row 1
And I set field "vom" to "<vom>" in row 0
And I set field "vdat" to "<vom>" in row 0
And I set field "budat" to "<vom>" in row 0
And I set field "ueb" to "ja" in row 0
And I set field "num" to "8.7" in row 0
And I set field "intrarel" to "nein" in row 1
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "opausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "nummer" to "161-<nr>"
And I set field "gkonto" to "18100"
And I set field "beldat" to "10.02.23"
And I set field "kbudat" to "10.02.23"
And I set field "beleg" to "400050"
And I set field "kwaehr" to "<kwaehr>"
And I create a new row at the end of the table
And I set field "konto" to "l <lief>" in row 1
And I press button "topladen" in row 1
Then the table has 2 rows
And I set field "gkowaehr" to "EUR" in row 0
And I set field "kowaehr" to "EUR" in row 0
Then field "ofbetr" has value "<ofbetr>" in row 1
And I press button "tueber" in row 1
Then field "opzabetr" has value "<opzabetr>" in row 1
And I set field "skstelle" to "100" in row 1
Then field "kursdiff" has value "<kursdiff>" in row 1
Then field "kokursdiff" has value "<kokursdiff>" in row 0
Then field "sumkursdiff" has value "<sumkursdiff>" in row 0
And I set field "kursdiffkst" to "100" in row 1
Then field "ofbetr" has value "<ofbetr>" in row 2
And I press button "tueber" in row 2
Then field "opzabetr" has value "<opzabetr>" in row 2
And I set field "skstelle" to "100" in row 2
Then field "kursdiff" has value "<kursdiffr2>" in row 2
Then field "kokursdiff" has value "<kokursdiff2>" in row 0
Then field "sumkursdiff" has value "<sumkursdiff2>" in row 0
And I set field "kursdiffkst" to "100" in row 2
# 588 : Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Examples:

|nr|   beleg|     vom|  lief|     vstaat| vrgstrgl|  artikel|waehr|ewekurs1|ewekurs2|ausbudat|kwaehr|  ofbetr|opzabetr|kursdiff|sumkursdiff|kokursdiff|koasaldo|kursdiffr2|kokursdiff2|sumkursdiff2|
| 1|200001-1|10.02.23| TIMUS|        USA|EKAUSFREI|EKTeilUSD|  USD|1.150298|1.150298|10.02.23|   USD|23262.56|22797.31|   -0.01|       0.01|      0.01|    0.00|     -0.01|       0.02|        0.02|
| 2|200002-1|21.03.22| TIMUS|        USA|EKAUSFREI|EKTeilUSD|  USD|1.150298|1.000000|10.02.23|   USD|23262.56|22797.31|   -0.01|       0.01|      0.01|    0.00|  -3496.32|    3496.33|     3496.33|
| 3|200003-1|10.02.23|   TIM|   SCHWEDEN| EKEUFREI|EKTeilSEK|  SEK|1.100000|1.100000|10.02.23|   DKK|26758.86|26223.68|    0.01|      -0.01|     -0.01|    0.01|      0.01|      -0.02|       -0.02|
| 4|200004-1|10.02.23|DIEBDE|DEUTSCHLAND| EKINFREI|EKTeilEUR|  EUR|1.000000|0.869340|10.02.23|   CHF|26758.87|26223.69|    0.01|      -0.01|     -0.01|    0.01|      0.01|      -0.02|       -0.02|



# 1) OP ausbuchen - erfassen Fremdwährung, buchen Inlandswährung
# 2) OP erstellen in Fremdwährung, Zahlung in gleicher Fremdwährung mit verändertem Kursdifferenzen
# 3) OP erstellen in Fremdwährung, zahlen in anderer Fremdwährung
# 4) OP in Inlandswährung erstellen, in Fremdwährung ausbuchen

Scenario: OPs überbezahlen

# Auftrag für Anzahlungsrechnung erfassen
Given I open an editor "opuebbest" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    |nummer|200005-1|
    |vom   |10.02.23|
    |lief  |TIMUSUEB|
Then field "vstaat" has value "USA"
Then field "ewekurs" has value "1.150298" in row 0
And I create a new row at the end of the table
And I set field "Artikel" to "EKTeilUSD" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "Artikel" to "ANZ" in row 2
And I save the current editor
And I close the current editor

# Anzahlungsrechnungen erzeugen und buchen
Given I open an editor "EKRech5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to "200005-1"
And I press button "bureabschluss" in row 0
Then field "vrgstrgl" has value "EKAUSFREI"
Then field "erfwaehr" has value "USD"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
Then the table has 1 rows
And I set field "pwert" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-23262.56" in row 1
And I set field "vom" to "10.02.23"
And I set field "vdat" to "10.02.23"
And I set field "budat" to "10.02.23"
And I set field "num" to "6.9" in row 0
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung erzeugen und buchen 
Given I open an editor "EKRech5" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "TIMUSUEB"
Then field "zbed^such" has value "PROZ2"
Then field "vrgstrgl" has value "EKAUSFREI"
Then field "erfwaehr" has value "USD"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
And I create a new row at the end of the table
And I set field "artikel" to "EKTeilUSD" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-1" in row 1
And I set field "vom" to "10.02.23" in row 0
And I set field "vdat" to "10.02.23" in row 0
And I set field "budat" to "10.02.23" in row 0
And I set field "ueb" to "ja" in row 0
And I set field "num" to "8.7" in row 0
And I set field "intrarel" to "nein" in row 1
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "opausbueb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "nummer" to "161-5"
And I set field "gkonto" to "18100"
And I set field "beldat" to "10.02.23"
And I set field "kbudat" to "10.02.23"
And I set field "beleg" to "400050"
And I set field "kwaehr" to "USD"
And I create a new row at the end of the table
And I set field "konto" to "l timusueb" in row 1
And I press button "topladen" in row 1
Then the table has 2 rows
Then field "opart" has value "Anzahlungen" in row 1
Then field "opart" has value "" in row 2
And I set field "gkowaehr" to "EUR" in row 0
And I set field "kowaehr" to "EUR" in row 0
Then field "ofbetr" has value "23262.56" in row 1
And I set field "opzabetr" to "200000" in row 1
Then field "ofbetr" has value "-180819.07" in row 1
Then field "skbetr" has value "4081.63" in row 1
And I set field "skstelle" to "100" in row 1
Then field "kursdiff" has value "-0.01" in row 1
Then field "kokursdiff" has value "0.01" in row 0
Then field "sumkursdiff" has value "0.01" in row 0
And I set field "kursdiffkst" to "100" in row 1
Then field "ofbetr" has value "23262.56" in row 2
And I set field "opzabetr" to "200000" in row 2
Then field "ofbetr" has value "-180819.07" in row 2
Then field "skbetr" has value "4081.63" in row 2
And I set field "skstelle" to "100" in row 2
Then field "kursdiff" has value "-0.01" in row 2
Then field "kokursdiff" has value "0.02" in row 0
Then field "sumkursdiff" has value "0.02" in row 0
And I set field "kursdiffkst" to "100" in row 2
# 4056 : Überzahlung der Anzahlungsanforderung nicht erlaubt
Then saving the current editor throws the exception "4056"
And I delete row at position 1
And I set field "gkowaehr" to "EUR" in row 0
And I set field "kowaehr" to "EUR" in row 0
Then field "kokursdiff" has value "0.01" in row 0
Then field "sumkursdiff" has value "0.01" in row 0
# 588 : Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

