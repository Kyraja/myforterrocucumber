# verantwortlich: uo
@persistent
Feature: Lagerneubewertung bei manuell erfassten Zugängen

Background:
And I set the fake date to "4.4.02"

Scenario: 01

And I set the fake date to "4.4.02"

Given I open an editor "TeilArtikel-1" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| nummer | 777            |
	| such   | artlneubewert  |
And I save the current editor

# ******** man. zugang des neuen artikels OHNE PREIS **********
#
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 777  |
	| beleg   | a    |
	| beldat  | .    |
	| buart   | zu   |
And I append rows
	| mge | platz2 |
	| 5   | f1     |
And I save the current editor
And I close the current editor

# ------ nicht neubewerten im engeren Sinne sondern Mischpreis MPR vergeben ----
#
Given I open an editor "Lneu1" for tip command "Lneubewertung" and arguments ""
And I set fields
	| artikel | 777  |
	| beleg   | c    |
	| beldat  | .    |
And I set field "mge" to "3" in row 1
And I set field "mmpr" to "30" in row 1
And I set field "lgruppe" to "KA" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ----------------------------------- ende erster artikel ---------------------
Given I open an editor "" from table "(Part):(Product)" with command "NEW" for record "777" 
And I set fields
	| nummer    | 888          |
	| such      | LGMPRNEUBEW  |
	| ekbewverf | 8            |
And I save the current editor
And I close the current editor


# ******** man. zugang des neuen artikels OHNE PREIS **********
#
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 888     |
	| beleg   | b       |
	| beldat  | .       |
	| buart   | zugang  |
And I append rows
	| mge | platz2 |
	| 10  | f2     |
And I save the current editor
And I close the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 888     |
	| beleg   | lgmabg  |
	| beldat  | .       |
	| buart   | abg     |
And I append rows
	| mge | platz |
	| 4   | f2    |
And I save the current editor
And I close the current editor

# ------ nicht neubewerten im engeren Sinne sondern Mischpreis MPR vergeben ----
Given I open an editor "Lneu2" for tip command "Lneubewertung" and arguments ""
And I set fields
	| artikel | 888  |
	| beleg   | f    |
	| beldat  | .    |
And I set field "mge" to "3" in row 1
And I set field "mmpr" to "20" in row 1
And I set field "lgruppe" to "KA" in row 1
And I save the current editor
And I close the current editor


# Nachbewerten
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
# ----------------------- mit preis --------------------
And I set fields
	| artikel | 888       |
	| beleg   | mitpreis  |
	| beldat  | .         |
	| buart   | zugang    |
	| wert    | 7         |
And I append rows
	| mge | platz2 |
	| 10  | L2F2   |
And I save the current editor
And I close the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 888         |
	| beleg   | lgmabgl2f2  |
	| beldat  | .           |
	| buart   | abg         |
And I append rows
	| mge | platz |
	| 8   | L2F2  |
And I save the current editor
And I close the current editor

#
# ------ nicht neubewerten im engeren Sinne sondern Mischpreis MPR vergeben ----
Given I open an editor "Lneu3" for tip command "Lneubewertung" and arguments ""
And I set fields
	| artikel | 888        |
	| beleg   | lneumitpr  |
	| beldat  | .          |
And I set field "mge" to "1" in row 1
And I set field "mmpr" to "15" in row 1
And I set field "lgruppe" to "HO" in row 1
And I save the current editor
And I close the current editor
