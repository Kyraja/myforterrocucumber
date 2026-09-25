# *****************************************************************************
#    Name      : kasb_zn_sperrpruef.feature               
#    Autor     : Jan Effler                                                    
#    Verantwortlich : hc                                                       
#    Kontrolle:                                                                
#                                                                              
#     Funktion : Test der Konten- und Kostenobjektsperre in Kassenbuchzeilen mit Bezug auf OP:
#                   1) Vorbelegung des Feldes (kc)skontosperredeakt in der Kassenbuchzeile
#                   2) Sperre der OP-relevanten Konten und Kostenobjekte in der Kassenbuchzeile
#
#
#      Objekte: 
#               -Konten
#                   --47365     : Standard-Skontokonto der erwarteten Steuerregel (bereits vorhanden)
#                   --47365k    : Skontokonto fuer Feld skonto2 - nicht gesperrt - Kopie von 47365
#                   --47365sk   : gesperrtes Skontokonto - Kopie von 47365
#               -Kostenobjekte
#                   --110ks     : Kostenstelle
#                   --110sks    : gesperrte Kostenstelle
#                   --111kt     : Kostentraeger
#                   --111skt    : gesperrter Kostentraeger
#                   --210skv    : gesperrter Kostenverteiler
#                   --210kvsks  : Kostenverteiler - enthaelt gesperrte Kostenstelle
#                   --210kvskt  : Kostenverteiler - enthaelt gesperrten Kostentraeger
#                       
#
# *****************************************************************************

@persistent

Feature:  kasb_zn_sperrpruef  
Background: Kassenbuch, Sperren

# ---------------------------------------------------------------------------------------------
Scenario Outline: Kostenstelle und Kostentraeger anlegen
# ---------------------------------------------------------------------------------------------

Given I open an editor "<editor>" from table "(Account):(<datei>)" with command "<command>" for record "<record>"
And I set field "nummer" to "<nummer>"
And I set field "such" to "<such>"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Examples:

|example|editor|     datei|command|record|nummer|  such|
|      1|    ks|CostCenter|    NEW|      |110sks| KS110|
|      2|   ksc|CostCenter|   COPY|110sks| 110ks|KSC110|
|      3|    kt|CostObject|    NEW|      |111skt| KT111|
|      4|   ktc|CostObject|   COPY|111skt| 111kt|KTC111|

# ---------------------------------------------------------------------------------------------
Scenario: Kostenverteiler anlegen
# ---------------------------------------------------------------------------------------------

Given I open an editor "kv" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "210skv"
And I set field "such" to "SKV11"
And I set field "sperrkonfigurationneu" to ""
And I create a new row at the end of the table
And I set field "kstelle" to "111kt" in row 1
And I set field "proz" to "70" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "110ks" in row 2
And I set field "proz" to "30" in row 2
And I save the current editor
And I close the current editor

Given I open an editor "kv" from table "(Account):(CostDistribution)" with command "COPY" for record "210skv"
And I set field "nummer" to "210kvsks"
And I set field "such" to "SKVKS11"
And I set field "kstelle" to "110sks" in row 2
And I save the current editor
And I close the current editor

Given I open an editor "kv" from table "(Account):(CostDistribution)" with command "COPY" for record "210skv"
And I set field "nummer" to "210kvskt"
And I set field "such" to "SKVKT11"
And I set field "kstelle" to "111skt" in row 1
And I save the current editor
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Skontokonto aus Steuerregel kopieren
# ---------------------------------------------------------------------------------------------

Given I open an editor "steuerregel" from table "(TaxCode):(TaxRule)" with command "VIEW" for record "VKIN"
And I close the current editor

# sperrbares Skontokonto
Given I open an editor "skontokonto" via ID from editor "steuerregel" from field "skkto" in row 1 for table "(Account):(Account)" with command "COPY"
And I set field "nummer" to "47365sk"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

# Nutzung als nicht gesperrtes zweites Skontokonto (damit s2kstelle in der Kassenbuchzeile beschreibbar ist)
Given I open an editor "skontokonto2" from table "(Account):(Account)" with command "COPY" for record "47365sk"
And I set field "nummer" to "47365k"
And I save the current editor
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario Outline: OPs erzeugen
# ---------------------------------------------------------------------------------------------

Given I open an editor "<editor>" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "vom" to "01.01.22"
And I set field "budat" to "01.01.22"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "10" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "psteuer" has value "1" in row 1
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Examples:

|example|  editor|
|      1| VKRech1|
|      2| VKRech2|
|      3| VKRech3|
|      4| VKRech4|
|      5| VKRech5|
|      6| VKRech6|
|      7| VKRech7|
|      8| VKRech8|
|      9| VKRech9|
|     10|VKRech10|

# ---------------------------------------------------------------------------------------------
Scenario Outline: OPs in Kassenbuchzeile laden -> Startzustand pruefen (Vorbelegung aus Steuerregel)
# ---------------------------------------------------------------------------------------------

Given I open an editor "kasb" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16000"
And I create a new row at the end of the table
And I set field "beldat" to "01.01.22" in row 1
Then field "budat" in row 1 has value equal to field "beldat" from editor "kasb" in row 1
Then field "op" is modifiable in row 1
And I set field "op" to "ophist^op" from editor "<rechnung>" in row 1
Then table has values
|!row| skonto|skonto2|skstelle|s2kstelle|skontosperredeakt|skonto^sperrkonfigurationneu|
|   1|  47365|       |        |         |             nein|                            |
And I close the current editor

Examples:

|example|rechnung|
|      1| VKRech1|
|      2| VKRech2|
|      3| VKRech3|
|      4| VKRech4|
|      5| VKRech5|
|      6| VKRech6|
|      7| VKRech7|
|      8| VKRech8|
|      9| VKRech9|
|     10|VKRech10|

# ---------------------------------------------------------------------------------------------
Scenario Outline: sperrbare Kostenobjekte/Skontokonto in OP(s) einpflegen
# ---------------------------------------------------------------------------------------------

Given I open an editor "<editor>" from table "(OIProcessing):(MaintainOutstandingItems)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "ophist" to "ophist^op" from editor "<rechnung>" in row 1
Then field "skonto2" has value "<origsk2val>" in row 1
And I set field "skonto2" to "<skonto2>" in row 1
Then field "<field>" has value "<origval>" in row 1
And I set field "<field>" to "<kobj>" in row 1
# 588 : Sind Sie sicher?
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
And I close the current editor

Examples:

|example|   editor|rechnung|    field|     kobj|origval|origsk2val|skonto2|
|      1|  oppflsk| VKRech1|   skonto|  47365sk|  47365|          |       |
|      2|  oppflks| VKRech2| skstelle|   110sks|       |          |       |
|      3|  oppflkt| VKRech3| skstelle|   111skt|       |          |       |
|      4|  oppflkv| VKRech4| skstelle|   210skv|       |          |       |
|      5|oppflkvks| VKRech5| skstelle| 210kvsks|       |          |       |
|      6|oppflkvkt| VKRech6|s2kstelle| 210kvskt|       |          | 47365k|
|      7| oppflsk2| VKRech7|   skonto|    47365|  47365|          |47365sk|
|      8| oppflks2| VKRech8|s2kstelle|   110sks|       |          | 47365k|
|      9| oppflkt2| VKRech9|s2kstelle|   111skt|       |          | 47365k|
|     10| oppflkv2|VKRech10|s2kstelle|   210skv|       |          | 47365k|


# ---------------------------------------------------------------------------------------------
Scenario Outline: Skontokonto und Kostenobjekte sperren
# ---------------------------------------------------------------------------------------------

Given I open an editor "skontoupd" from table "(Account):(<datei>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to "Standard-<type>sperre"
And I save the current editor
And I close the current editor

Examples:

|example|  editor|           datei| record|                 type|
|      1|skontupd|         Account|47365sk|                Konto|
|      2|   ksupd|      CostCenter| 110sks|        Kostenstellen|
|      3|   ktupd|      CostObject| 111skt|        Kostentraeger|
|      4|   kvupd|CostDistribution| 210skv| Stammkostenverteiler|

# ---------------------------------------------------------------------------------------------
Scenario Outline: OPs in Kassenbuchzeile laden -> Vorbelegung Bedingungsfeld und Fehlermeldung beim speichern testen
# ---------------------------------------------------------------------------------------------

Given I open an editor "<editor>" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16000"
And I create a new row at the end of the table
And I set field "beldat" to "01.01.22" in row 1
Then field "budat" in row 1 has value equal to field "beldat" from editor "<editor>" in row 1
Then field "op" is modifiable in row 1
And I set field "op" to "ophist^op" from editor "<rechnung>" in row 1
Then table has values
|!row|       skonto|       skonto2|  skstelle|  s2kstelle|skontosperredeakt|
|   1|<skontokonto>|<skontokonto2>|<skstelle>|<s2kstelle>|             nein|
Then saving the current editor throws the exception "<erronsave>"
# Bereits an dieser Stelle sollte die erste Fehlermeldung erscheinen.
# Sowohl im Mandanten als auch im epi-Log ist die Meldung zu finden.
# Cucumber scheint diese Meldung zu "verschlucken"
# Then pressing button "allefr" throws the exception "<erronfrgb>"
And I press button "allefr"
Then pressing button "bucheschl" in row 0 to open a subeditor throws the exception "<erronbuschl>"

Then field "skontosperredeakt" has value "nein" in row 1
Then saving the current editor throws the exception "<erronsave>"
Then field "tskbetr" is not empty in row 1
And I set field "tskbetr" to "0.00" in row 1
Then field "skontosperredeakt" has value "ja" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "<editor>tzahlb" via ID from editor "<editor>" from field "nummer" in row 0 for table "(CashBook):(CashBook)" with command "UPDATE"
And I set field "tskbetr" to "8.93" in row 1
Then field "skontosperredeakt" has value "nein" in row 1
Then saving the current editor throws the exception "<erronsave>"
Then field "tzahlbetr" is not empty in row 1
And I set field "beinn" to "0.00" in row 1
Then field "tzahlbetr" has value "0.00" in row 1
Then field "skontosperredeakt" has value "ja" in row 1
# 263 : Bitte Betraege vervollstaendigen
Then saving the current editor throws the exception "263"
And I set field "beinn" to "288.57" in row 1
Then field "tzahlbetr" has value "288.57" in row 1
Then field "skontosperredeakt" has value "nein" in row 1
Then saving the current editor throws the exception "<erronsave>"
Then field "isbestkorr" has value "nein" in row 1
And I set field "isbestkorr" to "ja" in row 1
Then field "skontosperredeakt" has value "ja" in row 1
#######################################################################################################################################################
# TODO TEMP Fehler: OP in der Kassenbuchzeile ==> OP wird immer ausgebucht, auch wenn isbestkorr aktiviert
#           Fehlerkorrektur s. REWE-3786 Kassenbestandskorrektur ohne Buchung und OP in Kassenbuchzeile sollen sich ausschliessen
Then saving the current editor throws the exception "<erronfrgb>"
And I set field "tskbetr" to "0" in row 1
# TEMP Abschnitt bildet das aktuelle Verhalten ab und ist notwendig um den Test beenden zu koennen => Abschnitt entfernen wenn das Issue geloest wurde
########################################################################################################################################################
And I save the current editor
And I close the current editor
 
Given I open an editor "<editor2>" via ID from editor "<editor>" from field "nummer" in row 0 for table "(CashBook):(CashBook)" with command "UPDATE"
Then field "buch" is empty in row 1
And I press button "allefr"
And I press button "bucheschl" to open a subeditor for ""
And I save the current subeditor to switch back to the parent editor
Then field "isbestkorr" has value "ja" in row 1
# TODO Fehlerhaftes Verhalten: Bei OP wird trotz isbestkorr eine Buchung erzeugt. Siehe REWE-3786
Then field "buch" is not empty in row 1
And I save the current editor
And I close the current editor

# 3852 : Zeile muss zuerst zur Buchung freigegeben werden
# 3602 : Kostenverteiler enthaelt gesperrte Objekte
# 4806 : Objekt ist gesperrt
# 6139 : Buchen nicht moeglich, gesperrtes Objekt beteiligt

Examples:

|example|editor| editor2|rechnung|skontokonto| skstelle|skontokonto2| s2kstelle|erronfrgb|erronbuschl|erronsave|
|      1| kasb1| buschl1| VKRech1|    47365sk|         |            |          |     6139|       4806|     4806|
|      2| kasb2| buschl2| VKRech2|      47365|   110sks|            |          |     6139|       4806|     4806|
|      3| kasb3| buschl3| VKRech3|      47365|   111skt|            |          |     6139|       4806|     4806|
|      4| kasb4| buschl4| VKRech4|      47365|   210skv|            |          |     6139|       4806|     4806|
|      5| kasb5| buschl5| VKRech5|      47365| 210kvsks|            |          |     3602|       3852|     3602|
|      6| kasb6| buschl6| VKRech6|      47365|         |      47365k|  210kvskt|     3602|       3852|     3602|
|      7| kasb7| buschl7| VKRech7|      47365|         |     47365sk|          |     6139|       4806|     4806|
|      8| kasb8| buschl8| VKRech8|      47365|         |      47365k|    110sks|     6139|       4806|     4806|
|      9| kasb9| buschl9| VKRech9|      47365|         |      47365k|    111skt|     6139|       4806|     4806|
|     10|kasb10|buschl10|VKRech10|      47365|         |      47365k|    210skv|     6139|       4806|     4806|
