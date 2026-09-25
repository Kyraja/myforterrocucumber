Feature: Bereichseingabe im Infosystem BANKEN pruefen
@persistent

Scenario: Infosystem BANKEN bedieinen

#Infosystem BANKEN ohne Selektion aufrufen
Given I open the infosystem "BANKEN"
And I press button "bstart"
Then the table has 10 rows
And I close the current editor

#Infosystem BANKEN mit Bereich 10!20
Given I open the infosystem "BANKEN"
And I set field "von" to "10"
And I set field "bis" to "20"
And I press button "bstart"
Then the table has 2 rows
And I close the current editor

#Infosystem BANKEN mit halber Bereichsangabe !1
Given I open the infosystem "BANKEN"
And I set field "bis" to "1"
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

#Infosystem BANKEN mit Bereich 2!1 macht Fehler
Given I open the infosystem "BANKEN"
And I set field "von" to "2"
And I set field "bis" to "1"
Then pressing button "bstart" throws the exception "Ungültiger Bereich"
And I close the current editor

#Infosystem BANKEN mit Bereich BA_14!BA_15
Given I open the infosystem "BANKEN"
And I set field "von" to "BA_14"
And I set field "bis" to "BA_15"
And I press button "bstart"
Then the table has 8 rows
And I close the current editor

#Infosystem BANKEN mit Bereich B!A macht Fehler
Given I open the infosystem "BANKEN"
And I set field "von" to "B"
And I set field "bis" to "A"
Then pressing button "bstart" throws the exception "Ungültiger Bereich"
And I close the current editor

#Infosystem BANKEN mit Bereich 1!A macht fehler (identnummer und suchwort vermicht)
Given I open the infosystem "BANKEN"
And I set field "von" to "1"
And I set field "bis" to "A"
Then pressing button "bstart" throws the exception "Bereich darf entweder nur Suchworte oder nur Identnummern enthalten"
And I close the current editor

#Infosystem BANKEN, weitere Eingabefelder
Given I open the infosystem "BANKEN"
And I set field "bname" to "Caisse"
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

#Infosystem BANKEN, weitere Eingabefelder
Given I open the infosystem "BANKEN"
And I set field "staat" to "ECUADOR"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

#Infosystem BANKEN, weitere Eingabefelder
Given I open the infosystem "BANKEN"
And I set field "nident" to "14604146"
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

#Infosystem BANKEN, weitere Eingabefelder (keine daten, aber Infosytem darf keine Exception werfen)
Given I open the infosystem "BANKEN"
And I set field "nident2" to "123"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

#Infosystem BANKEN, weitere Eingabefelder (keine daten, aber Infosytem darf keine Exception werfen)
Given I open the infosystem "BANKEN"
And I set field "iident" to "123"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

#Infosystem BANKEN, weitere Eingabefelder (keine daten, aber Infosytem darf keine Exception werfen)
Given I open the infosystem "BANKEN"
And I set field "region" to "EMR"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

#Infosystem BANKEN, weitere Eingabefelder (keine daten, aber Infosytem darf keine Exception werfen)
Given I open the infosystem "BANKEN"
And I set field "nouse" to "ja"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor
