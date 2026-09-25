# **********************************************************************************
#  Name             : Chargenverfolgung_Scenario03.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : bschiga
#  Funktion         : Chargenverfolgung manuell anlegen und Plausis testen
#  ref              : ref_chargenverfolgung_cu
#
# **********************************************************************************

@persistent
Feature: Chargenverfolgung_Scenario03.feature

Background:
And I set the fake date to "16.01.1995"

@Scenario03
Scenario: 03 Chargenverfolgung manuell anlegen und Plausis testen

Given I create a Lot "CHZU3-1" for Product "BG01_CHARGE"
Given I create a Lot "CHZU3-2" for Product "BG01_CHARGE"
Given I create a Lot "CHZUFALSCH2" for Product "BG02_CHARGE"
Given I create a Lot "CHAB3-1" for Product "EK01_CHARGE"
Given I create a Lot "CHABFALSCH2" for Product "EK02_CHARGE"

Given I create a work order "BA_CHVERF031" for Product "BG01_CHARGE" with quantity "50" and search word "CHVERF031_"
Given I create a work order "BA_CHVERF032" for Product "BG02_CHARGE" with quantity "50" and search word "CHVERF032_"
Given I create a work order "BA_CHVERF033" for Product "BG01_CHARGE" with quantity "50" and search word "CHVERF033_"

Given I open an editor "BA_CHVERF032_000" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "CHVERF032_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I close the current editor
And I switch the current editor to editor "BA_CHVERF032_000"
And I close the current editor

Given I open an editor "BA_CHVERF031_000" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "CHVERF031_000"
And I close the current editor

# Chargenverfolgung manuell anlegen
Given I open an editor "chverf_BG01_CHARGE_01" from table "(Lots):(LotTracking)" with command "NEW" for record ""
And I set field "fartikel" to "BG01_CHARGE"
# 3166 de Artikel stimmt nicht mit dem Artikel der Chargen-/Seriennummer ueberein
Then setting field "ncharge" to "CHZUFALSCH2" throws the exception "3166"
And I set field "ncharge" to "CHZU3-1"
# 3666 de Zugangsbewegung passt nicht zu Fertigteil.
Then setting field "zbeweg" in row 0 to "lres^id" from editor "BA_CHVERF032_000" in row 0 throws the exception "3666"
And I set field "zbeweg" to "lres^id" from editor "BA_CHVERF031_000"
And I set field "elex" to "EK01_CHARGE"
# 3166 de Artikel stimmt nicht mit dem Artikel der Chargen-/Seriennummer ueberein
Then setting field "vcharge" to "CHABFALSCH2" throws the exception "3166"
And I set field "vcharge" to "CHAB3-1"
# 3668 de Fertigungslistenelement passt nicht zur Reservierung.
Then setting field "reserv" in row 0 to saved value throws the exception "3668"
And I set field "reserv" to ""
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "manuell"
And I save the current editor

Given I open an editor "BA_CHVERF033_000" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "CHVERF033_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I close the current editor
And I switch the current editor to editor "BA_CHVERF033_000"
And I close the current editor

# Chargenverfolgung kopieren
Given I open an editor "chverf_BG01_CHARGE_02" from table "(Lots):(LotTracking)" with command "COPY" for record from editor "chverf_BG01_CHARGE_01"
# 3660 de Es ist bereits eine Chargenverfolgung fuer dieses Element vorhanden.
Then saving the current editor throws the exception "3660"
Then field "fartikel" is not modifiable
Then field "elex" is not modifiable
Then field "zbeweg" is not modifiable
Then field "reserv" is not modifiable
Then field "ncharge" is modifiable
Then field "vcharge" is modifiable
And I set field "ncharge" to "CHZU3-2"
Then field "vorgaenger^id" has value equal to field "id" from editor "chverf_BG01_CHARGE_01" in row 0
Then field "chverfherkunft" has value "manuell"
And I save the current editor

# Vorgaenger pruefen - gltbis muss gefuellt sein
Given I open an editor "chverf_BG01_CHARGE_01" from table "(Lots):(LotTracking)" with command "VIEW" for record from editor "chverf_BG01_CHARGE_01"
Then field "gltbis" is not empty
And I close the current editor

# Vorgaenger darf nicht kopiert werden, da er ungueltig ist.
# 3662 de Chargenverfolgung darf nicht kopiert werden, da sie nicht mehr gueltig ist.
Then opening an editor from table "(Lots):(LotTracking)" with command "COPY" for record from editor "chverf_BG01_CHARGE_01" throws the exception "3662"
And I close the current editor

# Noch eine neue Chargenverfolgung fuer weitere Tests anlegen
Given I open an editor "chverf_BG01_CHARGE_03" from table "(Lots):(LotTracking)" with command "NEW" for record ""
# Eingabereihenfolge muss zbeweg, fartikel sein, da es hier eine Diag gab
And I set field "zbeweg" to "lres^id" from editor "BA_CHVERF031_000"
And I set field "fartikel" to "BG01_CHARGE"
And I set field "ncharge" to "CHZU3-1"
And I set field "elex" to "EK01_CHARGE"
And I set field "vcharge" to "CHAB3-1"
# 3667 de Zugangsbewegung passt nicht zu Reservierung.
Then setting field "reserv" in row 0 to saved value throws the exception "3667"
And I set field "reserv" to ""
And I set field "zbeweg" to ""
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "manuell"
And I save the current editor

# Doublettenpruefung bei leerem zbeweg und reserv muss auch funktionieren
Given I open an editor "chverf_BG01_CHARGE_04" from table "(Lots):(LotTracking)" with command "COPY" for record from editor "chverf_BG01_CHARGE_03"
# 3660 de Es ist bereits eine Chargenverfolgung fuer dieses Element vorhanden.
Then saving the current editor throws the exception "3660"
And I close the current editor


@Scenario03
Scenario: 03a Chargenverfolgung fuer Koppelprodukt manuell anlegen

Given I create a Lot "CHZU4_BG" for Product "BG_CHARGE_KOPPEL"
Given I create a Lot "CHZU4_KOPPEL" for Product "KOPPELCHARGE"
Given I create a Lot "CHAB4_EK" for Product "EK01_CHARGE"

Given I create a work order "BA_CHVERF04" for Product "BG_CHARGE_KOPPEL" with quantity "50" and search word "CHVERF04_"

Given I open an editor "BA_CHVERF04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CHVERF04_000"
And I press button "absteig" to open a subeditor for "AFL"
And I set field "charge" to "!CHAB4_EK^id" in row 1
And I set field "charge" to "!CHZU4_KOPPEL^id" in row 2
And I save value from field "id" in row 2
And I save the current editor
And I switch the current editor to editor "BA_CHVERF04"
And I save the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 1, Zugang Koppelprodukt
Given I open an editor "RM_CHVERF04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=CHVERF04_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge   | !CHZU4_BG^id  |
    | sofort    | ja            |
    | bem       | RM1_CHVERF04  |
And I modify table
    | !row  | gutmge    | erbtext1      |
    | 1     | 15        | RM1_CHVERF04  |
And I save the current editor

Given I open an editor "chverf_BG01_CHARGE_04" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==CHZU4_BG;vcharge^exnum==CHAB4_EK;elex==EK01_CHARGE;"
And I close the current editor

# Chargenverfolgung manuell anlegen fuer Koppelprodukt
# zbeweg ist hier NICHT der FV, sondern die Reservierung des Koppelprodukts aus dem FV der Baugruppe, da Koppelprodukt daraus entstanden ist
Given I open an editor "chverf_KOPPELCHARGE" from table "(Lots):(LotTracking)" with command "NEW" for record ""
# Reservierung in reserv darf kein Koppelprodukt oder Umbauartikel enthalten
Then setting field "reserv" in row 0 to saved value throws the exception "3755"
And I set field "reserv" to "!chverf_BG01_CHARGE_04^reserv^id"
# Wenn zbeweg eine Reservierung enthaelt, dann muss diese fuer Koppelprodukt oder Umbauartikel sein
Then setting field "zbeweg" to "!chverf_BG01_CHARGE_04^reserv^id" in row 0 throws the exception "3756"
And I set field "zbeweg" in row 0 to saved value
Then field "reserv" is empty
Then field "reserv" is not modifiable
And I set field "fartikel" to "KOPPELCHARGE"
And I set field "ncharge" to "CHZU4_KOPPEL"
And I set field "elex" to "EK01_CHARGE"
And I set field "vcharge" to "vcharge^id" from editor "chverf_BG01_CHARGE_04"
Then field "gltvon" is not empty
Then field "gltbis" is empty
Then field "chverfherkunft" has value "manuell"
And I save the current editor
Then field "erfasserzeichen" has value "SY"
And I close the current editor
