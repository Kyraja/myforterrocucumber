@persistent
@FP_TEST
Feature: Daten anlegen fuer Infosystem FONTSMAPPING

Scenario: Archivierung beim Bildschirm Drucker deaktivieren
Given I open an editor "Drucker" from table "(Infrastructure):(Printer)" with command "UPDATE" for record "11001"
And I set field "archiv" to "nein"
And I save the current editor

Scenario: Standard Schriften laden, Schriftdatei checken, generieren und Druck probieren

Given I open the infosystem "FONTSMAPPING"
And I press button "bstart"
Then the table has 23 rows
Then field "spr1" is empty
Then field "spr2" is empty
Then field "tspr1" is not modifiable in row 1
Then field "tspr2" is not modifiable in row 1
And I press button "bucheck"
And I press button "bugenerate"
And I close the current editor

Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "VIEW" for record "4718"
And I print layout "MASTER" with filename "rmtmp/TestAuftrag.pdf"
And file "rmtmp/TestAuftrag.pdf" exists
And I close the current editor

Scenario: Zeilen hinzufuegen, loeschen und neue Mappingdatei generieren

Given I open the infosystem "FONTSMAPPING"
And I create a new row at the end of the table
Then field "tnormal" is not modifiable in row 1
Then field "tbold" is not modifiable in row 1
Then field "titalic" is not modifiable in row 1
Then field "tbolditalic" is not modifiable in row 1
Then field "tpdfencoding" is not modifiable in row 1
Then field "tnormal" has value "de/abas/erp/fonts/dejavu/DejaVuSans.ttf" in row 1
Then field "tbold" has value "de/abas/erp/fonts/dejavu/DejaVuSans-Bold.ttf" in row 1
Then field "titalic" has value "de/abas/erp/fonts/dejavu/DejaVuSans-Oblique.ttf" in row 1
Then field "tbolditalic" has value "de/abas/erp/fonts/dejavu/DejaVuSans-BoldOblique.ttf" in row 1
Then field "tpdfencoding" has value "Identity-H" in row 1
And I create a new row at the end of the table
And I delete row at position !lastRow
And I press button "bugenerate"
Then field "timgstatus" has value "icon:minus" in row 1
Then field "tstatus" has value "Die Schriftart ist ein Mussfeld." in row 1
And I set field "tfontname" to "Testschrift" in row 1
And I set field "spr1" to "xy"
And I set field "tspr1" to "ja" in row 1
And I press button "bugenerate"
Then field "timgstatus" has value "icon:ok" in row 1
And I create a new row at the end of the table
And I set field "tfontname" to "Testschrift" in row 2
And I press button "bugenerate"
Then field "tstatus" has value "Die Schriftart muss eindeutig sein." in row 2
Then file "myhomedir/print/fonts/jasperreports-fonts.xml" exists
Then file "myhomedir/print/fonts/jasperreports-fonts.xml" contains text "Testschrift"
Then file "myhomedir/print/fonts/jasperreports-fonts.xml" contains text "xy"
Then file "myhomedir/print/fonts/jasperreports-fonts_[0-9]{8}_[0-9]{6}\.xml" exists
And I close the current editor

