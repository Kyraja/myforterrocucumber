# *****************************************************************************
#  Name: parts_editor_obj_lock.feature
#  Autor: tf
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet das Setzen von Sperren im Teileeditor
# *****************************************************************************
@persistent
Feature: Locks in Parts

Scenario: Set Lock

Given I'm logged in with password "sy"

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_PART"
And I set field "classname" to "ArtikelSperre"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_PART_HINT"
And I set field "classname" to "ArtikelHinweis"
And I set field "gesperrtegruppe" to "V-02-01"
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_ADD"
And I set field "classname" to "ZusatzPositionSperre"
And I set field "gesperrtegruppe" to "V-02-04"
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_ADD_HINT"
And I set field "classname" to "ZusatzPositionHinw"
And I set field "gesperrtegruppe" to "V-02-04"
And I save the current editor
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""
And I set field "such" to "LOCK_SERVICE"
And I set field "classname" to "ServiceSperre"
And I set field "gesperrtegruppe" to "V-02-05"
And I save the current editor
And I close the current editor

Given I open an editor "Service" from table "(Part):(Service)" with command "NEW" for record ""
And I set field "such" to "SERVICE_ADD"
And I set field "name" to "SuperService"
And I save the current editor
And I close the current editor

Scenario: Enumeration 22001 erweitern
Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22001"
And I append rows
   | vaufzelem                         | aebez                 | aekbez           | aebezeichner
   | Sperrkonfiguration LOCK_PART      | Artikelsperre         | Artikelsperre    | Artikelsperre
   | Sperrkonfiguration LOCK_PART_HINT | Artikelhinweis        | Artikelhinweis   | Artikelhinw.
   | Sperrkonfiguration LOCK_ADD       | Zusatzpositionssperre | ZPsperre         | Zusatzpositionssperre
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor

Scenario: Enumeration 22002 erweitern
Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22002"
And I append rows
   | vaufzelem                                               | aebez                             | aekbez       | aebezeichner
   | Sperrkonfiguration LOCK_ADD            | Zusatzpositionssperre  | ZPsperre   | Zusatzpositionssperre
   | Sperrkonfiguration LOCK_ADD_HINT | Zusatzpositionshinweis | ZPhinweis | Zusatzpositionshinw
 And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor

Scenario: Enumeration 22003 erweitern
Given I open an editor "Enumeration" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "22003"
And I append rows
   | vaufzelem                         | aebez                 | aekbez           | aebezeichner
   | Sperrkonfiguration LOCK_SERVICE   | Servicesperre         | Servicesperre    | Servicesperre
And I respond with answer "Ja" to the dialog with id "10951"
And I save the current editor


Scenario: Testfaelle

Given I open an editor "Artikel_V1_01" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I set field "sperrgrundneu" to "Artikel kaputt"
And I save the current editor
And I close the current editor

Given I open an editor "Artikel_V1_02" from table "(Part):(Product)" with command "UPDATE" for record "V1"
Then field "sperrkonfiguration" has value "Artikelsperre"
Then field "sperrkonfigurationneu" has value "Artikelsperre"
Then field "sperrgrund" has value "Artikel kaputt"
Then field "sperrgrundneu" has value "Artikel kaputt"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
Then field "sperrgrundneu" has value "Artikel kaputt"
And I set field "sperrkonfigurationneu" to "Artikelhinweis"
Then field "sperrgrundneu" has value ""
And I set field "sperrkonfigurationneu" to "Artikelsperre"
Then field "sperrgrundneu" has value ""
And I close the current editor

Given I open an editor "Artikel_V2" from table "(Part):(Product)" with command "UPDATE" for record "V2"
And setting field "sperrkonfigurationneu" to "Zusatzpositionssperre" throws the exception "1361"
Then field "sperrgrundneu" has value ""
And I close the current editor

Given I open an editor "Dienstleistung" from table "(Part):(Service)" with command "UPDATE" for record "SERVICE_ADD"
And I set field "sperrkonfigurationneu" to "ServiceSperre"
And I set field "sperrgrundneu" to "Es gibt einen Grund!"
And I set field "sperrkonfigurationneu" to ""
Then field "sperrgrundneu" has value ""
And I close the current editor

Given I open an editor "Lock" from table "(LockConfiguration):(LockConfiguration)" with command "UPDATE" for record "100001"
And setting field "gesperrtegruppe" to "V-02-05" throws the exception "551"
And setting field "classname" to "NewClass" throws the exception "551"
And I save the current editor
And I close the current editor

# Test neues Framework in der Zusatzposition
Given I open an editor "Zusatzposition" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
And I set field "sperrkonfigurationneu" to "Zusatzpositionssperre"
And I set field "sperrgrundneu" to "Zusatzposition kaputt"
And I save the current editor
And I close the current editor

Given I open an editor "Zusatzposition" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "A."
Then field "sperrkonfiguration" has value "Zusatzpositionssperre"
Then field "sperrkonfigurationneu" has value "Zusatzpositionssperre"
Then field "sperrgrund" has value "Zusatzposition kaputt"
Then field "sperrgrundneu" has value "Zusatzposition kaputt"
And I set field "sperrkonfigurationneu" to "Zusatzpositionssperre"
Then field "sperrgrundneu" has value "Zusatzposition kaputt"
And I set field "sperrkonfigurationneu" to "Zusatzpositionshinweis"
Then field "sperrgrundneu" has value ""
And I set field "sperrkonfigurationneu" to "Zusatzpositionssperre"
Then field "sperrgrundneu" has value ""
And I close the current editor

Scenario: Create_locked_product
Given I open an editor "Artikel_D1" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set field "such" to "D1"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I set field "sperrgrundneu" to "Artikel kaputt"
And I save the current editor
And I close the current editor

Scenario: Delete_locked_product
Given I open an editor "Artikel_D1" from table "(Part):(Product)" with command "DELETE" for record "D1"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Select_filed_obj_lock_of_deleted_product
Given I query "such,ablagef" from table "(ObjectLock):(ObjectLock)" where "@ablageart=abgelegt;such=D1"
Then query has values
| such     | ablagef |
| D1       |   ja    |

Scenario: Select_filed_obj_lock_list_of_deleted_product
Given I query "such,ablagef" from table "(ObjectLock):(ObjectLockList)" where "@ablageart=abgelegt;such=D1"
Then query has values
| such     | ablagef |
| D1       |   ja    |

Scenario: Create_locked_supplementary_item
Given I open an editor "Zusatzposition_Z1" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "such" to "Z1"
And I set field "name" to "Zusatzposition"
And I set field "zptyp" to "AU/BE-Position,BV"
And I set field "sperrkonfigurationneu" to "Zusatzpositionssperre"
And I set field "sperrgrundneu" to "ZP kaputt"
And I save the current editor

Scenario: Delete_locked_supplementary_item
Given I open an editor "Zusatzposition_Z1" from table "(Part):(SupplementaryItem)" with command "DELETE" for record "Z1"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Select_filed_obj_lock_of_deleted_supplementary_item
Given I query "such,ablagef" from table "(ObjectLock):(ObjectLock)" where "@ablageart=abgelegt;such=Z1"
Then query has values
| such     | ablagef |
| Z1       |   ja    |

Scenario: Select_filed_obj_lock_list_of_deleted_supplementary_item
Given I query "such,ablagef" from table "(ObjectLock):(ObjectLockList)" where "@ablageart=abgelegt;such=Z1"
Then query has values
| such     | ablagef |
| Z1       |   ja    |

Scenario: Create_locked_product_P3
Given I open an editor "Product_P3" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "such" to "P3"
And I set field "name" to "Produkt 3"
And I set field "sperrkonfigurationneu" to "Artikelsperre"
And I set field "sperrgrundneu" to "Produkt kaputt"
And I save the current editor

Scenario: Unlock_product_P3
Given I open an editor "Product_P3" from table "(Part):(Product)" with command "UPDATE" for record "P3"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Scenario: Delete_product_P3
Given I open an editor "Product_P3" from table "(Part):(Product)" with command "DELETE" for record "P3"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Select_filed_obj_lock_of_deleted_product
Given I query "such,ablagef" from table "(ObjectLock):(ObjectLock)" where "@ablageart=abgelegt;such=P3"
Then query has values
| such     | ablagef |
| P3       |   ja    |

Scenario: Select_filed_obj_lock_list_of_deleted_product
Given I query "such,ablagef" from table "(ObjectLock):(ObjectLockList)" where "@ablageart=abgelegt;such=P3"
Then query has values
| such     | ablagef |
| P3       |   ja    |

Scenario: Create_locked_supplementary_item_Z3
Given I open an editor "Zusatzposition_Z3" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "such" to "Z3"
And I set field "name" to "Zusatzposition"
And I set field "zptyp" to "AU/BE-Position,BV"
And I set field "sperrkonfigurationneu" to "Zusatzpositionssperre"
And I set field "sperrgrundneu" to "ZP kaputt"
And I save the current editor

Scenario: Unlock_supplementary_item_Z3
Given I open an editor "Zusatzposition_Z3" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "Z3"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Scenario: Delete_supplementary_item_Z3
Given I open an editor "Zusatzposition_Z3" from table "(Part):(SupplementaryItem)" with command "DELETE" for record "Z3"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: Select_filed_obj_lock_of_deleted_supplementary_item
Given I query "such,ablagef" from table "(ObjectLock):(ObjectLock)" where "@ablageart=abgelegt;such=Z3"
Then query has values
| such     | ablagef |
| Z3       |   ja    |

Scenario: Select_filed_obj_lock_list_of_deleted_supplementary_item
Given I query "such,ablagef" from table "(ObjectLock):(ObjectLockList)" where "@ablageart=abgelegt;such=Z3"
Then query has values
| such     | ablagef |
| Z3       |   ja    |
