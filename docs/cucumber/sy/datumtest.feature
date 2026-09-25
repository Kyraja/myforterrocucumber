Feature: datumtest.feature

  Background:
    And I set the fake date to "02.01.2000"

# **********************************************************************************
#  Name             : datumtest
#  Autor            : pw
#  Verantwortlich   : teamcoreinfra
#  Kontrolle        :
#  Funktion         : Art Datum testen
#
# **********************************************************************************

Scenario: Auftrag anlegen mit leerem tterm, um "Abruf"-Datum zu erzeugen
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
 | nummer | 1  |
 | kunde  | 1  |
And I append rows
 | artikel | mge |
 | V1      | 1   |
And I save the current editor

Scenario: Test-FOP fuer das Standard-EKS-Datum
Given I execute FOP "DATUM.LGTEST"

Scenario: Test-FOP fuer GD / GW4
Given I execute FOP "GDATUM.LGTEST"

Scenario: Test-FOP fuer GD2 / GW2
Given I execute FOP "GDATUM2.LGTEST"

Scenario: Test-FOP fuer GD8 / GW4
Given I execute FOP "GDATUM8.LGTEST"

Scenario: Test-FOP fuer GD14
Given I execute FOP "GDATUM14.LGTEST"

Scenario: Liefertermine als Wochendatum
Given I open an editor "ArtDatum" from table "(Types):(Date)" with command "UPDATE" for record "60001"
And I set fields
 | vitnf | GW2 |
And I respond with answer "ja" to the dialog with id "10951"
And I save the current editor
# Test-FOP mit Referenzausgabe
Given I execute FOP "TERMIN.W.LGTEST"

Scenario: Liefertermine wieder als Tagesdatum
Given I open an editor "ArtDatum" from table "(Types):(Date)" with command "UPDATE" for record "60001"
And I set fields
 | vitnf | GD2 |
And I respond with answer "ja" to the dialog with id "10951"
And I save the current editor

Scenario: Testfop zum pruefen, ob DATUM und GDATUM im Wertebereich von datum identisch sind
Given I execute FOP "GDDAT.IDENT"
Given I execute FOP "DATUM.INT"

Scenario: Internationale Darstellung pruefen
Given I execute FOP "DATUM.INT.EINGABE"
