@persistent
Feature: Gueltigkeitsverhalten im Infosystem EKLAB pruefen

Scenario: Infosystem EKLAB bedienen, Komplikation Rahmenauftragsposition mit Guelttigkeiten, EDI-Datei erfolgreich erstellen

#Infosystem EKLAB nur Artikel EKLABART1
Given I open the infosystem "EKLAB"
And I set field "kartikel" to "EKLABART1" 
And I press button "bstart"
Then the table has 7 rows
And I press button "kbudispo"
And I press button "kbuvorschlag"
And the table has 11 rows
And table has values
    | ttyp             | tmge  | tbgltstatus |
    | Lieferant        |     0 | nein        |
    | Rahmenposition   | 10000 | ja          |
    | Bestellvorschlag |    60 | ja          |
    | Bestellvorschlag |    75 | ja          |
    | Bestellvorschlag |    50 | ja          |
    | Bestellvorschlag |    80 | ja          |
    | Rahmenposition   | 10000 | nein        |
    | Rahmenposition   |   400 | nein        |
    | Rahmenposition   | 10000 | nein        |
    | Rahmenposition   | 10000 | nein        |
    | Rahmenposition   |   400 | nein        |
And I press button "kbuauto"
And the table has 11 rows
And table has values
    | ttyp           | tmge  | tbgltstatus |
    | Lieferant      |     0 | nein        |
    | Rahmenposition | 10000 | ja          |
    | Lieferabruf    |    60 | ja          |
    | Lieferabruf    |    75 | ja          |
    | Lieferabruf    |    50 | ja          |
    | Lieferabruf    |    80 | ja          |
    | Rahmenposition | 10000 | nein        |
    | Rahmenposition |   400 | nein        |
    | Rahmenposition | 10000 | nein        |
    | Rahmenposition | 10000 | nein        |
    | Rahmenposition |   400 | nein        |
And I press button "kbuexport"
And the table has 11 rows
And table has values
    | ttyp           | tstatus         |
    | Lieferant      |                 |
    | Rahmenposition |                 |
    | Lieferabruf    | icon:ball_green |
    | Lieferabruf    | icon:ball_green |
    | Lieferabruf    | icon:ball_green |
    | Lieferabruf    | icon:ball_green |
    | Rahmenposition |                 |
    | Rahmenposition |                 |
    | Rahmenposition |                 |
    | Rahmenposition |                 |
    | Rahmenposition |                 |
And I close the current editor
