# *****************************************************************************
#  Name: field_changed.feature
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Feldaustritte
# *****************************************************************************
@persistent
@VALUE_LIST_FIELD_CHANGED
Feature: FIELD_CHANGED_109:4

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "FC_BRD" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "FC_BRD"
And I set field "classname" to "FcBrd"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichner

Given I open an editor "FC_BADEN" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "FC_BADEN"
And I set field "classname" to "FcBaden"
And I save the current editor
And I close the current editor

Scenario: EintragBoolWertFuehrtZuBoolTyp

Given I open an editor "FC_BOOL" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "bool" to "true" in row !lastRow
Then field "wtyp" has value "Bool" in row !lastRow
And I close the current editor

Scenario: EintragIntegerWertFuehrtZuIntegerTyp

Given I open an editor "FC_INT" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "integer" to "1" in row !lastRow
Then field "wtyp" has value "Integer" in row !lastRow
And I close the current editor

Scenario: EintragRealWertFuehrtZuRealTyp

Given I open an editor "FC_REAL" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "real" to "2.25" in row !lastRow
Then field "wtyp" has value "Real" in row !lastRow
And I close the current editor

Scenario: EintragObjektWertFuehrtZuVerweisTyp

Given I open an editor "FC_REF" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "objekt" to "109:1 FC_BRD" in row !lastRow
Then field "wtyp" has value "Verweis" in row !lastRow
And I close the current editor

Scenario: EintragKurztextWertFuehrtZuKurztextTyp

Given I open an editor "FC_KURZTEXT" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "kurztxt" to "52" in row !lastRow
Then field "wtyp" has value "Kurztext" in row !lastRow
And I close the current editor

Scenario: EintragEinzeiligerTextWertFuehrtZuTypTextEinzeilig

Given I open an editor "FC_EINZEILER" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "einzlgtxt" to "Hallo Welt!" in row !lastRow
Then field "wtyp" has value "Text einzeilig" in row !lastRow
And I close the current editor

Scenario: EintragMehrzeiligerTextWertFuehrtZuTypTextMehrzeilig

Given I open an editor "FC_MEHRZEILER" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "mzlgtxt" to "Hallo\nWelt!" in row !lastRow
Then field "wtyp" has value "Text mehrzeilig" in row !lastRow
And I close the current editor

Scenario: EintragFreitextWertFuehrtZuFreitextTyp

Given I open an editor "FC_FTEXT" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "ftext" to "Hallo Welt!" in row !lastRow
Then field "wtyp" has value "Freitext" in row !lastRow
And I close the current editor

Scenario: EintragBoolTypLeertAlleAnderenWerte

Given I open an editor "FC_BOOL" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "bool" to "true" in row !lastRow
And I set field "wtyp" to "Bool" in row !lastRow
Then field "bool" has value "ja" in row !lastRow
Then field "integer" has value "0" in row !lastRow
Then field "real" has value "0.0000" in row !lastRow
Then field "objekt" is empty in row !lastRow
Then field "kurztxt" is empty in row !lastRow
Then field "einzlgtxt" is empty in row !lastRow
Then field "mzlgtxt" is empty in row !lastRow
Then field "ftext" is empty in row !lastRow
And I close the current editor

Scenario: EintragIntegerTypLeertAlleAnderenWerte

Given I open an editor "FC_INT" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "integer" to "1" in row !lastRow
And I set field "wtyp" to "Integer" in row !lastRow
Then field "integer" has value "1" in row !lastRow
Then field "bool" has value "nein" in row !lastRow
Then field "real" has value "0.0000" in row !lastRow
Then field "objekt" is empty in row !lastRow
Then field "kurztxt" is empty in row !lastRow
Then field "einzlgtxt" is empty in row !lastRow
Then field "mzlgtxt" is empty in row !lastRow
Then field "ftext" is empty in row !lastRow
And I close the current editor

Scenario: EintragRealTypLeertAlleAnderenWerte

Given I open an editor "FC_REAL" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "real" to "2.25" in row !lastRow
And I set field "wtyp" to "Real" in row !lastRow
Then field "bool" has value "nein" in row !lastRow
Then field "integer" has value "0" in row !lastRow
Then field "real" has value "2.2500" in row !lastRow
Then field "objekt" is empty in row !lastRow
Then field "kurztxt" is empty in row !lastRow
Then field "einzlgtxt" is empty in row !lastRow
Then field "mzlgtxt" is empty in row !lastRow
Then field "ftext" is empty in row !lastRow
And I close the current editor

Scenario: EintragVerweisTypLeertAlleAnderenWerte

Given I open an editor "FC_REF" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "objekt" to "109:1 FC_BRD" in row !lastRow
And I set field "wtyp" to "Verweis" in row !lastRow
Then field "objekt^such" has value "FC_BRD" in row !lastRow
Then field "bool" has value "nein" in row !lastRow
Then field "integer" has value "0" in row !lastRow
Then field "real" has value "0.0000" in row !lastRow
Then field "kurztxt" is empty in row !lastRow
Then field "einzlgtxt" is empty in row !lastRow
Then field "mzlgtxt" is empty in row !lastRow
Then field "ftext" is empty in row !lastRow
And I close the current editor

Scenario: EintragKurztextTypLeertAlleAnderenWerte

Given I open an editor "FC_KURZZTEXT" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "kurztxt" to "52" in row !lastRow
And I set field "wtyp" to "Kurztext" in row !lastRow
Then field "kurztxt" has value "52" in row !lastRow
Then field "bool" has value "nein" in row !lastRow
Then field "integer" has value "0" in row !lastRow
Then field "real" has value "0.0000" in row !lastRow
Then field "objekt" is empty in row !lastRow
Then field "einzlgtxt" is empty in row !lastRow
Then field "mzlgtxt" is empty in row !lastRow
Then field "ftext" is empty in row !lastRow
And I close the current editor

Scenario: EintragEinzeilerTypLeertAlleAnderenWerte

Given I open an editor "FC_EINZEILER" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "einzlgtxt" to "Hallo Welt!" in row !lastRow
And I set field "wtyp" to "Text einzeilig" in row !lastRow
Then field "einzlgtxt" has value "Hallo Welt!" in row !lastRow
Then field "bool" has value "nein" in row !lastRow
Then field "integer" has value "0" in row !lastRow
Then field "real" has value "0.0000" in row !lastRow
Then field "objekt" is empty in row !lastRow
Then field "kurztxt" is empty in row !lastRow
Then field "mzlgtxt" is empty in row !lastRow
Then field "ftext" is empty in row !lastRow
And I close the current editor

Scenario: EintragMehrzeilerTypLeertAlleAnderenWerte

Given I open an editor "FC_MEHRZEILER" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "mzlgtxt" to "Hallo\nWelt!" in row !lastRow
And I set field "wtyp" to "Text mehrzeilig" in row !lastRow
Then field "mzlgtxt" has value "Hallo\nWelt!" in row !lastRow
Then field "bool" has value "nein" in row !lastRow
Then field "integer" has value "0" in row !lastRow
Then field "real" has value "0.0000" in row !lastRow
Then field "objekt" is empty in row !lastRow
Then field "kurztxt" is empty in row !lastRow
Then field "einzlgtxt" is empty in row !lastRow
Then field "ftext" is empty in row !lastRow
And I close the current editor

Scenario: EintragFreitextTypLeertAlleAnderenWerte

Given I open an editor "FC_FTEXT" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "ftext" to "Hallo Welt!" in row !lastRow
And I set field "wtyp" to "Freitext" in row !lastRow
Then field "ftext" has value "Hallo Welt!" in row !lastRow
Then field "bool" has value "nein" in row !lastRow
Then field "integer" has value "0" in row !lastRow
Then field "real" has value "0.0000" in row !lastRow
Then field "objekt" is empty in row !lastRow
Then field "kurztxt" is empty in row !lastRow
Then field "einzlgtxt" is empty in row !lastRow
Then field "mzlgtxt" is empty in row !lastRow
And I close the current editor

Scenario: LeereWertemengenbezeichnerBeiBearbeiteterTabelleNein

Given I open an editor "FC_WMBEZ" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then field "ladetab" is modifiable
And I press button "ladetab"
Then the table has 0 rows
And I create a new row at the end of the table
And I set field "bezeichner" to "FC_BADEN" in row !lastRow
And I set field "bool" to "true" in row !lastRow
And I respond with answer "nein" to the dialog with id "10310"
And I set field "wmbezeichner" to ""
Then the table has 1 rows
And I save the current editor
Then the table has 1 rows
And I close the current editor

Scenario: LeereWertemengenbezeichnerBeiNichtBearbeiteterTabelleOhneDialog

Given I open an editor "FC_WMBEZ" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then field "ladetab" is modifiable
And I press button "ladetab"
Then the table has 1 rows
And I set field "wmbezeichner" to ""
Then field "ladetab" is not modifiable
Then the table has 0 rows
And I close the current editor

Scenario: LeereWertemengenbezeichnerBeiBearbeiteterTabelleJa

Given I open an editor "FC_WMBEZ" from table "(ValueSet):(ValueList)" with command "UPDATE" for record ""
And I set field "wmbezeichner" to "FC_BRD"
Then field "ladetab" is modifiable
And I press button "ladetab"
Then the table has 1 rows
And I set field "integer" to "1" in row !lastRow
And I respond with answer "ja" to the dialog with id "10310"
And I set field "wmbezeichner" to ""
Then field "ladetab" is not modifiable
Then the table has 0 rows
And I close the current editor
