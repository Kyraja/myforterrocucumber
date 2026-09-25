# *****************************************************************************
#  Name             : anbu_anlkat_edit_01_plausis.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden die Plausis bzw. die Aenderbarkeit
#                     im Editor fuer Anlage geprueft.
#
# *****************************************************************************
@persistent
Feature: ANBU
Background: XXXXX


@FALL-1.BENUTZT
Scenario: FALL-1.benutzt

# Versuch eine "benutzte" Anlagenkategorie zu loeschen


# 2620 TX=de   |Objekt kann nicht geladen werden
# 1622 TX=de   |wird noch verwendet; darf nicht gel”scht werden
Then opening an editor from table "(FixedAsset):(FixedAssetGroup)" with command "DELETE" for record "1002" throws the exception "1622"


Given I open an editor "kopieren" from table "(FixedAsset):(FixedAssetGroup)" with command "COPY" for record "1002"
And I set field "nummer" to "1002copy"
And I save the current editor
And I close the current editor


# Versuch 1
# And I respond with answer "nein" to the dialog with id "826"
# Then opening an editor from table "(FixedAsset):(FixedAssetGroup)" with command "DELETE" for record "1002copy" throws the exception "10805"

# Versuch 2
# Given I open an editor "loeschen1" from table "(FixedAsset):(FixedAssetGroup)" with command "DELETE" for record "1002copy" with dialog "826" and answer "nein"


Given I open an editor "loeschen2" from table "(FixedAsset):(FixedAssetGroup)" with command "DELETE" for record "1002copy"
# =========================================================================================


