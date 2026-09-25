@persistent
Feature: chargencrash.feature

Background:
And I set the fake date to "16.01.1995"

#***************************************************************************
#
#  Name             : chargencrash.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet unerlaubte Aktionen mit Chargen
#  ref              : ref_charg_crash_cu
#
#***************************************************************************

Scenario: Plausi beim Anlegen von Chargen, sowie Loeschen von Chargen nicht erlaubt

Given I open an editor "TEST" from table "(Part):(Product)" with command "UPDATE" for record "TEST"
And I set field "chverfolgung" to "Chargenverfolgung"
And I save the current editor

Given I open an editor "Charge1" from table "(Lots):(Lots)" with command "STORE" for record ""
And I set fields
    | such          | Charge1       |
    | chname        | Testcharge 1  |
    | exnum         | 1234          |
    | status        | Y             |
    | ljtext        | .mach 1       |
    | artikel       | TEST          |
    | lief          | 1             |
And I save the current editor

# Eine Eigencharge darf kein Lieferant akzeptieren
Given I open an editor "Charge2" from table "(Lots):(Lots)" with command "STORE" for record ""
And I set fields
    | such          | Charge2       |
    | chname        | Testcharge 2  |
    | exnum         | 12345         |
    | status        | G             |
    | ljtext        | .mach 2       |
    | artikel       | 301           |
    | eigcharge     | ja            |
Then field "lief" is not modifiable
And I save the current editor

# Noch ein paar anonyme Chargen anlegen
Given I open an editor "anonym1" from table "(Lots):(Lots)" with command "STORE" for record ""
And I set fields
    | such          | anonym1       |
    | exnum         | 1234567       |
And I save the current editor

Given I open an editor "anonym2" from table "(Lots):(Lots)" with command "STORE" for record ""
And I set fields
    | such          | anonym2       |
    | exnum         | 12345678      |
And I save the current editor

Given I open an editor "Charge3" from table "(Lots):(Lots)" with command "STORE" for record ""
And I set fields
    | such          | Charge3       |
    | exnum         | 1234567890    |
    | artikel       | TEST          |
    | lief          | 001           |
And I save the current editor


Scenario: Einkaufsbestellung - Plausi Artikel stimmt nicht mit dem Artikel der Charge ueberein

Given I open an editor "EinkBestellung-2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | num   | 1 |
    | lief  | 1 |
And I append rows
    | artikel   | mge   |
    | TEST      | 1     |
# 3166 TX=de   |Artikel stimmt nicht mit dem Artikel der Chargen-/Seriennummer überein
Then setting field "charge" to "!Charge2^id" in row 1 throws the exception "3166"
And I close the current editor


Scenario: Einkaufsbestellung - Plausi Lieferant stimmt nicht mit dem Lieferanten der Charge ueberein

Given I open an editor "EinkBestellung-3" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | num   | 1 |
    | lief  | 1 |
And I append rows
    | artikel   | mge   |
    | TEST      | 1     |
# 3167 TX=de   |Lieferant stimmt nicht mit dem Lieferanten der Chargen-/Seriennummer überein
Then setting field "charge" to "!Charge3^id" in row 1 throws the exception "3167"
And I close the current editor


Scenario: Einkaufsbestellung - Plausi wenn kein Artikel eingetragen, sind die Chargenfelder schreibgeschuetzt

Given I open an editor "EinkBestellung-4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | num   | 1 |
    | lief  | 1 |
And I create a new row at position 1
Then field "charge" is not modifiable in row 1
Then field "tcharge" is not modifiable in row 1
And I close the current editor


Scenario: Einkaufsbestellung - Plausi wenn kein Lieferant eingetragen, sind die Chargenfelder schreibgeschuetzt

Given I open an editor "EinkBestellung-5" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | num   | 1 |
And I append rows
    | artikel   | mge   |
    | TEST      | 1     |
Then field "charge" is not modifiable in row 1
Then field "tcharge" is not modifiable in row 1
And I close the current editor


Scenario: Einkaufsbestellung - Plausi bei Aenderung des Lieferanten wird die Charge geleert

Given I open an editor "EinkBestellung-6" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | num   | 1 |
    | lief  | 1 |
And I append rows
    | artikel   | mge   | charge        |
    | TEST      | 1     | !Charge1^id   |
Then I set field "lief" to "001"
Then field "charge" is empty in row 1
Then field "tcharge" is empty in row 1
And I close the current editor


Scenario: Einkaufsbestellung - Plausi bei Aenderung des Artikels wird die Charge geleert

Given I open an editor "EinkBestellung-7" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | num   | 1 |
    | lief  | 1 |
And I append rows
    | artikel   | mge   | charge        |
    | TEST      | 1     | !Charge1^id   |
Then I set field "artikel" to "E2" in row 1
Then field "charge" is empty in row 1
Then field "tcharge" is empty in row 1
And I close the current editor


Scenario: Einkaufsbestellung - Plausi Eigencharge darf nicht eingetragen werden koennen

Given I open an editor "EinkBestellung-8" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | num   | 1 |
    | lief  | 1 |
And I append rows
    | artikel   | mge   |
    | BG1       | 1     |
# 3891 TX=de   |Chargen-/Seriennummer ist selbst produziert
Then setting field "charge" to "!Charge2^id" in row 1 throws the exception "3891"
And I close the current editor


Scenario: Umlagerungslieferschein - Umlagerungsplatz wird geleert, Charge muss ausgetragen werden

Given I open an editor "EinkLieferschein-9" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | num       | 1 |
    | lief      | 1 |
    | umplatz   | 1 |
And I append rows
    | artikel   | mge  | charge         |
    | TEST      | 1    | !Charge1^id    |
And I set field "umplatz" to ""
Then field "umcharge" is empty in row 1
Then field "tumcharge" is empty in row 1
And I close the current editor


Scenario: Inventur - Es darf keine zwei gleichen Positionen geben - Artikel,Platz,Faktor,Einheit,Charge

# Zaehlliste VOR Inventureroeffnung
Given I open an editor "INVNEU-10" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "INVNEU-10"
And I append rows
    | artikel   | platz | gebeinh   | gebf | charge         |
    | TEST      | F1    | Stück     | 1.0  | !Charge1^id    |
    | TEST      | F1    | Stück     | 1.0  |                |
# 6633 de      |Einheit mit gleichem Faktor, gleichem Behälter, gleicher Charge, gleichem Projekt oder gleicher Verwendung gibt es schon.
Then setting field "charge" to "!Charge1^id " in row 2 throws the exception "6633"
And I close the current editor

# Zaehlliste NACH Inventureroeffnung
Given I open an editor "INVNEU-11" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "INVNEU-11"
And I append rows
    | artikel   | platz | gebeinh   | gebf | charge         |
    | TEST      | F1    | Stück     | 1.0  | !Charge1^id    |
    | TEST      | F1    | Stück     | 1.0  |                |
And I save the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "INVNEU-11" and menu choice "Ja"
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "INVNEU-11"
Then table has values
    | artikel   | platz | gebeinh   | gebf | charge^id      |
    | TEST      | F1    | Stück     | 1    | (0,0,0)        |
    | TEST      | F1    | Stück     | 1    | !Charge1^id    |
Then fields in table are modifiable
    | charge    | tcharge   |
    | nein      | nein      |
    | nein      | nein      |
And I append rows
    | artikel   | platz | gebeinh   | charge         | gebf |
    | TEST      | F1    | Stück     | !Charge3^id    | 1.0  |
    | TEST      | F1    | Stück     | !Charge3^id    |      |
# 6633 de      |Einheit mit gleichem Faktor, gleichem Behälter, gleicher Charge/SN, gleichem Projekt oder gleicher Verwendung gibt es schon.
Then setting field "gebf" to "1.0" in row 4 throws the exception "6633"
And I close the current editor


Scenario: Lagerbestandskorrektur - Es darf keine zwei gleichen Positionen geben

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | TEST  |
    | beleg     | .     |
    | beldat    | .     |
And I modify table
    | !row      | platz | mge | charge1       |
    | 1         | F1    | 1   | !Charge1^id   |
And I create a new row at position 2
# Bestandskorrektur jeweils nur fuer einen Lagerplatz erlaubt
# die Meldung kommt, aber mit ACK statt NAK, kann also nicht abgefragt werden
#Then setting field "platz" to "F2" in row 2 throws the exception "1663"
And I set field "platz" to "F2" in row 2
# wird automatisch geaendert auf F1
Then field "platz" has value "F1" in row 2
And I modify table
    | !row  | mge | ze      | charge1       |
    | 2     | 1   | Stück   | !Charge1^id   |
# 6633 de      |Einheit mit gleichem Faktor, gleichem Behälter, gleicher Charge/SN, gleichem Projekt oder gleicher Verwendung gibt es schon.
Then saving the current editor throws the exception "6633"
And I set field "tcharge1" to "789" in row 2
And I save the current editor


Scenario: Im Einkaufsvorgang muss vor Eintragen der Charge ein Lieferant eingetragen sein, auch wenn in die Materialzuordnung abgestiegen wird

Given I open an editor "EinkLieferschein-13" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | num   | 12    |
And I append rows
    | artikel   | mge  |
    | TEST      | 500  |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
# 86 Bitte Lieferant eintragen
Then setting field "charge" to "!Charge1^id" in row 1 throws the exception "86"
Then field "charge" is not modifiable in row 1
Then field "tcharge" is not modifiable in row 1
And I close the current editor


Scenario: Fertigungsvorschlag anlegen, Plausi Artikel stimmt mit Charge ueberein

Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge |
    | TEST      | 1      |
# 3166 TX=de   |Artikel stimmt nicht mit dem Artikel der Chargen-/Seriennummer überein
Then setting field "charge" to "!Charge2^id" in row 1 throws the exception "3166"
And I close the current editor
