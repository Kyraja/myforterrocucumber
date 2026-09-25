# *****************************************************************************
#  Name             : vrgstrgl_laenderabhaengig_in_service_000_basis.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbereitung der Stammdaten
#
#
# *****************************************************************************
@persistent
Feature:  vrgstrgl_laenderabhaengig_in_service_000_basis.feature
Background: XXX


@FALL-STAMM-KU_LI
Scenario Outline: Lieferant und Kunde

Given I open an editor "kulie" from table "<table>" with command "COPY" for record "001"
And I set fields
 | nummer | <nummer> |
And I save the current editor
Examples:
 | nummer | table                 |
 | 10010  | (Vendor):(Vendor)     |
 | 10011  | (Vendor):(Vendor)     |
 | 40002  | (Vendor):(Vendor)     |
 | 60013  | (Vendor):(Vendor)     |
 | 840015 | (Vendor):(Vendor)     |
 | 840020 | (Vendor):(Vendor)     |
 | 2011   | (Vendor):(Vendor)     |
 | 2012   | (Vendor):(Vendor)     |
 | 050    | (Customer):(Customer) |
 | 051    | (Customer):(Customer) |
 | 20587  | (Customer):(Customer) |
 | 20586  | (Customer):(Customer) |
 | 40001  | (Customer):(Customer) |
 | 40002  | (Customer):(Customer) |
 | 2011   | (Customer):(Customer) |
 | 70008  | (Customer):(Customer) |
 | 2012   | (Customer):(Customer) |
################################################################################
