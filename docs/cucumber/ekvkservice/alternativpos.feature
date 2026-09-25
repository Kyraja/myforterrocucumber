# ***************************************************************************
#
#  Name      : alternativpos.feature
#  Datum     : 29.07.2014 / 05.06.2024
#  Vers.     : 1.0
#  Autor     : as
#  Verantwortlich : teampss
#
#  Funktion  : Cucumber Skript zum Referenztest ref_alternativpos.
#
# ***************************************************************************
@persistent
Feature: Test von Alternativpositionen in Ein- und Verkaufsvorgaengen
Background:
Given I set the fake date to "02.01.1995"

# ***************************************************************************
#  VERKAUF
# ***************************************************************************

Scenario: Angebot mit Materialzuschlaegen und Rabattpositionen

And I append text "############################################################################################" to output file "ALTERNATIVPOS.REF"
And I append text " VERKAUF " to output file "ALTERNATIVPOS.REF"
And I append text "############################################################################################" to output file "ALTERNATIVPOS.REF"

Given I open an editor "MATERIAL" from table "(Company):(MaterialSurchargeHeader)" with command "UPDATE" for record "MATERIAL"
And I create a new row at the end of the table
And I set field "matart" to "CU" in row 1
And I set field "matbasis" to "1" in row 1
And I set field "matnotiz" to "1,1" in row 1
And I save the current editor

Given I open an editor "V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "gewicht" to "50"
And I save the current editor

Given I open an editor "V12" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
	| such     | V12              |
	| namebspr | Verkaufsteil 12  |
	| matart   | CU               |
	| zmge     | 1                |
	| matvrel  | j                |
	| vrab     | V12              |
And I save the current editor

Given I open an editor "NEPO" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
	| such     | NEPO               |
	| namebspr | Neutrale Position  |
	| zptyp    | neutrale Position  |
And I save the current editor

Given I open an editor "1V12" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
	| nummer  | 1V12             |
	| such    | V12              |
	| typ     | Verkauf Rabatte  |
	| artpg   | V12              |
	| klpg    | 4                |
	| separat | ja               |
	| mgeab   | ja               |
And I create a new row at the end of the table
And I set field "mgrenze" to "5" in row 1
And I set field "mproz" to "-10" in row 1
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 2
And I set field "mproz" to "-20" in row 2
And I set field "mnrab" to "1" in row 2
And I save the current editor

Given I open an editor "1AN001" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
	| nummer | 1AN001  |
	| kunde  | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "V12" in row 2
And I set field "mge" to "10" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 6
And I set field "alternativpos" to "ja" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "V12" in row 7
And I set field "alternativpos" to "ja" in row 7
And I set field "mge" to "10" in row 7
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 11
And I create a new row at the end of the table
And I set field "artikel" to "NEPO" in row 12
And I set field "pwert" to "100" in row 12
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 13
And I set field "alternativpos" to "ja" in row 13
And I create a new row at the end of the table
And I set field "artikel" to "NEPO" in row 14
And I set field "pwert" to "100" in row 14
And I set field "alternativpos" to "ja" in row 14
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 15
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I set field "alternativpos" to "ja" in row 1
And I set field "alternativpos" to "ja" in row 2
And I set field "alternativpos" to "nein" in row 6
And I set field "alternativpos" to "nein" in row 7
And I set field "alternativpos" to "ja" in row 11
And I set field "alternativpos" to "ja" in row 12
And I set field "alternativpos" to "nein" in row 13
And I set field "alternativpos" to "nein" in row 14
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
Then setting field "alternativpos" to "nein" in row 3 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 4 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 5 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 8 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 9 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 10 throws the exception "203"
And I save the current editor

Scenario: Angebot kopieren

Given I open an editor "1AN001K" from table "(Sales):(Quotation)" with command "COPY" for record "1AN001"
And I set field "nummer" to "1AN001K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Angebot freigeben

Given I open an editor "1AU001" from table "(Sales):(Quotation)" with command "RELEASE" for record "1AN001"
And I set field "nummer" to "1AU001"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I set field "alternativpos" to "nein" in row 1
And I set field "alternativpos" to "nein" in row 2
And I set field "alternativpos" to "ja" in row 6
And I set field "alternativpos" to "ja" in row 7
And I set field "alternativpos" to "nein" in row 11
And I set field "alternativpos" to "nein" in row 12
And I set field "alternativpos" to "ja" in row 13
And I set field "alternativpos" to "ja" in row 14
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
Then setting field "alternativpos" to "nein" in row 3 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 4 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 5 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 8 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 9 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 10 throws the exception "203"
And I save the current editor

Scenario: 1. Teillieferung und Lieferschein buchen

Given I open an editor "1LS001" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU001"
And I set fields
	| nummer | 1LS001  |
	| ueb    | ja      |
And I set field "mge" to "5" in row 2
And I press button "offueb" in row 5
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: 2. Teillieferung und Lieferschein buchen

Given I open an editor "1LS002" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU001"
And I set fields
	| nummer | 1LS002  |
	| ueb    | ja      |
And I set field "mge" to "5" in row 1
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Alternativpositionen im Auftrag wandeln

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU001"
And I set field "alternativpos" to "nein" in row 6
And I set field "alternativpos" to "nein" in row 7
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Lieferung und Lieferschein buchen

Given I open an editor "1LS003" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU001"
And I set fields
	| nummer | 1LS003  |
	| ueb    | j       |
And I press button "offueb" in row 2
And I press button "offueb" in row 5
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Alternativpositionen im Auftrag wandeln

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU001"
And I set field "alternativpos" to "nein" in row 13
And I set field "alternativpos" to "nein" in row 14
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Auftrag berechnen und Rechnung buchen

Given I open an editor "1RE001" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "1AU001"
And I set fields
	| nummer | 1RE001  |
	| budat  | .       |
	| tterm  | .       |
	| ueb    | j       |
And I press button "offueb" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "VIEW" for record "+1AU001"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Lieferscheine berechnen und Rechnung buchen

Given I open an editor "1RE002" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1LS001"
And I set fields
	| nummer | 1RE002  |
	| tterm  | .       |
	| ueb    | j       |
And I set field "beleg" to "1LS002"
And I set field "beleg" to "1LS003"
And I delete row at position 26
And I delete row at position 25
And I delete row at position 24
And I delete row at position 17
And I delete row at position 16
And I delete row at position 15
And I delete row at position 10
And I delete row at position 9
And I delete row at position 8
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1RE002" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE002"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Webauftrag mit Umlagen und Alternativpositionsgruppen + Kopie + Freigabe

Given I open an editor "V13" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
	| such     | V13              |
	| namebspr | Verkaufsteil 13  |
	| vrab     | V13              |
And I save the current editor

Given I open an editor "UMLAGE" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
	| such     | UMLAGE             |
	| namebspr | Umlage             |
	| zptyp    | neutrale Position  |
	| umlage   | ja                 |
And I save the current editor

Given I open an editor "1WE001" from table "(Sales):(WebOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1WE001  |
	| kunde  | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "V13" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "UMLAGE" in row 2
And I set field "pwert" to "60" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "V13" in row 3
And I set field "alternativpos" to "ja" in row 3
And I set field "alternativgrp" to "B" in row 3
And I set field "mge" to "10" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "ZS." in row 4
And I create a new row at the end of the table
And I set field "artikel" to "V13" in row 5
And I set field "mge" to "10" in row 5
And I create a new row at the end of the table
And I set field "artikel" to "V13" in row 6
And I set field "alternativpos" to "ja" in row 6
And I set field "alternativgrp" to "A" in row 6
And I set field "mge" to "10" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "V13" in row 7
And I set field "alternativpos" to "ja" in row 7
And I set field "alternativgrp" to "B" in row 7
And I set field "mge" to "10" in row 7
And I create a new row at the end of the table
And I set field "artikel" to "UMLAGE" in row 8
And I set field "alternativpos" to "ja" in row 8
And I set field "alternativgrp" to "A" in row 8
And I set field "pwert" to "80" in row 8
And I create a new row at the end of the table
And I set field "artikel" to "V13" in row 9
And I set field "alternativpos" to "ja" in row 9
And I set field "alternativgrp" to "B" in row 9
And I set field "mge" to "10" in row 9
And I create a new row at the end of the table
And I set field "artikel" to "ZS." in row 10
And I set field "alternativpos" to "ja" in row 10
And I set field "alternativgrp" to "B" in row 10
And I create a new row at the end of the table
And I set field "artikel" to "UMLAGE" in row 11
And I set field "alternativpos" to "ja" in row 11
And I set field "alternativgrp" to "B" in row 11
And I set field "pwert" to "100" in row 11
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 12
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1WE001K" from table "(Sales):(WebOrder)" with command "COPY" for record "1WE001"
And I set field "nummer" to "1WE001K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU004" from table "(Sales):(WebOrder)" with command "RELEASE" for record "1WE001"
And I set field "nummer" to "1AU004"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS005" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU004"
And I set field "nummer" to "1LS005"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Chance mit Mindestbestellwertposition + Kopie + Freigabe

Given I open an editor "V14" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
	| such     | V14              |
	| namebspr | Verkaufsteil 14  |
	| vrab     | V14              |
And I save the current editor

Given I open an editor "MINBW" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
	| nummer   | 1MINBW                      |
	| such     | MINBW                       |
	| namebspr | Mindestbestellwert          |
	| zptyp    | Mindestbestellwertposition  |
And I save the current editor

Given I open an editor "1CH001" from table "(Sales):(Opportunity)" with command "NEW" for record ""
And I set fields
	| nummer | 1CH001  |
	| kunde  | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "V14" in row 1
And I set field "mge" to "15" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "MINBW" in row 2
And I set field "preis" to "400" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "V14" in row 3
And I set field "alternativpos" to "ja" in row 3
And I set field "alternativgrp" to "B" in row 3
And I set field "mge" to "10" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "MINBW" in row 4
And I set field "preis" to "300" in row 4
And I set field "alternativpos" to "ja" in row 4
And I create a new row at the end of the table
And I set field "artikel" to "MINBW" in row 5
And I set field "preis" to "400" in row 5
And I set field "alternativgrp" to "B" in row 5
And I set field "alternativpos" to "ja" in row 5
And I create a new row at the end of the table
And I set field "artikel" to "V14" in row 6
And I set field "mge" to "1" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "V14" in row 7
And I set field "mge" to "2" in row 7
And I set field "alternativgrp" to "A" in row 7
And I set field "alternativpos" to "ja" in row 7
And I create a new row at the end of the table
And I set field "artikel" to "V14" in row 8
And I set field "mge" to "3" in row 8
And I create a new row at the end of the table
And I set field "artikel" to "ZS." in row 9
And I set field "alternativgrp" to "A" in row 9
And I set field "alternativpos" to "ja" in row 9
And I create a new row at the end of the table
And I set field "artikel" to "MINBW" in row 10
And I set field "preis" to "100" in row 10
And I set field "alternativgrp" to "A" in row 10
And I set field "alternativpos" to "ja" in row 10
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 11
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1CH001" from table "(Sales):(Opportunity)" with command "COPY" for record "1CH001"
And I set field "nummer" to "1CH001K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AN004" from table "(Sales):(Opportunity)" with command "RELEASE" for record "1CH001"
And I set field "nummer" to "1AN004"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Angebot mit Gruppenrabatt + Kopie + Freigabe

Given I open an editor "V15" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
	| such     | V15              |
	| namebspr | Verkaufsteil 15  |
	| vrab     | V15_16           |
And I save the current editor

Given I open an editor "V16" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
	| such     | V16              |
	| namebspr | Verkaufsteil 16  |
	| vrab     | V15_16           |
And I save the current editor

Given I open an editor "1V15_16" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
	| nummer    | 1V15_16          |
	| such      | V15_16           |
	| typ       | Verkauf Rabatte  |
	| artpg     | V15_16           |
	| gruppenpr | ja               |
	| klpg      | 4                |
	| mgeab     | ja               |
And I create a new row at the end of the table
And I set field "mgrenze" to "5" in row 1
And I set field "mproz" to "-10" in row 1
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 2
And I set field "mproz" to "-20" in row 2
And I create a new row at the end of the table
And I set field "mgrenze" to "15" in row 3
And I set field "mproz" to "-30" in row 3
And I save the current editor

Given I open an editor "1AN002" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
	| nummer | 1AN002  |
	| kunde  | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "V15" in row 1
And I set field "mge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "V16" in row 2
And I set field "mge" to "5" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "V15" in row 3
And I set field "alternativpos" to "ja" in row 3
And I set field "alternativgrp" to "A" in row 3
And I set field "mge" to "5" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "V16" in row 4
And I set field "alternativpos" to "ja" in row 4
And I set field "alternativgrp" to "A" in row 4
And I set field "mge" to "5" in row 4
And I create a new row at the end of the table
And I set field "artikel" to "V15" in row 5
And I set field "alternativpos" to "ja" in row 5
And I set field "alternativgrp" to "B" in row 5
And I set field "mge" to "5" in row 5
And I create a new row at the end of the table
And I set field "artikel" to "V16" in row 6
And I set field "alternativpos" to "ja" in row 6
And I set field "mge" to "5" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 7
And I press button "rabdr"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AN002K" from table "(Sales):(Quotation)" with command "COPY" for record "1AN002"
And I set field "nummer" to "1AN002K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU005" from table "(Sales):(Quotation)" with command "RELEASE" for record "1AN002"
And I set field "nummer" to "1AU005"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS006" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU005"
And I set field "nummer" to "1LS006"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Angebot mit Kettenrabatt + Kopie + Freigabe

Given I open an editor "V17" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
	| such     | V17              |
	| namebspr | Verkaufsteil 17  |
	| vrab     | V17              |
And I save the current editor

Given I open an editor "1V17_1" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
	| nummer  | 1V17_1           |
	| such    | V17_1            |
	| typ     | Verkauf Rabatte  |
	| artpg   | V17              |
	| klpg    | 4                |
	| kettrab | ja               |
	| rfolge  | 1                |
	| separat | ja               |
	| mgeab   | ja               |
And I create a new row at the end of the table
And I set field "mgrenze" to "5" in row 1
And I set field "mproz" to "-10" in row 1
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 2
And I set field "mproz" to "-20" in row 2
And I create a new row at the end of the table
And I set field "mgrenze" to "15" in row 3
And I set field "mproz" to "-30" in row 3
And I save the current editor

Given I open an editor "1V17_2" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
	| nummer  | 1V17_2           |
	| such    | V17_2            |
	| typ     | Verkauf Rabatte  |
	| artpg   | V17              |
	| klpg    | 4                |
	| kettrab | ja               |
	| rfolge  | 2                |
	| separat | ja               |
	| mgeab   | ja               |
And I create a new row at the end of the table
And I set field "mgrenze" to "5" in row 1
And I set field "mproz" to "-2" in row 1
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 2
And I set field "mproz" to "-4" in row 2
And I create a new row at the end of the table
And I set field "mgrenze" to "15" in row 3
And I set field "mproz" to "-6" in row 3
And I save the current editor

Given I open an editor "1AN003" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
	| nummer | 1AN003  |
	| kunde  | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "V17" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "V17" in row 4
And I set field "alternativpos" to "ja" in row 4
And I set field "mge" to "20" in row 4
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 7
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AN003K" from table "(Sales):(Quotation)" with command "COPY" for record "1AN003"
And I set field "nummer" to "1AN003K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU006" from table "(Sales):(Quotation)" with command "RELEASE" for record "1AN003"
And I set field "nummer" to "1AU006"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS007" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU006"
And I set field "nummer" to "1LS007"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Auftrag mit Ausstattungen

Given I open an editor "E2A" from table "(Part):(Product)" with command "NEW" for record "E2"
And I set fields
	| such     | E2A          |
	| namebspr | E2 Variante  |
And I save the current editor

Given I open an editor "E3A" from table "(Part):(Product)" with command "NEW" for record "E3"
And I set fields
	| such     | E3A          |
	| namebspr | E3 Variante  |
And I save the current editor

Given I open an editor "V1VAR" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
	| such     | V1VAR                    |
	| namebspr | Verkaufsteil 1 Variante  |
And I set field "var" to "Normal" in row 1
And I create a new row at position 2
And I set field "elex" to "E2A" in row 2
And I set field "elanzahl" to "2" in row 2
And I set field "var" to "Wahlweise" in row 2
And I create a new row at position 3
And I set field "elex" to "E3" in row 3
And I set field "elanzahl" to "4" in row 3
And I set field "var" to "Normal" in row 3
And I create a new row at position 4
And I set field "elex" to "E3A" in row 4
And I set field "elanzahl" to "4" in row 4
And I set field "var" to "Wahlweise" in row 4
And I save the current editor

Given I open an editor "1AU002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU002  |
	| kunde  | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "V1VAR" in row 1
And I set field "mge" to "10" in row 1
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I press button "absteig" to open a subeditor for "fliste" in row 1
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor
And I switch the current editor to editor "1AU002"
And I create a new row at the end of the table
And I set field "pnum" to "A" in row 2
And I set field "artikel" to "E2A" in row 2
And I set field "alternativpos" to "ja" in row 2
And I create a new row at the end of the table
And I set field "pnum" to "A" in row 3
And I set field "artikel" to "E3A" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "V1VAR" in row 4
And I set field "mge" to "10" in row 4
And I set field "alternativpos" to "ja" in row 4
And I create a new row at the end of the table
And I set field "pnum" to "A" in row 5
And I set field "artikel" to "E2A" in row 5
And I set field "alternativpos" to "ja" in row 5
And I create a new row at the end of the table
And I set field "pnum" to "A" in row 6
And I set field "artikel" to "E3A" in row 6
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I press button "absteig" to open a subeditor for "fliste" in row 1
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "fliste" in row 4
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "1AU002" from table "(Sales):(SalesOrder)" with command "VIEW" for record "1AU002"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I press button "absteig" to open a subeditor for "fliste" in row 1
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current subeditor to switch back to the parent editor
And I press button "absteig" to open a subeditor for "fliste" in row 4
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Scenario: Ein- und ausschalten des Kennzeichens Alternativposition + Plausibilitaetspruefungen

Given I open an editor "V18" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
	| such     | V18              |
	| namebspr | Verkaufsteil 18  |
	| vrab     | V18              |
And I save the current editor

Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU003  |
	| kunde  | 1       |
And I append rows
	| artikel | mge         | alternativpos | einplan     | lirelev     |
	| V18     | 10          | ja            | !dontChange | !dontChange |
	| V18     | 10          | nein          | !dontChange | !dontChange |
	| V18     | 10          | nein          | nein        | !dontChange |
	| V18     | 10          | nein          | nein        | nein        |
	| ZS.     | !dontChange | ja            | !dontChange | !dontChange |
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU003"
And I set field "alternativpos" to "nein" in row 1
Then setting field "alternativpos" to "ja" in row 2 throws the exception "8636"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU003"
And I set fields
	| nummer | 1LS004  |
	| fakt   | nein    |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "1AU003"
And I set fields
	| nummer | 1RE003  |
	| budat  | .       |
	| tterm  | .       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I set field "mge" to "5" in row 3
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU003"
Then setting field "alternativpos" to "ja" in row 3 throws the exception "8637"
Then setting field "alternativpos" to "ja" in row 4 throws the exception "203"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS004" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS004"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1RE003" from table "(Sales):(Invoice)" with command "UPDATE" for record "1RE003"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I set field "mge" to "10" in row 3
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU003"
Then setting field "alternativpos" to "ja" in row 3 throws the exception "8637"
Then setting field "alternativpos" to "ja" in row 4 throws the exception "203"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS008" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU003"
And I set fields
	| nummer | 1LS008  |
	| ueb    | ja      |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU003"
Then setting field "alternativpos" to "ja" in row 3 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 4 throws the exception "203"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I delete row at position 1
And I delete row at position 4
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1AU003" from table "(Sales):(SalesOrder)" with command "VIEW" for record "+1AU003"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

# ***************************************************************************
#  EINKAUF
# ***************************************************************************

Scenario: Bestellung mit Materialzuschlaegen und Rabattpositionen

And I append text "" to output file "cucumber/refs/alternativpos.out"
And I append text "############################################################################################" to output file "cucumber/refs/alternativpos.out"
And I append text " EINKAUF " to output file "cucumber/refs/alternativpos.out"
And I append text "############################################################################################" to output file "cucumber/refs/alternativpos.out"

Given I open an editor "E22" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set fields
	| such     | E22              |
	| namebspr | Einkaufsteil 22  |
	| matart   | CU               |
	| zmge     | 1                |
	| materel  | j                |
	| erab     | E22              |
	| epr      | 25               |
And I save the current editor

Given I open an editor "1E22" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
	| nummer  | 1E22             |
	| such    | E22              |
	| typ     | Einkauf Rabatte  |
	| artpg   | E22              |
	| klpg    | 1                |
	| separat | ja               |
	| mgeab   | ja               |
And I create a new row at the end of the table
And I set field "mgrenze" to "5" in row 1
And I set field "mproz" to "-10" in row 1
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 2
And I set field "mproz" to "-20" in row 2
And I set field "mnrab" to "1" in row 2
And I save the current editor

Scenario: Anfrage anlegen

Given I open an editor "1AN001" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
	| nummer | 1AN001  |
	| lief   | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I set field "alternativpos" to "ja" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E22" in row 2
And I set field "mge" to "10" in row 2
And I set field "alternativpos" to "ja" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "E22" in row 4
And I set field "mge" to "10" in row 4
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 5
And I set field "alternativpos" to "ja" in row 5
And I create a new row at the end of the table
And I set field "artikel" to "NEPO" in row 6
And I set field "alternativpos" to "ja" in row 6
And I set field "pwert" to "100" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 7
And I create a new row at the end of the table
And I set field "artikel" to "NEPO" in row 8
And I set field "pwert" to "100" in row 8
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 9
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Anfrage kopieren

Given I open an editor "1AN001K" from table "(Purchasing):(Request)" with command "COPY" for record "1AN001"
And I set field "nummer" to "1AN001K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Anfrage freigeben

Given I open an editor "1BE001" from table "(Purchasing):(Request)" with command "RELEASE" for record "1AN001"
And I set field "nummer" to "1BE001"
And I set field "fixpwert" to "nein" in row 2
And I set field "fixpwert" to "nein" in row 7
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
Then setting field "alternativpos" to "nein" in row 3 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 4 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 5 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 8 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 9 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 10 throws the exception "203"
And I set field "alternativpos" to "nein" in row 1
And I set field "alternativpos" to "nein" in row 2
And I set field "alternativpos" to "ja" in row 6
And I set field "alternativpos" to "ja" in row 7
And I set field "alternativpos" to "nein" in row 11
And I set field "alternativpos" to "nein" in row 12
And I set field "alternativpos" to "ja" in row 13
And I set field "alternativpos" to "ja" in row 14
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Bestellung kopieren

Given I open an editor "1BE001K" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record "1BE001"
And I set field "nummer" to "1BE001K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: 1. Teillieferung und Lieferschein buchen

Given I open an editor "1LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE001"
And I set fields
	| nummer | 1LS001  |
	| ueb    | ja      |
	| vom    | .       |
And I set field "mge" to "5" in row 2
And I press button "offueb" in row 5
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: 2. Teillieferung und Lieferschein buchen

Given I open an editor "1LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE001"
And I set fields
	| nummer | 1LS002  |
	| ueb    | ja      |
	| vom    | .       |
And I set field "mge" to "5" in row 1
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Alternativpositionen in der Bestellung wandeln

Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE001"
And I set field "alternativpos" to "nein" in row 6
And I set field "alternativpos" to "nein" in row 7
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Lieferung und Lieferschein buchen

Given I open an editor "1LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE001"
And I set fields
	| nummer | 1LS003  |
	| ueb    | j       |
	| vom    | .       |
And I press button "offueb" in row 2
And I press button "offueb" in row 5
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Alternativpositionen in der Bestellung wandeln

Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE001"
And I set field "alternativpos" to "nein" in row 13
And I set field "alternativpos" to "nein" in row 14
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Bestellung berechnen und Rechnung buchen

Given I open an editor "1RE001" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE001"
And I set fields
	| nummer | 1RE001  |
	| budat  | .       |
	| vom    | .       |
	| ueb    | j       |
And I press button "offueb" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+1BE001"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Lieferscheine berechnen und Rechnung buchen

Given I open an editor "1RE002" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "1LS001"
And I set fields
	| nummer | 1RE002  |
	| budat  | .       |
	| vom    | .       |
	| ueb    | j       |
And I set field "beleg" to "1LS002"
And I set field "beleg" to "1LS003"
And I delete row at position 26
And I delete row at position 25
And I delete row at position 24
And I delete row at position 17
And I delete row at position 16
And I delete row at position 15
And I delete row at position 10
And I delete row at position 9
And I delete row at position 8
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1RE002" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE002"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Bestellung mit Umlagen und Alternativpositionsgruppen + Kopie + Lieferung

Given I open an editor "E23" from table "(Part):(Product)" with command "COPY" for record "E22"
And I set fields
	| such     | E23              |
	| namebspr | Einkaufsteil 23  |
	| erab     | E23              |
	| matart   |                  |
And I save the current editor

Given I open an editor "1BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE002  |
	| lief   | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "E23" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "UMLAGE" in row 2
And I set field "pwert" to "60" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "E23" in row 3
And I set field "mge" to "10" in row 3
And I set field "alternativpos" to "ja" in row 3
And I set field "alternativgrp" to "B" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "ZS." in row 4
And I create a new row at the end of the table
And I set field "artikel" to "E23" in row 5
And I set field "mge" to "10" in row 5
And I create a new row at the end of the table
And I set field "artikel" to "E23" in row 6
And I set field "mge" to "10" in row 6
And I set field "alternativpos" to "ja" in row 6
And I set field "alternativgrp" to "A" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "E23" in row 7
And I set field "mge" to "10" in row 7
And I set field "alternativpos" to "ja" in row 7
And I set field "alternativgrp" to "B" in row 7
And I create a new row at the end of the table
And I set field "artikel" to "UMLAGE" in row 8
And I set field "pwert" to "80" in row 8
And I set field "alternativpos" to "ja" in row 8
And I set field "alternativgrp" to "A" in row 8
And I create a new row at the end of the table
And I set field "artikel" to "E23" in row 9
And I set field "mge" to "10" in row 9
And I set field "alternativpos" to "ja" in row 9
And I set field "alternativgrp" to "B" in row 9
And I create a new row at the end of the table
And I set field "artikel" to "ZS." in row 10
And I set field "alternativpos" to "ja" in row 10
And I set field "alternativgrp" to "B" in row 10
And I create a new row at the end of the table
And I set field "artikel" to "UMLAGE" in row 11
And I set field "pwert" to "100" in row 11
And I set field "alternativpos" to "ja" in row 11
And I set field "alternativgrp" to "B" in row 11
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 12
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE002K" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record "1BE002"
And I set field "nummer" to "1BE002K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS004" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE002"
And I set field "nummer" to "1LS004"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Bestellung mit Mindestbestellwertposition + Kopie + Lieferung

Given I open an editor "E24" from table "(Part):(Product)" with command "COPY" for record "E22"
And I set fields
	| such     | E24              |
	| namebspr | Einkaufsteil 24  |
	| erab     | E24              |
	| matart   |                  |
And I save the current editor

Given I open an editor "1BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE003  |
	| lief   | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "E24" in row 1
And I set field "mge" to "15" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "MINBW" in row 2
And I set field "preis" to "400" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "E24" in row 3
And I set field "mge" to "10" in row 3
And I set field "alternativpos" to "ja" in row 3
And I set field "alternativgrp" to "B" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "MINBW" in row 4
And I set field "preis" to "300" in row 4
And I set field "alternativpos" to "ja" in row 4
And I create a new row at the end of the table
And I set field "artikel" to "MINBW" in row 5
And I set field "preis" to "400" in row 5
And I set field "alternativgrp" to "B" in row 5
And I set field "alternativpos" to "ja" in row 5
And I create a new row at the end of the table
And I set field "artikel" to "E24" in row 6
And I set field "mge" to "1" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "E24" in row 7
And I set field "mge" to "2" in row 7
And I set field "alternativgrp" to "A" in row 7
And I set field "alternativpos" to "ja" in row 7
And I create a new row at the end of the table
And I set field "artikel" to "E24" in row 8
And I set field "mge" to "3" in row 8
And I create a new row at the end of the table
And I set field "artikel" to "ZS." in row 9
And I set field "alternativgrp" to "A" in row 9
And I set field "alternativpos" to "ja" in row 9
And I create a new row at the end of the table
And I set field "artikel" to "MINBW" in row 10
And I set field "preis" to "100" in row 10
And I set field "alternativgrp" to "A" in row 10
And I set field "alternativpos" to "ja" in row 10
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 11
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE003K" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record "1BE003"
And I set field "nummer" to "1BE003K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS005" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE003"
And I set field "nummer" to "1LS005"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Bestellung mit Gruppenrabatt + Kopie + Lieferung

Given I open an editor "E25" from table "(Part):(Product)" with command "COPY" for record "E22"
And I set fields
	| such     | E25              |
	| namebspr | Einkaufsteil 25  |
	| erab     | E25_26           |
	| matart   |                  |
And I save the current editor

Given I open an editor "E26" from table "(Part):(Product)" with command "COPY" for record "E22"
And I set fields
	| such     | E26              |
	| namebspr | Einkaufsteil 26  |
	| erab     | E25_26           |
	| matart   |                  |
And I save the current editor

Given I open an editor "1E25_26" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
	| nummer    | 1E25_26          |
	| such      | E25_26           |
	| typ       | Einkauf Rabatte  |
	| artpg     | E25_26           |
	| gruppenpr | ja               |
	| klpg      | 1                |
	| mgeab     | ja               |
And I create a new row at the end of the table
And I set field "mgrenze" to "5" in row 1
And I set field "mproz" to "-10" in row 1
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 2
And I set field "mproz" to "-20" in row 2
And I create a new row at the end of the table
And I set field "mgrenze" to "15" in row 3
And I set field "mproz" to "-30" in row 3
And I save the current editor

Given I open an editor "1BE004" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE004  |
	| lief   | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "E25" in row 1
And I set field "mge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E26" in row 2
And I set field "mge" to "5" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "E25" in row 3
And I set field "mge" to "5" in row 3
And I set field "alternativpos" to "ja" in row 3
And I set field "alternativgrp" to "A" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "E26" in row 4
And I set field "mge" to "5" in row 4
And I set field "alternativpos" to "ja" in row 4
And I set field "alternativgrp" to "A" in row 4
And I create a new row at the end of the table
And I set field "artikel" to "E25" in row 5
And I set field "mge" to "5" in row 5
And I set field "alternativpos" to "ja" in row 5
And I set field "alternativgrp" to "B" in row 5
And I create a new row at the end of the table
And I set field "artikel" to "E26" in row 6
And I set field "mge" to "5" in row 6
And I set field "alternativpos" to "ja" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 7
And I press button "rabdr"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE004K" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record "1BE004"
And I set field "nummer" to "1BE004K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS006" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE004"
And I set field "nummer" to "1LS006"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Bestellung mit Kettenrabatt + Kopie + Lieferung

Given I open an editor "E27" from table "(Part):(Product)" with command "COPY" for record "E22"
And I set fields
	| such     | E27              |
	| namebspr | Einkaufsteil 27  |
	| erab     | E27              |
	| matart   |                  |
And I save the current editor

Given I open an editor "1E27_1" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
	| nummer  | 1E27_1           |
	| such    | E27_1            |
	| typ     | Einkauf Rabatte  |
	| artpg   | E27              |
	| klpg    | 1                |
	| kettrab | ja               |
	| rfolge  | 1                |
	| separat | ja               |
	| mgeab   | ja               |
And I create a new row at the end of the table
And I set field "mgrenze" to "5" in row 1
And I set field "mproz" to "-10" in row 1
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 2
And I set field "mproz" to "-20" in row 2
And I create a new row at the end of the table
And I set field "mgrenze" to "15" in row 3
And I set field "mproz" to "-30" in row 3
And I save the current editor

Given I open an editor "1E27_2" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
	| nummer  | 1E27_2           |
	| such    | E27_2            |
	| typ     | Einkauf Rabatte  |
	| artpg   | E27              |
	| klpg    | 1                |
	| kettrab | ja               |
	| rfolge  | 2                |
	| separat | ja               |
	| mgeab   | ja               |
And I create a new row at the end of the table
And I set field "mgrenze" to "5" in row 1
And I set field "mproz" to "-10" in row 1
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 2
And I set field "mproz" to "-20" in row 2
And I create a new row at the end of the table
And I set field "mgrenze" to "15" in row 3
And I set field "mproz" to "-30" in row 3
And I save the current editor

Given I open an editor "1BE005" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE005  |
	| lief   | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "E27" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E27" in row 4
And I set field "mge" to "20" in row 4
And I set field "alternativpos" to "ja" in row 4
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 7
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE005K" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record "1BE005"
And I set field "nummer" to "1BE005K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS007" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE005"
And I set field "nummer" to "1LS007"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Bestellung mit Beistellteilelisten

Given I open an editor "E28" from table "(Part):(Product)" with command "COPY" for record "E22"
And I set fields
	| such     | E28              |
	| namebspr | Einkaufsteil 28  |
	| erab     | E28              |
	| matart   |                  |
And I save the current editor

Given I open an editor "1BE007" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE007  |
	| lief   | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "E28" in row 1
And I set field "mge" to "10" in row 1
And I press button "absteig" to open a subeditor for "fliste" in row 1
And I create a new row at the end of the table
And I set field "elex" to "E3" in row 1
And I set field "elanzahl" to "1" in row 1
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor
And I switch the current editor to editor "1BE007"
And I create a new row at the end of the table
And I set field "artikel" to "E28" in row 2
And I set field "mge" to "10" in row 2
And I set field "alternativpos" to "ja" in row 2
And I press button "absteig" to open a subeditor for "fliste" in row 2
And I create a new row at the end of the table
And I set field "elex" to "E3" in row 1
And I set field "elanzahl" to "2" in row 1
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor
And I switch the current editor to editor "1BE007"
And I save the current editor

Given I open an editor "1BE007" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1BE007"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I press button "absteig" to open a subeditor for "fliste" in row 1
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor
And I switch the current editor to editor "1BE007"
And I press button "absteig" to open a subeditor for "fliste" in row 2
Then I fill template "ev_fliste_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor
And I switch the current editor to editor "1BE007"
And I close the current editor

Scenario: Ein- und ausschalten des Kennzeichens Alternativposition + Plausibilitaetspruefungen

Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1BE006  |
	| lief   | 1       |
And I append rows
	| artikel | mge         | alternativpos | rerelev     | lirelev     |
	| E28     | 10          | ja            | !dontChange | !dontChange |
	| E28     | 10          | nein          | !dontChange | !dontChange |
	| E28     | 10          | nein          | nein        | !dontChange |
	| E28     | 10          | nein          | !dontChange | nein        |
	| ZS.     | !dontChange | ja            | !dontChange | !dontChange |
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE006"
And I set field "alternativpos" to "nein" in row 1
Then setting field "alternativpos" to "ja" in row 2 throws the exception "8636"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE006"
And I set field "alternativpos" to "ja" in row 1
Then setting field "alternativpos" to "nein" in row 2 throws the exception "8636"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE006"
And I set fields
	| nummer | 1LS008  |
	| fakt   | nein    |
	| vom    | .       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE006"
And I set fields
	| nummer | 1RE003  |
	| budat  | .       |
	| vom    | .       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1LS008" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS008"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1RE003" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "1RE003"
And I set field "ueb" to "ja"
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE006"
Then setting field "alternativpos" to "ja" in row 3 throws the exception "8636"
Then setting field "alternativpos" to "ja" in row 4 throws the exception "203"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1LS009" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE006"
And I set fields
	| nummer | 1LS009  |
	| ueb    | ja      |
	| vom    | .       |
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE006"
Then setting field "alternativpos" to "ja" in row 3 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 4 throws the exception "203"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I delete row at position 1
And I delete row at position 4
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1BE006" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+1BE006"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

# ***************************************************************************
#  SERVICE
# ***************************************************************************

Scenario: Serviceangebot mit Materialzuschlaegen und Rabattpositionen

And I append text "" to output file "cucumber/refs/alternativpos.out"
And I append text "############################################################################################" to output file "cucumber/refs/alternativpos.out"
And I append text " SERVICE " to output file "cucumber/refs/alternativpos.out"
And I append text "############################################################################################" to output file "cucumber/refs/alternativpos.out"

Given I open an editor "1SA001" from table "(Sales):(ServiceQuotation)" with command "NEW" for record ""
And I set fields
	| nummer | 1SA001  |
	| kunde  | 1       |
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "V12" in row 2
And I set field "mge" to "10" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 6
And I set field "alternativpos" to "ja" in row 6
And I create a new row at the end of the table
And I set field "artikel" to "V12" in row 7
And I set field "alternativpos" to "ja" in row 7
And I set field "mge" to "10" in row 7
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 11
And I create a new row at the end of the table
And I set field "artikel" to "NEPO" in row 12
And I set field "pwert" to "100" in row 12
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 13
And I set field "alternativpos" to "ja" in row 13
And I create a new row at the end of the table
And I set field "artikel" to "NEPO" in row 14
And I set field "pwert" to "100" in row 14
And I set field "alternativpos" to "ja" in row 14
And I create a new row at the end of the table
And I set field "artikel" to "NS." in row 15
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I set field "alternativpos" to "ja" in row 1
And I set field "alternativpos" to "ja" in row 2
And I set field "alternativpos" to "nein" in row 6
And I set field "alternativpos" to "nein" in row 7
And I set field "alternativpos" to "ja" in row 11
And I set field "alternativpos" to "ja" in row 12
And I set field "alternativpos" to "nein" in row 13
And I set field "alternativpos" to "nein" in row 14
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
Then setting field "alternativpos" to "nein" in row 3 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 4 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 5 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 8 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 9 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 10 throws the exception "203"
And I save the current editor

Scenario: Serviceangebot kopieren

Given I open an editor "1SA001K" from table "(Sales):(ServiceQuotation)" with command "COPY" for record "1SA001"
And I set field "nummer" to "1SA001K"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Serviceangebot freigeben

Given I open an editor "1SA001" from table "(Sales):(ServiceQuotation)" with command "RELEASE" for record "1SA001"
And I set field "nummer" to "1SU001"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I set field "alternativpos" to "nein" in row 1
And I set field "alternativpos" to "nein" in row 2
And I set field "alternativpos" to "ja" in row 6
And I set field "alternativpos" to "ja" in row 7
And I set field "alternativpos" to "nein" in row 11
And I set field "alternativpos" to "nein" in row 12
And I set field "alternativpos" to "ja" in row 13
And I set field "alternativpos" to "ja" in row 14
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
Then setting field "alternativpos" to "nein" in row 3 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 4 throws the exception "203"
Then setting field "alternativpos" to "nein" in row 5 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 8 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 9 throws the exception "203"
Then setting field "alternativpos" to "ja" in row 10 throws the exception "203"
And I save the current editor

Scenario: 1. Teillieferung und Lieferschein buchen

Given I open an editor "1LS100" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "1SU001"
And I set fields
	| nummer | 1LS100  |
	| ueb    | ja      |
And I set field "mge" to "5" in row 2
And I press button "offueb" in row 5
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: 2. Teillieferung und Lieferschein buchen

Given I open an editor "1LS101" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "1SU001"
And I set fields
	| nummer | 1LS101  |
	| ueb    | ja      |
And I set field "mge" to "5" in row 1
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Alternativpositionen im Serviceauftrag wandeln

Given I open an editor "1SU001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "1SU001"
And I set field "alternativpos" to "nein" in row 6
And I set field "alternativpos" to "nein" in row 7
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Lieferung und Lieferschein buchen

Given I open an editor "1LS102" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "1SU001"
And I set fields
	| nummer | 1LS102  |
	| ueb    | j       |
And I press button "offueb" in row 2
And I press button "offueb" in row 5
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Alternativpositionen im Serviceauftrag wandeln

Given I open an editor "1SU001" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record "1SU001"
And I set field "alternativpos" to "nein" in row 13
And I set field "alternativpos" to "nein" in row 14
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Serviceauftrag berechnen und Rechnung buchen

Given I open an editor "1RE100" from table "(Sales):(ServiceOrder)" with command "INVOICE" for record "1SU001"
And I set fields
	| nummer | 1RE100  |
	| budat  | .       |
	| tterm  | .       |
	| ueb    | j       |
And I press button "offueb" in row 2
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Given I open an editor "1SU001" from table "(Sales):(ServiceOrder)" with command "VIEW" for record "+1SU001"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor

Scenario: Lieferscheine berechnen und Rechnung buchen

Given I open an editor "1RE101" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1LS100"
And I set fields
	| nummer | 1RE101  |
	| tterm  | .       |
	| ueb    | j       |
And I set field "beleg" to "1LS101"
And I set field "beleg" to "1LS102"
And I delete row at position 26
And I delete row at position 25
And I delete row at position 24
And I delete row at position 17
And I delete row at position 16
And I delete row at position 15
And I delete row at position 10
And I delete row at position 9
And I delete row at position 8
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1RE101" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I close the current editor

Scenario: Korrektur - Endlosschliefe bei Zwischensummen und Prozentpositionen

Given I open an editor "1AU007" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU007  |
	| kunde  | 1       |
And I append rows
	| artikel | mge         | alternativpos |
	| V1      | 10          | !dontChange   |
	| ZS.     | !dontChange | ja            |
	| PR.     | !dontChange | !dontChange   |
And I save the current editor

Given I open an editor "1AU007" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU007"
Then I fill template "ev_vorg_alternativpos.ftl" and append it to output file "alternativpos.out"
And I save the current editor
