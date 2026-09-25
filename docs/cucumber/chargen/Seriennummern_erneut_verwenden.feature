@persistent
Feature: Seriennummer_erneut_verwenden.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Seriennummer_erneut_verwenden.feature
#  Autor            : bschiga
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Testet erneutes Verwenden von Seriennummern in der Fertigung
#  ref              : ref_seriennr_erneut_verwenden_cu
#
# **********************************************************************************

Scenario: Chargenpflicht in Konfiguration einschalten

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | chpflicht   | ja  |
And I save the current editor


Scenario: Artikel mit Seriennummer für zusätzlich Entnahme anlegen

Given I open an editor "ZUSENT" from table "(Part):(Product)" with command "COPY" for search criteria "$,,such=EK01_SNR;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | such | ZUSENT01_SNR |
And I save the current editor


Scenario: SNR54 Seriennummer erneut verwenden in der Fertigung - Rückmeldung und Materialentnahme ohne MZ

# Benötigte Chargen anlegen
Given I create a Lot "SNR54ZU1" for Product "BG01_SNR"
Given I create a Lot "SNR54AB1" for Product "EK01_SNR"

Given I create a work order "SNR54" for Product "BG01_SNR" with quantity "5" and search word "SNR54_"

Given I open an editor "BA_SNR54" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR54_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA_SNR54"
And I save the current editor

# Rueckmeldung auf Arbeitsschein 2 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR54" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR54_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge   | SNR54ZU1  |
    | sofort    | ja        |
    | bem       | RM1_SNR54 |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_SNR54" in row 1
And I save the current editor

# Abgang buchen, damit die SNR erneut zugebucht werden kann
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG01_SNR      |
    | buart     | Abgang        |
    | beleg     | LBUA1_SNR54   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1   |
    | 1      | F1       | SNR54ZU1  |
And I save the current editor

# Rueckmeldung auf Arbeitsschein 2 mit der bereits verwendeten Seriennummer
Given I open an editor "RM1_SNR54" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR54_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge           | SNR54ZU1  |
    | ksnerneutverwend  | ja        |
    | sofort            | ja        |
    | bem               | RM2_SNR54 |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM2_SNR54" in row 1
And I save the current editor

Given I open an editor "JournalZuRM2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG01_SNR;buarta==Zugang;erbtext1==RM2_SNR54;"
And I close the current editor

# LJ-Eintrag in der Seriennummer gehoert zur zweiten Buchung
Given I open an editor "SNR54ZU1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR54ZU1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel        | BG01_SNR                  |
    | sngebzugang^id | !JournalZuRM2^id          |
And I close the current editor

# im gebuchten Rueckmeldebeleg ist ersichtlich, dass die SNR erneut verwendet wurde
Given I open an editor "RM2Pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SNR54_002;bem=RM2_SNR54;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "ksnerneutverwend" has value "ja"
And I close the current editor

# Material zubuchen, damit Materialentnahme nicht zu negativem Bestand fuehrt
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZ1_SNR54   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   |
    | 1      | F1       | SNR54AB1  |
And I save the current editor

Given I open an editor "FBU1_SNR54" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR54_001  |
    | charge    | SNR54ZU1   |
    | bem       | FBU1_SNR54 |
And I press button "stlvblad"
And I modify table
    | !row  | bumge | rescharge |
    | 1     | 1     | SNR54AB1  |
And I save the current editor

# Material wieder zubuchen, damit Materialentnahme erneut mit gleicher SNR moeglich ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZ2_SNR54   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   | snerneutverwend   |
    | 1      | F1       | SNR54AB1  | ja                |
And I save the current editor

# wieder zugebuchte SNR erneut verwenden
Given I open an editor "FBU2_SNR54" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR54_001  |
    | charge    | SNR54ZU1   |
    | bem       | FBU2_SNR54 |
And I press button "stlvblad"
And I modify table
    | !row  | bumge | rescharge | snerneutverwend   | ljtext1       |
    | 1     | 1     | SNR54AB1  | ja                | FBU2_SNR54    |
And I save the current editor

Given I open an editor "JournalAbFBU2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Abgang;erbtext1==FBU2_SNR54;"
And I close the current editor

# LJ-Eintrag in der Seriennummer gehoert zur zweiten Buchung
Given I open an editor "SNR54AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR54AB1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel        | EK01_SNR          |
    | sngebabgang^id | !JournalAbFBU2^id |
And I close the current editor

# im gebuchten Rueckmeldebeleg ist ersichtlich, dass die SNR erneut verwendet wurde
Given I open an editor "FBU2Pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SNR54_001;bem=FBU2_SNR54;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "snerneutverwend" has value "ja" in row 2
And I close the current editor


Scenario: SNR55 Seriennummer erneut verwenden in der Fertigung - Rueckmeldung mit zusaetzlicher Entnahme

# Benötigte Chargen anlegen
Given I create a Lot "SNR55ZU1" for Product "BG01_SNR"
Given I create a Lot "SNR55ZU2" for Product "BG01_SNR"
Given I create a Lot "SNR55AB1" for Product "ZUSENT01_SNR"
Given I create a Lot "SNR55ZUK" for Product "KOPPEL_SNR"

Given I create a work order "SNR55" for Product "BG01_SNR" with quantity "5" and search word "SNR55_"

# Material zubuchen, damit Materialentnahme nicht zu negativem Bestand führt
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ZUSENT01_SNR  |
    | buart     | Zugang        |
    | beleg     | LBUZ1_SNR55   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   |
    | 1      | F1       | SNR55AB1  |
And I save the current editor

# Rueckmeldung mit zusaetzlicher Entnahme
Given I open an editor "RMZUSATZ_SNR55" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR55_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge           | SNR55ZU1       |
    | sofort            | ja             |
    | bem               | RMZUSATZ_SNR55 |
And I set field "gutmge" to "1" in row 1
And I append rows
    | artikel      | mge  | charge    | kompeig       |
    | ZUSENT01_SNR | 1    | SNR55AB1  | !dontChange   |
    | KOPPEL_SNR   | 1    | SNR55ZUK  | Koppelprodukt |
And I save the current editor

# Material wieder zubuchen, damit Entnahme erneut mit gleicher SNR moeglich ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ZUSENT01_SNR  |
    | buart     | Zugang        |
    | beleg     | LBUZ2_SNR55   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   | snerneutverwend   |
    | 1      | F1       | SNR55AB1  | ja                |
And I save the current editor

# Koppelprodukt wieder abbuchen, damit Zugang erneut mit gleicher SNR moeglich ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | KOPPEL_SNR    |
    | buart     | Abgang        |
    | beleg     | LBUA2_SNR55   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1   |
    | 1      | F1       | SNR55ZUK  |
And I save the current editor

# Rueckmeldung mit zusaetzlicher Entnahme und SNR erneut verwenden
Given I open an editor "RMZUSATZ2_SNR55" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR55_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge           | SNR55ZU2        |
    | sofort            | ja              |
    | bem               | RMZUSATZ2_SNR55 |
And I set field "gutmge" to "1" in row 1
And I append rows
    | artikel      | mge  | charge    | snerneutverwend   | erbtext1          |
    | ZUSENT01_SNR | 1    | SNR55AB1  | ja                | RMZUSATZ2_SNR55   |
    | KOPPEL_SNR   | 1    | SNR55ZUK  | ja                | RMZUSATZK_SNR55   |
And I save the current editor

Given I open an editor "JournalAbZUSATZ2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==ZUSENT01_SNR;buarta==Abgang;erbtext1==RMZUSATZ2_SNR55;"
And I close the current editor

# LJ-Eintrag in der Seriennummer gehoert zur zweiten Buchung
Given I open an editor "SNR55AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR55AB1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel        | ZUSENT01_SNR          |
    | sngebabgang^id | !JournalAbZUSATZ2^id  |
And I close the current editor

# im gebuchten Rueckmeldebeleg ist ersichtlich, dass die SNR erneut verwendet wurde
Given I open an editor "RMZUSATZ2Pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SNR55_002;bem=RMZUSATZ2_SNR55;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "snerneutverwend" has value "ja" in row 2
And I close the current editor


Scenario: SNR56 Seriennummer erneut verwenden in der Fertigung - Rückmeldung und Materialentnahme mit zusätzlicher Entnahme

# Benötigte Chargen anlegen
Given I create a Lot "SNR56ZU1" for Product "BG01_SNR"
Given I create a Lot "SNR56AB1" for Product "EK01_SNR"
Given I create a Lot "SNR56ABZ" for Product "ZUSENT01_SNR"
Given I create a Lot "SNR56ZUK" for Product "KOPPEL_SNR"

Given I create a work order "SNR56" for Product "BG01_SNR" with quantity "5" and search word "SNR56_"

Given I open an editor "BA_SNR56" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR56_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA_SNR56"
And I save the current editor

# Rueckmeldung auf Arbeitsschein 2 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR56" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR56_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge   | SNR56ZU1  |
    | sofort    | ja        |
    | bem       | RM1_SNR56 |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_SNR56" in row 1
And I save the current editor

# Material zubuchen, damit Materialentnahme nicht zu negativem Bestand fuehrt
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZ1_SNR56   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   |
    | 1      | F1       | SNR56AB1  |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ZUSENT01_SNR  |
    | buart     | Zugang        |
    | beleg     | LBUZE_SNR56   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   |
    | 1      | F1       | SNR56ABZ  |
And I save the current editor

Given I open an editor "FBU1_SNR56" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR56_001  |
    | charge    | SNR56ZU1   |
    | bem       | FBU1_SNR56 |
And I press button "stlvblad"
And I set field "bumge" to "1" in row 1
And I set field "rescharge" to "SNR56AB1" in row 1
And I append rows
    | elex         | bumge | rescharge | kompeig       |
    | ZUSENT01_SNR | 1     | SNR56ABZ  | !dontChange   |
    | KOPPEL_SNR   | 1     | SNR56ZUK  | Koppelprodukt |
And I save the current editor

# Material wieder zubuchen, damit Materialentnahme erneut mit gleicher SNR moeglich ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | ZUSENT01_SNR  |
    | buart     | Zugang        |
    | beleg     | LBUZE_SNR56   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   | snerneutverwend   |
    | 1      | F1       | SNR56ABZ  | ja                |
And I save the current editor

# Koppelprodukt wieder abbuchen, damit Zugang erneut mit gleicher SNR moeglich ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | KOPPEL_SNR    |
    | buart     | Abgang        |
    | beleg     | LBUA2_SNR56   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1   |
    | 1      | F1       | SNR56ZUK  |
And I save the current editor

# wieder zugebuchte SNR erneut verwenden
Given I open an editor "FBU2_SNR56" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR56_001  |
    | charge    | SNR56ZU1   |
    | bem       | FBU2_SNR56 |
And I press button "stlvblad"
Then table has values
    | !row  | elex         | kompeig       |
    | 1     | EK01_SNR     |               |
    | 2     | KOPPEL_SNR   | Koppelprodukt |
    | 3     | ZUSENT01_SNR |               |
And I modify table
    | !row  | bumge | rescharge   | snerneutverwend |
    | 1     | 0     | !dontChange | !dontChange     |
    | 2     | 1     | SNR56ZUK    |              ja |
    | 3     | 1     | SNR56ABZ    |              ja |
And I save the current editor

# im gebuchten Rueckmeldebeleg ist ersichtlich, dass die SNR erneut verwendet wurde
Given I open an editor "FBU2Pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SNR56_001;bem=FBU2_SNR56;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "snerneutverwend" has value "ja" in row 2
Then field "snerneutverwend" has value "ja" in row 3
And I close the current editor


Scenario: SNR57 Seriennummer erneut verwenden in der Fertigung - Materialentnahme mit MZ

# Benötigte Chargen anlegen
Given I create a Lot "SNR57ZU1" for Product "BG01_SNR"
Given I create a Lot "SNR57AB1" for Product "EK01_SNR"
Given I create a Lot "SNR57AB2" for Product "EK01_SNR"
Given I create a Lot "SNR57AB3" for Product "EK01_SNR"

Given I create a work order "SNR57" for Product "BG01_SNR" with quantity "5" and search word "SNR57_"

Given I open an editor "BA_SNR57" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SNR57_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "BA_SNR57"
And I save the current editor

# Material zubuchen, damit Materialentnahme nicht zu negativem Bestand fuehrt
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZ1_SNR57   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   |
    | 1      | F1       | SNR57AB1  |
    | 1      | F1       | SNR57AB2  |
    | 1      | F1       | SNR57AB3  |
And I save the current editor

Given I open an editor "FBU1_SNR57" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR57_001  |
    | charge    | SNR57ZU1   |
    | bem       | FBU1_SNR57 |
And I press button "stlvblad"
And I set field "bumge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | zuomge    | charge    |
    | 1     | 1         | SNR57AB1  |
    | 2     | 1         | SNR57AB2  |
And I save the current editor
And I switch the current editor to editor "FBU1_SNR57"
And I save the current editor

# Material wieder zubuchen, damit Materialentnahme erneut mit gleicher SNR moeglich ist
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_SNR      |
    | buart     | Zugang        |
    | beleg     | LBUZ2_SNR57   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2   | snerneutverwend |
    | 1      | F1       | SNR57AB1  | ja              |
And I save the current editor

# wieder zugebuchte SNR erneut verwenden
Given I open an editor "FBU2_SNR57" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | SNR57_001  |
    | charge    | SNR57ZU1   |
    | bem       | FBU2_SNR57 |
And I press button "stlvblad"
And I set field "bumge" to "2" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | zuomge    | charge    | snerneutverwend   | platz | ljtext1       |
    | 1     | 1         | SNR57AB1  | ja                | F4    | FBU2_Z1_SNR57 |
    | 2     | 1         | SNR57AB3  | !dontChange       | F1    | FBU2_Z2_SNR57 |
And I save the current editor
And I switch the current editor to editor "FBU2_SNR57"
And I save the current editor

Given I open an editor "JournalAbFBU2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_SNR;buarta==Abgang;platz==F4;"
And I close the current editor

# LJ-Eintrag in der Seriennummer gehoert zur zweiten Buchung
Given I open an editor "SNR57AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR57AB1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel        | EK01_SNR          |
    | sngebabgang^id | !JournalAbFBU2^id |
And I close the current editor

# im gebuchten Rueckmeldebeleg ist ersichtlich, dass die SNR erneut verwendet wurde
Given I open an editor "FBU2Pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SNR57_001;bem=FBU2_SNR57;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 2
Then field "snerneutverwend" has value "ja" in row 1
And I close the current editor
And I switch the current editor to editor "FBU2Pruef"
And I close the current editor


Scenario: SNR58 Seriennummer erneut verwenden in der BDE Auftragszeit

# Benötigte Chargen anlegen
Given I create a Lot "SNR58ZU1" for Product "BG01_SNR"

Given I create a work order "SNR58" for Product "BG01_SNR" with quantity "5" and search word "SNR58_"

# Rueckmeldung auf Arbeitsschein 2 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR58" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR58_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge   | SNR58ZU1  |
    | sofort    | ja        |
    | bem       | RM1_SNR58 |
And I set field "gutmge" to "1" in row 1
And I set field "erbtext1" to "RM1_SNR58" in row 1
And I save the current editor

# Abgang buchen, damit die SNR erneut zugebucht werden kann
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG01_SNR      |
    | buart     | Abgang        |
    | beleg     | LBUA1_SNR58   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1   |
    | 1      | F1       | SNR58ZU1  |
And I save the current editor

Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma                | KARL      |
    | asma              | SNR58_002 |
    | anfdat            | .         |
    | anfzeit           | 08:00     |
    | enddat            | .         |
    | endzeit           | 08:45     |
    | istmge            | 1         |
    | charge            | SNR58ZU1  |
    | ksnerneutverwend  | ja        |
    | erbtext1          | PDC_SNR58 |
    | sofort            | ja        |
And I save the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==BG01_SNR;buarta==Zugang;erbtext1==PDC_SNR58;"
And I close the current editor

# LJ-Eintrag in der Seriennummer gehoert zur zweiten Buchung
Given I open an editor "SNR58ZU1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR58ZU1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel        | BG01_SNR          |
    | sngebzugang^id | !JournalZu2^id    |
And I close the current editor

# im gebuchten Rueckmeldebeleg ist ersichtlich, dass die SNR erneut verwendet wurde
Given I open an editor "RMPDCPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SNR58_002;ma^such=KARL;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "ksnerneutverwend" has value "ja"
And I close the current editor
