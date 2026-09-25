# *****************************************************************************************
#  Name           : ref_fibu_strgl_cu.feature
#  Autor          : jeffler
#  Verantwortlich : wane
#  Kontrolle      : hc
#  Funktion       : Testet die Ausgabe der Meldung 6751 bei Buchungen ohne Steuerregel
#
# *****************************************************************************************
@persistent

Feature: ref_fibu_strgl_cu
Background: Finanzbuchung - Steuerregel

Given I set the fake date to "02.01.2002"

Scenario: Steuerschlüssel, -konto und -regel anlegen

Given I open an editor "strschl" from table "(TaxCode):(TaxCode)" with command "NEW" for record ""
And I set field "nummer" to "3PERSTS1"
And I set field "such" to "STS3PER"
And I append rows
|gperr|psatz|      gvon|      gbis|
| PER1|   19|01.01.2000|31.12.2001|
| PER2|   17|01.01.2002|31.12.2002|
| PER3|   19|01.01.2003|31.12.2080|
And I save the current editor
And I close the current editor

Given I open an editor "strkonto" from table "(Account):(Account)" with command "NEW" for record ""
And I set fields
|   nummer|                                 159632|
|     such|                              strkonto1|
| namebspr|Steuerkonto für Steuerschlüssel STS3PER|
|      eva|                                Verkauf|
|    karta|                            Steuerkonto|
|steuersts|                               3PERSTS1|
And I save the current editor
And I close the current editor

Given I open an editor "strgl" from table "(TaxCode):(TaxRule)" with command "NEW" for record ""
And I set fields
|   such|      VKIN-3PER|
|     ev|        Verkauf|
|stlaart|         Inland|
| ustart|steuerpflichtig|
|    sts|       3PERSTS1|
Then the table has 0 rows 
And I press button "ladestpertab"
Then the table has 3 rows
And I set field "vstkonto" to "159632" in row 1
And I set field "vstkonto" to "159632" in row 2
And I set field "vstkonto" to "159632" in row 3
And I save the current editor
And I close the current editor

Given I open an editor "strgl" from table "(ProcessTaxRule):(ProcessTaxRule)" with command "NEW" for record ""
And I set fields
|    such|vgstrgl3per|
|      ev|    Verkauf|
| stlaart|     Inland|
|ustartsp|         ja|
And I save the current editor
And I close the current editor

Given I open an editor "strgl" from table "(TaxCode):(AccountTaxRule)" with command "NEW" for record ""
And I set fields
|   such|kstrgl3per|
|     ev|   Verkauf|
Then the table has 0 rows
And I append rows
|   vrgstrgl|    strgl|
|vgstrgl3per|VKIN-3PER|
And I save the current editor
And I close the current editor

Scenario: Buchungsdatum ändern bei Buchung anlegen ohne Zeilen

Given I open an editor "fibuvsummstrgl" from table "(Entry):(Entry)" with command "NEW" for record ""
Then field "budat" has value "02.01.02"
And I set field "budat" to "01.08.02"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I set field "budat" to "01.01.01"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I set field "budat" to "03.05.02"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I set field "budat" to "20.02.03"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I close the current editor

Scenario: Buchungsdatum ändern bei Buchung anlegen mit Zeilen, ohne Steuerregel

Given I open an editor "fibuvsummstrgl" from table "(Entry):(Entry)" with command "NEW" for record ""
And I append rows
|   konto|ewsbetr|ewhbetr|
|   18200|       |  10000|
|   18100|  10000|       |
Then field "steuer" has value "0" in row 1
Then field "steuer" has value "0" in row 2
Then field "strgl" has value "" in row 1
Then field "strgl" has value "" in row 2
Then field "budat" has value "02.01.02"
And I set field "budat" to "01.08.02"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I set field "budat" to "01.01.01"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I set field "budat" to "03.05.02"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I set field "budat" to "20.02.03"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I close the current editor

Scenario: Buchungsdatum ändern bei Buchung mit Zeilen mit Steuerregel

# Konto mit Kontensteuerregel anlegen
Given I open an editor "konto2" from table "(Account):(Account)" with command "NEW" for record ""
And I set fields
|  nummer|                                                  17935|
|    such|                                               ankokstr|
|namebspr|Anlagenkonto für Kontensteuerregel mit 3 Steuerperioden|
|     eva|                                                Verkauf|
|   karta|                                           Anlagenkonto|
|ktostrgl|                                             KSTRGL3PER|
Then field "laarta" has value "Inland"
And I save the current editor
And I close the current editor

 # Buchung mit Konto mit Kontensteuerregel anlegen -> Steuerregel wird aus dem Konto gezogen
Given I open an editor "fibuvsummstrgl" from table "(Entry):(Entry)" with command "NEW" for record ""
And I append rows
|   konto|ewsbetr|ewhbetr|
|ankokstr|       |  10000|
|   18100|  10000|       |
# steuerregel aus Konto "ankokstr"
Then field "steuer" has value "3PERSTS1" in row 1
Then field "strgl" has value "VKIN-3PER" in row 1
Then field "budat" has value "02.01.02"
And I set field "budat" to "01.08.02"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was not displayed
And I set field "budat" to "01.01.01"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was displayed
And I set field "budat" to "03.05.02"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was displayed
And I set field "budat" to "20.02.03"
Then message " Neues Buchungsdatum liegt vor oder nach Steuerumstellung. Steuerberechnung wird zurückgesetzt." was displayed
And I close the current editor
