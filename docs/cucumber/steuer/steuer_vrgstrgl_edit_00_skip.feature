# *****************************************************************************
#  Name             : steuer_vrgstrgl_edit_00_skip.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbereitung der Stammdaten
#
#
# *****************************************************************************
@persistent
Feature:  steuer_vrgstrgl_edit_00_skip.feature
Background: XXX


Scenario: SKIPs

Given I open an editor "vrgstrgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "NEW" for record ""
Then field "ustart" has value ""
Then field "ustartgem" has value "nein"
And I set field "ev" to "Einkauf"
And I set field "stlaart" to "Inland"
And I set field "such" to "SKIPS"
And I set field "nummer" to "1a"
#
And I set field "ustartsf" to "ja"
Then field "ustart" has value "steuerfrei"
Then field "ustartgem" has value "nein"
#
And I set field "ustartsf" to "nein"
Then field "ustart" has value ""
Then field "ustartgem" has value "nein"
#
And I set field "ustartsp" to "ja"
And I set field "ustartrc" to "ja"
Then field "ustart" has value "steuerrelevant"
Then field "ustartgem" has value "ja"
#
And I set field "ustartsp" to "nein"
And I set field "ustartrc" to "nein"
Then field "ustart" has value ""
Then field "ustartgem" has value "nein"
#
And I set field "ustartsp" to "ja"
Then field "ustart" has value "steuerpflichtig"
Then field "ustartgem" has value "nein"
#
And I set field "ustartns" to "ja"
Then field "ustart" has value "steuerrelevant"
Then field "ustartgem" has value "ja"
#
And I save the current editor
And I close the current editor


Given I open an editor "vrgstrgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "VIEW" for record "1a"
Then field "such" has value "SKIPS"
Then field "ev" has value "Einkauf"
Then field "stlaart" has value "Inland"
Then field "ustart" has value "steuerrelevant"
Then field "ustartgem" has value "ja"
#
Then field "ustartns" has value "ja"
Then field "ustartsp" has value "ja"
Then field "ustartrc" has value "nein"
Then field "ustartsf" has value "nein"
#
Then field "zmrel" has value "nein"
And I close the current editor


Given I open an editor "vrgstrgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "UPDATE" for record "1a"
And I set field "ustartsp" to "nein"
Then field "ustart" has value "nicht steuerbar"
Then field "ustartgem" has value "nein"
#
And I save the current editor
And I close the current editor
###############################################################################


