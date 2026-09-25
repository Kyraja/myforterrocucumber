Feature: taztest

  Background:
  And I set the fake date to "02.01.1995"

# **********************************************************************************
#  Name             : taztest.feature
#  Autor            : pw
#  Verantwortlich   : foe
#  Kontrolle        : ba
#  Funktion         : Test von Einheiten / Art TAZ
#
#  Beschreibung     :
#
#  Testziel         : Es soll sichergestellt werden, dass TAZ-Variablen in Masken
#                     funktionieren. Dazu werden TAZ-Felder im Arbeitsgang und
#                     Teilestamm gefüllt und die Werte geprüft.
#
#  Testablauf:        Scenario: 1. Ersatzeinheit "Stück" für Einheit . eintragen
#                     Scenario: 2. Standardeinheit in Artikel-Konfiguration auf "Palett" setzen
#                     Scenario: 3. Arbeitsgang anlegen
#                     Scenario: 4. Artikel anlegen
#                     Scenario: 5. Lagerbuchung absetzen
#                     Scenario: 6. Arten TAZ1 - TAZ7 mit Einheit "Palett" testen
#                     Scenario: 7. FOP mit Einheiteneingabe in verschiedenen Varianten
#                     Scenario: 8. Eingabe von Einheiten, die nicht erlaubt sind
#
# **********************************************************************************

  Scenario: 1. Ersatzeinheit Stueck für Einheit . eintragen

  Given I open an editor "EinheitLZ" from table "(Unit):(Unit)" with command "UPDATE" for record "LZ"
  And I set field "ersatzeinheit" to "Stück"
  And I save the current editor
  Then field "ersatzeinheit" has value "STUECK" in row 0
  And I close the current editor

  Scenario: 2. Standardeinheit in Artikel-Konfiguration auf Palett setzen

  Given I open an editor "ArtKonf_STD_PRODUCTCONF" from table "(Part):(ProductConfiguration)" with command "UPDATE" for record "STD_PRODUCTCONF"
  And I set field "stdeinheit" to "palett"
  And I save the current editor
  Then field "stdeinheit" has value "Palett" in row 0
  And I close the current editor

  Scenario: 3. Arbeitsgang anlegen

  Given I open an editor "Arbeitsgang" from table "(Operation):(Operation)" with command "NEW" for record ""
  And I set field "nummer" to "0ehag"
  Then field "ze" has value "min" in row 0
  Then field "zr" has value "min" in row 0
  And I set field "such" to "EHAG"
  And I set field "aschein" to "ja"
  And I save the current editor
  And I close the current editor

  Scenario: 4. Artikel anlegen

  Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
  And I set field "nummer" to "0ehart"
  And I create a new row at the end of the table
  And I set field "elex" to "E1" in row 1
  Then field "bme" has value "mm" in row 0
  Then field "ehe" has value "Palett" in row 0
  Then field "epe" has value "Palett" in row 0
  Then field "ge" has value "Palett" in row 0
  Then field "kbprpe" has value "Palett" in row 0
  Then field "le" has value "Palett" in row 0
  Then field "lme" has value "mm" in row 0
  Then field "ve" has value "Palett" in row 0
  Then field "vhe" has value "Palett" in row 0
  Then field "vpe" has value "Palett" in row 0
  Then field "elle" has value "m²" in row 1
  And I set field "such" to "EHARTIKEL"
  And I set field "name" to "EHARTIKEL"
  And I set field "zuplatz" to "f1"
  And I set field "abplatz" to "f1"
  And I set field "bsart" to "Eigenf"
  And I set field "dispo" to "V"
  And I set field "le" to "Palett"
  And I set field "gebvhe" to "j"
  And I set field "vhe" to "x974"
  And I set field "gebve" to "j"
  And I set field "ve" to "Karton"
  And I set field "gebge" to "j"
  And I set field "ge" to "x972"
  And I set field "elex" to "TEST" in row 1
  And I set field "elanzahl" to "1" in row 1
  And I create a new row at the end of the table
  And I set field "elex" to "A EHAG" in row 2
  And I set field "elanzahl" to "1" in row 2
  And I save the current editor
  And I close the current editor

  Scenario: 5. Lagerbuchung absetzen
  Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
  And I set fields
  | artikel  | 0ehart  |
  | buart    | zugang  |
  | beleg    | m1      |
  | beldat   | .       |
  And I delete all rows
  And I append rows
  | mge |          ze | verw |
  |   1 |         pal |    1 |
  |   3 |          ka |    1 |
  |   6 | !dontChange |    1 |
  |   9 |        x974 |    1 |

  Then field "le" has value "Palett" in row 0
  Then field "le" has value "Palett" in row 1
  Then field "ze" has value "Palett" in row 1
  Then field "ze2" has value "Palett" in row 1
  Then field "le" has value "Palett" in row 2
  Then field "ze" has value "Karton" in row 2
  Then field "ze2" has value "Karton" in row 2
  Then field "le" has value "Palett" in row 3
  Then field "ze" has value "Palett" in row 3
  Then field "ze2" has value "Palett" in row 3
  Then field "le" has value "Palett" in row 4
  Then field "ze" has value "x974" in row 4
  Then field "ze2" has value "x974" in row 4
  And I save the current editor
  And I close the current editor

  Given I query "nummer,zuord,le,me,mge" from table "(Journal):(Journal)" where "@ordnung=zuord"
  Then query has values
  | nummer        | zuord |     le |     me | mge |
  | 0ehart-150102 |     1 | Palett | Palett | 1   |
  | 0ehart-150102 |     2 | Palett | Karton | 0.6 |
  | 0ehart-150102 |     3 | Palett | Palett | 6   |
  | 0ehart-150102 |     4 | Palett |   x974 | 9   |

  Scenario: 6. Arten TAZ1 - TAZ7 mit Einheit "Palett" testen

  Given I execute FOP "TAZTEST1.FOP"
  Given I execute FOP "TAZTEST2.FOP"
  And executing FOP "TAZTEST3.FOP" throws the exception "x1: unzulässige Angabe: Kann nicht schreiben"
  And executing FOP "TAZTEST4.FOP" throws the exception "x1: unzulässige Angabe: Kann nicht schreiben"
  And executing FOP "TAZTEST5.FOP" throws the exception "x1: unzulässige Angabe: Kann nicht schreiben"
  And executing FOP "TAZTEST6.FOP" throws the exception "x1: unzulässige Angabe: Kann nicht schreiben"
  And executing FOP "TAZTEST7.FOP" throws the exception "x1: unzulässige Angabe: Kann nicht schreiben"

  Scenario: 7. FOP mit Einheiteneingabe in verschiedenen Varianten

  Given I open an editor "Einheit_KG" from table "(Unit):(Unit)" with command "UPDATE" for record "KGM"
  And I set fields
  | einheit10 | Ende |
  | einheit11 | XXX  |
  | reosofort | ja  |
  And I save the current editor
  And I close the current editor

  Given I execute FOP "TAZTEST.ZUWEIS.FOP"

  Scenario: 8. Eingabe von Einheiten, die nicht erlaubt sind

  Given I open an editor "Artikel700" from table "(Part):(Product)" with command "NEW" for record ""
  And I set fields
  | nummer | 700    |
  | such   | Platte |
  | bsart  | e      |
  And I save the current editor
  And I close the current editor

  Given I open an editor "SalesOrder" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
  And I set fields
  | nummer | 700    |
  | kunde  | 1      |
  And I append rows
  | artikel | mge | kalk |
  |     700 |   1 |   ja |
  And I save the current editor
  And I close the current editor
  Given I open an editor "SalesOrder" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "700"
  And I set field "he" to "P" in row 1
  Then setting field "he" to "Stück" in row 1 throws the exception "Stück: unzulässige Angabe"
  Then setting field "he" to "m" in row 1 throws the exception "m: unzulässige Angabe"
  Then setting field "he" to "kg" in row 1 throws the exception "kg: unzulässige Angabe"
  And I set field "he" to "palett" in row 1
  And I save the current editor
  And I close the current editor
