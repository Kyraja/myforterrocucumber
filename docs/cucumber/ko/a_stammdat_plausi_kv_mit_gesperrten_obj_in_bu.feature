# *****************************************************************************
#  Name           : a_stammdat_plausi_kv_mit_gesperrten_obj_in_bu.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Plausibilisierung von Stamm-Kostenverteilern, die ein gesperrtes Kostenobjekt enthalten, auf Verwendung
#                   in Finanz- und statistischen Buchungen
# 
#                   Anlage von Stammdaten:
#                   * Konteneigenschaften anpassen
#                   * Kst und Ktr anlegen
#                   * Stamm-Kostenverteiler erzeugen
# *****************************************************************************
#
@persistent
Feature: Stamm-Kostenverteiler mit gesperrten Objekten in Finanz- und statistischen Buchungen 
Background: 
Given I set the fake date to "20.12.1995"


Scenario: 01 Stammdaten
# statistische Konten mit Korezwang ausstatten
Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "99800"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "99000" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "99900"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "99000" in row 1
And I save the current editor
And I close the current editor

# Ktr anlegen
Given I open an editor "Ktr" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "100010"
And I set field "such" to "K100010"
And I save the current editor

Given I open an editor "Ktr" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "100020"
And I set field "such" to "K100020"
And I save the current editor

# Kst anlegen 
Given I open an editor "Ktr" from table "(Account):(CostCenter)" with command "COPY" for record "1300"
And I set field "nummer" to "1400"
And I set field "such" to "K1400"
And I save the current editor

# Stamm-Kostenverteiler anlegen
Given I open an editor "kostenverteiler-10" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "10"
And I set field "such" to "kv10"
And I create a new row at the end of the table
And I set field "kstelle" to "1100" in row 1
And I set field "proz" to "10" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "1200" in row 2
And I set field "proz" to "5" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "1300" in row 3
And I set field "proz" to "85" in row 3
And I save the current editor

Given I open an editor "kostenverteiler-20" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "20"
And I set field "such" to "kv20"
And I create a new row at the end of the table
And I set field "kstelle" to "5100" in row 1
And I set field "proz" to "10" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100010" in row 2
And I set field "proz" to "65" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100020" in row 3
And I set field "proz" to "25" in row 3
And I save the current editor

Given I open an editor "kostenverteiler-30" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "30"
And I set field "such" to "kv30"
And I create a new row at the end of the table
And I set field "kstelle" to "1100" in row 1
And I set field "proz" to "40" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100010" in row 2
And I set field "proz" to "60" in row 2
And I save the current editor

