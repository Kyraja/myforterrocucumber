# *****************************************************************************
#  Name             : anbu_afavorschlag1_001_kst.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier werden Plausis im Editor fuer AfA-Vorschlag geprueft
#                     * Scenario1: nicht bebuchbare KST in der Tabelle -> Modus "NEU"
#                     * Scenario2: nicht bebuchbare Kostenstelle in der Tabelle -> Modus "AENDERN"
#                     * Scenario3: KST - manuellen Aenderungen in der Tabelle
#                     * Scenario4: nicht bebuchbare Kostentraeger in der Tabelle
#
# *****************************************************************************
@persistent
Feature: anbu_afavorschlag1_001_kst.feature
Background: Test des AfA-Vorschlag-Editors

Given I set the fake date to "01.01.01"


@FALL-KST-nicht-bebuchbar1
Scenario: 1: nicht bebuchbare Kostenstelle in der Tabelle


# bei Anlage 135002 Kst eintragen
Given I open an editor "anlage-1" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "135002"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "kstelle" to "100"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1"
And I save the current editor


# AfA-Vorschlag fuer 1-1 2002
Given I open an editor "vorschlag-1" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001aaa"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "1"
And I set field "vanl" to "135002"
And I set field "banl" to "135002"
And I press button "afaerm"
Then the table has 1 rows
# nicht alles zeigen
And I set field "nzeigok" to "ja"
And I set field "nzeigwarn" to "ja"
And I set field "nzeigfehl" to "ja"
Then the table has 0 rows
And I set field "nzeigok" to "nein"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "135002" in row 1
Then field "betrag" has value "800.00" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "tafaftxt" is empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Bebuchbarkeit der KST ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# Kostenstelle auf "nicht bebuchbar" stellen
Given I open an editor "kst-1" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
And I set field "bebuchbar" to "nein"
And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"


# AfA-Vorschlag fuer 2-2 2002
Given I open an editor "vorschlag-2" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001aaa"
And I set field "gjahr" to "02"
And I set field "vmon" to "2"
And I set field "bmon" to "2"
And I set field "vanl" to "135002"
And I set field "banl" to "135002"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "nein" in row 1
Then field "buanlage" has value "135002" in row 1
Then field "betrag" has value "800.00" in row 1
Then field "tkstelle" has value "100" in row 1
Then field "tafaftxt" is not empty in row 1
And I close the current editor

# Bebuchbarkeit der KST ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# Kostenstelle auf "bebuchbar" stellen
Given I open an editor "kst-2" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
And I set field "bebuchbar" to "ja"
And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"
# =========================================================================================

@FALL-KST-nicht-bebuchbar2
Scenario: 2: nicht bebuchbare Kostenstelle in der Tabelle


# bei Anlage 240001 Kst eintragen
Given I open an editor "anlage-2" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240001"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "kstelle" to "101"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-2"
And I save the current editor


# AfA-Vorschlag fuer 1-1 2002
Given I open an editor "vorschlag-20" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "002aaa"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "1"
And I set field "vanl" to "240001"
And I set field "banl" to "240001"
And I press button "afaerm"
Then the table has 1 rows
# nicht alles zeigen
And I set field "nzeigok" to "ja"
And I set field "nzeigwarn" to "ja"
And I set field "nzeigfehl" to "ja"
Then the table has 0 rows
And I set field "nzeigok" to "nein"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "240001" in row 1
Then field "betrag" has value "1150.00" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# AfA-Vorschlag fuer 2-2 2002: speichern, aber verbuchen
Given I open an editor "vorschlag-21" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "003aaa"
And I set field "gjahr" to "02"
And I set field "vmon" to "2"
And I set field "bmon" to "2"
And I set field "vanl" to "240001"
And I set field "banl" to "240001"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "240001" in row 1
Then field "betrag" has value "1150.00" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is empty in row 1
# Speichern, aber nicht verbuchen
And I respond with answer "nein" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Bebuchbarkeit der KST ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# Kostenstelle auf "nicht bebuchbar" stellen
Given I open an editor "kst-3" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
And I set field "bebuchbar" to "nein"
And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"


# AfA-Vorschlag fuer 2-2 2002: Versuch zu verbuchen
Given I open an editor "vorschlag-22" from table "(FixedAsset):(DepreciationSuggestion)" with command "UPDATE" for record "003aaa"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "240001" in row 1
Then field "betrag" has value "1150.00" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is empty in row 1
# Versuch zu verbuchen -> Fehlermeldung
And I respond with answer "ja" to the dialog with id "4477"
#And I save the current editor
Then saving the current editor throws the exception "nur bebuchbare Kostenstellen erlaubt"
And I close the current editor

# Bebuchbarkeit der KST ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# Kostenstelle auf "bebuchbar" stellen
Given I open an editor "kst-4" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
And I set field "bebuchbar" to "ja"
And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"


# AfA-Vorschlag fuer 2-2 2002: verbuchen
Given I open an editor "vorschlag-23" from table "(FixedAsset):(DepreciationSuggestion)" with command "UPDATE" for record "003aaa"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "240001" in row 1
Then field "betrag" has value "1150.00" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is empty in row 1
# Speichern und verbuchen
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor
# =========================================================================================

@FALL-KST-nicht-bebuchbar3
Scenario: 3: KST - manuellen Aenderungen in der Tabelle

# nicht bebuchbare Kostenstelle in der Tabelle durch bebuchbare ersetzen
# Versuch eine nicht bebuchbare Kostenstelle in die Tabelle einzutragen


# bei Anlage 240002 Kst eintragen
Given I open an editor "anlage-5" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240002"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "kstelle" to "101"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-5"
And I save the current editor


# AfA-Vorschlag fuer 1-1 2002
Given I open an editor "vorschlag-30" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "002dddd"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "1"
And I set field "vanl" to "240002"
And I set field "banl" to "240002"
And I press button "afaerm"
Then the table has 1 rows
# nicht alles zeigen
And I set field "nzeigok" to "ja"
And I set field "nzeigwarn" to "ja"
And I set field "nzeigfehl" to "ja"
Then the table has 0 rows
And I set field "nzeigok" to "nein"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "240002" in row 1
Then field "betrag" has value "410.00" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# Bebuchbarkeit der KST ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# Kostenstelle auf "nicht bebuchbar" stellen
Given I open an editor "kst-5" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
And I set field "bebuchbar" to "nein"
And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"


# AfA-Vorschlag fuer 2-2 2002: anpassen und verbuchen
Given I open an editor "vorschlag-50" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "009mmm"
And I set field "gjahr" to "02"
And I set field "vmon" to "2"
And I set field "bmon" to "2"
And I set field "vanl" to "240002"
And I set field "banl" to "240003"
And I press button "afaerm"
Then the table has 2 rows
Then field "buchen" has value "nein" in row 1
Then field "buanlage" has value "240002" in row 1
Then field "betrag" has value "410.00" in row 1
Then field "tkstelle" has value "101" in row 1
Then field "tafaftxt" is not empty in row 1
#
# Versuch eine nicht bebuchbare KST einzutragen
Then field "tkstelle" is empty in row 2
And setting field "tkstelle" to "101" in row 2 throws the exception "4895"
Then field "tkstelle" is empty in row 2
#
# verbuchbare KST eintragen
And I set field "tkstelle" to "100" in row 1
Then field "tafaftxt" is empty in row 1
Then field "buchen" has value "nein" in row 1
And I set field "buchen" to "ja" in row 1
# Speichern und verbuchen
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


Given I open an editor "vorschlag-60" from table "(FixedAsset):(DepreciationSuggestion)" with command "VIEW" for record "+009mmm"
Then field "ablagef" has value "ja" in row 0
Then the table has 2 rows
Then field "buchen" has value "ja" in row 1
Then field "tafaftxt" is empty in row 1
Then field "tkstelle" has value "100" in row 1
# wurde verbucht
Then field "tbuafa" is not empty in row 1
Then field "buanlage" has value "240002" in row 1
Then field "betrag" has value "410.00" in row 1
#
Then field "tkstelle" is empty in row 2
Then field "buchen" has value "ja" in row 2
Then field "tbuafa" is not empty in row 2
And I close the current editor


# Bebuchbarkeit der KST ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# Kostenstelle auf "bebuchbar" stellen
Given I open an editor "kst-6" from table "(Account):(CostCenter)" with command "UPDATE" for record "101"
And I set field "bebuchbar" to "ja"
And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"

# =========================================================================================

@FALL-KTR-nicht-bebuchbar4
Scenario: 4: nicht bebuchbare Kostentraeger in der Tabelle


# bei Anlage 240004 Ktr eintragen
Given I open an editor "anlage-1ktr" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240004"
And I set field "modart" to "steuer"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "kstelle" to "100000"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-1ktr"
And I save the current editor


# AfA-Vorschlag fuer 1-1 2002
Given I open an editor "vorschlag-1ktr" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "001ktr"
And I set field "gjahr" to "02"
And I set field "vmon" to "1"
And I set field "bmon" to "1"
And I set field "vanl" to "240004"
And I set field "banl" to "240004"
And I press button "afaerm"
Then the table has 1 rows
# nicht alles zeigen
And I set field "nzeigok" to "ja"
And I set field "nzeigwarn" to "ja"
And I set field "nzeigfehl" to "ja"
Then the table has 0 rows
And I set field "nzeigok" to "nein"
Then the table has 1 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "240004" in row 1
Then field "betrag" has value "520.83" in row 1
Then field "tkstelle" has value "100000" in row 1
Then field "tafaftxt" is empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Bebuchbarkeit der KST ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# Kostentraeger 100000 auf "nicht bebuchbar" stellen
Given I open an editor "ktr-1" from table "(Account):(CostObject)" with command "UPDATE" for record "100000"
And I set field "bebuchbar" to "nein"
And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"


# AfA-Vorschlag fuer 2-2 2002 nur fuer Anlage 240004
Given I open an editor "vorschlag-2ktr" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "002ktr"
And I set field "gjahr" to "02"
And I set field "vmon" to "2"
And I set field "bmon" to "2"
And I set field "vanl" to "240004"
And I set field "banl" to "240004"
And I press button "afaerm"
Then the table has 1 rows
Then field "buchen" has value "nein" in row 1
Then field "buanlage" has value "240004" in row 1
Then field "betrag" has value "520.83" in row 1
Then field "tkstelle" has value "100000" in row 1
Then field "tafaftxt" is not empty in row 1
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor


# AfA-Vorschlag fuer 2-2 2002 nur fuer Anlage 240004
Given I open an editor "vorschlag-3ktr" from table "(FixedAsset):(DepreciationSuggestion)" with command "NEW" for record ""
And I set field "nummer" to "002ktr"
And I set field "gjahr" to "02"
And I set field "vmon" to "2"
And I set field "bmon" to "2"
And I set field "vanl" to "240005"
And I set field "banl" to "440002"
And I press button "afaerm"
Then the table has 3 rows
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "240005" in row 1
Then field "betrag" has value "840.00" in row 1
Then field "tkstelle" is empty in row 1
Then field "tafaftxt" is empty in row 1
# 
# Versuch einen nicht bebuchbaren KTR einzutragen
And setting field "tkstelle" to "100000" in row 1 throws the exception "4996"
# Kontrolle, dass der KTR nicht uebernommen wurde
Then field "buchen" has value "ja" in row 1
Then field "buanlage" has value "240005" in row 1
Then field "betrag" has value "840.00" in row 1
Then field "tkstelle" is empty in row 1
Then field "tafaftxt" is empty in row 1
#
And I respond with answer "ja" to the dialog with id "4477"
And I save the current editor
And I close the current editor

# Bebuchbarkeit der KTR ist nur in "Wartung" aenderbar
Given I'm logged in with password "annette"

# Kostentraeger auf "bebuchbar" stellen
Given I open an editor "ktr-2" from table "(Account):(CostObject)" with command "UPDATE" for record "100000"
And I set field "bebuchbar" to "ja"
And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"
# =========================================================================================


