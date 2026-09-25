# *****************************************************************************
#  Name           : ref_ilv_plausi_storno_cu.feature
#  Autor          : Michael Rothmann
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test des Verbots des Stornos von ILV-Buchungen
#
#
# *****************************************************************************
@persistent
Feature: Test des Verbots des Stornos von ILV-Buchungen
Background:

Given I set the fake date to "02.01.02"



Scenario: Erwartete Fehlermeldung 3558 beim Stornieren von ILV-Buchungen.

Then opening an editor from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for search criteria "$,,gjahr=02;monat=1;ursache=Leistungsverrechnung;vkzart=Ist;@richtung=rückwärts;@maxtreffer=1" throws the exception "3558"

Then opening an editor from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for search criteria "$,,gjahr=02;monat=1;ursache=Leistungsverrechnung Haupt-Kostenstelle;vkzart=Ist;@richtung=rückwärts;@maxtreffer=1" throws the exception "3558"

Then opening an editor from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for search criteria "$,,gjahr=02;monat=1;ursache=Leistungsverrechnung;vkzart=Plan;@richtung=rückwärts;@maxtreffer=1" throws the exception "3558"

Then opening an editor from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for search criteria "$,,gjahr=02;monat=1;ursache=Leistungsverrechnung Haupt-Kostenstelle;vkzart=Plan;@richtung=rückwärts;@maxtreffer=1" throws the exception "3558"

# =========================================================================================

