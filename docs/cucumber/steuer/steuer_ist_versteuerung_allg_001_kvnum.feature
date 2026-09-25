# *****************************************************************************
#  Name             : steuer_ist_versteuerung_allg_001_kvnum.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung von evkvnum in E/V und Weitergabe an die Buchung
#
#
# *****************************************************************************
@persistent
Feature: steuer_ist_versteuerung_allg_001_kvnum.feature
Background: Vorbelegung von evkvnum in E/V und Weitergabe an die Buchung

Given I set the fake date to "31.12.1999"

Scenario: EK-Rechnung

Given I open an editor "ek-Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num" to "50ist"
And I set field "vom" to "."
And I set field "lief" to "1"
Then field "vrgstrgl" has value "EKINL" in row 0
Then field "versteuerungsart" has value "Soll-Versteuerung" in row 0
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


#
Given I open an editor "ek-Rechnung-50ist" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "50ist"
Then field "vrgstrgl" has value "EKINL" in row 0
Then field "versteuerungsart" has value "Soll-Versteuerung" in row 0
#
Then the table has 4 rows
Then field "tename" has value "Steuer" in row 3
Then field "kvnum" is empty in row 3
Then field "kvnum" is not modifiable in row 3
Then field "konto" has value "14060" in row 3
#
And I set field "vrgstrgl" to ""
Then field "versteuerungsart" is empty in row 0
And I set field "istversteuerer" to "ja"
And I set field "vrgstrgl" to "6020"
#
Then the table has 1 rows
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


#
Given I open an editor "ek-Rechnung-50ist-test" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "50ist"
Then field "vrgstrgl" has value "EKIN-IST" in row 0
Then field "versteuerungsart" has value "Ist-Versteuerung" in row 0
And I set field "ueb" to "ja"
#
Then field "tename" has value "Steuer" in row 3
Then field "kvnum" has value "50ist" in row 3
Then field "kvnum" is modifiable in row 3
And I save the current editor
And I close the current editor


# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "50ist"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "14340" in row 3
Then field "kvnum" has value "50ist" in row 3
And I close the current editor


#
Given I open an editor "ek-Rechnung-50ist-copy" from table "(Purchasing):(Invoice)" with command "COPY" for record "+50ist"
Then field "vrgstrgl" has value "EKIN-IST" in row 0
Then field "versteuerungsart" has value "Ist-Versteuerung" in row 0
And I set field "num" to "50copy"
And I set field "ueb" to "ja"
And I set field "vom" to "."
#
Then field "tename" has value "Steuer" in row 3
Then field "kvnum" is empty in row 3
Then field "kvnum" is modifiable in row 3
And I save the current editor
And I close the current editor


#
Given I open an editor "ek-Rechnung-50copy-test" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+50copy"
Then field "vrgstrgl" has value "EKIN-IST" in row 0
Then field "versteuerungsart" has value "Ist-Versteuerung" in row 0
#
Then field "tename" has value "Steuer" in row 3
Then field "kvnum" has value "50copy" in row 3
Then field "kvnum" is not modifiable in row 3
And I close the current editor


# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "50copy"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "14340" in row 3
Then field "kvnum" has value "50copy" in row 3
And I close the current editor
# #######################################################################################

