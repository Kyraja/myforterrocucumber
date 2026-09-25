@persistent
Feature: Seriennummernverfolgung.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Seriennummernverfolgung.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: SN01 Artikel mit Bestand groesser 1 ohne Charge darf auf Seriennummernverfolgung umgestellt werden

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such              | NOCHA_AUF_SN      |
And I save the current editor

Given I post a receipt via ManualStockAdjustment for Product "NOCHA_AUF_SN" and quantity "5" on StorageLocation "F1" with document "LBU_SN01"

Given I open an editor "NOCHA_AUF_SN" from table "(Part):(Product)" with command "UPDATE" for record "NOCHA_AUF_SN"
And I set fields
    | chverfolgung  | Seriennummernverfolgung   |
And I save the current editor


Scenario: SN02 Artikel mit mehreren Einzelbestaenden von 1 mit eindeutiger Charge darf auf Seriennummernverfolgung umgestellt werden

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | CHA_AUF_SN02      |
    | chverfolgung  | Chargenverfolgung |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHA_AUF_SN02  |
    | buart     | Zugang        |
    | beleg     | LBU_SN02      |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 1      | F1       | 02SN1     |
    | 1      | F1       | 02SN2     |
    | 1      | F2       | 02SN3     |
    | 1      | F2       | 02SN4     |
And I save the current editor

Given I open an editor "CHA_AUF_SN02" from table "(Part):(Product)" with command "UPDATE" for record "CHA_AUF_SN02"
And I set fields
    | chverfolgung  | Seriennummernverfolgung   |
And I save the current editor


Scenario: SN03 Artikel mit mehreren Einzelbestaenden von 1 mit nicht eindeutiger Charge darf nicht auf Seriennummernverfolgung umgestellt werden

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | CHA_AUF_SN03      |
    | dispoa        | auftragsbezogen   |
    | chverfolgung  | Chargenverfolgung |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHA_AUF_SN03  |
    | buart     | Zugang        |
    | beleg     | LBU_SN03      |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  | verw  |
    | 1      | F1       | 03SN      | 123   |
    | 1      | F2       | 03SN      | 456   |
And I save the current editor

Given I open an editor "CHA_AUF_SN03" from table "(Part):(Product)" with command "UPDATE" for record "CHA_AUF_SN03"
# 3079 TX=de |Umstellung auf Seriennummernverfolgung nicht möglich, bitte Bestand und Gebindepflicht prüfen.
Then setting field "chverfolgung" to "Seriennummernverfolgung" throws the exception "3079"
And I save the current editor


Scenario: SN04 Artikel mit Einzelbestand groesser 1 mit mehrfach verwendeter Charge darf nicht auf Seriennummernverfolgung umgestellt werden

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | CHA_AUF_SN04      |
    | chverfolgung  | Chargenverfolgung |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHA_AUF_SN04  |
    | buart     | Zugang        |
    | beleg     | LBU_SN04      |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 2      | F1       | 04SN      |
    | 1      | F2       | 04SN      |
And I save the current editor

Given I open an editor "CHA_AUF_SN04" from table "(Part):(Product)" with command "UPDATE" for record "CHA_AUF_SN04"
# 3079 TX=de |Umstellung auf Seriennummernverfolgung nicht möglich, bitte Bestand und Gebindepflicht prüfen.
Then setting field "chverfolgung" to "Seriennummernverfolgung" throws the exception "3079"
And I save the current editor


Scenario: SN05 Artikel mit angehakter Gebindepflicht darf nicht auf Seriennummernverfolgung umgestellt werden

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such      | GEBINDE_SN05  |
    | gebvhe    | ja            |
And I save the current editor

Given I open an editor "GEBINDE_SN05" from table "(Part):(Product)" with command "UPDATE" for record "GEBINDE_SN05"
# 3079 TX=de |Umstellung auf Seriennummernverfolgung nicht möglich, bitte Bestand und Gebindepflicht prüfen.
Then setting field "chverfolgung" to "Seriennummernverfolgung" throws the exception "3079"
And I save the current editor


Scenario: SN06 Artikel mit Seriennummernverfolgung darf nicht auf Gebindepflicht umgestellt werden

# Artikel aus Scenario SN02 verwenden, der schon auf Seriennummernverfolgung eingestellt ist
Given I open an editor "CHA_AUF_SN02" from table "(Part):(Product)" with command "UPDATE" for record "CHA_AUF_SN02"
Then field "chverfolgung" has value "Seriennummernverfolgung"
# 3538 TX=de |Bei Seriennummernverfolgung nicht möglich.
Then setting field "gebvhe" to "ja" throws the exception "3538"
And I save the current editor


Scenario: SN07 Artikel ohne zwischenspeichern erst Gebindepflicht anhaken, darf nicht auf Seriennummernverfolgung eingestellt werden

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | GEBINDE_SN07              |
    | chverfolgung  | Seriennummernverfolgung   |
And I save the current editor

Given I open an editor "GEBINDE_SN07" from table "(Part):(Product)" with command "UPDATE" for record "GEBINDE_SN07"
And I set fields
    | chverfolgung  |       |
    | gebvhe        | ja    |
# 3079 TX=de |Umstellung auf Seriennummernverfolgung nicht möglich, bitte Bestand und Gebindepflicht prüfen.
Then setting field "chverfolgung" to "Seriennummernverfolgung" throws the exception "3079"
And I save the current editor


Scenario: SN08 Artikel ohne zwischenspeichern erst Seriennummernverfolgung einstellen, dann darf Gebindepflicht nicht angehakt werden

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such      | GEBINDE_SN08  |
And I save the current editor

Given I open an editor "GEBINDE_SN08" from table "(Part):(Product)" with command "UPDATE" for record "GEBINDE_SN08"
And I set fields
    | chverfolgung  | Seriennummernverfolgung |
# 3538 TX=de |Bei Seriennummernverfolgung nicht möglich.
Then setting field "gebvhe" to "ja" throws the exception "3538"
And I save the current editor


Scenario: SN09 Umstellen auf Seriennummernverfolgung, wenn Bestand und offene Vorgaenge

Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such          | CHA_AUF_SN09      |
    | chverfolgung  | Chargenverfolgung |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHA_AUF_SN09  |
    | buart     | Zugang        |
    | beleg     | LBU_SN09      |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 1      | F1       | CH01LBU   |
And I save the current editor

Given I open an editor "JournalZuLBU" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==CHA_AUF_SN09;buarta==Zugang;platz==F1;such==LLBU_SN09"
And I close the current editor

Given I open an editor "BE_SN09" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BE_SN09  |
    | ebeleg | BE_SN09  |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | CHA_AUF_SN09  | 2   |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 1        | CH1BE     |
    | +2    | F1     | 1        | CH2BE     |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "AUF_SN09" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUF_SN09   |
    | vom   | .          |
And I append rows
    | artikel       | mge | einplan |
    | CHA_AUF_SN09  | 3   | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge |
    | 1     | F1     | 2      | CH1AUF  |
    | +2    | F1     | 1      | CH2AUF  |
And I save the current editor
And I switch the current editor to editor "AUF_SN09"
And I save the current editor

Given I open an editor "CHA_AUF_SN09" from table "(Part):(Product)" with command "UPDATE" for record "CHA_AUF_SN09"
And I set fields
    | chverfolgung  | Seriennummernverfolgung |
And I save the current editor

Given I open an editor "CH01LBU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=CH01LBU;@maxtreffer=1;@ablageart=lebendig"
Then field "sngebzugang^id" has value "!JournalZuLBU^id"
And I close the current editor

Given I open an editor "CH1BE" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=CH1BE;@maxtreffer=1;@ablageart=lebendig"
Then field "snaktzugang" has value "nein"
And I close the current editor

Given I open an editor "CH2BE" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=CH2BE;@maxtreffer=1;@ablageart=lebendig"
Then field "snaktzugang" has value "nein"
And I close the current editor

Given I open an editor "AUF_SN09" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF_SN09"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge |
    | 1     | F1     | 2      | CH1AUF  |
    | 2     | F1     | 1      | CH2AUF  |
# Artikel mit Seriennummernverfolgung darf nur mit Menge und Faktor 1 in Lagereinheit gebucht werden. Vorgang oder MZ prüfen.
Then saving the current editor throws the exception "7039"
And I close the current editor
And I switch the current editor to editor "AUF_SN09"
And I close the current editor

# Datrep-Aufruf mit Ausgabe in Referenzdatei
And I execute shell command "echo \"Ausgabe datrep1 -d 59 -Anr vor Korrektur der Daten\" >> ref_chargen_seriennr_cu.orig.REF"
And I execute shell command "echo \"--------------------------------------------------\" >> ref_chargen_seriennr_cu.orig.REF"
And I execute shell command "echo \"\" >> ref_chargen_seriennr_cu.orig.REF"

And I execute shell command "datrep1 -d 59 -Anr >> ref_chargen_seriennr_cu.orig.REF 2>> ref_chargen_seriennr_cu.orig.REF" in directory "/bin/sh" with return code 2

Given I open an editor "AUF_SN09" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF_SN09"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F1     | 1      | !dontChange |
    | +3    | F1     | 1      | CH3AUF      |
And I save the current editor
And I switch the current editor to editor "AUF_SN09"
And I save the current editor

# Datrep-Aufruf mit Ausgabe in Referenzdatei
And I execute shell command "echo \"\" >> ref_chargen_seriennr_cu.orig.REF"
And I execute shell command "echo \"Ausgabe datrep1 -d 59 -Anr nach Korrektur der Daten\" >> ref_chargen_seriennr_cu.orig.REF"
And I execute shell command "echo \"---------------------------------------------------\" >> ref_chargen_seriennr_cu.orig.REF"
And I execute shell command "echo \"\" >> ref_chargen_seriennr_cu.orig.REF"

And I execute shell command "datrep1 -d 59 -Anr >> ref_chargen_seriennr_cu.orig.REF 2>> ref_chargen_seriennr_cu.orig.REF" in directory "/bin/sh" with return code 0

