# *****************************************************************************
#  Name             : ref_op_umbu_1_last.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Zahlungseingang - Lastschriften, Test zu: REWE-3903, ...
#  ref              : ref_op_umbu_1_last_cu
# *******************************************************************************
@persistent
Feature: OPs umbuchen, Zahlungseingang - Lastschriften, Test zu: REWE-3903, ...

Background:
Given I set the fake date to "31.12.2022"

# ---------------------------------------------------------------------------------------------
Scenario: Test zu REWE-3903
# ---------------------------------------------------------------------------------------------
# 102:9 - (OIProcessing):(IncomingPaymentsDirectDebits)
Given I open an editor "ZaEin-LAST1" from table "102:9" with command "NEW" for record ""
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST1|
  |beldat     |01.05.2022|
  |kbudat     |01.05.2022|
  |gkonto     |14622|
Then fields have values
  |zasammelart|Sammelbuchungen|
  |zagr       |1000           |
  |kwaehr     |               |

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 110|RE1104|
  |+5  |K 110|RE1105|
And I press button "opladen"
Then the table has 5 rows

And I modify table
  |!row|opzabetr|ebeleg   |
  |1   |  100.00|REWE-3903|
  |2   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |5   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 9900.00|  100.00|1       |1         |1           |4              |
  |2   |K 110|RE1102|EUR   | 9900.00|  100.00|1       |1         |2           |4              |
  |3   |K 110|RE1103|EUR   | 9900.00|  100.00|1       |1         |3           |4              |
  |4   |K 110|RE1104|EUR   |10000.00|    0.00|0       |0         |0           |0              |
  |5   |K 110|RE1105|EUR   | 9900.00|  100.00|1       |1         |4           |4              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST2" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST2|
  |beldat     |02.05.2022|
  |kbudat     |02.05.2022|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 110|RE1104|
  |+5  |K 110|RE1105|
And I press button "opladen"
Then the table has 5 rows

And I modify table
  |!row|opzabetr|ebeleg   |
  |1   |  200.00|REWE-3903|
  |3   |  200.00|REWE-3903|
  |5   |  200.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 9700.00|  200.00|1       |1         |1           |3              |
  |2   |K 110|RE1102|EUR   | 9900.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 9700.00|  200.00|1       |1         |2           |3              |
  |4   |K 110|RE1104|EUR   |10000.00|    0.00|0       |0         |0           |0              |
  |5   |K 110|RE1105|EUR   | 9700.00|  200.00|1       |1         |3           |3              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST3" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST3|
  |beldat     |03.05.2022|
  |kbudat     |03.05.2022|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
And I press button "opladen"
Then the table has 2 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |2   |  300.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 9700.00|    0.00|0       |0         |0           |0              |
  |2   |K 110|RE1102|EUR   | 9600.00|  300.00|1       |1         |1           |1              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST4" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST4|
  |beldat     |04.05.2022|
  |kbudat     |04.05.2022|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
And I press button "opladen"
Then the table has 2 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  400.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 9300.00|  400.00|1       |1         |1           |1              |
  |2   |K 110|RE1102|EUR   | 9600.00|    0.00|0       |0         |0           |0              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST5" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST5|
  |beldat     |05.05.2022|
  |kbudat     |05.05.2022|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
And I press button "opladen"
Then the table has 3 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 9200.00|  100.00|1       |1         |1           |2              |
  |2   |K 110|RE1102|EUR   | 9600.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 9600.00|  100.00|1       |1         |2           |2              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST6" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST6|
  |beldat     |06.05.2022|
  |kbudat     |06.05.2022|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 110|RE1104|
And I press button "opladen"
Then the table has 4 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |4   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 9100.00|  100.00|1       |1         |1           |3              |
  |2   |K 110|RE1102|EUR   | 9600.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 9500.00|  100.00|1       |1         |2           |3              |
  |4   |K 110|RE1104|EUR   | 9900.00|  100.00|1       |1         |3           |3              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST7" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST7|
  |beldat     |07.05.2022|
  |kbudat     |07.05.2022|
  |lform      |true|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 150|RE1501|
And I press button "opladen"
Then the table has 4 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |4   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 9000.00|  100.00|1       |1         |1           |2              |
  |2   |K 110|RE1102|EUR   | 9600.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 9400.00|  100.00|1       |1         |2           |2              |
  |4   |K 150|RE1501|EUR   | 9900.00|  100.00|2       |2         |1           |1              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST8" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST8|
  |beldat     |08.05.2022|
  |kbudat     |08.05.2022|
  |lform      |true|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 150|RE1501|
And I press button "opladen"
Then the table has 4 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |2   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |4   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 9000.00|    0.00|0       |0         |0           |0              |
  |2   |K 110|RE1102|EUR   | 9500.00|  100.00|1       |1         |1           |2              |
  |3   |K 110|RE1103|EUR   | 9300.00|  100.00|1       |1         |2           |2              |
  |4   |K 150|RE1501|EUR   | 9800.00|  100.00|2       |2         |1           |1              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST9" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST9|
  |beldat     |09.05.2022|
  |kbudat     |09.05.2022|
  |lform      |true|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 110|RE1104|
  |+5  |K 150|RE1501|
And I press button "opladen"
Then the table has 5 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |5   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 8900.00|  100.00|1       |1         |1           |2              |
  |2   |K 110|RE1102|EUR   | 9500.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 9200.00|  100.00|1       |1         |2           |2              |
  |4   |K 110|RE1104|EUR   | 9900.00|    0.00|0       |0         |0           |0              |
  |5   |K 150|RE1501|EUR   | 9700.00|  100.00|2       |2         |1           |1              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST10" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST10|
  |beldat     |10.05.2022|
  |kbudat     |10.05.2022|
  |lform      |true|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

Then fields have values
  |zasammelart|Sammelbuchungen|
  |zagr       |1000           |
  |kwaehr     |               |

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 150|RE1501|
  |+5  |K 150|RE1502|
And I press button "opladen"
Then the table has 5 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |5   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 8800.00|  100.00|1       |1         |1           |2              |
  |2   |K 110|RE1102|EUR   | 9500.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 9100.00|  100.00|1       |1         |2           |2              |
  |4   |K 150|RE1501|EUR   | 9700.00|    0.00|0       |0         |0           |0              |
  |5   |K 150|RE1502|EUR   | 9900.00|  100.00|2       |2         |1           |1              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST11" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST11|
  |beldat     |11.05.2022|
  |kbudat     |11.05.2022|
  |lform      |true|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 150|RE1501|
  |+5  |K 150|RE1502|
And I press button "opladen"
Then the table has 5 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |4   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 8700.00|  100.00|1       |1         |1           |2              |
  |2   |K 110|RE1102|EUR   | 9500.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 9000.00|  100.00|1       |1         |2           |2              |
  |4   |K 150|RE1501|EUR   | 9600.00|  100.00|2       |2         |1           |1              |
  |5   |K 150|RE1502|EUR   | 9900.00|    0.00|0       |0         |0           |0              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST11-View" from table "102:9" with command "VIEW" for record from editor "ZaEin-LAST11"
Then the table has 3 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|ophistgko^such|
  |1   |K 110|RE1101|EUR   | 8700.00|  100.00|1       |1         |1           |2              |OPLAST11      |
  |2   |K 110|RE1103|EUR   | 9000.00|  100.00|1       |1         |2           |2              |OPLAST11      |
  |3   |K 150|RE1501|EUR   | 9600.00|  100.00|2       |2         |1           |1              |OPLAST11      |
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST12" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST12|
  |beldat     |12.05.2022|
  |kbudat     |12.05.2022|
  |lform      |true|
  |sform      | |
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 150|RE1501|
  |+5  |K 130|RE1301|
And I press button "opladen"
Then the table has 5 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |4   |  100.00|REWE-3903|
  |5   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 8600.00|  100.00|1       |1         |1           |2              |
  |2   |K 110|RE1102|EUR   | 9500.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 8900.00|  100.00|1       |1         |2           |2              |
  |4   |K 150|RE1501|EUR   | 9500.00|  100.00|2       |2         |1           |1              |
  |5   |K 130|RE1301|EUR   | 9900.00|  100.00|3       |3         |1           |1              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST12-View" from table "102:9" with command "VIEW" for record from editor "ZaEin-LAST12"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|ophistgko^such|
  |1   |K 110|RE1101|EUR   | 8600.00|  100.00|1       |1         |1           |2              |OPLAST12      |
  |2   |K 110|RE1103|EUR   | 8900.00|  100.00|1       |1         |2           |2              |OPLAST12      |
  |3   |K 150|RE1501|EUR   | 9500.00|  100.00|2       |2         |1           |1              |OPLAST12      |
  |4   |K 130|RE1301|EUR   | 9900.00|  100.00|3       |3         |1           |1              |OPLAST12      |
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST13" from table "102:9" with command "COPY" for record from editor "ZaEin-LAST1"
And I set fields
  |such       |REWE-3903|
  |beleg      |LAST13|
  |beldat     |13.08.2022|
  |kbudat     |13.08.2022|
  |sform      | |
  |lform      |true|
Then fields have values
  |gkonto     |14622|
  |zasammelart|Sammelbuchungen|

And I modify table
  |!row|konto|tbeleg|
  |+1  |K 110|RE1101|
  |+2  |K 110|RE1102|
  |+3  |K 110|RE1103|
  |+4  |K 150|RE1501|
  |+5  |K 130|RE1301|
And I press button "opladen"
Then the table has 5 rows

And I modify table
  |!row|opzabetr|ebeleg|
  |1   |  100.00|REWE-3903|
  |3   |  100.00|REWE-3903|
  |4   |  100.00|REWE-3903|
  |5   |  100.00|REWE-3903|
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 8500.00|  100.00|1       |1         |1           |2              |
  |2   |K 110|RE1102|EUR   | 9500.00|    0.00|0       |0         |0           |0              |
  |3   |K 110|RE1103|EUR   | 8800.00|  100.00|1       |1         |2           |2              |
  |4   |K 150|RE1501|EUR   | 9400.00|  100.00|2       |2         |1           |1              |
  |5   |K 130|RE1301|EUR   | 9800.00|  100.00|3       |3         |1           |1              |

And I press button "nichtrelloesch"
And I press button "sammlerdatenakt"
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|
  |1   |K 110|RE1101|EUR   | 8500.00|  100.00|1       |1         |1           |2              |
  |2   |K 110|RE1103|EUR   | 8800.00|  100.00|1       |1         |2           |2              |
  |3   |K 150|RE1501|EUR   | 9400.00|  100.00|2       |2         |1           |1              |
  |4   |K 130|RE1301|EUR   | 9800.00|  100.00|3       |3         |1           |1              |

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# -------------------------
Given I open an editor "ZaEin-LAST13-View" from table "102:9" with command "VIEW" for record from editor "ZaEin-LAST13"
Then the table has 4 rows
Then table has values
  |!row|konto|tbeleg|twaehr|  ofbetr|opzabetr|opgkolnr|sammlerlnr|sammleroplnr|sammleropanzahl|ophistgko^such|
  |1   |K 110|RE1101|EUR   | 8500.00|  100.00|1       |1         |1           |2              |OPLAST13      |
  |2   |K 110|RE1103|EUR   | 8800.00|  100.00|1       |1         |2           |2              |OPLAST13      |
  |3   |K 150|RE1501|EUR   | 9400.00|  100.00|2       |2         |1           |1              |OPLAST13      |
  |4   |K 130|RE1301|EUR   | 9800.00|  100.00|3       |3         |1           |1              |OPLAST13      |
And I close the current editor
