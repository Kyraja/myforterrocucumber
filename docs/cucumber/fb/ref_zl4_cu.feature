@persistant
Feature: Edit of the  planned Payment
Background:

Scenario: EDIT_PZ
# Kalenderzyklus
    Given I open an editor "KAL" from table "(PlanningTimePeriod):(CalendarCycle)" with command "NEW" for record ""
    And I set field "such" to "Monat1"
    And I set field "zeiteinheit" to "Monat"       
    And I set field "monattag" to "1"   
    And I save the current editor
      
# Planzahlungen
    Given I open an editor "PZ" from table "(PlannedPayment):(PlannedPayment)" with command "NEW" for record ""
    Then field "iwbu" has value "EUR"
    Then field "zawaehr" has value "EUR"
    Then field "uw" has value "EUR"
    Then field "eikurs" is not modifiable
    Then field "ewekurs" is not modifiable
    Then field "betrag" is not modifiable
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.000000"
    Then field "ewekurs" has value "1.000000"
    Then field "eikurs" has value "1.000000"
    Then field "kursfix" has value "nein"
# Betrag setzen    
    And I set field "such" to "PZ1"
   	And I set field "zabetr" to "100"
    Then field "betrag" has value "100.00"
# Währung ändern auf USD
    And I set field "zawaehr" to "USD"
    Then field "eweinh" has value "1"
    Then field "eikurs" is modifiable
    Then field "ewekurs" is modifiable
    Then field "eikurs" has value "1.123800"
    And I set field "ewekurs" to "1.5"
    Then field "ewkurs" has value "1.500000"
   Then field "eikurs" has value "1.500000"
    Then field "kursfix" has value "ja"
    And I set field "kursfix" to "nein"
    Then field "eikurs" has value "1.123800"
    Then field "ewekurs" has value "1.123800"
# Währung ändern auf TRL
    And I set field "zawaehr" to "TRL"
    Then field "eikurs" is modifiable
    Then field "ewekurs" is modifiable
    Then field "eweinh" has value "1000000"
    Then field "eikurs" has value "0.000001"
    Then field "ewekurs" has value "0.775000"
    And I set field "ewekurs" to "1.5"
    Then field "eikurs" has value "0.000002"
    Then field "kursfix" has value "ja"
    And I set field "kursfix" to "nein"
    Then field "eikurs" has value "0.000001"
    Then field "ewekurs" has value "0.775000"
    And I save the current editor

# Planzahlungen
    Given I open an editor "PZ" from table "(PlannedPayment):(PlannedRepeatedPayment)" with command "NEW" for record ""
    And I set field "kzyklus" to "MONAT1"
    And I set field "anfdat" to "1.1.2000"
    And I set field "enddat" to "30.6.2000"
    Then field "iwbu" has value "EUR"
    Then field "zawaehr" has value "EUR"
    Then field "uw" has value "EUR"
    Then field "eikurs" is not modifiable
    Then field "ewekurs" is not modifiable
    Then field "betrag" is not modifiable
    Then field "iwekurs" is not modifiable
    Then field "iwekurs" has value "1.000000"
    Then field "ewekurs" has value "1.000000"
    Then field "eikurs" has value "1.000000"
    Then field "kursfix" has value "nein"
# Betrag setzen    
    And I set field "such" to "PZ1"
   	And I set field "zabetr" to "100"
    Then field "betrag" has value "100.00"
# Währung ändern auf USD
    And I set field "zawaehr" to "USD"
    Then field "eweinh" has value "1"
    Then field "eikurs" is modifiable
    Then field "ewekurs" is modifiable
    Then field "eikurs" has value "1.123800"
    And I set field "ewekurs" to "1.5"
    Then field "ewkurs" has value "1.500000"
   Then field "eikurs" has value "1.500000"
    Then field "kursfix" has value "ja"
    And I set field "kursfix" to "nein"
    Then field "eikurs" has value "1.123800"
    Then field "ewekurs" has value "1.123800"
# Währung ändern auf TRL
    And I set field "zawaehr" to "TRL"
    Then field "eikurs" is modifiable
    Then field "ewekurs" is modifiable
    Then field "eweinh" has value "1000000"
    Then field "eikurs" has value "0.000001"
    Then field "ewekurs" has value "0.775000"
    And I set field "ewekurs" to "1.5"
    Then field "eikurs" has value "0.000002"
    Then field "kursfix" has value "ja"
    And I set field "kursfix" to "nein"
    Then field "eikurs" has value "0.000001"
    Then field "ewekurs" has value "0.775000"
    And I save the current editor

