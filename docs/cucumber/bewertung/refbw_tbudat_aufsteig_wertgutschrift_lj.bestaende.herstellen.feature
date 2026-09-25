# *****************************************************************************
#  Verantwortlich   : uo
# *****************************************************************************
# DIESE DATEI LÄUFT NICHT EIGENSTÄNDIG SONDERN WIRD AM ENDE AN EINE FEATUREDATEI
# ANGEHÄNGT. DESHALB SIND DIE KOPFEIGENSCHAFTEN HIER AUSKOMMENTIERT/NICHT VORHANDEN!
 
# FUNKION: fehlende lagerbestände für abgänge in MPS-testquellen NACHTRÄGLICH bereitstellen, 
#          damit nach dem nachbewerten bew-origs und preise vorhanden sind und 
#          gebucht werden kann. siehe verwendung dieser datei, um den konkreten test
#          zu sehen..


Scenario Outline: Lagerzugänge für Fehlbestände buchen 
# -------------------------------------------------------
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | 03        |
    | beldat  | .         |
    | wert    | <wert> |
And I append rows
    | platz2   | mge   | verw   | charge2   | projekt   |
    | <platz2> | 1000  | <verw> | <charge2> | <projekt> |
And I save the current editor

Examples: Lagerzugang
| artikel   |platz2| wert | verw        | charge2       | projekt      |
| VK11      | F1   |   11 | !dontChange | !dontChange   | !dontChange  |
| VK22      | F1   |   22 | !dontChange | !dontChange   | !dontChange  |
| VK23      | F1   |   23 | !dontChange | !dontChange   | !dontChange  |

#  bestand für VK24 wird bereist im ursprungsskript bereitgestellt, um eventuelle Unterschiede in Bew. zu erkennen..
#  | VK24      | F1   |   24 | !dontChange | !dontChange   | !dontChange  |

| VK25      | F1   |   25 | !dontChange | !dontChange   | !dontChange  |
| VK26      | F1   |   26 | !dontChange | !dontChange   | !dontChange  |
| VK27      | F1   |   27 | !dontChange | !dontChange   | !dontChange  |
| EINK      | F1   |    8 | !dontChange | !dontChange   | !dontChange  |
| BAUT      |   F2 |   16 | !dontChange | !dontChange   | !dontChange  |
| VK29      | F1   |   29 | !dontChange | !dontChange   | !dontChange  |
|   E3      |   F2 |    3 | !dontChange | !dontChange   | !dontChange  |
| VK31      | F1   |   31 | !dontChange | !dontChange   | !dontChange  |
| VK32      | F1   |   32 | !dontChange | !dontChange   | !dontChange  |
| VK33      | F1   |   33 | !dontChange | !dontChange   | !dontChange  |
| VK34      | F1   |   34 | !dontChange | !dontChange   | !dontChange  |
| VK35      | F1   |   35 | !dontChange | !dontChange   | !dontChange  |
| TEST      |   F2 |    5 | !dontChange | !dontChange   | !dontChange  |
| VK37      | F1   |   37 | !dontChange | !dontChange   | !dontChange  |
| VK38      | F1   |   38 | !dontChange | !dontChange   | !dontChange  |
| VK39      | F1   |   39 | !dontChange | !dontChange   | !dontChange  |
| EKSET40   | F1   |   40 | !dontChange | !dontChange   | !dontChange  |


Scenario: revalue + costentries
# ------------------------------
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01.1996" until enddate "." with Command Revalue
