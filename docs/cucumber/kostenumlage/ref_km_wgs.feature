# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: kostenumlagen + wertgutschrift  

Background:
Given I set the fake date to "25.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: Stammdaten vorbereiten
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "25.01.2002"

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1EI-VO"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12003vo"
And I delete all rows
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1FR-VF"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12002vf"
And I delete all rows
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1LO-VO"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12002vf"
And I delete all rows
And I save the current editor


# Zusatzposition Transport
Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "1transp"
And I set field "such" to "transport"
And I set field "name" to "transportkosten"
And I save the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE_mit_Art.pos_u_add.Kosten----KM----Loeschung_der_Art.pos_in_einer_neuen_WGS
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "25.01.2002"

# Rechnung für Artikel und add. kosten
Given I open an editor "re-240" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "240"
And I set field "lief" to "1"
And I set field "erfwaehr" to "eur"
And I set field "vom" to "."
And I set field "ueb" to "ja"

And I append rows
 | artikel     | mge | preis | tterm | ptext    	| platz     |
 | E1EI-VO     | 10  | 10,00 | +4    | kmzpos12n	|!dontChange|

And I append rows
 |artex     | pwert| konto | kstelle | ptext          | 
 |transport |     6| 50011 |     111 | kost_qu_ek_14n |

And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# KM, quelle u. ziel in einer einzigen Rechnung
Given I open an editor "REpos-100%WGS-KM" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "240km" 
And I set field "such" to "km240" 
And I set field "pos" to "$,,ptext==kost_qu_ek_14n;art==transport;pwert==6;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos12n;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor


# Wertgutschrift nur für add.Kosten  dazu die Artikelpos. löschen (Kommando Rechnung auf eine Rechnung)
Given I open an editor "240-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+240"
And I set fields
   | nummer | 240wgs|
   | such   | wgs240 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
And I press button "komplettieren"
Then the table has 5 rows
Then field "artikel" has value "E1EI-VO" in row 1
Then field "mge" has value "-10" in row 1
Then field "pwert" has value "-100.00" in row 1
Then field "artikel" has value "TRANSPORT" in row 2
Then field "pwert" has value "-6.00" in row 2
# !!!! dieser test muss nur die löschbarkeit der artikelposition sicherstellen 
And I delete row at position 1
And I set field "ueb" to "nein"
# And saving the current editor throws the exception "9264" : wird in anderem test geprueft.
And I save the current editor


Given I open an editor "KM_muss_noch_da_sein" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+240km"
Then field "ebsum" has value "6.00"
Then the table has 1 rows
Then field "artikel" has value "E1EI-VO" in row 1
Then field "pos" has value "4 *" in row !lastRow
Then field "artikel" has value "E1EI-VO" in row !lastRow
Then field "mge" has value "10" in row !lastRow
Then field "proz" has value "100" in row !lastRow
Then field "betr" has value "6.00" in row !lastRow
And I close the current editor

