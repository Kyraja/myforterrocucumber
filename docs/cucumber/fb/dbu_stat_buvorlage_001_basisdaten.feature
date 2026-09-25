# *****************************************************************************
#  Name             : dbu_stat_buvorlage_001_basisdaten.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
#
# *****************************************************************************
@persistent
Feature: dbu_stat_buvorlage_001_basisdaten.feature
Background: Stammdaten anlegen

Given I set the fake date to "10.02.02"


Scenario: stat. Vorlagen

Given I open an editor "statBUVORL1" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I set field "such" to "Y3"
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "kstelle" to "101" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "hbetrag" to "77" in row 2
And I set field "kstelle" to "100" in row 2
And I respond with answer "Ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Given I open an editor "statBUVORL2" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I set field "such" to "Y4"
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "kstelle" to "100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "hbetrag" to "1111" in row 2
And I set field "kstelle" to "100000" in row 2
And I respond with answer "Ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: neu DBRegeln

Given I open an editor "dbregel1" from table "(RecurringEntry):(RecurringEntryRules)" with command "NEW" for record ""
And I set field "such" to "DBR-WOCH"
And I set field "name" to "stat. Buchungen; wochentlich"
And I create a new row at the end of the table
And I set field "rbuchvorl" to "Y3" in row 1
And I set field "kzyklus" to "W1" in row 1
And I set field "budatvon" to "10.02.02" in row 1
And I create a new row at the end of the table
And I set field "rbuchvorl" to "Y4" in row 2
And I set field "kzyklus" to "W1" in row 2
And I set field "budatvon" to "10.02.02" in row 2
And I create a new row at the end of the table
And I set field "rbuchvorl" to "9" in row 3
And I set field "kzyklus" to "W1" in row 3
And I set field "budatvon" to "10.02.02" in row 3
And I save the current editor
And I close the current editor


Given I open an editor "dbregel2" from table "(RecurringEntry):(RecurringEntryRules)" with command "NEW" for record ""
And I set field "such" to "DBR-MO"
And I set field "name" to "stat. Buchungen; wochentlich"
And I create a new row at the end of the table
# statistische BV
And I set field "rbuchvorl" to "Y3" in row 1
And I set field "kzyklus" to "M-2" in row 1
And I set field "budatvon" to "10.02.02" in row 1
And I create a new row at the end of the table
# statistische BV
And I set field "rbuchvorl" to "Y4" in row 2
And I set field "kzyklus" to "M-2" in row 2
And I set field "budatvon" to "10.02.02" in row 2
And I create a new row at the end of the table
# FinanzBV
And I set field "rbuchvorl" to "9" in row 3
And I set field "kzyklus" to "M-2" in row 3
And I set field "budatvon" to "10.02.02" in row 3
And I save the current editor
And I close the current editor
# =========================================================================================

