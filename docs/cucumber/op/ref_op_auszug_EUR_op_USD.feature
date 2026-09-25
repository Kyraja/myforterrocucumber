# *****************************************************************************
#  Name             : ref_op_auszug_EUR_op_USD.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Bankkontoauszug in Inlandswährung (EUR), OP in Fremdwährung (USD)
#  ref              : ref_op_auszug_EUR_op_USD_cu
# *******************************************************************************
@persistent
Feature: Bankimport, Bankkontoauszug in Inlandswährung (EUR), OP in Fremdwährung (USD)

Background:
Given I set the fake date to "30.04.2022"

# ---------------------------------------------------------------------------------------------
Scenario Outline: Kunden erfassen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "NEW" for record ""
And I set fields
  |nummer|<nummer>|
  |such  |<such>  |
  |staat |<staat> |
  |waehr |<waehr> |
  |zbed  |<zbed>  |
And I save the current editor

Examples:
|nummer|such  |staat|waehr|zbed|
|1KUUSD|KUUSD1|USA  |USD  |200 |

# ---------------------------------------------------------------------------------------------
Scenario Outline: Kurse erfassen
# ---------------------------------------------------------------------------------------------
Given I open an editor "<editor>" from table "(ExchangeRate)::(ExchangeRate)" with command "NEW" for record ""
And I set fields
  |kursdat  |<kursdat>   |
  |fwaehr   |<fwaehr>    |
  |faktieinh|<faktieinh> |
  |fkurs    |<fkurs>     |
Then fields have values
  |faktfeinh|<faktfeinh1>|
  |ikurs    |<ikurs1>    |
And I set fields
  |faktfeinh|<faktfeinh2>|
Then fields have values
  |ikurs    |<ikurs2>    |
And I set fields
  |faktfeinh|<faktfeinh> |
Then fields have values
  |ikurs    |<ikurs>     |
And I save the current editor

Examples:
  |editor        |kursdat   |faktieinh|fkurs   |fwaehr|faktfeinh1|ikurs1  |iwaehr|faktfeinh2|ikurs2       |faktfeinh|ikurs   |
  |USD-01.03.2022|01.03.2022|1        |1.390139|USD   |1         |0.719353|EUR   |1000000   |719352.525179|1        |0.719353|
  |USD-01.04.2022|01.04.2022|1        |1.391000|USD   |1         |0.718907|EUR   |1000000   |718907.260963|1        |0.718907|
  |USD-30.04.2022|30.04.2022|1        |1.392200|USD   |1         |0.718288|EUR   |1000000   |718287.602356|1        |0.718288|

# ---------------------------------------------------------------------------------------------
Scenario Outline: OPs erzeugen (Buchung neu)
# ---------------------------------------------------------------------------------------------

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set fields
  |beleg   |<beleg>   |
  |beldat  |<beldat>  |
  |budat   |<budat>   |
  |erfwaehr|<erfwaehr>|
And I append rows
  |konto   |kstelle    |ewsbetr   |ewhbetr   |
  |<1konto>|!dontChange|<1ewsbetr>|<1ewhbetr>|
  |<2konto>|<2kstelle> |<2ewsbetr>|<2ewhbetr>|
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

Examples:
 |beleg   |beldat    |budat     |erfwaehr|1konto  |1ewsbetr |1ewhbetr   |2konto|2kstelle|2ewsbetr   |2ewhbetr   |
 |REKUUSD1|01.03.2022|01.03.2022|USD     |K 1KUUSD|360873.97|!dontChange|44000 |101     |!dontChange|!dontChange|

# ---------------------------------------------------------------------------------------------
Scenario: Bankkontoauszug 9 in Wartung an den Test anpassen
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "annette"

Given I open an editor "Bankkontoauszug9-aend1" from table "90:1" with command "UPDATE" for record "9"
And I set fields
  |asaldat  |01.04.2022|
  |esaldat  |01.04.2022|
And I modify table
  |!row|tbudat    |tvaldat   |
  |1   |01.04.2022|01.04.2022|
#
Then fields have values
  |status   |in Bearbeitung|
  |asaldat  |01.04.2022    |
  |asalwaehr|EUR           |
  |esaldat  |01.04.2022    |
  |esalwaehr|EUR           |
  |bkonto   |              |
Then table has values
  |!row|tbudat    |tzabuchart|tbubetr  |twaehr|toffen   |tkonto |opanzahl|
  |1   |01.04.2022|Gutschrift|259595.60|EUR   |259595.60|       |0       |
And I save the current editor

Given I'm logged in with password "sy"

# ---------------------------------------------------------------------------------------------
Scenario: Zuordnungskonfiguration (ZVKonfig) an Test anpassen
#
# Minimale Zuordnungskonfiguration, Test betrifft manuelle Zuordnung
# ---------------------------------------------------------------------------------------------
Given I open an editor "ZK" from table "66:10" with command "NEW" for record ""
And I set fields
|such         |ZKGut     |
|zabuchart|Gutschrift|
|zkkunde       |ja        |
|zkauftr      |MUSS      |
And I save the current editor
And I close the current editor

Given I open an editor "ZK" from table "66:10" with command "NEW" for record ""
And I set fields
|such         |ZKBel    |
|zabuchart|Belastung|
|zklieferant        |ja       |
|zkauftr       |MUSS     |
And I save the current editor
And I close the current editor

Given I open an editor "ZVKonfig" from table "66:1" with command "UPDATE" for record "1"
And I set fields
|zuordkgutschrift|ZKGut|
|zuordkbelastung |ZKBel|
And I save the current editor
And I close the current editor
  

# ---------------------------------------------------------------------------------------------
# Scenario: Bankkontoauszug 9 bearbeiten, OP in USD manuell zuordnen
# ---------------------------------------------------------------------------------------------
Given I open an editor "Bankkontoauszug9-aend2" from table "90:1" with command "UPDATE" for record "9"
#
# Zuordnen, Ergebnis Prüfen 
And I press button "bauto" to open a subeditor for "Zuordnen"
And I save the current subeditor to switch back to the parent editor
Then table has values
  |!row|tbudat    |tbubetr  |twaehr|toffen   |tkonto |opanzahl|
  |1   |01.04.2022|259595.60|EUR   |259595.60|       |0       |
#
# In die manuelle Zuordnung in der ersten Zeile wechseln
And I press button "tmanuell" to open a subeditor for "Manuelle Zuordnung" in row 1
# Manuelle Zuordnung: OP laden
And I set fields
  |selkonto |K 1KUUSD|
  |sbeleg   |REKUUSD1|
And I press button "bladen"
Then table has values
  |!row|zmarke|tkonto  |tbeleg  |twaehr|trebetr  |opskrebetr|tzabetr|tsksatz|tskbetr|treoffen |tiwbu|budm|skdm|ezkurs  |
  |1   |nein  |K 1KUUSD|REKUUSD1|EUR   |259434.92|259434.92 |0.00   |0      |0.00   |259434.92|EUR  |0.00|0.00|1.000000|
Then fields have values
  |konto  |         |
  |sbubetr|259595.60|
  |szabetr|     0.00|
  |soffen |259595.60|
# Manuelle Zuordnung: OP zuordnen
And I set field "zmarke" to "ja" in row 1
Then table has values
  |!row|zmarke|tkonto  |tbeleg  |twaehr|trebetr  |opskrebetr|tzabetr  |tsksatz|tskbetr|treoffen|tiwbu|budm     |skdm|ezkurs  |
  |1   |ja    |K 1KUUSD|REKUUSD1|EUR   |259434.92|259434.92 |259434.92|0      |0.00   |0.00    |EUR  |259434.92|0.00|1.000000|
Then fields have values
  |konto  |K 1KUUSD |
  |sbubetr|259595.60|
  |szabetr|259434.92|
  |soffen |   160.68|
# Manuelle Zuordnung: den Restbetrag ausschliessen
And I set field "ausschl" to "ja"
And I save the current subeditor to switch back to the parent editor
# Werte in Bankkontoauszug 9 nach der Zuordnung prüfen
#
# Bankkontoauszug 9 bestätigen
And I set fields
  |bkonto|18100|
And I press button "bok" to open a subeditor for "Bestätigen"
And I save the current subeditor to switch back to the parent editor
Then fields have values
  |status|bestätigt|
#
# Bankkontoauszug 9 buchen, Submaske "Offene Posten ausbuchen"
And I press button "opausbuch" to open a subeditor for "Offene Posten ausbuchen"
# Vorbelegung der Daten beim Öffnen der Maske aus Bankkontoauszug
Then fields have values
  |gkonto    |18100     |
  |beleg     |27-1      |
  |beldat    |01.04.22  |
  |kbudat    |01.04.22  |
  |kiwbu     |EUR       | 
  |kwaehr    |EUR       |
  |kkonto    |K 1KUUSD  |
  |suzabetr  | 259434.92|
  |kozabetr  | 259434.92|
  |koskbetr  |      0.00|
  |kokursdiff|    160.68|
  |kozrebetr |      0.00|
  |koasaldo  | 259595.60|
  |konsaldo  |      0.00|
Then table has values
  |!row|opneu|konto   |tbeleg  |vom     |rebetr   |redm     |sha  |kkurs   |feinh|waehr|ekkurs  |iwbu|
  |1   |nein |K 1KUUSD|REKUUSD1|01.03.22|360873.97|259595.60|Haben|0.719353|1    |USD  |0.719353|EUR |
Then table has values
  |!row|rezakurs|opzaiwkurs|zkurs   |feinh|waehr|eopzaiwkurs|ziwbu|eweinh|twaehr|ezkurs  |kursfix|
  |1   |0.718907|0.718907  |1.000000|1    |USD  |0.718907   |EUR  |1     |EUR   |1.000000|ja     |
Then table has values
  |!row|zarebetr |iwredm   |sha  |opzabetr |budm     |skbetr|skdm|kursdiff|ofbetr |
  |1   |259434.92|259595.60|Haben|259434.92|259434.92|0.00  |0.00|160.68  |0.00   |
Then table has values
  |!row|zrebetr |zredm |zsh  |kkurs   |feinh|waehr|ekkurs  |iwbu|
  |1   |0.00    |  0.00|Haben|0.719353|1    |USD  |0.719353|EUR |
#
Then field "eopzaiwkurs" is modifiable in row 1
Then field "ezkurs" is not modifiable in row 1
Then field "kursfix" is modifiable in row 1
#
# Test: eopzaiwkurs mit dem OP-Kurs (ekkurs) vorbelegen (mit den ersichtlichen 6 Nachkommastellen)
#       ==> Kursfixierung wird aktiviert
#       ==> Beträge in Buchungswährung incl. Kursdifferenz werden aktualisiert
#       ==> Kleine Kursdifferenz, weil eopzaiwkurs <> ekkurs, in ekkurs sind mehr als 6 Nachkommastellen vorbelegt
#       Dann die Kursfixierung deaktivieren
#       ==> eopzaiwkurs wird zum Buchungsdatum ermittelt und vorbelegt.
#           Gleich dem Kurs, wie beim Öffnen der Ausbuchungsmaske.
#       ==> Beträge in Buchungswährung incl. Kursdifferenz werden aktualisiert.
#           Gleich dem Stand, wie beim Öffnen der Ausbuchungsmaske.
#
And I modify table
  |!row|eopzaiwkurs|
  |1   |0.719353   |
Then table has values
  |!row|kursfix|zarebetr |iwredm   |sha  |opzabetr |budm     |skbetr|skdm|kursdiff|ofbetr |
  |1   |ja     |259595.77|259595.60|Haben|259434.92|259434.92|0.00  |0.00|-0.17   |160.85 |
#
And I modify table
  |!row|kursfix|
  |1   |nein   |
Then table has values
  |!row|kursfix|zarebetr |iwredm   |sha  |opzabetr |budm     |skbetr|skdm|kursdiff|ofbetr |
  |1   |nein   |259434.92|259595.60|Haben|259434.92|259434.92|0.00  |0.00|160.68  |0.00   |
#
#
And I respond with answer "Ja" to the dialog with id "588"
And I save the current subeditor to switch back to the parent editor

And I save the current editor
