
# verantwortlich: uo

@persistent
Feature: Preiserfassungen fuer Planpreisartikel in manueller lagerbuchung (LBU) nach projekt lmenge21 Anfang 2022

Background:
And I set the fake date to "4.4.02"

# ======================================================================
Scenario: Planpreisartikel
# ======================================================================
And I set the fake date to "4.4.02"

# ******** man. zugang mit eingabe wert/preis pp0->0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 16po    |
	| beleg   | mpr.eq.0.0  |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp=0 mpr==0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 10  | f2     |
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "VIEW" for record "16po"
Then field "mpr" has value "0.0000"
Then field "planpr1" has value "0.0000"
And I close the current editor


# ------------------- MPR fuer artikel 16po erzeugen --------------------- 
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1    |
    | vom      | .          |
    | ueb      | ja         |
    | fakt     | ja         |
    | ebeleg   | x           |
    | erfwaehr | EUR        |
    | budat    | .          |
And I append rows
    | artikel     | mge | preis | tterm	| ljtext1              |
    | 16po        | 35  | 40,00 | +4	| pp==0 + erzeuge mpr>0 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ----------------- Planpreis1 MPR pruefen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "VIEW" for record "16po"
Then field "mpr" has value "31.1111"
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> KEINE EINGABE **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 16po    |
	| beleg   | mpr31.kEin |
	| beldat  | .       |
	| buart   | zugang  |
	| ljtext1 | pp==0 mpr=31.1111, keine einga. |
And I append rows
	| mge | platz2 |
	| 18  | f1     |
And I save the current editor
And I close the current editor

# ----------------- Planpreis1 erfassen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "16po"
Then field "mpr" has value "31.1111"
Then field "planpr1" has value "0.0000"
And I set field "planpr1" to "16.0"
And I save the current editor

# ----------------- Planpreis1 MPR pruefen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "VIEW" for record "16po"
Then field "mpr" has value "31.1111"
Then field "planpr1" has value "16.0000"
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp==16 + mpr>0 -> 0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 16po    |
	| beleg   | pp.na.0 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp==16 mpr=31.1111 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 4   | f1     |
And I save the current editor
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp==16 + mpr>0 -> 20 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 16po    |
	| beleg   | pp.na.20 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 20  |
	| ljtext1 | pp==16 mpr>0 eingabe 20 |
And I append rows
	| mge | platz2 |
	| 6   | f1     |
And I save the current editor
And I close the current editor


# ******** man. zugang mit eingabe wert/preis pp==16 + mpr>0 -> KEINE EINGABE **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 16po    |
	| beleg   | pp.kEin |
	| beldat  | .       |
	| buart   | zugang  |
	| ljtext1 | pp==16 mpr>0 keine einga. |
And I append rows
	| mge | platz2 |
	| 17  | f1     |
And I save the current editor
And I close the current editor


# ======================================================================
Scenario: vorgangspreisartikel fuer den MPR-Nachbewertungstest
# ======================================================================

And I set the fake date to "6.4.02"

# ******** man. zugang mit eingabe wert/preis mpr0->0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 13vo    |
	| beleg   | 0.na.0  |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp=0 mpr=0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 10  | f2     |
And I save the current editor
And I close the current editor

# ----------------- Planpreis1 erfassen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "13vo"
Then field "mpr" has value "0.0000"
Then field "planpr1" has value "0.0000"
And I set field "planpr1" to "13.0"
And I save the current editor

# ------------------- MPR fuer artikel 13vo erzeugen --------------------- 
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1    |
    | vom      | .          |
    | ueb      | ja         |
    | fakt     | ja         |
    | ebeleg   | x           |
    | erfwaehr | EUR        |
    | budat    | .          |
And I append rows
    | artikel     | mge | preis | tterm	| ljtext1              |
    | 13vo        | 20  | 45,00 | +4	| pp>0 + erzeuge mpr>0 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------- Planpreis1 pruefen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "13vo"
Then field "mpr" has value "30.0000"
Then field "planpr1" has value "13.0000"
And I close the current editor

# ******** man. zugang mit eingabe wert/preis  mpr>0 -> 0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 13vo    |
	| beleg   | mpr.gt0.0 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp>0 mpr>0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 5   | f1     |
And I save the current editor
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 mpr>0 -> 20 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 13vo    |
	| beleg   | mpr.na.x |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 20  |
	| ljtext1 | pp>0 mpr>0 eingabe 20 |
And I append rows
	| mge | platz2 |
	| 6   | f1     |
And I save the current editor
And I close the current editor


# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> KEINE EINGABE **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 13vo    |
	| beleg   | mpr.kEin |
	| beldat  | .       |
	| buart   | zugang  |
	| ljtext1 | pp>0 mpr>0 keine einga. |
And I append rows
	| mge | platz2 |
	| 17  | f1     |
And I save the current editor
And I close the current editor


# ======================================================================
Scenario: nullbewertungsartikel fuer den MPR-Nachbewertungstest
# ======================================================================
And I set the fake date to "8.4.02"

# ******** man. zugang mit eingabe wert/preis mpr0->0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 17zo    |
	| beleg   | 0.na.0  |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp=0 mpr=0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 10  | f2     |
And I save the current editor
And I close the current editor

# ----------------- Planpreis1 erfassen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "17zo"
Then field "mpr" has value "0.0000"
Then field "planpr1" has value "0.0000"
And I set field "planpr1" to "17.0"
And I save the current editor

# ------------------- MPR fuer artikel 17zo erzeugen --------------------- 
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1    |
    | vom      | .          |
    | ueb      | ja         |
    | fakt     | ja         |
    | ebeleg   | x           |
    | erfwaehr | EUR        |
    | budat    | .          |
And I append rows
    | artikel     | mge | preis | tterm	| ljtext1              |
    | 17zo        | 20  | 55,00 | +4	| pp>0 + erzeuge mpr>0 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------- Planpreis1 pruefen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "17zo"
Then field "mpr" has value "36.6667"
Then field "planpr1" has value "17.0000"
And I close the current editor

# ******** man. zugang mit eingabe wert/preis  pp>0 mpr>0 -> 0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 17zo    |
	| beleg   | mpr.gt0.0 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp>0 mpr>0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 5   | f1     |
And I save the current editor
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 mpr>0 -> 20 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 17zo    |
	| beleg   | mpr.na.x |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 20  |
	| ljtext1 | pp>0 mpr>0 eingabe 20 |
And I append rows
	| mge | platz2 |
	| 6   | f1     |
And I save the current editor
And I close the current editor


# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> KEINE EINGABE **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 17zo    |
	| beleg   | mpr.kEin |
	| beldat  | .       |
	| buart   | zugang  |
	| ljtext1 | pp>0 mpr>0 keine einga. |
And I append rows
	| mge | platz2 |
	| 17  | f1     |
And I save the current editor
And I close the current editor


# ======================================================================
Scenario: Teile kopieren zu eigenfertgiungsteilen
# ======================================================================
And I set the fake date to "4.4.02"

Given I open an editor "teil1" from table "(Part):(Product)" with command "COPY" for record "16po"
And I set fields
    | such			| teilppef	|
    | nummer		| 24poef	|
    | bsart         | Eigenfertigung |
And I save the current editor

Given I open an editor "teil2" from table "(Part):(Product)" with command "COPY" for record "13vo"
And I set fields
    | such			| teilvoef	|
    | nummer		| 25voef	|
    | bsart         | Eigenfertigung |
And I save the current editor

Given I open an editor "teil3" from table "(Part):(Product)" with command "COPY" for record "17zo"
And I set fields
    | such			| teilzoef	|
    | nummer		| 26zoef	|
    | bsart         | Eigenfertigung |
And I save the current editor


# ======================================================================
Scenario: Planpreisartikel ef
# ======================================================================
And I set the fake date to "4.4.02"

# ******** man. zugang mit eingabe wert/preis pp0->0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 24poef    |
	| beleg   | mpr.eq.0.0  |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp=0 mpr==0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 10  | f2     |
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "VIEW" for record "24poef"
Then field "mpr" has value "0.0000"
Then field "planpr1" has value "0.0000"
And I close the current editor


# ------------------- MPR fuer artikel 24poef erzeugen --------------------- 
Given I open an editor "Rechnung_24" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1    |
    | vom      | .          |
    | ueb      | ja         |
    | fakt     | ja         |
    | ebeleg   | x           |
| erfwaehr | EUR        |
    | budat    | .          |
And I append rows
    | artikel     | mge | preis | tterm	| ljtext1              |
    | 24poef      | 35  | 60,00 | +4	| pp>0 + erzeuge mpr>0 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ----------------- Planpreis1 MPR pruefen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "VIEW" for record "24poef"
Then field "mpr" has value "46.6667"
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> KEINE EINGABE **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 24poef    |
	| beleg   | mpr46.kEin |
	| beldat  | .       |
	| buart   | zugang  |
	| ljtext1 | pp==0 mpr=46.6667, keine einga. |
And I append rows
	| mge | platz2 |
	| 18  | f1     |
And I save the current editor
And I close the current editor

# ----------------- Planpreis1 erfassen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "24poef"
Then field "mpr" has value "46.6667"
Then field "planpr1" has value "0.0000"
And I set field "planpr1" to "24.0"
And I save the current editor

# ----------------- Planpreis1 MPR pruefen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "24poef"
Then field "mpr" has value "46.6667"
Then field "planpr1" has value "24.0000"
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> 0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 24poef    |
	| beleg   | pp.na.0 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp=24 mpr=46.6667 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 4   | f1     |
And I save the current editor
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> 20 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 24poef    |
	| beleg   | pp.na.20 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 20  |
	| ljtext1 | pp=24 mpr>0 eingabe 20 |
And I append rows
	| mge | platz2 |
	| 6   | f1     |
And I save the current editor
And I close the current editor


# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> KEINE EINGABE **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 24poef    |
	| beleg   | pp.kEin |
	| beldat  | .       |
	| buart   | zugang  |
	| ljtext1 | pp=24 mpr>0 keine einga. |
And I append rows
	| mge | platz2 |
	| 17  | f1     |
And I save the current editor
And I close the current editor


# ======================================================================
Scenario: vorgangspreisartikel ef
# ======================================================================
And I set the fake date to "4.4.02"

# ******** man. zugang mit eingabe wert/preis pp0->0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 25voef    |
	| beleg   | mpr.eq.0.0  |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp=0 mpr==0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 10  | f2     |
And I save the current editor
And I close the current editor

# ----------------- Planpreis1 erfassen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "25voef"
Then field "mpr" has value "0.0000"
Then field "planpr1" has value "0.0000"
And I set field "planpr1" to "25.0"
And I save the current editor

# ------------------- MPR fuer artikel 25voef erzeugen --------------------- 
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1    |
    | vom      | .          |
    | ueb      | ja         |
    | fakt     | ja         |
    | ebeleg   | x           |
    | erfwaehr | EUR        |
    | budat    | .          |
And I append rows
    | artikel     | mge | preis | tterm	| ljtext1              |
    | 25voef        | 35  | 65,00 | +4	| pp>0 + erzeuge mpr>0 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------- Planpreis1 pruefen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "25voef"
Then field "mpr" has value "50.5556"
Then field "planpr1" has value "25.0000"
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> 0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 25voef    |
	| beleg   | pp.na.0 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp>0 mpr>0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 4   | f1     |
And I save the current editor
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> 20 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 25voef    |
	| beleg   | pp.na.20 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 20  |
	| ljtext1 | pp>0 mpr>0 eingabe 20 |
And I append rows
	| mge | platz2 |
	| 6   | f1     |
And I save the current editor
And I close the current editor


# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> KEINE EINGABE **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 25voef    |
	| beleg   | pp.kEin |
	| beldat  | .       |
	| buart   | zugang  |
	| ljtext1 | pp>0 mpr>0 keine einga. |
And I append rows
	| mge | platz2 |
	| 17  | f1     |
And I save the current editor
And I close the current editor


# ======================================================================
Scenario: Nullpreisartikel ef
# ======================================================================
And I set the fake date to "4.4.02"

# ******** man. zugang mit eingabe wert/preis pp0->0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 26zoef    |
	| beleg   | mpr.eq.0.0  |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp=0 mpr==0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 10  | f2     |
And I save the current editor
And I close the current editor

# ----------------- Planpreis1 erfassen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "26zoef"
Then field "mpr" has value "0.0000"
Then field "planpr1" has value "0.0000"
And I set field "planpr1" to "26.0"
And I save the current editor

# ------------------- MPR fuer artikel 26zoef erzeugen --------------------- 
Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1    |
    | vom      | .          |
    | ueb      | ja         |
    | fakt     | ja         |
    | ebeleg   | x           |
    | erfwaehr | EUR        |
    | budat    | .          |
And I append rows
    | artikel     | mge | preis | tterm	| ljtext1              |
    | 26zoef        | 35  | 70,00 | +4	| pp>0 + erzeuge mpr>0 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------- Planpreis1 pruefen ---------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "26zoef"
Then field "mpr" has value "54.4444"
Then field "planpr1" has value "26.0000"
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> 0 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 26zoef    |
	| beleg   | pp.na.0 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 0  |
	| ljtext1 | pp>0 mpr>0 eingabe 0 |
And I append rows
	| mge | platz2 |
	| 4   | f1     |
And I save the current editor
And I close the current editor

# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> 20 **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 26zoef    |
	| beleg   | pp.na.20 |
	| beldat  | .       |
	| buart   | zugang  |
	| wert    | 20  |
	| ljtext1 | pp>0 mpr>0 eingabe 20 |
And I append rows
	| mge | platz2 |
	| 6   | f1     |
And I save the current editor
And I close the current editor


# ******** man. zugang mit eingabe wert/preis pp>0 + mpr>0 -> KEINE EINGABE **********
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel | 26zoef    |
	| beleg   | pp.kEin |
	| beldat  | .       |
	| buart   | zugang  |
	| ljtext1 | pp>0 mpr>0 keine einga. |
And I append rows
	| mge | platz2 |
	| 17  | f1     |
And I save the current editor
And I close the current editor

