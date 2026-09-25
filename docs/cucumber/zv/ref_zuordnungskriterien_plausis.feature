# *****************************************************************************
#  Name             : ref_zuordnungskriterien_plausis.feature
#  Autor            : jeffler
#  Verantwortlich   : hc
#  Kontrolle        : wane
#  Funktion         : 
#
# *****************************************************************************
@persistent

Feature: ref_zuordnungskriterien_plausis
Background: Zahlungsverkehr

Scenario: Suchwort muss eingetragen sein
Given I open an editor "such" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
# 10179 : bitte eintragen
Then saving the current editor throws the exception "10179"
And I close the current editor

Scenario: Kontengruppe muss ausgewählt sein
Given I open an editor "Kontengruppe" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "ZKTestCU"
Then message "Keine Kontengruppe ausgewählt." was displayed
# 3543 : Keine Kontengruppe ausgewählt
Then saving the current editor throws the exception "3543"
And I set field "zkmitarbeiter" to "ja"
And I save the current editor
And I close the current editor

Scenario: Keine Kriterien ausgewählt -> Hinweismeldung unplasible Konfiguration; speichern möglich
Given I open an editor "Konfig" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "ZKKonfCU"
And I set field "zkmitarbeiter" to "ja"
# 3544 : Konfiguration der Zuordnungskriterien nicht plausibel.
Then message "Konfiguration der Zuordnungskriterien nicht plausibel." was displayed
And I save the current editor
Then message "Konfiguration der Zuordnungskriterien nicht plausibel." was displayed
And I close the current editor

Scenario Outline: Maximallänge darf nicht kleiner als die Mindestlänge sein
Given I open an editor "länge<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I set field "zkkunde" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "<minfield>" to "<minval>"
And I set field "<maxfield>" to "<maxval>"
# 3553 : Minimale Länge muss kleiner oder gleich der maximalen Länge sein.
Then saving the current editor throws the exception "3553"
And I close the current editor

Examples:

|nr|   field|musskann| minfield| maxfield|minval|maxval|
| 1| zkbeleg|    Muss| zkbelmin| zkbelmax|   987|   986|
| 2|zkebeleg|    Muss|zkebelmin|zkebelmax|    23|    22|
| 3| zkkunid|    Muss| zkkunmin| zkkunmax|     2|     1|
| 4| zkzaref|    Muss| zkzarmin| zkzarmax|    53|    52| 
| 5| zkbeleg|    Kann| zkbelmin| zkbelmax|   101|    11|
| 6|zkebeleg|    Kann|zkebelmin|zkebelmax|    12|    11|
| 7| zkkunzu|    Kann| zkkunmin| zkkunmax|   321|   123|
| 8| zkzaref|    Kann| zkzarmin| zkzarmax|     2|     1|

Scenario Outline: Maximallänge darf nicht kleiner als die Mindestlänge sein - Außnahme: Maximallänge ist null
# Bis Feld und Maximallänge dürfen leer/null sein
Given I open an editor "länge<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I set field "zkkunde" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "<minfield>" to "<minval>"
And I set field "<maxfield>" to "<maxval>"
And I save the current editor
And I close the current editor

Examples:

|nr|   field|musskann| minfield| maxfield|minval|maxval|
| 1| zkbeleg|    Muss| zkbelmin| zkbelmax|   987|     0|
| 2|zkebeleg|    Muss|zkebelmin|zkebelmax|    23|     0|
| 3| zkkunid|    Muss| zkkunmin| zkkunmax|     2|     0|
| 8| zkzaref|    Kann| zkzarmin| zkzarmax|     1|     0|

Scenario Outline: Unterer Grenzwert muss kleiner oder gleich dem oberen Grenzwert sein - Numerische Werte
Given I open an editor "wert<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I set field "zkkunde" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "<numfield>" to "ja"
And I set field "<vonfield>" to "<vonval>"
And I set field "<bisfield>" to "<bisval>"
# 3547 : Untergrenze muss kleiner der Obergrenze sein.
Then saving the current editor throws the exception "3547"
And I close the current editor

Examples:

|nr|   field|musskann| numfield| vonfield|vonval| bisfield|bisval|
| 1| zkbeleg|    Muss| zkbelnum| zkbelvon|    99| zkbelbis|    12|
| 2|zkebeleg|    Muss|zkebelnum|zkebelvon|   999|zkebelbis|   111|
| 3| zkzaref|    Muss| zkzarnum| zkzarvon|     9| zkzarbis|     8|
| 4| zkkunzu|    Muss| zkkunnum| zkkunvon|    68| zkkunbis|    67|
| 5| zkbeleg|    Kann| zkbelnum| zkbelvon|    99| zkbelbis|    12|
| 6|zkebeleg|    Kann|zkebelnum|zkebelvon|   999|zkebelbis|   111|
| 7| zkzaref|    Kann| zkzarnum| zkzarvon|     9| zkzarbis|     8|
| 8| zkkunid|    Kann| zkkunnum| zkkunvon|    68| zkkunbis|    67|

Scenario Outline: Unterer Grenzwert muss kleiner oder gleich dem oberen Grenzwert sein - Numerische Werte - darf nicht scheitern
Given I open an editor "wert<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I set field "zkkunde" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "<numfield>" to "ja"
And I set field "<vonfield>" to "<vonval>"
And I set field "<bisfield>" to "<bisval>"
And I save the current editor
And I close the current editor

Examples:

|nr|   field|musskann| numfield| vonfield|vonval| bisfield|bisval|
| 1| zkbeleg|    Kann| zkbelnum| zkbelvon|   999| zkbelbis|  7000|
| 2|zkebeleg|    Muss|zkebelnum|zkebelvon|   999|zkebelbis|  7000|
| 3| zkzaref|    Kann| zkzarnum| zkzarvon|   999| zkzarbis|  7000|
| 4| zkkunid|    Muss| zkkunnum| zkkunvon|   999| zkkunbis|  7000|

Scenario Outline: Unterer Grenzwert darf gleich dem oberen Grenzwert sein - Numerische Werte
Given I open an editor "wert<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I set field "zkkunde" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "<numfield>" to "ja"
And I set field "<vonfield>" to "<vonval>"
And I set field "<bisfield>" to "<bisval>"
And I save the current editor
And I close the current editor

Examples:

|nr|   field|musskann| numfield|vonfield |vonval|bisfield|bisval|
| 1| zkbeleg|    Muss| zkbelnum|zkbelvon |    99| zkbelbis|   99|
| 2|zkebeleg|    Muss|zkebelnum|zkebelvon|     1|zkebelbis|    1|
| 3| zkzaref|    Muss| zkzarnum| zkzarvon|   999| zkzarbis|  999|
| 4| zkkunid|    Muss| zkkunnum| zkkunvon|   687| zkkunbis|  687|
| 5| zkbeleg|    Kann| zkbelnum|zkbelvon |    99| zkbelbis|   99|
| 6|zkebeleg|    Kann|zkebelnum|zkebelvon|     1|zkebelbis|    1|
| 7| zkzaref|    Kann| zkzarnum| zkzarvon|   999| zkzarbis|  999|
| 8| zkkunzu|    Kann| zkkunnum| zkkunvon|   687| zkkunbis|  687|

Scenario Outline: Unterer Grenzwert muss kleiner oder gleich dem oberen Grenzwert sein - Alphanumerische Werte
Given I open an editor "wert<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I set field "zkkunde" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "<numfield>" to "nein"
And I set field "<vonfield>" to "<vonval>"
And I set field "<bisfield>" to "<bisval>"
# 3547 : Untergrenze muss kleiner der Obergrenze sein.
Then saving the current editor throws the exception "3547"
And I close the current editor

Examples:

|nr|   field|musskann| numfield|vonfield |vonval|bisfield|bisval|
| 1| zkbeleg|    Muss| zkbelnum|zkbelvon |  asdf| zkbelbis| asde|
| 2|zkebeleg|    Muss|zkebelnum|zkebelvon|  ab9c|zkebelbis| ab1c|
| 3| zkzaref|    Muss| zkzarnum| zkzarvon|   129| zkzarbis|  128|
| 4| zkkunzu|    Muss| zkkunnum| zkkunvon|   12b| zkkunbis|  12a|
| 5| zkbeleg|    Kann| zkbelnum|zkbelvon |  asdf| zkbelbis| asde|
| 6|zkebeleg|    Kann|zkebelnum|zkebelvon|  ab9c|zkebelbis| ab1c|
| 7| zkzaref|    Kann| zkzarnum| zkzarvon|   129| zkzarbis|  128|
| 8| zkkunid|    Kann| zkkunnum| zkkunvon|   12b| zkkunbis|  12a|


Scenario Outline: Unterer Grenzwert darf gleich dem oberen Grenzwert sein - Alphanumerische Werte
Given I open an editor "wert<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I set field "zkkunde" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "<numfield>" to "nein"
And I set field "<vonfield>" to "<vonval>"
And I set field "<bisfield>" to "<bisval>"
And I save the current editor
And I close the current editor

Examples:

|nr|   field|musskann| numfield| vonfield|vonval| bisfield|bisval|
| 1| zkbeleg|    Muss| zkbelnum| zkbelvon|   abc| zkbelbis|   abc|
| 2|zkebeleg|    Muss|zkebelnum|zkebelvon|     1|zkebelbis|     1|
| 3| zkzaref|    Muss| zkzarnum| zkzarvon|    gg| zkzarbis|    gg|
| 4| zkkunzu|    Muss| zkkunnum| zkkunvon| 6c8d7| zkkunbis| 6c8d7|
| 5| zkbeleg|    Kann| zkbelnum| zkbelvon|   abc| zkbelbis|   abc|
| 6|zkebeleg|    Kann|zkebelnum|zkebelvon|     1|zkebelbis|     1|
| 7| zkzaref|    Kann| zkzarnum| zkzarvon|    gg| zkzarbis|    gg|
| 8| zkkunid|    Kann| zkkunnum| zkkunvon| 6c8d7| zkkunbis| 6c8d7|


Scenario Outline: Nur alphanumerische Grenzwerte erlaubt
Given I open an editor "alnumprep<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "alnum<nr>"
And I set field "zkkonto" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "zk<infix>num" to "nein"
And I set field "zk<infix>bis" to "zzzzzzzzzzzzzzzzzzzzzz"
And I save the current editor
And I close the current editor

Given I open an editor "alnumedit" via ID from editor "alnumprep<nr>" from field "nummer" in row 0 for table "(PaymentMasterFiles):(AllocationCriteria)" with command "UPDATE"
# 3549 : Wert darf nur alphanumerische Zeichen (a-z, A-Z, 0-9) enthalten.
And I set field "zk<infix>von" to "abc:324"
Then saving the current editor throws the exception "3549"
And I set field "zk<infix>von" to "23-345"
Then saving the current editor throws the exception "3549"
And I set field "zk<infix>von" to "32a;"
Then saving the current editor throws the exception "3549"
And I set field "zk<infix>von" to "al-num"
Then saving the current editor throws the exception "3549"
And I set field "zk<infix>von" to ""
And I set field "zk<infix>bis" to "abc:324"
Then saving the current editor throws the exception "3549"
And I set field "zk<infix>bis" to "23-345"
Then saving the current editor throws the exception "3549"
And I set field "zk<infix>bis" to "32a;"
Then saving the current editor throws the exception "3549"
And I set field "zk<infix>bis" to "al-num"
Then saving the current editor throws the exception "3549"
And I close the current editor

Examples:

|nr|   field|musskann|infix|
| 1| zkbeleg|    Muss|  bel|
| 2|zkebeleg|    Muss| ebel|
| 3| zkzaref|    Muss|  zar|
| 4| zkkunid|    Muss|  kun|
| 5| zkbeleg|    Kann|  bel|
| 6|zkebeleg|    Kann| ebel|
| 7| zkzaref|    Kann|  zar|
| 8| zkkunzu|    Kann|  kun|


Scenario Outline: Wenn numerisch gewählt, nur numerische Grenzwerte erlaubt
Given I open an editor "numprep<nr>" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "numpre"
And I set field "zkkonto" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "zk<infix>num" to "ja"
And I set field "zk<infix>bis" to "999999999999999999"
And I save the current editor
And I close the current editor

Given I open an editor "numedit" via ID from editor "numprep<nr>" from field "nummer" in row 0 for table "(PaymentMasterFiles):(AllocationCriteria)" with command "UPDATE"
And I set field "such" to "TEST"
And I set field "zklieferant" to "ja"
And I set field "<field>" to "<musskann>"
And I set field "zk<infix>num" to "ja"
And I set field "zk<infix>von" to "a"
# 3548 : Feld "Numerisch" ist gesetzt. Wert darf nur aus numerischen Zeichen (0-9) bestehen.
Then saving the current editor throws the exception "3548"
And I set field "zk<infix>von" to "a2"
Then saving the current editor throws the exception "3548"
And I set field "zk<infix>von" to "3a2"
Then saving the current editor throws the exception "3548"
And I set field "zk<infix>von" to "369-28542"
Then saving the current editor throws the exception "3548"
And I set field "zk<infix>von" to ""
And I set field "zk<infix>bis" to "a"
Then saving the current editor throws the exception "3548"
And I set field "zk<infix>bis" to "a2"
Then saving the current editor throws the exception "3548"
And I set field "zk<infix>bis" to "3a2"
Then saving the current editor throws the exception "3548"
And I set field "zk<infix>bis" to "369-28542"
Then saving the current editor throws the exception "3548"
And I close the current editor

Examples:

|nr|   field|musskann|infix|
| 1| zkbeleg|    Muss|  bel|
| 2|zkebeleg|    Muss| ebel|
| 3| zkzaref|    Muss|  zar|
| 4| zkkunzu|    Muss|  kun|
| 5| zkbeleg|    Kann|  bel|
| 6|zkebeleg|    Kann| ebel|
| 7| zkzaref|    Kann|  zar|
| 8| zkkunid|    Kann|  kun|


Scenario: Verwendung einer unplausiblen Konfiguration
# Anlegen der Zuordnungskriterien
Given I open an editor "unpl_gut" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "zkgutunp"
And I set field "zkkunde" to "ja"
And I set field "zabuchart" to "Gutschrift"
And I save the current editor
Then message "Konfiguration der Zuordnungskriterien nicht plausibel." was displayed
And I close the current editor

Given I open an editor "unpl_bel" from table "(PaymentMasterFiles):(AllocationCriteria)" with command "NEW" for record ""
And I set field "such" to "zkbelunp"
And I set field "zkkunde" to "ja"
And I set field "zabuchart" to "Belastung"
And I save the current editor
Then message "Konfiguration der Zuordnungskriterien nicht plausibel." was displayed
And I close the current editor

# Eintrag durch Anwender
Given I open an editor "bauszunpl1" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "1bauszun"
And I create a new row at the end of the table
And I set field "tbubetr" to "100" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bauszunple" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "1bauszun"
And I set field "zkgutschrift" to "zkgutunp"
And I set field "zkbelastung" to "zkbelunp"
# 3544 : Konfiguration der Zuordnungskriterien nicht plausibel.
Then pressing button "bauto" in row 0 to open a subeditor throws the exception "3544"
And I close the current editor

# - Bankimpordatei
Given I open an editor "bauszunpl2" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "2bauszun"
And I create a new row at the end of the table
And I set field "tbubetr" to "100" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bdatunpl1" from table "(Bankimport):(BankImportFile)" with command "NEW" for record ""
And I set field "nummer" to "1bdatun"
And I create a new row at the end of the table
And I set field "nachricht" to "2bauszun" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bdatunple" from table "(Bankimport):(BankImportFile)" with command "UPDATE" for record "1bdatun"
And I set field "zkgutschrift" to "zkgutunp"
And I set field "zkbelastung" to "zkbelunp"
# 3544 : Konfiguration der Zuordnungskriterien nicht plausibel.
Then pressing button "bauto" in row 0 to open a subeditor throws the exception "3544"
And I close the current editor

# Eintrag durch Vorbelegung aus Konfig
# Als Standard in Konfig eintragen
Given I open an editor "konf" from table "(PaymentMasterFiles):(CMConfig)" with command "UPDATE" for record "1"
And I set field "zuordkgutschrift" to "nummer" from editor "unpl_gut"
And I set field "zuordkbelastung" to "nummer" from editor "unpl_bel"
And I save the current editor
And I close the current editor

# - Bankkontoauszug
Given I open an editor "bauszunpl2" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "3bauszun"
And I create a new row at the end of the table
And I set field "tbubetr" to "100" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bauszunple" from table "(Bankimport):(BankStatement)" with command "UPDATE" for record "3bauszun"
Then field "zkgutschrift^such" has value "ZKGUTUNP"
Then field "zkbelastung^such" has value "ZKBELUNP"
# 3544 : Konfiguration der Zuordnungskriterien nicht plausibel.
Then pressing button "bauto" in row 0 to open a subeditor throws the exception "3544"
And I close the current editor

# - Bankimpordatei
Given I open an editor "bauszunpl4" from table "(Bankimport):(BankStatement)" with command "NEW" for record ""
And I set field "nummer" to "4bauszun"
And I create a new row at the end of the table
And I set field "tbubetr" to "100" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bdatunpl2" from table "(Bankimport):(BankImportFile)" with command "NEW" for record ""
And I set field "nummer" to "2bdatun"
And I create a new row at the end of the table
And I set field "nachricht" to "4bauszun" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "bdatunple" from table "(Bankimport):(BankImportFile)" with command "UPDATE" for record "2bdatun"
Then field "zkgutschrift^such" has value "ZKGUTUNP"
Then field "zkbelastung^such" has value "ZKBELUNP"
# 3544 : Konfiguration der Zuordnungskriterien nicht plausibel.
Then pressing button "bauto" in row 0 to open a subeditor throws the exception "3544"
And I close the current editor

