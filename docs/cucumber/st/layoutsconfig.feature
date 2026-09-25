@persistent
@FP_TEST
Feature: Daten anlegen fuer Infosystem LAYOUTSCONFIG

Scenario Outline: Betriebsdaten fuellen und abgleichen mit Layout und Infosystem
Given I open an editor "Passwort" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set field "fontname" to "<fontname>"
And I set field "pformat" to "<pformat>"
And I set field "fontgr" to "<fontgr>"
And I set field "ausricht" to "<ausricht>"
And I save the current editor
And I close the current editor

#Werte im neuen Layout testen
Given I open an editor "NeuesLayout" from table "(PrintParameter):(Layout)" with command "NEW" for record ""
Then field "fontname" has value "<fontname>"
Then field "pformat" has value "<pformat>"
Then field "fontgr" has value "<fontgr>"
Then field "ausricht" has value "<ausricht>"
And I close the current editor

#Werte im Kopf des IS testen
Given I open the infosystem "LAYOUTSCONFIG"
Then field "fontname" has value "<fontname>"
Then field "pformat" has value "<pformat>"
Then field "fontgr" has value "<fontgr>"
Then field "ausricht" has value "<ausricht>"
And I set field "kanal" to "jasper"
And I set field "layarb" to "fe"
And I press button "bstart"

#Alle markieren / Markierung aufheben
And I press button "selectall"
Then field "tmark" has value "ja" in row 1
And I press button "deselectall"
Then field "tmark" has value "nein" in row 1

# Werte in der Zeile testen
And I set field "tmark" to "1" in row 2
And I press button "defaultcp"
Then field "tfontname" has value "<fontname>" in row 2
Then field "tpformat" has value "<pformat>" in row 2
Then field "tfontgr" has value "<fontgr>" in row 2
Then field "tausricht" has value "<ausricht>" in row 2
Then field "tlayout^fontname" has value "<fontname>" in row 2
Then field "tlayout^pformat" has value "<pformat>" in row 2
Then field "tlayout^fontgr" has value "<fontgr>" in row 2
Then field "tlayout^ausricht" has value "<ausricht>" in row 2
Then field "tlayout^genlayout" has value "ja" in row 2
And I close the current editor

Examples:
| row | fontname | pformat | fontgr | ausricht   |
| 001 | Courier  | LETTER  | 12     | Querformat |
