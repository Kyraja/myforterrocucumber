# *****************************************************************************
#  Name             : performancetest_kvlbu.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Performancetest zu IS KVLBU
#
# *****************************************************************************
#  Die Datei wird in einer Schleife ausgefuehrt:
#    siehe https://wiki.abasag.intra/x/Q4AABw
#    oder  https://abascloud.atlassian.net/wiki/x/QQCl4CU
#  Pro einen Durchlauf wird IS KVLBU 10 Mal aufgerufen
#
# *****************************************************************************
@persistent
Feature: performancetest_kvlbu.feature
Background:

Given I set the fake date to "1.6.1996"

Scenario Outline: KVLBU fuer nur eine Kontovorgangsnummer "-" mit viele BU-Zeilen aufrufen -> theoretisch mehrere Konten moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Konto"
And I set field "kvvon" to "-"
And I set field "kvbis" to "-"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "1"
And I set field "endm" to "11"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario Outline: KVLBU fuer nur einen Kontovorgang "S16000_-" mit vielen BU-Zeilen aufrufen -> nur ein Konten moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Konto"
And I set field "konto" to "16000"
And I set field "kvvon" to "-"
And I set field "kvbis" to "-"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "4"
And I set field "endm" to "12"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario Outline: KVLBU fuer nur eine Kontovorgangsnummer "APP_11" mit vielen BU-Zeilen aufrufen -> theoretisch mehrere Konten moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Konto"
And I set field "kvvon" to "APP_11"
And I set field "kvbis" to "APP_11"
And I set field "anfj" to "94"
And I set field "endj" to "95"
And I set field "anfm" to "6"
And I set field "endm" to "12"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################

#  Fehlermeldung:
#  GewÿÂnschter SchlÿÂssel: (AccountStatement_AccountTransactionNumber3), Schÿâ€žtzwert: 11640
#  Nicht eingeschrÿâ€žnkte TeilschlÿÂssel: 
#  @datenbank=131:0;@ablage=(Active);@zeilen=(0)
#  SEL: "0:kvrel=1;0:typ=1;0:kvnum=VIELE_ZEILEN!VIELE_ZEILEN;0:iwbu=(153,94,0);0:sortgjgm=19950101!19950112;0:budat=19950101!19951231;@ordnung=0:konto.(Forwards),0:sortgjgm.(Forwards),0:budat.(Forwards)"
#  selrohl: "$,"
#  Nicht optimale Suche
#  Fehlernummer -4711
#  Ohne Programmabbruch
#
#
# Scenario Outline: KVLBU fuer nur eine Kontovorgangsnummer "VIELE_ZEILEN" mit vielen BU-Zeilen aufrufen -> theoretisch mehrere Konten moeglich
#
# Given I open the infosystem "KVLBU"
# And I set field "vtab" to "Konto"
# And I set field "kvvon" to "VIELE_ZEILEN"
# And I set field "kvbis" to "VIELE_ZEILEN"
# And I set field "anfj" to "95"
# And I set field "endj" to "95"
# And I set field "anfm" to "1"
# And I set field "endm" to "12"
# #
# And I press start
# And I close the current editor
# 
# Examples:
#               | id   |
# #LOOP 1 to 1  | #id# |
#               | 1    |
# ###############################################################################


Scenario Outline: KVLBU fuer einen Kontovorgang "S35555_VIELE_ZEILEN" aufrufen -> nur ein Konto moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Konto"
And I set field "kvvon" to "VIELE_ZEILEN"
And I set field "kvbis" to "VIELE_ZEILEN"
And I set field "konto" to "35555"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "7"
And I set field "endm" to "12"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario Outline: KVLBU fuer einen Kontovorgang "S45555_VIELE_ZEILEN" aufrufen -> nur ein Konto moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Konto"
And I set field "kvvon" to "VIELE_ZEILEN"
And I set field "kvbis" to "VIELE_ZEILEN"
And I set field "konto" to "45555"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "1"
And I set field "endm" to "10"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario Outline: KVLBU fuer einen Kontovorgang "S45556_VIELE_ZEILEN" aufrufen -> nur ein Konto moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Konto"
And I set field "kvvon" to "VIELE_ZEILEN"
And I set field "kvbis" to "VIELE_ZEILEN"
And I set field "konto" to "45556"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "2"
And I set field "endm" to "11"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario Outline: KVLBU fuer das Konto 00995 -> darf keine KVs haben; das Konto ist nicht kvrelevant

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Konto"
And I set field "konto" to "00995"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "3"
And I set field "endm" to "11"
#
And I press start
Then the table has 0 rows
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario Outline: KVLBU fuer eine Kontovorgangsnummer "APP_11" mit vielen BU-Zeilen aufrufen -> theoretisch mehrere Konten moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Lieferant"
And I set field "kvvon" to "APP_11"
And I set field "kvbis" to "APP_11"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "3"
And I set field "endm" to "10"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario Outline: KVLBU fuer einen Kontovorgang "L001_APP_11" aufrufen -> nur ein Konto "L 001" moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Lieferant"
And I set field "kvvon" to "APP_11"
And I set field "kvbis" to "APP_11"
And I set field "konto" to "L 001"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "5"
And I set field "endm" to "11"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################


Scenario Outline: KVLBU fuer einen Kontovorgang "L004_APP_11" aufrufen -> nur ein Konto "L 004" moeglich

Given I open the infosystem "KVLBU"
And I set field "vtab" to "Lieferant"
And I set field "kvvon" to "APP_11"
And I set field "kvbis" to "APP_11"
And I set field "konto" to "L 004"
And I set field "anfj" to "94"
And I set field "endj" to "96"
And I set field "anfm" to "1"
And I set field "endm" to "6"
#
And I press start
And I close the current editor

Examples:
              | id   |
#LOOP 1 to 1  | #id# |
              | 1    |
###############################################################################

