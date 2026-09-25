# *****************************************************************************
#  Name           : sondermasseinheit.feature
#  Autor          : foe
#  Verantwortlich : foe
#  Kontrolle      : dago
#  Funktion       : Testet Funktionen rund um die Sondermasseinheit fuer die INTRASTAT.
#                   z.B: Vorbelegungen im Kopf auf die Zeilen uebernehmen.
#
# *****************************************************************************
#
@persistent
Feature: Sondermasseinheiten

Background:
Given I set the fake date to "02.01.1995"

#----------------------------------------------------------------------------------------------
Scenario: Stammdaten
#----------------------------------------------------------------------------------------------

# Kurztext Sondermasseinheit anlegen
Given I open an editor "SMKurztext1" from table "(Company):(Summary)" with command "NEW" for record ""
And I set fields
	| nummer    | 111                 |
	| namebspr  | Sondermasseinheit 1 |
	| such      | SM1                 |
	| sme       | Paar                |
And I save the current editor

Given I open an editor "SMKurztext2" from table "(Company):(Summary)" with command "NEW" for record ""
And I set fields
	| nummer    | 222                 |
	| namebspr  | Sondermasseinheit 2 |
	| such      | SM2                 |
	| sme       | m                   |
And I save the current editor

Given I open an editor "SMKurztext3" from table "(Company):(Summary)" with command "NEW" for record ""
And I set fields
	| nummer    | 333                 |
	| namebspr  | Sondermasseinheit 3 |
	| such      | SM3                 |
	| sme       | g                   |
And I save the current editor

# Neuen Artikel anlegen
Given I open an editor "TESM1" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TESM1            |
   | namebspr | TeilSM1          |
   | vpr      | 20               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | ahnum    | 111              |
Then field "sme" has value "Paar"
And I set field "smele" to "22"
And I save the current editor

# Weiteren Artikel anlegen
Given I open an editor "TESM2" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TESM2            |
   | namebspr | TeilSM2          |
   | vpr      | 50               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | ahnum    | 222              |
Then field "sme" has value "m"
Then field "sme" is not modifiable
And I set field "smele" to "0.5"
And I save the current editor

# Weiteren Artikel anlegen - mehrere Einheiten
Given I open an editor "TESM3" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TESM3            |
   | namebspr | TeilSM3          |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 100              |
   | lief     | 1                |
   | epr      | 100              |
   | fvhe     | 2                |
   | vhe      | kg               |
   | ahnum    | 333              |
Then field "sme" has value "g"
And I set field "smele" to "1000"
And I save the current editor

# Weiteren Artikel ohne Sondermasseinheit anlegen
Given I open an editor "TEOSM" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | TEOSM            |
   | namebspr | TeilOSM          |
   | vpr      | 50               |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
Then field "sme" has value ""
Then field "smele" is not modifiable
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag Neu
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-SM1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 01AU   |
   | kunde  | 1      |
   | such   | AU-SM1 |
When I create a new row at the end of the table
And I set field "artex" to "TESM1" in row 1
And I set field "mge" to "10" in row 1
Then field "sme" has value "Paar" in row 1
Then field "smele" has value "22" in row 1
Then field "intramge" has value "220" in row 1
When I create a new row at the end of the table
And I set field "artex" to "TESM2" in row 2
And I set field "mge" to "30" in row 2
Then field "sme" has value "m" in row 2
Then field "smele" has value "0.5" in row 2
Then field "intramge" has value "15" in row 2
When I create a new row at the end of the table
And I set field "artex" to "TESM3" in row 3
And I set field "mge" to "3" in row 3
Then field "sme" has value "g" in row 3
Then field "smele" has value "1000" in row 3
Then field "intramge" has value "1500" in row 3
And I set field "smele" to "50" in row 3
# (v)lehe = 0,5 fuer Artikel TESM3
Then field "intramge" has value "75" in row 3
When I create a new row at the end of the table
And I set field "artex" to "TEOSM" in row 4
And I set field "mge" to "12" in row 4
Then field "sme" has value "" in row 4
Then field "smele" has value "0" in row 4
Then field "smele" is not modifiable in row 4
Then field "intramge" has value "0" in row 4
And I save the current editor


#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung Neu
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-SM1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 01BE   |
   | lief   | 1      |
   | such   | BE-SM1 |
When I create a new row at the end of the table
And I set field "artex" to "TESM1" in row 1
And I set field "mge" to "10" in row 1
Then field "sme" has value "Paar" in row 1
Then field "smele" has value "22" in row 1
Then field "intramge" has value "220" in row 1
When I create a new row at the end of the table
And I set field "artex" to "TESM2" in row 2
And I set field "mge" to "30" in row 2
Then field "sme" has value "m" in row 2
Then field "smele" has value "0.5" in row 2
Then field "intramge" has value "15" in row 2
When I create a new row at the end of the table
And I set field "artex" to "TESM3" in row 3
And I set field "mge" to "3" in row 3
Then field "sme" has value "g" in row 3
Then field "smele" has value "1000" in row 3
# (e)lehe = 1 fuer Artikel TESM3
Then field "intramge" has value "3000" in row 3
And I set field "smele" to "50" in row 3
Then field "intramge" has value "150" in row 3
When I create a new row at the end of the table
And I set field "artex" to "TEOSM" in row 4
And I set field "mge" to "12" in row 4
Then field "sme" has value "" in row 4
Then field "smele" has value "0" in row 4
Then field "smele" is not modifiable in row 4
Then field "intramge" has value "0" in row 4
And I save the current editor

Given I open an editor "BE-RE01" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "01BE"
And I set fields
   | such   | BE-RE01 |
   | ebeleg | BE-RE01 |
   | ueb    | ja      |
   | tterm  | .       |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "5" in row 1
Then field "intramge" has value "110" in row 1
And I set field "mge" to "15" in row 2
Then field "intramge" has value "7.5" in row 2
And I set field "mge" to "2" in row 3
And I set field "smele" to "1000" in row 3
Then field "intramge" has value "2000" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag -> Warennummer in der Position eintragen -> Sondermaßeinheitenfelder pruefen
#----------------------------------------------------------------------------------------------
# AU/BE Artikel anlegen
Given I open an editor "1AUBE" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
   | nummer   | 1AUBE |
   | such     | AUBE1 |
   | zptyp    | AU/BE |
And I save the current editor

# Auftrag mit Artikel ohne Sondermasseinheitangaben anlegen
Given I open an editor "AU2-SM" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 02AU   |
   | kunde  | 2      |
   | such   | AU2-SM |
And I append rows
   | artex | mge |
   | TEOSM |  12 |
   | 1AUBE |  10 |
Then table has values
   | sme | smele | intramge | mge |
   |     | 0     | 0        | 12  |
   |     | 0     | 0        | 10  |
And I save the current editor

# Artikel TEOSM: Warennummer, Sondermasseinheit eintragen
Given I open an editor "TEOSM" from table "(Part):(Product)" with command "UPDATE" for record "TEOSM"
And I set fields
   | intrarel | ja  |
   | ahnum    | 333 |
   | smele    | 2   |
Then field "sme" has value "g"
And I save the current editor

# AU/BE Position: Warennummer, Sondermasseinheit eintragen
Given I open an editor "1AUBE" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "1AUBE"
And I set fields
   | intrarel | ja    |
   | ahnum    | 333   |
And I save the current editor

# Auftrag Warennummer in der Position eintragen + Neue Position eintragen
Given I open an editor "AU2-SM" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "02AU"
Then table has values
   | sme | smele | intramge | mge |
   |     | 0     | 0        | 12  |
And I set field "pahnum" to "333" in row 1
And I set field "pahnum" to "333" in row 2
And I append rows
   | artex | mge | pahnum |
   | TEOSM | 21  | 333    |
Then table has values
   | !row | sme | smele | intramge | mge |
   |    1 | g   | 2     | 24       | 12  |
   |    2 |     | 0     |  0       | 10  |
   |    3 | g   | 2     | 42       | 21  |
And I save the current editor

# Sondermasseinheit von g auf kg umstellen
Given I open an editor "SMKurztext3" from table "(Company):(Summary)" with command "UPDATE" for record "333"
And I set field "sme" to "kg"
And I save the current editor


# Auftrag Warennummer in der Position eintragen + Warennummer loeschen
Given I open an editor "AU2-SM" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AU2-SM"
And I set field "pahnum" to "333" in row 1
Then table has values
   | !row | sme | smele | intramge | mge |
   |    1 | kg  | 2     | 24       | 12  |
   |    2 |     | 0     |  0       | 10  |
   |    3 | g   | 2     | 42       | 21  |
Then field "intramge" is modifiable in row 1
And I set field "pahnum" to "" in row 1
Then table has values
   | sme | smele | intramge | mge |
   |     | 0     | 0        | 12  |
Then field "intramge" is not modifiable in row 1
And I save the current editor

# Artikel TEOSM: Warennummer, Sondermasseinheit wieder loeschen
Given I open an editor "TEOSM" from table "(Part):(Product)" with command "UPDATE" for record "TEOSM"
And I set fields
   | intrarel | nein |
   | ahnum    |      |
Then field "sme" has value ""
Then field "smele" has value "0"
And I save the current editor
