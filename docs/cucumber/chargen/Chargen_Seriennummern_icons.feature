@persistent
Feature: Chargen_Seriennummern_icons.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Chargen_Seriennummern.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : carue
#  Funktion         : Testet Chargen-/Seriennummernverwaltung Icons
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: Einkaufen mit Beistellung und Chargen

Given I open an editor "BE-BEI01CH" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | BEI01CH  |
    | ebeleg | BEI01CH  |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | KT-BEISTELL   | 15  |
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I set field "tcharge" to "testch1" in row 1
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | 
    | +1    | F1     | 15       | testch_b_1    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "BE-BEI01CH_REOPEN" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BEI01CH"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I close the current editor

Given I open an editor "BE-BEI01CH" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BEI01CH"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I set field "charge" to "" in row 1
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | charge       | 
    | 1     |              |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge        |
    |  1    | F1     | 5        | testch_MZ_1    |
    | +2    | F2     | 10       | testch_MZ_1    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | 
    | 1     | F1     | 15       | testch_b_1    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "BE-BEI01CH_REOPEN" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BEI01CH"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I close the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I close the current editor

Given I open an editor "LICONBEI01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BEI01CH"
And I set fields
   | ebeleg | L-ICONBEI-1  |
   | such   | LICONBEI1    |
   | vom    | .            |
Then field "chzuordnung" has value " " in row 1
And I set field "mge" to "10" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I delete all rows
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I set field "mzueb" to "nein"
And I delete all rows
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I save the current editor

Given I open an editor "LICONBEI01-REOPEN" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LICONBEI1"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | zuomge   | tcharge        |
    |  1    | 5        | testch_MZ_1    |
    | +2    | 5        | testch_MZ_1    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | 
    | +1    | F1     | 10       |               |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge        |
    |  1    | F1     | 5        |                |
    |  2    | F2     | 5        |                |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge        |
    |  1    | F1     | 5        | testch_MZ_1    |
    |  2    | F2     | 5        | testch_MZ_1    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | 
    | 1     | F1     | 10       | testch_b_1    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LICONBEI01-REOPEN" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "LICONBEI1"
Then field "chzuordnung" has value "" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I close the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "" in row 1
And I close the current editor

Given I open an editor "EKCHINV01" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BEI01CH"
And I set fields
    | such   | EKRECH01  |
    | ebeleg | EKRECH01  |
    | vom    | .         |
    | tterm  | .         |
    | ueb    | nein      |
And I set field "mge" to "5" in row 1
Then field "chzuordnung" has value "" in row 1
And I set field "fakt" to "ja"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "EKCHINV01" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "BEI01CH"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I close the current editor

Given I open an editor "EKCHINV01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "LICONBEI1"
And I set fields
    | such   | EKRECH01  |
    | ebeleg | EKRECH01  |
    | vom    | .         |
    | tterm  | .         |
    | ueb    | nein      |
And I set field "mge" to "10" in row 1
Then field "chzuordnung" has value " " in row 1
And I save the current editor

Scenario: Verkaufen mit Set und Chargen

Given I open an editor "VKICON1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1 |
    | such   | VKICON1  |
    | ebeleg | VKICON1  |
    | tterm  | .        |
    | budat  | .        |
And I append rows
    | artikel       | mge |
    | SET-CHARGE    | 15  |
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I set field "tcharge" to "testch1" in row 1
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzabsm" to open a subeditor for "SetartikelMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | 
    | +1    | F1     | 15       | testch_V_1    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzabsm" to open a subeditor for "SetartikelMZ" in row 1
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 30       | testch_V_2    |
And I save the current editor
And I switch the current editor to editor "VKICON1"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "VKICON1_REOPEN" from table "(Sales):(SalesOrder)" with command "VIEW" for record "VKICON1"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzabsm" to open a subeditor for "SetartikelMZ" in row 1
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I close the current editor

Given I open an editor "LVKICON1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKICON1"
And I set fields
   | ebeleg | L-VKICON1  |
   | such   | LVKICON1   |
   | vom    | .          |
Then field "chzuordnung" has value " " in row 1
And I set field "mge" to "15" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I delete all rows
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I set field "tcharge" to "" in row 1
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I save the current editor

Given I open an editor "LVKICON1-REOPEN" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LVKICON1"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I set field "tcharge" to "testch1" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzabsm" to open a subeditor for "BeistellMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | 
    | +1    | F1     | 15       |               |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzabsm" to open a subeditor for "SetartikelMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | 
    | 1     | F1     | 15       | testch_V_1    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "LVKICON1-REOPEN" from table "(Sales):(PackingSlip)" with command "VIEW" for record "LVKICON1"
Then field "chzuordnung" has value " " in row 1
And I press button "mzabsm" to open a subeditor for "MZ" in row 1
And I close the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value " " in row 1
And I close the current editor

Scenario: Verkaufen mit Chargen

Given I open an editor "VKAUFCH01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | VKAUFCH01  |
    | vom   | .          |
And I append rows
    | artikel       | mge | tcharge  | einplan |
    | EK01_CHARGE   | 100 | EK01_001 | ja      |
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I set field "tcharge" to " " in row 1
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F1     | 100    | EK01_001    |
And I save the current editor
And I switch the current editor to editor "VKAUFCH01"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "VKAUFCH01" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUFCH01"
And I set fields
    | such   | VKCHLS01 |
    | vom    | .        |
    | ueb    | nein     |
And I set field "mge" to "40" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I set field "mzueb" to "nein"
And I save the current editor
And I switch the current editor to editor "VKAUFCH01"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "VKAUFCH01" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKCHLS01"
And I set field "ueb" to "ja"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I set field "tcharge" to "EK01_002" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "VKAUFCH01" from table "(Sales):(PackingSlip)" with command "VIEW" for record "VKCHLS01"
Then field "chzuordnung" has value " " in row 1
And I close the current editor

Given I open an editor "VKAUFCH02" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUFCH01"
And I set fields
    | such   | VKCHLS02 |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "40" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | zuomge | tcharge     |
    | 1     | 40     |             |
And I set field "mzueb" to "nein"
And I save the current editor
And I switch the current editor to editor "VKAUFCH02"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | zuomge | tcharge     |
    | 1     | 40     | EK01_001    |
And I set field "mzueb" to "nein"
And I save the current editor
And I switch the current editor to editor "VKAUFCH02"
And I save the current editor

Given I open an editor "VKAUFCH02" from table "(Sales):(PackingSlip)" with command "VIEW" for record "VKCHLS02"
Then field "chzuordnung" has value " " in row 1
And I close the current editor

Given I open an editor "VKCHINV02" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "VKCHLS02"
And I set fields
    | such   | RECH02  |
    | ebeleg | RECH02  |
    | vom    | .       |
    | tterm  | .       |
    | ueb    | nein    |
And I set field "mge" to "40" in row 1
Then field "chzuordnung" has value "" in row 1 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "VKCHINV02" from table "(Sales):(Invoice)" with command "UPDATE" for record "RECH02"
And I set field "ueb" to "ja"
Then field "chzuordnung" has value " " in row 1 
And I save the current editor

Given I open an editor "VKRE" from table "(Sales):(Invoice)" with command "VIEW" for search criteria "$,,such=RECH02;@ablage=abgelegt;@maxordtreffer=1"
Then field "chzuordnung" has value " " in row 1 
And I close the current editor

Given I open an editor "VKLS" from table "(Sales):(PackingSlip)" with command "VIEW" for search criteria "$,,such=VKCHLS02;@ablage=abgelegt;@maxordtreffer=1"
Then field "chzuordnung" has value " " in row 1 
And I close the current editor

Given I open an editor "VKCHINV02" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "VKAUFCH01"
And I set fields
    | such   | RECH03  |
    | ebeleg | RECH03  |
    | vom    | .       |
    | tterm  | .       |
    | ueb    | nein    |
    | fakt   | nein    |
And I set field "mge" to "20" in row 1
Then field "chzuordnung" has value " " in row 1
And I set field "fakt" to "ja"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1 
And I set field "tcharge" to "EK01_001" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Fertigung mit Chargen: BA

Given I create a work order "FV01" for Product "BG01_CHARGE" with quantity "20" and search word "FV01_"

Given I open an editor "BA_FV01" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV01_000"
Then field "chzuordnung" has value "icon:barcode_cross_red"
And I press button "absteig" to open a subeditor for "AFL"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set fields
    | banummer | !BA_FV01^nummer |
And I press button "ladetab"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then table has values
      | chzuordnung               |
      | icon:barcode_cross_red    |
      |                           |
      | icon:barcode_cross_red    |
      |                           |
And I close the current editor
And I switch the current editor to editor "fvor"
And I close the current editor

Given I open an editor "BA_FV01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV01_000"
Then field "chzuordnung" has value "icon:barcode_cross_red"
And I press button "mzsubm" to open a subeditor for "MZFERTIG"
And I modify table
    | !row  | zuomge | tcharge     |
    | +1    | 20     | BG01_001    |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow"
And I save the current editor

Given I open an editor "BA_FV01" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV01_000"
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow"
And I close the current editor

Given I open an editor "BA_FV01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV01_000"
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow"
And I press button "absteig" to open a subeditor for "AFL"
And I modify table
      | !row | tcharge |
      | 1    | AFLCH01 |
      | 3    | AFLCH02 |
Then table has values
      | chzuordnung               |
      | icon:barcode_tick_green   |
      |                           |
      | icon:barcode_tick_green   |
      |                           |
And I save the current editor
And I switch the current editor to editor "BA_FV01"
Then field "chzuordnung" has value "icon:barcode_tick_green"
And I save the current editor


Scenario: Fertigung mit Chargen: BDE

Given I create a work order "FV02" for Product "BG01_CHARGE" with quantity "20" and search word "FV02_"

Given I open an editor "CHBG01" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=BG01_001;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "BA_FV01" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set field "asma" to "FV02_002"
Then field "chzuordnung" has value " "
And I set fields
    | tplan   | tpnormal |
    | anfdat  | .        |
    | anfzeit | .        |
    | ma      | Karl     |
    | istmge  | 10       |
Then field "chzuordnung" has value "icon:barcode_cross_red"
And I set field "charge" to "!CHBG01^id"
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow"
And I save the current editor

Given I open an editor "BA_FV02" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV02_000"
And I close the current editor

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | banummer | !BA_FV02^nummer |
And I press button "ladetab"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I modify table
      | !row | tcharge |
      | 1    | AFLCH01 |
      | 3    | AFLCH02 |
Then table has values
      | chzuordnung               |
      | icon:barcode_tick_green   |
      |                           |
      | icon:barcode_tick_green   |
      |                           |
And I save the current editor
And I close the current subeditor to switch back to the parent editor
And I set field "tcharge" to "BG01_001" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "BA_FV01" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set field "asma" to "FV02_002"
Then field "chzuordnung" has value " "
And I set fields
    | tplan   | tpnormal |
    | anfdat  | .        |
    | anfzeit | .        |
    | ma      | Karl     |
    | istmge  | 10       |
Then field "chzuordnung" has value "icon:barcode_cross_red"
And I set field "charge" to "!CHBG01^id"
Then field "chzuordnung" has value "icon:barcode_tick_green"
And I close the current editor


Scenario: Fertigung mit Chargen: FV

Given I create a work order "FV03" for Product "BG01_CHARGE" with quantity "20" and search word "FV03_"

Given I open an editor "BA_FV03" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV03_000"
And I close the current editor

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | banummer | !BA_FV03^nummer |
And I press button "ladetab"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then table has values
      | chzuordnung               |
      | icon:barcode_cross_red    |
      |                           |
      | icon:barcode_cross_red    |
      |                           |
And I close the current editor
And I switch the current editor to editor "fvor"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 20       | BG01_001      |
And I save the current subeditor to switch back to the parent editor
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
And I press button "mzabsm" to open a subeditor for "ENTNAHME" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 20       | AFLCH01   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 20       | AFLCH02   |
And I save the current editor
And I switch the current editor to editor "fvor"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "BA_FV03" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV03_000"
Then field "chzuordnung" has value "icon:barcode_tick_green"
And I close the current editor

Given I open an editor "BA_FV01" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set field "asma" to "FV03_002"
And I set fields
    | tplan   | tpnormal |
    | anfdat  | .        |
    | anfzeit | .        |
    | ma      | Karl     |
    | istmge  | 10       |
Then field "chzuordnung" has value "icon:barcode_tick_green"
And I close the current editor

Scenario: Fertigung mit Chargen: FBU

Given I create a work order "FV04" for Product "BG01_CHARGE" with quantity "20" and search word "FV04_"

Given I open an editor "BA_FV04" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV04_000"
And I close the current editor

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | banummer | !BA_FV04^nummer |
And I press button "ladetab"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I modify table
    | !row  | manbu   |
    | 1     | ja      |
And I save the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

Given I open an editor "FBU_04" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | FV04_001  |
    | bem       | Entnahme  |
And I press button "stllad"
And I set field "ljtext1" to "FBU_04" in row 1
And I set field "tvcharge" to "AFLCH01" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "FBU_04" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | FV04_001  |
And I press button "stllad"
Then field "chzuordnungtext" has value "Position nicht chargen-/seriennummernpflichtig" in row 1
And I close the current editor

# Rueckmeldung auf zweiten Arbeitsschein, nur mit Chargenangabe
Given I open an editor "RM01" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV04_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja        |
And I set field "gutmge" to "5" in row 1
Then field "tchzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 5        | BG01_001      |
And I save the current subeditor to switch back to the parent editor
And I modify table
    | !row  | artikel     | mge  | tcharge       |
    | +2    | EK03_CHARGE |5     | BG03_001      |
Then field "tchzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "RM2Pruef" via ID from editor "RM01" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 3 rows
Then table has values
  | artikel     | mge   | gutmge    | tchzuordnung    | tchzuordnungtext                                                             |
  | BG01_CHARGE | 20    | 5         |                 | Chargen-/Seriennummernangaben nicht mehr relevant, Position bereits verbucht |
  | EK03_CHARGE |  5    | 0         |                 | Chargen-/Seriennummernangaben nicht mehr relevant, Position bereits verbucht |
  | EK02_CHARGE |  0    | 0         |                 | Chargen-/Seriennummernangaben nicht mehr relevant, Position bereits verbucht |
And I close the current editor


Scenario: Versandplanung mit Chargen: 

Given I open an editor "VKAU2PLAN" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1   |
    | such   | VKAU2PLAN  |
    | ebeleg | VKAU2PLAN  |
    | tterm  | .          |
    | budat  | .          |
And I append rows
    | artikel       | mge |
    | EK01_CHARGE   | 15  |
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I save the current editor

Given I open an editor "VKPLAN" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
And I set fields
    | pstermvon  | . |
    | pstermbis  | . |
And I append rows
    | vkkopf      |
    | VKAU2PLAN   |
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
Then I set field "tcharge" to "EK01_001" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I close the current editor

Given I open an editor "VKAUFCH01" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "VKAU2PLAN"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I set field "tcharge" to "EK01_001" in row 1
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "VKPLAN" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
And I set fields
    | pstermvon  | . |
    | pstermbis  | . |
And I append rows
    | vkkopf      |
    | VKAU2PLAN   |
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I close the current editor

Given I open an editor "VKAU2PLAN" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "VKAU2PLAN"
And I set field "tcharge" to " " in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F1     | 15     | EK01_001    |
And I save the current editor
And I switch the current editor to editor "VKAU2PLAN"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "VKPLAN" from table "(ShippingPlanning):(ShippingPlanning)" with command "NEW" for record ""
And I set fields
    | such       | VKPLAN01 |
    | pstermvon  | .        |
    | pstermbis  | .        |
And I append rows
    | vkkopf      |
    | VKAU2PLAN   |
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "VKAU2PLAN" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "VKAU2PLAN"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F1     | 15     |             |
And I save the current editor
And I switch the current editor to editor "VKAU2PLAN"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I save the current editor

Given I open an editor "VKPLAN" from table "(ShippingPlanning):(ShippingPlanning)" with command "UPDATE" for record "VKPLAN01"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I set field "planlmge" to "10" in row 1
And I press button "offueballe"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "LIEFERSCHEIN"
And I close the current editor
And I switch the current editor to editor "VKPLAN"
And I save the current editor

Given I open an editor "VKLIEFCH02" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "LKUNDECH1"
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge  |
    | 1     | F1     | 10     | EK01_001 |
And I save the current editor
And I switch the current editor to editor "VKLIEFCH02"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "VKPLAN" from table "(ShippingPlanning):(ShippingPlanning)" with command "VIEW" for record "VKPLAN01"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I close the current editor

Scenario: Fertigungsvorschlag freigeben mit Komando Freigabe in Maske

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I modify table
    | !row  | artikel     | netmge | tcharge  |
    | +1    | BG01_CHARGE | 10     | BG01_001 |

And I press button "absteig" to open a subeditor for "AFL" in row 1
And I modify table
    | !row | tcharge |
    | 1    | AFLCH01 |
    | 3    | AFLCH02 |
And I save the current editor
And I switch the current editor to editor "fvor"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I save the current editor

Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "RELEASE" for record ""
And I set field "artikel" to "BG01_CHARGE"
And I press button "ladetab"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I close the current editor
