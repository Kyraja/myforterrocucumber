@persistent
Feature: ref_bab_rere_werte
Background:
Given I set the fake date to "31.07.2002"

# *****************************************************************************
#  Name             : bab_rere_werte.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test der korrekten Berechnung der VKZ von Rechenregeln, wenn kumulierte Werte des Zeitraums null sind.
#
# *****************************************************************************

Scenario: 01 Stammdaten und Buchungen
# Kostenstellen anlegen, Bezugsgröße zuordnen und dort VKZ erfassen, Buchungen erzeugen, BAB-Formular anlegen
#
Given I open an editor "Kst1" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "909"
And I set field "such" to "k909"
And I set field "bezug" to "100"
And I save the current editor
#
Given I open an editor "Kst2" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "910"
And I set field "such" to "k910"
And I save the current editor
#
Given I open an editor "bg100" from table "(ActivityBase):(ActivityBase)" with command "UPDATE" for record "100"
And I set field "gjahr" to "02-2"
And I press button "ivkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "100"
And I set field "s2" to "100"
And I set field "s3" to "100"
And I set field "s4" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg100"
#
And I press button "pvkz" to open a subeditor for "Ist-Vkz" in row 0 with dialog "2011" and answer "Ja"
And I set field "s1" to "120"
And I set field "s2" to "120"
And I set field "s3" to "120"
And I set field "s4" to "120"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "bg100"
And I close the current editor
#
Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "1.6.02"
And  I create a new row at the end of the table
And I set field "konto" to "60100" in row 1
And I set field "ewsbetr" to "100" in row 1
And I set field "kstelle" to "909" in row 1
And  I create a new row at the end of the table
And I set field "konto" to "60200" in row 2
And I set field "ewsbetr" to "400" in row 2
And I set field "kstelle" to "909" in row 2
And  I create a new row at the end of the table
And I set field "konto" to "11400" in row 3
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor

Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "1.7.02"
And  I create a new row at the end of the table
And I set field "konto" to "60100" in row 1
And I set field "ewhbetr" to "100" in row 1
And I set field "kstelle" to "909" in row 1
And  I create a new row at the end of the table
And I set field "konto" to "60200" in row 2
And I set field "ewhbetr" to "400" in row 2
And I set field "kstelle" to "909" in row 2
And  I create a new row at the end of the table
And I set field "konto" to "11400" in row 3
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor

Given I open an editor "babformular" from table "(EDS):(EDS)" with command "NEW" for record ""
And I set field "num63" to "909"
And I set field "such63" to "bab909"
And I set field "name" to "kumulierte Werte mit Saldo null von Rechenregeln"
And I set field "gjahr" to "02-2"
And I set field "ganmon" to "1"
And I set field "gendmon" to "4"
And I set field "koobj" to "909"
And I create a new row at the end of the table
And I set field "koart" to "60100" in row 1
And I create a new row at the end of the table
And I set field "koart" to "60200" in row 2
And I create a new row at the end of the table
And I set field "koart" to "10.2" in row 3
And I save the current editor

###################
# Kst 909: Istkosten
# Die Rechenregel addiert die Werte der beiden Kostenarten. Zu diesem Zeitpunkt gibt es nur Ist-VKZ bei den Kostenarten.
# Die kumulierten Ist-Monatswerte über alle Monate bei der Rechenregel ergeben null, aber die einzelnen Monatswerte sind ungleich null.
###################
Scenario: 02 Ist-VKZ Rechenregel auswerten
Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "909"
# Ist Verkehrszahlen prüfen
And I press button "istkost" to open a subeditor for "Ist-Vkz" in row 1
Then field "sa3" has value "100.00"
Then field "sa4" has value "-100.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
#
And I press button "istkost" to open a subeditor for "Ist-Vkz" in row 2
Then field "sa3" has value "400.00"
Then field "sa4" has value "-400.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
#
# Istkosten der Rechenregel in Zeile 3 prüfen
And I press button "istkost" to open a subeditor for "Ist-Vkz" in row 3
Then field "sa3" has value "500.00"
Then field "s3" has value "500.00"
Then field "h3" has value "0.00"
Then field "sa4" has value "-500.00"
Then field "s4" has value "0.00"
Then field "h4" has value "500.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
And I close the current editor

###################
# Kst 909: zusätzlich Erfasen von fixen Plankosten (PF) für die beiden Kostenarten. Die Rechenregel addiert die Werte der beiden Kostenarten.
# Die kumulierten PF-Monatswerte über alle Monate bei der Rechenregel ergeben nun NICHT null.
# Deshalb wird ein PF-VKZ-Satz für die Rechenregel erzeugt.
# Da die Bestimmung der kumulierten Monatswerte über alle Monate bei der Rechenregel für die PF-VKZ nun positiv ausgefallen ist,
# werden neben den PF-VKZ auch die Ist-VKZ für die Rechenregel erzeugt.
# Dieses Verhalten ist zufällig und daher falsch. Der Fehler liegt in der Art Bestimmung, ob VKZ für die Rechenregel gebildet werden müssen.
###################
Scenario: 03 planfixe VKZ für Kostenarten erfassen und für Kostenarten und Rechenregel auswerten
Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "909"
# planfixe Verkehrszahlen erfassen für Zeile 1 und Zeile 2 (Kostenarten)
And I press button "planfix" to open a subeditor for "Planfix-Vkz" in row 1 with dialog "2011" and answer "Ja"
And I set field "s3" to "200.00"
And I set field "s4" to "400.00"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "BABFORMULAR"
#
And I press button "planfix" to open a subeditor for "Planfix-Vkz" in row 2 with dialog "2011" and answer "Ja"
And I set field "h3" to "300.00"
And I set field "s4" to "500.00"
And I set field "h4" to "300.00"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "BABFORMULAR"
And I save the current editor
#
#
# Formular erst schließen. Nach erneutem Öffnen sind die VKZ der ReRe da
#
Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "909"
# nun sind Ist-VKZ der Rechenregel vorhanden, denn die erfassten fixen Plankosten sorgen dafür, dass kumulierte Werte (PF) ungleich null erkannt werden
# Istkosten der Rechenregel in Zeile 3 prüfen
And I press button "istkost" to open a subeditor for "Ist-Vkz" in row 3
Then field "sa3" has value "500.00"
Then field "s3" has value "500.00"
Then field "h3" has value "0.00"
Then field "sa4" has value "-500.00"
Then field "s4" has value "0.00"
Then field "h4" has value "500.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
#
# planfixe VKZ  der Rechenregel in Zeile 1 prüfen
And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 1
Then field "sa3" has value "200.00"
Then field "s3" has value "200.00"
Then field "sa4" has value "400.00"
Then field "s4" has value "400.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
#
# planfixe VKZ  der Rechenregel in Zeile 2 prüfen
And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 2
Then field "sa3" has value "-300.00"
Then field "h3" has value "300.00"
Then field "sa4" has value "200.00"
Then field "s4" has value "500.00"
Then field "h4" has value "300.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
#
# planfixe VKZ  der Rechenregel in Zeile 3 prüfen
And I press button "planfix" to open a subeditor for "Plan-Vkz" in row 3
Then field "sa3" has value "-100.00"
Then field "s3" has value "-100.00"
Then field "h3" has value "0.00"
Then field "sa4" has value "600.00"
Then field "s4" has value "600.00"
Then field "h4" has value "0.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
And I close the current editor
#
Scenario: 04 Soll-VKZ der Rechenregel in Zeile 3 auswerten
Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "909"
And I press button "sollkost" to open a subeditor for "Soll-Vkz" in row 3
Then field "sa3" has value "-100.00"
Then field "s3" has value "-100.00"
Then field "h3" has value "0.00"
Then field "sa4" has value "600.00"
Then field "s4" has value "600.00"
Then field "h4" has value "0.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
And I close the current editor
#
###################
# andere Kst 910: Erfasen von fixen Plankosten für die beiden Kostenarten. Die Rechenregel addiert die Werte der beiden Kostenarten.
# Da die Monatswerte der Rechenregel kumuliert über alle Monate des BAB-Formulars null ergeben, erzeugt das Programm keinen
# PF-VKZ-Satz und auch keinen Soll-VKZ-Satz für die Rechenregel (Bug FICO-37).
###################
Scenario: 05 Planfixe VKZ fuer Kst 910 fuer die Kostenarten 60100, 60200 erfassen mit Saldo der Rechenregel 10.2 null
Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "909"
And I set field "koobj" to "910"
# planfixe Verkehrszahlen in Zeilen 1 und (Kostenarten) erfassen
And I press button "planfix" to open a subeditor for "Planfix-Vkz" in row 1 with dialog "2011" and answer "Ja"
And I set field "s3" to "333.00"
And I set field "s4" to "666.00"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "BABFORMULAR"
And I press button "planfix" to open a subeditor for "Planfix-Vkz" in row 2 with dialog "2011" and answer "Ja"
And I set field "s3" to "-333.00"
And I set field "h4" to "666.00"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "BABFORMULAR"
And I save the current editor
And I close the current editor
#
Given I open an editor "BABFORMULAR" from table "(EDS):(EDS)" with command "UPDATE" for record "909"
# planfixe VKZ der Rechenregel in Zeile 3
# PROGRAMMFEHLER:
# der fehlende VKZ-Satz für die Rechenregelzeile (zeile 3) ist der momentan hier dokumentierte Fehler (vgl. FICO-37)
#  2919 de      |Bewegungsdatensatz nicht vorhanden
Then pressing button "planfix" in row 3 to open a subeditor throws the exception "2919"
# And I press button "planfix" to open a subeditor for "Planfix-Vkz" in row 3
# Then field "sa3" has value "0.00"
# Then field "s3" has value "0.00"
# Then field "h3" has value "0.00"
# Then field "sa4" has value "0.00"
# Then field "s4" has value "666.00"
# Then field "h4" has value "666.00"
# And I close the current editor
# And I switch the current editor to editor "BABFORMULAR"
#
# Soll-VKZ der Kostenart in Zeile 1
And I press button "sollkost" to open a subeditor for "Planfix-Vkz" in row 1
Then field "sa3" has value "333.00"
Then field "s3" has value "333.00"
Then field "h3" has value "0.00"
Then field "sa4" has value "666.00"
Then field "s4" has value "666.00"
Then field "h4" has value "0.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
#
# Soll-VKZ der Kostenart in Zeile 2
And I press button "sollkost" to open a subeditor for "Planfix-Vkz" in row 2
Then field "sa3" has value "-333.00"
Then field "s3" has value "-333.00"
Then field "h3" has value "0.00"
Then field "sa4" has value "-666.00"
Then field "s4" has value "-666.00"
Then field "h4" has value "0.00"
And I close the current editor
And I switch the current editor to editor "BABFORMULAR"
#
# Soll-VKZ der Rechenregel in Zeile 3
# PROGRAMMFEHLER:
# der fehlende VKZ-Satz für die Rechenregelzeile (zeile 3) ist der momentan hier dokumentierte Fehler (vgl. FICO-37)
#  2919 de      |Bewegungsdatensatz nicht vorhanden
Then pressing button "sollkost" in row 3 to open a subeditor throws the exception "2919"
And I close the current editor
    





