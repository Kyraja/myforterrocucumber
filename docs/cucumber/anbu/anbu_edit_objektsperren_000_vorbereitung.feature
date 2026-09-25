# *****************************************************************************
#  Name             : anbu_edit_objektsperren_000_vorbereitung.feature
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
Background: Sperren bei Anlagenvorgang: Objekte Sperren

Given I set the fake date to "01.02.01"


Scenario Outline: Objekte sperren

Given I open an editor "<editor>" from table "(Account):(<datei>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to "Standard-<type>sperre"
And I set field "namebspr" to "Objekt ist immer gesperrt!!!"
And I save the current editor
And I close the current editor

Examples:
|editor|           datei| record|                type|
|    ks|      CostCenter|   100e|       Kostenstellen|
|   ktr|      CostObject|100000e|       Kostentraeger|
| kvert|CostDistribution|   1003|Stammkostenverteiler|
# |    ko|         Account|  ?????|               Konto|
# =========================================================================================


Scenario Outline: Anlagen mit Kostenobjekten versorgen

Given I open an editor "anlage-<nummer>" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "<anlage>"
And I set field "namebspr" to "<namebspr>"
And I set field "modart" to "<art>"
# Wechsel in das AfA-Modell
And I press button "bafamodell" to open a subeditor for ""
And I set field "kstelle" to "<kstelle>"
#And I respond with answer "Ja" to the dialog with id "4530"
And I save the current editor
# zurueck zum Anlageneditor
And I switch the current editor to editor "anlage-<nummer>"
And I save the current editor

Examples:
|nummer|anlage|   art|kstelle|namebspr|Kommentar
|     1|440003|steuer|   100a| mit KST| vollabgeschieben
|     2|440002|steuer|100000a| mit KTR|nicht vollabgeschieben
|     3|520003|steuer|   1004|  mit KV|nicht vollabgeschieben
|     4|520005|steuer|100000b| mit KTR|nicht vollabgeschieben
|     5|690001|steuer|   1001|  mit KV|nicht vollabgeschieben
|     6|690006|steuer|   100b| mit KST|nicht vollabgeschieben
|     7|690007|steuer|   100c| mit KST|nicht vollabgeschieben
# =========================================================================================


Scenario Outline: Kostenobjekten, die in ANlagen stecken, sperren

Given I open an editor "<editor>" from table "(Account):(<datei>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to "Standard-<type>sperre"
And I set field "namebspr" to "Objekt ist immer gesperrt!!!"
And I save the current editor
And I close the current editor

Examples:
|editor|           datei| record|                type|
|   ks1|      CostCenter|   100a|       Kostenstellen|
|   ks2|      CostCenter|   100b|       Kostenstellen|
|  ktr1|      CostObject|100000a|       Kostentraeger|
|kvert1|CostDistribution|   1004|Stammkostenverteiler|
# =========================================================================================


Scenario Outline: Anlagen mit/ohne Kostenobjekt kopieren

Given I open an editor "anlage-copy<nummer>" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "<quelle>"
And I set field "nummer" to "<anlage>"
And I save the current editor

Examples:
|nummer|quelle|anlage|   art|
|     1|690001|770000|steuer|
|     2|690006|770001|steuer|
|     3|520001|770002|steuer|

# =========================================================================================
