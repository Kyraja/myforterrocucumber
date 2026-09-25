@persistent
Feature: storno_rm_neu.feature

  Background:
    And I set the fake date to "10.02.1995"

# *****************************************************************************
#  Name             : storno_rm_neu
#  Autor            : amk
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Tested den Storno von Rückmeldungen ohne FV
#  Jira-Issue       : FDA-2110
# *****************************************************************************


  Scenario: P01 Rückmeldung ohne FV erzeugen und anschliessend stornieren

# Rückmeldung <Neu> erfassen
    Given I open an editor "RMneu" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    Then field "typa279" has value "Rückmeldung ohne Fertigungsvorschlag"
    And I set fields
      | barmex  | 123         |
      | such    | RMohneFV    |
      | artikel | B_BAUGRUPPE |
      | mgr     | 101         |
      | kstelle | 101         |
      | lgr     | 1           |
      | mzeit   | 3           |
      | bzeit   | 3           |
    And I append rows
      | artikel    | mge | gutmge | verlustmge | namge | kompeig       |
      | EINKAUF-1  | 1   | 2      | 3          | 4     |               |
      | KOPPELPROD | 11  | 22     | 33         | 44    | Koppelprodukt |
    And I save the current editor

# Rückmeldung <Neu> stornieren
    Given I open an editor "RMneuStorno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RMneu"
    Then field "typa279" has value "Storno-Rückmeldung ohne Fertigungsvorschlag"
    And I set field "bem" to "Storno RMneu"
    And I save the current editor

# Rückmeldung <Neu> prüfen
    Given I open an editor "RMneuPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record from editor "RMneu"
    Then field "typa279" has value "Stornierte Rückmeldung ohne Fertigungsvorschlag"
    And I close the current editor

# LJ Einträge prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | 123       |
      | richtung | rückwärts |
    And I press start
    Then table has values
      | art        | detursache                                | zmge | amge |
      | KOPPELPROD | Storno-Fertigung ohne Fertigungsvorschlag | -11  |      |
      | EINKAUF-1  | Storno-Fertigung ohne Fertigungsvorschlag |      | -1   |
      | EINKAUF-1  | Fertigung ohne Fertigungsvorschlag        |      | 1    |
      | KOPPELPROD | Fertigung ohne Fertigungsvorschlag        | 11   |      |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 3


  Scenario: P02 Eine Storno- bzw. Stornierte Rückmeldung ohne FV darf nicht kopiert werden

# Storno-Rückmeldung (aus Scenario P01) kopieren ist nicht erlaubt
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=RMohneFV;typa279=Storno-Rückmeldung ohne Fertigungsvorschlag;@gruppe=2;@ablage=abgelegt;@maxordtreffer=1" throws the exception "1647"

# Stornierte Rückmeldung (aus Scenario P01) kopieren ist nicht erlaubt
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=RMohneFV;typa279=Stornierte Rückmeldung ohne Fertigungsvorschlag;@gruppe=2;@ablage=abgelegt;@maxordtreffer=1" throws the exception "1647"

