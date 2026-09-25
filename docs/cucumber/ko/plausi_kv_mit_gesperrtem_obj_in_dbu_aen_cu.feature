# *****************************************************************************
#  Name           : plausi_kv_mit_gesperrtem_obj_in_dbu_aen_cu.feature
#  Autor          : Jan Effler
#  Verantwortlich : sih
#  Funktion       : Prüfung auf hart und Hinweis-gesperrte Kostenobjekte in Kostenverteilern (Stamm- und dynamische) bei Verwendung
#                   der Kostenverteiler in der Finanz- und statistischen Buchungsvorlage bei Aendern
#
# *****************************************************************************

@persistent

Feature: plausi_kv_mit_gesperrtem_obj_in_dbu_aen_cu
Background: Sperren

Given I set the fake date to "07.12.95"

Scenario: Konto anlegen

Given I open an editor "acc1" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "159678"
And I set field "such" to "guv1"
And I set field "namebspr" to "GuV Konto 1-2"
And I set field "gv" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "acc2" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "159679"
And I set field "such" to "guv2"
And I set field "namebspr" to "GuV Konto 2-2"
And I set field "gv" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "statacc1" from table "(Account):(Account)" with command "COPY" for record "159678"
And I set field "nummer" to "159678S"
And I set field "stata" to "Kostenrechnung"
And I save the current editor
And I close the current editor

Given I open an editor "statacc2" from table "(Account):(Account)" with command "COPY" for record "159679"
And I set field "nummer" to "159679S"
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
|CostCenter|1ksaen|    ksaen|
|CostCenter|2ksaen| ksaenhal|
|CostCenter|3ksaen| ksaenhil|
|CostObject|1ktaen|    ktaen|
|CostObject|2ktaen| ktaenhal|
|CostObject|3ktaen| ktaenhil|

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
|888888|      kvaenfr|    ksaen|   50|    ktaen|   50|
|888000|      kvaenhi|    ksaen|   50|    ktaen|   50|
|888001|      kvaenha|    ktaen|   50|    ksaen|   50|
|888002|    kvaenkshi|   3ksaen|   50|    ktaen|   50|
|888003|    kvaenkthi|   3ktaen|   50|    ksaen|   50|
|888004|    kvaenksha|   2ksaen|   50|    ktaen|   50|
|888005|    kvaenktha|   2ktaen|   50|    ksaen|   50|
|888006|  kvaenkshiha|   3ksaen|   50|   2ksaen|   50|
|888007|  kvaenkthiha|   2ktaen|   50|   3ktaen|   50|
|888008|kvaenkthiksha|   3ktaen|   50|   2ksaen|   50|
|888009|kvaenkthakshi|   2ktaen|   50|   3ksaen|   50|

Scenario Outline: Kostenobjekte sperren

Given I open an editor "kskt" from table "(Account):(<type>)" with command "UPDATE" for record "<nummer>"
And I set field "sperrkonfigurationneu" to "<sperrkonfig>"
And I save the current editor
And I close the current editor

Examples:

|            type|nummer|                                         sperrkonfig|
|      CostCenter|2ksaen|                        Standard-Kostenstellensperre|
|      CostCenter|3ksaen|       Individuelle Kostenstellensperre, nur Hinweis|
|      CostObject|2ktaen|                        Standard-Kostentraegersperre|
|      CostObject|3ktaen|        Individuelle Kostenträgersperre, nur Hinweis|
|CostDistribution|888001|                 Standard-Stammkostenverteilersperre|
|CostDistribution|888000|Individuelle Stammkostenverteilersperre, nur Hinweis|

Scenario: Finanzbuchungsvorlage mit Stammkostenverteilern erstellen

Given I open an editor "skvfibuvorl" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
And I set fields
|    nummer|                  148101|
|     budat|                01.01.96|
|     butyp|Allgemeine Finanzbuchung|
|inbukreis1|                      ja|
And I append rows
| Konto|ewsbetr|ewhbetr|  kstelle|
|159678|    100|       |   888888|
|159679|       |    100|         |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Scenario: Statistische Buchungsvorlage mit Stammkostenverteilern erstellen

Given I open an editor "skvstatbuvorl" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I set fields
|    nummer|  148201|
|     budat|01.01.96|
|inbukreis1|      ja|
And I append rows
|  Konto|sbetrag|hbetrag|  kstelle|
|159678S|    100|       |   888888|
|159679S|       |    100|         |
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Scenario: Statistische Buchungsvorlage mit dynamischen kostenverteilern erstellen

Given I open an editor "skvstatbuvorl" from table "(RecurringEntry):(StatisticalEntryTemplate)" with command "NEW" for record ""
And I set fields
|    nummer|  148301|
|     budat|01.01.96|
|inbukreis1|      ja|
And I append rows
|  Konto|sbetrag|hbetrag|
|159678S|    100|       |
|159679S|       |    100|
And I press button "vert" to open a subeditor for "skvstatbuvorlvert" in row 1
    And I append rows
    |kstelle|proz|
    |  ksaen|  50|
    |  ktaen|  50|
And I save the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Scenario: Finanzbuchungsvorlage mit dynamischen Kostenverteilern erstellen

Given I open an editor "skvfibuvorl" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
And I set fields
|    nummer|                  148401|
|     budat|                01.01.96|
|     butyp|Allgemeine Finanzbuchung|
|inbukreis1|                      ja|
And I append rows
| Konto|ewsbetr|ewhbetr|
|159678|    100|       |
|159679|       |    100|
And I press button "vert" to open a subeditor for "skvfibuvorlvert" in row 1
    And I append rows
    |kstelle|proz|
    |  ksaen|  50|
    |  ktaen|  50|
And I save the current subeditor to switch back to the parent editor
# 7709 : Buchungsvorlage o.k.?
And I respond with answer "ja" to the dialog with id "7709"
And I save the current editor
And I close the current editor

Scenario Outline: hart gesperrte Kostenobjekte eintragen 1 - Stammkostenverteiler

Given I open an editor "<editor>" from table "(RecurringEntry):(<type>EntryTemplate)" with command "UPDATE" for record "<record>"
Then field "kstelle" has value "888888" in row 1
# 3602 : Kostenverteiler enthaelt gesperrte Objekte
Then setting field "kstelle" to "<kstelle>" in row 1 throws the exception "3602"
Then field "kstelle" has value "888888" in row 1
And I close the current editor

Examples:

|example| editor|       type|record|  kstelle|
|      2|skvhal2|  Financial|148101|kvaenksha|
|      3|skvhal3|  Financial|148101|kvaenktha|
|      4|skvhal5|Statistical|148201|kvaenksha|
|      6|skvhal6|Statistical|148201|kvaenktha|

Scenario Outline: hart gesperrte Kostenobjekte eintragen 2 - Stammkostenverteiler

Given I open an editor "<editor>" from table "(RecurringEntry):(<type>EntryTemplate)" with command "UPDATE" for record "<record>"
Then field "kstelle" has value "888888" in row 1
Then field "kstellesperredeakt" has value "ja" in row 1
# Kostenverteiler enthaelt gesperrte Objekte.
Then setting field "kstelle" to "<kstelle>" in row 1 throws the exception "3602"
And I close the current editor

Examples:
|example|  editor|       type|record|      kstelle|
|      1|skvmixl1|  Financial|148101|  kvaenkshiha|
|      2|skvmixl2|  Financial|148101|  kvaenkthiha|
|      3|skvmixl3|  Financial|148101|kvaenkthiksha|
|      4|skvmixl4|  Financial|148101|kvaenkthakshi|


Scenario Outline: gemischt gesperrte Kostenobjekte eintragen - Stammkostenverteiler

# Es erscheint nur die Fehlermeldung 3602, es gibt keinen separaten Hinweis für Hinweisgesperrte Kostenobjekte im Stammkostenverteiler
Given I open an editor "<editor>" from table "(RecurringEntry):(<type>EntryTemplate)" with command "UPDATE" for record "<record>"
Then field "kstelle" has value "888888" in row 1
# 3602 : Kostenverteiler enthaelt gesperrte Objekte
Then setting field "kstelle" to "<kstelle>" in row 1 throws the exception "3602"
And I close the current editor

Examples:
|example|  editor|       type|record|      kstelle|
|      1|skvmixl1|  Financial|148101|  kvaenkshiha|
|      2|skvmixl2|  Financial|148101|  kvaenkthiha|
|      3|skvmixl3|  Financial|148101|kvaenkthiksha|
|      4|skvmixl4|  Financial|148101|kvaenkthakshi|
|      5|skvmixl5|Statistical|148201|  kvaenkshiha|
|      6|skvmixl6|Statistical|148201|  kvaenkthiha|
|      7|skvmixl7|Statistical|148201|kvaenkthiksha|
|      8|skvmixl8|Statistical|148201|kvaenkthakshi|
