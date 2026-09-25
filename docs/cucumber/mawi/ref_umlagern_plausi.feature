@persistent
Feature: ref_umlagern_plausi.feature

# **********************************************************************************
#  Name             : versionen_in_afl_tauschen.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : 
#  Funktion         : Testet Fehlermeldungen in Umlagerungseigenschaft
#
# **********************************************************************************

  # Stammdaten fuer den weiteren Testverlauf anlegen

  Scenario: Umlagerungseigenschaften anlegen und fehleingaben testen
    Given I open an editor "Umlagerungseigenschatft" from table "(Warehouse):(RelocationProperty)" with command "STORE" for record "LG4"
    And I set fields
    | lgziel	| Karlsruhe	|
    | spedit	| 003 		|
	Then saving the current editor throws the exception "10179"
	And I set field "lgquell" to "LG4"
	And I set field "tlzeit" to "1"
	Then saving the current editor throws the exception "4027"
	And I set field "tlzeiteinh" to "st"
    And I save the current editor


 Scenario Outline: weitere Umlagerungseigenschaften anlegen
     Given I open an editor "Umlagerungseigenschatft" from table "(Warehouse):(RelocationProperty)" with command "STORE" for record "LG4"
    And I set fields
	| lgquell		| LG4			|
    | lgziel		| KARLSRUHE		|
    | spedit		| <spedit> 		|
	| tlzeit		| <tlzeit>		|
	| tlzeiteinh	| <tlzeiteinh>	| 
    And I save the current editor

    Examples:
    | spedit	| tlzeit	| tlzeiteinh    |
	| 001		| 2			| st			|
    | 003		| 1			| Arbeitstage	|
    | 003		| 3			| st			|


Scenario: Doppelte Umlagerungseigenschaften sind nicht erlaubt
    Given I open an editor "Umlagerungseigenschatft" from table "(Warehouse):(RelocationProperty)" with command "STORE" for record "LG4"
    And I set fields
	| lgquell		| LG4		|
    | lgziel		| Karlsruhe	|
    | spedit		| 003 		|
	| tlzeit		| 1			|
	| tlzeiteinh	| st 		|
	Then saving the current editor throws the exception "985"
    And I close the current editor
