# *****************************************************************************
#  Name             : anbu_edit_objektsperren_001_anlvorgang.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : 
#
#
#
# *****************************************************************************
@persistent
Feature: anbu_edit_objektsperren_001_anlvorgang.feature
Background: Sperren bei Anlagenvorgang

Given I set the fake date to "01.02.01"

Scenario: Bedingungsfeld "kstellesperredeakt"

Given I open an editor "anlagenvorg-kstellesperredeakt" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "200VA"
And I set field "vorgart" to "Vollabgang"
Then field "kstellesperredeakt" has value "ja"
#
# ab hier ist die Anlage nicht leer
And I set field "anlage" to "520001"
Then field "abkstelle" is empty in row 0
Then field "kstellesperredeakt" has value "nein"
#
And I set field "vorgart" to "Teilabgang"
Then field "kstellesperredeakt" has value "nein"
#
And I set field "vorgart" to "Vollumbuchung"
Then field "kstellesperredeakt" has value "ja"
#
And I set field "vorgart" to "Teilumbuchung"
Then field "kstellesperredeakt" has value "ja"
#
And I set field "vorgart" to "Bilanzkontowechsel"
Then field "kstellesperredeakt" has value "ja"
#
And I set field "vorgart" to "Teilabgang"
Then field "kstellesperredeakt" has value "nein"
#
And I set field "auahk" to "500.11"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: gesperrte Kostenobjekte, Teil 1

Given I set the fake date to "01.12.01"

Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "300VA"
And I set field "vorgart" to "Vollabgang"
Then field "kstellesperredeakt" has value "ja"
#
# Anlage mit der gesperren KST
And I set field "anlage" to "690006"
Then field "abkstelle" has value "100b"
Then field "kstellesperredeakt" has value "nein"
#
# 4806 TX=de   |Objekt ist gesperrt.
And saving the current editor throws the exception "4806"
#  2743 TX=de   |Vorgang abgebrochen
And saving the current editor throws the exception "2743"
#
#
# Anlage mit dem gesperren KTR
And I set field "anlage" to "440002"
Then field "abkstelle" has value "100000a"
Then field "kstellesperredeakt" has value "nein"
#
# 4806 TX=de   |Objekt ist gesperrt.
And saving the current editor throws the exception "4806"
#  2743 TX=de   |Vorgang abgebrochen
And saving the current editor throws the exception "2743"
And I close the current editor


# Anlage mit einem gesperren KV
Given I open an editor "anlagenvorg2" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "300VA"
And I set field "vorgart" to "Vollabgang"
Then field "kstellesperredeakt" has value "ja"
# Anlage mit dem gesperren KV
And I set field "anlage" to "520003"
Then field "abkstelle" has value "1004"
Then field "kstellesperredeakt" has value "nein"
#
# 4806 TX=de   |Objekt ist gesperrt.
And saving the current editor throws the exception "4806"
#  2743 TX=de   |Vorgang abgebrochen
And saving the current editor throws the exception "2743"
And I close the current editor
# =========================================================================================


Scenario: STORNO mit gesperrten Objekten

Given I set the fake date to "01.12.01"

# ANlage 520005 ist bis November abgeschrieben -> "01.12.01"

Given I open an editor "anlagenvorg" from table "(FixedAsset):(FixedAssetTransaction)" with command "NEW" for record ""
And I set field "nummer" to "333VA"
And I set field "vorgart" to "Vollabgang"
Then field "kstellesperredeakt" has value "ja"
#
And I set field "anlage" to "520005"
Then field "abkstelle" has value "100000b"
Then field "kstellesperredeakt" has value "nein"
And I respond with answer "Ja" to the dialog with id "4479"
And I save the current editor
And I close the current editor


Given I open an editor "kostentr1" from table "(Account):(CostObject)" with command "UPDATE" for record "100000b"
And I set field "sperrkonfigurationneu" to "Standard-Kostentraegersperre"
And I save the current editor
And I close the current editor


Given I open an editor "anlagenvorg-storno1" from table "(FixedAsset):(FixedAssetTransaction)" with command "REVERSAL" for record "+333VA"
Then field "anlage" has value "520005"
Then field "abkstelle" has value "100000b"
Then field "kstellesperredeakt" has value "ja"
And I save the current editor
And I close the current editor
# =========================================================================================


