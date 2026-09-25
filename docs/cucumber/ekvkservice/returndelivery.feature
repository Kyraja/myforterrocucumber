# *****************************************************************************
#  Name           : returndelivery.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teampss
#  Funktion       : Testet das IS RETURNDELIVERY (Ruecklieferungen)
#
# *****************************************************************************
#
@persistent
Feature: Ruecklieferung EK/VK
# Test vom Infosystem Ruecklieferung
Background:
Given I set the fake date to "02.01.1995"

@Charge
Scenario: Charge anlegen
Given I open an editor "tempcharge" from table "(Lots):(Lots)" with command "NEW" for record ""
Then I set field "nummer" to "1111"
Then I set field "such" to "testcharge"
Then I set field "exnum" to "123"
And I save the current editor

Scenario: Projekt anlegen
Given I open an editor "tempprojekt" from table "(Transaction):(Project)" with command "NEW" for record ""
Then I set field "nummer" to "111"
Then I set field "such" to "testprojekt"
And I save the current editor

@EK-Lieferschein
Scenario:  E I N K A U F Daten anlegen
# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "betreuer" to "1"
Then I set field "such" to "LS101"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row !lastRow
Then I set field "mge" to "8" in row !lastRow
Then I set field "verw" to "test" in row !lastRow
And I save the current editor

# Kommando <(Purchasing)> LIEFERSCHEIN <(return)>
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS101"
Then I set field "kenn" to "E I N K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Transportschaden"
Then I set field "vom" to "."
Then I set field "mge" to "-8" in row !lastRow
Then I set field "rueckligrund" to "Ware beschädigt" in row !lastRow
Then I set field "ebeleg" to "101"
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "001"
Then I set field "betreuer" to "1"
Then I set field "such" to "LS102"
Then I set field "vom" to "."
Then I set field "ebeleg" to "151"
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row 1
Then I set field "mge" to "20" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "E1" in row 2
Then I set field "mge" to "25" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS102"
Then I set field "kenn" to "E I N K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Falschlieferung"
Then I set field "vom" to "."
Then I set field "ebeleg" to "151"
Then I set field "rueckligrund" to "Ware gefällt nicht" in row 1
Then I set field "mge" to "-20" in row 1
Then I set field "rueckligrund" to "Ware beschädigt" in row 2
Then I set field "mge" to "-20" in row 2
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "001"
Then I set field "such" to "LS103"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row 1
Then I set field "mge" to "8" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "E1" in row 2
Then I set field "mge" to "20" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS103"
Then I set field "kenn" to "E I N K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Ware gefällt nicht"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "rueckligrund" to "Falschlieferung" in row 2
Then I set field "mge" to "-10" in row 2
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "such" to "LS104"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row 1
Then I set field "mge" to "8" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "E1" in row 2
Then I set field "mge" to "20" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS104"
Then I set field "kenn" to "E I N K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Ware gefällt nicht"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "rueckligrund" to "Falschlieferung" in row 1
Then I set field "mge" to "-8" in row 1
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "such" to "LS105"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row 1
Then I set field "mge" to "8" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "E1" in row 2
Then I set field "mge" to "20" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS105"
Then I set field "kenn" to "E I N K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Ware gefällt nicht"
Then I set field "rueckligrund" to "Falschlieferung" in row 1
Then I set field "mge" to "-4" in row 1
Then I set field "vom" to "-4"
Then I set field "ebeleg" to "111"
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "such" to "LS106"
Then I set field "vom" to "-2"
Then I set field "ebeleg" to "111"
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row 1
Then I set field "mge" to "8" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "E1" in row 2
Then I set field "mge" to "20" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS106"
Then I set field "kenn" to "E I N K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Ware gefällt nicht"
And I set field "rueckligrund" to "Ware gefällt nicht" in row 1
Then I set field "mge" to "-8" in row 1
Then I set field "mge" to "-8" in row 2
Then I set field "vom" to "-2"
Then I set field "ebeleg" to "1111"
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "such" to "LS107"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row 1
Then I set field "mge" to "8" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "E1" in row 2
Then I set field "mge" to "20" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS107"
Then I set field "kenn" to "E I N K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Falschlieferung"
And I set field "rueckligrund" to "Ware gefällt nicht" in row 1
Then I set field "mge" to "-8" in row 1
Then I set field "mge" to "-8" in row 2
Then I set field "vom" to "."
Then I set field "ebeleg" to "113"
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "such" to "LS108"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row 1
Then I set field "mge" to "8" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "E1" in row 2
Then I set field "mge" to "20" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS108"
Then I set field "kenn" to "E I N K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "rueckligrund" to ""
Then I set field "rueckligrund" to "Ware gefällt nicht" in row 1
Then I set field "mge" to "-2" in row 1
Then I set field "rueckligrund" to "Falschlieferung" in row 2
Then I set field "mge" to "-8" in row 2
Then I set field "vom" to "-5"
Then I set field "ebeleg" to "111"
And I save the current editor

@VK-Lieferschein
Scenario: V E R K A U F Daten anlegen
# Anlegen eines Lieferscheins / buchen
Given I open an editor "tempkunde" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "1"
Then I set field "such" to "LS201"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "V1" in row 1
Then I set field "mge" to "33" in row 1
Then I set field "verw" to "test" in row 1
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS201"
Then I set field "kenn" to "V E R K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Falschlieferung"
And I set field "rueckligrund" to "Transportschaden"
Then I set field "rueckligrund" to "Ware beschädigt" in row 1
Then I set field "mge" to "-14" in row 1
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "tempkunde" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "4"
Then I set field "betreuer" to "1"
Then I set field "such" to "LS202"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "V1" in row 1
Then I set field "mge" to "33" in row 1
Then I set field "charge" to "1111" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "V2" in row 2
Then I set field "mge" to "23" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS202"
Then I set field "kenn" to "V E R K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "rueckligrund" to "Falschlieferung"
Then I set field "rueckligrund" to "Ware gefällt nicht" in row 1
Then I set field "mge" to "-8" in row 1
Then I set field "rueckligrund" to "Ware beschädigt" in row 2
Then I set field "mge" to "-8" in row 2
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "tempkunde" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "4"
Then I set field "such" to "LS203"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "V1" in row 1
Then I set field "mge" to "33" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "V2" in row 2
Then I set field "mge" to "23" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS203"
Then I set field "kenn" to "V E R K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Ware gefällt nicht"
Then I set field "rueckligrund" to "Falschlieferung" in row 2
Then I set field "mge" to "-8" in row 2
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "tempkunde" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "4"
Then I set field "such" to "LS204"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "V1" in row 1
Then I set field "mge" to "33" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "V2" in row 2
Then I set field "mge" to "23" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS204"
Then I set field "kenn" to "V E R K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "mge" to "-23" in row 1
And I set field "rueckligrund" to "Ware gefällt nicht"
Then I set field "rueckligrund" to "Falschlieferung" in row 1
Then I set field "mge" to "-8" in row 1
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "tempkunde" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "1"
Then I set field "such" to "LS205"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "vprojekt" to "111"
And I create a new row at the end of the table
Then I set field "artikel" to "V2" in row 1
Then I set field "mge" to "33" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "V1" in row 2
Then I set field "mge" to "23" in row 2
Then I set field "charge" to "1111" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS205"
Then I set field "kenn" to "V E R K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Ware gefällt nicht"
Then I set field "mge" to "-23" in row 1
Then I set field "rueckligrund" to "Falschlieferung" in row 1
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "tempkunde" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "1"
Then I set field "such" to "LS206"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "V1" in row 1
Then I set field "mge" to "33" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "V2" in row 2
Then I set field "mge" to "23" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS206"
Then I set field "kenn" to "V E R K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Ware gefällt nicht"
Then I set field "mge" to "-13" in row 2
And I save the current editor

# Anlegen eines Lieferscheins / buchen
Given I open an editor "tempkunde" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "1"
Then I set field "such" to "LS207"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
And I create a new row at the end of the table
Then I set field "artikel" to "V3" in row 1
Then I set field "mge" to "33" in row 1
And I create a new row at the end of the table
Then I set field "artikel" to "V2" in row 2
Then I set field "mge" to "23" in row 2
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS207"
Then I set field "kenn" to "V E R K A U F"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "rueckligrund" to "Ware gefällt nicht"
Then I set field "mge" to "-1" in row 1
Then I set field "rueckligrund" to "Falschlieferung" in row 1
Then I set field "mge" to "-8" in row 1
And I save the current editor

@Infosystem_EK
Scenario:  Infosystem starten EK, ablageart = beides
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I press button "bstart"
Then the table has 62 rows

Scenario:  Infosystem starten EK, ablageart = beides und Artikel E2
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "artikel" to "E2"
And I press button "bstart"
Then the table has 17 rows

Scenario:  Infosystem starten EK, ablageart = beides und Artikel E1
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "artikel" to "E1"
And I press button "bstart"
Then the table has 9 rows

Scenario:  Infosystem starten EK, ablageart = beides und Lieferant 001
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "lief" to "001"
And I press button "bstart"
Then the table has 4 rows

Scenario:  Infosystem starten EK, ablageart = beides und Betreuer 1
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "betreuer" to "1"
And I press button "bstart"
Then the table has 5 rows

Scenario:  Infosystem starten EK, ablageart = beides und Verwendung test
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "verw" to "test"
And I press button "bstart"
Then the table has 1 rows

Scenario:  Infosystem starten EK, ablageart = lebendig
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "lebendig"
And I press button "bstart"
Then the table has 16 rows

Scenario:  Infosystem starten EK, ablageart = lebendig
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "lebendig"
And I set field "nuebertr" to "ja"
And I press button "bstart"
Then the table has 30 rows

Scenario:  Infosystem starten EK, ablageart = abgelegt
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "abgelegt"
And I press button "bstart"
Then the table has 32 rows

Scenario:  Infosystem starten EK, ablageart = beides + Rückliefergrund 1 Kopf
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "rueckligrundt" to "Ware gefällt nicht"
And I press button "bstart"
Then the table has 5 rows
Then field "trueckligrundt" has value "Falschlieferung" in row 1
Then field "trueckligrundk" has value "Ware gefällt nicht" in row 1

Scenario:  Infosystem starten EK, ablageart = beides + Rückliefergrund 1 Tabelle
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "rueckligrundt" to "Falschlieferung"
And I set field "tabellengrundb" to "ja"
And I press button "bstart"
Then the table has 4 rows

Scenario:  Infosystem starten EK, ablageart = beides + Rückliefergrund 2 Kopf
Given I open the infosystem "RETURNDELIVERY"
And I set field "beinkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "rueckligrundt" to "Falschlieferung"
And I press button "bstart"
Then the table has 4 rows
Then field "trueckligrundt" has value "Ware gefällt nicht" in row 1
Then field "trueckligrundk" has value "Falschlieferung" in row 1
Then field "trueckligrundt" has value "Ware beschädigt" in row 2
Then field "trueckligrundk" has value "Falschlieferung" in row 2
Then field "trueckligrundt" has value "Ware gefällt nicht" in row 3
Then field "trueckligrundt" is empty in row 4

@Infosystem_VK
Scenario:  Infosystem starten VK, ablageart = beides
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I press button "bstart"
Then the table has 59 rows
Then field "tartikel" has value "V1" in row 1
Then field "lsart" has value "Rücklieferschein" in row 44
Then field "lsart" has value "Kundenanlieferung" in row 36

Scenario:  Infosystem starten VK, ablageart = beides und Artikel V1
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "artikel" to "V1"
And I press button "bstart"
Then the table has 22 rows

Scenario:  Infosystem starten VK, ablageart = beides und Artikel V2
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "artikel" to "V2"
And I press button "bstart"
Then the table has 4 rows

Scenario:  Infosystem starten VK, ablageart = beides und Projekt 111
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "projekt" to "111"
And I press button "bstart"
Then the table has 1 rows

Scenario:  Infosystem starten VK, ablageart = beides und Kunde 4
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "kunde" to "4"
And I press button "bstart"
Then the table has 4 rows

Scenario:  Infosystem starten VK, ablageart = beides und Betreuer 1
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "betreuer" to "1"
And I press button "bstart"
Then the table has 3 rows

Scenario:  Infosystem starten VK, ablageart = beides und Charge 1111
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "charge" to "1111"
And I press button "bstart"
Then the table has 1 rows

Scenario:  Infosystem starten VK, ablageart = lebendig
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "lebendig"
And I set field "nuebertr" to "ja"
And I press button "bstart"
Then the table has 33 rows

Scenario:  Infosystem starten VK, ablageart = lebendig
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "lebendig"
And I set field "nuebertr" to "nein"
And I press button "bstart"
Then the table has 16 rows

Scenario:  Infosystem starten VK, ablageart = abgelegt
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "abgelegt"
And I press button "bstart"
Then the table has 26 rows

Scenario:  Infosystem starten VK, ablageart = beides + Rückliefergrund 1 Kopf
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "rueckligrundt" to "Ware gefällt nicht"
And I press button "bstart"
Then the table has 5 rows
Then field "trueckligrundt" has value "Falschlieferung" in row 1
Then field "trueckligrundk" has value "Ware gefällt nicht" in row 1
Then field "trueckligrundt" has value "Falschlieferung" in row 2
Then field "trueckligrundk" has value "Ware gefällt nicht" in row 2
Then field "trueckligrundt" has value "Falschlieferung" in row 3
Then field "trueckligrundk" has value "Ware gefällt nicht" in row 3
Then field "trueckligrundt" has value "" in row 4
Then field "trueckligrundk" has value "Ware gefällt nicht" in row 4
Then field "trueckligrundt" has value "Falschlieferung" in row 5
Then field "trueckligrundk" has value "Ware gefällt nicht" in row 5

Scenario:  Infosystem starten VK, ablageart = beides + Rückliefergrund  Tabelle
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "rueckligrundt" to "Ware gefällt nicht"
And I set field "tabellengrundb" to "ja"
And I press button "bstart"
Then the table has 1 rows

Scenario:  Infosystem starten VK, ablageart = beides + Rückliefergrund 2 Kopf
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "rueckligrundt" to "Falschlieferung"
And I press button "bstart"
Then the table has 2 rows
Then field "trueckligrundt" has value "Ware gefällt nicht" in row 1
Then field "trueckligrundk" has value "Falschlieferung" in row 1
Then field "trueckligrundt" has value "Ware beschädigt" in row 2
Then field "trueckligrundk" has value "Falschlieferung" in row 2

@Infosystem_EKZENTRALE
Scenario:  Infosystem starten EKZENTRALE, ablageart = beides
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "ektyp" to "Lieferschein"
And I set field "lsart" to ""
And I press button "bstart"
Then the table has 143 rows
And I press button "exp"
Then the table has 219 rows

Scenario:  Infosystem starten EKZENTRALE, ablageart = lebendig
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "lebendig"
And I set field "ektyp" to "Lieferschein"
And I set field "lsart" to ""
And I press button "bstart"
Then the table has 68 rows

Scenario:  Infosystem starten EKZENTRALE, ablageart = beides
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "ektyp" to "Lieferschein"
And I set field "lsart" to ""
And I set field "kebeleg" to "151"
And I press button "bstart"
Then the table has 2 rows
Then field "tlsart" has value "Lieferschein" in row 1
Then field "ttrans" has value "E 31" in row 1
Then field "ttrans" has value "E 32" in row 2

Scenario:  Infosystem starten EKZENTRALE, ablageart = beides
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "ektyp" to "Lieferschein"
And I set field "lsart" to "Rücklieferschein"
And I press button "bstart"
Then the table has 55 rows
Then field "tlsart" has value "Rücklieferschein" in row 1
Then field "ttrans" has value "E 1" in row 1

Scenario:  Infosystem starten EKZENTRALE, ablageart = beides, nicht gebucht
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "ektyp" to "Lieferschein"
And I set field "lsart" to "Rücklieferschein"
And I set field "kuebertr" to "ja"
And I set field "knuebertr" to "nein"
And I press button "bstart"
Then the table has 13 rows
Then field "tlsart" has value "Rücklieferschein" in row 1
Then field "ttrans" has value "E 1" in row 1

Scenario:  Infosystem starten EKZENTRALE, ablageart = beides, Storno-rücklieferschein
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "ektyp" to "Lieferschein"
And I set field "lsart" to "Storno-Rücklieferschein"
And I press button "bstart"
Then the table has 5 rows
Then field "tlsart" has value "Storno-Rücklieferschein" in row 1
Then field "ttrans" has value "E +17" in row 1

Scenario:  Infosystem starten EKZENTRALE, ablageart = beides, stornierter Rücklieferschein
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "ektyp" to "Lieferschein"
And I set field "lsart" to "Stornierter Rücklieferschein"
And I press button "bstart"
Then the table has 5 rows
Then field "tlsart" has value "Stornierter Rücklieferschein" in row 1
Then field "ttrans" has value "E +1RLS12C" in row 1

@Infosystem_VKZENTRALE
Scenario:  Infosystem starten VKZENTRALE, ablageart = beides
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to ""
And I press button "bstart"
Then the table has 136 rows
And I press button "exp"
Then the table has 203 rows

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, Rücklieferschein
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to "Rücklieferschein"
And I press button "bstart"
Then the table has 46 rows
Then field "tlsart" has value "Rücklieferschein" in row 1
Then field "ttrans" has value "V 300002" in row 1

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, Rücklieferschein, nicht gebucht
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to "Rücklieferschein"
And I set field "kuebertr" to "ja"
And I set field "knuebertr" to "nein"
And I press button "bstart"
Then the table has 14 rows
Then field "tlsart" has value "Rücklieferschein" in row 1
Then field "ttrans" has value "V 300002" in row 1

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, Storno-Rücklieferschein
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to "Storno-Rücklieferschein"
And I press button "bstart"
Then the table has 7 rows
Then field "tlsart" has value "Storno-Rücklieferschein" in row 1
Then field "ttrans" has value "V +300023" in row 1

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, Stornierter Rücklieferschein
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to "Stornierter Rücklieferschein"
And I press button "bstart"
Then the table has 7 rows
Then field "tlsart" has value "Stornierter Rücklieferschein" in row 1
Then field "ttrans" has value "V +300022" in row 1

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, Kundenanlieferung
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to "Kundenanlieferung"
And I press button "bstart"
Then the table has 7 rows
Then field "tlsart" has value "Kundenanlieferung" in row 1
Then field "ttrans" has value "V 1500-KDA" in row 1

# Hier muss die Ausgabe noch aktuialisiert werden. Aktuell kommen nur Rücklieferungen
Scenario:  Infosystem starten VK, ablageart = beides + Rückliefergrund  Tabelle
Given I open the infosystem "RETURNDELIVERY"
And I set field "bverkauf" to "ja"
And I set field "ablageart" to "beides"
And I set field "bruecklief" to "nein"
And I press button "bstart"
Then the table has 7 rows
Then field "lsart" has value "Kundenanlieferung" in row 1

