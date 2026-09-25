# *****************************************************************************
#  Name: field_changed.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Feldaustritte
# *****************************************************************************
@persistent
@VALUE_FIELD_CHANGED
Feature: FIELD_CHANGED_109:3

 Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Scenario: ErzeugeWertemengenBezeichner

Given I open an editor "FC_BEZ" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "FC_WMBEZ"
And I set field "classname" to "FcValueSetIdentifier"
And I save the current editor
And I close the current editor

Scenario: ErzeugeBezeichner

Given I open an editor "FC_BEZEICHNER" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "FC_BEZEICHNER"
And I set field "classname" to "FcIdentifier"
And I save the current editor
And I close the current editor

Scenario: EintragBoolWertFuehrtZuBoolTyp

Given I open an editor "FC_BOOL" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "bool" to "true"
Then field "wtyp" has value "Bool"
And I close the current editor

Scenario: EintragIntegerWertFuehrtZuIntegerTyp

Given I open an editor "FC_INT" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "integer" to "1"
Then field "wtyp" has value "Integer"
And I close the current editor

Scenario: EintragRealWertFuehrtZuRealTyp

Given I open an editor "FC_REAL" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "real" to "2,25"
Then field "wtyp" has value "Real"
And I close the current editor

Scenario: EintragObjektWertFuehrtZuVerweisTyp

Given I open an editor "FC_REF" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "objekt" to "109:1 FC_WMBEZ"
Then field "wtyp" has value "Verweis"
And I close the current editor

Scenario: EintragKurztextWertFuehrtZuKurztextTyp

Given I open an editor "FC_KURZTEXT" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "kurztxt" to "52"
Then field "wtyp" has value "Kurztext"
And I close the current editor

Scenario: EintragEinzeiligerTextWertFuehrtZuTypTextEinzeilig

Given I open an editor "FC_EINZEILER" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "einzlgtxt" to "Hallo Welt!"
Then field "wtyp" has value "Text einzeilig"
And I close the current editor

Scenario: EintragMehrzeiligerTextWertFuehrtZuTypTextMehrzeilig

Given I open an editor "FC_MEHRZEILER" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "mzlgtxt" to "Hallo\nWelt!"
Then field "wtyp" has value "Text mehrzeilig"
And I close the current editor

Scenario: EintragFreitextWertFuehrtZuFreitextTyp

Given I open an editor "FC_FREITEXT" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "ftext" to "Hallo Welt!"
Then field "wtyp" has value "Freitext"
And I close the current editor

Scenario: EintragBoolTypLeertAlleAnderenWerte

Given I open an editor "FC_BOOL" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "bool" to "true"
And I set field "wtyp" to "Bool"
Then field "bool" has value "ja"
Then field "integer" has value "0"
Then field "real" has value "0.0000"
Then field "objekt" is empty
Then field "kurztxt" is empty
Then field "einzlgtxt" is empty
Then field "mzlgtxt" is empty
Then field "ftext" is empty
And I close the current editor

Scenario: EintragIntegerTypLeertAlleAnderenWerte

Given I open an editor "FC_INT" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "integer" to "1"
And I set field "wtyp" to "Integer"
Then field "integer" has value "1"
Then field "bool" has value "nein"
Then field "real" has value "0.0000"
Then field "objekt" is empty
Then field "kurztxt" is empty
Then field "einzlgtxt" is empty
Then field "mzlgtxt" is empty
Then field "ftext" is empty
And I close the current editor

Scenario: EintragRealTypLeertAlleAnderenWerte

Given I open an editor "FC_REAL" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "real" to "2,25"
And I set field "wtyp" to "Real"
Then field "bool" has value "nein"
Then field "integer" has value "0"
Then field "real" has value "2.2500"
Then field "objekt" is empty
Then field "kurztxt" is empty
Then field "einzlgtxt" is empty
Then field "mzlgtxt" is empty
Then field "ftext" is empty
And I close the current editor

Scenario: EintragVerweisTypLeertAlleAnderenWerte

Given I open an editor "FC_REF" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "objekt" to "109:1 FC_WMBEZ"
And I set field "wtyp" to "Verweis"
Then field "objekt^such" has value "FC_WMBEZ"
Then field "bool" has value "nein"
Then field "integer" has value "0"
Then field "real" has value "0.0000"
Then field "kurztxt" is empty
Then field "einzlgtxt" is empty
Then field "mzlgtxt" is empty
Then field "ftext" is empty
And I close the current editor

Scenario: EintragKurztextTypLeertAlleAnderenWerte

Given I open an editor "FC_KURZTEXT" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "kurztxt" to "52"
And I set field "wtyp" to "Kurztext"
Then field "kurztxt" has value "52"
Then field "bool" has value "nein"
Then field "integer" has value "0"
Then field "real" has value "0.0000"
Then field "objekt" is empty
Then field "einzlgtxt" is empty
Then field "mzlgtxt" is empty
Then field "ftext" is empty
And I close the current editor

Scenario: EintragEinzeilerTypLeertAlleAnderenWerte

Given I open an editor "FC_EINZEILER" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "einzlgtxt" to "Hallo Welt!"
And I set field "wtyp" to "Text einzeilig"
Then field "einzlgtxt" has value "Hallo Welt!"
Then field "bool" has value "nein"
Then field "integer" has value "0"
Then field "real" has value "0.0000"
Then field "objekt" is empty
Then field "kurztxt" is empty
Then field "mzlgtxt" is empty
Then field "ftext" is empty
And I close the current editor

Scenario: EintragMehrzeilerTypLeertAlleAnderenWerte

Given I open an editor "FC_MEHRZEILER" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "mzlgtxt" to "Hallo\nWelt!"
And I set field "wtyp" to "Text mehrzeilig"
Then field "mzlgtxt" has value "Hallo\nWelt!"
Then field "bool" has value "nein"
Then field "integer" has value "0"
Then field "real" has value "0.0000"
Then field "objekt" is empty
Then field "kurztxt" is empty
Then field "einzlgtxt" is empty
Then field "ftext" is empty
And I close the current editor

Scenario: EintragFreitextTypLeertAlleAnderenWerte

Given I open an editor "FC_FREITEXT" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "FC_WMBEZ"
And I set field "bezeichner" to "FC_BEZEICHNER"
And I set field "ftext" to "Hallo Welt!"
And I set field "wtyp" to "Freitext"
Then field "ftext" has value "Hallo Welt!"
Then field "bool" has value "nein"
Then field "integer" has value "0"
Then field "real" has value "0.0000"
Then field "objekt" is empty
Then field "kurztxt" is empty
Then field "einzlgtxt" is empty
Then field "mzlgtxt" is empty
And I close the current editor
