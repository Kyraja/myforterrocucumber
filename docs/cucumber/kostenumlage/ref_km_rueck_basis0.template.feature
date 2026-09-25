# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: BW2-1520 Kostenumlage rückführen 

Background:
Given I set the fake date to "10.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: schaffen einer weiterverwendbaren schematischen bewegungsdatenbasis
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
Given I'm logged in with password "sy"
Given I set the fake date to "10.01.2002"

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1EI-VO"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1LO-VO"
And I set field "gemein" to ""
And I save the current editor

# addk-aus-ek ## Zusatzposition Transport
# addk-aus-ek #Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
# addk-aus-ek #And I set field "nummer" to "1transp"
# addk-aus-ek #And I set field "such" to "transport"
# addk-aus-ek #And I set field "name" to "transportkosten"
# addk-aus-ek #And I save the current editor

# addk-aus-ek ## Rechnung für add. kosten anlegen
# addk-aus-ek #Given I open an editor "re-addkosten1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "134-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "gbp"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext         | 
# addk-aus-ek # |transport |     6| 50011 |     111 | kost_qu_ek_11 |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

# addk-aus-FIBU ## --- km-fähige fibu-buchung -----
# addk-aus-FIBU #Given I open an editor "buchung_1km_faehige_bilanzzeile" from table "(Entry):(Entry)" with command "NEW" for record ""
# addk-aus-FIBU #And I set field "such" to "b134-add"
# addk-aus-FIBU #And I set field "erfwaehr" to "gbp"
# addk-aus-FIBU #And I set field "budat" to "10.01.2002"
# addk-aus-FIBU #And I set field "text" to "qu:z2:11"
# addk-aus-FIBU #And I append rows
# addk-aus-FIBU # | konto | kstelle   |ewsbetr| ptext         | 
# addk-aus-FIBU # | 10000 |!dontChange|       |               |
# addk-aus-FIBU # | 50011 |     111   |     6 | kost_qu_ek_11 |
# addk-aus-FIBU #And I respond with answer "Ja" to the dialog with id "1941"
# addk-aus-FIBU #And I save the current editor

# Rechnung für add. kosten anlegen
# addk-aus-ek #Given I open an editor "re-addkosten2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "135-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          | 
# addk-aus-ek # |transport |    10| 50011 |     111 | kost_qu_ek_15  |
# addk-aus-ek # |transport |    20| 50012 |     112 | kost_qu_ek_2_12|
# addk-aus-ek # |transport |    30| 50013 |     113 | kost_qu_ek_3   |
# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

# addk-aus-FIBU ## --- km-fähige fibu-buchung -----
# addk-aus-FIBU #Given I open an editor "buchung_2km_faehige_bilanzzeile" from table "(Entry):(Entry)" with command "NEW" for record ""
# addk-aus-FIBU #And I set field "such" to "b135-add"
# addk-aus-FIBU #And I set field "budat" to "10.01.2002"
# addk-aus-FIBU #And I set field "text" to "qu:z2:15,z3:2_12,z4:3"
# addk-aus-FIBU #And I append rows
# addk-aus-FIBU # | konto | kstelle   |ewsbetr| ptext        | 
# addk-aus-FIBU # | 10000 |!dontChange|       |              |
# addk-aus-FIBU # | 50011 |     111   |    10 | kost_qu_ek_15 |
# addk-aus-FIBU # | 50012 |     112   |    20 | kost_qu_ek_2_12 |
# addk-aus-FIBU # | 50013 |     113   |    30 | kost_qu_ek_3 |
# addk-aus-FIBU #
# addk-aus-FIBU #And I respond with answer "Ja" to the dialog with id "1941"
# addk-aus-FIBU #And I save the current editor


Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15-2|
    | such4    | R11-15-2|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm	| ptext    | platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	| kmzpos11 |!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	| kmzpos15 |!dontChange|
# mit-mkv #    | E1EI-VO     | 20  | 20,00 | +4	| kmzpos2  |  L3F1     |

# ohne-mkv #   | artikel     | mge | preis | tterm	| ptext    | platz     | kstelle |
# ohne-mkv #   | E1EI-VO     | 10  | 10,00 | +4	| kmzpos11 |!dontChange|   110   |
# ohne-mkv #   | E1EI-VO     | 15  | 15,00 | +4	| kmzpos15 |!dontChange|   111   |
# ohne-mkv #   | E1EI-VO     | 20  | 20,00 | +4	| kmzpos2  |  L3F1     |   112   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Rechnung_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
 | lief     | 1   |
 | num4     | 3-4 |
 | such4    | R3-4|
 | vom      | .      |
 | ueb      | ja     |
 | ebeleg   | MATRE1 |
 | budat    | .      |
And I append rows
 | artikel |  lffert   |mge | preis | tterm	| ptext   | konto     | kstelle   |
 | E1LO-VO | EFLO-VO   | 30 | 30,00 | +4	| kmzpos3 | 50012     |    112    |
# mit-mkv # | E1EI-VO |!dontChange| 40 | 40,00 | +4	| kmzpos4 |!dontChange|!dontChange|
# ohne-mkv # | E1EI-VO |!dontChange| 40 | 40,00 | +4	| kmzpos4 |!dontChange|    118    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Rechnung_02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1     |
    | num4     | 5-6-7 |
    | such4    | R5-6-7|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I append rows
# mit-mkv #    | artikel     | mge | preis | tterm	| ptext   |
# mit-mkv #    | E1EI-VO     | 50  | 50,00 | +4	| kmzpos5 |
# mit-mkv #    | E1EI-VO     | 60  | 60,00 | +4	| kmzpos6 |
# mit-mkv #    | E1EI-VO     | 70  | 70,00 | +4	| kmzpos7 |
# mit-mkv #    | E2FR-VF     | 80  | 80,00 | +4	| kmzpos8 |

# ohne-mkv #    | artikel     | mge | preis | tterm	| ptext   | kstelle |
# ohne-mkv #    | E1EI-VO     | 50  | 50,00 | +4	| kmzpos5 |   114   |
# ohne-mkv #    | E1EI-VO     | 60  | 60,00 | +4	| kmzpos6 |   115   |
# ohne-mkv #    | E1EI-VO     | 70  | 70,00 | +4	| kmzpos7 |   116   |
# ohne-mkv #    | E2FR-VF     | 80  | 80,00 | +4	| kmzpos8 |   116   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# *********************************************************************************************
#  diesen Block 136-add hier stehen lassen, damit diese kostenquelle unter die kostenempfänger 
#  gemischt wird und einer satznummer dazwischen bekommt. so wird im nachfolgenden 
#  aufräumtest das aufräumen auch für die leerung der felder kepos und kekopf getestet 
#  (zumindest durchlaufen).
# *********************************************************************************************
# addk-aus-ek ## Rechnung für add. kosten anlegen
# addk-aus-ek #Given I open an editor "re-addkosten3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# addk-aus-ek #And I set field "num4" to "136-add"
# addk-aus-ek #And I set field "lief" to "1"
# addk-aus-ek #And I set field "erfwaehr" to "eur"
# addk-aus-ek #And I set field "vom" to "."
# addk-aus-ek #And I set field "ueb" to "ja"
# addk-aus-ek #And I append rows
# addk-aus-ek # |artex     | pwert| konto | kstelle | ptext          | 
# addk-aus-ek # |transport |    40| 50014 |     114 | kost_qu_ek_4   |
# addk-aus-ek # |transport |    50| 50012 |     112 | kost_qu_ek_5_12|
# addk-aus-ek # |transport |   -32| 50016 |     113 | kost_qu_ek_6   |

# addk-aus-ek ## 16er-hinweis:
# addk-aus-ek ## diese -32 landen mit dem guv-konto letztlich im haben
# addk-aus-ek ## deshalb auch unten in der entspr. fibu-zeile die 32 im haben
# addk-aus-ek ## und die kstelle darf nicht 116 sein, weil sonst quell- u.
# addk-aus-ek ## ziel-kstelle identisch werden wodurch keine umbuchung gemacht wird. 

# addk-aus-ek #And I respond with answer "Ja" to the dialog with id "4841"
# addk-aus-ek #And I save the current editor

# addk-aus-FIBU ## --- km-fähige fibu-buchung -----
# addk-aus-FIBU #Given I open an editor "buchung_3km_faehige_bilanzzeile" from table "(Entry):(Entry)" with command "NEW" for record ""
# addk-aus-FIBU #And I set field "such" to "b136-add"
# addk-aus-FIBU #And I set field "budat" to "10.01.2002"
# addk-aus-FIBU #And I set field "text" to "qu:z2:4,z3:5_12,z4:6"
# addk-aus-FIBU #And I append rows
# addk-aus-FIBU # | konto | kstelle   |ewsbetr|ewhbetr| ptext            | 
# addk-aus-FIBU # | 10000 |!dontChange|       |       |                  |
# addk-aus-FIBU # | 50014 |     114   |    40 |       |  kost_qu_ek_4    |
# addk-aus-FIBU # | 50012 |     112   |    50 |       |  kost_qu_ek_5_12 |
# addk-aus-FIBU # | 50016 |     113   |       |   32  |  kost_qu_ek_6    |
# addk-aus-FIBU ##      siehe oben 32er-hinweis

# addk-aus-FIBU #And I respond with answer "Ja" to the dialog with id "1941"
# addk-aus-FIBU #And I save the current editor

# ------------------------------------------------------------------------
Scenario: Manuelle Abgänge der Zugänge und darüber hinaus (ohne bestand)
# ------------------------------------------------------------------------

Given I set the fake date to "11.01.2002"

Given I open an editor "LbuchAb" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "E1EI-VO"
And I set field "beleg" to "allesweg"
And I set field "beldat" to "."
And I set field "buart" to "Abgang"

And I set field "mge" to "100" in row !lastRow
And I set field "platz" to "F2" in row !lastRow

And I create a new row at the end of the table
And I set field "mge" to "180" in row !lastRow
And I set field "platz" to "F2" in row !lastRow

And I save the current editor

Given I open an editor "LbuchAb" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "E1LO-VO"
And I set field "beleg" to "loweg"
And I set field "beldat" to "."
And I set field "buart" to "Abgang"
And I set field "lffert" to "EFLO-VO"

And I set field "mge" to "30" in row !lastRow
And I set field "platz" to "F1" in row !lastRow

And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Artikel umlagern mit Kosten (Umlagerung) plus in folgetests additive Kosten zusätzlich
# ----------------------------------------------------------------------------------------------
Given I set the fake date to "11.01.2002"

Given I open an editor "LSzuUml" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer   | 50umlls    |
    | bsart    | Umlagern   |
    | lief     | 1          |
    | vom      | .          |
    | ebeleg   | Umlagern50 |
    | ueb      | ja         |
    | erfwaehr | EUR        |
And I append rows
    | artikel   | mge | abplatz | platz |
    | E1EI-VO   | 20  | L3F1    |  F2   |
And I save the current editor

# Transportkosten bezahlen: ergibt additive kosten in der Zugangsbewertung
Given I open an editor "RechnungmLUm" from table "(Purchasing):(Invoice)" with command "NEW" for record from editor "LSzuUml"
And I set fields
    | nummer   | 50uml      |
    | vom      | .          |
    | ebeleg   | Umlagern50 |
    | ueb      | ja         |
    | erfwaehr | EUR        |
And I press button "offueb" in row 1
And I set field " preis" to "1.00" in row 1
# ohne-mkv #And I set field "kstelle" to "117" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
