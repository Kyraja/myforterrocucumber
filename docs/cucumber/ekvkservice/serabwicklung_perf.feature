# *****************************************************************************
#  Name           : serabwicklung_perf.feature
#  Verantwortlich : teampss
#  Funktion       : Performancetest zur Serviceabwicklung
#
# *****************************************************************************
#
@persistent
Feature: Performancekritische Ablaeufe in der Serviceabwicklung
Background:
Given I set the fake date to "02.01.1995"

Scenario Outline: Charge im Lager aktivieren

Given I open an editor "art-einkaufsteil" from table "(Part):(Product)" with command "UPDATE" for record "<teilenr>"
And I set field "chimlager" to "ja"
And I save the current editor

Examples:
   | teilenr |
   | 0-C     |
   | 0-R     |
   | 0-T     |
   | 1-C     |
   | 1-R     |
   | 1-T     |
   | 2-C     |
   | 2-R     |
   | 2-T     |
   | 3-C     |
   | 3-R     |
   | 3-T     |
   | 4-C     |
   | 4-R     |
   | 4-T     |
   | 5-C     |
   | 5-R     |
   | 5-T     |
   | 6-C     |
   | 6-R     |
   | 6-T     |
   | 7-C     |
   | 7-R     |
   | 7-T     |
   | 8-C     |
   | 8-R     |
   | 8-T     |
   | 9-C     |
   | 9-R     |
   | 9-T     |
   | 10-C    |
   | 10-R    |
   | 10-T    |
   | 11-C    |
   | 11-R    |
   | 11-T    |
   | 12-C    |
   | 12-R    |
   | 12-T    |
   | 13-C    |
   | 13-R    |
   | 13-T    |
   | 14-C    |
   | 14-R    |
   | 14-T    |
   | 15-C    |
   | 15-R    |
   | 15-T    |
   | 16-C    |
   | 16-R    |
   | 16-T    |
   | 17-C    |
   | 17-R    |
   | 17-T    |
   | 18-C    |
   | 18-R    |
   | 18-T    |
   | 19-C    |
   | 19-R    |
   | 19-T    |
   | 20-C    |
   | 20-R    |
   | 20-T    |
   | 21-C    |
   | 21-R    |
   | 21-T    |
   | 22-C    |
   | 22-R    |
   | 22-T    |
   | 23-C    |
   | 23-R    |
   | 23-T    |
   | 24-C    |
   | 24-R    |
   | 24-T    |
   | 25-C    |
   | 25-R    |
   | 25-T    |
   | 26-C    |
   | 26-R    |
   | 26-T    |
   | 27-C    |
   | 27-R    |
   | 27-T    |
   | 28-C    |
   | 28-R    |
   | 28-T    |
   | 29-C    |
   | 29-R    |
   | 29-T    |
   | 30-C    |
   | 30-R    |
   | 30-T    |
   | 31-C    |
   | 31-R    |
   | 31-T    |
   | 32-C    |
   | 32-R    |
   | 32-T    |
   | 33-C    |
   | 33-R    |
   | 33-T    |
   | 34-C    |
   | 34-R    |
   | 34-T    |
   | 35-C    |
   | 35-R    |
   | 35-T    |
   | 36-C    |
   | 36-R    |
   | 36-T    |
   | 37-C    |
   | 37-R    |
   | 37-T    |
   | 38-C    |
   | 38-R    |
   | 38-T    |
   | 39-C    |
   | 39-R    |
   | 39-T    |
   | 40-C    |
   | 40-R    |
   | 40-T    |
   | 41-C    |
   | 41-R    |
   | 41-T    |
   | 42-C    |
   | 42-R    |
   | 42-T    |
   | 43-C    |
   | 43-R    |
   | 43-T    |
   | 44-C    |
   | 44-R    |
   | 44-T    |
   | 45-C    |
   | 45-R    |
   | 45-T    |
   | 46-C    |
   | 46-R    |
   | 46-T    |
   | 47-C    |
   | 47-R    |
   | 47-T    |
   | 48-C    |
   | 48-R    |
   | 48-T    |
   | 49-C    |
   | 49-R    |
   | 49-T    |

Scenario Outline: Chargen anlegen

Given I open an editor "charge" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | C-<teilenr> |
   | exnum   | C-<teilenr> |
   | artikel | <teilenr>   |
And I save the current editor

Examples:
   | teilenr |
   | 0-C     |
   | 0-R     |
   | 0-T     |
   | 1-C     |
   | 1-R     |
   | 1-T     |
   | 2-C     |
   | 2-R     |
   | 2-T     |
   | 3-C     |
   | 3-R     |
   | 3-T     |
   | 4-C     |
   | 4-R     |
   | 4-T     |
   | 5-C     |
   | 5-R     |
   | 5-T     |
   | 6-C     |
   | 6-R     |
   | 6-T     |
   | 7-C     |
   | 7-R     |
   | 7-T     |
   | 8-C     |
   | 8-R     |
   | 8-T     |
   | 9-C     |
   | 9-R     |
   | 9-T     |
   | 10-C    |
   | 10-R    |
   | 10-T    |
   | 11-C    |
   | 11-R    |
   | 11-T    |
   | 12-C    |
   | 12-R    |
   | 12-T    |
   | 13-C    |
   | 13-R    |
   | 13-T    |
   | 14-C    |
   | 14-R    |
   | 14-T    |
   | 15-C    |
   | 15-R    |
   | 15-T    |
   | 16-C    |
   | 16-R    |
   | 16-T    |
   | 17-C    |
   | 17-R    |
   | 17-T    |
   | 18-C    |
   | 18-R    |
   | 18-T    |
   | 19-C    |
   | 19-R    |
   | 19-T    |
   | 20-C    |
   | 20-R    |
   | 20-T    |
   | 21-C    |
   | 21-R    |
   | 21-T    |
   | 22-C    |
   | 22-R    |
   | 22-T    |
   | 23-C    |
   | 23-R    |
   | 23-T    |
   | 24-C    |
   | 24-R    |
   | 24-T    |
   | 25-C    |
   | 25-R    |
   | 25-T    |
   | 26-C    |
   | 26-R    |
   | 26-T    |
   | 27-C    |
   | 27-R    |
   | 27-T    |
   | 28-C    |
   | 28-R    |
   | 28-T    |
   | 29-C    |
   | 29-R    |
   | 29-T    |
   | 30-C    |
   | 30-R    |
   | 30-T    |
   | 31-C    |
   | 31-R    |
   | 31-T    |
   | 32-C    |
   | 32-R    |
   | 32-T    |
   | 33-C    |
   | 33-R    |
   | 33-T    |
   | 34-C    |
   | 34-R    |
   | 34-T    |
   | 35-C    |
   | 35-R    |
   | 35-T    |
   | 36-C    |
   | 36-R    |
   | 36-T    |
   | 37-C    |
   | 37-R    |
   | 37-T    |
   | 38-C    |
   | 38-R    |
   | 38-T    |
   | 39-C    |
   | 39-R    |
   | 39-T    |
   | 40-C    |
   | 40-R    |
   | 40-T    |
   | 41-C    |
   | 41-R    |
   | 41-T    |
   | 42-C    |
   | 42-R    |
   | 42-T    |
   | 43-C    |
   | 43-R    |
   | 43-T    |
   | 44-C    |
   | 44-R    |
   | 44-T    |
   | 45-C    |
   | 45-R    |
   | 45-T    |
   | 46-C    |
   | 46-R    |
   | 46-T    |
   | 47-C    |
   | 47-R    |
   | 47-T    |
   | 48-C    |
   | 48-R    |
   | 48-T    |
   | 49-C    |
   | 49-R    |
   | 49-T    |

Scenario: Baugruppe anlegen

Given I open an editor "art-platine" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | PLATINE         |
   | namebspr  | Platine         |
   | dispoa    | auftragsbezogen |
   | bsart     | Eigenfertigung  |
   | chimlager | ja              |
And I append rows
   | elex       | elanzahl | tnwpflicht |
   | 0-C        | 1        | ja         |
   | 0-R        | 2        | ja         |
   | 0-T        | 3        | ja         |
   | 1-C        | 1        | ja         |
   | 1-R        | 2        | ja         |
   | 1-T        | 3        | ja         |
   | 2-C        | 1        | ja         |
   | 2-R        | 2        | ja         |
   | 2-T        | 3        | ja         |
   | 3-C        | 1        | ja         |
   | 3-R        | 2        | ja         |
   | 3-T        | 3        | ja         |
   | 4-C        | 1        | ja         |
   | 4-R        | 2        | ja         |
   | 4-T        | 3        | ja         |
   | 5-C        | 1        | ja         |
   | 5-R        | 2        | ja         |
   | 5-T        | 3        | ja         |
   | 6-C        | 1        | ja         |
   | 6-R        | 2        | ja         |
   | 6-T        | 3        | ja         |
   | 7-C        | 1        | ja         |
   | 7-R        | 2        | ja         |
   | 7-T        | 3        | ja         |
   | 8-C        | 1        | ja         |
   | 8-R        | 2        | ja         |
   | 8-T        | 3        | ja         |
   | 9-C        | 1        | ja         |
   | 9-R        | 2        | ja         |
   | 9-T        | 3        | ja         |
   | 10-C       | 11       | ja         |
   | 10-R       | 12       | ja         |
   | 10-T       | 13       | ja         |
   | 11-C       | 11       | ja         |
   | 11-R       | 12       | ja         |
   | 11-T       | 13       | ja         |
   | 12-C       | 11       | ja         |
   | 12-R       | 12       | ja         |
   | 12-T       | 13       | ja         |
   | 13-C       | 11       | ja         |
   | 13-R       | 12       | ja         |
   | 13-T       | 13       | ja         |
   | 14-C       | 11       | ja         |
   | 14-R       | 12       | ja         |
   | 14-T       | 13       | ja         |
   | 15-C       | 11       | ja         |
   | 15-R       | 12       | ja         |
   | 15-T       | 13       | ja         |
   | 16-C       | 11       | ja         |
   | 16-R       | 12       | ja         |
   | 16-T       | 13       | ja         |
   | 17-C       | 11       | ja         |
   | 17-R       | 12       | ja         |
   | 17-T       | 13       | ja         |
   | 18-C       | 11       | ja         |
   | 18-R       | 12       | ja         |
   | 18-T       | 13       | ja         |
   | 19-C       | 11       | ja         |
   | 19-R       | 12       | ja         |
   | 19-T       | 13       | ja         |
   | 20-C       | 21       | ja         |
   | 20-R       | 22       | ja         |
   | 20-T       | 23       | ja         |
   | 21-C       | 21       | ja         |
   | 21-R       | 22       | ja         |
   | 21-T       | 23       | ja         |
   | 22-C       | 21       | ja         |
   | 22-R       | 22       | ja         |
   | 22-T       | 23       | ja         |
   | 23-C       | 21       | ja         |
   | 23-R       | 22       | ja         |
   | 23-T       | 23       | ja         |
   | 24-C       | 21       | ja         |
   | 24-R       | 22       | ja         |
   | 24-T       | 23       | ja         |
   | 25-C       | 21       | ja         |
   | 25-R       | 22       | ja         |
   | 25-T       | 23       | ja         |
   | 26-C       | 21       | ja         |
   | 26-R       | 22       | ja         |
   | 26-T       | 23       | ja         |
   | 27-C       | 21       | ja         |
   | 27-R       | 22       | ja         |
   | 27-T       | 23       | ja         |
   | 28-C       | 21       | ja         |
   | 28-R       | 22       | ja         |
   | 28-T       | 23       | ja         |
   | 29-C       | 21       | ja         |
   | 29-R       | 22       | ja         |
   | 29-T       | 23       | ja         |
   | 30-C       | 31       | ja         |
   | 30-R       | 32       | ja         |
   | 30-T       | 33       | ja         |
   | 31-C       | 31       | ja         |
   | 31-R       | 32       | ja         |
   | 31-T       | 33       | ja         |
   | 32-C       | 31       | ja         |
   | 32-R       | 32       | ja         |
   | 32-T       | 33       | ja         |
   | 33-C       | 31       | ja         |
   | 33-R       | 32       | ja         |
   | 33-T       | 33       | ja         |
   | 34-C       | 31       | ja         |
   | 34-R       | 32       | ja         |
   | 34-T       | 33       | ja         |
   | 35-C       | 31       | ja         |
   | 35-R       | 32       | ja         |
   | 35-T       | 33       | ja         |
   | 36-C       | 31       | ja         |
   | 36-R       | 32       | ja         |
   | 36-T       | 33       | ja         |
   | 37-C       | 31       | ja         |
   | 37-R       | 32       | ja         |
   | 37-T       | 33       | ja         |
   | 38-C       | 31       | ja         |
   | 38-R       | 32       | ja         |
   | 38-T       | 33       | ja         |
   | 39-C       | 31       | ja         |
   | 39-R       | 32       | ja         |
   | 39-T       | 33       | ja         |
   | 40-C       | 41       | ja         |
   | 40-R       | 42       | ja         |
   | 40-T       | 43       | ja         |
   | 41-C       | 41       | ja         |
   | 41-R       | 42       | ja         |
   | 41-T       | 43       | ja         |
   | 42-C       | 41       | ja         |
   | 42-R       | 42       | ja         |
   | 42-T       | 43       | ja         |
   | 43-C       | 41       | ja         |
   | 43-R       | 42       | ja         |
   | 43-T       | 43       | ja         |
   | 44-C       | 41       | ja         |
   | 44-R       | 42       | ja         |
   | 44-T       | 43       | ja         |
   | 45-C       | 41       | ja         |
   | 45-R       | 42       | ja         |
   | 45-T       | 43       | ja         |
   | 46-C       | 41       | ja         |
   | 46-R       | 42       | ja         |
   | 46-T       | 43       | ja         |
   | 47-C       | 41       | ja         |
   | 47-R       | 42       | ja         |
   | 47-T       | 43       | ja         |
   | 48-C       | 41       | ja         |
   | 48-R       | 42       | ja         |
   | 48-T       | 43       | ja         |
   | 49-C       | 41       | ja         |
   | 49-R       | 42       | ja         |
   | 49-T       | 43       | ja         |
   | A AG1      | 1        | ja         |
And I save the current editor

Scenario Outline: Serviceprodukte anlegen

Given I open an editor "sp-platine" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "PLATINE<serprod>"
And I set field "namebspr" to "Platine"
And I set field "artikel" to id from editor "art-platine"
And I save the current editor

Examples:
   | serprod |
   | 001     |
   | 002     |
   | 003     |
   | 004     |
   | 005     |
   | 006     |
   | 007     |
   | 008     |
   | 009     |
   | 010     |
   | 011     |
   | 012     |
   | 013     |
   | 014     |
   | 015     |
   | 016     |
   | 017     |
   | 018     |
   | 019     |
   | 020     |
   | 021     |
   | 022     |
   | 023     |
   | 024     |
   | 025     |
   | 026     |
   | 027     |
   | 028     |
   | 029     |
   | 030     |
   | 031     |
   | 032     |
   | 033     |
   | 034     |
   | 035     |
   | 036     |
   | 037     |
   | 038     |
   | 039     |
   | 040     |
   | 041     |
   | 042     |
   | 043     |
   | 044     |
   | 045     |
   | 046     |
   | 047     |
   | 048     |
   | 049     |
   | 050     |
   | 051     |
   | 052     |
   | 053     |
   | 054     |
   | 055     |
   | 056     |
   | 057     |
   | 058     |
   | 059     |
   | 060     |
   | 061     |
   | 062     |
   | 063     |
   | 064     |
   | 065     |
   | 066     |
   | 067     |
   | 068     |
   | 069     |
   | 070     |
   | 071     |
   | 072     |
   | 073     |
   | 074     |
   | 075     |
   | 076     |
   | 077     |
   | 078     |
   | 079     |
   | 080     |
   | 081     |
   | 082     |
   | 083     |
   | 084     |
   | 085     |
   | 086     |
   | 087     |
   | 088     |
   | 089     |
   | 090     |
   | 091     |
   | 092     |
   | 093     |
   | 094     |
   | 095     |
   | 096     |
   | 097     |
   | 098     |
   | 099     |
   | 100     |
   | 101     |
   | 102     |
   | 103     |
   | 104     |
   | 105     |
   | 106     |
   | 107     |
   | 108     |
   | 109     |
   | 110     |
   | 111     |
   | 112     |
   | 113     |
   | 114     |
   | 115     |
   | 116     |
   | 117     |
   | 118     |
   | 119     |
   | 120     |
   | 121     |
   | 122     |
   | 123     |
   | 124     |
   | 125     |
   | 126     |
   | 127     |
   | 128     |
   | 129     |
   | 130     |
   | 131     |
   | 132     |
   | 133     |
   | 134     |
   | 135     |
   | 136     |
   | 137     |
   | 138     |
   | 139     |
   | 140     |
   | 141     |
   | 142     |
   | 143     |
   | 144     |
   | 145     |
   | 146     |
   | 147     |
   | 148     |
   | 149     |
   | 150     |
   | 151     |
   | 152     |
   | 153     |
   | 154     |
   | 155     |
   | 156     |
   | 157     |
   | 158     |
   | 159     |
   | 160     |
   | 161     |
   | 162     |
   | 163     |
   | 164     |
   | 165     |
   | 166     |
   | 167     |
   | 168     |
   | 169     |
   | 170     |
   | 171     |
   | 172     |
   | 173     |
   | 174     |
   | 175     |
   | 176     |
   | 177     |
   | 178     |
   | 179     |
   | 180     |
   | 181     |
   | 182     |
   | 183     |
   | 184     |
   | 185     |
   | 186     |
   | 187     |
   | 188     |
   | 189     |
   | 190     |
   | 191     |
   | 192     |
   | 193     |
   | 194     |
   | 195     |
   | 196     |
   | 197     |
   | 198     |
   | 199     |
   | 200     |

Scenario: Bestellung und Lieferschein anlegen

Given I open an editor "1BE100" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE100 |
And I append rows
   | artex  | mge     | vmge    | platz | charge |
   | 0-C    | 100000  | 100000  | F1    | C-0-C  |
   | 0-R    | 100000  | 100000  | F1    | C-0-R  |
   | 0-T    | 100000  | 100000  | F1    | C-0-T  |
   | 1-C    | 100000  | 100000  | F1    | C-1-C  |
   | 1-R    | 100000  | 100000  | F1    | C-1-R  |
   | 1-T    | 100000  | 100000  | F1    | C-1-T  |
   | 2-C    | 100000  | 100000  | F1    | C-2-C  |
   | 2-R    | 100000  | 100000  | F1    | C-2-R  |
   | 2-T    | 100000  | 100000  | F1    | C-2-T  |
   | 3-C    | 100000  | 100000  | F1    | C-3-C  |
   | 3-R    | 100000  | 100000  | F1    | C-3-R  |
   | 3-T    | 100000  | 100000  | F1    | C-3-T  |
   | 4-C    | 100000  | 100000  | F1    | C-4-C  |
   | 4-R    | 100000  | 100000  | F1    | C-4-R  |
   | 4-T    | 100000  | 100000  | F1    | C-4-T  |
   | 5-C    | 100000  | 100000  | F1    | C-5-C  |
   | 5-R    | 100000  | 100000  | F1    | C-5-R  |
   | 5-T    | 100000  | 100000  | F1    | C-5-T  |
   | 6-C    | 100000  | 100000  | F1    | C-6-C  |
   | 6-R    | 100000  | 100000  | F1    | C-6-R  |
   | 6-T    | 100000  | 100000  | F1    | C-6-T  |
   | 7-C    | 100000  | 100000  | F1    | C-7-C  |
   | 7-R    | 100000  | 100000  | F1    | C-7-R  |
   | 7-T    | 100000  | 100000  | F1    | C-7-T  |
   | 8-C    | 100000  | 100000  | F1    | C-8-C  |
   | 8-R    | 100000  | 100000  | F1    | C-8-R  |
   | 8-T    | 100000  | 100000  | F1    | C-8-T  |
   | 9-C    | 100000  | 100000  | F1    | C-9-C  |
   | 9-R    | 100000  | 100000  | F1    | C-9-R  |
   | 9-T    | 100000  | 100000  | F1    | C-9-T  |
   | 10-C   | 100000  | 100000  | F1    | C-10-C |
   | 10-R   | 100000  | 100000  | F1    | C-10-R |
   | 10-T   | 100000  | 100000  | F1    | C-10-T |
   | 11-C   | 100000  | 100000  | F1    | C-11-C |
   | 11-R   | 100000  | 100000  | F1    | C-11-R |
   | 11-T   | 100000  | 100000  | F1    | C-11-T |
   | 12-C   | 100000  | 100000  | F1    | C-12-C |
   | 12-R   | 100000  | 100000  | F1    | C-12-R |
   | 12-T   | 100000  | 100000  | F1    | C-12-T |
   | 13-C   | 100000  | 100000  | F1    | C-13-C |
   | 13-R   | 100000  | 100000  | F1    | C-13-R |
   | 13-T   | 100000  | 100000  | F1    | C-13-T |
   | 14-C   | 100000  | 100000  | F1    | C-14-C |
   | 14-R   | 100000  | 100000  | F1    | C-14-R |
   | 14-T   | 100000  | 100000  | F1    | C-14-T |
   | 15-C   | 100000  | 100000  | F1    | C-15-C |
   | 15-R   | 100000  | 100000  | F1    | C-15-R |
   | 15-T   | 100000  | 100000  | F1    | C-15-T |
   | 16-C   | 100000  | 100000  | F1    | C-16-C |
   | 16-R   | 100000  | 100000  | F1    | C-16-R |
   | 16-T   | 100000  | 100000  | F1    | C-16-T |
   | 17-C   | 100000  | 100000  | F1    | C-17-C |
   | 17-R   | 100000  | 100000  | F1    | C-17-R |
   | 17-T   | 100000  | 100000  | F1    | C-17-T |
   | 18-C   | 100000  | 100000  | F1    | C-18-C |
   | 18-R   | 100000  | 100000  | F1    | C-18-R |
   | 18-T   | 100000  | 100000  | F1    | C-18-T |
   | 19-C   | 100000  | 100000  | F1    | C-19-C |
   | 19-R   | 100000  | 100000  | F1    | C-19-R |
   | 19-T   | 100000  | 100000  | F1    | C-19-T |
   | 20-C   | 100000  | 100000  | F1    | C-20-C |
   | 20-R   | 100000  | 100000  | F1    | C-20-R |
   | 20-T   | 100000  | 100000  | F1    | C-20-T |
   | 21-C   | 100000  | 100000  | F1    | C-21-C |
   | 21-R   | 100000  | 100000  | F1    | C-21-R |
   | 21-T   | 100000  | 100000  | F1    | C-21-T |
   | 22-C   | 100000  | 100000  | F1    | C-22-C |
   | 22-R   | 100000  | 100000  | F1    | C-22-R |
   | 22-T   | 100000  | 100000  | F1    | C-22-T |
   | 23-C   | 100000  | 100000  | F1    | C-23-C |
   | 23-R   | 100000  | 100000  | F1    | C-23-R |
   | 23-T   | 100000  | 100000  | F1    | C-23-T |
   | 24-C   | 100000  | 100000  | F1    | C-24-C |
   | 24-R   | 100000  | 100000  | F1    | C-24-R |
   | 24-T   | 100000  | 100000  | F1    | C-24-T |
   | 25-C   | 100000  | 100000  | F1    | C-25-C |
   | 25-R   | 100000  | 100000  | F1    | C-25-R |
   | 25-T   | 100000  | 100000  | F1    | C-25-T |
   | 26-C   | 100000  | 100000  | F1    | C-26-C |
   | 26-R   | 100000  | 100000  | F1    | C-26-R |
   | 26-T   | 100000  | 100000  | F1    | C-26-T |
   | 27-C   | 100000  | 100000  | F1    | C-27-C |
   | 27-R   | 100000  | 100000  | F1    | C-27-R |
   | 27-T   | 100000  | 100000  | F1    | C-27-T |
   | 28-C   | 100000  | 100000  | F1    | C-28-C |
   | 28-R   | 100000  | 100000  | F1    | C-28-R |
   | 28-T   | 100000  | 100000  | F1    | C-28-T |
   | 29-C   | 100000  | 100000  | F1    | C-29-C |
   | 29-R   | 100000  | 100000  | F1    | C-29-R |
   | 29-T   | 100000  | 100000  | F1    | C-29-T |
   | 30-C   | 100000  | 100000  | F1    | C-30-C |
   | 30-R   | 100000  | 100000  | F1    | C-30-R |
   | 30-T   | 100000  | 100000  | F1    | C-30-T |
   | 31-C   | 100000  | 100000  | F1    | C-31-C |
   | 31-R   | 100000  | 100000  | F1    | C-31-R |
   | 31-T   | 100000  | 100000  | F1    | C-31-T |
   | 32-C   | 100000  | 100000  | F1    | C-32-C |
   | 32-R   | 100000  | 100000  | F1    | C-32-R |
   | 32-T   | 100000  | 100000  | F1    | C-32-T |
   | 33-C   | 100000  | 100000  | F1    | C-33-C |
   | 33-R   | 100000  | 100000  | F1    | C-33-R |
   | 33-T   | 100000  | 100000  | F1    | C-33-T |
   | 34-C   | 100000  | 100000  | F1    | C-34-C |
   | 34-R   | 100000  | 100000  | F1    | C-34-R |
   | 34-T   | 100000  | 100000  | F1    | C-34-T |
   | 35-C   | 100000  | 100000  | F1    | C-35-C |
   | 35-R   | 100000  | 100000  | F1    | C-35-R |
   | 35-T   | 100000  | 100000  | F1    | C-35-T |
   | 36-C   | 100000  | 100000  | F1    | C-36-C |
   | 36-R   | 100000  | 100000  | F1    | C-36-R |
   | 36-T   | 100000  | 100000  | F1    | C-36-T |
   | 37-C   | 100000  | 100000  | F1    | C-37-C |
   | 37-R   | 100000  | 100000  | F1    | C-37-R |
   | 37-T   | 100000  | 100000  | F1    | C-37-T |
   | 38-C   | 100000  | 100000  | F1    | C-38-C |
   | 38-R   | 100000  | 100000  | F1    | C-38-R |
   | 38-T   | 100000  | 100000  | F1    | C-38-T |
   | 39-C   | 100000  | 100000  | F1    | C-39-C |
   | 39-R   | 100000  | 100000  | F1    | C-39-R |
   | 39-T   | 100000  | 100000  | F1    | C-39-T |
   | 40-C   | 100000  | 100000  | F1    | C-40-C |
   | 40-R   | 100000  | 100000  | F1    | C-40-R |
   | 40-T   | 100000  | 100000  | F1    | C-40-T |
   | 41-C   | 100000  | 100000  | F1    | C-41-C |
   | 41-R   | 100000  | 100000  | F1    | C-41-R |
   | 41-T   | 100000  | 100000  | F1    | C-41-T |
   | 42-C   | 100000  | 100000  | F1    | C-42-C |
   | 42-R   | 100000  | 100000  | F1    | C-42-R |
   | 42-T   | 100000  | 100000  | F1    | C-42-T |
   | 43-C   | 100000  | 100000  | F1    | C-43-C |
   | 43-R   | 100000  | 100000  | F1    | C-43-R |
   | 43-T   | 100000  | 100000  | F1    | C-43-T |
   | 44-C   | 100000  | 100000  | F1    | C-44-C |
   | 44-R   | 100000  | 100000  | F1    | C-44-R |
   | 44-T   | 100000  | 100000  | F1    | C-44-T |
   | 45-C   | 100000  | 100000  | F1    | C-45-C |
   | 45-R   | 100000  | 100000  | F1    | C-45-R |
   | 45-T   | 100000  | 100000  | F1    | C-45-T |
   | 46-C   | 100000  | 100000  | F1    | C-46-C |
   | 46-R   | 100000  | 100000  | F1    | C-46-R |
   | 46-T   | 100000  | 100000  | F1    | C-46-T |
   | 47-C   | 100000  | 100000  | F1    | C-47-C |
   | 47-R   | 100000  | 100000  | F1    | C-47-R |
   | 47-T   | 100000  | 100000  | F1    | C-47-T |
   | 48-C   | 100000  | 100000  | F1    | C-48-C |
   | 48-R   | 100000  | 100000  | F1    | C-48-R |
   | 48-T   | 100000  | 100000  | F1    | C-48-T |
   | 49-C   | 100000  | 100000  | F1    | C-49-C |
   | 49-R   | 100000  | 100000  | F1    | C-49-R |
   | 49-T   | 100000  | 100000  | F1    | C-49-T |
And I save the current editor

# Lieferschein anlegen und buchen
Given I open an editor "1LS100" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE100"
And I set fields
   | num4 | 1LS100 |
   | vom  | .      |
   | ueb  | ja     |
And I save the current editor

Scenario: Fertigungsvorschlag anlegen

Given I open an editor "fv" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | netmge |
   | PLATINE | 200    |
And I press button "absteig" to open a subeditor for "afl" in row 1
And I set field "charge" to "C-0-C" in row 1
And I set field "charge" to "C-0-R" in row 2
And I set field "charge" to "C-0-T" in row 3
And I set field "charge" to "C-1-C" in row 4
And I set field "charge" to "C-1-R" in row 5
And I set field "charge" to "C-1-T" in row 6
And I set field "charge" to "C-2-C" in row 7
And I set field "charge" to "C-2-R" in row 8
And I set field "charge" to "C-2-T" in row 9
And I set field "charge" to "C-3-C" in row 10
And I set field "charge" to "C-3-R" in row 11
And I set field "charge" to "C-3-T" in row 12
And I set field "charge" to "C-4-C" in row 13
And I set field "charge" to "C-4-R" in row 14
And I set field "charge" to "C-4-T" in row 15
And I set field "charge" to "C-5-C" in row 16
And I set field "charge" to "C-5-R" in row 17
And I set field "charge" to "C-5-T" in row 18
And I set field "charge" to "C-6-C" in row 19
And I set field "charge" to "C-6-R" in row 20
And I set field "charge" to "C-6-T" in row 21
And I set field "charge" to "C-7-C" in row 22
And I set field "charge" to "C-7-R" in row 23
And I set field "charge" to "C-7-T" in row 24
And I set field "charge" to "C-8-C" in row 25
And I set field "charge" to "C-8-R" in row 26
And I set field "charge" to "C-8-T" in row 27
And I set field "charge" to "C-9-C" in row 28
And I set field "charge" to "C-9-R" in row 29
And I set field "charge" to "C-9-T" in row 30
And I set field "charge" to "C-10-C" in row 31
And I set field "charge" to "C-10-R" in row 32
And I set field "charge" to "C-10-T" in row 33
And I set field "charge" to "C-11-C" in row 34
And I set field "charge" to "C-11-R" in row 35
And I set field "charge" to "C-11-T" in row 36
And I set field "charge" to "C-12-C" in row 37
And I set field "charge" to "C-12-R" in row 38
And I set field "charge" to "C-12-T" in row 39
And I set field "charge" to "C-13-C" in row 40
And I set field "charge" to "C-13-R" in row 41
And I set field "charge" to "C-13-T" in row 42
And I set field "charge" to "C-14-C" in row 43
And I set field "charge" to "C-14-R" in row 44
And I set field "charge" to "C-14-T" in row 45
And I set field "charge" to "C-15-C" in row 46
And I set field "charge" to "C-15-R" in row 47
And I set field "charge" to "C-15-T" in row 48
And I set field "charge" to "C-16-C" in row 49
And I set field "charge" to "C-16-R" in row 50
And I set field "charge" to "C-16-T" in row 51
And I set field "charge" to "C-17-C" in row 52
And I set field "charge" to "C-17-R" in row 53
And I set field "charge" to "C-17-T" in row 54
And I set field "charge" to "C-18-C" in row 55
And I set field "charge" to "C-18-R" in row 56
And I set field "charge" to "C-18-T" in row 57
And I set field "charge" to "C-19-C" in row 58
And I set field "charge" to "C-19-R" in row 59
And I set field "charge" to "C-19-T" in row 60
And I set field "charge" to "C-20-C" in row 61
And I set field "charge" to "C-20-R" in row 62
And I set field "charge" to "C-20-T" in row 63
And I set field "charge" to "C-21-C" in row 64
And I set field "charge" to "C-21-R" in row 65
And I set field "charge" to "C-21-T" in row 66
And I set field "charge" to "C-22-C" in row 67
And I set field "charge" to "C-22-R" in row 68
And I set field "charge" to "C-22-T" in row 69
And I set field "charge" to "C-23-C" in row 70
And I set field "charge" to "C-23-R" in row 71
And I set field "charge" to "C-23-T" in row 72
And I set field "charge" to "C-24-C" in row 73
And I set field "charge" to "C-24-R" in row 74
And I set field "charge" to "C-24-T" in row 75
And I set field "charge" to "C-25-C" in row 76
And I set field "charge" to "C-25-R" in row 77
And I set field "charge" to "C-25-T" in row 78
And I set field "charge" to "C-26-C" in row 79
And I set field "charge" to "C-26-R" in row 80
And I set field "charge" to "C-26-T" in row 81
And I set field "charge" to "C-27-C" in row 82
And I set field "charge" to "C-27-R" in row 83
And I set field "charge" to "C-27-T" in row 84
And I set field "charge" to "C-28-C" in row 85
And I set field "charge" to "C-28-R" in row 86
And I set field "charge" to "C-28-T" in row 87
And I set field "charge" to "C-29-C" in row 88
And I set field "charge" to "C-29-R" in row 89
And I set field "charge" to "C-29-T" in row 90
And I set field "charge" to "C-30-C" in row 91
And I set field "charge" to "C-30-R" in row 92
And I set field "charge" to "C-30-T" in row 93
And I set field "charge" to "C-31-C" in row 94
And I set field "charge" to "C-31-R" in row 95
And I set field "charge" to "C-31-T" in row 96
And I set field "charge" to "C-32-C" in row 97
And I set field "charge" to "C-32-R" in row 98
And I set field "charge" to "C-32-T" in row 99
And I set field "charge" to "C-33-C" in row 100
And I set field "charge" to "C-33-R" in row 101
And I set field "charge" to "C-33-T" in row 102
And I set field "charge" to "C-34-C" in row 103
And I set field "charge" to "C-34-R" in row 104
And I set field "charge" to "C-34-T" in row 105
And I set field "charge" to "C-35-C" in row 106
And I set field "charge" to "C-35-R" in row 107
And I set field "charge" to "C-35-T" in row 108
And I set field "charge" to "C-36-C" in row 109
And I set field "charge" to "C-36-R" in row 110
And I set field "charge" to "C-36-T" in row 111
And I set field "charge" to "C-37-C" in row 112
And I set field "charge" to "C-37-R" in row 113
And I set field "charge" to "C-37-T" in row 114
And I set field "charge" to "C-38-C" in row 115
And I set field "charge" to "C-38-R" in row 116
And I set field "charge" to "C-38-T" in row 117
And I set field "charge" to "C-39-C" in row 118
And I set field "charge" to "C-39-R" in row 119
And I set field "charge" to "C-39-T" in row 120
And I set field "charge" to "C-40-C" in row 121
And I set field "charge" to "C-40-R" in row 122
And I set field "charge" to "C-40-T" in row 123
And I set field "charge" to "C-41-C" in row 124
And I set field "charge" to "C-41-R" in row 125
And I set field "charge" to "C-41-T" in row 126
And I set field "charge" to "C-42-C" in row 127
And I set field "charge" to "C-42-R" in row 128
And I set field "charge" to "C-42-T" in row 129
And I set field "charge" to "C-43-C" in row 130
And I set field "charge" to "C-43-R" in row 131
And I set field "charge" to "C-43-T" in row 132
And I set field "charge" to "C-44-C" in row 133
And I set field "charge" to "C-44-R" in row 134
And I set field "charge" to "C-44-T" in row 135
And I set field "charge" to "C-45-C" in row 136
And I set field "charge" to "C-45-R" in row 137
And I set field "charge" to "C-45-T" in row 138
And I set field "charge" to "C-46-C" in row 139
And I set field "charge" to "C-46-R" in row 140
And I set field "charge" to "C-46-T" in row 141
And I set field "charge" to "C-47-C" in row 142
And I set field "charge" to "C-47-R" in row 143
And I set field "charge" to "C-47-T" in row 144
And I set field "charge" to "C-48-C" in row 145
And I set field "charge" to "C-48-R" in row 146
And I set field "charge" to "C-48-T" in row 147
And I set field "charge" to "C-49-C" in row 148
And I set field "charge" to "C-49-R" in row 149
And I set field "charge" to "C-49-T" in row 150
And I save the current editor
And I switch the current editor to editor "fv"
And I set field "bisuch" to "PLATINE" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "freig"
And I close the current editor
And I switch the current editor to editor "fv"
And I save the current editor

Scenario Outline: Rueckmeldungen anlegen

Given I open an editor "rueckmeldung" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLATINE000"
And I set fields
   | sofort | ja  |
   | mgr    | 101 |
And I set field "gutmge" to "<gutmge>" in row 1
And I save the current editor

Examples:
   | gutmge |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |
   | 1      |

Scenario Outline: Abgangslieferscheine mit Serviceprodukten anlegen

Given I open an editor "vk-lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS<vkls> |
   | kunde  | 1         |
   | ueb    | ja        |
And I append rows
   | artikel | mge | serprod       |
   | PLATINE | 1   | PLATINE<vkls> |
And I save the current editor

Examples:
   | vkls |
   | 001  |
   | 002  |
   | 003  |
   | 004  |
   | 005  |
   | 006  |
   | 007  |
   | 008  |
   | 009  |
   | 010  |
   | 011  |
   | 012  |
   | 013  |
   | 014  |
   | 015  |
   | 016  |
   | 017  |
   | 018  |
   | 019  |
   | 020  |
   | 021  |
   | 022  |
   | 023  |
   | 024  |
   | 025  |
   | 026  |
   | 027  |
   | 028  |
   | 029  |
   | 030  |
   | 031  |
   | 032  |
   | 033  |
   | 034  |
   | 035  |
   | 036  |
   | 037  |
   | 038  |
   | 039  |
   | 040  |
   | 041  |
   | 042  |
   | 043  |
   | 044  |
   | 045  |
   | 046  |
   | 047  |
   | 048  |
   | 049  |
   | 050  |
   | 051  |
   | 052  |
   | 053  |
   | 054  |
   | 055  |
   | 056  |
   | 057  |
   | 058  |
   | 059  |
   | 060  |
   | 061  |
   | 062  |
   | 063  |
   | 064  |
   | 065  |
   | 066  |
   | 067  |
   | 068  |
   | 069  |
   | 070  |
   | 071  |
   | 072  |
   | 073  |
   | 074  |
   | 075  |
   | 076  |
   | 077  |
   | 078  |
   | 079  |
   | 080  |
   | 081  |
   | 082  |
   | 083  |
   | 084  |
   | 085  |
   | 086  |
   | 087  |
   | 088  |
   | 089  |
   | 090  |
   | 091  |
   | 092  |
   | 093  |
   | 094  |
   | 095  |
   | 096  |
   | 097  |
   | 098  |
   | 099  |
   | 100  |
