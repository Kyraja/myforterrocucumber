# *****************************************************************************
#  Name             : ref_op_umbew_aenderbar.feature
#  Verantwortlich   : hc 
#  Kontrolle        :
# *****************************************************************************

@persistent

Feature: ref_schreibschutz_op_umbewerten
Background: Schreibschutz

Given I set the fake date to "01.01.2022"

Scenario: Schreibschutz in Abhängigkeit von der Tabelle pruefen

Given I open an editor "umbew" from table "(OIProcessing):(ReEvaluateOutstandingItems)" with command "NEW" for record ""
Then field "kursladen" is not modifiable
And I set field "kwaehr" to "USD"
Then field "eopkursneu" is modifiable
Then field "kursladen" is modifiable
And I create a new row at the end of the table
And I set field "konto" to "18100" in row 1
Then field "kursladen" is not modifiable
Then field "eopkursneu" is not modifiable
Then field "eopkursneu" has value "0.892857"
# And I set field "eopkursneu" to "1"
Then setting field "eopkursneu" to "1" throws the exception "2057"
Then field "eopkursneu" has value "0.892857"
Then field "eopkursneu" is not modifiable
Then field "kursladen" is not modifiable
And I close the current editor
