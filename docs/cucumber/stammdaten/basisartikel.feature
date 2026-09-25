@persistent
Feature: basisartikel.feature

  Background:
    And I set the fake date to "02.01.95"
    Given I enable the flag 39
# Achtung, in Scenario: Infosystem LMB kann alle Versionen bei Vorschlag berücksichtigen wird das Fake Date auf April gesetzt



# *****************************************************************************
#  Name             : basisartikel.feature
#  Autor            : bschiga
#  Verantwortlich   : drpf
#  Kontrolle        : lbettendorf
#  Funktion         : Grundfunktionen und Plausis zu Basisartikel und Versionen
#  ref                      : ref_basisartikel_cu
#  Stammdaten            : basis_stammdaten.feature
#
# *****************************************************************************

  Scenario: Versionsnummernvorlage eintragen
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | verskontrnummerkreisvorl | 313 |
    And I save the current editor

  Scenario Outline: Basisartikel anlegen
    Given I open an editor "<such>" from table "(Part):(BaseProduct)" with command "STORE" for record "<such>"
    And I set fields
      | such         | <such>     |
      | namebspr     | <namebspr> |
      | konstrukteur | MEIER      |
      | fbetreuer    | KARL       |
    And I save the current editor
    Examples:
      | such     | namebspr                     |
      | BAS_AUF  | Basisartikel auftragsbezogen |
      | BAS_BED  | Basisartikel bedarfsbezogen  |
      | BAS_AUSL | Auslaufteil                  |
      | LOC_VERG | Lokale Vergabe               |
      | EXT_VERG | Externe Vergabe              |

  Scenario Outline: Basisartikel anlegen mit Identnummer
    Given I open an editor "<such>" from table "(Part):(BaseProduct)" with command "STORE" for record "<such>"
    And I set fields
      | nummer       | <nummer>   |
      | such         | <such>     |
      | namebspr     | <namebspr> |
      | konstrukteur | MEIER      |
      | fbetreuer    | KARL       |
    And I save the current editor
    Examples:
      | nummer  | such        | namebspr                        |
      | 123%V1$ | Sonderzeich | Basisart mit Sonderzeich in Num |
      | 12345V  | KURZ_IND    | Kurzer Index, Trenner V         |
      
  Scenario Outline: Nummer der Nummernkreise prüfen.
    Given I open an editor "<editor>" via ID from editor "<such>" from field "nummernkreis" in row 0 for table "(NumberAssignment):(NumberRange)" with command "VIEW"
    Then field "nummer" has value "<nummer>"
    Then field "such" has value "<such>"

    And I close the current editor
    Examples:
      | editor            | such     | nummer   |
      | NUMKREIS_BAS_AUF  | BAS_AUF  | 90000001 |
      | NUMKREIS_BAS_BED  | BAS_BED  | 90000002 |
      | NUMKREIS_BAS_AUSL | BAS_AUSL | 90000003 |

  Scenario Outline: Nummernkreis anpassen
    Given I open an editor "<editor>" via ID from editor "<such>" from field "nummernkreis" in row 0 for table "(NumberAssignment):(NumberRange)" with command "UPDATE"
      And I set fields
         | obergr     | <obergr>     |
         | fmtvorlage | <fmtvorlage> |
         | verfahren  | <verfahren>  |
    And I save the current editor
      Examples:
         | editor       | such     | obergr      | fmtvorlage  | verfahren      |
         | NUM_KURZ_IND | KURZ_IND | 20          | 12345V00    | !dontChange    |
         | NUM_LOC_VERG | LOC_VERG | !dontChange | !dontChange | Lokale Vergabe |
      
  Scenario Outline: Artikel anlegen als Versionen für die Basisartikel 
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
      And I set fields
       | nummer       | <nummer>       |
     | such         | <such>         |
       | basisartikel | <basisartikel> |
       | index        | <index>        |
      And I save the current editor
      Examples:
       | nummer      | such      | basisartikel | index       |
       | !dontChange | A12345V01 | KURZ_IND     | 01          |
       | !dontChange | A12345V02 | KURZ_IND     | 02          |
     | !dontChange | LOC1      | LOC_VERG     | !dontChange |
     | 800002      | LOC2      | LOC_VERG     | 01          |
     | 80000303    | LOC3      | LOC_VERG     | 003         |
     | 800004      | LOC4      | LOC_VERG     | 004         |
     | 900001      | EXT1      | EXT_VERG     | 001         |

  Scenario Outline: Artikel anlegen als Versionen für die Basisartikel 
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
      And I set fields
     | such         | <such>         |
       | nummer       | <nummer>       |
       | index        | <index>        |
       | basisartikel | <basisartikel> |
      And I save the current editor
      Examples:
       | nummer      | such      | basisartikel | index       |
     | 900002      | EXT2      | EXT_VERG     | 002         |

 Scenario Outline: Nummer und Index von Version prüfen 
    Given I open an editor "<such>" from table "(Part):(Product)" with command "VIEW" for record "<such>"
    Then fields have values
       | index  | <index>  |
       | nummer | <nummer> |
    And I close the current editor
    Examples:
     | such      | index | nummer     |
     | A12345V01 | 01    | 12345V01   |
     | LOC1      | 001   | 10090-001  |
     | LOC2      | 01    | 800002     |
     | LOC3      | 003   | 80000303   |
     | LOC4      | 004   | 800004     |
     | EXT1      | 001   | 900001     |

  Scenario: Prüfen des Index bei lokaler Vergabe mit manueller Identnummer
    Given I open an editor "try" from table "(Part):(Product)" with command "STORE" for record "try"
    And I set fields
      | such         | LOC5     |
      | basisartikel | LOC_VERG |
      | nummer       | 800005   |
    Then saving the current editor throws the exception "2743"
    
 Scenario Outline: Artikel anlegen als Versionen für die Basisartikel
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>         |
      | namebspr | <namebspr>     |
      | dispoa   | <dispoa>       |
      | bsart    | Eigenfertigung |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
    And I save the current editor
    Examples:
      | such        | namebspr                         | dispoa          | elex1 | anzahl1 | elex2 | anzahl2 |
      | FE1-BEDARF  | Eigenfertigung 1 bedarfsbezogen  | bedarfsbezogen  | E3    | 1       | A AG1 | 1       |
      | FE2-BEDARF  | Eigenfertigung 2 bedarfsbezogen  | bedarfsbezogen  | E3    | 1       | A AG1 | 1       |
      | FE3-BEDARF  | Eigenfertigung 3 bedarfsbezogen  | bedarfsbezogen  | E3    | 1       | A AG1 | 1       |
      | FE1-AUFTRAG | Eigenfertigung 1 auftragsbezogen | auftragsbezogen | EINK  | 1       | A AG2 | 1       |
      | FE2-AUFTRAG | Eigenfertigung 2 auftragsbezogen | auftragsbezogen | EINK  | 1       | A AG2 | 1       |
      | FE3-AUFTRAG | Eigenfertigung 3 auftragsbezogen | auftragsbezogen | EINK  | 1       | A AG2 | 1       |


  Scenario: Auslaufartikel anlegen und Basisartikel zuordnen, für nachfolgende Tests

# Status Auslaufteil, aber keinen Nachfolger eintragen
    Given I open an editor "V_AUSLAUF" from table "(Part):(Product)" with command "STORE" for record "V_AUSLAUF"
    And I set fields
      | such      | V_AUSLAUF      |
      | namebspr  | Auslaufteil    |
      | artstatus | Auslaufteil    |
      | bsart     | Eigenfertigung |
    And I save the current editor

    Given I open an editor "BAS_AUSL" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_AUSL"
    And I append rows
      | tversion  | tindex | tstdvers |
      | V_AUSLAUF | XXX    | nein     |
    And I save the current editor

  Scenario: Basisartikel ohne Version kann nicht in Fertigungsliste eingetragen werden

    Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    And I create a new row at the end of the table
# 1288 de |Dieser Basisartikel hat noch keine Versionen.
    Then setting field "tbasisartikel" to "BAS_AUF" in row !lastRow throws the exception "1288"
    And I close the current editor

  Scenario: Versionen hinzufügen für BAS-BED

    Given I open an editor "BAS_BED" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_BED"
    And I delete all rows
    And I append rows
      | tversion   | tindex |
      | FE1-BEDARF | 001    |
      | FE2-BEDARF | 002    |
    Then saving the current editor throws the exception "2171"
    Then I set field "tstdvers" to "ja" in row 1
    And I save the current editor

    Given I open an editor "BAS_BED" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS_BED"
    Then the table has 2 rows
    Then table has values
      | tversion   | tstdvers |
      | FE1-BEDARF | ja       |
      | FE2-BEDARF | nein     |
    And I close the current editor


  Scenario: Version, die bereits Index, einfügen in Basisartikel, Index schon vorhanden, Index ändern und zurückschreiben

    Given I open an editor "FE3-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "FE3-BEDARF"
    And I set field "index" to "002"
    And I save the current editor

    Given I open an editor "BAS_BED" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_BED"
    And I create a new row at the end of the table
    And I set field "tversion" to "FE3-BEDARF" in row !lastRow
 # 2851 |Index schon vorhanden für diesen Artikel.
    Then saving the current editor throws the exception "2851"
    And I set field "tindex" to "003" in row !lastRow
    And I save the current editor

# Index wurde zurückgeschrieben in den Artikel
    Given I open an editor "FE3-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "FE3-BEDARF"
    Then field "index" has value "003"
#And I set field "basisartikel" to ""
    And I save the current editor

# Version in einen anderen Basisartikel eintragen und Index ändern
    Given I open an editor "BAS_AUF" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_AUF"
    And I create a new row at the end of the table
    And I set field "tversion" to "FE3-BEDARF" in row !lastRow
    Then field "tindex" has value "003" in row !lastRow
    And I set field "tindex" to "001" in row !lastRow
    And I set field "tstdvers" to "ja" in row !lastRow
    And I save the current editor

# Index und Basisartikel wurden geändert im Artikel
    Given I open an editor "FE3-BEDARF" from table "(Part):(Product)" with command "VIEW" for record "FE3-BEDARF"
    Then field "index" has value "001"
    Then field "basisartikel" has value "BAS_AUF"
    And I close the current editor

  Scenario: Version, die bereits Index, einfügen in Basisartikel, Index schon vorhanden, Index ändern und zurückschreiben

# Version in einen anderen Basisartikel eintragen und Index ändern
    Given I open an editor "BAS_AUF" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_AUF"
    Then field "tversion" has value "FE3-BEDARF" in row !lastRow
    And I create a new row at the end of the table
    And I set field "tversion" to "FE1-AUFTRAG" in row !lastRow
    And I set field "tindex" to "A01" in row !lastRow
    And I set field "tstdvers" to "ja" in row !lastRow
    And I save the current editor

    Given I open an editor "FE3-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "FE3-BEDARF"
    Then field "index" has value "001"
    And I set field "basisartikel" to "BAS_BED"
 # 2851 |Index schon vorhanden für diesen Artikel.
    Then saving the current editor throws the exception "2851"
    And I set field "index" to "003"
    And I save the current editor

#Version aus Basisartikel wieder entfernen, wegen folgender Scenarien
    Given I open an editor "BAS_AUF" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_AUF"
    And I delete all rows
    And I save the current editor

# Index und Basisartikel wurden geändert im Artikel
    Given I open an editor "FE3-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "FE3-BEDARF"
    And I set field "index" to "003"
    And I set field "basisartikel" to ""
    And I save the current editor

# Index und Basisartikel wurden geändert im Artikel
    Given I open an editor "FE1-AUFTRAG" from table "(Part):(Product)" with command "UPDATE" for record "FE1-AUFTRAG"
    And I set field "index" to ""
    And I set field "basisartikel" to ""
    And I save the current editor


  Scenario: Basisartikel mit Standardversion kann in Fertigungsliste eingetragen werden ohne Angabe elex

    Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    And I create a new row at the end of the table
    And I set field "tbasisartikel" to "BAS_BED" in row !lastRow
    Then field "elex" is empty in row !lastRow
    And I save the current editor

  Scenario: Basisartikel in Version eintragen, Index erforderlich

    Given I open an editor "FE1-AUFTRAG" from table "(Part):(Product)" with command "UPDATE" for record "FE1-AUFTRAG"
    Then I set field "basisartikel" to "BAS_AUF"
# 279 Bitte eintragen # der Index muss eingetragen werden
    Then saving the current editor throws the exception "279"
    Then I set field "index" to "E01"
    And I save the current editor

    Given I open an editor "FE2-AUFTRAG" from table "(Part):(Product)" with command "UPDATE" for record "FE2-AUFTRAG"
    Then I set field "basisartikel" to "BAS_AUF"
    Then I set field "index" to "E02"
    And I save the current editor

# erste Version zum Basisartikel wurde automatisch Standardversion
    Given I open an editor "BAS_AUF" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS_AUF"
    Then the table has 2 rows
    Then table has values
      | tversion    | tstdvers |
      | FE1-AUFTRAG | ja       |
      | FE2-AUFTRAG | nein     |
    And I close the current editor


# FE1-AUFTRAG ist Standardversion
    Given I open an editor "FE1-AUFTRAG" from table "(Part):(Product)" with command "VIEW" for record "FE1-AUFTRAG"
    Then field "stdvers" has value "ja"
    And I close the current editor


# FE2-AUFTRAG ist nicht Standardversion
    Given I open an editor "FE2-AUFTRAG" from table "(Part):(Product)" with command "VIEW" for record "FE2-AUFTRAG"
    Then field "stdvers" has value "nein"
    And I close the current editor

  Scenario: Standard in anderer Zeile setzen entfernt in der bisherigen Zeile - es kann nur einen geben

    Given I open an editor "BAS_AUF" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_AUF"
    Then the table has 2 rows
    Then table has values
      | tversion    | tstdvers |
      | FE1-AUFTRAG | ja       |
      | FE2-AUFTRAG | nein     |
    And I set field "tstdvers" to "ja" in row 2
    Then field "tstdvers" has value "nein" in row 1
    And I save the current editor

 # FE1-AUFTRAG ist nicht Standardversion
    Given I open an editor "FE1-AUFTRAG" from table "(Part):(Product)" with command "VIEW" for record "FE1-AUFTRAG"
    Then field "stdvers" has value "nein"
    And I close the current editor


# FE2-AUFTRAG ist Standardversion
    Given I open an editor "FE2-AUFTRAG" from table "(Part):(Product)" with command "VIEW" for record "FE2-AUFTRAG"
    Then field "stdvers" has value "ja"
    And I close the current editor


  Scenario: Basisartikel anlegen und vorhandene Version eintragen

    Given I open an editor "BEK-Projekt" from table "(Part):(BaseProduct)" with command "STORE" for record "BEK-Projekt"
    And I set fields
      | such         | BEK-Projekt |
      | namebspr     | BEK-Projekt |
      | konstrukteur | MEIER       |
    And I append rows
      | tversion   | tstdvers |
      | EK-Projekt | ja       |
  # 279 Bitte eintragen ### der Index muss eingetragen werden
    Then saving the current editor throws the exception "279"
    Then I set field "tindex" to "P01" in row 1
    And I save the current editor


  Scenario: EK-Projekt ist Standardversion

    Given I open an editor "EK-Projekt" from table "(Part):(Product)" with command "VIEW" for record "EK-Projekt"
    Then field "stdvers" has value "ja"
    Then field "basisartikel" has value equal to field "such" from editor "BEK-Projekt" in row 0
    And I close the current editor

  Scenario: Basisartikel lässt sich nicht aus Standardversion löschen und nicht ändern

    Given I open an editor "FE2-AUFTRAG" from table "(Part):(Product)" with command "UPDATE" for record "FE2-AUFTRAG"
 # 2170 de |Diese Version ist die Standardversion des Basisartikels.
    Then setting field "basisartikel" to "" throws the exception "2170"
    Then setting field "basisartikel" to "BAS_BED" throws the exception "2170"
    And I close the current editor


  Scenario: Entfernen einer Version und wieder einfügen der selben Version (Teste Nachbehandlung im Artikel)

 # Editor öffnen um Zugriff auf Feld zu haben
    Given I open an editor "FE2-BEDARF" from table "(Part):(Product)" with command "VIEW" for record "FE2-BEDARF"
    And I close the current editor

    Given I open an editor "BAS_BED" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_BED"
    Then the table has 2 rows
 # FE2-BEDARF aus der Tabelle löschen, steht in Zeile 2
    And I delete row at position 2
 # Leere Zeile einfügen
    And I append rows
      | tversion    |
      | !dontChange |
 # Artikel, der noch in der Tabelle eintragen, um Fehlermeldung zu provozieren
 # 5114 Ist in der Tabelle bereits vorhanden
    Then setting field "tversion" to "FE1-BEDARF" in row 2 throws the exception "5114"
 # Artikel eintragen, der geloescht wurde.
    And I set field "tversion" to "FE2-BEDARF" in row 2
 # Index ist schreibgeschützt, wenn der Artikel bereits einen Index hat
    Then field "tindex" is not modifiable in row 2
    Then field "tindex" has value "!FE2-BEDARF^index" in row 2
    And I save the current editor

    Given I open an editor "BAS_BED" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS_BED"
    Then the table has 2 rows
    And I close the current editor


  Scenario: Entfernen der Standardversion und wieder einfügen, nach dem andere Version Standard geworden ist

    Given I open an editor "BAS_BED" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_BED"
    Then the table has 2 rows
 # FE1-BEDARF aus der Tabelle löschen, steht in Zeile 1
    And I delete row at position 1
 # In verbliebener Zeile Standardversion setzen
    And I set field "tstdvers" to "ja" in row 1
 # Gelöschte Version wieder einsetzen
    And I append rows
      | tversion   |
      | FE1-BEDARF |
    Then field "tstdvers" has value "nein" in row 2
    And I save the current editor


  Scenario: Einfügen einer Version, die bereits einen anderen Basisartikel hat und dort Standardversion ist

    Given I open an editor "BAS_BED" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_BED"
    And I append rows
      | tversion    |
      | !dontChange |
 # 2172 de |Die Version ist bereits Standardversion zu einem anderen Basisartikel.
    Then setting field "tversion" to "FE2-AUFTRAG" in row 3 throws the exception "2172"
    And I save the current editor


  Scenario: Entfernen der Standardversion. Version prüfen.

    Given I open an editor "BAS_BED" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_BED"
    Then the table has 2 rows
 # FE1-BEDARF aus der Tabelle löschen, steht in Zeile 1
    And I delete row at position 1
 # In verbliebener Zeile Standardversion setzen
    And I set field "tstdvers" to "ja" in row 1
    And I save the current editor

    Given I open an editor "FE1-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "FE1-BEDARF"
    Then field "basisartikel" has value ""
    Then field "stdvers" has value "nein"
    And I set field "basisartikel" to "BEK-Projekt"
    And I save the current editor

    Given I open an editor "FE1-BEDARF" from table "(Part):(Product)" with command "UPDATE" for record "FE1-BEDARF"
    And I set field "basisartikel" to ""
    And I save the current editor

    Given I open an editor "FE2-BEDARF" from table "(Part):(Product)" with command "VIEW" for record "FE2-BEDARF"
    Then field "basisartikel" has value "BAS_BED"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such     | FE5-BEDARF                      |
      | namebspr | Eigenfertigung 5 bedarfsbezogen |
      | index    | 002                             |
 # 2851 |Index schon vorhanden für diesen Artikel.
    Then saving the current editor throws the exception "2851"
    And I set field "index" to "E05"
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor


  Scenario: Basisartikel anlegen und neue Version anlegen und Identnummer prüfen

    Given I open an editor "BAS-IDENT" from table "(Part):(BaseProduct)" with command "NEW" for record ""
    And I set fields
      | such     | BAS-IDENT          |
      | namebspr | Identnummer prüfen |
      | nummer   | 22222              |
    And I save the current editor

    Given I open an editor "VERS-IDENT" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such         | VERS-IDENT         |
      | namebspr     | Identnummer prüfen |
      | basisartikel | 22222              |
      | index        | ABC                |
    And I save the current editor

    Given I open an editor "BAS-IDENT" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-IDENT"
    Then table has values
      | tversion   | tindex |
      | VERS-IDENT | ABC    |
    And I close the current editor

    Given I open an editor "VERS-IDENT" from table "(Part):(Product)" with command "UPDATE" for record "VERS-IDENT"
    Then field "nummer" has value "22222-ABC"
    And I set field "index" to "123"
    And I save the current editor

    Given I open an editor "VERS-IDENT" from table "(Part):(Product)" with command "VIEW" for record "VERS-IDENT"
    Then field "nummer" has value "22222-ABC"
    Then field "index" has value "123"
    And I close the current editor

    Given I open an editor "BAS-IDENT" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-IDENT"
    Then field "tindex" has value "123" in row 1
    And I close the current editor


  Scenario: Lieferanten Index und Zeichnungsnummer

    Given I open an editor "LIEF-ZEICHN" from table "(Part):(Product)" with command "STORE" for record "LIEF-ZEICHN"
    And I set fields
      | such        | LIEF-ZEICHN               |
      | namebspr    | Lieferant Index Zeichnung |
      | zeichn      | intern456                 |
      | bsart       | Fremdbeschaffung          |
      | lief        | LIEFER1                   |
      | liefindex1  | ABC                       |
      | liefzeichn1 | LF123-ABC                 |
      | lief2       | LIEFER2                   |
      | liefindex2  | 123                       |
      | liefzeichn2 | XYZ_123                   |
    And I save the current editor


  Scenario: Lagergruppeneigenschaften mit Lieferanten Index und Zeichnungsnummer

    Given I open an editor "LG-EIGEN" from table "(Part):(Product)" with command "STORE" for record "LG-EIGEN"
    And I set fields
      | such     | LG-EIGEN                  |
      | namebspr | LGruppe Lief Index Zeichn |
      | zeichn   | intern001                 |
      | bsart    | Fremdbeschaffung          |
      | umllg    | BERLIN                    |
    And I press button "alge" to open a subeditor for "Lgruppen"
    And I delete all rows
    And I append rows
      | lgruppe | bsart            | lief    | liefindex1 | liefzeichn1 | lief2   | liefindex2 | liefzeichn2 |
      | BERLIN  | Fremdbeschaffung | LIEFER1 | ABX        | LF456-ABX   | LIEFER2 | 134        | XYZ-134     |
    And I save the current subeditor to switch back to the parent editor
    And I set field "bsart" to "Umlagern"
    And I save the current editor


  Scenario: Basisartikel mit mehreren Version, unterschiedliche Versionen in Fertigungslisten

    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS-FL"
    And I set fields
      | such         | BAS-FL                    |
      | namebspr     | Basis für Fertigungsliste |
      | konstrukteur | MEIER                     |
    And I save the current editor

    Given I open an editor "VERS-FL01" from table "(Part):(Product)" with command "STORE" for record "VERS-FL01"
    And I set fields
      | such         | VERS-FL01                     |
      | namebspr     | Version01 für Fertigungsliste |
      | basisartikel | BAS-FL                        |
      | index        | F01                           |
      | bsart        | Eigenfertigung                |
    And I delete all rows
    And I append rows
      | elex  | elanzahl |
      | E3    | 1        |
      | A AG1 | 1        |
    And I save the current editor

    Given I open an editor "VERS-FL01" from table "(Part):(Product)" with command "VIEW" for record "VERS-FL01"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such     | VERS-FL02                     |
      | namebspr | Version02 für Fertigungsliste |
      | index    | F02                           |
      | bsart    | Eigenfertigung                |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-FL"
    Then table has values
      | tversion  | tstdvers |
      | VERS-FL01 | ja       |
      | VERS-FL02 | nein     |
    And I close the current editor

# unterschiedliche Versionen können in die gleiche Fertigungsliste eingetragen werden
    Given I open an editor "V3" from table "(Part):(Product)" with command "UPDATE" for record "V3"
    And I append rows
      | tbasisartikel | elex      | elanzahl | filter | filtervgl |
      | BAS-FL        | VERS-FL01 | 1        | Q<     | 10        |
      | BAS-FL        | VERS-FL02 | 1        | Q>=    | 10        |
    And I save the current editor

# Version, die nicht Standard ist, kann in Fertigungsliste eingetragen werden
    Given I open an editor "V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
    And I append rows
      | tbasisartikel | elex      | elanzahl |
      | BAS-FL        | VERS-FL02 | 1        |
    And I save the current editor

# Basisartikel kann ohne Angabe der Version in der Fertigungsliste verwendet werden, Standardversion wird gezogen
    Given I open an editor "V2" from table "(Part):(Product)" with command "UPDATE" for record "V2"
    And I set field "mindest" to "50"
    And I append rows
      | tbasisartikel | elex | elanzahl |
      | BAS-FL        |      | 1        |
    And I save the current editor

    And I run Scheduling

# Fertigungsvorschlag prüfen, Feld artikel ist gefüllt mit der Standardversion
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "basisartikel" to "BAS-FL"
    And I press button "ladetab"
    Then field "artikel" has value "VERS-FL01" in row 1
    And I close the current editor

# Mindestbestand erhöhen, damit weiterer Fertigungsvorschlag ausgelöst wird, vorher Standardversion ändern
# maximale Beschaffungsmenge auf 50, damit es 2 Fertigungsvorschläge gibt
    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-FL"
    And I set field "tstdvers" to "ja" in row 2
    And I save the current editor

    Given I open an editor "V2" from table "(Part):(Product)" with command "UPDATE" for record "V2"
    And I set field "mindest" to "100"
    And I set field "maxbsmge" to "50"
    And I save the current editor

    And I run Scheduling

# Fertigungsvorschlag prüfen, Feld artikel ist gefüllt mit der neuen Standardversion bei zweitem FeVo
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "basisartikel" to "BAS-FL"
    And I press button "ladetab"
    Then field "artikel" has value "VERS-FL01" in row 1
    Then field "artikel" has value "VERS-FL02" in row 2
    And I close the current editor

# Standardversion wieder zurücksetzen wegen weiterer Scenarien
    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-FL"
    And I set field "tstdvers" to "ja" in row 1
    And I save the current editor

# Version, die zum gleichen Basisartikel gehört, kann in die Fertigungsliste einer Version eingetragen werden, bspw. Umbau von einer Version auf die andere
# Angabe elex erforderlich, auch wenn andere Version Standard ist (Standardversion könnte sich ändern und dann zu zyklischer Struktur führen)
    Given I open an editor "VERS-FL02" from table "(Part):(Product)" with command "UPDATE" for record "VERS-FL02"
    Then field "basisartikel" has value "BAS-FL"
    And I delete all rows
    And I append rows
      | tbasisartikel | elex  | elanzahl |
      | BAS-FL        |       | 1        |
      |               | A AG1 | 1        |
# 2382 de      |Bitte Artikel eintragen
    Then saving the current editor throws the exception "2382"
    And I set field "elex" to "VERS-FL02" in row 1
# 93 de      |Zyklische Struktur
    Then saving the current editor throws the exception "93"
    And I set field "elex" to "VERS-FL01" in row 1
    And I save the current editor


  Scenario: Basisartikel als Umbauartikel nur möglich mit Angabe der Version

# auch bei kompeig Umbauartikel ist die Angabe der Version (elex oder elem) erforderlich
    Given I open an editor "BG1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    And I delete all rows
    And I append rows
      | tbasisartikel | kompeig      | elex      | elanzahl |
      |               | !dontChange  | VERS-FL01 | 1        |
      | BAS-FL        | Umbauartikel |           | 1        |
      |               | !dontChange  | A AG1     | 1        |
# 2382 de      |Bitte Artikel eintragen
    Then saving the current editor throws the exception "2382"
    And I set field "elex" to "VERS-FL02" in row 2
    And I save the current editor


  Scenario: Basisartikel als Halbfabrikat nur möglich mit Angabe der Version

    Given I open an editor "BAS-HALBFAB" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS-HALBFAB"
    And I set fields
      | such         | BAS-HALBFAB            |
      | namebspr     | Basis für Halbfabrikat |
      | konstrukteur | MEIER                  |
    And I save the current editor

    Given I open an editor "HALBFAB01" from table "(Part):(Product)" with command "STORE" for record "HALBFAB01"
    And I set fields
      | such         | HALBFAB01      |
      | namebspr     | Halbfabrikat   |
      | index        | H01            |
      | basisartikel | BAS-HALBFAB    |
      | dispoa       |                |
      | bsart        | Eigenfertigung |
      | earta        | keine          |
    And I save the current editor

    Given I open an editor "HALBFAB01" from table "(Part):(Product)" with command "VIEW" for record "HALBFAB01"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such  | HALBFAB02 |
      | index | H02       |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "LOHNFERT" from table "(Part):(Product)" with command "STORE" for record "LOHNFERT"
    And I set fields
      | such     | LOHNFERT        |
      | namebspr | Lohnfertigung   |
      | dispoa   | auftragsbezogen |
      | bsart    | Lohnfertigung   |
      | earta    | über Artikel    |
    And I delete all rows
    And I append rows
      | tbasisartikel | kompeig      | elanzahl |
      | BAS-HALBFAB   | Halbfabrikat | 1        |
# 2382 de      |Bitte Artikel eintragen
    Then saving the current editor throws the exception "2382"
    And I set field "elem" to "HALBFAB02" in row 1
    And I save the current editor


  Scenario: Basisartikel und Koppelprodukt nur möglich mit Angabe der Version

    Given I open an editor "BAS-KOPPEL" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS-KOPPEL"
    And I set fields
      | such         | BAS-KOPPEL                 |
      | namebspr     | Basis für Koppelproduktion |
      | konstrukteur | MEIER                      |
    And I save the current editor

    Given I open an editor "KOPPEL-V01" from table "(Part):(Product)" with command "STORE" for record "KOPPEL-V01"
    And I set fields
      | such         | KOPPEL-V01            |
      | namebspr     | Version Koppelprodukt |
      | index        | V01                   |
      | basisartikel | BAS-KOPPEL            |
      | bsart        | Eigenfertigung        |
    And I save the current editor

    Given I open an editor "KOPPEL-V01" from table "(Part):(Product)" with command "VIEW" for record "KOPPEL-V01"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such  | KOPPEL-V02 |
      | index | V02        |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

# bei kompeig Koppelprodukt muss ein Artikel eingetragen werden
    Given I open an editor "BG-KOPPEL" from table "(Part):(Product)" with command "STORE" for record "BG-KOPPEL"
    And I set fields
      | such     | BG-KOPPEL               |
      | namebspr | Baugruppe Koppelprodukt |
      | index    |                         |
      | bsart    | Eigenfertigung          |
    And I delete all rows
    And I append rows
      | tbasisartikel | kompeig       | elex       | elanzahl |
      |               | !dontChange   | KOPPEL-V01 | 1        |
      | BAS-KOPPEL    | Koppelprodukt |            | 1        |
      |               | !dontChange   | A AG2      | 1        |
# 2382 de      |Bitte Artikel eintragen
    Then saving the current editor throws the exception "2382"
    And I set field "elem" to "KOPPEL-V02" in row 2
    And I save the current editor


  Scenario: verschiedene Versionen zum gleichen Basisartikel in Aufträgen verwenden, sowie Bestand prüfen im Basisartikel

    Given I set StorageQuantity to zero for Product "VERS-FL01" on StorageLocation "F1" with document "KORR-01"
    Given I set StorageQuantity to zero for Product "VERS-FL02" on StorageLocation "F1" with document "KORR-02"

    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-FL"
    Then fields have values
      | bestand   | 0 |
      | lgbestand | 0 |
    And I close the current editor

    Given I open an editor "AUF_FL01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | KUNDE1   |
      | such  | AUF_FL01 |
      | vom   | .        |
    And I append rows
      | artikel   | mge | einplan |
      | VERS-FL01 | 10  | ja      |
    And I save the current editor

    Given I open an editor "AUF_FL02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | KUNDE1   |
      | such  | AUF_FL02 |
      | vom   | .        |
    And I append rows
      | artikel   | mge | einplan |
      | VERS-FL02 | 10  | ja      |
    And I save the current editor

    And I post a receipt via ManualStockAdjustment for Product "VERS-FL01" and quantity "8" on StorageLocation "F1" with document "MANLBU01"
    And I post a receipt via ManualStockAdjustment for Product "VERS-FL02" and quantity "15" on StorageLocation "F1" with document "MANLBU02"

    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-FL"
    Then fields have values
      | bestand   | 23 |
      | lgbestand | 23 |
    And I close the current editor

    And I deliver the SalesOrder "AUF_FL01" with PackingSlip "LS-AUF1"
    And I deliver the SalesOrder "AUF_FL02" with PackingSlip "LS-AUF2"

    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-FL"
    Then fields have values
      | bestand   | 3 |
      | lgbestand | 3 |
    Then table has values
      | tversion  | tbestand |
      | VERS-FL01 | -2       |
      | VERS-FL02 | 5        |
    And I close the current editor


  Scenario: Kundenartikeleigenschaften für Basisartikel mit mehreren Version

# Zeichnung und Versionsnummer in den Kundenartikeleigenschaften hinterlegen

    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-FL"
# nur zur Überprüfung, dass Standardversion sich nicht ändert
    Then table has values
      | tversion  | tstdvers |
      | VERS-FL01 | ja       |
      | VERS-FL02 | nein     |
# Kundenartikeleigenschaften anlegen
    And I press button "akle" to open a subeditor for "KuartEigenschaft"
    Then fields have values
      | basisartikel     | BAS-FL                    |
      | basisartikelname | Basis für Fertigungsliste |
    Then field "artikel" is empty
    Then field "artikel" is not modifiable
    Then field "basisartikel" is not modifiable
    And I append rows
      | kl     | kuartnr | zeichn  | index | packanwversand  | fmengeversand | vorlauf |
      | KUNDE1 | 12345   | ZG12345 | 10    | VERSAND_EINFACH | 20            | 2       |
      | KUNDE2 | XYZ12   | Z_XYZ12 | 08    |                 |               | 5       |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor


    Given I open an editor "VERS-FL01" from table "(Part):(Product)" with command "UPDATE" for record "VERS-FL01"
    And I press button "akle" to open a subeditor for "KuartEigenschaft"
    Then fields have values
      | basisartikel     | BAS-FL                        |
      | basisartikelname | Basis für Fertigungsliste     |
      | artikel          | VERS-FL01                     |
      | artname          | Version01 für Fertigungsliste |
    Then field "basisartikel" is not modifiable
    Then field "artikel" is not modifiable
    And I append rows
      | kl     | kuartnr  | zeichn     | index | packanwversand | fmengeversand | vorlauf |
      | KUNDE1 | 12345NEU | ZG12345NEU | 11    | PAEINFACH      | 25            | 5       |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor


    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-FL"
    And I press button "akle" to open a subeditor for "KuartEigenschaft"
    And I delete all rows
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "VERS-FL01" from table "(Part):(Product)" with command "VIEW" for record "VERS-FL01"
    And I press button "akle" to open a subeditor for "KuartEigenschaft"
    Then table has values
      | kl^such | kuartnr  | zeichn     | index | packanwversand^such | fmengeversand | vorlauf |
      | KUNDE1  | 12345NEU | ZG12345NEU | 11    | PAEINFACH           | 25            | 5       |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "BAS-FL" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-FL"
# nur zur Überprüfung, dass Standardversion sich nicht geändert hat
    Then table has values
      | tversion  | tstdvers |
      | VERS-FL01 | ja       |
      | VERS-FL02 | nein     |
    And I close the current editor


  Scenario: Version löschen wenn keine Standardversion, Basisartikel löschen wenn keine lebendigen Versionen

    Given I open an editor "BAS-LOESCH" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS-LOESCH"
    And I set fields
      | such     | BAS-LOESCH   |
      | namebspr | Test Löschen |
    And I save the current editor

    Given I open an editor "LOESCH-001" from table "(Part):(Product)" with command "STORE" for record "LOESCH-001"
    And I set fields
      | such         | LOESCH-001   |
      | namebspr     | Test Löschen |
      | basisartikel | BAS-LOESCH   |
      | index        | 001          |
    And I save the current editor

    Given I open an editor "LOESCH-002" from table "(Part):(Product)" with command "STORE" for record "LOESCH-002"
    And I set fields
      | such         | LOESCH-002   |
      | namebspr     | Test Löschen |
      | basisartikel | BAS-LOESCH   |
      | index        | 002          |
    And I save the current editor

    Given I open an editor "BAS-LOESCH" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-LOESCH"
    Then table has values
      | tversion   | tstdvers |
      | LOESCH-001 | ja       |
      | LOESCH-002 | nein     |
    And I close the current editor

# löschen Standardversion darf nicht möglich sein
    Given I open an editor "LOESCH-001" from table "(Part):(Product)" with command "DELETE" for record "LOESCH-001"
# 2959 de      |Darf nicht gelöscht werden, da er die Standardversion eines Basisartikels ist.
    Then saving the current editor throws the exception "2959"
    And I close the current editor

    Given I open an editor "LOESCH-002" from table "(Part):(Product)" with command "DELETE" for record "LOESCH-002"
# 826 de      |Wirklich löschen?
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

# der gelöschte Artikel wird aus der Tabelle entfernt
    Given I open an editor "BAS-LOESCH" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-LOESCH"
    Then the table has 1 rows
    Then table has values
      | tversion   | tstdvers |
      | LOESCH-001 | ja       |
    And I close the current editor

# Basisartikel in Fertigungsliste eintragen
    Given I open an editor "BG1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    And I create a new row at the end of the table
    And I set field "tbasisartikel" to "BAS-LOESCH" in row !lastRow
    And I save the current editor

# Löschen Basisartikel darf nicht möglich sein, wenn er noch lebendige Versionen hat
    Given I open an editor "BAS-LOESCH" from table "(Part):(BaseProduct)" with command "DELETE" for record "BAS-LOESCH"
# 2960 de      |Basisartikel darf nicht gelöscht werden, da er noch aktive Versionen hat.
    Then saving the current editor throws the exception "2960"
    And I close the current editor

    Given I open an editor "LOESCH-001" from table "(Part):(Product)" with command "UPDATE" for record "LOESCH-001"
    And I set field "artstatus" to "Auslaufteil"
    And I save the current editor

# Standard darf nicht entfernt werden, wenn der Basisartikel ohne Version in Fertigungslisten
    Given I open an editor "BAS-LOESCH" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-LOESCH"
# 2192 de      |Basisartikel ist noch in Fertigungslisten eingetragen.
    Then setting field "tstdvers" to "nein" in row 1 throws the exception "2192"
    And I close the current editor

# Löschen der Version darf nicht möglich sein, da letzte Version des Basisartikels und dieser in Fertigungsliste eingetragen
    Given I open an editor "LOESCH-001" from table "(Part):(Product)" with command "DELETE" for record "LOESCH-001"
# 2959 de      |Darf nicht gelöscht werden, da er die Standardversion eines Basisartikels ist.
    Then saving the current editor throws the exception "2959"
    And I close the current editor

# Löschen Basisartikel darf nicht möglich sein, wenn er in Fertigungslisten eingetragen ist
    Given I open an editor "BAS-LOESCH" from table "(Part):(BaseProduct)" with command "DELETE" for record "BAS-LOESCH"
## Test muss hier angepasst werden, dass er das richtige testet
# 2192 de      |Basisartikel ist noch in Fertigungslisten eingetragen.
#Then saving the current editor throws the exception "2192"
    Then saving the current editor throws the exception "2960"
    And I close the current editor

# Basisartikel aus der Fertigungsliste entfernen
    Given I open an editor "BG1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    And I delete row at position !lastRow
    And I save the current editor

# Standardhaken entfernen
    Given I open an editor "BAS-LOESCH" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-LOESCH"
    And I set field "tstdvers" to "nein" in row 1
    And I save the current editor

# Version löschen
    Given I open an editor "LOESCH-001" from table "(Part):(Product)" with command "DELETE" for record "LOESCH-001"
# 826 de      |Wirklich löschen?
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

# Basisartikel löschen
    Given I open an editor "BAS-LOESCH" from table "(Part):(BaseProduct)" with command "DELETE" for record "BAS-LOESCH"
# 826 de      |Wirklich löschen?
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor


  Scenario: Basisartikel mit einer Version, Änderung nacheinander unterschiedliche Artikelstati

    Given I open an editor "STATUS-A01" from table "(Part):(Product)" with command "STORE" for record "STATUS-A01"
    And I set fields
      | such      | STATUS-A01         |
      | namebspr  | Test Artikelstatus |
      | artstatus | Artikelerstellung  |
      | index     | A01                |
    And I save the current editor

    Given I open an editor "BAS-STATUS" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS-STATUS"
    And I set fields
      | such         | BAS-STATUS              |
      | namebspr     | Basis für Artikelstatus |
      | konstrukteur | MEIER                   |
    And I create a new row at the end of the table
    And I set field "tversion" to "STATUS-A01" in row 1
    Then field "tstdvers" is not modifiable in row 1
    And I save the current editor

    Given I open an editor "STATUS-A01" from table "(Part):(Product)" with command "UPDATE" for record "STATUS-A01"
    Then field "stdvers" has value "nein"
    And I set field "artstatus" to "In Entwicklung"
    And I set field "bsart" to "Eigenfertigung"
    And I append rows
      | elex  | elanzahl |
      | E3    | 0        |
      | A AG1 | 0        |
    And I save the current editor

    Given I open an editor "BAS-STATUS" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-STATUS"
    Then field "tartstatus" has value "In Entwicklung" in row 1
    Then field "tstdvers" is not modifiable in row 1
    And I close the current editor

    Given I open an editor "STATUS-A01" from table "(Part):(Product)" with command "UPDATE" for record "STATUS-A01"
    And I set field "artstatus" to "Prototyp"
    And I modify table
      | !row | elex        | elanzahl |
      | 1    | !dontChange | 1        |
      | 2    | !dontChange | 1        |
      | +3   | EINK        | 1        |
      | +4   | A AG2       | 1        |
    And I save the current editor

    Given I open an editor "BAS-STATUS" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-STATUS"
    Then field "tartstatus" has value "Prototyp" in row 1
    Then field "tstdvers" is not modifiable in row 1
    And I close the current editor

    Given I open an editor "STATUS-A01" from table "(Part):(Product)" with command "UPDATE" for record "STATUS-A01"
    And I set field "artstatus" to "Einzelfertigung"
    And I save the current editor

    Given I open an editor "BAS-STATUS" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-STATUS"
    Then field "tartstatus" has value "Einzelfertigung" in row 1
    Then field "tstdvers" has value "ja" in row 1
    Then field "tstdvers" is modifiable in row 1
    And I close the current editor

# aus der Version eine neue Version erstellen und diese als Planartikel einstellen
    Given I open an editor "STATUS-A01" from table "(Part):(Product)" with command "VIEW" for record "STATUS-A01"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such      | STATUS-PL                 |
      | namebspr  | Planartikel zu BAS-STATUS |
      | index     | PL                        |
      | artstatus | Planartikel               |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "STATUS-A01" from table "(Part):(Product)" with command "UPDATE" for record "STATUS-A01"
    And I set field "artstatus" to "Serienfertigung"
    And I save the current editor

    Given I open an editor "BAS-STATUS" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-STATUS"
    Then table has values
      | tversion   | tartstatus      | tstdvers |
      | STATUS-A01 | Serienfertigung | ja       |
      | STATUS-PL  | Planartikel     | nein     |
    Then field "tstdvers" is modifiable in row 1
    Then field "tstdvers" is not modifiable in row 2
    And I close the current editor

    Given I open an editor "STATUS-A01" from table "(Part):(Product)" with command "VIEW" for record "STATUS-A01"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such      | STATUS-A02      |
      | index     | A02             |
      | artstatus | Serienfertigung |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "STATUS-A01" from table "(Part):(Product)" with command "UPDATE" for record "STATUS-A01"
    And I set fields
      | artstatus        | Auslaufteil   |
      | nachfolgeartikel | STATUS-A02    |
      | vgltermin        | Anfangstermin |
      | lbsdatum         | -10           |
      | lverwdatum       | -1            |
    And I save the current editor

    Given I open an editor "BAS-STATUS" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-STATUS"
    And I set field "tstdvers" to "ja" in row 2
    Then table has values
      | tversion   | tartstatus      | tstdvers | auslaufstatusicon |
      | STATUS-A01 | Auslaufteil     | nein     | icon:replace      |
      | STATUS-A02 | Serienfertigung | ja       |                   |
      | STATUS-PL  | Planartikel     | nein     |                   |
    Then field "tstdvers" is modifiable in row 1
    Then field "tstdvers" is modifiable in row 2
    Then field "tstdvers" is not modifiable in row 3
    And I save the current editor


  Scenario: Basisartikel mit mehreren Versionen, unterschiedliche Artikelstati, keine Standardversion

    Given I open an editor "BAS-PLAN" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS-PLAN"
    And I set fields
      | such         | BAS-PLAN                      |
      | namebspr     | Basis Planung    und Entwicklung |
      | konstrukteur | MEIER                         |
    And I save the current editor

    Given I open an editor "PLAN-P01" from table "(Part):(Product)" with command "STORE" for record "PLAN-P01"
    And I set fields
      | such         | PLAN-P01            |
      | namebspr     | Planung zu BAS-PLAN |
      | artstatus    | Planartikel         |
      | index        | P01                 |
      | basisartikel | BAS-PLAN            |
    And I save the current editor

    Given I open an editor "PLAN-P01" from table "(Part):(Product)" with command "VIEW" for record "PLAN-P01"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such         | PLAN-E01                  |
      | namebspr     | erste Version zu BAS-PLAN |
      | artstatus    | In Entwicklung            |
      | index        | E01                       |
      | basisartikel | BAS-PLAN                  |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "BAS-PLAN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-PLAN"
    Then table has values
      | tversion | tartstatus     | tstdvers |
      | PLAN-E01 | In Entwicklung | nein     |
      | PLAN-P01 | Planartikel    | nein     |
    Then field "tstdvers" is not modifiable in row 1
    Then field "tstdvers" is not modifiable in row 2
    And I close the current editor

    Given I open an editor "BAUT" from table "(Part):(Product)" with command "UPDATE" for record "BAUT"
    And I create a new row at the end of the table
    And I set field "tbasisartikel" to "BAS-PLAN" in row !lastRow
#  3122 |Dieser Basisartikel hat keine Standardversion, bitte Version eintragen.
    Then saving the current editor throws the exception "3122"
    And I set field "elex" to "PLAN-E01" in row !lastRow
    And I set field "elanzahl" to "1" in row !lastRow
    Then field "tbasisartikel" has value "BAS-PLAN" in row !lastRow
    And I save the current editor


  Scenario: Basisartikel mit 2 Versionen, Artikelstatus ändern, Plausi im Basisartikel wenn Artikel geändert wurde

    Given I open an editor "BAS-AENDERN" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS-AENDERN"
    And I set fields
      | such         | BAS-AENDERN                 |
      | namebspr     | Basis Plausi Ändern Artikel |
      | konstrukteur | MEIER                       |
      | fbetreuer    | KARL                        |
    And I save the current editor

    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "STORE" for record "AENDERN1"
    And I set fields
      | such         | AENDERN1                 |
      | namebspr     | Version 1 zu BAS-AENDERN |
      | artstatus    | Serienfertigung          |
      | index        | V01                      |
      | basisartikel | BAS-AENDERN              |
      | bsart        | Eigenfertigung           |
    And I save the current editor

    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "VIEW" for record "AENDERN1"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such         | AENDERN2                 |
      | namebspr     | Version 2 zu BAS-AENDERN |
      | artstatus    | In Entwicklung           |
      | index        | V02                      |
      | basisartikel | BAS-AENDERN              |
      | bsart        | Eigenfertigung           |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "VIEW" for record "AENDERN1"
    And I press button "neuevers" to open a subeditor for "Version"
    And I set fields
      | such         | AENDERN3                 |
      | namebspr     | Version 3 zu BAS-AENDERN |
      | artstatus    | Serienfertigung          |
      | index        | V03                      |
      | basisartikel | BAS-AENDERN              |
      | bsart        | Eigenfertigung           |
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

# Standardversion ändern, um zu prüfen dass bei neu laden korrekt zurückgesetzt wird und nicht die erste Version Standard wird
    Given I open an editor "BAS-AENDERN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-AENDERN"
    And I set field "tstdvers" to "ja" in row 3
    And I save the current editor

# Kopffeld ändern, bleibt erhalten nach neu laden der Tabelle; Editor bleibt offen und wird erst am Ende gespeichert
    Given I open an editor "BAS-AENDERN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-AENDERN"
    And I set field "fbetreuer" to "KARL"
    Then table has values
      | tversion | tartstatus      | tstdvers |
      | AENDERN1 | Serienfertigung | nein     |
      | AENDERN2 | In Entwicklung  | nein     |
      | AENDERN3 | Serienfertigung | ja       |
    Then field "tstdvers" is not modifiable in row 2
# Editor geöffnet lassen

    Given I'm logged in with password "adm"
    Given I set the fake date to "01.01.2000"

    Given I open an editor "AENDERN2" from table "(Part):(Product)" with command "UPDATE" for record "AENDERN2"
    And I set field "artstatus" to "Einzelfertigung"
    And I save the current editor

    Given I'm logged in with password "sy"

# zurück zum Basisartikel, die Tabelle muss neu geladen werden, da Änderung am Artikel
    And I switch the current editor to editor "BAS-AENDERN" with command "UPDATE"
# 2193 de      |Die Änderungen können nicht gespeichert werden, eine Version wurden inzwischen geändert. Tabelle wird neu geladen.
    Then saving the current editor throws the exception "2193"
    Then field "tartstatus" has value "Einzelfertigung" in row 2
    Then field "tstdvers" is modifiable in row 2
    And I set field "tstdvers" to "ja" in row 2
# Editor offen lassen

    Given I'm logged in with password "adm"
    Given I set the fake date to "01.01.2000"

    And I switch the current editor to editor "AENDERN2" with command "UPDATE"
    And I set field "artstatus" to "In Entwicklung"
    And I save the current editor

    Given I'm logged in with password "sy"

# zurück zum Basisartikel, die Tabelle muss neu geladen werden, da Änderung am Artikel, Status und Standard wird wieder zurück gesetzt
    And I switch the current editor to editor "BAS-AENDERN" with command "UPDATE"
# 2193 de      |Die Änderungen können nicht gespeichert werden, eine Version wurden inzwischen geändert. Tabelle wird neu geladen.
    Then saving the current editor throws the exception "2193"
    Then table has values
      | tversion | tartstatus      | tstdvers |
      | AENDERN1 | Serienfertigung | nein     |
      | AENDERN2 | In Entwicklung  | nein     |
      | AENDERN3 | Serienfertigung | ja       |
    Then field "tstdvers" is not modifiable in row 2
# die Änderung des Kopffeldes bleibt erhalten
    Then field "fbetreuer" has value "KARL"
    And I save the current editor


  Scenario: Basisartikel für Beistellungen

# Basisartikel kann ohne Versionsangabe als Lieferantenbeistellung in die Fertigungsliste eines Kaufteils eingetragen werden

    Given I open an editor "EK-ERWBEDARF" from table "(Part):(Product)" with command "UPDATE" for record "EK-ERWBEDARF"
    And I set field "mindest" to "15"
    And I delete all rows
    And I append rows
      | tbasisartikel | elanzahl | bua                    |
      | BAS_BED       | 1        | Lieferantenbeistellung |
    And I save the current editor

    And I run Scheduling

# Fertigungsvorschlag für Beistellteil, Standardversion von BAS_BED ist FE2-BEDARF
    Given I open an editor "BV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "FE2-BEDARF"
    And I press button "ladetab"
    Then field "mge" has value "15" in row 1
    And I close the current editor


  Scenario: Sachmerkmalsleiste für Basisartikel anlegen, eintragen und Merkmale speichern

# Sachmerkmalsleiste anlegen für Gruppe Basisartikel
    Given I open an editor "SML-BAS" from table "(Company):(CharacteristicsBar)" with command "NEW" for record ""
    And I set fields
      | such  | SML-BAS      |
      | grtxt | Basisartikel |
    And I delete all rows
    And I append rows
      | benennibspr | zusatzart | vname   |
      | Durchmesser | R4.2      | qdurchm |
    And I save the current editor

# Sachmerkmalsleiste kann in Basisartikel eingetragen werden, wenn sie die Gruppe Basisartikel hat
# SML 0s hat nur Gruppe Artikel
    Given I open an editor "SML" from table "(Company):(CharacteristicsBar)" with command "VIEW" for record "0s"
    Then field "grtxt" has value "Artikel"
    And I close the current editor

    Given I open an editor "BAS-AENDERN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-AENDERN"
# 600 de      |%s: SML-Leiste passt nicht zu dieser Gruppe.
# 1361 Ungültiger Feldwert
    Then setting field "sach" to "0s" throws the exception "1361"
    And I set fields
      | sach | SML-BAS |
    And I press button "bmerk" to open a subeditor for "Sachmerkmale"
    And I set fields
      | qdurchm | 10,3 |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# Gruppe Basisartikel darf in der verwendeten SML nicht mehr entfernt werden, dann beide Gruppen auswählen, Artikel und Basisartikel
    Given I open an editor "SML-BAS" from table "(Company):(CharacteristicsBar)" with command "UPDATE" for record "SML-BAS"
#    2236 de      |Eine verwendete Gruppe darf nicht mehr entfernt werden.
    Then setting field "grtxt" to "Artikel" throws the exception "2236"
# Gruppe Artikel und Basisartikel auswählen
    And I set field "grliste" to "2:1.9"
    And I save the current editor

# die Sachmerkmalsleiste kann in die Version eingetragen werden, wenn die SML auch die Gruppe Artikel hat, keine Werte übernommen
    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "UPDATE" for record "AENDERN1"
    Then field "basisartikel" has value "BAS-AENDERN"
    Then field "sach" is empty
    And I set fields
      | sach | SML-BAS |
    And I press button "bmerk" to open a subeditor for "Sachmerkmale"
    Then fields have values
      | qdurchm | 0.00 |
    And I set fields
      | qdurchm | 9,8 |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

# die Sachmerkmalsleiste kann aus dem Basisartikel entfernt werden, bleibt in der Version erhalten
    Given I open an editor "BAS-AENDERN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-AENDERN"
    And I respond with answer "ja" to the dialog with id "vorhandene Sachmerkmal-Leiste löschen?"
    And I set field "sach" to ""
    And I save the current editor

    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "VIEW" for record "AENDERN1"
    Then field "sach^id" has value "!SML-BAS^id"
    And I press button "bmerk" to open a subeditor for "Sachmerkmale"
    Then fields have values
      | qdurchm | 9.80 |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


  Scenario: Lagereinheit im Basisartikel wird aus der standard Artikelkonf, oder wenn diese leer dann mit Stück vorbelegt

# Standardeinheit in der Artikelkonf ist leer
    Given I open an editor "teil" from table "(Part):(ProductConfiguration)" with command "VIEW" for record "STD_PRODUCTCONF"
    Then field "stdeinheit" is empty
    And I close the current editor

# bei fehlender Standardeinheit, ist die Lagereinheit im Basisartikel änderbar, ansonsten beim Speichern mit Stück vorbelegt
    Given I open an editor "BAS-EINH-KG" from table "(Part):(BaseProduct)" with command "NEW" for record ""
    And I set fields
      | such     | BAS-EINH-KG         |
      | namebspr | Einheiten prüfen kg |
    Then field "le" is empty
    Then field "le" is modifiable
    And I save the current editor

# Lagereinheit Stück wurde vorbelegt, kann nicht geändert werden, wenn Prio zu niedrig
    Given I open an editor "BAS-EINH-KG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-EINH-KG"
    Then field "le" has value "Stück"
    Then field "le" is not modifiable
    And I close the current editor


  Scenario: Lagereinheit kann geändert werden mit Prio

    Given I'm logged in with password "adm"
    Given I set the fake date to "01.01.2000"

# Lagereinheit Stück wurde vorbelegt, kann geändert werden, wenn keine Versionen und mindestens Prio E
    Given I open an editor "BAS-EINH-KG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-EINH-KG"
    Then field "le" has value "Stück"
# 10550 de      |Eine leere Eingabe ist unzulässig.
    Then setting field "le" to "" throws the exception "10550"
    And I set field "le" to "kg"
    And I save the current editor

# Version mit abweichender Lagereinheit kann dem Basisartikel nicht zugeordnet werden
    Given I open an editor "BAS-EINH-KG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-EINH-KG"
    Then field "le" has value "kg"
    And I delete all rows
    And I create a new row at the end of the table
# 2953 de      |Artikel hat nicht die selbe Lagereinheit wie der Basisartikel.
    Then setting field "tversion" to "E1" in row 1 throws the exception "2953"
    And I close the current editor

    Given I open an editor "E1" from table "(Part):(Product)" with command "UPDATE" for record "E1"
    Then field "le" has value "m²"
# 2953 de      |Artikel hat nicht die selbe Lagereinheit wie der Basisartikel.
    Then setting field "basisartikel" to "BAS-EINH-KG" throws the exception "2953"
    And I close the current editor

  Scenario: Lagereinheit im Basisartikel Modus Neu wird aus den Betriebsdaten oder der zugeordneten Version geholt

# Standardeinheit in der standard Artikelkonf auf m ändern
    Given I open an editor "Artikelkonf" from table "(Part):(ProductConfiguration)" with command "UPDATE" for record "STD_PRODUCTCONF"
    And I set field "stdeinheit" to "m"
    And I save the current editor

# Standardeinheit aus der Artikelkonf wird vorbelegt beim Speichern
    Given I open an editor "BAS-EINH-M" from table "(Part):(BaseProduct)" with command "NEW" for record ""
    And I set fields
      | such     | BAS-EINH-M         |
      | namebspr | Einheiten prüfen m |
    And I save the current editor

    Given I open an editor "BAS-EINH-M" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS-EINH-M"
    Then field "le" has value "m"
    And I close the current editor

# wenn beim Anlegen des Basisartikels direkt eine Version eingetragen wird, dann wird die Lagereinheit der Version eingetragen
    Given I open an editor "BAS-EINH-ST" from table "(Part):(BaseProduct)" with command "NEW" for record ""
    And I set fields
      | such     | BAS-EINH-ST         |
      | namebspr | Einheiten prüfen St |
    Then field "le" is empty
    And I delete all rows
    And I append rows
      | tversion | tindex | tstdvers |
      | V2       | 001    | ja       |
    Then field "le" has value "Stück"
    And I save the current editor


  Scenario: bei Basisartikel mit Versionen kann die Einheit auch mit Wartungspasswort nicht mehr geändert werden

    Given I'm logged in with password "annette"
    Given I set the fake date to "01.01.2000"

    Given I open an editor "BAS-EINH-ST" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-EINH-ST"
    Then field "le" is not modifiable in row 0
    And I delete all rows
    Then field "le" is modifiable in row 0
    And I set field "le" to "m"
    And I save the current editor

# Standardeinheit in der standard Artikelkonf wieder auf St�ck setzen
    Given I open an editor "Artikelkonf" from table "(Part):(ProductConfiguration)" with command "UPDATE" for record "STD_PRODUCTCONF"
    And I set field "stdeinheit" to "Stück"
    And I save the current editor


  Scenario: Artikel neu und Eintragen von Basisartikel belegt alle Einheiten im Artikel vor

    Given I open an editor "VERS-EINH" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such         | VERS-EINH        |
      | namebspr     | Einheiten prüfen |
      | basisartikel | BAS-EINH-KG      |
      | index        | K01              |
      | bsart        | Eigenfertigung   |
    Then fields have values
      | le     | kg |
      | vhe    | kg |
      | vpe    | kg |
      | ehe    | kg |
      | epe    | kg |
      | ve     | kg |
      | ge     | kg |
      | fle    | 1  |
      | fvhe   | 1  |
      | fvpe   | 1  |
      | fehe   | 1  |
      | fepe   | 1  |
      | fve    | 1  |
      | fge    | 1  |
      | plprpe | kg |
      | epe1   | kg |
      | ehe1   | kg |
      | epe2   | kg |
      | ehe2   | kg |
      | epe3   | kg |
      | ehe3   | kg |
      | epe4   | kg |
      | ehe4   | kg |
      | epe5   | kg |
      | ehe5   | kg |
    And I set field "le" to "Stück"
# 2953 de      |Artikel hat nicht die selbe Lagereinheit wie der Basisartikel.
    Then saving the current editor throws the exception "2953"
    And I set field "le" to "kg"
    And I save the current editor

  Scenario: Entfernen Basisartikel aus Version ist möglich und wird in Verwendung vererbt
# FDA-3672

# Baugruppe anlegen, Fertigungsliste mit Basisartikel und elem gefüllt, nicht Standardversion
    Given I open an editor "BGBASVERS" from table "(Part):(Product)" with command "STORE" for record "BGBASVERS"
    And I set fields
      | such     | BGBASVERS                        |
      | namebspr | Bauteil Basisartikel und Version |
      | bsart    | Eigenfertigung                   |
    And I delete all rows
    And I append rows
      | tbasisartikel | elex     | elanzahl |
      | BAS-AENDERN   | AENDERN1 | 1        |
      |               | E3       | 1        |
      |               | A AG1    | 1        |
    And I save the current editor

# Basisartikel ändern ist möglich und wird in Version vererbt
    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "UPDATE" for record "AENDERN1"
    Then field "basisartikel" has value "BAS-AENDERN"
    And I set field "basisartikel" to "BAS_AUF"
    And I save the current editor

# Basisartikel wurde in der Fertigungsliste geändert
    Given I open an editor "BGBASVERS" from table "(Part):(Product)" with command "VIEW" for record "BGBASVERS"
    Then table has values
      | !row | tbasisartikel | elex     |
      | 1    | BAS_AUF       | AENDERN1 |
    And I close the current editor

# Entfernen Basisartikel aus Version ist möglich und wird in Verwendung vererbt
    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "UPDATE" for record "AENDERN1"
    Then field "basisartikel" has value "BAS_AUF"
    And I set field "basisartikel" to ""
    And I save the current editor

# Basisartikel wurde in der Fertigungsliste entfernt
    Given I open an editor "BGBASVERS" from table "(Part):(Product)" with command "VIEW" for record "BGBASVERS"
    Then table has values
      | !row | tbasisartikel | elex     |
      | 1    |               | AENDERN1 |
    And I close the current editor

# Basisartikel wieder wie am Anfang setzen
    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "UPDATE" for record "AENDERN1"
    Then field "basisartikel" has value ""
    And I set field "basisartikel" to "BAS-AENDERN"
    And I save the current editor

# Basisartikel wurde in der Fertigungsliste geändert
    Given I open an editor "BGBASVERS" from table "(Part):(Product)" with command "VIEW" for record "BGBASVERS"
    Then table has values
      | !row | tbasisartikel | elex     |
      | 1    | BAS-AENDERN   | AENDERN1 |
    And I close the current editor

# Zeile kann aus Basisartikel entfernt werdenm obwohl noch in Fertigungsliste eingetragen
    Given I open an editor "BAS-AENDERN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-AENDERN"
    Then table has values
      | tversion | tartstatus      | tstdvers |
      | AENDERN1 | Serienfertigung | nein     |
      | AENDERN2 | In Entwicklung  | nein     |
      | AENDERN3 | Serienfertigung | ja       |
    And I delete row at position 1
    And I save the current editor

# Basisartikel wurde in der Fertigungsliste entfernt
    Given I open an editor "BGBASVERS" from table "(Part):(Product)" with command "VIEW" for record "BGBASVERS"
    Then table has values
      | !row | tbasisartikel | elex     |
      | 1    |               | AENDERN1 |
    And I close the current editor

# Basisartikel wieder wie am Anfang setzen
    Given I open an editor "AENDERN1" from table "(Part):(Product)" with command "UPDATE" for record "AENDERN1"
    Then field "basisartikel" has value ""
    And I set field "basisartikel" to "BAS-AENDERN"
    And I save the current editor

  Scenario: Preis/Rabattgruppe im Basisartikel

# Preisgruppe anlegen
    Given I open an editor "PREISGR" from table "(Pricing):(Pricing)" with command "NEW" for record ""
    And I set fields
      | such   | PREISGR |
      | gltvon | .       |
      | gltbis | +10     |
      | mgeab  | ja      |
    And I delete all rows
    And I append rows
      | mgrenze | mpreis |
      | 1       | 10     |
      | 50      | 8      |
    And I save the current editor

# Basisartikel neu anlegen, beim Speichern werden die Preis-/Rabattgruppen mit der Identnummer des Basisartikels gefüllt
    Given I open an editor "BAS-PRG" from table "(Part):(BaseProduct)" with command "NEW" for record ""
    And I set fields
      | such     | BAS-PRG     |
      | namebspr | Preisgruppe |
    And I save the current editor

# Preis-/Rabattgruppen sind vorbelegt mit Identnummer des Basisartikels und sind änderbar
    Given I open an editor "BAS-PRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-PRG"
    Then fields have values
      | vprg  | !BAS-PRG^nummer |
      | vrab  | !BAS-PRG^nummer |
      | prov  | !BAS-PRG^nummer |
      | eprg  | !BAS-PRG^nummer |
      | erab  | !BAS-PRG^nummer |
      | eprg2 | !BAS-PRG^nummer |
      | erab2 | !BAS-PRG^nummer |
      | eprg3 | !BAS-PRG^nummer |
      | erab3 | !BAS-PRG^nummer |
      | eprg4 | !BAS-PRG^nummer |
      | erab4 | !BAS-PRG^nummer |
      | eprg5 | !BAS-PRG^nummer |
      | erab5 | !BAS-PRG^nummer |
    Then field "vprg" is modifiable
    Then field "vrab" is modifiable
    Then field "prov" is modifiable
    Then field "eprg" is modifiable
    Then field "erab" is modifiable
    Then field "eprg2" is modifiable
    Then field "erab2" is modifiable
    Then field "eprg3" is modifiable
    Then field "erab3" is modifiable
    Then field "eprg4" is modifiable
    Then field "erab4" is modifiable
    Then field "eprg5" is modifiable
    Then field "erab5" is modifiable
    And I set field "vprg" to "PREISGR"
    And I save the current editor

# bei Artikel Neuanlage wird die Preisgruppe nicht aus dem Basisartikel vorbelegt
    Given I open an editor "PRG-G01" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such         | PRG-G01                 |
      | namebspr     | Preisgruppe nicht Basis |
      | basisartikel | BAS-PRG                 |
      | index        | G01                     |
# Felder sind leer
    Then fields have values
      | vprg  |  |
      | vrab  |  |
      | prov  |  |
      | eprg  |  |
      | erab  |  |
      | eprg2 |  |
      | erab2 |  |
      | eprg3 |  |
      | erab3 |  |
      | eprg4 |  |
      | erab4 |  |
      | eprg5 |  |
      | erab5 |  |
    And I save the current editor


# Basisartikel kopieren, die Felder Preis-/Rabattgruppen werden geleert
    Given I open an editor "BAS-PRG" from table "(Part):(BaseProduct)" with command "COPY" for record "BAS-PRG"
    And I set fields
      | such     | KOPIE                    |
      | namebspr | Preis/Rabattgruppen leer |
# manuell eingetragene Preisgruppe wird übernommen, andere Felder geleert
    Then fields have values
      | vprg  | PREISGR |
      | vrab  |         |
      | prov  |         |
      | eprg  |         |
      | erab  |         |
      | eprg2 |         |
      | erab2 |         |
      | eprg3 |         |
      | erab3 |         |
      | eprg4 |         |
      | erab4 |         |
      | eprg5 |         |
      | erab5 |         |
    And I save the current editor

# Preis-/Rabattgruppen wurden beim Speichern mit Identnummer des Basisartikels gefüllt, der übernommene Wert bleibt
    Given I open an editor "KOPIE" from table "(Part):(BaseProduct)" with command "UPDATE" for record "KOPIE"
    Then fields have values
      | vprg  | PREISGR         |
      | vrab  | !BAS-PRG^nummer |
      | prov  | !BAS-PRG^nummer |
      | eprg  | !BAS-PRG^nummer |
      | erab  | !BAS-PRG^nummer |
      | eprg2 | !BAS-PRG^nummer |
      | erab2 | !BAS-PRG^nummer |
      | eprg3 | !BAS-PRG^nummer |
      | erab3 | !BAS-PRG^nummer |
      | eprg4 | !BAS-PRG^nummer |
      | erab4 | !BAS-PRG^nummer |
      | eprg5 | !BAS-PRG^nummer |
      | erab5 | !BAS-PRG^nummer |
    And I close the current editor

# Preis-/Rabattgruppen im Basisartikel können geleert werden
    Given I open an editor "BAS-PRG" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS-PRG"
    And I set field "vprg" to ""
    And I set field "vrab" to ""
    And I set field "prov" to ""
    And I save the current editor


  Scenario: Zyklusprüfung bei Basisartikel-FL-Zeilen ohne Version läuft über Standardversion, Prüfung im Artikel
# Baugruppe mit Basisartikel in Stückliste (elex=leer)
    Given I open an editor "BG-XX" from table "(Part):(Product)" with command "STORE" for record "BG-XX"
    And I set fields
      | such     | BG-XX          |
      | namebspr | BG-XX          |
      | bsart    | Eigenfertigung |
    And I delete all rows
    And I append rows
      | tbasisartikel | elex       | elanzahl |
      | BASISART      |            | 1        |
      |               | A AG-LOHN1 | 1        |
      |               | A AG-LOHN2 | 1        |
    And I save the current editor

# BG-XX in Fertigungsliste von EK-B-VERS1 (Standard BASISART) eintragen
# Fehler:     93 de      |Zyklische Struktur
    Given I open an editor "EK-B-VERS1" from table "(Part):(Product)" with command "STORE" for record "EK-B-VERS1"
    And I create a new row at the end of the table
    And I set field "elex" to "BG-XX" in row !lastRow
    Then saving the current editor throws the exception "93"
    And I close the current editor


  Scenario: Zyklusprüfung bei Basisartikel-FL-Zeilen ohne Version läuft über Standardversion, Prüfung im Basisartikel
# Baugruppe mit Basisartikel in Stückliste (elex=leer)
    Given I open an editor "BG-XX" from table "(Part):(Product)" with command "STORE" for record "BG-XX"
    And I set fields
      | such     | BG-XX          |
      | namebspr | BG-XX          |
      | bsart    | Eigenfertigung |
    And I delete all rows
    And I append rows
      | tbasisartikel | elex       | elanzahl |
      | BASISART      |            | 1        |
      |               | A AG-LOHN1 | 1        |
      |               | A AG-LOHN2 | 1        |
    And I save the current editor

# BG-XX in FL von
    Given I open an editor "EK-B-VERS2" from table "(Part):(Product)" with command "STORE" for record "EK-B-VERS2"
    And I append rows
      | elex  | elanzahl |
      | BG-XX | 1        |
    And I save the current editor

# in BASISART Standardversion auf EK-B-VERS2 ändern
# Fehler: 3147 TX=de   |Zyklische Struktur. Das Ändern der Standardversion wurde zurückgenommen, um den Zyklus zu verhindern.
# Fehlermeldung kann nicht geprüft werden, da nach dem Speichern geprüft und Daten wieder zurückgesetzt werden
    Given I open an editor "BASISART" from table "(Part):(BaseProduct)" with command "STORE" for record "BASISART"
    And I set field "tstdvers" to "ja" in row 2
#   Then saving the current editor throws the exception "3147"
    And I save the current editor

    And I switch the current editor to editor "BASISART"
    Then field "tstdvers" has value "ja" in row 1
    Then field "tstdvers" has value "nein" in row 2
    And I close the current editor

    And I switch the current editor to editor "EK-B-VERS2" with command "UPDATE"
    And I delete all rows
    And I save the current editor

  Scenario: Flag manbu setzen in der Stückliste und in der FL, wenn nur der Basisartikel eingetragen wurde
# Neuen Artikel anlegen und nur den Basisartikel eintragen, manbu = ja setzen
    Given I open an editor "TE_MANBU" from table "(Part):(Product)" with command "STORE" for record "TE_MANBU"
    And I set fields
      | such     | TE_MANBU                    |
      | namebspr | Teil mit manueller Entnahme |
      | dispoa   | bedarfsbezogen              |
      | bsart    | Eigenfertigung              |
    And I delete all rows
    And I append rows
      | tbasisartikel | anzahl | manbu |
      | BAS_BED       | 1      | ja    |
    And I save the current editor

# Fertigungsliste des Artikels ändern und weiteren Basisartikel eintragen und manbu = ja setzen
    Given I open an editor "FL_MANBU" from table "(ProductionList):(ProductionList)" with command "STORE" for search criteria "$,,artikel=TE_MANBU;@richtung=rückwärts;@maxtreffer=1"
    And I append rows
      | tbasisartikel | anzahl | manbu |
      | BAS_AUF       | 1      | ja    |
    And I save the current editor


  Scenario: Prozessdurchlauf
# Mengen auf 0 setzen
    Given I set StorageQuantity to zero for Product "EK-B-VERS1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK-B-VERS2" on StorageLocation "F1"

# Testvorbereitung: Artikel anlegen, IS VERWEND pruefen
    Given I open an editor "FE9-BEDARF" from table "(Part):(Product)" with command "STORE" for record "FE9-BEDARF"
    And I set fields
      | such  | FE9-BEDARF     |
      | bsart | Eigenfertigung |
    And I delete all rows
    And I append rows
      | tbasisartikel | elex       | elanzahl    |
      | BASISART      |            | 1           |
      |               | EK1-BEDARF | 1           |
      |               | A AG-LOHN1 | !dontChange |
      |               | A AG-LOHN2 | !dontChange |
    And I save the current editor

    Given I open the infosystem "VERWEND"
    And I set field "kbasisartikel" to "BASISART"
    And I press start
    Then table has values
      | telem      | tvaterelem | tanzahl | !row |
      | FE9-BEDARF | EK-B-VERS1 | 1       | 2    |
    And I close the current editor

# Prozessdurchlauf
# Auftrag anlegen und Material beschaffen
    Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel    | mge |
      | FE9-BEDARF | 50  |
    And I save the current editor
    And I run Scheduling

    Given I create a PurchaseOrder "Best-EK1" for Vendor "LIEFER1" with Product "EK1-BEDARF" and quantity "50"
    And I deliver the PurchaseOrder "Best-EK1" with PackingSlip "LS-EK1"
    Given I create a PurchaseOrder "Best-EKB1" for Vendor "LIEFER1" with Product "EK-B-VERS1" and quantity "50"
    And I deliver the PurchaseOrder "Best-EKB1" with PackingSlip "LS-EKB1"

# Bestand Basisartikel pruefen
    Given I open the infosystem "BESTAND"
    And I set field "basisartikel" to "BASISART"
    And I set field "details" to "nein"
    And I press start
    Then the table has 2 rows
    Then table has values
      | tbasisartikel | tartikel   | lemge |
      | BASISART      | EK-B-VERS1 | 50    |
    And I close the current editor

# Betriebsauftrag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "FE9-BEDARF"
    And I press button "ladetab"
    And I modify table
      | !row | bisuch  | mfreig |
      | 1    | PROZESS | ja     |
    And I press button "freig" to open a subeditor for "fvor_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Kalkulation BA pruefen
    Given I query "typ,hk" from table "(CostingSheet):(CostingSheet)" where "artikel==FE9-BEDARF;basis=50"
    Then query has values
      | typ                    | hk      |
      | Auftragsvorkalkulation | 26.8000 |
    And I close the current editor

# Version in Fertigungsliste aendern
    Given I open an editor "Reserv_SETAG" from table "(Purchasing):(Reservations)" with command "UPDATE" for search criteria "$,,elex=EK-B-VERS1;@richtung=rueckwaerts;@maxtreffer=1"
    And I delete row at position 1
    And I create a new row at position 1
    And I modify table
      | elex       | elanzahl | !row |
      | EK-B-VERS2 | 1        | 1    |
    And I save the current editor

# BA nachkalkulieren, Aenderung der Herstellkosten pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "FE9-BEDARF"
    And I press button "ladetab"
    And I press button "bunkalk" to open a subeditor for "Nachkalkulation" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I query "typ,hk" from table "(CostingSheet):(CostingSheet)" where "artikel==FE9-BEDARF;basis=50"
    Then query has values
      | typ                    | hk      |
      | Auftragsvorkalkulation | 26.8000 |
      | Nachkalkulation        | 24.4000 |
    And I close the current editor

# Bestellung EK-B-VERS2
    Given I create a PurchaseOrder "Best-EKB2" for Vendor "LIEFER1" with Product "EK-B-VERS2" and quantity "50"
    And I deliver the PurchaseOrder "Best-EKB2" with PackingSlip "LS-EKB2"
    And I run Scheduling

# Bestand Basisartikel pruefen
    Given I open the infosystem "BESTAND"
    And I set field "basisartikel" to "BASISART"
    And I set field "details" to "nein"
    And I press start
    Then the table has 2 rows
    Then table has values
      | tbasisartikel | tartikel   | lemge |
      | BASISART      | EK-B-VERS1 | 50    |
      | BASISART      | EK-B-VERS2 | 50    |
    And I close the current editor

# Rueckmeldungen auf BA
    Given I open an editor "RM1_RROZESS" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROZESS001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I open an editor "RM2_RROZESS" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROZESS002"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Auftrag liefern
    Given I deliver the SalesOrder "Auftrag1" with PackingSlip "LAuftrag1"

# Standardversion in Basisartikel aendern
    Given I open an editor "BASISART" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISART"
    And I set field "tstdvers" to "ja" in row 2
    And I save the current editor

# Auftrag anlegen und FV auf geaenderten Basisartikel pruefen
    Given I open an editor "Auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set field "kunde" to "KUNDE1"
    And I append rows
      | artikel    | mge |
      | FE9-BEDARF | 50  |
    And I save the current editor
    And I run Scheduling

    Given I open an editor "Reserv_Auftrag2" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=EK-B-VERS2;@richtung=rueckwaerts;@maxtreffer=1"
    Then table has values
      | elex       | elanzahl | !row |
      | EK-B-VERS2 | 1        | 1    |
    And I close the current editor

# Auftrag loeschen
    Given I switch the current editor to editor "Auftrag2" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor

  Scenario: Eintrag Basisartikel in Artikel wird in alle Fertigungslisten nachgetragen, in denen der Artikel verwendet wird

    Given I open an editor "NACHTRAG" from table "(Part):(Product)" with command "STORE" for record "NACHTRAG"
    And I set fields
      | such     | NACHTRAG                   |
      | namebspr | Basisartikel nachtraeglich |
      | dispoa   | bedarfsbezogen             |
      | bsart    | Fremdbeschaffung           |
    And I save the current editor

    Given I open an editor "NACHTRAG" from table "(Part):(Product)" with command "COPY" for record "NACHTRAG"
    And I set fields
      | such | NACHTRAG2 |
    And I save the current editor

    Given I open an editor "BG1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    And I create a new row at position 1
    And I modify table
      | !row | elex     | anzahl |
      | 1    | NACHTRAG | 1      |
    Then field "tbasisartikel" is empty in row 1
    And I save the current editor

    Given I open an editor "V1" from table "(Part):(Product)" with command "UPDATE" for record "V1"
    And I create a new row at position 1
    And I modify table
      | !row | elex      | anzahl |
      | 1    | NACHTRAG2 | 1      |
    Then field "tbasisartikel" is empty in row 1
    And I save the current editor

    Given I open an editor "NACHTRAG" from table "(Part):(Product)" with command "UPDATE" for record "NACHTRAG"
    Then I set field "basisartikel" to "BAS_BED"
    Then I set field "index" to "011"
    And I save the current editor

    Given I open an editor "BAS_AUF" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_AUF"
    And I append rows
      | tversion  | tindex |
      | NACHTRAG2 | 012    |
    And I save the current editor

    Given I open an editor "BG1" from table "(Part):(Product)" with command "VIEW" for record "BG1"
    Then field "tbasisartikel" has value "BAS_BED" in row 1
    And I close the current editor

    Given I open an editor "V1" from table "(Part):(Product)" with command "VIEW" for record "V1"
    Then field "tbasisartikel" has value "BAS_AUF" in row 1
    And I close the current editor


  Scenario: Infosystem LMB kann alle Versionen bei Vorschlag beruecksichtigen
    Given I set the fake date to "01.04.1995"
# Zweiten Basisartikel und Versionen anlegen, es gibt bereits BASISART mit den Versionen EK-B-VERS1 und EK-B-VERS2
    Given I open an editor "BASISART2" from table "(Part):(BaseProduct)" with command "STORE" for record "BASISART2"
    And I set field "such" to "BASISART2"
    And I delete all rows
    And I save the current editor

    Given I open an editor "EK2-B-VERS3" from table "(Part):(Product)" with command "STORE" for record "EK2-B-VERS3"
    And I set fields
      | such         | EK2-B-VERS3 |
      | namebspr     | EK2-B-VERS3 |
      | basisartikel | !BASISART2  |
      | index        | 100         |
      | lief         | LIEFER1     |
      | efrist       | 3           |
      | epr          | 3           |
    And I save the current editor

    Given I open an editor "EK2-B-VERS4" from table "(Part):(Product)" with command "STORE" for record "EK2-B-VERS4"
    And I set fields
      | such         | EK2-B-VERS4 |
      | namebspr     | EK2-B-VERS4 |
      | basisartikel | !BASISART2  |
      | index        | 200         |
      | lief         | LIEFER1     |
      | efrist       | 3           |
      | epr          | 5           |
    And I save the current editor

# Standardversion in BASISART aendern und Bestand auf 0
    Given I set StorageQuantity to zero for Product "EK-B-VERS1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK-B-VERS2" on StorageLocation "F1"

    Given I open an editor "BASISART" from table "(Part):(BaseProduct)" with command "STORE" for record "BASISART"
    And I set field "tstdvers" to "ja" in row 1
    And I save the current editor

# Lagerzugaenge für Versionen buchen
    Given I post a receipt via ManualStockAdjustment for Product "EK-B-VERS1" and quantity "900" on StorageLocation "F1" with document "VERS1"
    Given I post a receipt via ManualStockAdjustment for Product "EK-B-VERS2" and quantity "500" on StorageLocation "F1" with document "VERS2"
    Given I post a receipt via ManualStockAdjustment for Product "EK2-B-VERS3" and quantity "900" on StorageLocation "F1" with document "VERS3"
    Given I post a receipt via ManualStockAdjustment for Product "EK2-B-VERS4" and quantity "500" on StorageLocation "F1" with document "VERS4"

  Scenario Outline: Infosystem LMB kann alle Versionen bei Vorschlag berücksichtigen
# Abgaenge Basisartikel über Auftrag über zwei Monate
    Given I open an editor "<such>" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | such  | <such>  |
      | kunde | <kunde> |
      | vom   | <vom>   |
    And I append rows
      | basisartikel    | artikel    | mge    |
      | <basisartikel1> | <artikel1> | <mge1> |
      | <basisartikel2> | <artikel2> | <mge2> |
    And I save the current editor

    Given I switch the current editor to editor "<such>" with command "DELIVERY"
    And I set fields
      | vom | <vom2> |
      | ueb | ja     |
    And I modify table
      | !row | mge    |
      | 1    | <mge1> |
      | 2    | <mge2> |
    And I save the current editor

    Examples:
      | such     | kunde  | vom | basisartikel1 | artikel1   | mge1 | basisartikel2 | artikel2    | mge2 | vom2 |
      | AUFTRAG1 | KUNDE1 | -40 | BASISART      | EK-B-VERS1 | 100  | BASISART2     | EK2-B-VERS3 | 100  | -39  |
      | AUFTRAG2 | KUNDE2 | -35 | BASISART      | EK-B-VERS1 | 150  | BASISART2     | EK2-B-VERS3 | 150  | -34  |
      | AUFTRAG3 | KUNDE2 | -30 | !dontChange   | EK-B-VERS2 | 100  | !dontChange   | EK2-B-VERS4 | 100  | -29  |
      | AUFTRAG4 | KUNDE1 | -10 | BASISART      | EK-B-VERS1 | 200  | BASISART2     | EK2-B-VERS3 | 200  | -9   |
      | AUFTRAG5 | KUNDE2 | -5  | BASISART      | EK-B-VERS1 | 250  | BASISART2     | EK2-B-VERS3 | 250  | -4   |
      | AUFTRAG6 | KUNDE2 | -5  | !dontChange   | EK-B-VERS2 | 200  | !dontChange   | EK2-B-VERS4 | 200  | -4   |

  Scenario: Infosystem LMB kann alle Versionen bei Vorschlag berücksichtigen
# Infosystem LMB auswerten
    Given I open the infosystem "LMB"
    And I set fields
      | kbasisvon | BASISART  |
      | kbasisbis | BASISART2 |
      | zurueck   | ja        |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 6 rows
    Then table has values
      | artikel     | lbest | mlb | min | !row |
      | EK-B-VERS1  | 200   | 25  | 0   | 2    |
      | EK-B-VERS2  | 200   | 12  | 0   | 3    |
      | EK2-B-VERS3 | 200   | 25  | 0   | 5    |
      | EK2-B-VERS4 | 200   | 11  | 0   | 6    |
    And I set field "tauswahl" to "ja" in row 2
    And I set field "tauswahl" to "ja" in row 6
    And I press button "sollist"
    Then table has values
      | !row | artikel     | min |
      | 2    | EK-B-VERS1  | 25  |
      | 3    | EK-B-VERS2  | 0   |
      | 5    | EK2-B-VERS3 | 0   |
      | 6    | EK2-B-VERS4 | 11  |
    And I press button "zuschr"
    And I close the current editor

    And I open an editor "EK-B-VERS1" from table "(Part):(Product)" with command "VIEW" for record "EK-B-VERS1"
    Then field "mindest" has value "25"
    And I close the current editor

    And I switch the current editor to editor "EK2-B-VERS4" with command "VIEW"
    Then field "mindest" has value "11"
    And I close the current editor


  Scenario: Im IS BESTAND Bestaende eines Basisartikels verdichtet ausgeben

    Given I open an editor "BASISART" from table "(Part):(BaseProduct)" with command "STORE" for record "VERDICHTEN"
    And I set field "such" to "VERDICHTEN"
    And I delete all rows
    And I append rows
      | tversion    | tstdvers | tindex |
      | EK1-AUFTRAG | ja       | V01    |
      | EK2-AUFTRAG |          | V02    |
    And I save the current editor

# Zugaenge buchen
    Given I open an editor "manuellerZugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
    And I set fields
      | artikel | EK1-AUFTRAG |
      | buart   | Zugang      |
      | beldat  | .           |
    And I append rows
      | mge | platz2 |
      | 10  | F1     |
      | 20  | F2     |
      | 30  | F3     |
      | 10  | L2F1   |
      | 20  | L2F2   |
      | 30  | L2F2   |
      | 50  | L3F1   |
    And I save the current editor

    Given I open an editor "manuellerZugang" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "NEW" for record ""
    And I set fields
      | artikel | EK2-AUFTRAG |
      | buart   | Zugang      |
      | beldat  | .           |
    And I append rows
      | mge | platz2 |
      | 10  | F1     |
      | 20  | F2     |
      | 30  | F3     |
      | 10  | L2F1   |
      | 20  | L2F2   |
      | 30  | L2F2   |
      | 50  | L3F1   |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | basisartikel  | VERDICHTEN |
      | klgruppe      |            |
      | artverdichten | ja         |
      | details       | nein       |
    And I press start
# verdichten auf Artikelebene
    Then the table has 2 rows
    Then table has values
      | lgruppe | lager | lplatz | tbasisartikel | tartikel    | lemge | !row |
      |         |       |        | VERDICHTEN    | EK1-AUFTRAG | 170   | 1    |
      |         |       |        | VERDICHTEN    | EK2-AUFTRAG | 170   | 2    |
# verdichten auf Lagerplatzebene
    And I set fields
      | verdichten | ja   |
      | details    | nein |
    And I press start
    Then the table has 12 rows
    Then table has values
      | lgruppe   | lager | lplatz | tartikel    | lemge | !row |
      | KARLSRUHE | L1    | F1     | EK1-AUFTRAG | 10    | 1    |
      | KARLSRUHE | L1    | F1     | EK2-AUFTRAG | 10    | 2    |
      | KARLSRUHE | L1    | F2     | EK1-AUFTRAG | 20    | 3    |
      | KARLSRUHE | L1    | F2     | EK2-AUFTRAG | 20    | 4    |
      | KARLSRUHE | L1    | F3     | EK1-AUFTRAG | 30    | 5    |
      | KARLSRUHE | L1    | F3     | EK2-AUFTRAG | 30    | 6    |
      | HONGKONG  | L2    | L2F1   | EK1-AUFTRAG | 10    | 7    |
      | HONGKONG  | L2    | L2F1   | EK2-AUFTRAG | 10    | 8    |
      | HONGKONG  | L2    | L2F2   | EK1-AUFTRAG | 50    | 9    |
      | HONGKONG  | L2    | L2F2   | EK2-AUFTRAG | 50    | 10   |
      | BERLIN    | L3    | L3F1   | EK1-AUFTRAG | 50    | 11   |
      | BERLIN    | L3    | L3F1   | EK2-AUFTRAG | 50    | 12   |
# verdichten auf Lagerebene
    And I set fields
      | lagerverdichten | ja   |
      | details         | nein |
    And I press start
    Then the table has 6 rows
    Then table has values
      | lgruppe   | lager | lplatz | tartikel    | lemge | !row |
      | KARLSRUHE | L1    |        | EK1-AUFTRAG | 60    | 1    |
      | KARLSRUHE | L1    |        | EK2-AUFTRAG | 60    | 2    |
      | HONGKONG  | L2    |        | EK1-AUFTRAG | 60    | 3    |
      | HONGKONG  | L2    |        | EK2-AUFTRAG | 60    | 4    |
      | BERLIN    | L3    |        | EK1-AUFTRAG | 50    | 5    |
      | BERLIN    | L3    |        | EK2-AUFTRAG | 50    | 6    |
# verdichten auf Lagergruppenebene
    And I set fields
      | lgruppeverdichten | ja   |
      | details           | nein |
    And I press start
    Then the table has 6 rows
    Then table has values
      | lgruppe   | lager | lplatz | tartikel    | lemge | !row |
      | KARLSRUHE |       |        | EK1-AUFTRAG | 60    | 1    |
      | HONGKONG  |       |        | EK1-AUFTRAG | 60    | 2    |
      | BERLIN    |       |        | EK1-AUFTRAG | 50    | 3    |
      | KARLSRUHE |       |        | EK2-AUFTRAG | 60    | 4    |
      | HONGKONG  |       |        | EK2-AUFTRAG | 60    | 5    |
      | BERLIN    |       |        | EK2-AUFTRAG | 50    | 6    |
    And I close the current editor

  Scenario: Basisartikel ohne Nummernkreisvorlage anlegen
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | verskontrnummerkreisvorl |  |
    And I save the current editor

    Given I open an editor "BAS_ONUM" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS_ONUM"
    And I set fields
      | such         | BAS_ONUM                 |
      | namebspr     | BasisartikelOhneNumkreis |
      | konstrukteur | MEIER                    |
      | fbetreuer    | KARL                     |
    And I save the current editor
    And I close the current editor

    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | verskontrnummerkreisvorl | 313 |
    And I save the current editor

    @BS
  Scenario: Fertigungslistenzeile nur mit Basisartikel kann Umrechnung Fertigung aufnehmen, Einheiten in allen Versionen muessen uebereinstimmen
# Artikel anlegen mit Umrechnung Fertigung
    Given I open an editor "UMRECHFERT" from table "(Part):(Product)" with command "STORE" for record "UMRECHFERT"
    And I set fields
      | such      | UMRECHFERT            |
      | namebspr  | Umrechnung Fertigung  |
      | flme      | 30                    |
      | lme       | cm                    |
      | fbme      | 10                    |
      | bme       | cm                    |
    And I save the current editor

# Artikel anlegen ohne Umrechnung Fertigung und abweichende Einheiten
    Given I open an editor "KEINUMRECH" from table "(Part):(Product)" with command "STORE" for record "KEINUMRECH"
    And I set fields
      | such      | KEINUMRECH            |
      | namebspr  | keine Umrechnung      |
   Then fields have values
      | flme      | 0                     |
      | lme       | mm                    |
      | fbme      | 0                     |
      | bme       | mm                    |
    And I save the current editor

# Basisartikel anlegen und Versionen mit unterschiedlichen Einheiten eintragen, Einheiten der Standardversion werden uebernommen
    Given I open an editor "BAS_UMRECH" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS_UMRECH"
    And I set fields
      | such          | BAS_UMRECH                    |
      | namebspr      | Basis Umrechnung Fertigung    |
    And I append rows
      | tversion      | tindex | tstdvers |
      | UMRECHFERT    | X01    | ja       |
      | KEINUMRECH    | X02    | nein     |
    # 11287 TX=de |Fertigungseinheiten in Version passen nicht. Sollen diese angepasst werden?
    And I respond with answer "ja" to the dialog with id "11289"
    And I save the current editor

# Artikel pruefen, die Einheiten wurden auf cm geaendert
    Given I open an editor "KEINUMRECH" from table "(Part):(Product)" with command "VIEW" for record "KEINUMRECH"
   Then fields have values
      | flme      | 0                     |
      | lme       | cm                    |
      | fbme      | 0                     |
      | bme       | cm                    |
    And I save the current editor

# wenn die Standardversion Umrechnung Fertigung hat, dann sind die Mengenfelder lge und breite in der FL aenderbar, Einheiten nicht
    Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    And I create a new row at the end of the table
    And I set field "tbasisartikel" to "BAS_UMRECH" in row !lastRow
    Then field "elex" is empty in row !lastRow
    Then field "lge" is modifiable in row !lastRow
    Then field "breite" is modifiable in row !lastRow
    Then field "zr" is not modifiable in row !lastRow
    Then field "ze" is not modifiable in row !lastRow
    Then field "zr" has value "cm" in row !lastRow
    Then field "ze" has value "cm" in row !lastRow
    And I save the current editor
    
    Given I open an editor "BAS_UMRECH" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_UMRECH"
    Then the table has 2 rows
    Then table has values
      | tversion      | tindex | tstdvers | !row |
      | UMRECHFERT    | X01    | ja       | 1   |
      | KEINUMRECH    | X02    | nein     | 2   |
    And I modify table
      | !row                   | tstdvers |
      | tversion=='KEINUMRECH' | ja       |
    Then table has values
      | tversion      | tindex | tstdvers | !row |
      | UMRECHFERT    | X01    | nein     | 1   |
      | KEINUMRECH    | X02    | ja       | 2   |
    And I save the current editor

# wenn die Standardversion keine Umrechnung Fertigung hat, dann sind die Mengenfelder in der FL nicht aenderbar, Einheiten sind leer
    Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    Then field "lge" is modifiable in row !lastRow
    Then field "breite" is modifiable in row !lastRow
    And I create a new row at the end of the table
    And I set field "tbasisartikel" to "BAS_UMRECH" in row !lastRow
    Then field "elex" is empty in row !lastRow
    Then field "lge" is not modifiable in row !lastRow
    Then field "breite" is not modifiable in row !lastRow
    Then field "zr" is not modifiable in row !lastRow
    Then field "ze" is not modifiable in row !lastRow
    Then field "zr" is empty in row !lastRow
    Then field "ze" is empty in row !lastRow
    And I save the current editor

# Eintragen einer Version, wechseln und austragen, dabei immer Schreibschutz prüfen
    Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
    Then field "tbasisartikel" has value "BAS_UMRECH" in row !lastRow
    Then field "elex" is empty in row !lastRow
    Then field "lge" is not modifiable in row !lastRow
    Then field "breite" is not modifiable in row !lastRow
    And I set field "elex" to "UMRECHFERT" in row !lastRow
    Then field "lge" is modifiable in row !lastRow
    Then field "breite" is modifiable in row !lastRow
    And I set field "elex" to "" in row !lastRow
    Then field "lge" is not modifiable in row !lastRow
    Then field "breite" is not modifiable in row !lastRow
    And I set field "elex" to "UMRECHFERT" in row !lastRow
    Then field "lge" is modifiable in row !lastRow
    Then field "breite" is modifiable in row !lastRow
    And I set field "elex" to "KEINUMRECH" in row !lastRow
    Then field "lge" is not modifiable in row !lastRow
    Then field "breite" is not modifiable in row !lastRow
    And I close the current editor

@BS
  Scenario: Fertigungseinheiten koennen nur in der Standardversion geaendert werden und werden in alle Versionen uebertragen
# Artikel anlegen mit unterschiedlicher Umrechnung Fertigung
    Given I open an editor "EINHEITAENDERN1" from table "(Part):(Product)" with command "STORE" for record "EINHEITAENDERN1"
    And I set fields
      | such      | EINHEITAENDERN1                 |
      | namebspr  | Umrechnung Fertigung aendern    |
      | flme      | 0,002                           |
      | lme       | kg                              |
      | fbme      | 10                              |
      | bme       | g                               |
    And I save the current editor

    # Felder lme und bme sind schreibgeschuetzt, Werte werden aus der Standardversion in den Basisartikel uebernommen
    Given I open an editor "BAS_AENDERN" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS_AENDERN"
    And I set fields
      | such          | BAS_AENDERN                     |
      | namebspr      | Basis Umrechn Fertigung aendern |
    Then fields are modifiable
        | bme   | nein  |
        | lme   | nein  |
    Then field "bme" is empty
    Then field "lme" is empty
    And I append rows
      | tversion        | tindex | tstdvers |
      | EINHEITAENDERN1 | A01    | ja       |
    And I save the current editor

    Given I open an editor "BAS_AENDERN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_AENDERN"
    Then fields are modifiable
        | bme   | nein  |
        | lme   | nein  |
    Then field "bme" has value "g"
    Then field "lme" has value "kg"
    And I close the current editor

# Artikel anlegen mit abweichender Umrechnung Fertigung und Basisartikel eintragen
    Given I open an editor "EINHEITAENDERN2" from table "(Part):(Product)" with command "STORE" for record "EINHEITAENDERN2"
    And I set fields
      | such            | EINHEITAENDERN2                   |
      | namebspr        | Umrechnung Fertigung aendern      |
      | flme            | 2                                 |
      | lme             | m                                 |
      | fbme            | 10                                |
      | bme             | cm                                |
    And I save the current editor

    Given I open an editor "EINHEITAENDERN2" from table "(Part):(Product)" with command "UPDATE" for record "EINHEITAENDERN2"
    And I set fields
      | basisartikel    | BAS_AENDERN                       |
      | index           | A02                               |
   And I save the current editor

# Artikel pruefen, Umrechnung Fertigung wurde aus Standardversion uebernommen
    Given I open an editor "EINHEITAENDERN2" from table "(Part):(Product)" with command "VIEW" for record "EINHEITAENDERN2"
    Then fields have values
      | flme            | 2     |
      | lme             | kg    |
      | fbme            | 10    |
      | bme             | g     |
   And I close the current editor

# Einheiten koennen nur in der Standardversion geaendert werden und werden dann in die Versionen uebernommen
    Given I open an editor "EINHEITAENDERN2" from table "(Part):(Product)" with command "UPDATE" for record "EINHEITAENDERN2"
    Then field "lme" is not modifiable
    Then field "bme" is not modifiable
   And I close the current editor

    Given I open an editor "EINHEITAENDERN1" from table "(Part):(Product)" with command "UPDATE" for record "EINHEITAENDERN1"
    And I set fields
      | lme       | cm  |
      | bme       | m   |
    # 11288 TX=de |Fertigungseinheiten werden in allen Versionen geändert. Werte müssen danach manuell angepasst werden.
    And I respond with answer "ja" to the dialog with id "11290"
    And I save the current editor

# Artikel pruefen, Umrechnung Fertigung wurde aus Standardversion uebernommen
    Given I open an editor "EINHEITAENDERN2" from table "(Part):(Product)" with command "VIEW" for record "EINHEITAENDERN2"
    Then fields have values
      | flme            | 2     |
      | lme             | cm    |
      | fbme            | 10    |
      | bme             | m     |
   And I close the current editor

    # Umrechnung Fertigung wurde auch in den Basisartikel uebernommen
    Given I open an editor "BAS_AENDERN" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_AENDERN"
    Then fields are modifiable
        | bme   | nein  |
        | lme   | nein  |
    Then field "bme" has value "m"
    Then field "lme" has value "cm"
    And I close the current editor

@BS
Scenario: Basisartikel ohne Standardversion, Fertigungseinheiten koennen in jeder Version geaendert werden und werden in alle Versionen uebertragen
# Artikel anlegen mit Artikelstatus der nicht Standardversion sein kann
    Given I open an editor "PROTOTYP" from table "(Part):(Product)" with command "STORE" for record "PROTOTYP"
    And I set fields
      | such      | PROTOTYP                        |
      | namebspr  | Umrechnung Fertigung PROTOTYP   |
      | artstatus | Prototyp                        |
      | flme      | 2                               |
      | lme       | m                               |
      | fbme      | 10                              |
      | bme       | cm                              |
    And I save the current editor

    Given I open an editor "BAS_KEINSTANDARD" from table "(Part):(BaseProduct)" with command "STORE" for record "BAS_KEINSTANDARD"
    And I set fields
      | such          | BAS_KEINSTANDARD            |
      | namebspr      | Basis keine Standardversion |
    And I delete all rows
    And I append rows
      | tversion    | tindex | tstdvers |
      | PROTOTYP    | P01    | nein     |
    And I save the current editor

    Given I open an editor "BAS_KEINSTANDARD" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS_KEINSTANDARD"
    Then field "bme" has value "cm"
    Then field "lme" has value "m"
    And I close the current editor

    # Abruch beim Aendern der Fertiguingseinheiten laesst Fertigungseinheiten im Basisartikel unberuehrt
    Given I open an editor "PROTOTYP" from table "(Part):(Product)" with command "UPDATE" for record "PROTOTYP"
    And I set fields
      | lme       | cm  |
      | bme       | mm  |
    # 11288 TX=de |Fertigungseinheiten werden in allen Versionen geändert. Werte müssen danach manuell angepasst werden.
    And I respond with answer "nein" to the dialog with id "11290"
    Then saving the current editor throws the exception "2743"
    And I close the current editor

    Given I open an editor "BAS_KEINSTANDARD" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS_KEINSTANDARD"
    Then field "bme" has value "cm"
    Then field "lme" has value "m"
    And I close the current editor

# Artikel anlegen mit Artikelstatus der nicht Standardversion sein kann
    Given I open an editor "ARTERSTELL" from table "(Part):(Product)" with command "COPY" for record "PROTOTYP"
    And I set fields
      | such      | ARTERSTELL                      |
      | namebspr  | Umrechnung Artikelerstellung    |
      | artstatus | Artikelerstellung               |
      | index     | P02                             |
      | flme      | 1                               |
      | lme       | m                               |
      | fbme      | 80                              |
      | bme       | cm                              |
    And I save the current editor

    Given I open an editor "PROTOTYP" from table "(Part):(Product)" with command "COPY" for record "PROTOTYP"
    And I set fields
      | such      | PROTO_2                         |
      | namebspr  | Umrechnung Prototyp 2           |
      | artstatus | Prototyp                        |
      | index     | P03                             |
      | flme      | 1                               |
      | lme       | m                               |
      | fbme      | 80                              |
      | bme       | cm                              |
    And I save the current editor

# Einheiten koennen in jeder Version geaendert werden und werden dann in die Versionen uebernommen, auch in den Basisartikel
    Given I open an editor "PROTOTYP" from table "(Part):(Product)" with command "UPDATE" for record "PROTOTYP"
    Then field "lme" is modifiable
    Then field "bme" is modifiable
   And I close the current editor

    Given I open an editor "ARTERSTELL" from table "(Part):(Product)" with command "UPDATE" for record "ARTERSTELL"
    And I set fields
      | lme       | cm  |
      | bme       | mm  |
    # 11288 TX=de |Fertigungseinheiten werden in allen Versionen geändert. Werte müssen danach manuell angepasst werden.
    And I respond with answer "ja" to the dialog with id "11290"
    And I save the current editor

# Artikel pruefen, Umrechnung Fertigung wurde aus der anderen Version uebernommen
    Given I open an editor "PROTOTYP" from table "(Part):(Product)" with command "VIEW" for record "PROTOTYP"
    Then fields have values
      | flme            | 2     |
      | lme             | cm    |
      | fbme            | 10    |
      | bme             | mm    |
   And I close the current editor

Given I open an editor "PROTO_2" from table "(Part):(Product)" with command "VIEW" for record "PROTO_2"
    Then fields have values
      | flme            | 1     |
      | lme             | cm    |
      | fbme            | 80    |
      | bme             | mm    |
   And I close the current editor

    Given I open an editor "BAS_KEINSTANDARD" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS_KEINSTANDARD"
    Then field "bme" has value "mm"
    Then field "lme" has value "cm"
    And I close the current editor

    Given I open an editor "PROTO_2" from table "(Part):(Product)" with command "UPDATE" for record "PROTO_2"
    And I set fields
      | lme       | kg  |
      | bme       | g   |
    # 11288 TX=de |Fertigungseinheiten werden in allen Versionen geändert. Werte müssen danach manuell angepasst werden.
    And I respond with answer "ja" to the dialog with id "11290"
    And I save the current editor

    # Artikel pruefen, Umrechnung Fertigung wurde aus der anderen Version uebernommen
    Given I open an editor "PROTOTYP" from table "(Part):(Product)" with command "VIEW" for record "PROTOTYP"
    Then fields have values
      | flme            | 2     |
      | lme             | kg    |
      | fbme            | 10    |
      | bme             | g     |
   And I close the current editor

Given I open an editor "ARTERSTELL" from table "(Part):(Product)" with command "VIEW" for record "ARTERSTELL"
    Then fields have values
      | flme            | 1     |
      | lme             | kg    |
      | fbme            | 80    |
      | bme             | g     |
   And I close the current editor

    Given I open an editor "BAS_KEINSTANDARD" from table "(Part):(BaseProduct)" with command "VIEW" for record "BAS_KEINSTANDARD"
    Then field "bme" has value "g"
    Then field "lme" has value "kg"
    And I close the current editor

   @drpf
   Scenario: Basisartikel Nummernkreis lokale Vergabe, manuell vergebenen Index überspirngen. 
   Given I open an editor "SONDER" from table "(NumberAssignment):(NumberRange)" with command "UPDATE" for record "SONDERZEICH"
   And I set fields
     | verfahren      | Lokale Vergabe |
   And I save the current editor
      
   Given I open an editor "A123V002" from table "(Part):(Product)" with command "STORE" for record "A123V002"
   And I set fields
     | such      | A123V002                        |
     | namebspr  | Manueller index                 |
   And I save the current editor
   
   Given I open an editor "A123V002" from table "(Part):(Product)" with command "UPDATE" for record "A123V002"
   And I set fields
     | basisartikel | Sonderzeich |
     | index        | 002         |
   And I save the current editor
   
   Scenario Outline: Artikel anlegen als Versionen für die Basisartikel Sonderzeich
   Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
   And I set fields
      | such         | <such>         |
      | basisartikel | <basisartikel> |
    And I save the current editor
    Examples:
      | such      | basisartikel |
      | A123V001  | Sonderzeich  |
      | A123V003  | Sonderzeich  |

    Scenario: Basisartikel 
   Given I open an editor "A123V003" from table "(Part):(Product)" with command "VIEW" for record "A123V003"
   Then fields have values
      | index           | 003         |
      | nummer          | 123%V1$-003 |
   And I close the current editor


Scenario: Basisartikel mit Standardversion in Fertigungsliste ohne Angabe elex, bei verskontr=false wird trotzdem AFL aufgeloest

Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BAUT"
And I create a new row at position 1
And I set field "tbasisartikel" to "BAS_BED" in row 1
And I set field "anzahl" to "1" in row 1
Then field "elex" is empty in row 1
And I save the current editor

# Versionierung in der Konfiguration abschalten
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "verskontr" to "nein"
And I save the current editor

Given I create a SalesOrder "AUF01" for Customer "TEST" with Product "BAUT" and quantity "20"

Given I open an editor "AUF01" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF01"
And I set field "mge" to "25" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then the table has 5 rows
Then field "elex" has value "FE2-BEDARF" in row 1
And I close the current editor
And I switch the current editor to editor "AUF01"
And I close the current editor

Given I open an editor "Baugruppe" from table "(Part):(Product)" with command "UPDATE" for record "BAUT"
And I set field "mindest" to "100"
# beim Speichern wird geprueft und festgestellt, dass es eine Fertigungslistenzeile ohne elex gibt, das muss gefuellt werden
Then saving the current editor throws the exception "64"
And I close the current editor

# Dispo laeuft ohne Diag
And I run Scheduling

# Versionierung in der Konfiguration wieder einschalten
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "verskontr" to "ja"
And I save the current editor
