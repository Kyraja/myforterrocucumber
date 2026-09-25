# *****************************************************************************
#  Name             : steuer_ist_versteuerung_allg_002_kvnum_man_buchung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung von evkvnum in Steuerzeilen bei man. RE-Buchung
#
#
# *****************************************************************************
@persistent
Feature: steuer_ist_versteuerung_allg_001_kvnum.feature
Background: Vorbelegung von evkvnum in Steuerzeilen bei man. RE-Buchung

Given I set the fake date to "31.12.1999"

Scenario: EK-Rechnungsbuchung; Steuerzeile selbst eingetragen

Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "ek555re"
And I set field "butyp" to "Rechnungsbuchung"
And I set field "klm" to "L 1"
And I set field "vrgstrgl" to "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
#
# Tabelle
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "konto" to "L 1" in row 1
Then field "konto" has value "L 1" in row 1
And I set field "ewhbetr" to "15000" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "10000" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "14340" in row 3
Then field "kvnum" has value "ek555re" in row 3
Then field "kvnum" is modifiable in row 3
#
# "583 de      |Buchung o.k.?"
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "ek555re"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "butyp" has value "Rechnungsbuchung"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "14340" in row 3
Then field "kvnum" has value "ek555re" in row 3
And I close the current editor

# Buchung kopieren
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "COPY" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "ek555re"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "butyp" has value "Rechnungsbuchung"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "14340" in row 3
Then field "kvnum" has value "" in row 3
And I set field "beleg" to "ek777re"
#
# "583 de      |Buchung o.k.?"
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "ek777re"
Then field "vrgstrgl" has value "EKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "butyp" has value "Rechnungsbuchung"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "14340" in row 3
Then field "kvnum" has value "ek777re" in row 3
And I close the current editor
# #######################################################################################


Scenario: VK-Rechnungsbuchung; Steuerzeile automatisch erzeugt

Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "vk222re"
And I set field "butyp" to "Rechnungsbuchung"
And I set field "klm" to "K 001"
And I set field "vrgstrgl" to "VKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung" in row 0
#
# Tabelle
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "konto" to "K 001" in row 1
Then field "konto" has value "K 001" in row 1
And I set field "ewhbetr" to "20000" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
#
# "583 de      |Buchung o.k.?"
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "vk222re"
Then field "vrgstrgl" has value "VKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "butyp" has value "Rechnungsbuchung"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "38160" in row 3
Then field "kvnum" has value "vk222re" in row 3
And I close the current editor

#
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "COPY" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then the table has 3 rows
Then field "beleg" has value "vk222re"
Then field "konto" has value "38160" in row 3
Then field "kvnum" has value "" in row 3
Then field "kvrel" has value "nein" in row 3
Then field "kv" is empty in row 3
#
And I set field "beleg" to "vk333re"
Then field "konto" has value "38160" in row 3
Then field "kvnum" has value "vk333re" in row 3
Then field "kv" is empty in row 3
# "583 de      |Buchung o.k.?"
And I respond with answer "nein" to the dialog with id "583"
# 1298 TX=de   |Bitte Buchung pruefen
Then saving the current editor throws the exception "1298"
# And I save the current editor
Then field "konto" has value "38160" in row 3
Then field "kvnum" has value "vk333re" in row 3
Then field "kvrel" has value "nein" in row 3
Then field "kv" is empty in row 3
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "vk333re"
Then field "vrgstrgl" has value "VKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "butyp" has value "Rechnungsbuchung"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "38160" in row 3
Then field "kvnum" has value "vk333re" in row 3
Then field "kvrel" has value "nein" in row 3
Then field "kv" is empty in row 3
And I close the current editor
# #######################################################################################


Scenario: VK-Rechnungsbuchung; Steuerzeile automatisch erzeugt

Given I open an editor "Buchung5" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "vk555re"
And I set field "butyp" to "Rechnungsbuchung"
And I set field "klm" to "K 001"
And I set field "vrgstrgl" to "VKINL"
Then field "versteuerungsart" has value "Soll-Versteuerung" in row 0
#
# Tabelle
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "konto" to "K 001" in row 1
Then field "konto" has value "K 001" in row 1
And I set field "ewhbetr" to "20000" in row 1
Then field "kvnum" is modifiable in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
Then field "kvnum" is modifiable in row 2
#
# "583 de      |Buchung o.k.?"
And I respond with answer "nein" to the dialog with id "583"
# 1298 TX=de   |Bitte Buchung pruefen
Then saving the current editor throws the exception "1298"
# And I save the current editor
Then field "konto" has value "38060" in row 3
Then field "kvnum" is modifiable in row 3
Then field "kvnum" has value "" in row 3
Then field "kvrel" has value "nein" in row 3
Then field "kv" is empty in row 3
#
And I set field "vrgstrgl" to "VKIN-IST"
Then the table has 2 rows
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Buchung anschauen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,;@richtung=rückwärts;@maxtreffer=1"
Then field "beleg" has value "vk555re"
Then field "vrgstrgl" has value "VKIN-IST"
Then field "versteuerungsart" has value "Ist-Versteuerung"
Then field "butyp" has value "Rechnungsbuchung"
Then field "stornovorlobjekt" is empty
Then the table has 3 rows
Then field "konto" has value "38160" in row 3
Then field "kvnum" has value "vk555re" in row 3
Then field "kvrel" has value "nein" in row 3
Then field "kv" is empty in row 3
And I close the current editor
# #######################################################################################

