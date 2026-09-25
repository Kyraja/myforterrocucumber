# *****************************************************************************
#  Name           : opendownpayments.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teaminfosysteme
#  Funktion       : Testet das IS OPENDOWNPAYMENTS auf Sonderfaelle
#                   Verantwortlich: Renate
#
# *****************************************************************************
@persistent
Feature: OPENDOWNPAYMENTS
Background:
Given I set the fake date to "02.01.1995"
# ---------------------------------------------------------------------------------------------
Scenario: Anzahlungskonto aufbereiten
# ---------------------------------------------------------------------------------------------
Given I open an editor "kontostammdaten" from table "(Account):(Account)" with command "UPDATE" for record "32700"
And I set field "ktostrgl" to "7000"
And I save the current editor
# ---------------------------------------------------------------------------------------------
Scenario: Auftrag 99001 erstellen mit Anzahlungsposition
# ---------------------------------------------------------------------------------------------
Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "STORE" for record "BTEST"
And I set field "nummer" to "99001"
And I set field "kunde" to "1"
And I set field "vom" to "."
And I set field "oterm" to "+30"
And I set field "budat" to "."
And I append rows
    | artex | mge         | preis       | tterm       | konto      | oterm       |
    | V1    | 1000        | 25          | +30         | !dontChange| !dontChange |
    | V2    | 1000        | 20          | !dontChange | !dontChange| +30         |
    | ANZ   | !dontChange | !dontChange | !dontChange | 32700      | +30         |
And I save the current editor
# ---------------------------------------------------------------------------------------------
Scenario: Anzahlungsrechnung aus Auftrag 99001 
# ---------------------------------------------------------------------------------------------
Given I open an editor "Anzahlungsrechnung" from table "(Sales):(Invoice)" with command "NEW" for record "BTEST"
And I set fields
    |vorganga|Anzahlung|
    |nummer  |1234     |
    |tterm   |.        |
    |ueb     |ja       |
And I set field "pwert" to "5000" in row 1
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
# ---------------------------------------------------------------------------------------------
Scenario: Az vollstaendig bezahlen 
# ---------------------------------------------------------------------------------------------
Given I open an editor "OffenePostenAusbuchen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set fields
    |gkonto|   18100|
    |beleg |      12|
And I append rows
    |tbeleg|    1234|
And I press button "opladen" 
Then field "konto" has value "K 4" in row 1
And  I set field "opzabetr" to "5750.00" in row 1
Then field "ofbetr" has value "0.00" in row 1
#CONFIRMATION dialog: id=[588] title=[] prompt=[Sind Sie sicher?]
And I respond with answer "yes" to the dialog with id "588"
And I save the current editor
# ---------------------------------------------------------------------------------------------
Scenario: Teilschlussrechnung aus Auftrag 99001 
# ---------------------------------------------------------------------------------------------
Given I open an editor "TeilSchlussrechnung" from table "(Sales):(Invoice)" with command "NEW" for record "BTEST"
And I set field "mge" to "500" in row 1
And I set field "mge" to "500" in row 2
And I set field "pwert" to "-4500.00" in row 3
And I set field "ueb" to "yes"
And I set field "tterm" to "."
And I respond with answer "yes" to the dialog with id "4841"
And I save the current editor
# ---------------------------------------------------------------------------------------------
Scenario: Teilschlussrechnung bezahlen 
# ---------------------------------------------------------------------------------------------
Given I open an editor "OffenePosten_Ausbuchen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set fields
    |gkonto|   18100|
    |beleg |      13|
And I append rows
    |konto |     K 4|
And I press button "opladen"
Then field "konto" has value "K 4" in row 1
And I press button "tueber" in row 1
And I respond with answer "yes" to the dialog with id "588"
And I save the current editor
#----------------------------------------------------------------------------------------------
#Scenario: IS Opendownpayements - alter Zustand 
#----------------------------------------------------------------------------------------------
#Given I open the infosystem "OPENDOWNPAYMENTS"
#And I set field "stichtag" to "31.12.1995"
#And I press start
#And I append ScenarioHeadline to output file "ref_fb_opendownpayments_cu.ref"
#And I export fields "aunummer,auzn,vom,tkunde,kname,tschlvre,bschluss,anzrenr,tanzvre,anzredat,anzrebetr,vorganga,anzwaehr,tanzkonto,budat,zahlbetr,ewbetr" from table content to output file "ref_fb_opendownpayments_cu.ref"
#And I close the current editor














