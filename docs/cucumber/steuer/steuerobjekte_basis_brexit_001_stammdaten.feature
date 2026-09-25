# *****************************************************************************
#  Name             : steuerobjekte_basis_brexit_001_stammdaten.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbereitung der Stammdaten zum EU-Austritt (z.B. Brexit)
#
#
# *****************************************************************************
@persistent
Feature:  steuerobjekte_basis_brexit_001_stammdaten.feature
Background:
Given I set the fake date to "01.01.2002"

############################################################

@FALL-STAMM-Land
Scenario: Region "GROSSBRITANNIEN"

Given I open an editor "land" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "GROSSBRITANNIEN"
And I set field "egbis" to ""
And I set field "waeh" to "GBP"
And I respond with answer "ja" to the dialog with id "5523"
And I respond with answer "ja" to the dialog with id "5523"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-STAMM-GB_REGIONEN
Scenario Outline: Lieferant und Kunde

Given I set the fake date to "01.01.2002"


Given I open an editor "region" from table "(Regions):(RegionCountryEconomicArea)" with command "COPY" for record "GROSSBRITANNIEN"
And I set fields
| such      | <such>          |
| nummer    | <nummer1>       |
| rnamebspr | <namebspr>      |
| kenn      | <kenn>          |
| typ       | Region          |
| typb      | Regione         |
| ueberg    | GROSSBRITANNIEN |
And I save the current editor
Examples:
| such    | nummer1 | namebspr   | kenn |
| ENGLAND | 5001    | England    | ENG  |
| SCHOTTL | 5002    | Schottland | STL  |
| WALES   | 5003    | Wales      | WL   |
| NORDIRL | 5004    | Nordirland | NI   |
#####################################################################################################################################


@FALL-STAMM-KU_LI
Scenario Outline: Lieferant und Kunde

Given I set the fake date to "01.01.2002"


Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
| such     | <such>          |
| nummer   | <nummer1>       |
| namebspr | <namebspr>      |
| ans      | <ans>           |
| str      | <str>           |
| plz      | <plz>           |
| nort     | <nort>          |
| zbed     | 201             |
| waehr    | GBP             |
| staat    | GROSSBRITANNIEN |
| region   | <region>        |
| staat2   | GROSSBRITANNIEN |
| region2  | <region2>       |
| ustid    | <ustid>         |

And I save the current editor
Examples:
| table                 | such    | nummer1 | namebspr               | ans             | str             | plz   | nort     | ustid      | region  | region2 | 
| (Vendor):(Vendor)     | BREXIT1 | 1brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000001 | WALES   | WALES   |
| (Vendor):(Vendor)     | BREXIT2 | 2brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000002 | ENGLAND | ENGLAND |
| (Vendor):(Vendor)     | BREXIT3 | 3brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000003 |         |         |
| (Vendor):(Vendor)     | BREXIT4 | 4brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000004 |         |         |
| (Vendor):(Vendor)     | BREXIT5 | 5brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000005 | NORDIRL | NORDIRL |
| (Vendor):(Vendor)     | BREXIT6 | 6brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000006 |         |         |
| (Vendor):(Vendor)     | BREXIT7 | 7brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000007 | NORDIRL | NORDIRL |
| (Vendor):(Vendor)     | BREXIT8 | 8brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000007 | ENGLAND | WALES   |
| (Vendor):(Vendor)     | BREXIT9 | 9brexit | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt | GB00000007 |         |         |
| (Customer):(Customer) | BREXIT1 | 1brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000011 |         |         |
| (Customer):(Customer) | BREXIT2 | 2brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000012 |         |         |
| (Customer):(Customer) | BREXIT3 | 3brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000013 |         |         |
| (Customer):(Customer) | BREXIT4 | 4brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000014 |         |         |
| (Customer):(Customer) | BREXIT5 | 5brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000015 | NORDIRL | NORDIRL |
| (Customer):(Customer) | BREXIT6 | 6brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000016 |         |         |
| (Customer):(Customer) | BREXIT7 | 7brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000017 | NORDIRL | NORDIRL |
| (Customer):(Customer) | BREXIT8 | 8brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000017 |         |         |
| (Customer):(Customer) | BREXIT9 | 9brexit | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  | GB00000017 |         |         |
#####################################################################################################################################

@FALL-STAMM-WG_PG
Scenario Outline: bei Artikel WG und PG leeren

Given I set the fake date to "01.01.2002"


Given I open an editor "<such>" from table "(Part):(Product)" with command "UPDATE" for record "<such>"
And I set field "wgruppe" to ""
And I set field "erlgrp" to ""
And I save the current editor
Examples:
| such     |
| 0vfall1  |
| 0vfall2  |
| 0vfall3  |
| 0vfall4  |
| 0vfall5  |
| 0vfall6  |
| 0vfall7  |
| 0vfall8  |
| 0vfall9  |
| 0vfall10 |
| 0vfall11 |
| 0vfall12 |
| 0vfall13 |
| 0vfall14 |
| 0vfall15 |
| 0vfall16 |
| 0vfall17 |
| 0vfall18 |
| 0vfall19 |
| 0vfall20 |
| 0vfall21 |
| 0vfall22 |
| 0vfall23 |
#####################################################################################################################################


