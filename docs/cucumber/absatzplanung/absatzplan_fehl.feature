@persistent
Feature: absatzplan_fehl.feature

Background:
Given I set the fake date to "01.02.2009"

# **********************************************************************************
#  Name             : absatzplan_fehl.feature
#  Autor            : foe
#  Verantwortlich   : foe
#  Kontrolle        :
#  Funktion         : Test von nicht erlaubten Angaben in der Absatzplanung
#
# **********************************************************************************

##############################################################################################################

Scenario: Planungseinheit fuer Set-Artikel nicht erlaubt, auch nicht als Herkunft der Basisdaten

Given I open an editor "PESet" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set field "such" to "PE09SET"
And I set field "name" to "PE 2009 SET"
And I set field "planung" to "PLANUNG2009"
And setting field "artber" to "SET" throws the exception "6820"
And I set field "artber" to "E1"
And setting field "herkunft" to "SET" throws the exception "6820"
And I close the current editor

Scenario: Planungseinheit mit SET auch im Tabelle nicht eintragbar 

Given I open an editor "PESET" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09GESCHIRR"
And I set field "anzauto" to "ja"
And I press button "knstanz"
Then the table has 4 rows
And I create a new row at the end of the table
And setting field "tartber" to "SET" in row 5 throws the exception "6820"
And I close the current editor

Scenario: Set in Artikelbereich nicht planungsrelevant

Given I open an editor "ABMITSET" from table "(ProductRange):(ProductRange)" with command "UPDATE" for record "P1-3"
Then the table has 3 rows
And I create a new row at the end of the table
And I set field "artikel" to "SET" in row 4
And setting field "plaktiv" to "ja" in row 4 throws the exception "203"
And I close the current editor
