@persistent
Feature: BW2-1620
Background: 
Given I set the fake date to "16.12.01"
Given I enable the flag 39

# *****************************************************************************
#  Name             : anlkore2.feature
#  Autor            : sih
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Erzeugen von kalkulatorischen Afa-Buchungen mit Kostenobjekten und Projekten
#
# *****************************************************************************
Scenario: 00 Projektkostenrechnung aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "ja"
And I save the current editor

Given I open an editor "Termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "term"
And I set field "pkbabkoartgj" to "01"
And I set field "pkbabkoartgm" to "1"
And I save the current editor

Scenario: 01 Stammdaten
# Kostenstellen
Given I open an editor "konto" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "903"
And I set field "such" to "K903"
And I set field "namebspr" to "kalkulatorische Anlagen"
And I save the current editor

Given I open an editor "konto" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "901kalk"
And I set field "such" to "K901kalk"
And I set field "namebspr" to "kalkulatorische Anlagen"
And I save the current editor

Given I open an editor "konto" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "902kalk"
And I set field "such" to "K902kalk"
And I set field "namebspr" to "kalkulatorische Anlagen"
And I save the current editor

Given I open an editor "konto" from table "(Account):(CostCenter)" with command "COPY" for record "101"
And I set field "nummer" to "903kalk"
And I set field "such" to "K903kalk"
And I set field "namebspr" to "kalkulatorische Anlagen"
And I save the current editor

# Projekte
Given I open an editor "projekt901" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "nummer" to "901"
And I set field "such" to "P901"
And I save the current editor

Given I open an editor "projekt902" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "nummer" to "902"
And I set field "such" to "P902"
And I save the current editor

Given I open an editor "projekt903" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "nummer" to "903"
And I set field "such" to "P903"
And I save the current editor

# Kostenarten
Given I open an editor "KoarttKalk" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "90002k"
And I set field "such" to "K90002"
And I set field "stat" to "ja"
And I save the current editor

Given I open an editor "KoarttKalk" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "90003k"
And I set field "such" to "K90003"
And I set field "stat" to "ja"
And I save the current editor

Given I open an editor "KoarttKalk" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "10002k"
And I set field "such" to "K10002"
And I set field "bilkostart" to "ja"
And I set field "stat" to "ja"
And I save the current editor

Given I open an editor "KoarttKalk" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "10003k"
And I set field "such" to "K10003"
And I set field "bilkostart" to "ja"
And I set field "stat" to "ja"
And I save the current editor

# Konten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "90001"
And I set field "such" to "K90001"
And I set field "stat" to "Kostenrechnung"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "90003"
And I set field "such" to "K90003"
And I set field "kstelle" to "903"
And I set field "stat" to "Kostenrechnung"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "90003k" in row 1
And I set field "koartvon" to "1.01.01" in row 1
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10001k"
And I set field "such" to "K10001"
And I set field "stat" to "Kostenrechnung"
And I set field "gv" to "nein"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10002k"
And I set field "such" to "K10002"
And I set field "stat" to "Kostenrechnung"
And I set field "gv" to "nein"
And I create a new row at the end of the table
And I set field "zkoart" to "10002k" in row 1
And I set field "pkkoartvon" to "1.01.01" in row 1
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10003k"
And I set field "such" to "K10003"
And I set field "stat" to "Kostenrechnung"
And I set field "gv" to "nein"
And I create a new row at the end of the table
And I set field "zkoart" to "10003k" in row 1
And I set field "pkkoartvon" to "1.01.01" in row 1
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "11000k"
And I set field "such" to "K11000"
And I set field "stat" to "Kostenrechnung"
And I set field "gv" to "nein"
And I save the current editor


# kalkulatorische Anlagen anlegen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "901kalk"
And I set field "such" to "KA901"
And I set field "modart" to "kalk"
# Wechsel in das Afa-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1007"
And I set field "kstelle" to "901kalk"
And I set field "projekt" to "901"
And I set field "afako" to "90001"
And I set field "bilkto" to "10001k"
And I set field "erinnerwert" to "1.00"
And I set field "andat" to "1.01.99"
And I set field "nmon" to "240"
And I set field "erafa" to "1200"
And I save the current editor
And I close the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor
And I close the current editor

Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "902kalk"
And I set field "such" to "KA902"
And I set field "modart" to "kalk"
# Wechsel in das Afa-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1007"
And I set field "kstelle" to "902kalk"
And I set field "projekt" to "902"
And I set field "afako" to "90002"
And I set field "bilkto" to "10002k"
And I set field "erinnerwert" to "1.00"
And I set field "andat" to "1.01.99"
And I set field "nmon" to "240"
And I set field "erafa" to "1200"
And I save the current editor
And I close the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor
And I close the current editor

Given I open an editor "anlage-3" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "903kalk"
And I set field "such" to "KA903"
And I set field "modart" to "kalk"
# Wechsel in das Afa-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "wg" to "1007"
And I set field "kstelle" to "903kalk"
And I set field "projekt" to "903"
And I set field "afako" to "90003"
And I set field "bilkto" to "10003k"
And I set field "erinnerwert" to "1.00"
And I set field "andat" to "1.01.99"
And I set field "nmon" to "240"
And I set field "erafa" to "1200"
And I save the current editor
And I close the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-3"
And I save the current editor
And I close the current editor

# Anchaffungswert für kalk. Anlage 901kalk
Given I open an editor "BuchungAnl" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "budat" to "05.01.00"
And I set field "kenn" to "zu"
And I create a new row at the end of the table
And I set field "anlage" to "901kalk" in row 1
And I set field "sbetrag" to "100000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "11000k" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer 901kalk GJ 00 (vor Startdatum Kore)
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "0901kalk"
And I set field "gjahr" to "00"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "901kalk"
And I set field "banl" to "901kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Anchaffungswert für kalk. Anlage 902kalk
Given I open an editor "BuchungAnl" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "budat" to "05.01.00"
And I set field "kenn" to "zu"
And I create a new row at the end of the table
And I set field "anlage" to "902kalk" in row 1
And I set field "sbetrag" to "200000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "11000k" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer 902kalk GJ 00 (vor Startdatum Kore)
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "0902kalk"
And I set field "gjahr" to "00"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "902kalk"
And I set field "banl" to "902kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Anchaffungswert für kalk. Anlage 903kalk
Given I open an editor "BuchungAnl" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "budat" to "05.01.00"
And I set field "kenn" to "zu"
And I create a new row at the end of the table
And I set field "anlage" to "903kalk" in row 1
And I set field "sbetrag" to "300000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "11000k" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer 903kalk GJ 00 (vor Startdatum Kore)
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "0903kalk"
And I set field "gjahr" to "00"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "903kalk"
And I set field "banl" to "903kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer 901kalk GJ 01 (ab Startdatum Kore)
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "0901kalk"
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "901kalk"
And I set field "banl" to "901kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer 902kalk GJ 01 (ab Startdatum Kore)
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "0902kalk"
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "902kalk"
And I set field "banl" to "902kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer 903kalk GJ 01 (ab Startdatum Kore)
Given I open an editor "vorschlag" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "0903kalk"
And I set field "gjahr" to "01"
And I set field "apart" to "kalk"
And I set field "vmon" to "1"
And I set field "bmon" to "12"
And I set field "vanl" to "903kalk"
And I set field "banl" to "903kalk"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

