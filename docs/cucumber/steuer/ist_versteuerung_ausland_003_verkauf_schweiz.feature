# *****************************************************************************************
#  Name           : ist_versteuerung_ausland_003_verkauf_schweiz.feature
#  Verantwortlich : wane
#  Funktion       : 
#
# ****************************************************************************************
@persistant

Feature: ist_versteuerung_ausland_003_verkauf_schweiz.feature

Background:

Scenario: Ware nach CH und in CH "Ist-Versteuerer"

# Auftrag anlegen
Given I open an editor "auftrag-111" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "num3" to "0111-AU"
And I set field "kunde" to "10007"
Then field "staat" has value "SCHWEIZ"
Then field "staat2" has value "SCHWEIZ"
#
Then field "vrgstrgl" has value "VKIN-IST-SCHWEIZ"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
Then field "vrgstrglustland" has value "SCHWEIZ"
Then field "rechnland" has value "SCHWEIZ"
Then field "vstaat" has value "SCHWEIZ"
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "20" in row 1
And I set field "preis" to "20" in row 1
Then field "konto" has value "41500CH" in row 1
Then field "ktostrgl" has value "SCHWEIZ" in row 1
Then field "vstkonto" has value "38160CH" in row 1
Then field "strgl" has value "VK5550CH" in row 1
#
And I save the current editor


# Lieferschein zum Auftrag anlegen
Given I open an editor "lieferschein-111" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-111"
And I set field "num3" to "111-LS"
#
Then field "vrgstrgl" has value "VKIN-IST-SCHWEIZ"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
#
And I set field "vom" to "."
And I set field "mge" to "20" in row 1
#
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein anlegen
Given I open an editor "rechnung-111" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-111"
And I set field "num3" to "111-RE"
And I set field "gart" to "1000000"
#
Then field "vrgstrgl" has value "VKIN-IST-SCHWEIZ"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is modifiable
Then field "vrgstrglustland" has value "SCHWEIZ"
Then field "rechnland" has value "SCHWEIZ"
Then field "vstaat" has value "SCHWEIZ"
#
And I press button "offueb" in row 1
Then field "konto" has value "41500CH" in row 1
Then field "ktostrgl" has value "SCHWEIZ" in row 1
Then field "vstkonto" has value "38160CH" in row 1
Then field "strgl" has value "VK5550CH" in row 1
#
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "111-RE"
Then field "vrgstrgl" has value "VKIN-IST-SCHWEIZ"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "38160CH" in row 3
Then field "kvnum" has value "111-RE" in row 3
Then field "ustva" has value "" in row 3
And I close the current editor


# Rechnung kopieren -> "istversteuerer" muss neu ermittelt werden
Given I open an editor "rechnung-222" from table "(Sales):(Invoice)" with command "COPY" for record "+111-RE"
Then field "istversteuerer" has value "nein"
# wird nicht gespeichert
And I close the current editor


# Wertgutschrift aus Rechnung
Given I open an editor "rechnung-222" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rechnung-111"
Then field "wertgutschrift" has value "ja"
Then field "op" has value ""
Then field "opz" has value ""
#
And I set field "num3" to "111-WGS"
And I set field "vom" to "."
#
Then field "vrgstrgl" has value "VKIN-IST-SCHWEIZ"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is modifiable
Then field "vrgstrglustland" has value "SCHWEIZ"
Then field "rechnland" has value "SCHWEIZ"
Then field "vstaat" has value "SCHWEIZ"
#
And I press button "offueb" in row 1
Then field "konto" has value "41500CH" in row 1
Then field "ktostrgl" has value "SCHWEIZ" in row 1
Then field "vstkonto" has value "38160CH" in row 1
Then field "strgl" has value "VK5550CH" in row 1
#
And I set field "ueb" to "ja"
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Buchung anschauen
Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "111-WGS"
Then field "vrgstrgl" has value "VKIN-IST-SCHWEIZ"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "38160CH" in row 3
Then field "kvnum" has value "111-RE" in row 3
Then field "ustva" has value "" in row 3
And I close the current editor
###################################################################################################
