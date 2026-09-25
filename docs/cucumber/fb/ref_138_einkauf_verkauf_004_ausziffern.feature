# *****************************************************************************
#  Name             : ref_138_einkauf_verkauf_004_ausziffern.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Sammeln in der Buchung: "kvnum" wird beruecksichtigt
#
# *****************************************************************************
@persistent
Feature: ref_138_einkauf_verkauf_004_ausziffern.feature
Background:


Scenario: Sammeln in der Buchung

Given I open an editor "auftrag510" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "510au"
When I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "50" in row 1
And I set field "platz" to "F1" in row 1
Then field "kvnum" is modifiable in row 1
Then field "kvnum" has value "" in row 1
And I set field "kvnum" to "test510" in row 1
And I save the current editor

# Fakturaplan fuer Auftrag anlegen
Given I open an editor "vkfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag510"
And I set field "namebspr" to "Fakturaplan zu Auftrag 510au"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "20" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 2
And I set field "proz" to "10" in row 2
And I set field "ptext" to "2. Anzahlung" in row 2
And I set field "zbed" to "203" in row 2

# Anzahlungsrechnung1 anlegen
And I press button "anzahlungsrechn" to open a subeditor for "vkanzahlung" in row 1
And I set field "nummer" to "510anz1"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "vkfakturaplan"
Then field "sumfakturiert" has value "1000.00" in row 1
#
# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "vkanzahlung" in row 2
And I set field "nummer" to "510anz2"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "vkfakturaplan"
Then field "sumfakturiert" has value "500.00" in row 2
And I save the current editor

# Schlussrechnung anlegen
Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag510"
And I set field "nummer" to "510re"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Buchung pruefen
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,@richtung=rückwärts;@maxtreffer=1"
Then the table has 4 rows
Then field "kvnum" has value "510re" in row 1
#
Then field "konto" has value "44000" in row 2
Then field "kvnum" has value "test510" in row 2
Then field "ewhbetr" has value "5000.00" in row 2
#
# 1000 + 500
Then field "konto" has value "44000" in row 3
Then field "kvnum" has value "510au" in row 3
Then field "ewsbetr" has value "1500.00" in row 3
And I close the current editor

# Kontovorgang pruefen
Given I open an editor "kontovorgang-view1" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "S44000_510AU"
Then field "kvoffen" has value "ja"
Then field "anzahlzeil" has value "1"
And I close the current editor

# Offene Posten ausbuchen
Given I open an editor "OPAUSBU1neu" from table "102:04" with command "NEW" for record ""
And I set field "such" to "OPAUSBU"
And I set field "beleg" to "ausbu"
And I set field "gkonto" to "44000"
#
And I set field "opausgleich" to "true"
#
# ----- OP1 laden
And I create a new row at the end of the table
And I set field "tbeleg" to "510anz1" in row 1
And I press button "topladen" in row 1
And I press button "tueber" in row 1
#
Then field "opzabetr" has value "1190.00" in row 1
Then field "sha" has value "Haben" in row 1
Then field "ofbetr" has value "0.00" in row 1
#
# ----- OP2 laden
And I create a new row at the end of the table
And I set field "tbeleg" to "510anz2" in row 2
And I press button "topladen" in row 2
And I press button "tueber" in row 2
#
Then field "opzabetr" has value "595.00" in row 2
Then field "sha" has value "Haben" in row 2
Then field "ofbetr" has value "0.00" in row 2
#
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

# Kontovorgang pruefen
Given I open an editor "kontovorgang-view2" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "+S44000_510AU"
Then field "kvoffen" has value "nein"
Then field "anzahlzeil" has value "3"
And I close the current editor
########################################################################################################

