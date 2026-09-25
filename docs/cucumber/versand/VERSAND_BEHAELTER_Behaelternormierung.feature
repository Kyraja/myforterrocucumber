@persistent
Feature: VERSAND_BEHAELTER_Behaelternormierung.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Behaelternormierung.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet die Normierung von Behaelternummern und Suchwoertern
#  ref              : ref_behaelter_eigenschaften_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"

# ACHTUNG!! NUMMER ANLEGEN FUER ALLE SZENARIEN:
# ERSETZEN FUER BEHAELTERNUMMER (nummer) - 3SP_


Scenario Outline: 01 Einbuchen Artikel in Behaelter

Given I open an editor "<editor>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "packm" to "KLT"
And I save the current editor

Examples: Behaelter anlegen
| editor     | nummer  |
| behaelter1 | 3SP_abc |
| behaelter2 | 3SP_ABC |
| behaelter3 | 3SP_Abc |
| behaelter4 | 3SP_AbC |
| behaelter5 | 3SP_aBc |
| behaelter6 | 3SP_abC |

Scenario: 01 Einkauf ein Artikel, Artikelzeile _aBc, wird in _ABC gebucht - Normierung
Given I open an editor "eklieferschein_01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | ebeleg    | EK-Lieferschein_01  |
  | lief      | LIEFER1             |
  | vom       | .                   |
  | ueb       | ja                  |
And I append rows
  | artikel     | mge   | !dialogId                                     | !dialogAnswer | exbehnum |
  | EK1-BEDARF  | 5     | Externe Behälternummer ist bereits vergeben. | nein          | 3SP_aBc  |
And I save the current editor

# Ruecksendung, ein Artikel, Artikelzeile _aBc
Given I open an editor "ekls_rueck_01" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "eklieferschein_01"
  And I set fields
  | ebeleg    | Rücklieferung_01    |
  | vom       | .                   |
  | ueb       | ja                  |
And I modify table
  | !row  | mge | behaelter |
  | 1     | -5  | 3SP_ABC   |
And I save the current editor

# Lagerjournal ausgeben
And I open the infosystem "LJ"
And I set fields
  | adatum  | .                     |
  | beleg   | !ekls_rueck_01^nummer |
And I press start
  Then table has values
  | !row  | art         | zmge  |
  | 1     | EK1-BEDARF  | -5    |
And I close the current editor

And I switch the current editor to editor "behaelter5" with command "VIEW"
Then the table has 0 rows
Then field "behstatusaz" has value ""
And I close the current editor

And I switch the current editor to editor "behaelter2" with command "VIEW"
Then the table has 0 rows
Then field "behstatusaz" has value "Rücklieferung"
And I close the current editor


Scenario: 02 Normierung von Behaelternummern

# nummer: muss mit Zahl beginnen
# such: muss mit Buchstaben beginnen, normiert zu Grossbuchstaben
# exbehnum: alle Eingaben moeglich
Given I open an editor "behaelter7" from table "(Container):(ContainerShell)" with command "NEW" for record ""
# Fehler: 131 de      |unzulässige Angabe
And setting field "nummer" to "A08" throws the exception "131"
# Fehler: 131 de      |unzulässige Angabe
And setting field "such" to "08A" throws the exception "131"
And I set field "exbehnum" to "A08"
And I set field "exbehnum" to "08A"
And I set field "exbehnum" to "_08A"
And I close the current editor
