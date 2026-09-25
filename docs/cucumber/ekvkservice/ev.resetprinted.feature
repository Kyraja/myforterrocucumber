@include @persistent
Feature: Daten fuer RESETPRINTED
Background:
Given I'm logged in with password "adm"
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "EV.RESETPRINTED.CU.REF"
Given I set saved value "Feldliste" to "tbeleg,tbelegsuch,reart,erechok,druck,tkuli,tkuli2,tkuli3,vertret,spediteur"

#Verkauf
Scenario:  Infosystem RESETPRINTED starten mit Kunde MAIER
Given I open the infosystem "RESETPRINTED"
And I set field "kkl" to "K MAIER"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 2 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem RESETPRINTED starten mit Kunde BAUER
Given I open the infosystem "RESETPRINTED"
And I set field "kkl" to "K BAUER"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 2 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem RESETPRINTED starten mit Kunde KURZ
Given I open the infosystem "RESETPRINTED"
And I set field "kkl" to "K KURZ"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem RESETPRINTED starten mit Kunde LANG
Given I open the infosystem "RESETPRINTED"
And I set field "kkl" to "K LANG"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

#Einkauf
Scenario:  Infosystem RESETPRINTED starten mit Lieferant GOLD
Given I open the infosystem "RESETPRINTED"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L GOLD"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 2 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem RESETPRINTED starten mit Lieferant SCHWARZ
Given I open the infosystem "RESETPRINTED"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L SCHWARZ"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem RESETPRINTED starten mit Lieferant ROT
Given I open the infosystem "RESETPRINTED"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L ROT"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 0 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

#Verkauf
#Ablageart=abgelegt
Scenario:  Infosystem RESETPRINTED starten mit Kunde MAIER
Given I open the infosystem "RESETPRINTED"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "beides"
And I set field "kkl" to "K MAIER"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario:  Infosystem RESETPRINTED starten mit Kunde BAUER
Given I open the infosystem "RESETPRINTED"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "beides"
And I set field "kkl" to "K BAUER"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

#Einkauf
Scenario:  Infosystem RESETPRINTED starten mit Lieferant GOLD
Given I open the infosystem "RESETPRINTED"
And I set field "stichvon" to "1.1."
And I set field "ablageart" to "beides"
And I set field "bereich" to "Einkauf"
And I set field "kkl" to "L GOLD"
And I set field "bnochmaldrucken" to "nein"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

