@persistent
Feature: Warengruppen-Kontierungsfälle
Background: Test 
Given I set the fake date to "08.01.2002"

@Fälle
Scenario: teil einkaufen
Given I set the fake date to "08.01.2002"


Given I open an editor "wgruppe-12003vo" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "12003vo"
And I create a new row at the end of the table
And I set field "bvfall" to "N" in row !lastRow
And I set field "bestkto" to "10013" in row !lastRow
And I set field "bvkonto" to "50030" in row !lastRow
And I create a new row at the end of the table
And I set field "bvfall" to "O" in row !lastRow
And I set field "bestkto" to "10013" in row !lastRow
And I set field "bvkonto" to "50031" in row !lastRow
And I create a new row at the end of the table
And I set field "bvfall" to "P" in row !lastRow
And I set field "bestkto" to "10013" in row !lastRow
And I set field "bvkonto" to "50032" in row !lastRow
And I create a new row at the end of the table
And I set field "bvfall" to "P" in row !lastRow
And I set field "bestkto" to "10014" in row !lastRow
And I set field "bvkonto" to "50030" in row !lastRow
And I create a new row at the end of the table
And I set field "bvfall" to "Q" in row !lastRow
And I set field "bestkto" to "10013" in row !lastRow
And I set field "bvkonto" to "50033" in row !lastRow
And I set field "bvfall" to "Q" in row !lastRow
And I set field "bestkto" to "10014" in row !lastRow
And I set field "bvkonto" to "50034" in row !lastRow
And I save the current editor

# ls1 anlegen
Given I open an editor "ls-ek1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1ls"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "13vo" in row 1
And I set field "mge" to "7" in row 1
And I set field "preis" to "14" in row 1
And I set field "kenn" to "ls1-kenn"
# And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Rechnung1 anlegen
Given I open an editor "rechnung-ek1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "13vo" in row 1
And I set field "mge" to "3" in row 1
And I set field "preis" to "19" in row 1
And I set field "konto" to "10014" in row 1
And I set field "kenn" to "ek1"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ------ direktes umlagern mit buchungswunsch ----------------
Given I open an editor "DirektUmlagern" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "13vo" in row 1
And I set field "mge" to "6" in row 1
And I set field "abplatz" to "F1" in row 1
# And I set field "verw2" to "MN-UML-EIGT" in row 1
And I set field "platz" to "L2F2" in row 1
# And I set field "verw" to "UMLZ-MIT-MKV" in row 1
And I set field "mfreig" to "JA" in row 1
And I set field "beleg" to "diruml1"
And I set field "beldat" to "."
And I set field "mkvwunsch" to "ja"
And I press button "umbuchen" to open a subeditor for "Umlagerung"
And I close the current editor
And I switch the current editor to editor "DirektUmlagern"
And I save the current editor


# Zaehlliste anlegen ACHARGE, EINHEIT    OHNE KONTENÄNDERUNG
Given I open an editor "Zaehlliste_ACHARGE_EINH" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ACHARGE_EIN_VZAEHL"
And I append rows
    | artikel        | platz| gebf |gebeinh |
    | 13vo 	         | L2F2 |  1   | m²     |
    | 13vo 	         | F1   |  1   | m²     |
And I save the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "ACHARGE_EIN_VZAEHL" and menu choice "Ja"
And I save the current editor

# Zählliste ACHARGE, EINHEIT bearbeiten und Zählmengen erfassen MIT KONTENÄNDERUNG
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ACHARGE_EIN_VZAEHL"
Then table has values
    | platz   | ibest | gebeinh |
    | F1      | 4     | m²      |
    | L2F2    | 6     | m²      |
And I modify table
    | !row            | nbest | gvko |
    | platz=='F1'     |  1    |      |
    | platz=='L2F2'   |  4    | 50101|
And I save the current editor

# Bestandsabschluss ACHARGE, EINHEIT
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ACHARGE_EIN_VZAEHL" and menu choice "Ja"
And I save the current editor

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "ACHARGE_EIN_VZAEHL" and menu choice "Ja"
And I save the current editor


# Bestandskorrekturabgang MIT KONTENÄNDERUNG
# Given I set StorageQuantity to zero for Product "13vo" on StorageLocation "L2F2" with document "bkorrab"
Given I open an editor "Bestandskorrektur" for tip command "(SInventory)" and arguments ""
And I set fields
	| artikel	| 13vo	|
	| beleg		| lkoabgkto |
	| beldat	| .			|
And I set field "platz" to "L2F2" in row 1
And I modify table
	| mge	| !row			| kosoll |
	| 3		| platz=='L2F2'	| 50102  |
And I save the current editor


# Bestandskorrekturabgang OHNE KONTENÄNDERUNG
# Given I set StorageQuantity to zero for Product "13vo" on StorageLocation "L2F2" with document "bkorrab"
Given I open an editor "Bestandskorrektur" for tip command "(SInventory)" and arguments ""
And I set fields
	| artikel	| 13vo	|
	| beleg		| lkoabg |
	| beldat	| .			|
And I set field "platz" to "L2F2" in row 1
And I modify table
	| mge	| !row			|
	| 2		| platz=='L2F2'	|
And I save the current editor


# ------ direktes umlagern OHNE buchungswunsch ----------------
Given I open an editor "DirektUmlagernOhneUmbuchungswunsch" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "13vo" in row 1
And I set field "mge" to "1" in row 1
And I set field "abplatz" to "F1" in row 1
And I set field "platz" to "L3F1" in row 1
And I set field "mfreig" to "JA" in row 1
And I set field "beleg" to "diruml2"
And I set field "beldat" to "."
And I set field "mkvwunsch" to "nein"
And I press button "umbuchen" to open a subeditor for "Umlagerung"
And I close the current editor
And I switch the current editor to editor "DirektUmlagernOhneUmbuchungswunsch"
And I save the current editor



# Mengenneubewertung auf ursprüngliche rechnung (2. zugang)
Given I open an editor "mnb1" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB1"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art==13vo;buart=1;mge=3;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "74" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor

# Mengenneubewertung auf ursprünglichen LS (= 1. zugang)
Given I open an editor "mnb1" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB2"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art==13vo;buart=1;mge=7;detursache==Lieferschein Einkauf;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "40" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor


# Mengenneubewertung auf umlagerung ohne buchung
Given I open an editor "mnb1" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB3"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,art==13vo;buart=1;mge=1;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "7" in row 1
And I set field "nbewertet" to "direkt" in row 1
And I save the current editor
And I close the current editor


# Nachbewerten
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
