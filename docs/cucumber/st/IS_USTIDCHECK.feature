Feature: Infosystem USTIDCHECK
@persistent

Scenario: Infosystem bedienen - Keine Parameter
Given I open the infosystem "USTIDCHECK"
And I press button "bstart"
Then the table has 38 rows
And I close the current editor

Scenario: Infosystem bedienen - Kunden
Given I open the infosystem "USTIDCHECK"
And I set field "kunden" to "1"
And I set field "liefer" to "0"
And I press button "bstart"
Then the table has 36 rows
And I close the current editor

Scenario: Infosystem bedienen - Kunden, offlinesyntaxcheck
Given I open the infosystem "USTIDCHECK"
And I set field "kunden" to "1"
And I set field "liefer" to "0"
And I set field "select" to "70014!70018"
And I press button "bstart"
And I press button "kbusyntaxpruefen"
Then the table has 5 rows
And table has values
  | tobjekt | tcode | ttext                                                        | tstatusz        |
  | K 70014 |   200 | Die USt-IdNr des EU-Mitgliedsstaats ist syntaktisch korrekt. | icon:ball_green |
  | K 70015 |   200 | Die USt-IdNr des EU-Mitgliedsstaats ist syntaktisch korrekt. | icon:ball_green |
  | K 70016 |   200 | Die USt-IdNr des EU-Mitgliedsstaats ist syntaktisch korrekt. | icon:ball_green |
  | K 70017 |   200 | Die USt-IdNr des EU-Mitgliedsstaats ist syntaktisch korrekt. | icon:ball_green |
  | K 70018 |   200 | Die USt-IdNr des EU-Mitgliedsstaats ist syntaktisch korrekt. | icon:ball_green |
And I close the current editor

Scenario: Infosystem bedienen - Lieferanten
Given I open the infosystem "USTIDCHECK"
And I set field "kunden" to "0"
And I set field "liefer" to "1"
And I press button "bstart"
Then the table has 2 rows
And I close the current editor

Scenario: Infosystem bedienen - Lieferanten, einfache Pruefung 
Given I open the infosystem "USTIDCHECK"
And I set field "kunden" to "0"
And I set field "liefer" to "1"
And I press button "bstart"
And I press button "bcheck"
Then the table has 2 rows
And table has values
  | tobjekt  | tcode      | tstatusz      |
  | L 60004  | evatr-2006 | icon:ball_red | # ttext raus, da BZSt Texte aendert
  | L 840004 | evatr-0005 | icon:ball_red |
And I close the current editor

Scenario: Infosystem bedienen - Verkauf
Given I open the infosystem "USTIDCHECK"
And I set field "kunden" to "0"
And I set field "liefer" to "0"
And I set field "kbverkauf" to "1"
And I set field "kbeinkauf" to "0"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

Scenario: Infosystem bedienen - Einkauf
Given I open the infosystem "USTIDCHECK"
And I set field "kunden" to "0"
And I set field "liefer" to "0"
And I set field "kbverkauf" to "0"
And I set field "kbeinkauf" to "1"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

Scenario: Infosystem bedienen - Kunden, qualifizierte pruefung mit speichern und historie zeigen
Given I open the infosystem "USTIDCHECK"
And I set field "kunden" to "1"
And I set field "liefer" to "0"
And I set field "select" to "70014!70015"
And I press button "bstart"
And I press button "kbuqcheck"
# kein assert zu ttext, da Text vom BZSt in Echtzeit geholt wird, und extern veraendert werden kann
# und wir schon eine Aenderung hatten
Then the table has 2 rows
And table has values
  | tobjekt | tcode      | tergfirmenname | tergort | tergplz | tergstrasse | tstatusz         |
  | K 70014 | evatr-0000 | B              | A       | A       | A           | icon:ball_yellow |
  | K 70015 | evatr-0000 | A              | A       | A       | B           | icon:ball_yellow |
And I press button "kubqcheckspeichern"
Then the table has 2 rows
And I press button "kubqcheckzeigen"
Then the table has 4 rows
And I close the current editor
