# *****************************************************************************
#  Name             : steuer_formular_infosys_01.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test von IS in UStVA-Formular
#
#
# *****************************************************************************
@persistent
Feature:  steuer_formular_infosys_01.feature
Background: XXX



Scenario: Buchungsnachweis (Umsatzsteuerposition)

# 
Given I open the infosystem "USTPOSBUNACH"
And I set field "posnum" to "1SAM-CZ"
And I press start
Then field "ssum" has value "0.00" in row 0
Then field "hsum" has value "264.95" in row 0
Then field "saldo" has value "-264.95" in row 0
Then the table has 2 rows
Then table has values
 |tbuchung|tbuzeile|tkonto |tposition|tbeleg|tssum|thsum |
 |602     |1       |44000CZ|81CZ     |400661|     |109.10|
 |603     |1       |44000CZ|43CZ     |2     |     |155.85|
And I close the current editor

Given I open the infosystem "USTPOSBUNACH"
And I set field "posnum" to "81S"
And I press start
Then field "ssum" has value "0.00" in row 0
Then field "hsum" has value "1460385.40" in row 0
Then field "saldo" has value "-1460385.40" in row 0
Then the table has 42 rows

Then field "tbuchung" has value "150" in row 1
Then field "tbuzeile" has value "2" in row 1
Then field "tkonto" has value "44000" in row 1
Then field "tposition" has value "81" in row 1
Then field "tbeleg" has value "400002" in row 1
Then field "tssum" has value "" in row 1
Then field "thsum" has value "117800.00" in row 1

Then field "tbuchung" has value "17" in row 42
Then field "tbuzeile" has value "1" in row 42
Then field "tkonto" has value "48300" in row 42
Then field "tposition" has value "81" in row 42
Then field "tssum" has value "" in row 42
Then field "thsum" has value "150.00" in row 42
And I close the current editor
# =========================================================================================


Scenario: Kontennachweis(Umsatzsteuerposition)

Given I open the infosystem "USTPOSKONACH"
And I set field "posnum" to "81S"
And I press start
Then field "ssum" has value "0.00" in row 0
Then field "hsum" has value "1460385.40" in row 0
Then field "saldo" has value "-1460385.40" in row 0
Then the table has 2 rows
Then table has values
 |tkonto|tkosteuer|tkolaart|tkoev  |tssum|thsum     |tsaldo     |
 |44000 |1        |Inland  |Verkauf| 0.00|1460235.40|-1460235.40|
 |48300 |1        |Inland  |Verkauf| 0.00|150.00    |-150.00    |
And I close the current editor

Given I open the infosystem "USTPOSKONACH"
And I set field "posnum" to "1SAM-CZ"
And I press start
Then field "ssum" has value "0.00" in row 0
Then field "hsum" has value "264.95" in row 0
Then field "saldo" has value "-264.95" in row 0
Then the table has 2 rows
Then table has values
 |tkonto |tkosteuer|tkolaart|tkoev  |tssum|thsum |tsaldo |
 |44000CZ|3        |Inland  |Verkauf| 0.00|109.10|-109.10|
 |44000CZ|3        |Inland  |Verkauf| 0.00|155.85|-155.85|
And I close the current editor
# =========================================================================================


Scenario: Kontennachweis(Umsatzsteuerformat)

Given I open the infosystem "USTKONACH"
And I set field "ustform" to "2022-CZK"
And I press start
Then the table has 7 rows
Then table has values
 |tustzn|tustpos| tkonto|tkosteuer|tkolaart|  tkoev|tkokart|tssum| thsum| tsaldo|
 |     1|   81CZ|44000CZ|        3|  Inland|Verkauf|       | 0.00|109.10|-109.10|
 |     1|       |       |         |        |       |       | 0.00|109.10|-109.10|
 |     2|   43CZ|44000CZ|        3|  Inland|Verkauf|       | 0.00|155.85|-155.85|
 |     2|       |       |         |        |       |       | 0.00|155.85|-155.85|
 |     3|1SAM-CZ|44000CZ|        3|  Inland|Verkauf|       | 0.00|109.10|-109.10|
 |     3|1SAM-CZ|44000CZ|        3|  Inland|Verkauf|       | 0.00|155.85|-155.85|
 |     3|       |       |         |        |       |       | 0.00|264.95|-264.95|
And I close the current editor


Given I open the infosystem "USTKONACH"
And I set field "ustform" to "2011"
And I press start
Then the table has 7 rows
Then table has values
 |tustzn|tustpos|tkonto|tkosteuer|tkolaart|  tkoev|tkokart|tssum|     thsum|     tsaldo|
 |     1|     81| 44000|        1|  Inland|Verkauf|       | 0.00|1460235.40|-1460235.40|
 |     1|     81| 48300|        1|  Inland|Verkauf|       | 0.00|150.00    |-150.00    |
 |     1|       |      |         |        |       |       | 0.00|1460385.40|-1460385.40|
 |     7|     41| 43150|        0|EU-Staat|Verkauf|       | 0.00|216850.00 |-216850.00 |
 |     7|       |      |         |        |       |       | 0.00|216850.00 |-216850.00 |
 |    10|     43| 41500|        0| Ausland|Verkauf|       | 0.00|677200.00 |-677200.00 |
 |    10|       |      |         |        |       |       | 0.00|677200.00 |-677200.00 |
And I close the current editor

# =========================================================================================


Scenario: Buchungsnachweis(Umsatzsteuerformat)

Given I open the infosystem "USTBUNACH"
And I set field "ustform" to "2022-CZK"
And I press start
Then the table has 11 rows
Then table has values
 |tustzn|tustpos| tkonto|tbuchung|tbuzeile|tssum| thsum|
 |     1|   81CZ|44000CZ|     602|       1|     |109.10|
 |     1|       |44000CZ|        |        |     |109.10|
 |     1|       |       |        |        |     |109.10|
 |     2|   43CZ|44000CZ|     603|       1|     |155.85|
 |     2|       |44000CZ|        |        |     |155.85|
 |     2|       |       |        |        |     |155.85|
 |     3|   81CZ|44000CZ|     602|       1|     |109.10|
 |     3|       |44000CZ|        |        |     |109.10|
 |     3|   43CZ|44000CZ|     603|       1|     |155.85|
 |     3|       |44000CZ|        |        |     |155.85|
 |     3|       |       |        |        |     |264.95|
And I close the current editor


Given I open the infosystem "USTKONACH"
And I set field "ustform" to "2011"
And I press start
Then the table has 7 rows
And I close the current editor


