# *****************************************************************************
#  Name             : kasb_kasbfw_001.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : ersetzt kasbfw_edp1.txt, kasbfw_edp2.txt,kasbfw_edp3.txt
#                     und kasbfw_edp4.txt in ref_kasbfw
# *****************************************************************************

Feature: kasb_kasbfw_001
Background: kasbfw
Scenario: kasbfw1

# #######################################kasbfw1################################################################################################

# getestet wird hier:
# - Anlage von 2 Kassenkonten mit 2ter Kontow�„hrung
# - Neuanlage mit diverses Plausis bezogen auf das Eintragen einer W�„hrung
# - Anlage eines Fremdw�„hrungskassenbuches K16001/02/01/01
# - Verbuchen eines Fremdw�„hrungskassenbuches
# - Anlegen eines neuen Fremdw�„hrungskassenbuch
# - Moab 01/2002 => scheitert
# - Kassenbuch verbuchen
# - Moab 01/2002 => funktioniert
#

# ###############################################

Scenario Outline: kasbfw1 Waehrungskurse USD erzeugen

Given I'm logged in with password "sy"
Given I open an editor "usd" from table "(ExchangeRate)" with command "NEW" for record ""
And I set field "kursdat" to "<kursdat>"
And I set field "fwaehr" to "USD"
And I set field "fkurs" to "<fkurs>"
And I set field "faktfeinh" to "10"
And I save the current editor
And I close the current editor

Examples:

| kursdat|  fkurs|
|20020101| 1.0101|
|20020102| 1.0102|
|20020103| 1.0103|
|20020104| 1.0104|
|20020105| 1.0105|
|20020106| 1.0106|
|20020107| 1.0107|
|20020108| 1.0108|
|20020109| 1.0109|
|20020110| 1.0110|
|20020215|0.95330|

# ###################################################

Scenario Outline: kasbfw1 Konten

Given I open an editor "" from table "(Account):(Account)" with command "COPY" for record "16000"
And I set field "nummer" to "<nummer>"
And I set field "w2ist" to "<w2ist>"
And I set field "w2gjahr" to "<w2gjahr>"
And I save the current editor
And I close the current editor

Examples:

|nummer|w2ist|w2gjahr|
| 16001|  USD|     02|
| 16002|  USD|     03|
| 16003|  TRL|     02|

# ###################################################

Scenario: kasfw1

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Given I'm logged in with password "sy"
And I set field "kasskto" to ""
And I set field "gj" to "02"
And I set field "gm" to "01"
And I set field "waehr" to "EUR"
And I set field "such" to ""
# 204  (Obj#3): Buchungskonto fehlt: kasskto
# 10179 : bitte eintragen
Then saving the current editor throws the exception "10179"
And I close the current editor

# FEHLER 814 (Obj#14[16000]:kasbfw_edp1.txt:61): Gesch�ftsmonat in diesem Gesch�ftsjahr nicht bebuchbar: gj
# FEHLER (Obj#14[16000]:kasbfw_edp1.txt:61): Ungültiger Feldwert: gj=01
# FEHLER 8820 (Obj#14[16000]:kasbfw_edp1.txt:61): Nur Inlandswährung oder zweite Kontowährung des Kassenkontos gültig.: waehr
# FEHLER (Obj#14[16000]:kasbfw_edp1.txt:61): Ungültiger Feldwert: waehr=USD
# FEHLER 46 (Obj#14[16000]:kasbfw_edp1.txt:61): Bitte Suchwort eintragen: such98,such,suchb
# FEHLER (Obj#14[16000]:kasbfw_edp1.txt:61): Daten wegen Fehler(n) nicht gespeichert

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Given I'm logged in with password "sy"
And I set field "kasskto" to "16000"
Then setting field "gj" to "01" throws the exception "814"
And I set field "gm" to "01"
Then setting field "waehr" to "USD" throws the exception "8820"
And I set field "such" to ""
# 10179 : bitte eintragen
Then saving the current editor throws the exception "10179"
And I close the current editor

# FEHLER 8820 (Obj#15[16002]:kasbfw_edp1.txt:68): Nur Inlandswährung oder zweite Kontowährung des Kassenkontos gültig.: waehr
# FEHLER (Obj#15[16002]:kasbfw_edp1.txt:68): Ungültiger Feldwert: waehr=USD
# FEHLER 46 (Obj#15[16002]:kasbfw_edp1.txt:68): Bitte Suchwort eintragen: such98,such,suchb
# FEHLER (Obj#15[16002]:kasbfw_edp1.txt:68): Daten wegen Fehler(n) nicht gespeichert

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Given I'm logged in with password "sy"
And I set field "kasskto" to "16002"
And I set field "gj" to "02"
And I set field "gm" to "01"
Then setting field "waehr" to "USD" throws the exception "8820"
And I set field "such" to ""
# 10179 : bitte eintragen
Then saving the current editor throws the exception "10179"
And I close the current editor

#       (Obj#6): Wird erfolgreich angelegt.

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Given I'm logged in with password "sy"
And I set field "kasskto" to "16002"
And I set field "gj" to "03"
And I set field "gm" to "01"
And I set field "waehr" to "USD"
And I set field "such" to "K16002"
And I save the current editor
And I close the current editor

# FEHLER 8822 (Obj#17[16002]:kasbfw_edp1.txt:75): Zu diesem Kassenkonto existiert ein Kassenbuch in Fremdwährung.: waehr
# FEHLER (Obj#17[16002]:kasbfw_edp1.txt:75): Ungültiger Feldwert: waehr=EUR
# FEHLER 8822 (Obj#17[16002]:kasbfw_edp1.txt:75): Zu diesem Kassenkonto existiert ein Kassenbuch in Fremdwährung.: waehr
# FEHLER (Obj#17[16002]:kasbfw_edp1.txt:75): Daten wegen Fehler(n) nicht gespeichert

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Given I'm logged in with password "sy"
And I set field "kasskto" to "16002"
And I set field "gj" to "02"
And I set field "gm" to "01"
Then setting field "waehr" to "EUR" throws the exception "8822"
And I set field "such" to ""
Then saving the current editor throws the exception "10179"
And I close the current editor

# FEHLER 8820 (Obj#18[16001]:kasbfw_edp1.txt:79): Nur Inlandswährung oder zweite Kontowährung des Kassenkontos gültig.: waehr
# FEHLER (Obj#18[16001]:kasbfw_edp1.txt:79): Ungültiger Feldwert: waehr=TRL
# FEHLER 46 (Obj#18[16001]:kasbfw_edp1.txt:79): Bitte Suchwort eintragen: such98,such,suchb
# FEHLER (Obj#18[16001]:kasbfw_edp1.txt:79): Daten wegen Fehler(n) nicht gespeichert

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Given I'm logged in with password "sy"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "01"
Then setting field "waehr" to "TRL" throws the exception "8820"
And I set field "such" to ""
Then saving the current editor throws the exception "10179"
And I close the current editor

#       (Obj#9): Wird erfolgreich angelegt.

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Given I'm logged in with password "sy"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "01"
And I set field "waehr" to "USD"
And I set field "such" to "K16001/02/01/01"
And I save the current editor
And I close the current editor

# (#1) Kassenbuch vollst�ndigen: anfangsbestand, kontieren, betr�ge, kurztexte und buchungstext 
#     eintragen und speichern

# ##############################################

Scenario Outline: kasbfw1 Kassenbuch1

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/01/01"
And I set field "anfbest" to "<anfbest>"
And I create a new row at the end of the table
And I set field "beldat" to "<beldat>" in row !lastRow
And I set field "gegenkto" to "<gegenkto>" in row !lastRow
And I set field "kstelle" to "<kstelle>" in row !lastRow
And I set field "beinn" to "<beinn>" in row !lastRow
And I set field "bausg" to "<bausg>" in row !lastRow
And I save the current editor
And I close the current editor

Examples:

|    anfbest|     beldat|   gegenkto|    kstelle|      beinn|      bausg|
|       5.33|   01.01.02|      44000|        100|        111|!dontChange|
|       5.33|   02.01.02|      54000|        100|       9.87|      33.42|

Scenario: kasbfw1

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/01/01"
# (#4) erfolgreiche Freigabe
And I press button "allefr"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "K16001/02/01/01"
# (#5) erfolgreiche Buchung
And I save the current editor
And I close the current editor

# ##############################################

Given I'm logged in with password "annette"
Given I open an editor "acc-16001" from table "(Account):(Account)" with command "UPDATE" for record "16001"
And I set field "w2ist" to "TRL"
And I save the current editor
And I close the current editor

# ###############################################

Scenario Outline: kasbfw1 Kassenbuch2

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "<waehr>"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "01"
And I set field "such" to "K16001/02/01/02"
# 8821: Kassenbuch in Fremdwährung: Es existiert ein Kassenbuch zu diesem Konto mit abweichender W�hrung.
Then saving the current editor throws the exception "8821"
And I close the current editor

Examples:

|waehr|
# Nur Inlandswährung oder zweite Kontowährung des Kassenkontos gültig: waehr
# FEHLER 8821 (Obj#24[USD]:kasbfw_edp1.txt:120): Kassenbuch in Fremdwährung: Es existiert ein Kassenbuch zu diesem Konto mit abweichender W�hrung.: waehr
# FEHLER (Obj#24[USD]:kasbfw_edp1.txt:120): Daten wegen Fehler(n) nicht gespeichert
|  USD|
# Kassenbuch in Fremdwährung: Es existiert ein Kassenbuch zu diesem Konto mit abweichender W�hrung.
# FEHLER 8821 (Obj#25[TRL]:kasbfw_edp1.txt:122): Kassenbuch in Fremdwährung: Es existiert ein Kassenbuch zu diesem Konto mit abweichender W�hrung.: waehr
# FEHLER (Obj#25[TRL]:kasbfw_edp1.txt:122): Daten wegen Fehler(n) nicht gespeichert
|  TRL|

# ###############################################

Scenario: kasbfw1

Given I'm logged in with password "annette"
Given I open an editor "acc-16001" from table "(Account):(Account)" with command "UPDATE" for record "16001"
And I set field "w2ist" to "USD"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "USD"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "01"
And I set field "such" to "K16001/02/01/02"
And I save the current editor
And I close the current editor

# (#1) Kassenbuch vollst�ndigen: anfangsbestand, kontieren, betr�ge, kurztexte und buchungstext 
#     eintragen und speichern

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/01/02"
And I create a new row at the end of the table
And I set field "beldat" to "03.01.02" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "111,03" in row !lastRow
And I press button "sanpass" in row !lastRow
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/01/02"
And I create a new row at the end of the table
And I set field "beldat" to "04.01.02" in row !lastRow
And I set field "gegenkto" to "54000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "9.88" in row !lastRow
And I set field "bausg" to "33.42" in row !lastRow
And I save the current editor
And I close the current editor

# Monatsabschluss für Januar 2002 geht jetzt nicht. 

Given I open an editor "abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "nummer" to "200"
And I set field "such" to "ABSCHL"
And I press button "fbbbu" in row 4
# 2743: Vorgang abgebrochen
Then saving the current editor throws the exception "2743"
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/01/02"
# (#4) erfolgreiche Freigabe
And I press button "allefr"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "K16001/02/01/02"
# (#5) erfolgreiche Buchung
And I save the current editor 
And I close the current editor

# Monatsabschluss für Januar 2002 geht jetzt. Dazu aber das Datum auf 1. Febr. 2002 setzen
Given I set the fake date to "1.2.02"
Given I open an editor "abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "nummer" to "200"
And I set field "such" to "ABSCHL"
And I press button "fbbbu" in row 4
# 7626: Aktion wirklich durchf�hren?
And I respond with answer "ja" to the dialog with id "7626"
And I save the current editor
And I close the current editor

# #######################################kasbfw2################################################################################################

# Test der Korrekturzeilenermittlung bei einem Kassenbuch in Fremdwaehrung
# - Kassenkonto in Fremdwaehrung fuer 16001, 02/2002 angelegt
# - USD-Rechnung fuer Februar eingebucht
# - Euro-Rechnung fuer Februar eingebucht
# - USD-Rechnung bezahlt => Korrekturzeile nach 16001
# - Euro-Rechnung bezahlt => keine Korrekturzeile nach 16001
# - Barrechnungen erzeugt fuer Kassenkonto 16001
#   1) in Euro => keine Korrekturzeile
#   2) in USD  => Korrekturzeile
# - Personenkontozeile 

Scenario: kasbfw2

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "USD"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "02"
And I set field "such" to "K16001/02/02/01"
And I save the current editor
And I close the current editor

####################################################

Scenario Outline: kasbfw2 Rechnung erzeugen

Given I open an editor "" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "kunde" to "1"
And I set field "vom" to "20020201"
And I set field "budat" to "20020201"
And I set field "kterm" to "20020201"
And I set field "land" to "<land>"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "pnum" to "1" in row <row>
And I set field "artex" to "E1" in row <row>
And I set field "mge" to "1" in row <row>
And I set field "preis" to "<preis>" in row <row>
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples: 

|nummer|land| preis|row|
|20010A| USD|100.00|  1|
|20010B| EUR|200.00|  1|

# ####################################################

Scenario Outline: kasbfw2 Offene Posten ausbuchen

Given I open an editor "OI" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "kbudat" to "20020201"
And I set field "beleg" to "<beleg>"
And I set field "gkonto" to "16001"
And I set field "beldat" to "20020201"
And I set field "zasammelart" to "Sammelbuchungen"
And I set field "zagr" to "1"
And I set field "opausgleich" to "ja"
And I set field "sbeleg" to "<sbeleg>"
And I press button "opladen"
# 588: Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Examples:

|beleg|sbeleg|
|ZAFW1|20010A|
|ZAFW2|20010B|

# ####################################################

Scenario Outline: kasbfw2 Barrechnungen erzeugen

Given I open an editor "inv" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "kunde" to "1"
And I set field "kterm" to "3.2.02"
And I set field "term" to "3.2.02"
And I set field "tterm" to "3.2.02"
And I set field "mterm" to "false"
And I set field "vom" to "<vom>"
And I set field "budat" to "<budat>"
And I set field "land" to "<land>"
And I set field "vorganga" to "Barzahlung"
And I set field "kasskto" to "16001"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "<artex>" in row <row>
And I set field "mge" to "<mge>" in row <row>
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples:

|nummer|   vom| budat|land|artex|row|mge|
|2002B1|6.2.02|7.2.02| EUR|   V1|1  | 10|
|2002B2|3.2.02|3.2.02| USD|   V2|1  |  3|
|2002B3|6.2.02|5.2.02| USD|   V3|1  |  1|

# ####################################################

# Kassenkontozeile mit Personenkonto eintragen
# (#1) Kassenbuch vollstaendigen: anfangsbestand, kontieren, betraege, kurztexte und buchungstext 
#     eintragen und speichern

Scenario: kasbfw2

Given I'm logged in with password "sy"
Given I open an editor "kasb-4" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/02/01"
And I set field "anfbest" to "5.33"
And I set field "beldat" to "09.02.02" in row 2
And I set field "gegenkto" to "K 001" in row 2
# 203 : Eintrag ist schreibgesch�tzt
Then setting field "tewekurs" to "1.0" in row 2 throws the exception "203"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-4" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/02/01"
And I set field "anfbest" to "5.33"
And I set field "beldat" to "09.02.02" in row 2
And I set field "gegenkto" to "K 001" in row 2
# 203 : Eintrag ist schreibgesch�tzt
Then setting field "teikurs" to "1.0" in row 2 throws the exception "203"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-4" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/02/01"
And I set field "anfbest" to "5.33"
And I create a new row at the end of the table
And I set field "beldat" to "08.02.02" in row !lastRow
And I set field "gegenkto" to "K 001" in row !lastRow
And I set field "beinn" to "111" in row !lastRow
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-4" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/02/01"
And I set field "anfbest" to "5.33"
And I create a new row at the end of the table
And I set field "beldat" to "09.02.02" in row !lastRow
And I set field "gegenkto" to "K 001" in row !lastRow
And I set field "beinn" to "9.87" in row !lastRow
And I set field "bausg" to "33.42" in row !lastRow
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-4" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/02/01"
# (#4) erfolgreiche Freigabe
And I press button "allefr"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-4" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "K16001/02/02/01"
# (#5) erfolgreiche Buchung
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-4" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "USD"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "03"
And I set field "such" to "K16001/02/03/01"
And I save the current editor
And I close the current editor

# Kassenkontozeile mit nicht aufgeloester Rundungsdifferenz
# (#1) Kassenbuch vollstaendigen: anfangsbestand, kontieren, betraege, kurztexte und buchungstext 
#     eintragen und speichern

Given I'm logged in with password "sy"
Given I open an editor "kasb-5" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/01"
And I create a new row at the end of the table
And I set field "beldat" to "15.03.02" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "696,18" in row !lastRow
# 6245 : Rundungsdifferenz muss 0 sein
Then saving the current editor throws the exception "6245"
And I close the current editor

# Kassenkontozeile Rundungsdifferenzzeilen
# (#1) Kassenbuch vollstaendigen: anfangsbestand, kontieren, betraege, kurztexte und buchungstext 
#     eintragen und speichern

Given I'm logged in with password "sy"
Given I open an editor "kasb-6" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/01"
And I create a new row at the end of the table
And I set field "beldat" to "1.03.02" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "696,01" in row !lastRow
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-6" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/01"
# (#4) erfolgreiche Freigabe 
And I press button "allefr"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-6" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "K16001/02/03/01"
# (#5) erfolgreiche Buchung 
And I save the current editor
And I close the current editor

# #######################################kasbfw3################################################################################################

Scenario: kasbfw3

# Kurse in Kassenbuchzeilen ändern

Given I'm logged in with password "sy"
Given I open an editor "kasb-7" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "USD"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "03"
And I set field "such" to "K16001/02/03/02"
And I save the current editor
And I close the current editor

# ####################################################

Scenario Outline: kasbfw3 Kassenkontozeile mit Kursangabe

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/02"
And I create a new row at the end of the table
And I set field "beldat" to "<beldat>" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "696,01" in row !lastRow
And I set field "tewekurs" to "<tewekurs>" in row !lastRow
And I save the current editor
And I close the current editor

Examples:

| beldat|tewekurs|
|1.03.02|     9,1|
|2.03.02|     9,2|
|3.03.02|     9,3|

# ####################################################

Scenario: kasbfw3

#  Kursfixierh�cken bei einer Zeile entfernt: es gilt nun wieder der Buchungsdatumskurs

Given I'm logged in with password "sy"
Given I open an editor "kasb-8" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/02"
And I set field "tkursfix" to "nein" in row 2
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-8" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/02"
# (#4) erfolgreiche Freigabe
And I press button "allefr"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb-8" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "K16001/02/03/02"
# (#5) erfolgreiche Buchung
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "USD"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "03"
And I set field "such" to "K16001/02/03/03"
And I save the current editor
And I close the current editor

# Kassenkontozeile mit Splitzeilen und Kursangabe
# 1. erste Zeile eintragen
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
And I create a new row at the end of the table
And I set field "beleg" to "1" in row !lastRow
And I set field "beldat" to "4.03.02" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "696,01" in row !lastRow
And I set field "tewekurs" to "9,0" in row !lastRow
And I save the current editor
And I close the current editor

# Kassenkontozeile mit Splitzeilen und Kursangabe
# 2. Splitzeile eintragen + Beldat => Fehlermeldung
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
And I create a new row at the end of the table
And I set field "beleg" to "1" in row !lastRow
# 8498 : Feld darf nur in der ersten Splittbuchungszeile geändert werden.
Then setting field "beldat" to "4.03.02" in row !lastRow throws the exception "8498"
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "100,00" in row !lastRow
And I save the current editor
And I close the current editor

# Kassenkontozeile mit Splitzeilen und Kursangabe
# 3. Splitzeile eintragen + tewekurs => Fehlermeldung
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
And I create a new row at the end of the table
And I set field "beleg" to "1" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "100,00" in row !lastRow
# 8498 : Feld darf nur in der ersten Splittbuchungszeile geändert werden.
Then setting field "tewekurs" to "9,1" in row !lastRow throws the exception "8498"
And I save the current editor
And I close the current editor

# Kassenkontozeile mit Splitzeilen und Kursangabe
# 4. Splitzeile eintragen + teikurs => Fehlermeldung
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
And I create a new row at the end of the table
And I set field "beleg" to "1" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "100,00" in row !lastRow
# 8498 : Feld darf nur in der ersten Splittbuchungszeile geändert werden.
Then setting field "teikurs" to "9,1" in row !lastRow throws the exception "8498"
And I save the current editor
And I close the current editor

# Kassenkontozeile mit Splitzeilen und Kursangabe
# 5. Splitzeile eintragen ohne Kurs etc. => ok
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
And I create a new row at the end of the table
And I set field "beleg" to "1" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "100,00" in row !lastRow
And I save the current editor
And I close the current editor

# Kassenkontozeile mit Splitzeilen und Kursangabe
# 6. Normale Zeile eintragen
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
And I create a new row at the end of the table
And I set field "beleg" to "5" in row !lastRow
And I set field "beldat" to "6.03.02" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "100,00" in row !lastRow
And I save the current editor
And I close the current editor

# Kassenkontozeile mit Splitzeilen und Kursangabe
# 7. Splitbuchung "teilen" => Fehlermeldung
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
And I set field "beleg" to "4" in row 3
And I set field "gegenkto" to "44000" in row 3
And I set field "kstelle" to "100" in row 3
And I set field "beinn" to "100,00" in row 3
# 5793 : Unsinnige Belegnummernfolge wie z.B: 2,3,4,2,5,6 - die 2 darf nicht getrennt erscheinen
Then saving the current editor throws the exception "5793"
And I close the current editor

# Kassenkontozeile mit Splitzeilen und Kursangabe
# 8. Buchungsdatum der ersten Splitzeile ändern, �ndert die anderen Splittzeilen mit
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
And I set field "budat" to "5.03.02" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16001/02/03/03"
# (#4) erfolgreiche Freigabe
And I press button "allefr"
And I save the current editor
And I close the current editor

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "K16001/02/03/03"
# (#5) erfolgreiche Buchung
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "TRL"
And I set field "kasskto" to "16003"
And I set field "gj" to "02"
And I set field "gm" to "03"
And I set field "such" to "K16003/02/03/01"
And I save the current editor
And I close the current editor

# ####################################################

Scenario Outline: kasbfw3 Kassenkontozeile mit geaendertem teikurs

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16003/02/03/01"
And I create a new row at the end of the table
And I set field "beleg" to "<beleg>" in row !lastRow
And I set field "beldat" to "1.3.02" in row !lastRow
And I set field "gegenkto" to "44000" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "beinn" to "100000,00" in row !lastRow
And I set field "teikurs" to "<teikurs>" in row !lastRow
And I set field "tewekurs" to "<tewekurs>" in row !lastRow
And I save the current editor
And I close the current editor

Examples:

|beleg|    teikurs|   tewekurs|
|    1|!dontChange|!dontChange|
|    2|     0,0009|!dontChange|
|    3|!dontChange|     0,0009|

# ####################################################

Scenario: kasbfw3

# Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for record "K16003/02/03/01"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "UPDATE" for search criteria "$,,such==K16003/02/03/01;@maxordtreffer=1;@ordnung=nummer;@richtung=rueckwaerts"
# (#4) erfolgreiche Freigabe
And I press button "allefr"
And I save the current editor
And I close the current editor


Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "K16003/02/03/01"
# (#5) erfolgreiche Buchung
And I save the current editor
And I close the current editor

# #######################################kasbfw4################################################################################################

# getestet wird hier der Umgang mit dem Standardkassenbuch bei der Rechnung

Scenario Outline: kasbfw4 Konten 

Given I'm logged in with password "sy"
Given I open an editor "acc" from table "(Account):(Account)" with command "COPY" for record "16000"
And I set field "nummer" to "<nummer>"
And I set field "w2ist" to "<w2ist>"
And I set field "w2gjahr" to "<w2gjahr>"
And I save the current editor
And I close the current editor

Examples:

|nummer|      w2ist|    w2gjahr|
| 16004|!dontChange|!dontChange|
| 16005|        USD|         02|

# ####################################################

# 1ter Versuch: Barrechnungen werden erzeugt.
# Es gibt für Monat 04/02 keine offenen Kassenbücher.
# Daher wird das Standardkassenkonto in der Buchung verwendet.
# Korrekturzeilen entstehen nicht.

Scenario Outline: kasbfw4 Invoice

Given I open an editor "inv" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "kunde" to "1"
And I set field "kterm" to "03.04.02"
And I set field "term" to "03.04.02"
And I set field "tterm" to "03.04.02"
And I set field "mterm" to "false"
And I set field "vom" to "03.04.02"
And I set field "budat" to "03.04.02"
And I set field "land" to "<land>"
And I set field "vorganga" to "Barzahlung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "<artex>" in row <row>
And I set field "mge" to "<mge>" in row <row>
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples:

| nummer|land|artex|row|mge|
|2002B11| EUR|   V1|  1| 10|
|2002B12| USD|   V2|  1|  3|
|2002B13| PLZ|   V3|  1|  1|

# ####################################################

Scenario: kasbfw4

# Nun Kassenbücher anlegen: erstmal für das Standardkassenkonto

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "EUR"
And I set field "kasskto" to "16000"
And I set field "gj" to "02"
And I set field "gm" to "04"
And I set field "such" to "K16000/02/04/01"
And I save the current editor
And I close the current editor

# ####################################################

# 2ter Versuch: Barrechnungen werden erzeugt.
# Es gibt für Monat 04/02 nur 1 offenes Kassenbuch (zu 16000).
# 16000 wird daher in der Buchung verwendet.
# Korrekturzeilen entstehen nur für die Euro-Barrechnung.

Scenario Outline: kasbfw4 Invoice 2

Given I open an editor "inv" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "kunde" to "1"
And I set field "kterm" to "03.04.02"
And I set field "term" to "03.04.02"
And I set field "tterm" to "03.04.02"
And I set field "mterm" to "false"
And I set field "vom" to "03.04.02"
And I set field "budat" to "03.04.02"
And I set field "land" to "<land>"
And I set field "vorganga" to "Barzahlung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "<artex>" in row <row>
And I set field "mge" to "<mge>" in row <row>
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples:

| nummer|land|artex|row|mge|
|2002B21| EUR|   V1|  1| 10|
|2002B22| USD|   V2|  1|  3|
|2002B23| PLZ|   V3|  1|  1|


# ####################################################

Scenario: kasbfw4

# Nun Kassenbücher anlegen: nun auch für das USD-Kassenkonto

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "USD"
And I set field "kasskto" to "16001"
And I set field "gj" to "02"
And I set field "gm" to "04"
And I set field "such" to "K16001/02/04/01"
And I save the current editor
And I close the current editor

# ####################################################

# 3ter Versuch: Barrechnungen werden erzeugt.
# Es gibt für Monat 04/02 offene Kassenbücher zu 16000 und 16001
# 16000 wird beim Buchen der PLN- und der EUR-Rechnung verwendet
# 16001 wird beim Buchen der USD-Rechnung verwendet.
# Korrekturzeilen entstehen:
# 16000 für die EUR-Rechnung
# 16001 für die USD-Rechnung

Scenario Outline: kasbfw4 Invoice 3

Given I open an editor "inv" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "kunde" to "1"
And I set field "kterm" to "03.04.02"
And I set field "term" to "03.04.02"
And I set field "tterm" to "03.04.02"
And I set field "mterm" to "false"
And I set field "vom" to "03.04.02"
And I set field "budat" to "03.04.02"
And I set field "land" to "<land>"
And I set field "vorganga" to "Barzahlung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "<artex>" in row <row>
And I set field "mge" to "<mge>" in row <row>
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples:

| nummer|land|artex|row|mge|
|2002B31| EUR|   V1|  1| 10|
|2002B32| USD|   V2|  1|  3|
|2002B33| PLZ|   V3|  1|  1|


# ####################################################

# Nun Kassenbücher anlegen für die neuen Konten von oben (16004 und 16005)

Scenario Outline: kasbfw4 Kassenbuecher

Given I'm logged in with password "sy"
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "<waehr>"
And I set field "kasskto" to "<kasskto>"
And I set field "gj" to "02"
And I set field "gm" to "04"
And I set field "such" to "<such>"
And I save the current editor
And I close the current editor

Examples:

|waehr|kasskto|           such|
|  EUR|  16004|K16004/02/04/01|
|  USD|  16005|K16005/02/04/01|

# ####################################################

# 4ter Versuch: Barrechnungen werden erzeugt.
# Es gibt für Monat 04/02 je 2 offene Kassenbücher zu 16000 und 16001
# 16000 wird beim Buchen der PLN- -Rechnung verwendet (weil Standardkassenkonto)
# Beim Buchen der EUR-Rechnung und der USD-Rechnung gibt es eine Fehlermeldung da es zwei m�gliche Kassenkonten mit 
# offenen Kassenbüchern gab, und keine Vorbelegung erfolgte.
# Korrekturzeilen entstehen nicht

# ####################################################

Scenario Outline: kasbfw4 Invoice 4

Given I open an editor "inv" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "kunde" to "1"
And I set field "kterm" to "03.04.02"
And I set field "term" to "03.04.02"
And I set field "tterm" to "03.04.02"
And I set field "mterm" to "false"
And I set field "vom" to "03.04.02"
And I set field "budat" to "03.04.02"
And I set field "land" to "<land>"
And I set field "vorganga" to "Barzahlung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "<artex>" in row <row>
And I set field "mge" to "<mge>" in row <row>
And I respond with answer "ja" to the dialog with id "4841"
# 279: Bitte eintragen
Then saving the current editor throws the exception "279"
And I close the current editor

Examples:

| nummer|land|artex|row|mge|
|2002B41| EUR|   V1|  1| 10|
|2002B42| USD|   V2|  1|  3|

# # ####################################################

Scenario: kasbfw4 Invoice4_3

Given I open an editor "inv" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "2002B43"
And I set field "kunde" to "1"
And I set field "kterm" to "03.04.02"
And I set field "term" to "03.04.02"
And I set field "tterm" to "03.04.02"
And I set field "mterm" to "false"
And I set field "vom" to "03.04.02"
And I set field "budat" to "03.04.02"
And I set field "land" to "PLZ"
And I set field "vorganga" to "Barzahlung"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "V3" in row 1
And I set field "mge" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# 5ter Versuch: Barrechnungen wird erzeut und evkasskto eingetragen.
# dann wird dieses verwendet.
# Korrekturzeilen entstehen für B51, und B52

# ####################################################

Scenario Outline: kasbfw4 Invoice 5

Given I open an editor "inv" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "kunde" to "1"
And I set field "kterm" to "03.04.02"
And I set field "term" to "03.04.02"
And I set field "tterm" to "03.04.02"
And I set field "mterm" to "false"
And I set field "vom" to "03.04.02"
And I set field "budat" to "03.04.02"
And I set field "land" to "<land>"
And I set field "vorganga" to "Barzahlung"
And I set field "kasskto" to "<kasskto>"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "<artex>" in row <row>
And I set field "mge" to "<mge>" in row <row>
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples:

| nummer|land|kasskto|artex|row|mge|
|2002B51| EUR|  16000|   V1|  1| 10|
|2002B52| USD|  16001|   V2|  1|  3|
|2002B53| PLZ|  16002|   V3|  1|  1|

# ####################################################




