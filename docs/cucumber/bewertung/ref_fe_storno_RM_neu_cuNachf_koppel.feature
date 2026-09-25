#  Verantwortlich   : uo

@persistent
Feature: Bewertungen für uE-relevante Zugänge aus Rückmeldungen ohne FV (RM neu)

Background:
   And I set the fake date to "12.02.1995"


Scenario: uE Buchung auf fuer 50000er konto

Given I open an editor "Konto50000" from table "(Account):(Account)" with command "UPDATE" for record "50000"
And I set field "hkost" to "ja"
And I save the current editor


Scenario: S1 Rückmeldung ohne FV erzeugen hk-relevant mit KTR und anschliessend stornieren

# Rückmeldung <Neu> erfassen
    Given I open an editor "RMneu1" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    Then field "typa279" has value "Rückmeldung ohne Fertigungsvorschlag"
    And I set fields
      | barmex  | 123         |
      | such    | RMohneFVhk  |
      | artikel | B_BAUGRUPPE |
      | mgr     | 101         |
      | kstelle | 100000      |
      | lgr     | 2           |
      | mzeit   | 1           |
      | bzeit   | 2           |
    And I append rows
      | artikel    | mge | gutmge | verlustmge | namge | kompeig       |
      | EINKAUF-1  | 2   | 3      | 5          | 7     |               |
      | KOPPELPROD | 6   | 10     | 16         | 22    | Koppelprodukt |
    And I save the current editor

# Rückmeldung <Neu> stornieren
    Given I open an editor "RMneuStorno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RMneu1"
    Then field "typa279" has value "Storno-Rückmeldung ohne Fertigungsvorschlag"
    And I set field "bem" to "Storno RMneu1"
    And I save the current editor
