# *****************************************************************************
#  Name           : rahmen_perf_ls.feature
#  Autor          : as
#  Verantwortlich : teampss
#  Funktion       : Testet das Anlegen von Lieferscheinen mit vielen Positionen
#                   und Rahmenauftragsbezug.
#
# *****************************************************************************
#
Feature: RahmenauftaegePerformance
Background:
Given I set the fake date to "02.01.1995"

Scenario Outline: Artikel anlegen

Given I open an editor "TE<id>" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
   | such | V1<id>             |
   | name | Verkaufsteil 1<id> |
And I save the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |

Scenario Outline: Rahmenauftraege anlegen

Given I open an editor "RA2<id>" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
   | kunde | 1       |
   | such  | RA2<id> |
And I append rows
   | artikel | mge   |
   | V1<id>  | 10000 |
And I save the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |

Scenario Outline: Abrufe anlegen

Given I open an editor "LS200<id>" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde         | 1         |
   | such          | LS200<id> |
   | ueb           | ja        |
   | wertaktspeich | ja        |
And I append rows
                  | artikel | mge |
#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |
And I save the current editor

Examples:
                | id   |
#LOOP 1 to 1    | #id# |
                | 1    |

Scenario: Grossen Lieferschein anlegen

Given I open an editor "LS2000" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde | 1      |
   | such  | LS2000 |
And I append rows
                  | artikel | mge |
#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |

#LOOP_POS 1 to 1  | V1#id#  | 1   |
And I save the current editor

Scenario: Lieferschein aendern, Mengen nochmals eintragen

# Bei nochmaliger Eingabe der Menge (ohne Aenderung) erfolgt keine Aktualisierung des Rahemenauftragsstatus
Given I open an editor "LS2000" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS2000"
And I modify table
                  | !row  | mge |
#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 1   |
And I close the current editor

Scenario: Lieferschein aendern, wertaktspeich = ja setzen

# Bei Mengenaenderung und wertaktspeich = ja erfolgt keine Aktualisierung des Rahemenauftragsstatus
Given I open an editor "LS2000" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS2000"
And I set field "wertaktspeich" to "ja"
And I modify table
                  | !row  | mge |
#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |

#LOOP_POS 1 to 1  | #id#  | 2   |

#LOOP_POS 1 to 1  | #id#  | 1   |
And I close the current editor
