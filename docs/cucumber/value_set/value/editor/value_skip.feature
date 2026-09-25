# *****************************************************************************
#  Name:  skip.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet die Skiplademethoden im Objekt Wert
# *****************************************************************************
@persistent
@CREATE_IDENTIFIER
Feature: CREATE_IDENTIFIER

Scenario: Datenerfassung

Background:
   Given I'm logged in with password "sy"
   And I set the operation language to "Deutsch"
   Given I disable the flag 298

Given I open an editor "Datentypen" from table "(ValueSet):(ValueSetIdentifier)" with command "NEW" for record ""
And I set field "such" to "Datentypen"
And I set field "classname" to "DatenTypen"
And I save the current editor
And I close the current editor

Given I open an editor "Datentyp" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "Integer"
And I set field "classname" to "DatenTypInteger"
And I save the current editor
And I close the current editor

Given I open an editor "Datentyp" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "real"
And I set field "classname" to "DatenTypRead"
And I save the current editor
And I close the current editor

Given I open an editor "Datentyp" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "bool"
And I set field "classname" to "DatenTypBool"
And I save the current editor
And I close the current editor

Given I open an editor "Datentyp" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "objekt"
And I set field "classname" to "DatenTypObjekt"
And I save the current editor
And I close the current editor

Given I open an editor "Datentyp" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "kurztext"
And I set field "classname" to "DatenTypKurztext"
And I save the current editor
And I close the current editor

Given I open an editor "Datentyp" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "Einzeilig"
And I set field "classname" to "DatenTypEinzeilig"
And I save the current editor
And I close the current editor


Given I open an editor "Datentyp" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "Mehrzeilig"
And I set field "classname" to "DatenTypMehrzeilig"
And I save the current editor
And I close the current editor

Given I open an editor "Datentyp" from table "(ValueSet):(Identifier)" with command "NEW" for record ""
And I set field "such" to "Freitext"
And I set field "classname" to "DatenTypFreitext"
And I save the current editor
And I close the current editor

Given I open an editor "Integer" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "Datentypen"
And I set field "bezeichner" to "Integer"
And I set field "wtyp" to "Integer"
And I set field "integer" to "1"
Then field "wertart" has value "I9"
Then field "wertuniversal" has value "1"
And I save the current editor
And I close the current editor

Given I open an editor "Real" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "Datentypen"
And I set field "bezeichner" to "Real"
And I set field "wtyp" to "Real"
And I set field "real" to "3,1415"
Then field "wertart" has value "R11.4"
Then field "wertuniversal" has value "3.1415"
And I save the current editor
And I close the current editor

Given I open an editor "Boolean" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "Datentypen"
And I set field "bezeichner" to "bool"
And I set field "wtyp" to "Bool"
And I set field "bool" to "TRUE"
Then field "wertart" has value "B"
Then field "wertuniversal" has value "(Yes)"
And I save the current editor
And I close the current editor

Given I open an editor "Objekt" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "Datentypen"
And I set field "bezeichner" to "Objekt"
And I set field "wtyp" to "Verweis"
And I set field "objekt" to "(154, 0, 0)"
Then field "wertart" has value "VPB88"
Then field "wertuniversal" is not empty in row 0
And I save the current editor
And I close the current editor

Given I open an editor "Kurztext" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "Datentypen"
And I set field "bezeichner" to "Kurztext"
And I set field "wtyp" to "Kurztext"
And I set field "kurztxt" to "45"
Then field "wertart" has value "P12:3"
Then field "wertuniversal" is not empty in row 0
And I save the current editor
And I close the current editor

Given I open an editor "Einzeilig" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "Datentypen"
And I set field "bezeichner" to "Einzeilig"
And I set field "wtyp" to "Text einzeilig"
And I set field "einzlgtxt" to "Rabarberkuchen"
Then field "wertart" has value "GL100"
Then field "wertuniversal" has value "Rabarberkuchen"
And I save the current editor
And I close the current editor

Given I open an editor "Mehrzeilig" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "Datentypen"
And I set field "bezeichner" to "Mehrzeilig"
And I set field "wtyp" to "Text mehrzeilig"
And I set field "mzlgtxt" to "Rabarber;Kuchen"
Then field "wertart" has value "T46"
Then field "wertuniversal" has value "Rabarber;Kuchen"
And I save the current editor
And I close the current editor

Given I open an editor "Freitext" from table "(ValueSet):(Value)" with command "NEW" for record ""
And I set field "wmbez" to "Datentypen"
And I set field "bezeichner" to "Freitext"
And I set field "wtyp" to "Freitext"
And I set field "ftext" to ""
And I save the current editor
And I close the current editor
