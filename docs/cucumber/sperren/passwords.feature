# *****************************************************************************
#  Name: passwords.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Legt Test-Passworte für die DB Objektsperre an
# *****************************************************************************
@persistent
@PERMISSIONS
Feature: OBJLOCK 12:11

Given I'm logged in with password "annette"

Scenario: ErlNixNeu

Given I open an editor "ErlNixNeu" from table "(Permission):(Permission)" with command "NEW" for record "26"
And I set field "such" to "NixNeu"
And I set field "dn12p" to "-" in rowspec "$,,datnr==193"
And I set field "dn13p" to "-" in rowspec "$,,datnr==193"
And I save the current editor
And I close the current editor

Scenario: ErlNixLoesch

Given I open an editor "ErlNixLoesch" from table "(Permission):(Permission)" with command "NEW" for record "26"
And I set field "such" to "NixLoesch"
And I set field "dn9p" to "-" in rowspec "$,,datnr==193"
And I save the current editor
And I close the current editor

Scenario: ErlNixAendern

Given I open an editor "ErlNixAendern" from table "(Permission):(Permission)" with command "NEW" for record "26"
And I set field "such" to "NixAendern"
And I set field "dn11p" to "-" in rowspec "$,,datnr==193"
And I save the current editor
And I close the current editor

Scenario: Password_NixNeu

Given I open an editor "PassWdNixNeu" from table "(Company):(Password)" with command "NEW" for record "26"
And I set field "such" to "NixNeu"
And I set field "namebspr" to "Passwort NixNeu"
And I set field "bezeich" to "NixNeu"
And I set field "abaserplogin" to "ja"
And I set field "pw1" to "NixNeu"
And I set field "pw2" to "NixNeu"
And I set field "rechte" to "NIXNEU" in row 1
And I save the current editor
And I close the current editor

Scenario: Password_NixLoesch

Given I open an editor "PassWdNixLoesch" from table "(Company):(Password)" with command "NEW" for record "26"
And I set field "such" to "NixLoesch"
And I set field "namebspr" to "Passwort NixLoesch"
And I set field "bezeich" to "NixLoesch"
And I set field "abaserplogin" to "ja"
And I set field "pw1" to "NixLoesch"
And I set field "pw2" to "NixLoesch"
And I set field "rechte" to "NIXLOESCH" in row 1
And I save the current editor
And I close the current editor

Scenario: Password_NixAendern

Given I open an editor "PassWdNixAemderm" from table "(Company):(Password)" with command "NEW" for record "26"
And I set field "such" to "NixAendern"
And I set field "namebspr" to "Passwort NixAendern"
And I set field "bezeich" to "NixAendern"
And I set field "abaserplogin" to "ja"
And I set field "pw1" to "NixAendern"
And I set field "pw2" to "NixAendern"
And I set field "rechte" to "NIXAENDERN" in row 1
And I save the current editor
And I close the current editor
