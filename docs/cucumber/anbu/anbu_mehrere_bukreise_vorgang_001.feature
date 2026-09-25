# *****************************************************************************
#  Name             : anbu_mehrere_bukreise_vorgang_001.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Hier werden Plausis und Editierverhalten
#                     im Editor fuer Anlagenvorgang geprueft
#
# *****************************************************************************
@persistent
Feature: anbu_mehrere_bukreise_vorgang_001.feature
Background: Test des Editors fuer Anlagenvorgang

Given I set the fake date to "7.1.01"


@FALL-Kopie
# 1: vanl-banl; vkstelle-bkstelle und vwg-bwg
Scenario: Umbuchung in mehreren Bu-Kreisen

# Umbuchung im 1. Buchungskreis
Given I open an editor "anlagenvorg-1" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "2002VU"
And I set field "selbukreis" to "1"
And I set field "vorgart" to "Vollumbuchung"
And I set field "anlage" to "XXX1"
And I set field "uanlage" to "XXX5"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor

# Umbuchung im 2. Buchungskreis
Given I open an editor "anlagenvorg-2" from table "(FixedAsset):(FixedAssetTransaction)" with command "COPY" for record "+2002VU"
#
# 6640 TX=de   |Feldoperation kann nicht ausgefuehrt werden.
Then setting field "selbukreis" to "2" in row 1 throws the exception "6640"
#
# 8609 TX=de   |Anlage nicht bebuchbar: in diesem Buchungskreis bereits abgegangen!
Then setting field "selbukreis" to "1" in row 1 throws the exception "6640"
#
And I set field "selbukreis" to "4"
# wird nicht gespeichert
And I close the current editor

# Umbuchung im 5. Buchungskreis
Given I open an editor "anlagenvorg-5" from table "(FixedAsset):(FixedAssetTransaction)" with command "COPY" for record "+2002VU"
And I set field "selbukreis" to "5"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor
# =========================================================================================
