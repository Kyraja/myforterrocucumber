# *****************************************************************************
#  Name             : steuer_ist_versteuerung_allg_003_ev_istversteuerer.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung/Plausis/Nachbehandlung von (ev)istversteuerer
#                     in EV-Vorgaengen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ist_versteuerung_allg_003_ev_istversteuerer.feature
Background: Vorbelegung/Plausis/Nachbehandlung von (ev)istversteuerer

Given I set the fake date to "31.12.1999"

Scenario: Einkauf


# Bestellung anlegen: Normalfall
Given I open an editor "bestellung-001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0001-BE"
#
Then field "vrgstrgl" has value "EKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "020" in row 1
And I set field "preis" to "020" in row 1
#
And I save the current editor


# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-001"
And I set field "num4" to "001-LS"
#
Then field "vrgstrgl" has value "EKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung"
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
Given I open an editor "rechnung-001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-001"
And I set field "num4" to "001-RE"
And I set field "vom" to "."
#
Then field "vrgstrgl" has value "EKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is modifiable
#
And I press button "offueb" in row 1
Then field "konto" has value "10000" in row 1
Then field "estkonto" has value "14060" in row 1
Then field "ekstustpos" has value "66" in row 1
#
And I set field "istversteuerer" to "ja"
Then field "fixvrgstrgl" has value "nein"
Then field "vrgstrgl" has value ""
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
#
And I set field "vrgstrgl" to "EKIN-IST"
Then field "istversteuerer" is modifiable
Then field "istversteuerer" has value "ja"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "fixvrgstrgl" has value "ja"
Then field "konto" has value "10000" in row 1
Then field "estkonto" has value "14340" in row 1
Then field "ekstustpos" has value "" in row 1
#
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "001-RE"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "14340" in row 3
Then field "kvnum" has value "001-RE" in row 3
Then field "ustva" has value "" in row 3
And I close the current editor
###################################################################################################

Scenario: Verkauf


# Auftrag anlegen: Normalfall
Given I open an editor "auftrag-001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "num3" to "0001-AU"
#
Then field "vrgstrgl" has value "VKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "020" in row 1
And I set field "preis" to "020" in row 1
#
And I save the current editor


# Lieferschein zum Auftrag anlegen
Given I open an editor "lieferschein-001" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-001"
And I set field "num3" to "001-LS"
#
Then field "vrgstrgl" has value "VKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
#
And I set field "vom" to "."
And I set field "mge" to "020" in row 1
Then field "konto" has value "44000" in row 1
#
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein anlegen
Given I open an editor "rechnung-001" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-001"
And I set field "num3" to "001-RE"
And I set field "vom" to "."
#
Then field "vrgstrgl" has value "VKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is modifiable
#
And I press button "offueb" in row 1
Then field "konto" has value "44000" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "vkstustpos" has value "551" in row 1
#
And I set field "istversteuerer" to "ja"
Then field "fixvrgstrgl" has value "nein"
Then field "vrgstrgl" has value ""
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
#
And I set field "vrgstrgl" to "VKIN-IST"
Then field "istversteuerer" is modifiable
Then field "istversteuerer" has value "ja"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "fixvrgstrgl" has value "ja"
Then field "konto" has value "44000" in row 1
Then field "vstkonto" has value "38160" in row 1
Then field "vkstustpos" has value "" in row 1
#
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "001-RE"
Then field "vrgstrgl" has value "VKIN-IST"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "38160" in row 3
Then field "kvnum" has value "001-RE" in row 3
Then field "ustva" has value "" in row 3
And I close the current editor


# Rechnung kopieren -> im EK muss "istversteuerer" geleert werden!
Given I open an editor "rechnung-222" from table "(Purchasing):(Invoice)" with command "COPY" for record "+001-RE"
Then field "istversteuerer" has value "nein"
# wird nicht gespeichert
And I close the current editor
###################################################################################################

Scenario: Einkauf


# Bestellung anlegen: "Ist-Versteuerung"-VRGSTRGL aus dem Lieferant
Given I open an editor "bestellung-005" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "1001-BE"
#
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "020" in row 1
And I set field "preis" to "020" in row 1
#
And I save the current editor
And I close the current editor
###################################################################################################

Scenario: Vorbelegung von "istversteuerer" in Verkauf


# Vorbereitung: 1
Given I open an editor "land" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "72"
Then field "such" has value "DEUTSCHLAND"
Then field "istversteuerer" has value "nein"
And I set field "istversteuerer" to "ja"
And I save the current editor
And I close the current editor

# Vorbereitung: 2. Vorgangsteuerkonfiguration anpassen
Given I open an editor "PrcesstaxConf" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
|ev     |rechnlaart|bestlaart|vrgstrgl|istversteuerer|standard|
|Verkauf|Inland    |Inland   |5020    |            ja|      ja|
And I save the current editor


# Auftrag anlegen
Given I open an editor "auftrag-111" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "num3" to "0111-AU"
#
Then field "vrgstrgl" has value "VKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
Then field "istversteuerer" is not modifiable
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "020" in row 1
And I set field "preis" to "020" in row 1
#
And I save the current editor


# Lieferschein zum Auftrag anlegen
Given I open an editor "lieferschein-111" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-111"
And I set field "num3" to "111-LS"
#
Then field "vrgstrgl" has value "VKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
Then field "istversteuerer" is not modifiable
#
And I set field "vom" to "."
And I set field "mge" to "020" in row 1
Then field "konto" has value "44000" in row 1
#
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein anlegen
Given I open an editor "rechnung-111" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-111"
And I set field "num3" to "111-RE"
And I set field "vom" to "."
#
Then field "vrgstrgl" has value "VKIN-IST"
Then field "fixvrgstrgl" has value "nein"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
Then field "istversteuerer" is modifiable
#
And I press button "offueb" in row 1
Then field "konto" has value "44000" in row 1
Then field "vstkonto" has value "38160" in row 1
Then field "vkstustpos" has value "" in row 1
#
And I set field "istversteuerer" to "nein"
Then field "vrgstrgl" has value "VKINL"
Then field "fixvrgstrgl" has value "nein"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
#
Then field "konto" has value "44000" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "vkstustpos" has value "551" in row 1
#
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "111-RE"
Then field "vrgstrgl" has value "VKINL"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "38060" in row 3
Then field "kvnum" has value "" in row 3
Then field "ustva" has value "551" in row 3
And I close the current editor


# Rechnung kopieren -> "istversteuerer" muss neu ermittelt werden
Given I open an editor "rechnung-222" from table "(Sales):(Invoice)" with command "COPY" for record "+111-RE"
Then field "istversteuerer" has value "ja"
# wird nicht gespeichert
And I close the current editor


# Wertgutschrift aus Rechnung
Given I open an editor "rechnung-222" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rechnung-111"
And I set field "num3" to "111-WGS"
And I set field "vom" to "."
#
Then field "wertgutschrift" has value "ja"
Then field "vrgstrgl" has value "VKIN-IST"
Then field "fixvrgstrgl" has value "nein"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "ja"
Then field "istversteuerer" is modifiable
#
And I press button "offueb" in row 1
Then field "konto" has value "44000" in row 1
Then field "vstkonto" has value "38160" in row 1
Then field "vkstustpos" has value "" in row 1
#
And I set field "istversteuerer" to "nein"
Then field "vrgstrgl" has value "VKINL"
Then field "fixvrgstrgl" has value "nein"
Then field "versteuerungsart" has value "Soll-Versteuerung"
Then field "versteuerungsart" is not modifiable
#
Then field "konto" has value "44000" in row 1
Then field "vstkonto" has value "38060" in row 1
Then field "vkstustpos" has value "551" in row 1
#
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "111-WGS"
Then field "vrgstrgl" has value "VKINL"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "38060" in row 3
Then field "kvnum" has value "" in row 3
Then field "ustva" has value "551" in row 3
And I close the current editor


# Aufraeumen
Given I open an editor "land" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "72"
Then field "such" has value "DEUTSCHLAND"
Then field "istversteuerer" has value "ja"
And I set field "istversteuerer" to "nein"
And I save the current editor
And I close the current editor
###################################################################################################

Scenario: Vorbelegung von "istversteuerer" in Einkauf


# Vorbereitung: 1
Given I open an editor "land" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "72"
Then field "such" has value "DEUTSCHLAND"
Then field "istversteuerer" has value "nein"
And I set field "istversteuerer" to "ja"
And I save the current editor
And I close the current editor

# Vorbereitung: 2. Vorgangsteuerkonfiguration anpassen
Given I open an editor "PrcesstaxConf" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
|ev     |rechnlaart|bestlaart|vrgstrgl|istversteuerer|standard|
|Einkauf|Inland    |Inland   |6020    |            ja|      ja|
And I save the current editor


# Bestellung anlegen
Given I open an editor "bestellung-222" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "001"
And I set field "num4" to "0111-BE"
#
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is not modifiable
#
And I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "020" in row 1
And I set field "preis" to "020" in row 1
#
And I save the current editor


# Lieferschein zur Bestellung anlegen
Given I open an editor "lieferschein-111" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-222"
And I set field "num4" to "111-LS"
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
Given I open an editor "rechnung-111" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-111"
And I set field "num4" to "111-RE"
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
Then field "beleg" has value "111-RE"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "14340" in row 3
Then field "kvnum" has value "111-RE" in row 3
Then field "ustva" has value "" in row 3
And I close the current editor


# Rechnung kopieren -> "istversteuerer" muss neu ermittelt werden
Given I open an editor "rechnung-222" from table "(Purchasing):(Invoice)" with command "COPY" for record "+111-RE"
Then field "istversteuerer" has value "nein"
# wird nicht gespeichert
And I close the current editor

Given I set the fake date to "01.01.2000"

# Wertgutschrift aus Rechnung
Given I open an editor "rechnung-999" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rechnung-111"
And I set field "num4" to "111-WGS"
And I set field "vom" to "."
#
Then field "wertgutschrift" has value "ja"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "fixvrgstrgl" has value "nein"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "versteuerungsart" is not modifiable
Then field "istversteuerer" has value "nein"
Then field "istversteuerer" is modifiable
Then field "op" has value ""
Then field "opz" has value ""
#
And I press button "offueb" in row 1
Then field "konto" has value "10000" in row 1
Then field "estkonto" has value "14340" in row 1
Then field "ekstustpos" has value "" in row 1
#
And I set field "ueb" to "ja"
#
And I set field "vrgstrgl" to "EKINL"
Then field "fixvrgstrgl" has value "ja"
#
# And I set field "istversteuerer" to "ja"
Then field "versteuerungsart" has value "Soll-Versteuerung"
#
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


#  # Buchung anschauen
#  Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
#  Then field "beleg" has value "111-WGS"
#  Then field "vrgstrgl" has value "EKINL"
#  Then field "stornovorlobjekt" is empty
#  Then the table has 3 rows
#  Then field "konto" has value "14340" in row 3
#  Then field "kvnum" has value "" in row 3
#  Then field "ustva" has value "" in row 3
#  And I close the current editor


# Aufraeumen
Given I open an editor "land" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "72"
Then field "such" has value "DEUTSCHLAND"
Then field "istversteuerer" has value "ja"
And I set field "istversteuerer" to "nein"
And I save the current editor
And I close the current editor
###################################################################################################

