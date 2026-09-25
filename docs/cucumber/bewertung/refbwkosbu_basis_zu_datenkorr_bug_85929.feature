#  Autor            : uo
#  Verantwortlich   : uo

@persistent
Feature: korrekturskript zu bug 85929 

Background:
Given I set the fake date to "10.01.2002"

Scenario: Kostenbuchungsvorschlag aus einfachen zugangsbewertungen herstellen

And I post a receipt via ManualStockAdjustment for Product "E1A-VLI" and quantity "1" on StorageLocation "F2" with document "zugE1A-VLI1" and price "1.0"
And I post a receipt via ManualStockAdjustment for Product "E1A-VF" and quantity "1" on StorageLocation "F2" with document "zugE1A-VF1" and price "2.0"
And I post a receipt via ManualStockAdjustment for Product "E1A-VO" and quantity "1" on StorageLocation "F2" with document "zugE1A-VO1" and price "5.0"
And I post a receipt via ManualStockAdjustment for Product "E1A-VM" and quantity "1" on StorageLocation "F2" with document "zugE1A-VM1" and price "9.0"
And I post a receipt via ManualStockAdjustment for Product "E1A-VLM" and quantity "1" on StorageLocation "F2" with document "zugE1A-VLM1" and price "13.0"
And I post a receipt via ManualStockAdjustment for Product "E1A-ZO" and quantity "1" on StorageLocation "F2" with document "zugE1A-ZO1" and price "17.0"
And I post a receipt via ManualStockAdjustment for Product "E1A-HK" and quantity "1" on StorageLocation "F2" with document "zugE1A-HK1" and price "21.0"

And I post a receipt via ManualStockAdjustment for Product "E1A-VLI" and quantity "3" on StorageLocation "F1" with document "zugE1A-VLI2" and price "100"
And I post a receipt via ManualStockAdjustment for Product "E1A-VF" and quantity "3" on StorageLocation "F1" with document "zugE1A-VF2" and price "200"
And I post a receipt via ManualStockAdjustment for Product "E1A-VO" and quantity "3" on StorageLocation "F1" with document "zugE1A-VO2" and price "500"
And I post a receipt via ManualStockAdjustment for Product "E1A-VM" and quantity "3" on StorageLocation "F1" with document "zugE1A-VM2" and price "900"
And I post a receipt via ManualStockAdjustment for Product "E1A-VLM" and quantity "3" on StorageLocation "F1" with document "zugE1A-VLM2" and price "1300"
And I post a receipt via ManualStockAdjustment for Product "E1A-ZO" and quantity "3" on StorageLocation "F1" with document "zugE1A-ZO2" and price "1700"
And I post a receipt via ManualStockAdjustment for Product "E1A-HK" and quantity "3" on StorageLocation "F1" with document "zugE1A-HK2" and price "2100"


Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

