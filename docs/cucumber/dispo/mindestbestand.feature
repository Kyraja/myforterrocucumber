@persistent
Feature: FDA-4063_Mindestbestandsauffueller

# FDA-4063
Scenario: Terminierung Mindestbestandsauffüller
And I set the fake date to "15.09.2022"

#Given I set StorageQuantity to zero for Product "MINDESTLOS" on StorageLocation "F1"

# Artikel mit Mindestbestand und Losgroesse
Given I open an editor "M2INDESTLOS" from table "(Part):(Product)" with command "STORE" for record "M2INDESTLOS"
And I set fields
    | such      | M2INDESTLOS                   |
    | namebspr  | Mindestbestand und Losgröße   |
    | mindest   | 50                            |
    | losgr     | 150                           |
And I save the current editor

# negativer Bestand
#Given I post an issue via ManualStockAdjustment "Abgang" for Product "MINDESTLOS" and quantity "50" on StorageLocation "F1" with document "Abgang01"

# Bedarfe anlegen
Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | KUNDE1    |
And I append rows
    | artikel        | mge   | wtterm    |
    | M2INDESTLOS    | 100   | +50       |
    | M2INDESTLOS    | 100   | +60       |
And I save the current editor

And I run Scheduling

# Terminierung und Zuordnung pruefen
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "M2INDESTLOS"
And I press start
And I press button "buresbesch" in row 2
Then table has values
    | tterm         | twterm        | buresbesch            | zuomge    | zugang    | abgang    | vart              |
    |               |               |                       |           |           |           | Lager             |
    | 08.09.2022    | 04.11.2022    | icon:transfer_plus    | 150       | 150       |           | Fremdbeschaffung  |
    | 04.11.2022    | 04.11.2022    | icon:transfer_minus   | 100       |           | 100       | Auftrag           |
    | 14.11.2022    | 14.11.2022    |                       |           | 150       |           | Fremdbeschaffung  |
    | 14.11.2022    | 14.11.2022    | icon:transfer_minus   | 50        |           | 100       | Auftrag           |
And I press button "buresbesch" in row 4
Then table has values
    | tterm         | twterm        | buresbesch            | zuomge    | zugang    | abgang    | vart              |
    |               |               | icon:transfer_minus   | 50        |           |           | Lager             |
    | 08.09.2022    | 04.11.2022    |                       |           | 150       |           | Fremdbeschaffung  |
    | 04.11.2022    | 04.11.2022    |                       |           |           | 100       | Auftrag           |
    | 14.11.2022    | 14.11.2022    | icon:transfer_plus    | 100       | 150       |           | Fremdbeschaffung  |
    | 14.11.2022    | 14.11.2022    | icon:transfer_minus   | 50        |           | 100       | Auftrag           |
And I close the current editor

Scenario: Terminierung negativer Lagerbestand auffüllen
And I set the fake date to "15.09.2022"

# Artikel mit Mindestbestand und Losgroesse
Given I open an editor "MINDESTLOS" from table "(Part):(Product)" with command "STORE" for record "MINDESTLOS"
And I set fields
    | such      | MINDESTLOS                    |
    | namebspr  | Losgröße                      |
    | mindest   | 0                             |
    | losgr     | 150                           |
And I save the current editor

Given I set StorageQuantity to zero for Product "MINDESTLOS" on StorageLocation "F1"

# negativer Bestand
Given I post an issue via ManualStockAdjustment "Abgang" for Product "MINDESTLOS" and quantity "50" on StorageLocation "F1" with document "Abgang01"

# Bedarfe anlegen
Given I open an editor "Auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | KUNDE1    |
And I append rows
    | artikel        | mge   | wtterm    |
    | MINDESTLOS     | 100   | +50       |
    | MINDESTLOS     | 100   | +60       |
And I save the current editor

And I run Scheduling

# Terminierung und Zuordnung pruefen
Given I open the infosystem "PLANKARTE"
And I set field "kart" to "MINDESTLOS"
And I press start
And I press button "buresbesch" in row 2
Then table has values
    | tterm         | twterm        | buresbesch            | zuomge    | zugang    | abgang    | vart              |
    |               |               | icon:transfer_minus   | 50        |           | 50        | Lager             |
    | 08.09.2022    | 04.11.2022    | icon:transfer_plus    | 150       | 150       |           | Fremdbeschaffung  |
    | 04.11.2022    | 04.11.2022    | icon:transfer_minus   | 100       |           | 100       | Auftrag           |
    | 14.11.2022    | 14.11.2022    |                       |           | 150       |           | Fremdbeschaffung  |
    | 14.11.2022    | 14.11.2022    |                       |           |           | 100       | Auftrag           |
And I press button "buresbesch" in row 4
Then table has values
    | tterm         | twterm        | buresbesch            | zuomge    | zugang    | abgang    | vart              |
    |               |               |                       |           |           | 50        | Lager             |
    | 08.09.2022    | 04.11.2022    |                       |           | 150       |           | Fremdbeschaffung  |
    | 04.11.2022    | 04.11.2022    |                       |           |           | 100       | Auftrag           |
    | 14.11.2022    | 14.11.2022    | icon:transfer_plus    | 100       | 150       |           | Fremdbeschaffung  |
    | 14.11.2022    | 14.11.2022    | icon:transfer_minus   | 100       |           | 100       | Auftrag           |
And I close the current editor
