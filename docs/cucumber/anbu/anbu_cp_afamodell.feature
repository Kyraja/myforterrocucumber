# *********************************************************************************************************
#  Name             : anbu_cp_afamodell.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : ersetzt Lader CPAFAMOD.LAD in Test ref_anbu_2bukreise
#
#
# *********************************************************************************************************

@persistent
Feature: Anlagenbuchhaltung mit zwei Buchungskreisen
Background:
And I enable the flag 93

Scenario:


# Auskommentierte Zeilen beschreiben Aktionen, welche im Lader Fehler verursachen
# während sie in Cucumber ohne Fehler ablaufen (Then setting field "selbukreis" to ...)
# oder nicht ausgef�hrt werden k�nnen (speichern und schlie�en des subeditors für Button bafamodell (zuvor bereits Fehler beim öffnen des Subeditors))


Given I open an editor "anl-135002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "135002"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "52800.00" throws the exception "551"
Then setting field "erafa" to "39600.00" throws the exception "551"
Then setting field "nmon" to "72" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-710001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "710001"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "138600.00" throws the exception "551"
Then setting field "erafa" to "0.00" throws the exception "551"
Then setting field "nmon" to "1212" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-240001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240001"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "379500.00" throws the exception "551"
Then setting field "erafa" to "96965.00" throws the exception "551"
Then setting field "nmon" to "312" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-240002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240002"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "270600.00" throws the exception "551"
Then setting field "erafa" to "145222.00" throws the exception "551"
Then setting field "nmon" to "612" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-240003" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240003"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "290400.00" throws the exception "551"
Then setting field "erafa" to "188760.00" throws the exception "551"
Then setting field "nmon" to "612" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-240004" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240004"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "275000.00" throws the exception "551"
Then setting field "erafa" to "151250.00" throws the exception "551"
Then setting field "nmon" to "312" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-240005" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "240005"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "138600.00" throws the exception "551"
Then setting field "erafa" to "3234.00" throws the exception "551"
Then setting field "nmon" to "312" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-215001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "215001"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "110000.00" throws the exception "551"
Then setting field "erafa" to "0.00" throws the exception "551"
Then setting field "nmon" to "1212" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-235001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "235001"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "165000.00" throws the exception "551"
Then setting field "erafa" to "0.00" throws the exception "551"
Then setting field "nmon" to "1212" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-235002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "235002"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "88000.00" throws the exception "551"
Then setting field "erafa" to "0.00" throws the exception "551"
Then setting field "nmon" to "612" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-235003" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "235003"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "132000.00" throws the exception "551"
Then setting field "erafa" to "0.00" throws the exception "551"
Then setting field "nmon" to "1212" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-235004" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "235004"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "99000.00" throws the exception "551"
Then setting field "erafa" to "0.00" throws the exception "551"
Then setting field "nmon" to "612" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-235005" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "235005"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "88000.00" throws the exception "551"
Then setting field "erafa" to "0.00" throws the exception "551"
Then setting field "nmon" to "1212" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-670001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "670001"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "5500.00" throws the exception "551"
Then setting field "erafa" to "5498.90" throws the exception "551"
Then setting field "nmon" to "24" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-670002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "670002"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "2200.00" throws the exception "551"
Then setting field "erafa" to "2198.90" throws the exception "551"
Then setting field "nmon" to "24" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-670003" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "670003"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "3850.00" throws the exception "551"
Then setting field "erafa" to "3848.90" throws the exception "551"
Then setting field "nmon" to "24" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-440001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440001"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "99000.00" throws the exception "551"
Then setting field "erafa" to "90514.60" throws the exception "551"
Then setting field "nmon" to "108" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-440002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440002"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "99000.00" throws the exception "551"
Then setting field "erafa" to "93453.80" throws the exception "551"
Then setting field "nmon" to "108" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-440003" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440003"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "97218.00" throws the exception "551"
Then setting field "erafa" to "97216.90" throws the exception "551"
Then setting field "nmon" to "252" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-440004" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440004"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "73920.00" throws the exception "551"
Then setting field "erafa" to "73918.90" throws the exception "551"
Then setting field "nmon" to "252" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-440005" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440005"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "176000.00" throws the exception "551"
Then setting field "erafa" to "175998.90" throws the exception "551"
Then setting field "nmon" to "252" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-440006" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "440006"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "220000.00" throws the exception "551"
Then setting field "erafa" to "219998.90" throws the exception "551"
Then setting field "nmon" to "252" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-520001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520001"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "40258.90" throws the exception "551"
Then setting field "erafa" to "15499.00" throws the exception "551"
Then setting field "nmon" to "72" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-520002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520002"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "44000.00" throws the exception "551"
Then setting field "erafa" to "41066.70" throws the exception "551"
Then setting field "nmon" to "72" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-520003" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520003"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "82058.90" throws the exception "551"
Then setting field "erafa" to "39897.00" throws the exception "551"
Then setting field "nmon" to "72" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-520004" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520004"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "43404.66" throws the exception "551"
Then setting field "erafa" to "43403.56" throws the exception "551"
Then setting field "nmon" to "72" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-520005" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "520005"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "550678.66" throws the exception "551"
Then setting field "erafa" to "8535.76" throws the exception "551"
Then setting field "nmon" to "72" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-690001" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "690001"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "29447.00" throws the exception "551"
Then setting field "erafa" to "27454.90" throws the exception "551"
Then setting field "nmon" to "60" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-690002" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "690002"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "12265.00" throws the exception "551"
Then setting field "erafa" to "7876.00" throws the exception "551"
Then setting field "nmon" to "60" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-690003" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "690003"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "6336.00" throws the exception "551"
Then setting field "erafa" to "1584.00" throws the exception "551"
Then setting field "nmon" to "60" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-690004" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "690004"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "6547.20" throws the exception "551"
Then setting field "erafa" to "5456.00" throws the exception "551"
Then setting field "nmon" to "60" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-690005" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "690005"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "9768.00" throws the exception "551"
Then setting field "erafa" to "5907.00" throws the exception "551"
Then setting field "nmon" to "60" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-690006" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "690006"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "6820.00" throws the exception "551"
Then setting field "erafa" to "1705.00" throws the exception "551"
Then setting field "nmon" to "60" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "anl-690007" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "690007"
And I set field "selbukreis" to "IFRS"
# Then setting field "selbukreis" to "IFRS" throws the exception "550"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "2619"
Then setting field "kpbukreis" to "HGB" throws the exception "550"
Then pressing button "kpafmod" in row 0 throws the exception "550"
Then setting field "erzuab" to "12566.40" throws the exception "551"
Then setting field "erafa" to "2517.90" throws the exception "551"
Then setting field "nmon" to "60" throws the exception "551"
# Then saving the current editor throws the exception "550"
# And I close the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor


