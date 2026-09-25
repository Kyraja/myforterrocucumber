@persistent
Feature: CEPI_Sperrmodus_Gesperrt_BASISARTIKEL.feature

Background:
And I set the fake date to "07.01.1995"

# **********************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_BASISARTIKEL.feature
#  Autor            : bschiga
#  Verantwortlich   : drpf
#  Kontrolle        : bschiga
#  Funktion         : Testet Basisartikel mit Sperrkonfiguration
#  ref              : 
#  Stammdaten       : CEPI_Stammdaten.feature
#
# **********************************************************************************

Scenario: Sperrkonfiguration mit Verweissperrstelle fuer Fertigungsliste anlegen

# Given I open an editor "Verweissperrstelle" from table "(LockConfiguration):(LockableReferences)" with command "STORE" for record "BASEPROD-PRODLIST-LOCK"
# And I set fields
#     | such              | BASEPROD-PRODLIST-LOCK                        |
#     | namebspr          | Basisartikel in Fertigungsliste mit Sperre    |
#     | gesperrtegruppe   | V-02-09                                       |
# And I delete all rows
# And I append rows
#     | verweisfeldingruppe | verweisfeldintabelle  | verweisfeldname   |
#     | V-02-01             | ja                    | tbasisartikel     |
# And I save the current editor
#
# Given I open an editor "Sperrkonfiguration" from table "(LockConfiguration):(LockConfiguration)" with command "STORE" for record "BASEPRODLOCK"
# And I set fields
#     | such              | BASEPRODLOCK                  |
#     | namebspr          | Standard-Basisartikelsperre   |
#     | gesperrtegruppe   | V-02-09                       |
#     | classname         | BaseproductStandardLock       |
#     | icontext          | icon:lock_red                 |
#     | hinweisbspr       | Artikel ist defekt            |
# And I delete all rows
# And I append rows
#     | verweissperrstellen     | prozesssperrstelle  | sperrwirkung    |
#     | BASEPROD-PRODLIST-LOCK  | !dontChange         | Gesperrt        |
#     | !dontChange             | PROD-BASEPROD       | Gesperrt        |
# And I save the current editor
#
# Given I open an editor "Aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "BASISARTSPERRE"
# And I set field "reosofort" to "ja"
# And I append rows
#     | aufzelem       | aebez                                    | aeaktiv  |
#     | BASEPRODLOCK   | Standard-Basisartikelsperre, Gesperrt    | ja       |
# And I save the current editor


Scenario: Basisartikel anlegen und sperren

# Basisartikel anlegen mit einer Version
Given I open an editor "BAS_SPERR" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
    | such     | BAS_SPERR           |
    | namebspr | Basisartikel Sperre |
And I append rows
    | tversion      | tindex | tstdvers |
    | EK-OHNESPERRE | S01    | ja       |
And I save the current editor

# Basisartikel sperren
Given I open an editor "BAS_SPERR" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_SPERR"
And I set fields
    | sperrkonfigurationneu | Standard-Basisartikelsperre |
And I save the current editor


Scenario: Ein gesperrter Basisartikel mit Verweissperrstelle Fertigungsliste, kann nicht in die Fertigungsliste eines Artikels eingetragen werden

Given I open an editor "V2" from table "(Part):(Product)" with command "UPDATE" for record "V2"
And I create a new row at the end of the table
Then setting field "tbasisartikel" to "BAS_SPERR" in row !lastRow throws the exception "1361"
And I close the current editor
## Meldung abfragen geht aktuell nicht, ACK anstatt NAK
## [Acceptance Tests:1] recv: E|2|10061 BAS_SPERR Basisartikel Sperre\nBasisartikel ist mit "Standard-Basisartikelsperre" gesperrt.\n\nHinweis: Artikel ist defekt\n\nObjekt ist gesperrt.|ERROR||6|tbasisartikel||!6|


Scenario: Ein mit Hinweis gesperrter Basisartikel mit Verweissperrstelle Fertigungsliste, kann in die Fertigungsliste eines Artikels eingetragen werden

# Basisartikel mit Hinweis sperren
Given I open an editor "BAS_SPERR" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_SPERR"
And I set fields
    | sperrkonfigurationneu | Standard-Basisartikelsperre, nur Hinweis |
And I save the current editor

Given I open an editor "V2" from table "(Part):(Product)" with command "UPDATE" for record "V2"
And I create a new row at the end of the table
## die Meldung kann aktuell nicht abgefragt werden
## And I respond with answer "ja" to the dialog with id "10061"
And I set field "tbasisartikel" to "BAS_SPERR" in row !lastRow
And I save the current editor
Then field "tbasisartikel" has value "BAS_SPERR" in row !lastRow


Scenario: Prozesssperrstelle - Zu einem gesperrtem Basisartikel koennen keine neuen Versionen zugefuegt werden

# Basisartikel sperren
Given I open an editor "BAS_SPERR" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_SPERR"
And I set fields
    | sperrkonfigurationneu | Standard-Basisartikelsperre |
And I save the current editor

# Sperre des Basisartikels hat keine Auswirkung auf die bereits zugeordnete Version, diese wird nicht gesperrt
Given I open an editor "EK-OHNESPERRE" from table "(Part):(Product)" with command "VIEW" for record "EK-OHNESPERRE"
Then field "basisartikel" has value "BAS_SPERR"
Then field "sperrkonfigurationneu" is empty
And I close the current editor

# der gesperrte Basisartikel kann keinem Artikel neu zugewiesen werden
Given I open an editor "EINK" from table "(Part):(Product)" with command "UPDATE" for record "EINK"
# 4844 de      |Neue Version kann zu einem gesperrten Basisartikel nicht zugefügt werden.
Then setting field "basisartikel" to "BAS_SPERR" throws the exception "4844"
Then field "basisartikel" is empty
And I save the current editor

# zu einem gesperrten Basisartikel kann keine neue Version angelegt werden
Given I open an editor "EK-OHNESPERRE" from table "(Part):(Product)" with command "UPDATE" for record "EK-OHNESPERRE"
Then field "basisartikel" has value "BAS_SPERR"
# 4844 de      |Neue Version kann zu einem gesperrten Basisartikel nicht zugefügt werden.
Then pressing button "neuevers" throws the exception "4844"
And I close the current editor

# bei einem gesperrten Basisartikel kann keine neue Version eingefuegt werden
Given I open an editor "BAS_SPERR" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BAS_SPERR"
# 4844 de      |Neue Version kann zu einem gesperrten Basisartikel nicht zugefügt werden.
And I create a new row at the end of the table
Then setting field "tversion" to "V2" in row !lastRow throws the exception "4844"
And I close the current editor

# zu einem gesperrten Basisartikel kann keine neue Version angelegt werden, kopieren ist moeglich, gesperrter Basisartikel muss entfernt werden
Given I open an editor "EK-OHNESPERRE" from table "(Part):(Product)" with command "COPY" for record "EK-OHNESPERRE"
Then field "basisartikel" has value "BAS_SPERR"
    And I set field "such" to "EK-OSPERR"
# 4844 de      |Neue Version kann zu einem gesperrten Basisartikel nicht zugefügt werden.
Then saving the current editor throws the exception "4844"
And I set field "basisartikel" to ""
And I save the current editor
