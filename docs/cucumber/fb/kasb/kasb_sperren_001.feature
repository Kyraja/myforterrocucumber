# *****************************************************************************
#  Name             : kasb_sperren_001.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Sperren von Konten und Kostenobjekten in Kassenbuch
#
#
#    moegliche Stelle, wo Konten vorkommen koennen:
#    * gkonto
#    * skonto, skonto2
#    * skkonto
#    * estkonto
#    * vstkonto
#
#    moegliche Stelle, wo Kostenobjekte vorkommen koennen:
#    * kstelle
#    * skstelle, s2kstelle
#
#   ausserdem gibt es eine "Bedingungsvariable, die Sperren in Kassenbuch steuert:
#   * skontosperredeakt
#
#
# siehe auch ref_kasb_zn_sperrpruef_cu bzw. kasb_zn_sperrpruef.feature
#
# *****************************************************************************

@persistent
Feature: Kassenbuch und Sperren
Background: Sperren in Kassenbuch

Given I set the fake date to "03.02.2002"


Scenario: Vorbereitung: Stammdaten

Given I open an editor "konto" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "100a"
And I save the current editor
And I close the current editor
###############################################################################


Scenario: Versuch das Kassenkonto aus Standardkontierung zu sperren

Given I open an editor "kassenkonto" from table "(Account):(Account)" with command "UPDATE" for record "16000"
Then field "karta" has value "Kassenkonto"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
#
# 2203 TX=de   |Sperre nicht m”glich, da das Objekt in der Standardkontierung verwendet wird.
Then saving the current editor throws the exception "2203"
And I close the current editor
###############################################################################


Scenario: (Gegen)Konto/Kostenstelle sperren
Given I open an editor "Kassenbuch" from table "(CashBook):(CashBook)" with command "UPDATE" for record "18"
Then field "kasskto" has value "16004"
Then field "endbest" has value "-300.00"
Then field "isgebucht" has value "nein"
#
And I create a new row at the end of the table
And I set field "beldat" to "15.02.02" in row !lastRow
And I set field "beinn" to "1500" in row !lastRow
And I set field "gkonto" to "45001" in row !lastRow
And I set field "kstelle" to "100a" in row !lastRow
#
Then field "isbestkorr" has value "nein" in row !lastRow
Then field "skontosperredeakt" has value "ja" in row !lastRow
Then field "skstelle" has value "" in row !lastRow
Then field "s2kstelle" has value "" in row !lastRow
#
And I save the current editor
And I close the current editor


# Konto sperren
Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "45001"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I save the current editor
And I close the current editor


Given I open an editor "kasb-frei" from table "(CashBook):(CashBook)" with command "UPDATE" for record "18"
And I press button "allefr"
#   4806 TX=de   |Objekt ist gesperrt.
Then saving the current editor throws the exception "4806"
#   2743 TX=de   |Vorgang abgebrochen
Then saving the current editor throws the exception "2743"
And I close the current editor


Given I'm logged in with password "sy"
Given I open an editor "kasb-uebertragen" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "18"
#   4806 TX=de   |Objekt ist gesperrt.
Then saving the current editor throws the exception "4806"
#   2743 TX=de   |Vorgang abgebrochen
Then saving the current editor throws the exception "2743"
And I close the current editor


# Konto entsperren
Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "45001"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor


# Kostenstelle sperren
Given I open an editor "konto" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor
And I close the current editor


Given I open an editor "kasb-frei2" from table "(CashBook):(CashBook)" with command "UPDATE" for record "18"
And I press button "allefr"
#   4806 TX=de   |Objekt ist gesperrt.
Then saving the current editor throws the exception "4806"
#   2743 TX=de   |Vorgang abgebrochen
Then saving the current editor throws the exception "2743"
And I close the current editor


Given I'm logged in with password "sy"
Given I open an editor "kasb-uebertragen2" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "18"
#   4806 TX=de   |Objekt ist gesperrt.
Then saving the current editor throws the exception "4806"
#   2743 TX=de   |Vorgang abgebrochen
Then saving the current editor throws the exception "2743"
And I close the current editor

# Kostenstelle entsperren
Given I open an editor "konto" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: Versuch das Kassenkonto, das in einem KB verwendet wird zu sperren

Given I open an editor "kassenbuch-view" from table "(CashBook):(CashBook)" with command "VIEW" for record "18"
Then field "kasskto" has value "16004"
Then field "endbest" has value "1200.00"
Then field "isgebucht" has value "nein"
And I close the current editor


# Kassenkonto, das in einem Kassenbuch verwendet wird, wird gesperrt
Given I open an editor "kassenkonto-sperren" from table "(Account):(Account)" with command "UPDATE" for record "16004"
Then field "karta" has value "Kassenkonto"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I save the current editor
And I close the current editor


#
Given I open an editor "kasb-frei4" from table "(CashBook):(CashBook)" with command "UPDATE" for record "18"
And I press button "allefr"
#   4806 TX=de   |Objekt ist gesperrt.
Then saving the current editor throws the exception "4806"
#   2743 TX=de   |Vorgang abgebrochen
Then saving the current editor throws the exception "2743"
And I close the current editor


Given I'm logged in with password "sy"
Given I open an editor "kasb-uebertragen4" from table "(CashBook):(CashBook)" with command "TRANSFER" for record "18"
#   4806 TX=de   |Objekt ist gesperrt.
Then saving the current editor throws the exception "4806"
#   2743 TX=de   |Vorgang abgebrochen
Then saving the current editor throws the exception "2743"
And I close the current editor


# gesperrtes Kassenkonto wird entsperrt
Given I open an editor "kassenkonto-sperren" from table "(Account):(Account)" with command "UPDATE" for record "16004"
Then field "karta" has value "Kassenkonto"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor
###############################################################################

