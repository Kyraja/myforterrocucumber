# *****************************************************************************
#  Name           : ev_basisartikel_price_info_cu.feature
#  Autor          : dago
#  Verantwortlich : teampss
#  Funktion       : Tests fuer (Basis-)Artikel mit Rabattgruppen im Einkauf und Verkauf
#                   der Preisauskunft
#
# *****************************************************************************
#
@persistent
Feature: Preisauskunft mit Basisartikel im Einkauf und Verkauf
Background:
And I set the fake date to "01.01.2000"

Scenario: Stammdaten (Rabattgruppen, Basisartikel) anlegen
# EK - Rabattgruppe anlegen
Given I open an editor "EK-RAB-GR1" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
  | nummer | 001             |
  | such   | EKRAB-GR1       |
  | typ    | Einkauf Rabatte |
  | gltvon | .               |
  | gltbis | +10             |
  | klpg   | 001             |
  | artpg  | 001             |
  | mgeab  | ja              |
And I delete all rows
And I append rows
  | mgrenze | mproz |
  | 1       | -10   |
  | 50      | -12   |
And I save the current editor

Given I open an editor "EK-RAB-GR2" from table "(Pricing):(Pricing)" with command "NEW" for record ""
And I set fields
  | nummer | 002             |
  | such   | EKRAB-GR2       |
  | typ    | Einkauf Rabatte |
  | gltvon | .               |
  | gltbis | +10             |
  | klpg   | 002             |
  | artpg  | 002             |
  | mgeab  | ja              |
And I delete all rows
And I append rows
  | mgrenze | mproz |
  | 1       | -15   |
  | 50      | -20   |
And I save the current editor

# EK - Basisartikel neu anlegen
Given I open an editor "BASIS-ST" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
  | such      | BASIS-STEIN |
  | namebspr  | Basisstein  |
  | erab      | 001         |
  | erab2     | 002         |
  | prgrabueb | ja          |
And I save the current editor

# EK - Versionen zum Basisartikel anlegen
Given I open an editor "STEIN-G01" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
  | such         | STEIN-BLAU    |
  | namebspr     | Stein in Blau |
  | basisartikel | BASIS-STEIN   |
  | index        | G01           |
  | lief         | 001           |
  | epr          | 20            |
  | lief2        | 002           |
  | epr2         | 22            |
And I save the current editor

# VK - Rabattgruppe anlegen
Scenario Outline: VK Rabatte
Given I open an editor "<such>" from table "(Pricing):(Pricing)" with command "STORE" for record "<such>"
  And I set fields
    | such  | <such>  |
    | typ   | <typ>   |
    | artpg | <artpg> |
    | klpg  | <klpg>  |
    | mgeab | <mgeab> |
  And I delete all rows
  And I append rows
      | mgrenze    | mproz    |
      | <mgrenze1> | <mproz1> |
      | <mgrenze2> | <mproz2> |
  And I save the current editor
  Examples:
    | such      | typ             | artpg       | klpg  | mgeab | mgrenze1 | mproz1  | gltvon | gltbis | mgrenze2 | mproz2 |
    | VKRAB-GR1 | Verkauf Rabatte | !dontChange | 101   | ja    | 1        | -14     | .      | +10    | 25       | -16    |

Scenario: Stammdaten (Rabattgruppen, Basisartikel) anlegen
# Neuer Kunde mit Preisgruppe 101
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "COPY" for record "001"
And I set fields
  | nummer | 101      |
  | such   | GAERTNER |
  | rab    | 101      |
  | prg    | 101      |
  | waehr  | EUR      |
And I save the current editor

# VK - Basisartikel neu anlegen
Given I open an editor "ROSENGARTEN" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
  | such      | ROSENGARTEN |
  | namebspr  | Rosengarten |
  | vrab      | 101         |
  | prgrabueb | ja          |
And I save the current editor

# VK - Version zum Basisartikel anlegen
Given I open an editor "ROSE-ROT" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
  | such         | ROSE-ROT    |
  | namebspr     | Rote Rose   |
  | basisartikel | ROSENGARTEN |
  | index        | G01         |
  | vpr          | 10          |
  | vpr2         | 11          |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Preisauskunft allgemein
#----------------------------------------------------------------------------------------------
Given I open an editor "VK_Preis_info1" for tip command "(PriceInformation)" and arguments ""
And I set fields
  | eva     | Verkauf |
  | artikel | V2      |
  | kl      | 101     |
# Der Artikel ist keine Version des Basisartikels.
And setting field "basisartikel" to "ROSENGARTEN" throws the exception "1163"
And I set fields
  | artikel      |             |
  | basisartikel | ROSENGARTEN |
  | mge          | 10          |
Then field "artikel" has value "ROSE-ROT"
Then field "mpreis" has value "10.00" in row 1
# Rabatt
Then field "mproz" has value "-14" in row 2
And I set fields
  | mge | 25 |
# Rabatt
Then field "mproz" has value "-16" in row 2
And I set field "basisartikel" to ""
Then the table has 0 rows
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Preisauskunft allgemein
#----------------------------------------------------------------------------------------------
Given I open an editor "EK_Preis_info1" for tip command "(PriceInformation)" and arguments ""
And I set fields
  | artikel | E1     |
  | kl      | L 002  |
# Der Artikel ist keine Version des Basisartikels.
And setting field "basisartikel" to "BASIS-ST" throws the exception "1163"
And I set fields
  | artikel      |          |
  | basisartikel | BASIS-ST |
  | mge          | 10       |
Then field "artikel" has value "STEIN-BLAU"
Then field "mpreis" has value "22.00" in row 1
# Rabatt
Then field "mproz" has value "-15" in row 2
And I set fields
  | mge | 50 |
# Rabatt
Then field "mproz" has value "-20" in row 2
And I set field "basisartikel" to ""
Then the table has 0 rows
And I close the current editor

Given I open an editor "STEIN-G01" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
  | such         | STEIN-GELB    |
  | namebspr     | Stein in gelb |
  | basisartikel | BASIS-STEIN   |
  | index        | G02           |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Feld Basisartikel ist schreibgeschuetzt ausser es handelt sich um einen reinen Artikel
#----------------------------------------------------------------------------------------------
Given I open an editor "PreisInfo-ohne-EK" for tip command "(PriceInformation)" and arguments ""
And I set fields
  | eva | Einkauf |
And I set field "artikel" to "DL-ANALYSE"
Then field "basisartikel" is not modifiable
And I set field "artikel" to ""
Then field "basisartikel" is modifiable
And I set field "artikel" to "AU/BE"
Then field "basisartikel" is not modifiable
And I set field "artikel" to "V1-ROT"
Then field "basisartikel" is modifiable
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: LF - Wechsel auf nicht LF Artikel loescht lffert
#----------------------------------------------------------------------------------------------

Given I open an editor "V1-METALL1" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
  | such  | V1-METALL1     |
  | le    | Stück          |
  | bsart | Eigenfertigung |
And I save the current editor

Given I open an editor "V1-METALL2" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set fields
  | such  | V1-METALL2      |
  | le    | Stück           |
  | bsart | Eigenfertigung  |
And I save the current editor

# Versionen zum Basisartikel Metallplatte anlegen,
Given I open an editor "B-METALLPLATTE" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
  | such     | B-METALLPLATTE |
  | namebspr | Metallplatte   |
And I append rows
  | tversion      | tindex  | tstdvers |
  | !V1-METALL1^id | 1      | nein     |
  | !V1-METALL2^id | 2      | ja       |
And I save the current editor

# Lohnfertigungsteile  anlegen
Given I open an editor "LF.SCHLEIFEN" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | LF.SCHLEIFEN             |
   | namebspr | Lohnfertigung Schleifen  |
   | bsart    | Lohnfertigung            |
And I save the current editor

Given I open an editor "LF.GALVANISIEREN" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | LF.GALVANISIEREN             |
   | namebspr | Lohnfertigung Galvanisieren |
   | bsart    | Lohnfertigung                |
And I save the current editor

Given I open an editor "Preisauskunft" for tip command "(PriceInformation)" and arguments ""
And I set field "kl" to "L 1"
And I set field "artikel" to "!LF.SCHLEIFEN"
And I set field "basisartikel" to "!B-METALLPLATTE"
And I set field "mge" to "1"
And I set field "lffert" to "!V1-METALL2"

# Setzen auf anderen LF Artikel -> lffert bleibt erhalten
And I set field "artikel" to "!LF.GALVANISIEREN"
Then field "lffert" has value "V1-METALL2"
Then field "basisartikel" has value "B-METALLPLATTE"

# Setzen auf nicht LF Artikel -> lffert wird geleert
And I set field "artikel" to "V1"

Then field "lffert" has value ""
Then field "lffert" is empty
Then field "basisartikel" is empty

# Wieder eintragen
And I set field "artikel" to "!LF.SCHLEIFEN"
And I set field "lffert" to "!V1-METALL2"
Then field "basisartikel" has value "B-METALLPLATTE"

# Leeren Artikel -> lffert wird geleert
And I set field "artikel" to ""
Then field "lffert" is empty

# wieder eintragen
And I set field "artikel" to "!LF.SCHLEIFEN"
And I set field "lffert" to "!V1-METALL2"
Then field "basisartikel" has value "B-METALLPLATTE"

# Leeren Basisartikel -> artikel und lffert wird geleert
And I set field "basisartikel" to ""
Then field "artikel" has value "LF.SCHLEIFEN"
Then field "lffert" is empty
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK Rabatte - Im Auftrag Preise- und Rabatte ermitteln per Button
#----------------------------------------------------------------------------------------------
# VK-Rabatte
Given I open an editor "VK-RABATT1" from table "(Pricing):(Pricing)" with command "STORE" for record "RABATT1"
And I set fields
  | nummer    | 102             |
  | such      | RABATT1         |
  | typ       | Verkauf Rabatte |
  | gruppenpr | ja              |
  | artpg     | RABATT          |
  | klpg      | 70001           |
  | mgeab     | ja              |
  | rfolge    | 1               |
  | separat   | ja              |
And I create a new row at the end of the table
And I set field "mgrenze" to "10" in row 1
And I set field "mproz" to "-1" in row 1
And I save the current editor

Given I open an editor "VK-RABATT1" from table "(Pricing):(Pricing)" with command "STORE" for record "RABATT2"
And I set fields
  | nummer    | 103             |
  | such      | RABATT2         |
  | typ       | Verkauf Rabatte |
  | klpg      | 70001           |
  | mgeab     | ja              |
  | rfolge    | 2               |
  | separat   | ja              |
And I create a new row at the end of the table
And I set field "mgrenze" to "2" in row 1
And I set field "mproz" to "-2" in row 1
And I save the current editor

# VK - Artikel goldene TULPE mit Rabatt hinterlegen
Given I open an editor "TULPE_GOLDEN" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
  | such      | TULPE_GOLD    |
  | namebspr  | Goldene Tulpe |
  | vrab      | RABATT        |
And I save the current editor

# VK - Artikel silberne TULPE mit Rabatt hinterlegen
Given I open an editor "TULPE_SILBER" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
  | such      | TULPE_SILBER   |
  | namebspr  | Silberne Tulpe |
  | vrab      | RABATT         |
And I save the current editor

# Auftrag
Given I open an editor "AU001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU001 |
   | kunde   | 70001  |
   | such    | AU001  |
And I append rows
   | artikel      | mge |
   | TULPE_GOLD   | 1   |
   | TULPE_SILBER | 9   |
Then the table has 3 rows
And I press button "rabdr"
Then the table has 5 rows
And I save the current editor

# Auftrag
Given I open an editor "AU002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU002 |
   | kunde   | 70001  |
   | such    | AU002  |
And I append rows
   | artikel      | mge |
   | TULPE_GOLD   | 2   |
   | TULPE_SILBER | 8   |
Then the table has 4 rows
And I press button "rabdr"
Then the table has 6 rows
And I save the current editor
