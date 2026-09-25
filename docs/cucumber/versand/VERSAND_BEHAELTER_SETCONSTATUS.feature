# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_SETCONSTATUS.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Aenderungen am Behaelterstatus (per Infosystem)
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_SETCONSTATUS.feature
Background:
Given I set the fake date to "02.01.95"


@SETCONSTATUS
@testvorbereitung
Scenario Outline: Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such      | <such>     |
    | namebspr  | <namebspr> |
    | dispoa    | <dispoa>   |
    | chverfolgung | Chargenverfolgung |
    | chimlager | ja         |
    | packmit   | <packmit>  |
    | pmtyp     | <pmtyp>    |
And I save the current editor

Examples: Artikel
| such       | namebspr         | dispoa          | packmit | pmtyp     |
| SETCONST-1 | Artikel 1        | auftragsbezogen | nein    |           |
| SETCONST-2 | Artikel 2        | auftragsbezogen | nein    |           |
| SETCONST-3 | Artikel 3        | auftragsbezogen | nein    |           |
| SPALETTE   | Palette Standard | !dontChange     | ja      | Palette   |
| SKARTON    | KARTON Standard  | !dontChange     | ja      | Behaelter |

@SETCONSTATUS
@testvorbereitung
Scenario: Projekt anlegen
Given I open an editor "BEHSTATUS" from table "(Transaction):(Project)" with command "STORE" for record "BESTATUS"
And I set fields
    | such     | BEHSTATUS       |
    | namebspr | Behaelterstatus |
And I save the current editor

@SETCONSTATUS
@testvorbereitung
Scenario Outline: Chargen anlegen
Given I open an editor "<such>" from table "(Lots):(Lots)" with command "STORE" for record "<such>"
And I set fields
    | such    | <such>    |
    | exnum   | <exnum>   |
    | artikel | <artikel> |
And I save the current editor

Examples: Chargen
| such         | exbenum  | artikel    |
| CH_CONSTAT-1 | 1-CHARGE | SETCONST-1 |
| CH_CONSTAT-2 | 2-CHARGE | SETCONST-2 |


##################################################################################################################

Scenario: 01 Ein gefuellter Behaelter kann nicht ausgewaehlt werden
# Behaelter anlegen
Given I open an editor "CON_GEFUELLT" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "CON_GEFUELLT"
And I set field "packm" to "BEHAELTER"
And I save the current editor

# Behaelter fuellen
Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | SETCONST-1 |
    | buart   | Zugang     |
    | beleg   | FEHL01     |
    | beldat  | .          |
And I append rows
    | mge | behaelter                                                | charge2      |
    | 10  | $,,such=CON_GEFUELLT;@richtung=rückwärts;@maxtreffer=1 |              |
    | 10  | $,,such=CON_GEFUELLT;@richtung=rückwärts;@maxtreffer=1 | CH_CONSTAT-1 |
And I save the current editor

# Behaelterstatus aendern SETCONSTATUS
Given I open the infosystem "SETCONSTATUS"
And I set field "kconnumvon" to id from editor "CON_GEFUELLT"
And I press start
Then field "tueber" is not modifiable in row 1
Then field "tleer" has value "nein" in row 1
And I close the current editor


Scenario: 02 Status Ruecklieferung und Geliefert darf nicht gesetzt werden
# Behaelter anlegen
Given I open an editor "CON_FEHL" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "CON_FEHL"
And I set field "packm" to "BEHAELTER"
And I save the current editor

# Behaelterstatus aendern SETCONSTATUS
Given I open the infosystem "SETCONSTATUS"
And I set field "kconnumvon" to id from editor "CON_FEHL"
And I press start

# Status Ruecklieferung
And I set field "tbstatusneu" to "Rücklieferung" in row 1
Then message "Dieser Status darf nicht manuell gesetzt werden." was displayed

# Status Geliefert
And I set field "tbstatusneu" to "Geliefert" in row 1
Then message "Dieser Status darf nicht manuell gesetzt werden." was displayed
And I close the current editor


Scenario Outline: 03 A Status leer kann in der Zeile gesetzt werden
# verschiedene Behaelter anlegen
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I set field "behstatusaz" to "Gesperrt"
And I save the current editor

Examples:
| such      | packm     |
| BEHAELTER | BEHAELTER |
| SKARTON   | SKARTON   |
| SPALETTE  | SPALETTE  |

Scenario: 03 B Status leer kann gesetzt werden
Given I set the fake date to "03.01.95"
# Behaelterstatus aendern SETCONSTATUS
Given I open the infosystem "SETCONSTATUS"
And I set field "kconnumvon" to id from editor "BEHAELTER"
And I set field "kconnumbis" to id from editor "SPALETTE"
And I press start
Then the table has 3 rows
And I modify table
    | tbstatusneu | !row | tueber |
    |             | 1    | ja     |
    |             | 2    | ja     |
    |             | 3    | ja     |
And I press button "ksetstatus"
And I close the current editor

Scenario Outline: 03 C Status leer kann gesetzt werden
Given I set the fake date to "04.01.95"
# Behaelterobjekt pruefen
Given I switch the current editor to editor "<editor>"
Then field "behstatusaz" has value ""
And I close the current editor

Examples:
| editor    |
| BEHAELTER |
| SKARTON   |
| SPALETTE  |


Scenario Outline: 04 A Status leer kann fuer die gesamte Tabelle gesetzt werden
Given I set the fake date to "05.01.95"
# verscheidene Behaelter anlegen
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I set field "behstatusaz" to "Gesperrt"
And I save the current editor

Examples:
| such      | packm	    |
| BEHAELTER | BEHAELTER |
| SKARTON   | SKARTON   |
| SPALETTE  | SPALETTE  |

Scenario: 04 B Status leer kann fuer die gesamte Tabelle gesetzt werden
Given I set the fake date to "06.01.95"
# Behaelterstatus aendern SETCONSTATUS
Given I open the infosystem "SETCONSTATUS"
And I set field "kconnumvon" to id from editor "BEHAELTER"
And I set field "kconnumbis" to id from editor "SPALETTE"
And I press start
Then the table has 3 rows
And I set field "kbstatusneu" to ""
And I modify table
    | !row                      | tueber |
    | tkpackmittel=="BEHAELTER" | ja     |
    | tkpackmittel=="SKARTON"   | ja     |
    | tkpackmittel=="SPALETTE"  | ja     |
And I press button "ksetstatus"
And I close the current editor

Scenario Outline: 04 C Status leer kann fuer die gesamte Tabelle gesetzt werden
Given I set the fake date to "07.01.95"
# Behaelterobjekt prueen
Given I switch the current editor to editor "<editor>"
Then field "behstatusaz" has value ""
And I close the current editor

Examples:
| editor    |
| BEHAELTER |
| SKARTON   |
| SPALETTE  |


Scenario: 05 Status Gesperrt kann gesetzt werden
Given I set the fake date to "08.01.95"
# Behaelter anlegen
Given I open an editor "GESPERRT" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "GESPERRT"
And I set field "packm" to "BEHAELTER"
And I save the current editor

# Behaelterstatus aendern SETCONSTATUS
Given I open the infosystem "SETCONSTATUS"
And I set field "kconnumvon" to id from editor "GESPERRT"
And I press start
Then the table has 1 rows
And I modify table
    | !row              | tbstatusneu |
    | tsuch=="GESPERRT" | Gesperrt    |
And I press button "kallmark"	
And I press button "ksetstatus"
Then the table has 1 rows
And I close the current editor

# Behaelterobjekt pruefen
Given I switch the current editor to editor "GESPERRT"
Then field "behstatusaz" has value "Gesperrt"
And I close the current editor


Scenario Outline: 06 A Mehrere verschiedene Behaelterstatus koennen gesetzt werden, nicht erlaubte werden abgehlehnt
Given I set the fake date to "09.01.95"
# verschiedene Behaelter anlegen
Given I open an editor "<such>" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "packm" to "<packm>"
And I set field "behstatusaz" to "<behstatusaz>"
And I save the current editor

Examples:
| such        | packm     | behstatusaz | exbehnum       |
| BEHAELTER_1 | BEHAELTER | Gesperrt    |                |
| BEHAELTER_2 | BEHAELTER |             | Geliefert      |
| BEHAELTER_3 | BEHAELTER |             | Rückgeliefert |
| BEHAELTER_4 | BEHAELTER |             | Gefüllt       |
| BEHAELTER_5 | BEHAELTER |             |                |

Scenario: 06 B Mehrere verschiedene Behaelterstatus koennen gesetzt werden, nicht erlaubte werden abgehlehnt
Given I set the fake date to "10.01.95"
# Lagerbuchung fuer Behaelter_2, _3 und _4
Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | SETCONST-1 |
    | beleg   | 06         |
    | beldat  | .          |
    | buart   | Zugang     |
And I append rows
    | mge | behaelter                                               |
    | 1   | $,,such=BEHAELTER_2;@richtung=rückwärts;@maxtreffer=1 |
    | 1   | $,,such=BEHAELTER_3;@richtung=rückwärts;@maxtreffer=1 |
    | 1   | $,,such=BEHAELTER_4;@richtung=rückwärts;@maxtreffer=1 |
And I save the current editor

# Verkaufsvorgang fuer Status Geliefert
Given I open an editor "VK-Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | 1  |
    | ueb   | ja |
And I append rows
    | artikel    | mge | behaelter                                               |
    | SETCONST-1 | 1   | $,,such=BEHAELTER_2;@richtung=rückwärts;@maxtreffer=1 |
And I save the current editor

# Einkaufsvorgang fuer Status rueckgeliefert
Given I open an editor "EK-Lieferschein_06" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | 1    |
    | ueb    | ja   |
    | vom    | .    |
    | ebeleg | LS06 |
And I append rows
    | artikel    | mge |
    | SETCONST-1 | 10  |
And I save the current editor

Given I open an editor "EK-RueckLieferschein" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EK-Lieferschein_06"
And I set fields
    | ueb    | ja   |
    | vom    | .    |
    | ebeleg | LSR06 |
And I modify table
    | !row | mge | behaelter                                               |
    | 1    | -1  | $,,such=BEHAELTER_3;@richtung=rückwärts;@maxtreffer=1 |
And I save the current editor

Scenario: 06 C Mehrere verschiedene Behaelterstatus koennen gesetzt werden, nicht erlaubte werden abgehlehnt
Given I set the fake date to "11.01.95"
# Behaelterstatus aendern SETCONSTATUS
Given I open the infosystem "SETCONSTATUS"
And I set field "kconnumvon" to id from editor "BEHAELTER_1"
And I set field "kconnumbis" to id from editor "BEHAELTER_5"
And I press start
Then the table has 5 rows
And I modify table
    | !row                 | tueber | tbstatusneu |
    | tsuch=="BEHAELTER_1" | ja     |             |
    | tsuch=="BEHAELTER_2" | ja     |             |
    | tsuch=="BEHAELTER_3" | ja     | Gesperrt    |
And I set field "tbstatusneu" to "Geliefert" in row 5
Then message "Dieser Status darf nicht manuell gesetzt werden." was displayed
Then field "tueber" is not modifiable in row 4
And I press button "ksetstatus"
And I close the current editor
