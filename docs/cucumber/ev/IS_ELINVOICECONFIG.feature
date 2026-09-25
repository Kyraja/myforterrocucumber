# *****************************************************************************
#  Name           : IS_ELINVOICECONFIG.feature
#  Autor          : mh
#  Verantwortlich : teaminfosysteme
#  Funktion       : Testet Funktionen des ElInvoiceConfig Infosystems
#
# *****************************************************************************
#
@persistent
Feature: Infosystem ELINVOICECONFIG verwenden
Background:
#Given I set the fake date to "05.01.1995"
Given I set saved value "REF_FILE" to "EV.ELINVOICECONFIG.CU.REF"
Given I set saved value "FeldlisteIS" to "tlief, tliefsuch, tkunde, tkundesuch, tabm, tabmverab, tobjsuche, taktiv"

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann START 1
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set field "kohnezugferdkonfig" to "ja"
And I press button "bstart"
Then field "kedinachrzugferdaz" has value "ZUGFeRD-Rechnung Import"
Then the table has 19 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann START 2
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kvon               |    |
  | kbis               |    |
  | ksuchwort          |    |
  | kohnezugferdkonfig | ja |
And I press button "bstart"
Then the table has 19 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann START 3
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kvon               |     |
  | kbis               |     |
  | ksuchwort          | EDI |
  | kohnezugferdkonfig | ja  |
And I press button "bstart"
Then the table has 6 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann START 4
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kvon               | 228501 |
  | kbis               | 229504 |
  | ksuchwort          |        |
  | kohnezugferdkonfig | ja     |
And I press button "bstart"
Then the table has 4 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann START 5
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kvon               | 228501 |
  | kbis               | 229504 |
  | ksuchwort          | EDIRE  |
  | kohnezugferdkonfig | ja     |
And I press button "bstart"
Then the table has 2 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann Einstellungen setzen
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kvon               | 228501 |
  | kbis               | 229504 |
  | ksuchwort          | EDIRE  |
  | kohnezugferdkonfig | ja     |
And I press button "bstart"
And the table has 2 rows
And I press button "sellall"
And I append text "" to output file "$REF_FILE"
And I append text "---Lieferanten 228501-229504 Suchwort 'EDIRE' ohne EDI Werte---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I set fields
  | kabm       | 4160  |
  | kabmverarb | 4161  |
  | kobjsuche  | 11003 |
  | kaktiv     | ja    |
And I press button "kbueintragen"
And I set field "kohnezugferdkonfig" to "nein"
And I press button "bstart"
And I append text "" to output file "$REF_FILE"
And I append text "---Lieferanten 228501-229504 Suchwort 'EDIRE' mit EDI Werten---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann START mit Ankreuzfeldern mit/ohne - EINFACH 1
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kvon               |      |
  | kbis               |      |
  | ksuchwort          | EDI  |
  | kohnezugferdkonfig | nein |
And I press button "bstart"
Then the table has 2 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann START mit Ankreuzfeldern mit/ohne - EINFACH 2
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kvon               |     |
  | kbis               |     |
  | ksuchwort          | EDI |
  | kohnezugferdkonfig | ja  |
And I press button "bstart"
Then the table has 4 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann Einstellungen die bereits da sind ändern/zurücksetzen
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kvon               |      |
  | kbis               |      |
  | ksuchwort          | EDI  |
  | kohnezugferdkonfig | nein |
  | kaktiv             | nein |
And I press button "bstart"
Then the table has 2 rows
And I press button "sellall"
And I press button "kbueintragen"
And I set field "kohnezugferdkonfig" to "ja"
And I press button "bstart"
And I append text "" to output file "$REF_FILE"
And I append text "---Lieferanten Suchwort 'EDI' zurücksetzen---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann ZUGFeRD-Rechnung Export mit Lieferanten
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kedinachrzugferdaz | ZUGFeRD-Rechnung Export |
  | kohnezugferdkonfig | ja                      |
And I press button "bstart"
Then the table has 19 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann ZUGFeRD-Rechnung Export mit Lieferanten und Einstellungen setzen
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kedinachrzugferdaz | ZUGFeRD-Rechnung Export |
  | kvon               | 228501                  |
  | kbis               | 229504                  |
  | ksuchwort          | EDIRE                   |
  | kohnezugferdkonfig | ja                      |
And I press button "bstart"
And the table has 2 rows
And I press button "sellall"
And I append text "" to output file "$REF_FILE"
And I append text "---Lieferanten 228501-229504 Suchwort 'EDIRE' ohne EDI Werte ZUGFeRD-Rechnung Export---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I set fields
  | kabm       | 4150  |
  | kaktiv     | ja    |
And I press button "kbueintragen"
And I set field "kohnezugferdkonfig" to "nein"
And I press button "bstart"
And I append text "" to output file "$REF_FILE"
And I append text "---Lieferanten 228501-229504 Suchwort 'EDIRE' mit EDI Werten ZUGFeRD-Rechnung Export---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann ZUGFeRD-Rechnung Export mit Lieferanten und Einstellungen ändern/zurücksetzen
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I set fields
  | kedinachrzugferdaz | ZUGFeRD-Rechnung Export |
  | kvon               |                         |
  | kbis               |                         |
  | ksuchwort          | EDI                     |
  | kohnezugferdkonfig | nein                    |
  | kaktiv             | nein                    |
And I press button "bstart"
Then the table has 2 rows
And I press button "sellall"
And I press button "kbueintragen"
And I set field "kohnezugferdkonfig" to "ja"
And I press button "bstart"
And I append text "" to output file "$REF_FILE"
And I append text "---Lieferanten Suchwort 'EDI' mit ZUGFeRD-Rechnung Export zurücksetzen---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG: Toggle der Lieferanten-/Kunden-Checkboxen und Schreibschutz Abbildungsmodelle
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"

Then field "kkunden" has value "ja"
Then field "klieferanten" has value "nein"
Then field "kabm" is modifiable
Then field "kabmverarb" is not modifiable
Then field "kobjsuche" is not modifiable
And I set field "kedinachrzugferdaz" to "ZUGFeRD-Rechnung Import"
Then field "kabm" is modifiable
Then field "kabmverarb" is modifiable
Then field "kobjsuche" is modifiable

And I set field "klieferanten" to "ja"
Then field "kkunden" has value "nein"
Then field "kabm" is modifiable
Then field "kabmverarb" is modifiable
Then field "kobjsuche" is modifiable
And I set field "kedinachrzugferdaz" to "ZUGFeRD-Rechnung Export"
Then field "kabm" is modifiable
Then field "kabmverarb" is not modifiable
Then field "kobjsuche" is not modifiable

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG: Schutz und Filter der Abbildungsmodell-Wahlfelder testen (klieferanten)
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"

And I set field "klieferanten" to "ja"

# Je Feld erst ein falsches Abbildungsmodell (ergibt es leeres Feld), dann ein richtiges

And I set field "kabm" to "4150"
Then field "kabm" has value ""
And I set field "kabm" to "4160"
Then field "kabm" has value "4160"

And I set field "kabmverarb" to "4150"
Then field "kabmverarb" has value ""
And I set field "kabmverarb" to "4161"
Then field "kabmverarb" has value "4161"

And I set field "kobjsuche" to "11001"
Then field "kobjsuche" has value ""
And I set field "kobjsuche" to "11003"
Then field "kobjsuche" has value "11003"

And I set field "kkunden" to "ja"

And I set field "kabm" to "4160"
Then field "kabm" has value ""
And I set field "kabm" to "4150"
Then field "kabm" has value "4150"

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG: Tabelle Kunden Zeilen
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"

# Fall Start
And I set field "kkunden" to "ja"
And I set field "kohnezugferdkonfig" to "ja"
And I press button "bstart"
Then the table has 34 rows


# Fall Start mit EDI Suchwort
And I set fields
  | kvon               |     |
  | kbis               |     |
  | ksuchwort          | EDI |
  | kohnezugferdkonfig | ja  |
And I press button "bstart"
Then the table has 6 rows


# Fall Start mit Kundenbereich
And I set fields
  | kvon               | 001 |
  | kbis               | 008 |
  | ksuchwort          |     |
  | kohnezugferdkonfig | ja  |
And I press button "bstart"
Then the table has 6 rows

# Fall Start mit EDI Suchwort und Kundenbereich
And I set fields
  | kvon               | 001 |
  | kbis               | 004 |
  | ksuchwort          | mil |
  | kohnezugferdkonfig | ja  |
And I press button "bstart"
Then the table has 2 rows

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG: EDI Abbildungsmodelle fuer Kunden schreiben
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"

And I set field "kkunden" to "ja"
And I set fields
  | kvon               | 001 |
  | kbis               | 008 |
  | ksuchwort          |     |
  | kohnezugferdkonfig | ja  |
And I set field "kabm" to "4150"
And I set field "kaktiv" to "ja"
And I press button "bstart"
And I press button "sellall"
And I press button "kbueintragen"

And I set field "kohnezugferdkonfig" to "nein"
And I press button "bstart"
And I append text "" to output file "$REF_FILE"
And I append text "---EDI Abbildungsmodelle in Verkauf schreiben---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann ZUGFeRD-Rechnung Import mit Kunden
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "kkunden" to "ja"
And I set fields
  | kedinachrzugferdaz | ZUGFeRD-Rechnung Import |
  | kohnezugferdkonfig | ja                      |
And I press button "bstart"
Then the table has 34 rows
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann ZUGFeRD-Rechnung Import mit Kunden und Einstellungen setzen
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "kkunden" to "ja"
And I set fields
  | kedinachrzugferdaz | ZUGFeRD-Rechnung Import |
  | kvon               | 002                     |
  | kbis               | 008                     |
  | ksuchwort          | MIL                     |
  | kohnezugferdkonfig | ja                      |
And I press button "bstart"
And the table has 4 rows
And I press button "sellall"
And I append text "" to output file "$REF_FILE"
And I append text "---Kunden 002-008 Suchwort 'MIL' ohne EDI Werte ZUGFeRD-Rechnung Import---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I set fields
  | kabm       | 4160  |
  | kabmverarb | 4161  |
  | kobjsuche  | 11003 |
  | kaktiv     | ja    |
And I press button "kbueintragen"
And I set field "kohnezugferdkonfig" to "nein"
And I press button "bstart"
And I append text "" to output file "$REF_FILE"
And I append text "---Kunden 002-008 Suchwort 'MIL' mit EDI Werten ZUGFeRD-Rechnung Import---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann ZUGFeRD-Rechnung Import mit Kunden und Einstellungen ändern/zurücksetzen
# ----------------------------------------------------------------------------------------------

Given I open the infosystem "ELINVOICECONFIG"
And I set field "kkunden" to "ja"
And I set fields
  | kedinachrzugferdaz | ZUGFeRD-Rechnung Import |
  | kvon               |                         |
  | kbis               |                         |
  | ksuchwort          | MIL                     |
  | kohnezugferdkonfig | nein                    |
  | kaktiv             | nein                    |
And I press button "bstart"
Then the table has 4 rows
And I press button "sellall"
And I press button "kbueintragen"
And I set field "kohnezugferdkonfig" to "ja"
And I press button "bstart"
And I append text "" to output file "$REF_FILE"
And I append text "---Kunden Suchwort 'MIL' mit ZUGFeRD-Rechnung Import zurücksetzen---" to output file "$REF_FILE"
And I export fields "$FeldlisteIS" from table content to output file "$REF_FILE"

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Infosystem ELINVOICECONFIG kann mit abgelegten Abbildungsmodellen umgehen
# ----------------------------------------------------------------------------------------------

Given I enable the flag 298

Given I open the infosystem "ELINVOICECONFIG"
And I set fields
  | klieferanten       | ja    |
  | kohnezugferdkonfig | ja    |
  | ksuchwort          | MERT  |
  | kabm               | 4160  |
  | kabmverarb         | 4161  |
  | kobjsuche          | 11003 |
  | kaktiv             | ja    |
And I press button "bstart"
And I press button "sellall"
And I press button "kbueintragen"
And I close the current editor

Given I open an editor "4150" from table "(EDIConfiguration):(MappingModel)" with command "DELETE" for record "4150"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open the infosystem "ELINVOICECONFIG"
And I set field "kkunden" to "ja"
And I press button "bstart"
Then message ".formula M|tabm = 9|ieabmodell ??" was not displayed
And I create a new row at the end of the table
And I set field "tkunde" to "MERT" in row !lastRow
Then message ".formula M|tabm = 9|ieabmodell ??" was not displayed
And I close the current editor

Given I open an editor "4161" from table "(EDIConfiguration):(MappingModel)" with command "DELETE" for record "4161"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "11003" from table "(EDIConfiguration):(EDIObjectSearch)" with command "DELETE" for record "11003"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open the infosystem "ELINVOICECONFIG"
And I set field "klieferanten" to "ja"
And I press button "bstart"
Then message ".formula M|tabm = 9|ieabmodell ??" was not displayed
And I create a new row at the end of the table
And I set field "tlief" to "001" in row !lastRow
Then message ".formula M|tabmverab = 9|abmodell ??" was not displayed
Then message ".formula M|tobjsuche = 9|suchkonfig ??" was not displayed
And I close the current editor
