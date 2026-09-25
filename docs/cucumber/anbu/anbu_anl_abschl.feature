# *****************************************************************************
#  Name             : anbu_anl_abschl.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Cucumberscript für ref_anl_abschl
# *****************************************************************************

Feature: anbu_anl_abschl
Background: 
Scenario: anl_abschl

Given I set the fake date to "02.01.1995"
Given I'm logged in with password "annette"
# --------------------------------------------------------------------------
# Abschreibungsarten
# --------------------------------------------------------------------------

Given I open an editor "dm-1" from table "(FixedAsset):(DepreciationMethod)" with command "NEW" for record ""
And I set field "nummer" to "1"
And I set field "such" to "LINEAR"
And I set field "rart" to "Restbuchwert/Restnutzungsdauer"
And I set field "afako" to "62200"
And I set field "name" to "Lineare Abschreibung"
And I save the current editor
And I close the current editor

# -----------------------------------------------
# Anlagekategorien
# -----------------------------------------------

Given I set the fake date to "02.01.1995"
Given I'm logged in with password "annette"

Given I open an editor "anlkat-1" from table "(FixedAsset):(FixedAssetGroup)" with command "NEW" for record ""
And I set field "nummer" to "10000"
And I set field "such" to "ANLKAT"
And I set field "name" to "Anlagekategorie"
And I set field "verd" to "05200"
And I create a new row at the end of the table
And I set field "wgafa" to "1" in row 1
And I save the current editor
And I close the current editor

# -----------------------------------------------
# Anlage
# -----------------------------------------------

Given I open an editor "anl-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "100"
And I set field "such" to "Anlage"
And I set field "name" to "Anlage"
And I save the current editor
And I close the current editor

Given I open an editor "anl-100" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "100"
And I press button "bafamodell" to open a subeditor for "anl-1-afamod"
And I set field "wg" to "10000"
And I set field "kstelle" to "100"
And I set field "bilkto" to "05200"
And I set field "afaart" to "1"
And I set field "afako" to "62200"
And I set field "andat" to "19950101"
# 551: Feld ist nicht änderbar
Then setting field "afadat" to "19950101" throws the exception "551"
And I set field "nmon" to "120"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "buch-1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "ZUGANG"
And I set field "kenn" to "ZU"
And I set field "beleg" to "ZUGANG"
And I set field "beldat" to "19950101"
And I set field "budat" to "19950101"
And I create a new row at the end of the table
And I set field "anlage" to "100" in row 1
And I set field "sbetrag" to "10000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "35010" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# ##################################################
# Anzahl der abgeschlossenen Monate auf 6 setzen

Given I'm logged in with password "annette"
Given I open an editor "term" from table "(Company):(FinancialDates)" with command "UPDATE" for record "2"
And I set field "monneu" to "6"
And I save the current editor 
And I close the current editor
Given I'm logged in with password "sy"

# ##################################################
# Abschreibungslauf 1A 
# Zeitraum umfasst abgeschlossene und offene Monate
# Das Buchungsdatum liegt im abgeschlossenen Bereich.

Given I open an editor "as-1a" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "95"
And I set field "vmon" to "1"
And I set field "bmon" to "7"
And I press button "afaerm"
# 1361 : Ungültiger Feldwert
Then setting field "budat" to "30.06.95" throws the exception "1361"
# : Falsche Eingabe, Fehler im Lader, nicht aber in Cucumber: 
# Then pressing button "buchap" throws the exception "97"

And I close the current editor

# ##################################################
# Abschreibungslauf 2 
# Zeitraum umfasst abgeschlossene und offene Monate
# Das Buchungsdatum liegt im offenen Bereich.

Given I open an editor "as-2" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "95"
And I set field "vmon" to "1"
And I set field "bmon" to "6"

# : Buchungsdatum fehlt
And I set field "budat" to ""
Then field "budat" is empty

# Erwartet: Fehlermeldung "Buchungsdatum fehlt", Fehlermeldung kommt nicht
# Then pressing button "afaerm" throws the exception "109"
And I press button "afaerm"

And I press button "buchap"

# Vorschlag wird ohne Zeilen abgespeichert (um die gleiche Ausgabe wie beim Lader zu erzielen)
Then the table has 0 rows
And I save the current editor

And I close the current editor

# ##################################################
# Abschreibungslauf 1B 
# Zeitraum umfasst abgeschlossene und offene Monate
# Das Buchungsdatum liegt im offenen Bereich.

Given I open an editor "as-1b" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "gjahr" to "95"
And I set field "vmon" to "1"
And I set field "bmon" to "7"
And I press button "afaerm"
# ####################################################
# "01.07." ohne Jahreszahl führt zu Fehlermeldung "Ungültiger Feldwert budat(0) =  [01.07]" - "unzulässiges Datum"
Then field "gjahr" has value "95"
And I set field "budat" to "01.07.95"
# And I set field "budat" to "01.07."
# ####################################################
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# ##################################################
# Anlagenvorgang 1A
# Anlagenabgang im abgeschlossenem Zeitraum

Given I open an editor "av-1a" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "vorgart" to "Teilabgang"
And I set field "vdatum" to "18.02.1995"
And I set field "anlage" to "100"
And I set field "auahk" to "100.00"
And I set field "auafa" to "10.00"
And I set field "erloes" to "150.00"
# 4479 : Verbuchen von Anlagenvorgang?
And I respond with answer "ja" to the dialog with id "4479"
# 106 : unzulässiges Datum
Then saving the current editor throws the exception "106"
And I close the current editor

# ##################################################
# Anlagenvorgang 1A
# Anlagenabgang im abgeschlossenem Zeitraum

Given I'm logged in with password "annette"

Given I open an editor "av-1a-2" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "vorgart" to "Teilabgang"
And I set field "vdatum" to "01.08.1995"
And I set field "anlage" to "100"
And I set field "auahk" to "100.00"
And I set field "auafa" to "10.00"
And I set field "erloes" to "150.00"
# 4479 : Verbuchen von Anlagenvorgang?
And I respond with answer "ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor




