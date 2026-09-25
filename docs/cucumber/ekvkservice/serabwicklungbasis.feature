#***************************************************************************
#
#
#  Name           : serabwicklungsbasis.feature
#  Datum          : 14.02.2023
#  Autor          : nkoeninger
#  Verantwortlich : teampss
#
#  Funktion  : Cucumberskript zur Bereistellung der Grunddaten fuer Tests der Serviceabwicklung
#
#***************************************************************************

Feature: serabwicklungbasis
Background:
Given I'm logged in with password "annette"
Given I set the fake date to "02.01.1995"
 
 
# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN Allgemein - Kostenarten, Konten, Mitarbeiter, Qualifikationen
# ----------------------------------------------------------------------------------------------
Given I open an editor "terTermine-1" from table "(Company):(FinancialDates)" with command "UPDATE" for record "term"
And I set fields
	| babkoartgj     | 1995    |
	| babkoartgm     | 1       |
	| ilviststartgj  | 1995    |
	| ilviststartgm  | 1       |
	| ilvplanstartgj | 1995    |
	| ilvplanstartgm | 1       |
	| klbmindat      | 1.1.95  |
	| kuemindat      | 1.1.95  |
	| rmmindat       | 1.1.95  |
	| rmuemindat     | 1.1.95  |
And I save the current editor

Given I open an editor "KOArtKostenart-1" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set fields
	| nummer   | 99800                   |
	| such     | k                       |
	| namebspr | statistische Kostenart  |
	| stat     | j                       |
And I save the current editor

Given I open an editor "KOArtKostenart-1.1" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set fields
	| nummer   | 50000      |
	| such     | k          |
	| namebspr | Kostenart  |
And I save the current editor
Given I open an editor "KOArtKostenart-1.2" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set fields
	| nummer   | 48000      |
	| such     | k          |
	| namebspr | Kostenart  |
And I save the current editor

Given I open an editor "KOArtKostenart-2" from table "(Account):(Account)" with command "UPDATE" for record "50000"
And I set fields
	| hkost | j  |
	| kost  | j  |
And I create a new row at the end of the table 
And I set field "zkoart" to "50000" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-3" from table "(Account):(Account)" with command "UPDATE" for record "48000"
And I set fields
	| hkost | j  |
	| kost  | j  |
And I create a new row at the end of the table 
And I set field "zkoart" to "48000" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-4" from table "(Account):(Account)" with command "UPDATE" for record "99900"
And I set fields
	| hkost | j  |
	| kost  | j  |
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-5" from table "(Account):(Account)" with command "UPDATE" for record "99800"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-6" from table "(Account):(Account)" with command "UPDATE" for record "5aoz"
And I set fields
	| hkost | j  |
	| kost  | j  |
And I create a new row at the end of the table 
And I set field "zkoart" to "50000" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-7" from table "(Account):(Account)" with command "UPDATE" for record "88100"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-8" from table "(Account):(Account)" with command "UPDATE" for record "88101"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-9" from table "(Account):(Account)" with command "UPDATE" for record "88200"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-10" from table "(Account):(Account)" with command "UPDATE" for record "88201"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-11" from table "(Account):(Account)" with command "UPDATE" for record "88300"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-12" from table "(Account):(Account)" with command "UPDATE" for record "88301"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-13" from table "(Account):(Account)" with command "UPDATE" for record "88400"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-14" from table "(Account):(Account)" with command "UPDATE" for record "88401"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-15" from table "(Account):(Account)" with command "UPDATE" for record "88500"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-16" from table "(Account):(Account)" with command "UPDATE" for record "88501"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "KOArtKostenart-17" from table "(Account):(Account)" with command "UPDATE" for record "88889"
And I set field "kost" to "j" 
And I create a new row at the end of the table 
And I set field "zkoart" to "99800" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor

Given I open an editor "WG-01" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "WG-RHB"
And I set field "wgkst" to "100000" 
And I save the current editor

Given I open an editor "WG-02" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "WG-FE"
And I set field "wgkst" to "100000" 
And I save the current editor

Given I open an editor "PG-01" from table "(Company):(ProductGroup)" with command "UPDATE" for record "PG-UE"
And I set field "pgkst" to "100000" 
And I save the current editor

Given I open an editor "mitarMitarbeiter-1" from table "(Employee):(Employee)" with command "COPY" for record "7802"
And I set field "such" to "BRAUN" 
And I save the current editor
Given I open an editor "mitarMitarbeiter-1.2" from table "(Employee):(Employee)" with command "COPY" for record "7802"
And I set field "such" to "KELLER" 
And I save the current editor
Given I open an editor "mitarMitarbeiter-1.3" from table "(Employee):(Employee)" with command "COPY" for record "7802"
And I set field "such" to "KOCH" 
And I save the current editor

Given I open an editor "qualQualifikationen-2" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | WIG             |
	| name | WIG Schweissen  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.1" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | ELEKTROTECHNIK  |
	| name | Elektrotechnik  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.3" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | Karosserie     |
	| name | Karosseriebau  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.4" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | Mechanik               |
	| name | Landmaschinenmechanik  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.5" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | GPS                     |
	| name | GPS-Anlagen-Elektronik  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.6" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | Hydraulik        |
	| name | Hydraulikanlage  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.7" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | Motor    |
	| name | Motoren  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.8" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | Fahrwerk  |
	| name | Fahrwerk  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.9" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | Getriebe  |
	| name | Getriebe  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.10" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | Englisch  |
	| name | Englisch  |
And I save the current editor
Given I open an editor "qualQualifikationen-2.11" from table "(Qualifications):(Qualifications)" with command "NEW" for record ""
And I set fields
	| such | Franzoesich   |
	| name | Franzoesich  |
And I save the current editor
 
Given I open an editor "KOArtKostenart-18" from table "(Account):(Account)" with command "UPDATE" for record "44000"
And I set field "kost" to "ja" 
And I create a new row at the end of the table
And I set field "zkoart" to "48000" in row !lastRow
And I set field "koartvon" to "1.01.95" in row !lastRow
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN Service - Serviceeinsatzmittel, Techniker, Lieferanten, Kapazitaeten, Arbeitsgaenge
# ---------------------------------------------------------------------------------------------
Given I open an editor "serviceeinsEinsatzmittel-3" from table "(ServiceAssignment):(AssignmentResources)" with command "NEW" for record ""
And I set fields
	| such   | KA-XX01               |
	| name   | Firmenwagen KA-XX 01  |
	| vbzeit | 15m                   |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-3.1" from table "(ServiceAssignment):(AssignmentResources)" with command "NEW" for record ""
And I set fields
	| such   | KA-XX02               |
	| name   | Firmenwagen KA-XX 02  |
	| vbzeit | 15m                   |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-3.2" from table "(ServiceAssignment):(AssignmentResources)" with command "NEW" for record ""
And I set fields
	| such   | KA-XX03               |
	| name   | Firmenwagen KA-XX 03  |
	| vbzeit | 20m                   |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-3.3" from table "(ServiceAssignment):(AssignmentResources)" with command "NEW" for record ""
And I set fields
	| such   | BAHN                           |
	| name   | Bahn                           |
	| vbzeit | 20m							  |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-3.4" from table "(ServiceAssignment):(AssignmentResources)" with command "NEW" for record ""
And I set fields
	| such   | NAVI                           |
	| name   | Navigationssystem              |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-4" from table "(Qualifications):(LevelOfQualification)" with command "NEW" for record ""
And I set fields
	| such | S1_MECHANIKER            |
	| name | Landmaschinenmechaniker  |
And I append rows
	| serqual  |
	| Mechanik |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-4.1" from table "(Qualifications):(LevelOfQualification)" with command "NEW" for record ""
And I set fields
	| such | ELEKTRO           |
	| name | Elektrotechniker  |
And I append rows
	| serqual        |
	| Elektrotechnik |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-4.2" from table "(Qualifications):(LevelOfQualification)" with command "NEW" for record ""
And I set fields
	| such | S2_MECHANIKER               |
	| name | S2_Landmaschinenmechaniker  |
And I append rows
	| serqual  |
	| Mechanik |
	| Motor    |
	| Fahrwerk |
And I save the current editor

Given I open an editor "serviceeinsEinsatzmittel-4.3" from table "(Qualifications):(LevelOfQualification)" with command "NEW" for record ""
And I set fields
	| such | S3_MECHANIKER               |
	| name | S3_Landmaschinenmechaniker  |
And I append rows
	| serqual   |
	| Mechanik  |
	| Motor     |
	| Getriebe  |
	| Hydraulik |
And I save the current editor

Given I open an editor "serviceeinsEinsatzmittel-4.4" from table "(Qualifications):(LevelOfQualification)" with command "NEW" for record ""
And I set fields
	| such | KAROSSERIEBAUER                |
	| name | Karosseriebauer Landmaschinen  |
And I append rows
	| serqual    |
	| Karosserie |
	| WIG        |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-4.5" from table "(Qualifications):(LevelOfQualification)" with command "NEW" for record ""
And I set fields
	| such | S1_ELEKTROTECH       |
	| name | S1_Elektrotechniker  |
And I append rows
	| serqual        |
	| Elektrotechnik |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-4.6" from table "(Qualifications):(LevelOfQualification)" with command "NEW" for record ""
And I set fields
	| such | S2_ELEKTROTECH       |
	| name | S2_Elektrotechniker  |
And I append rows
	| serqual        |
	| Elektrotechnik |
	| GPS            |
And I save the current editor
 
 
Given I open an editor "serviceeinsEinsatzmittel-5" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set fields
	| such    | SPEZIALIST1  |
	| name    | Spezialist   |
	| ma      | test         |
	| anreism | KA-XX01      |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-6" from table "(Qualifications):(ListOfQualifications)" with command "NEW" for record ""
And I set fields
	| ma   | test           |
	| grad | S1_MECHANIKER  |
And I delete all rows
And I append rows
	| serqual  | gltvon      | gltbis      |
	| Mechanik | 01.01.95    | 01.01.07    |
	| Englisch | !dontChange | !dontChange |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-7" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set fields
	| such  | SPEZIALIST2  |
	| name  | Spezialist   |
	| ma    | 7801         |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-8" from table "(Qualifications):(ListOfQualifications)" with command "NEW" for record ""
And I set fields
	| ma   | 7801           |
	| grad | S2_MECHANIKER  |
And I delete all rows
And I append rows
	| serqual     | gltvon      | gltbis      |
	| Mechanik    | 01.01.95    | 01.01.07    |
	| Franzoesich | !dontChange | !dontChange |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-9" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set fields
	| such  | ELEKTRO1          |
	| name | Elektrotechniker  |
	| ma    | 7802              |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-10" from table "(Qualifications):(ListOfQualifications)" with command "NEW" for record ""
And I set fields
	| ma   | 7802            |
	| grad | S1_ELEKTROTECH  |
And I delete all rows
And I append rows
	| serqual        | gltvon      | gltbis      |
	| Englisch       | !dontChange | !dontChange |
	| GPS            | 01.01.95    | 01.01.04    |
	| Elektrotechnik | 01.01.95    | 01.01.04    |
And I save the current editor

Given I open an editor "serviceeinsEinsatzmittel-11" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set fields
	| such  | MECHANIKER1  |
	| name | Mechaniker   |
	| ma    | BRAUN        |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-12" from table "(Qualifications):(ListOfQualifications)" with command "NEW" for record ""
And I set fields
	| ma   | BRAUN          |
	| grad | S1_MECHANIKER  |
And I delete all rows
And I append rows
	| serqual  | gltvon   | gltbis   |
	| Mechanik | 01.01.95 | 01.01.07 |
	| wig      | 01.01.95 | 01.01.04 |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-13" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set fields
	| such  | MECHANIKER2  |
	| name  | Mechaniker   |
	| ma    | KELLER       |
And I save the current editor

 
Given I open an editor "serviceeinsEinsatzmittel-14" from table "(Qualifications):(ListOfQualifications)" with command "NEW" for record ""
And I set fields
	| ma   | KELLER         |
	| grad | S2_MECHANIKER  |
And I delete all rows
And I append rows
	| serqual  | gltvon      | gltbis      |
	| Mechanik | 01.01.95    | 01.01.07    |
	| wig      | 01.01.95    | 01.01.04    |
	| Englisch | !dontChange | !dontChange |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-15" from table "(ServiceEmployees):(EmployeeRole)" with command "NEW" for record ""
And I set fields
	| such  | MECHANIKER3  |
	| name  | Mechaniker   |
	| ma    | KOCH         |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-16" from table "(Qualifications):(ListOfQualifications)" with command "NEW" for record ""
And I set fields
	| ma   | KOCH           |
	| grad | S3_MECHANIKER  |
And I delete all rows
And I append rows
	| serqual     | gltvon      | gltbis      |
	| Mechanik    | 01.01.95    | 01.01.07    |
	| wig         | 01.01.95    | 01.01.04    |
	| Englisch    | !dontChange | !dontChange |
	| Franzoesich | !dontChange | !dontChange |
And I save the current editor
 
Given I open an editor "serviceeinsEinsatzmittel-17" from table "(ServiceEmployees):(Team)" with command "NEW" for record ""
And I set fields
	| such     | Team1      |
	| name     | Team eins  |
	| teamleit | karl       |
And I append rows
	| mitarbrolle | gltvon   |
	| Spezialist1 | 01.01.95 |
	| Elektro1    | 01.01.95 |
	| Mechaniker1 | 01.01.95 |
	| Mechaniker2 | 01.01.95 |
And I save the current editor
Given I open an editor "serviceeinsEinsatzmittel-17" from table "(ServiceEmployees):(Team)" with command "NEW" for record ""
And I set fields
	| such     | Team2    |
	| name     | Team zwei|
	| teamleit | meier    |
And I append rows
	| mitarbrolle | gltvon   | gltbis      |
	| Spezialist1 | 01.01.95 | !dontChange |
	| Mechaniker1 | 01.01.95 | 01.01.04    |
And I save the current editor

Given I open an editor "serviceeinsEinsatzart-1" from table "(ServiceAssignment):(AssignmentType)" with command "NEW" for record ""
And I set fields
	| such    | Wartung         |
	| name    | Wartungseingriff|
	| fakt    | ja              |
	| serleis | ja              |
And I save the current editor
Given I open an editor "serviceeinsEinsatzart-1" from table "(ServiceAssignment):(AssignmentType)" with command "NEW" for record ""
And I set fields
	| such    | Stoerung           |
	| name    | Maschinenstillstand|
	| fakt    | ja                 |
	| serleis | ja                 |
And I save the current editor
Given I open an editor "serviceeinsEinsatzart-1" from table "(ServiceAssignment):(AssignmentType)" with command "NEW" for record ""
And I set fields
	| such    | Garantie        |
	| name    | Garantie-Einsatz|
	| fakt    | nein            |
	| serleis | ja              |
And I save the current editor
 
Given I open an editor "lieferantLieferant-1" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "60001" 
And I save the current editor
Given I open an editor "lieferantLieferant-2" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "60002" 
And I save the current editor
Given I open an editor "lieferantLieferant-3" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "60003" 
And I save the current editor
Given I open an editor "lieferantLieferant-4" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "60004" 
And I save the current editor
Given I open an editor "lieferantLieferant-5" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "60005" 
And I save the current editor
Given I open an editor "lieferantLieferant-6" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "60006" 
And I save the current editor
Given I open an editor "lieferantLieferant-7" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "60007" 
And I save the current editor
Given I open an editor "lieferantLieferant-8" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "60008" 
And I save the current editor
 
Given I open an editor "einheitEinheit-2" from table "(Unit):(Unit)" with command "NEW" for record ""
And I set fields
	| such        | AT  |
	| faktor1     | 1   |
	| einheitbspr | at  |
	| faktor2     | 8   |
	| dimension   | Zeit|
And I respond with answer "ja" to the dialog with id "10951"
And I save the current editor
And I close the current editor
  
Given I open an editor "kapazitaetEinheit-3" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 199  |
	| such     | SAEGE|
	| kstelle  | 101  |
	| auslast  | 100  |
	| leist    | 100  |
	| azpt     | 8    |
	| nschicht | 1    |
	| kapaz    | 8    |
	| manz     | 1    |
	| gkapaz   | 8    |
	| name     | Saege|
	| abtlg    | 1    |
And I save the current editor

Given I open an editor "kapazitaetEinheit-4" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 198             |
	| such     | SCHWEISS        |
	| kstelle  | 101             |
	| auslast  | 100             |
	| leist    | 100             |
	| azpt     | 8               |
	| nschicht | 1               |
	| kapaz    | 8               |
	| manz     | 1               |
	| gkapaz   | 8               |
	| name     | Handschweisserei|
	| abtlg    | 1               |
And I save the current editor

  
Given I open an editor "kapazitaetEinheit-5" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 103               |
	| such     | SASTRAHL          |
	| kstelle  | 101               |
	| auslast  | 100               |
	| leist    | 100               |
	| azpt     | 8                 |
	| nschicht | 1                 |
	| kapaz    | 8                 |
	| manz     | 1                 |
	| gkapaz   | 8                 |
	| name     | Sandstrahlmaschine|
	| abtlg    | 1                 |
And I save the current editor

  
Given I open an editor "kapazitaetEinheit-6" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 104        |
	| such     | LACKIER    |
	| kstelle  | 101        |
	| auslast  | 100        |
	| leist    | 100        |
	| azpt     | 8          |
	| nschicht | 1          |
	| kapaz    | 8          |
	| manz     | 1          |
	| gkapaz   | 8          |
	| name     | Lackiererei|
	| abtlg    | 1          |
And I save the current editor

  
Given I open an editor "kapazitaetEinheit-7" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 105          |
	| such     | BIEGEREI     |
	| kstelle  | 101          |
	| auslast  | 100          |
	| leist    | 100          |
	| azpt     | 8            |
	| nschicht | 1            |
	| kapaz    | 8            |
	| manz     | 1            |
	| gkapaz   | 8            |
	| name     | Biegemaschine|
	| abtlg    | 1            |
And I save the current editor

  
Given I open an editor "kapazitaetEinheit-8" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 106                     |
	| such     | MONTAGE                 |
	| kstelle  | 101                     |
	| auslast  | 100                     |
	| leist    | 100                     |
	| azpt     | 8                       |
	| nschicht | 1                       |
	| kapaz    | 8                       |
	| manz     | 1                       |
	| gkapaz   | 8                       |
	| name     | Handarbeitsplatz Montage|
	| abtlg    | 1                       |
And I save the current editor

  
Given I open an editor "kapazitaetEinheit-9" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 107                        |
	| such     | VERPACK                    |
	| kstelle  | 101                        |
	| auslast  | 100                        |
	| leist    | 100                        |
	| azpt     | 8                          |
	| nschicht | 1                          |
	| kapaz    | 8                          |
	| manz     | 1                          |
	| gkapaz   | 8                          |
	| name     | Handarbeitsplatz Verpackung|
	| abtlg    | 1                          |
And I save the current editor

  
Given I open an editor "einheitEinheit-10" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 108         |
	| such     | KONTROLL    |
	| kstelle  | 101         |
	| auslast  | 100         |
	| leist    | 100         |
	| azpt     | 8           |
	| nschicht | 1           |
	| kapaz    | 8           |
	| manz     | 1           |
	| gkapaz   | 8           |
	| name     | Endkontrolle|
	| abtlg    | 1           |
And I save the current editor

  
Given I open an editor "einheitEinheit-11" from table "(Capacity):(WorkCenter)" with command "NEW" for record ""
And I set fields
	| nummer   | 109        |
	| such     | TROFEN     |
	| kstelle  | 101        |
	| auslast  | 100        |
	| leist    | 100        |
	| azpt     | 8          |
	| nschicht | 1          |
	| kapaz    | 8          |
	| manz     | 1          |
	| gkapaz   | 8          |
	| name     | Trockenofen|
	| abtlg    | 1          |
And I save the current editor
Given I open an editor "arbeitsgangArbeitsgang-1" from table "(Operation):(Operation)" with command "NEW" for record ""
And I set fields
	| nummer  | 199                 |
	| such    | ZUSCHNEIDEN         |
	| mgr     | 101                 |
	| grgr    | 1                   |
	| ze      | min                 |
	| zesek   | 60                  |
	| zr      | min                 |
	| zrsek   | 60                  |
	| aschein | ja                  |
	| name    | Material zuschneiden|
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-2" from table "(Operation):(Operation)" with command "NEW" for record ""
And I set fields
	| nummer  | 102       |
	| such    | SCHWEISSEN|
	| mgr     | 198       |
	| grgr    | 1         |
	| ze      | min       |
	| zesek   | 60        |
	| zr      | min       |
	| zrsek   | 60        |
	| aschein | ja        |
	| name    | Schweissen|
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-3" from table "(Operation):(Operation)" with command "NEW" for record ""
And I set fields
	| nummer  | 103          |
	| such    | SANDSTRAHLEN |
	| mgr     | 103          |
	| grgr    | 1            |
	| ze      | min          |
	| zesek   | 60           |
	| zr      | min          |
	| zrsek   | 60           |
	| aschein | ja           |
	| name    | Sandstrahlen |
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-4" from table "(Operation):(Operation)" with command "NEW" for record "" 
 
And I set fields
	| nummer  | 104                |
	| such    | BESCHICHTEN        |
	| mgr     | 104                |
	| grgr    | 1                  |
	| ze      | min                |
	| zesek   | 60                 |
	| zr      | min                |
	| zrsek   | 60                 |
	| aschein | ja                 |
	| name    | Pulverbeschichtung |
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-5" from table "(Operation):(Operation)" with command "NEW" for record ""
 
And I set fields
	| nummer  | 105    |
	| such    | BIEGEN |
	| mgr     | 105    |
	| grgr    | 1      |
	| ze      | min    |
	| zesek   | 60     |
	| zr      | min    |
	| zrsek   | 60     |
	| aschein | ja     |
	| name    | Biegen |
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-6" from table "(Operation):(Operation)" with command "NEW" for record "" 
 
And I set fields
	| nummer  | 106      |
	| such    | MONTIEREN|
	| mgr     | 106      |
	| grgr    | 1        |
	| ze      | min      |
	| zesek   | 60       |
	| zr      | min      |
	| zrsek   | 60       |
	| aschein | ja       |
	| name    | Montieren|
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-7" from table "(Operation):(Operation)" with command "NEW" for record ""
 
And I set fields
	| nummer  | 107                    |
	| such    | VERPACKEN              |
	| mgr     | 107                    |
	| grgr    | 1                      |
	| ze      | min                    |
	| zesek   | 60                     |
	| zr      | min                    |
	| zrsek   | 60                     |
	| aschein | ja                     |
	| name    | Versandfertig verpacken|
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-8" from table "(Operation):(Operation)" with command "NEW" for record "" 
 
And I set fields
	| nummer  | 108                          |
	| such    | ENDKONTROLLE                 |
	| mgr     | 108                          |
	| grgr    | 1                            |
	| ze      | min                          |
	| zesek   | 60                           |
	| zr      | min                          |
	| zrsek   | 60                           |
	| aschein | ja                           |
	| name    | Funktions-/Qualitaetspruefung|
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-10" from table "(Operation):(Operation)" with command "NEW" for record ""
 
And I set fields
	| nummer  | 109                    |
	| such    | TROCKNEN               |
	| mgr     | 109                    |
	| grgr    | 1                      |
	| ze      | min                    |
	| zesek   | 60                     |
	| zr      | min                    |
	| zrsek   | 60                     |
	| aschein | ja                     |
	| name    | Trocknen im Trockenofen|
And I save the current editor

  
Given I open an editor "arbeitsgangArbeitsgang-11" from table "(Operation):(Operation)" with command "NEW" for record ""
 
And I set fields
	| nummer  | 110       |
	| such    | GRUNDIEREN|
	| mgr     | 104       |
	| grgr    | 1         |
	| ze      | min       |
	| zesek   | 60        |
	| zr      | min       |
	| zrsek   | 60        |
	| aschein | ja        |
	| name    | Grundieren|
And I save the current editor
  
Given I open an editor "TeilArtikel-12" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
	| such  | Versandpauschale   |
	| zptyp | AU/BE-Position,BV  |
	| vpr   | 20                 |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Artikel mit Fertigungsliste, Dienstleistungen
# ----------------------------------------------------------------------------------------------
Given I open an editor "TeilArtikel-13" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | GETRIEBEOEL     |
	| vpe        | l               |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | l               |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Getriebeoel     |
	| erab       | 64              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 24.20           |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 64              |
	| prov       | 64              |
	| intrarel   | ja              |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | F3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-14" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO              |
	| such       | OELFILTER_G       |
	| vpe        | Stueck            |
	| vhe        | Stueck            |
	| epe        | Stueck            |
	| ehe        | Stueck            |
	| le         | Stueck            |
	| lme        | mm                |
	| bme        | mm                |
	| fvhe       | 1                 |
	| fehe       | 1                 |
	| fle        | 1                 |
	| fvpe       | 1                 |
	| fepe       | 1                 |
	| skfaehig   | ja                |
	| name       | oelfilter Getriebe|
	| erab       | 65                |
	| ewaehr     | EUR               |
	| ewaehr2    | EUR               |
	| ewaehr3    | EUR               |
	| vpr        | 34.25             |
	| vwaehr     | EUR               |
	| vwaehr2    | EUR               |
	| vrab       | 65                |
	| prov       | 65                |
	| intrarel   | ja                |
	| dispoa     | bedarfsbezogen    |
	| rerelev    | ja                |
	| ge         | Stueck            |
	| ve         | Stueck            |
	| fve        | 1                 |
	| fge        | 1                 |
	| zuplatz    | F1                |
	| abplatz    | F1                |
	| kbpr       | Einkaufspreis     |
	| kbprwaeh   | EUR               |
	| kbprpe     | Stueck            |
	| bsart      | Fremdbeschaffung  |
	| earta      | ueber Artikel     |
	| catsale    | ja                |
	| ersabplatz | f3                |
	| nwpflicht  | ja                |
	| gdauer     | 365D              |
	| chimlager  | ja                |
And I save the current editor
  
Given I open an editor "TeilArtikel-15" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                  |
	| such       | DICHTUNG_GETR         |
	| vpe        | Stueck                |
	| vhe        | Stueck                |
	| epe        | Stueck                |
	| ehe        | Stueck                |
	| le         | Stueck                |
	| lme        | mm                    |
	| bme        | mm                    |
	| fvhe       | 1                     |
	| fehe       | 1                     |
	| fle        | 1                     |
	| fvpe       | 1                     |
	| fepe       | 1                     |
	| skfaehig   | ja                    |
	| name       | Dichtungssatz Getriebe|
	| erab       | 66                    |
	| ewaehr     | EUR                   |
	| ewaehr2    | EUR                   |
	| ewaehr3    | EUR                   |
	| vpr        | 16.85                 |
	| vwaehr     | EUR                   |
	| vwaehr2    | EUR                   |
	| vrab       | 66                    |
	| prov       | 66                    |
	| intrarel   | ja                    |
	| dispoa     | bedarfsbezogen        |
	| rerelev    | ja                    |
	| ge         | Stueck                |
	| ve         | Stueck                |
	| fve        | 1                     |
	| fge        | 1                     |
	| zuplatz    | F1                    |
	| abplatz    | F1                    |
	| kbpr       | Einkaufspreis         |
	| kbprwaeh   | EUR                   |
	| kbprpe     | Stueck                |
	| bsart      | Fremdbeschaffung      |
	| earta      | ueber Artikel         |
	| catsale    | ja                    |
	| ersabplatz | L3F1                  |
	| nwpflicht  | ja                    |
	| gdauer     | 365D                  |
And I save the current editor

  
Given I open an editor "TeilArtikel-16" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                            |
	| such      | BREMSANLAGE-TB                  |
	| vpe       | Stueck                          |
	| vhe       | Stueck                          |
	| epe       | Stueck                          |
	| ehe       | Stueck                          |
	| le        | Stueck                          |
	| lme       | mm                              |
	| bme       | mm                              |
	| fvhe      | 1                               |
	| fehe      | 1                               |
	| fle       | 1                               |
	| fvpe      | 1                               |
	| fepe      | 1                               |
	| skfaehig  | ja                              |
	| name      | TB Bremsanlage komplett montiert|
	| lief      | 60001                           |
	| epr       | 45.00                           |
	| erab      | 10022                           |
	| ewaehr    | EUR                             |
	| ewaehr2   | EUR                             |
	| ewaehr3   | EUR                             |
	| efrist    | 3                               |
	| vorlauf   | 3                               |
	| vwaehr    | EUR                             |
	| vwaehr2   | EUR                             |
	| vrab      | 10022                           |
	| prov      | 10022                           |
	| ebez      | Bremsanlage komplett vormontiert|
	| intrarel  | ja                              |
	| losgr     | 25                              |
	| dispoa    | bedarfsbezogen                  |
	| mindest   | 100                             |
	| rerelev   | ja                              |
	| ge        | Stueck                          |
	| ve        | Stueck                          |
	| fve       | 1                               |
	| fge       | 1                               |
	| zuplatz   | F1                              |
	| abplatz   | F1                              |
	| kbpr      | Einkaufspreis                   |
	| kbprwaeh  | EUR                             |
	| kbprpe    | Stueck                          |
	| bsart     | Fremdbeschaffung                |
	| earta     | ueber Artikel                   |
	| nwpflicht | ja                              |
	| gdauer    | 365D                            |
And I save the current editor

  
Given I open an editor "TeilArtikel-17" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                  |
	| such      | KARTON-GROSS          |
	| vpe       | Stueck                |
	| vhe       | Stueck                |
	| epe       | Stueck                |
	| ehe       | Stueck                |
	| le        | Stueck                |
	| lme       | mm                    |
	| bme       | mm                    |
	| fvhe      | 1                     |
	| fehe      | 1                     |
	| fle       | 1                     |
	| fvpe      | 1                     |
	| fepe      | 1                     |
	| skfaehig  | ja                    |
	| name      | KARTONAGE, gross      |
	| lief      | 60007                 |
	| epr       | 0.50                  |
	| erab      | 10023                 |
	| ewaehr    | EUR                   |
	| ewaehr2   | EUR                   |
	| ewaehr3   | EUR                   |
	| efrist    | 3                     |
	| vorlauf   | 3                     |
	| vwaehr    | EUR                   |
	| vwaehr2   | EUR                   |
	| vrab      | 10023                 |
	| prov      | 10023                 |
	| ebez      | Karton (Verpackungsmaterial);180 x 80 x 150 cm|
	| vbez      | Verpackungsmaterial   |
	| intrarel  | ja                    |
	| losgr     | 100                   |
	| dispoa    | mindestbestandsbezogen|
	| mindest   | 500                   |
	| rerelev   | ja                    |
	| ge        | Stueck                |
	| ve        | Stueck                |
	| fve       | 1                     |
	| fge       | 1                     |
	| zuplatz   | F1                    |
	| abplatz   | F1                    |
	| kbpr      | Einkaufspreis         |
	| kbprwaeh  | EUR                   |
	| kbprpe    | Stueck                |
	| bsart     | Fremdbeschaffung      |
	| earta     | ueber Artikel         |
	| nwpflicht | ja                    |
	| gdauer    | 365D                  |
And I save the current editor

  
Given I open an editor "TeilArtikel-18" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                          |
	| such       | GLUEHBIRNE-HAL                |
	| vpe        | Stueck                        |
	| vhe        | Stueck                        |
	| epe        | Stueck                        |
	| ehe        | Stueck                        |
	| le         | Stueck                        |
	| lme        | mm                            |
	| bme        | mm                            |
	| fvhe       | 1                             |
	| fehe       | 1                             |
	| fle        | 1                             |
	| fvpe       | 1                             |
	| fepe       | 1                             |
	| skfaehig   | ja                            |
	| name       | Halogen Gluehbirne 6 V / 2.4 W|
	| lief       | 60002                         |
	| epr        | 1.25                          |
	| erab       | 10024                         |
	| ewaehr     | EUR                           |
	| ewaehr2    | EUR                           |
	| ewaehr3    | EUR                           |
	| efrist     | 2                             |
	| vorlauf    | 2                             |
	| vpr        | 3.20                          |
	| vwaehr     | EUR                           |
	| vwaehr2    | EUR                           |
	| vrab       | 10024                         |
	| prov       | 10024                         |
	| ebez       | Halogen Gluehbirne 6 V / 2.4 W|
	| vbez       | Halogen Gluehbirne 6 V / 2.4 W fuer;Frontscheinwerfer|
	| vkbez      | Halogen Gluehbirne 6 V / 2.4 W |
	| intrarel   | ja                             |
	| losgr      | 25                             |
	| dispoa     | bedarfsbezogen                 |
	| mindest    | 100                            |
	| rerelev    | ja                             |
	| ge         | Stueck                         |
	| ve         | Stueck                         |
	| fve        | 1                              |
	| fge        | 1                              |
	| zuplatz    | F1                             |
	| abplatz    | F1                             |
	| kbpr       | Einkaufspreis                  |
	| kbprwaeh   | EUR                            |
	| kbprpe     | Stueck                         |
	| bsart      | Fremdbeschaffung               |
	| earta      | ueber Artikel                  |
	| catsale    | ja                             |
	| ersabplatz | f3                             |
	| nwpflicht  | ja                             |
	| gdauer     | 365D                           |
And I save the current editor

  
Given I open an editor "TeilArtikel-19" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                  |
	| such       | GLUEHBIRNE-6V         |
	| vpe        | Stueck                |
	| vhe        | Stueck                |
	| epe        | Stueck                |
	| ehe        | Stueck                |
	| le         | Stueck                |
	| lme        | mm                    |
	| bme        | mm                    |
	| fvhe       | 1                     |
	| fehe       | 1                     |
	| fle        | 1                     |
	| fvpe       | 1                     |
	| fepe       | 1                     |
	| skfaehig   | ja                    |
	| name       | Gluehbirne 6 V / 0.6 W|
	| lief       | 60002                 |
	| epr        | 0.25                  |
	| erab       | 10025                 |
	| ewaehr     | EUR                   |
	| ewaehr2    | EUR                   |
	| ewaehr3    | EUR                   |
	| efrist     | 2                     |
	| vorlauf    | 2                     |
	| vpr        | 2.20                  |
	| vwaehr     | EUR                   |
	| vwaehr2    | EUR                   |
	| vrab       | 10025                 |
	| prov       | 10025                 |
	| ebez       | Gluehbirne 6 V / 0.6 W|
	| vbez       | Gluehbirnebirne 6 V / 0.6 W fuer;Ruecklicht|
	| vkbez      | Gluehbirne 6 V / 0.6 W|
	| intrarel   | ja                    |
	| losgr      | 25                    |
	| dispoa     | bedarfsbezogen        |
	| mindest    | 100                   |
	| rerelev    | ja                    |
	| ge         | Stueck                |
	| ve         | Stueck                |
	| fve        | 1                     |
	| fge        | 1                     |
	| zuplatz    | F1                    |
	| abplatz    | F1                    |
	| kbpr       | Einkaufspreis         |
	| kbprwaeh   | EUR                   |
	| kbprpe     | Stueck                |
	| bsart      | Fremdbeschaffung      |
	| earta      | ueber Artikel         |
	| catsale    | ja                    |
	| ersabplatz | f3                    |
	| nwpflicht  | ja                    |
	| gdauer     | 365D                  |
And I save the current editor

  
Given I open an editor "TeilArtikel-20" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                  |
	| such      | KARTON-MITTEL         |
	| vpe       | Stueck                |
	| vhe       | Stueck                |
	| epe       | Stueck                |
	| ehe       | Stueck                |
	| le        | Stueck                |
	| lme       | mm                    |
	| bme       | mm                    |
	| fvhe      | 1                     |
	| fehe      | 1                     |
	| fle       | 1                     |
	| fvpe      | 1                     |
	| fepe      | 1                     |
	| skfaehig  | ja                    |
	| name      | KARTONAGE, mittel     |
	| lief      | 60007                 |
	| epr       | 0.30                  |
	| erab      | 10026                 |
	| ewaehr    | EUR                   |
	| ewaehr2   | EUR                   |
	| ewaehr3   | EUR                   |
	| efrist    | 3                     |
	| vorlauf   | 3                     |
	| vwaehr    | EUR                   |
	| vwaehr2   | EUR                   |
	| vrab      | 10026                 |
	| prov      | 10026                 |
	| ebez      | Karton (Verpackungsmaterial);100 x 50 x 40 cm|
	| vbez      | Verpackungsmaterial   |
	| intrarel  | ja                    |
	| losgr     | 50                    |
	| dispoa    | mindestbestandsbezogen|
	| mindest   | 100                   |
	| rerelev   | ja                    |
	| ge        | Stueck                |
	| ve        | Stueck                |
	| fve       | 1                     |
	| fge       | 1                     |
	| zuplatz   | F1                    |
	| abplatz   | F1                    |
	| kbpr      | Einkaufspreis         |
	| kbprwaeh  | EUR                   |
	| kbprpe    | Stueck                |
	| bsart     | Fremdbeschaffung      |
	| earta     | ueber Artikel         |
	| nwpflicht | ja                    |
	| gdauer    | 365D                  |
And I save the current editor

  
Given I open an editor "TeilArtikel-21" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                  |
	| such      | KARTON-KLEIN          |
	| vpe       | Stueck                |
	| vhe       | Stueck                |
	| epe       | Stueck                |
	| ehe       | Stueck                |
	| le        | Stueck                |
	| lme       | mm                    |
	| bme       | mm                    |
	| fvhe      | 1                     |
	| fehe      | 1                     |
	| fle       | 1                     |
	| fvpe      | 1                     |
	| fepe      | 1                     |
	| skfaehig  | ja                    |
	| name      | KARTONAGE, klein      |
	| lief      | 60007                 |
	| epr       | 0.25                  |
	| erab      | 10027                 |
	| ewaehr    | EUR                   |
	| ewaehr2   | EUR                   |
	| ewaehr3   | EUR                   |
	| efrist    | 3                     |
	| vorlauf   | 3                     |
	| vwaehr    | EUR                   |
	| vwaehr2   | EUR                   |
	| vrab      | 10027                 |
	| prov      | 10027                 |
	| ebez      | Karton (Verpackungsmaterial);50 x 30 x 30 cm|
	| vbez      | Verpackungsmaterial   |
	| intrarel  | ja                    |
	| losgr     | 50                    |
	| dispoa    | mindestbestandsbezogen|
	| mindest   | 200                   |
	| rerelev   | ja                    |
	| ge        | Stueck                |
	| ve        | Stueck                |
	| fve       | 1                     |
	| fge       | 1                     |
	| zuplatz   | F1                    |
	| abplatz   | F1                    |
	| kbpr      | Einkaufspreis         |
	| kbprwaeh  | EUR                   |
	| kbprpe    | Stueck                |
	| bsart     | Fremdbeschaffung      |
	| earta     | ueber Artikel         |
	| nwpflicht | ja                    |
	| gdauer    | 365D                  |
And I save the current editor

  
Given I open an editor "TeilArtikel-22" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                                |
	| such      | SCHLAUCH26             |
	| vpe       | Stueck                 |
	| vhe       | Stueck                 |
	| epe       | Stueck                 |
	| ehe       | Stueck                 |
	| le        | Stueck                 |
	| lme       | mm                     |
	| bme       | mm                     |
	| fvhe      | 1                      |
	| fehe      | 1                      |
	| fle       | 1                      |
	| fvpe      | 1                      |
	| fepe      | 1                      |
	| skfaehig  | ja                     |
	| name      | Schlauch 26" mit Ventil|
	| lief      | 60008                  |
	| epr       | 2.25                   |
	| erab      | 10028                  |
	| ewaehr    | EUR                    |
	| ewaehr2   | EUR                    |
	| ewaehr3   | EUR                    |
	| efrist    | 2                      |
	| vorlauf   | 2                      |
	| vwaehr    | EUR                    |
	| vwaehr2   | EUR                    |
	| vrab      | 10028                  |
	| prov      | 10028                  |
	| ebez      | Schlauch 26" mit Ventil|
	| vbez      | Fahrrad-Schlauch 26" mit Blitzventil|
	| intrarel  | ja                     |
	| losgr     | 10                     |
	| dispoa    | bedarfsbezogen         |
	| mindest   | 50                     |
	| rerelev   | ja                     |
	| ge        | Stueck                 |
	| ve        | Stueck                 |
	| fve       | 1                      |
	| fge       | 1                      |
	| zuplatz   | F1                     |
	| abplatz   | F1                     |
	| kbpr      | Einkaufspreis          |
	| kbprwaeh  | EUR                    |
	| kbprpe    | Stueck                 |
	| bsart     | Fremdbeschaffung       |
	| earta     | ueber Artikel          |
	| nwpflicht | ja                     |
	| gdauer    | 365D                   |
And I save the current editor

  
Given I open an editor "TeilArtikel-23" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO             |
	| such      | REIFEN26         |
	| vpe       | Stueck           |
	| vhe       | Stueck           |
	| epe       | Stueck           |
	| ehe       | Stueck           |
	| le        | Stueck           |
	| lme       | mm               |
	| bme       | mm               |
	| fvhe      | 1                |
	| fehe      | 1                |
	| fle       | 1                |
	| fvpe      | 1                |
	| fepe      | 1                |
	| skfaehig  | ja               |
	| name      | Reifen/Mantel 26"|
	| lief      | 60008            |
	| epr       | 8.50             |
	| erab      | 10029            |
	| ewaehr    | EUR              |
	| ewaehr2   | EUR              |
	| ewaehr3   | EUR              |
	| efrist    | 2                |
	| vorlauf   | 2                |
	| vwaehr    | EUR              |
	| vwaehr2   | EUR              |
	| vrab      | 10029            |
	| prov      | 10029            |
	| ebez      | Reifen 26"       |
	| vbez      | Fahrrad-Reifen 26";Profil: Trekking/Touring;|
	| intrarel  | ja               |
	| dispoa    | bedarfsbezogen   |
	| rerelev   | ja               |
	| ge        | Stueck           |
	| ve        | Stueck           |
	| fve       | 1                |
	| fge       | 1                |
	| zuplatz   | F1               |
	| abplatz   | F1               |
	| kbpr      | Einkaufspreis    |
	| kbprwaeh  | EUR              |
	| kbprpe    | Stueck           |
	| bsart     | Fremdbeschaffung |
	| earta     | ueber Artikel    |
	| nwpflicht | ja               |
	| gdauer    | 365D             |
And I save the current editor

  
Given I open an editor "TeilArtikel-24" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | FLASCHENHALTER             |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Klick-Fix Flaschenhalter   |
	| lief      | 60004                      |
	| epr       | 4.10                       |
	| erab      | 10030                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| efrist    | 3                          |
	| vorlauf   | 3                          |
	| vpr       | 6.00                       |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10030                      |
	| prov      | 10030                      |
	| ebez      | Flaschenhalter             |
	| vbez      | Klick-Fix Flaschenhalter mit;Universal-Sockel zur einfachen;Nachruestung;|
	| vkbez     | Klick-Fix Flaschenhalter   |
	| intrarel  | ja                         |
	| losgr     | 5                          |
	| dispoa    | bedarfsbezogen             |
	| mindest   | 30                         |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10030.jpg      |
	| catpicsz  | images/part/10030.jpg      |
	| catpicl   | images/part/10030_large.jpg|
	| catpiclz  | images/part/10030_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor
  
Given I open an editor "TeilArtikel-25" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | TRINKFLASCHE               |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Trinkflasche 0,5l          |
	| lief      | 60004                      |
	| epr       | 8.50                       |
	| erab      | 10031                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| efrist    | 4                          |
	| vorlauf   | 4                          |
	| vpr       | 11.00                      |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10031                      |
	| prov      | 10031                      |
	| ebez      | Alu-Trinkflasche 0,5l      |
	| vbez      | Alu-Trinkflasche 0,5l      |
	| intrarel  | ja                         |
	| losgr     | 5                          |
	| dispoa    | bedarfsbezogen             |
	| mindest   | 30                         |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10031.jpg      |
	| catpicsz  | images/part/10031.jpg      |
	| catpicl   | images/part/10031_large.jpg|
	| catpiclz  | images/part/10031_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-26" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                      |
	| such       | ROHR-ST-22*1.4            |
	| vpe        | m                         |
	| vhe        | m                         |
	| epe        | m                         |
	| ehe        | m                         |
	| le         | Stueck                    |
	| lme        | m                         |
	| bme        | m                         |
	| flme       | 2                         |
	| fvhe       | 2                         |
	| fehe       | 2                         |
	| fle        | 1                         |
	| fvpe       | 2                         |
	| fepe       | 1                         |
	| skfaehig   | ja                        |
	| name       | Stahlrohr ST37-2 22*1.4 mm|
	| lief       | 60004                     |
	| epr        | 2.00                      |
	| erab       | 10032                     |
	| ewaehr     | EUR                       |
	| ewaehr2    | EUR                       |
	| ewaehr3    | EUR                       |
	| efrist     | 2                         |
	| vorlauf    | 2                         |
	| vpr        | 7.45                      |
	| vwaehr     | EUR                       |
	| vwaehr2    | EUR                       |
	| vrab       | 10032                     |
	| prov       | 10032                     |
	| ebez       | ST37-2 22*1.4 mm          |
	| intrarel   | ja                        |
	| losgr      | 10                        |
	| dispoa     | bedarfsbezogen            |
	| mindest    | 80                        |
	| rerelev    | ja                        |
	| ge         | m                         |
	| ve         | m                         |
	| fve        | 2                         |
	| fge        | 2                         |
	| zuplatz    | F1                        |
	| abplatz    | F1                        |
	| kbpr       | Einkaufspreis             |
	| kbprwaeh   | EUR                       |
	| kbprpe     | Stueck                    |
	| bsart      | Fremdbeschaffung          |
	| earta      | ueber Artikel             |
	| catsale    | ja                        |
	| ersabplatz | f3                        |
	| nwpflicht  | ja                        |
	| gdauer     | 365D                      |
And I save the current editor

  
Given I open an editor "TeilArtikel-27" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                      |
	| such      | ROHR-ST-20*1.2            |
	| vpe       | m                         |
	| vhe       | m                         |
	| epe       | m                         |
	| ehe       | m                         |
	| le        | Stueck                    |
	| lme       | m                         |
	| bme       | m                         |
	| flme      | 2                         |
	| fvhe      | 2                         |
	| fehe      | 2                         |
	| fle       | 1                         |
	| fvpe      | 2                         |
	| fepe      | 2                         |
	| skfaehig  | ja                        |
	| name      | Stahlrohr ST37-2 20*1.2 mm|
	| lief      | 60004                     |
	| epr       | 1.80                      |
	| erab      | 10033                     |
	| ewaehr    | EUR                       |
	| ewaehr2   | EUR                       |
	| ewaehr3   | EUR                       |
	| efrist    | 2                         |
	| vorlauf   | 2                         |
	| vwaehr    | EUR                       |
	| vwaehr2   | EUR                       |
	| vrab      | 10033                     |
	| prov      | 10033                     |
	| ebez      | ST37-2 20*1.2 mm          |
	| intrarel  | ja                        |
	| losgr     | 5                         |
	| dispoa    | bedarfsbezogen            |
	| mindest   | 10                        |
	| rerelev   | ja                        |
	| ge        | m                         |
	| ve        | m                         |
	| fve       | 2                         |
	| fge       | 2                         |
	| zuplatz   | F1                        |
	| abplatz   | F1                        |
	| kbpr      | Einkaufspreis             |
	| kbprwaeh  | EUR                       |
	| kbprpe    | Stueck                    |
	| bsart     | Fremdbeschaffung          |
	| earta     | ueber Artikel             |
	| nwpflicht | ja                        |
	| gdauer    | 365D                      |
And I save the current editor

  
Given I open an editor "TeilArtikel-28" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                      |
	| such       | ROHR-ST-16*1.2            |
	| vpe        | m                         |
	| vhe        | m                         |
	| epe        | m                         |
	| ehe        | m                         |
	| le         | Stueck                    |
	| lme        | m                         |
	| bme        | m                         |
	| flme       | 2                         |
	| fvhe       | 2                         |
	| fehe       | 2                         |
	| fle        | 1                         |
	| fvpe       | 2                         |
	| fepe       | 2                         |
	| skfaehig   | ja                        |
	| name       | Stahlrohr ST37-2 16*1.2 mm|
	| lief       | 60004                     |
	| epr        | 1.00                      |
	| erab       | 10034                     |
	| ewaehr     | EUR                       |
	| ewaehr2    | EUR                       |
	| ewaehr3    | EUR                       |
	| efrist     | 2                         |
	| vorlauf    | 2                         |
	| vpr        | 10.00                     |
	| vwaehr     | EUR                       |
	| vwaehr2    | EUR                       |
	| vrab       | 10034                     |
	| prov       | 10034                     |
	| ebez       | ST37-2 16*1.2 mm          |
	| intrarel   | ja                        |
	| losgr      | 10                        |
	| dispoa     | bedarfsbezogen            |
	| mindest    | 50                        |
	| rerelev    | ja                        |
	| ge         | m                         |
	| ve         | m                         |
	| fve        | 2                         |
	| fge        | 2                         |
	| zuplatz    | F1                        |
	| abplatz    | F1                        |
	| kbpr       | Einkaufspreis             |
	| kbprwaeh   | EUR                       |
	| kbprpe     | Stueck                    |
	| bsart      | Fremdbeschaffung          |
	| earta      | ueber Artikel             |
	| ersabplatz | f3                        |
	| nwpflicht  | ja                        |
	| gdauer     | 365D                      |
And I save the current editor

  
Given I open an editor "TeilArtikel-29" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | LACK-SILBER     |
	| vpe       | l               |
	| vhe       | l               |
	| epe       | l               |
	| ehe       | l               |
	| le        | l               |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | Metallic-Pulverlack silber    |
	| lief      | 60005           |
	| epr       | 4.00            |
	| erab      | 10035           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 3               |
	| vorlauf   | 3               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10035           |
	| prov      | 10035           |
	| ebez      | Metallic-Pulverlack R70 silber|
	| intrarel  | ja              |
	| losgr     | 25              |
	| dispoa    | bedarfsbezogen  |
	| mindest   | 100             |
	| rerelev   | ja              |
	| ge        | l               |
	| ve        | l               |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-30" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO               |
	| such      | VORDERRAD-C        |
	| vpe       | Stueck             |
	| vhe       | Stueck             |
	| epe       | Stueck             |
	| ehe       | Stueck             |
	| le        | Stueck             |
	| lme       | mm                 |
	| bme       | mm                 |
	| fvhe      | 1                  |
	| fehe      | 1                  |
	| fle       | 1                  |
	| fvpe      | 1                  |
	| fepe      | 1                  |
	| skfaehig  | ja                 |
	| name      | City Bike Vorderrad kompl. mont.    |
	| lief      | 60002              |
	| epr       | 24.50              |
	| erab      | 10036              |
	| ewaehr    | EUR                |
	| ewaehr2   | EUR                |
	| ewaehr3   | EUR                |
	| efrist    | 2                  |
	| vorlauf   | 2                  |
	| vwaehr    | EUR                |
	| vwaehr2   | EUR                |
	| vrab      | 10036              |
	| prov      | 10036              |
	| ebez      | Vorderrad komplett |
	| vbez      | City Vorderrad;komplett mit Schlauch|
	| intrarel  | ja                 |
	| losgr     | 25                 |
	| dispoa    | bedarfsbezogen     |
	| mindest   | 50                 |
	| rerelev   | ja                 |
	| ge        | Stueck             |
	| ve        | Stueck             |
	| fve       | 1                  |
	| fge       | 1                  |
	| zuplatz   | F1                 |
	| abplatz   | F1                 |
	| kbpr      | Einkaufspreis      |
	| kbprwaeh  | EUR                |
	| kbprpe    | Stueck             |
	| bsart     | Fremdbeschaffung   |
	| earta     | ueber Artikel      |
	| nwpflicht | ja                 |
	| gdauer    | 365D               |
And I save the current editor

  
Given I open an editor "TeilArtikel-31" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                     |
	| such       | LA15000                  |
	| vpe        | Stueck                   |
	| vhe        | Stueck                   |
	| epe        | Stueck                   |
	| ehe        | Stueck                   |
	| le         | Stueck                   |
	| lme        | mm                       |
	| bme        | mm                       |
	| fvhe       | 1                        |
	| fehe       | 1                        |
	| fle        | 1                        |
	| fvpe       | 1                        |
	| fepe       | 1                        |
	| skfaehig   | ja                       |
	| name       | Lasereinheit 15000 Watt  |
	| lief       | 60002                    |
	| epr        | 18.90                    |
	| erab       | 10037                    |
	| ewaehr     | EUR                      |
	| ewaehr2    | EUR                      |
	| ewaehr3    | EUR                      |
	| efrist     | 3                        |
	| vorlauf    | 3                        |
	| vpr        | 9000.00                  |
	| vwaehr     | EUR                      |
	| vwaehr2    | EUR                      |
	| vrab       | 10037                    |
	| prov       | 10037                    |
	| ebez       | Tretlagereinheit komplett|
	| vbez       | Lasereinheit 15000 Watt  |
	| intrarel   | ja                       |
	| losgr      | 10                       |
	| dispoa     | bedarfsbezogen           |
	| mindest    | 50                       |
	| rerelev    | ja                       |
	| ge         | Stueck                   |
	| ve         | Stueck                   |
	| fve        | 1                        |
	| fge        | 1                        |
	| zuplatz    | F1                       |
	| abplatz    | F1                       |
	| kbpr       | Einkaufspreis            |
	| kbprwaeh   | EUR                      |
	| kbprpe     | Stueck                   |
	| bsart      | Fremdbeschaffung         |
	| earta      | ueber Artikel            |
	| ersabplatz | f3                       |
	| nwpflicht  | ja                       |
	| gdauer     | 365D                     |
And I save the current editor

  
Given I open an editor "TeilArtikel-32" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                      |
	| such       | LA25000                   |
	| vpe        | Stueck                    |
	| vhe        | Stueck                    |
	| epe        | Stueck                    |
	| ehe        | Stueck                    |
	| le         | Stueck                    |
	| lme        | mm                        |
	| bme        | mm                        |
	| fvhe       | 1                         |
	| fehe       | 1                         |
	| fle        | 1                         |
	| fvpe       | 1                         |
	| fepe       | 1                         |
	| skfaehig   | ja                        |
	| name       | Lasereinheit 25000 Watt   |
	| lief       | 60002                     |
	| epr        | 1.15                      |
	| erab       | 10038                     |
	| ewaehr     | EUR                       |
	| ewaehr2    | EUR                       |
	| ewaehr3    | EUR                       |
	| efrist     | 3                         |
	| vorlauf    | 3                         |
	| vpr        | 3720.00                   |
	| vwaehr     | EUR                       |
	| vwaehr2    | EUR                       |
	| vrab       | 10038                     |
	| prov       | 10038                     |
	| ebez       | Pedale Kunststoff, Schwarz|
	| vbez       | Lasereinheit 25000 Watt   |
	| intrarel   | ja                        |
	| losgr      | 100                       |
	| dispoa     | mindestbestandsbezogen    |
	| mindest    | 100                       |
	| rerelev    | ja                        |
	| ge         | Stueck                    |
	| ve         | Stueck                    |
	| fve        | 1                         |
	| fge        | 1                         |
	| zuplatz    | F1                        |
	| abplatz    | F1                        |
	| kbpr       | Einkaufspreis             |
	| kbprwaeh   | EUR                       |
	| kbprpe     | Stueck                    |
	| bsart      | Fremdbeschaffung          |
	| earta      | ueber Artikel             |
	| ersabplatz | f3                        |
	| nwpflicht  | ja                        |
	| gdauer     | 365D                      |
And I save the current editor

  
Given I open an editor "TeilArtikel-33" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                   |
	| such       | LA40000                |
	| vpe        | Stueck                 |
	| vhe        | Stueck                 |
	| epe        | Stueck                 |
	| ehe        | Stueck                 |
	| le         | Stueck                 |
	| lme        | mm                     |
	| bme        | mm                     |
	| fvhe       | 1                      |
	| fehe       | 1                      |
	| fle        | 1                      |
	| fvpe       | 1                      |
	| fepe       | 1                      |
	| skfaehig   | ja                     |
	| name       | Lasereinheit 40000 Watt|
	| lief       | 60002                  |
	| epr        | 44.60                  |
	| erab       | 10039                  |
	| ewaehr     | EUR                    |
	| ewaehr2    | EUR                    |
	| ewaehr3    | EUR                    |
	| efrist     | 2                      |
	| vorlauf    | 2                      |
	| vwaehr     | EUR                    |
	| vwaehr2    | EUR                    |
	| vrab       | 10039                  |
	| prov       | 10039                  |
	| ebez       | Hinterrad komplett     |
	| vbez       | Lasereinheit 40000 Watt|
	| intrarel   | ja                     |
	| losgr      | 25                     |
	| dispoa     | bedarfsbezogen         |
	| mindest    | 50                     |
	| rerelev    | ja                     |
	| ge         | Stueck                 |
	| ve         | Stueck                 |
	| fve        | 1                      |
	| fge        | 1                      |
	| zuplatz    | F1                     |
	| abplatz    | F1                     |
	| kbpr       | Einkaufspreis          |
	| kbprwaeh   | EUR                    |
	| kbprpe     | Stueck                 |
	| bsart      | Fremdbeschaffung       |
	| earta      | ueber Artikel          |
	| ersabplatz | f3                     |
	| nwpflicht  | ja                     |
	| gdauer     | 365D                   |
And I save the current editor
 
Given I open an editor "TeilArtikel-34" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO               |
	| such      | KETTE-100G         |
	| vpe       | Stueck             |
	| vhe       | Stueck             |
	| epe       | Stueck             |
	| ehe       | Stueck             |
	| le        | Stueck             |
	| lme       | mm                 |
	| bme       | mm                 |
	| fvhe      | 1                  |
	| fehe      | 1                  |
	| fle       | 1                  |
	| fvpe      | 1                  |
	| fepe      | 1                  |
	| skfaehig  | ja                 |
	| name      | Kette - 100 Glieder|
	| lief      | 60001              |
	| epr       | 7.40               |
	| erab      | 10040              |
	| ewaehr    | EUR                |
	| ewaehr2   | EUR                |
	| ewaehr3   | EUR                |
	| efrist    | 3                  |
	| vorlauf   | 3                  |
	| vwaehr    | EUR                |
	| vwaehr2   | EUR                |
	| vrab      | 10040              |
	| prov      | 10040              |
	| ebez      | Kette 100 Glieder  |
	| vbez      | Fahrrad-Kette, 100 Glieder|
	| intrarel  | ja                 |
	| losgr     | 50                 |
	| dispoa    | bedarfsbezogen     |
	| mindest   | 100                |
	| rerelev   | ja                 |
	| ge        | Stueck             |
	| ve        | Stueck             |
	| fve       | 1                  |
	| fge       | 1                  |
	| zuplatz   | F1                 |
	| abplatz   | F1                 |
	| kbpr      | Einkaufspreis      |
	| kbprwaeh  | EUR                |
	| kbprpe    | Stueck             |
	| bsart     | Fremdbeschaffung   |
	| earta     | ueber Artikel      |
	| nwpflicht | ja                 |
	| gdauer    | 365D               |
And I save the current editor

  
Given I open an editor "TeilArtikel-35" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | KETTENSCHUTZ-C  |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | C Kettenkasten aus ABS schwarz                       |
	| lief      | 60002           |
	| epr       | 3.25            |
	| erab      | 10041           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 2               |
	| vorlauf   | 2               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10041           |
	| prov      | 10041           |
	| ebez      | Kettenkasten aus ABS, schwarz                        |
	| vbez      | Kettenschutz 24-26" aus ABS-Kunststoff;Farbe: schwarz|
	| intrarel  | ja              |
	| losgr     | 25              |
	| dispoa    | bedarfsbezogen  |
	| mindest   | 50              |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-36" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | SCHALTWERK6     |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | Schaltwerk 6 Gang komplett         |
	| lief      | 60001           |
	| epr       | 96.40           |
	| erab      | 10042           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 5               |
	| vorlauf   | 5               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10042           |
	| prov      | 10042           |
	| ebez      | Schaltwerk 6 Gang komplett montiert|
	| intrarel  | ja              |
	| losgr     | 30              |
	| dispoa    | bedarfsbezogen  |
	| mindest   | 100             |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-37" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                     |
	| such      | SATTEL-CITY              |
	| vpe       | Stueck                   |
	| vhe       | Stueck                   |
	| epe       | Stueck                   |
	| ehe       | Stueck                   |
	| le        | Stueck                   |
	| lme       | mm                       |
	| bme       | mm                       |
	| fvhe      | 1                        |
	| fehe      | 1                        |
	| fle       | 1                        |
	| fvpe      | 1                        |
	| fepe      | 1                        |
	| skfaehig  | ja                       |
	| name      | City Bike Sattel, schwarz|
	| lief      | 60002                    |
	| epr       | 18.50                    |
	| erab      | 10043                    |
	| ewaehr    | EUR                      |
	| ewaehr2   | EUR                      |
	| ewaehr3   | EUR                      |
	| efrist    | 3                        |
	| vorlauf   | 3                        |
	| vwaehr    | EUR                      |
	| vwaehr2   | EUR                      |
	| vrab      | 10043                    |
	| prov      | 10043                    |
	| ebez      | Ergogel-Plus Tourensattel schwarz                                         |
	| vbez      | Fahrrad-Sattel mit Ergogel-Plus;Polsterung f�uer City Bikes;Farbe: schwarz|
	| intrarel  | ja                       |
	| losgr     | 10                       |
	| dispoa    | bedarfsbezogen           |
	| mindest   | 50                       |
	| rerelev   | ja                       |
	| ge        | Stueck                   |
	| ve        | Stueck                   |
	| fve       | 1                        |
	| fge       | 1                        |
	| zuplatz   | F1                       |
	| abplatz   | F1                       |
	| kbpr      | Einkaufspreis            |
	| kbprwaeh  | EUR                      |
	| kbprpe    | Stueck                   |
	| bsart     | Fremdbeschaffung         |
	| earta     | ueber Artikel            |
	| nwpflicht | ja                       |
	| gdauer    | 365D                     |
And I save the current editor

  
Given I open an editor "TeilArtikel-38" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | LENKER-CITY     |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | City Lenker 560mm mit Vorbau                                    |
	| lief      | 60002           |
	| epr       | 19.80           |
	| erab      | 10044           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 2               |
	| vorlauf   | 2               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10044           |
	| prov      | 10044           |
	| ebez      | Fahrrradlenker incl. Vorbau Typ "City"                          |
	| vbez      | Fahrrradlenker incl. Vorbau;Typ "Tourer" f�uer Trekking und City|
	| intrarel  | ja              |
	| losgr     | 10              |
	| dispoa    | bedarfsbezogen  |
	| mindest   | 50              |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-39" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | BREMSANLAGE-C   |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | City B. Bremsanlage kompl. mont.|
	| lief      | 60001           |
	| epr       | 45.00           |
	| erab      | 10045           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 3               |
	| vorlauf   | 3               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10045           |
	| prov      | 10045           |
	| ebez      | Bremsanlage komplett vormontiert|
	| intrarel  | ja              |
	| losgr     | 25              |
	| dispoa    | bedarfsbezogen  |
	| mindest   | 100             |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-40" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | ROHR-ST-65*1.5  |
	| vpe        | m               |
	| vhe        | m               |
	| epe        | m               |
	| ehe        | m               |
	| le         | Stueck          |
	| lme        | m               |
	| bme        | m               |
	| flme       | 2               |
	| fvhe       | 2               |
	| fehe       | 2               |
	| fle        | 1               |
	| fvpe       | 2               |
	| fepe       | 2               |
	| skfaehig   | ja              |
	| name       | Stahlrohr ST37-2 65*1.5 mm|
	| lief       | 60004           |
	| epr        | 1.80            |
	| erab       | 10046           |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| efrist     | 2               |
	| vorlauf    | 2               |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 10046           |
	| prov       | 10046           |
	| ebez       | ST37-2 65*1.5 mm|
	| intrarel   | ja              |
	| losgr      | 5               |
	| dispoa     | bedarfsbezogen  |
	| mindest    | 10              |
	| rerelev    | ja              |
	| ge         | m               |
	| ve         | m               |
	| fve        | 2               |
	| fge        | 2               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-41" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                       |
	| such       | FLACH-ST-30*1.5            |
	| vpe        | m                          |
	| vhe        | m                          |
	| epe        | m                          |
	| ehe        | m                          |
	| le         | Stueck                     |
	| lme        | m                          |
	| bme        | m                          |
	| flme       | 2                          |
	| fvhe       | 2                          |
	| fehe       | 2                          |
	| fle        | 1                          |
	| fvpe       | 2                          |
	| fepe       | 2                          |
	| skfaehig   | ja                         |
	| name       | Flachstahl ST37-2 65*1.5 mm|
	| lief       | 60004                      |
	| epr        | 1.80                       |
	| erab       | 10047                      |
	| ewaehr     | EUR                        |
	| ewaehr2    | EUR                        |
	| ewaehr3    | EUR                        |
	| efrist     | 2                          |
	| vorlauf    | 2                          |
	| vwaehr     | EUR                        |
	| vwaehr2    | EUR                        |
	| vrab       | 10047                      |
	| prov       | 10047                      |
	| ebez       | ST37-2 30*1.5 mm           |
	| vbez       | Flachstahl ST37-2 65*1.5 mm|
	| vkbez      | Flachstahl ST37-2 65*1.5 mm|
	| intrarel   | ja                         |
	| losgr      | 5                          |
	| dispoa     | bedarfsbezogen             |
	| mindest    | 10                         |
	| rerelev    | ja                         |
	| ge         | m                          |
	| ve         | m                          |
	| fve        | 2                          |
	| fge        | 2                          |
	| zuplatz    | F1                         |
	| abplatz    | F1                         |
	| kbpr       | Einkaufspreis              |
	| kbprwaeh   | EUR                        |
	| kbprpe     | Stueck                     |
	| bsart      | Fremdbeschaffung           |
	| earta      | ueber Artikel              |
	| catsale    | ja                         |
	| ersabplatz | f3                         |
	| nwpflicht  | ja                         |
	| gdauer     | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-42" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO              |
	| such      | PROFIL-ST         |
	| vpe       | m                 |
	| vhe       | m                 |
	| epe       | m                 |
	| ehe       | m                 |
	| le        | Stueck            |
	| lme       | m                 |
	| bme       | m                 |
	| flme      | 2                 |
	| fvhe      | 2                 |
	| fehe      | 2                 |
	| fle       | 1                 |
	| fvpe      | 2                 |
	| fepe      | 2                 |
	| skfaehig  | ja                |
	| name      | Profilstahl ST37-2|
	| lief      | 60004             |
	| epr       | 1.80              |
	| erab      | 10048             |
	| ewaehr    | EUR               |
	| ewaehr2   | EUR               |
	| ewaehr3   | EUR               |
	| efrist    | 2                 |
	| vorlauf   | 2                 |
	| vwaehr    | EUR               |
	| vwaehr2   | EUR               |
	| vrab      | 10048             |
	| prov      | 10048             |
	| ebez      | Profilstahl ST37-2|
	| intrarel  | ja                |
	| losgr     | 5                 |
	| dispoa    | bedarfsbezogen    |
	| mindest   | 10                |
	| rerelev   | ja                |
	| ge        | m                 |
	| ve        | m                 |
	| fve       | 2                 |
	| fge       | 2                 |
	| zuplatz   | F1                |
	| abplatz   | F1                |
	| kbpr      | Einkaufspreis     |
	| kbprwaeh  | EUR               |
	| kbprpe    | Stueck            |
	| bsart     | Fremdbeschaffung  |
	| earta     | ueber Artikel     |
	| nwpflicht | ja                |
	| gdauer    | 365D              |
And I save the current editor

  
Given I open an editor "TeilArtikel-43" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | GELENK          |
	| vpe        | Stueck          |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | Stueck          |
	| lme        | m               |
	| bme        | m               |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Gelenk          |
	| lief       | 60004           |
	| epr        | 1.80            |
	| erab       | 10049           |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| efrist     | 2               |
	| vorlauf    | 2               |
	| vpr        | 12.35           |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 10049           |
	| prov       | 10049           |
	| ebez       | Gelenk          |
	| vbez       | Gelenk          |
	| vkbez      | Gelenk          |
	| intrarel   | ja              |
	| losgr      | 5               |
	| dispoa     | bedarfsbezogen  |
	| mindest    | 10              |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-44" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                 |
	| such      | FUSSKAPPE            |
	| vpe       | Stueck               |
	| vhe       | Stueck               |
	| epe       | Stueck               |
	| ehe       | Stueck               |
	| le        | Stueck               |
	| lme       | mm                   |
	| bme       | mm                   |
	| fvhe      | 1                    |
	| fehe      | 1                    |
	| fle       | 1                    |
	| fvpe      | 1                    |
	| fepe      | 1                    |
	| skfaehig  | ja                   |
	| name      | Fuuekappe rund, Gummi|
	| lief      | 60008                |
	| epr       | 0.05                 |
	| erab      | 10050                |
	| ewaehr    | EUR                  |
	| ewaehr2   | EUR                  |
	| ewaehr3   | EUR                  |
	| efrist    | 1                    |
	| vorlauf   | 1                    |
	| vwaehr    | EUR                  |
	| vwaehr2   | EUR                  |
	| vrab      | 10050                |
	| prov      | 10050                |
	| ebez      | Fuuekappe            |
	| intrarel  | ja                   |
	| dispoa    | bedarfsbezogen       |
	| rerelev   | ja                   |
	| ge        | Stueck               |
	| ve        | Stueck               |
	| fve       | 1                    |
	| fge       | 1                    |
	| zuplatz   | F1                   |
	| abplatz   | F1                   |
	| kbpr      | Einkaufspreis        |
	| kbprwaeh  | EUR                  |
	| kbprpe    | Stueck               |
	| bsart     | Fremdbeschaffung     |
	| earta     | ueber Artikel        |
	| nwpflicht | ja                   |
	| gdauer    | 365D                 |
And I save the current editor

  
Given I open an editor "TeilArtikel-45" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                      |
	| such      | BLECH-ST-5*1.2            |
	| vpe       | m                         |
	| vhe       | m                         |
	| epe       | m                         |
	| ehe       | m                         |
	| le        | Stueck                    |
	| lme       | m                         |
	| bme       | m                         |
	| flme      | 2                         |
	| fvhe      | 2                         |
	| fehe      | 2                         |
	| fle       | 1                         |
	| fvpe      | 2                         |
	| fepe      | 2                         |
	| skfaehig  | ja                        |
	| name      | Stahlblech ST37-2 5*1.2 mm|
	| lief      | 60004                     |
	| epr       | 1.00                      |
	| erab      | 10051                     |
	| ewaehr    | EUR                       |
	| ewaehr2   | EUR                       |
	| ewaehr3   | EUR                       |
	| efrist    | 2                         |
	| vorlauf   | 2                         |
	| vwaehr    | EUR                       |
	| vwaehr2   | EUR                       |
	| vrab      | 10051                     |
	| prov      | 10051                     |
	| ebez      | Blech ST37-2 5*1.2 mm     |
	| intrarel  | ja                        |
	| losgr     | 10                        |
	| dispoa    | bedarfsbezogen            |
	| mindest   | 50                        |
	| rerelev   | ja                        |
	| ge        | m                         |
	| ve        | m                         |
	| fve       | 2                         |
	| fge       | 2                         |
	| zuplatz   | F1                        |
	| abplatz   | F1                        |
	| kbpr      | Einkaufspreis             |
	| kbprwaeh  | EUR                       |
	| kbprpe    | Stueck                    |
	| bsart     | Fremdbeschaffung          |
	| earta     | ueber Artikel             |
	| nwpflicht | ja                        |
	| gdauer    | 365D                      |
And I save the current editor

  
Given I open an editor "TeilArtikel-46" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | HANDKURBEL      |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | Handkurbel      |
	| lief      | 60004           |
	| epr       | 0.85            |
	| erab      | 10052           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 2               |
	| vorlauf   | 2               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10052           |
	| prov      | 10052           |
	| ebez      | Handkurbel      |
	| intrarel  | ja              |
	| dispoa    | bedarfsbezogen  |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-47" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | LAGER           |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | Lager           |
	| lief      | 60004           |
	| epr       | 1.05            |
	| erab      | 10053           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 2               |
	| vorlauf   | 2               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10053           |
	| prov      | 10053           |
	| ebez      | Lager           |
	| intrarel  | ja              |
	| dispoa    | bedarfsbezogen  |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-48" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | WIRBELSTR-BREMS |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | Wirbelstrombremse mit Fernbed.      |
	| lief      | 60004           |
	| epr       | 38.90           |
	| erab      | 10054           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 2               |
	| vorlauf   | 2               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10054           |
	| prov      | 10054           |
	| ebez      | Wirbelstrombremse mit Lenkerschalter|
	| intrarel  | ja              |
	| dispoa    | bedarfsbezogen  |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-49" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | FUSSPEDAL       |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| name      | Fuuepedal       |
	| lief      | 60004           |
	| epr       | 1.75            |
	| erab      | 10055           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| efrist    | 2               |
	| vorlauf   | 2               |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10055           |
	| prov      | 10055           |
	| ebez      | Fu�pedal      |
	| intrarel  | ja              |
	| dispoa    | bedarfsbezogen  |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-50" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO            |
	| such      | ZZZZ            |
	| vpe       | Stueck          |
	| vhe       | Stueck          |
	| epe       | Stueck          |
	| ehe       | Stueck          |
	| le        | Stueck          |
	| lme       | mm              |
	| bme       | mm              |
	| fvhe      | 1               |
	| fehe      | 1               |
	| fle       | 1               |
	| fvpe      | 1               |
	| fepe      | 1               |
	| skfaehig  | ja              |
	| erab      | 10056           |
	| ewaehr    | EUR             |
	| ewaehr2   | EUR             |
	| ewaehr3   | EUR             |
	| vwaehr    | EUR             |
	| vwaehr2   | EUR             |
	| vrab      | 10056           |
	| prov      | 10056           |
	| intrarel  | ja              |
	| dispoa    | bedarfsbezogen  |
	| rerelev   | ja              |
	| ge        | Stueck          |
	| ve        | Stueck          |
	| fve       | 1               |
	| fge       | 1               |
	| zuplatz   | F1              |
	| abplatz   | F1              |
	| kbpr      | Einkaufspreis   |
	| kbprwaeh  | EUR             |
	| kbprpe    | Stueck          |
	| bsart     | Fremdbeschaffung|
	| earta     | ueber Artikel   |
	| nwpflicht | ja              |
	| gdauer    | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-51" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | ARMLINGE                   |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Armlinge                   |
	| erab      | 10057                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 20.00                      |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10057                      |
	| prov      | 10057                      |
	| ebez      | Armlinge                   |
	| vbez      | Armlinge                   |
	| vkbez     | Armlinge                   |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10057.jpg      |
	| catpicsz  | images/part/10057.jpg      |
	| catpicl   | images/part/10057_large.jpg|
	| catpiclz  | images/part/10057_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-52" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | BEINLINGE                  |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Beinlinge                  |
	| erab      | 10058                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 29.99                      |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10058                      |
	| prov      | 10058                      |
	| ebez      | Beinlinge                  |
	| vbez      | Beinlinge                  |
	| vkbez     | Beinling                   |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10058.jpg      |
	| catpicsz  | images/part/10058.jpg      |
	| catpicl   | images/part/10058_large.jpg|
	| catpiclz  | images/part/10058_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-53" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | AIRJACK851BLAU             |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Air Jack 851 blau          |
	| erab      | 10059                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 69.90                      |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10059                      |
	| prov      | 10059                      |
	| ebez      | Air Jack 851 blau          |
	| vbez      | Air Jack 851 blau          |
	| vkbez     | Air Jack 851 blau          |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10059.jpg      |
	| catpicsz  | images/part/10059.jpg      |
	| catpicl   | images/part/10059_large.jpg|
	| catpiclz  | images/part/10059_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-54" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | TRINKFLALU                 |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Trinkflasche Alu           |
	| erab      | 10060                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 8.00                       |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10060                      |
	| prov      | 10060                      |
	| ebez      | Trinkflasche Alu           |
	| vbez      | Trinkflasche Alu           |
	| vkbez     | Trinkflasche Alu           |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10060.jpg      |
	| catpicsz  | images/part/10060.jpg      |
	| catpicl   | images/part/10060_large.jpg|
	| catpiclz  | images/part/10060_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-55" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | TRINKFLCOKE                |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Trinkflasche Coke          |
	| erab      | 10061                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 4.00                       |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10061                      |
	| prov      | 10061                      |
	| ebez      | Trinkflasche Coke          |
	| vbez      | Trinkflasche Coke          |
	| vkbez     | Trinkflasche Coke          |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10061.jpg      |
	| catpicsz  | images/part/10061.jpg      |
	| catpicl   | images/part/10061_large.jpg|
	| catpiclz  | images/part/10061_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

Given I open an editor "TeilArtikel-56" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | BREMSHEBEL                 |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Bremsschalthebel           |
	| erab      | 10062                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 20.00                      |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10062                      |
	| prov      | 10062                      |
	| ebez      | Bremsschalthebel           |
	| vbez      | Bremsschalthebel           |
	| vkbez     | Bremsschalthebel           |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10062.jpg      |
	| catpicsz  | images/part/10062.jpg      |
	| catpicl   | images/part/10062_large.jpg|
	| catpiclz  | images/part/10062_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-57" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | DAUMENHEBEL                |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Damenschalthebel           |
	| erab      | 10063                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 25.00                      |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10063                      |
	| prov      | 10063                      |
	| ebez      | Damenschalthebel           |
	| vbez      | Damenschalthebel           |
	| vkbez     | Damenschalthebel           |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10063.jpg      |
	| catpicsz  | images/part/10063.jpg      |
	| catpicl   | images/part/10063_large.jpg|
	| catpiclz  | images/part/10063_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-58" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | BMXLENKER                  |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | BMX Lenker                 |
	| erab      | 10064                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 49.00                      |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10064                      |
	| prov      | 10064                      |
	| ebez      | BMX Lenker                 |
	| vbez      | BMX Lenker                 |
	| vkbez     | BMX Lenker                 |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10064.jpg      |
	| catpicsz  | images/part/10064.jpg      |
	| catpicl   | images/part/10064_large.jpg|
	| catpiclz  | images/part/10064_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-59" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | LENKER-NORMAL              |
	| vpe       | Stueck                     |
	| vhe       | Stueck                     |
	| epe       | Stueck                     |
	| ehe       | Stueck                     |
	| le        | Stueck                     |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Lenker                     |
	| erab      | 10065                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| vpr       | 100.00                     |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10065                      |
	| prov      | 10065                      |
	| ebez      | Lenker                     |
	| vbez      | Lenker                     |
	| vkbez     | Lenker                     |
	| intrarel  | ja                         |
	| dispoa    | bedarfsbezogen             |
	| rerelev   | ja                         |
	| ge        | Stueck                     |
	| ve        | Stueck                     |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| catpics   | images/part/10065.jpg      |
	| catpicsz  | images/part/10065.jpg      |
	| catpicl   | images/part/10065_large.jpg|
	| catpiclz  | images/part/10065_large.jpg|
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-60" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | GPS_JUSTIERUNG|
	| lirelev  | nein          |
	| vpe      | h             |
	| vhe      | Stueck        |
	| epe      | Stueck        |
	| ehe      | Stueck        |
	| le       | h             |
	| fvhe     | 1             |
	| fehe     | 1             |
	| fvpe     | 1             |
	| fepe     | 1             |
	| skfaehig | ja            |
	| name     | Justierung GPS|
	| erab     | 69            |
	| ewaehr   | EUR           |
	| ewaehr2  | EUR           |
	| ewaehr3  | EUR           |
	| vpr      | 145.00        |
	| vwaehr   | EUR           |
	| vwaehr2  | EUR           |
	| vrab     | 69            |
	| kbpr     | eigener Basispreis (zz |
	| kbprwaeh | EUR           |
	| kbprpe   | Stueck        |
	| catsale  | ja            |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor

  
Given I open an editor "TeilArtikel-61" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | INSPGR_FIRMENWAGEN            |
	| vpe      | Stueck                        |
	| vhe      | Stueck                        |
	| epe      | Stueck                        |
	| ehe      | Stueck                        |
	| le       | Stueck                        |
	| fvhe     | 1                             |
	| fehe     | 1                             |
	| fvpe     | 1                             |
	| fepe     | 1                             |
	| skfaehig | ja                            |
	| name     | Inspektion "Grosse Durchsicht"|
	| epr      | 1000.00                       |
	| erab     | 71                            |
	| ewaehr   | EUR                           |
	| ewaehr2  | EUR                           |
	| ewaehr3  | EUR                           |
	| vwaehr   | EUR                           |
	| vwaehr2  | EUR                           |
	| vrab     | 71                            |
	| rerelev  | ja                            |
	| kbpr     | eigener Basispreis (zz        |
	| kbprwaeh | EUR                           |
	| kbprpe   | Stueck                        |
	| catsale  | ja                            |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor

  
Given I open an editor "TeilArtikel-62" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | INSPKL_FIRMENWAGEN            |
	| vpe      | Stueck                        |
	| vhe      | Stueck                        |
	| epe      | Stueck                        |
	| ehe      | Stueck                        |
	| le       | Stueck                        |
	| fvhe     | 1                             |
	| fehe     | 1                             |
	| fvpe     | 1                             |
	| fepe     | 1                             |
	| skfaehig | ja                            |
	| name     | Inspektion "Kleine Durchsicht"|
	| epr      | 500.00                        |
	| erab     | 72                            |
	| ewaehr   | EUR                           |
	| ewaehr2  | EUR                           |
	| ewaehr3  | EUR                           |
	| vwaehr   | EUR                           |
	| vwaehr2  | EUR                           |
	| vrab     | 72                            |
	| rerelev  | ja                            |
	| kbpr     | eigener Basispreis (zz        |
	| kbprwaeh | EUR                           |
	| kbprpe   | Stueck                        |
	| catsale  | ja                            |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor

  
Given I open an editor "TeilArtikel-63" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                   |
	| such       | ROHR-AL-20*2.4         |
	| vpe        | m                      |
	| vhe        | m                      |
	| epe        | m                      |
	| ehe        | m                      |
	| le         | Stueck                 |
	| lme        | m                      |
	| bme        | m                      |
	| flme       | 2                      |
	| fvhe       | 2                      |
	| fehe       | 2                      |
	| fle        | 1                      |
	| fvpe       | 2                      |
	| fepe       | 2                      |
	| skfaehig   | ja                     |
	| name       | Aluminiumrohr 20*2.4 mm|
	| lief       | 60004                  |
	| epr        | 6.70                   |
	| erab       | 10000                  |
	| ewaehr     | EUR                    |
	| ewaehr2    | EUR                    |
	| ewaehr3    | EUR                    |
	| efrist     | 2                      |
	| vorlauf    | 2                      |
	| vpr        | 15.00                  |
	| vwaehr     | EUR                    |
	| vwaehr2    | EUR                    |
	| vrab       | 10000                  |
	| prov       | 10000                  |
	| ebez       | AL 20*2.4 mm           |
	| intrarel   | ja                     |
	| losgr      | 5                      |
	| dispoa     | bedarfsbezogen         |
	| mindest    | 10                     |
	| rerelev    | ja                     |
	| ge         | m                      |
	| ve         | m                      |
	| fve        | 2                      |
	| fge        | 2                      |
	| zuplatz    | F1                     |
	| abplatz    | F1                     |
	| kbpr       | Einkaufspreis          |
	| kbprwaeh   | EUR                    |
	| kbprpe     | Stueck                 |
	| bsart      | Fremdbeschaffung       |
	| earta      | ueber Artikel          |
	| ersabplatz | f3                     |
	| nwpflicht  | ja                     |
	| gdauer     | 365D                   |
And I save the current editor

  
Given I open an editor "TeilArtikel-64" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                   |
	| such      | ROHR-AL-22*2.8         |
	| vpe       | m                      |
	| vhe       | m                      |
	| epe       | m                      |
	| ehe       | m                      |
	| le        | Stueck                 |
	| lme       | m                      |
	| bme       | m                      |
	| flme      | 2                      |
	| fvhe      | 2                      |
	| fehe      | 2                      |
	| fle       | 1                      |
	| fvpe      | 2                      |
	| fepe      | 2                      |
	| skfaehig  | ja                     |
	| name      | Aluminiumrohr 22*2.8 mm|
	| lief      | 60004                  |
	| epr       | 7.50                   |
	| erab      | 10111                  |
	| ewaehr    | EUR                    |
	| ewaehr2   | EUR                    |
	| ewaehr3   | EUR                    |
	| efrist    | 2                      |
	| vorlauf   | 2                      |
	| vwaehr    | EUR                    |
	| vwaehr2   | EUR                    |
	| vrab      | 10111                  |
	| prov      | 10111                  |
	| ebez      | AL 22*2.8 mm           |
	| intrarel  | ja                     |
	| losgr     | 10                     |
	| dispoa    | bedarfsbezogen         |
	| mindest   | 80                     |
	| rerelev   | ja                     |
	| ge        | m                      |
	| ve        | m                      |
	| fve       | 2                      |
	| fge       | 2                      |
	| zuplatz   | F1                     |
	| abplatz   | F1                     |
	| kbpr      | Einkaufspreis          |
	| kbprwaeh  | EUR                    |
	| kbprpe    | Stueck                 |
	| bsart     | Fremdbeschaffung       |
	| earta     | ueber Artikel          |
	| nwpflicht | ja                     |
	| gdauer    | 365D                   |
And I save the current editor

  
Given I open an editor "TeilArtikel-65" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                   |
	| such      | ROHR-AL-16*2.4         |
	| vpe       | m                      |
	| vhe       | m                      |
	| epe       | m                      |
	| ehe       | m                      |
	| le        | Stueck                 |
	| lme       | m                      |
	| bme       | m                      |
	| flme      | 2                      |
	| fvhe      | 2                      |
	| fehe      | 2                      |
	| fle       | 1                      |
	| fvpe      | 2                      |
	| fepe      | 2                      |
	| skfaehig  | ja                     |
	| name      | Aluminiumrohr 16*2.4 mm|
	| lief      | 60004                  |
	| epr       | 5.80                   |
	| erab      | 10222                  |
	| ewaehr    | EUR                    |
	| ewaehr2   | EUR                    |
	| ewaehr3   | EUR                    |
	| efrist    | 2                      |
	| vorlauf   | 2                      |
	| vwaehr    | EUR                    |
	| vwaehr2   | EUR                    |
	| vrab      | 10222                  |
	| prov      | 10222                  |
	| ebez      | AL 16*2.4 mm           |
	| intrarel  | ja                     |
	| losgr     | 10                     |
	| dispoa    | bedarfsbezogen         |
	| mindest   | 50                     |
	| rerelev   | ja                     |
	| ge        | m                      |
	| ve        | m                      |
	| fve       | 2                      |
	| fge       | 2                      |
	| zuplatz   | F1                     |
	| abplatz   | F1                     |
	| kbpr      | Einkaufspreis          |
	| kbprwaeh  | EUR                    |
	| kbprpe    | Stueck                 |
	| bsart     | Fremdbeschaffung       |
	| earta     | ueber Artikel          |
	| nwpflicht | ja                     |
	| gdauer    | 365D                   |
And I save the current editor

  
Given I open an editor "TeilArtikel-66" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                                              |
	| such      | GRUNDIERUNG                                       |
	| vpe       | l                                                 |
	| vhe       | l                                                 |
	| epe       | l                                                 |
	| ehe       | l                                                 |
	| le        | l                                                 |
	| lme       | mm                                                |
	| bme       | mm                                                |
	| fvhe      | 1                                                 |
	| fehe      | 1                                                 |
	| fle       | 1                                                 |
	| fvpe      | 1                                                 |
	| fepe      | 1                                                 |
	| skfaehig  | ja                                                |
	| name      | Grundierung                                       |
	| lief      | 60005                                             |
	| epr       | 1.50                                              |
	| erab      | 10003                                             |
	| ewaehr    | EUR                                               |
	| ewaehr2   | EUR                                               |
	| ewaehr3   | EUR                                               |
	| efrist    | 2                                                 |
	| vorlauf   | 2                                                 |
	| vwaehr    | EUR                                               |
	| vwaehr2   | EUR                                               |
	| vrab      | 10003                                             |
	| prov      | 10003                                             |
	| ebez      | Einkomponenten-Haftgrund auf;Polyvinylbutyra-Basis|
	| intrarel  | ja                                                |
	| losgr     | 10                                                |
	| dispoa    | bedarfsbezogen                                    |
	| mindest   | 70                                                |
	| rerelev   | ja                                                |
	| ge        | l                                                 |
	| ve        | l                                                 |
	| fve       | 1                                                 |
	| fge       | 1                                                 |
	| zuplatz   | F1                                                |
	| abplatz   | F1                                                |
	| kbpr      | Einkaufspreis                                     |
	| kbprwaeh  | EUR                                               |
	| kbprpe    | Stueck                                            |
	| bsart     | Fremdbeschaffung                                  |
	| earta     | ueber Artikel                                     |
	| nwpflicht | ja                                                |
	| gdauer    | 365D                                              |
And I save the current editor

  
Given I open an editor "TeilArtikel-67" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | LACK-ROT                   |
	| vpe       | l                          |
	| vhe       | l                          |
	| epe       | l                          |
	| ehe       | l                          |
	| le        | l                          |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Metallic-Pulverlack rot    |
	| lief      | 60005                      |
	| epr       | 4.00                       |
	| erab      | 10004                      |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| efrist    | 3                          |
	| vorlauf   | 3                          |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 10004                      |
	| prov      | 10004                      |
	| ebez      | Metallic-Pulverlack R70 rot|
	| intrarel  | ja                         |
	| losgr     | 25                         |
	| dispoa    | bedarfsbezogen             |
	| mindest   | 100                        |
	| rerelev   | ja                         |
	| ge        | l                          |
	| ve        | l                          |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-68" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                        |
	| such      | LACK-BLAU                   |
	| vpe       | l                           |
	| vhe       | l                           |
	| epe       | l                           |
	| ehe       | l                           |
	| le        | l                           |
	| lme       | mm                          |
	| bme       | mm                          |
	| fvhe      | 1                           |
	| fehe      | 1                           |
	| fle       | 1                           |
	| fvpe      | 1                           |
	| fepe      | 1                           |
	| skfaehig  | ja                          |
	| name      | Metallic-Pulverlack blau    |
	| lief      | 60005                       |
	| epr       | 4.00                        |
	| erab      | 10005                       |
	| ewaehr    | EUR                         |
	| ewaehr2   | EUR                         |
	| ewaehr3   | EUR                         |
	| efrist    | 3                           |
	| vorlauf   | 3                           |
	| vwaehr    | EUR                         |
	| vwaehr2   | EUR                         |
	| vrab      | 10005                       |
	| prov      | 10005                       |
	| ebez      | Metallic-Pulverlack R70 blau|
	| intrarel  | ja                          |
	| losgr     | 25                          |
	| dispoa    | bedarfsbezogen              |
	| mindest   | 100                         |
	| rerelev   | ja                          |
	| ge        | l                           |
	| ve        | l                           |
	| fve       | 1                           |
	| fge       | 1                           |
	| zuplatz   | F1                          |
	| abplatz   | F1                          |
	| kbpr      | Einkaufspreis               |
	| kbprwaeh  | EUR                         |
	| kbprpe    | Stueck                      |
	| bsart     | Fremdbeschaffung            |
	| earta     | ueber Artikel               |
	| nwpflicht | ja                          |
	| gdauer    | 365D                        |
And I save the current editor

  
Given I open an editor "TeilArtikel-69" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                         |
	| such      | LACK-GRUEN                   |
	| vpe       | l                            |
	| vhe       | l                            |
	| epe       | l                            |
	| ehe       | l                            |
	| le        | l                            |
	| lme       | mm                           |
	| bme       | mm                           |
	| fvhe      | 1                            |
	| fehe      | 1                            |
	| fle       | 1                            |
	| fvpe      | 1                            |
	| fepe      | 1                            |
	| skfaehig  | ja                           |
	| name      | Metallic-Pulverlack gruen    |
	| lief      | 60005                        |
	| epr       | 4.00                         |
	| erab      | 10006                        |
	| ewaehr    | EUR                          |
	| ewaehr2   | EUR                          |
	| ewaehr3   | EUR                          |
	| efrist    | 3                            |
	| vorlauf   | 3                            |
	| vwaehr    | EUR                          |
	| vwaehr2   | EUR                          |
	| vrab      | 10006                        |
	| prov      | 10006                        |
	| ebez      | Metallic-Pulverlack R70 gruen|
	| intrarel  | ja                           |
	| losgr     | 25                           |
	| dispoa    | bedarfsbezogen               |
	| mindest   | 100                          |
	| rerelev   | ja                           |
	| ge        | l                            |
	| ve        | l                            |
	| fve       | 1                            |
	| fge       | 1                            |
	| zuplatz   | F1                           |
	| abplatz   | F1                           |
	| kbpr      | Einkaufspreis                |
	| kbprwaeh  | EUR                          |
	| kbprpe    | Stueck                       |
	| bsart     | Fremdbeschaffung             |
	| earta     | ueber Artikel                |
	| nwpflicht | ja                           |
	| gdauer    | 365D                         |
And I save the current editor

  
Given I open an editor "TeilArtikel-70" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                   |
	| such      | GABEL-MUTTER           |
	| vpe       | Stueck                 |
	| vhe       | Stueck                 |
	| epe       | Stueck                 |
	| ehe       | Stueck                 |
	| le        | Stueck                 |
	| lme       | mm                     |
	| bme       | mm                     |
	| fvhe      | 1                      |
	| fehe      | 1                      |
	| fle       | 1                      |
	| fvpe      | 1                      |
	| fepe      | 1                      |
	| skfaehig  | ja                     |
	| name      | Mutter fuer Gabel 22mm |
	| lief      | 60004                  |
	| epr       | 0.15                   |
	| erab      | 10007                  |
	| ewaehr    | EUR                    |
	| ewaehr2   | EUR                    |
	| ewaehr3   | EUR                    |
	| efrist    | 3                      |
	| vorlauf   | 3                      |
	| vwaehr    | EUR                    |
	| vwaehr2   | EUR                    |
	| vrab      | 10007                  |
	| prov      | 10007                  |
	| ebez      | Mutter Durchmesser 22mm|
	| intrarel  | ja                     |
	| losgr     | 100                    |
	| dispoa    | mindestbestandsbezogen |
	| mindest   | 100                    |
	| rerelev   | ja                     |
	| ge        | Stueck                 |
	| ve        | Stueck                 |
	| fve       | 1                      |
	| fge       | 1                      |
	| zuplatz   | F1                     |
	| abplatz   | F1                     |
	| kbpr      | Einkaufspreis          |
	| kbprwaeh  | EUR                    |
	| kbprpe    | Stueck                 |
	| bsart     | Fremdbeschaffung       |
	| earta     | ueber Artikel          |
	| nwpflicht | ja                     |
	| gdauer    | 365D                   |
And I save the current editor

  
Given I open an editor "TeilArtikel-71" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                                    |
	| such      | VORDERRAD-TB                            |
	| vpe       | Stueck                                  |
	| vhe       | Stueck                                  |
	| epe       | Stueck                                  |
	| ehe       | Stueck                                  |
	| le        | Stueck                                  |
	| lme       | mm                                      |
	| bme       | mm                                      |
	| fvhe      | 1                                       |
	| fehe      | 1                                       |
	| fle       | 1                                       |
	| fvpe      | 1                                       |
	| fepe      | 1                                       |
	| skfaehig  | ja                                      |
	| name      | TB Vorderrad komplett montiert          |
	| lief      | 60002                                   |
	| epr       | 24.50                                   |
	| erab      | 10008                                   |
	| ewaehr    | EUR                                     |
	| ewaehr2   | EUR                                     |
	| ewaehr3   | EUR                                     |
	| efrist    | 2                                       |
	| vorlauf   | 2                                       |
	| vwaehr    | EUR                                     |
	| vwaehr2   | EUR                                     |
	| vrab      | 10008                                   |
	| prov      | 10008                                   |
	| ebez      | Vorderrad komplett                      |
	| vbez      | Trekking Vorderrad;komplett mit Schlauch|
	| intrarel  | ja                                      |
	| losgr     | 25                                      |
	| dispoa    | bedarfsbezogen                          |
	| mindest   | 50                                      |
	| rerelev   | ja                                      |
	| ge        | Stueck                                  |
	| ve        | Stueck                                  |
	| fve       | 1                                       |
	| fge       | 1                                       |
	| zuplatz   | F1                                      |
	| abplatz   | F1                                      |
	| kbpr      | Einkaufspreis                           |
	| kbprwaeh  | EUR                                     |
	| kbprpe    | Stueck                                  |
	| bsart     | Fremdbeschaffung                        |
	| earta     | ueber Artikel                           |
	| nwpflicht | ja                                      |
	| gdauer    | 365D                                    |
And I save the current editor

  
Given I open an editor "TeilArtikel-72" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                              |
	| such      | TRETLAGER-TB                      |
	| vpe       | Stueck                            |
	| vhe       | Stueck                            |
	| epe       | Stueck                            |
	| ehe       | Stueck                            |
	| le        | Stueck                            |
	| lme       | mm                                |
	| bme       | mm                                |
	| fvhe      | 1                                 |
	| fehe      | 1                                 |
	| fle       | 1                                 |
	| fvpe      | 1                                 |
	| fepe      | 1                                 |
	| skfaehig  | ja                                |
	| name      | TB Tretlagereinheit komplett      |
	| lief      | 60002                             |
	| epr       | 18.90                             |
	| erab      | 10009                             |
	| ewaehr    | EUR                               |
	| ewaehr2   | EUR                               |
	| ewaehr3   | EUR                               |
	| efrist    | 3                                 |
	| vorlauf   | 3                                 |
	| vwaehr    | EUR                               |
	| vwaehr2   | EUR                               |
	| vrab      | 10009                             |
	| prov      | 10009                             |
	| ebez      | Tretlagereinheit komplett         |
	| vbez      | Trekking Tretlagereinheit komplett|
	| intrarel  | ja                                |
	| losgr     | 10                                |
	| dispoa    | bedarfsbezogen                    |
	| mindest   | 50                                |
	| rerelev   | ja                                |
	| ge        | Stueck                            |
	| ve        | Stueck                            |
	| fve       | 1                                 |
	| fge       | 1                                 |
	| zuplatz   | F1                                |
	| abplatz   | F1                                |
	| kbpr      | Einkaufspreis                     |
	| kbprwaeh  | EUR                               |
	| kbprpe    | Stueck                            |
	| bsart     | Fremdbeschaffung                  |
	| earta     | ueber Artikel                     |
	| nwpflicht | ja                                |
	| gdauer    | 365D                              |
And I save the current editor

  
Given I open an editor "TeilArtikel-73" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | MOTOROEL_5W30   |
	| vpe        | l               |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | l               |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Motoroel 5W30   |
	| erab       | 60              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 15.00           |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 60              |
	| prov       | 60              |
	| ebez       | Motoroel 5W30   |
	| vbez       | Motoroel 5W30   |
	| vkbez      | Motoroel 5W30   |
	| intrarel   | ja              |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| gemein     | 19              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-74" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | OELFILTER       |
	| vpe        | Stueck          |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | Stueck          |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | oelfilter       |
	| erab       | 61              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 24.80           |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 61              |
	| prov       | 61              |
	| intrarel   | ja              |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-75" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                    |
	| such       | DICHTUNG_MOTOR          |
	| vpe        | Stueck                  |
	| vhe        | Stueck                  |
	| epe        | Stueck                  |
	| ehe        | Stueck                  |
	| le         | Stueck                  |
	| lme        | mm                      |
	| bme        | mm                      |
	| fvhe       | 1                       |
	| fehe       | 1                       |
	| fle        | 1                       |
	| fvpe       | 1                       |
	| fepe       | 1                       |
	| skfaehig   | ja                      |
	| name       | Dichtungssatz oelwechsel|
	| erab       | 62                      |
	| ewaehr     | EUR                     |
	| ewaehr2    | EUR                     |
	| ewaehr3    | EUR                     |
	| vpr        | 3.24                    |
	| vwaehr     | EUR                     |
	| vwaehr2    | EUR                     |
	| vrab       | 62                      |
	| prov       | 62                      |
	| intrarel   | ja                      |
	| dispoa     | bedarfsbezogen          |
	| rerelev    | ja                      |
	| ge         | Stueck                  |
	| ve         | Stueck                  |
	| fve        | 1                       |
	| fge        | 1                       |
	| zuplatz    | F1                      |
	| abplatz    | F1                      |
	| kbpr       | Einkaufspreis           |
	| kbprwaeh   | EUR                     |
	| kbprpe     | Stueck                  |
	| bsart      | Fremdbeschaffung        |
	| earta      | ueber Artikel           |
	| catsale    | ja                      |
	| ersabplatz | f3                      |
	| nwpflicht  | ja                      |
	| gdauer     | 365D                    |
And I save the current editor

  
Given I open an editor "TeilArtikel-76" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                                           |
	| such       | WHEELM830                                      |
	| vpe        | Stueck                                         |
	| vhe        | Stueck                                         |
	| epe        | Stueck                                         |
	| ehe        | Stueck                                         |
	| le         | Stueck                                         |
	| lme        | mm                                             |
	| bme        | mm                                             |
	| fvhe       | 1                                              |
	| fehe       | 1                                              |
	| fle        | 1                                              |
	| fvpe       | 1                                              |
	| fepe       | 1                                              |
	| skfaehig   | ja                                             |
	| name       | Rad 800/70R38 173A8 Goodyear                   |
	| erab       | 56                                             |
	| ewaehr     | EUR                                            |
	| ewaehr2    | EUR                                            |
	| ewaehr3    | EUR                                            |
	| vpr        | 725.00                                         |
	| vwaehr     | EUR                                            |
	| vwaehr2    | EUR                                            |
	| vrab       | 56                                             |
	| prov       | 56                                             |
	| vbez       | Rad 800/70R38 173A8 Goodyear;auf Felge montiert|
	| vkbez      | Rad 800/70R38 173A8 Goodyear                   |
	| intrarel   | ja                                             |
	| dispoa     | bedarfsbezogen                                 |
	| rerelev    | ja                                             |
	| ge         | Stueck                                         |
	| ve         | Stueck                                         |
	| fve        | 1                                              |
	| fge        | 1                                              |
	| zuplatz    | F1                                             |
	| abplatz    | F1                                             |
	| kbpr       | Einkaufspreis                                  |
	| kbprwaeh   | EUR                                            |
	| kbprpe     | Stueck                                         |
	| bsart      | Fremdbeschaffung                               |
	| earta      | ueber Artikel                                  |
	| catsale    | ja                                             |
	| ersabplatz | f3                                             |
	| nwpflicht  | ja                                             |
	| gdauer     | 365D                                           |
And I save the current editor

  
Given I open an editor "TeilArtikel-77" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                           |
	| such       | KONTROLLANLAGE                 |
	| vpe        | Stueck                         |
	| vhe        | Stueck                         |
	| epe        | Stueck                         |
	| ehe        | Stueck                         |
	| le         | Stueck                         |
	| lme        | mm                             |
	| bme        | mm                             |
	| fvhe       | 1                              |
	| fehe       | 1                              |
	| fle        | 1                              |
	| fvpe       | 1                              |
	| fepe       | 1                              |
	| skfaehig   | ja                             |
	| name       | Kontrollanlage Geraetesteuerung|
	| erab       | 52                             |
	| ewaehr     | EUR                            |
	| ewaehr2    | EUR                            |
	| ewaehr3    | EUR                            |
	| vpr        | 5015.00                        |
	| vwaehr     | EUR                            |
	| vwaehr2    | EUR                            |
	| vrab       | 52                             |
	| prov       | 52                             |
	| ebez       | Kontrollanlage Geraetesteuerung|
	| vbez       | Kontrollanlage Geraetesteuerung|
	| vkbez      | Kontrollanlage Geraetesteuerung|
	| intrarel   | ja                             |
	| dispoa     | bedarfsbezogen                 |
	| rerelev    | ja                             |
	| ge         | Stueck                         |
	| ve         | Stueck                         |
	| fve        | 1                              |
	| fge        | 1                              |
	| zuplatz    | F1                             |
	| abplatz    | F1                             |
	| kbpr       | Einkaufspreis                  |
	| kbprwaeh   | EUR                            |
	| kbprpe     | Stueck                         |
	| bsart      | Fremdbeschaffung               |
	| earta      | ueber Artikel                  |
	| catsale    | ja                             |
	| ersabplatz | f3                             |
	| nwpflicht  | ja                             |
	| gdauer     | 365D                           |
And I save the current editor

  
Given I open an editor "TeilArtikel-78" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | KLIMAANLAGE     |
	| vpe        | Stueck          |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | Stueck          |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Klimaanlage     |
	| erab       | 53              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 3200.00         |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 53              |
	| prov       | 53              |
	| ebez       | Klimaanlage     |
	| vbez       | Klimaanlage     |
	| vkbez      | Klimaanlage     |
	| intrarel   | ja              |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-79" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO              |
	| such       | KRAFTHEBER        |
	| vpe        | Stueck            |
	| vhe        | Stueck            |
	| epe        | Stueck            |
	| ehe        | Stueck            |
	| le         | Stueck            |
	| lme        | mm                |
	| bme        | mm                |
	| fvhe       | 1                 |
	| fehe       | 1                 |
	| fle        | 1                 |
	| fvpe       | 1                 |
	| fepe       | 1                 |
	| skfaehig   | ja                |
	| name       | Krafthebergehaeuse|
	| erab       | 54                |
	| ewaehr     | EUR               |
	| ewaehr2    | EUR               |
	| ewaehr3    | EUR               |
	| vpr        | 3500.00           |
	| vwaehr     | EUR               |
	| vwaehr2    | EUR               |
	| vrab       | 54                |
	| prov       | 54                |
	| ebez       | Krafthebergehaeuse|
	| vbez       | Krafthebergehaeuse|
	| vkbez      | Krafthebergehaeuse|
	| intrarel   | ja                |
	| dispoa     | bedarfsbezogen    |
	| rerelev    | ja                |
	| ge         | Stueck            |
	| ve         | Stueck            |
	| fve        | 1                 |
	| fge        | 1                 |
	| zuplatz    | F1                |
	| abplatz    | F1                |
	| kbpr       | Einkaufspreis     |
	| kbprwaeh   | EUR               |
	| kbprpe     | Stueck            |
	| bsart      | Fremdbeschaffung  |
	| earta      | ueber Artikel     |
	| catsale    | ja                |
	| ersabplatz | f3                |
	| nwpflicht  | ja                |
	| gdauer     | 365D              |
And I save the current editor

  
Given I open an editor "TeilArtikel-80" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | TEMPOMAT        |
	| vpe        | Stueck          |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | Stueck          |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Tempomat        |
	| erab       | 46              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 1280.00         |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 46              |
	| prov       | 46              |
	| ebez       | Tempomat        |
	| vbez       | Tempomat        |
	| vkbez      | Tempomat        |
	| intrarel   | ja              |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 730D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-81" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | EINSPRITZANLAGE |
	| vpe        | Stueck          |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | Stueck          |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Einspritzanlage |
	| erab       | 50              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 8500.00         |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 50              |
	| prov       | 50              |
	| ebez       | Einspritzanlage |
	| vbez       | Einspritzanlage |
	| vkbez      | Einspritzanlage |
	| intrarel   | ja              |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-82" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                       |
	| such      | LF_LACK-ROT                |
	| vpe       | l                          |
	| vhe       | l                          |
	| epe       | l                          |
	| ehe       | l                          |
	| le        | l                          |
	| lme       | mm                         |
	| bme       | mm                         |
	| fvhe      | 1                          |
	| fehe      | 1                          |
	| fle       | 1                          |
	| fvpe      | 1                          |
	| fepe      | 1                          |
	| skfaehig  | ja                         |
	| name      | Metallic-Pulverlack rot    |
	| lief      | 60005                      |
	| epr       | 4.00                       |
	| erab      | 20                         |
	| ewaehr    | EUR                        |
	| ewaehr2   | EUR                        |
	| ewaehr3   | EUR                        |
	| efrist    | 3                          |
	| vorlauf   | 3                          |
	| vwaehr    | EUR                        |
	| vwaehr2   | EUR                        |
	| vrab      | 20                         |
	| prov      | 20                         |
	| ebez      | Metallic-Pulverlack R70 rot|
	| intrarel  | ja                         |
	| losgr     | 25                         |
	| dispoa    | bedarfsbezogen             |
	| mindest   | 100                        |
	| rerelev   | ja                         |
	| ge        | l                          |
	| ve        | l                          |
	| fve       | 1                          |
	| fge       | 1                          |
	| zuplatz   | F1                         |
	| abplatz   | F1                         |
	| kbpr      | Einkaufspreis              |
	| kbprwaeh  | EUR                        |
	| kbprpe    | Stueck                     |
	| bsart     | Fremdbeschaffung           |
	| earta     | ueber Artikel              |
	| nwpflicht | ja                         |
	| gdauer    | 365D                       |
And I save the current editor

  
Given I open an editor "TeilArtikel-83" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | ARBEITSZEIT    |
	| vpe      | h              |
	| vhe      | Stueck         |
	| epe      | h              |
	| ehe      | h              |
	| le       | h              |
	| fvhe     | 1              |
	| fehe     | 1              |
	| fvpe     | 1              |
	| fepe     | 1              |
	| skfaehig | ja             |
	| name     | Arbeitszeit (h)|
	| erab     | 25             |
	| ewaehr   | EUR            |
	| ewaehr2  | EUR            |
	| ewaehr3  | EUR            |
	| vpr      | 88.00          |
	| vwaehr   | EUR            |
	| vwaehr2  | EUR            |
	| vrab     | 25             |
	| vkbez    | Arbeitszeit (h)|
	| rerelev  | ja             |
	| kbpr     | eigener Basispreis (zz |
	| kbprwaeh | EUR            |
	| kbprpe   | Stueck         |
	| catsale  | ja             |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor

  
Given I open an editor "TeilArtikel-84" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                        |
	| such      | LF_LACK-GELB                |
	| vpe       | l                           |
	| vhe       | l                           |
	| epe       | l                           |
	| ehe       | l                           |
	| le        | l                           |
	| lme       | mm                          |
	| bme       | mm                          |
	| fvhe      | 1                           |
	| fehe      | 1                           |
	| fle       | 1                           |
	| fvpe      | 1                           |
	| fepe      | 1                           |
	| skfaehig  | ja                          |
	| name      | Metallic-Pulverlack gelb    |
	| lief      | 60005                       |
	| epr       | 4.00                        |
	| erab      | 21                          |
	| ewaehr    | EUR                         |
	| ewaehr2   | EUR                         |
	| ewaehr3   | EUR                         |
	| efrist    | 3                           |
	| vorlauf   | 3                           |
	| vwaehr    | EUR                         |
	| vwaehr2   | EUR                         |
	| vrab      | 21                          |
	| prov      | 21                          |
	| ebez      | Metallic-Pulverlack R70 gelb|
	| intrarel  | ja                          |
	| losgr     | 25                          |
	| dispoa    | bedarfsbezogen              |
	| mindest   | 100                         |
	| rerelev   | ja                          |
	| ge        | l                           |
	| ve        | l                           |
	| fve       | 1                           |
	| fge       | 1                           |
	| zuplatz   | F1                          |
	| abplatz   | F1                          |
	| kbpr      | Einkaufspreis               |
	| kbprwaeh  | EUR                         |
	| kbprpe    | Stueck                      |
	| bsart     | Fremdbeschaffung            |
	| earta     | ueber Artikel               |
	| nwpflicht | ja                          |
	| gdauer    | 365D                        |
And I save the current editor

  
Given I open an editor "TeilArtikel-85" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge   | FIFO                          |
	| such     | LF_LACK-SILBER                |
	| vpe      | l                             |
	| vhe      | l                             |
	| epe      | l                             |
	| ehe      | l                             |
	| le       | l                             |
	| lme      | mm                            |
	| bme      | mm                            |
	| fvhe     | 1                             |
	| fehe     | 1                             |
	| fle      | 1                             |
	| fvpe     | 1                             |
	| fepe     | 1                             |
	| skfaehig | ja                            |
	| name     | Metallic-Pulverlack silber    |
	| lief     | 60005                         |
	| epr      | 4.00                          |
	| ewaehr   | EUR                           |
	| ewaehr2  | EUR                           |
	| ewaehr3  | EUR                           |
	| efrist   | 3                             |
	| vorlauf  | 3                             |
	| vwaehr   | EUR                           |
	| vwaehr2  | EUR                           |
	| ebez     | Metallic-Pulverlack R70 silber|
	| intrarel | ja                            |
	| dispoa   | variantenbezogen              |
	| rerelev  | ja                            |
	| ge       | l                             |
	| ve       | l                             |
	| fve      | 1                             |
	| fge      | 1                             |
	| zuplatz  | F1                            |
	| abplatz  | F1                            |
	| kbpr     | Einkaufspreis                 |
	| kbprwaeh | EUR                           |
	| kbprpe   | Stueck                        |
	| bsart    | Lohnfertigung                 |
And I save the current editor

  
Given I open an editor "TeilArtikel-86" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | MONTAGEEINSATZ    |
	| vpe      | at                |
	| vhe      | Stueck            |
	| epe      | at                |
	| ehe      | Stueck            |
	| le       | at                |
	| fvhe     | 1                 |
	| fehe     | 1                 |
	| fvpe     | 1                 |
	| fepe     | 1                 |
	| skfaehig | ja                |
	| name     | Montageeinsatz (d)|
	| erab     | 23                |
	| ewaehr   | EUR               |
	| ewaehr2  | EUR               |
	| ewaehr3  | EUR               |
	| vpr      | 704.00            |
	| vwaehr   | EUR               |
	| vwaehr2  | EUR               |
	| vrab     | 23                |
	| vkbez    | Montageeinsatz (d)|
	| rerelev  | ja                |
	| kbpr     | eigener Basispreis (zz |
	| kbprwaeh | EUR               |
	| kbprpe   | Stueck            |
	| catsale  | ja                |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor

  
Given I open an editor "TeilArtikel-87" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge   | FIFO                        |
	| such     | LF_LACK-BLAU                |
	| vpe      | l                           |
	| vhe      | l                           |
	| epe      | l                           |
	| ehe      | l                           |
	| le       | l                           |
	| lme      | mm                          |
	| bme      | mm                          |
	| fvhe     | 1                           |
	| fehe     | 1                           |
	| fle      | 1                           |
	| fvpe     | 1                           |
	| fepe     | 1                           |
	| skfaehig | ja                          |
	| name     | Metallic-Pulverlack blau    |
	| lief     | 60005                       |
	| epr      | 4.00                        |
	| ewaehr   | EUR                         |
	| ewaehr2  | EUR                         |
	| ewaehr3  | EUR                         |
	| efrist   | 3                           |
	| vorlauf  | 3                           |
	| vwaehr   | EUR                         |
	| vwaehr2  | EUR                         |
	| ebez     | Metallic-Pulverlack R70 blau|
	| intrarel | ja                          |
	| dispoa   | variantenbezogen            |
	| rerelev  | ja                          |
	| ge       | l                           |
	| ve       | l                           |
	| fve      | 1                           |
	| fge      | 1                           |
	| zuplatz  | F1                          |
	| abplatz  | F1                          |
	| kbpr     | Einkaufspreis               |
	| kbprwaeh | EUR                         |
	| kbprpe   | Stueck                      |
	| bsart    | Lohnfertigung               |
And I save the current editor

  
Given I open an editor "TeilArtikel-88" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge   | FIFO                         |
	| such     | LF_LACK-GRUEN                |
	| vpe      | l                            |
	| vhe      | l                            |
	| epe      | l                            |
	| ehe      | l                            |
	| le       | l                            |
	| lme      | mm                           |
	| bme      | mm                           |
	| fvhe     | 1                            |
	| fehe     | 1                            |
	| fle      | 1                            |
	| fvpe     | 1                            |
	| fepe     | 1                            |
	| skfaehig | ja                           |
	| name     | Metallic-Pulverlack gruen    |
	| lief     | 60005                        |
	| epr      | 4.00                         |
	| ewaehr   | EUR                          |
	| ewaehr2  | EUR                          |
	| ewaehr3  | EUR                          |
	| efrist   | 3                            |
	| vorlauf  | 3                            |
	| vwaehr   | EUR                          |
	| vwaehr2  | EUR                          |
	| ebez     | Metallic-Pulverlack R70 gruen|
	| intrarel | ja                           |
	| dispoa   | variantenbezogen             |
	| rerelev  | ja                           |
	| ge       | l                            |
	| ve       | l                            |
	| fve      | 1                            |
	| fge      | 1                            |
	| zuplatz  | F1                           |
	| abplatz  | F1                           |
	| kbpr     | Einkaufspreis                |
	| kbprwaeh | EUR                          |
	| kbprpe   | Stueck                       |
	| bsart    | Lohnfertigung                |
And I save the current editor

  
Given I open an editor "TeilArtikel-89" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | HYDRAULIKOEL    |
	| vpe        | l               |
	| vhe        | l               |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | l               |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Hydraulikoel    |
	| erab       | 13              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 21.24           |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 13              |
	| prov       | 13              |
	| ebez       | Hydraulikoel    |
	| vbez       | Hydraulikoel    |
	| vkbez      | Hydraulikoel    |
	| intrarel   | ja              |
	| vol        | 1               |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I save the current editor

  
Given I open an editor "TeilArtikel-90" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge   | FIFO                                              |
	| such     | LF_GRUNDIERUNG                                    |
	| vpe      | l                                                 |
	| vhe      | l                                                 |
	| epe      | l                                                 |
	| ehe      | l                                                 |
	| le       | l                                                 |
	| lme      | mm                                                |
	| bme      | mm                                                |
	| fvhe     | 1                                                 |
	| fehe     | 1                                                 |
	| fle      | 1                                                 |
	| fvpe     | 1                                                 |
	| fepe     | 1                                                 |
	| skfaehig | ja                                                |
	| name     | Grundierung in Lack                               |
	| lief     | 60005                                             |
	| epr      | 5.00                                              |
	| ewaehr   | EUR                                               |
	| ewaehr2  | EUR                                               |
	| ewaehr3  | EUR                                               |
	| efrist   | 2                                                 |
	| vorlauf  | 2                                                 |
	| vwaehr   | EUR                                               |
	| vwaehr2  | EUR                                               |
	| ebez     | Einkomponenten-Haftgrund auf;Polyvinylbutyra-Basis|
	| intrarel | ja                                                |
	| dispoa   | variantenbezogen                                  |
	| rerelev  | ja                                                |
	| ge       | l                                                 |
	| ve       | l                                                 |
	| fve      | 1                                                 |
	| fge      | 1                                                 |
	| zuplatz  | F1                                                |
	| abplatz  | F1                                                |
	| kbpr     | Einkaufspreis                                     |
	| kbprwaeh | EUR                                               |
	| kbprpe   | Stueck                                            |
	| bsart    | Lohnfertigung                                     |
And I save the current editor

  
Given I open an editor "TeilArtikel-91" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | LEUCHTE-RUECK   |
	| vpe        | Stueck          |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | Stueck          |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Rueckleuchte    |
	| lief       | 60001           |
	| epr        | 2.50            |
	| erab       | 10021           |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| efrist     | 3               |
	| vorlauf    | 3               |
	| vpr        | 16.85           |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 10021           |
	| prov       | 10021           |
	| ebez       | Rueckleuchte    |
	| vbez       | Rueckleuchte    |
	| vkbez      | Rueckleuchte    |
	| intrarel   | ja              |
	| losgr      | 10              |
	| dispoa     | bedarfsbezogen  |
	| mindest    | 80              |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 365D            |
And I append rows
	| elex          | elanzahl |
	| GLUEHBIRNE-6V | 1        |
And I save the current editor

Given I open an editor "TeilArtikel-92" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | MOTORKW276      |
	| vpe        | Stueck          |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | Stueck          |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Motor 276 kW    |
	| erab       | 44              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 29000.00        |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 44              |
	| prov       | 44              |
	| ebez       | Motor 276 kW    |
	| vbez       | Motor 276 kW    |
	| vkbez      | Motor 276 kW    |
	| intrarel   | ja              |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| nwpflicht  | ja              |
	| gdauer     | 730D            |
	| gemein     | 19              |
And I append rows
	| elex           | elanzahl |
	| MOTOROEL_5W30  | 8        |
	| OELFILTER      | 2        |
	| DICHTUNG_MOTOR | 1        |
And I save the current editor

  
Given I open an editor "TeilArtikel-93" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                    |
	| such       | GETRIEBE185             |
	| vpe        | Stueck                  |
	| vhe        | Stueck                  |
	| epe        | Stueck                  |
	| ehe        | Stueck                  |
	| le         | Stueck                  |
	| lme        | mm                      |
	| bme        | mm                      |
	| fvhe       | 1                       |
	| fehe       | 1                       |
	| fle        | 1                       |
	| fvpe       | 1                       |
	| fepe       | 1                       |
	| skfaehig   | ja                      |
	| name       | 18/5 PowerShift Getriebe|
	| erab       | 45                      |
	| ewaehr     | EUR                     |
	| ewaehr2    | EUR                     |
	| ewaehr3    | EUR                     |
	| vpr        | 12500.00                |
	| vwaehr     | EUR                     |
	| vwaehr2    | EUR                     |
	| vrab       | 45                      |
	| prov       | 45                      |
	| ebez       | 18/5 PowerShift Getriebe|
	| vbez       | 18/5 PowerShift Getriebe|
	| vkbez      | 18/5 PowerShift Getriebe|
	| intrarel   | ja                      |
	| dispoa     | auftragsbezogen         |
	| rerelev    | ja                      |
	| ge         | Stueck                  |
	| ve         | Stueck                  |
	| fve        | 1                       |
	| fge        | 1                       |
	| zuplatz    | F1                      |
	| abplatz    | F1                      |
	| kbpr       | Einkaufspreis           |
	| kbprwaeh   | EUR                     |
	| kbprpe     | Stueck                  |
	| bsart      | Eigenfertigung          |
	| earta      | ueber Artikel           |
	| catsale    | ja                      |
	| ersabplatz | f3                      |
	| nwpflicht  | ja                      |
	| serpflicht | ja                      |
	| gdauer     | 365D                    |
	| chimlager  | ja                      |
And I append rows
	| elex            | elanzahl | lge         |
	| GETRIEBEOEL     | 4.8      | !dontChange |
	| OELFILTER_G     | 1        | !dontChange |
	| DICHTUNG_GETR   | 1        | !dontChange |
	| FLACH-ST-30*1.5 | 1        | 0.25        |
	| GELENK          | 4        | !dontChange |
And I save the current editor

  
Given I open an editor "TeilArtikel-94" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO              |
	| such       | LENKUNGM830       |
	| vpe        | Stueck            |
	| vhe        | Stueck            |
	| epe        | Stueck            |
	| ehe        | Stueck            |
	| le         | Stueck            |
	| lme        | mm                |
	| bme        | mm                |
	| fvhe       | 1                 |
	| fehe       | 1                 |
	| fle        | 1                 |
	| fvpe       | 1                 |
	| fepe       | 1                 |
	| skfaehig   | ja                |
	| name       | Lenkung Modell 830|
	| erab       | 48                |
	| ewaehr     | EUR               |
	| ewaehr2    | EUR               |
	| ewaehr3    | EUR               |
	| vpr        | 9120.00           |
	| vwaehr     | EUR               |
	| vwaehr2    | EUR               |
	| vrab       | 48                |
	| prov       | 48                |
	| ebez       | Lenkung Modell 830|
	| vbez       | Lenkung Modell 830|
	| vkbez      | Lenkung Modell 830|
	| intrarel   | ja                |
	| dispoa     | auftragsbezogen   |
	| rerelev    | ja                |
	| ge         | Stueck            |
	| ve         | Stueck            |
	| fve        | 1                 |
	| fge        | 1                 |
	| zuplatz    | F1                |
	| abplatz    | F1                |
	| kbpr       | Einkaufspreis     |
	| kbprwaeh   | EUR               |
	| kbprpe     | Stueck            |
	| bsart      | Eigenfertigung    |
	| earta      | ueber Artikel     |
	| catsale    | ja                |
	| ersabplatz | f3                |
	| nwpflicht  | ja                |
	| gdauer     | 365D              |
And I append rows
	| elex            | lge         | elanzahl |
	| FLACH-ST-30*1.5 | 2.5         | 1        |
	| GELENK          | !dontChange | 2        |
And I save the current editor

  
Given I open an editor "TeilArtikel-95" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                        |
	| such       | KRAFTSTOFFTANK              |
	| vpe        | Stueck                      |
	| vhe        | Stueck                      |
	| epe        | Stueck                      |
	| ehe        | Stueck                      |
	| le         | Stueck                      |
	| lme        | mm                          |
	| bme        | mm                          |
	| fvhe       | 1                           |
	| fehe       | 1                           |
	| fle        | 1                           |
	| fvpe       | 1                           |
	| fepe       | 1                           |
	| skfaehig   | ja                          |
	| name       | Kraftstofftank Volumen 990 l|
	| erab       | 51                          |
	| ewaehr     | EUR                         |
	| ewaehr2    | EUR                         |
	| ewaehr3    | EUR                         |
	| vpr        | 2875.00                     |
	| vwaehr     | EUR                         |
	| vwaehr2    | EUR                         |
	| vrab       | 51                          |
	| prov       | 51                          |
	| ebez       | Kraftstofftank Volumen 990 l|
	| vbez       | Kraftstofftank Volumen 990 l|
	| vkbez      | Kraftstofftank Volumen 990 l|
	| intrarel   | ja                          |
	| dispoa     | bedarfsbezogen              |
	| rerelev    | ja                          |
	| ge         | Stueck                      |
	| ve         | Stueck                      |
	| fve        | 1                           |
	| fge        | 1                           |
	| zuplatz    | F1                          |
	| abplatz    | F1                          |
	| kbpr       | Einkaufspreis               |
	| kbprwaeh   | EUR                         |
	| kbprpe     | Stueck                      |
	| bsart      | Fremdbeschaffung            |
	| earta      | ueber Artikel               |
	| catsale    | ja                          |
	| ersabplatz | f3                          |
	| gdauer     | 365D                        |
	| nwpflicht  | ja                          |
And I append rows
	| elex            | lge | elanzahl |
	| FLACH-ST-30*1.5 | 4.5 | 1        |
	| PROFIL-ST       | 1.5 | 1        |
And I save the current editor

  
Given I open an editor "TeilArtikel-96" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                     |
	| such       | LEUCHTE-FRONT            |
	| vpe        | Stueck                   |
	| vhe        | Stueck                   |
	| epe        | Stueck                   |
	| ehe        | Stueck                   |
	| le         | Stueck                   |
	| lme        | mm                       |
	| bme        | mm                       |
	| fvhe       | 1                        |
	| fehe       | 1                        |
	| fle        | 1                        |
	| fvpe       | 1                        |
	| fepe       | 1                        |
	| skfaehig   | ja                       |
	| name       | Frontscheinwerfer        |
	| lief       | 60001                    |
	| epr        | 5.80                     |
	| erab       | 10020                    |
	| ewaehr     | EUR                      |
	| ewaehr2    | EUR                      |
	| ewaehr3    | EUR                      |
	| efrist     | 3                        |
	| vorlauf    | 3                        |
	| vpr        | 35.00                    |
	| vwaehr     | EUR                      |
	| vwaehr2    | EUR                      |
	| vrab       | 10020                    |
	| prov       | 10020                    |
	| ebez       | Halogen Frontscheinwerfer|
	| vbez       | Halogen Frontscheinwerfer|
	| vkbez      | Frontscheinwerfer        |
	| intrarel   | ja                       |
	| losgr      | 10                       |
	| dispoa     | bedarfsbezogen           |
	| mindest    | 80                       |
	| rerelev    | ja                       |
	| ge         | Stueck                   |
	| ve         | Stueck                   |
	| fve        | 1                        |
	| fge        | 1                        |
	| zuplatz    | F1                       |
	| abplatz    | F1                       |
	| kbpr       | Einkaufspreis            |
	| kbprwaeh   | EUR                      |
	| kbprpe     | Stueck                   |
	| bsart      | Fremdbeschaffung         |
	| earta      | ueber Artikel            |
	| ersabplatz | f3                       |
	| nwpflicht  | ja                       |
	| gdauer     | 365D                     |
And I append rows
	| elex           | elanzahl |
	| GLUEHBIRNE-HAL | 1        |
And I save the current editor


  
Given I open an editor "TeilArtikel-97" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO             |
	| such       | CHASISM830       |
	| vpe        | Stueck           |
	| vhe        | Stueck           |
	| epe        | Stueck           |
	| ehe        | Stueck           |
	| le         | Stueck           |
	| lme        | mm               |
	| bme        | mm               |
	| fvhe       | 1                |
	| fehe       | 1                |
	| fle        | 1                |
	| fvpe       | 1                |
	| fepe       | 1                |
	| skfaehig   | ja               |
	| name       | Chasis Modell 830|
	| erab       | 55               |
	| ewaehr     | EUR              |
	| ewaehr2    | EUR              |
	| ewaehr3    | EUR              |
	| vpr        | 9560.00          |
	| vwaehr     | EUR              |
	| vwaehr2    | EUR              |
	| vrab       | 55               |
	| prov       | 55               |
	| ebez       | Chasis Modell 830|
	| vbez       | Chasis Modell 830|
	| vkbez      | Chasis Modell 830|
	| intrarel   | ja               |
	| dispoa     | bedarfsbezogen   |
	| rerelev    | ja               |
	| ge         | Stueck           |
	| ve         | Stueck           |
	| fve        | 1                |
	| fge        | 1                |
	| zuplatz    | F1               |
	| abplatz    | F1               |
	| kbpr       | Einkaufspreis    |
	| kbprwaeh   | EUR              |
	| kbprpe     | Stueck           |
	| bsart      | Fremdbeschaffung |
	| earta      | ueber Artikel    |
	| ersabplatz | f3               |
	| gdauer     | 365D             |
	| nwpflicht  | ja               |
And I append rows
	| elex            | lge         | elanzahl | bu          |
	| ROHR-ST-65*1.5  | 12.8        | 1        | !dontChange |
	| FLACH-ST-30*1.5 | 6.3         | 1        | !dontChange |
	| ROHR-ST-65*1.5  | 5.2         | 1        | !dontChange |
	| LF_GRUNDIERUNG  | !dontChange | 5.6      | Ende        |
	| LF_LACK-GRUEN   | !dontChange | 15       | Ende        |
	| LEUCHTE-FRONT   | !dontChange | 4        | !dontChange |
	| LEUCHTE-RUECK   | !dontChange | 4        | !dontChange |
And I save the current editor

  
Given I open an editor "TeilArtikel-98" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                         |
	| such       | TRACTORM830SD                |
	| vpe        | Stueck                       |
	| vhe        | Stueck                       |
	| epe        | Stueck                       |
	| ehe        | Stueck                       |
	| le         | Stueck                       |
	| lme        | mm                           |
	| bme        | mm                           |
	| fvhe       | 1                            |
	| fehe       | 1                            |
	| fle        | 1                            |
	| fvpe       | 1                            |
	| fepe       | 1                            |
	| skfaehig   | ja                           |
	| name       | Traktor, Modell 830, Standard|
	| erab       | 11                           |
	| ewaehr     | EUR                          |
	| ewaehr2    | EUR                          |
	| ewaehr3    | EUR                          |
	| vpr        | 125000.00                    |
	| vwaehr     | EUR                          |
	| vwaehr2    | EUR                          |
	| vrab       | 11                           |
	| prov       | 11                           |
	| vbez       | Traktor, Modell 830, Standard|
	| vkbez      | Traktor, Modell 830, Standard|
	| intrarel   | ja                           |
	| dispoa     | auftragsbezogen              |
	| rerelev    | ja                           |
	| ge         | Stueck                       |
	| ve         | Stueck                       |
	| fve        | 1                            |
	| fge        | 1                            |
	| zuplatz    | F1                           |
	| abplatz    | F1                           |
	| kbpr       | Einkaufspreis                |
	| kbprwaeh   | EUR                          |
	| kbprpe     | Stueck                       |
	| bsart      | Eigenfertigung               |
	| earta      | ueber Artikel                |
	| flbasis    | 1                            |
	| catsale    | ja                           |
	| serpflicht | ja                           |
And I set field "gdauer" to "365D"
And I set field "nwpflicht" to "ja"
And I set field "gdauer" to "730D" 

And I append rows
	| elex            | elanzahl|
	| MOTORKW276      | 1       |
	| GETRIEBE185     | 1       |
	| HYDRAULIK       | 1       |
	| LENKUNGM830     | 1       |
	| EINSPRITZANLAGE | 1       |
	| KRAFTSTOFFTANK  | 1       |
	| KONTROLLANLAGE  | 1       |
	| CHASISM830      | 1       |
	| WHEELM830       | 4       |
And I save the current editor

  
Given I open an editor "TeilArtikel-99" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                     |
	| such       | TRACTORM830T             |
	| vpe        | Stueck                   |
	| vhe        | Stueck                   |
	| epe        | Stueck                   |
	| ehe        | Stueck                   |
	| le         | Stueck                   |
	| lme        | mm                       |
	| bme        | mm                       |
	| fvhe       | 1                        |
	| fehe       | 1                        |
	| fle        | 1                        |
	| fvpe       | 1                        |
	| fepe       | 1                        |
	| skfaehig   | ja                       |
	| name       | Traktor, Modell 1030, Top|
	| erab       | 43                       |
	| ewaehr     | EUR                      |
	| ewaehr2    | EUR                      |
	| ewaehr3    | EUR                      |
	| vpr        | 165000.00                |
	| vwaehr     | EUR                      |
	| vwaehr2    | EUR                      |
	| vrab       | 43                       |
	| prov       | 43                       |
	| vbez       | Traktor, Modell 830, Top |
	| vkbez      | Traktor, Modell 830, Top |
	| intrarel   | ja                       |
	| dispoa     | auftragsbezogen          |
	| rerelev    | ja                       |
	| ge         | Stueck                   |
	| ve         | Stueck                   |
	| fve        | 1                        |
	| fge        | 1                        |
	| zuplatz    | F1                       |
	| abplatz    | F1                       |
	| kbpr       | Einkaufspreis            |
	| kbprwaeh   | EUR                      |
	| kbprpe     | Stueck                   |
	| bsart      | Eigenfertigung           |
	| earta      | ueber Artikel            |
	| flbasis    | 1                        |
	| catsale    | ja                       |
	| serpflicht | ja                       |
	| gdauer     | 365D                     |
	| nwpflicht  | ja                       |
And I append rows
	| elex            | elanzahl |
	| MOTORKW276      | 1        |
	| GETRIEBE185     | 1        |
	| TEMPOMAT        | 1        |
	| HYDRAULIK       | 1        |
	| LENKUNGM830     | 1        |
	| EINSPRITZANLAGE | 1        |
	| KRAFTSTOFFTANK  | 1        |
	| KONTROLLANLAGE  | 1        |
	| KLIMAANLAGE     | 1        |
	| KRAFTHEBER      | 1        |
	| CHASISM830      | 1        |
	| WHEELM830       | 4        |
And I save the current editor

  
Given I open an editor "TeilArtikel-100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO            |
	| such       | HYDRAULIK       |
	| vpe        | Stueck          |
	| vhe        | Stueck          |
	| epe        | Stueck          |
	| ehe        | Stueck          |
	| le         | Stueck          |
	| lme        | mm              |
	| bme        | mm              |
	| fvhe       | 1               |
	| fehe       | 1               |
	| fle        | 1               |
	| fvpe       | 1               |
	| fepe       | 1               |
	| skfaehig   | ja              |
	| name       | Hydrauliksystem |
	| erab       | 47              |
	| ewaehr     | EUR             |
	| ewaehr2    | EUR             |
	| ewaehr3    | EUR             |
	| vpr        | 7650.00         |
	| vwaehr     | EUR             |
	| vwaehr2    | EUR             |
	| vrab       | 47              |
	| prov       | 47              |
	| ebez       | Hydrauliksystem |
	| vbez       | Hydrauliksystem |
	| vkbez      | Hydrauliksystem |
	| intrarel   | ja              |
	| dispoa     | bedarfsbezogen  |
	| rerelev    | ja              |
	| ge         | Stueck          |
	| ve         | Stueck          |
	| fve        | 1               |
	| fge        | 1               |
	| zuplatz    | F1              |
	| abplatz    | F1              |
	| kbpr       | Einkaufspreis   |
	| kbprwaeh   | EUR             |
	| kbprpe     | Stueck          |
	| bsart      | Fremdbeschaffung|
	| earta      | ueber Artikel   |
	| catsale    | ja              |
	| ersabplatz | f3              |
	| gdauer     | 365D            |
	| nwpflicht  | ja              |
And I append rows
	| elex           | elanzahl | lge         |
	| HYDRAULIKOEL   | 8        | !dontChange |
	| ROHR-ST-22*1.4 | 1        | 0.2         |
	| GELENK         | 3        | !dontChange |
And I save the current editor

  
Given I open an editor "TeilArtikel-101" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | OELWECHSEL_G        |
	| vpe      | h                   |
	| vhe      | Stueck              |
	| epe      | Stueck              |
	| ehe      | Stueck              |
	| le       | h                   |
	| fvhe     | 1                   |
	| fehe     | 1                   |
	| fvpe     | 1                   |
	| fepe     | 1                   |
	| skfaehig | ja                  |
	| name     | �lwechsel Getriebe|
	| erab     | 63                  |
	| ewaehr   | EUR                 |
	| ewaehr2  | EUR                 |
	| ewaehr3  | EUR                 |
	| vpr      | 245.00              |
	| vwaehr   | EUR                 |
	| vwaehr2  | EUR                 |
	| vrab     | 63                  |
	| rerelev  | ja                  |
	| kbpr     | eigener Basispreis (zz  |
	| kbprwaeh | EUR                 |
	| kbprpe   | Stueck              |
	| catsale  | ja                  |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Serviceprodukte, Serviceproduktstuecklisten
# ----------------------------------------------------------------------------------------------
Given I open an editor "TeilArtikel-102" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
And I set fields
	| nummer  | 1000          |
	| dienstl | OELWECHSEL_G  |
And I append rows
	| elex          | elanzahl |
	| GETRIEBEOEL   | 3.25     |
	| OELFILTER_G   | 1        |
	| DICHTUNG_GETR | 1        |
And I save the current editor
  
Given I open an editor "TeilArtikel-103" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
And I set fields
	| nummer  | 1500          |
	| dienstl | OELWECHSEL_G  |
	| artikel | TRACTORM830T  |
And I append rows
	| elex          | elanzahl |
	| GETRIEBEOEL   | 3.25     |
	| OELFILTER_G   | 1        |
	| DICHTUNG_GETR | 1        |
And I save the current editor
  
Given I open an editor "ProduktStueck lst-01" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "UPDATE" for record "1500"
And I delete row at position 1

And I delete row at position 2

And I save the current editor
  
Given I open an editor "ProduktStueck lst-02" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "DELETE" for record "1500"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor 
  

Given I open an editor "TeilDienstl-12" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | OELWECHSEL_M     |
	| vpe      | h                |
	| vhe      | Stueck           |
	| epe      | Stueck           |
	| ehe      | Stueck           |
	| le       | h                |
	| fvhe     | 1                |
	| fehe     | 1                |
	| fvpe     | 1                |
	| fepe     | 1                |
	| skfaehig | ja               |
	| name     | �lwechsel Motor|
	| erab     | 67               |
	| ewaehr   | EUR              |
	| ewaehr2  | EUR              |
	| ewaehr3  | EUR              |
	| vpr      | 180.00           |
	| vwaehr   | EUR              |
	| vwaehr2  | EUR              |
	| vrab     | 67               |
	| rerelev  | ja               |
	| kbpr     | eigener Basispreis (zzg |
	| kbprwaeh | EUR              |
	| kbprpe   | Stueck           |
	| catsale  | ja               |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor
 
 
Given I open an editor "TeilDienstl-13" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
And I set fields
	| nummer  | 1001          |
	| dienstl | OELWECHSEL_M  |
And I append rows
	| elex           | elanzahl |
	| MOTOROEL_5W30  | 6.5      |
	| OELFILTER      | 1        |
	| DICHTUNG_MOTOR | 1        |
And I save the current editor

  
Given I open an editor "TeilDienstl-14" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | INSP_500_BS                   |
	| vpe      | h                             |
	| vhe      | Stueck                        |
	| epe      | Stueck                        |
	| ehe      | Stueck                        |
	| le       | h                             |
	| fvhe     | 1                             |
	| fehe     | 1                             |
	| fvpe     | 1                             |
	| fepe     | 1                             |
	| skfaehig | ja                            |
	| name     | Inspektion 500 Betriebsstunden|
	| erab     | 57                            |
	| ewaehr   | EUR                           |
	| ewaehr2  | EUR                           |
	| ewaehr3  | EUR                           |
	| vpr      | 500.00                        |
	| vwaehr   | EUR                           |
	| vwaehr2  | EUR                           |
	| vrab     | 57                            |
	| rerelev  | ja                            |
	| kbpr     | eigener Basispreis (zzg       |
	| kbprwaeh | EUR                           |
	| kbprpe   | Stueck                        |
	| catsale  | ja                            |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor
 
 
Given I open an editor "TeilDienstl-15" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
And I set fields
	| nummer  | 1002         |
	| dienstl | INSP_500_BS  |
And I append rows
	| elex         | elanzahl | vpos |
	| OELWECHSEL_M | 1        | 1    |
And I save the current editor

  
Given I open an editor "TeilDienstl-16" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | UE_HYDRAULIK                  |
	| vpe      | h                             |
	| vhe      | h                             |
	| epe      | h                             |
	| ehe      | h                             |
	| le       | h                             |
	| fvhe     | 1                             |
	| fehe     | 1                             |
	| fvpe     | 1                             |
	| fepe     | 1                             |
	| skfaehig | ja                            |
	| name     | ueberpruefung Hydrauliksystem |
	| erab     | 68                            |
	| ewaehr   | EUR                           |
	| ewaehr2  | EUR                           |
	| ewaehr3  | EUR                           |
	| vpr      | 125.00                        |
	| vwaehr   | EUR                           |
	| vwaehr2  | EUR                           |
	| vrab     | 68                            |
	| rerelev  | ja                            |
	| kbpr     | eigener Basispreis (zzg       |
	| kbprwaeh | EUR                           |
	| kbprpe   | Stueck                        |
	| catsale  | ja                            |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor

  
Given I open an editor "TeilDienstl-17" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | INSP_1200_BS                   |
	| vpe      | h                              |
	| vhe      | Stueck                         |
	| epe      | Stueck                         |
	| ehe      | Stueck                         |
	| le       | h                              |
	| fvhe     | 1                              |
	| fehe     | 1                              |
	| fvpe     | 1                              |
	| fepe     | 1                              |
	| skfaehig | ja                             |
	| name     | Inspektion 1200 Betriebsstunden|
	| erab     | 58                             |
	| ewaehr   | EUR                            |
	| ewaehr2  | EUR                            |
	| ewaehr3  | EUR                            |
	| vpr      | 2700.00                        |
	| vwaehr   | EUR                            |
	| vwaehr2  | EUR                            |
	| vrab     | 58                             |
	| rerelev  | ja                             |
	| kbpr     | eigener Basispreis (zzg        |
	| kbprwaeh | EUR                            |
	| kbprpe   | Stueck                         |
	| catsale  | ja                             |
And I append rows
	| elex  | elanzahl    |
	| a ag2 | !dontChange |
	| e2    | 2           |
And I save the current editor
 
 
Given I open an editor "TeilDienstl-18" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
And I set fields
	| nummer  | 1003          |
	| dienstl | INSP_1200_BS  |
And I append rows
	| elex         | elanzahl |
	| OELWECHSEL_G | 1        |
	| OELWECHSEL_M | 1        |
	| UE_HYDRAULIK | 1        |
	| OELFILTER    | 1        |
And I save the current editor
  
Given I open an editor "TeilDienstl-19" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge     | FIFO                          |
	| such       | TISCH                         |
	| vpe        | Stueck                        |
	| vhe        | Stueck                        |
	| epe        | Stueck                        |
	| ehe        | Stueck                        |
	| le         | Stueck                        |
	| lme        | mm                            |
	| bme        | mm                            |
	| fvhe       | 1                             |
	| fehe       | 1                             |
	| fle        | 1                             |
	| fvpe       | 1                             |
	| fepe       | 1                             |
	| skfaehig   | ja                            |
	| name       | Tisch                         |
	| erab       | 20013                         |
	| ewaehr     | EUR                           |
	| ewaehr2    | EUR                           |
	| ewaehr3    | EUR                           |
	| vwaehr     | EUR                           |
	| vwaehr2    | EUR                           |
	| vrab       | 20013                         |
	| prov       | 20013                         |
	| vbez       | Trekking-Rahmen, blau lackiert|
	| intrarel   | ja                            |
	| dispoa     | bedarfsbezogen                |
	| rerelev    | ja                            |
	| ge         | Stueck                        |
	| ve         | Stueck                        |
	| fve        | 1                             |
	| fge        | 1                             |
	| zuplatz    | F1                            |
	| abplatz    | F1                            |
	| kbpr       | Einkaufspreis                 |
	| kbprwaeh   | EUR                           |
	| kbprpe     | Stueck                        |
	| bsart      | Eigenfertigung                |
	| earta      | ueber Artikel                 |
	| ersabplatz | f3                            |
	| gdauer     | 365D                          |
	| nwpflicht  | ja                            |
And I append rows
	| elex           | lge         | elanzahl    | bu          | breite      | mgr         |
	| ROHR-ST-16*1.2 | 2.5         | 1           | !dontChange | !dontChange | !dontChange |
	| LF_GRUNDIERUNG | !dontChange | 1           | Ende        | !dontChange | !dontChange |
	| A TROCKNEN     | !dontChange | 0.05        | Ende        | 10          | 109         |
	| LF_LACK-BLAU   | !dontChange | 1           | Ende        | !dontChange | !dontChange |
	| A TROCKNEN     | !dontChange | 0.05        | Ende        | 15          | 109         |
And I save the current editor
  
Given I open an editor "TeilDienstl-20" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| vfolge    | FIFO                  |
	| such      | SCHRAUBE-M5           |
	| vpe       | Stueck                |
	| vhe       | Stueck                |
	| epe       | Stueck                |
	| ehe       | Stueck                |
	| le        | Stueck                |
	| lme       | mm                    |
	| bme       | mm                    |
	| fvhe      | 1                     |
	| fehe      | 1                     |
	| fle       | 1                     |
	| fvpe      | 1                     |
	| fepe      | 1                     |
	| skfaehig  | ja                    |
	| name      | Schraube M5           |
	| lief      | 60004                 |
	| epr       | 0.05                  |
	| erab      | 10015                 |
	| ewaehr    | EUR                   |
	| ewaehr2   | EUR                   |
	| ewaehr3   | EUR                   |
	| efrist    | 2                     |
	| vorlauf   | 2                     |
	| vwaehr    | EUR                   |
	| vwaehr2   | EUR                   |
	| vrab      | 10015                 |
	| prov      | 10015                 |
	| ebez      | Schraube M5           |
	| intrarel  | ja                    |
	| losgr     | 100                   |
	| dispoa    | mindestbestandsbezogen|
	| mindest   | 1000                  |
	| rerelev   | ja                    |
	| ge        | Stueck                |
	| ve        | Stueck                |
	| fve       | 1                     |
	| fge       | 1                     |
	| zuplatz   | F1                    |
	| abplatz   | F1                    |
	| kbpr      | Einkaufspreis         |
	| kbprwaeh  | EUR                   |
	| kbprpe    | Stueck                |
	| bsart     | Fremdbeschaffung      |
	| earta     | ueber Artikel         |
	| gdauer    | 365D                  |
	| nwpflicht | ja                    |
	| chimlager | ja                    |
And I save the current editor

  
Given I open an editor "TeilDienstl-21" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
	| such     | KABEL        |
	| namebspr | Elektrokabel |
	| le       | m            |
	| vpe      | m            |
	| vpr      | 0,50         |
And I save the current editor

Given I open an editor "TeilDienstl-22" from table "(Part):(Product)" with command "COPY" for record "TRACTORM830T"
And I set fields
	| such | F248-Tractor            |
	| name | Traktor, Modell F248 F1 |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Kunden, Chargen
# ----------------------------------------------------------------------------------------------
Given I open an editor "KundeKunde01" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I set fields
	| techniker | SPEZIALIST1   |
	| extdl     | 001           |
	| email     | bheim@abas.de |
And I save the current editor

Given I open an editor "FirmaFirmaDaten-01" from table "(Company):(CompanyData)" with command "UPDATE" for record "BETR"
And I set field "email" to "hotline@abas.de" 
And I save the current editor

Given I open an editor "chargeneu-23" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer  | 1     |
	| such    | CH-E3 |
	| exnum   | CH-E3 |
	| artikel | e3    |
And I save the current editor
Given I open an editor "chargeneu-23.1" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer  | 2     |
	| such    | CH-E2 |
	| exnum   | CH-E2 |
	| artikel | e2    |
And I save the current editor
Given I open an editor "chargeneu-23.2" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer  | 3     |
	| such    | CH-E1 |
	| exnum   | CH-E1 |
	| artikel | e1    |
And I save the current editor
Given I open an editor "chargeneu-23.3" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer  | 4       |
	| such    | CH-E1-2 |
	| exnum   | CH-E1-2 |
	| artikel | e1      |
And I save the current editor
Given I open an editor "chargeneu-23.4" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer | 10    |
	| such   | CH-10 |
	| exnum  | CH-10 |
And I save the current editor
Given I open an editor "chargeneu-23.5" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer | 11    |
	| such   | CH-11 |
	| exnum  | CH-11 |
And I save the current editor
Given I open an editor "chargeneu-23.5" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer  | 50          |
	| such    | CH-GETRIEBE |
	| exnum   | CH-GETRIEBE |
	| artikel | getriebe185 |
And I save the current editor
Given I open an editor "chargeneu-23.6" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer  | 51            |
	| such    | CH-GETRIEBE-1 |
	| exnum   | CH-GETRIEBE-1 |
	| artikel | getriebe185   |
And I save the current editor
Given I open an editor "chargeneu-23.7" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer  | 52            |
	| such    | CH-GETRIEBE-2 |
	| exnum   | CH-GETRIEBE-2 |
	| artikel | getriebe185   |
And I save the current editor
Given I open an editor "chargeneu-23.8" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
	| nummer  | 53            |
	| such    | CH-GETRIEBE-3 |
	| exnum   | CH-GETRIEBE-3 |
	| artikel | getriebe185   |
And I save the current editor
Given I open an editor "TeilDienstl-23" from table "(Part):(Product)" with command "UPDATE" for record "e3"
And I set field "vfolge" to "FIFO" 
And I save the current editor

Given I open an editor "TeilDienstl-24" from table "(Part):(Product)" with command "UPDATE" for record "e1"
And I set field "vfolge" to "FIFO" 
And I create a new row at the end of the table
And I set field "elex" to "e3" in row 1
And I set field "elanzahl" to "1" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Lagerbestaende schaffen
# ----------------------------------------------------------------------------------------------
Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
	| artikel | e2 |
	| buart   | zu |
	| beleg   | .  |
	| beldat  | .  |
And I set field "mge" to "100" in row 1
And I set field "platz2" to "F2" in row 1
And I set field "charge2" to "CH-E2" in row 1
And I save the current editor

Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
	| artikel | MOTORKW276 |
	| buart   | zu         |
	| beleg   | .          |
	| beldat  | .          |
	| wert    | 4520       |
And I set field "mge" to "100" in row 1
And I set field "platz2" to "F2" in row 1
And I save the current editor

Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
	| artikel | MOTOROEL_5W30 |
	| buart   | zu            |
	| beleg   | .             |
	| beldat  | .             |
	| wert    | 19,55         |
And I set field "mge" to "100" in row 1
And I set field "platz2" to "F2" in row 1
And I save the current editor

Given I open an editor "LBuchung" for tip command "Lbuchung" and arguments ""
And I set fields
	| artikel | e3  |
	| buart   | zu  |
	| beleg   | .   |
	| beldat  | .   |
And I set field "mge" to "100" in row 1
And I set field "platz2" to "F2" in row 1
And I set field "charge2" to "CH-E3" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Servicedienstleistungen
# ----------------------------------------------------------------------------------------------
Given I open an editor "TeilDienstl-24" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | Fehleranalyse              |
	| vpe      | Stueck                     |
	| vhe      | Stueck                     |
	| epe      | Stueck                     |
	| ehe      | Stueck                     |
	| le       | Stueck                     |
	| fvhe     | 1                          |
	| fehe     | 1                          |
	| fvpe     | 1                          |
	| fepe     | 1                          |
	| skfaehig | ja                         |
	| name     | Inspektion "Fehleranalyse" |
	| epr      | 30.00                      |
	| erab     | 72                         |
	| ewaehr   | EUR                        |
	| ewaehr2  | EUR                        |
	| ewaehr3  | EUR                        |
	| vwaehr   | EUR                        |
	| vwaehr2  | EUR                        |
	| vrab     | 72                         |
	| rerelev  | ja                         |
	| kbpr     | eigener Basispreis (zz     |
	| kbprwaeh | EUR                        |
	| kbprpe   | Stueck                     |
	| catsale  | ja                         |
And I append rows
	| elex  |
	| a ag1 |
And I save the current editor

Given I open an editor "TeilDienstl-25" from table "(Part):(Service)" with command "NEW" for record ""
And I set fields
	| such     | Reparieren                     |
	| vpe      | Stueck                         |
	| vhe      | Stueck                         |
	| epe      | Stueck                         |
	| ehe      | Stueck                         |
	| le       | Stueck                         |
	| fvhe     | 1                              |
	| fehe     | 1                              |
	| fvpe     | 1                              |
	| fepe     | 1                              |
	| skfaehig | ja                             |
	| name     | Inspektion "Reparieren des Ger |
	| epr      | 100.00                         |
	| erab     | 72                             |
	| ewaehr   | EUR                            |
	| ewaehr2  | EUR                            |
	| ewaehr3  | EUR                            |
	| vpr      | 22.00                          |
	| vwaehr   | EUR                            |
	| vwaehr2  | EUR                            |
	| kbpr     | eigener Basispreis (zz         |
	| kbprwaeh | EUR                            |
	| kbprpe   | Stueck                         |
	| catsale  | ja                             |
And I append rows
	| elex  |
	| a ag2 |
And I save the current editor

Given I open an editor "TeilDienstl-26" from table "(Company):(Summary)" with command "NEW" for record ""
And I set fields
	| nummer    | 1SERVAU        |
	| such      | SERVAU         |
	| classname | Serviceauftrag |
	| typ       | Serviceauftrag |
And I save the current editor

Given I open an editor "aufzaehlungAufzaehl-01" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "20341"
And I set fields
	| fldname  | such |
	| fldkname | such |
And I append rows
	| aufzelem |
	| SERVAU   |
And I respond with answer "ja" to the dialog with id "10951"
And I save the current editor

Given I open an editor "aufzaehlungAufzaehl-02" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "20341"
And I set field "reosofort" to "ja" 
And I save the current editor
