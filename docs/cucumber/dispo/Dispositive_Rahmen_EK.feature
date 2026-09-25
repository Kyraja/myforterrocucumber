@persistent
Feature: Dispositive_Rahmen_EK.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Dispositive_Rahmen_EK
#  Autor            : bschiga
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Dispositive Rahmenauftraege Einkauf
#  ref              : ref_dispo_rahmen_cu
#
# **********************************************************************************
## Stammdaten verwenden - Stammdaten_Dispositive_Rahmen.feature


Scenario: 01 Wertereihe bearbeiten, Bestellung und Lieferschein zum Rahmen, Lieferschein Storno, Bestellmenge reduzieren

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "EKRAHMEN1"
And I set fields
    | such     | EKRAHMEN1        |
    | namebspr | Einkauf Rahmen1  |
    | bsart    | Fremdbeschaffung |
    | dispoa   | bedarfsbezogen   |
    | lief     | LIEFER1          |
    | efrist   | 30               |
    | bfrist   | 30               |
    | epr      | 50               |
And I save the current editor

# Rahmenauftrag anlegen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I set field "such" to "RAHMEN_1"
And I append rows
    | artikel   | mge   | zraster | zgltvon  | zgltbis  | einplan |
    | EKRAHMEN1 | 12000 | MONAT1  | 01.02.95 | 31.01.96 | ja      |
And I save the current editor

Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 12 rows
Then table has values
    | bmge | bistmge | bmgeabweich | status        | fix  |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Wertereihe im Rahmenauftrag bearbeiten
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
And I set field "bmge" to "900" in row 1
Then field "status" has value "manuell" in row 1
And I set field "bmge" to "1200" in row 2
Then field "status" has value "manuell" in row 1
And I respond with answer "ja" to the dialog with id "Wertereihen von Rahmenauftrag"
# in der GUI bekommt man keine Fehlermeldung, der Subeditor bleibt offen
Then saving the current editor throws the exception "2743"
Then field "bmge" has value "900" in row 12
Then table has values
    | bmge | bistmge | bmgeabweich | status        | fix  |
    | 900  | 0       | 900         | manuell       | ja   |
    | 1200 | 0       | 1200        | manuell       | ja   |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 900  | 0       | 1000        | initialisiert | nein |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
And I set field "bmge" to "800" in row 1
Then field "status" has value "manuell" in row 1
And I set field "bmge" to "800" in row 2
Then field "status" has value "manuell" in row 2
And I set field "bmge" to "1400" in row 12
Then field "status" has value "manuell" in row 12
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

And I set the fake date to "06.02.1995"

# Plankarte enthält die Planzugänge, Vorgangsart ist Rahmenauftrag
## Identnummer von Lieferant kann anders sein, ggf. Spalte verw weglassen ###
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EKRAHMEN1"
And I press start
Then the table has 13 rows
Then table has values
    | zugang | verw | vart          | vkopf^id    | geschaeftspartner  |
    |        |      | Lager         | (0,0,0)     |                    |
    | 800    |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 800    |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1000   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
    | 1400   |      | Rahmenauftrag | !Rahmen1^id | Lieferant 1 Inland |
And I close the current editor

# Bestellung anlegen
Given I create a PurchaseOrder "bestell01" for Vendor "LIEFER1" with Product "EKRAHMEN1" and quantity "500"

Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "bestell01"
And I set field "wtterm" to "22.02.95" in row 1
And I save the current editor

# Wertereihe pruefen, bmgeabweich aendert sich erst nach Dispolauf
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 12 rows
Then table has values
    | bmge | bistmge | bmgeabweich | status  | fix |
    | 800  | 0       | 800         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

# Wertereihe pruefen, bmgeabweich
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 12 rows
Then table has values
    | bmge | bistmge | bmgeabweich | status  | fix |
    | 800  | 0       | 300         | manuell | ja  |
    | 800  | 0       | 800         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Bestellung liefern
And I deliver the PurchaseOrder "bestell01" with PackingSlip "LS-01"

# Wertereihe pruefen und Fortschrittszahl pruefen, Zeitraster nicht aenderbar
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
Then field "fzahl" has value "500" in row 1
Then field "zraster" is not modifiable in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich | status  | fix |
    | 800  | 500     | 300         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I set the fake date to "06.03.1995"

# Lieferschein stornieren
And I reverse the PurchasingPackingSlip "LS-01"

# Wertereihe pruefen und Fortschrittszahl pruefen, Zeitraster wieder aenderbar
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_1"
Then field "fzahl" has value "0" in row 1
Then field "zraster" is modifiable in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich | status  | fix |
    | 800  | 0       | 300         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Bestellmenge reduzieren
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "bestell01"
And I set field "mge" to "400" in row 1
And I set field "wtterm" to "08.03.95" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich | status  | fix |
    | 800  | 0       | 800         | manuell | ja  |
    | 800  | 0       | 400         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Bestellung mit Haken Rahmenauftrag ignorieren
Given I create a PurchaseOrder "BEST_IGN" for Vendor "LIEFER1" with Product "EKRAHMEN1" and quantity "5000"

Given I open an editor "bestell" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BEST_IGN"
And I set field "zignrahmen" to "ja" in row 1
And I save the current editor

# Bestellung fuer anderen Lieferant wird nicht beruecksichtigt im Rahmen
Given I create a PurchaseOrder "BEST_ABW" for Vendor "LIEFER2" with Product "EKRAHMEN1" and quantity "200"

And I run Scheduling

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
Then field "fzahl" has value "0" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich | status        | fix  |
    | 800  | 0       | 800         | manuell       | ja   |
    | 800  | 0       | 400         | manuell       | ja   |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1400 | 0       | 1400        | manuell       | ja   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I deliver the PurchaseOrder "BEST_IGN" with PackingSlip "LS-ign"

And I deliver the PurchaseOrder "BEST_ABW" with PackingSlip "LS-abw"

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
Then field "fzahl" has value "0" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich | status        | fix  |
    | 800  | 0       | 800         | manuell       | ja   |
    | 800  | 0       | 400         | manuell       | ja   |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1000 | 0       | 1000        | initialisiert | nein |
    | 1400 | 0       | 1400        | manuell       | ja   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Lieferschein und dann Ruecklieferung
And I deliver the PurchaseOrder "bestell01" with PackingSlip "LS-02"

And I run Scheduling

# Wertereihe pruefen und Fortschrittszahl pruefen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
Then field "fzahl" has value "400" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich | status  | fix |
    | 800  | 400     | 400         | manuell | ja  |
    | 800  | 0       | 800         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I set the fake date to "05.04.1995"

# Ruecklieferung Teilmenge
Given I open an editor "Rueckliefer" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS-02"
And I set field "ueb" to "ja"
And I set field "such" to "RUECKLS-1"
And I set field "mge" to "-20" in row 1
And I save the current editor

# Wertereihe pruefen und Fortschrittszahl pruefen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
Then field "fzahl" has value "380" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich | status  | fix |
    | 800  | 380     | 400         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

# Wertereihe pruefen und Fortschrittszahl pruefen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_1"
Then field "fzahl" has value "380" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich | status  | fix |
    | 800  | 380     | 420         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 02 Bestellung zum Rahmen und Rechnung mit Lagerbewegung, sowie weitere Bestellungen und Lieferscheine

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "EKRAHMEN2"
And I set fields
    | such     | EKRAHMEN2        |
    | namebspr | Einkauf Rahmen2  |
    | bsart    | Fremdbeschaffung |
    | dispoa   | bedarfsbezogen   |
    | lief     | LIEFER1          |
    | efrist   | 15               |
    | bfrist   | 15               |
    | epr      | 50               |
And I save the current editor

# neuen Rahmenauftrag anlegen
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I set field "such" to "RAHMEN_2"
And I append rows
    | artikel   | mge  | zraster | zgltvon  | zgltbis  | einplan |
    | EKRAHMEN2 | 2700 | WOCHE1  | 06.02.95 | 09.04.95 | ja      |
And I save the current editor

And I set the fake date to "06.02.1995"

Given I create a PurchaseOrder "bestell02" for Vendor "LIEFER1" with Product "EKRAHMEN2" and quantity "500"
# Liefertermin ergibt den 27.02.

And I run Scheduling

And I set the fake date to "15.02.1995"

# Bestellung liefern, Rechnung mit Lagerbewegung, Teilmenge
Given I switch the current editor to editor "bestell02" with command "INVOICE"
And I set fields
    | vom    | .    |
    | tterm  | .    |
    | ueb    | ja   |
    | fakt   | ja   |
    | ebeleg | RE01 |
And I set field "mge" to "300" in row 1
Then field "zrahmen" has value "!Rahmen^nummer" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Scheduling

# Wertereihe pruefen und Wertereihe nicht änderbar, wenn Istmenge gleich Planmenge, bmge ist schreibgeschuetzt, aenderbar wenn Istmenge kleiner Planmenge
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_2"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 06.02.1995 | 12.02.1995 | 300  | 300     | 0           | initialisiert | nein |
    | 13.02.1995 | 19.02.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 20.02.1995 | 26.02.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 27.02.1995 | 05.03.1995 | 300  | 0       | 100         | initialisiert | nein |
    | 06.03.1995 | 12.03.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 13.03.1995 | 19.03.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 20.03.1995 | 26.03.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 27.03.1995 | 02.04.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 03.04.1995 | 09.04.1995 | 300  | 0       | 300         | initialisiert | nein |
Then field "bmge" is not modifiable in row 1
Then field "bistmge" is not modifiable in row 1
Then field "bmge" is modifiable in row 2
Then field "bistmge" is not modifiable in row 2
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "bestell02a" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFER1  |
    | such | BEST_02A |
    | vom  | .        |
And I append rows
    | artikel   | mge | wtterm   | einplan |
    | EKRAHMEN2 | 800 | 03.03.95 | ja      |
Then field "zrahmen" has value "!Rahmen^nummer" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe pruefen, es gibt noch eine offene Restmenge von 200 und weitere Bestellung über 800
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RAHMEN_2"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 06.02.1995 | 12.02.1995 | 300  | 300     | 0           | initialisiert | nein |
    | 13.02.1995 | 19.02.1995 | 300  | 0       | 0           | initialisiert | nein |
    | 20.02.1995 | 26.02.1995 | 300  | 0       | 0           | initialisiert | nein |
    | 27.02.1995 | 05.03.1995 | 300  | 0       | 0           | initialisiert | nein |
    | 06.03.1995 | 12.03.1995 | 300  | 0       | 200         | initialisiert | nein |
    | 13.03.1995 | 19.03.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 20.03.1995 | 26.03.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 27.03.1995 | 02.04.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 03.04.1995 | 09.04.1995 | 300  | 0       | 300         | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I set the fake date to "22.02.1995"

# Teilmenge liefern
Given I switch the current editor to editor "bestell02a" with command "DELIVERY"
And I set fields
    | vom    | .         |
    | ebeleg | LS_scen02 |
    | tterm  | .         |
    | ueb    | ja        |
And I set field "mge" to "400" in row 1
Then field "zrahmen" has value "!Rahmen^nummer" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe pruefen und Summe Istmenge pruefen, Planmenge nur aenderbar wenn groesser als Istmenge
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_2"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 06.02.1995 | 12.02.1995 | 300  | 300     | 0           | initialisiert | nein |
    | 13.02.1995 | 19.02.1995 | 300  | 300     | 0           | initialisiert | nein |
    | 20.02.1995 | 26.02.1995 | 300  | 100     | 0           | initialisiert | nein |
    | 27.02.1995 | 05.03.1995 | 300  | 0       | 0           | initialisiert | nein |
    | 06.03.1995 | 12.03.1995 | 300  | 0       | 200         | initialisiert | nein |
    | 13.03.1995 | 19.03.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 20.03.1995 | 26.03.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 27.03.1995 | 02.04.1995 | 300  | 0       | 300         | initialisiert | nein |
    | 03.04.1995 | 09.04.1995 | 300  | 0       | 300         | initialisiert | nein |
# Planmenge nur aenderbar, wenn groesser als Istmenge
Then field "bmge" is not modifiable in row 1
Then field "bmge" is not modifiable in row 2
Then field "bmge" is modifiable in row 3
# 2657 de   |Die Menge kann nicht kleiner als die Ist-Menge werden.
Then setting field "bmge" to "50" in row 3 throws the exception "2657"
Then I set field "mge" to "100" in row 3
Then I set field "mge" to "500" in row 9
Then field "istmgesum" has value "700" in row 0
Then field "mgeabwsum" has value "1600" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

Given I open an editor "bestell02" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BESTELL02"
And I close the current editor

Given I open an editor "bestell02a" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BEST_02A"
And I close the current editor

# Plankarte prüfen
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EKRAHMEN2"
And I press start
Then table has values
    | zugang | abgang | verw | vart             | vkopf^id       | geschaeftspartner  |
    | 700    |        |      | Lager            | (0,0,0)        |                    |
    | 200    |        |      | Fremdbeschaffung | !bestell02^id  | Lieferant 1 Inland |
    | 400    |        |      | Fremdbeschaffung | !bestell02a^id | Lieferant 1 Inland |
    | 300    |        |      | Rahmenauftrag    | !Rahmen^id     | Lieferant 1 Inland |
    | 300    |        |      | Rahmenauftrag    | !Rahmen^id     | Lieferant 1 Inland |
    | 300    |        |      | Rahmenauftrag    | !Rahmen^id     | Lieferant 1 Inland |
    | 500    |        |      | Rahmenauftrag    | !Rahmen^id     | Lieferant 1 Inland |
And I close the current editor
## von den ursprünglich 9 Einteilungen in der Wertereihe sind noch 4 offen, die ersten 3 bereits beliefert, für die nächsten beiden gibt es Bestellungen

# editierbare Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "EKRAHMEN2"
And I press button "ladetab"
Then table has values
    | bsnlimge | lzuomge | rlimge | kbs^id         |
    | 700      | 700     |        | (0,0,0)        |
    |          |         |        | (0,0,0)        |
    | 200      | 200     |        | !bestell02^id  |
    |          |         |        | (0,0,0)        |
    | 400      | 400     |        | !bestell02a^id |
And I close the current editor
# Einteilungen aus dispositiven Rahmen sind nicht in der editierbaren Plankarte


Scenario: 03 Pruefungen, Hinweis- und Fehlermeldungen

And I set the fake date to "13.02.1995"

# Rundungsfaktor im Artikelstamm setzen
Given I open an editor "ART_EK1" from table "(Part):(Product)" with command "STORE" for record "EK2-BEDARF"
And I set field "rundung" to "1"
And I save the current editor

Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER2"
And I set field "such" to "RA_TEST"
And I append rows
    | artikel    | mge  |
    | EK2-BEDARF | 1000 |
And I save the current editor

# Einplan ist nur aenderbar, wenn Menge, sowie Gueltigkeitszeitraum gesetzt sind
# Rundungsfaktor wird aus Artikelstamm uebernommen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
Then field "einplan" is not modifiable in row 1
And I set field "zraster" to "WOCHE1" in row 1
Then field "einplan" is not modifiable in row 1
And I set field "zgltvon" to "13.02.95" in row 1
Then field "einplan" is not modifiable in row 1
And I set field "zgltbis" to "12.03.95" in row 1
Then field "einplan" is modifiable in row 1
Then table has values
    | artikel    | mge  | zraster | zgltvon  | zgltbis  | einplan | rundung |
    | EK2-BEDARF | 1000 | WOCHE1  | 13.02.95 | 12.03.95 | nein    | 1       |
And I save the current editor

# Absteigen in Wertereihe nicht moeglich, wenn nicht eingeplant ist
Given I open an editor "Rahmen_pruef" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
Then field "einplan" has value "nein" in row 1
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I close the current editor

# Rundungsfaktor im Artikelstamm entfernen, im Rahmen bleibt der Wert
Given I open an editor "ART_EK1" from table "(Part):(Product)" with command "STORE" for record "EK2-BEDARF"
And I set field "rundung" to "0"
And I save the current editor

# Rundungsfaktor im Rahmen bleibt, außerdem Rahmen einplanen, und Zeitraum testen, Zeilen dürfen nicht gelöscht oder eingefügt werden
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
Then field "rundung" has value "1" in row 1
And I set field "einplan" to "ja" in row 1
And I set field "zgltvon" to "" in row 1
#  3003 de   |Angegebener Zeitraum ungültig!
Then saving the current editor throws the exception "3003"
And I set field "zgltvon" to "13.02.95" in row 1
And I set field "zgltbis" to "" in row 1
Then saving the current editor throws the exception "3003"
And I set field "zgltbis" to "12.03.95" in row 1
## diese Meldung kommt nicht mehr, erst beim Speichern
## 8568 de   |Das Feld 'von' ist größer als das Feld 'bis'. Bitte die Eingabe prüfen.
Then setting field "zgltvon" to "03.04.95" in row 1 throws the exception "8568"
#And I set field "zgltvon" to "03.04.95" in row 1
#Then saving the current editor throws the exception "3003"
And I set field "zgltvon" to "13.02.95" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
# 295 de   |Es dürfen keine Zeilen gelöscht werden
Then deleting the row at position 1 throws the exception "295"
# 294 de   |Es dürfen keine Zeilen ein- oder angefügt werden
Then creating a new row at position 2 throws the exception "294"
# Zeitraeume mit Planmenge 0 sind moeglich
And I set field "bmge" to "0" in row 3
And I set field "bmge" to "500" in row 4
And I set field "fix" to "nein" in row 4
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 13.02.1995 | 19.02.1995 | 250  | 0       | 250         | initialisiert | nein |
    | 20.02.1995 | 26.02.1995 | 250  | 0       | 250         | initialisiert | nein |
    | 27.02.1995 | 05.03.1995 | 0    | 0       | 0           | manuell       | ja   |
    | 06.03.1995 | 12.03.1995 | 500  | 0       | 500         | manuell       | nein |
And I close the current subeditor to switch back to the parent editor
And I set field "mge" to "1200" in row 1
# wenn Gesamtmenge sich aendert, verteilt sich die Menge nur auf die Zeilen die nicht fixiert sind
# die zusätzliche Menge wird zur bisherigen Menge pro Zeitraum addiert, nicht die neue Gesamtmenge gleichmaessig verteilt
# bmgeabweich wird erst durch Dispo aktualisiert
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 13.02.1995 | 19.02.1995 | 317  | 0       | 250         | initialisiert | nein |
    | 20.02.1995 | 26.02.1995 | 317  | 0       | 250         | initialisiert | nein |
    | 27.02.1995 | 05.03.1995 | 0    | 0       | 0           | manuell       | ja   |
    | 06.03.1995 | 12.03.1995 | 566  | 0       | 500         | manuell       | nein |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Wertereihe pruefen, Rundungsfaktor und Gesamtmenge aendern
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 13.02.1995 | 19.02.1995 | 317  | 0       | 317         | initialisiert | nein |
    | 20.02.1995 | 26.02.1995 | 317  | 0       | 317         | initialisiert | nein |
    | 27.02.1995 | 05.03.1995 | 0    | 0       | 0           | manuell       | ja   |
    | 06.03.1995 | 12.03.1995 | 566  | 0       | 566         | manuell       | nein |
And I close the current subeditor to switch back to the parent editor
# Rundungsfaktor kann geaendert werden, letzte Teilmenge Rundungsfaktor nicht beruecksichtigt, fuellt bis Gesamtmenge auf
And I set field "rundung" to "10" in row 1
And I set field "mge" to "1230" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 13.02.1995 | 19.02.1995 | 330  | 0       | 317         | initialisiert | nein |
    | 20.02.1995 | 26.02.1995 | 330  | 0       | 317         | initialisiert | nein |
    | 27.02.1995 | 05.03.1995 | 0    | 0       | 0           | manuell       | ja   |
    | 06.03.1995 | 12.03.1995 | 570  | 0       | 566         | manuell       | nein |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 13.02.1995 | 19.02.1995 | 330  | 0       | 330         | initialisiert | nein |
    | 20.02.1995 | 26.02.1995 | 330  | 0       | 330         | initialisiert | nein |
    | 27.02.1995 | 05.03.1995 | 0    | 0       | 0           | manuell       | ja   |
    | 06.03.1995 | 12.03.1995 | 570  | 0       | 570         | manuell       | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Zeitraster aendern, Freie Periode kann verwendet werden
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
And I set field "zraster" to "FREI1" in row 1
And I set field "mge" to "1200" in row 1
Then field "zgltbis" has value "21.04.95" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 13.02.1995 | 07.03.1995 | 400  | 0       | 400         | initialisiert | nein |
    | 08.03.1995 | 23.03.1995 | 400  | 0       | 400         | initialisiert | nein |
    | 24.03.1995 | 21.04.1995 | 400  | 0       | 400         | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Plankarte enthaelt die Planzugaenge
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EK2-BEDARF"
And I press start
Then the table has 4 rows
Then table has values
    | zugang | verw | vart          | vkopf^id    | geschaeftspartner  |
    |        |      | Lager         | (0,0,0)     |                    |
    | 400    |      | Rahmenauftrag | !Rahmen1^id | Lieferant 2 Inland |
    | 400    |      | Rahmenauftrag | !Rahmen1^id | Lieferant 2 Inland |
    | 400    |      | Rahmenauftrag | !Rahmen1^id | Lieferant 2 Inland |
And I close the current editor


Scenario: 04 Bestellung mit Beleg anfügen, Lieferschein NEU

Given I set StorageQuantity to zero for Product "EINK" on StorageLocation "F1"

Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I set field "such" to "RA_EINK"
And I append rows
    | artikel | mge  | zraster | zgltvon  | zgltbis  | einplan | rundung |
    | EINK    | 1000 | MONAT1  | 01.02.95 | 31.05.95 | ja      | 1       |
And I save the current editor

And I set the fake date to "06.02.1995"

# Bestellung aus Rahmen durch Beleg anfuegen
Given I open an editor "BE1_RA" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen1^id |
    | such  | BE1_RA      |
    | vom   | .           |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 200 | 12.03.95 | ja      |
Then field "zrahmen" has value "!Rahmen1^nummer" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RA_EINK"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 01.02.1995 | 28.02.1995 | 250  | 0       | 250         | initialisiert | nein |
    | 01.03.1995 | 31.03.1995 | 250  | 0       | 50          | initialisiert | nein |
    | 01.04.1995 | 30.04.1995 | 250  | 0       | 250         | initialisiert | nein |
    | 01.05.1995 | 31.05.1995 | 250  | 0       | 250         | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Lieferschein Modus NEU hat Verbindung zum Rahmen und Wertereihe
Given I open an editor "LS1_RA" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFER1 |
    | such   | LS1_RA  |
    | ebeleg | LS1_RA  |
    | vom    | .       |
    | ueb    | ja      |
And I append rows
    | artikel | mge |
    | EINK    | 50  |
Then field "zrahmen" has value "!Rahmen1^nummer" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "RA_EINK"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich | status        | fix  |
    | 01.02.1995 | 28.02.1995 | 250  | 50      | 200         | initialisiert | nein |
    | 01.03.1995 | 31.03.1995 | 250  | 0       | 50          | initialisiert | nein |
    | 01.04.1995 | 30.04.1995 | 250  | 0       | 250         | initialisiert | nein |
    | 01.05.1995 | 31.05.1995 | 250  | 0       | 250         | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Bestellung anliefern
And I deliver the PurchaseOrder "BE1_RA" with PackingSlip "LS-BE1"

# Ablegen durch Wiedervorlagedatum entfernen, plant den Rahmen aus und löscht die Wertereihe
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_EINK"
And I set field "tterm" to ""
Then field "einplan" has value "nein" in row 1
Then field "einplan" is not modifiable in row 1
And I save the current editor

# prüfen dass der Rahmen dann abgelegt ist
Then "(Purchasing):(BlanketOrder)" with the editor id "Rahmen1" is filed

# prüfen dass die Wertereihe nicht mehr vorhanden ist
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for search criteria "$,,such=RA_EINK;@richtung=(Backwards);@maxtreffer=1;@ablageart=abgelegt"
# 203 de      |Eintrag ist schreibgeschützt
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I close the current editor

And I run Scheduling

# Plankarte ist dann leer, bis auf Lagerzeile
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EINK"
And I press start
Then the table has 1 rows
And I close the current editor


# FDA-1752
Scenario: 05 Dienstleistungen können nicht eingeplant werden, einplan, zraster und rundung schreibgeschützt

Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I set field "such" to "RA_DL_EK"
And I append rows
    | artikel      | mge | zgltvon  | zgltbis  |
    | DL-REPARATUR | 6   | 16.01.95 | 31.07.95 |
Then field "zraster" is not modifiable in row 1
Then field "rundung" is not modifiable in row 1
Then field "einplan" is not modifiable in row 1
And I save the current editor

Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_DL_EK"
Then field "einplan" is not modifiable in row 1
Then field "zraster" is not modifiable in row 1
Then field "rundung" is not modifiable in row 1
And I close the current editor


# FDA-2835 Visualisierung des Starttermins für eine Freigabe aus EK-Rahmen
Scenario: 06 lzeit im Rahmen ist kleiner als efrist im Artikel

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "LZEIT"
And I set fields
    | such     | LZEIT            |
    | namebspr | lzeit Rahmen     |
    | bsart    | Fremdbeschaffung |
    | dispoa   | bedarfsbezogen   |
    | lief     | LIEFER1          |
    | efrist   | 15               |
    | bfrist   | 15               |
    | epr      | 50               |
And I save the current editor

# Rahmenauftrag anlegen
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I set field "such" to "R_LZEIT"
And I append rows
    | artikel | mge  | zraster | zgltvon  | zgltbis  | einplan | lzeit |
    | LZEIT   | 6000 | MONAT1  | 01.02.95 | 31.07.95 | ja      | 5     |
And I save the current editor

Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "R_LZEIT"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | sterm      | bmge | bistmge | bmgeabweich | status        | fix  |
    | 25.01.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 22.02.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 24.03.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 21.04.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 24.05.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 23.06.1995 | 1000 | 0       | 1000        | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Rahmen ablegen, plant den Rahmen aus und löscht die Wertereihe
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "R_LZEIT"
And I set field "tterm" to ""
And I save the current editor


Scenario: 07 keine lzeit im Rahmen, efrist aus Artikel wird verwendet

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "EFRIST"
And I set fields
    | such     | EFRIST             |
    | namebspr | efrist statt lzeit |
    | bsart    | Fremdbeschaffung   |
    | dispoa   | bedarfsbezogen     |
    | lief     | LIEFER1            |
    | efrist   | 15                 |
    | bfrist   | 15                 |
    | epr      | 50                 |
And I save the current editor

# Rahmenauftrag anlegen und lzeit auf 0 setzen
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I set field "such" to "R_EFRIST"
And I append rows
    | artikel | mge  | zraster | zgltvon  | zgltbis  | einplan |
    | EFRIST  | 6000 | MONAT1  | 01.02.95 | 31.07.95 | ja      |
Then field "lzeit" has value "15" in row 1
And I set field "lzeit" to "0" in row 1
And I save the current editor

Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "R_EFRIST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | sterm      | bmge | bistmge | bmgeabweich | status        | fix  |
    | 11.01.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 08.02.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 10.03.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 05.04.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 10.05.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 08.06.1995 | 1000 | 0       | 1000        | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Rahmen ablegen, plant den Rahmen aus und löscht die Wertereihe
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "R_EFRIST"
And I set field "tterm" to ""
And I save the current editor


Scenario: 08 Lieferant im Rahmen ist lief2 im Artikel, efrist2 wird verwendet

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "LIEF2_EFRIST2"
And I set fields
    | such     | LIEF2_EFRIST2       |
    | namebspr | efrist2 und lzeit 0 |
    | bsart    | Fremdbeschaffung    |
    | dispoa   | bedarfsbezogen      |
    | lief     | LIEFER1             |
    | efrist   | 30                  |
    | lief2    | LIEFER2             |
    | efrist2  | 15                  |
    | bfrist   | 15                  |
    | epr      | 50                  |
And I save the current editor

# Rahmenauftrag anlegen und lzeit auf 0 setzen
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER2"
And I set field "such" to "R_EFRIST2"
And I append rows
    | artikel       | mge  | zraster | zgltvon  | zgltbis  | einplan | lzeit |
    | LIEF2_EFRIST2 | 6000 | MONAT1  | 01.02.95 | 31.07.95 | ja      | 0     |
And I save the current editor

Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record "R_EFRIST2"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | sterm      | bmge | bistmge | bmgeabweich | status        | fix  |
    | 11.01.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 08.02.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 10.03.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 05.04.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 10.05.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 08.06.1995 | 1000 | 0       | 1000        | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Rahmen ablegen, plant den Rahmen aus und löscht die Wertereihe
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "R_EFRIST2"
And I set field "tterm" to ""
And I save the current editor


Scenario: 09 Änderung lzeit im Rahmen passt direkt den Bestelltermin in der Wertereihe an

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "AENDERN_LZEIT"
And I set fields
    | such     | AENDERN_LZEIT           |
    | namebspr | lzeit aendern im Rahmen |
    | bsart    | Fremdbeschaffung        |
    | dispoa   | bedarfsbezogen          |
    | lief     | LIEFER1                 |
    | efrist   | 15                      |
    | bfrist   | 15                      |
    | epr      | 50                      |
And I save the current editor

# Rahmenauftrag anlegen für anderen Lieferant, der nicht im Artikelstamm hinterlegt ist
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER2"
And I set field "such" to "R_LZEIT_2"
And I append rows
    | artikel       | mge  | zraster | zgltvon  | zgltbis  | einplan |
    | AENDERN_LZEIT | 6000 | MONAT1  | 01.02.95 | 31.07.95 | ja      |
Then field "lzeit" has value "0" in row 1
And I save the current editor

# Änderung lzeit im Rahmen ändert direkt sterm
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "R_LZEIT_2"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | sterm      | bmge | bistmge | bmgeabweich | status        | fix  |
    | 01.02.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 01.03.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 31.03.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 28.04.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 01.06.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 30.06.1995 | 1000 | 0       | 1000        | initialisiert | nein |
And I close the current subeditor to switch back to the parent editor
And I set field "lzeit" to "5" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | sterm      | bmge | bistmge | bmgeabweich | status        | fix  |
    | 25.01.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 22.02.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 24.03.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 21.04.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 24.05.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 23.06.1995 | 1000 | 0       | 1000        | initialisiert | nein |
And I save the current subeditor to switch back to the parent editor
And I set field "lzeit" to "15" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | sterm      | bmge | bistmge | bmgeabweich | status        | fix  |
    | 11.01.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 08.02.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 10.03.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 05.04.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 10.05.1995 | 1000 | 0       | 1000        | initialisiert | nein |
    | 08.06.1995 | 1000 | 0       | 1000        | initialisiert | nein |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Rahmen ablegen, plant den Rahmen aus und löscht die Wertereihe
Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "R_LZEIT_2"
And I set field "tterm" to ""
And I save the current editor


Scenario: 10 Artikelvorkalkulation mit sofort abrufbarer Menge

# Artikel und EK-Rahmen anlegen
Given I open an editor "SABRUF" from table "(Part):(Product)" with command "STORE" for record "SABRUF"
And I set fields
    | such     | SABRUF  |
    | namebspr | SABRUF  |
    | lief     | LIEFER1 |
    | efrist   | 50      |
    | vorlauf  | 50      |
    | epr      | 10      |
    | lief2    | LIEFER2 |
    | efrist2  | 30      |
    | vorlauf2 | 30      |
    | epr2     | 20      |
And I save the current editor

Given I open an editor "Rahmen" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I append rows
    | artikel | mge  | verfuegbmge | lfristkurz | zraster | zgltvon | zgltbis | einplan |
    | SABRUF  | 1200 | 200         | 2          | MONAT   | .       | +365    | ja      |
And I save the current editor

Given I switch the current editor to editor "SABRUF" with command "UPDATE"
# Standardmenge auf 100 setzen, Kalkulation nimmt die kurze Lieferzeit
And I set field "basis" to "100"
And I press button "kalkul" to open a subeditor for "Kblatt"
Then field "artikel" has value "SABRUF"
Then fields have values
    | kbfrist    | 2  |
    | bfrist     | 2  |
    | kbfristmin | 2  |
    | kbfristmax | 50 |
And I save the current subeditor to switch back to the parent editor
# Standardmenge auf 500 setzen, Kalkulation nimmt die reguläre Lieferzeit
And I set field "basis" to "500"
And I press button "kalkul" to open a subeditor for "Kblatt"
Then fields have values
    | kbfrist    | 50 |
    | bfrist     | 50 |
    | kbfristmin | 50 |
    | kbfristmax | 50 |
And I save the current subeditor to switch back to the parent editor
# Standardmenge=0, Losgröße=50 und Mindestbestand=100
And I set fields
    | basis   | 0   |
    | mindest | 100 |
    | losgr   | 50  |
And I press button "kalkul" to open a subeditor for "Kblatt"
Then fields have values
    | kbfrist    | 2  |
    | bfrist     | 0  |
    | kbfristmin | 2  |
    | kbfristmax | 50 |
And I save the current subeditor to switch back to the parent editor
And I set fields
    | mindest | 0 |
    | losgr   | 0 |
# Zweitliefrant wird Erstlieferant, der keinen EK-Rahmen hat
And I press button "ersterlief2"
Then field "lief^such" has value "LIEFER2"
And I press button "kalkul" to open a subeditor for "Kblatt"
Then fields have values
    | kbfrist    | 30 |
    | bfrist     | 30 |
    | kbfristmin | 30 |
    | kbfristmax | 30 |
And I save the current subeditor to switch back to the parent editor
And I press button "ersterlief2"
And I save the current editor

# Gültigkeit EK-Rahmen in Vergangenheit
And I switch the current editor to editor "Rahmen" with command "UPDATE"
And I modify table
    | zgltvon | zgltbis | !row |
    | -180    | -5      | 1    |
And I save the current editor

Given I switch the current editor to editor "SABRUF" with command "UPDATE"
And I press button "kalkul" to open a subeditor for "Kblatt"
Then fields have values
    | kbfrist    | 50 |
    | bfrist     | 50 |
    | kbfristmin | 50 |
    | kbfristmax | 50 |
And I save the current subeditor to switch back to the parent editor


Scenario: 11 Rahmenposition durch Setzen des Status stornieren entfernt die Wertereihe

Given I open an editor "Rahmen11" from table "(Purchasing):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 3 rows
And I close the current subeditor to switch back to the parent editor
And I set field "status" to "S" in row 1
And I save the current editor

Given I open an editor "Rahmen11" from table "(Purchasing):(BlanketOrder)" with command "VIEW" for record from editor "Rahmen11"
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I close the current editor

# Plankarte ist dann leer
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EK2-BEDARF"
And I press start
Then the table has 0 rows
And I close the current editor


Scenario: 12 Ausgeschoepfter Rahmen hat auch nach Stornieren einer Bestellung keine Wertereihe mehr in Plankarte

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "AUSGESCHOEPFT"
And I set fields
    | such     | AUSGESCHOEPFT          |
    | namebspr | Rahmen ausgeschoepft   |
    | bsart    | Fremdbeschaffung       |
    | dispoa   | bedarfsbezogen         |
    | lief     | LIEFER1                |
    | efrist   | 10                     |
    | bfrist   | 10                     |
    | epr      | 50                     |
And I save the current editor

# Rahmenauftrag anlegen, ohne Zeitraster
Given I open an editor "Rahmen1" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to "LIEFER1"
And I set field "such" to "RAH_AUS"
And I append rows
    | artikel       | mge   | zgltvon  | zgltbis  | einplan |
    | AUSGESCHOEPFT | 1000  | 01.01.95 | 31.12.95 | ja      |
And I save the current editor

And I create a SalesOrder "AUF1" for Customer "TEST" with Product "AUSGESCHOEPFT" and quantity "100"

And I create a SalesOrder "AUF2" for Customer "TEST" with Product "AUSGESCHOEPFT" and quantity "200"

And I create a SalesOrder "AUF3" for Customer "TEST" with Product "AUSGESCHOEPFT" and quantity "300"

And I create a SalesOrder "AUF4" for Customer "TEST" with Product "AUSGESCHOEPFT" and quantity "400"

Given I open an editor "AUF1" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF1"
And I set field "wtterm" to "07.06.95" in row 1
And I save the current editor

Given I open an editor "AUF2" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF2"
And I set field "wtterm" to "05.07.95" in row 1
And I save the current editor

Given I open an editor "AUF3" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF3"
And I set field "wtterm" to "10.08.95" in row 1
And I save the current editor

Given I open an editor "AUF4" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF4"
And I set field "wtterm" to "01.09.95" in row 1
And I save the current editor

And I run Scheduling

# Bestellvorschläge freigeben
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "AUSGESCHOEPFT"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BE_LIEFERN" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE01"
And I set fields
    | ebeleg    | LS_BE01   |
    | vom       |  .        |
    | ueb       | ja        |
And I set field "mge" to "100" in row 1
And I save the current editor

# Bestellvorschläge freigeben
Given I open an editor "BV02" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "AUSGESCHOEPFT"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE02"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BV03" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "AUSGESCHOEPFT"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE03"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "BV04" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "AUSGESCHOEPFT"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE04"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Bestellung stornieren
Given I open an editor "BE03" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE03"
# 191 de      |Wollen Sie diese Position wirklich stornieren?
And I respond with answer "ja" to the dialog with id "191"
And I set field "mge" to "0" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "BE02" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE02"
And I close the current editor
Given I open an editor "BE04" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BE04"
And I close the current editor

# Plankarte pruefen, keine Wertereihen, nur Bestellung und Bestellvorschlag
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "AUSGESCHOEPFT"
And I press start
Then table has values
    | zugang | abgang | vart             | vkopf^id  |
    | 100    |        | Lager            | (0,0,0)   |
    |        | 100    | Auftrag          | !AUF1^id  |
    | 200    |        | Fremdbeschaffung | !BE02^id  |
    |        | 200    | Auftrag          | !AUF2^id  |
    | 300    |        | Fremdbeschaffung | (0,0,0)   |
    |        | 300    | Auftrag          | !AUF3^id  |
    | 400    |        | Fremdbeschaffung | !BE04^id  |
    |        | 400    | Auftrag          | !AUF4^id  |
And I close the current editor
