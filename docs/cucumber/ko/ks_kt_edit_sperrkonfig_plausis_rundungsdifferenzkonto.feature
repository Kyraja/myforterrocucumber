# *****************************************************************************
#  Name           : ks_kt_edit_sperrkonfig_plausis_rundungsdifferenzkonto.feature
#  Autor          : jeffler
#  Verantwortlich : sih
#  Kontrolle      : 
#  Funktion       : 
#
# *****************************************************************************

@persistent
Feature: BW2-2000 (Kostenobjekte, die nicht gesperrt werden duerfen - Kostenobjekteigenschaft)
Background:

Given I set the fake date to "20.01.2002"


# pruefen, dass neu angelegte Konten (ohne Identnr => mit leerem Verweis) gesperrt werden koennen ohne, dass Treffer aufgrund leerer Verweise in Differenzkonten zu einem Verbot der Sperre fuehren
Scenario: Kostenobjekt erstellen und sofort sperren

# Konto muss leere Kostenstelle haben, damit das Scenario sinnvoll ist
Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "68800"
Then field "kstelle" has value ""
And I close the current editor

Given I open an editor "kstsperrsofort" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "such" to "kstsperrs"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor
And I close the current editor

Given I open an editor "ktrsperrsofort" from table "(Account):(CostObject)" with command "NEW" for record ""
And I set field "such" to "ktrsperrs"
And I set field "sperrkonfigurationneu" to "Standard-Kostentraegersperre"
And I save the current editor
And I close the current editor

Given I open an editor "kvsperrsofort" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "kvsperrs"
And I set field "sperrkonfigurationneu" to "Standard-Stammkostenverteilersperre"
And I append rows
|kstelle|proz|
|    100|  50|
|    101|  50|
And I save the current editor
And I close the current editor

Scenario Outline: Kostenstellen kopieren

Given I open an editor "verdkostenstelle2" from table "(Account):(CostCenter)" with command "COPY" for record "<record>"
And I set field "nummer" to "<nummer>"
And I set field "bebuchbar" to "<bebuchbar>"
And I set field "sperrkonfigurationneu" to ""
And I set field "verd" to "<verd>"
And I save the current editor
And I close the current editor

Examples:

|record|nummer|bebuchbar|verd|
|   101|  101b|     nein|    |
|   101|  101a|     nein|101b|
|   101|  101d|     nein|    |
|   101|  101c|     nein|101d|
|   100|  100a|       ja|101a|
|   100|  100c|       ja|101c|

Scenario Outline: Kostentraeger kopieren

Given I open an editor "kostentraeger" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "<nummer>"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Examples:

| nummer|
|100000a|
|100000c|

Scenario: Kostenverteiler kopieren

Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "2"
And I set field "such" to "kvsperr"
And I set field "sperrkonfigurationneu" to ""
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "50" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "50" in row 2
And I save the current editor
And I close the current editor

Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "COPY" for record "2"
And I set field "nummer" to "2a"
And I set field "such" to "kvsperr2"
And I save the current editor
And I close the current editor

Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "COPY" for record "2"
And I set field "nummer" to "2c"
And I set field "such" to "kvsperr2"
And I create a new row at the end of the table
And I set field "kstelle" to "100c" in row 1
And I set field "proz" to "50" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100000c" in row 2
And I set field "proz" to "50" in row 2
And I save the current editor
And I close the current editor


Scenario Outline: Differenzkonten anlegen

Given I open an editor "term" from table "(Company):(FinancialDates)" with command "VIEW" for record "2"
Then field "babkoartgj" has value "02"
Then field "babkoartgm" has value "1"
And I close the current editor

Given I open an editor "diffkonto" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "<nummer>"
And I set field "such" to "<such>"
And I set field "karta" to "<karta>"
And I set field "gv" to "ja"
And I set field "kstelle" to "<kst>"
And I set field "namebspr" to "<name>"
And I set field "eva" to "Einkauf"
And I save the current editor
And I close the current editor

Examples:

|nummer|                 karta|    kst|    such|                                      name|
# Rundungsdifferenzkonto mit Kostenstelle
|11000d|Rundungsdifferenzkonto|   100a|rdiffkst|   Rundungsdifferenzkonto mit Kostenstelle|
# Rundungsdifferenzkonto mit Kostentraeger
|12000d|Rundungsdifferenzkonto|100000a|rdiffktr|  Rundungsdifferenzkonto mit Kostentraeger|
# Rundungsdifferenzkonto mit Kostenverteiler
|13000d|Rundungsdifferenzkonto|     2a| rdiffkv|Rundungsdifferenzkonto mit Kostenverteiler|
# Kursdifferenzkonto mit Kostenstelle
|21000k|    Kursdifferenzkonto|   100c|kdiffkst|       Kursdifferenzkonto mit Kostenstelle|
# Kursdifferenzkonto mit Kostentraeger
|22000k|    Kursdifferenzkonto|100000c|kdiffktr|      Kursdifferenzkonto mit Kostentraeger|
# Kursdifferenzkonto mit Kostenverteiler
|23000k|    Kursdifferenzkonto|     2c| kdiffkv|    Kursdifferenzkonto mit Kostenverteiler|

# RUNDUNGSDIFFERENZKONTEN - kst sperren 
Scenario: Rundungsdifferenzkonto Kostenstelle sperren

# Konto In Standardkontierung eintragen
Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "drund" to "11000d"
And I save the current editor
And I close the current editor
# Sperrversuch der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Rundungsdifferenzenkonto verwendet wird. Es kommt im Konto 11000d vor.
"""
And I close the current editor
# Sperrversuch der Verdichtungskostenstelle aus der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor
# Sperrversuch der Verdichtungskostenstelle der Verdichtungskostenstelle aus der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101b"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor
# Konto aus Standardkontierung entfernen
Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "drund" to "68820"
And I save the current editor
And I close the current editor
# Sperrversuch der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Rundungsdifferenzenkonto verwendet wird. Es kommt im Konto 11000d vor.
"""
And I close the current editor
# Sperrversuch der Verdichtungskostenstelle aus der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor
# Sperrversuch der Verdichtungskostenstelle der Verdichtungskostenstelle aus der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101b"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor
# Kostenstelle aus Konto entfernen
Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "11000d"
And I set field "kstelle" to "100"
And I save the current editor
And I close the current editor
# Sperren erfolgreich
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor
And I close the current editor
# entsperren fuer weitere Testverwendung
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor
# 2068 : Beim Verdichtungsobjekt nicht aenderbar
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor
# 2068 : Beim Verdichtungsobjekt nicht aenderbar
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101b"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor
# Kostenstelle in Kostenverteiler eintragen
Given I open an editor "kvert" from table "(Account):(CostDistribution)" with command "UPDATE" for record "2a"
And I set field "proz" to "30" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100a" in row 3
And I set field "proz" to "20" in row 3
And I save the current editor
And I close the current editor
# Sperrversuch der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Rundungsdifferenzenkonto verwendet wird. Es kommt im Konto 13000d vor.
"""
And I close the current editor
# Sperrversuch der Verdichtungskostenstelle aus der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor
# Sperrversuch der Verdichtungskostenstelle der Verdichtungskostenstelle aus der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101b"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor

Scenario: Rundungsdifferenzkonto Kostentraeger sperren

# Konto In Standardkontierung eintragen
Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "drund" to "12000d"
And I save the current editor
And I close the current editor
# Sperrversuch scheitert
Given I open an editor "kstsperr" from table "(Account):(CostObject)" with command "UPDATE" for record "100000a"
And I set field "sperrkonfigurationneu" to "Standard-Kostentraegersperre"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Rundungsdifferenzenkonto verwendet wird. Es kommt im Konto 12000d vor.
"""
And I close the current editor
# Konto aus Standardkontierung entfernen
Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "drund" to "68820"
And I save the current editor
And I close the current editor
# Sperrversuch scheitert
Given I open an editor "kstsperr" from table "(Account):(CostObject)" with command "UPDATE" for record "100000a"
And I set field "sperrkonfigurationneu" to "Standard-Kostentraegersperre"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Rundungsdifferenzenkonto verwendet wird. Es kommt im Konto 12000d vor.
"""
And I close the current editor
# Kostentraeger aus Konto entfernen
Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "12000d"
And I set field "kstelle" to "100"
And I save the current editor
And I close the current editor
# Sperren erfolgreich
Given I open an editor "kstsperr" from table "(Account):(CostObject)" with command "UPDATE" for record "100000a"
And I set field "sperrkonfigurationneu" to "Standard-Kostentraegersperre"
And I save the current editor
And I close the current editor

Scenario: Rundungsdifferenzkonto Kostenverteiler sperren

# Konto In Standardkontierung eintragen
Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "drund" to "13000d"
And I save the current editor
And I close the current editor
# Sperrversuch scheitert
Given I open an editor "kvertsperr" from table "(Account):(CostDistribution)" with command "UPDATE" for record "2a"
And I set field "sperrkonfigurationneu" to "Standard-Stammkostenvert"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Rundungsdifferenzenkonto verwendet wird. Es kommt im Konto 13000d vor.
"""
And I close the current editor
# Konto aus Standardkontierung entfernen
Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "drund" to "68820"
And I save the current editor
And I close the current editor
# Sperrversuch scheitert
Given I open an editor "kvertsperr" from table "(Account):(CostDistribution)" with command "UPDATE" for record "2a"
And I set field "sperrkonfigurationneu" to "Standard-Stammkostenvert"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Rundungsdifferenzenkonto verwendet wird. Es kommt im Konto 13000d vor.
"""
And I close the current editor
# Kostenverteiler aus Konto entfernen
Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "13000d"
And I set field "kstelle" to "100"
And I save the current editor
And I close the current editor
# Sperren erfolgreich
Given I open an editor "kvertsperr" from table "(Account):(CostDistribution)" with command "UPDATE" for record "2a"
And I set field "sperrkonfigurationneu" to "Standard-Stammkostenvert"
And I save the current editor
And I close the current editor
# Sperre lösen
Given I open an editor "kvertsperr" from table "(Account):(CostDistribution)" with command "UPDATE" for record "2a"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor
# Kostenverteiler in Konto eintrage
Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "13000d"
And I set field "kstelle" to "2a"
And I save the current editor
And I close the current editor
# Kostenstelle in Kostenverteiler eintragen
Given I open an editor "kver" from table "(Account):(CostDistribution)" with command "UPDATE" for record "2a"
And I create a new row at the end of the table 
And I set field "kstelle" to "100a" in row !lastRow
And I save the current editor
And I close the current editor
# Kostenstelle sperren scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "100a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Rundungsdifferenzenkonto verwendet wird. Es kommt im Konto 13000d vor.
"""
And I close the current editor
# Sperrversuch der Verdichtungskostenstelle aus der Kostenstelle scheitert
Given I open an editor "kstsperr" from table "(Account):(CostCenter)" with command "UPDATE" for record "101a"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "2068"
And I close the current editor


Scenario Outline: Kursdifferenzkonten Kostenobjekte eintragen

# Kostenobjekte (ausgenomöglich 

Given I open an editor "diffkonto" from table "(Account):(<group>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to "<sperrkonfig>"
And I save the current editor
And I close the current editor
# Wieder entsperren
Given I open an editor "diffkonto" from table "(Account):(<group>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Examples:

|           group| record|                 sperrkonfig|
|      CostCenter|   100c|Standard-Kostenstellensperre|
|      CostObject|100000c|           Standard-Kostentr|
|CostDistribution|     2c|    Standard-Stammkostenvert|

# Kursdifferenzkonten in Standardkontierung eintrage => sperren sollte scheitern
Scenario: Kostenstelle in Kursdifferenzkonto der Standardkontierung

Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "dkurs" to "21000k"
And I save the current editor
And I close the current editor

Given I open an editor "diffkonto" from table "(Account):(CostCenter)" with command "UPDATE" for record "100c"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Kursdifferenzenkonto der Standardkontierung verwendet wird. Es kommt im Konto 21000k vor.
"""
And I close the current editor

Scenario Outline: alle anderen Kostenobjekte koennen weiterhin gesperrt werden

Given I open an editor "diffkonto" from table "(Account):(<group>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to "<sperrkonfig>"
And I save the current editor
And I close the current editor
# Wieder entsperren
Given I open an editor "diffkonto" from table "(Account):(<group>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Examples:

|           group| record|                 sperrkonfig|
|      CostObject|100000c|           Standard-Kostentr|
|CostDistribution|     2c|    Standard-Stammkostenvert|

Scenario: Kostentraeger in Kursdifferenzkonto der Standardkontierung

Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "dkurs" to "22000k"
And I save the current editor
And I close the current editor

Given I open an editor "diffkonto" from table "(Account):(CostObject)" with command "UPDATE" for record "100000c"
And I set field "sperrkonfigurationneu" to "Standard-Kostentr"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Kursdifferenzenkonto der Standardkontierung verwendet wird. Es kommt im Konto 22000k vor.
"""
And I close the current editor

Scenario Outline: alle anderen Kostenobjekte koennen weiterhin gesperrt werden

Given I open an editor "diffkonto" from table "(Account):(<group>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to "<sperrkonfig>"
And I save the current editor
And I close the current editor
# Wieder entsperren
Given I open an editor "diffkonto" from table "(Account):(<group>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Examples:

|           group| record|                 sperrkonfig|
|      CostCenter|   100c|Standard-Kostenstellensperre|
|CostDistribution|     2c|               Standard-Stammkostenvert|

Scenario: Kostenverteiler in Kursdifferenzkonto der Standardkontierung

Given I open an editor "standardkont" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "dkurs" to "23000k"
And I save the current editor
And I close the current editor

Scenario Outline: Kostenverteiler enthaelt Kostenstelle und Kostentraeger => keine Sperren möglich

Given I open an editor "diffkonto" from table "(Account):(<group>)" with command "UPDATE" for record "<record>"
And I set field "sperrkonfigurationneu" to "<sperrkonfig>"
Then saving the current editor throws the exception 
"""
Sperre nicht möglich, da das Objekt in einem Kursdifferenzenkonto der Standardkontierung verwendet wird. Es kommt im Konto 23000k vor.
"""
And I close the current editor

Examples:

|           group| record|                 sperrkonfig|
|      CostCenter|   100c|Standard-Kostenstellensperre|
|      CostObject|100000c|           Standard-Kostentr|
|CostDistribution|     2c|    Standard-Stammkostenvert|

