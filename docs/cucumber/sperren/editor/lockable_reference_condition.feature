# *****************************************************************************
#  Name: lockable_references_condition.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Editor der Verweissperrstellen
# *****************************************************************************
@persistent
@LOCKABLE_REFERENCES
Feature: Conditions_of_LockableReferences

Given I'm logged in with password "annette"

Scenario: UPDATE

Given I open an editor "LR_UPDATE" from table "(LockConfiguration):(LockableReferences)" with command "UPDATE" for record "LR_CREATE"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-24             | ja                   | artikel         | vorganga       | Barzahlung        |
Then field "bedingungsfeld" has value "vorganga" in row 2
Then field "bedingungsfeldbedeutung" has value "Rechnungsart" in row 2
Then field "bedingungsfeldart" has value "A11" in row 2
Then field "bedingungswertuniversal" has value "(CashPayment)" in row 2
Then field "bedingungswert" has value "Barzahlung" in row 2
Then field "bedingungswertneu" has value "Barzahlung" in row 2
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstellen_Artikel_Webauftrag_1

Given I open an editor "VOM_GD2_1" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "VOM_1"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel in Webauftragsposition bei Tagesdatum -1"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | vom            | 20260404          |
    | V-03-25             | ja                   | artikel         | vom            | 20230515          |
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstellen_Artikel_Webauftrag_2

Given I open an editor "VOM_GD2_2" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "VOM_2"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel in Webauftragsposition bei Tagesdatum -1"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | vom            | 20200304          |
    | V-03-25             | ja                   | artikel         | vom            | 20310503          |
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstellen_Artikel_Webauftrag_druck

Given I open an editor "DRUCK_ZAE" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "DRUCK"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel in zu druckender Webauftragsposition"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | druck          | true              |
Then field "bedingungswertuniversal" has value "(Yes)" in row 1
Then field "bedingungswert" has value "ja" in row 1
Then field "bedingungswertneu" has value "ja" in row 1
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstellen_Artikel_Webauftrag_vsperre

Given I open an editor "VSPERRE_BOOL" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "VSPERRE"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel in Warenkorbposition"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | vsperre        | true              |
Then field "bedingungswertuniversal" has value "(Yes)" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "ZEICH_GL" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "ZEICH"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel in Webauftragsposition von zeich"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | zeich          | fwester           |
Then field "bedingungswertuniversal" has value "fwester" in row 1
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstellen_Artikel_Webauftrag_waehr

Given I open an editor "WAEHR_VERWEIS" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "WAEHR"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel in Webauftragsposition bei Währung"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | waehr          | USD               |
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstellen_Artikel_Webauftrag_vorgartaz

Given I open an editor "Kurztext" from table "(Company):(Summary)" with command "NEW" for record ""
And I set field "such" to "WEBORDERLE"
And I set field "namebspr" to "Webaufträgle"
And I set field "such" to "WebOrderle"
And I save the current editor
And I close the current editor

Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "20341"
And I delete all rows
And I append rows
   | vaufzelem        | aebez              | aebezeichner | aekbez |
   | Firma WEBORDERLE | Webaufträgle       | (WebOrderle) | WebAU  |
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor
And I close the current editor

Given I open an editor "WAEHR_VORGANGA" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "VORGANGA"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel in Webauftragsposition bei Vorgangsart"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | vorgartaz      | WebAU             |
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstellen_Artikel_Webauftrag_vom

Given I open an editor "VOM_GD2_LEER" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "VOM_LEER"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel in Webauftragsposition bei leerem Tagesdatum"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | vom            |                   |
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstellen_Artikel_Webauftrag_mge

Given I open an editor "MGE" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "MGE"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel mit Rechnungsmenge 30 sperren"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeldintabelle | bedingungsfeld | bedingungswertneu |
    | V-03-25             | ja                   | artikel         | ja                      | mge            | 30                |
And I save the current editor
And I close the current editor

Scenario: Bedingte_Verweissperrstelle_Artikel_im_Rücklieferschein

Given I open an editor "LSART" from table "(LockConfiguration):(LockableReferences)" with command "NEW" for record ""
And I set field "such" to "LSART"
And I set field "gesperrtegruppe" to "V-02-01"
And I set field "namebspr" to "Artikel im Rücklieferschein sperren"
And I append rows
    | verweisfeldingruppe | verweisfeldintabelle | verweisfeldname | bedingungsfeldintabelle | bedingungsfeld | bedingungswertneu   |
    | V-03-23             | ja                   | artikel         | nein                    | lsart          | (ReturnPackingSlip) |
And I save the current editor
And I close the current editor
