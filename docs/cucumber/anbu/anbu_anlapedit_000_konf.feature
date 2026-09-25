# *****************************************************************************
#  Name             : anbu_anlapedit_000_konf.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Cucumberscript ersetzt Lader ANLPEDIT.KONF für die Tests
#                     ref_anlapedit und ref_anlapedit2
# *****************************************************************************

@persistent 

Feature: anlapedit
Scenario: anlapedit konf

Given I open an editor "anbukonf" from table "(FixedAsset):(FixedAssetAccountingConfiguration)" with command "UPDATE" for record "500"
And I set field "apedit" to "ja"
And I set field "anlvlad" to "ja"
And I save the current editor 
And I close the current editor
