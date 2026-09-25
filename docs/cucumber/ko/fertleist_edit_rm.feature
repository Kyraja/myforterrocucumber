# *****************************************************************************
#  Name           : fertleist_edit_rm.feature             
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test der Datenerfassung in der Rückmeldung "von links nach rechts".
#                   a) Ändern von Daten und Auswirkung der Änderung (Ermittlung davon anhängiger Daten)
#                   b) Leeren von Feldern. Leere Felder verhindern das Speichern der Rückmeldung
#                   Plausibilierung der eingetragenen Konten in der Rückmeldung.
#
# *****************************************************************************
@persistent
Feature: BW2-547   
Background:
Given I set the fake date to "02.01.1995"

Scenario: 00 RM buchen
Given I open an editor "Rtsckmeldung1_AS1" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "BETR_001"
And I save the current editor

Scenario: 01 Plausibilisierung der Datenerfassung von links nach rechts

# (MA hat keine eigene Kst)
# (Mgr ändern)
# (Ma ändern)
# (mgkstl ändern)
# (makstl ändern)
# Feld der oberen leeren
# Konto leeren

# zunächst RM erfassen, Mitarbeiter hat keine eigene Kst 
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BETR_001"
And I set field "ma" to "1"
And I set field "lgr" to "2"
And I set field "bzeit" to "1,5"
And I set field "mzeit" to "2,5"
Then field "mgkstl" has value "101"
Then field "mkostfixsoll" has value "88200"
Then field "mkostfixhaben" has value "88201"
Then field "mkostvarsoll" has value "88300"
Then field "mkostvarhaben" has value "88301"
Then field "skostfixsoll" has value "88400"
Then field "skostfixhaben" has value "88401"
Then field "skostvarsoll" has value "88500"
Then field "skostvarhaben" has value "88501"
Then field "lohnkostsoll" has value "97100"
Then field "lohnkosthaben" has value "97101"
Then field "makstl" has value "100"
And I save the current editor

# RM: anderen Mitarbeiter mit eigener Kst eintragen
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "ma" to "102"
And I set field "lgr" to "2"
And I set field "bzeit" to "1,5"
And I set field "mzeit" to "2,5"
#
Then field "mgkstl" has value "101"
Then field "mkostfixsoll" has value "88200"
Then field "mkostfixhaben" has value "88201"
Then field "mkostvarsoll" has value "88300"
Then field "mkostvarhaben" has value "88301"
Then field "skostfixsoll" has value "88400"
Then field "skostfixhaben" has value "88401"
Then field "skostvarsoll" has value "88500"
Then field "skostvarhaben" has value "88501"
Then field "lohnkostsoll" has value "88100"
Then field "lohnkosthaben" has value "88101"
Then field "makstl" has value "102"
#
And I save the current editor

# RM: andere Mgr mit KV eintragen
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "mgr" to "200"
#
Then field "mgkstl" has value "10"
Then field "mkostfixsoll" has value "97200"
Then field "mkostfixhaben" has value "97201"
Then field "mkostvarsoll" has value "97300"
Then field "mkostvarhaben" has value "97301"
Then field "skostfixsoll" has value "97400"
Then field "skostfixhaben" has value "97401"
Then field "skostvarsoll" has value "97500"
Then field "skostvarhaben" has value "97501"
Then field "lohnkostsoll" has value "88100"
Then field "lohnkosthaben" has value "88101"
Then field "makstl" has value "102"
#
And I save the current editor

# RM: andere Mgr mit eigener Kst eintragen
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "mgr" to "660"
#
Then field "mgkstl" has value "600"
Then field "mkostfixsoll" has value "66800"
Then field "mkostfixhaben" has value "66900"
Then field "mkostvarsoll" has value "66800"
Then field "mkostvarhaben" has value "66900"
Then field "skostfixsoll" has value "66800"
Then field "skostfixhaben" has value "66900"
Then field "skostvarsoll" has value "66800"
Then field "skostvarhaben" has value "66900"
Then field "lohnkostsoll" has value "88100"
Then field "lohnkosthaben" has value "88101"
Then field "makstl" has value "102"
#
And I save the current editor

# RM: Kst der Mgr ändern
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "mgkstl" to "100"
#
Then field "mgr" has value "660"
Then field "mkostfixsoll" has value "97200"
Then field "mkostfixhaben" has value "97201"
Then field "mkostvarsoll" has value "97300"
Then field "mkostvarhaben" has value "97301"
Then field "skostfixsoll" has value "97400"
Then field "skostfixhaben" has value "97401"
Then field "skostvarsoll" has value "97500"
Then field "skostvarhaben" has value "97501"
Then field "lohnkostsoll" has value "88100"
Then field "lohnkosthaben" has value "88101"
Then field "makstl" has value "102"
#
And I save the current editor

# RM: KV bei MA1 erfassen
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "makstl" to "10"
#
Then field "mgr" has value "660"
Then field "mgkstl" has value "100"
Then field "mkostfixsoll" has value "97200"
Then field "mkostfixhaben" has value "97201"
Then field "mkostvarsoll" has value "97300"
Then field "mkostvarhaben" has value "97301"
Then field "skostfixsoll" has value "97400"
Then field "skostfixhaben" has value "97401"
Then field "skostvarsoll" has value "97500"
Then field "skostvarhaben" has value "97501"
Then field "lohnkostsoll" has value "97100"
Then field "lohnkosthaben" has value "97101"
Then field "makstl" has value "10"
#
And I save the current editor

# RM: Kst von MA1 ändern
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "makstl" to "600"
#
Then field "mgr" has value "660"
Then field "mgkstl" has value "100"
Then field "mkostfixsoll" has value "97200"
Then field "mkostfixhaben" has value "97201"
Then field "mkostvarsoll" has value "97300"
Then field "mkostvarhaben" has value "97301"
Then field "skostfixsoll" has value "97400"
Then field "skostfixhaben" has value "97401"
Then field "skostvarsoll" has value "97500"
Then field "skostvarhaben" has value "97501"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
Then field "makstl" has value "600"
#
And I save the current editor

Scenario: 02 Mgr mehrfach hin und her wechseln
# 
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
#
Then field "mgr" has value "660"
Then field "mgkstl" has value "100"
Then field "makstl" has value "600"
Then field "mkostfixsoll" has value "97200"
Then field "mkostfixhaben" has value "97201"
Then field "mkostvarsoll" has value "97300"
Then field "mkostvarhaben" has value "97301"
Then field "skostfixsoll" has value "97400"
Then field "skostfixhaben" has value "97401"
Then field "skostvarsoll" has value "97500"
Then field "skostvarhaben" has value "97501"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
#
And I set field "mgr" to "101"
#
Then field "makstl" has value "600"
Then field "mgkstl" has value "101"
Then field "mkostfixsoll" has value "88200"
Then field "mkostfixhaben" has value "88201"
Then field "mkostvarsoll" has value "88300"
Then field "mkostvarhaben" has value "88301"
Then field "skostfixsoll" has value "88400"
Then field "skostfixhaben" has value "88401"
Then field "skostvarsoll" has value "88500"
Then field "skostvarhaben" has value "88501"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
#
And I set field "mgr" to "660"
#
Then field "makstl" has value "600"
Then field "mgkstl" has value "600"
Then field "mkostfixsoll" has value "66800"
Then field "mkostfixhaben" has value "66900"
Then field "mkostvarsoll" has value "66800"
Then field "mkostvarhaben" has value "66900"
Then field "skostfixsoll" has value "66800"
Then field "skostfixhaben" has value "66900"
Then field "skostvarsoll" has value "66800"
Then field "skostvarhaben" has value "66900"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
#
And I set field "mgr" to "101"
#
Then field "makstl" has value "600"
Then field "mgkstl" has value "101"
Then field "mkostfixsoll" has value "88200"
Then field "mkostfixhaben" has value "88201"
Then field "mkostvarsoll" has value "88300"
Then field "mkostvarhaben" has value "88301"
Then field "skostfixsoll" has value "88400"
Then field "skostfixhaben" has value "88401"
Then field "skostvarsoll" has value "88500"
Then field "skostvarhaben" has value "88501"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
#
And I save the current editor

Scenario: 03 Plausibilisierung der Datenerfassung beim Leeren eines kontierungsrelevanten Felds
# RM: Mgr leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "mgr" to ""
#
Then field "mgr" has value ""
Then field "mgkstl" has value "101"
Then field "mkostfixsoll" has value "88200"
Then field "mkostfixhaben" has value "88201"
Then field "mkostvarsoll" has value "88300"
Then field "mkostvarhaben" has value "88301"
Then field "skostfixsoll" has value "88400"
Then field "skostfixhaben" has value "88401"
Then field "skostvarsoll" has value "88500"
Then field "skostvarhaben" has value "88501"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
Then field "makstl" has value "600"
#
# 3072 de      |Bitte Maschinengruppe/Abteilung eintragen
Then saving the current editor throws the exception "3072"
And I set field "mgr" to "122"
Then field "mgkstl" has value "101"
Then field "mkostfixsoll" has value "88200"
Then field "mkostfixhaben" has value "88201"
Then field "mkostvarsoll" has value "88300"
Then field "mkostvarhaben" has value "88301"
Then field "skostfixsoll" has value "88400"
Then field "skostfixhaben" has value "88401"
Then field "skostvarsoll" has value "88500"
Then field "skostvarhaben" has value "88501"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
Then field "makstl" has value "600"
And I save the current editor

# RM: Kst Mgr leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "mgkstl" to ""
Then field "mgkstl" has value ""
Then saving the current editor throws the exception "279"
#
Then field "mkostfixsoll" has value "88200"
Then field "mkostfixhaben" has value "88201"
Then field "mkostvarsoll" has value "88300"
Then field "mkostvarhaben" has value "88301"
Then field "skostfixsoll" has value "88400"
Then field "skostfixhaben" has value "88401"
Then field "skostvarsoll" has value "88500"
Then field "skostvarhaben" has value "88501"
Then field "makstl" has value "600"
#
And I set field "mgr" to "660"
Then field "mgkstl" has value "600"
Then field "mkostfixsoll" has value "66800"
Then field "mkostfixhaben" has value "66900"
Then field "mkostvarsoll" has value "66800"
Then field "mkostvarhaben" has value "66900"
Then field "skostfixsoll" has value "66800"
Then field "skostfixhaben" has value "66900"
Then field "skostvarsoll" has value "66800"
Then field "skostvarhaben" has value "66900"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
Then field "makstl" has value "600"
#
And I save the current editor

# MA leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "ma" to ""
Then field "mgkstl" has value "600"
Then field "makstl" has value "600"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
#
And I save the current editor
#
Then field "mgkstl" has value "600"
Then field "mkostfixsoll" has value "66800"
Then field "mkostfixhaben" has value "66900"
Then field "mkostvarsoll" has value "66800"
Then field "mkostvarhaben" has value "66900"
Then field "skostfixsoll" has value "66800"
Then field "skostfixhaben" has value "66900"
Then field "skostvarsoll" has value "66800"
Then field "skostvarhaben" has value "66900"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
Then field "makstl" has value "600"
#

# Kst MA leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "makstl" to ""
#
Then field "makstl" has value ""
Then field "mgkstl" has value "600"
Then field "mkostfixsoll" has value "66800"
Then field "mkostfixhaben" has value "66900"
Then field "mkostvarsoll" has value "66800"
Then field "mkostvarhaben" has value "66900"
Then field "skostfixsoll" has value "66800"
Then field "skostfixhaben" has value "66900"
Then field "skostvarsoll" has value "66800"
Then field "skostvarhaben" has value "66900"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
#
Then saving the current editor throws the exception "7147"
And I set field "makstl" to "600"
And I save the current editor

# Lohnkonto leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "lohnkostsoll" to ""
Then field "lohnkostsoll" has value ""
Then saving the current editor throws the exception "57"
And I set field "lohnkostsoll" to "66800"
And I save the current editor
#
Then field "makstl" has value "600"
Then field "mgkstl" has value "600"
Then field "mkostfixsoll" has value "66800"
Then field "mkostfixhaben" has value "66900"
Then field "mkostvarsoll" has value "66800"
Then field "mkostvarhaben" has value "66900"
Then field "skostfixsoll" has value "66800"
Then field "skostfixhaben" has value "66900"
Then field "skostvarsoll" has value "66800"
Then field "skostvarhaben" has value "66900"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
#

# Maschinenkostenkonto leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "mkostfixsoll" to ""
Then saving the current editor throws the exception "57"
#
Then field "makstl" has value "600"
Then field "mgkstl" has value "600"
And I set field "mkostfixsoll" to "99800"
Then field "mkostfixsoll" has value "99800"
Then field "mkostfixhaben" has value "66900"
Then field "mkostvarsoll" has value "66800"
Then field "mkostvarhaben" has value "66900"
Then field "skostfixsoll" has value "66800"
Then field "skostfixhaben" has value "66900"
Then field "skostvarsoll" has value "66800"
Then field "skostvarhaben" has value "66900"
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
#
And I save the current editor

Scenario: 04 Plausiprüfung der Konten in der RM
# 
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
Then setting field "lohnkostsoll" to "99001" throws the exception "2986"
Then setting field "lohnkosthaben" to "99002" throws the exception "2986"
Then setting field "lohnkostsoll" to "11400" throws the exception "2986"
Then setting field "lohnkosthaben" to "54000" throws the exception "2986"
Then setting field "lohnkostsoll" to "12000" throws the exception "2986"
Then setting field "lohnkosthaben" to "99006" throws the exception "53"
#
Then setting field "mkostfixsoll" to "99001" throws the exception "2986"
Then setting field "mkostfixhaben" to "99002" throws the exception "2986"
Then setting field "mkostvarsoll" to "11400" throws the exception "2986"
Then setting field "mkostvarhaben" to "54000" throws the exception "2986"
Then setting field "skostfixsoll" to "12000" throws the exception "2986"
Then setting field "skostfixhaben" to "99006" throws the exception "53"

Scenario: 05 Erfassen Arbeitszeit ohne Mitarbeiter, dann fehlt erst mal die Kst für den MA
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BETR_002"
And I set field "lgr" to "2"
And I set field "bzeit" to "1,5"
Then field "makstl" has value "101"
Then field "lohnkostsoll" has value "88100"
Then field "lohnkosthaben" has value "88101"
And I save the current editor

Scenario: 06 Test, dass bei Fehlen der Kontierung zu einer Kostenart und nicht vorhandener Kostenart "Fertigungskosten undifferenziert" auf die Standardfertigungskontengruppe zugegriffen wird
# Fertigungskontengruppe 200 in Kst 101
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "200" 
# Zeile mit Kostenart "Lohn" loeschen
And I delete row at position 1
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
And I set field "fertkont" to "200"
And I save the current editor

Given I open an editor "Rueckmeldung6" from table "(Workorder):(WorkOrders)" with command "DONE" for record "1002001"
# And I set field "ma" to "1"
And I set field "lgr3" to "3"
And I set field "bzeit3" to "2"
And I set field "mzeit3" to "2"
Then field "makstl3" has value "101"
Then field "lohnkostsoll3" has value "97100"
Then field "lohnkosthaben3" has value "97101"
Then field "mkostfixsoll" has value "88200"
Then field "mkostfixhaben" has value "88201"
And I save the current editor







