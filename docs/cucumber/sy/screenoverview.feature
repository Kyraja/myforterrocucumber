@persistent
Feature: screenoverview.feature
# Test des Infosystems sy/SCREENOVERVIEW
Scenario: 1 Testen der FOPs fuer sy/SCREENOVERVIEW
################################################################################
#01 Testen der FOPs fuer sy/EXPLORER 
Given I'm logged in with password "adm"
Given I open the infosystem "SCREENOVERVIEW"
And I set field "infosystem" to "SCREENOVERVIEW"
And I press start
Then the table has 24 rows
Then table has values
    | unterprogramme      | objekt            | event           | var              | beschreibung                              | oeffnen         |
    |                     |                   |                 |                  | Vartab vom Infosystem SCREENOVERVIEW     |                 |
    |                     | Variablentabelle  |                 |                  |                                           | icon:view       |
    |                     |                   |                 |                  | Aktive Programme                          |                 |
    | icon:folder_closed  | FOP               | Maskeneintritt  |                  |  sy/SCREENOVERVIEW.SE                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Buttonnach      | isbstart         |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Feldaustritt    | isinfosystem     |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Feldaustritt    | isapgruppennr    |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Feldaustritt    | isgruppennr      |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Feldaustritt    | isapdatenbank    |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Feldaustritt    | isdatenbank      |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Feldaustritt    | ismasknr         |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Feldaustritt    | isvariable       |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Buttonnach      | isoeffnen        |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Buttonnach      | isunterprogramme |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    | icon:folder_closed  | FOP               | Buttonnach      | isttreffer       |  sy/SCREENOVERVIEW.EV                     | icon:text_edit  |
    |                     |                   |                 | buaktion         | Kopf: Individuelle Aufrufparameterliste   | icon:view       |
    |                     |                   |                 | buaktion         | Kopf: Standard-Aufrufparameterliste       | icon:view       |
    |                     |                   |                 | buinfosys        | Kopf: Individuelle Aufrufparameterliste   | icon:view       |
    |                     |                   |                 | buinfosys        | Kopf: Standard-Aufrufparameterliste       | icon:view       |
    |                     |                   |                 | buaktion         | Tabelle: Individuelle Aufrufparameterliste| icon:view       |
    |                     |                   |                 | buaktion         | Tabelle: Standard-Aufrufparameterliste    | icon:view       |
    |                     |                   |                 | buinfosys        | Tabelle: Individuelle Aufrufparameterliste| icon:view       |
    |                     |                   |                 | buinfosys        | Tabelle: Standard-Aufrufparameterliste    | icon:view       |
    |                     |                   |                 |                  | Drucklayout                               |                 |
And I close the current editor










