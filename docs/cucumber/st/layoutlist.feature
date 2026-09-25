@persistent
@FP_TEST
Feature: Daten anlegen fuer Infosystem LAYOUTLIST

Scenario: Teste alle Eingabefelder des Infosystem mit dem Druckeinstellung
Given I open the infosystem "LAYOUTLIST"
And I set field "layout" to "12503"
And I press button "bstart"
Then field "tlayoutlist" has value "EINKAUF" in row 1
Then field "tinlayoutlistb" has value "icon:minus" in row 1
Then field "tinlayoutlistbsub" has value "icon:minus" in row 1
And I press button "tinlayoutlistb" in row 1
Then field "tinlayoutlistb" has value "icon:ok" in row 1
Then field "tlayoutlist" has value "SERVICE" in row 5
Then field "tinlayoutlistb" has value "icon:minus" in row 5 
Then field "tinlayoutlistbsub" has value "icon:ok" in row 5 
And I press button "tinlayoutlistbsub" in row 5
Then field "tinlayoutlistb" has value "icon:minus" in row 5 
And I close the current editor

Given I open an editor "LayoutlisteEinkauf" from table "(PrintParameter):(LayoutList)" with command "VIEW" for record "EINKAUF"
Then field "tlaybez" has value "Rechnung (Verkauf)" in row !lastRow
Then field "layzeilentyp" has value "Menüeintrag" in row !lastRow
And I close the current editor

Given I open an editor "LayoutlisteVerkauf" from table "(PrintParameter):(LayoutList)" with command "VIEW" for record "SERVICE"
Then field "tlaybez" has value "ZUGFeRD2-Rechnung (Verkauf)" in row !lastRow
Then field "layzeilentyp" has value "Submenü" in row !lastRow
And I close the current editor

Given I open the infosystem "LAYOUTLIST"
And I set field "layout" to "12503"
And I press button "bstart"
And I press button "layoutloeschen"
And I close the current editor

Scenario: Query Keine Zuordnung
Given I query "nummer, tlayout^nummer" from table "(PrintParameter):(LayoutList)" where "1:tlayout=12503"
Then query has no hits
