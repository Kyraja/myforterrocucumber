@persistent
Feature: schedoverview_dispostatus.feature

Background:
And I set the fake date to "07.01.95"

# **********************************************************************************
#  Name             : schedoverview_dispostatus.feature
#  Autor            : bschiga
#  Verantwortlich   : bschiga
#  Kontrolle        : cl
#  Funktion         : Testet Dispositionsstatus im IS SCHEDOVERVIEW
#  ref              : ref_la_schedoverview_dispostatus_cu
#
# **********************************************************************************
# Vorgaenger ref_la.SCHEDOVERVIEW

Scenario: 01 Sicht Dispositionsstatus - alle Warteschlangen anzeigen

And I open the infosystem "SCHEDOVERVIEW"
And I set field "offenewseintraege" to "ja"
Then field "letztedispolaeufe" has value "nein"
And I press start
Then field "dispolaeuft" has value "nein"
Then the table has 11 rows
Then table has values
    | tnummerwarteschlange  | twarteschlangebez                     | tanzahleintraege  |
    | 4                     | Nachkalkulationswarteschlange         | 0                 |
    | 6                     | Dispowarteschlange Einkauf            | 0                 |
    | 7                     | Dispowarteschlange Verkauf            | 0                 |
    | 8                     | Dispowarteschlange Aufschubvermerke   | 0                 |
    | 9                     | Dispowarteschlange Teile              | 12                |
    | 10                    | Dispowarteschlange Kapazitäten        | 0                 |
    | 11                    | Dispofehlerwarteschlange              | 0                 |
    | 12                    | Dispowarteschlange Kalenderänderung   | 1                 |
    | 13                    | Dispowarteschlange Reparatur          | 0                 |
    | 14                    | Disposition Stammdatenvererbung       | 0                 |
    | 15                    | Disposition Stammdatenvererbung       | 0                 |
And I close the current editor


Scenario: 02 Sicht Dispositionsstatus - eine Warteschlange anzeigen und Plausis

And I open the infosystem "SCHEDOVERVIEW"
And I set field "warteschlange" to "4"
Then field "offenewseintraege" has value "ja"
Then field "letztedispolaeufe" has value "nein"
Then the table has 1 rows
Then table has values
    | tnummerwarteschlange  | twarteschlangebez                     | tanzahleintraege  |
    | 4                     | Nachkalkulationswarteschlange         | 0                 |
And I set field "warteschlange" to "9"
Then field "offenewseintraege" has value "ja"
Then field "letztedispolaeufe" has value "nein"
Then table has values
    | 9                     | Dispowarteschlange Teile              | 12                |
And I set field "warteschlange" to ""
Then field "offenewseintraege" has value "ja"
Then field "letztedispolaeufe" has value "nein"
And I set field "warteschlange" to "10"
Then the table has 1 rows
Then field "offenewseintraege" has value "ja"
Then field "letztedispolaeufe" has value "nein"
And I set field "letztedispolaeufe" to "ja"
Then field "offenewseintraege" has value "nein"
Then the table has more than 1 rows
And I set field "offenewseintraege" to "ja"
And I set field "maxanz" to "50"
Then field "letztedispolaeufe" has value "ja"
Then field "offenewseintraege" has value "nein"
And I set field "offenewseintraege" to "ja"
And I set field "dlauf" to "07.01.95"
Then field "letztedispolaeufe" has value "ja"
Then field "offenewseintraege" has value "nein"
And I set field "offenewseintraege" to "ja"
And I set field "bzeichen" to "SY"
Then field "letztedispolaeufe" has value "ja"
Then field "offenewseintraege" has value "nein"
And I set field "offenewseintraege" to "ja"
And I set field "kmeldetext" to "Disposition mit unerwartetem Ende"
Then field "letztedispolaeufe" has value "ja"
Then field "offenewseintraege" has value "nein"
And I set field "bzeichen" to "SY"
And I set field "offenewseintraege" to "ja"
Then field "bzeichen" has value ""
And I set field "maxanz" to "50"
And I set field "offenewseintraege" to "ja"
Then field "maxanz" has value "100"
And I set field "warteschlange" to "7"
Then field "letztedispolaeufe" has value "nein"
Then field "offenewseintraege" has value "ja"
And I set field "kmeldetext" to "Disposition ist unvollständig abgeschlossen"
Then field "warteschlange" has value ""
Then field "letztedispolaeufe" has value "ja"
Then field "offenewseintraege" has value "nein"
And I close the current editor


Scenario: 03 Sicht Dispositionsstatus - Dispo starten ueber Button, Ergebnis in Tabelle pruefen

And I open the infosystem "SCHEDOVERVIEW"
And I set field "offenewseintraege" to "ja"
And I press button "bdispo" to open a subeditor for "Dispo"
And I close the current subeditor to switch back to the parent editor
And I press start
Then the table has 11 rows
Then table has values
    | tnummerwarteschlange  | twarteschlangebez                     | tanzahleintraege  |
    | 4                     | Nachkalkulationswarteschlange         | 0                 |
    | 6                     | Dispowarteschlange Einkauf            | 0                 |
    | 7                     | Dispowarteschlange Verkauf            | 0                 |
    | 8                     | Dispowarteschlange Aufschubvermerke   | 0                 |
    | 9                     | Dispowarteschlange Teile              | 0                 |
    | 10                    | Dispowarteschlange Kapazitäten        | 0                 |
    | 11                    | Dispofehlerwarteschlange              | 12                |
    | 12                    | Dispowarteschlange Kalenderänderung   | 0                 |
    | 13                    | Dispowarteschlange Reparatur          | 0                 |
    | 14                    | Disposition Stammdatenvererbung       | 0                 |
    | 15                    | Disposition Stammdatenvererbung       | 0                 |
And I close the current editor
