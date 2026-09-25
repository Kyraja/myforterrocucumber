# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
# run-stand-alone #@persistent
# run-stand-alone #Feature: BW2-1520 Kostenumlage rückführen basis1 
# run-stand-alone #Background:
# run-stand-alone #Given I set the fake date to "12.01.2002"

# ---------------------------------------------------------------------------------------------
# Kopie aus basis0 nur zum schnelleren lesezugriff, pflege in basis0!
#  schaffen einer weiterverwendbaren schematischen bewegungsdatenbasis
# ------------------------------------------------------------------------
#
# die anzahl zuordnungen/zeile ergibt die anzahl tabellenzeilen
# in der km
#
# die anzahl zuordnungen/spalte ergibt die mehrfachbelegung von 
# zugängen mit km
#
# nicht vorhandene zuordnung bedeutet: derzeit keine verwendung von
# zeilen oder spalten
#
# ----------------|------------------------------------------------------
#                 | Zielposition auf die die kostenquelle umgelegt wird:
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
#                 | 11| 15| 2 | 3 | 4 | 5 | 6 | 7 | 8 |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kostenquelle:   |   |   |   |   |   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_11   |100|   |   |   |   |   |   |100|   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_15   |   |150|   |   |   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_2_12 |   |   |   |200|   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_3    |400|   |400|   |400|400|   |   |   |           400 = U4-4ZEI
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_4    |   |   |300|300|   |   |   |   |   |           300 = U3-2ZEI
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_5_12 |   |   |500|500|   |   |500|   |   |           500 = U5-3ZEI-12
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_6    |   |   |   |   |   |   |   |   |600|           600 = U6-NEG (-)           
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
#
# in KM 200: identische guv konten und kostenobjekte, damit ohne umbuchung 
#                                                           ~~~~~~~~~~~~~~
#            in der km und der rückführung erlaubt!
#
# in KM 500: identische guv konto und kostenobjekt mit zielpos3, 
#            deshalb nur teilweise umbuchung in der km und der rückführung!
#                        ~~~~~~~~~~~~~~~~~~~
# ---------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------
Scenario: Kostenumlagen erzeugen
# ------------------------------------------------------------------------
# Given I'm logged in with password "sy"
Given I set the fake date to "12.01.2002"

Given I open an editor "kostenuml-11" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "110" 
And I set field "such" to "U11-2ZEI" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;@ablageart=(Filed)"
# addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_11"
# addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos7;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor

# Kostenumlagen erzeugen
Given I open an editor "kostenuml-15" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "150" 
And I set field "such" to "U15-1ZEI" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_15;art==transport;@ablageart=(Filed)"
# addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_15"
# addk-aus-FIBU #And I set field "umlagebuzeile" to "2"
# mit-mkv #And I set field "fibuumbuch" to "ja"
# ohne-mkv #And I set field "fibuumbuch" to "nein"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor


# Kostenumlagen erzeugen
Given I open an editor "kostenuml-2" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "200" 
And I set field "such" to "U2-1ZEI-12" 
And I set field "name" to "übereinst.d.kont. keine umbuchung"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_2_12;art==transport;@ablageart=(Filed)"
# addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_2_12"
# addk-aus-FIBU #And I set field "umlagebuzeile" to "3"
And I set field "fibuumbuch" to "nein"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos3;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor


# Kostenumlagen erzeugen
# kopierquelle : std/test/cucumber/kostenumlage/ref_km_rueck_basis1.template.feature
Given I open an editor "kostenuml-3" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "300" 
And I set field "such" to "U3-2ZEI" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_4;art==transport;@ablageart=(Filed)"
# addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_4"
# addk-aus-FIBU #And I set field "umlagebuzeile" to "2"

And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos2;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I set field "proz" to "40" in row !lastRow

And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos3;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I set field "proz" to "60" in row !lastRow

# ohne-mkv ##  mit fibuumbuch=nein wird eine ADM.FEHL erzeugt. in der GUI aber nicht. warum ist unklar.
# ohne-mkv ##  die meldung ist ungefähr so: EFOP Maskenaustritt an dieser Stelle nicht erlaubt.
# ohne-mkv ##  siehe dazu https://jira.abasag.intra/browse/CUCU-190 (on premis jira bis 2021)
# ohne-mkv ##  und https://jira.abasag.intra/browse/BW2-1391 (on premis jira bis 2021)
# ohne-mkv ## mit fibuumbuch = nein und ohne respond 2911 (früher 9425) kam es zu einer ADM.FEHL  
# ohne-mkv #And I set field "fibuumbuch" to "nein"
# ohne-mkv #And I respond with answer "Nein" to the dialog with id "2911"

# mit-mkv #And I set field "fibuumbuch" to "nein"
# mit-mkv ## 8878 de      |Abweichende Konten in Kopf und Tabelle der Kostenumlage. Umbuchung durchfhren.
# mit-mkv #And saving the current editor throws the exception "8878"
# mit-mkv #And I set field "fibuumbuch" to "ja"
And I save the current editor


# Kostenumlagen erzeugen
Given I open an editor "kostenuml-4" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "400" 
And I set field "such" to "U4-4ZEI" 
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_3;art==transport;@ablageart=(Filed)"
# addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_3"
# addk-aus-FIBU #And I set field "umlagebuzeile" to "4"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"

And I append rows
 | pos                                                         |proz|
 |$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed) | 10 |
 |$,,ptext==kmzpos2;@gruppe=2;@datenbank=4;@ablageart=(Filed)  | 20 |
 |$,,ptext==kmzpos4;@gruppe=2;@datenbank=4;@ablageart=(Filed)  | 30 |
 |$,,ptext==kmzpos5;@gruppe=2;@datenbank=4;@ablageart=(Filed)  | 40 |
And I save the current editor


# quellpos:              zielpos:
#
#                      __(kmzpos2)          
#                     /     
# kost_qu_ek_5_12-> KM___(kmzpos3)
#                     \  
#                      \_(kmzpos6)---- MN   

# Kostenumlagen erzeugen
Given I open an editor "kostenuml-5" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "500" 
And I set field "such" to "U5-3ZEI-12"
And I set field "name" to "teilübereinst.d.kont. teilumbuchung"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_5_12;art==transport;@ablageart=(Filed)"
# addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_5_12"
# addk-aus-FIBU #And I set field "umlagebuzeile" to "3"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Gewicht"

And I append rows
 | pos                                                        |proz|
 |$,,ptext==kmzpos2;@gruppe=2;@datenbank=4;@ablageart=(Filed) | 50 |
 |$,,ptext==kmzpos3;@gruppe=2;@datenbank=4;@ablageart=(Filed) | 20 |
 |$,,ptext==kmzpos6;@gruppe=2;@datenbank=4;@ablageart=(Filed) | 30 |
And I save the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# -- mn --
Given I open an editor "mnb-von-kmzpos6" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "NBzpos6"
And I set field "nummer" to "6444"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,buart=1;artikel==E1EI-VO;mge==60;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "2" in row 1
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ------------------------------------------------------------------------
Scenario: negative Kostenumlage erzeugen
# ------------------------------------------------------------------------
Given I set the fake date to "13.01.2002"

# quellpos:              zielpos:
#
# kost_qu_ek_6-> KM___(kmzpos8)

# Kostenumlagen erzeugen
Given I open an editor "kostenuml-6" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "600" 
And I set field "such" to "U6-NEG"
And I set field "name" to "test fuer negative Kostenumlage"
# addk-aus-ek #And I set field "pos" to "$,,ptext==kost_qu_ek_6;art==transport;@ablageart=(Filed)"
# addk-aus-FIBU #And I set field "umlagebuchung" to "$,,ptext==kost_qu_ek_6"
# addk-aus-FIBU #And I set field "umlagebuzeile" to "4"
And I set field "fibuumbuch" to "ja"

And I append rows
 | pos                                                        |proz|
 |$,,ptext==kmzpos8;@gruppe=2;@datenbank=4;@ablageart=(Filed) |100 |
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ------------------------------------------------------------------------
Scenario: Reservefelder anlegen
# ------------------------------------------------------------------------

Given I set the fake date to "13.01.2002"

# ...........
Given I open an editor "resfeld-vartab" from table "(Company):(Vartab)" with command "UPDATE" for record "V-135-03"
And I press button "vresein"
# hier der ersatz/ die abhilfe für !currentRow
And I set field "vname" to "kmyreskopfgl" in rowspec "$,,vname==`"
And I set field "vitf" to "GL" in rowspec "$,,vname==kmyreskopfgl"

And I press button "vtresein"
# hier der ersatz/ die abhilfe für !currentRow
And I set field "vname" to "kmyrestabip2" in rowspec "$,,vname==`"
And I set field "vitf" to "IP2" in rowspec "$,,vname==kmyrestabip2"

And I respond with answer "Ja" to the dialog with id "Variablentabelle"
And I save the current editor

# ...........
# diese variable wird zur zeit nur hier mit hinzugefügt, aber nicht aktiv befüllt.
# dafür wäre ein AP notwendig, mit dem direkt aus dem kostenumlagekopf in die 
# 1. buchungszeile kopiert wird. so einen gibt es derzeit nicht. aber falls doch 
# einmal wäre das feld hier schon da.
Given I open an editor "resfeld-buchung" from table "(Company):(Vartab)" with command "UPDATE" for record "V-06-00"
And I press button "vresein"
# hier der ersatz/ die abhilfe für !currentRow
And I set field "vname" to "kmyreskopfgl" in rowspec "$,,vname==`"
And I set field "vitf" to "GL" in rowspec "$,,vname==kmyreskopfgl"

And I press button "vtresein"
# hier der ersatz/ die abhilfe für !currentRow
And I set field "vname" to "kmyrestabip2" in rowspec "$,,vname==`"
And I set field "vitf" to "IP2" in rowspec "$,,vname==kmyrestabip2"

And I create a new row at the end of the table
# hier der ersatz/ die abhilfe für !currentRow
And I set field "vname" to "kmyreskopftabgl" in rowspec "$,,vname==`"
And I set field "vitf" to "GL" in rowspec "$,,vname==kmyreskopftabgl"

And I respond with answer "Ja" to the dialog with id "Variablentabelle"
And I save the current editor

# ...........
Given I open an editor "resfeld-buj" from table "(Company):(Vartab)" with command "UPDATE" for record "V-131-00"
And I press button "vresein"
# hier der ersatz/ die abhilfe für !currentRow
And I set field "vname" to "kmyreskopfgl" in rowspec "$,,vname==`"
And I set field "vitf" to "GL" in rowspec "$,,vname==kmyreskopfgl"

And I press button "vtresein"
# hier der ersatz/ die abhilfe für !currentRow
And I set field "vname" to "kmyrestabip2" in rowspec "$,,vname==`"
And I set field "vitf" to "IP2" in rowspec "$,,vname==kmyrestabip2"

# diese variable wird zur zeit nur hier mit hinzugefügt, aber nicht aktiv befüllt.
# dafür wäre ein AP notwendig, mit dem direkt aus dem kostenumlagekopf in die 
# 1. buchungszeile kopiert wird. so einen gibt es derzeit nicht. aber falls doch 
# einmal wäre das feld hier schon da.
And I create a new row at the end of the table
# hier der ersatz/ die abhilfe für !currentRow
And I set field "vname" to "kmyreskopftabgl" in rowspec "$,,vname==`"
And I set field "vitf" to "GL" in rowspec "$,,vname==kmyreskopftabgl"

And I respond with answer "Ja" to the dialog with id "Variablentabelle"
And I save the current editor
