# ***************************************************************************
#
#  Name      : rlw.feature
#  Datum     : 15.08.2024
#  Autor     : as
#  Verantwortlich : as
#  Kontrolle : foe
#
#  Funktion  : Cucumber Skript zum Testen von Regionen/Laendern/Wirtschaftsraeumen
#
# ***************************************************************************
@persistent
Feature: Test von Regionen/Laendern/Wirtschaftsraeumen
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------
Scenario: Schreibschutz- und Feldpruefungen
# ----------------------------------------------------------------------------

Given I open an editor "ablr" from table "(Regions):(RegionCountryEconomicArea)" with command "NEW" for record ""
And I set field "such" to "ABGELEGT"
And I set field "typ" to "Region"
And I set field "rname" to "abgelegt"
And I set field "kenn" to "ABL"
And I set field "ueberg" to "DEUTSCHLAND"
And I save the current editor

Given I open an editor "ablr" from table "(Regions):(RegionCountryEconomicArea)" with command "DELETE" for record from editor "ablr"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "ablw" from table "(Regions):(RegionCountryEconomicArea)" with command "COPY" for record "EUZV"
And I set field "such" to "ABLW"
And I set field "kenn" to "ABL"
And I save the current editor

Given I open an editor "ablw" from table "(Regions):(RegionCountryEconomicArea)" with command "DELETE" for record from editor "ablw"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "NEW" for record ""
Then field "iso2" is not modifiable
Then field "iso3" is not modifiable
Then field "abbrev" is not modifiable
Then field "egkenn" is not modifiable
Then field "egab" is not modifiable
Then field "laiw" is not modifiable
Then field "laniw" is not modifiable
Then field "sepaland" is not modifiable
Then field "laart" is not modifiable
Then field "eschl" is not modifiable
Then field "ekenn" is not modifiable
And I set field "typ" to "Land"
Then field "iso2" is modifiable
Then field "iso3" is modifiable
Then field "abbrev" is modifiable
Then field "egkenn" is modifiable
Then field "egab" is modifiable
Then field "laiw" is modifiable
Then field "laniw" is modifiable
Then field "sepaland" is modifiable
Then field "laart" is modifiable
Then field "eschl" is not modifiable
Then field "ekenn" is not modifiable
And I set field "typ" to "Region"
Then field "iso2" is not modifiable
Then field "iso3" is not modifiable
Then field "abbrev" is not modifiable
Then field "egkenn" is not modifiable
Then field "egab" is not modifiable
Then field "laiw" is not modifiable
Then field "laniw" is not modifiable
Then field "sepaland" is not modifiable
Then field "laart" is not modifiable
Then field "eschl" is modifiable
Then field "ekenn" is modifiable
And I set field "typ" to "Land"
# Diese Kennung muss aus zwei Buchstaben bestehen
Then setting field "iso2" to "X" throws the exception "154"
Then setting field "egkenn" to "X" throws the exception "154"
# Diese Kennung muss aus drei Buchstaben bestehen
Then setting field "iso3" to "XX" throws the exception "982"
# Ungueltiger Regionentyp
Then setting field "ueberg" to "DEUTSCHLAND" throws the exception "5919"
Then setting field "ueberg" to "BREMEN" throws the exception "5919"
And I set field "typ" to "Region"
Then setting field "ueberg" to "EUZV" throws the exception "5919"
# Regionen aus der Ablage duerfen nicht eingetragen werden
Then setting field "ueberg" to "!ablr" throws the exception "1450"
And I set field "typ" to "Land"
# Laender aus der Ablage duerfen nicht eingetragen werden
Then setting field "ueberg" to "!ablw" throws the exception "1449"
# Bitte Waehrung eintragen
Then setting field "waeh" to " " throws the exception "134"
And I close the current editor

Given I open an editor "hessen" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "HESSEN"
# Das Land und die Region sind nicht aus der gleichen Hierarchie
Then setting field "finlakenn" to "BADEN-WUERTTEMBERG" throws the exception "5917"
And I close the current editor

Given I open an editor "deutschland" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "DEUTSCHLAND"
# WARNUNG: USt-IdNr passt nicht zur EU-Kennung
Then setting field "ustid" to "FR00001" throws the exception "127"
And I close the current editor

Given I open an editor "deutschland" from table "(Regions):(RegionCountryEconomicArea)" with command "COPY" for record "DEUTSCHLAND"
And I set field "typ" to "Region"
Then field "iso2" is empty
Then field "iso3" is empty
Then field "laart" is empty
Then field "egkenn" is empty
Then field "egab" is empty
Then field "egbis" is empty
Then field "laiw" is empty
Then field "ueberg" is empty
And I close the current editor

# ----------------------------------------------------------------------------
Scenario: Pruefungen beim Speichern
# ----------------------------------------------------------------------------

Given I open an editor "atlantis-zv" from table "(Regions):(RegionCountryEconomicArea)" with command "NEW" for record ""
And I set field "such" to "ATLANTIS-ZV"
And I set field "typ" to "Wirtschaftsraum"
# Bezeichnung bitte eintragen
Then saving the current editor throws the exception "10179"
And I set field "rname" to "Zahlungsverkehr Atlantis"
And I save the current editor

Given I open an editor "atlantis-zv" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record from editor "atlantis-zv"
And I set field "ueberg" to "ATLANTIS-ZV"
# Zyklische Struktur
Then saving the current editor throws the exception "93"
And I close the current editor

Given I open an editor "spanien" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "SPANIEN"
Then field "nummer" has value "81"
And I set field "nummer" to ""
And I save the current editor
Then field "nummer" from editor "spanien" is not empty

Given I open an editor "atlantis" from table "(Regions):(RegionCountryEconomicArea)" with command "NEW" for record ""
# Suchwort bitte eintragen
Then saving the current editor throws the exception "10179"
And I set field "such" to "ATLANTIS"
# Typ bitte eintragen
Then saving the current editor throws the exception "10179"
And I set field "typ" to "Land"
# Bezeichnung bitte eintragen
Then saving the current editor throws the exception "10179"
And I set field "rname" to "Atlantis"
# Bitte Adressformat des Landes eintragen
Then saving the current editor throws the exception "9293"
And I set field "adrformat" to "ADRFORM-DE"
# Bitte Kennzeichen eintragen
Then saving the current editor throws the exception "146"
And I set field "kenn" to "AT"
# Land-Art fehlt
Then saving the current editor throws the exception "205"
And I set field "laart" to "EU-Staat"
# Bitte Sprache eintragen
Then saving the current editor throws the exception "133"
And I set field "spr" to "Deutsch"
# Bitte Waehrung eintragen
Then saving the current editor throws the exception "134"
And I set field "waeh" to "EUR"
# Bitte EU-Laenderkennung eintragen
Then saving the current editor throws the exception "119"
And I set field "egkenn" to "AT"
And I set field "egbis" to "+100"
# Bitte Datum eintragen
Then saving the current editor throws the exception "58"
And I set field "egab" to "+101"
# unzulaessiges Datum
Then saving the current editor throws the exception "106"
And I set field "egab" to "."
# Der Laendercode kommt mehrfach vor. o.k.?
And I respond with answer "nein" to the dialog with id "5523"
# Dieses Kennzeichen kommt mehrfach vor
Then saving the current editor throws the exception "137"
# Der Laendercode kommt mehrfach vor. o.k.?
And I respond with answer "ja" to the dialog with id "5523"
# Dieses Kennzeichen kommt mehrfach vor
Then saving the current editor throws the exception "137"
And I set field "egkenn" to "AX"
And I set field "iso2" to "AX"
And I set field "iso3" to "AXL"
And I set field "ueberg" to "ATLANTIS-ZV"
And I save the current editor

Given I open an editor "atlantis-stadt" from table "(Regions):(RegionCountryEconomicArea)" with command "NEW" for record ""
And I set field "such" to "ATLANTIS-STADT"
And I set field "typ" to "Region"
And I set field "rname" to "Atlantis-Stadt"
# Eine Region muss ein uebergeordnetes Gebiet haben
Then saving the current editor throws the exception "6243"
And I set field "ueberg" to "ATLANTIS"
# Bitte Kennzeichen eintragen
Then saving the current editor throws the exception "146"
And I set field "kenn" to "AT"
# Dieses Kennzeichen ist schon im uebergeordnetem Raum benutzt
Then saving the current editor throws the exception "136"
And I set field "kenn" to "ATS"
And I save the current editor
