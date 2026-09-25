@persistent
Feature: Testet das komplexe Sammellayout mit Aufrufkontext in Zeilen (Feld: zeilenweise)

Scenario: Komplexe Sammellayout erstellen

Given I open an editor "Sammellayout" from table "(PrintParameter):(CollectiveLayout)" with command "COPY" for record "12536"
And I set field "such" to "XKOMMISSION"
And I set field "zeilenlayout" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "Sammellayout" from table "(PrintParameter):(CollectiveLayout)" with command "COPY" for record "12502"
And I set field "such" to "XMASTER"
And I create a new row at the end of the table
And I set field "tlayout" to "XKOMMISSION" in row 2
And I create a new row at the end of the table
And I set field "tlayout" to "XKOMMISSION" in row 3
And I create a new row at the end of the table
And I set field "tlayout" to "12511" in row 4
And I set field "isaufruf" to "50031" in row 4
And I create a new row at the end of the table
And I set field "tlayout" to "XKOMMISSION" in row 5
And I create a new row at the end of the table
And I set field "tlayout" to "XKOMMISSION" in row 6
And I create a new row at the end of the table
And I set field "tlayout" to "XKOMMISSION" in row 7
And I save the current editor
And I close the current editor

Scenario: Erstellen von Auftrag zum Drucken
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "schlag" to "Auftrag"
And I set field "nummer" to "321"
And I set field "kl" to "1"
And I set field "such" to "A321"
And I set field "tterm" to "."
And I set field "kopien" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "201" in row 1
And I set field "mge" to "5" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "201" in row 2
And I set field "mge" to "5" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "201" in row 3
And I set field "mge" to "5" in row 3
And I save the current editor
And I close the current editor

Scenario: Komplexe Sammellayout drucken

Given I enable the flag 310
Given I open an editor "Vorgang" from table "(Sales):(SalesOrder)" with command "VIEW" for record "A321"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "XMASTER"
And I set field "drucker" to "DATEI"
And I set field "archiv" to "nein"
And I set field "datname" to "rmtmp/out/Auftrag3Z.pdf"
And I save the current editor
And I switch the current editor to editor "Vorgang"
And I close the current editor
Then file "rmtmp/out/Auftrag3Z.pdf" exists
Then PDF file "rmtmp/out/Auftrag3Z.pdf" contains 19 pages

Scenario Outline: Layouts für Zeilendruck LKU anlegen
Given I open an editor "Layout" from table "(PrintParameter):(Layout)" with command "STORE" for record "<such>"
And I set fields
	| such           | <such> |
	| name           | <name> |
	| aktiv          | <aktiv> |
	| kanal          | <kanal> |
	| zeilenlayout   | <zeilenlayout> |
	| arb            | <arb> |
	| kontext        | <kontext> |
	| layname        | <layname> |
	| gendgfop       | ja        |
And I save the current editor
And I close the current editor

Examples:
| row | such | name                       |aktiv|kanal | zeilenlayout|arb|kontext|layname                     |
| 001 |FALL01|Testdruck Layout normal     |ja   |16007 |nein         |ow1|I LKU  |jasper/layout/st/STLKU.jrxml|
| 002 |FALL02|Testdruck Layout zeilenweise|ja   |16007 |ja           |ow1|I LKU  |jasper/layout/st/STLKU.jrxml|

Scenario Outline: Aufrufparameter fuer indirekten Druck LKU anlegen
Given I open an editor "Layout" from table "(DataExport):(CallParameter)" with command "STORE" for record "<such>"
And I set fields
	| such           | <such> |
	| name           | <name> |
	| zielobj        | <zielobj> |
	| aufrktxt       | <aufrktxt> |
	| aufrtab        | <aufrtab> |
And I append rows
	| zielvar        | aufrwtyp    | aufrwert    |
	| <zielvar>      | <aufrwtyp>  | <aufrwert>  |
	| <zielvar2>     | <aufrwtyp2> | <aufrwert2> |
And I save the current editor
And I close the current editor

Examples:

| row |such      |name                 |zielobj|aufrktxt |aufrtab|zielvar  |aufrwtyp    |aufrwert|zielvar2 |aufrwtyp2   |aufrwert2|
| 001 |LKUTOLKUK |LKU druck aus Kopf   |I LKU  |I LKU    |nein   |kkundevon|(Constant)  |1       |kkundebis|(Constant)  |5        |
| 002 |LKUTOLKUT |LKU druck aus Tabelle|I LKU  |I LKU    |ja     |kkundevon|(TableField)|tnum    |kkundebis|(TableField)|tnum     |
| 003 |KUNDETOLKU|LKU druck aus Kunde  |I LKU  |V V-00-01|nein   |kkundevon|(Constant)  |1       |kkundebis|(Constant)  |5        |

Scenario Outline: Sammellayouts für Zeilendruck LKU anlegen
Given I open an editor "Layout" from table "(PrintParameter):(CollectiveLayout)" with command "STORE" for record "<such>"
And I set fields
	| such           | <such> |
	| name           | <name> |
	| aktiv          | <aktiv> |
	| kanal          | <kanal> |
	| zeilenlayout   | <zeilenlayout> |
	| arb            | <arb> |
	| kontext        | <kontext> |
And I append rows
	| tlayout        | isaufruf   |
	| <tlayout>      | <isaufruf> |
And I save the current editor
And I close the current editor

Examples:

| row |such  |name                                           |aktiv|kanal|zeilenlayout|arb|kontext  |tlayout|isaufruf    |
| 001 |FALL03|Testdruck Layout direkt normal                 |ja   |16007|nein        |ow1|I LKU    |FALL01 |!dontChange |
| 002 |FALL04|Testdruck Layout direkt normal                 |ja   |16007|nein        |ow1|I LKU    |FALL02 |!dontChange |
| 003 |FALL05|Testdruck Layout direkt zeilenweise            |ja   |16007|ja          |ow1|I LKU    |FALL01 |!dontChange |
| 004 |FALL06|Testdruck Layout direkt zweilenweise           |ja   |16007|ja          |ow1|I LKU    |FALL02 |!dontChange |
| 005 |FALL07|Normal Layout indirekt Kopf normal             |ja   |16007|nein        |ow1|I LKU    |FALL01 |LKUTOLKUK   |
| 006 |FALL08|Normal Layout indirekt Kopf zeilenweise        |ja   |16007|nein        |ow1|I LKU    |FALL02 |LKUTOLKUK   |
| 007 |FALL09|Zeilenweise Layout indirekt Kopf normal        |ja   |16007|ja          |ow1|I LKU    |FALL01 |LKUTOLKUK   |
| 008 |FALL10|Zeilenweise Layout indirekt Kopf zeilenweise   |ja   |16007|ja          |ow1|I LKU    |FALL02 |LKUTOLKUK   |
| 009 |FALL11|Zeilenweise Layout indirekt Tabelle normal     |ja   |16007|ja          |ow1|I LKU    |FALL01 |LKUTOLKUT   |
| 010 |FALL12|Zeilenweise Layout indirekt Tabelle zeilenweise|ja   |16007|ja          |ow1|I LKU    |FALL02 |LKUTOLKUT   |
| 011 |FALL13|Testdruck Layout indirekt normal               |ja   |16007|nein        |ow1|V V-00-01|FALL01 |KUNDETOLKU  |
| 012 |FALL14|Testdruck Layout indirekt zeilenweise          |ja   |16007|nein        |ow1|V V-00-01|FALL02 |KUNDETOLKU  |

Scenario Outline: Sammellayout aus Infosystem LKU drucken

Given I enable the flag 310
Given I open the infosystem "LKU"
And I set fields
	|kkundevon | 1  |
	|kkundebis | 5  |
	|bstart    | ja |
And I print layout "<layout>" with printer "BILDSCHIRM" and filename "rmtmp/<layout>.pdf"
And I close the current editor
Then file "rmtmp/<layout>.pdf" exists
Then file "rmtmp/mergedFileForPrinter.BILDSCHIRM.*.<layout>.pdf.SCREEN.pdf" exists
Then PDF file "rmtmp/<layout>.pdf" contains <seiten> pages

Examples:

| row |layout | seiten |
| 001 |FALL03 | 1      |
| 002 |FALL04 | 5      |
| 003 |FALL05 | 5      |
| 004 |FALL06 | 25     |
| 005 |FALL07 | 1      |
| 006 |FALL08 | 5      |
| 007 |FALL09 | 5      |
| 008 |FALL10 | 25     |
| 009 |FALL11 | 5      |
| 010 |FALL12 | 5      |

Scenario Outline: Sammellayout aus Infosystem Kunde drucken

Given I enable the flag 310
Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "VIEW" for record "1"
And I print layout "<layout>" with printer "BILDSCHIRM" and filename "rmtmp/<layout>.pdf"
And I close the current editor
Then file "rmtmp/<layout>.pdf" exists
Then file "rmtmp/mergedFileForPrinter.BILDSCHIRM.*.<layout>.pdf.SCREEN.pdf" exists
Then PDF file "rmtmp/<layout>.pdf" contains <seiten> pages

Examples:

| row |layout | seiten |
| 001 |FALL13 | 1      |
| 002 |FALL14 | 5      |
