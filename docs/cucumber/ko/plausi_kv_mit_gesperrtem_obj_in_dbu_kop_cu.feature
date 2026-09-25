# *****************************************************************************
#  Name           : plausi_kv_mit_gesperrtem_obj_in_dbu_kop_cu.feature
#  Autor          : Jan Effler
#  Verantwortlich : sih
#  Funktion       : Prüfung auf hart und Hinweis-gesperrte Kostenobjekte in Kostenverteilern (Stamm- und dynamische) bei Verwendung
#                   der Kostenverteiler in der Finanz- und statistischen Buchungsvorlage bei Kopieren
#
# *****************************************************************************

@persistent

Feature: plausi_kv_mit_gesperrtem_obj_in_dbu_kop_cu
Background: Sperren

Given I set the fake date to "07.12.95"

Scenario: Konto anlegen

Given I open an editor "acc1" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "159676"
And I set field "such" to "guv1"
And I set field "namebspr" to "GuV Konto 1-2"
And I set field "gv" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "acc2" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "159677"
And I set field "such" to "guv2"
And I set field "namebspr" to "GuV Konto 2-2"
And I set field "gv" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "statacc1" from table "(Account):(Account)" with command "COPY" for record "159676"
And I set field "nummer" to "159676S"
And I set field "stata" to "Kostenrechnung"
And I save the current editor
And I close the current editor

Given I open an editor "statacc2" from table "(Account):(Account)" with command "COPY" for record "159677"
And I set field "nummer" to "159677S"
And I set field "stata" to "Kostenrechnung"
And I save the current editor
And I close the current editor


Scenario Outline: Kostenstellen und -traeger anlegen

Given I open an editor "kskt" from table "(Account):(<type>)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "such" to "<such>"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Examples:

|      type|nummer|     such|
|CostCenter|1kskop|    kskop|
|CostCenter|2kskop|kshartkop|
|CostCenter|3kskop|kshinwkop|
|CostObject|1ktkop|    ktkop|
|CostObject|2ktkop|kthartkop|
|CostObject|3ktkop|kthinwkop|

Scenario Outline: Stammkostenverteiler anlegen

Given I open an editor "kv" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set fields
|nummer|<nummer>|
|  such|  <such>|
And I append rows
|   kstelle|   proz|
|<kstelle1>|<proz1>|
|<kstelle2>|<proz2>|
And I save the current editor
And I close the current editor

Examples:

|nummer|         such| kstelle1|proz1| kstelle2|proz2|
|777771|      kvhinw2|    kskop|   50|    ktkop|   50|
|777772|      kvhart2|    kskop|   50|    ktkop|   50|
|777000|      kvfrei2|    kskop|   50|    ktkop|   50|
|777001|    kvkshinw2|kshinwkop|   50|    kskop|   50|
|777002|    kvkshart2|kshartkop|   50|    kskop|   50|
|777003|kvkshinwhart2|kshinwkop|   50|kshartkop|   50|
|777004|    kvkthinw2|    ktkop|   50|kthinwkop|   50|
|777005|    kvkthart2|    ktkop|   50|kthartkop|   50|
|777006|kvkthinwhart2|kthartkop|   50|kthinwkop|   50|
|777007| kvmischhart2|kshartkop|   50|kthartkop|   50|
|777008| kvmischhinw2|kthinwkop|   50|kshinwkop|   50|
|777009| kvmischhiha2|kshinwkop|   50|kthartkop|   50|
|777010|kvmischhiha22|kshartkop|   50|kthinwkop|   50|


Scenario Outline: Finanzbuchungsvorlagen mit Stammkostenverteilern erstellen

Given I open an editor "skvfibuvorl" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
And I set fields
|    nummer|                <nummer>|
|     budat|                01.01.96|
|     butyp|Allgemeine Finanzbuchung|
|inbukreis1|                      ja|
And I append rows
| Konto|ewsbetr|ewhbetr|  kstelle|
|159676|    100|       |<kstelle>|
|159677|       |    100|         |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Examples:

|nummer|kstelle|
|159113| 777771|
|159112| 777772|
|159101| 777000|
|159102| 777001|
|159103| 777002|
|159104| 777003|
|159105| 777004|
|159106| 777005|
|159107| 777006|
|159108| 777007|
|159109| 777008|
|159110| 777009|
|159111| 777010|

Scenario Outline: Statistische Buchungsvorlagen mit Stammkostenverteilern erstellen

Given I open an editor "skvstatbuvorl" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I set fields
|    nummer|<nummer>|
|     budat|01.01.96|
|inbukreis1|      ja|
And I append rows
|  Konto|sbetrag|hbetrag|  kstelle|
|159676S|    100|       |<kstelle>|
|159677S|       |    100|         |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Examples:

|nummer|kstelle|
|159221| 777771|
|159222| 777772|
|159201| 777000|
|159202| 777001|
|159203| 777002|
|159204| 777003|
|159205| 777004|
|159206| 777005|
|159207| 777006|
|159208| 777007|
|159209| 777008|
|159210| 777009|
|159211| 777010|

Scenario Outline: Statistische Buchungsvorlagen mit dynamischen kostenverteilern erstellen

Given I open an editor "skvstatbuvorl" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I set fields
|    nummer|<nummer>|
|     budat|01.01.96|
|inbukreis1|      ja|
And I append rows
|  Konto|sbetrag|hbetrag|
|159676S|    100|       |
|159677S|       |    100|
And I press button "vert" to open a subeditor for "skvstatbuvorlvert" in row 1
    And I append rows
    |kstelle|proz|
    |  <ks1>|  50|
    |  <ks2>|  50|
And I save the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Examples:

|nummer|   ks1|   ks2|
|159301|1kskop|1ktkop|
|159302|3kskop|1kskop|
|159303|2kskop|1kskop|
|159304|3kskop|2kskop|
|159305|1ktkop|3ktkop|
|159306|1ktkop|2ktkop|
|159307|2ktkop|3ktkop|
|159308|2kskop|2ktkop|
|159309|3ktkop|3kskop|
|159310|3kskop|2ktkop|
|159311|2kskop|3ktkop|

Scenario Outline: Finanzbuchungsvorlagen mit dynamischen Kostenverteilern erstellen

Given I open an editor "skvfibuvorl" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
And I set fields
|    nummer|                <nummer>|
|     budat|                01.01.96|
|     butyp|Allgemeine Finanzbuchung|
|inbukreis1|                      ja|
And I append rows
| konto|ewsbetr|ewhbetr|
|159676|    100|       |
|159677|       |    100|
And I press button "vert" to open a subeditor for "skvfibuvorlvert" in row 1
    And I append rows
    |kstelle|proz|
    |  <ks1>|  50|
    |  <ks2>|  50|
And I save the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Examples:

|nummer|   ks1|   ks2|
|159401|1kskop|1ktkop|
|159402|3kskop|1kskop|
|159403|2kskop|1kskop|
|159404|3kskop|2kskop|
|159405|1ktkop|3ktkop|
|159406|1ktkop|2ktkop|
|159407|2ktkop|3ktkop|
|159408|2kskop|2ktkop|
|159409|3ktkop|3kskop|
|159410|3kskop|2ktkop|
|159411|2kskop|3ktkop|

Scenario Outline: Kostenstellen und -traeger sperren

Given I open an editor "kskt" from table "(Account):(<type>)" with command "UPDATE" for record "<nummer>"
And I set field "sperrkonfigurationneu" to "<sperrkonfig>"
And I save the current editor
And I close the current editor

Examples:

|            type|nummer|                                         sperrkonfig|
|      CostCenter|2kskop|                        Standard-Kostenstellensperre|
|      CostCenter|3kskop|       Individuelle Kostenstellensperre, nur Hinweis|
|      CostObject|2ktkop|                        Standard-Kostentraegersperre|
|      CostObject|3ktkop|        Individuelle Kostenträgersperre, nur Hinweis|
|CostDistribution|777772|                 Standard-Stammkostenverteilersperre|
|CostDistribution|777771|Individuelle Stammkostenverteilersperre, nur Hinweis|

Scenario: Finanzbuchungsvorlagen mit gesperrtem Objekt im Stammkostenverteiler Kopieren - ohne Sperren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==159101;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|kstelle|
|   1|159676| 100.00|   0.00| 777000|
|   2|159677|   0.00| 100.00|       |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor


Scenario Outline: Finanzbuchungsvorlagen mit gesperrtem Objekt im Stammkostenverteiler Kopieren - Hinweissperren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|kstelle|
|   1|159676| 100.00|   0.00|  <kst>|
|   2|159677|   0.00| 100.00|       |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I close the current editor

Examples:

|example|record|   kst|
|      1|159113|777771|
|      2|159102|777001|
|      3|159105|777004|
|      4|159109|777008|


Scenario Outline: Finanzbuchungsvorlage mit hart gesperrtem Stammkostenverteiler kopieren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==159112;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|kstelle|
|   1|159676| 100.00|   0.00| 777772|
|   2|159677|   0.00| 100.00|       |
Then saving the current editor throws the exception "4806"
And I close the current editor

Scenario Outline: Finanzbuchungsvorlagen mit gesperrtem Objekt im Stammkostenverteiler Kopieren - harte Sperren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|kstelle|
|   1|159676| 100.00|   0.00|  <kst>|
|   2|159677|   0.00| 100.00|       |
Then saving the current editor throws the exception "3602"
And I close the current editor

Examples:

|example|record|   kst|
|      1|159103|777002|
|      2|159106|777005|
|      3|159108|777007|

Scenario Outline: Finanzbuchungsvorlagen mit gesperrtem Objekt im Stammkostenverteiler Kopieren - gemischte Sperren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|kstelle|
|   1|159676| 100.00|   0.00|  <kst>|
|   2|159677|   0.00| 100.00|       |
Then saving the current editor throws the exception "3602"
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I close the current editor

Examples:

|example|record|   kst|
|      1|159104|777003|
|      2|159107|777006|
|      3|159110|777009|
|      4|159111|777010|

Scenario: Statistische Buchungsvorlagen mit gesperrtem Objekt im Stammkostenverteiler Kopieren - ohne Sperren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==159201;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|kstelle|
|   1|159676S| 100.00|   0.00| 777000|
|   2|159677S|   0.00| 100.00|       |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor


Scenario Outline: Statistische Buchungsvorlagen mit gesperrtem Objekt im Stammkostenverteiler Kopieren - Hinweissperren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|kstelle|
|   1|159676S| 100.00|   0.00|  <kst>|
|   2|159677S|   0.00| 100.00|       |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I close the current editor

Examples:

|example|record|   kst|
|      1|159221|777771|
|      2|159202|777001|
|      3|159205|777004|
|      4|159209|777008|

Scenario Outline: Statistische Buchungsvorlage mit hart gesperrtem Stammkostenverteiler kopieren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==159222;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|kstelle|
|   1|159676S| 100.00|   0.00| 777772|
|   2|159677S|   0.00| 100.00|       |
# Objekt ist gesperrt.
Then saving the current editor throws the exception "4806"
And I close the current editor

Examples:

|example|record|   kst|
|      1|159203|777002|
|      2|159206|777005|
|      3|159208|777007|


Scenario Outline: Statistische Buchungsvorlagen mit gesperrtem Objekt im Stammkostenverteiler Kopieren - harte Sperren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|kstelle|
|   1|159676S| 100.00|   0.00|  <kst>|
|   2|159677S|   0.00| 100.00|       |
Then saving the current editor throws the exception "3602"
And I close the current editor

Examples:

|example|record|   kst|
|      1|159203|777002|
|      2|159206|777005|
|      3|159208|777007|

Scenario Outline: Statistische Buchungsvorlagen mit gesperrtem Objekt im Stammkostenverteiler Kopieren - gemischte Sperren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|kstelle|
|   1|159676S| 100.00|   0.00|  <kst>|
|   2|159677S|   0.00| 100.00|       |
Then saving the current editor throws the exception "3602"
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I close the current editor

Examples:

|example|record|   kst|
|      1|159204|777003|
|      2|159207|777006|
|      3|159210|777009|
|      4|159211|777010|

Scenario: Finanzbuchungsvorlagen mit gesperrtem Objekt im dynamischen Kostenverteiler Kopieren - ohne Sperren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==159401;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|
|   1|159676| 100.00|   0.00|
|   2|159677|   0.00| 100.00|
And I press button "vert" to open a subeditor for "buvorsperrvert" in row 1
    Then table has values
    |!row|kstelle|proz|
    |   1| 1kskop|  50|
    |   2| 1ktkop|  50|
And I close the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Scenario Outline: Finanzbuchungsvorlagen mit gesperrtem Objekt im dynamischen Kostenverteiler Kopieren - Hinweissperren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|
|   1|159676| 100.00|   0.00|
|   2|159677|   0.00| 100.00|
And I press button "vert" to open a subeditor for "buvorsperrvert" in row 1
    Then table has values
    |!row|kstelle|proz|
    |   1| <kst1>|  50|
    |   2| <kst2>|  50|
And I close the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I close the current editor

Examples:

|example|record|  kst1|  kst2|
|      1|159402|3kskop|1kskop|
|      2|159405|1ktkop|3ktkop|
|      3|159409|3ktkop|3kskop|

Scenario Outline: Finanzbuchungsvorlagen mit gesperrtem Objekt im dynamischen Kostenverteiler Kopieren - harte Sperren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|
|   1|159676| 100.00|   0.00|
|   2|159677|   0.00| 100.00|
And I press button "vert" to open a subeditor for "buvorsperrvert" in row 1
    Then table has values
    |!row|kstelle|proz|
    |   1| <kst1>|  50|
    |   2| <kst2>|  50|
And I close the current subeditor to switch back to the parent editor
Then saving the current editor throws the exception "3602"
And I close the current editor

Examples:

|example|record|  kst1|  kst2|
|      1|159403|2kskop|1kskop|
|      2|159406|1ktkop|2ktkop|
|      3|159408|2kskop|2ktkop|

Scenario Outline: Finanzbuchungsvorlagen mit gesperrtem Objekt im dynamischen Kostenverteiler Kopieren - gemischte Sperren

Given I open an editor "buvorsperr" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=0"
Then field "budat" has value "01.01.96"
Then field "butyp" has value "Allgemeine Finanzbuchung"
Then field "inbukreis1" has value "ja"
Then table has values
|!row| konto|ewsbetr|ewhbetr|
|   1|159676| 100.00|   0.00|
|   2|159677|   0.00| 100.00|
And I press button "vert" to open a subeditor for "buvorsperrvert" in row 1
    Then table has values
    |!row|kstelle|proz|
    |   1| <kst1>|  50|
    |   2| <kst2>|  50|
And I close the current subeditor to switch back to the parent editor
Then saving the current editor throws the exception "3602"
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I close the current editor

Examples:

|example|record|  kst1|  kst2|
|      1|159404|3kskop|2kskop|
|      2|159407|2ktkop|3ktkop|
|      3|159410|3kskop|2ktkop|
|      3|159411|2kskop|3ktkop|

Scenario: Statistische Buchungsvorlagen mit gesperrtem Objekt im dynamischen Kostenverteiler Kopieren - ohne Sperren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==159301;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|
|   1|159676S| 100.00|   0.00|
|   2|159677S|   0.00| 100.00|
And I press button "vert" to open a subeditor for "buvorsperrvert" in row 1
    Then table has values
    |!row|kstelle|proz|
    |   1| 1kskop|  50|
    |   2| 1ktkop|  50|
And I close the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Scenario Outline: Statistische Buchungsvorlagen mit gesperrtem Objekt im dynamischen Kostenverteiler Kopieren - Hinweissperren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|
|   1|159676S| 100.00|   0.00|
|   2|159677S|   0.00| 100.00|
And I press button "vert" to open a subeditor for "buvorsperrvert" in row 1
    Then table has values
    |!row|kstelle|proz|
    |   1| <kst1>|  50|
    |   2| <kst2>|  50|
And I close the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I close the current editor

Examples:

|example|record|  kst1|  kst2|
|      1|159302|3kskop|1kskop|
|      2|159305|1ktkop|3ktkop|
|      3|159309|3ktkop|3kskop|

Scenario Outline: Statistische Buchungsvorlagen mit gesperrtem Objekt im dynamischen Kostenverteiler Kopieren - harte Sperren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|
|   1|159676S| 100.00|   0.00|
|   2|159677S|   0.00| 100.00|
And I press button "vert" to open a subeditor for "buvorsperrvert" in row 1
    Then table has values
    |!row|kstelle|proz|
    |   1| <kst1>|  50|
    |   2| <kst2>|  50|
And I close the current subeditor to switch back to the parent editor
Then saving the current editor throws the exception "3602"
And I close the current editor

Examples:

|example|record|  kst1|  kst2|
|      1|159303|2kskop|1kskop|
|      2|159306|1ktkop|2ktkop|
|      3|159308|2kskop|2ktkop|

Scenario Outline: Statistische Buchungsvorlagen mit gesperrtem Objekt im dynamischen Kostenverteiler Kopieren - gemischte Sperren

Given I open an editor "statbuvorsperr" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "COPY" for search criteria "$,,nummer==<record>;@datenbank=110;@gruppe=1"
Then field "budat" has value "01.01.96"
Then field "inbukreis1" has value "ja"
Then table has values
|!row|  konto|sbetrag|hbetrag|
|   1|159676S| 100.00|   0.00|
|   2|159677S|   0.00| 100.00|
And I press button "vert" to open a subeditor for "buvorsperrvert" in row 1
    Then table has values
    |!row|kstelle|proz|
    |   1| <kst1>|  50|
    |   2| <kst2>|  50|
And I close the current subeditor to switch back to the parent editor
Then saving the current editor throws the exception "3602"
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I close the current editor

Examples:

|example|record|  kst1|  kst2|
|      1|159304|3kskop|2kskop|
|      2|159307|2ktkop|3ktkop|
|      3|159310|3kskop|2ktkop|
|      3|159311|2kskop|3ktkop|

