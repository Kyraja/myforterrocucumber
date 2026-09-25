# *****************************************************************************
#  Name             : steuer_ist_versteuerung_allg_005_anzahlung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : 
#
#
# *****************************************************************************
@persistent
Feature: steuer_ist_versteuerung_allg_005_anzahlung.feature
Background: 

Given I set the fake date to "31.12.1999"


Scenario: Stammdaten anpassen

# Vorbereitung: Vorgangsteuerkonfiguration anpassen
Given I open an editor "PrcesstaxConf" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
|ev     |rechnlaart|bestlaart|vrgstrgl|istversteuerer|standard|
|Einkauf|Inland    |Inland   |6000    |            ja|    nein|
And I save the current editor
###################################################################################################

Scenario: EK, Anzahlung


# Bestellung anlegen
Given I open an editor "bestellung-100" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "0100-BE"
#
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "250" in row 1
#
And I create a new row at the end of the table
And I set field "artex" to "ANZAHLUNG" in row 2
#
And I save the current editor

# Anzahlungsrechnung aus Bestellung anlegen
Given I open an editor "rechnung-100anz" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-100"
And I set field "num4" to "100-ANZ"
And I set field "vom" to "."
Then the table has 2 rows
And I set field "vorgang" to "Anzahlung"
Then field "rebubeizahlung" has value "ja"
Then the table has 1 rows
#
Then field "vrgstrgl" has value "EKIN-IST"
Then field "fixvrgstrgl" has value "nein"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is modifiable
#
And I set field "istversteuerer" to "ja"
Then field "artex" has value "ANZAHLUNG" in row 1
Then field "konto" has value "50000" in row 1
Then field "pwert" has value "0.00" in row 1
And I set field "pwert" to "3000" in row 1
#
And I set field "ueb" to "ja"
# 2164 |Fuer Bar-Rechnungen und Anzahlungsrechnungen nur Vorgangssteuerregeln mit Steuerbuchungsart = Sollversteuerung erlaubt.
Then saving the current editor throws the exception "2164"
#
And I set field "vrgstrgl" to "EKINL"
Then field "vrgstrgl" has value "EKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ANZ-Rechnung kopieren -> "istversteuerer" muss neu ermittelt werden
Given I open an editor "rechnung-anz2" from table "(Purchasing):(Invoice)" with command "COPY" for record "+100-ANZ"
Then field "istversteuerer" has value "nein"
And I set field "num4" to "100-ANZ2"
And I set field "vrgstrgl" to "EKINL"
Then field "vrgstrgl" has value "EKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "vorgang" has value "R"
Then field "rebubeizahlung" has value "nein"
#
And I set field "vorgang" to "Anzahlung"
Then field "rebubeizahlung" has value "ja"
Then the table has 0 rows
And I create a new row at the end of the table
Then setting field "artex" to "ANZAHLUNG" in row 1 throws the exception "1361"
# wird nicht gespeichert
And I close the current editor


# Lieferschein zur Bestellung anlegen
Given I open an editor "lieferschein-100" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-100"
And I set field "num4" to "100-LS"
#
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
#
And I set field "vom" to "."
And I set field "mge" to "020" in row 1
Then field "konto" has value "10000" in row 1
#
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein anlegen
Given I open an editor "rechnung-100" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-100"
And I set field "num4" to "100-RE"
And I set field "vom" to "."
#
Then field "vrgstrgl" has value "EKIN-IST"
Then field "fixvrgstrgl" has value "nein"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is modifiable
#
And I set field "istversteuerer" to "ja"
#
And I press button "offueb" in row 1
Then field "konto" has value "10000" in row 1
Then field "estkonto" has value "14340" in row 1
Then field "ekstustpos" has value "" in row 1
#
And I set field "istversteuerer" to "ja"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "fixvrgstrgl" has value "nein"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
#
Then field "konto" has value "10000" in row 1
Then field "estkonto" has value "14340" in row 1
Then field "ekstustpos" has value "" in row 1
#
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "100-RE"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "stornovorlobjekt" is empty
Then the table has 4 rows
Then field "konto" has value "50000" in row 3
Then field "kvnum" has value "0100-BE" in row 3
Then field "ustva" has value "" in row 3
#
Then field "konto" has value "14340" in row 4
Then field "kvnum" has value "100-RE" in row 4
Then field "ustva" has value "" in row 4
And I close the current editor
###################################################################################################

