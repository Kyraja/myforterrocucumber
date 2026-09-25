# *****************************************************************************
#  Name           : fertleist_fertigungskonten.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test 
#                   1) der Plausibilisierung der Fertigungsleistungskonten in den Fertigungskontengruppen.
#                      Konten erfassen, Fertigungskonten-Objekte anlegen und plausibilisieren
#                   2) der Datenerfassung in der Rückmeldung "von links nach rechts"
#                   2)a) Andern von Daten und Auswirkung (Ermittlung davon anhängiger Daten)
#                   2)b) Leeren von Feldern; verhindert Speichern der Rückmeldung
#                   3) des Löschens von Konten, die in Fertigungskontengruppen verwendet werden
#
# *****************************************************************************
@persistent
Feature: BW2-547   
Background:
Given I set the fake date to "02.01.1995"

Scenario: 01 Stammdaten
Given I open an editor "kst" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "102"
And I set field "such" to "k102"
And I set field "fertkont" to "100"
And I save the current editor

Given I open an editor "ma" from table "(Employee):(Employee)" with command "COPY" for record "1"
And I set field "nummer" to "102"
And I set field "such" to "ma102"
And I set field "kstelle" to "102"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "66800"
And I set field "such" to "K66800"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "66900"
And I set field "such" to "K66900"
And I save the current editor

Given I open an editor "fk" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "NEW" for record ""
And I set field "nummer" to "66"
And I set field "such" to "KFKONT"
And I append rows
    | fertigungskosten     | belast    | entlast   |
    | fertigungskosten un  | 66800     | 66900     |
And I save the current editor

Given I open an editor "kst" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "600"
And I set field "such" to "k600"
And I set field "fertkont" to "66"
And I save the current editor

Given I open an editor "mgr" from table "(Capacity):(WorkCenter)" with command "COPY" for record "101"
And I set field "nummer" to "660"
And I set field "such" to "mgr660"
And I set field "kstelle" to "600"
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel  | mge | mfreig | bisuch |
    | bg1      | 12 | ja     | BETR_  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor


##################################################################
# Plausibilisierung der Datenerfassung von links nach rechts
##################################################################
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

# RM: Kst von MA1 ändern
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "makstl" to "600"
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
Then field "lohnkostsoll" has value "66800"
Then field "lohnkosthaben" has value "66900"
Then field "makstl" has value "600"
#
And I save the current editor


## Felder leeren

Given I open an editor "kst" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
And I set field "fertkont" to "100"
And I save the current editor

# RM: Mgr leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
And I set field "mgr" to ""
#
Then field "mgr" has value ""
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
Then saving the current editor throws the exception "3072"
And I set field "mgr" to "122"
# abhängige Felder neu ermitteln
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

# Mgr mehrfach hin und her wechseln (660 -> 101 -> 660 -> 101)
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
#
Then field "makstl" has value "600"
Then field "mgkstl" has value "600"
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

######################################################################################
# Plausibilisierung der Datenerfassung bei Leeren eines kontierungsrelevanten Felds
#######################################################################################
# Mgr leeren
# bimgkstl leeren
# MA leeren
# Kst MA leeren
# Sollkonto Lohn leeren
# Sollkonto Maschinenkosten var leeren
# Sollkonto Sonderkosten fix leeren

# Ausgangszustand
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
#
Then field "mgr" has value "101"
Then field "kstelle" has value "101"
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
And I close the current editor

# Mgr leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
#
And I set field "mgr" to ""
Then field "mgr" has value ""
Then field "kstelle" has value "101"
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
Then saving the current editor throws the exception "3072"
And I set field "mgr" to "101"
#
Then field "kstelle" has value "101"
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

# bimgkstl leeren
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BETR_001"
#
And I set field "mgkstl" to ""
Then field "mgkstl" has value ""
Then field "mgr" has value "101"
Then field "kstelle" has value "101"
Then field "makstl" has value "600"
# Then field "mgkstl" has value "101"
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
Then saving the current editor throws the exception "279"
# And I save the current editor
And I close the current editor

Scenario: 02 Editieren der Standardfertigungskontengruppe
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "500" 
And I set field "such" to "FKO500"
And I save the current editor

Scenario: 03 Plausibilisieren der Fertigungskontengruppe auf mehrfach vorkommende Kostenart 
#        (2822: Kostenart darf nicht mehrfach verwendet werden.)
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "COPY" for record "FK100"
And I set field "nummer" to "200"
And I set field "such" to "FK200"
And I save the current editor

Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "FK200"
And I append rows
    | fertigungskosten  | belast    | entlast   | 
    | lohn              | 99800     | 99900     | 
Then saving the current editor throws the exception "2822"
And I close the current editor

Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "FK100"
And I append rows
    | fertigungskosten  | belast    | entlast   | 
    | fertigungskosten  | 99800     | 99900     | 
    | fertigungskosten  | 99800     | 99900     | 
Then saving the current editor throws the exception "2822"
And I close the current editor

Scenario: 04 Plausibilisieren der Fertigungskontengruppe auf Nicht Vorkommen der Kostenart "Fertigungskosten undfifferenziert", falls alle 5 detaillierten Kostenarten vorkommen
#        (2829: Diese Kostenart kann nur verwendet werden, wenn mindestens zwei eindeutige Fertigungskostenarten in der Tabelle fehlen.
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "FK200"
And I append rows
   | fertigungskosten  | belast    | entlast   | 
   | fertigungskosten  | 99800     | 99900     | 
Then saving the current editor throws the exception "2829"
And I close the current editor

Scenario: 05 Plausibilisieren  des Editierens der Standardfertigungskontengruppe - Konten dürfen geaendert werden, es muessen Zeilen mit allen 5 speziellen Kostenrten enthalten sein
#         2820 de      |Die Standardfertigungskontengruppe muß alle Fertigungskostenarten enthalten.
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "500" 
And I delete row at position !lastRow
Then saving the current editor throws the exception "2820"
And I close the current editor

Scenario: 06 Plausibilisieren  des Editierens der Fertigungskontengruppe. Konten muessen eingetragen werden in Zeilen.
#         279 de      |Bitte eintragen
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "100" 
And I create a new row at the end of the table
And I set field "fertigungskosten" to "Fertigungskosten undifferenziert" in row !lastRow
Then saving the current editor throws the exception "279"
And I close the current editor

Scenario: 07 Plausibilisieren  des Editierens der Fertigungskontengruppe. Vor Hinweis auf Eintrag der Konten Kostenart prüfen. 
#        2822 de      |Kostenart darf nicht mehrfach verwendet werden.
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "100" 
And I create a new row at the end of the table
And I set field "fertigungskosten" to "Lohn" in row !lastRow
Then saving the current editor throws the exception "2822"
And I close the current editor

Scenario: 08 Plausibilisieren  des Editierens der Fertigungskontengruppe. "Fertigungskosten undifferenziert" darf nur verwendet werden, wenn mindestens zwei eindeutige Kostenarten fehlen. 
#        2829: Diese Kostenart kann nur verwendet werden, wenn mindestens zwei eindeutige Fertigungskostenarten in der Tabelle fehlen.
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "COPY" for record "100" 
And I set field "nummer" to "999"
And I set field "such" to "K999"
And I save the current editor

Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "999" 
Then the table has 5 rows
And I create a new row at the end of the table
And I set field "fertigungskosten" to "Fertigungskosten undifferenziert" in row !lastRow
And I set field "belast" to "99800" in row !lastRow
And I set field "entlast" to "99900" in row !lastRow
Then saving the current editor throws the exception "2829"
And I close the current editor

Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "999" 
And I delete row at position !lastRow
Then the table has 4 rows
And I save the current editor

Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "999" 
And I create a new row at the end of the table
And I set field "fertigungskosten" to "Fertigungskosten undifferenziert" in row !lastRow
And I set field "belast" to "99800" in row !lastRow
And I set field "entlast" to "99900" in row !lastRow
Then saving the current editor throws the exception "2829"
And I close the current editor

Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "999" 
And I delete row at position !lastRow
Then the table has 3 rows
And I save the current editor

Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "999" 
And I create a new row at the end of the table
And I set field "fertigungskosten" to "Fertigungskosten undifferenziert" in row !lastRow
And I set field "belast" to "99800" in row !lastRow
And I set field "entlast" to "99900" in row !lastRow
And I save the current editor

#######################################################################################
# BW2-1668 Löschen Konto: auch Vorkommen in Fertigungskontengruppen prüfen
#######################################################################################

Given I open an editor "ko" from table "(Account):(Account)" with command "DELETE" for record " 66800"
Then saving the current editor throws the exception "2148"
And I close the current editor

Given I open an editor "ko" from table "(Account):(Account)" with command "DELETE" for record " 66900"
Then saving the current editor throws the exception "2148"
And I close the current editor

