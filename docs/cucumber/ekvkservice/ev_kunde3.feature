# *****************************************************************************
#  Name           : ev_kunde3.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Je nachdem ob Kunde oder Kundenkontakt im Feld Kunde oder Wahrenempfaenger
#                   eingetragen ist und ob  sie eine Versandadresse besitzen wird diese
#                   in einem Lieferschein als Versandadresse (Ablieferungsort - adresse2) belegt.
#
# *****************************************************************************
#
@persistent
Feature: Servicereservierung
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

@service
Scenario Outline: Uebernahme Versandadressen bei Kunden, Kundenkontakt

#Hauptkunde anpassen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "KUNDE"
And I set field "such" to "KUNDE"
And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
And I set field "ans" to "<k_ans>"
And I set field "str" to "<k_str>"
And I set field "plz" to "<k_plz>"
And I set field "nort" to "<k_nort>"
And I set field "region" to "<k_region>"
And I set field "staat" to "<k_staat>"
And I set field "ans2" to "<k_ans2>"
And I set field "str2" to "<k_str2>"
And I set field "plz2" to "<k_plz2>"
And I set field "nort2" to "<k_nort2>"
And I set field "region2" to "<k_region2>"
And I set field "staat2" to "<k_staat2>"
And I save the current editor

# Kundenkontakt anpassen
Given I open an editor "kunde" from table "(Customer):(CustomerContact)" with command "STORE" for record "KKONTAKT"
And I set field "such" to "KKONTAKT"
And I set field "namebspr" to "Bayram Aussenlager, Niederbuehl"
And I set field "firma" to "KUNDE"
And I set field "ans" to "<kk_ans>"
And I set field "str" to "<kk_str>"
And I set field "plz" to "<kk_plz>"
And I set field "nort" to "<kk_nort>"
And I set field "region" to "<kk_region>"
And I set field "staat" to "<kk_staat>"
And I set field "ans2" to "<kk_ans2>"
And I set field "str2" to "<kk_str2>"
And I set field "plz2" to "<kk_plz2>"
And I set field "nort2" to "<kk_nort2>"
And I set field "region2" to "<kk_region2>"
And I set field "staat2" to "<kk_staat2>"
And I save the current editor

# Lieferschein neu und Kombinationen zwischen Lieferant und Warenempfaenger testen
Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "<kunde>"
And I set field "warenempf" to "<warenempf>"
Then field "adresse" has value "<soll_adresse>"
Then field "adresse2" has value "<soll_adresse2>"
And I close the current editor


Examples:
# Nachfolgend werden die Kombinationen getestet.
# Das Feld kombi ist zur Info und bedeutet folgendes:
# 1. Bit : Wenn 1, so ist beim Kunden eine Anschrift verwaltet
# 2. Bit : Wenn 1, so ist beim Kunden eine Versandanschrift verwaltet
# 3. Bit : Wenn 1, so ist beim Kundenkontakt eine Anschrift verwaltet
# 4. Bit : Wenn 1, so ist beim Kundenkontakt eine Versandanschrift verwaltet
# 5. Bit : Wenn 0, Rechempf. ist Hauptkunde, Wenn 1 Rechempf ist Kundenkontakt
# 6. Bit : Wenn 0, Warenempf ist Hauptkunde, wenn 1 Warenempf ist Kundenkontakt

#                                 Anschrift LS                    Versandanschrift LS  Kunde (Stammdaten) Anschrift    Kunde (Stammdaten Versandanschrift)  Kundenkontakt (STammdaten) Anschrift   Kundenkontakt (Stammdaten) Versandanschrift             
  |row |kombi   |kunde    |warenempf|soll_adresse                   |soll_adresse2                      |k_ans  |k_str  |k_plz  |k_nort  |k_region |k_staat |k_ans2  |k_str2  |k_plz2  |k_nort2  |k_region2 |k_staat2 |kk_ans |kk_str |kk_plz |kk_nort |kk_region |kk_staat |kk_ans2 |kk_str2 |kk_plz2 |kk_nort2 |kk_region2 |kk_staat2 |
  |01  |0000 00 |KUNDE    |KUNDE    |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |02  |0000 01 |KUNDE    |KKONTAKT |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |03  |0000 10 |KKONTAKT |KUNDE    |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |04  |0000 11 |KKONTAKT |KKONTAKT |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |05  |0001 00 |KUNDE    |KUNDE    |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |06  |0001 01 |KUNDE    |KKONTAKT |                               |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |07  |0001 10 |KKONTAKT |KUNDE    |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |08  |0001 11 |KKONTAKT |KKONTAKT |                               |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |09  |0010 00 |KUNDE    |KUNDE    |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |10  |0010 01 |KUNDE    |KKONTAKT |                               |KK_ans\nKK_str\nKK_plz KK_nort     |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |11  |0010 10 |KKONTAKT |KUNDE    |KK_ans\nKK_str\nKK_plz KK_nort |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |12  |0010 11 |KKONTAKT |KKONTAKT |KK_ans\nKK_str\nKK_plz KK_nort |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |13  |0011 00 |KUNDE    |KUNDE    |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |14  |0011 01 |KUNDE    |KKONTAKT |                               |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |15  |0011 10 |KKONTAKT |KUNDE    |KK_ans\nKK_str\nKK_plz KK_nort |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |15  |0011 11 |KKONTAKT |KKONTAKT |KK_ans\nKK_str\nKK_plz KK_nort |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |17  |0100 00 |KUNDE    |KUNDE    |                               |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |18  |0100 01 |KUNDE    |KKONTAKT |                               |                                   |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |19  |0100 10 |KKONTAKT |KUNDE    |                               |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |20  |0100 11 |KKONTAKT |KKONTAKT |                               |                                   |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |21  |0101 00 |KUNDE    |KUNDE    |                               |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       | 
  |22  |0101 01 |KUNDE    |KKONTAKT |                               |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       | 
  |23  |0101 10 |KKONTAKT |KUNDE    |                               |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       | 
  |24  |0101 11 |KKONTAKT |KKONTAKT |                               |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       | 
  |25  |0110 00 |KUNDE    |KUNDE    |                               |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |26  |0110 01 |KUNDE    |KKONTAKT |                               |KK_ans\nKK_str\nKK_plz KK_nort     |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |27  |0110 10 |KKONTAKT |KUNDE    |KK_ans\nKK_str\nKK_plz KK_nort |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |28  |0110 11 |KKONTAKT |KKONTAKT |KK_ans\nKK_str\nKK_plz KK_nort |                                   |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |29  |0111 00 |KUNDE    |KUNDE    |                               |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |30  |0111 01 |KUNDE    |KKONTAKT |                               |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |31  |0111 10 |KKONTAKT |KUNDE    |KK_ans\nKK_str\nKK_plz KK_nort |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |32  |0111 11 |KKONTAKT |KKONTAKT |KK_ans\nKK_str\nKK_plz KK_nort |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |       |       |       |        |         |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |33  |1000 00 |KUNDE    |KUNDE    |KU_ans\nKU_str\nKU_plz KU_nort |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |34  |1000 01 |KUNDE    |KKONTAKT |KU_ans\nKU_str\nKU_plz KU_nort |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |35  |1000 10 |KKONTAKT |KUNDE    |                               |KU_ans\nKU_str\nKU_plz KU_nort     |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |36  |1000 11 |KKONTAKT |KKONTAKT |                               |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |37  |1001 00 |KUNDE    |KUNDE    |KU_ans\nKU_str\nKU_plz KU_nort |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |38  |1001 01 |KUNDE    |KKONTAKT |KU_ans\nKU_str\nKU_plz KU_nort |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |39  |1001 10 |KKONTAKT |KUNDE    |                               |KU_ans\nKU_str\nKU_plz KU_nort     |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |40  |1001 11 |KKONTAKT |KKONTAKT |                               |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |41  |1010 00 |KUNDE    |KUNDE    |KU_ans\nKU_str\nKU_plz KU_nort |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |42  |1010 01 |KUNDE    |KKONTAKT |KU_ans\nKU_str\nKU_plz KU_nort |KK_ans\nKK_str\nKK_plz KK_nort     |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |43  |1010 10 |KKONTAKT |KUNDE    |KK_ans\nKK_str\nKK_plz KK_nort |KU_ans\nKU_str\nKU_plz KU_nort     |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |44  |1010 11 |KKONTAKT |KKONTAKT |KK_ans\nKK_str\nKK_plz KK_nort |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |45  |1011 00 |KUNDE    |KUNDE    |KU_ans\nKU_str\nKU_plz KU_nort |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |46  |1011 01 |KUNDE    |KKONTAKT |KU_ans\nKU_str\nKU_plz KU_nort |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |47  |1011 10 |KKONTAKT |KUNDE    |KK_ans\nKK_str\nKK_plz KK_nort |KU_ans\nKU_str\nKU_plz KU_nort     |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |48  |1011 11 |KKONTAKT |KKONTAKT |KK_ans\nKK_str\nKK_plz KK_nort |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |49  |1100 00 |KUNDE    |KUNDE    |KU_ans\nKU_str\nKU_plz KU_nort |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |50  |1100 01 |KUNDE    |KKONTAKT |KU_ans\nKU_str\nKU_plz KU_nort |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |51  |1100 10 |KKONTAKT |KUNDE    |                               |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |52  |1100 11 |KKONTAKT |KKONTAKT |                               |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |53  |1101 00 |KUNDE    |KUNDE    |KU_ans\nKU_str\nKU_plz KU_nort |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |54  |1101 01 |KUNDE    |KKONTAKT |KU_ans\nKU_str\nKU_plz KU_nort |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |55  |1101 10 |KKONTAKT |KUNDE    |                               |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |56  |1101 11 |KKONTAKT |KKONTAKT |                               |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |57  |1110 00 |KUNDE    |KUNDE    |KU_ans\nKU_str\nKU_plz KU_nort |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |58  |1110 01 |KUNDE    |KKONTAKT |KU_ans\nKU_str\nKU_plz KU_nort |KK_ans\nKK_str\nKK_plz KK_nort     |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |59  |1110 10 |KKONTAKT |KUNDE    |KK_ans\nKK_str\nKK_plz KK_nort |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |60  |1110 11 |KKONTAKT |KKONTAKT |KK_ans\nKK_str\nKK_plz KK_nort |                                   |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |61  |1111 00 |KUNDE    |KUNDE    |KU_ans\nKU_str\nKU_plz KU_nort |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |62  |1111 01 |KUNDE    |KKONTAKT |KU_ans\nKU_str\nKU_plz KU_nort |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |63  |1111 10 |KKONTAKT |KUNDE    |KK_ans\nKK_str\nKK_plz KK_nort |KU_ans2\nKU_str2\nKU_plz2 KU_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  |64  |1111 11 |KKONTAKT |KKONTAKT |KK_ans\nKK_str\nKK_plz KK_nort |KK_ans2\nKK_str2\nKK_plz2 KK_nort2 |KU_ans |KU_str |KU_plz |KU_nort |BADEN    |DEU     |KU_ans2 |KU_str2 |KU_plz2 |KU_nort2 |BADEN     |DEU      |KK_ans |KK_str |KK_plz |KK_nort |BADEN     |DEU      |KK_ans2 |KK_str2 |KK_plz2 |KK_nort2 |BADEN      |DEU       |
  

@service
Scenario Outline: Uebernahme Versandadressen bei Lieferant, Lieferantenkontakt
# Je nachdem ob Lieferant oder Lieferantenkontakt im Feld Liefernt oder Rechnungssteller (Hier keine Lieferantenkontakte moeglich!)
# eingetragen ist und ob  sie eine Versandadresse besitzen wird diese in einem Lieferschein
# als Versandadresse (Ablieferungsort - adresse2) belegt.

#Hauptlieferant anpassen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "LIEF"
And I set field "such" to "LIEF"
And I set field "namebspr" to "Mertens, Baden-Baden, Haueneberstein"
And I set field "ans" to "<l_ans>"
And I set field "str" to "<l_str>"
And I set field "plz" to "<l_plz>"
And I set field "nort" to "<l_nort>"
And I set field "region" to "<l_region>"
And I set field "staat" to "<l_staat>"
And I set field "ans2" to "<l_ans2>"
And I set field "str2" to "<l_str2>"
And I set field "plz2" to "<l_plz2>"
And I set field "nort2" to "<l_nort2>"
And I set field "region2" to "<l_region2>"
And I set field "staat2" to "<l_staat2>"
And I save the current editor

# Lieferantenkontakt anpassen
Given I open an editor "lkontakt" from table "(Vendor):(VendorContact)" with command "STORE" for record "LKONTAKT"
And I set field "namebspr" to "Mertens, Vertriebszentrum, Malsch"
And I set field "firma" to "LIEF"
And I set field "such" to "LKONTAKT"
And I set field "ans" to "<lk_ans>"
And I set field "str" to "<lk_str>"
And I set field "plz" to "<lk_plz>"
And I set field "nort" to "<lk_nort>"
And I set field "region" to "<lk_region>"
And I set field "staat" to "<lk_staat>"
And I set field "ans2" to "<lk_ans2>"
And I set field "str2" to "<lk_str2>"
And I set field "plz2" to "<lk_plz2>"
And I set field "nort2" to "<lk_nort2>"
And I set field "region2" to "<lk_region2>"
And I set field "staat2" to "<lk_staat2>"
And I save the current editor

# Lieferschein neu und Kombinationen zwischen Lieferant und Rechnungsempfaenger testen
Given I open an editor "Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "<lief>"
And I set field "kl2" to "<rechempf>"
Then field "adresse" has value "<soll_adresse>"
Then field "adresse2" has value "<soll_adresse2>"
And I close the current editor


Examples:
# Nachfolgend werden die Kombinationen getestet.
# Das Feld kombi ist zur Info und bedeutet folgendes:
# 1. Bit : Wenn 1, so ist beim Lieferanten eine Anschrift verwaltet
# 2. Bit : Wenn 1, so ist beim Lieferanten eine Versandanschrift verwaltet
# 3. Bit : Wenn 1, so ist beim Lieferantenkontakt eine Anschrift verwaltet
# 4. Bit : Wenn 1, so ist beim Lieferantenkontakt eine Versandanschrift verwaltet
# 5. Bit : Wenn 0, Lieferant ist Hauptlieferant, Wenn 1 Lieferant ist Lieferantenkontakt
# 6. Bit : 0, Rechnungssteller ist Hauptlieferant (im EK die einzigste Moeglichkeit)

#                                 Anschrift LS                    Versandanschrift LS  Kunde (Stammdaten) Anschrift    Kunde (Stammdaten Versandanschrift)  Kundenkontakt (STammdaten) Anschrift   Kundenkontakt (Stammdaten) Versandanschrift             
  |row |kombi   |lief     |rechempf |soll_adresse                   |soll_adresse2                      |l_ans  |l_str  |l_plz  |l_nort  |l_region |l_staat |l_ans2  |l_str2  |l_plz2  |l_nort2  |l_region2 |l_staat2 |lk_ans |lk_str |lk_plz |lk_nort |lk_region |lk_staat |lk_ans2 |lk_str2 |lk_plz2 |lk_nort2 |lk_region2 |lk_staat2 |
  |01  |0000 00 |LIEF     |LIEF     |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |02  |0000 10 |LKONTAKT |LIEF     |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |03  |0001 00 |LIEF     |LIEF     |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |04  |0001 10 |LKONTAKT |LIEF     |                               |LK_ans2\nLK_str2\nLK_plz2 LK_nort2 |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |05  |0010 00 |LIEF     |LIEF     |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |06  |0010 10 |LKONTAKT |LIEF     |LK_ans\nLK_str\nLK_plz LK_nort |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |07  |0011 00 |LIEF     |LIEF     |                               |                                   |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |08  |0011 10 |LKONTAKT |LIEF     |LK_ans\nLK_str\nLK_plz LK_nort |LK_ans2\nLK_str2\nLK_plz2 LK_nort2 |       |       |       |        |         |DEU     |        |        |        |         |          |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |09  |0100 00 |LIEF     |LIEF     |                               |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |       |       |       |        |         |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |10  |0100 10 |LKONTAKT |LIEF     |                               |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |       |       |       |        |         |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |11  |0101 00 |LIEF     |LIEF     |                               |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |       |       |       |        |         |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       | 
  |12  |0101 10 |LKONTAKT |LIEF     |                               |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |       |       |       |        |         |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       | 
  |13  |0110 00 |LIEF     |LIEF     |                               |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |       |       |       |        |         |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |14  |0110 10 |LKONTAKT |LIEF     |LK_ans\nLK_str\nLK_plz LK_nort |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |       |       |       |        |         |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |15  |0111 00 |LIEF     |LIEF     |                               |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |       |       |       |        |         |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |16  |0111 10 |LKONTAKT |LIEF     |LK_ans\nLK_str\nLK_plz LK_nort |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |       |       |       |        |         |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |17  |1000 00 |LIEF     |LIEF     |LI_ans\nLI_str\nLI_plz LI_nort |                                   |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |18  |1000 10 |LKONTAKT |LIEF     |                               |                                   |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |19  |1001 00 |LIEF     |LIEF     |LI_ans\nLI_str\nLI_plz LI_nort |                                   |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |20  |1001 10 |LKONTAKT |LIEF     |                               |LK_ans2\nLK_str2\nLK_plz2 LK_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |       |       |       |        |          |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |21  |1010 00 |LIEF     |LIEF     |LI_ans\nLI_str\nLI_plz LI_nort |                                   |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |22  |1010 10 |LKONTAKT |LIEF     |LK_ans\nLK_str\nLK_plz LK_nort |                                   |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |23  |1011 00 |LIEF     |LIEF     |LI_ans\nLI_str\nLI_plz LI_nort |                                   |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |24  |1011 10 |LKONTAKT |LIEF     |LK_ans\nLK_str\nLK_plz LK_nort |LK_ans2\nLK_str2\nLK_plz2 LK_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |        |        |        |         |          |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |25  |1100 00 |LIEF     |LIEF     |LI_ans\nLI_str\nLI_plz LI_nort |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |26  |1100 10 |LKONTAKT |LIEF     |                               |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |        |        |        |         |           |DEU       |
  |27  |1101 00 |LIEF     |LIEF     |LI_ans\nLI_str\nLI_plz LI_nort |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |28  |1101 10 |LKONTAKT |LIEF     |                               |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |       |       |       |        |          |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |29  |1110 00 |LIEF     |LIEF     |LI_ans\nLI_str\nLI_plz LI_nort |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |30  |1110 10 |LKONTAKT |LIEF     |LK_ans\nLK_str\nLK_plz LK_nort |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |        |        |        |         |           |DEU       |
  |31  |1111 00 |LIEF     |LIEF     |LI_ans\nLI_str\nLI_plz LI_nort |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  |32  |1111 10 |LKONTAKT |LIEF     |LK_ans\nLK_str\nLK_plz LK_nort |LI_ans2\nLI_str2\nLI_plz2 LI_nort2 |LI_ans |LI_str |LI_plz |LI_nort |BADEN    |DEU     |LI_ans2 |LI_str2 |LI_plz2 |LI_nort2 |BADEN     |DEU      |LK_ans |LK_str |LK_plz |LK_nort |BADEN     |DEU      |LK_ans2 |LK_str2 |LK_plz2 |LK_nort2 |BADEN      |DEU       |
  

@service
@EDL
Scenario: EDI einschalte - Ist fuer EDL Test Vorraussetzung
Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
# Nachfolgendes darf nicht zweimal auf ja gesetzt werden!
# And I set field "edi" to "ja"
And I set field "automotive" to "ja"
And I save the current editor

@service
@EDL
Scenario Outline: VK mit EDL: Uebernahme Versandadressen bei Kunden, Kundenkontakt
# Je nachdem ob Kunde oder Kundenkontakt im Feld Kunde oder Wahrenempfaenger 
# eingetragen ist und ob  sie eine Versandadresse besitzen wird diese in einem Lieferschein 
# als Versandadresse (Ablieferungsort - adresse2) belegt.
# Ausnahme bei VK-Lieferschein mit eingetragenem EDL (Externer Dienstleister). 
# Hier wird dessen Lieferadresse bevorzugt. Ist ein EDL eingetragen und dieser 
# besitzt keine Versandadresse, wird keine uebernommen.

#Hauptkunde anpassen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "KUNDE"
And I set field "such" to "KUNDE"
And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
And I set field "ans" to ""
And I set field "str" to ""
And I set field "plz" to ""
And I set field "nort" to ""
And I set field "region" to "BADEN"
And I set field "staat" to "DEU"
And I set field "ans2" to ""
And I set field "str2" to ""
And I set field "plz2" to ""
And I set field "nort2" to ""
And I set field "staat2" to "DEU"
And I set field "region2" to "BADEN"
And I save the current editor

# Kundenkontakt anpassen
Given I open an editor "kunde" from table "(Customer):(CustomerContact)" with command "STORE" for record "KKONTAKT"
And I set field "such" to "KKONTAKT"
And I set field "namebspr" to "Bayram Aussenlager, Niederbuehl"
And I set field "firma" to "KUNDE"
And I set field "ans" to "KK_ans"
And I set field "str" to "KK_str"
And I set field "plz" to "KK_plz"
And I set field "nort" to "KK_nort"
And I set field "staat" to "DEU"
And I set field "region" to "BADEN"
And I set field "ans2" to "KK_ans2"
And I set field "str2" to "KK_str2"
And I set field "plz2" to "KK_plz2"
And I set field "nort2" to "KK_nort2"
And I set field "staat2" to "DEU"
And I set field "region2" to "BADEN"
And I save the current editor

#EDL-Hauptkunde anpassen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "EDLKU"
And I set field "such" to "EDLKU"
And I set field "namebspr" to "ExService-Station, Rastatt"
And I set field "ans" to "<edlk_ans>"
And I set field "str" to "<edlk_str>"
And I set field "plz" to "<edlk_plz>"
And I set field "nort" to "<edlk_nort>"
And I set field "region" to "<edlk_region>"
And I set field "staat" to "<edlk_staat>"
And I set field "ans2" to "<edlk_ans2>"
And I set field "str2" to "<edlk_str2>"
And I set field "plz2" to "<edlk_plz2>"
And I set field "nort2" to "<edlk_nort2>"
And I set field "staat2" to "<edlk_staat2>"
And I set field "region2" to "<edlk_region2>"
And I save the current editor

# EDL-Kundenkontakt anpassen
Given I open an editor "kunde" from table "(Customer):(CustomerContact)" with command "STORE" for record "EDLKK"
And I set field "such" to "EDLKK"
And I set field "namebspr" to "ExService-Station, Muggensturm"
And I set field "firma" to "EDLKU"
And I set field "ans" to "<edlkk_ans>"
And I set field "str" to "<edlkk_str>"
And I set field "plz" to "<edlkk_plz>"
And I set field "nort" to "<edlkk_nort>"
And I set field "region" to "<edlkk_region>"
And I set field "staat" to "<edlkk_staat>"
And I set field "ans2" to "<edlkk_ans2>"
And I set field "str2" to "<edlkk_str2>"
And I set field "plz2" to "<edlkk_plz2>"
And I set field "nort2" to "<edlkk_nort2>"
And I set field "staat2" to "<edlkk_staat2>"
And I set field "region2" to "<edlkk_region2>"
And I save the current editor

# Lieferschein neu und Kombinationen zwischen Lieferant und Warenempfaenger testen
Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "KKONTAKT"
And I set field "kl2" to "KUNDE"
And I set field "edl" to "<edl>"
Then field "adresse" has value "<soll_adresse>"
Then field "adresse2" has value "<soll_adresse2>"
And I close the current editor


Examples:
# Nachfolgend werden die Kombinationen getestet. 
# Das Feld kombi ist zur Info und bedeutet folgendes:
# 1. Bit : Wenn 1, so ist beim EDL-Kunden eine Anschrift verwaltet
# 2. Bit : Wenn 1, so ist beim EDL-Kunden eine Versandanschrift verwaltet
# 3. Bit : Wenn 1, so ist beim EDL-Kundenkontakt eine Anschrift verwaltet
# 4. Bit : Wenn 1, so ist beim EDL-Kundenkontakt eine Versandanschrift verwaltet
# 5. Bit : Wenn 0, Externer Dienstleister ist EDL Kunde, Externer Dienstleister ist EDL Kundebkontakt

#                         Anschrift LS  Versandanschrift LS                             EDL-Kunde (Stammdaten) Anschrift                                      EDL-Kunde (Stammdaten Versandanschrift)                                     EDL-Kundenkontakt (Stammdaten) Anschrift                                EDL-Kundenkontakt (Stammdaten) Versandanschrift                                                                                                       
  |row |kombi  |edl      |soll_adresse                   |soll_adresse2                                  |edlk_ans  |edlk_str  |edlk_plz  |edlk_nort  |edlk_region |edlk_staat |edlk_ans2  |edlk_str2  |edlk_plz2  |edlk_nort2  |edlk_region2 |edlk_staat2 |edlkk_ans |edlkk_str |edlkk_plz |edlkk_nort |edlkk_region |edlkk_staat |edlkk_ans2 |edlkk_str2 |edlkk_plz2 |edlkk_nort2 |edlkk_region2 |edlkk_staat2 |
  |01  |0000 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |                                               |          |          |          |           |            |DEU        |           |           |           |            |             |DEU         |          |          |          |           |             |DEU         |           |           |           |            |              |DEU          |
  |02  |0000 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |                                               |          |          |          |           |            |DEU        |           |           |           |            |             |DEU         |          |          |          |           |             |DEU         |           |           |           |            |              |DEU          |
  |03  |0001 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |                                               |          |          |          |           |            |DEU        |           |           |           |            |             |DEU         |          |          |          |           |             |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |04  |0001 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans2\nEDLKK_str2\nEDLKK_plz2 EDLKK_nort2 |          |          |          |           |            |DEU        |           |           |           |            |             |DEU         |          |          |          |           |             |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |05  |0010 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |                                               |          |          |          |           |            |DEU        |           |           |           |            |             |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |           |           |           |            |              |DEU          |
  |06  |0010 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans\nEDLKK_str\nEDLKK_plz EDLKK_nort     |          |          |          |           |            |DEU        |           |           |           |            |             |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |           |           |           |            |              |DEU          |
  |07  |0011 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |                                               |          |          |          |           |            |DEU        |           |           |           |            |             |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |08  |0011 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans2\nEDLKK_str2\nEDLKK_plz2 EDLKK_nort2 |          |          |          |           |            |DEU        |           |           |           |            |             |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |09  |0100 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans2\nEDLKU_str2\nEDLKU_plz2 EDLKU_nort2 |          |          |          |           |            |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |          |          |          |           |             |DEU         |           |           |           |            |              |DEU          |
  |10  |0100 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |                                               |          |          |          |           |            |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |          |          |          |           |             |DEU         |           |           |           |            |              |DEU          |
  |11  |0101 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans2\nEDLKU_str2\nEDLKU_plz2 EDLKU_nort2 |          |          |          |           |            |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |          |          |          |           |             |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          | 
  |12  |0101 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans2\nEDLKK_str2\nEDLKK_plz2 EDLKK_nort2 |          |          |          |           |            |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |          |          |          |           |             |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          | 
  |13  |0110 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans2\nEDLKU_str2\nEDLKU_plz2 EDLKU_nort2 |          |          |          |           |            |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |           |           |           |            |              |DEU          |
  |14  |0110 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans\nEDLKK_str\nEDLKK_plz EDLKK_nort     |          |          |          |           |            |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |           |           |           |            |              |DEU          |
  |15  |0111 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans2\nEDLKU_str2\nEDLKU_plz2 EDLKU_nort2 |          |          |          |           |            |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |16  |0111 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans2\nEDLKK_str2\nEDLKK_plz2 EDLKK_nort2 |          |          |          |           |            |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |17  |1000 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans\nEDLKU_str\nEDLKU_plz EDLKU_nort     |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |           |           |           |            |             |DEU         |          |          |          |           |             |DEU         |           |           |           |            |              |DEU          |
  |18  |1000 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |                                               |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |           |           |           |            |             |DEU         |          |          |          |           |             |DEU         |           |           |           |            |              |DEU          |
  |19  |1001 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans\nEDLKU_str\nEDLKU_plz EDLKU_nort     |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |           |           |           |            |             |DEU         |          |          |          |           |             |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |20  |1001 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans2\nEDLKK_str2\nEDLKK_plz2 EDLKK_nort2 |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |           |           |           |            |             |DEU         |          |          |          |           |             |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |21  |1010 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans\nEDLKU_str\nEDLKU_plz EDLKU_nort     |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |           |           |           |            |             |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |           |           |           |            |              |DEU          |
  |22  |1010 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans\nEDLKK_str\nEDLKK_plz EDLKK_nort     |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |           |           |           |            |             |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |           |           |           |            |              |DEU          |
  |23  |1011 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans\nEDLKU_str\nEDLKU_plz EDLKU_nort     |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |           |           |           |            |             |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |24  |1011 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans2\nEDLKK_str2\nEDLKK_plz2 EDLKK_nort2 |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |           |           |           |            |             |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |25  |1100 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans2\nEDLKU_str2\nEDLKU_plz2 EDLKU_nort2 |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |          |          |          |           |             |DEU         |           |           |           |            |              |DEU          |
  |26  |1100 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |                                               |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |          |          |          |           |             |DEU         |           |           |           |            |              |DEU          |
  |27  |1101 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans2\nEDLKU_str2\nEDLKU_plz2 EDLKU_nort2 |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |          |          |          |           |             |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |28  |1101 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans2\nEDLKK_str2\nEDLKK_plz2 EDLKK_nort2 |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |          |          |          |           |             |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |29  |1110 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans2\nEDLKU_str2\nEDLKU_plz2 EDLKU_nort2 |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |           |           |           |            |              |DEU          |
  |30  |1110 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans\nEDLKK_str\nEDLKK_plz EDLKK_nort     |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |           |           |           |            |              |DEU          |
  |31  |1111 0 |EDLKU    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKU_ans2\nEDLKU_str2\nEDLKU_plz2 EDLKU_nort2 |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |
  |32  |1111 1 |EDLKK    |KK_ans\nKK_str\nKK_plz KK_nort |EDLKK_ans2\nEDLKK_str2\nEDLKK_plz2 EDLKK_nort2 |EDLKU_ans |EDLKU_str |EDLKU_plz |EDLKU_nort |BADEN       |DEU        |EDLKU_ans2 |EDLKU_str2 |EDLKU_plz2 |EDLKU_nort2 |BADEN        |DEU         |EDLKK_ans |EDLKK_str |EDLKK_plz |EDLKK_nort |BADEN        |DEU         |EDLKK_ans2 |EDLKK_str2 |EDLKK_plz2 |EDLKK_nort2 |BADEN         |DEU          |


