# *****************************************************************************
#  Name             : ref_op_umbu_1_ueberw.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Zahlungsausgang - Sonstige Zahlungen, Test zu: REWE-3902, ...
#  ref              : ref_op_umbu_1_ueberw_cu
# *******************************************************************************
@persistent
Feature: OPs umbuchen, Zahlungsausgang - Banküberweisungen, Test zu: REWE-3902, ...

Background:
Given I set the fake date to "31.12.2022"

# ---------------------------------------------------------------------------------------------
Scenario: Test zu REWE-3902
# ---------------------------------------------------------------------------------------------
# 102:1 - (OIProcessing):(OutgoingPaymentsBankTransfers)
Given I open an editor "ZaAus-UEBERW1" from table "102:1" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |beleg      |UEBERW1|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14613|
Then fields have values
  |zasammelart|Sammelbuchungen und Sammel-OP|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |L 510|RE5101|
  |+2  |L 510|RE5102|
  |+3  |L 550|RE5501|
  |+4  |L 550|RE5502|
And I press button "opladen"
Then the table has 4 rows

And I modify table
  |!row|opzabetr|ebeleg   |
  |1   |  100.00|REWE-3902|
  |2   | -100.00|REWE-3902|
  |3   | 1000.00|REWE-3902|
  |4   | 1000.00|REWE-3902|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha |opgkolnr|opgkobubetr|opgkosh|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |L 510|RE5101|EUR   | 9900.00|  100.00|Soll|       1|    2000.00|Haben  |         1|         0.00|Soll     |
  |2   |L 510|RE5102|EUR   |10100.00| -100.00|Soll|       1|    2000.00|Haben  |         1|         0.00|Soll     |
  |3   |L 550|RE5501|EUR   | 9000.00| 1000.00|Soll|       1|    2000.00|Haben  |         2|      2000.00|Soll     |
  |4   |L 550|RE5502|EUR   | 9000.00| 1000.00|Soll|       1|    2000.00|Haben  |         2|      2000.00|Soll     |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaAus-UEBERW1-View" from table "102:1" with command "VIEW" for record from editor "ZaAus-UEBERW1"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such |buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |L 510|RE5101|EUR   | 9900.00|  100.00|Soll |UEBERW1         |       1|    2000.00|Haben  |        |UEBERW1       |         1|         0.00|Soll     |
  |2   |L 510|RE5102|EUR   |10100.00| -100.00|Soll |UEBERW1         |       1|    2000.00|Haben  |        |UEBERW1       |         1|         0.00|Soll     |
  |3   |L 550|RE5501|EUR   | 9000.00| 1000.00|Soll |UEBERW1         |       1|    2000.00|Haben  |XUEBERW1|UEBERW1       |         2|      2000.00|Soll     |
  |4   |L 550|RE5502|EUR   | 9000.00| 1000.00|Soll |UEBERW1         |       1|    2000.00|Haben  |XUEBERW1|UEBERW1       |         2|      2000.00|Soll     |
And I close the current editor

# -------------------------
Given I open an editor "ZaAus-UEBERW2" from table "102:1" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |beleg      |UEBERW2|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14613|
Then fields have values
  |zasammelart|Sammelbuchungen und Sammel-OP|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |L 510|RE5101|
  |+2  |L 510|RE5102|
  |+3  |L 550|RE5501|
  |+4  |L 550|RE5502|
And I press button "opladen"
Then the table has 4 rows

And I modify table
  |!row|opzabetr|ebeleg   |
  |1   | -100.00|REWE-3902|
  |2   |  100.00|REWE-3902|
  |3   |  100.00|REWE-3902|
  |4   | -100.00|REWE-3902|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |opgkolnr|opgkobubetr|opgkosh|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |L 510|RE5101|EUR   |10000.00| -100.00|Soll |       1|       0.00|Haben  |         1|         0.00|Soll     |
  |2   |L 510|RE5102|EUR   |10000.00|  100.00|Soll |       1|       0.00|Haben  |         1|         0.00|Soll     |
  |3   |L 550|RE5501|EUR   | 8900.00|  100.00|Soll |       1|       0.00|Haben  |         2|         0.00|Soll     |
  |4   |L 550|RE5502|EUR   | 9100.00| -100.00|Soll |       1|       0.00|Haben  |         2|         0.00|Soll     |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaAus-UEBERW2-View" from table "102:1" with command "VIEW" for record from editor "ZaAus-UEBERW2"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such|buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |L 510|RE5101|EUR   |10000.00| -100.00|Soll |               |       1|       0.00|Haben  |        |UEBERW2       |         1|         0.00|Soll     |
  |2   |L 510|RE5102|EUR   |10000.00|  100.00|Soll |               |       1|       0.00|Haben  |        |UEBERW2       |         1|         0.00|Soll     |
  |3   |L 550|RE5501|EUR   | 8900.00|  100.00|Soll |               |       1|       0.00|Haben  |        |UEBERW2       |         2|         0.00|Soll     |
  |4   |L 550|RE5502|EUR   | 9100.00| -100.00|Soll |               |       1|       0.00|Haben  |        |UEBERW2       |         2|         0.00|Soll     |
And I close the current editor

# -------------------------
Given I open an editor "ZaAus-UEBERW3" from table "102:1" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |beleg      |UEBERW3|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14612|
Then fields have values
  |zasammelart|Sammelbuchungen|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |L 510|RE5101|
  |+2  |L 510|RE5102|
  |+3  |L 550|RE5501|
  |+4  |L 550|RE5502|
And I press button "opladen"
Then the table has 4 rows

And I modify table
  |!row|opzabetr|ebeleg   |
  |1   |  100.00|REWE-3902|
  |2   | -100.00|REWE-3902|
  |3   | 1000.00|REWE-3902|
  |4   | 1000.00|REWE-3902|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |opgkolnr|opgkobubetr|opgkosh|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |L 510|RE5101|EUR   | 9900.00|  100.00|Soll |       1|       0.00|Haben  |         1|         0.00|Soll     |
  |2   |L 510|RE5102|EUR   |10100.00| -100.00|Soll |       1|       0.00|Haben  |         1|         0.00|Soll     |
  |3   |L 550|RE5501|EUR   | 7900.00| 1000.00|Soll |       2|    2000.00|Haben  |         2|      2000.00|Soll     |
  |4   |L 550|RE5502|EUR   | 8100.00| 1000.00|Soll |       2|    2000.00|Haben  |         2|      2000.00|Soll     |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaAus-UEBERW3-View" from table "102:1" with command "VIEW" for record from editor "ZaAus-UEBERW3"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such|buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |L 510|RE5101|EUR   | 9900.00|  100.00|Soll |               |       1|       0.00|Haben  |        |UEBERW3      |         1|         0.00|Soll     |
  |2   |L 510|RE5102|EUR   |10100.00| -100.00|Soll |               |       1|       0.00|Haben  |        |UEBERW3      |         1|         0.00|Soll     |
  |3   |L 550|RE5501|EUR   | 7900.00| 1000.00|Soll |UEBERW3        |       2|    2000.00|Haben  |XUEBERW3|UEBERW3      |         2|      2000.00|Soll     |
  |4   |L 550|RE5502|EUR   | 8100.00| 1000.00|Soll |UEBERW3        |       2|    2000.00|Haben  |XUEBERW3|UEBERW3      |         2|      2000.00|Soll     |
And I close the current editor
