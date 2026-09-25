# *****************************************************************************
#  Name             : ref_zuordnungskriterien_vorbelegungen.feature
#  Autor            : jeffler
#  Verantwortlich   : hc
#  Kontrolle        : wane
#  Funktion         :
#
# *****************************************************************************
@persistent

Feature: ref_zuordnungskriterien_vorbelegungen
Background: Zahlungsverkehr

Scenario: Zuordnungskriterien für Gutschrift und Belastung anlegen und in Konfig eintragen

Given I open an editor "zuordnungskriterien" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TESTGUT"
And I set field "zkkunde" to "ja"
And I set field "zabuchart" to "Gutschrift"
And I set field "zkkunzu" to "Kann"
And I save the current editor
And I close the current editor

Given I open an editor "zuordnungskriterien" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TESTBEL"
And I set field "zklieferant" to "ja"
And I set field "zabuchart" to "Belastung"
And I set field "zkkunzu" to "Kann"
And I save the current editor
And I close the current editor

Scenario: Zuordnungskriterien für Gutschrift und Belastung in als Standard in Konfig eintragen
Given I open an editor "konf" from table "(PaymentMasterFiles):(CMConfig)" with command "UPDATE" for record "1"
And I set field "zuordkgutschrift" to "TESTGUT"
And I set field "zuordkbelastung" to "TESTBEL"
And I save the current editor
And I close the current editor

Scenario Outline: Länge wird bei Eintrag von Grenzwert automatisch vorbelegt

Given I open an editor "vorbel_len" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "<field>" to "<musskann>"
And I set field "<vonfield>" to "abc123"
Then field "<minfield>" has value "6"
And I set field "<bisfield>" to "abc123def456ghi789jklmn"
Then field "<maxfield>" has value "23"
And I close the current editor

Examples:

|   field|musskann| vonfield| minfield| bisfield| maxfield|
| zkkunid|    Muss| zkkunvon| zkkunmin| zkkunbis| zkkunmax|
| zkbeleg|    Muss| zkbelvon| zkbelmin| zkbelbis| zkbelmax|
|zkebeleg|    Muss|zkebelvon|zkebelmin|zkebelbis|zkebelmax|
| zkzaref|    Muss| zkzarvon| zkzarmin| zkzarbis| zkzarmax|
| zkkunid|    Kann| zkkunvon| zkkunmin| zkkunbis| zkkunmax|
| zkbeleg|    Kann| zkbelvon| zkbelmin| zkbelbis| zkbelmax|
|zkebeleg|    Kann|zkebelvon|zkebelmin|zkebelbis|zkebelmax|
| zkzaref|    Kann| zkzarvon| zkzarmin| zkzarbis| zkzarmax|


Scenario Outline: Länge wird überschrieben, wenn ein Grenzwert eingetragen wird
Given I open an editor "leer_len" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "<field>" to "<musskann>"
And I set field "<numfield>" to "<num>"
And I set field "<minfield>" to "101"
And I set field "<maxfield>" to "999"
Then field "<minfield>" has value "101"
Then field "<maxfield>" has value "999"
And I set field "<vonfield>" to "123"
Then field "<minfield>" has value "3"
And I set field "<bisfield>" to "12345678910"
Then field "<maxfield>" has value "11"
And I close the current editor

Examples:

|   field|musskann| numfield| num| vonfield| minfield| bisfield| maxfield|
| zkkunid|    Muss| zkkunnum|  ja| zkkunvon| zkkunmin| zkkunbis| zkkunmax|
| zkbeleg|    Muss| zkbelnum|  ja| zkbelvon| zkbelmin| zkbelbis| zkbelmax|
|zkebeleg|    Muss|zkebelnum|  ja|zkebelvon|zkebelmin|zkebelbis|zkebelmax|
| zkzaref|    Muss| zkzarnum|  ja| zkzarvon| zkzarmin| zkzarbis| zkzarmax|
| zkkunid|    Kann| zkkunnum|  ja| zkkunvon| zkkunmin| zkkunbis| zkkunmax|
| zkbeleg|    Kann| zkbelnum|  ja| zkbelvon| zkbelmin| zkbelbis| zkbelmax|
|zkebeleg|    Kann|zkebelnum|  ja|zkebelvon|zkebelmin|zkebelbis|zkebelmax|
| zkzaref|    Kann| zkzarnum|  ja| zkzarvon| zkzarmin| zkzarbis| zkzarmax|
| zkkunid|    Muss| zkkunnum|nein| zkkunvon| zkkunmin| zkkunbis| zkkunmax|
| zkbeleg|    Muss| zkbelnum|nein| zkbelvon| zkbelmin| zkbelbis| zkbelmax|
|zkebeleg|    Muss|zkebelnum|nein|zkebelvon|zkebelmin|zkebelbis|zkebelmax|
| zkzaref|    Muss| zkzarnum|nein| zkzarvon| zkzarmin| zkzarbis| zkzarmax|
| zkkunid|    Kann| zkkunnum|nein| zkkunvon| zkkunmin| zkkunbis| zkkunmax|
| zkbeleg|    Kann| zkbelnum|nein| zkbelvon| zkbelmin| zkbelbis| zkbelmax|
|zkebeleg|    Kann|zkebelnum|nein|zkebelvon|zkebelmin|zkebelbis|zkebelmax|
| zkzaref|    Kann| zkzarnum|nein| zkzarvon| zkzarmin| zkzarbis| zkzarmax|

Scenario Outline: Felder werden geleert, wenn Kriterium geleert wird (Muss/Kann Feld auf "" setzen)
Given I open an editor "leer_krit" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "<field1>" to "<musskann1>"
And I set field "<numfield1>" to "<numval1>"
And I set field "<vonfield1>" to "159468"
And I set field "<bisfield1>" to "18967534"
Then field "<minfield1>" has value "6"
Then field "<maxfield1>" has value "8"

And I set field "<field2>" to "<musskann2>"
And I set field "<numfield2>" to "<numval2>"
And I set field "<vonfield2>" to "101151689412367"
And I set field "<bisfield2>" to "823486123789452582"
Then field "<minfield2>" has value "15"
Then field "<maxfield2>" has value "18"

And I set field "<field3>" to "<musskann3>"
And I set field "<minfield3>" to "23"
And I set field "<maxfield3>" to "28"
And I set field "<vonfield3>" to ""
And I set field "<bisfield3>" to ""

And I set field "<field3>" to ""
Then field "<minfield3>" has value "0"
Then field "<maxfield3>" has value "0"
Then field "<vonfield3>" has value ""
Then field "<bisfield3>" has value ""
Then field "<numfield3>" has value "nein"
Then field "<field2>" has value "<musskann2>"
Then field "<numfield2>" has value "<numval2>"
Then field "<vonfield2>" has value "101151689412367"
Then field "<bisfield2>" has value "823486123789452582"
Then field "<minfield2>" has value "15"
Then field "<maxfield2>" has value "18"
Then field "<field1>" has value "<musskann1>"
Then field "<numfield1>" has value "<numval1>"
Then field "<vonfield1>" has value "159468"
Then field "<bisfield1>" has value "18967534"
Then field "<minfield1>" has value "6"
Then field "<maxfield1>" has value "8"

And I set field "<field2>" to ""
Then field "<field3>" has value ""
Then field "<minfield3>" has value "0"
Then field "<maxfield3>" has value "0"
Then field "<vonfield3>" has value ""
Then field "<bisfield3>" has value ""
Then field "<numfield3>" has value "nein"
Then field "<field2>" has value ""
Then field "<numfield2>" has value "nein"
Then field "<vonfield2>" has value ""
Then field "<bisfield2>" has value ""
Then field "<minfield2>" has value "0"
Then field "<maxfield2>" has value "0"
Then field "<field1>" has value "<musskann1>"
Then field "<numfield1>" has value "<numval1>"
Then field "<vonfield1>" has value "159468"
Then field "<bisfield1>" has value "18967534"
Then field "<minfield1>" has value "6"
Then field "<maxfield1>" has value "8"

And I set field "<field1>" to ""
Then field "<field3>" has value ""
Then field "<minfield3>" has value "0"
Then field "<maxfield3>" has value "0"
Then field "<vonfield3>" has value ""
Then field "<bisfield3>" has value ""
Then field "<numfield3>" has value "nein"
Then field "<field2>" has value ""
Then field "<numfield2>" has value "nein"
Then field "<vonfield2>" has value ""
Then field "<bisfield2>" has value ""
Then field "<minfield2>" has value "0"
Then field "<maxfield2>" has value "0"
Then field "<field1>" has value ""
Then field "<numfield1>" has value "nein"
Then field "<vonfield1>" has value ""
Then field "<bisfield1>" has value ""
Then field "<minfield1>" has value "0"
Then field "<maxfield1>" has value "0"
And I close the current editor

Examples:

|musskann1|musskann2|musskann3|numval1|numval2|numval3|  field1|numfield1|vonfield1|bisfield1|minfield1|maxfield1|  field2|numfield2|vonfield2|bisfield2|minfield2|maxfield2|  field3|numfield3|vonfield3|bisfield3|minfield3|maxfield3|
|     Muss|     Kann|     Muss|     ja|     ja|   nein| zkkunid| zkkunnum| zkkunvon| zkkunbis| zkkunmin| zkkunmax| zkbeleg| zkbelnum| zkbelvon| zkbelbis| zkbelmin| zkbelmax|zkebeleg|zkebelnum|zkebelvon|zkebelbis|zkebelmin|zkebelmax|
|     Muss|     Muss|     Kann|   nein|     ja|   nein| zkbeleg| zkbelnum| zkbelvon| zkbelbis| zkbelmin| zkbelmax|zkebeleg|zkebelnum|zkebelvon|zkebelbis|zkebelmin|zkebelmax| zkzaref| zkzarnum| zkzarvon| zkzarbis| zkzarmin| zkzarmax|
|     Kann|     Kann|     Muss|     ja|   nein|     ja|zkebeleg|zkebelnum|zkebelvon|zkebelbis|zkebelmin|zkebelmax| zkzaref| zkzarnum| zkzarvon| zkzarbis| zkzarmin| zkzarmax| zkbeleg| zkbelnum| zkbelvon| zkbelbis| zkbelmin| zkbelmax|
|     Muss|     Kann|     Kann|   nein|   nein|     ja| zkzaref| zkzarnum| zkzarvon| zkzarbis| zkzarmin| zkzarmax| zkbeleg| zkbelnum| zkbelvon| zkbelbis| zkbelmin| zkbelmax| zkkunid| zkkunnum| zkkunvon| zkkunbis| zkkunmin| zkkunmax|

Scenario: Toleranzfelder werden geleert, wenn Betrag deaktiviert wird

Given I open an editor "leer_betrag" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TESTBETR"
And I set field "zkkunde" to "ja"
And I set field "zkbetr" to "ja"
And I set field "zkbetrtu" to "10,5"
And I set field "zkbetrto" to "9"
Then field "zkbetrtu" has value "10.50"
Then field "zkbetrto" has value "9.00"
And I set field "zkbetr" to "nein"
Then field "zkbetrtu" has value "0.00"
Then field "zkbetrto" has value "0.00"
And I close the current editor

Scenario: Standard wird zu Beginn aus Konfig übernommen
# Bankimportdatei
Given I open an editor "bimportdat" from table "(Bankimport):(BankImportFile)" with command "NEW" for record ""
And I set field "nummer" to "1bimp"
And I save the current editor
And I close the current editor

Given I open an editor "bimportdatedit" from table "(Bankimport):(BankImportFile)" with command "UPDATE" for record "1bimp"
Then field "zkgutschrift^such" has value "TESTGUT"
Then field "zkbelastung^such" has value "TESTBEL"
And I close the current editor

# Bankkontoauszug
Given I open an editor "bausz" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "1bausz"
And I save the current editor
And I close the current editor

Given I open an editor "bauszedit" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "1bausz"
Then field "zkgutschrift^such" has value "TESTGUT"
Then field "zkbelastung^such" has value "TESTBEL"
And I close the current editor

Scenario: leere Zuordnungskriterien werden aus Konfig aufgefüllt
# Bankkontoauszug
Given I open an editor "bausz1" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "1bauszf" in row 0
And I create a new row at the end of the table
And I set field "tbubetr" to "100" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bausz2" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "2bauszf" in row 0
And I create a new row at the end of the table
And I set field "tbubetr" to "100" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bausz3" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "3bauszf" in row 0
And I create a new row at the end of the table
And I set field "tbubetr" to "100" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "fillbausz" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "1bauszf"
Then field "zkgutschrift^such" has value "TESTGUT"
Then field "zkbelastung^such" has value "TESTBEL"
And I set field "zkgutschrift" to ""
And I set field "zkbelastung" to ""
Then field "zkgutschrift^such" has value "TESTGUT"
Then field "zkbelastung^such" has value "TESTBEL"
And I press button "bauto" to open a subeditor for "fillbauszsub" 
And I close the current subeditor to switch back to the parent editor
Then field "zkgutschrift^such" has value "TESTGUT"
Then field "zkbelastung^such" has value "TESTBEL"
And I close the current editor

# Bankimportdatei
Given I open an editor "fillbdat" from table "(Bankimport):(BankImportFile)" with command "NEW" for record ""
And I set field "nummer" to "2bdatf" in row 0
And I create a new row at the end of the table
And I set field "nachricht" to "3bauszf" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bdat" from table "(Bankimport):(BankImportFile)" with command "UPDATE" for record "2bdatf"
Then field "zkgutschrift^such" has value "TESTGUT"
Then field "zkbelastung^such" has value "TESTBEL"
And I set field "zkbelastung" to ""
And I set field "zkgutschrift" to ""
Then field "zkgutschrift^such" has value "TESTGUT"
Then field "zkbelastung^such" has value "TESTBEL"
And I press button "bauto" to open a subeditor for "bdatsub" 
And I close the current subeditor to switch back to the parent editor
Then field "zkgutschrift^such" has value "TESTGUT"
Then field "zkbelastung^such" has value "TESTBEL"
And I close the current editor

Scenario: zbauto ohne Zuordnungskriterien => kein Standard in Konfig => Fehlermeldung

Given I open an editor "konfig" from table "(PaymentMasterFiles):(CMConfig)" with command "UPDATE" for record "1"
And I set field "zuordkgutschrift" to ""
And I set field "zuordkbelastung" to ""
And I save the current editor
And I close the current editor

Given I open an editor "fillbausz" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "1bauszf"
Then field "zkgutschrift" has value ""
Then field "zkbelastung" has value ""
# 3541 : Zuordnungskriterien für Gutschriften fehlen
Then pressing button "bauto" throws the exception "3541"
And I set field "zkgutschrift" to "TESTGUT"
Then field "zkbelastung" has value ""
Then field "zkgutschrift^such" has value "TESTGUT"
# 3542 : Zuordnungskriterien für Belastungen fehlen
Then pressing button "bauto" throws the exception "3542"
And I close the current editor

Given I open an editor "fillbausz2" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "2bauszf"
Then field "zkgutschrift" has value ""
Then field "zkbelastung" has value ""
# 3541 : Zuordnungskriterien für Gutschriften fehlen
Then pressing button "bauto" throws the exception "3541"
And I set field "zkbelastung" to "TESTBEL"
Then field "zkbelastung^such" has value "TESTBEL"
Then field "zkgutschrift" has value ""
# 3541 : Zuordnungskriterien für Gutschriften fehlen
Then pressing button "bauto" throws the exception "3541"
And I close the current editor

# Bankimportdatei

Given I open an editor "bausz3" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "4bauszf" in row 0
And I create a new row at the end of the table
And I set field "tbubetr" to "100" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "fillbdat" from table "(Bankimport):(BankImportFile)" with command "NEW" for record ""
And I set field "nummer" to "3bdatf" in row 0
And I create a new row at the end of the table
And I set field "nachricht" to "4bauszf" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bdat" from table "(Bankimport):(BankImportFile)" with command "UPDATE" for record "3bdatf"
Then field "zkgutschrift" has value ""
Then field "zkbelastung" has value ""
And I set field "zkgutschrift" to ""
# 3541 : Zuordnungskriterien für Gutschriften fehlen
Then pressing button "bauto" throws the exception "3541"
And I set field "zkbelastung" to "TESTBEL"
Then field "zkgutschrift" has value ""
Then field "zkbelastung^such" has value "TESTBEL"
# 3541 : Zuordnungskriterien für Gutschriften fehlen
Then pressing button "bauto" throws the exception "3541"
And I close the current editor

Given I open an editor "bdat" from table "(Bankimport):(BankImportFile)" with command "UPDATE" for record "3bdatf"
Then field "zkgutschrift" has value ""
Then field "zkbelastung" has value ""
And I set field "zkbelastung" to ""
# 3541 : Zuordnungskriterien für Belastungen fehlen
Then pressing button "bauto" throws the exception "3541"
And I set field "zkgutschrift" to "TESTGUT"
Then field "zkbelastung" has value ""
Then field "zkgutschrift^such" has value "TESTGUT"
# 3542 : Zuordnungskriterien für Belastungen fehlen
Then pressing button "bauto" throws the exception "3542"
And I close the current editor
