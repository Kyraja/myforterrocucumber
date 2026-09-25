# *****************************************************************************
#  Name           : speditionsauftrag.feature
#  Autor          : foe
#  Verantwortlich : teampss
#  Funktion       : Testet Speditionsauftrag
#
# *****************************************************************************
#
@persistent
Feature: Speditionsauftrag
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Gewicht in den Artikel V1 und V2 hinterlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "artikel1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "ntgewicht" to "10"
And I save the current editor

Given I open an editor "artikel2" from table "(Part):(Product)" with command "UPDATE" for record "V2"
And I set field "ntgewicht" to "5"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Speditionsauftrag anlegen, 2 Lieferscheine anlegen
#  Im Speditionsauftrag werden stornierte und Storno-Lieferscheine bei der Berechnung der Gewichte beruecksichtigt
# ----------------------------------------------------------------------------------------------
Given I open an editor "spedauftrag" from table "(ShipOrder):(ShippingOrder)" with command "NEW" for record ""
And I set fields
    | such      | STEST |
    | warenempf | 1     |
And I save the current editor

#Lieferschein 1 anlegen
Given I open an editor "vk1ls" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "betreff" to "Speditionsauftrag"
And I set field "sped" to id from editor "spedauftrag"
And I set field "ueb" to "ja"
And I append rows
    | pnum | artex  | mge  |
    | 1    | V1     | 10   |
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to "501" in row 2
And I set field "mge" to "5" in row 2
And I set field "fmenge" to "2" in row 2
And I save the current editor

#Lieferschein 2 anlegen
Given I open an editor "vk2ls" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "betreff" to "Speditionsauftrag"
And I set field "sped" to id from editor "spedauftrag"
And I set field "ueb" to "ja"
And I append rows
    | pnum | artex  | mge  |
    | 1    | V2     | 10   |
And I press button "pmneu" in row 1
And I create a new row at the end of the table
And I set field "artex" to "501" in row 2
And I set field "mge" to "5" in row 2
And I set field "fmenge" to "2" in row 2
And I save the current editor

#Lieferschein 1 stornieren
Given I open an editor "stornols" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "vk1ls"
And I save the current editor

#Speditionsauftrag aufrufen und Gewicht pruefen
Given I open an editor "spedview" from table "(ShipOrder):(ShippingOrder)" with command "VIEW" for record from editor "spedauftrag"
# Bei der Berechnung der Gewichte wurde nur Lieferschein 2 beruecksichtigt
Then field "nettogew" has value "50"
Then field "bruttogew" has value "52.5"
Then field "anzpackstls" has value "5"
And I close the current editor
