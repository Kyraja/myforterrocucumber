Feature: lieferliz.feature

  Background:
    And I set the fake date to "02.01.1995"
	 And I enable the flag 71

# **********************************************************************************
#  Name             : lieferliz
#  Autor            : pw
#  Verantwortlich   : teamcoreinfra
#  Kontrolle        :
#  Funktion         : Shopfloor-Passwort anlegen und Lieferlizenzen testen
#
# **********************************************************************************

  Scenario: Rechte der gelieferten Erlaubnissätze lesbar und diffbar ausgeben
  Given I execute FOP "LIEFERLIZENZEN.FOP LIMITED"
  Given I execute FOP "LIEFERLIZENZEN.FOP MOBILE"


  Scenario: F|cmdpermitted() läuft ohne Fehler mit aktuellem Passwort
  Given I execute FOP "LIEFERLIZENZENTEST.FOP"

  Scenario: F|cmdpermitted() läuft ohne Fehler mit sfloor Passwort
  Given I'm logged in with password "sfloor"
  Given I execute FOP "LIEFERLIZENZENTEST.FOP"


  Scenario: Shopfloor-Erlaubis kopieren und Lizenzart pruefen
  Given I open an editor "Erlaubnis" from table "(Permission):(Permission)" with command "COPY" for record "100000101"
  And I set fields
  | such         | MYSFLOOR |
  Then field "lizenzart" has value "FULL" in row 0
  And I save the current editor
  And I close the current editor

  Scenario: In neuem Passwort "MYSFLOOR" die Lizenzart mit unterschiedlichen Rechten testen
  Given I open an editor "Passwort" from table "(Company):(Password)" with command "STORE" for record "MYSFLOOR"
  And I set fields
    | such         | MYSFLOOR |
    | bezeich      | mysfloor |
    | name         | mysfloor |
    | abaserplogin | (1)      |
    | pw1          | mysfloor |
    | pw2          | mysfloor |
  Then field "lizenzart" has value "FULL" in row 0
  And I modify table
    | rechte	    | !row     |
    | MYSFLOOR  	 | +1       |
  Then field "lizenzart" has value "FULL" in row 0
  And I modify table
    | rechte	    | !row     |
    | 500000101	 | 1        |
  Then field "lizenzart" has value "LIMITED" in row 0
  And I modify table
    | rechte	    | !row     |
    | 500000101	 | +1       |
  Then field "lizenzart" has value "FULL" in row 0
  And I modify table
    | rechte	    | !row     |
    | 100000101    | 1        |
    | 100000201  	 | 2        |
  Then field "lizenzart" has value "LIMITED" in row 0
  And I save the current editor
  And I close the current editor
