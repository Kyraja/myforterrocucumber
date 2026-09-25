# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
# Verantwortlich: mh
# Kontrolle:      teaminfosysteme
# Funktion:       Test Grundfunktionen IS MATERIALSURCHARGES
#                 Testumfang
#                  + Selektionen
#                  + Neuanlegen MTZ im leeren Infosytem
#                  + Vorbelegung aus Vorgaenerzeile
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
Feature: Infosystem MATERIALSURCHARGES (Materialzuschläge) - 
@persistent

Scenario: Keine Daten
Given I open the infosystem "MATERIALSURCHARGES"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

Scenario: Daten anlegen (10 Datensaetze, 2 Materialarten ABC und XYZ mit je 5 verschiedenen Datums)
Given I open the infosystem "MATERIALSURCHARGES"
And I press button "bstart"
Then the table has 0 rows
And I append rows 
  | matart | matnotiz | matdat |
  | ABC    | 15       | +1     |
  | ABC    | 16       | +3     |
  | ABC    | 17       | +5     |
  | ABC    | 18       | +7     |
  | ABC    | 19       | +9     |
  | XYZ    | 25       | +1     |
  | XYZ    | 26       | +3     |
  | XYZ    | 27       | +5     |
  | XYZ    | 28       | +7     |
  | XYZ    | 29       | +9     |
And I press button "kbuschreiben"
And I press button "bstart"
And the table has 10 rows
And I close the current editor

Scenario: Selektion 1a, Materialart (kmatart)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatart" to "UPS"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

Scenario: Selektion 1b, Materialart (kmatart)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatart" to "ABC"
And I press button "bstart"
Then the table has 5 rows
And I close the current editor

Scenario: Selektion 1c, Materialart (kmatart)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatart" to "XYZ"
And I press button "bstart"
Then the table has 5 rows
And I close the current editor

Scenario: Selektion 2a, Datum (kmatvom,kmatbis)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatvom" to "-1"
And I set field "kmatbis" to "-1"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

Scenario: Selektion 2b, Datum (kmatvom,kmatbis)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatvom" to "-1"
And I set field "kmatbis" to "+3"
And I press button "bstart"
Then the table has 4 rows
And I close the current editor

Scenario: Selektion 2c, Datum (kmatvom,kmatbis)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatvom" to "+2"
And I set field "kmatbis" to ""
And I press button "bstart"
Then the table has 8 rows
And I close the current editor

Scenario: Selektion 2d, Datum (kmatvom,kmatbis)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatvom" to "+3"
And I set field "kmatbis" to "+5"
And I press button "bstart"
Then the table has 4 rows
And I close the current editor

Scenario: Selektion 2e, Datum (kmatvom,kmatbis)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatvom" to ""
And I set field "kmatbis" to "+1"
And I press button "bstart"
Then the table has 2 rows
And I close the current editor

Scenario: Selektion 3a, Materialart und Datum (kmatart, kmatvom, kmatbis)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatart" to "ABC"
And I set field "kmatvom" to ""
And I set field "kmatbis" to "+1"
And I press button "bstart"
Then the table has 1 rows
And I close the current editor

Scenario: Selektion 3b, Materialart und Datum (kmatart, kmatvom, kmatbis)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatart" to "XYZ"
And I set field "kmatvom" to "+3"
And I set field "kmatbis" to "+5"
And I press button "bstart"
Then the table has 2 rows
And I close the current editor

Scenario: Werte vorbelegen aus vorangehender Zeile (hier: matart ABC)
Given I open the infosystem "MATERIALSURCHARGES"
And I set field "kmatart" to "ABC"
And I set field "kmatvom" to "+1"
And I set field "kmatbis" to "+1"
And I press button "bstart"
Then the table has 1 rows
And table has values
  | matart | matnotiz |
  | ABC    | 15.00    |  # wir haben genau 1 Zeile selektiert
And I append rows 
  | matnotiz |
  | 99       |  # nur den Preis (matnotiz) setzen, die matart kommt aus Zeile 1
Then the table has 2 rows
And table has values
  | matart | matnotiz |
  | ABC    | 15.00    | 
  | ABC    | 99.00    | 
And I close the current editor
