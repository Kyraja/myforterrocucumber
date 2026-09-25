@persistent
Feature: editplankarte.feature

# **********************************************************************************
#  Name             : editplankarte.feature
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : bheim
#  Funktion         : Testet Neuerungen in der editierbaren Plankarte
#  Issues			      : FDA-3067
#
# **********************************************************************************

Background:
And I set the fake date to "4.10.2023"

Scenario: Zu Bedarfen von Koppelprodukten gibt es Beschaffungen
# Auftraege fuer BG-KOPPELPROD sowie KOPPELROD
Given I create a SalesOrder "AU_BG" for Customer "1" with Product "BG-KOPPELPROD" and quantity "50"
And I run Scheduling

Given I open an editor "Reserv_BG" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=KOPPELPROD;limge=50;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor

Given I open an editor "AU1_Koppel" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | KUNDE1    |
  | vom     | .         |
And I append rows
  | artikel    | mge      | tterm |
  | KOPPELPROD | 100      | +2    |
And I save the current editor

  Given I open an editor "AU2_Koppel" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde   | KUNDE2    |
  | vom     | .         |
And I append rows
  | artikel    | mge      | tterm |
  | KOPPELPROD | 30       | +9    |
And I save the current editor
And I run Scheduling

Given I open an editor "Best1_KOPPEL" from table "(Purchasing):(Item)" with command "VIEW" for search criteria "$,,artikel=KOPPELPROD;mge=100;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor

Given I open an editor "Reserv1_Koppel" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=KOPPELPROD;limge=100;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor

Given I open an editor "Best2_KOPPEL" from table "(Purchasing):(Item)" with command "VIEW" for search criteria "$,,artikel=KOPPELPROD;mge=100;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor

Given I open an editor "Reserv2_Koppel" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=KOPPELPROD;limge=30;@richtung=rueckwaerts;@maxtreffer=1"
And I close the current editor

# Editierbare Plankarte zeigt die Verknuepfungen der Reservierungen fuer das Koppelprodukt mit den jeweiligen Beschaffern.
# Folgende Abfrage fuer die Abfrage der id des Koppelprodukts aus der Baugruppe funktioniert derzeit noch nicht:
# | 1     | Fertigung   | !Reserv_BG^id     | Auftrag | !Reserv1_Koppel^id  | 50      | 100   |

Given I open an editor "Reserv1_Koppel" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=KOPPELPROD;limge=100;@richtung=rueckwaerts;@maxtreffer=1"
And I save value from field "id" in row 1
And I close the current editor

Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "KOPPELPROD"
And I press button "ladetab"
Then table has values
| !row  | bobart      | beschaffung^id    | robart  | bslmge  | rmge  |
| 1     | Fertigung   | !dontChange       |         | 50      |   0   |
| 2     | Fertigung   | !dontChange       | Auftrag | 50      |  30   |
| 4     | Bestellung  | !Best1_KOPPEL^id  | Auftrag | 100     | 100   |
Then field "reserv^id" in row 4 equals saved value
And I close the current editor

Given I open an editor "Reserv2_Koppel" from table "(Purchasing):(Reservations)" with command "VIEW" for search criteria "$,,elex=KOPPELPROD;limge=30;@richtung=rueckwaerts;@maxtreffer=1"
And I save value from field "id" in row 1
And I close the current editor

Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "VIEW" for record ""
And I set field "artikel" to "KOPPELPROD"
And I press button "ladetab"
Then table has values
| !row  | bobart      | beschaffung^id    | robart  | bslmge  | rmge  |
| 1     | Fertigung   | !dontChange       |         | 50      |   0   |
| 2     | Fertigung   | !dontChange       | Auftrag | 50      |  30   |
| 4     | Bestellung  | !Best1_KOPPEL^id  | Auftrag | 100     | 100   |
Then field "reserv^id" in row 2 equals saved value
And I close the current editor
