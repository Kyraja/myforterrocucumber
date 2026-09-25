# *****************************************************************************
#  Name             : anbu_anlapedit_000_konf2.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Cucumberscript ersetzt Lader ANLPEDIT.KONF für den Test
#                     ref_anlapedit3
# *****************************************************************************

@persistent 

Feature: anlapedit
Scenario: anlapedit konf2

# Lader wirft für alle drei Änderungen den Fehler "unzulässige Angabe". 
# Da diese Änderungen in Cucumber möglich sind, wird hier nicht gespeichert.

Given I open an editor "anbukonf" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
And I set field "stafakost" to "nein"
And I set field "apedit" to "ja"
And I set field "anlvlad" to "ja"
# And I save the current editor
And I close the current editor
