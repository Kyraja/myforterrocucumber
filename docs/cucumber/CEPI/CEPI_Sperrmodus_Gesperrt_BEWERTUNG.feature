@persistent
Feature: CEPI_Sperrmodus_Gesperrt_BEWERTUNG.feature


# *****************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_BEWERTUNG
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : bschiga
#  Jira-Issue       : FDA-1299
#  Funktion         : Testet die Neubewertung und Mengenneubewertung eines
#                     gesperrten Artikels 
#
# *****************************************************************************

  Scenario: 01 Neubewertung eines gesperrten Artikels möglich

    Given I open an editor "Neubewertung" for tip command "(SRevaluation)" and arguments ""
    And I set fields
      | artikel | EK-GESPERRT |
      | beleg   | 01          |
      | beldat  | .           |
    And I modify table
      | !row | mge | mmpr  |
      | 1    | 1   | 13,50 |
    And I save the current editor


  Scenario: 02 Mengenneubewertung eines Vorgangs mit gesperrtem Artikel möglich

# Switch-Artikel leere Sperre
    Given I open an editor "EK-SWITCH" from table "(Part):(Product)" with command "UPDATE" for record "EK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# EK-Lieferschein
    Given I open an editor "EK-Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lief   | FABER   |
      | ebeleg | VORGANG |
      | vom    | .       |
      | ueb    | ja      |
    And I append rows
      | artikel   | mge | ljtext1               |
      | EK-SWITCH | 10  | Switch-Artikel Sperre |
    And I save the current editor

# ID aus Lagerjournal
    Given I open an editor "Journaleintrag_LS" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,erbtext1=Switch-Artikel Sperre;@richtung=rückwärts;@maxordtreffer=1"
    Then field "vorgang^id" in row 0 has value equal to field "pos^id" from editor "EK-Lieferschein" in row 1
    And I close the current editor

# Switch-Artikel Sperre setzen
    And I switch the current editor to editor "EK-SWITCH" with command "UPDATE"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Mengenneubewertung
    Given I open an editor "Mengenneubewertung" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
    And I set field "such" to "BEW"
    And I set field "vorgang" in row 1 to "id" from editor "Journaleintrag_LS" in row 0
    And I set field "ntbewpr" to "16" in row 1
    And I save the current editor
