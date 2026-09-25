@persistent
Feature: Dispositive_Rahmen_VK.feature

Background:
And I set the fake date to "16.01.1995"



# **********************************************************************************
#  Name             : Dispositive_Rahmen_VK
#  Autor            : bschiga
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Dispositive Rahmenauftraege Verkauf
#  ref              : ref_dispo_rahmen_cu
#
# **********************************************************************************
# verwendete Stammdaten  - Stammdaten_Dispositive_Rahmen.feature
####################################################################################

Scenario: 01 Auftrag zum Rahmen und Rechnung mit Lagerbewegung, sowie weitere Auftraege und Lieferscheine

# Bestand zubuchen
Given I open an editor "Rechnung_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_SCEN01     |
    | budat    | .             |
And I append rows
    | artikel     | mge   | platz   | preis | tterm |
    | EK2-AUFTRAG | 700   | F1      | 12,00 | +4    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# neuen Rahmenauftrag anlegen
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RAHMEN_02"
And I append rows
    | artikel     | mge  | zraster  | zgltvon  | zgltbis  | einplan |
    | EK2-AUFTRAG | 2700 | WOCHE1   | 06.02.95 | 09.04.95 | ja      |
And I save the current editor

And I set the fake date to "06.02.1995"

Given I create a SalesOrder "auftrag02" for Customer "KUNDE1" with Product "EK2-AUFTRAG" and quantity "500"

And I run Scheduling

### wichtig, je nachdem, wie das fake date gesetzt ist, ändert sich der Zeitraum der Verrechnung ###
# Auftrag liefern, Rechnung mit Lagerbewegung, Teilmenge
Given I switch the current editor to editor "auftrag02" with command "INVOICE"
And I set fields
    | vom   | .     |
    | tterm | .     |
    | ueb   | ja    |
    | fakt  | ja    |
And I set field "mge" to "300" in row 1
And I set field "preis" to "15,00" in row 1
Then field "zrahmen" has value "!Rahmen^nummer" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Scheduling

# Wertereihe pruefen und Wertereihe nicht änderbar, wenn Istmenge gleich Planmenge, bmge ist schreibgeschuetzt, aenderbar wenn Istmenge kleiner Planmenge
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_02"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich  | status        | fix   |
    |  300 |  300    |    0         | initialisiert | nein  |
    |  300 |  0      |  100         | initialisiert | nein  |
    |  300 |  0      |  300         | initialisiert | nein  |
    |  300 |  0      |  300         | initialisiert | nein  |
    |  300 |  0      |  300         | initialisiert | nein  |
    |  300 |  0      |  300         | initialisiert | nein  |
    |  300 |  0      |  300         | initialisiert | nein  |
    |  300 |  0      |  300         | initialisiert | nein  |
    |  300 |  0      |  300         | initialisiert | nein  |
Then field "bmge" is not modifiable in row 1
Then field "bistmge" is not modifiable in row 1
Then field "bmge" is modifiable in row 2
Then field "bistmge" is not modifiable in row 2
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "auftrag02a" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1    |
    | such  | AUF_02A   |
    | vom   | .         |
And I append rows
    | artikel       | mge  | wtterm   | einplan |
    | EK2-AUFTRAG   |  800 | 24.02.95 |  ja     |
Then field "zrahmen" has value "!Rahmen^nummer" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe pruefen
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_02"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 06.02.1995 | 12.02.1995|  300 |  300    |    0        | initialisiert | nein  |
    | 13.02.1995 | 19.02.1995|  300 |  0      |    0        | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  300 |  0      |    0        | initialisiert | nein  |
    | 27.02.1995 | 05.03.1995|  300 |  0      |    0        | initialisiert | nein  |
    | 06.03.1995 | 12.03.1995|  300 |  0      |  200        | initialisiert | nein  |
    | 13.03.1995 | 19.03.1995|  300 |  0      |  300        | initialisiert | nein  |
    | 20.03.1995 | 26.03.1995|  300 |  0      |  300        | initialisiert | nein  |
    | 27.03.1995 | 02.04.1995|  300 |  0      |  300        | initialisiert | nein  |
    | 03.04.1995 | 09.04.1995|  300 |  0      |  300        | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Teilmenge liefern
Given I switch the current editor to editor "auftrag02a" with command "DELIVERY"
And I set fields
    | vom   | .     |
    | tterm | .     |
    | ueb   | ja    |
And I set field "mge" to "400" in row 1
Then field "zrahmen" has value "!Rahmen^nummer" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe pruefen und Summe Istmenge pruefen, Planmenge nur aenderbar wenn groesser als Istmenge
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_02"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 06.02.1995 | 12.02.1995|  300 |  300    |    0        | initialisiert | nein  |
    | 13.02.1995 | 19.02.1995|  300 |  300    |    0        | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  300 |  100    |    0        | initialisiert | nein  |
    | 27.02.1995 | 05.03.1995|  300 |  0      |    0        | initialisiert | nein  |
    | 06.03.1995 | 12.03.1995|  300 |  0      |  200        | initialisiert | nein  |
    | 13.03.1995 | 19.03.1995|  300 |  0      |  300        | initialisiert | nein  |
    | 20.03.1995 | 26.03.1995|  300 |  0      |  300        | initialisiert | nein  |
    | 27.03.1995 | 02.04.1995|  300 |  0      |  300        | initialisiert | nein  |
    | 03.04.1995 | 09.04.1995|  300 |  0      |  300        | initialisiert | nein  |
# Planmenge nur aenderbar, wenn groesser als Istmenge
Then field "bmge" is not modifiable in row 1
Then field "bmge" is not modifiable in row 2
Then field "bmge" is modifiable in row 3
# 2657 de   |Die Menge kann nicht kleiner als die Ist-Menge werden.
Then setting field "bmge" to "50" in row 3 throws the exception "2657"
Then I set field "mge" to "100" in row 3
Then I set field "mge" to "500" in row 9
Then I set field "fix" to "nein" in row 9
Then field "istmgesum" has value "700" in row 0
Then field "mgeabwsum" has value "1600" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Gültigkeitszeitraum verlängern
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_02"
And I set field "zgltbis" to "21.04.95" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe prüfen, noch offene Menge auf offene Zeitraeume verteilt, Istmengen bleiben erhalten
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_02"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 06.02.1995 | 12.02.1995|  300 |  300    |    0        | initialisiert | nein  |
    | 13.02.1995 | 19.02.1995|  300 |  300    |    0        | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  100 |  100    |    0        | manuell       | ja    |
    | 27.02.1995 | 05.03.1995|  250 |  0      |    0        | initialisiert | nein  |
    | 06.03.1995 | 12.03.1995|  250 |  0      |    0        | initialisiert | nein  |
    | 13.03.1995 | 19.03.1995|  250 |  0      |  150        | initialisiert | nein  |
    | 20.03.1995 | 26.03.1995|  250 |  0      |  250        | initialisiert | nein  |
    | 27.03.1995 | 02.04.1995|  250 |  0      |  250        | initialisiert | nein  |
    | 03.04.1995 | 09.04.1995|  250 |  0      |  250        | initialisiert | nein  |
    | 10.04.1995 | 16.04.1995|  250 |  0      |  250        | initialisiert | nein  |
    | 17.04.1995 | 21.04.1995|  250 |  0      |  250        | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Gültigkeitszeitraum verkürzen
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_02"
And I set field "zgltbis" to "31.03.95" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe prüfen, noch offene Menge auf offene Zeitraeume verteilt, Istmengen bleiben erhalten
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_02"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 06.02.1995 | 12.02.1995|  300 |  300    |    0        | initialisiert | nein  |
    | 13.02.1995 | 19.02.1995|  300 |  300    |    0        | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  100 |  100    |    0        | manuell       | ja    |
    | 27.02.1995 | 05.03.1995|  400 |  0      |    0        | initialisiert | nein  |
    | 06.03.1995 | 12.03.1995|  400 |  0      |  200        | initialisiert | nein  |
    | 13.03.1995 | 19.03.1995|  400 |  0      |  400        | initialisiert | nein  |
    | 20.03.1995 | 26.03.1995|  400 |  0      |  400        | initialisiert | nein  |
    | 27.03.1995 | 31.03.1995|  400 |  0      |  400        | initialisiert | nein  |
And I close the current editor


Scenario: 02 Testet Mengenaenderungen, Hinweis- und Fehlermeldungen, Wertereihe kann nicht geloescht werden

And I set the fake date to "13.02.1995"

# Rundungsfaktor im Artikelstamm setzen
Given I open an editor "ART_EK1" from table "(Part):(Product)" with command "STORE" for record "EK3-BEDARF"
And I set field "rundung" to "1"
And I save the current editor

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE2"
And I set field "such" to "RA_TEST"
And I append rows
    | artikel    | mge   |
    | EK3-BEDARF | 1000  |
And I save the current editor

# Einplan ist nur aenderbar, wenn Menge, Zeitraster, sowie Gueltigkeitszeitraum gesetzt sind
# Rundungsfaktor wird aus Artikelstamm uebernommen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
Then field "einplan" is not modifiable in row 1
And I set field "zraster" to "WOCHE1" in row 1
Then field "einplan" is not modifiable in row 1
And I set field "zgltvon" to "13.02.95" in row 1
Then field "einplan" is not modifiable in row 1
And I set field "zgltbis" to "12.03.95" in row 1
Then field "einplan" is modifiable in row 1
Then table has values
    | artikel       | mge    | zraster  | zgltvon  | zgltbis  | einplan | rundung |
    | EK3-BEDARF    | 1000   | WOCHE1   | 13.02.95 | 12.03.95 | nein    | 1       |
And I save the current editor

# Absteigen in Wertereihe nicht moeglich, wenn nicht eingeplant ist
Given I open an editor "Rahmen_pruef" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
Then field "einplan" has value "nein" in row 1
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I close the current editor

# Rundungsfaktor im Artikelstamm entfernen, im Rahmen bleibt der Wert
Given I open an editor "ART_EK1" from table "(Part):(Product)" with command "STORE" for record "EK3-BEDARF"
And I set field "rundung" to "0"
And I save the current editor

# Rundungsfaktor im Rahmen bleibt, außerdem Rahmen einplanen, und Zeitraum testen, Zeilen dürfen nicht gelöscht oder eingefügt werden
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
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
#  3003 de   |Angegebener Zeitraum ungültig!
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
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 13.02.1995 | 19.02.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 27.02.1995 | 05.03.1995|    0 |  0      |      0      | manuell       | ja    |
    | 06.03.1995 | 12.03.1995|  500 |  0      |    500      | manuell       | nein  |
And I close the current subeditor to switch back to the parent editor
And I set field "mge" to "1200" in row 1
# wenn Gesamtmenge sich aendert, verteilt sich die Menge nur auf die Zeilen die nicht fixiert sind
# die zusätzliche Menge wird zur bisherigen Menge pro Zeitraum addiert, nicht die neue Gesamtmenge gleichmaessig verteilt
# bmgeabweich wird erst durch Dispo aktualisiert
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 13.02.1995 | 19.02.1995|  317 |  0      |    250      | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  317 |  0      |    250      | initialisiert | nein  |
    | 27.02.1995 | 05.03.1995|    0 |  0      |      0      | manuell       | ja    |
    | 06.03.1995 | 12.03.1995|  566 |  0      |    500      | manuell       | nein  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Wertereihe pruefen, Rundungsfaktor und Gesamtmenge aendern
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 13.02.1995 | 19.02.1995|  317 |  0      |    317      | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  317 |  0      |    317      | initialisiert | nein  |
    | 27.02.1995 | 05.03.1995|    0 |  0      |      0      | manuell       | ja    |
    | 06.03.1995 | 12.03.1995|  566 |  0      |    566      | manuell       | nein  |
And I close the current subeditor to switch back to the parent editor
# Rundungsfaktor kann geaendert werden, letzte Teilmenge Rundungsfaktor nicht beruecksichtigt, fuellt bis Gesamtmenge auf
And I set field "rundung" to "10" in row 1
And I set field "mge" to "1230" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 13.02.1995 | 19.02.1995|  330 |  0      |    317      | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  330 |  0      |    317      | initialisiert | nein  |
    | 27.02.1995 | 05.03.1995|    0 |  0      |      0      | manuell       | ja    |
    | 06.03.1995 | 12.03.1995|  570 |  0      |    566      | manuell       | nein  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 13.02.1995 | 19.02.1995|  330 |  0      |    330      | initialisiert | nein  |
    | 20.02.1995 | 26.02.1995|  330 |  0      |    330      | initialisiert | nein  |
    | 27.02.1995 | 05.03.1995|    0 |  0      |      0      | manuell       | ja    |
    | 06.03.1995 | 12.03.1995|  570 |  0      |    570      | manuell       | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Zeitraster aendern ist möglich,sowie Freie Periode kann verwendet werden
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
And I set field "zraster" to "FREI1" in row 1
And I set field "mge" to "1200" in row 1
Then field "zgltbis" has value "21.04.95" in row 1
Then field "einplan" has value "ja" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_TEST"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 13.02.1995 | 07.03.1995|  400 |  0      |    400      | initialisiert | nein  |
    | 08.03.1995 | 23.03.1995|  400 |  0      |    400      | initialisiert | nein  |
    | 24.03.1995 | 21.04.1995|  400 |  0      |    400      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Plankarte enthält die Planbedarfe sowie die Bestellvorschläge
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EK3-BEDARF"
And I press start
Then the table has 7 rows
Then table has values
    | zugang    | abgang    | verw      | vart              | vkopf^id      | geschaeftspartner |
    |           |           |           | Lager             | (0,0,0)       |                   |
    |  400      |           |           | Fremdbeschaffung  | (0,0,0)       |                   |
    |           |  400      |           | Rahmenauftrag     | !Rahmen1^id   | Kunde 2 Inland    |
    |  400      |           |           | Fremdbeschaffung  | (0,0,0)       |                   |
    |           |  400      |           | Rahmenauftrag     | !Rahmen1^id   | Kunde 2 Inland    |
    |  400      |           |           | Fremdbeschaffung  | (0,0,0)       |                   |
    |           |  400      |           | Rahmenauftrag     | !Rahmen1^id   | Kunde 2 Inland    |
And I close the current editor

# 6253  Wertereihen von eingeplanten Rahmenaufträgen dürfen nicht gelöscht werden.
Given I open an editor "Wertereihe_RA_TEST" from table "(ValueSequence):(RollingForecast)" with command "DELETE" for search criteria "$,,rahmenkopf^such==RA_TEST;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then saving the current editor throws the exception "6253"
And I close the current editor

# Rahmen ausplanen entfernt die Wertereihe
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_TEST"
And I respond with answer "ja" to the dialog with id "Rahmenauftragsposition ausplanen"
And I set field "einplan" to "nein" in row 1
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I save the current editor

And I run Scheduling

# Plankarte ist dann leer
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EK3-BEDARF"
And I press start
Then the table has 0 rows
And I close the current editor


Scenario: 03 Auftrag mit Beleg anfügen, Lieferschein NEU ohne Auftrag

Given I set StorageQuantity to zero for Product "E3" on StorageLocation "F1"

# Bestand zubuchen
Given I open an editor "Rechnung_04" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_SCEN04     |
    | budat    | .             |
And I append rows
    | artikel   | mge   | platz | preis | tterm |
    | E3        | 250   | F1    | 80,00 | +4    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "TESTM"
And I set field "such" to "RA1_E3"
And I append rows
    | artikel   | mge    | zraster  | zgltvon  | zgltbis  | einplan | rundung |
    | E3        | 1000   | MONAT1   | 01.02.95 | 31.05.95 | ja      |  1      |
And I save the current editor

And I set the fake date to "08.02.1995"

# Auftrag aus Rahmen durch Beleg anfuegen
Given I open an editor "AUF1_RA1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen1^id |
    | such  | AUF1_RA1    |
    | vom   | .           |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 200 | 15.03.95 |  ja     |
Then field "zrahmen" has value "!Rahmen1^nummer" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA1_E3"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |     50      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.05.1995 | 31.05.1995|  250 |  0      |    250      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Lieferschein Modus NEU hat Verbindung zum Rahmen und Wertereihe
Given I open an editor "LS1_RA1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | TESTM     |
    | such  | LS1_RA1   |
    | vom   | .         |
    | ueb   | ja        |
And I append rows
    | artikel | mge |
    | E3      | 50  |
Then field "zrahmen" has value "!Rahmen1^nummer" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA1_E3"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  50     |    200      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |     50      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.05.1995 | 31.05.1995|  250 |  0      |    250      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Auftrag liefern
And I deliver the SalesOrder "AUF1_RA1" with PackingSlip "LS-AUF1"

# Ablegen durch Wiedervorlagedatum entfernen, plant den Rahmen aus und löscht die Wertereihe
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA1_E3"
And I set field "tterm" to ""
Then field "einplan" has value "nein" in row 1
Then field "einplan" is not modifiable in row 1
And I save the current editor

# prüfen dass der Rahmen abgelegt ist
Then "(Sales):(BlanketOrder)" with the editor id "Rahmen1" is filed

# prüfen dass die Wertereihe nicht mehr vorhanden ist
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for search criteria "$,,such=RA1_E3;@richtung=(Backwards);@maxtreffer=1;@ablageart=abgelegt"
# 203 de      |Eintrag ist schreibgeschützt
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I close the current editor

And I run Scheduling

# Plankarte ist dann leer, auch keine Plandaten mehr, Wertereihe ist geloescht
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "E3"
And I press start
Then the table has 0 rows
And I close the current editor


Scenario: 04 Dienstleistungen können nicht eingeplant werden, einplan, zraster, rundung schreibgeschützt

Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_DL_VK"
And I append rows
    | artikel       | mge    | zgltvon  | zgltbis  |
    | DL-REPARATUR  |  6     | 16.01.95 | 31.07.95 |
Then field "zraster" is not modifiable in row 1
Then field "rundung" is not modifiable in row 1
Then field "einplan" is not modifiable in row 1
And I save the current editor

Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_DL_VK"
Then field "einplan" is not modifiable in row 1
Then field "zraster" is not modifiable in row 1
Then field "rundung" is not modifiable in row 1
And I close the current editor


Scenario: 05 Wertereihe bearbeiten, Auftrag und Lieferschein zum Rahmen, Lieferschein Storno, Auftragsmenge reduzieren

# Bestand zubuchen
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_SCEN01     |
    | budat    | .             |
And I append rows
    | artikel     | mge   | platz   | preis | tterm |
    | EK1-AUFTRAG | 7000  | F1      | 15,00 | +4    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rahmenauftrag anlegen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RAHMEN_01"
And I append rows
    | artikel       | mge    | zraster  | zgltvon  | zgltbis  | einplan |
    | EK1-AUFTRAG   | 12000  | MONAT1   | 01.02.95 | 31.01.96 | ja      |
And I save the current editor

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 12 rows
Then table has values
    | bmge | bistmge | bmgeabweich  | status        | fix   |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Wertereihe im Rahmenauftrag bearbeiten
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_01"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
And I set field "bmge" to "1200" in row 1
Then field "status" has value "manuell" in row 1
And I set field "bmge" to "950" in row 2
Then field "status" has value "manuell" in row 1
And I respond with answer "ja" to the dialog with id "Wertereihen von Rahmenauftrag"
# in der GUI bekommt man keine Fehlermeldung, der Subeditor bleibt offen
Then saving the current editor throws the exception "2743"
Then field "bmge" has value "850" in row 12
Then table has values
    | bmge | bistmge | bmgeabweich  | status        | fix   |
    | 1200 |  0      | 1200         | manuell       | ja    |
    |  950 |  0      |  950         | manuell       | ja    |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    |  850 |  0      | 1000         | initialisiert | nein  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_01"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
And I set field "bmge" to "1200" in row 1
Then field "status" has value "manuell" in row 1
And I set field "bmge" to "800" in row 2
Then field "status" has value "manuell" in row 2
And I set field "bmge" to "1000" in row 12
Then field "status" has value "manuell" in row 12
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I set the fake date to "08.02.1995"

# Auftrag anlegen
Given I create a SalesOrder "auftrag01" for Customer "KUNDE1" with Product "EK1-AUFTRAG" and quantity "500"

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 12 rows
Then table has values
    | bmge | bistmge | bmgeabweich  | status  | fix |
    | 1200 |  0      | 1200         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 12 rows
Then table has values
    | bmge | bistmge | bmgeabweich  | status  | fix |
    | 1200 |  0      | 700          | manuell | ja  |
    |  800 |  0      | 800          | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Auftrag liefern
And I deliver the SalesOrder "auftrag01" with PackingSlip "LS-01"

# Wertereihe pruefen und Fortschrittszahl pruefen, Zeitraster nicht aenderbar
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
Then field "fzahl" has value "500" in row 1
Then field "zraster" is not modifiable in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich  | status  | fix |
    | 1200 |  500    | 700          | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I set the fake date to "06.03.1995"

# Lieferschein stornieren
And I reverse the PackingSlip "LS-01"

# Wertereihe pruefen und Fortschrittszahl pruefen, Zeitraster wieder aenderbar
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAHMEN_01"
Then field "fzahl" has value "0" in row 1
Then field "zraster" is modifiable in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich  | status  | fix |
    | 1200 |  0      | 700          | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Auftragsmenge reduzieren
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "auftrag01"
And I set field "mge" to "100" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich  | status  | fix |
    | 1200 |  0      | 1100         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Auftrag mit Haken Rahmenauftrag ignorieren
Given I create a SalesOrder "auftr_ign" for Customer "KUNDE1" with Product "EK1-AUFTRAG" and quantity "5000"

Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "auftr_ign"
And I set field "zignrahmen" to "ja" in row 1
And I save the current editor

# Auftrag fuer anderen Kunde wird nicht beruecksichtigt im Rahmen
Given I create a SalesOrder "auftr_abw" for Customer "KUNDE2" with Product "EK1-AUFTRAG" and quantity "200"

And I run Scheduling

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
Then field "fzahl" has value "0" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich  | status        | fix   |
    | 1200 |  0      | 1100         | manuell       | ja    |
    |  800 |  0      |  800         | manuell       | ja    |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | manuell       | ja    |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I deliver the SalesOrder "auftr_ign" with PackingSlip "LS-ign"

And I deliver the SalesOrder "auftr_abw" with PackingSlip "LS-abw"

# Wertereihe pruefen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
Then field "fzahl" has value "0" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich  | status        | fix   |
    | 1200 |  0      | 1100         | manuell       | ja    |
    |  800 |  0      |  800         | manuell       | ja    |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | initialisiert | nein  |
    | 1000 |  0      | 1000         | manuell       | ja    |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Lieferschein und dann Ruecklieferung
And I deliver the SalesOrder "auftrag01" with PackingSlip "LS-02"

# Wertereihe pruefen und Fortschrittszahl pruefen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
Then field "fzahl" has value "100" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich  | status  | fix |
    | 1200 |  100    | 1100         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I set the fake date to "05.04.1995"

# Ruecklieferung Teilmenge
Given I open an editor "Rueckliefer" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS-02"
And I set field "ueb" to "ja"
And I set field "such" to "RUECKLS-1"
And I set field "mge" to "-20" in row 1
And I save the current editor

# Wertereihe pruefen und Fortschrittszahl pruefen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAHMEN_01"
Then field "fzahl" has value "80" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | bmge | bistmge | bmgeabweich  | status  | fix |
    | 1200 |  80     | 1100         | manuell | ja  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 06 Absatzplanung und Wertereihe aus Rahmenauftrag

And I set the fake date to "15.01.1995"

# Artikel anlegen
Given I open an editor "E-Motor" from table "(Part):(Product)" with command "STORE" for record "E_MOTOR_PLAN"
And I set fields
    | such     | E_MOTOR_PLAN               |
    | namebspr | Elektromotor mit Planung   |
    | bsart    | Fremdbeschaffung           |
    | dispoa   | bedarfsbezogen             |
    | lief     | LIEFER1                    |
    | efrist   | 7                          |
    | epr      | 80                         |
And I save the current editor

# Anlieferung E_MOTOR_PLAN
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | LIEFER1       |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE1_scen05    |
    | budat    | .             |
And I append rows
    | artikel       | mge | preis | tterm   |
    | E_MOTOR_PLAN  | 35  | 80,00 | +4      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Zeitraster anlegen
Given I open an editor "ZeitrasterM" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such          | PL_MONAT      |
    | namebspr      | Plan Monat    |
    | zeiteinheit   | Monat         |
    | zefaktor      | 1             |
And I save the current editor

Given I open an editor "ZeitrasterW" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such          | PL_WOCHE      |
    | namebspr      | Plan Woche    |
    | zeiteinheit   | Woche         |
    | zefaktor      | 1             |
And I save the current editor

# Planungszeitraeume anlegen
Given I open an editor "Planungzeitraum1" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
    | such      | MONAT1993     |
    | namebspr  | Monat 1993    |
    | zraster   | PL_MONAT      |
    | vorgdat   | 1.1.93        |
    | dauer     |   12          |
And I save the current editor

Given I open an editor "Planungzeitraum2" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
    | such      | MONAT1994     |
    | namebspr  | Monat 1994    |
    | zraster   | PL_MONAT      |
    | vorgdat   | 1.1.94        |
    | dauer     |   12          |
And I save the current editor

Given I open an editor "Planungzeitraum3" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
    | such      | MONAT1995     |
    | namebspr  | Monat 1995    |
    | zraster   | PL_MONAT      |
    | vorgdat   | 1.1.95        |
    | dauer     |   12          |
And I save the current editor

# Rollierungszeitraeume anlegen
Given I open an editor "RollzeitraumM" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
    | such      | RMONAT1994            |
    | namebspr  | Monat Rollierung 1994 |
    | zraster   | PL_MONAT              |
    | vorgdat   | 1.11.94               |
    | dauer     |   12                  |
And I save the current editor

Given I open an editor "RollzeitraumW" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
    | such      | RWOCHE1994            |
    | namebspr  | Woche Rollierung 1994 |
    | zraster   | PL_WOCHE              |
    | vorgdat   | 1.11.94               |
    | dauer     |   4                   |
And I save the current editor

# rollierende Planung anlegen
Given I open an editor "RollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "NEW" for record ""
And I set fields
    | such          | ROLLPLAN          |
    | namebspr      | Rollierender Plan |
    | swprefix      | RP94              |
    | nametext      | Roll94            |
    | maxrabschn    |   1               |
    | aktrabschn    |   1               |
    | rollzraum1    | RMONAT1994        |
    | aktiv         | ja                |
And I save the current editor

# Planung anlegen
Given I open an editor "Planung1995" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
    | such          | PLAN1995          |
    | namebspr      | Planung fuer 1995 |
    | swprefix      | PL95              |
    | nametext      | Plan fuer 1995    |
    | vtabstufen    |   2               |
    | vtabzeilen    |  20               |
    | basiszraum    | MONAT1994         |
    | istzraum      | MONAT1995         |
    | planzraum     | MONAT1995         |
    | rollplanung   | ROLLPLAN          |
And I save the current editor

# Hauptplanungseinheit anlegen
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set fields
    | such          | HPL95         |
    | name          | HauptPE 1995  |
    | planung       | PLAN1995      |
    | artber        | E_MOTOR_PLAN  |
    | progtyp       | Mittelwert    |
    | zyklus        | 12            |
    | zeiteinheit   | Monat         |
    | zuwachsfakt   | 0             |
    | rundung       | 1             |
And I save the current editor

# Planung aktivieren
Given I open an editor "Planung1995" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN1995"
And I set field "aktiv" to "ja"
And I save the current editor

# Basisdaten erzeugen
Given I open an editor "Planung1995" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN1995"
And I press button "basiserz" to open a subeditor for "basisdaten"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

#Basismengen erfassen
Given I open an editor "Wertereihe" from table "(ValueSequence):(ValueSequence)" with command "UPDATE" for search criteria "$,,eplan=HPL95;artber=E_MOTOR_PLAN;typ=Basisdaten;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
And I modify table
    | !row  | mge   |
    | 1     | 50    |
    | 2     | 50    |
    | 3     | 50    |
    | 4     | 50    |
    | 5     | 50    |
    | 6     | 50    |
    | 7     | 50    |
    | 8     | 50    |
    | 9     | 50    |
    | 10    | 50    |
    | 11    | 50    |
And I save the current editor

# Plandaten erzeugen
Given I open an editor "Planung1995" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN1995"
And I press button "planerz" to open a subeditor for "plandaten"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Bedarfsplanung erzeugen
Given I open an editor "Planung1995" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN1995"
And I press button "bedarfplerz" to open a subeditor for "bedarfsplanung"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Rollieren
Given I open an editor "RollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "."
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Wertereihe der Absatzplanung ist angelegt

# Rahmen anlegen
Given I open an editor "RahmenK1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1        |
    | such  | EM_KUNDE1     |
    | vom   | .             |
And I append rows
    | artikel       | mge    | preis    | zraster   | zgltvon  | zgltbis  | einplan | rundung |
    | E_MOTOR_PLAN  | 120    | 115      | MONAT1    | 15.01.95 | 31.12.95 | ja      |  1      |
And I save the current editor

Given I wait 1 time units to move the time forward

Given I open an editor "RahmenK2" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE2        |
    | such  | EM_KUNDE2     |
    | vom   | .             |
And I append rows
    | artikel       | mge    | preis    | zraster   | zgltvon  | zgltbis  | einplan | rundung |
    | E_MOTOR_PLAN  | 240    | 110      | MONAT1    | 15.01.95 | 31.12.95 | ja      |  1      |
And I save the current editor

Given I wait 1 time units to move the time forward

# Rahmen anlegen, der nicht eingeplant wird
Given I open an editor "Rahmennoeinplan" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde | MERT      |
    | such  | NOEINPLAN |
    | vom   | .         |
And I append rows
    | artikel       | mge    | preis    |
    | E_MOTOR_PLAN  | 100    | 130      |
And I save the current editor

Given I wait 1 time units to move the time forward

# Auftrag anderer Kunde ohne Rahmen
Given I open an editor "auftrag01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | TEST      |
    | such  | A01_TEST  |
    | vom   | .         |
And I append rows
    | artikel       | mge   | preis | tterm    | einplan |
    | E_MOTOR_PLAN  |  7    |   115 | 15.02.95 |  ja     |
And I save the current editor

Given I wait 1 time units to move the time forward

# Auftrag Rahmen-Kunde1
Given I open an editor "auftrag02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1    |
    | such  | A02_KD1   |
    | vom   | .         |
And I append rows
    | artikel       | mge   | preis | tterm    | einplan |
    | E_MOTOR_PLAN  |  8    |   115 | 18.01.95 |  ja     |
And I save the current editor

Given I wait 1 time units to move the time forward

# Auftrag Rahmen-Kunde2
Given I open an editor "auftrag03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE2    |
    | such  | A03_KD2   |
    | vom   | .         |
And I append rows
    | artikel       | mge   | preis | tterm    | einplan |
    | E_MOTOR_PLAN  |  12   |   115 | 25.01.95 |  ja     |
And I save the current editor

Given I wait 1 time units to move the time forward

# Auftrag aus Rahmen ohne Wertereihe, durch Beleg anfuegen
Given I open an editor "auftrag04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmennoeinplan^id |
    | such  | A04_MERT            |
    | vom   | .                   |
And I modify table
    | !row | mge | wtterm   |
    | 1    | 2   | 07.02.95 |
Then field "zrahmen" has value "!Rahmennoeinplan^nummer" in row 1
And I save the current editor

Given I wait 1 time units to move the time forward

# Rahmen EK anlegen
Given I open an editor "RahmenEK" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | lief  | LIEFER1   |
    | such  | RA_MOTOR  |
    | vom   | .         |
And I append rows
    | artikel       | mge    | preis    | zraster   | zgltvon  | zgltbis  | einplan |
    | E_MOTOR_PLAN  | 1500   | 70       | MONAT1    | 15.01.95 | 31.12.95 | ja      |
And I save the current editor

And I run Scheduling

# LS zu den Aufträgen und die Istmengen prüfen

And I deliver the SalesOrder "auftrag01" with PackingSlip "LS-TEST"

And I deliver the SalesOrder "auftrag02" with PackingSlip "LS-KUNDE1"

And I deliver the SalesOrder "auftrag03" with PackingSlip "LS-KUNDE2"

And I deliver the SalesOrder "auftrag04" with PackingSlip "LS-MERT"

# Dispo laufen lassen, damit auch bmgeabweich in der Wertereihe der Absatzplanung angepasst wird
And I run Scheduling

# Istmengen prüfen in den Wertereihen
Given I open an editor "RahmenK1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "EM_KUNDE1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bpreis    | bistmge | bmgeabweich | status        | fix   |
    | 15.01.1995 | 14.02.1995|  10  | 115.0000  |  8      |    2        | initialisiert | nein  |
    | 15.02.1995 | 14.03.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.03.1995 | 14.04.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.04.1995 | 14.05.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.05.1995 | 14.06.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.06.1995 | 14.07.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.07.1995 | 14.08.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.08.1995 | 14.09.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.09.1995 | 14.10.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.10.1995 | 14.11.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.11.1995 | 14.12.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.12.1995 | 31.12.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "RahmenK2" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "EM_KUNDE2"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bpreis    | bistmge | bmgeabweich | status        | fix   |
    | 15.01.1995 | 14.02.1995|  20  | 110.0000  |  12     |     8       | initialisiert | nein  |
    | 15.02.1995 | 14.03.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.03.1995 | 14.04.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.04.1995 | 14.05.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.05.1995 | 14.06.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.06.1995 | 14.07.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.07.1995 | 14.08.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.08.1995 | 14.09.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.09.1995 | 14.10.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.10.1995 | 14.11.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.11.1995 | 14.12.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.12.1995 | 31.12.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Wertereihe zur Absatzplanung, beginnt am 15.01., hat aber Planungszeitraum der immer zum 1. beginnt
# Istmenge pruefen, Auftraege ohne dispositiven Rahmen 7 und 2
Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "VIEW" for search criteria "$,,artber=E_MOTOR_PLAN;rahmenpos=`;typ=82;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
    | vondat     | bisdat    | bmge | bpreis | bistmge | bmgeabweich | status      | fix    |
    | 15.01.1995 | 31.01.1995|  29  | 0.0000 |  9      |    20       | automatisch | nein   |
    | 01.02.1995 | 28.02.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.03.1995 | 31.03.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.04.1995 | 30.04.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.05.1995 | 31.05.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.06.1995 | 30.06.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.07.1995 | 31.07.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.08.1995 | 31.08.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.09.1995 | 30.09.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.10.1995 | 31.10.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.11.1995 | 30.11.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.12.1995 | 31.12.1995|   0  | 0.0000 |  0      |     0       | automatisch | nein   |
And I close the current editor

## vor dem Rollieren das fake date in anderen Monat setzen
And I set the fake date to "01.02.1995"

# Rollieren
Given I open an editor "RollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "01.02.95"
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

## vor dem Storno das fake date in anderen Monat setzen
And I set the fake date to "15.02.1995"

# Lieferscheine stornieren
And I reverse the PackingSlip "LS-TEST"

And I reverse the PackingSlip "LS-KUNDE1"

And I reverse the PackingSlip "LS-KUNDE2"

And I reverse the PackingSlip "LS-MERT"

And I run Scheduling

# Istmengen prüfen in den Wertereihen, keine gelieferte Menge mehr und Auftrag wieder offen
Given I open an editor "RahmenK1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "EM_KUNDE1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bpreis    | bistmge | bmgeabweich | status        | fix   |
    | 15.01.1995 | 14.02.1995|  10  | 115.0000  |  0      |    2        | initialisiert | nein  |
    | 15.02.1995 | 14.03.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.03.1995 | 14.04.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.04.1995 | 14.05.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.05.1995 | 14.06.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.06.1995 | 14.07.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.07.1995 | 14.08.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.08.1995 | 14.09.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.09.1995 | 14.10.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.10.1995 | 14.11.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.11.1995 | 14.12.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
    | 15.12.1995 | 31.12.1995|  10  | 115.0000  |  0      |    10       | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "RahmenK2" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "EM_KUNDE2"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bpreis    | bistmge | bmgeabweich | status        | fix   |
    | 15.01.1995 | 14.02.1995|  20  | 110.0000  |  0      |     8       | initialisiert | nein  |
    | 15.02.1995 | 14.03.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.03.1995 | 14.04.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.04.1995 | 14.05.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.05.1995 | 14.06.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.06.1995 | 14.07.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.07.1995 | 14.08.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.08.1995 | 14.09.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.09.1995 | 14.10.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.10.1995 | 14.11.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.11.1995 | 14.12.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
    | 15.12.1995 | 31.12.1995|  20  | 110.0000  |  0      |    20       | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# archivierte Daten prüfen, es wurde rolliert mit Datum 01.02.95
# Istmenge wieder auf 0 gesetzt nach Storno und offene Auftragsmenge in offenen Zeitraum verrechnen
Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "VIEW" for search criteria "$,,artber=E_MOTOR_PLAN;rahmenpos=`;archiv=ja;typ=(RollingForecast);@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
    | vondat     | bisdat    | bmge | bpreis | bistmge | bmgeabweich | status      | fix    |
    | 15.01.1995 | 31.01.1995|  29  | 0.0000 |  0      |    29       | automatisch | nein   |
And I close the current editor

## es wurde rolliert mit Datum 01.02.95
## nicht archivierte Daten prüfen
# geliefert wurden nichts, Auftraege wieder offen nach Storno (7 aus Auftrag ohne Rahmen und 2 aus Auftrag zum nicht dispostiven Rahmen)
Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "VIEW" for search criteria "$,,artber=E_MOTOR_PLAN;rahmenpos=`;archiv=nein;typ=(RollingForecast);@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
    | vondat     | bisdat    | bmge | bpreis | bistmge | bmgeabweich | status      | fix    |
    | 01.02.1995 | 28.02.1995|  50  | 0.0000 |  0      |    41       | automatisch | nein   |
    | 01.03.1995 | 31.03.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.04.1995 | 30.04.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.05.1995 | 31.05.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.06.1995 | 30.06.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.07.1995 | 31.07.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.08.1995 | 31.08.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.09.1995 | 30.09.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.10.1995 | 31.10.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.11.1995 | 30.11.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
    | 01.12.1995 | 31.12.1995|   0  | 0.0000 |  0      |     0       | automatisch | nein   |
    | 01.01.1996 | 31.01.1996|   0  | 0.0000 |  0      |     0       | initialisiert | nein |
And I close the current editor

############# ab hier funktioniert es nicht, Verrechnung der stornierten Mengen und der rückgelieferten Mengen

## Rücklieferschein zu Auftrag Absatzplanung auch testen, bei Rahmen geht es schon
## das ist ein Fall für Frauke, Dispo errechnet bmgeabweich, bistmge bezieht sich auf die Buchungen

#Given I wait 1 time units to move the time forward
#
#And I deliver the SalesOrder "auftrag01" with PackingSlip "LS2-TEST"
#
### vor der Rücklieferung das fake date in einen anderen Monat setzen
#And I set the fake date to "05.03.1995"
#
## Ruecklieferung Teilmenge
#Given I open an editor "Rueckliefer" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS2-TEST"
#And I set field "ueb" to "ja"
#And I set field "such" to "RLS1-TEST"
#And I set field "mge" to "-3" in row 1
#And I save the current editor
#
## Dispo laufen lassen, damit auch bmgeabweich in der Wertereihe der Absatzplanung angepasst wird
#And I run Scheduling
#
### es wurde rolliert mit Datum 01.02.95
## geliefert wurden 4 (7 abzgl 3 RLS) und noch offen sind 2 aus anderem Auftrag
#
## archivierte Daten pruefen, 3 aus RLS mit bistmge verrechnet
#Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "VIEW" for search criteria "$,,artber=E_MOTOR_PLAN;rahmenpos=`;archiv=ja;typ=(RollingForecast);@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
#Then table has values
#   | vondat     | bisdat    | bmge | bpreis | bistmge | bmgeabweich | status      | fix    |
#   | 15.01.1995 | 31.01.1995|  29  | 0.0000 |  0      |    29       | automatisch | nein   |
#   | 01.02.1995 | 28.02.1995|  50  | 0.0000 |  4      |    44       | automatisch | nein   |
#And I close the current editor
#
## nicht archivierte Daten pruefen, noch 2 aus Auftrag offen
#Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=E_MOTOR_PLAN;rahmenpos=`;archiv=nein;typ=(RollingForecast);@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
#Then table has values
#   | vondat     | bisdat    | bmge | bpreis | bistmge | bmgeabweich | status      | fix    |
#   | 01.03.1995 | 31.03.1995|  50  | 0.0000 |  0      |    48       | automatisch | nein   |
#   | 01.04.1995 | 30.04.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
#   | 01.05.1995 | 31.05.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
#   | 01.06.1995 | 30.06.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
#   | 01.07.1995 | 31.07.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
#   | 01.08.1995 | 31.08.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
#   | 01.09.1995 | 30.09.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
#   | 01.10.1995 | 31.10.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
#   | 01.11.1995 | 30.11.1995|  50  | 0.0000 |  0      |    50       | automatisch | nein   |
#   | 01.12.1995 | 31.12.1995|   0  | 0.0000 |  0      |     0       | automatisch | nein   |
#   | 01.01.2096 | 31.01.2096|   0  | 0.0000 |  0      |     0       | initialisiert | nein |
#And I close the current editor


## folgende Szenarien mit sofort abrufbarer Menge im Rahmenauftrag

Scenario: 07 Rahmenauftrag mit sofort abrufbarer Menge

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "VERFUEGBAR"
And I set fields
    | such     | VERFUEGBAR                 |
    | namebspr | sofort verfuegbare Menge   |
    | bsart    | Fremdbeschaffung           |
    | dispoa   | bedarfsbezogen             |
    | lief     | LIEFER1                    |
    | efrist   | 30                         |
    | bfrist   | 30                         |
    | epr      | 50                         |
And I save the current editor

# Rahmen mit sofort abrufbarer Menge anlegen
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "R_VERFUEG"
And I append rows
    | artikel    | mge   | zraster  | zgltvon  | zgltbis  | einplan | rundung | verfuegbmge | lfristkurz    | lzeit |
    | VERFUEGBAR | 50    | MONAT1   | 01.02.95 | 30.11.95 | ja      |  1      |   10        |  3            |  15           |
And I save the current editor

Given I wait 1 time units to move the time forward

# Bestand zubuchen durch EK-Rechnung
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | LIEFER1       |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE1_scen07    |
    | budat    | .             |
And I append rows
    | artikel       | mge | preis | tterm   |
    | VERFUEGBAR    | 15  | 50,00 | +4      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Scheduling

And I set the fake date to "06.02.1995"

# Auftrag anlegen für anderen Kunde
Given I open an editor "AUF01_KD2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE2    |
    | such  | AUF01_KD2 |
    | vom   | .         |
And I append rows
    | artikel       | mge   | wtterm | einplan |
    | VERFUEGBAR    |  8    | +2     |  ja     |
Then field "zrahmen" is empty in row 1
And I save the current editor

And I run Scheduling

# Zuordnung prüfen, editierbare Plankarte, Rahmen bekommt 10 vom Lager, Auftrag nur 5
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "VERFUEGBAR"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | fix   | kres^id       | bobart    |
    |    15     |   5       |   5       | ja    | !Rahmen^id    | Lager     |
    |    15     |   5       |   8       | nein  | !AUF01_KD2^id | Lager     |
    |    15     |   5       |   5       | ja    | !Rahmen^id    | Lager     |
And I close the current editor

Given I wait 1 time units to move the time forward

# Auftrag aus Rahmen durch Beleg anfuegen
Given I open an editor "AUF01_RA" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen^id |
    | such  | AUF01_RA   |
    | vom   | .          |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 10  | +3       |  ja     |
And I save the current editor

And I run Scheduling

# editierbare Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "VERFUEGBAR"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    15     |   5       |   8       | !AUF01_KD2^id | Lager     |
    |    15     |   10      |   10      | !AUF01_RA^id  | Lager     |
And I close the current editor

# Auftragsmenge reduzieren, damit noch sofort abrufbare Menge frei
Given I open an editor "AUF01_RA" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF01_RA"
And I set field "mge" to "7" in row 1
And I save the current editor

Given I wait 1 time units to move the time forward

# weiteren Auftrag zum Rahmen, noch 3 sofort abrufbare Menge
Given I open an editor "AUF02_RA" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE1 |
    | such  | AUF02_RA   |
    | vom   | .          |
And I append rows
    | artikel       | mge | wtterm   | einplan |
    | VERFUEGBAR    | 3   | +15     |  ja     |
#   | VERFUEGBAR    | 2   | +20     |  ja     |
And I save the current editor

And I run Scheduling

# editierbare Plankarte prüfen
# 7 und 3 sofort abrufbar, falls Position 2 erfasst wird, diese bekommt keinen Lagerbestand
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "VERFUEGBAR"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    15     |   5       |   8       | !AUF01_KD2^id | Lager     |
    |    15     |   7       |   7       | !AUF01_RA^id  | Lager     |
    |    15     |   3       |   3       | !AUF02_RA^id  | Lager     |
And I close the current editor


## Verfügbarkeitsprüfung testen, nur wenn Auftrag über mehr als 3 erstellt wird
## sofort abrufbare Menge noch 3 offen
#Given I open an editor "AUF02_RA" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF02_RA"
#And I press button "verfuegpruef" to open a subeditor for "verfuegpruefung" in row 1
#Then table has values
#   | tnterm    | nmge  | bobart        |
#   | 15.02.95  | 3     | Lager         |
#   | 29.03.95  | 2     | Beschaffung   |
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor


Scenario: 08 Zuordnung Lagerbestand Aufträge mit und ohne Rahmenbezug, Zuordnung nach manueller Abgangsbuchung

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "SOFORT"
And I set fields
    | such     | SOFORT                     |
    | namebspr | sofort verfuegbare Menge   |
    | bsart    | Fremdbeschaffung           |
    | dispoa   | bedarfsbezogen             |
    | lief     | LIEFER1                    |
    | efrist   | 30                         |
    | bfrist   | 30                         |
    | epr      | 50                         |
And I save the current editor

# VK Rahmen anlegen, das sind dann 12 Einteilungen mit 50 und sofort 100
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_SOFORT"
And I append rows
    | artikel    | mge   | zraster  | zgltvon  | zgltbis  | einplan | rundung | verfuegbmge | lfristkurz    | lzeit |
    | SOFORT     | 600   | WOCHE1   | 17.04.95 | 07.07.95 | ja      |  1      |   100       |  3            |  15           |
And I save the current editor

And I run Scheduling

# Bestellvorschläge freigeben
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "SOFORT"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# das ist dann eine Bestellung mit 50 Stück

Given I open an editor "EK-Liefer" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE01"
And I set fields
    | ebeleg    | LS_BE01   |
    | vom       |  .        |
    | ueb       | ja        |
And I set field "mge" to "50" in row 1
And I save the current editor

# Bestellvorschläge freigeben
Given I open an editor "BV02" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "SOFORT"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE02"
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# das ist dann eine Bestellung mit 50 Stück

Given I open an editor "EK-Liefer" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE02"
And I set fields
    | ebeleg    | LS_BE02   |
    | vom       |  .        |
    | ueb       | ja        |
And I set field "mge" to "50" in row 1
And I save the current editor
# jetzt sind 100 Stk an Lager

# Bestellvorschläge freigeben
Given I open an editor "BV03" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "SOFORT"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "BE03"
And I save the current subeditor to switch back to the parent editor
And I close the current editor
# das ist dann eine Bestellung mit 50 Stück

And I run Scheduling

And I set the fake date to "17.04.1995"

# Auftrag anlegen für anderen Kunde
Given I open an editor "AUF_KD2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE2    |
    | such  | AUF_KD2   |
    | vom   | .         |
And I append rows
    | artikel   | mge   | wtterm | einplan |
    | SOFORT    |  45   | +2     |  ja     |
Then field "zrahmen" is empty in row 1
And I save the current editor

And I run Scheduling

Given I wait 1 time units to move the time forward

# Auftrag aus Rahmen durch Beleg anfuegen, Menge = sofort abrufbare Menge
Given I open an editor "AUF1_RA" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen^id |
    | such  | AUF1_RA    |
    | vom   | .          |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 100 | +3       |  ja     |
And I save the current editor

And I run Scheduling

Given I wait 1 time units to move the time forward

# weiterer Auftrag aus Rahmen, sofort abrufbare Menge ist ausgeschöpft
Given I open an editor "AUF2_RA" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen^id |
    | such  | AUF2_RA    |
    | vom   | .          |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 20  | +5       |  ja     |
And I save the current editor
## wtterm später, als im ersten Auftrag

# weitere Anlieferung, Menge erhöhen
Given I open an editor "EK-Liefer" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE03"
And I set fields
    | ebeleg    | LS_BE03   |
    | vom       |  .        |
    | ueb       | ja        |
And I set field "mge" to "65" in row 1
And I save the current editor
# jetzt sind 165 Stk an Lager, reicht für alle 3 Aufträge

And I run Scheduling

Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "SOFORT"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    165    |   45      |   45      | !AUF_KD2^id   | Lager     |
    |    165    |  100      |  100      | !AUF1_RA^id   | Lager     |
    |    165    |   20      |   20      | !AUF2_RA^id   | Lager     |
And I close the current editor

# manuelle Abgangsbuchung
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | SOFORT  |
    | beleg   | SCEN08  |
    | beldat  |  .      |
    | buart   | Abgang  |
And I append rows
    | mge | platz   |
    | 20  | F1      |
And I save the current editor

And I run Scheduling

# zweiter Auftrag zum Rahmen bekommt keinen Bestand, da sofort abrufbare Menge überschritten und Auftrag anderer Kunde vorher eingeplant wurde
# editierbare Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "SOFORT"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    145    |   45      |   45      | !AUF_KD2^id   | Lager     |
    |    145    |  100      |  100      | !AUF1_RA^id   | Lager     |
And I close the current editor


Scenario: 09 Restmenge im Rahmen ist kleiner als sofort abrufbare Menge

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "VERFUEGREST"
And I set fields
    | such     | VERFUEGREST                    |
    | namebspr | sofort verfuegbare Restmenge   |
    | bsart    | Fremdbeschaffung               |
    | dispoa   | bedarfsbezogen                 |
    | lief     | LIEFER1                        |
    | efrist   | 150                            |
    | bfrist   | 150                            |
    | epr      | 50                             |
And I save the current editor

# Rahmen mit sofort abrufbarer Menge anlegen
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_REST"
And I append rows
    | artikel     | mge  | zraster  | zgltvon  | zgltbis  | einplan | rundung | verfuegbmge |  lfristkurz   |
    | VERFUEGREST | 600  | MONAT1   | 01.02.95 | 31.07.95 | ja      |  1      |   150       |     5         |
And I save the current editor

# Bestand zubuchen durch EK-Rechnung
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | LIEFER1       |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE1_scen09    |
    | budat    | .             |
And I append rows
    | artikel       | mge | preis | tterm   |
    | VERFUEGREST   | 650 | 50,00 | +4      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Scheduling

And I set the fake date to "06.02.1995"

# Auftrag aus Rahmen durch Beleg anfuegen
Given I open an editor "AUF09" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen^id |
    | such  | AUF09  |
    | vom   | .          |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 500 | +3       |  ja     |
And I set field "verwendlfristkurz" to "nein" in row 1
And I save the current editor

# Auftrag liefern
And I deliver the SalesOrder "AUF09" with PackingSlip "LS-AUF09"

Given I wait 1 time units to move the time forward

# Auftrag anlegen für anderen Kunde
Given I open an editor "AUF_KD2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE2    |
    | such  | AUF_KD2   |
    | vom   | .         |
And I append rows
    | artikel       | mge   | wtterm        | einplan |
    | VERFUEGREST   |  70   | 01.07.1995    |  ja     |
Then field "zrahmen" is empty in row 1
And I save the current editor

And I run Scheduling

# Zuordnung prüfen, editierbare Plankarte
# Rest an Lager 150, sofort abrufbar 150, Restmenge Rahmen 100, deshalb nur noch 100 für Rahmen und 50 für Auftrag anderer Kunde
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "VERFUEGREST"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    150    |    50     |    70     | !AUF_KD2^id   | Lager     |
    |    150    |   100     |   100     | !Rahmen^id    | Lager     |
And I close the current editor


Scenario: 10 Rahmen mit sofort abrufbare Menge, mehrere Abrufe und andere Bedarfe, Zeitverlauf durch fake date

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "RAHMEN20"
And I set fields
    | such     | RAHMEN20           |
    | namebspr | Planmenge 20       |
    | bsart    | Fremdbeschaffung   |
    | dispoa   | bedarfsbezogen     |
    | lief     | LIEFER1            |
    | efrist   | 30                 |
    | bfrist   | 30                 |
    | epr      | 50                 |
And I save the current editor

# Rahmen mit sofort abrufbarer Menge anlegen
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_PLAN20"
And I append rows
    | artikel    | mge   | zraster  | zgltvon  | zgltbis  | einplan | rundung | verfuegbmge |  lfristkurz   |
    | RAHMEN20   | 120   | MONAT1   | 01.03.95 | 30.08.95 | ja      |  1      |   40        |     15            |
And I save the current editor

# Bestand zubuchen durch EK-Rechnung
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | LIEFER1       |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE1_scen10    |
    | budat    | .             |
And I append rows
    | artikel   | mge | preis | tterm   |
    | RAHMEN20  |  50 | 50,00 | +4      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Scheduling

# Plankarte prüfen
## alle 50 Stück dem Rahmen zugeordnet, 40 sind fixiert, Zeitraum 1 und 2
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    50     |    20     |    20     | !Rahmen^id    | Lager     |
    |    50     |    20     |    20     | !Rahmen^id    | Lager     |
    |    50     |    10     |    20     | !Rahmen^id    | Lager     |
And I close the current editor

And I set the fake date to "06.03.1995"

# Auftrag aus Rahmen durch Beleg anfuegen
Given I open an editor "AUF_RA10" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen^id |
    | such  | AUF_RA10   |
    | vom   | .          |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 40  | +3       |  ja     |
And I save the current editor

And I run Scheduling

# Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    50     |    40     |    40     | !AUF_RA10^id  | Lager     |
    |    50     |    10     |    20     | !Rahmen^id    | Lager     |
And I close the current editor

# Auftrag liefern
And I deliver the SalesOrder "AUF_RA10" with PackingSlip "LS-RA10"

And I run Scheduling

# BV prüfen, sind vorgezogen um 40 sofort abrufbar wieder aufzufüllen
# Bestellvorschläge prüfen
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    |  mge  | wtterm    |
    | 10    | 10.04.95  |
    | 20    | 10.04.95  |
    | 20    | 30.06.95  |
    | 20    | 01.08.95  |
And I close the current editor

Given I wait 1 time units to move the time forward

# Bestellvorschläge freigeben, 10 und 20 zum 10.04. zusammenfassen
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I set field "mge" to "30" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "EKBE01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

And I set the fake date to "13.03.1995"

# Auftrag anlegen für anderen Kunde
Given I open an editor "AUF1_KD2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE2    |
    | such  | AUF1_KD2  |
    | vom   | .         |
And I append rows
    | artikel   | mge   | wtterm        | einplan |
    | RAHMEN20  |  15   | 27.03.1995    |  ja     |
Then field "zrahmen" is empty in row 1
And I save the current editor

And I run Scheduling

# Plankarte prüfen, Auftrag anderer Kunde bekommt neue Beschaffung
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    |kbs^such   | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart     |
    |           |    10     |    10     |    20     | !Rahmen^id    | Lager      |
    |           |           |           |           | (0,0,0)       | --         |
    | EKBE01    |    30     |    10     |    20     | !Rahmen^id    | Bestellung |
    | EKBE01    |    30     |    20     |    20     | !Rahmen^id    | Bestellung |
    |           |           |           |           | (0,0,0)       | --         |
    |           |    15     |    15     |    15     | !AUF1_KD2^id  | Bestellung |
And I close the current editor

Given I wait 1 time units to move the time forward

# Bestellvorschläge freigeben, 15 zum 13.04.
Given I open an editor "BV02" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then field "mge" has value "15" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "EKBE02"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

# Plankarte prüfen, Auftrag anderer Kunde bekommt neue Bestellung
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    |kbs^such   | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart     |
    |           |    10     |    10     |    20     | !Rahmen^id    | Lager      |
    |           |           |           |           | (0,0,0)       | --         |
    | EKBE01    |    30     |    10     |    20     | !Rahmen^id    | Bestellung |
    | EKBE01    |    30     |    20     |    20     | !Rahmen^id    | Bestellung |
    |           |           |           |           | (0,0,0)       | --         |
    | EKBE02    |    15     |    15     |    15     | !AUF1_KD2^id  | Bestellung |
And I close the current editor

And I set the fake date to "13.04.1995"

# Auftrag aus Rahmen durch Beleg anfuegen
Given I open an editor "AUF_RA11" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen^id |
    | such  | AUF_RA11   |
    | vom   | .          |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 20  | +3       |  ja     |
And I save the current editor

And I run Scheduling

# Plankarte prüfen, Auftrag aus Rahmen soll Lager und Bestellung EKBE01 zugeordnet haben
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    |kbs^such   | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart     |
    |           |    10     |    10     |    20     | !AUF_RA11^id  | Lager      |
    |           |           |           |           | (0,0,0)       | --         |
    | EKBE01    |    30     |    10     |    20     | !AUF_RA11^id  | Bestellung |
    | EKBE01    |    30     |    20     |    20     | !Rahmen^id    | Bestellung |
    |           |           |           |           | (0,0,0)       | --         |
    | EKBE02    |    15     |    15     |    15     | !AUF1_KD2^id  | Bestellung |
And I close the current editor

# Bestand zubuchen, Bestellung liefern
Given I open an editor "EK-Liefer" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBE01"
And I set fields
    | ebeleg    | LS_EKBE01 |
    | vom       |  .        |
    | ueb       | ja        |
And I press button "offueb" in row 1
And I save the current editor

And I run Scheduling

# Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    40     |    20     |    20     | !AUF_RA11^id  | Lager     |
    |    40     |    20     |    20     | !Rahmen^id    | Lager     |
And I close the current editor

# Bestand zubuchen, weitere Bestellung liefern
Given I open an editor "EK-Liefer" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBE02"
And I set fields
    | ebeleg    | LS_EKBE02 |
    | vom       |  .        |
    | ueb       | ja        |
And I press button "offueb" in row 1
And I save the current editor

And I run Scheduling

# Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    55     |    15     |    15     | !AUF1_KD2^id  | Lager     |
    |    55     |    20     |    20     | !AUF_RA11^id  | Lager     |
    |    55     |    20     |    20     | !Rahmen^id    | Lager     |
And I close the current editor

# Auftrag liefern
And I deliver the SalesOrder "AUF_RA11" with PackingSlip "LS-RA11"

# Auftrag liefern
And I deliver the SalesOrder "AUF1_KD2" with PackingSlip "LS-AUF1"

# Auftrag anlegen für anderen Kunde
Given I open an editor "AUF2_KD2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE2    |
    | such  | AUF2_KD2  |
    | vom   | .         |
And I append rows
    | artikel   | mge   | wtterm        | einplan |
    | RAHMEN20  |  5    | 30.04.1995    |  ja     |
Then field "zrahmen" is empty in row 1
And I save the current editor

And I run Scheduling

# Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart     |
    |    20     |    20     |    20     | !Rahmen^id    | Lager      |
    |           |           |           | (0,0,0)       | --         |
    |    5      |    5      |     5     | !AUF2_KD2^id  | Bestellung |
And I close the current editor

# Bestellvorschläge prüfen, 20 um sofort abrufbar wieder aufzufüllen und 5 für anderen Auftrag
Given I open an editor "BV01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    |  mge  | wtterm    |
    | 20    | 23.05.95  |
    |  5    | 23.05.95  |
    | 20    | 01.08.95  |
And I close the current editor

Given I wait 1 time units to move the time forward

# Bestellvorschläge freigeben, 5 und 20 zum 23.05. zusammenfassen
Given I open an editor "BV03" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 2
And I set field "mge" to "25" in row 2
And I press button "freig" to open a subeditor for "BV_freigeben"
And I set field "such" to "EKBE03"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

# Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart     |
    |    20     |    20     |    20     | !Rahmen^id    | Lager      |
    |           |           |           | (0,0,0)       | --         |
    |    25     |    5      |     5     | !AUF2_KD2^id  | Bestellung |
    |    25     |    20     |    20     | !Rahmen^id    | Bestellung |
And I close the current editor

And I set the fake date to "12.05.1995"

# Auftrag aus Rahmen durch Beleg anfuegen
Given I open an editor "AUF_RA12" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen^id |
    | such  | AUF_RA12   |
    | vom   | .          |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 20  | +3       |  ja     |
And I save the current editor

And I run Scheduling

# Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart     |
    |    20     |    20     |    20     | !AUF_RA12^id  | Lager      |
    |           |           |           | (0,0,0)       | --         |
    |    25     |    5      |     5     | !AUF2_KD2^id  | Bestellung |
    |    25     |    20     |    20     | !Rahmen^id    | Bestellung |
And I close the current editor

# Auftrag anlegen für anderen Kunde
Given I open an editor "AUF3_KD2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDE2    |
    | such  | AUF3_KD2  |
    | vom   | .         |
And I append rows
    | artikel   | mge   | wtterm        | einplan |
    | RAHMEN20  |  5    | 25.05.1995    |  ja     |
Then field "zrahmen" is empty in row 1
And I save the current editor

And I run Scheduling

# Plankarte prüfen
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart     |
    |    20     |    20     |    20     | !AUF_RA12^id  | Lager      |
    |           |           |           | (0,0,0)       | --         |
    |    25     |     5     |     5     | !AUF2_KD2^id  | Bestellung |
    |    25     |    20     |    20     | !Rahmen^id    | Bestellung |
    |           |           |           | (0,0,0)       | --         |
    |     5     |    5      |     5     | !AUF3_KD2^id  | Bestellung |
And I close the current editor

And I set the fake date to "22.05.1995"

# Bestand zubuchen, weitere Bestellung liefern
Given I open an editor "EK-Liefer" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBE03"
And I set fields
    | ebeleg    | LS_EKBE03 |
    | vom       |  .        |
    | ueb       | ja        |
And I press button "offueb" in row 1
And I save the current editor

And I run Scheduling

# Zuordnung prüfen, editierbare Plankarte
Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "RAHMEN20"
And I press button "ladetab"
Then table has values
    | bsnlimge  | lzuomge   | rlimge    | kres^id       | bobart    |
    |    45     |    5      |     5     | !AUF2_KD2^id  | Lager     |
    |    45     |    20     |    20     | !AUF_RA12^id  | Lager     |
    |    45     |    20     |    20     | !Rahmen^id    | Lager     |
    |           |           |           | (0,0,0)       | --         |
    |     5     |    5      |     5     | !AUF3_KD2^id  | Bestellung |
And I close the current editor


Scenario: 11 Rahmenauftrag mit sofort abrufbarer Menge, Losgröße im Artikelstamm

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "LOSGROESSE"
And I set fields
    | such      | LOSGROESSE                |
    | namebspr  | Losgroesse kleiner sofort |
    | bsart     | Fremdbeschaffung          |
    | dispoa    | bedarfsbezogen            |
    | losgr     | 150                       |
    | lief      | LIEFER1                   |
    | efrist    | 30                        |
    | bfrist    | 30                        |
    | epr       | 50                        |
And I save the current editor

# Rahmen mit sofort abrufbarer Menge anlegen
Given I open an editor "RahmenL" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_LOSGR"
And I append rows
    | artikel    | mge   | zraster  | zgltvon  | zgltbis  | einplan | rundung | verfuegbmge | lfristkurz    | lzeit |
    | LOSGROESSE | 1200  | MONAT1   | 01.02.95 | 31.01.96 | ja      |  1      |   250       |  3            |  15           |
And I save the current editor

# Bestand zubuchen durch EK-Rechnung
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | LIEFER1       |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE1_scen11    |
    | budat    | .             |
And I append rows
    | artikel       | mge | preis | tterm   |
    | LOSGROESSE    | 250 | 50,00 | +4      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I run Scheduling

And I set the fake date to "06.02.1995"

# Auftrag aus Rahmen durch Beleg anfuegen
Given I open an editor "AUF11_RA" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !RahmenL^id |
    | such  | AUF11_RA    |
    | vom   | .           |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 250 | +3       |  ja     |
And I save the current editor

Given I open an editor "AUF12_RA" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !RahmenL^id |
    | such  | AUF12_RA    |
    | vom   | .           |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 250 | +30      |  ja     |
And I save the current editor

And I run Scheduling

# Plankarte prüfen
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "LOSGROESSE"
And I press start
Then table has values
    | zugang    | abgang    | vart              | vkopf^id      |
    |    250    |           | Lager             | (0,0,0)       |
    |           |   250     | Auftrag           | !AUF11_RA^id  |
    |           |   250     | Auftrag           | !AUF12_RA^id  |
    |    300    |           | Fremdbeschaffung  | (0,0,0)       |
    |    150    |           | Fremdbeschaffung  | (0,0,0)       |
    |           |  100      | Rahmenauftrag     | !RahmenL^id   |
    |           |  100      | Rahmenauftrag     | !RahmenL^id   |
    |    150    |           | Fremdbeschaffung  | (0,0,0)       |
    |           |  100      | Rahmenauftrag     | !RahmenL^id   |
    |    150    |           | Fremdbeschaffung  | (0,0,0)       |
    |           |  100      | Rahmenauftrag     | !RahmenL^id   |
    |           |  100      | Rahmenauftrag     | !RahmenL^id   |
    |    150    |           | Fremdbeschaffung  | (0,0,0)       |
    |           |  100      | Rahmenauftrag     | !RahmenL^id   |
    |    150    |           | Fremdbeschaffung  | (0,0,0)       |
    |           |  100      | Rahmenauftrag     | !RahmenL^id   |
And I close the current editor


Scenario: 12 Wertereihe rollierender Plan zum Rahmen zieht Anfangsdatum aus Gültigkeit

# Rahmen mit Gueltigkeit anlegen
Given I open an editor "RA_GUELT" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_GUELT"
And I append rows
    | artikel    | mge   | zraster  | zgltvon  | zgltbis  | einplan | rundung |
    | V1         | 1200  | MONAT1   | 10.02.95 | 31.07.95 | ja      |  1      |
And I save the current editor

# Monatszeitraum beginnt jeweils am 10. und der letzte Abschnitt ist verkuerzt durch Ende der Gueltigkeit
Given I open an editor "RA_GUELT" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_GUELT"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 10.02.1995 | 09.03.1995|  200 |  0      |    200      | initialisiert | nein  |
    | 10.03.1995 | 09.04.1995|  200 |  0      |    200      | initialisiert | nein  |
    | 10.04.1995 | 09.05.1995|  200 |  0      |    200      | initialisiert | nein  |
    | 10.05.1995 | 09.06.1995|  200 |  0      |    200      | initialisiert | nein  |
    | 10.06.1995 | 09.07.1995|  200 |  0      |    200      | initialisiert | nein  |
    | 10.07.1995 | 31.07.1995|  200 |  0      |    200      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Zeitraster aendern und Anfangstermin auf Mittwoch, Abschnitte beginnen jeweils Mittwochs
Given I open an editor "RA_GUELT" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_GUELT"
And I set field "zraster" to "WOCHE1" in row 1
And I set field "zgltvon" to "08.02.95" in row 1
And I set field "zgltbis" to "31.03.95" in row 1
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 08.02.1995 | 14.02.1995|  150 |  0      |    150      | initialisiert | nein  |
    | 15.02.1995 | 21.02.1995|  150 |  0      |    150      | initialisiert | nein  |
    | 22.02.1995 | 28.02.1995|  150 |  0      |    150      | initialisiert | nein  |
    | 01.03.1995 | 07.03.1995|  150 |  0      |    150      | initialisiert | nein  |
    | 08.03.1995 | 14.03.1995|  150 |  0      |    150      | initialisiert | nein  |
    | 15.03.1995 | 21.03.1995|  150 |  0      |    150      | initialisiert | nein  |
    | 22.03.1995 | 28.03.1995|  150 |  0      |    150      | initialisiert | nein  |
    | 29.03.1995 | 31.03.1995|  150 |  0      |    150      | initialisiert | nein  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: 13 Wertereihe initialisieren durch Button bwreinit

Given I set StorageQuantity to zero for Product "EINK" on StorageLocation "F1"

# Bestand zubuchen
Given I open an editor "Rechnung_13" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_SCEN13     |
    | budat    | .             |
And I append rows
    | artikel   | mge   | platz | preis | tterm |
    | EINK      | 250   | F1    | 80,00 | +4    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rahmen anlegen und einplanen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "TESTM"
And I set field "such" to "RA_INIT"
And I append rows
    | artikel   | mge    | zraster  | zgltvon  | zgltbis  | einplan | rundung |
    | EINK      | 1000   | MONAT1   | 01.02.95 | 31.05.95 | ja      |  1      |
And I save the current editor

# Wertereihe manuell bearbeiten und wieder zuruecksetzen Button bwreinit
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_INIT"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.05.1995 | 31.05.1995|  250 |  0      |    250      | initialisiert | nein  |
And I set field "bmge" to "200" in row 3
And I set field "bmge" to "300" in row 4
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  200 |  0      |    200      | manuell       | ja    |
    | 01.05.1995 | 31.05.1995|  300 |  0      |    300      | manuell       | ja    |
And I press button "bwreinit"
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.05.1995 | 31.05.1995|  250 |  0      |    250      | initialisiert | nein  |
And I set field "bmge" to "220" in row 3
And I set field "bmge" to "280" in row 4
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I set the fake date to "08.02.1995"

Given I open an editor "AUF1_INIT" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen1^id |
    | such  | AUF1_INIT   |
    | vom   | .           |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 200 | 15.02.95 |  ja     |
Then field "zrahmen" has value "!Rahmen1^nummer" in row 1
And I save the current editor

And I run Scheduling

# Wertereihe initialisieren
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_INIT"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  0      |     50      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  220 |  0      |    220      | manuell       | ja    |
    | 01.05.1995 | 31.05.1995|  280 |  0      |    280      | manuell       | ja    |
And I press button "bwreinit"
# Menge aus Auftrag wird erst beim naechsten Dispolauf wieder verrechnet
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.05.1995 | 31.05.1995|  250 |  0      |    250      | initialisiert | nein  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Pruefen dass Auftragsmenge wieder verrechnet wurde und Wertereihe manuell anpassen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_INIT"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  0      |     50      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.05.1995 | 31.05.1995|  250 |  0      |    250      | initialisiert | nein  |
And I set field "bmge" to "200" in row 3
And I set field "bmge" to "300" in row 4
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I deliver the SalesOrder "AUF1_INIT" with PackingSlip "LS-INIT"

And I run Scheduling

# Initialisieren nicht mehr moeglich, da es bereits Istmengen gibt
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_INIT"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1995 | 28.02.1995|  250 |  200    |     50      | initialisiert | nein  |
    | 01.03.1995 | 31.03.1995|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1995 | 30.04.1995|  200 |  0      |    200      | manuell       | ja    |
    | 01.05.1995 | 31.05.1995|  300 |  0      |    300      | manuell       | ja    |
# 229 Bereits belieferte Rahmenaufträge können nicht mehr initialisiert werden.
Then pressing button "bwreinit" throws the exception "229"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Abschluss, Ablegen des Rahmens löscht die Wertereihe
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_INIT"
And I set field "tterm" to ""
Then field "einplan" has value "nein" in row 1
Then field "einplan" is not modifiable in row 1
And I save the current editor


Scenario: 14 Testet Zeitraster Quartal, Aufteilung Zeitraeume

And I set the fake date to "01.01.1996"

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE2"
And I set field "such" to "RA_QUART"
And I append rows
    | artikel     | mge  | zraster  | zgltvon  | zgltbis  | einplan |
    | EINK        | 1000 | QUARTAL1 | 01.01.96 | 31.12.96 | ja      |
And I save the current editor

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_QUART"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge | bistmge | bmgeabweich  | status        | fix   |
    | 01.01.1996 | 31.03.1996 |  250 |  0      |  250         | initialisiert | nein  |
    | 01.04.1996 | 30.06.1996 |  250 |  0      |  250         | initialisiert | nein  |
    | 01.07.1996 | 30.09.1996 |  250 |  0      |  250         | initialisiert | nein  |
    | 01.10.1996 | 31.12.1996 |  250 |  0      |  250         | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Rahmen ausplanen entfernt die Wertereihe
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_QUART"
And I respond with answer "ja" to the dialog with id "Rahmenauftragsposition ausplanen"
And I set field "einplan" to "nein" in row 1
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I save the current editor


Scenario: 15 Testet Rundungsfaktor 1 bei Menge 1, Verrechnung eingeplante Mengen

And I set the fake date to "01.01.1996"

Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_MGE1"
And I append rows
    | artikel     | mge  | rundung  | zraster  | zgltvon  | zgltbis  | einplan |
    | EINK        | 1    | 1        | MONAT1   | 01.01.96 | 31.12.96 | ja      |
And I save the current editor

# Rahmen wurde neu angelegt ohne in die Beschaffungsplanung abzusteigen
# Mengen wurden korrekt gerundet und verrechnet, auch wenn man dann nur mit zeigen und nicht mit aendern absteigt
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_MGE1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 12 rows
Then table has values
    | bmge | bistmge | bmgeabweich  | status        | fix   |
    |  1   |  0      |  1           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Mengen werden direkt gerundet und verrechnet, wenn man ohne zu speichern bei Neuanlage direkt in die Beschaffungsplanung absteigt
Given I open an editor "Rahmen2" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA2_MGE1"
And I append rows
    | artikel     | mge  | rundung  | zraster  | zgltvon  | zgltbis  | einplan |
    | EINK        | 1    | 1        | MONAT1   | 01.01.97 | 30.06.97 | ja      |
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 6 rows
Then table has values
    | bmge | bistmge | bmgeabweich  | status        | fix   |
    |  1   |  0      |  1           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
    |  0   |  0      |  0           | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Rahmen ablegen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA2_MGE1"
And I set field "tterm" to ""
And I save the current editor


Scenario: 16 Einplanen nachtraeglich aktivieren fuer bereits belieferte Rahmen

And I set the fake date to "01.02.1996"

Given I set StorageQuantity to zero for Product "TEST" on StorageLocation "F1"

# Bestand zubuchen
Given I open an editor "Rechnung_16" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_SCEN16     |
    | budat    | .             |
And I append rows
    | artikel   | mge   | platz | preis | tterm |
    | TEST      | 250   | F1    | 80,00 | +4    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rahmen anlegen, NICHT einplanen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "TESTM"
And I set field "such" to "RA_EINPL"
And I append rows
    | artikel   | mge    |
    | TEST      | 2750   |
Then field "einplan" has value "nein" in row 1
And I save the current editor

# Auftrag und Lieferung
Given I open an editor "AUF1EINPL" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen1^id |
    | such  | AUF1EINPL   |
    | vom   | .           |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 20  | 15.02.96 |  ja     |
Then field "zrahmen" has value "!Rahmen1^nummer" in row 1
And I save the current editor

And I deliver the SalesOrder "AUF1EINPL" with PackingSlip "LS-EINPL1"

And I set the fake date to "08.03.1996"

Given I open an editor "AUF2EINPL" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen1^id |
    | such  | AUF2EINPL   |
    | vom   | .           |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 200 | 15.03.96 |  ja     |
Then field "zrahmen" has value "!Rahmen1^nummer" in row 1
And I save the current editor

And I deliver the SalesOrder "AUF2EINPL" with PackingSlip "LS-EINPL2"

Given I open an editor "AUF3EINPL" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen1^id |
    | such  | AUF3EINPL   |
    | vom   | .           |
And I modify table
    | !row | mge | wtterm   | einplan |
    | 1    | 200 | 15.04.96 |  ja     |
Then field "zrahmen" has value "!Rahmen1^nummer" in row 1
And I save the current editor

# Rahmen einplanen
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_EINPL"
And I modify table
    | !row  | zraster  | zgltvon  | zgltbis  | einplan | rundung |
    | 1     | MONAT1   | 01.02.96 | 31.12.96 | ja      |  1      |
And I save the current editor

# die gelieferte Menge wird als Istmenge verrechnet, die Auftragsmenge wird erst durch den naechsten Dispolauf beruecksichtigt
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_EINPL"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1996 | 29.02.1996|  250 |  220    |    250      | initialisiert | nein  |
    | 01.03.1996 | 31.03.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1996 | 30.04.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.05.1996 | 31.05.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.06.1996 | 30.06.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.07.1996 | 31.07.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.08.1996 | 31.08.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.09.1996 | 30.09.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.10.1996 | 31.10.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.11.1996 | 30.11.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.12.1996 | 31.12.1996|  250 |  0      |    250      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

And I run Scheduling

# die Auftragsmenge wird jetzt auch beruecksichtigt
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_EINPL"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.02.1996 | 29.02.1996|  250 |  220    |     30      | initialisiert | nein  |
    | 01.03.1996 | 31.03.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.04.1996 | 30.04.1996|  250 |  0      |     50      | initialisiert | nein  |
    | 01.05.1996 | 31.05.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.06.1996 | 30.06.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.07.1996 | 31.07.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.08.1996 | 31.08.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.09.1996 | 30.09.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.10.1996 | 31.10.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.11.1996 | 30.11.1996|  250 |  0      |    250      | initialisiert | nein  |
    | 01.12.1996 | 31.12.1996|  250 |  0      |    250      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Rahmen ausplanen entfernt die Wertereihe
Given I open an editor "Rahmen1" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_EINPL"
And I respond with answer "ja" to the dialog with id "Rahmenauftragsposition ausplanen"
And I set field "einplan" to "nein" in row 1
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I save the current editor


Scenario: 17 Rahmenposition durch Setzen des Status stornieren entfernt die Wertereihe

And I set the fake date to "15.03.1996"

Given I open an editor "Rahmen17" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_MGE1"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 12 rows
And I close the current subeditor to switch back to the parent editor
And I set field "status" to "S" in row 1
And I save the current editor

Given I open an editor "Rahmen17" from table "(Sales):(BlanketOrder)" with command "VIEW" for record from editor "Rahmen17"
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I close the current editor

And I run Scheduling

# Plankarte ist dann leer, nur noch Lagerzeile
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EINK"
And I press start
Then the table has 1 rows
Then field "vart" has value "Lager" in row 1
And I close the current editor


Scenario: 18 Artikel mit dispoa mindestbestandsbezogen oder leer können nicht eingeplant werden

And I set the fake date to "25.03.1996"

Given I open an editor "ART_LEER" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such      | ART_LEER  |
    | dispoa    |           |
And I save the current editor

Given I open an editor "Rahmen18" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_LEER"
And I append rows
    | artikel     | mge  | rundung  | zraster  | zgltvon  | zgltbis  |
    | ART_LEER    | 100  | 1        | MONAT1   | 01.01.96 | 31.12.96 |
Then field "einplan" is not modifiable in row 1
And I save the current editor

Given I open an editor "Rahmen18" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_LEER"
Then pressing button "wertereihe" in row 1 to open a subeditor throws the exception "203"
And I close the current editor

# Plankarte ist leer
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "ART_LEER"
And I press start
Then the table has 0 rows
And I close the current editor

Given I open an editor "ART_MIND" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such      | ART_MIND                  |
    | dispoa    | mindestbestandsbezogen    |
And I save the current editor

Given I open an editor "Rahmen18" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_LEER"
And I append rows
    | artikel     | mge  | rundung  | zraster  | zgltvon  | zgltbis  |
    | ART_MIND    | 100  | 1        | MONAT1   | 01.01.96 | 31.12.96 |
Then field "einplan" is not modifiable in row 2
And I save the current editor

Given I open an editor "Rahmen18" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_LEER"
Then pressing button "wertereihe" in row 2 to open a subeditor throws the exception "203"
And I close the current editor

# Plankarte ist leer
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "ART_MIND"
And I press start
Then the table has 0 rows
And I close the current editor


Scenario: 19 Setartikel koennen nicht eingeplant werden, einplan ist schreibgeschuetzt

Given I open an editor "SET19" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such      | SET19             |
    | dispoa    | auftragsbezogen   |
    | earta     | über Stückliste   |
And I delete all rows
And I append rows
    | elex  | anzahl    |
    | EINK  | 1         |
    | TEST  | 2         |
And I save the current editor

Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_SET"
And I append rows
    | artikel   | mge    | zgltvon  | zgltbis  | zraster    |
    | SET19     | 100    | 16.01.95 | 31.07.95 | MONAT1     |
Then field "einplan" is not modifiable in row 1
And I save the current editor

Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_SET"
Then field "einplan" is not modifiable in row 1
And I close the current editor


Scenario: 20 Artikel darf nicht auf Setartikel umgestellt werden, wenn es eine eingeplante Rahmenposition gibt

And I set the fake date to "25.03.1996"

Given I open an editor "ART_KEINSET" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such      | ART_KEINSET  |
And I delete all rows
And I append rows
    | elex  | anzahl    |
    | EINK  | 1         |
    | TEST  | 2         |
And I save the current editor

Given I open an editor "Rahmen20" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_NO_SET"
And I append rows
    | artikel     | mge  | rundung  | zraster  | zgltvon  | zgltbis  | einplan  |
    | ART_KEINSET | 100  | 1        | MONAT1   | 01.01.96 | 31.12.96 | ja       |
And I save the current editor

Given I open an editor "ART_KEINSET" from table "(Part):(Product)" with command "UPDATE" for record "ART_KEINSET"
# 1543 de      |Ein Artikel darf nicht zu einem Setartikel geändert werden, wenn er bereits in Vorgängen verwendet wurde.
Then setting field "earta" to "über Stückliste" throws the exception "1543"
And I save the current editor
Then field "earta" has value "Über Artikel"

Scenario: 21 Rahmenauftragsposition darf nicht eingeplant werden, wenn der Artikel auf Setartikel umgestellt wurde

And I set the fake date to "25.03.1996"

Given I open an editor "Rahmen21" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_NO_SET"
And I respond with answer "ja" to the dialog with id "Rahmenauftragsposition ausplanen"
And I set field "einplan" to "nein" in row 1
And I save the current editor

Given I open an editor "ART_KEINSET" from table "(Part):(Product)" with command "UPDATE" for record "ART_KEINSET"
And I set field "earta" to "Über Stückliste"
And I save the current editor

Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_NO_SET"
Then field "einplan" is not modifiable in row 1
And I close the current editor


Scenario: 22 Sofort abrufbare Menge ist ungleich der Menge pro Zeitabschnitt, keine Verrechnung in der Wertereihe

And I set the fake date to "30.03.1996"

Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "ART_BMGEABWEICH"
And I set fields
    | such     | ART_BMGEABWEICH                |
    | namebspr | Verrechnung sofort Menge       |
    | bsart    | Fremdbeschaffung               |
    | dispoa   | bedarfsbezogen                 |
    | lief     | LIEFER1                        |
    | efrist   | 150                            |
    | bfrist   | 150                            |
    | epr      | 50                             |
And I save the current editor

# Rahmen anlegen mit sofort abrufbarer Menge kleiner als Menge pro Zeitabschnitt
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_ABWEI"
And I append rows
    | artikel           | mge  | zraster  | zgltvon  | zgltbis  | einplan | rundung | verfuegbmge |  lfristkurz   |
    | ART_BMGEABWEICH   | 400  | MONAT1   | 01.04.96 | 31.07.96 | ja      |  1      |    50       |     5         |
And I save the current editor

And I run Scheduling

# sofort abrufbare Menge wird NICHT bei Plan-Ist-Abweichung verrechnet
Given I open an editor "RA_ABWEI" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_ABWEI"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.04.1996 | 30.04.1996|  100 |  0      |    100      | initialisiert | nein  |
    | 01.05.1996 | 31.05.1996|  100 |  0      |    100      | initialisiert | nein  |
    | 01.06.1996 | 30.06.1996|  100 |  0      |    100      | initialisiert | nein  |
    | 01.07.1996 | 31.07.1996|  100 |  0      |    100      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# sofort abrufbare Menge erhoehen auf Wert groesser als Menge pro Zeitabschnitt
Given I open an editor "RA_ABWEI" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_ABWEI"
And I set field "verfuegbmge" to "120" in row 1
And I save the current editor

And I run Scheduling

# sofort abrufbare Menge wird NICHT bei Plan-Ist-Abweichung verrechnet
Given I open an editor "RA_ABWEI" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_ABWEI"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.04.1996 | 30.04.1996|  100 |  0      |    100      | initialisiert | nein  |
    | 01.05.1996 | 31.05.1996|  100 |  0      |    100      | initialisiert | nein  |
    | 01.06.1996 | 30.06.1996|  100 |  0      |    100      | initialisiert | nein  |
    | 01.07.1996 | 31.07.1996|  100 |  0      |    100      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor


#Scenario: 23 Rahmenpositionen mit variantenbezogenem Artikel werden auftragsbezogen eingeplant werden


Scenario: 24 Rahmen der eine variantenbezogene AFL durch absteigen hat, kann nicht eingeplant werden

And I set the fake date to "10.04.1996"

Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "ABSTEIG"
And I set fields
    | such     | ABSTEIG                        |
    | namebspr | AFL absteigen variantenbezogen |
    | bsart    | Eigenfertigung                 |
    | dispoa   | auftragsbezogen                |
And I save the current editor

Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_ABSTEI"
And I append rows
    | artikel   | mge  | zraster  | zgltvon  | zgltbis  |
    | ABSTEIG   | 400  | MONAT1   | 01.05.96 | 31.12.96 |
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I save the current subeditor to switch back to the parent editor
Then field "einplan" is not modifiable in row 1
And I save the current editor

Given I open an editor "RA_ABSTEI" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_ABSTEI"
Then field "einplan" is not modifiable in row 1
# pruefen dass die AFL variantenbezogen ist
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "dispoa" has value "variantenbezogen"
And I close the current subeditor to switch back to the parent editor
And I close the current editor


Scenario: 25  Bei eingeplantem Rahmen darf nicht in die AFL abgestiegen werden, um keine variantenbezogene AFL zu erzeugen

And I set the fake date to "10.04.1996"

Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "ABSTEIGNEIN"
And I set fields
    | such     | ABSTEIGNEIN                    |
    | namebspr | AFL absteigen variantenbezogen |
    | bsart    | Eigenfertigung                 |
    | dispoa   | auftragsbezogen                |
And I save the current editor

Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_AFLNO"
And I append rows
    | artikel       | mge  | zraster  | zgltvon  | zgltbis  | einplan   |
    | ABSTEIGNEIN   | 400  | MONAT1   | 01.05.96 | 31.12.96 | ja        |
# absteigen nicht moeglich, da die Position eingeplant ist
Then pressing button "absteig" in row 1 to open a subeditor throws the exception ""
And I save the current editor

# bei einer eingeplanten Rahmenposition darf nicht in die AFL abgestiegen werden
Given I open an editor "RA_AFLNO" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_AFLNO"
Then pressing button "absteig" in row 1 to open a subeditor throws the exception ""
And I save the current editor


Scenario: 26 Wertereihe wird geloescht, wenn die Rahmenauftragsposition mit Setzen des Status storniert und dann geloescht wurde

And I set the fake date to "15.04.1996"

Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "RA_STORNO"
And I append rows
    | artikel   | mge  | zraster  | zgltvon  | zgltbis  | einplan |
    | EINK      | 400  | MONAT1   | 01.05.96 | 31.08.96 | ja      |
    | BG1       | 400  | MONAT1   | 01.05.96 | 31.08.96 | ja      |
And I save the current editor

Given I open an editor "Rahmen26" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_STORNO"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then the table has 4 rows
And I close the current subeditor to switch back to the parent editor
And I set field "status" to "S" in row 1
And I save the current editor

Given I open an editor "Rahmen26" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_STORNO"
And I delete row at position 1
And I save the current editor

Then opening an editor from table "(ValueSequence):(RollingForecast)" with command "VIEW" for search criteria "$,,rahmenkopf^such==RA_STORNO;artber==EINK;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig" throws the exception "149"
And I close the current editor

And I run Scheduling

# Plankarte ist dann leer, nur noch Lagerzeile
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "EINK"
And I press start
Then the table has 1 rows
Then field "vart" has value "Lager" in row 1
And I close the current editor


Scenario: 27 Rahmenauftrag eingplant, mit sofort verfuegbarer Menge, ohne Zeitraster, Verrechnung Planmengen

And I set the fake date to "20.04.1996"

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "KEINZEITRASTER"
And I set fields
    | such     | KEINZEITRASTER                     |
    | namebspr | sofort verfuegb, kein Zeitraster   |
    | bsart    | Fremdbeschaffung                   |
    | dispoa   | bedarfsbezogen                     |
    | lief     | LIEFER1                            |
    | efrist   | 30                                 |
    | bfrist   | 30                                 |
    | epr      | 50                                 |
And I save the current editor

# Rahmen mit sofort abrufbarer Menge anlegen, OHNE Zeitraster
Given I open an editor "Rahmen" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I set field "such" to "R_NO_ZEIT"
And I append rows
    | artikel           | mge   | zgltvon  | zgltbis  | einplan | rundung | verfuegbmge | lfristkurz    | lzeit |
    | KEINZEITRASTER    | 1750  | 01.05.96 | 31.12.96 | ja      |  1      | 250         |  3            |  15   |
And I save the current editor

And I run Scheduling

And I set the fake date to "15.06.1996"

And I run Scheduling

# Einteilung im Rahmen pruefen, 1 Zeile mit Gesamtmenge 1750
Given I open an editor "R_NO_ZEIT" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "R_NO_ZEIT"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat       | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.05.1996 | 31.12.1996   | 1750 |  0      | 1750        | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "KEINZEITRASTER"
And I press start
Then the table has 4 rows
Then table has values
    | zugang    | abgang    | verw      | vart              | vkopf^id      |
    |           |           |           | Lager             | (0,0,0)       |
    |           | 1750      |           | Rahmenauftrag     | !R_NO_ZEIT^id |
    |  250      |           |           | Fremdbeschaffung  | (0,0,0)       |
    | 1500      |           |           | Fremdbeschaffung  | (0,0,0)       |
And I close the current editor


# dieser Testfall ist unabhaengig von dispositiven Rahmen, kann ggf. in Scenario mit Absatzplanung eingebaut werden
Scenario: 28 Planungsrelevanz im Auftrag nachtraeglich aenderbar, Dispoanstoss vorhanden

Given I create a SalesOrder "AUF28" for Customer "TEST" with Product "BAUT" and quantity "10"

And I run Scheduling

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "BAUT"
And I press start
Then field "hinweis" is empty
And I close the current editor

Given I open an editor "AUF28" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF28"
Then field "planrel" is modifiable in row 1
And I set field "planrel" to "nein" in row 1
And I save the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "BAUT"
And I press start
Then field "hinweis" is not empty
And I close the current editor

And I run Scheduling

Given I open an editor "AUF28" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF28"
And I set field "planrel" to "ja" in row 1
And I save the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "BAUT"
And I press start
Then field "hinweis" is not empty
And I close the current editor


Scenario: 29 Rahmen wird eingeplant, nachdem bereits Istmengen vorhanden, für Artikel mit Handelseinheit ungleich Lagereinheit

And I set the fake date to "01.03.1996"

# Einheit anlegen
Given I open an editor "TSDSTK" from table "(Unit):(Unit)" with command "STORE" for record "TSDSTK"
And I set fields
    | such          | TSDSTK            |
    | namebspr      | Tausend Stueck    |
    | einheitbspr   | TSDSTK            |
    | classname     | TSDSTK            |
    | reosofort     | ja                |
And I save the current editor

# Artikel mit Handelseinheit ungleich Lagereinheit anlegen
Given I open an editor "TEIL_HE_UNGLEICH_LE" from table "(Part):(Product)" with command "STORE" for record "TEIL_HE_UNGLEICH_LE"
And I set fields
    | such              | TEIL_HE_UNGLEICH_LE           |
    | namebspr          | Handelseinheit ungleich le    |
    | bsart             | Fremdbeschaffung              |
    | lief              | TEST                          |
    | efrist            | 5                             |
    | le                | TSDSTK                        |
    | fvhe              | 1000                          |
    | vhe               | Stück                         |
And I save the current editor

# Bestand zubuchen
Given I open an editor "Rechnung_29" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | TEST          |
    | vom      | .             |
    | ueb      | ja            |
    | fakt     | ja            |
    | ebeleg   | RE_SCEN29     |
    | budat    | .             |
And I append rows
    | artikel               | mge   | platz | preis | tterm |
    | TEIL_HE_UNGLEICH_LE   | 27    | F1    | 5,00  | +4    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rahmen anlegen, NICHT einplanen
Given I open an editor "Rahmen29" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "TESTM"
And I set field "such" to "RA_HE_LE"
And I append rows
    | artikel               | mge    |
    | TEIL_HE_UNGLEICH_LE   | 130000 |
Then field "einplan" has value "nein" in row 1
And I save the current editor

# Auftrag und Lieferung
Given I open an editor "AUF_HE_LE" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | beleg | !Rahmen29^id  |
    | such  | AUF_HE_LE     |
    | vom   | .             |
And I modify table
    | !row | mge    | wtterm   | einplan |
    | 1    | 27000  | 05.07.96 |  ja     |
Then field "zrahmen" has value "!Rahmen29^nummer" in row 1
And I save the current editor

And I deliver the SalesOrder "AUF_HE_LE" with PackingSlip "LS_HE_LE"

And I set the fake date to "10.03.1996"

# Rahmen einplanen
Given I open an editor "Rahmen29" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_HE_LE"
And I modify table
    | !row  | zgltvon  | zgltbis  | einplan |
    | 1     | 01.03.96 | 31.12.96 | ja      |
And I save the current editor

And I run Scheduling

# die gelieferte Menge wird als Istmenge verrechnet
Given I open an editor "Rahmen29" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RA_HE_LE"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat    | bmge | bistmge | bmgeabweich | status        | fix   |
    | 01.03.1996 | 31.12.1996|  130 |  27     |    103      | initialisiert | nein  |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open the infosystem "PLANKARTE"
And I set field "kart" to "TEIL_HE_UNGLEICH_LE"
And I press start
Then the table has 3 rows
Then table has values
    | zugang    | abgang    | verw      | vart              | vkopf^id      | geschaeftspartner |
    |           |           |           | Lager             | (0,0,0)       |                   |
    |           |  103      |           | Rahmenauftrag     | !Rahmen29^id  | Testkunde         |
    |  103      |           |           | Fremdbeschaffung  | (0,0,0)       |                   |
And I close the current editor


Scenario: 30 MPS-Analyse enthaelt nur Ist-Daten zur Absatzplanung, Rahmenabrufe werden ausgeklammert
# verwendet die Daten aus Scenario 06

Given I open the infosystem "MPSLISTE"
And I set field "kvon" to "01.01.1995"
And I set field "kvon" to "31.12.1995"
And I press start
Then the table has 1 rows
Then table has values
    | tart          | gesistmge |
    | E_MOTOR_PLAN  | 7         |
And I close the current editor



Scenario: 31 Testet Zeitraster mit Faktor

And I set the fake date to "01.01.1996"

# Zeitraster anlegen
Given I open an editor "ZeitrasterM" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such          | PL_WOCHE_F10  |
    | namebspr      | WOCHE_F10     |
    | zeiteinheit   | Woche         |
    | zefaktor      | 10            |
And I save the current editor

Given I open an editor "Rahmen10" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE2"
And I set field "such" to "RA_WOCHEF"
And I append rows
    | artikel     | mge  | zraster      | zgltvon  | zgltbis  | einplan |
    | EINK        | 1000 | PL_WOCHE_F10 | 01.01.96 | 31.12.96 | ja      |
And I save the current editor

Given I open an editor "Rahmen10" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RA_WOCHEF"
And I press button "wertereihe" to open a subeditor for "wertereihe" in row 1
Then table has values
    | vondat     | bisdat     | bmge     |
    | 01.01.1996 | 10.03.1996 |  166.667 |
    | 11.03.1996 | 19.05.1996 |  166.667 |
    | 20.05.1996 | 28.07.1996 |  166.667 |
    | 29.07.1996 | 06.10.1996 |  166.667 |
    | 07.10.1996 | 15.12.1996 |  166.667 |
    | 16.12.1996 | 31.12.1996 |  166.665 |
And I close the current subeditor to switch back to the parent editor
And I close the current editor
