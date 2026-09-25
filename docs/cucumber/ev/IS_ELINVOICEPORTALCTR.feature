@persistent
Feature: Infosystem ELINVOICEPORTALCTR starten

# Ohne Properties geht es nicht

Scenario: Infosystem ELINVOICEPORTALCTR ohne Properties starten bricht mit Fehler ab
Given I open the infosystem "ELINVOICEPORTALCTR"
And I press button "bstart"
Then the table has 0 rows
And I close the current editor

# FIXME: die Exception kommt in cucu nicht als "exception" an
# Then pressing button "bstart" throws the exception "Die Authentifizierung bei der MyForterro API ist gescheitert."
# bei Verwendung von NOCHECK_errorlog im Testbett, passiert gar nichts
# ohne daas Flag, erhaelt das Testbett ein grosses StackTrace im errorlog, cucu selbst meldet weiterhin, dass
# die hier erwartete Exception nicht aufgetreten ist.

