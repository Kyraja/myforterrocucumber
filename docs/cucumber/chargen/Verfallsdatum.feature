@persistent
Feature: Verfallsdatum.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Verfallsdatum.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: V01 Verfallsdatum wird bei Zugang aus Fertigung in der Charge des Fertigteils gesetzt

Given I open an editor "BG02_CHARGE" from table "(Part):(Product)" with command "UPDATE" for record "BG02_CHARGE"
And I set field "haltbarkeit" to "365"
And I save the current editor

Given I create a work order "V01" for Product "BG02_CHARGE" with quantity "20" and search word "V01_"

# Rueckmeldung Teilmenge auf Arbeitsschein 2
Given I open an editor "RM_V01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=V01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM1_V01   |
And I modify table
    | !row  | gutmge    | erbtext1  | tcharge   |
    | 1     | 15        | RM1_V01   | 55555_01  |
And I save the current editor

# das Verfallsdatum wurde in der Charge gesetzt
Given I open an editor "Charge55555_01" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=55555_01;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 55555_01      |
    | eigcharge | ja            |
    | verfall   | 16.01.96      |
    | lief      |               |
And I close the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG02_CHARGE;buarta==Zugang;platz==F1;erbtext1==RM1_V01"
Then fields have values
    | artikel       | BG02_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 15                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "55555_01" in row 1
And I close the current editor

And I set the fake date to "20.01.1995"

# ein bereits gesetztes Verfallsdatum in einer Charge bleibt erhalten, auch wenn später weitere Gutmengen zugebucht werden
# Rueckmeldung Teilmenge auf Arbeitsschein 2
Given I open an editor "RM2_V01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=V01_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM2_V01   |
And I modify table
    | !row  | gutmge    | erbtext1  | charge                |
    | 1     | 5         | RM2_V01   | !Charge55555_01^id    |
And I save the current editor

# Verfallsdatum ist gleich geblieben
Given I open an editor "Charge55555_01" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=55555_01;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 55555_01      |
    | eigcharge | ja            |
    | verfall   | 16.01.96      |
    | lief      |               |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG02_CHARGE;buarta==Zugang;platz==F1;erbtext1==RM2_V01"
Then fields have values
    | artikel       | BG02_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 5                             |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "55555_01" in row 1
And I close the current editor


@V01MZ
Scenario: V01MZ Verfallsdatum wird bei Zugang aus Fertigung in der Charge des Fertigteils gesetzt, BA mit FertigteilMZ

Given I create a work order "V01MZ" for Product "BG02_CHARGE" with quantity "20" and search word "V01MZ_"

Given I open an editor "BA_V01MZ" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "V01MZ_000"
And I press button "mzsubm" to open a subeditor for "FertigteilMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 12       | 55555_10  |
    | +2    | F2     | 8        | 55555_11  |
And I save the current editor
And I switch the current editor to editor "BA_V01MZ"
And I save the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 2
Given I open an editor "RM_V01MZ" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=V01MZ_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM1_V01MZ |
And I modify table
    | !row  | gutmge    | erbtext1  |
    | 1     | 14        | RM1_V01MZ |
And I save the current editor

# das Verfallsdatum wurde in der Charge gesetzt
Given I open an editor "Charge55555_10" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=55555_10;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 55555_10      |
    | eigcharge | ja            |
    | verfall   | 16.01.96      |
    | lief      |               |
And I close the current editor

Given I open an editor "Charge55555_11" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=55555_11;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 55555_11      |
    | eigcharge | ja            |
    | verfall   | 16.01.96      |
    | lief      |               |
And I close the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG02_CHARGE;buarta==Zugang;platz==F1;erbtext1==RM1_V01MZ"
Then fields have values
    | artikel       | BG02_CHARGE                   |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 12                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "55555_10" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG02_CHARGE;buarta==Zugang;platz==F2;erbtext1==RM1_V01MZ"
Then fields have values
    | artikel       | BG02_CHARGE                   |
    | platz         | F2                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 2                             |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "55555_11" in row 1
And I close the current editor

And I set the fake date to "20.01.1995"

# ein bereits gesetztes Verfallsdatum in einer Charge bleibt erhalten, auch wenn später weitere Gutmengen zugebucht werden
# Rueckmeldung Teilmenge auf Arbeitsschein 2
Given I open an editor "RM2_V01MZ" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=V01MZ_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM2_V01MZ |
And I modify table
    | !row  | gutmge    | erbtext1  |
    | 1     | 6         | RM2_V01MZ |
And I save the current editor

# Verfallsdatum ist gleich geblieben
Given I open an editor "Charge55555_11" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=55555_11;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 55555_11      |
    | eigcharge | ja            |
    | verfall   | 16.01.96      |
    | lief      |               |
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG02_CHARGE;buarta==Zugang;platz==F2;erbtext1==RM2_V01MZ"
Then fields have values
    | artikel       | BG02_CHARGE                   |
    | platz         | F2                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 6                             |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "55555_11" in row 1
And I close the current editor


Scenario: V02 Verfallsdatum in EK-Belegen setzen, sowie fuer gleiche Charge mit gleichem Artikel darf kein abweichendes Verfallsdatum angegeben werden

Given I open an editor "EKBEV02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | EKBEV02    |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan |
    | BG02_CHARGE   | 100 | ja      |
    | BG02_CHARGE   | 50  | ja      |
Then field "tcharge" is empty in row 1
Then field "tcharge" is empty in row 2
And I save the current editor

# Verfallsdatum ist keine Pflichtangabe, kann aber eingetragen werden
Given I open an editor "EKBEV02" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBEV02"
And I set fields
    | such   | LS1_V02  |
    | ebeleg | LS1_V02  |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "10" in row 1
And I set field "tcharge" to "020202_01" in row 1
Then field "chverfallsdatum" is empty in row 1
And I save the current editor

Given I open an editor "Charge020202_01" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=020202_01;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 020202_01     |
    | eigcharge | nein          |
    | verfall   |               |
    | lief^such | LIEFCHA1      |
And I close the current editor

Given I open an editor "EKBEV02" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBEV02"
And I set fields
    | such   | LS2_V02  |
    | ebeleg | LS2_V02  |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "80" in row 1
And I set field "tcharge" to "020202_02" in row 1
And I set field "chverfallsdatum" to "31.07.95" in row 1
And I set field "mge" to "10" in row 2
And I set field "tcharge" to "020202_02" in row 2
And I set field "chverfallsdatum" to "31.08.95" in row 2
# 3087 TX=de |Für diesen Artikel mit dieser Charge gibt es ein abweichendes Verfallsdatum.
Then saving the current editor throws the exception "3087"
And I set field "chverfallsdatum" to "31.07.95" in row 2
And I save the current editor

# das Verfallsdatum wurde in der Charge gesetzt
Given I open an editor "Charge020202_02" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=020202_02;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 020202_02     |
    | eigcharge | nein          |
    | verfall   | 31.07.95      |
    | lief^such | LIEFCHA1      |
And I close the current editor

# Verfallsdatum wird aus vorhandener Charge in den EK-Beleg uebernommen, aendern ist moeglich
Given I open an editor "EKBEV02" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "EKBEV02"
And I set fields
    | such   | RE1_V02  |
    | ebeleg | RE1_V02  |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "10" in row 1
And I set field "charge" to "!Charge020202_01^id" in row 1
Then field "chverfallsdatum" is empty in row 1
And I set field "chverfallsdatum" to "31.10.95" in row 1
And I set field "mge" to "10" in row 2
And I set field "charge" to "!Charge020202_02^id" in row 2
Then field "chverfallsdatum" has value "31.07.95" in row 2
Then field "chverfallsdatum" is modifiable in row 1
And I save the current editor

# Verfallsdatum wurde nachtraeglich gesetzt in der vorhandenen Charge, die bisher kein Verfallsdatum hatte
Given I open an editor "Charge020202_01" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=020202_01;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 020202_01     |
    | eigcharge | nein          |
    | verfall   | 31.10.95      |
    | lief^such | LIEFCHA1      |
And I close the current editor


Scenario: V03 Verfallsdatum in EK-Belegen in der MZ eintragen

Given I open an editor "EKBEV03" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | EKBEV03    |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan |
    | BG02_CHARGE   | 100 | ja      |
Then field "tcharge" is empty in row 1
And I save the current editor

# Verfallsdatum ist keine Pflichtangabe, kann aber eingetragen werden
Given I open an editor "EKBEV03" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBEV03"
And I set fields
    | such   | LS1_V03  |
    | ebeleg | LS1_V03  |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "80" in row 1
And I set field "tcharge" to "030303_01" in row 1
And I set field "chverfallsdatum" to "31.10.95" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge     | chverfallsdatum   |
    | 1     | F1     | 70     | 030303_01   | 31.08.95          |
    | +2    | F2     | 5      | 030303_02   | 30.09.95          |
    | +3    | F2     | 5      | 030303_02   | 31.08.95          |
Then saving the current editor throws the exception "3087"
And I set field "chverfallsdatum" to "30.09.95" in row 3
And I save the current editor
And I switch the current editor to editor "EKBEV03"
# Verfallsdatum der Charge in der Position weicht ab vom Verfallsdatum der gleichen Charge in der MZ
Then saving the current editor throws the exception "3087"
And I set field "chverfallsdatum" to "31.08.95" in row 1
And I save the current editor

# das Verfallsdatum wurde in den Chargen gesetzt
Given I open an editor "Charge030303_01" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=030303_01;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 030303_01     |
    | eigcharge | nein          |
    | verfall   | 31.08.95      |
    | lief^such | LIEFCHA1      |
And I close the current editor

Given I open an editor "Charge030303_02" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=030303_02;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 030303_02     |
    | eigcharge | nein          |
    | verfall   | 30.09.95      |
    | lief^such | LIEFCHA1      |
And I close the current editor

# Verfallsdatum wird aus vorhandener Charge in den EK-Beleg uebernommen, aendern ist moeglich
Given I open an editor "EKBEV03" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "EKBEV03"
And I set fields
    | such   | RE1_V03  |
    | ebeleg | RE1_V03  |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "20" in row 1
And I set field "charge" to "!Charge030303_02^id" in row 1
Then field "chverfallsdatum" has value "30.09.95" in row 1
Then field "chverfallsdatum" is modifiable in row 1
# Verfallsdatum ist aenderbar, das bereits vorhandene Verfallsdatum in der Charge wird jedoch NICHT ueberschrieben
And I set field "chverfallsdatum" to "31.08.95" in row 1
And I save the current editor

# in der Charge bleibt das bisherige Datum, kann aber geandert werden
Given I open an editor "Charge030303_02" from table "(Lots):(Lots)" with command "UPDATE" for search criteria "$,,exnum=030303_02;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 030303_02     |
    | eigcharge | nein          |
    | verfall   | 30.09.95      |
    | lief^such | LIEFCHA1      |
And I set field "verfall" to "31.08.95"
And I save the current editor


Scenario: V04 Verfallsdatum wird bei Zugang aus Fertigung in der Charge des Fertigteils gesetzt

Given I open an editor "KOPPELCHARGE" from table "(Part):(Product)" with command "UPDATE" for record "KOPPELCHARGE"
And I set field "haltbarkeit" to "365"
And I save the current editor

Given I create a work order "V04" for Product "BG_CHARGE_KOPPEL" with quantity "20" and search word "V04_"

Given I open an editor "BA_V04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "V04_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 2
Then field "artikel" has value "KOPPELCHARGE"
And I create a new row at position 1
And I set field "zuomge" to "20" in row 1
And I set field "tcharge" to "KOPPEL_V04" in row 1
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BA_V04"
And I save the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 1, Zugang Koppelprodukt
Given I open an editor "RM_V04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=V04_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM1_V04   |
And I modify table
    | !row  | gutmge    | erbtext1  |
    | 1     | 15        | RM1_V04   |
And I save the current editor

# das Verfallsdatum wurde in der Charge gesetzt
Given I open an editor "KOPPEL_V04" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=KOPPEL_V04;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | KOPPEL_V04    |
    | eigcharge | ja            |
    | verfall   | 16.01.96      |
    | lief      |               |
And I close the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==KOPPELCHARGE;buarta==Zugang;platz==F1;erbtext1==RM1_V04"
Then fields have values
    | artikel       | KOPPELCHARGE                  |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 15                            |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "KOPPEL_V04" in row 1
And I close the current editor

And I set the fake date to "20.01.1995"

# ein bereits gesetztes Verfallsdatum in einer Charge bleibt erhalten, auch wenn später weitere Mengen zugebucht werden
# Rueckmeldung Teilmenge auf Arbeitsschein 1
Given I open an editor "RM2_V04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=V04_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
    | bem       | RM2_V04   |
And I modify table
    | !row  | gutmge    | erbtext1  |
    | 1     | 5         | RM2_V04   |
And I save the current editor

# Verfallsdatum ist gleich geblieben
Given I open an editor "KOPPEL_V04" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=KOPPEL_V04;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | KOPPEL_V04    |
    | eigcharge | ja            |
    | verfall   | 16.01.96      |
    | lief      |               |
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==KOPPELCHARGE;buarta==Zugang;platz==F1;erbtext1==RM2_V04"
Then fields have values
    | artikel       | KOPPELCHARGE                  |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 5                             |
    | buart         | 1                             |
    | buarta        | Zugang                        |
    | ursache       | Fertigung                     |
    | detursache    | Rückmeldung Fertigung         |
Then field "tncharge" has value "KOPPEL_V04" in row 1
And I close the current editor


Scenario: V05 Verfallsdatum in BeistellMZ eintragen bei EK-Lieferschein mit Koppelzugang als Beistellung

Given I open an editor "KT-BEISTELL" from table "(Part):(Product)" with command "COPY" for record "KT-BEISTELL"
And I set fields
    | such          | KT_BEI_KOPPEL                     |
    | namebspr      | Kaufteil mit Koppel-Beistellung   |
    | bsart         | Fremdbeschaffung                  |
    | lief          | LIEFCHA2                          |
    | chverfolgung  | Chargenverfolgung                 |
And I delete all rows
And I append rows
    | elex          | elanzahl  | bua                       | kompeig       |
    | EKBEI         | 1         | Lieferantenbeistellung    | !dontChange   |
    | KOPPELCHARGE  | 1         | Lieferantenbeistellung    | Koppelprodukt |
And I save the current editor

Given I open an editor "EKBEV05" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA2   |
    | such | EKBEV05    |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan |
    | KT_BEI_KOPPEL | 20  | ja      |
Then field "tcharge" is empty in row 1
And I save the current editor

# Verfallsdatum fuer Koppelzugang und Chargen in BeistellMZ eintragen
Given I open an editor "EKBEV05" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBEV05"
And I set fields
    | such   | LS1_V05  |
    | num    | 1LS_V05  |
    | ebeleg | LS1_V05  |
    | vom    | .        |
And I set field "mge" to "20" in row 1
And I set field "tcharge" to "V05ZU" in row 1
And I set field "chverfallsdatum" to "31.10.95" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I append rows
    | lpsuch | zuomge | tcharge     |
    | F1     | 20     | V05_BEI_1   |
And I press button for next product
And I append rows
    | lpsuch | zuomge | tcharge         | chverfallsdatum   |
    | F1     | 20     | V05_KOPPELZU    | 31.08.95          |
And I save the current editor
And I switch the current editor to editor "EKBEV05"
And I set field "ueb" to "ja"
And I save the current editor

# das Verfallsdatum wurde in der Charge des Koppelprodukts gesetzt
Given I open an editor "V05_KOPPELZU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=V05_KOPPELZU;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | V05_KOPPELZU  |
    | eigcharge | nein          |
    | verfall   | 31.08.95      |
#    | lief^such | LIEFCHA2      |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "1LS_V05"
And I press start
Then table has values
    | art           | zmge | amge     | tvcharge    | tncharge      |
    | EKBEI         |      | 20       | V05_BEI_1   | V05ZU         |
    | KOPPELCHARGE  | 20   |          |             | V05_KOPPELZU  |
    | KT_BEI_KOPPEL | 20   |          |             | V05ZU         |
And I close the current editor

