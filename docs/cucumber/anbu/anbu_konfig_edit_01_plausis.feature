# *****************************************************************************
#  Name             : anbanbu_konfig_00_edit_plausis.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Test der Aeditierbarkeit bei ANBU-Konfiguration
#
# *****************************************************************************
@persistent
Feature: anbu_konfig_edit_01_plausis.feature
Background: Test der Aeditierbarkeit bei ANBU-Konfiguration


Given I set the fake date to "01.01.01"

@FALL-Konfig1
Scenario: Vereinfachungsregel unter 'sy'; ohne Speichern

Given I open an editor "ve-regel001" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"

Then field "anve" is not modifiable
Then field "anve" has value "halbjährig"
#
Then field "abve" is modifiable
Then field "abve" has value ""

Then field "anakt" is modifiable
Then field "andeakt" is modifiable
Then field "abakt" is not modifiable
Then field "abdeakt" is not modifiable

And I set field "abve" to "halbjährig"
Then field "abakt" is modifiable
Then field "abdeakt" is modifiable
And I set field "abakt" to "01.01.01"
And I set field "abdeakt" to "31.12.03"
#
# immer noch editierbar, weil noch nicht gespeichert wurde
Then field "abve" is modifiable

# es wird nicht gespeichert
# And I save the current editor
And I close the current editor
# =========================================================================================


@FALL-Konfig2
Scenario: Vereinfachungsregel unter 'annette'; ohne Speichern

Given I'm logged in with password "annette"

Given I open an editor "ve-regel002" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"

Then field "anve" is modifiable
Then field "anve" has value "halbjährig"
#
Then field "abve" is modifiable
Then field "abve" has value ""

Then field "anakt" is modifiable
Then field "andeakt" is modifiable
Then field "abakt" is modifiable
Then field "abdeakt" is modifiable

And I set field "abve" to "halbjährig"
Then field "abakt" is modifiable
Then field "abdeakt" is modifiable
And I set field "abakt" to "01.01.01"
And I set field "abdeakt" to "31.12.03"
#
# immer noch editierbar, weil noch nicht gespeichert wurde
Then field "abve" is modifiable

# es wird nicht gespeichert
# And I save the current editor
And I close the current editor

# "Wartungs-PW" aufgeben
Given I'm logged in with password "sy"
# =========================================================================================


@FALL-Konfig3
Scenario: Vereinfachungsregel unter 'sy'; mit Speichern

Given I open an editor "ve-regel003" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"

Then field "anve" is not modifiable
Then field "anve" has value "halbjährig"
#
Then field "abve" is modifiable
Then field "abve" has value ""

Then field "anakt" is modifiable
Then field "andeakt" is modifiable
Then field "abakt" is not modifiable
Then field "abdeakt" is not modifiable

And I set field "abve" to "halbjährig"
Then field "abakt" is modifiable
Then field "abdeakt" is modifiable
And I set field "abakt" to "01.01.01"
And I set field "abdeakt" to "31.12.03"
#
# immer noch editierbar, weil noch nicht gespeichert wurde
Then field "abve" is modifiable
And I save the current editor
And I close the current editor


Given I open an editor "ve-regel004" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"

Then field "anve" is not modifiable
Then field "anve" has value "halbjährig"
#
Then field "abve" is not modifiable
Then field "abve" has value "halbjährig"

Then field "anakt" is empty
Then field "anakt" is modifiable
Then field "andeakt" is empty
Then field "andeakt" is modifiable
Then field "abakt" is not empty
Then field "abakt" is not modifiable
Then field "abdeakt" is not empty
Then field "abdeakt" is not modifiable
# es wird nicht gespeichert
# And I save the current editor
And I close the current editor
# =========================================================================================
