# *****************************************************************************
#  Name           : db_metadata_cu.feature
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       :
#
# *****************************************************************************
#

@persistent
Feature: DB Metadaten Test
Background:
Given I set the fake date to "05.01.1995"


# ------------------------------------------------------
Scenario Outline: DB Metadaten Test
# ------------------------------------------------------

Given I open an editor "Vartab" from table "(Company):(Vartab)" with command "VIEW" for record "<DB-Gruppe>"

Then field "vstammdat" has value "<vstammdatValue>"
Then field "veinmal" has value "<veinmalValue>"
Then field "vistzd" has value "<vistzdValue>"

And I close the current editor

Examples:
| DB-Gruppe | vstammdatValue | veinmalValue | vistzdValue |

|   V-15-00 |           nein |         nein |          ja |
|   V-65-01 |             ja |         nein |        nein |
|   V-89-02 |             ja |           ja |        nein |
|  V-184-00 |           nein |         nein |        nein |

