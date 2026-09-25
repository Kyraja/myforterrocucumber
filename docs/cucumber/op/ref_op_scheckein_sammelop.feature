# *****************************************************************************
#  Name             : ref_op_scheckein_sammelop.feature
#  Autor            : Jan Effler
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Test der Bearbeitung der Eingangsschecks, Sammelart: Sammelbuchungen und Sammel-OP
#  Verwendung       : ref_op_scheckein_sammelop_cu
# *****************************************************************************

@persistent

Feature: fibu_zahlungseingang_scheckeingaenge_sammelbuchung_sammelop
Background: Zahlungseingang - Scheckeingang

Given I set the fake date to "01.06.2022"

Scenario Outline: Kunden mit Zahlart Scheck anlegen

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "zbed" to "<zbed>"
And I set field "zaform" to "Scheck"
And I save the current editor
And I close the current editor

Examples:

|    such|zbed|
| KSCHECK| 200|
|KSCHECK2| 203|
|KSCHECK3| 200|

Scenario: Geldtransitkonto mit Zahlart Scheck anlegen

Given I open an editor "konto" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "1SCHECKK"
And I set field "such" to "GTKZESE"
And I set field "namebspr" to "Geldtransitkonto Scheckeingang"
And I set field "oprel" to "ja"
And I set field "zawaehr" to "EUR"
And I set field "karta" to "Geldtransitkonto"
And I set field "zaform" to "Scheck"
And I set field "zasammelart" to "Sammelbuchungen und Sammel-OP"
And I set field "zagr" to "1000"
And I save the current editor
And I close the current editor

Scenario Outline: OPs aus Rechnungen erzeugen

Given I open an editor "rech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "kunde" to "<kunde>"
And I set field "budat" to "01.06.2022"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "<artikel>" in row 1
And I set field "mge" to "<menge>" in row 1
#  4841: Rechnungsabschlusspositionen wurden ergaenzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples:

|nummer|   kunde|artikel|menge|
| 1K1V1| KSCHECK|     V1|   25|
| 1K1V2| KSCHECK|     V2|  100|
| 1K2V1|KSCHECK2|     V1|  100|
| 1K2V2|KSCHECK2|     V2|   25|
| 1K3V1|KSCHECK3|     V1|  100|
| 1K3V2|KSCHECK3|     V2|   25|
| 2K3V1|KSCHECK3|     V1|   75|
| 2K3V2|KSCHECK3|     V2|   75|

Scenario Outline: Scheckeingaenge verbuchen - Schecks erzeugen

Given I open an editor "scheckein" from table "(OIProcessing):(IncomingPaymentsIncomingChecks)" with command "NEW" for record ""
And I set field "kbudat" to "15.06.2022"
And I set field "kwaehr" to "EUR"
And I set field "gkonto" to "1SCHECKK"
Then field "zasammelart" has value "Sammelbuchungen und Sammel-OP"
Then field "zagr" has value "1000"
And I set field "scheckeinrauto" to "ja"
And I set field "beleg" to "<beleg>"
And I set field "beldat" to "15.06.2022"
And I set field "selkonto" to "<selkonto>"
Then field "sform" has value "Scheck"
And I press button "opladen"
# Auf erwartete OPs testen
Then the table has 2 rows
Then field "op^such" has value "<op1>" in row 1
And I press button "tueber" in row 1
And I set field "schecknum" to "<schecknr>" in row 1

Then field "op^such" has value "<op2>" in row 2
And I press button "tueber" in row 2
And I set field "schecknum" to "<schecknr>" in row 2

And I press button "sammlerdatenakt"
# erwartete Sammlerdaten pruefen (erwartet wird, dass eine Buchung und ein OP erzeugt werden)
Then field "sammlerlnr" has value "1" in row 1
Then field "sammlerlnr" has value "1" in row 2
Then field "opgkolnr" has value "1" in row 1
Then field "opgkolnr" has value "1" in row 2
And I set field "scheckbetr" in row 1 to "sammlerbubetr" from editor "scheckein" in row 1
And I set field "scheckbetr" in row 2 to "sammlerbubetr" from editor "scheckein" in row 2
# 588: Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Examples:

| beleg|  selkonto|    op1|    op2|schecknr|
|K12OPS| K KSCHECK|OP1K1V1|OP1K1V2| 1SCHECK|
|K22OPS|K KSCHECK2|OP1K2V1|OP1K2V2| 2SCHECK|

Scenario: Scheckeingaenge verbuchen - vorbereitung für späteres Teilstorno - Schecks erzeugen

Given I open an editor "scheckein2" from table "(OIProcessing):(IncomingPaymentsIncomingChecks)" with command "NEW" for record ""
And I set field "kbudat" to "15.06.2022"
And I set field "kwaehr" to "EUR"
And I set field "gkonto" to "1SCHECKK"
Then field "zasammelart" has value "Sammelbuchungen und Sammel-OP"
Then field "zagr" has value "1000"
And I set field "scheckeinrauto" to "ja"
And I set field "beleg" to "K34OPS"
And I set field "beldat" to "15.06.2022"
And I set field "selkonto" to "K KSCHECK3"
Then field "sform" has value "Scheck"
And I press button "opladen"
# Auf erwartete OPs testen
Then the table has 4 rows
Then field "op^such" has value "OP1K3V1" in row 1
And I press button "tueber" in row 1
And I set field "schecknum" to "3SCHECK1" in row 1
Then field "op^such" has value "OP1K3V2" in row 2
And I press button "tueber" in row 2
And I set field "schecknum" to "3SCHECK1" in row 2
Then field "op^such" has value "OP2K3V1" in row 3
And I press button "tueber" in row 3
And I set field "schecknum" to "3SCHECK2" in row 3
Then field "op^such" has value "OP2K3V2" in row 4
And I press button "tueber" in row 4
And I set field "schecknum" to "3SCHECK2" in row 4

And I press button "sammlerdatenakt"
And I set field "scheckbetr" in row 1 to "sammlerbubetr" from editor "scheckein2" in row 1
And I set field "scheckbetr" in row 2 to "sammlerbubetr" from editor "scheckein2" in row 2
And I set field "scheckbetr" in row 3 to "sammlerbubetr" from editor "scheckein2" in row 3
And I set field "scheckbetr" in row 4 to "sammlerbubetr" from editor "scheckein2" in row 4
# erwartete Sammlerdaten pruefen (erwartet wird, dass eine Buchung und ein OP erzeugt werden sollen)
Then field "sammlerlnr" has value "1" in row 1
Then field "sammlerlnr" has value "1" in row 2
Then field "sammlerlnr" has value "1" in row 3
Then field "sammlerlnr" has value "1" in row 4

Then field "opgkolnr" has value "1" in row 1
Then field "opgkolnr" has value "1" in row 2
Then field "opgkolnr" has value "1" in row 3
Then field "opgkolnr" has value "1" in row 4
# speichern muss scheitern, da sich zwei Schecks in einem Sammler befinden
# 5953: Nur ein Scheck pro Zahlungssammler erlaubt.
Then saving the current editor throws the exception "5953"
# maximale Anzahl Buchungen im Sammler anpassen, um zwei Sammler (4 Buchungen, max 2 Buchungen pro Sammler) zu erzeugen
And I set field "zagr" to "2"
Then field "zasammelart" has value "Sammelbuchungen und Sammel-OP"
Then field "zagr" has value "2"
And I press button "sammlerdatenakt"
# erwartete Sammlerdaten pruefen (erwartet wird, dass zwei Buchungen und ein OP erzeugt werden sollen)
Then field "sammlerlnr" has value "1" in row 1
Then field "sammlerlnr" has value "1" in row 2
Then field "sammlerlnr" has value "2" in row 3
Then field "sammlerlnr" has value "2" in row 4

Then field "opgkolnr" has value "1" in row 1
Then field "opgkolnr" has value "1" in row 2
Then field "opgkolnr" has value "1" in row 3
Then field "opgkolnr" has value "1" in row 4

# 6237: Scheckbetrag passt nicht zum Sammlerbetrag
Then saving the current editor throws the exception "6237"

And I press button "sammlerdatenakt"
And I set field "scheckbetr" in row 1 to "sammlerbubetr" from editor "scheckein2" in row 1
And I set field "scheckbetr" in row 2 to "sammlerbubetr" from editor "scheckein2" in row 2
And I set field "scheckbetr" in row 3 to "sammlerbubetr" from editor "scheckein2" in row 3
And I set field "scheckbetr" in row 4 to "sammlerbubetr" from editor "scheckein2" in row 4
# 588: Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario: LOP fuer Kunden pruefen - keine OPs; OPs wurden zuvor alle mit Scheckeingang ausgeglichen

Given I open the infosystem "LOP"
And I set field "vtab" to "Kunde"
And I set field "bervon" to "KSCHECK"
And I set field "berbis" to "KSCHECK3"
And I set field "kosalden" to "ja"
And I press button "bstart"
Then the table has 0 rows
Then field "diff" has value "0.00"
And I close the current editor

Scenario: LOP fuer Geldtransitkonto pruefen - 3 OPs aus Scheckeingang

Given I open the infosystem "LOP"
And I set field "kkonto" to "1SCHECKK"
Then field "vtab" has value "Konto"
Then field "bervon" has value "1SCHECKK"
Then field "berbis" has value "1SCHECKK"
And I set field "kosalden" to "ja"
And I press button "bstart"
# 3 (Sammel-)OPs (einer je Kunde) + 1 zusammenfassende Zeile
Then the table has 4 rows
Then field "diff" has value "0.00"
And I close the current editor

Scenario: erzeugten Scheck stornieren - einziger Scheck in Sammelbuchung

Given I open an editor "storno" from table "(PaymentForm):(IncomingCheck)" with command "UPDATE" for record "X1SCHECK"
# 396: Wirklich stornieren?
And I press button "bstorno" to open a subeditor for "stornieren" in row 0 with dialog "396" and answer "ja"
And I save the current editor
And I close the current editor

Scenario: LOP fuer Kunden nach storno Scheck pruefen - 2 OPs aus storniertem Scheck

Given I open the infosystem "LOP"
And I set field "vtab" to "Kunde"
And I set field "bervon" to "KSCHECK"
And I set field "berbis" to "KSCHECK3"
And I set field "kosalden" to "ja"
And I press button "bstart"
# Eingangsscheck storniert -> Tabelle enthaelt 2 OPs des Kunden KSCHECK + 1 zusammenfassende Zeile = 3 Zeilen
Then the table has 3 rows
Then field "diff" has value "0.00"
And I close the current editor

Scenario: LOP fuer Geldtransitkonto nach storno Scheck pruefen - 2 (Sammel-)OPs verbleibend
Given I open the infosystem "LOP"
And I set field "kkonto" to "1SCHECKK"
Then field "vtab" has value "Konto"
Then field "bervon" has value "1SCHECKK"
Then field "berbis" has value "1SCHECKK"
And I set field "kosalden" to "ja"
And I press button "bstart"
# je 1 (Sammel-)OP von Kunde KSCHECK2 und KSCHECK3 + 1 zusammenfassende Zeile = 3 Zeilen
# OP aus Scheckeingang von Kunde KSCHECK fehlt hier, da der Scheckeingang zuvor storniert wurde.
Then the table has 3 rows
Then field "diff" has value "0.00"
And I close the current editor

Scenario: OP des Geldtransitkonto ausbuchen
Given I open an editor "opausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "kbudat" to "30.06.2022"
And I set field "selkonto" to "1SCHECKK"
And I set field "sform" to "Scheck"
And I press button "opladen"
# (Sammel-)OPs von 2 Kunden => 2 Tabellenzeilen
Then the table has 2 rows
And I press button "tueber" in row 1
And I press button "tueber" in row 2
And I set field "gkonto" to "18100" in row 0
And I set field "beleg" to "gtksch" in row 0
And I set field "beldat" in row 0 to "kbudat" from editor "opausb" in row 0
# 588: Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario: LOP fuer Kunden pruefen

Given I open the infosystem "LOP"
And I set field "vtab" to "Kunde"
And I set field "bervon" to "KSCHECK"
And I set field "berbis" to "KSCHECK3"
And I set field "kosalden" to "ja"
And I press button "bstart"
# 2 OPs von Kunde KSCHECK + 1 zusammenfassende Zeile
Then the table has 3 rows
Then field "diff" has value "0.00"
And I close the current editor

Scenario: LOP fuer Geldtransitkonto pruefen

Given I open the infosystem "LOP"
And I set field "kkonto" to "1SCHECKK"
Then field "vtab" has value "Konto"
Then field "bervon" has value "1SCHECKK"
Then field "berbis" has value "1SCHECKK"
And I set field "kosalden" to "ja"
And I press button "bstart"
# OPs von Geldtransitkonto wurden zuvor ausgebucht
Then the table has 0 rows
Then field "diff" has value "0.00"
And I close the current editor

Scenario: erzeugten Scheck stornieren - einer von zwei Schecks in Sammelbuchung

Given I open an editor "storno" from table "(PaymentForm):(IncomingCheck)" with command "UPDATE" for record "+X3SCHECK2"
# 396: Wirklich stornieren?
And I press button "bstorno" to open a subeditor for "stornieren" in row 0 with dialog "396" and answer "ja"
And I save the current editor
And I close the current editor

Scenario: LOP fuer Kunden pruefen

Given I open the infosystem "LOP"
And I set field "vtab" to "Kunde"
And I set field "bervon" to "KSCHECK"
And I set field "berbis" to "KSCHECK3"
And I set field "kosalden" to "ja"
And I press button "bstart"
# 2 OPs je Kunde KSCHECK und KSCHECK2 aufgrund der zuvor stornierten Eingangsschecks + 2 zusammenfassende Zeilen (eine je Kunde)
Then the table has 6 rows
Then field "diff" has value "0.00"
And I close the current editor

Scenario: LOP fuer Geldtransitkonto pruefen

Given I open the infosystem "LOP"
And I set field "kkonto" to "1SCHECKK"
Then field "vtab" has value "Konto"
Then field "bervon" has value "1SCHECKK"
Then field "berbis" has value "1SCHECKK"
And I set field "kosalden" to "ja"
And I press button "bstart"
# OPs des Geldtransitkonto bleiben unveraendert
Then the table has 0 rows
Then field "diff" has value "0.00"
And I close the current editor
