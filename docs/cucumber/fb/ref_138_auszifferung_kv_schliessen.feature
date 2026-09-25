# *****************************************************************************
#  Name             : ref_138_auszifferung_kv_schliessen.feature
#  Autor            : jeffler
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Auszifferung speichern mit "kvschl" auf ja
#
# *****************************************************************************
@persistent
Feature: ref_138_auszifferung_kv_schliessen.feature
Background: 

Given I set the fake date to "05.10.95"

Scenario: KV in Terminen aktivieren

Given I'm logged in with password "annette"

Given I open an editor "term" from table "12:12" with command "UPDATE" for record "2"
#And I press button "bsperremand"
And I set field "kvjahrku" to "94"
And I set field "kvjahrli" to "94"
And I set field "kvjahrma" to "94"
And I set field "kvjahrko" to "94"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"

Scenario: KV relevantes Konto anlegen

Given I open an editor "konto" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "1kauszkv"
And I set field "such" to "kvkonto"
And I set field "namebspr" to "Testkonto fuer Tests im Bereich der Auszifferungsmaske und Kontovorgaenge"
And I set field "kvrel" to "ja"
And I save the current editor
And I close the current editor

Scenario Outline: Buchungen erzeugen

Given I open an editor "buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "<beleg>"
And I set field "beldat" to "<beldat>"
And I set field "budat" to "<budat>"
And I set field "term" to "<term>"
And I create a new row at the end of the table
And I set field "konto" to "<konto>" in row 1
And I set field "ewsbetr" to "<ewsbetr>" in row 1
And I set field "ewhbetr" to "<ewhbetr>" in row 1
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor

Examples: Buchungen

| beleg|  beldat|   budat|    term|  konto|   ewsbetr|ewhbetr|
|KVBU23|07.01.95|07.01.95|07.01.95|1kauszkv|1234567.89|   0.00|
|KVBU23|08.05.95|08.05.95|08.05.95|1kauszkv|      0.00|  56.00|
|KVBU23|01.04.95|01.04.95|01.04.95|1kauszkv|    150.00|   7.36|
|KVBU23|01.08.95|01.08.95|01.08.95|1kauszkv|      0.00|1597.00|
|KVBU23|01.09.95|01.09.95|01.09.95|1kauszkv|    225.95|   0.00|

Scenario: default KV ausziffern und schliessen => Fehler

Given I open an editor "ausziffern" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "1kauszkv"
And I set field "kvneu" to "-"
And I set field "kvschl" to "ja"
# 'default'-Kontovorgänge dürfen nicht geschlossen werden.
#Then saving the current editor throws the exception "3234" 
# Vorgang abgebrochen 
Then saving the current editor throws the exception "2743"  
And I close the current editor

Scenario: Ausziffern und KV schliessen

Given I open an editor "ausziffernkvschl" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "1kauszkv" in row 0
And I press button "ladetab" in row 0
And I set field "kvneu" to "1kvausz" in row 0
And I set field "kvschl" to "ja" in row 0
And I set field "tmarke" to "ja" in row 1
And I set field "tmarke" to "ja" in row 2
And I set field "tmarke" to "ja" in row 3
And I save the current editor
And I close the current editor

Given I open an editor "kvpruefen" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "$,,such=S1KAUSZKV_1KVAUSZ;@richtung=rückwärts;@ablageart=beides;@maxordtreffer=1"
Then field "ablagef" has value "ja" in row 0
Then field "anzahlzeil" has value "3" in row 0
Then field "gdmgeschl" has value "05.10.95" in row 0
And I save the current editor
And I close the current editor

Scenario: Ausziffern ohne KV zu schliessen

Given I open an editor "ausziffernkvschl" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "1kauszkv" in row 0
And I press button "ladetab" in row 0
And I set field "kvneu" to "2kvausz" in row 0
And I set field "kvschl" to "nein" in row 0
And I set field "tmarke" to "ja" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "kvpruefen" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "S1KAUSZKV_2KVAUSZ"
Then field "ablagef" has value "nein" in row 0
Then field "anzahlzeil" has value "1" in row 0
Then field "gdmgeschl" has value "" in row 0
And I save the current editor
And I close the current editor

Scenario: default KV ausziffern aber nicht schliessen

Given I open an editor "ausziffern" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "1kauszkv" in row 0
And I press button "ladetab" in row 0
And I set field "kvneu" to "-" in row 0
And I set field "kvschl" to "nein" in row 0
And I set field "tmarke" to "ja" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "kvpruefen" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for search criteria "$,,such=S1KAUSZKV_-;@richtung=rückwärts;@ablageart=beides;@maxordtreffer=1"
Then field "ablagef" has value "nein" in row 0
#Then field "anzahlzeil" has value "1" in row 0
Then field "gdmgeschl" has value "" in row 0
And I save the current editor
And I close the current editor
