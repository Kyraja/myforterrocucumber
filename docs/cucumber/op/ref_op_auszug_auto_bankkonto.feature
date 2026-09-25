# *****************************************************************************
#  Name             : ref_op_auszug_auto_bankkonto.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Bearbeitung der Bankkontoauszüge (90:1), automatische Zuordnung des Bankkontos
#  ref              : ref_op_auszug_auto_bankkonto_cu
# *******************************************************************************
@persistent
Feature: Bankimport, automatische Zuordnung, Zuordnung des Bankkontos

Background:
Given I set the fake date to "02.01.2022"

# Betroffen:
# - Bankkontoauszug 1 mit der IBAN "DE87200500001234567890" und Bankkontonummer leer
# - Bankkonto über IBAN zuordnen (s. ABS-1365)
# - Ausschließen, bereits zugeordnetes Bankkonto unverändert lassen

# ---------------------------------------------------------------------------------------------
Scenario: Vorbelegung der relevanten Daten prüfen
# ---------------------------------------------------------------------------------------------

# ----- Ist das Sachkonto 18100 ein Bankkonto?
Given I open an editor "KO18100zeigen" from table "5:1" with command "VIEW" for record "18100"
Then field "karta" has value "Bankkonto"
And I close the current editor

# ----- Bankkontoauszug 1, Vorbelegung der Felder: Bankkonto, IBAN, Kontonummer (Bankkontonummer)
Given I open an editor "Bankkontoauszug1-0" from table "90:1" with command "VIEW" for record "1"
Then field "bkonto" has value ""
Then field "iban" has value "DE87200500001234567890"
Then field "konum" has value ""
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Gleiche IBAN, aber mit Leerzeichen in Bankverbindung erfasst, Bankkontoauszug zuordnen ==> Bankkonto nicht zugeordnet
# ---------------------------------------------------------------------------------------------

# ----- Bankverbindung für Bankkonto 18100 mit IBAN "DE87 2005 0000 1234 5678 90" erfassen

Given I open an editor "Bank-BANK-1" from table "96:1" with command "NEW" for record ""
And I set fields
  | nummer   | 1BANK    |
  | such     | BANK     |
  | name     | Bank Bezeichnung |
  | nident   | 18100181 |
And I save the current editor

Given I open an editor "Bankverbindung-18100-1" from table "96:2" with command "NEW" for record ""
And I set fields
  | nummer | 18100-1   |
  | such   | BANK18100 |
  | konto  | 18100 |
  | koinh  | Eigene Firma |
  | bank   | 1BANK      |
  | konum  |            |
  | iban   | DE87 2005 0000 1234 5678 90 |
And I save the current editor

# ----- Bankkontoauszug 1 zuordnen ==> Bankkonto nicht zugeordnet

Given I open an editor "Bankkontoauszug1-1" from table "90:1" with command "UPDATE" for record "1"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# ==> Bankkonto nicht zugeordnet
Then field "bkonto" has value ""
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Gleiche IBAN in Bankverbindung erfasst, Bankkontoauszug zuordnen ==> Bankkonto wird zugeordnet
# ---------------------------------------------------------------------------------------------

# ----- Bankverbindung für Bankkonto 18100 mit IBAN "DE87200500001234567890" erfassen

Given I open an editor "Bankverbindung-18100-1" from table "96:2" with command "NEW" for record ""
And I set fields
  | nummer | 18100-2   |
  | such   | BANK18100 |
  | konto  | 18100 |
  | koinh  | Eigene Firma |
  | bank   | 1BANK      |
  | konum  |            |
  | iban   | DE87200500001234567890 |
And I save the current editor

# ----- Bankkontoauszug 1 zuordnen ==> Bankkonto zugeordnet

Given I open an editor "Bankkontoauszug1-2" from table "90:1" with command "UPDATE" for record "1"
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# ==> Bankkonto 18100 zugeordnet
Then field "bkonto" has value "18100"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Bankkonto vorbelegt, Bankkontoauszug zuordnen ==> Bankkonto bleibt unverändert
# ---------------------------------------------------------------------------------------------

# ----- Bankkontoauszug 1 zuordnen ==> Bankkonto nicht zugeordnet

Given I open an editor "Bankkontoauszug1-3" from table "90:1" with command "UPDATE" for record "1"
# Bankkonto 18200 vorbelegen
And I set field "bkonto" to "18200"
# Zuordnen
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# ==> Bankkonto 18200 bleibt unverändert
Then field "bkonto" has value "18200"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Bankkonto leeren, Bankkontoauszug zuordnen ==> Bankkonto wird vorbelegt
# ---------------------------------------------------------------------------------------------

# ----- Bankkontoauszug 1 zuordnen ==> Bankkonto nicht zugeordnet

Given I open an editor "Bankkontoauszug1-4" from table "90:1" with command "UPDATE" for record "1"
# Bankkonto leeren
And I set field "bkonto" to ""
# Zuordnen
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
# ==> Bankkonto wurde (über IBAN) zugeordnet
Then field "bkonto" has value "18100"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Bankkontoauszug ausschließen ==> Bankkonto bleibt unverändert
# ---------------------------------------------------------------------------------------------

Given I open an editor "Bankkontoauszug1-ausschliessen" from table "90:1" with command "UPDATE" for record "1"
Then field "bkonto" has value "18100"
And I press button "bausschl" to open a subeditor for "Ausschließen"
And I save the current subeditor to switch back to the parent editor
# ==> Bankkonto bleibt unverändert
Then field "bkonto" has value "18100"
And I save the current editor
