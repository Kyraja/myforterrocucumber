# *****************************************************************************
#  Name             : ref_op_umbu_1_sonstein.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Zahlungseingang - Sonstige Zahlungen, Test zu: REWE-3902, ...
#  ref              : ref_op_umbu_1_sonstein_cu
# *******************************************************************************
@persistent
Feature: OPs umbuchen, Zahlungseingang - Sonstige Zahlungen, Test zu: REWE-3902, ...

Background:
Given I set the fake date to "31.12.2022"

# ---------------------------------------------------------------------------------------------
Scenario: Test zu REWE-3902, Negative Sammelbeträge NICHT erlaubt (sammnegativ default false aus ZVKonfig)
# ---------------------------------------------------------------------------------------------
# 102:3 - (OIProcessing):(OtherPayments)
Given I open an editor "ZaEin-SONST1" from table "102:3" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |zaeinaus   |Zahlungseingang|
  |beleg      |SONST1|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14673|
Then fields have values
  |sammnegativ|nein|
  |zasammelart|Sammelbuchungen und Sammel-OP|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 130|RE1301|
  |+2  |K 130|RE1302|
  |+3  |K 150|RE1501|
  |+4  |K 150|RE1502|
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
  |1   |K 130|RE1301|EUR   | 9900.00|  100.00|Haben|       1|    2000.00|Soll   |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10100.00| -100.00|Haben|       1|    2000.00|Soll   |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 9000.00| 1000.00|Haben|       1|    2000.00|Soll   |         2|      2000.00|Haben    |
  |4   |K 150|RE1502|EUR   | 9000.00| 1000.00|Haben|       1|    2000.00|Soll   |         2|      2000.00|Haben    |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST1-View" from table "102:3" with command "VIEW" for record from editor "ZaEin-SONST1"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such|buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |K 130|RE1301|EUR   | 9900.00|  100.00|Haben|SONST1         |       1|    2000.00|Soll   |        |SONST1       |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10100.00| -100.00|Haben|SONST1         |       1|    2000.00|Soll   |        |SONST1       |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 9000.00| 1000.00|Haben|SONST1         |       1|    2000.00|Soll   |XSONST1 |SONST1       |         2|      2000.00|Haben    |
  |4   |K 150|RE1502|EUR   | 9000.00| 1000.00|Haben|SONST1         |       1|    2000.00|Soll   |XSONST1 |SONST1       |         2|      2000.00|Haben    |
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST2" from table "102:3" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |zaeinaus   |Zahlungseingang|
  |beleg      |SONST2|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14673|
Then fields have values
  |sammnegativ|nein|
  |zasammelart|Sammelbuchungen und Sammel-OP|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 130|RE1301|
  |+2  |K 130|RE1302|
  |+3  |K 150|RE1501|
  |+4  |K 150|RE1502|
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
  |1   |K 130|RE1301|EUR   |10000.00| -100.00|Haben|       1|       0.00|Soll   |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10000.00|  100.00|Haben|       1|       0.00|Soll   |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 8900.00|  100.00|Haben|       1|       0.00|Soll   |         2|         0.00|Haben    |
  |4   |K 150|RE1502|EUR   | 9100.00| -100.00|Haben|       1|       0.00|Soll   |         2|         0.00|Haben    |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST2-View" from table "102:3" with command "VIEW" for record from editor "ZaEin-SONST2"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such|buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |K 130|RE1301|EUR   |10000.00| -100.00|Haben|               |       1|       0.00|Soll   |        |SONST2       |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10000.00|  100.00|Haben|               |       1|       0.00|Soll   |        |SONST2       |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 8900.00|  100.00|Haben|               |       1|       0.00|Soll   |        |SONST2       |         2|         0.00|Haben    |
  |4   |K 150|RE1502|EUR   | 9100.00| -100.00|Haben|               |       1|       0.00|Soll   |        |SONST2       |         2|         0.00|Haben    |
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST3" from table "102:3" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |zaeinaus   |Zahlungseingang|
  |beleg      |SONST3|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14672|
Then fields have values
  |sammnegativ|nein|
  |zasammelart|Sammelbuchungen|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 130|RE1301|
  |+2  |K 130|RE1302|
  |+3  |K 150|RE1501|
  |+4  |K 150|RE1502|
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
  |1   |K 130|RE1301|EUR   | 9900.00|  100.00|Haben|       1|       0.00|Soll   |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10100.00| -100.00|Haben|       1|       0.00|Soll   |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 7900.00| 1000.00|Haben|       2|    2000.00|Soll   |         2|      2000.00|Haben    |
  |4   |K 150|RE1502|EUR   | 8100.00| 1000.00|Haben|       2|    2000.00|Soll   |         2|      2000.00|Haben    |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST3-View" from table "102:3" with command "VIEW" for record from editor "ZaEin-SONST3"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such|buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |K 130|RE1301|EUR   | 9900.00|  100.00|Haben|               |       1|       0.00|Soll   |        |SONST3       |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10100.00| -100.00|Haben|               |       1|       0.00|Soll   |        |SONST3       |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 7900.00| 1000.00|Haben|SONST3         |       2|    2000.00|Soll   |XSONST3 |SONST3       |         2|      2000.00|Haben    |
  |4   |K 150|RE1502|EUR   | 8100.00| 1000.00|Haben|SONST3         |       2|    2000.00|Soll   |XSONST3 |SONST3       |         2|      2000.00|Haben    |
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Test zu REWE-3902, Negative Sammelbeträge erlaubt (sammnegativ true)
# ---------------------------------------------------------------------------------------------
# 102:3 - (OIProcessing):(OtherPayments)
Given I open an editor "ZaEin-SONST4" from table "102:3" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |zaeinaus   |Zahlungseingang|
  |beleg      |SONST4|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14673|
  |sammnegativ|ja|
Then fields have values
  |zasammelart|Sammelbuchungen und Sammel-OP|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 130|RE1301|
  |+2  |K 130|RE1302|
  |+3  |K 150|RE1501|
  |+4  |K 150|RE1502|
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
  |1   |K 130|RE1301|EUR   | 9800.00|  100.00|Haben|       1|    2000.00|Soll   |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10200.00| -100.00|Haben|       1|    2000.00|Soll   |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 6900.00| 1000.00|Haben|       1|    2000.00|Soll   |         2|      2000.00|Haben    |
  |4   |K 150|RE1502|EUR   | 7100.00| 1000.00|Haben|       1|    2000.00|Soll   |         2|      2000.00|Haben    |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST4-View" from table "102:3" with command "VIEW" for record from editor "ZaEin-SONST4"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such|buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |K 130|RE1301|EUR   | 9800.00|  100.00|Haben|SONST4         |       1|    2000.00|Soll   |XSONST4 |SONST4       |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10200.00| -100.00|Haben|SONST4         |       1|    2000.00|Soll   |XSONST4 |SONST4       |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 6900.00| 1000.00|Haben|SONST4         |       1|    2000.00|Soll   |XSONST4 |SONST4       |         2|      2000.00|Haben    |
  |4   |K 150|RE1502|EUR   | 7100.00| 1000.00|Haben|SONST4         |       1|    2000.00|Soll   |XSONST4 |SONST4       |         2|      2000.00|Haben    |
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST5" from table "102:3" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |zaeinaus   |Zahlungseingang|
  |beleg      |SONST5|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14673|
  |sammnegativ|ja|
Then fields have values
  |zasammelart|Sammelbuchungen und Sammel-OP|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 130|RE1301|
  |+2  |K 130|RE1302|
  |+3  |K 150|RE1501|
  |+4  |K 150|RE1502|
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
  |1   |K 130|RE1301|EUR   | 9900.00| -100.00|Haben|       1|       0.00|Soll   |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10100.00|  100.00|Haben|       1|       0.00|Soll   |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 6800.00|  100.00|Haben|       1|       0.00|Soll   |         2|         0.00|Haben    |
  |4   |K 150|RE1502|EUR   | 7200.00| -100.00|Haben|       1|       0.00|Soll   |         2|         0.00|Haben    |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST5-View" from table "102:3" with command "VIEW" for record from editor "ZaEin-SONST5"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such|buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |K 130|RE1301|EUR   | 9900.00| -100.00|Haben|               |       1|       0.00|Soll   |XSONST5 |SONST5       |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10100.00|  100.00|Haben|               |       1|       0.00|Soll   |XSONST5 |SONST5       |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 6800.00|  100.00|Haben|               |       1|       0.00|Soll   |XSONST5 |SONST5       |         2|         0.00|Haben    |
  |4   |K 150|RE1502|EUR   | 7200.00| -100.00|Haben|               |       1|       0.00|Soll   |XSONST5 |SONST5       |         2|         0.00|Haben    |
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST6" from table "102:3" with command "NEW" for record ""
And I set fields
  |such       |REWE-3902|
  |zaeinaus   |Zahlungseingang|
  |beleg      |SONST6|
  |beldat     |01.07.2022|
  |kbudat     |01.07.2022|
  |gkonto     |14672|
    |sammnegativ|ja|
Then fields have values
  |zasammelart|Sammelbuchungen|
  |zagr       |1000|
  |kwaehr     |    |

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 130|RE1301|
  |+2  |K 130|RE1302|
  |+3  |K 150|RE1501|
  |+4  |K 150|RE1502|
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
  |1   |K 130|RE1301|EUR   | 9800.00|  100.00|Haben|       1|       0.00|Soll   |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10200.00| -100.00|Haben|       1|       0.00|Soll   |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 5800.00| 1000.00|Haben|       2|    2000.00|Soll   |         2|      2000.00|Haben    |
  |4   |K 150|RE1502|EUR   | 6200.00| 1000.00|Haben|       2|    2000.00|Soll   |         2|      2000.00|Haben    |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-SONST6-View" from table "102:3" with command "VIEW" for record from editor "ZaEin-SONST6"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|sha  |ophistgko^beleg|opgkolnr|opgkobubetr|opgkosh|ztr^such|buchung^beleg|sammlerlnr|sammlerbubetr|sammlersh|
  |1   |K 130|RE1301|EUR   | 9800.00|  100.00|Haben|               |       1|       0.00|Soll   |XSONST6 |SONST6       |         1|         0.00|Haben    |
  |2   |K 130|RE1302|EUR   |10200.00| -100.00|Haben|               |       1|       0.00|Soll   |XSONST6 |SONST6       |         1|         0.00|Haben    |
  |3   |K 150|RE1501|EUR   | 5800.00| 1000.00|Haben|SONST6         |       2|    2000.00|Soll   |XSONST6 |SONST6       |         2|      2000.00|Haben    |
  |4   |K 150|RE1502|EUR   | 6200.00| 1000.00|Haben|SONST6         |       2|    2000.00|Soll   |XSONST6 |SONST6       |         2|      2000.00|Haben    |
And I close the current editor
