# *****************************************************************************
#  Name             : ref_zuordnungskriterien_schreibschutz.feature
#  Autor            : jeffler
#  Verantwortlich   : hc
#  Kontrolle        : wane
#  Funktion         : 
#
# *****************************************************************************
@persistent

Feature: ref_zuordnungskriterien_schreibschutz
Background: Zahlungsverkehr

Scenario Outline: Felder nur beschreibbar, wenn Muss/Kann ausgewählt ist.
Given I open an editor "MussKann<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "<mkfield>" to "<mkval>"
Then field "<numerisch>" is <modifiable>
Then field "<von>" is <modifiable>
Then field "<bis>" is <modifiable>
Then field "<min>" is <modifiable>
Then field "<max>" is <modifiable>
And I close the current editor

Examples:

|nr| mkfield|mkval|numerisch|      von|      bis|      min|      max|    modifiable|
|M1| zkbeleg| Muss| zkbelnum| zkbelvon| zkbelbis| zkbelmin| zkbelmax|    modifiable|
|M2|zkebeleg| Muss|zkebelnum|zkebelvon|zkebelbis|zkebelmin|zkebelmax|    modifiable|
|M3| zkzaref| Muss| zkzarnum| zkzarvon| zkzarbis| zkzarmin| zkzarmax|    modifiable|
|M4| zkkunid| Muss| zkkunnum| zkkunvon| zkkunbis| zkkunmin| zkkunmax|    modifiable|
|M5| zkkunzu| Muss| zkkunnum| zkkunvon| zkkunbis| zkkunmin| zkkunmax|    modifiable|
|K1| zkbeleg| Kann| zkbelnum| zkbelvon| zkbelbis| zkbelmin| zkbelmax|    modifiable|
|K2|zkebeleg| Kann|zkebelnum|zkebelvon|zkebelbis|zkebelmin|zkebelmax|    modifiable|
|K3| zkzaref| Kann| zkzarnum| zkzarvon| zkzarbis| zkzarmin| zkzarmax|    modifiable|
|K4| zkkunid| Kann| zkkunnum| zkkunvon| zkkunbis| zkkunmin| zkkunmax|    modifiable|
|K5| zkkunzu| Kann| zkkunnum| zkkunvon| zkkunbis| zkkunmin| zkkunmax|    modifiable|
|-1| zkbeleg|     | zkbelnum| zkbelvon| zkbelbis| zkbelmin| zkbelmax|not modifiable|
|-2|zkebeleg|     |zkebelnum|zkebelvon|zkebelbis|zkebelmin|zkebelmax|not modifiable|
|-3| zkzaref|     | zkzarnum| zkzarvon| zkzarbis| zkzarmin| zkzarmax|not modifiable|
|-4| zkkunid|     | zkkunnum| zkkunvon| zkkunbis| zkkunmin| zkkunmax|not modifiable|
|-5| zkkunzu|     | zkkunnum| zkkunvon| zkkunbis| zkkunmin| zkkunmax|not modifiable|


Scenario Outline: Länge schreibgeschützt, wenn aus Grenzwerten ermittelt
Given I open an editor "Länge<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "<mkfield>" to "<mkval>"
Then field "<minfield>" is modifiable
Then field "<maxfield>" is modifiable
And I set field "<vonfield>" to "<vonval>"
Then field "<minfield>" is not modifiable
Then field "<maxfield>" is modifiable
And I set field "<bisfield>" to "<bisval>"
Then field "<minfield>" is not modifiable
Then field "<maxfield>" is not modifiable
And I set field "<vonfield>" to ""
Then field "<minfield>" is modifiable
Then field "<maxfield>" is not modifiable
And I set field "<bisfield>" to ""
Then field "<minfield>" is modifiable
Then field "<maxfield>" is modifiable
And I close the current editor

Examples:

|nr| mkfield|mkval| minfield| maxfield| vonfield|vonval| bisfield|bisval|
| 1| zkbeleg| Muss| zkbelmin| zkbelmax| zkbelvon|    1a| zkbelbis|999zzz|
| 2| zkbeleg| Kann| zkbelmin| zkbelmax| zkbelvon|    1a| zkbelbis|999zzz|
| 3|zkebeleg| Muss|zkebelmin|zkebelmax|zkebelvon|    1a|zkebelbis|999zzz|
| 4|zkebeleg| Kann|zkebelmin|zkebelmax|zkebelvon|    1a|zkebelbis|999zzz|
| 5| zkzaref| Muss| zkzarmin| zkzarmax| zkzarvon|    1a| zkzarbis|999zzz|
| 6| zkzaref| Kann| zkzarmin| zkzarmax| zkzarvon|    1a| zkzarbis|999zzz|
| 7| zkkunid| Muss| zkkunmin| zkkunmax| zkkunvon|    1a| zkkunbis|999zzz|
| 8| zkkunid| Kann| zkkunmin| zkkunmax| zkkunvon|    1a| zkkunbis|999zzz|


Scenario: Toleranz schreibgeschützt, wenn Betrag false

Given I open an editor "Betrag" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
Then field "zkbetr" is modifiable
Then field "zkbetrtu" is not modifiable
Then field "zkbetrto" is not modifiable
And I set field "zkbetr" to "ja"
Then field "zkbetr" is modifiable
Then field "zkbetrtu" is modifiable
Then field "zkbetrto" is modifiable
And I set field "zkbetr" to "nein"
Then field "zkbetr" is modifiable
Then field "zkbetrtu" is not modifiable
Then field "zkbetrto" is not modifiable
And I close the current editor

Scenario: Buchungsart schreibgeschützt, wenn ZK als Standard in ZVKonfig eingetragen

Given I open an editor "zkgutneu" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TAC0GUT"
And I set field "zabuchart" to "Gutschrift"
And I set field "zkkunde" to "ja"
And I set field "zkbeleg" to "Kann"
And I set field "zkbelmin" to "1"
And I set field "zkbelmax" to "999"
And I save the current editor
And I close the current editor

Given I open an editor "zkbelneu" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TAC0BEL"
And I set field "zabuchart" to "Belastung"
And I set field "zklieferant" to "ja"
And I set field "zkbeleg" to "Kann"
And I set field "zkbelmin" to "1"
And I set field "zkbelmax" to "999"
And I save the current editor
And I close the current editor

Given I open an editor "zkstandard" via ID from editor "zkgutneu" from field "nummer" in row 0 for table "(PaymentMasterFiles):(AllocationCriteria)" with command "UPDATE"
Then field "zabuchart" is modifiable
And I close the current editor

Given I open an editor "zkstandard" via ID from editor "zkbelneu" from field "nummer" in row 0 for table "(PaymentMasterFiles):(AllocationCriteria)" with command "UPDATE"
Then field "zabuchart" is modifiable
And I close the current editor

Given I open an editor "konfig" from table "(PaymentMasterFiles):(CMConfig)" with command "UPDATE" for record "1"
And I set field "zuordkgutschrift" to "nummer" from editor "zkgutneu"
And I set field "zuordkbelastung" to "nummer" from editor "zkbelneu"
And I save the current editor
And I close the current editor

Given I open an editor "zkstandard" via ID from editor "zkgutneu" from field "nummer" in row 0 for table "(PaymentMasterFiles):(AllocationCriteria)" with command "UPDATE"
Then field "zabuchart" is not modifiable
And I close the current editor

Given I open an editor "zkstandard" via ID from editor "zkbelneu" from field "nummer" in row 0 for table "(PaymentMasterFiles):(AllocationCriteria)" with command "UPDATE"
Then field "zabuchart" is not modifiable
And I close the current editor

Scenario: Schreibschutz bei Kommando Neu
Given I open an editor "neu" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
Then field "such" is modifiable
Then field "name" is modifiable
Then field "zabuchart" is modifiable
Then field "zkkunde" is modifiable
Then field "zklieferant" is modifiable
Then field "zkmitarbeiter" is modifiable
Then field "zkkonto" is modifiable
Then field "zkbeleg" is modifiable
Then field "zkebeleg" is modifiable
Then field "zkzaref" is modifiable
Then field "zkbetr" is modifiable
Then field "zkkunid" is modifiable
Then field "zkkunzu" is modifiable
Then field "zkbverb" is modifiable
Then field "zkauftr" is modifiable
Then field "zkvzweck" is modifiable

Then field "zkbelmin" is not modifiable
Then field "zkbelmax" is not modifiable
Then field "zkbelnum" is not modifiable
Then field "zkbelvon" is not modifiable
Then field "zkbelbis" is not modifiable
Then field "zkebelmin" is not modifiable
Then field "zkebelmax" is not modifiable
Then field "zkebelnum" is not modifiable
Then field "zkebelvon" is not modifiable
Then field "zkebelbis" is not modifiable
Then field "zkzarmin" is not modifiable
Then field "zkzarmax" is not modifiable
Then field "zkzarnum" is not modifiable
Then field "zkzarvon" is not modifiable
Then field "zkzarbis" is not modifiable
Then field "zkbetrtu" is not modifiable
Then field "zkbetrto" is not modifiable
Then field "zkkunmin" is not modifiable
Then field "zkkunmax" is not modifiable
Then field "zkkunnum" is not modifiable
Then field "zkkunvon" is not modifiable
Then field "zkkunbis" is not modifiable

And I set field "such" to "zkfptest"
And I set field "zkkunde" to "ja"
And I save the current editor
And I close the current editor


Scenario: Schreibschutz bei Kommando Ändern (nicht Standardzuordnungskriterien)
Given I open an editor "neu" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "UPDATE" for record "zkfptest"
Then field "such" is modifiable
Then field "name" is modifiable
Then field "zabuchart" is modifiable
Then field "zkkunde" is modifiable
Then field "zklieferant" is modifiable
Then field "zkmitarbeiter" is modifiable
Then field "zkkonto" is modifiable
Then field "zkbeleg" is modifiable
Then field "zkebeleg" is modifiable
Then field "zkzaref" is modifiable
Then field "zkbetr" is modifiable
Then field "zkkunid" is modifiable
Then field "zkkunzu" is modifiable
Then field "zkbverb" is modifiable
Then field "zkauftr" is modifiable
Then field "zkvzweck" is modifiable

Then field "zkbelmin" is not modifiable
Then field "zkbelmax" is not modifiable
Then field "zkbelnum" is not modifiable
Then field "zkbelvon" is not modifiable
Then field "zkbelbis" is not modifiable
Then field "zkebelmin" is not modifiable
Then field "zkebelmax" is not modifiable
Then field "zkebelnum" is not modifiable
Then field "zkebelvon" is not modifiable
Then field "zkebelbis" is not modifiable
Then field "zkzarmin" is not modifiable
Then field "zkzarmax" is not modifiable
Then field "zkzarnum" is not modifiable
Then field "zkzarvon" is not modifiable
Then field "zkzarbis" is not modifiable
Then field "zkbetrtu" is not modifiable
Then field "zkbetrto" is not modifiable
Then field "zkkunmin" is not modifiable
Then field "zkkunmax" is not modifiable
Then field "zkkunnum" is not modifiable
Then field "zkkunvon" is not modifiable
Then field "zkkunbis" is not modifiable

And I close the current editor
