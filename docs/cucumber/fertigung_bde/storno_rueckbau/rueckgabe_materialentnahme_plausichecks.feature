@persistent
Feature: rueckgabe_materialentnahme_plausichecks.feature

  Background:
    And I set the fake date to "03.01.1995"


# *****************************************************************************
#  Name             : rueckgabe_materialentnahme_plausichecks
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet die Rückgabe von Material über die 
#                     Materialentnahme
#  Jira-Issue       : FDA-538
# *****************************************************************************

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-0" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

  Scenario: 01 Wird eine negative Menge eingegeben, wird die Fbuchung zur Rückgabe und es können in weitere Zeilen nur noch negative Werte eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch    | mfreig |
      | M_BAUGRUPPE | 10     | NEGRUECK_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=NEGRUECK_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-1" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Rückgabe zur Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=NEGRUECK_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bumge" to "-10" in row 1
    And I create a new row at the end of the table
# keine positiven Werte erlaubt
    And I set field "elex" to "EINKAUF-1" in row !lastRow
    And setting field "bumge" to "5" in row !lastRow throws the exception "1361"
    And I set field "elex" to "EINKAUF-2" in row !lastRow
    And setting field "bumge" to "5" in row !lastRow throws the exception "1361"
    And I set field "elex" to "EINKAUF-3" in row !lastRow
    And setting field "bumge" to "5" in row !lastRow throws the exception "1361"
# negative Mengen von bereits entnommenem Material
    And I set field "bumge" to "-1" in row 2
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-2" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NEGRUECK_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 02 Bei einer Materialentnahme können keine negativen Mengen eingegeben werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch  | mfreig |
      | M_BAUGRUPPE | 10     | MATENT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MATENT_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I create a new row at the end of the table
    And I set field "elex" to "EINKAUF-3" in row !lastRow
    And setting field "bumge" to "-5" in row !lastRow throws the exception "1361"
    And I close the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-3" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MATENT_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 03 Neuer Rest kann bei Materialentnahme und Rückgabe gesetzt werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch     | mfreig |
      | M_BAUGRUPPE | 10     | NEUERREST_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=NEUERREST_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-4" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Materialentnahme Rückgabe
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=NEUERREST_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I set field "gmgevorschl" to "-2"
    And I press button "stlvblad"
    And I modify table
      | !row | nlimge |
      | 1    | 10     |
      | 2    | 5      |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-5" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=NEUERREST_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "."
    And I set field "beleg" to "barmex" from editor "Rückgabe1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | detursache                 |
      | EINKAUF-1 | -4   | Materialrückgabe Fertigung |
      | EINKAUF-2 | -2   | Materialrückgabe Fertigung |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NEUERREST_000"
    Then field "mge" has value "10"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "5" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: 04 Materialentnahmen haben den Typ Rückmeldung Fertigung, Materialrückgaben Rückbau Fertigung
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch  | mfreig |
      | M_BAUGRUPPE | 10     | MATENT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MATENT_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-6" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Typ in Rückmeldung zur Materialentnahme prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MATENT_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Rückmeldung"
    And I close the current editor

# Materialentnahme Rückgabe
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MATENT_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I modify table
      | !row | bumge |
      | 1    | -10   |
      | 2    | -5    |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-7" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Typ in Rückmeldung zur Materialentnahme Rückgabe prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MATENT_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Rückbau auf Betriebsauftrag"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MATENT_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 05 Materialrückgaben erhöhen die offenen Mengen
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch  | mfreig |
      | M_BAUGRUPPE | 10     | MENGEN_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MENGEN_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-8" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Materialentnahme Rückgabe
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MENGEN_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I modify table
      | !row | bumge |
      | 1    | -10   |
      | 2    | -5    |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-9" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

    Given I open an editor "Rückmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MENGEN_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "."
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | detursache                 |
      | EINKAUF-1 | -10  | Materialrückgabe Fertigung |
      | EINKAUF-2 | -5   | Materialrückgabe Fertigung |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MENGEN_000"
    Then field "mge" has value "10"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "5" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-10" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."


  Scenario: 06 Retrograd entnommenes Material kann nur in individueller Menge und bei manbu=ja zurückgegeben werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | MENGEN_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-11" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MENGEN_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-12" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Materialentnahme Rückgabe
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MENGEN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I set field "gmgevorschl" to "-2"
    And I press button "stlvblad"
    And I modify table
      | !row | manbu | bumge |
      | 1    | ja    | -6    |
      | 2    | ja    | -2    |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-13" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MENGEN_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-14" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "."
    And I set field "beleg" to "barmex" from editor "Rückgabe1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | detursache                 |
      | EINKAUF-1 | -6   | Materialrückgabe Fertigung |
      | EINKAUF-2 | -2   | Materialrückgabe Fertigung |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MENGEN_000"
    Then field "mge" has value "5"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "16" in row 1
    Then field "limge" has value "7" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-15" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."


  Scenario: 07 Rückgabe von manuell entnommenen Material auf abgelegten FV erzeugt Rückmeldung typ=Rückbau zu abgelegtem Fertigungsvorschlag
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch          |
      | M_BAUGRUPPE | 10  | ja     | MRUECKABGELEGT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-16" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MRUECKABGELEGT_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-17" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Rückgabe von Material
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MRUECKABGELEGT_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-18" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."


  Scenario: 08 Bei Rückgabe auf abgelegten FV kann keine negative Zeit eingetragen werden
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch      |
      | BAUGRUPPE | 10  | ja     | NONEGATIVE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NONEGATIVE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-19" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Negative Arbeits- und/oder Maschinenzeit nicht erlaubt
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "lgr" to "1"
    Then setting field "bzeit" to "-3" throws the exception "11034"
    Then setting field "mzeit" to "-3" throws the exception "11034"
    And I close the current editor


  Scenario: 09 Bei Rückgabe von Material auf abgelegten FV kann keine positive Gutmenge eingetragen werden
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | NOGUTMGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NOGUTMGE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Positive Gutmenge bei negativer Menge des Materials nicht erlaubt
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "mge" to "3" in row 2
    And I set field "gutmge" to "-7" in row 1
    Then saving the current editor throws the exception "11121"
    And I close the current editor


  Scenario: 10 Bei Rückgabe von Material auf abgelegten FV kann keine positive Gutmenge eingetragen werden
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | NOMGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NOMGE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-20" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Negative Gutmenge ist bei positiver Menge des Materials nicht erlaubt
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "-7" in row 1
    And setting field "mge" to "5" in row 2 throws the exception "11121"
    And I close the current editor


# Es kann mehr zurückgebucht werden, als ursprünglich entnommen wurde
  Scenario: 11 Bei Rückgabe auf abgelegten FV kann nicht mehr Material zurückgegeben werden, als ursprünglich gebucht war
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | TOOMUCH_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=TOOMUCH_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TOOMUCH_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-21" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Mehr Material, als ursprünglich entnommen wurde, ist nicht erlaubt
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    Then setting field "mge" to "-500" in row 2 throws the exception "1395"
    Then setting field "mge" to "-500" in row 3 throws the exception "1395"
    And I close the current editor


  Scenario: 12 Zusätzliches Material auf einen abgelegten FV, das vorher nicht entnommen wurde, kann nicht zurückgegeben werden
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BAUGRUPPE | 10  | ja     | ZUSAZT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSAZT_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Material, das nie entnommen wurde, ist nicht erlaubt
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I modify table
      | !row | artikel   |
      | +2   | EINKAUF-3 |
    Then setting field "mge" to "-5" in row 2 throws the exception "1395"
    And I close the current editor


  Scenario: 13 Erbtext und Bemerkung werden in Rückbau zu abgelegtem FV Materialentnahme übernommen
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | ERBTEXT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=ERBTEXT_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ERBTEXT_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-22" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# Rückbau auf abgelegten FV
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=ERBTEXT_001;manrm=ja;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I modify table
      | !row | erbtext1  | mge |
      | 2    | EINKAUF-1 | -1  |
      | 3    | EINKAUF-2 | -1  |
    And I save the current editor

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-23" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | !row | erbtext1  |
      | 1    | EINKAUF-1 |
      | 2    | EINKAUF-2 |
    And I close the current editor


  Scenario: 14 Materialrückgabe auf abweichendem Platz verhindern, wenn der Original Abgangsplatz negativen Bestand hat
# Bestand B_EINKAUF-1 auf Null
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-B1"

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | bisuch   | mfreig |
      | B_BAUGRUPPE | 10  | NPLATZ1_ | ja     |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NPLATZ1_001"
    And I close the current editor

# Materialentnahme bucht für B_EINKAUF-1 negativen Bestand auf F1
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag   | !Arbeitsschein1^nummer |
      | autorment | ja                     |
    And I press button "stllad"
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel  | B_EINKAUF-1 |
      | klgruppe | KARLSRUHE   |
      | details  | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | gebmge | lplatz | lemge |
      |        | F1     | -20   |
      | -20    | F1     |       |
    And I close the current editor

# Rückgabe B_EINKAUF-1 auf Platz F2 bringt Fehler
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -10                    |
      | autorment   | ja                     |
    And I press button "stllad"
    And I set field "manbu" to "ja" in row 1
    And I set field "buplatz" to "F2" in row 1
    Then saving the current editor throws the exception "2037"
    And I close the current editor

# FV abschließen und negativen Bestand ausgleichen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NPLATZ1_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: 15 Materialrückgabe auf abweichendem Platz verhindern, wenn der Original Abgangsplatz negativen Bestand hat (2 Plaetze)
# Bestand B_EINKAUF-1 auf Null
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-B1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-B1"

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | bisuch   | mfreig |
      | B_BAUGRUPPE | 10  | NPLATZ2_ | ja     |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NPLATZ2_001"
    And I close the current editor

# Materialentnahme bucht für B_EINKAUF-1 negativen Bestand auf F1
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag   | !Arbeitsschein1^nummer |
      | autorment | ja                     |
    And I press button "stllad"
    And I set field "manbu" to "ja" in row 1
    And I set field "bumge" to "5" in row 1
    And I set field "buplatz" to "F1" in row 1
    And I save the current editor

# Materialentnahme bucht für B_EINKAUF-1 negativen Bestand auf F2
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag   | !Arbeitsschein1^nummer |
      | autorment | ja                     |
    And I press button "stllad"
    And I set field "bumge" to "2" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel  | B_EINKAUF-1 |
      | klgruppe | KARLSRUHE   |
      | details  | nein        |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | gebmge | lplatz | lemge |
      |        | F1     | -5    |
      | -5     | F1     |       |
      |        | F2     | -2    |
      | -2     | F2     |       |
    And I close the current editor

# Rückgabe B_EINKAUF-1 auf Platz F2 bringt Fehler, da mehr als zurückgegeben wird wie auf F2 negativ liegt und daher F1 beruecksichtigt wird.
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -4                     |
      | autorment   | ja                     |
    And I press button "stllad"
    And I set field "buplatz" to "F2" in row 1
    Then saving the current editor throws the exception "2037"
    And I close the current editor

# FV abschließen und negativen Bestand ausgleichen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NPLATZ2_001"
    And I set fields
      | gut     | ja |
      | sofort  | ja |
      | manrest | ja |
    And I save the current editor


  Scenario: 16 Materialrückgabe auf abweichendem Platz verhindern, wenn der Original Abgangsplatz negativen Bestand hat mit MZ-Rueckgabe (erzeugen)
# Bestand B_EINKAUF-1 auf Null
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-B1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-B1"

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | bisuch   | mfreig |
      | B_BAUGRUPPE | 10  | NPLATZ3_ | ja     |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NPLATZ3_001"
    And I close the current editor

# Materialentnahme bucht für B_EINKAUF-1 negativen Bestand auf F1
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag   | !Arbeitsschein1^nummer |
      | autorment | ja                     |
    And I press button "stllad"
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel  | B_EINKAUF-1 |
      | klgruppe | KARLSRUHE   |
      | details  | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | gebmge | lplatz | lemge |
      |        | F1     | -20   |
      | -20    | F1     |       |
    And I close the current editor

# Rückgabe B_EINKAUF-1 auf Platz F2 bringt Fehler nach Erzeugen der MZ und ändern des Platzes
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -10                    |
      | autorment   | ja                     |
    And I press button "stllad"
    And I set field "manbu" to "ja" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    Then the table has 1 rows
    And I press button "burueckmzerg"
    Then the table has 2 rows
    And I set field "lpsuch" to "F2" in row 1
    And setting field "lpsuch" to "F2" in row 2 throws the exception "2037"
    And I close the current editor
    And I switch the current editor to editor "Materialentnahme1"
    And I close the current editor

# FV abschließen und negativen Bestand ausgleichen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NPLATZ3_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


  Scenario: 17 Materialrückgabe auf abweichendem Platz verhindern, wenn der Original Abgangsplatz negativen Bestand hat mit MZ_rueckgabe (zuordnen)
# Bestand B_EINKAUF-1 auf Null
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-B1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-B1"

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | bisuch   | mfreig |
      | B_BAUGRUPPE | 10  | NPLATZ4_ | ja     |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NPLATZ4_001"
    And I close the current editor

# Materialentnahme bucht für B_EINKAUF-1 negativen Bestand auf F1
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag   | !Arbeitsschein1^nummer |
      | autorment | ja                     |
    And I press button "stllad"
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel  | B_EINKAUF-1 |
      | klgruppe | KARLSRUHE   |
      | nullmge  | nein        |
      | details  | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | gebmge | lplatz | lemge |
      |        | F1     | -20   |
      | -20    | F1     |       |
    And I close the current editor

# Rückgabe B_EINKAUF-1 auf Platz F2 bringt Fehler
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -10                    |
      | autorment   | ja                     |
    And I press button "stllad"
    And I set field "manbu" to "ja" in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I set field "lpsuch" to "F2" in row 1
    #And I press button "burueckmzzuord"
    And pressing button "burueckmzzuord" throws the exception "2037"
    And I close the current editor
    And I switch the current editor to editor "Materialentnahme1"
    And I close the current editor

# FV abschließen und negativen Bestand ausgleichen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NPLATZ4_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

  Scenario: 18 Materialrückgabe auf abweichendem Platz verhindern, wenn der Original Abgangsplatz unbewerteten Bestand hat
# Bestand B_EINKAUF-1 auf Null
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-B1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-B1"

# Lagerbuchungen Bestand von nichts auf F1 auf F2 umbuchen, so dass F2 10 Bestand hat, aber unbewertet.
    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | B_EINKAUF-1 |
      | buart   | Umbuchung   |
      | beleg   | UM1         |
      | beldat  | .           |
    And I modify table
      | mge | !row | platz | platz2 |
      | 10  | 1    | F1    | F2     |
    And I save the current editor

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | bisuch   | mfreig |
      | B_BAUGRUPPE | 10  | NPLATZ1_ | ja     |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NPLATZ1_001"
    And I close the current editor

# Materialentnahme bucht für B_EINKAUF-1 von F2
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag   | !Arbeitsschein1^nummer |
      | autorment | ja                     |
    And I press button "stllad"
    And I set field "manbu" to "ja" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

# Rückgabe B_EINKAUF-1 auf Platz F1 bringt Fehler
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -10                    |
    And I press button "stllad"
    And I set field "buplatz" to "F1" in row 1
    Then saving the current editor throws the exception "2037"
    And I close the current editor

# FV abschließen und negativen Bestand ausgleichen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NPLATZ1_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

  Scenario: 19 Materialrückgabe: Mz auf Zeile mit Menge 0 muss Fehlermeldung in Mz-Submaske ausgeben, wenn so nicht gebucht wurde
# Bestand B_EINKAUF-1 auf Null
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-B1"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR-B1"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "KORR-B1"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F2" with document "KORR-B1"

    Given I create a Lot "CH_E101" for Product "EINKAUF-1"

# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | bisuch | mfreig |
      | M_BAUGRUPPE | 10  | NMZ0_  | ja     |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "NMZ0_001"
    And I close the current editor

    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stllad"
    And I set field "bumge" to "5" in row 1
    And I set field "bumge" to "5" in row 2
    And I save the current editor

    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 0                      |
      | maxofmge    | nein                   |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
    And I set field "zuomge" to "-1" in row 1
    And I set field "charge" to "CH_E101" in row 1
    Then saving the current editor throws the exception "4066"
    And I close the current editor
    And I switch the current editor to editor "Materialentnahme1"
    And I close the current editor

# FV abschließen und negativen Bestand ausgleichen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NMZ0_000"
    And I set fields
      | mgr     | 101 |
      | manrest | ja  |
      | gut     | ja  |
      | sofort  | ja  |
    And I save the current editor
