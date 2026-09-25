@persistent
Feature: Datei Kostenart Plausitest
Background:
Given I set the fake date to "1.07.2002"
Given I enable the flag 39 

# *****************************************************************************
#  Name             : Datei Kostenart: Plausiprüfungen
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test der Plausis beiKostenarten, Rechenregeln, der Kore-Konfiguration und der Einzelkostenbasis.
#
# *****************************************************************************

# Kostenart Scenario 01
Scenario: 010 Neuanlage Kostenart
Given I open an editor "kostenart" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "70"
And I set field "such" to "koart70"
Then field "prim" has value "ja"
And I set field "prim" to "nein"
And I set field "sekgut" to "ja"
And I set field "stat" to "nein"
# 4836: primäre Kostenart kann keine Kostenart für Gutschrift sek. Kosten sein
Then saving the current editor throws the exception "4836"
And I close the current editor

Scenario: 011 Neuanlage Kostenart
Given I open an editor "kostenart" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "70"
And I set field "such" to "koart70"
Then field "prim" has value "ja"
And I set field "erlkoart" to "ja"
And I set field "prim" to "nein"
# 4837: sekundäre Kostenart kann keine Erlös-Kostenart sein
Then saving the current editor throws the exception "4837"
And I close the current editor

# Rechenregel Scenario 02
Scenario: 020 Neuanlage Rechenregel
# eine Zeilen und Leerzeilen erfassen - Leerzeilen werden beim Speichern gelöscht
Given I open an editor "kostenart" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "nummer" to "80"
And I set field "such" to "rere80"
And I set field "optyp" to "Summierung"
And I create a new row at the end of the table
And I create a new row at the end of the table
And I create a new row at the end of the table
And I create a new row at the end of the table
# Then the table hast 3 rows
And I set field "koart" to "50000" in row 2
And I set field "koart" to "54000" in row 4
And I save the current editor
Then the table has 2 rows

Scenario: 021 Anzeige Rechenregel
Given I open an editor "kostenart" from table "(CostType):(ComputationRule)" with command "VIEW" for record "80"
Then the table has 2 rows
And I save the current editor

Scenario: 022 Ändern Rechenregel 
Given I open an editor "rere" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "80"
And I create a new row at the end of the table
And I set field "koart" to "10.1" in row 3
And I set field "closed" to "nein" in row 3
And I save the current editor

Scenario: 023 Ändern Rechenregel - geöffnete Struktur beim Speichern nicht erlaubt
Given I open an editor "rere" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "80"
# 2220: Bitte zuerst die komplette Struktur zuklappen!
Then saving the current editor throws the exception "2220"
And I close the current editor

# Prüfungen bei der Berechnungsart der Rechenregel
Scenario: 024 Ändern Rechenregel - Berechnungsart "Leerzeile" - Zeile darf keine Einträge enthalten
Given I open an editor "kostenart" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "nummer" to "120"
And I set field "such" to "rere120"
And I set field "optyp" to "Leerzeile"
And I create a new row at the end of the table
And I set field "koart" to "50000" in row 1
And I set field "zproz" to "80" in row 1
Then saving the current editor throws the exception "3894"
And I close the current editor

Scenario: 025 Ändern Rechenregel - Berechnungsart "Summierung", "Subtraktion" - Zeile muss vorhanden und gefüllt sein
Given I open an editor "kostenart" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "nummer" to "130"
And I set field "such" to "rere130"
And I set field "optyp" to "Subtraktion"
Then saving the current editor throws the exception "1188"
And I close the current editor

Scenario: 026 Ändern Rechenregel 
Given I open an editor "kostenart" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "nummer" to "130"
And I set field "such" to "rere130"
And I set field "optyp" to "Subtraktion"
And I create a new row at the end of the table
Then saving the current editor throws the exception "279"
And I set field "koart" to "50000" in row 1
And I save the current editor

Scenario: 027 Ändern Rechenregel - Berechnungsart "Übertrag" - eine Zeile muss vorhanden und gefüllt sein, es dürfen nicht mehr als 1 Zeile vorhanden sein
Given I open an editor "kostenart" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "nummer" to "140"
And I set field "such" to "rere140"
And I set field "optyp" to "Übertrag"
Then saving the current editor throws the exception "1188"
And I close the current editor

Scenario: 028 Neuanlage Rechenregel - Bei Berechnungsart "Übertrag" ist nur 1 Zeile erlaubt
Given I open an editor "kostenart" from table "(CostType):(ComputationRule)" with command "NEW" for record ""
And I set field "nummer" to "140"
And I set field "such" to "rere140"
And I set field "optyp" to "Übertrag"
And I create a new row at the end of the table
Then saving the current editor throws the exception "279"
And I set field "koart" to "50000" in row 1
And I create a new row at the end of the table
And I set field "koart" to "130" in row 2
# 3893: Bei Berechnungsart "Übertrag" ist nur 1 Zeile erlaubt
Then saving the current editor throws the exception "3893"
And I delete row at position 2
And I save the current editor

Scenario: 029 Ändern Rechenregel - neue Zeile einfügen
Given I open an editor "rere" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "10.1"
And I create a new row at the end of the table
And I set field "koart" to "10.2" in row !lastRow
And I save the current editor

Scenario: 030 Ändern Rechenregel - Zyklusprüfung
Given I open an editor "rere" from table "(CostType):(ComputationRule)" with command "UPDATE" for record "10.2"
And I create a new row at the end of the table
And I set field "koart" to "10.1" in row !lastRow
And I save the current editor
Then message "Enthaltene Rechenregel 10.1 verursacht einen Zyklus." was displayed

# Kostenrechnungskonfiguration Scenario 04
Scenario: 041 Kostenrechnungskonfiguration vorbereiten für Plausis
Given I'm logged in with password "annette"
Given I enable the flag 71
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "MODIFY" for record "korekonf"
And I set field "strest" to "222"
And I set field "trrest" to "111111"
And I set field "fertkont" to ""
And I save the current editor
Given I disable the flag 71
Given I'm logged in with password "sy"

Scenario: 042 Test der Plausis
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
# 4895: nur bebuchbare Kostenstellen erlaubt
Then saving the current editor throws the exception "4895"
And I set field "strest" to "100"
# 4996: nur bebuchbare Kostenträger erlaubt
Then saving the current editor throws the exception "4996"
And I set field "trrest" to "100000"
# 2842: Tragen Sie eine Fertigungskontengruppe ein.
Then saving the current editor throws the exception "2842"
And I set field "fertkont" to "100"
And I save the current editor

Scenario: 043 Kostenrechnungskonfiguration vorbereiten für Plausis
Given I open an editor "termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM"
And I set field "ilviststartgj" to "02-2"
And I set field "ilviststartgm" to "1"
And I save the current editor

Scenario: 044 Kostenrechnungskonfiguration - wenn es ein ILV-Startdatum gibt, müssen Konto und Kostenobjekt für Rundungsdifferenzen aus der ILV vorhanden sein
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
# 7846: Konto für Rundungsdifferenz aus der ILV fehlt.
Then saving the current editor throws the exception "7846"
And I set field "ilvko" to "99800"
# 6631: Kostenstelle/Kostenträger für Rundungsdifferenz aus der ILV fehlt.
Then saving the current editor throws the exception "6631"
And I set field "ilvks" to "100"
And I save the current editor

Scenario: 045 Kostenrechnungskonfiguration - weitere Plausi
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "gekobuch" to "ja"
And I set field "gekoindi" to "ja"
And I set field "gekobuch" to "nein"
# 5878: nur in Kombination mit der Entlastung der Haupt-Kostenstellen möglich
Then saving the current editor throws the exception "5878"
And I close the current editor

Scenario: 046 Kostenrechnungskonfiguration - weitere Plausi
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "pprop" to "nein"
# 2173: Zur Errechnung der Sollkosten werden Plankosten benötigt
Then saving the current editor throws the exception "2173"
And I set field "pprop" to "ja"
And I set field "pfix" to "nein"
Then saving the current editor throws the exception "2173"
And I set field "pfix" to "ja"
And I save the current editor

Scenario: 047 Kostenrechnungskonfiguration - weitere Plausi
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "ist" to "nein"
# 2218: Zur Errechnung der Soll-Ist-Abweichung werden Soll- und Istkosten benötigt!
Then saving the current editor throws the exception "2218"
And I set field "ist" to "ja"
And I set field "soll" to "nein"
Then saving the current editor throws the exception "2218"
And I set field "soll" to "ja"
And I save the current editor

Scenario: 048 Kostenrechnungskonfiguration - es duerfen nicht beide - sich ausschliessende - Optionen gewaehlt sein
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "kosbuprozeile" to "ja"
And I set field "kokos" to "ja"
Then field "kosbuprozeile" has value "nein"
And I save the current editor

Scenario: 049 Kostenrechnungskonfiguration - es duerfen nicht beide - sich ausschliessende - Optionen gewaehlt sein
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "kokos" to "ja"
And I set field "kosbuprozeile" to "ja"
Then field "kokos" has value "nein"
And I save the current editor

Scenario: 050 Kostenrechnungskonfiguration - es duerfen nicht beide - sich ausschliessende - Optionen gewaehlt sein
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "kosbuprozeile" to "ja"
And I set field "kosbuprotag" to "ja"
Then field "kosbuprozeile" has value "nein"
And I save the current editor

Scenario: 051 Kostenrechnungskonfiguration - es duerfen nicht beide - sich ausschliessende - Optionen gewaehlt sein
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "kosbuprotag" to "ja"
And I set field "kosbuprozeile" to "ja"
Then field "kosbuprotag" has value "nein"
And I save the current editor

Scenario: 052 Kostenrechnungskonfiguration - Editierbarkeit folgender Felder prüfen...
Given I open an editor "k" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
Then field "strest" is modifiable
Then field "trrest" is modifiable
Then field "ilvauto" is modifiable
Then field "vsround" is modifiable
Then field "piv" is modifiable
Then field "gekobuch" is modifiable
Then field "ist" is modifiable
Then field "pfix" is modifiable
Then field "pprop" is modifiable
Then field "soll" is modifiable
Then field "rsia" is modifiable
Then field "asia" is modifiable
Then field "pverdkst" is modifiable
Then field "pverdktr" is modifiable
Then field "pverdprj" is modifiable
Then field "ilvabschl" is modifiable
Then field "ilvko" is modifiable
Then field "ilvks" is modifiable
Then field "fertkont" is modifiable
And I save the current editor

Scenario: 053 Kostenrechnungskonfiguration - neue Kst anlegen und als neue Rest-Kostenstelle verwenden, dann eine Finanzbuchung mit Rest erzeugen, der auf die neue Rest-Ks geucht wird
Given I open an editor "kst-rest" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "such" to "rest2"
And I set field "nummer" to "1005"
And I set field "namebspr" to "Restkostenstelle2"
And I save the current editor
And I close the current editor

Given I open an editor "konf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "strest" to "rest2"
And I save the current editor
And I close the current editor

# Konto 68820 (Aufwendungen aus Rundungsdifferenzen) braucht Kostenrechnungszwang, damit Rundungsdifferenz auf Rest-Kostenstelle gebucht wird
Given I open an editor "ko-rest" from table "(Account):(Account)" with command "UPDATE" for record "68820"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "44000" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "Buchung-mit-Rest" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "KSREST2"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "K 1" in row 1
And I set field "ewsbetr" to "100,01" in row 1
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
And I set field "kstelle" to "100000" in row 2
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor

# Kst 1005 (REST2) muss in Zeile 4 der zuvor erfassten Buchung mit einer Rundungsdifferenz in der Zeile mit dem Rundungsdifferenzkonto stehen
Given I open an editor "buchung-mit-rest" from table "(Entry):(Entry)" with command "VIEW" for record "KSREST2"
Then field "konto" has value "68820" in row 4
Then field "kstelle" has value "1005" in row 4
And I close the current editor

Scenario: 054 Kostenrechnungskonfiguration - Einmaldatensatz (Normalmodus)
# 351: Datensatz existiert - Mehrfacherfassung nicht erlaubt
Then opening an editor from table "(CostType):(CostAccountingConfig)" with command "NEW" for record "" throws the exception "351"

Scenario: 055 Kostenrechnungskonfiguration - Einmaldatensatz (Wartung)
Given I'm logged in with password "annette"
# 351: Datensatz existiert - Mehrfacherfassung nicht erlaubt
Then opening an editor from table "(CostType):(CostAccountingConfig)" with command "NEW" for record "" throws the exception "351"
Given I'm logged in with password "sy"

Scenario: 056 Kostenrechnungskonfiguration - Löschen (Normalmodus)
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "DELETE" for record "KOREKONF"
# 111: darf nicht gelöscht werden
Then saving the current editor throws the exception "111"
And I close the current editor

Scenario: 057 Kostenrechnungskonfiguration - Löschen (Wartung)
Given I'm logged in with password "annette"
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "DELETE" for record "KOREKONF"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor
Given I'm logged in with password "sy"

# Einzelkostenbasis Scenario 06
Scenario: 060 Einzelkostenbasis Neuanlage 
Given I open an editor "k" from table "(CostType):(DirectCostBase)" with command "NEW" for record ""
And I set field "nummer" to "1234"
And I set field "such" to "ek1234"
Then saving the current editor throws the exception "1188"
And I close the current editor

Scenario: 061 Einzelkostenbasis - Projektkostenrechnung in Firma KONF aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
And I save the current editor

Scenario: 062 Einzelkostenbasis - Startdaten für Projektkostenrechnung in Firma TERM setzen
Given I open an editor "termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM"
And I set field "pkbabkoartgj" to "02-2"
And I set field "pkbabkoartgm" to "1"
And I save the current editor

Scenario: 063 Einzelkostenbasis - Kostenart vom Typ "Bilanzkostenart" anlegen
Given I open an editor "kostenart" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "999"
And I set field "such" to "koart999"
And I set field "bilkostart" to "ja"
And I save the current editor

Scenario: 064 Einzelkostenbasis anlegen
Given I open an editor "k" from table "(CostType):(DirectCostBase)" with command "NEW" for record ""
And I set field "nummer" to "1234"
And I set field "such" to "ek1234"
And I create a new row at the end of the table
And I set field "koart" to "999" in row 1
Then saving the current editor throws the exception "962"
And I close the current editor

# Einzelkostenbasis anlegen - Kostenart mehrfach in Tabelle eintragen plausibilisieren
Given I open an editor "k" from table "(CostType):(DirectCostBase)" with command "NEW" for record ""
And I set field "nummer" to "5000"
And I set field "such" to "ek5000"
And I create a new row at the end of the table
And I set field "koart" to "50000" in row 1
And I create a new row at the end of the table
# 3855 kommt mehrfach vor
And setting field "koart" to "50000" in row 2 throws the exception "3855"
And I set field "koart" to "54000" in row 2
And I save the current editor
And I close the current editor

Given I open an editor "k" from table "(CostType):(DirectCostBase)" with command "COPY" for record "5000"
And I set field "nummer" to "5001"
And I set field "such" to "ek5001"
And I save the current editor
And I close the current editor

# Kostentrtagermonatsumlage mit Einzelkostenbasis anlegen
Given I open an editor "um20" from table "(Assessment):(CostObjectMonthlyAssessment)" with command "NEW" for record ""
And I set field "nummer" to "20"
And I set field "such" to "um"
And I set field "ksab" to "101"
And I set field "gmon" to "1"
And I set field "ekgrp" to "5001"
And I create a new row at the end of the table
And I set field "kszu" to "100000" in row 1
And I set field "istmoproz" to "100" in row 1
And I save the current editor
Then field "absistrest" has value "0.00"
And I close the current editor

# Einzelkostenbasis Löschen
Given I open an editor "k" from table "(CostType):(DirectCostBase)" with command "DELETE" for record "5000"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Given I open an editor "k" from table "(CostType):(DirectCostBase)" with command "DELETE" for record "5001"
# 873  |Einzelkostenbasis kommt noch in einer Umlage vor. Kann nicht geloescht werden!
Then saving the current editor throws the exception "873"
And I close the current editor













