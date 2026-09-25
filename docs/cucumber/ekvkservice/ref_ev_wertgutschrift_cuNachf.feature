#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
#  Funktion       : hängt an den vorgängertest, rund um die Wertgutschrift, noch prozesse an... 
#
# *****************************************************************************
#
@persistent
Feature: Wertgutschriften
Background:
Given I set the fake date to "6.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: weitere TWGS fur RE30 bis alles gutgeschrieben
# ----------------------------------------------------------------------------------------------

# TWGS der zweiten Position
Given I open an editor "WGS30C" from table "(Sales):(Invoice)" with command "INVOICE" for record "+RE30"
And I set fields
   | such   | WGS30C     |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I press button "buwertgutschrift"
Then field "artikel" has value "TECH006" in row 1
And I set field "mge" to "-1" in row 1
And I save the current editor

# TWGS der zweiten Position
Given I open an editor "WGS30D" from table "(Sales):(Invoice)" with command "INVOICE" for record "+RE30"
And I set fields
   | such   | WGS30D     |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I press button "buwertgutschrift"
Then field "artikel" has value "TECH006" in row 1
And I set field "mge" to "-1" in row 1
And I save the current editor

