# *****************************************************************************
#  Name             : anbu_anl_aend.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Daten fuer den Test ref_anl_aend erzeugen
#
# *****************************************************************************

@persistent
Feature: ANBU Fehler
Background: Test des Editors fuer Anlage

Given I set the fake date to "01.01.94"

Given I'm logged in with password "sy"


Scenario: Anlegen einer lineare Abschreibung

Given I open an editor "abschreibungsart-1" from table "(FixedAsset):(DepreciationMethod)" with command "NEW" for record ""

And I set field "nummer" to "100"
And I set field "such" to "Linear"
And I set field "name" to "Lineare Abschreibung"
And I set field "afako" to "62200"
And I set field "rart" to "Restbuchwert/Restnutzungsdauer"
And I save the current editor
And I close the current editor

# Scenario: Anlegen einer degressiven Abschreibung

Given I open an editor "abschreibungsart-2" from table "(FixedAsset):(DepreciationMethod)" with command "NEW" for record ""
And I set field "nummer" to "110"
And I set field "such" to "Degress"
And I set field "name" to "Degressive Abschreibung"
And I set field "afako" to "62200"
And I set field "umafa" to "100"
And I set field "rart" to "Restbuchwert/Restnutzungsdauer"
And I create a new row at the end of the table
And I set field "vj" to "1" in row 1
And I set field "bj" to "10" in row 1
And I set field "afapz" to "10" in row 1
And I save the current editor
And I close the current editor

# Scenario: Anlagekategorie anlegen

Given I open an editor "anlkat-1" from table "(FixedAsset):(FixedAssetGroup)" with command "NEW" for record ""
And I set field "nummer" to "600"
And I set field "such" to "FP"
And I set field "name" to "Fuhrpark"
And I set field "verd" to "05200"
And I set field "kstelle" to "100"
And I set field "nmon" to "120"
And I set field "erinnerwert" to "1"
Then setting field "hwaehr" to "EUR" throws the exception "203"
And I create a new row at the end of the table
And I set field "wgafa" to "100" in row !lastRow
And I create a new row at the end of the table
And I set field "wgafa" to "110" in row !lastRow
And I save the current editor
And I close the current editor

Given I open an editor "anl-610" from table "(FixedAsset):(FixedAssetGroup)" with command "COPY" for record "600"
And I set field "nummer" to "610"
And I set field "name" to "Wagenpark"
And I set field "nmon" to "50"
And I set field "nmon" to "60"
And I save the current editor
And I respond with answer "nein" to the dialog with id ""

# Scenario: Anlage anlegen

Given I open an editor "anl-1000" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "1000"
And I set field "such" to "BENZ"
And I set field "name" to "KA-AB 993"
And I press button "bafamodell" to open a subeditor for "anl-1000-afamod"
And I set field "wg" to "600"
And I set field "andat" to "15.01.1992"
And I set field "afadat" to "01.01.1992"
And I set field "nmon" to "120"
And I set field "erzuab" to "10000"
And I set field "erafa" to "3000"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

# Anlage anlegen

Given I open an editor "anl-1010" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "1010"
And I set field "such" to "VW"
And I set field "name" to "KA-RL 838"
And I press button "bafamodell" to open a subeditor for "anl-1010-afamod"
And I set field "wg" to "600"
And I set field "andat" to "."
And I set field "andat" to "15.01.1995"
And I set field "nmon" to "120"
And I set field "uebahk" to "10000"
And I set field "erinnerwert" to "1.00"
And I respond with answer "ja" to the dialog with id ""
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

# =======================================================
# Scenario: �nderung von Abschreibungen

Given I open an editor "anl-101" from table "(FixedAsset):(DepreciationMethod)" with command "UPDATE" for record "100"
And I set field "nummer" to "101"
And I set field "such" to "LINEAR2"
And I set field "name" to "Lineare Abschreibung - alt"
And I set field "afako" to "62000"
And I set field "rart" to "Restbuchwert/Restnutzungsdauer"
And I create a new row at the end of the table
And I set field "vj" to "1" in row !lastRow
And I set field "bj" to "10" in row !lastRow
And I set field "afapz" to "12" in row !lastRow
And I save the current editor
And I close the current editor

# =======================================================
# Scenario: �nderung von Wirtschaftsg�tern

Given I open an editor "anl-601" from table "(FixedAsset):(FixedAssetGroup)" with command "UPDATE" for record "600"
And I set field "nummer" to "601"
And I set field "such" to "FP2"
And I set field "name" to "Fuhrpark alt"
And I set field "verd" to "05600"
Then setting field "kost" to "ja" throws the exception "550"
Then setting field "hkost" to "ja" throws the exception "550"
And I set field "kstelle" to "100"
And I set field "nmon" to "600"
And I set field "erinnerwert" to "1000"
And I delete row at position 1
And I create a new row at position 1
Then setting field "wgafa" to "100" in row 1 throws the exception "100: nicht gefunden"
And I delete row at position 1
And I create a new row at position 2
Then setting field "wgafa" to "100" in row 2 throws the exception "100: nicht gefunden"
# Then saving the current editor throws the exception "100: nicht gefunden"
# Fehler sollte beim speichern geworfen werden. Laderskript wirft hier einen Fehler, Cucumber nicht.
# Um die gleiche Ausgabe zu erzeugen werden die Änderungen hier nicht gespeichert
And I close the current editor

#########################################################
# =======================================================
# Scenario: �nderung von Anlagen

# Das Öffnen der Anlage 1000 wirft im Test des Laders einen Fehler ("1000: nicht gefunden") obwohl die Anlage im Mandanten vorhanden ist. 
# Cucumber wirft hier keinen Fehler:

# Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "1000" throws the exception "1000: nicht gefunden"
Given I open an editor "" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "1000"

# Gleiches gilt für die meisten Änderungen nach dem Öffnen der Anlage (lediglich die Felder "kost" und "versich" verursachen auch in Cucumber fehler):

# Then setting field "nummer" to "2000" throws the exception "unzul�„ssige Angabe"
# Then setting field "such" to "Daimler" throws the exception "unzul�„ssige Angabe"
# Then setting field "name" to "KA-IE 8832" throws the exception "unzul�„ssige Angabe"
# Then setting field "kost" to "ja" throws the exception "550"
# Then setting field "versich" to "2" throws the exception "203"
# Then setting field "kenn" to "Abgeschafft" throws the exception "unzul�„ssige Angabe"
# Then setting field "beleg" to "100" throws the exception "unzul�„ssige Angabe"
# Then setting field "beldat" to "19.02.99" throws the exception "unzul�„ssige Angabe"
# Then setting field "liefer" to "1" throws the exception "unzul�„ssige Angabe"
# Then saving the current editor throws the exception "unzul�„ssige Angabe"

And I set field "nummer" to "2000"
And I set field "such" to "Daimler"
And I set field "name" to "KA-IE 8832"
Then setting field "kost" to "ja" throws the exception "550"
Then setting field "versich" to "2" throws the exception "203"
And I set field "kenn" to "Abgeschafft"
And I set field "beleg" to "100"
And I set field "beldat" to "19.02.99"
And I set field "liefer" to "1"
# Um die Ausgabe gegenüber dem Lader nicht zu verändern, werden die Änderungen nicht gespeichert.
# And I save the current editor
And I close the current editor

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "2000" throws the exception "2000: nicht gefunden" 
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "5322"
Then setting field "wg" to "610" throws the exception "1771"
Then setting field "bilkto" to "05600" throws the exception "1771"
Then setting field "kstelle" to "101" throws the exception "1771"
Then setting field "afaart" to "110" throws the exception "1771"
Then setting field "afako" to "62000" throws the exception "1771"
Then setting field "elanzahl" to "5" throws the exception "1771"
Then setting field "ve" to "ja" throws the exception "1771"
Then setting field "andat" to "15.02.1992" throws the exception "1771"
Then setting field "uebahk" to "11000" throws the exception "1771"

Then setting field "afadat" to "01.02.1992" throws the exception "1771"
Then setting field "nmon" to "144" throws the exception "1771"
Then setting field "erinnerwert" to "100" throws the exception "1771"
Then setting field "erzuab" to "15000" throws the exception "1771"
Then setting field "erafa" to "5000" throws the exception "1771"
Then setting field "w2ist" to "dem" throws the exception "1771"
Then setting field "w2ist" to "eur" throws the exception "1771"
Then setting field "abbetr" to "10000" throws the exception "1771"
Then setting field "abdat" to "31.01.1995" throws the exception "1771"
Then setting field "gewinn" to "5000" throws the exception "1771"
Then setting field "verlust" to "5000" throws the exception "1771"
Then setting field "abertrag" to "8000" throws the exception "1771"
Then setting field "upbetr" to "1000" throws the exception "1771"
Then setting field "afaart" to "" throws the exception "1771"
Then setting field "gewko" to "50000" throws the exception "1771"
Then setting field "verko" to "50000" throws the exception "1771"
Then setting field "erlko" to "50000" throws the exception "1771"

Then setting field "safavm" to "1" in row 1 throws the exception "1771"
Then setting field "safavgj" to "94" in row 1 throws the exception "1771"
Then setting field "safabm" to "12" in row 1 throws the exception "1771"
Then setting field "safabgj" to "95" in row 1 throws the exception "1771"
Then setting field "safako" to "62200" in row 1 throws the exception "1771"
Then setting field "safapr" to "100" in row 1 throws the exception "1771"
Then setting field "safapr" to "20" in row 1 throws the exception "1771"
Then setting field "safabasis" to "50000" in row 1 throws the exception "1771"
# Gemäß Laderfehlerdatei sollte das erste save (subeditor bafamodell) einen Fehler werfen, das Zweite nicht
# In Cucumber ist dies umgekehrt:
# And I save the current subeditor to switch back to the parent editor
# Then saving the current editor throws the exception "Kommando nicht erlaubt"
Then saving the current editor throws the exception "1771"
And I close the current subeditor to switch back to the parent editor
# And I save the current editor
And I close the current editor

# ------------------------------
# Scenario: �nderung der Altdaten

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "2000" throws the exception "2000: nicht gefunden"
Then saving the current editor throws the exception "1771"
And I close the current editor

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "2000" throws the exception "2000: nicht gefunden"
Then pressing button "bafamodell" in row 0 to open a subeditor throws the exception "5322"
Then setting field "erzuab" to "15000" throws the exception "1771"
Then setting field "erafa" to "5000" throws the exception "1771"
# Gemäß Laderfehlerdatei sollte das erste save (subeditor bafamodell) einen Fehler werfen, das Zweite nicht
# In Cucumber ist dies umgekehrt:
# And I save the current subeditor to switch back to the parent editor
# Then saving the current editor throws the exception "Kommando nicht erlaubt"
Then saving the current editor throws the exception "1771"
And I close the current subeditor to switch back to the parent editor
# And I save the current editor
And I close the current editor

# ==================================================
# Anlage mit Zubuchungen, bei der nachtr�glich das Anschaffungsdatum 
# ge�ndert wird. 
# �nderung des Anschaffungsdatums nur per Wartung m�glich!!
# --------------------------------------------------

Given I open an editor "anl-2000X" from table "(FixedAsset):(FixedAsset)" with command "NEW" for record ""
And I set field "nummer" to "2000X"
And I set field "such" to "ANLZUB"
And I set field "name" to "Anlagen mit Zubuchung und geõndertem Anschaffungsdatum"
And I press button "bafamodell" to open a subeditor for "anl-2000X-afamod"
And I set field "kstelle" to "100"
And I set field "bilkto" to "05200"
Then setting field "afaart" to "100" throws the exception "100: nicht gefunden"

# Ändern der Feldwerte verursacht im Lader Fehler, bei Cucumber nicht:
# Then setting field "afako" to "62200" throws the exception "unzul�„ssige Angabe"
# Then setting field "andat" to "19950101" throws the exception "unzul�„ssige Angabe"
And I set field "afako" to "62200"
And I set field "andat" to "19950101"

Then setting field "afadat" to "19950101" throws the exception "551"

# Ändern der Feldwerte verursacht im Lader Fehler, bei Cucumber nicht:
# Then setting field "erinnerwert" to "1.00" throws the exception "unzul�„ssige Angabe"
# Then setting field "nmon" to "120" throws the exception "unzul�„ssige Angabe"
And I set field "erinnerwert" to "1.00"
And I set field "nmon" to "120"

# Speichern sowohl des Subeditors(afamodell) als auch des parent editors verursacht im Lader Fehler, bei Cucumber nicht.
# Um die gleiche Ausgabe zu erhalten wird hier nicht gespeichert:
# Then saving the current editor throws the exception "2743"
And I close the current subeditor to switch back to the parent editor
# Then saving the current editor throws the exception "unzul�„ssige Angabe"
And I close the current editor

 # --------------------------------------------------

Given I open an editor "buch-1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "ZUGANG"
And I set field "kenn" to "ZU"
And I set field "beleg" to "ZUGANG"
And I set field "beldat" to "19950101"
And I set field "budat" to "19950101"
Then setting field "anlage" to "2000X" in row 1 throws the exception "6640"
Then setting field "sbetrag" to "50000" in row 1 throws the exception "6640"
Then creating a new row at position !lastRow throws the exception "6641"
Then setting field "konto" to "35010" in row 2 throws the exception "6640"
Then saving the current editor throws the exception "2743"
And I close the current editor

# --------------------------------------------------
# Scenario: �nderung des Anschaffungsdatums der Anlage

Given I'm logged in with password "annette"
And I open an editor "anl-2000X" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "2000X"
And I press button "bafamodell" to open a subeditor for "anl-2000X-afamod"
And I set field "andat" to "19950201"
# And I respond with answer "ja" to the dialog with id "4350"
Then saving the current editor throws the exception "Bitte eintragen"
And I close the current subeditor to switch back to the parent editor
# Lader verusacht Fehler "Bitte eintragen" Cucumber nicht:
# Then saving the current editor throws the exception "550"
And I save the current editor

# wirft im Lader einen Fehler, in Cucumber nicht:
# Given I'm logged in with password "sy" 

# ============================================
# Scenario: �nderung von Verkehrszahlen

# wirft im Lader einen Fehler, in Cucumber nicht:
# Given I'm logged in with password "annette" 

Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "2000" throws the exception "1582"
Then pressing button "pvkz" in row 0 to open a subeditor throws the exception "5322"
Then saving the current editor throws the exception "1771"
And I close the current subeditor to switch back to the parent editor
# Speichern verursacht beim Lader einen Fehler bei Cucumber jedoch nicht:
# Then saving the current editor throws the exception "2743"
And I close the current editor

Given I'm logged in with password "sy"
Then opening an editor from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "2000" throws the exception "2000: nicht gefunden"
Then pressing button "pvkz" in row 0 to open a subeditor throws the exception "5322"
Then setting field "h1" to "1000" throws the exception "1771"
Then setting field "s2" to "1000" throws the exception "1771"
Then setting field "h2" to "1000" throws the exception "1771"
Then setting field "s3" to "1000" throws the exception "1771"
Then setting field "h3" to "1000" throws the exception "1771"
Then setting field "s4" to "1000" throws the exception "1771"
Then setting field "h4" to "1000" throws the exception "1771"
Then setting field "s5" to "1000" throws the exception "1771"
Then setting field "h5" to "1000" throws the exception "1771"
Then setting field "s6" to "1000" throws the exception "1771"
Then setting field "h6" to "1000" throws the exception "1771"
Then setting field "s7" to "1000" throws the exception "1771"
Then setting field "h7" to "1000" throws the exception "1771"
Then setting field "s8" to "1000" throws the exception "1771"
Then setting field "h8" to "1000" throws the exception "1771"
Then setting field "s9" to "1000" throws the exception "1771"
Then setting field "h9" to "1000" throws the exception "1771"
Then setting field "s10" to "1000" throws the exception "1771"
Then setting field "h10" to "1000" throws the exception "1771"
Then setting field "s11" to "1000" throws the exception "1771"
Then setting field "h11" to "1000" throws the exception "1771"
Then setting field "s12" to "1000" throws the exception "1771"
Then setting field "h12" to "1000" throws the exception "1771"
Then setting field "s13" to "1000" throws the exception "1771"
Then setting field "h13" to "1000" throws the exception "1771"
Then setting field "s14" to "1000" throws the exception "1771"
Then setting field "h14" to "1000" throws the exception "1771"
Then setting field "s15" to "1000" throws the exception "1771"
Then setting field "h15" to "1000" throws the exception "1771"
Then setting field "hafa1" to "1000" throws the exception "1771"
Then setting field "safa1" to "1000" throws the exception "1771"
Then setting field "hafa2" to "1000" throws the exception "1771"
Then setting field "safa2" to "1000" throws the exception "1771"
Then setting field "hafa3" to "1000" throws the exception "1771"
Then setting field "safa3" to "1000" throws the exception "1771"
Then setting field "hafa4" to "1000" throws the exception "1771"
Then setting field "safa4" to "1000" throws the exception "1771"
Then setting field "hafa5" to "1000" throws the exception "1771"
Then setting field "safa5" to "1000" throws the exception "1771"
Then setting field "hafa6" to "1000" throws the exception "1771"
Then setting field "safa6" to "1000" throws the exception "1771"
Then setting field "hafa7" to "1000" throws the exception "1771"
Then setting field "safa7" to "1000" throws the exception "1771"
Then setting field "hafa8" to "1000" throws the exception "1771"
Then setting field "safa8" to "1000" throws the exception "1771"
Then setting field "hafa9" to "1000" throws the exception "1771"
Then setting field "safa9" to "1000" throws the exception "1771"
Then setting field "hafa10" to "1000" throws the exception "1771"
Then setting field "safa10" to "1000" throws the exception "1771"
Then setting field "hafa11" to "1000" throws the exception "1771"
Then setting field "safa11" to "1000" throws the exception "1771"
Then setting field "hafa12" to "1000" throws the exception "1771"
Then setting field "safa12" to "1000" throws the exception "1771"
Then setting field "hafa13" to "1000" throws the exception "1771"
Then setting field "safa13" to "1000" throws the exception "1771"
Then setting field "hafa14" to "1000" throws the exception "1771"
Then setting field "safa14" to "1000" throws the exception "1771"
Then setting field "hafa15" to "1000" throws the exception "1771"
Then setting field "safa15" to "1000" throws the exception "1771"
Then setting field "suahk1" to "1000" throws the exception "1771"
Then setting field "huahk1" to "1000" throws the exception "1771"
Then setting field "suahk2" to "1000" throws the exception "1771"
Then setting field "huahk2" to "1000" throws the exception "1771"
Then setting field "suahk3" to "1000" throws the exception "1771"
Then setting field "huahk3" to "1000" throws the exception "1771"
Then setting field "suahk4" to "1000" throws the exception "1771"
Then setting field "huahk4" to "1000" throws the exception "1771"
Then setting field "suahk5" to "1000" throws the exception "1771"
Then setting field "huahk5" to "1000" throws the exception "1771"
Then setting field "suahk6" to "1000" throws the exception "1771"
Then setting field "huahk6" to "1000" throws the exception "1771"
Then setting field "suahk7" to "1000" throws the exception "1771"
Then setting field "huahk7" to "1000" throws the exception "1771"
Then setting field "suahk8" to "1000" throws the exception "1771"
Then setting field "huahk8" to "1000" throws the exception "1771"
Then setting field "suahk9" to "1000" throws the exception "1771"
Then setting field "huahk9" to "1000" throws the exception "1771"
Then setting field "suahk10" to "1000" throws the exception "1771"
Then setting field "huahk10" to "1000" throws the exception "1771"
Then setting field "suahk11" to "1000" throws the exception "1771"
Then setting field "huahk11" to "1000" throws the exception "1771"
Then setting field "suahk12" to "1000" throws the exception "1771"
Then setting field "huahk12" to "1000" throws the exception "1771"
Then setting field "huahk13" to "1000" throws the exception "1771"
Then setting field "suahk13" to "1000" throws the exception "1771"
Then setting field "suahk14" to "1000" throws the exception "1771"
Then setting field "huahk14" to "1000" throws the exception "1771"
Then setting field "suahk15" to "1000" throws the exception "1771"
Then setting field "huahk15" to "1000" throws the exception "1771"
Then setting field "huafa1" to "1000" throws the exception "1771"
Then setting field "suafa1" to "1000" throws the exception "1771"
Then setting field "huafa2" to "1000" throws the exception "1771"
Then setting field "suafa2" to "1000" throws the exception "1771"
Then setting field "huafa3" to "1000" throws the exception "1771"
Then setting field "suafa3" to "1000" throws the exception "1771"
Then setting field "huafa4" to "1000" throws the exception "1771"
Then setting field "suafa4" to "1000" throws the exception "1771"
Then setting field "suafa5" to "1000" throws the exception "1771"
Then setting field "huafa5" to "1000" throws the exception "1771"
Then setting field "suafa5" to "1000" throws the exception "1771"
Then setting field "huafa6" to "1000" throws the exception "1771"
Then setting field "suafa6" to "1000" throws the exception "1771"
Then setting field "huafa7" to "1000" throws the exception "1771"
Then setting field "suafa7" to "1000" throws the exception "1771"
Then setting field "huafa8" to "1000" throws the exception "1771"
Then setting field "suafa8" to "1000" throws the exception "1771"
Then setting field "kjhuahk" to "1000" throws the exception "1771"
Then setting field "huafa9" to "1000" throws the exception "1771"
Then setting field "suafa9" to "1000" throws the exception "1771"
Then setting field "kjhuafa" to "1000" throws the exception "1771"
Then setting field "huafa10" to "1000" throws the exception "1771"
Then setting field "suafa10" to "1000" throws the exception "1771"
Then setting field "huafa11" to "1000" throws the exception "1771"
Then setting field "suafa11" to "1000" throws the exception "1771"
Then setting field "huafa12" to "1000" throws the exception "1771"
Then setting field "suafa12" to "1000" throws the exception "1771"
Then setting field "huafa13" to "1000" throws the exception "1771"
Then setting field "suafa13" to "1000" throws the exception "1771"
Then setting field "huafa14" to "1000" throws the exception "1771"
Then setting field "suafa14" to "1000" throws the exception "1771"
Then setting field "huafa15" to "1000" throws the exception "1771"
Then setting field "suafa15" to "1000" throws the exception "1771"
Then setting field "szub1" to "1000" throws the exception "1771"
Then setting field "szub2" to "1000" throws the exception "1771"
Then setting field "szub3" to "1000" throws the exception "1771"
Then setting field "szub4" to "1000" throws the exception "1771"
Then setting field "szub5" to "1000" throws the exception "1771"
Then setting field "szub6" to "1000" throws the exception "1771"
Then setting field "szub7" to "1000" throws the exception "1771"
Then setting field "szub8" to "1000" throws the exception "1771"
Then setting field "szub9" to "1000" throws the exception "1771"
Then setting field "szub10" to "1000" throws the exception "1771"
Then setting field "szub11" to "1000" throws the exception "1771"
Then setting field "szub12" to "1000" throws the exception "1771"
Then setting field "szub13" to "1000" throws the exception "1771"
Then setting field "szub14" to "1000" throws the exception "1771"
Then setting field "szub15" to "1000" throws the exception "1771"
# Im Lader wird der Subeditor gespeichert und der parent editor ohne weiteres Speichern geschlossen:
# Diese Schritte verursachen im Lader keine Fehlermeldung
# Bei Cucumber wird beim Speichern des Subeditors die Fehlermeldung "Aktion nicht aktiv" ausgegeben:
# And I save the current subeditor to switch back to the parent editor
Then saving the current editor throws the exception "1771"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# ============================================================
# Neue Anlage, deren Abschreibungsart nach einem Zugang ge�ndert
# wird, dann wird eine manuelle Abschreibungsbuchung auf diese
# Anlage erfasst, so dass die Abschreibungsart nicht mehr �nder-
# bar ist. Durch das Stornieren der Abschreibungsbuchung kann 
# die Abschreibungsart wieder ge�ndert werden!

Given I open an editor "anl-1030" from table "(FixedAsset):(FixedAsset)" with command "COPY" for record "1010"
And I set field "nummer" to "1030"
And I press button "bafamodell" to open a subeditor for "anl-1030-afamod"
Then setting field "wg" to "601" throws the exception "601: nicht gefunden"

# Schritt verursacht Fehler im Lader, nicht aber bei Cucumber:
# Then setting field "andat" to "15.01.1995" throws the exception "unzul�„ssige Angabe"
And I set field "andat" to "15.01.1995"

Then setting field "afadat" to "01.01.1995" throws the exception "203"

# Schritte verursachen Fehler im Lader, nicht aber bei Cucumber:
# Then setting field "nmon" to "120" throws the exception "203"
And I set field "nmon" to "120"
# Then setting field "erinnerwert" to "1.00" throws the exception "203"
And I set field "erinnerwert" to "1.00"

Then saving the current editor throws the exception "2743"
And I close the current subeditor to switch back to the parent editor

# Schritt verursacht Fehler im Lader, nicht aber bei Cucumber:
# Then saving the current editor throws the exception "203"

And I close the current editor

Given I open an editor "buch-2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "kenn" to "zu"
And I set field "beldat" to "20.01.95"
And I set field "budat" to "20.01.95"
And I create a new row at the end of the table
And I set field "anlage" to "1030" in row 1
And I set field "ewsbetr" to "10000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "35010" in row 2
And I respond with answer "ja" to the dialog with id ""
And I save the current editor
And I close the current editor

Given I open an editor "anl-1030" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "1030"
And I press button "bafamodell" to open a subeditor for "anl-1030-afamod"
And I set field "afaart" to "110"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

Given I open an editor "buch-3" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "kenn " to "ab"
And I create a new row at the end of the table
And I set field "anlage" to "1030" in row 1
And I set field "ewhbetr" to "1000" in row 1
And I create a new row at the end of the table
And I set field "konto" to "62200" in row 2
And I respond with answer "ja" to the dialog with id ""
And I save the current editor
And I close the current editor

Given I open an editor "anl-1030" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "1030"
And I press button "bafamodell" to open a subeditor for "anl-1030-afamod"
Then setting field "afaart" to "100" throws the exception "100: nicht gefunden"

# Schritt verursacht Fehler im Lader, nicht aber bei Cucumber:
# Then saving the current editor throws the exception "100: nicht gefunden"

And I close the current subeditor to switch back to the parent editor

# Schritt verursacht Fehler im Lader, nicht aber bei Cucumber:
# Then saving the current editor throws the exception "100: nicht gefunden"

And I close the current editor

Then opening an editor from table "(Entry):(Entry)" with command "COPY" for record "3" throws the exception "3: nicht gefunden"
Then pressing button "storno" throws the exception "1771"

# Schritt verursacht Fehler in Cucumber, nicht aber beim Lader:
# And I save the current editor
Then saving the current editor throws the exception "1771"

And I close the current editor

Given I open an editor "anl-1030" from table "(FixedAsset):(FixedAsset)" with command "UPDATE" for record "1030"
And I press button "bafamodell" to open a subeditor for "anl-1030-afamod"
Then setting field "afaart" to "100" throws the exception "100: nicht gefunden"

# Schritt verursacht Fehler im Lader, nicht aber bei Cucumber:
# Then saving the current editor throws the exception "100: nicht gefunden"

And I close the current subeditor to switch back to the parent editor

# Schritt verursacht Fehler im Lader, nicht aber bei Cucumber:
# Then saving the current editor throws the exception "100: nicht gefunden"

And I close the current editor

# ==========================================================


