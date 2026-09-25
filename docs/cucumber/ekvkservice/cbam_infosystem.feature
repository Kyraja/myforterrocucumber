# *****************************************************************************
#  Name           : cbam_infosystem.feature
#  Autor          : khuelskaemper
#  Verantwortlich : teaminfosysteme
#  Funktion       : Testet Funktionen des CBAM Infosystems
#
# *****************************************************************************
#
@persistent
Feature: CBAM-Infosystem
Background:
Given I set the fake date to "05.01.1995"
Given I set saved value "REF_FILE" to "EK.cbam_infosystem.CU.REF"
Given I set saved value "FeldlisteIS" to "tlieferant,twarennr,tversandland,tgesamtgewichtint,tgewichtco2int"

# ----------------------------------------------------------------------------------------------
Scenario: CBAM-Meldepflicht Infosystem - Tabelle
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "CBAM"
And I set field "budatvon" to "31.12.1994"

# Nach dem Öffnen (RE, LS, gruppiert)
And I press start

And I append ScenarioHeadline to output file "$REF_FILE"
And I append text "---RE, LS, gruppiert---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

# Von allen Vorgangsarten anzeigen
And I set field "brueckls" to "ja"
And I set field "bstorno" to "ja"
And I press start
Then the table has 4 rows
And I append text "---RE, LS, RueckLS, Stornos, gruppiert---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

# Nur Rück und Stornierte
And I set field "brechnung" to "nein"
And I set field "blieferschein" to "nein"
And I press start
Then the table has 2 rows
And I append text "---RueckLS, Stornos, gruppiert---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

# Nur Rück und Stornierte ohne Gruppierung
And I set field "bdetaillierteanzeige" to "ja"
And I press start
Then the table has 5 rows
And I append text "---RueckLS, Stornos, nicht gruppiert---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"
 
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: CBAM-Meldepflicht Infosystem - Datum
# ----------------------------------------------------------------------------------------------
Given I open the infosystem "CBAM"
And I press start

# Datum-von testen 
And I set field "budatvon" to "02.02.1995"
And I press start
Then the table has 0 rows

And I set field "budatvon" to "31.12.1994"
And I press start
Then the table has 4 rows

# Datum-bis testen 
And I set field "budatvon" to ""
And I set field "budatbis" to "02.02.1995"
And I press start
Then the table has 4 rows

And I set field "budatbis" to "31.12.1994"
And I press start
Then the table has 0 rows

# Falsches Datum testen 
And I set field "budatvon" to "02.02.1995"
And I set field "budatbis" to "01.01.1995"
Then pressing button "start" throws the exception "1283" 

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: CBAM-Meldepflicht Infosystem - Nach Lieferant filtern
# ----------------------------------------------------------------------------------------------
Given I open the infosystem "CBAM"
And I set field "budatvon" to "31.12.1994"

And I set field "klief" to "60011"
And I press start
Then the table has 1 rows

And I set field "bdetaillierteanzeige" to "ja"
And I press start
Then the table has 6 rows

And I set field "klief" to "1"
And I press start
Then the table has 1 rows

And I set field "klief" to "001"
And I press start
Then the table has 0 rows
