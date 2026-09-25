@persistant
Feature: Edit of the transactionFigures
Background:
Given I set the fake date to "02.01.2003"
#
Scenario: Edit_EntryTemplateDownPaymentInvoice
Given I'm logged in with password "sy"
Given I open an editor "VlbView" from table "(EntryTemplate):(EntryTemplateDownPaymentInvoice)" with command "VIEW" for record "+1ANZREEK" 	
#
#
Given I'm logged in with password "annette"
Given I open an editor "VlbDel" from table "(EntryTemplate):(EntryTemplateDownPaymentInvoice)" with command "DELETE" for record "+1ANZREEK" 	
And I save the current editor
And I switch the current editor to editor "VlbView"
And I close the current editor
