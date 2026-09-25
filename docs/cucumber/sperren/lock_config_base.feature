# *****************************************************************************
#  Name: lock_config_base.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Legt Sperrkonfigurationen an und konfiguiert sie in Aufzaehlungen.
# *****************************************************************************
@persistent
Feature: ExemplarischeSperrKonfig

Scenario: SperrKonfigZusatzPos

Given I'm logged in with password "sy"

# Gueltige Sperrkonfigurationen fuer Zusatzpositionen

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_ADD_ERR"
And I set field "classname" to "ZusatzPositionSperre"
And I set field "gesperrtegruppe" to "V-02-04"
And I save the current editor
And I close the current editor

Given I open an editor "Hint" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_ADD_HINT"
And I set field "classname" to "ZusatzPositionHinw"
And I set field "gesperrtegruppe" to "V-02-04"
And I save the current editor
And I close the current editor

# Gueltige Aufzaehlung fuer Zusatzpositionen

Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22002"
And I append rows
   | vaufzelem                        | aebez                  | aekbez    | aebezeichner
   | Sperrkonfiguration LOCK_ADD_ERR  | Zusatzpositionssperre  | ZPsperre  | Zusatzpositionssperre
   | Sperrkonfiguration LOCK_ADD_HINT | Zusatzpositionshinweis | ZPhinweis | Zusatzpositionshinw

# Gehoert Ja, passiert aber unten nochmal und einmal reicht.
And I respond with answer "Nein" to the dialog with id "10951"
And I save the current editor

# Gueltige Sperrkonfigurationen fuer Dienstleistungen
# und eine für Zusatzpostionen

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_SERVICE_ERR"
And I set field "classname" to "DienstleistungsSperre"
And I set field "gesperrtegruppe" to "V-02-05"
And I save the current editor
And I close the current editor

Given I open an editor "Hint" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_SERVICE_HINT"
And I set field "classname" to "DienstleistungsHinw"
And I set field "gesperrtegruppe" to "V-02-05"
And I save the current editor
And I close the current editor

Given I open an editor "Hint" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_NOT_SERVICE"
And I set field "classname" to "KeineDienstleistungssperre"
And I set field "gesperrtegruppe" to "V-02-04"
And I save the current editor
And I close the current editor

# Falsch konfigurierte Aufzaehlung fuer Dienstleistungen

Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22003"
And I append rows
   | vaufzelem                            | aebez                      | aekbez     | aebezeichner
   | Sperrkonfiguration LOCK_SERVICE_ERR  | Dienstleistungssperre      | DLsperre   | Dienstleistungssperre
   | Sperrkonfiguration LOCK_SERVICE_HINT | Dienstleistungshinweis     | DLhinweis  | Dienstleistungshinw
   | Sperrkonfiguration LOCK_NOT_SERVICE  | Falsche Gruppe             | NoDLsperre | FalscheGruppe
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor

# Gueltige Sperrkonfigurationen fuer Artikel

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "ART_LOCK"
And I set field "classname" to "ArtSperreHart"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Given I open an editor "Hint" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "ART_HINT"
And I set field "classname" to "ArtSperreWeich"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

# Gueltige Aufzaehlung fuer Produkte

Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22001"
And I append rows
   | vaufzelem                   | aebez               | aekbez       | aebezeichner
   | Sperrkonfiguration ART_LOCK | Artikelvollsperre   | Vollgesperrt | Artikelsperre
   | Sperrkonfiguration ART_HINT | Artikelsperrhinweis | Hinweis      | Artikelhinweis
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor
And I close the current editor
