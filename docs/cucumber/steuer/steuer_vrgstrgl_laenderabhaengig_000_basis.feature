# *****************************************************************************
#  Name             : steuer_vrgstrgl_laenderabhaengig_000_basis.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbereitung der Stammdaten
#
#
# *****************************************************************************
@persistent
Feature:  steuer_vrgstrgl_laenderabhaengig_000_basis.feature
Background: XXX


@FALL-VGSTRGL
Scenario Outline: VGSTRGL

Given I open an editor "vrgstrgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "NEW" for record ""
And I set fields
 | nummer   | <nummer>  |
 | such     | <such>    |
 | ev       | <ev>      |
 | ustland  | <ustland> |
 | stlaart  | <stlaart> |
 | namebspr | <text>    |
 | ustartsf | ja        |
 | ustartsp | ja        |
 | ustartrc | ja        |
 | ustartns | ja        |
And I save the current editor
Examples:
| nummer | such   | ustland     | ev      | stlaart  | text                                      |
| 5010   | VKITAL | DEUTSCHLAND | Verkauf | EU-Staat | Verkauf nach Italien                      |
| 5011   | VKUSA  | DEUTSCHLAND | Verkauf | Ausland  | Verkauf nach USA                          |
| 5012   | VKBAD  | DEUTSCHLAND | Verkauf | Inland   | Verkauf nach BADEN-WUERTTEMBERG           |
| 5013   | VKTOS  | DEUTSCHLAND | Verkauf | EU-Staat | Verkauf nach Toscana                      |
| 5014   | VKNY   | DEUTSCHLAND | Verkauf | Ausland  | Verkauf nach NY                           |
| 5015   | VKMEX  | DEUTSCHLAND | Verkauf | Ausland  | Verkauf; RE nach Hawaii, Ware nach MEXIKO |
| 5016   | VKBLA1 | DEUTSCHLAND | Verkauf | EU-Staat | Verkauf; Unsinn 1                         |
| 5017   | VKBLA2 | DEUTSCHLAND | Verkauf | EU-Staat | Verkauf; Unsinn 2                         |
| 50aa|VKEUFREIUST| DEUTSCHLAND | Verkauf | EU-Staat | Verkauf; REWE-3854                        |
| 6010   | EKITAL | DEUTSCHLAND | Einkauf | EU-Staat | Einkauf in Italien                        |
| 6011   | EKUSA  | DEUTSCHLAND | Einkauf | Ausland  | Einkauf in USA                            |
| 6012   | EKBAD  | DEUTSCHLAND | Einkauf | Inland   | Einkauf in BADEN-WUERTTEMBERG             |
| 6013   | EKTOS  | DEUTSCHLAND | Einkauf | EU-Staat | Einkauf in Toscana                        |
| 6014   | EKNY   | DEUTSCHLAND | Einkauf | Ausland  | Einkauf in NY                             |
| 6015   | EKMEX  | DEUTSCHLAND | Einkauf | Ausland  | Einkauf; RE von USA, Ware von MEXIKO      |
| 6016   | EKBLA3 | DEUTSCHLAND | Einkauf | EU-Staat | Einkauf; Unsinn 3                         |
| 6017   | EKBLA4 | DEUTSCHLAND | Einkauf | EU-Staat | Einkauf; Unsinn 4                         |
| 60aa|EKEUFREIUST| DEUTSCHLAND | Einkauf | EU-Staat | Einkauf; REWE-3854                        |
#####################################################################################################################################


@FALL-KONFIG
Scenario: Konfig-Erweiterung

Given I open an editor "konfig" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
# Zeilen an einer bestimmten Position einfuehren
And I create a new row at position 4
And I set field "ev" to "Verkauf" in row 4
And I set field "rechnlaart" to "Inland" in row 4
And I set field "bestlaart" to "EU-Staat" in row 4
And I set field "rechnustid" to "irrelevant" in row 4
And I set field "bestustid" to "vorhanden und aus EU-Staat" in row 4
And I set field "standard" to "ja" in row 4
And I set field "vrgstrgl" to "VKEUFREIUST" in row 4
And I set field "namebspr" to "VRGSTRGL aus der Zeile 4 - vorne; REWE-3854" in row 4
#
And I set field "namebspr" to "Zeilenreinhenfolge; REWE-3854" in row 10
And I save the current editor
And I close the current editor


Given I open an editor "konfig2" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
And I append rows
| ev      | rechnlaart | rechnland          | bestlaart | bestland           | rechnustid                 | rechnustidland | standard | vrgstrgl | namebspr                               |
| Verkauf | EU-Staat   | ITALIEN            | EU-Staat  | ITALIEN            | vorhanden und aus EU-Staat | ITALIEN        | ja       | VKITAL   | Verkauf nach Italien                   |
| Verkauf | Ausland    | USA                | Ausland   | USA                | irrelevant                 | !dontChange    | ja       | VKUSA    | Verkauf nach USA                       |
| Verkauf | Inland     | BADEN-WUERTTEMBERG | Inland    | BADEN-WUERTTEMBERG | leer oder aus Inland       | !dontChange    | ja       | VKBAD    | Verkauf nach BADEN-WUERTTEMBERG        |
| Verkauf | EU-Staat   | TOS                | EU-Staat  |                    | vorhanden und aus EU-Staat | ITALIEN        | ja       | VKTOS    | Verkauf; RE nach Toscana, Ware nach EU |
| Verkauf | Ausland    | USA                | Ausland   | NY                 | irrelevant                 | !dontChange    | ja       | VKNY     | Verkauf; RE nach USA. Ware nach NY     |
| Verkauf | Ausland    | USA                | Ausland   | MEXIKO             | irrelevant                 | !dontChange    | ja       | VKMEX    | Verkauf; RE nach USA. Ware nach MEXIKO |
| Verkauf | Inland     |                    | Ausland   |                    | vorhanden und aus EU-Staat | ITALIEN        | ja       | VKBLA1   | VK; RE -> DE, Ware -> Ausland, UstId -> IT |
| Verkauf | EU-Staat   | TOS                | EU-Staat  |                    | vorhanden und aus EU-Staat | FRANKREICH     | ja       | VKBLA2   | Verkauf; RE nach Toscana, UstId aus FR |
| Einkauf | EU-Staat   | ITALIEN            | EU-Staat  | ITALIEN            | vorhanden und aus EU-Staat | ITALIEN        | ja       | EKITAL   | Einkauf in Italien                     |
| Einkauf | Ausland    | USA                | Ausland   | USA                | irrelevant                 | !dontChange    | ja       | EKUSA    | Einkauf in USA                         |
| Einkauf | Inland     | BADEN-WUERTTEMBERG | Inland    | BADEN-WUERTTEMBERG | leer oder aus Inland       | !dontChange    | ja       | EKBAD    | Einkauf in BADEN-WUERTTEMBERG          |
| Einkauf | EU-Staat   | TOS                | EU-Staat  |                    | vorhanden und aus EU-Staat | ITALIEN        | ja       | EKTOS    | Einkauf; RE von Toscana, Ware von EU   |
| Einkauf | Ausland    | USA                | Ausland   | NY                 | irrelevant                 | !dontChange    | ja       | EKNY     | Einkauf; RE von USA. Ware von NY       |
| Einkauf | Ausland    | USA                | Ausland   | MEXIKO             | irrelevant                 | !dontChange    | ja       | EKMEX    | Einkauf; RE von USA. Ware von MEXIKO   |
| Einkauf | Inland     |                    | Ausland   |                    | vorhanden und aus EU-Staat | ITALIEN        | ja       | EKBLA3   | EK; RE -> DE, Ware -> Ausland, UstId -> IT |
| Einkauf | EU-Staat   | TOS                | EU-Staat  |                    | vorhanden und aus EU-Staat | FRANKREICH     | ja       | EKBLA4   | Einkauf; RE von Toscana, UstId aus FR  |
And I save the current editor
And I close the current editor



Given I open an editor "konfig3" from table "(ProcessTaxRule):(ProcessTaxConfiguration)" with command "UPDATE" for record "500"
# Zeilen an einer bestimmten Position einfuehren
And I create a new row at the end of the table

And I set field "ev" to "Einkauf" in row !lastRow
And I set field "rechnlaart" to "Inland" in row !lastRow
And I set field "bestlaart" to "EU-Staat" in row !lastRow
And I set field "rechnustid" to "irrelevant" in row !lastRow
And I set field "bestustid" to "vorhanden und aus EU-Staat" in row !lastRow
And I set field "standard" to "ja" in row !lastRow
And I set field "vrgstrgl" to "EKEUFREIUST" in row !lastRow
And I set field "namebspr" to "VRGSTRGL aus der letzten Zeile; REWE-3854" in row !lastRow
And I save the current editor
And I close the current editor


#####################################################################################################################################


@FALL-Kontensteuerregel
Scenario: Kontensteuerregel


Given I open an editor "kontenstrgl1" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "EKIN-ALL"
And I append rows
| vrgstrgl | strgl             | namebspr                              |
| EKITAL   | EKEUSOFORT-1-W-89 | Einkauf in Italien                    |
| EKUSA    | EKAUSFREI-0       | Einkauf in USA                        |
| EKBAD    | EKINSTPF-1        | Einkauf in BADEN-WUERTTEMBERG         |
| EKTOS    | EKEUSOFORT-1-W-89 | Einkauf; RE von Toscana, Ware von EU  |
| EKNY     | EKAUSFREI-0       | Einkauf; RE von USA. Ware von NY      |
| EKMEX    | EKAUSFREI-0       | Einkauf; RE von USA. Ware von MEXIKO  |
| EKBLA3   | EKEUSOFORT-1-W-89 | EK; RE -> DE, Ware -> Ausland, UstId -> IT|
| EKBLA4   | EKEUSOFORT-1-W-89 | Einkauf; RE von Toscana, UstId aus FR |
|EKEUFREIUST|EKEUSOFORT-2-W-93 | Einkauf; Zeilentest in KONFIG; REWE-3854|
And I save the current editor
And I close the current editor

Given I open an editor "kontenstrgl2" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "VKIN-81"
And I append rows
 | vrgstrgl    | strgl         | namebspr                        |
 | VKBAD       | VKINSTPF-1-81 | Verkauf nach BADEN-WUERTTEMBERG |
 | VKEUFREIUST | VKEUFREI-0    | Verkauf; Zeilentest in KONFIG: REWE-3854|
And I save the current editor
And I close the current editor

Given I open an editor "kontenstrgl3" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "VKEUFREI-0-41"
And I append rows
| vrgstrgl | teartdleist    | strgl            | namebspr             |
| VKITAL   | Ware           | VKEUFREI-0-W-41  | Verkauf nach Italien |
| VKITAL   | Dienstleistung | VKEUFREI-0-DL-21 | Verkauf nach Italien |
| VKITAL   |                | 5007             | Verkauf nach Italien |
| VKTOS    | Ware           | VKEUFREI-0-W-41  | Verkauf nach Italien |
| VKTOS    | Dienstleistung | VKEUFREI-0-DL-21 | Verkauf nach Italien |
| VKTOS    |                | 5007             | Verkauf nach Italien |
And I save the current editor
And I close the current editor

Given I open an editor "kontenstrgl4" from table "(TaxCode):(AccountTaxRule)" with command "UPDATE" for record "VKAUSFREI-0-43"
And I append rows
| vrgstrgl | teartdleist | strgl          | namebspr                |
| VKUSA    |             | VKAUSFREI-0-43 | Verkauf nach USA        |
| VKNY     |             | VKAUSFREI-0-43 | Verkauf nach NY         |
| VKMEX    |             | VKAUSFREI-0-43 | Verkauf nach USA/MEXIKO |
And I save the current editor
And I close the current editor
#####################################################################################################################################


@FALL-Vorgangskontotausch
Scenario: Vorgangskontotausch


Given I open an editor "kontotausch" from table "(ProcessAccountChange):(ProcessAccountChange)" with command "UPDATE" for record "44000"
And I append rows
| vrgstrgl | konto |
| VKITAL   | 43150 |
| VKUSA    | 41500 |
| VKTOS    | 43150 |
| VKNY     | 41500 |
| VKMEX    | 41500 |
And I save the current editor
And I close the current editor
#####################################################################################################################################


@FALL-STAMM-MA
Scenario Outline: Mitarbeiter

Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "NEW" for record ""
And I set fields
 | nummer  | <nummer> |
 | staat   | <staat>  |
 | region  | <region> |
 | such    | <such>   |
 | laart   | <laart>  |
 | geburt  | <geburt> |
 | famst   | <famst>  |
And I save the current editor
Examples:
 | nummer | such | staat       | region             | laart    | geburt     | famst |
 | 77711  | MA11 | DEUTSCHLAND | RHEINLAND-PFALZ    | Inland   | 01.11.1989 | ledig |
 | 77712  | MA12 | DEUTSCHLAND | BADEN-WUERTTEMBERG | Inland   | 05.01.1979 | ledig |
 | 77713  | MA13 | DEUTSCHLAND | BERLIN             | Inland   | 01.01.1989 | ledig |
 | 77714  | MA14 | USA         | HI                 | Ausland  | 05.05.1981 | ledig |
 | 77715  | MA15 | USA         | CO                 | Ausland  | 01.01.1982 | ledig |
 | 77716  | MA16 | ITALIEN     | TOS                | EU-Staat | 06.06.1983 | ledig |
 | 77717  | MA17 | ITALIEN     | LOM                | EU-Staat | 07.07.1984 | ledig |
 | 77718  | MA18 | ITALIEN     | MOL                | EU-Staat | 08.08.1985 | ledig |
 | 77719  | MA19 | ITALIEN     | NA                 | EU-Staat | 09.09.1986 | ledig |
 | 77720  | MA20 | DEUTSCHLAND | BADEN-WUERTTEMBERG | Ausland  | 01.12.1987 | ledig |
 | 77721  | MA21 | DEUTSCHLAND | RHEINLAND-PFALZ    | Ausland  | 30.01.1988 | ledig |
 | 77722  | MA22 | USA         | TX                 | Inland   | 14.02.1989 | ledig |
 | 77723  | MA23 | USA         | NY                 | Inland   | 11.01.2000 | ledig |
 | 77724  | MA24 | ITALIEN     | SIC                | Inland   | 01.01.2003 | ledig |
 | 77725  | MA25 | ITALIEN     | EMR                | Inland   | 22.01.1997 | ledig |
#####################################################################################################################################

@FALL-STAMM-KU_LI
Scenario Outline: Lieferant und Kunde

Given I open an editor "kulie" from table "<table>" with command "UPDATE" for record "<nummer>"
And I set fields
 | staat    | <staat>    |
 | region   | <region>   |
 | staat2   | <staat2>   |
 | region2  | <region2>  |
 | vrgstrgl | <vrgstrgl> |
 | ustid    | <ustid>    |
And I save the current editor
Examples:
 | nummer | table                 | staat       | region             | ustid    | staat2      | region2            | vrgstrgl    |
 | 10010  | (Vendor):(Vendor)     | DEUTSCHLAND | RHEINLAND-PFALZ    | DE123456 | DEUTSCHLAND | RHEINLAND-PFALZ    | EKIN        |
 | 10011  | (Vendor):(Vendor)     | DEUTSCHLAND | BADEN-WUERTTEMBERG | DE123456 | ITALIEN     | TOS                | !dontChange |
 | 40002  | (Vendor):(Vendor)     | DEUTSCHLAND | BADEN-WUERTTEMBERG | DE123456 | DEUTSCHLAND | BADEN-WUERTTEMBERG | !dontChange |
 | 60013  | (Vendor):(Vendor)     | USA         | HI                 |          | USA         | HI                 | !dontChange |
 | 840015 | (Vendor):(Vendor)     | USA         | NY                 |          | USA         | NY                 | !dontChange |
 | 840020 | (Vendor):(Vendor)     | USA         | NY                 |          | USA         | NY                 | EKUSA       |
 | 2011   | (Vendor):(Vendor)     | ITALIEN     | TOS                | IT123456 | ITALIEN     | TOS                | !dontChange |
 | 2012   | (Vendor):(Vendor)     | ITALIEN     | LOM                | IT123545 | ITALIEN     | LOM                | !dontChange |
 | 050    | (Customer):(Customer) | DEUTSCHLAND | BREMEN             | DE123456 | ITALIEN     | TOS                | !dontChange |
 | 051    | (Customer):(Customer) | DEUTSCHLAND | BAYERN             | DE123456 | DEUTSCHLAND | BAYERN             | !dontChange |
 | 20587  | (Customer):(Customer) | DEUTSCHLAND | BADEN-WUERTTEMBERG | DE123456 | DEUTSCHLAND | BADEN-WUERTTEMBERG | VKBAD       |
 | 20586  | (Customer):(Customer) | DEUTSCHLAND | RHEINLAND-PFALZ    | DE123456 | DEUTSCHLAND | RHEINLAND-PFALZ    | !dontChange |
 | 40001  | (Customer):(Customer) | USA         | HI                 |          | MEXIKO      | TAB                | !dontChange |
 | 40002  | (Customer):(Customer) | USA         | NY                 |          | USA         | NY                 | !dontChange |
 | 2011   | (Customer):(Customer) | ITALIEN     | TOS                | IT123456 | ITALIEN     | TOS                | !dontChange |
 | 70008  | (Customer):(Customer) | ITALIEN     | TOS                | IT123456 | ITALIEN     | TOS                | VKITAL      |
 | 2012   | (Customer):(Customer) | ITALIEN     | LOM                | IT123545 | ITALIEN     | LOM                | !dontChange |
#####################################################################################################################################


