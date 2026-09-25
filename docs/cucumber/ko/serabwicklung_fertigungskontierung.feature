# *****************************************************************************
#  Name           : serabwicklung_fertigungskontierung.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test der Plausibilisierung der Kostenobjekte in der Servicer�ckmeldung (beim Bearbeiten)
#                   und der �berpr�fung der Kontierung in der R�ckmeldung, die aus der Servicer�ckmeldung entsteht.
#
#  Info            : Servicer�ckmeldung hies fr�her Technikerbericht!
#
# *****************************************************************************
@persistent
Feature: BW2-1415  
Background: ref_serabwicklung_fertigungskontierung_cu
Given I set the fake date to "10.02.1995"

# Stammdaten
# Kostenstellen
Given I open an editor "Kst2" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "102"
And I set field "such" to "k102"
And I save the current editor

Given I open an editor "Kst3" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "103"
And I set field "such" to "k103"
And I save the current editor

# Kostentraeger
Given I open an editor "Ktr2" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "100002"
And I set field "such" to "k100002"
And I save the current editor

Given I open an editor "Ktr3" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "100003"
And I set field "such" to "k100003"
And I save the current editor

Given I open an editor "Ktr4" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "100004"
And I set field "such" to "k100004"
And I save the current editor

Given I open an editor "Ktr5" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "100005"
And I set field "such" to "k100005"
And I save the current editor

# Kostenverteiler, neue Konten und Fertigungskontengruppe f�r Kst 100
Given I open an editor "kostenverteiler-10" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "10"
And I set field "such" to "kv"
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 1
And I set field "proz" to "10" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100000" in row 2
And I set field "proz" to "5" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 3
And I set field "proz" to "85" in row 3
And I save the current editor

Given I open an editor "kostenverteiler-20" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "20"
And I set field "such" to "kv"
And I create a new row at the end of the table
And I set field "kstelle" to "100003" in row 1
And I set field "proz" to "10" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100004" in row 2
And I set field "proz" to "5" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100005" in row 3
And I set field "proz" to "85" in row 3
And I save the current editor

# statistische Konten und Fertigungskontengruppe mit Kostenart "Lohn"
Given I open an editor "Konto" from table "(Account):(Account)" with command "COPY" for record "99900"
And I set field "nummer" to "88900"
And I set field "such" to "k88900"
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "COPY" for record "99900"
And I set field "nummer" to "88910"
And I set field "such" to "k88910"
And I save the current editor

Given I open an editor "fk" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "NEW" for record ""
And I set field "nummer" to "900"
And I set field "such" to "KFKONT"
And I append rows
    | fertigungskosten     | belast    | entlast   |
    | Lohn                 | 88900     | 88910     |
    | Fertigungskosten un  | 99800     | 99900     |
And I save the current editor

Scenario: 01 Editieren der Servicerueckmeldung 2
# In der Position muss ein Kostenobjekt eingetragen sein/werden.
Given I open an editor "srm2" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "UPDATE" for record "2"
And I set field "kstelle" to "102"
# Erzeugen einer DL-Position, die verbucht werden soll, zun�chst ohne Kostenobjekt
And I create a new row at the end of the table
And I set field "artikel" to "100001" in row 1
And I set field "dauer" to "0D00h30m" in row 1
# 9724 de      |In der Position fehlt die Kostenstelle aus der Serviceauftragsposition.
Then saving the current editor throws the exception "9724"
And I set field "tkstelle" to "100002" in row 1
And I save the current editor

# Editieren der Servicerueckmeldung 2
# Im Kopf muss ein Kostenobjekt eingetragen sein/werden.
Given I open an editor "srm2" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "UPDATE" for record "2"
And I set field "kstelle" to ""
# Erzeugen einer DL-Position, die verbucht werden soll, zun�chst ohne Kostenobjekt
And I create a new row at the end of the table
And I set field "artikel" to "100001" in row 1
And I set field "dauer" to "0D00h30m" in row 1
And I set field "tkstelle" to "100002" in row 1
#  2743 de      |Vorgang abgebrochen
# Then saving the current editor throws the exception "2743"
And I set field "kstelle" to "102"
And I save the current editor

# neue Service-RM1 erzeugen mit Kst im Kopf (Technikerbericht), die keine eigene Fertigungskontengruppe besitzt, d.h. die Lohnkonten aus Standardfertigungskontengruppe werden genommen.
Given I open an editor "srmneu1" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to "1002"
And I set field "servau" to "200005"
And I set field "lgr" to "3"
And I set field "kstelle" to "102"
And I set field "such" to "XSIH1"
And I create a new row at the end of the table
And I set field "artikel" to "e1" in row 1
And I set field "bumge" to "1" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "100013" in row 2
And I set field "dauer" to "0D00h30m" in row 2
And I set field "tkstelle" to "100002" in row 2
And I save the current editor

Given I open an editor "Kst" from table "(Account):(CostCenter)" with command "UPDATE" for record "103"
And I set field "fertkont" to "900"
And I save the current editor

# neue Service-RM2 erzeugen mit Kst im Kopf (Technikerbericht), die eine eigene Fertigungskontengruppe besitzt, d.h. es werden die Lohnkonten aus eigener Fertigungskontengruppe genommen
Given I open an editor "srmneu2" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to "1002"
And I set field "servau" to "200006"
And I set field "lgr" to "3"
And I set field "kstelle" to "103"
And I set field "such" to "XSIH2"
And I create a new row at the end of the table
And I set field "artikel" to "e2" in row 1
And I set field "bumge" to "2" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "100013" in row 2
And I set field "dauer" to "0D01h30m" in row 2
And I set field "tkstelle" to "100003" in row 2
And I save the current editor

# neue Service-RM3 erzeugen mit KV im Kopf (Technikerbericht), der keine eigene Fertigungskontengruppe besitzt, d.h. es werden die Lohnkonten aus Standardfertigungskontengruppe genommen
Given I open an editor "srmneu3" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to "1005"
And I set field "servau" to "200007"
And I set field "lgr" to "2"
And I set field "kstelle" to "10"
And I set field "such" to "XSIH3"
And I create a new row at the end of the table
And I set field "artikel" to "10004" in row 1
And I set field "bumge" to "4" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "100005" in row 2
And I set field "dauer" to "0D02h45m" in row 2
And I set field "tkstelle" to "100004" in row 2
And I save the current editor

Given I open an editor "Kv" from table "(Account):(CostDistribution)" with command "UPDATE" for record "20"
And I set field "fertkont" to "900"
And I save the current editor

# neue Service-RM4 erzeugen mit KV im Kopf (Technikerbericht), der eine eigene Fertigungskontengruppe besitzt, d.h. es werden die Lohnkonten aus eigener Fertigungskontengruppe genommen
Given I open an editor "srmneu4" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to "1006"
And I set field "servau" to "200008"
And I set field "lgr" to "2"
And I set field "kstelle" to "20"
And I set field "such" to "XSIH4"
And I create a new row at the end of the table
And I set field "artikel" to "10004" in row 1
And I set field "bumge" to "1" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "100005" in row 2
And I set field "dauer" to "0D00h25m" in row 2
And I set field "tkstelle" to "100005" in row 2
And I save the current editor





