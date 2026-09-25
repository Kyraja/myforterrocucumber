# *****************************************************************************
#  Name             : fb_anz_op_fw_rdiff_vk.feature
#  Autor            : jeffler
#  Verantwortlich   : hc
#  Kontrolle        : 
#  Funktion         : Test des Verhaltens bei Kurs-/Rundungsdifferenzen 
#                     bei OPs aus Rechnung und OPs aus Anzahlungsrechnung im Verkauf
#
# *****************************************************************************
@persistent

Feature: rewe-3830_vk
Background: Zahlungsverkehr

Given I set the fake date to "10.02.2023"

Scenario: Kunde anlegen

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set field "such" to "KLAUS"
And I set field "namebspr" to "K. L. Ausland"
And I set field "ans" to "Kunigunde Ludwig"
And I set field "str" to "Hauptstraße 42"
And I set field "plz" to "12345"
And I set field "nort" to "Meppen Süd"
And I set field "staat" to "USA"
And I set field "region" to "IL"
Then field "laarta" has value "Ausland"
And I set field "waehr" to "USD"
And I set field "vrgstrgl" to "VKAUSFREI"
And I set field "zbed" to "PROZ2"
And I save the current editor
And I close the current editor

# Kopie für überzahlung
Given I open an editor "kundeueb" from table "(Customer):(Customer)" with command "COPY" for record "KLAUS"
And I set field "such" to "KLAUSUEB"
And I save the current editor
And I close the current editor


Scenario Outline: Kundenkopie für verschiedene Währungen anlegen

Given I open an editor "kunde2" from table "(Customer):(Customer)" with command "COPY" for record "KLAUS"
And I set field "such" to "KLAUS<sucherw>"
And I set field "namebspr" to "K. L. Ausland <sucherw>"
And I set field "staat" to "<land>"
Then field "laarta" has value "<laarta>"
And I set field "waehr" to "<waehr>"
And I set field "vrgstrgl" to "<vrgstrgl>"
And I set field "ustid" to "<ustid>"
And I set field "zbed" to "PROZ2"
And I save the current editor
And I close the current editor

Examples:

|sucherw|           land|  laarta|waehr| vrgstrgl|      ustid|
|     GB|GROSSBRITANNIEN| Ausland|  GBP|VKAUSFREI|           |
|     SE|       SCHWEDEN|EU-Staat|  SEK| VKEUFREI|SE123456789|
|     DE|    DEUTSCHLAND|  Inland|  EUR|     VKIN|           |

Scenario Outline: Kontensteuerregeln anpassen

Given I open an editor "acc" from table "(Account):(Account)" with command "UPDATE" for record "<record>"
And I set field "ktostrgl" to "VKINFREI-0"
And I save the current editor
And I close the current editor

Examples:

|record|
| 32720|
| 44000|

Scenario: OP umbuchen - OP Währung ist Fremdwährung, Buchungswährung ist Inlandswährung

# Anfrage für Anzahlungsrechnung erfassen
Given I open an editor "anfr1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    |nummer|  600001|
    |vom   |10.02.23|
    |kunde | KLAUSGB|
Then field "vstaat" has value "GROSSBRITANNIEN"
And I create a new row at the end of the table
And I set field "Artikel" to "VKTeilGBP" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "Artikel" to "ANZ" in row 2
And I save the current editor
And I close the current editor

# Anzahlungsrechnung erfassen und buchen
Given I open an editor "VKRech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to "600001"
And I press button "bureabschluss"
Then field "vrgstrgl" has value "VKAUSFREI"
Then field "waehr" has value "GBP"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
Then the table has 1 rows
And I set field "pwert" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-23262.56" in row 1
And I set field "vom" to "10.02.23"
And I set field "budat" to "10.02.23"
And I set field "vdat" to "10.02.23"
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung erfassen und buchen
Given I open an editor "VKRech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "KLAUSGB"
Then field "zbed^such" has value "PROZ2"
Then field "vrgstrgl" has value "VKAUSFREI"
Then field "waehr" has value "GBP"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
And I create a new row at the end of the table
And I set field "artikel" to "VKTeilGBP" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-1" in row 1
And I set field "vom" to "10.02.23"
And I set field "budat" to "10.02.23"
And I set field "vdat" to "10.02.23"
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Geldtransitkonto für sonstige Zahlung anlegen
Given I open an editor "gtk" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "72011"
And I set field "such" to "GTK"
And I set field "namebspr" to "Geldtransitkonto"
And I set field "karta" to "Geldtransitkonto"
And I set field "oprel" to "ja"
And I set field "zaform" to "Sonstige"
And I save the current editor
And I close the current editor

# OP umbuchen
Given I open an editor "umbuch" from table "(OIProcessing):(OtherPayments)" with command "NEW" for record ""
And I set field "zaeinaus" to "Zahlungseingang"
And I set field "gkonto" to "72011"
And I set field "beleg" to "1510"
And I set field "beldat" to "10.02.23"
And I set field "kbudat" to "10.02.23"
And I create a new row at the end of the table
And I set field "konto" to "k klausgb" in row 1
And I press button "topladen" in row 1
Then the table has 2 rows
And I press button "tueber" in row 1
Then field "opzabetr" has value "22797.31" in row 1
Then field "kursdiff" has value "-0.01" in row 1
Then field "ziwbu" has value "EUR" in row 1
Then field "sumkursdiff" has value "-0.01" in row 0
Then field "kokursdiff" has value "-0.01" in row 0
And I set field "skstelle" to "100" in row 1
And I set field "kursdiffkst" to "100" in row 1
And I press button "tueber" in row 2
Then field "opzabetr" has value "22797.31" in row 2
Then field "kursdiff" has value "-0.01" in row 2
Then field "sumkursdiff" has value "-0.02" in row 0
Then field "kokursdiff" has value "-0.02" in row 0
And I set field "skstelle" to "100" in row 2
And I set field "kursdiffkst" to "100" in row 2
# 588 : Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario: OP verrechnen - OP-Währung ist Fremdwährung, Buchungswährung ist Inlandswährung

# Anfrage für Anzahlungsrechnung erfassen
Given I open an editor "anfr2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    |nummer|  600002|
    |vom   |10.02.23|
    |kunde | KLAUSGB|
Then field "vstaat" has value "GROSSBRITANNIEN"
And I create a new row at the end of the table
And I set field "Artikel" to "VKTeilGBP" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "Artikel" to "ANZ" in row 2
And I save the current editor
And I close the current editor

# Anzahlungsrechnung erfassen und buchen
Given I open an editor "VKRech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "600002"
And I press button "bureabschluss"
And I set field "vorganga" to "Anzahlung"
Then field "vrgstrgl" has value "VKAUSFREI"
Then field "waehr" has value "GBP"
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

# Finanzbuchung in für Lieferanten in Fremwährung erfassen -> OP für Verrechnung entsteht
Given I open an editor "fibu" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "erfwaehr" to "GBP"
Then field "iwbu" has value "EUR"
Then field "ewekurs" has value "1.150298"
And I set field "beldat" to "10.02.23"
And I set field "budat" to "10.02.23"
And I append rows
|    konto| ewsbetr| ewhbetr|
|k klausgb|    0,00|23262,56|
|    18100|23262,56|    0,00|
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
|    konto|ewsbetr|ewhbetr|
|k klausgb| 535,18|   0,00|
|    16000|   0,00| 535,18|
# 1941 : Buchung o.k., Automatische Belegnummer?
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Verrechnungskonto anlegen
Given I open an editor "verrkto" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "18555"
And I set field "such" to "verrechkto"
And I set field "namebspr" to "Verrechnungskonto"
And I set field "karta" to "Verrechnungskonto"
And I save the current editor
And I close the current editor

# OPs verrechnen 
Given I open an editor "verrech" from table "(OIProcessing):(SettleOutstandingItems)" with command "NEW" for record ""
And I set field "verrkonto" to "18555"
And I set field "beleg" to "400050"
And I set field "beldat" to "10.02.23"
And I set field "kbudat" to "10.02.23"
And I set field "kwaehr" to "GBP"
And I create a new row at the end of the table
And I set field "konto" to "k klausgb" in row 1
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
Then field "sumkursdiff" has value "-0.01" in row 0
Then field "subudm" has value "0.01" in row 0
Then field "kozabetr" has value "0.00" in row 0
And I set field "skstelle" to "100" in row 1
And I set field "kursdiffkst" to "100" in row 1
# 588 : Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario Outline: OPs ausbuchen

# Auftrag für Anzahlungsrechnung erfassen
Given I open an editor "auftr<nr>" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    |nummer|<beleg>|
    |vom   |  <vom>|
    |kunde | <kunde>|
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
Given I open an editor "VKRech<nr>" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to "<beleg>"
And I press button "bureabschluss" in row 0
Then field "vrgstrgl" has value "<vrgstrgl>"
Then field "waehr" has value "<waehr>"
Then field "ewekurs" has value "<ewekurs1>"
Then field "iwbu" has value "EUR"
Then the table has 1 rows
And I set field "pwert" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-23262.56" in row 1
And I set field "vom" to "<vom>"
And I set field "vdat" to "<vom>"
And I set field "budat" to "<vom>"
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung erzeugen und buchen 
Given I open an editor "VKRech<nr>" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "<kunde>"
Then field "zbed^such" has value "PROZ2"
Then field "vrgstrgl" has value "<vrgstrgl>"
Then field "waehr" has value "<waehr>"
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
And I set field "intrarel" to "nein" in row 1
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


Given I open an editor "opausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "nummer" to "161"
And I set field "gkonto" to "18100"
And I set field "kwaehr" to "<kwaehr>"
And I set field "beldat" to "10.02.23"
And I set field "kbudat" to "10.02.23"
And I set field "beleg" to "400050"
And I create a new row at the end of the table
And I set field "konto" to "k <kunde>" in row 1
And I press button "topladen" in row 1
Then the table has 2 rows
And I set field "gkowaehr" to "EUR" in row 0
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

|nr| beleg|     vom|   kunde| vrgstrgl|     vstaat|  artikel|waehr|ewekurs1|ewekurs2|ausbudat|kwaehr|  ofbetr|opzabetr|kursdiff|sumkursdiff|kokursdiff|koasaldo|kursdiffr2|kokursdiff2|sumkursdiff2|
| 1|200001|10.02.23|   KLAUS|VKAUSFREI|        USA|VKTeilUSD|  USD|1.150298|1.150298|10.02.23|   USD|23262.56|22797.31|   -0.01|      -0.01|      0.00|    0.00|     -0.01|       0.00|       -0.02|
| 2|200002|21.03.22|   KLAUS|VKAUSFREI|        USA|VKTeilUSD|  USD|1.150298|1.000000|10.02.23|   USD|23262.56|22797.31|   -0.01|      -0.01|      0.00|    0.00|  -3496.32|       0.00|    -3496.33|
| 3|200003|10.02.23| KLAUSSE| VKEUFREI|   SCHWEDEN|VKTeilSEK|  SEK|1.100000|1.100000|10.02.23|   DKK|26758.86|26223.68|    0.01|       0.01|      0.00|    0.01|      0.01|       0.00|        0.02|
| 4|200004|10.02.23| KLAUSDE|     VKIN|DEUTSCHLAND|VKTeilEUR|  EUR|1.000000|0.869340|10.02.23|   CHF|26758.87|26223.69|    0.01|       0.01|      0.00|    0.01|      0.01|       0.00|        0.02|

# 1) OP ausbuchen - erfassen Fremdwährung, buchen Inlandswährung
# 2) OP erstellen in Fremdwährung, Zahlung in gleicher Fremdwährung mit verändertem Kursdifferenzen
# 3) OP erstellen in Fremdwährung, zahlen in anderer Fremdwährung
# 4) OP in Inlandswährung erstellen, in Fremdwährung ausbuchen

Scenario: OPs überbezahlen

# Auftrag für Anzahlungsrechnung erfassen
Given I open an editor "opuebbest" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    |nummer|200005-1|
    |vom   |10.02.23|
    |kunde |KLAUSUEB|
Then field "vstaat" has value "USA"
Then field "ewekurs" has value "1.150298" in row 0
And I create a new row at the end of the table
And I set field "Artikel" to "VKTeilUSD" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "Artikel" to "ANZ" in row 2
And I save the current editor
And I close the current editor

# Anzahlungsrechnungen erzeugen und buchen
Given I open an editor "EKRech5" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to "200005-1"
And I press button "bureabschluss" in row 0
Then field "vrgstrgl" has value "VKAUSFREI"
Then field "waehr" has value "USD"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
Then the table has 1 rows
And I set field "pwert" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-23262.56" in row 1
And I set field "vom" to "10.02.23"
And I set field "vdat" to "10.02.23"
And I set field "budat" to "10.02.23"
And I set field "ueb" to "ja" in row 0
# 4841 : Rechnungsabschlusspositionen wurden ergänzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung erzeugen und buchen 
Given I open an editor "EKRech5" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "KLAUSUEB"
Then field "zbed^such" has value "PROZ2"
Then field "vrgstrgl" has value "VKAUSFREI"
Then field "waehr" has value "USD"
Then field "ewekurs" has value "1.150298"
Then field "iwbu" has value "EUR"
And I create a new row at the end of the table
And I set field "artikel" to "VKTeilUSD" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "23262,56" in row 1
Then field "pwert" has value "23262.56" in row 1
Then field "ofmge" has value "-1" in row 1
And I set field "vom" to "10.02.23" in row 0
And I set field "vdat" to "10.02.23" in row 0
And I set field "budat" to "10.02.23" in row 0
And I set field "ueb" to "ja" in row 0
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
And I set field "konto" to "k klausueb" in row 1
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
Then field "kokursdiff" has value "-0.01" in row 0
Then field "sumkursdiff" has value "-0.01" in row 0
And I set field "kursdiffkst" to "100" in row 1
Then field "ofbetr" has value "23262.56" in row 2
And I set field "opzabetr" to "200000" in row 2
Then field "ofbetr" has value "-180819.07" in row 2
Then field "skbetr" has value "4081.63" in row 2
And I set field "skstelle" to "100" in row 2
Then field "kursdiff" has value "-0.01" in row 2
Then field "kokursdiff" has value "-0.02" in row 0
Then field "sumkursdiff" has value "-0.02" in row 0
And I set field "kursdiffkst" to "100" in row 2
# 4056 : Überzahlung der Anzahlungsanforderung nicht erlaubt
Then saving the current editor throws the exception "4056"
And I delete row at position 1
And I set field "gkowaehr" to "EUR" in row 0
And I set field "kowaehr" to "EUR" in row 0
Then field "kokursdiff" has value "-0.01" in row 0
Then field "sumkursdiff" has value "-0.01" in row 0
# 588 : Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor
