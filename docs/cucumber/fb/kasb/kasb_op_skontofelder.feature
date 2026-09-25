# *****************************************************************************
#  Name             : kasb_op_skontofelder.feature
#  Autor            : Jan Effler
#  Verantwortlich   : hc
#  Kontrolle        : 
#  Funktion         : Testet die Vorbelegung der Skipfelder 
#                     skonto, skstelle, skonto2 und s2kstelle beim Laden 
#                     eines offenen Posten im Kassenbuch und vergleicht
#                     diese mit der Vorbelegung der Felder 
#                     in der Maske offene Posten ausbuchen
#   Ablauf:
#                      
#
# *****************************************************************************

@persistent

Feature: kasb_op_skontofelder
Background: Offene Posten

Scenario: Konfiguration pruefen

Given I open an editor "term" from table "(Company):(FinancialDates)" with command "VIEW" for record "2"
Then field "babkoartgj" has value "21"
Then field "babkoartgm" has value "1"
And I close the current editor

Scenario: Offene Posten aus Rechnungen erzeugen

Given I'm logged in with password "sy"

Given I open an editor "inv1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "1VOPKASB"
And I set field "kunde" to "001"
And I set field "budat" to "01.01.21"
And I set field "waehr" to "EUR"
And I set field "such" to "VOPKASB1"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "125" in row 1
And I set field "ueb" to "ja" in row 0
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "inv2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "2VOPKASB"
And I set field "kunde" to "001"
And I set field "budat" to "01.01.21"
And I set field "waehr" to "EUR"
And I set field "such" to "VOPKASB2"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "125" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "V2" in row 2
And I set field "mge" to "12" in row 2
And I set field "ueb" to "ja" in row 0
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "inv3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "1EOPKASB"
And I set field "lief" to "001"
And I set field "vom" to "01.01.21"
And I set field "budat" to "01.01.21"
And I set field "erfwaehr" to "EUR"
And I set field "such" to "EOPKASB1"
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row 1
And I set field "mge" to "125" in row 1
And I set field "preis" to "17,58" in row 1
And I set field "ueb" to "ja" in row 0
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "inv4" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "2EOPKASB"
And I set field "lief" to "001"
And I set field "vom" to "01.01.21"
And I set field "budat" to "01.01.21"
And I set field "erfwaehr" to "EUR"
And I set field "such" to "EOPKASB2"
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row 1
And I set field "mge" to "125" in row 1
And I set field "preis" to "17,58" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 2
And I set field "mge" to "85" in row 2
And I set field "preis" to "86" in row 2
And I set field "ueb" to "ja" in row 0
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------------------------
# Skontokonten kopieren und Kostenrechnungszwang einschalten
Scenario Outline: Skontokonto kopieren

Given I open an editor "skontocp" from table "(Account):(Account)" with command "COPY" for record "<record>"
And I set field "nummer" to "<nummer>"
And I set field "gv" to "ja"
And I set field "kost" to "ja"
And I set field "kstelle" to "<kstelle>"
And I create a new row at the end of the table
And I set field "zkoart" to "<koart>" in row 1
And I set field "koartvon" to "<von>" in row 1
And I save the current editor
And I close the current editor

Examples:

|record| nummer|kstelle|koart|     von|
| 47365|47365-2|    100|44000|01.01.21|
| 57365|57365-2|    100|54000|01.01.21|
| 57366|57366-2|    101|54000|01.01.21|

# 47365: Gewaehrte Skonti 19% netto
# 57365: Erhaltene Skonti 19% Vst netto

# ##########################################################################################################################################
# erzeugte OPs werden einmal im Kassenbuch und einmal in Offene Posten ausbuchen mit gleichem Buchungsdatum geladen 
# um die Werte der Felder skonto, skstelle, skonto2 und s2kstelle jeweils in den beiden Masken zu vergleichen

Scenario Outline: Feldwerte aus Kassenbuch mit Maske Offene Posten ausbuchen vergleichen

Given I'm logged in with password "me"
# Rechnung oeffnen um identnummer des OP auslesen zu koennen
Given I open an editor "rech" from table "(<db>):(Invoice)" with command "VIEW" for record "<rechnung>"
Then field "ablagef" has value "ja"
And I close the current editor

# OP in Maske "Offene Posten ausbuchen" laden
Given I open an editor "op-ausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "kbudat" to "<date>"
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0

Given I'm logged in with password "sy"
# OP in Kassenbuch laden
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Then field "waehr" has value "EUR"
And I create a new row at the end of the table
And I set field "budat" to "<date>" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0

And I switch the current editor to editor "kasb"
# Feldwerte vergleichen
Then field "skonto" in row 1 has value equal to field "skonto" from editor "op-ausb" in row 1
Then field "skonto" has value "<skonto>" in row 1
Then field "skstelle" in row 1 has value equal to field "skstelle" from editor "op-ausb" in row 1
Then field "skstelle" has value "<skstelle>" in row 1
Then field "skonto2" in row 1 has value equal to field "skonto2" from editor "op-ausb" in row 1
Then field "skonto2" has value "<skonto2>" in row 1
Then field "s2kstelle" in row 1 has value equal to field "s2kstelle" from editor "op-ausb" in row 1
Then field "s2kstelle" has value "<s2kstelle>" in row 1

And I close the current editor
And I switch the current editor to editor "op-ausb"
And I close the current editor

Examples:

|        db| rechnung|    date|skonto|skstelle|skonto2|s2kstelle|
|     Sales|+1VOPKASB|01.01.22| 47365|        |       |         |
|     Sales|+2VOPKASB|01.01.22| 47365|        |       |         |
|Purchasing|+1EOPKASB|01.01.22| 57365|        |       |         |
|Purchasing|+2EOPKASB|01.01.22| 57365|        |       |         |

# ------------------------------------------------------------------------------------------------------------------------------------------

Scenario: OP in Maske "Offene Posten pflegen" anpassen (Skontokonto aendern) -> Aenderungen in Kassenbuch und offene Posten ausbuchen vergleichen
 
Given I'm logged in with password "me"
# Rechnung oeffnen um identnummer des OP auslesen zu koennen
Given I open an editor "rech" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1EOPKASB"
Then field "ablagef" has value "ja"
And I close the current editor

# Skontokonto in Maske "Offene Posten pflegen" aendern
Given I open an editor "op-pfl" from table "(OIProcessing):(MaintainOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
# 57315: erhaltene Skonti 7% netto
And I set field "skonto" to "57315" in row 1
And I set field "skonto2" to "" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# Aenderung sollten in Maske "Offene Posten ausbuchen" sichtbar sein
Given I open an editor "op-ausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "kbudat" to "01.01.22"
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "57315" in row 1
Then field "skstelle" has value "" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1

Given I'm logged in with password "sy"

# Aenderung sollten im Kassenbuch sichtbar und identisch zu "Offene Posten ausbuchen" sein
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Then field "waehr" has value "EUR"
And I create a new row at the end of the table
And I set field "budat" to "01.01.22" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" in row 1 has value equal to field "skonto" from editor "op-ausb" in row 1
Then field "skstelle" in row 1 has value equal to field "skstelle" from editor "op-ausb" in row 1
Then field "skonto2" in row 1 has value equal to field "skonto2" from editor "op-ausb" in row 1
Then field "s2kstelle" in row 1 has value equal to field "s2kstelle" from editor "op-ausb" in row 1
And I close the current editor
And I switch the current editor to editor "op-ausb"
And I close the current editor

Given I'm logged in with password "me"

# Skontokonten in Maske "Offene Posten pflegen" aendern (Konten mit Kostenrechnungszwang und Kostenstelle)
Given I open an editor "op-pfl" from table "(OIProcessing):(MaintainOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
And I set field "skonto" to "57365-2" in row 1
And I set field "skonto2" to "57366-2" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# Soll Zustand, vergleiche REWE-#TODO

# Aenderung sollte im Kassenbuch sichtbar sein, Kostenstellen aus den Skontokonten uebernommen werden
# And I switch the current editor to editor "kasb"
# And I set field "budat" to "01.01.22" in row 1
# Then field "skonto" has value "57365-2" in row 1
# Then field "skstelle" has value "100" in row 1
# Then field "skonto2" has value "57366-2" in row 1
# Then field "s2kstelle" has value "101" in row 1
# And I close the current editor 

Given I open an editor "op-ausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "kbudat" to "01.01.22"
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0

Given I'm logged in with password "sy"

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Then field "waehr" has value "EUR"
And I create a new row at the end of the table
And I set field "budat" to "01.01.22" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "57365-2" in row 1
Then field "skonto" in row 1 has value equal to field "skonto" from editor "op-ausb" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skstelle" in row 1 has value equal to field "skstelle" from editor "op-ausb" in row 1
Then field "skonto2" has value "57366-2" in row 1
Then field "skonto2" in row 1 has value equal to field "skonto2" from editor "op-ausb" in row 1
Then field "s2kstelle" has value "101" in row 1
Then field "s2kstelle" in row 1 has value equal to field "s2kstelle" from editor "op-ausb" in row 1
And I close the current editor

Given I set the fake date to "01.01.22"

# ------------------------------------------------------------------------------------------------------------------------------------------

Scenario Outline: identische OPs erstellen

# Rechnung oeffnen um identnummer des OP auslesen zu koennen
Given I open an editor "rech" from table "(Purchasing):(Invoice)" with command "VIEW" for record "<orig-record>"
And I close the current editor

# Rechnung kopieren und buchen um identischen OP zu erhalten
Given I open an editor "rechcp" from table "(Purchasing):(Invoice)" with command "COPY" for record "<orig-record>"
And I set field "nummer" to "<new-record>"
And I set field "vom" to "vom" from editor "rech"
And I set field "budat" to "budat" from editor "rech"
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor

Examples:

|orig-record|new-record|
|  +2EOPKASB|  2EOPKAS2|
|  +1EOPKASB|  1EOPKAS2|

Scenario: Kopie des mit OP pflegen angepassten OP ebenfalls anpassen

# neue Rechnung oeffnen um identnummer des OP auslesen zu koennen
Given I open an editor "rech" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1EOPKAS2"
And I close the current editor

# Original Rechnung oeffnen um auf Werte des zugrundeliegendenden OP zugreifen zu koennen
Given I open an editor "rechorig" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1EOPKASB"
And I close the current editor

# Feldwerte im OP anpassen
Given I open an editor "op-pfl" from table "(OIProcessing):(MaintainOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
And I set field "skonto" to "57365-2" in row 1 
And I set field "skonto2" to "57366-2" in row 1 
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Scenario Outline: identische OPs ausbuchen und Werte der Skipfelder skonto, skstelle, skonto2 und s2kstelle pruefen

# Rechnung oeffnen um identnummer des OP auslesen zu koennen
Given I open an editor "rech" from table "(Purchasing):(Invoice)" with command "VIEW" for record "<orig-record>"
And I close the current editor

# Rechnung oeffnen um identnummer des OP auslesen zu koennen
Given I open an editor "rech2" from table "(Purchasing):(Invoice)" with command "VIEW" for record "<new-record>"
Then field "ablagef" has value "ja"
And I close the current editor

# den ersten OP mit Maske "Offene Posten ausbuchen" ausbuchen
Given I open an editor "opausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "kbudat" to "01.01.22" in row 0
And I create a new row at the end of the table
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "op" has value "<opexpausb>" in row 1
And I press button "tueber" in row 1
And I set field "gkonto" to "18100"
And I set field "beleg" to "nummer" from editor "rech"
And I set field "beldat" to "vom" from editor "rech"
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# den zweiten OP ueber das Kassenbuch ausgleichen
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16000"
And I create a new row at the end of the table
And I set field "beldat" to "01.01.22" in row 1
Then field "budat" has value "01.01.22" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech2" in row 0
Then field "op" has value "<opexpkasb>" in row 1
Then the table has 1 rows
And I press button "allefr"
And I press button "bucheschl" to open a subeditor for "buch" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

# Feldwerte der mit "Offene Posten ausbuchen" ausgebuchten OPs gegen die Sollwerte abgleichen
Given I open an editor "opausberg" from table "(OutstandingItems):(OutstandingItem)" with command "VIEW" for record "+<opexpausb>"
Then field "opzl^skonto" has value "<skonto>"
Then field "opzl^skstelle" has value "<skstelle>"
Then field "opzl^skonto2" has value "<skonto2>"
Then field "opzl^s2kstelle" has value "<s2kstelle>"
And I close the current editor

# Feldwerte der mit "Kassenbuch" asugebuchten OPs gegen das mit "Offene Posten ausbuchen" ausgebuchte Gegenstueck abgleichen
Given I open an editor "opkasberg" from table "(OutstandingItems):(OutstandingItem)" with command "VIEW" for record "+<opexpkasb>"
Then field "opzl^skonto" has value equal to field "opzl^skonto" from editor "opausberg"
Then field "opzl^skstelle" has value equal to field "opzl^skstelle" from editor "opausberg"
Then field "opzl^skonto2" has value equal to field "opzl^skonto2" from editor "opausberg"
Then field "opzl^s2kstelle" has value equal to field "opzl^s2kstelle" from editor "opausberg"
And I close the current editor

Examples:

|orig-record|new-record|opexpausb|opexpkasb| skonto|skstelle|skonto2|s2kstelle|
|  +2EOPKASB| +2EOPKAS2|       10|       13|  57365|        |       |         |
|  +1EOPKASB| +1EOPKAS2|        7|       16|57365-2|     100|57366-2|      101|

# ------------------------------------------------------------------------------------------------------------------------------------------

Scenario: Aenderbarkeit der Felder pruefen

Given I'm logged in with password "sy"

# Rechnung oeffnen um identnummer des OP auslesen zu koennen
Given I open an editor "rech" from table "(Sales):(Invoice)" with command "VIEW" for record "+2VOPKASB"
And I close the current editor

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I create a new row at the end of the table
Then field "op" is not modifiable in row 1
Then field "skonto" is not modifiable in row 1
Then field "skstelle" is not modifiable in row 1
Then field "skonto2" is not modifiable in row 1
Then field "s2kstelle" is not modifiable in row 1
And I set field "budat" to "01.01.22" in row 1
Then field "op" is modifiable in row 1
Then field "skonto" is not modifiable in row 1
Then field "skstelle" is not modifiable in row 1
Then field "skonto2" is not modifiable in row 1
Then field "s2kstelle" is not modifiable in row 1
And I set field "budat" to "" in row 1
Then field "op" is not modifiable in row 1
Then field "skonto" is not modifiable in row 1
Then field "skstelle" is not modifiable in row 1
Then field "skonto2" is not modifiable in row 1
Then field "s2kstelle" is not modifiable in row 1
Then field "budat" has value "" in row 1
And I set field "beldat" to "01.01.22" in row 1
Then field "budat" has value "01.01.22" in row 1
Then field "op" is modifiable in row 1
Then field "skonto" is not modifiable in row 1
Then field "skstelle" is not modifiable in row 1
Then field "skonto2" is not modifiable in row 1
Then field "s2kstelle" is not modifiable in row 1
And I set field "beldat" to "" in row 1
Then field "budat" has value "01.01.22" in row 1
Then field "op" is modifiable in row 1
Then field "skonto" is not modifiable in row 1
Then field "skstelle" is not modifiable in row 1
Then field "skonto2" is not modifiable in row 1
Then field "s2kstelle" is not modifiable in row 1
And I set field "beldat" to "01.01.22" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" is not modifiable in row 1
Then field "skstelle" is not modifiable in row 1
Then field "skonto2" is not modifiable in row 1
Then field "s2kstelle" is not modifiable in row 1
And I close the current editor

Scenario: OPs ausbuchen vor und nach beginn der Kostenrechnung und mit und ohne Kostenstelle im OP

Given I set the fake date to "01.01.22"

Given I open an editor "rech" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VOPKASB"
Then field "ablagef" has value "ja"
And I close the current editor

# Skontokonto in Maske "Offene Posten pflegen" aendern

Given I open an editor "op-pfl" from table "(OIProcessing):(MaintainOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
And I set field "skonto" to "47365-2" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# Beginn der Kostenrechnung nach hinten verschieben um bebuchbare Daten vor und nach Beginn der Kostenrechnung zu haben
Given I'm logged in with password "annette"

Given I open an editor "term" from table "(Company):(FinancialDates)" with command "UPDATE" for record "2"
And I set field "babkoartgj" to "22"
And I set field "babkoartgm" to "4"
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"
# Konto an neuen Beginn der Kostenrechnung anpassen
Given I open an editor "skontoupd" from table "(Account):(Account)" with command "UPDATE" for record "47365-2"
And I set field "koartvon" to "01.04.22" in row 1
And I save the current editor
And I close the current editor

# Feldwerte fuer Buchungsdatum vor und Buchungsdatum nach Beginn der Kostenrechnung pruefen
# Buchungsdatum VOR Beginn der Kostenrechnung, Feld Kostenstelle in OP NICHT leer
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Then field "waehr" has value "EUR"
And I create a new row at the end of the table
And I set field "beldat" to "01.01.22" in row 1
Then field "budat" has value "01.01.22" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I set field "beinn" to "100" in row 1
And I set field "nummer" to "1MITKST"
And I set field "kasskto" to "16000"
And I press button "allefr"
And I press button "bucheschl" to open a subeditor for "" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "VIEW" for record "1MITKST"
Then field "op" in row 1 has value equal to field "ophist^op" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I close the current editor

# Buchungsdatum VOR Beginn der Kostenrechnung, Feld Kostenstelle in OP NICHT leer
Given I open an editor "op-ausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "kbudat" to "01.01.22"
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I set field "opzabetr" to "100" in row 1
And I set field "gkonto" to "18100"
And I set field "beleg" to "1VOPKB11"
And I set field "beldat" to "01.01.22"
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

And I open an editor "partdebitoi1" from table "(OIProcessing):(DebitOutstandingItems)" with command "VIEW" for record "+X20220101-1VOPKB11"
Then field "kbudat" has value "01.01.22"
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I close the current editor

# Kostenstelle im OP leeren
Given I open an editor "op-pfl" from table "(OIProcessing):(MaintainOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
And I set field "skstelle" to "" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Given I open an editor "op-ausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
# Buchungsdatum VOR Beginn der Kostenrechnung, Feld Kostenstelle in OP leer
And I set field "kbudat" to "01.01.22"
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I set field "opzabetr" to "100" in row 1
And I set field "gkonto" to "18100"
And I set field "beleg" to "1VOPKB12"
And I set field "beldat" to "01.01.22"
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

And I open an editor "partdebitoi2" from table "(OIProcessing):(DebitOutstandingItems)" with command "VIEW" for record "+X20220101-1VOPKB12"
Then field "kbudat" has value "01.01.22"
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I close the current editor

# Buchungsdatum VOR Beginn der Kostenrechnung, Feld Kostenstelle in OP leer
Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Then field "waehr" has value "EUR"
And I create a new row at the end of the table
And I set field "beldat" to "01.01.22" in row 1
Then field "budat" has value "01.01.22" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I set field "beinn" to "100" in row 1
And I set field "nummer" to "1OHNKST"
And I set field "kasskto" to "16000"
And I press button "allefr"
And I press button "bucheschl" to open a subeditor for "" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "VIEW" for record "1OHNKST"
Then field "op" in row 1 has value equal to field "ophist^op" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I close the current editor

# Nach Beginn der Kostenrechnung
# Kostenstelle im OP wieder befuellen
Given I open an editor "op-pfl" from table "(OIProcessing):(MaintainOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
And I set field "skstelle" to "101" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# Buchungsdatum NACH Beginn der Kostenrechnung, Feld Kostenstelle in OP NICHT leer

Given I set the fake date to "01.05.22"

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Then field "waehr" has value "EUR"
And I create a new row at the end of the table
And I set field "beldat" to "01.05.22" in row 1
Then field "budat" has value "01.05.22" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "101" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I set field "beinn" to "100" in row 1
And I set field "nummer" to "2MITKST"
And I set field "kasskto" to "16000"
And I press button "allefr"
And I press button "bucheschl" to open a subeditor for "" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "VIEW" for record "2MITKST"
Then field "op" in row 1 has value equal to field "ophist^op" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "101" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I close the current editor

Given I open an editor "op-ausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "kbudat" to "01.05.22"
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "101" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I set field "opzabetr" to "100" in row 1
And I set field "gkonto" to "18100"
And I set field "beleg" to "1VOPKB21"
And I set field "beldat" to "01.05.22"
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

And I open an editor "partdebitoi3" from table "(OIProcessing):(DebitOutstandingItems)" with command "VIEW" for record "+X20220501-1VOPKB21"
Then field "kbudat" has value "01.05.22"
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "101" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I close the current editor

# Kostenstelle im OP leeren
Given I open an editor "op-pfl" from table "(OIProcessing):(MaintainOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
And I set field "skstelle" to "" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

# Buchungsdatum NACH Beginn der Kostenrechnung, Feld Kostenstelle in OP leer
Given I open an editor "op-ausb" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "kbudat" to "01.05.22"
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I set field "opzabetr" to "100" in row 1
And I set field "gkonto" to "18100"
And I set field "beleg" to "1VOPKB22"
And I set field "beldat" to "01.05.22"
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

And I open an editor "partdebitoi4" from table "(OIProcessing):(DebitOutstandingItems)" with command "VIEW" for record "+X20220501-1VOPKB22"
Then field "kbudat" has value "01.05.22"
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I close the current editor

# Buchungsdatum VOR Beginn der Kostenrechnung, Feld Kostenstelle in OP leer

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
Then field "waehr" has value "EUR"
And I create a new row at the end of the table
And I set field "beldat" to "01.05.22" in row 1
Then field "budat" has value "01.05.22" in row 1
And I set field "op" in row 1 to "ophist" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I set field "beinn" to "100" in row 1
And I set field "nummer" to "2OHNKST"
And I set field "kasskto" to "16000"
And I press button "allefr"
And I press button "bucheschl" to open a subeditor for "" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "VIEW" for record "2OHNKST"
Then field "op" in row 1 has value equal to field "ophist^op" from editor "rech" in row 0
Then field "skonto" has value "47365-2" in row 1
Then field "skstelle" has value "100" in row 1
Then field "skonto2" has value "" in row 1
Then field "s2kstelle" has value "" in row 1
And I close the current editor

Given I set the fake date to "01.01.22"
