# *****************************************************************************
#  Name             : anbu_edit_objektsperren_004_anbukonfig.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Konten und Sperren in ANBU-Konfiguration
#
# *****************************************************************************
@persistent
Feature: anbu_edit_objektsperren_004_anbukonfig.feature
Background: Konten aus ANBU-Konfig duerfen nicht gesperrt werden

Given I set the fake date to "01.01.01"


Scenario Outline: Konten aus ANBU-Konfig duerfen nicht gesperrt werden


# Kontrolle, welche Konten bei Konfig. eingetragen sind
Given I open an editor "konfig-view" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "VIEW" for record "500"
# Erloes-Konten
Then field "erabver" has value "68850"
Then field "erabgew" has value "48450"
# Restbuchwertkonten
Then field "ebbver" has value "68950"
Then field "ebbgew" has value "48550"
And I save the current editor
And I close the current editor


Given I open an editor "<editor>" from table "(Account):(Account)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And saving the current editor throws the exception "3324"
And I close the current editor

Examples:
|editor|record|
|konto1| 68850|
|konto2| 48450|
|konto3| 68950|
|konto4| 48550|
# =========================================================================================


Scenario: Versuch ein gesperrtes Konto bei ANBU-Konfig einzutragen


Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "68850"
And I set field "nummer" to "68850a"
And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
And I save the current editor
And I close the current editor


Given I open an editor "konfig-update" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
# Erloes-Konten
Then setting field "erabver" to "68850a" throws the exception "1361"
Then setting field "erabgew" to "68850a" throws the exception "1361"
Then field "erabver" has value "68850"
Then field "erabgew" has value "48450"
# Restbuchwertkonten
Then setting field "ebbver" to "68850a" throws the exception "1361"
Then setting field "ebbgew" to "68850a" throws the exception "1361"
Then field "ebbver" has value "68950"
Then field "ebbgew" has value "48550"
# es wird nicht gespeichert - da nichts geaendert wurde
And I close the current editor
# =========================================================================================


