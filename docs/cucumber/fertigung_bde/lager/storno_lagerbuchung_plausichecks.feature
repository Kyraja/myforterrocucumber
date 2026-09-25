@persistent
Feature: storno_lagerbuchung_plausichecks.feature

Background:
And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : storno_lagerbuchung_plausichecks
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : carue
#  Funktion         : Testet Plausis beim Storno einer Lagerbuchung
#  Jira-Issue       : FDA-755
# *****************************************************************************

Scenario Outline: 01 Alle Felder außer Erbtext und Belegnr sind schreibgeschützt
# Lagerzugang buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
	| such		| <such>	|
And I append rows
	| mge	| platz		| platz2	|
	| <mge>	| <platz>	| <platz2>	|
And I save the current editor


# Lagerbuchung stornieren

Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
Then field "beleg" is modifiable
Then field "ljtext1" is modifiable
# Schreibschutz Kopffelder
Then field "beldat" is not modifiable
Then field "wert" is not modifiable
Then field "buart" is not modifiable
Then field "stl" is not modifiable
Then field "kstelle" is not modifiable
Then field "verw" is not modifiable
Then field "projekt" is not modifiable
# Schreibschutz Tabellenfelder
Then field "mge" is not modifiable in row 1
Then field "lffert" is not modifiable in row 1
Then field "verw" is not modifiable in row 1
Then field "verw2" is not modifiable in row 1
Then field "projekt" is not modifiable in row 1
Then field "projekt2" is not modifiable in row 1
Then field "platz2" is not modifiable in row 1
Then field "tcharge2" is not modifiable in row 1
Then field "verfdat" is not modifiable in row 1
Then field "ze" is not modifiable in row 1
Then field "zele" is not modifiable in row 1
Then field "behaelter" is not modifiable in row 1
Then field "behaelterzu" is not modifiable in row 1
And I close the current editor


Examples:
| buart			| beleg		| mge	| platz			| platz2		| such 		|
| Zugang		| LB01-Z	| 10	| !dontChange	| F1			| ZU_LB01	|
| Abgang		| LB01-A	| 10	| F1			| !dontChange	| AB_LB01	|
| Umbuchung		| LB01-U	| 10	| F1			| F2			| UM_LB01	|



## entfällt, Rücksprache mit Anne, Storno über Tippkommando lässt nur Selektion von manuellen Lagerbuchungen zu ##
#Scenario Outline: 02 Es kann kein anderer Vorgang über LBuchung storniert werden
## Einkaufs- und Verkaufslieferscheine
#Given I open an editor "<vorgang>" from table "<table>" with command "NEW" for record ""
#And I set fields
#	| <kl>		| <kunde_lief>	|
#	| ueb		| ja			|
#	| vom		| .				|
#	| budat     | .			    |
#	| <beleg>	| <ebeleg>		|
#And I append rows
#	| artikel	| mge	| 
#	| EINKAUF-1	| 10	|
#And I save the current editor
#
## ID Lagerjournaleintrag speichern
#Given I open the infosystem "LJ"
#And I set field "richtung" to "rückwärts"
#And I set field "beleg" to "nummer" from editor "<vorgang>"
#And I press start
#And I save value from field "verweis^id" in row 1
#And I close the current editor 
#
## LJ Eintrag aufrufen
#Given I open an editor "LJ-Eintrag" from table "(Journal):(Journal)" with command "VIEW" for search criteria "<search>"
#And I close the current editor
#
## Lagerzugang buchen
#Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
#Then setting field "stornolj" in row 0 to "id" from editor "LJ-Eintrag" in row 0 throws the exception "633"
#And I close the current editor
#
#Examples:
#| vorgang			| table							| kl	| kunde_lief	| beleg			| ebeleg		| search	|
#| EK-Lieferschein	| (Purchasing):(PackingSlip)	| lief	| KETTLER		| ebeleg		| EK-Lief02		| $,,ursache=Lieferschein;@richtung=rückwärts;@maxtreffer=1	|
#| VK-Lieferschein	| (Sales):(PackingSlip)			| kunde	| RADSHOP		| !dontChange	| !dontChange	| $,,ursache=Lieferschein;@richtung=rückwärts;@maxtreffer=1	|	
#| VK-Rechnung		| (Sales):(Invoice)				| kunde	| RADSHOP		| !dontChange	| !dontChange	| $,,ursache=Rechnung;@richtung=rückwärts;@maxtreffer=1	|


Scenario: 03 Eine stornierte LBuchung kann nicht noch einmal storniert werden, der Storno einer LBuchung kann nicht storniert werden

# Lagerbuchung und Lagerbuchung stornieren
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| buart		| Zugang	|
	| beleg		| LB03		|
	| beldat	| .			|
	| ljtext1	| Buchung1	|
	| such		| MAN_LB03	|
And I append rows
	| mge	| platz2	|
	| 10	| F1		|
And I save the current editor

Given I open an editor "LBuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for search criteria "$,,such=MAN_LB03;@ablageart=abgelegt"
And I set fields
	| beleg		| LB03_S	|
	| ljtext1	| Storno1	|
	| such		| STORNO_03	|
And I save the current editor

Given I open an editor "LBuStornoPruef" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "VIEW" for record from editor "LBuchungStorno"
Then field "stornopartnervorg^id" has value "!LBuchung^id"
And I close the current editor

Given I open an editor "LBuPruef" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "VIEW" for record from editor "LBuchung"
Then field "storniert" has value "ja"
And I close the current editor

# Fehlermeldung, wenn Storno LBuchung oder stornierte LBuchung storniert werden wollen
# 9311 de      |Der Vorgang ist schon storniert.
Then opening an editor from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung" throws the exception "9311"
# 10912 de      |Stornovorgang kann nicht selbst storniert werden.
Then opening an editor from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchungStorno" throws the exception "10912"

Scenario: 04 Eine LBuchung kann nicht storniert werden, wenn der Behälter inzwischen gesperrt ist

# Behälter anlegen
Given I create a Container "SPERRE" for packaging material "BEHAELTER"

# Lagerbuchung Zugang in Behälter und Abgang
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| buart		| Zugang	|
	| beleg		| LB04ZU	|
	| beldat	| .			|
	| such		| LB_ZU04	|
And I modify table
	| mge	| platz2	| !row	|
	| 10	| F1		| 1		|
And I set field "behaelter" to id from editor "SPERRE" in row 1
And I save the current editor

Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| buart		| Abgang	|
	| beleg		| LB04		|
	| beldat	| .			|
	| such		| LB_AB04	|
And I modify table
	| mge	| platz	| !row	|
	| 10	| F1	| 1		|
And I set field "behaelter" to id from editor "SPERRE" in row 1
And I save the current editor

# Behälter sperren
Given I switch the current editor to editor "SPERRE" with command "UPDATE"
And I set field "behstatusaz" to "Gesperrt"
And I save the current editor

# Lagerbuchung stornieren führt zu Fehler
Given I open an editor "LBuchung" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for search criteria "$,,such=LB_AB04;@ablageart=abgelegt"
And I set field "beleg" to "STORNO"
Then saving the current editor throws the exception "11072"
And I close the current editor 

Given I open an editor "LBuchung" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for search criteria "$,,such=LB_ZU04;@ablageart=abgelegt"
And I set field "beleg" to "STORNO"
Then saving the current editor throws the exception "11072"
And I close the current editor
