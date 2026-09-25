# *****************************************************************************
#  Name           : rueck_ls_gutschrift_perf.feature
#  Verantwortlich : teampss
#  Funktion       : Performancetest fuer Ruecklieferung und Gutschrift im Einkauf/Verkauf
#
# *****************************************************************************
#
@persistent
Feature: Performancetest fuer Storno und Ruecklieferung im Einkauf/Verkauf
Background:
Given I set the fake date to "02.01.1995"

Scenario: Stammdaten anlegen

Given I open an editor "A100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | A100             |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | chimlager | ja               |
   | lief      | 1                |
   | epr       | 100              |
And I save the current editor

Scenario: Bestellung anlegen

Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | num4   | 1BE001 |
And I append rows
   | artex  | mge    |
   | A100   | 2000   |
And I save the current editor

Scenario Outline: Rechnungen anlegen

Given I open an editor "1RE" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE001"
And I set fields
   | num4   | <nummer> |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "10" in row 1
And I set field "preis" to "<preis>" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Examples:
   | nummer | preis  |
   | 1RE001 | 001    |
   | 1RE002 | 002    |
   | 1RE003 | 003    |
   | 1RE004 | 004    |
   | 1RE005 | 005    |
   | 1RE006 | 006    |
   | 1RE007 | 007    |
   | 1RE008 | 008    |
   | 1RE009 | 009    |
   | 1RE010 | 010    |
   | 1RE011 | 011    |
   | 1RE012 | 012    |
   | 1RE013 | 013    |
   | 1RE014 | 014    |
   | 1RE015 | 015    |
   | 1RE016 | 016    |
   | 1RE017 | 017    |
   | 1RE018 | 018    |
   | 1RE019 | 019    |
   | 1RE020 | 020    |
   | 1RE021 | 021    |
   | 1RE022 | 022    |
   | 1RE023 | 023    |
   | 1RE024 | 024    |
   | 1RE025 | 025    |
   | 1RE026 | 026    |
   | 1RE027 | 027    |
   | 1RE028 | 028    |
   | 1RE029 | 029    |
   | 1RE030 | 030    |
   | 1RE031 | 031    |
   | 1RE032 | 032    |
   | 1RE033 | 033    |
   | 1RE034 | 034    |
   | 1RE035 | 035    |
   | 1RE036 | 036    |
   | 1RE037 | 037    |
   | 1RE038 | 038    |
   | 1RE039 | 039    |
   | 1RE040 | 040    |
   | 1RE041 | 041    |
   | 1RE042 | 042    |
   | 1RE043 | 043    |
   | 1RE044 | 044    |
   | 1RE045 | 045    |
   | 1RE046 | 046    |
   | 1RE047 | 047    |
   | 1RE048 | 048    |
   | 1RE049 | 049    |
   | 1RE050 | 050    |
   | 1RE051 | 051    |
   | 1RE052 | 052    |
   | 1RE053 | 053    |
   | 1RE054 | 054    |
   | 1RE055 | 055    |
   | 1RE056 | 056    |
   | 1RE057 | 057    |
   | 1RE058 | 058    |
   | 1RE059 | 059    |
   | 1RE060 | 060    |
   | 1RE061 | 061    |
   | 1RE062 | 062    |
   | 1RE063 | 063    |
   | 1RE064 | 064    |
   | 1RE065 | 065    |
   | 1RE066 | 066    |
   | 1RE067 | 067    |
   | 1RE068 | 068    |
   | 1RE069 | 069    |
   | 1RE070 | 070    |
   | 1RE071 | 071    |
   | 1RE072 | 072    |
   | 1RE073 | 073    |
   | 1RE074 | 074    |
   | 1RE075 | 075    |
   | 1RE076 | 076    |
   | 1RE077 | 077    |
   | 1RE078 | 078    |
   | 1RE079 | 079    |
   | 1RE080 | 080    |
   | 1RE081 | 081    |
   | 1RE082 | 082    |
   | 1RE083 | 083    |
   | 1RE084 | 084    |
   | 1RE085 | 085    |
   | 1RE086 | 086    |
   | 1RE087 | 087    |
   | 1RE088 | 088    |
   | 1RE089 | 089    |
   | 1RE090 | 090    |
   | 1RE091 | 091    |
   | 1RE092 | 092    |
   | 1RE093 | 093    |
   | 1RE094 | 094    |
   | 1RE095 | 095    |
   | 1RE096 | 096    |
   | 1RE097 | 097    |
   | 1RE098 | 098    |
   | 1RE099 | 099    |
   | 1RE100 | 100    |
   | 1RE101 | 101    |
   | 1RE102 | 102    |
   | 1RE103 | 103    |
   | 1RE104 | 104    |
   | 1RE105 | 105    |
   | 1RE106 | 106    |
   | 1RE107 | 107    |
   | 1RE108 | 108    |
   | 1RE109 | 109    |
   | 1RE110 | 110    |
   | 1RE111 | 111    |
   | 1RE112 | 112    |
   | 1RE113 | 113    |
   | 1RE114 | 114    |
   | 1RE115 | 115    |
   | 1RE116 | 116    |
   | 1RE117 | 117    |
   | 1RE118 | 118    |
   | 1RE119 | 119    |
   | 1RE120 | 120    |
   | 1RE121 | 121    |
   | 1RE122 | 122    |
   | 1RE123 | 123    |
   | 1RE124 | 124    |
   | 1RE125 | 125    |
   | 1RE126 | 126    |
   | 1RE127 | 127    |
   | 1RE128 | 128    |
   | 1RE129 | 129    |
   | 1RE130 | 130    |
   | 1RE131 | 131    |
   | 1RE132 | 132    |
   | 1RE133 | 133    |
   | 1RE134 | 134    |
   | 1RE135 | 135    |
   | 1RE136 | 136    |
   | 1RE137 | 137    |
   | 1RE138 | 138    |
   | 1RE139 | 139    |
   | 1RE140 | 140    |
   | 1RE141 | 141    |
   | 1RE142 | 142    |
   | 1RE143 | 143    |
   | 1RE144 | 144    |
   | 1RE145 | 145    |
   | 1RE146 | 146    |
   | 1RE147 | 147    |
   | 1RE148 | 148    |
   | 1RE149 | 149    |
   | 1RE150 | 150    |
   | 1RE151 | 151    |
   | 1RE152 | 152    |
   | 1RE153 | 153    |
   | 1RE154 | 154    |
   | 1RE155 | 155    |
   | 1RE156 | 156    |
   | 1RE157 | 157    |
   | 1RE158 | 158    |
   | 1RE159 | 159    |
   | 1RE160 | 160    |
   | 1RE161 | 161    |
   | 1RE162 | 162    |
   | 1RE163 | 163    |
   | 1RE164 | 164    |
   | 1RE165 | 165    |
   | 1RE166 | 166    |
   | 1RE167 | 167    |
   | 1RE168 | 168    |
   | 1RE169 | 169    |
   | 1RE170 | 170    |
   | 1RE171 | 171    |
   | 1RE172 | 172    |
   | 1RE173 | 173    |
   | 1RE174 | 174    |
   | 1RE175 | 175    |
   | 1RE176 | 176    |
   | 1RE177 | 177    |
   | 1RE178 | 178    |
   | 1RE179 | 179    |
   | 1RE180 | 180    |
   | 1RE181 | 181    |
   | 1RE182 | 182    |
   | 1RE183 | 183    |
   | 1RE184 | 184    |
   | 1RE185 | 185    |
   | 1RE186 | 186    |
   | 1RE187 | 187    |
   | 1RE188 | 188    |
   | 1RE189 | 189    |
   | 1RE190 | 190    |
   | 1RE191 | 191    |
   | 1RE192 | 192    |
   | 1RE193 | 193    |
   | 1RE194 | 194    |
   | 1RE195 | 195    |
   | 1RE196 | 196    |
   | 1RE197 | 197    |
   | 1RE198 | 198    |
   | 1RE199 | 199    |
   | 1RE200 | 200    |

Scenario Outline: Lieferscheine anlegen

Given I open an editor "1LS" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | num4   | <nummer> |
   | vom    | .        |
   | ueb    | ja       |
And I set field "mge" to "20" in row 1
And I save the current editor

Examples:
   | nummer |
   | 1LS001 |
   | 1LS002 |
   | 1LS003 |
   | 1LS004 |
   | 1LS005 |
   | 1LS006 |
   | 1LS007 |
   | 1LS008 |
   | 1LS009 |
   | 1LS010 |
   | 1LS011 |
   | 1LS012 |
   | 1LS013 |
   | 1LS014 |
   | 1LS015 |
   | 1LS016 |
   | 1LS017 |
   | 1LS018 |
   | 1LS019 |
   | 1LS020 |
   | 1LS021 |
   | 1LS022 |
   | 1LS023 |
   | 1LS024 |
   | 1LS025 |
   | 1LS026 |
   | 1LS027 |
   | 1LS028 |
   | 1LS029 |
   | 1LS030 |
   | 1LS031 |
   | 1LS032 |
   | 1LS033 |
   | 1LS034 |
   | 1LS035 |
   | 1LS036 |
   | 1LS037 |
   | 1LS038 |
   | 1LS039 |
   | 1LS040 |
   | 1LS041 |
   | 1LS042 |
   | 1LS043 |
   | 1LS044 |
   | 1LS045 |
   | 1LS046 |
   | 1LS047 |
   | 1LS048 |
   | 1LS049 |
   | 1LS050 |
   | 1LS051 |
   | 1LS052 |
   | 1LS053 |
   | 1LS054 |
   | 1LS055 |
   | 1LS056 |
   | 1LS057 |
   | 1LS058 |
   | 1LS059 |
   | 1LS060 |
   | 1LS061 |
   | 1LS062 |
   | 1LS063 |
   | 1LS064 |
   | 1LS065 |
   | 1LS066 |
   | 1LS067 |
   | 1LS068 |
   | 1LS069 |
   | 1LS070 |
   | 1LS071 |
   | 1LS072 |
   | 1LS073 |
   | 1LS074 |
   | 1LS075 |
   | 1LS076 |
   | 1LS077 |
   | 1LS078 |
   | 1LS079 |
   | 1LS080 |
   | 1LS081 |
   | 1LS082 |
   | 1LS083 |
   | 1LS084 |
   | 1LS085 |
   | 1LS086 |
   | 1LS087 |
   | 1LS088 |
   | 1LS089 |
   | 1LS090 |
   | 1LS091 |
   | 1LS092 |
   | 1LS093 |
   | 1LS094 |
   | 1LS095 |
   | 1LS096 |
   | 1LS097 |
   | 1LS098 |
   | 1LS099 |
   | 1LS100 |

Scenario: Sammel-Ruecklieferschein anlegen

Given I open an editor "1RLS001" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to "+1LS001"
And I set field "beleg" to "+1LS002"
And I set field "beleg" to "+1LS003"
And I set field "beleg" to "+1LS004"
And I set field "beleg" to "+1LS005"
And I set field "beleg" to "+1LS006"
And I set field "beleg" to "+1LS007"
And I set field "beleg" to "+1LS008"
And I set field "beleg" to "+1LS009"
And I set field "beleg" to "+1LS010"
And I set field "beleg" to "+1LS011"
And I set field "beleg" to "+1LS012"
And I set field "beleg" to "+1LS013"
And I set field "beleg" to "+1LS014"
And I set field "beleg" to "+1LS015"
And I set field "beleg" to "+1LS016"
And I set field "beleg" to "+1LS017"
And I set field "beleg" to "+1LS018"
And I set field "beleg" to "+1LS019"
And I set field "beleg" to "+1LS020"
And I set field "beleg" to "+1LS021"
And I set field "beleg" to "+1LS022"
And I set field "beleg" to "+1LS023"
And I set field "beleg" to "+1LS024"
And I set field "beleg" to "+1LS025"
And I set field "beleg" to "+1LS026"
And I set field "beleg" to "+1LS027"
And I set field "beleg" to "+1LS028"
And I set field "beleg" to "+1LS029"
And I set field "beleg" to "+1LS030"
And I set field "beleg" to "+1LS031"
And I set field "beleg" to "+1LS032"
And I set field "beleg" to "+1LS033"
And I set field "beleg" to "+1LS034"
And I set field "beleg" to "+1LS035"
And I set field "beleg" to "+1LS036"
And I set field "beleg" to "+1LS037"
And I set field "beleg" to "+1LS038"
And I set field "beleg" to "+1LS039"
And I set field "beleg" to "+1LS040"
And I set field "beleg" to "+1LS041"
And I set field "beleg" to "+1LS042"
And I set field "beleg" to "+1LS043"
And I set field "beleg" to "+1LS044"
And I set field "beleg" to "+1LS045"
And I set field "beleg" to "+1LS046"
And I set field "beleg" to "+1LS047"
And I set field "beleg" to "+1LS048"
And I set field "beleg" to "+1LS049"
And I set field "beleg" to "+1LS050"
And I set field "beleg" to "+1LS051"
And I set field "beleg" to "+1LS052"
And I set field "beleg" to "+1LS053"
And I set field "beleg" to "+1LS054"
And I set field "beleg" to "+1LS055"
And I set field "beleg" to "+1LS056"
And I set field "beleg" to "+1LS057"
And I set field "beleg" to "+1LS058"
And I set field "beleg" to "+1LS059"
And I set field "beleg" to "+1LS060"
And I set field "beleg" to "+1LS061"
And I set field "beleg" to "+1LS062"
And I set field "beleg" to "+1LS063"
And I set field "beleg" to "+1LS064"
And I set field "beleg" to "+1LS065"
And I set field "beleg" to "+1LS066"
And I set field "beleg" to "+1LS067"
And I set field "beleg" to "+1LS068"
And I set field "beleg" to "+1LS069"
And I set field "beleg" to "+1LS070"
And I set field "beleg" to "+1LS071"
And I set field "beleg" to "+1LS072"
And I set field "beleg" to "+1LS073"
And I set field "beleg" to "+1LS074"
And I set field "beleg" to "+1LS075"
And I set field "beleg" to "+1LS076"
And I set field "beleg" to "+1LS077"
And I set field "beleg" to "+1LS078"
And I set field "beleg" to "+1LS079"
And I set field "beleg" to "+1LS080"
And I set field "beleg" to "+1LS081"
And I set field "beleg" to "+1LS082"
And I set field "beleg" to "+1LS083"
And I set field "beleg" to "+1LS084"
And I set field "beleg" to "+1LS085"
And I set field "beleg" to "+1LS086"
And I set field "beleg" to "+1LS087"
And I set field "beleg" to "+1LS088"
And I set field "beleg" to "+1LS089"
And I set field "beleg" to "+1LS090"
And I set field "beleg" to "+1LS091"
And I set field "beleg" to "+1LS092"
And I set field "beleg" to "+1LS093"
And I set field "beleg" to "+1LS094"
And I set field "beleg" to "+1LS095"
And I set field "beleg" to "+1LS096"
And I set field "beleg" to "+1LS097"
And I set field "beleg" to "+1LS098"
And I set field "beleg" to "+1LS099"
And I set field "beleg" to "+1LS100"
And I set field "mge" to "-20" in row 1
And I set field "mge" to "-20" in row 3
And I set field "mge" to "-20" in row 5
And I set field "mge" to "-20" in row 7
And I set field "mge" to "-20" in row 9
And I set field "mge" to "-20" in row 11
And I set field "mge" to "-20" in row 13
And I set field "mge" to "-20" in row 15
And I set field "mge" to "-20" in row 17
And I set field "mge" to "-20" in row 19
And I set field "mge" to "-20" in row 21
And I set field "mge" to "-20" in row 23
And I set field "mge" to "-20" in row 25
And I set field "mge" to "-20" in row 27
And I set field "mge" to "-20" in row 29
And I set field "mge" to "-20" in row 31
And I set field "mge" to "-20" in row 33
And I set field "mge" to "-20" in row 35
And I set field "mge" to "-20" in row 37
And I set field "mge" to "-20" in row 39
And I set field "mge" to "-20" in row 41
And I set field "mge" to "-20" in row 43
And I set field "mge" to "-20" in row 45
And I set field "mge" to "-20" in row 47
And I set field "mge" to "-20" in row 49
And I set field "mge" to "-20" in row 51
And I set field "mge" to "-20" in row 53
And I set field "mge" to "-20" in row 55
And I set field "mge" to "-20" in row 57
And I set field "mge" to "-20" in row 59
And I set field "mge" to "-20" in row 61
And I set field "mge" to "-20" in row 63
And I set field "mge" to "-20" in row 65
And I set field "mge" to "-20" in row 67
And I set field "mge" to "-20" in row 69
And I set field "mge" to "-20" in row 71
And I set field "mge" to "-20" in row 73
And I set field "mge" to "-20" in row 75
And I set field "mge" to "-20" in row 77
And I set field "mge" to "-20" in row 79
And I set field "mge" to "-20" in row 81
And I set field "mge" to "-20" in row 83
And I set field "mge" to "-20" in row 85
And I set field "mge" to "-20" in row 87
And I set field "mge" to "-20" in row 89
And I set field "mge" to "-20" in row 91
And I set field "mge" to "-20" in row 93
And I set field "mge" to "-20" in row 95
And I set field "mge" to "-20" in row 97
And I set field "mge" to "-20" in row 99
And I set field "mge" to "-20" in row 101
And I set field "mge" to "-20" in row 103
And I set field "mge" to "-20" in row 105
And I set field "mge" to "-20" in row 107
And I set field "mge" to "-20" in row 109
And I set field "mge" to "-20" in row 111
And I set field "mge" to "-20" in row 113
And I set field "mge" to "-20" in row 115
And I set field "mge" to "-20" in row 117
And I set field "mge" to "-20" in row 119
And I set field "mge" to "-20" in row 121
And I set field "mge" to "-20" in row 123
And I set field "mge" to "-20" in row 125
And I set field "mge" to "-20" in row 127
And I set field "mge" to "-20" in row 129
And I set field "mge" to "-20" in row 131
And I set field "mge" to "-20" in row 133
And I set field "mge" to "-20" in row 135
And I set field "mge" to "-20" in row 137
And I set field "mge" to "-20" in row 139
And I set field "mge" to "-20" in row 141
And I set field "mge" to "-20" in row 143
And I set field "mge" to "-20" in row 145
And I set field "mge" to "-20" in row 147
And I set field "mge" to "-20" in row 149
And I set field "mge" to "-20" in row 151
And I set field "mge" to "-20" in row 153
And I set field "mge" to "-20" in row 155
And I set field "mge" to "-20" in row 157
And I set field "mge" to "-20" in row 159
And I set field "mge" to "-20" in row 161
And I set field "mge" to "-20" in row 163
And I set field "mge" to "-20" in row 165
And I set field "mge" to "-20" in row 167
And I set field "mge" to "-20" in row 169
And I set field "mge" to "-20" in row 171
And I set field "mge" to "-20" in row 173
And I set field "mge" to "-20" in row 175
And I set field "mge" to "-20" in row 177
And I set field "mge" to "-20" in row 179
And I set field "mge" to "-20" in row 181
And I set field "mge" to "-20" in row 183
And I set field "mge" to "-20" in row 185
And I set field "mge" to "-20" in row 187
And I set field "mge" to "-20" in row 189
And I set field "mge" to "-20" in row 191
And I set field "mge" to "-20" in row 193
And I set field "mge" to "-20" in row 195
And I set field "mge" to "-20" in row 197
And I set field "mge" to "-20" in row 199
And I set field "num4" to "1RLS001"
And I set field "vom" to "."
And I save the current editor
