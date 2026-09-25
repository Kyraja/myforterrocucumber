# *****************************************************************************
#  Name           : plausi_kv_mit_gesperrtem_obj_in_dbu_neu_cu.feature
#  Autor          : Jan Effler
#  Verantwortlich : sih
#  Funktion       : Prüfung auf hart und Hinweis-gesperrte Kostenobjekte in Kostenverteilern (Stamm- und dynamische) bei Verwendung 
#                   der Kostenverteiler in der Finanz- und statistischen Buchungsvorlage bei Neuanlage
#
# *****************************************************************************

@persistent
Feature: plausi_kv_mit_gesperrtem_obj_in_dbu_neu_cu
Background: Sperren

Given I set the fake date to "07.12.95"

Scenario: Konto anlegen

Given I open an editor "acc1" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "159674"
And I set field "such" to "guv1"
And I set field "namebspr" to "GuV Konto 1"
And I set field "gv" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "acc2" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "159675"
And I set field "such" to "guv2"
And I set field "namebspr" to "GuV Konto 2"
And I set field "gv" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "statacc1" from table "(Account):(Account)" with command "COPY" for record "159674"
And I set field "nummer" to "159674S"
And I set field "stata" to "Kostenrechnung"
And I save the current editor
And I close the current editor

Given I open an editor "statacc2" from table "(Account):(Account)" with command "COPY" for record "159675"
And I set field "nummer" to "159675S"
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

|      type|nummer|  such|
|CostCenter|   1ks|    ks|
|CostCenter|   2ks|kshart|
|CostCenter|   3ks|kshinw|
|CostObject|   1kt|    kt|
|CostObject|   2kt|kthart|
|CostObject|   3kt|kthinw|

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

|nummer|        such|kstelle1|proz1|kstelle2|proz2|
|999991|      kvhinw|     1ks|   50|     1kt|   50|
|999992|      kvhart|     1ks|   50|     1kt|   50|
|999000|      kvfrei|     1ks|   50|     1kt|   50|
|999001|    kvkshinw|     3ks|   50|     1ks|   50|
|999002|    kvkshart|     2ks|   50|     1ks|   50|
|999003|kvkshinwhart|     3ks|   50|     2ks|   50|
|999004|    kvkthinw|     1kt|   50|     3kt|   50|
|999005|    kvkthart|     1kt|   50|     2kt|   50|
|999006|kvkthinwhart|     2kt|   50|     3kt|   50|
|999007| kvmischhart|     2ks|   50|     2kt|   50|
|999008| kvmischhinw|     3kt|   50|     3ks|   50|
|999009| kvmischhiha|     3ks|   50|     2kt|   50|
|999010|kvmischhiha2|     2ks|   50|     3kt|   50|

Scenario Outline: Kostenstellen und -traeger anlegen
Given I open an editor "kskt" from table "(Account):(<type>)" with command "UPDATE" for record "<nummer>"
And I set field "sperrkonfigurationneu" to "<sperrkonfig>"
And I save the current editor
And I close the current editor

Examples:

|            type|nummer|                                         sperrkonfig|
|      CostCenter|   2ks|                        Standard-Kostenstellensperre|
|      CostCenter|   3ks|       Individuelle Kostenstellensperre, nur Hinweis|
|      CostObject|   2kt|                        Standard-Kostentraegersperre|
|      CostObject|   3kt|        Individuelle Kostenträgersperre, nur Hinweis|
|CostDistribution|999992|                 Standard-Stammkostenverteilersperre|
|CostDistribution|999991|Individuelle Stammkostenverteilersperre, nur Hinweis|


Scenario: Vorlagen anlegen - Stammkostenverteiler ohne sperren

Given I open an editor "fibuvorl" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
And I set field "budat" to "01.01.96"
And I set field "butyp" to "Allgemeine Finanzbuchung"
And I set field "inbukreis1" to "ja"
And I append rows
| konto|ewsbetr|ewhbetr|kstelle|
|159674|    100|      0| 999000|
|159675|      0|    100|       |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor 
And I close the current editor

Given I open an editor "statbuvorl" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I append rows
|  konto|sbetrag|hbetrag|kstelle|
|159674S|    100|      0| 999000|
|159675S|      0|    100|       |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor 
And I close the current editor

Scenario Outline: Finanzbuchungsvorlagen anlegen - Stammkostenverteiler mit hart gesperrten Kostenobjekten

Given I open an editor "fibuvorl" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
And I set field "budat" to "01.01.96"
And I set field "butyp" to "Allgemeine Finanzbuchung"
And I set field "inbukreis1" to "ja"
And I append rows
| konto|ewsbetr|ewhbetr|
|159674|    100|      0|
|159675|      0|    100|
Then setting field "kstelle" to "<kstelle>" in row 1 throws the exception "3602"
And I close the current editor

Examples:

|kstelle|
| 999002|
| 999003|
| 999005|
| 999006|
| 999007|
| 999009|
| 999010|

Scenario Outline: Statistische Buchungsvorlagen anlegen - Stammkostenverteiler mit hart gesperrten Kostenobjekten

Given I open an editor "statbuvorl" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I set field "budat" to "01.01.96"
And I set field "inbukreis1" to "ja"
And I append rows
| konto |sbetrag|hbetrag|
|159674S|    100|      0|
|159675S|      0|    100|
Then setting field "kstelle" to "<kstelle>" in row 1 throws the exception "3602"
And I close the current editor

Examples:

|kstelle|
| 999002|
| 999003|
| 999005|
| 999006|
| 999007|
| 999009|
| 999010|

Scenario: Finanzbuchungsvorlagen anlegen - dynamischer Kostenverteiler ohne sperren

Given I open an editor "fibuvorl" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
And I set field "budat" to "01.01.96"
And I set field "butyp" to "Allgemeine Finanzbuchung"
And I set field "inbukreis1" to "ja"
And I append rows
| konto|ewsbetr|ewhbetr|
|159674|    100|      0|
|159675|      0|    100|
And I press button "vert" to open a subeditor for "fibuvorlvert" in row 1
    And I append rows
    |kstelle|proz|
    |    1ks|  50|
    |    1kt|  50|
And I save the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor 
And I close the current editor

Given I open an editor "statbuvorl" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I append rows
|  konto|sbetrag|hbetrag|
|159674S|    100|      0|
|159675S|      0|    100|
And I press button "vert" to open a subeditor for "statbuvorlvert" in row 1
    And I append rows
    |kstelle|proz|
    |    1ks|  50|
    |    1kt|  50|
And I save the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor 
And I close the current editor


