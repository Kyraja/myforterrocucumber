Feature: nrswecho

  Background:
    And I set the fake date to "02.01.1995"

# **********************************************************************************
#  Name             : nrswecho.feature
#  Autor            : pw
#  Verantwortlich   : ba
#  Kontrolle        :
#  Funktion         : Test von Artikelecho im Konfigsatz - Nummer / Suchwort
#
#  Beschreibung     :
#
#  Testziel:
#     Sicherstellen, dass im Lieferumfang im KONFIG-Satz Suchwort-Echo
#     eingestellt ist, und alle Artikel- und Arbeitsgang-Verweise
#     einheitlich Suchwort-Echo haben.
#
#  Testablauf:
#     1. Ausgangslage sicherstellen: In Konfigsatz ist Suchwort-Echo eingestellt und es existieren keine vorbereiteten Vartabsätze
#     2. Konfigsatz auf Nummern-Echo umstellen und sicherstellen, dass vorbereitete Vartabsätze erzeugt sind
#     3. Die erzeugten vorbereiteten Vartabsätze wieder löschen
#     4. Konfigsatz wieder auf Suchwort-Echo umstellen und sicherstellen, dass keine vorbereiteten Vartabsätze erzeugt wurden
#        --> Falls doch, ist in ERP-Schema eine falsche Verweisdefinition eingetragen!!!!!!
#     5. Konfigsatz auf Nummern-Echo mit erweiterter Suchwort-Länge umstellen und sicherstellen, dass vorbereitete Vartabsätze erzeugt sind
#     6. Die erzeugten vorbereiteten Vartabsätze wieder löschen
#     7. Konfigsatz wieder auf Suchwort-Echo umstellen und sicherstellen, dass keine vorbereiteten Vartabsätze erzeugt wurden
#
# **********************************************************************************

  Scenario: 1. Sicherstellen, dass in Konfigsatz Suchwort-Echo eingestellt ist und keine vorbereiteten Vartabsätze existieren

  Given I query "nrdte,eswte,swdte,nrate,swate" from table "(Company):(Configuration)" where "such==KONFIG"
  Then query has values
  | nrdte | eswte | swdte  | nrate | swate |
  | nein  | nein  | ja     | nein  | ja    |

  Given I query "such" from table "(Company):(Vartab)" where "such==VVAR"
  Then query has no hits


  Scenario: 2. Konfigsatz auf Nummern-Echo umstellen, prüfen ob es vorb. Vartab-Sätze gibt

  Given I open an editor "Konfiguration1" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
  And I set fields
  | nrdte         | ja |
  | nrate         | ja |
  Then field "eswte" has value "nein" in row 0
  Then field "swdte" has value "nein" in row 0
  Then field "swate" has value "nein" in row 0
  And I save the current editor
  And I close the current editor

  # Prüfen, ob es für Verkaufsposition (enthält sicher Artikel) vorbereiteten Vartabsatz gibt
  Given I query "such,vdntxts,vgrtxts" from table "(Company):(Vartab)" where "such==VVAR;vdn==3;vgr==2"
  Then query has values
  | such | vdntxts | vgrtxts |
  | VVAR | (Sales) | (Item)  |


  Scenario: 3. Vorbereitete Vartabsätze löschen

  # Servicemenü habe ich per Cucumber nicht zum laufen bekommen
  # Schön ware die direkte Bedienung des Servicemenüs, z.B. so:
  # Given I open an editor "VVARWEG0" for tip command "(Service)" and arguments ""
  # And I respond with answer "2" to the dialog with id "Servicearbeiten"
  # And I respond with answer "7" to the dialog with id "Variablentabelle"
  # And I respond with answer "y" to the dialog with id ""

  Given I open an editor "VVARWEG1" for tip command "(System)" and arguments "rm -rf vvarweg.epi vvarweg.out"
  And I close the current editor
  Given I append text "lgn||sy" to output file "vvarweg.epi"
  And I append text "SET|1|DIALOGMODE|1|" to output file "vvarweg.epi"
  And I append text "AID|2|PIN|EDIT|VVARWEGEPI|" to output file "vvarweg.epi"
  And I append text "SDA|2|Servicearbeiten|2|" to output file "vvarweg.epi"
  And I append text "SDA|2|Variablentabelle|7|" to output file "vvarweg.epi"
  And I append text "SDA|2||y|" to output file "vvarweg.epi"
  And I append text "EDI|2|DO|(Service)|||||" to output file "vvarweg.epi"
  And I append text "COM|2" to output file "vvarweg.epi"
  And I append text "AID|2|release" to output file "vvarweg.epi"
  And I append text "END" to output file "vvarweg.epi"
  Given I open an editor "VVARWEG2" for tip command "(System)" and arguments "epi < vvarweg.epi >vvarweg.out 2>vvarweg.err"
  And I close the current editor


  Scenario: Konfigsatz wieder auf Suchwort-Echo umstellen und sicherstellen, dass keine vorbereiteten Vartabsätze erzeugt wurden

  Given I open an editor "Konfiguration2" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
  And I set fields
  | swdte         | ja |
  | swate         | ja |
  Then field "eswte" has value "nein" in row 0
  Then field "nrdte" has value "nein" in row 0
  Then field "nrate" has value "nein" in row 0
  And I save the current editor
  And I close the current editor

  # Sicherstellen, dass keine vorbereiteten Vartabsätze existieren
  Given I query "such" from table "(Company):(Vartab)" where "such==VVAR"
  Then query has no hits


  Scenario: 5. Konfigsatz auf Nummern-Echo mit erweiterter Suchwort-Länge umstellen und sicherstellen, dass vorbereitete Vartabsätze erzeugt sind

  Given I open an editor "Konfiguration3" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
  And I set fields
  | eswte         | ja |
  | nrate         | ja |
  Then field "swdte" has value "nein" in row 0
  Then field "nrdte" has value "nein" in row 0
  Then field "swate" has value "nein" in row 0
  And I save the current editor
  And I close the current editor

  # Prüfen, ob es für Verkaufsposition (enthält sicher Artikel) vorbereiteten Vartabsatz gibt
  Given I query "such,vdntxts,vgrtxts" from table "(Company):(Vartab)" where "such==VVAR;vdn==3;vgr==2"
  Then query has values
  | such | vdntxts | vgrtxts |
  | VVAR | (Sales) | (Item)  |


  Scenario: 6. Vorbereitete Vartabsätze löschen

  Given I open an editor "VVARWEG3" for tip command "(System)" and arguments "epi < vvarweg.epi >vvarweg.out 2>vvarweg.err"
  And I close the current editor

  Scenario:  Konfigsatz wieder auf Suchwort-Echo umstellen und sicherstellen, dass keine vorbereiteten Vartabsätze erzeugt wurden

  Given I open an editor "Konfiguration4" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
  And I set fields
  | swdte         | ja |
  | swate         | ja |
  Then field "eswte" has value "nein" in row 0
  Then field "nrdte" has value "nein" in row 0
  Then field "nrate" has value "nein" in row 0
  And I save the current editor
  And I close the current editor

  # Sicherstellen, dass keine vorbereiteten Vartabsätze existieren
  Given I query "such" from table "(Company):(Vartab)" where "such==VVAR"
  Then query has no hits
