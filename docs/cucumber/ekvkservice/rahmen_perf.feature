# *****************************************************************************
#  Name           : rahmen_perf.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Testet Rahmenauftraege bezueglich der Performance.
#
# *****************************************************************************
#
Feature: RahmenauftaegePerformance
Background:
Given I set the fake date to "02.01.1995"


#  V E R K A U F


Scenario: VK Rahmenauftrag mit vielen offenen Auftraegen anlegen
# Kunde anlegen
Given I open an editor "KU1000" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
	| such    | KU1000             |
	| name    | Tony Tausend       |
	| ans     | Tony Tausend       |
	| nort    | Mille              |
	| plz     | 10000              |
And I save the current editor

Given I open an editor "RA1" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "KU1000"
And I set field "such" to "RA1"
And I append rows
              | artex | mge  | verw  |
#LOOP_POS 1 to 1 |V1     | #id# | v#id# |                
              |V1     | 1    | v1    |

And I save the current editor

Scenario Outline: VK RA mit vielen offenen AU Positionen
Given I open an editor "AU<id>" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record from editor "RA1"
And I set field "such" to "AUA<id>"
And I set field "mge" to "1" in row 1
And I save the current editor

Given I open an editor "LS<id>" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU<id>"
And I set field "such" to "LS<id>"
And I set field "mge" to "1" in row 1
And I save the current editor

Examples:
			  | id   |
#LOOP 1 to 1  | #id# |
	          | 1    |
	          
Scenario: VK IS RAUOV zum KU1000 oeffnen	          
Given I open the infosystem "RAUOV"
And I set field "kkuli" to id from editor "KU1000"
And I press start
And I close the current editor	


# E I N K A U F


Scenario: EK Rahmenauftrag mit vielen offenen Bestellungen anlegen
# Lieferant anlegen
Given I open an editor "LI1000" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
	| such    | LI1000             |
	| name    | Henry Hundert      |
	| ans     | Henry Hundert      |
	| nort    | Cento              |
	| plz     | 100                |
And I save the current editor

Given I open an editor "RAE1" from table "(Purchasing):(BlanketOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "LI1000"
And I set field "such" to "RAE1"
And I append rows
              | artex | mge  | verw  |
#LOOP_POS 1 to 1 |E1     | #id# | v#id# |              
              |E1     | 1    | E1    |

And I save the current editor

Scenario Outline: EK RA mit vielen offenen BE Positionen
Given I open an editor "BE" from table "(Purchasing):(BlanketOrder)" with command "RELEASE" for record from editor "RAE1"
And I set field "such" to "BEA<id>"
And I set field "mge" to "1" in row 1
And I save the current editor

Examples:
			  | id   |
#LOOP 1 to 1  | #id# |
	          | 1    |
	          
Scenario: EK IS RAUOE zum LI1000 oeffnen	          
Given I open the infosystem "RAUOE"
And I set field "kkuli" to id from editor "LI1000"
And I press start
And I close the current editor	
