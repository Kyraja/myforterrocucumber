# *****************************************************************************
#  Verantwortlich : uo
#  Kontrolle      : hc
#  Funktion       : s. dateiname            
#
# *****************************************************************************
@persistent
Feature: Sperrkonfiguration-Plausis Verweissperre in Konto setzen (REWE-3552 REWE-3599 ...)

Background:
Given I set the fake date to "31.12.2002"


Scenario: Sperrverbot Verdichtung prüfen
# stammdaten dazu siehe minimal_sperrkonfig.edp im testbett
	Given I open an editor "Konto_sperr_verd_verboten" from table "(Account):(Account)" with command "UPDATE" for record "33000" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	  # 1822 Beim Verdichtungskonto nicht änderbar
	Then saving the current editor throws the exception "1822"
    And I close the current editor

	Given I open an editor "Konto_sperr_verd_pruef" from table "(Account):(Account)" with command "VIEW" for record "33000" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor
    
Scenario: Sperrverbot Geldtransit prüfen
# stammdaten dazu siehe minimal_sperrkonfig.edp im testbett
	Given I open an editor "mache_wirklich_gtrans_kto" from table "(Account):(Account)" with command "UPDATE" for record "14600" 	
	And I set field "karta" to "Geldtransit"
	And I set field "oprel" to "ja"
	And I set field "zaform" to "Lastschrift"
    And I save the current editor
    
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I set field "kenn" to "DI"
    And I set field "beleg" to "8888"
    And I set field "such" to "GTRANS1"
    And I set field "text" to "saldo verhindert sperre"
    And I create a new row at the end of the table
    And I set field "konto" to "14600" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "50000" in row 2
    And I set field "ewhbetr" to "1000" in row 2
    And I set field "kstelle" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor
    And I close the current editor

	Given I open an editor "Konto_sperr_gtrans_verboten" from table "(Account):(Account)" with command "UPDATE" for record "14600" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	  # 2927  Bei dieser Kontenart nicht erlaubt
	Then saving the current editor throws the exception "2928"
    And I close the current editor

    Given I open an editor "Buchungsstorno" from table "(Entry):(Entry)" with command "REVERSAL" for record "GTRANS1"
    And I set field "text" to "saldo auf 0, dann kann gesperrt werden"
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor

	Given I open an editor "Konto_sperr_gtrans_erlaubt" from table "(Account):(Account)" with command "UPDATE" for record "14600" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
    And I save the current editor

	Given I open an editor "Konto_sperr_gtrans_erlaubt" from table "(Account):(Account)" with command "VIEW" for record "14600" 	
    Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor

    
Scenario Outline: Sperrverbot Rundungsdiff. prüfen plausi
# stammdaten dazu siehe minimal_sperrkonfig.edp im testbett
	Given I open an editor "Konto_sperr_rdiff_kto_verboten" from table "(Account):(Account)" with command "UPDATE" for record "<konto>" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	  # 2927  Bei dieser Kontenart nicht erlaubt
	Then saving the current editor throws the exception "2927"
    And I close the current editor

	# alle relevanten konten der std.konfig 
	Examples:
    | konto |	
    | 68820 |
    | 48420 |


Scenario Outline: Sperrverbot Rundungsdiff. prüfen view
	Given I open an editor "Konto_sperr_rdiff_kto_pruef" from table "(Account):(Account)" with command "VIEW" for record "<konto>" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor

	Examples:
    | konto |	
    | 68820 |
    | 48420 |


Scenario: Konto in Std-PG ggue Std-Fibu-Konto aendern 
	# std-pg
	Given I open an editor "Konto_in_std-PG_eintragen" from table "(Company):(ProductGroup)" with command "UPDATE" for record "66" 	
	And I set field "pgerlo" to "45000"
    And I save the current editor


Scenario Outline: Sperrverbot Konto in Standardkontierung plausibilisieren
	Given I open an editor "Konto_in_std_kontier_sperr_verboten" from table "(Account):(Account)" with command "UPDATE" for record "<konto>" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	Then saving the current editor throws the exception "2203"
    And I close the current editor

	# alle relevanten konten der std.konfig 
	Examples:
    | konto |	
    | 54000 |
    | 16000 |
    | 44000 | kommt schon in der PG 66 vor, deshalb vorherige, andere fehlermeldung die nicht mit diesem Outline moeglich ist.
    | 68800 |
    | 48400 |

Scenario Outline: Sperrverbot Konto in Standardkontierung views
	Given I open an editor "Konto_sperr_rdiff_kto_pruef" from table "(Account):(Account)" with command "VIEW" for record "<konto>" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor

	Examples:
    | konto |	
    | 54000 |
    | 16000 |
    | 44000 |
    | 68800 |
    | 48400 |

    
Scenario: Sperrverbot Konto in Std-WG und beliebiger WG prüfen

	# std
	Given I open an editor "Konto_in_WG_eintragen" from table "(Company):(MaterialGroup)" with command "UPDATE" for record "55" 	
	And I set field "bvfertinfert" to "50002"
    And I save the current editor

	Given I open an editor "Konto_in_Std-WG" from table "(Account):(Account)" with command "UPDATE" for record "50002" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	Then saving the current editor throws the exception
	""" 
	Sperre nicht möglich, da das Objekt in einer Warengruppe verwendet wird. Es kommt in der Warengruppe 55 vor.
	"""
    And I close the current editor

	Given I open an editor "Kontopruef" from table "(Account):(Account)" with command "VIEW" for record "50002" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor
    
    # nicht-std
	Given I open an editor "Konto_in_NICHT_Std-WG" from table "(Account):(Account)" with command "UPDATE" for record "50198" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	# geht nur so, wegen c-implemtierung:
	Then saving the current editor throws the exception
	""" 
	Sperre nicht möglich, da das Objekt in einer Warengruppe verwendet wird. Es kommt in der Warengruppe 56 vor.
	"""
    And I close the current editor

	Given I open an editor "Kontopruef" from table "(Account):(Account)" with command "VIEW" for record "50198" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor


Scenario Outline: Sperrverbot hier die Std-Konten der Std-WG in diesem Test 55 

	Given I open an editor "Konto_in_Std-WG" from table "(Account):(Account)" with command "UPDATE" for record "<konto>" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	Then saving the current editor throws the exception
	""" 
	Sperre nicht möglich, da das Objekt in einer Warengruppe verwendet wird. Es kommt in der Warengruppe 55 vor.
	"""
    And I close the current editor

	Examples:
    | konto |	
    | 10000 |
    | 50000 |

Scenario Outline: Sperrverbot hier Konten aus der WG 56 

	Given I open an editor "Konto_in_Std-WG" from table "(Account):(Account)" with command "UPDATE" for record "<konto>" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	Then saving the current editor throws the exception
	""" 
	Sperre nicht möglich, da das Objekt in einer Warengruppe verwendet wird. Es kommt in der Warengruppe 56 vor.
	"""
    And I close the current editor

	Examples:
    | konto |	
    | 10900 |
    | 13700 |
    |  7aoz |
    |  5aoz |
	| 64800 |    


Scenario: Sperrverbot Konto in Std-PG und beliebiger PG prüfen

	# std
	Given I open an editor "Konto_in_std-PG_eintragen" from table "(Company):(ProductGroup)" with command "UPDATE" for record "66" 	
	And I set field "pgerlo" to "45000"
    And I save the current editor

	Given I open an editor "Konto_in_Std-PG" from table "(Account):(Account)" with command "UPDATE" for record "45000" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	Then saving the current editor throws the exception
	""" 
	Sperre nicht möglich, da das Objekt in einer Produktgruppe verwendet wird. Es kommt in der Produktgruppe 66 vor.
	"""
    And I close the current editor

	Given I open an editor "Kontopruef" from table "(Account):(Account)" with command "VIEW" for record "45000"
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor
    
	# nicht-std
	Given I open an editor "NICHT-PG-ANLEGEN" from table "(Company):(ProductGroup)" with command "COPY" for record "66" 	
	And I set field "nummer" to "67s"
	And I set field "bvzumaschkostvar" to "48180"
    And I save the current editor
    
	Given I open an editor "Konto_in_NICHT_Std-PG" from table "(Account):(Account)" with command "UPDATE" for record "48180" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	# geht nur so, wegen c-implemtierung:
	Then saving the current editor throws the exception
	""" 
	Sperre nicht möglich, da das Objekt in einer Produktgruppe verwendet wird. Es kommt in der Produktgruppe 67s vor.
	"""
    And I close the current editor

	Given I open an editor "Kontopruef" from table "(Account):(Account)" with command "VIEW" for record "48180" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor


Scenario: Sperrverbot Rundungsdifferenzkonto in Korekonfig

	Given I open an editor "Rdiff-Konto-anlegen" from table "(Account):(Account)" with command "NEW" for record "" 	
	And I set field "nummer" to "68263"
	And I set field "such" to "RDIFFSTAT"
	And I set field "name" to "stat. runddiff konto"
	And I set field "gv" to "ja"
	And I set field "stata" to "Kostenrechnung"
    And I save the current editor

	# std
	Given I open an editor "Konto_in_Korekonfig_eintragen" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "KOREKONF" 	
	And I set field "ilvko" to "RDIFFSTAT"
    And I save the current editor
    
	Given I open an editor "Konto_in_korekonfig_sperr_verboten" from table "(Account):(Account)" with command "UPDATE" for record "RDIFFSTAT" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	Then saving the current editor throws the exception "3277"
    And I close the current editor

	Given I open an editor "Konto_sperr_rdiff_kto_pruef" from table "(Account):(Account)" with command "VIEW" for record "RDIFFSTAT" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor


Scenario: Sperrverbot Konto in beliebiger Fertigungskontengruppe

 # in korekonfig
	Given I open an editor "Konto_in_korekonfig_fertig.kto.grp_sperr_verboten" from table "(Account):(Account)" with command "UPDATE" for record "88101" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	# fehlermeldung 3278
	Then saving the current editor throws the exception
	"""
	Sperre nicht möglich, da das Objekt in einer Fertigungskontengruppe verwendet wird. Es kommt in der Fertigungskontengruppe 100 vor.
	"""
    And I close the current editor

	Given I open an editor "Konto_sperr_rdiff_kto_pruef" from table "(Account):(Account)" with command "VIEW" for record "88101" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor

 # in beliebiger gruppe
	Given I open an editor "Fertigungskosten-Konto-anlegen" from table "(Account):(Account)" with command "COPY" for record "88101" 	
	And I set field "nummer" to "88119"
	And I set field "such" to "FERTKO119"
    And I save the current editor

    Given I open an editor "kopiere_fert.ko.gruppe" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "COPY" for record "100"
	And I set field "nummer" to "119"
	And I set field "such" to "KTOGR119"
	And I set field "entlast" to "FERTKO119" in row 1
    And I save the current editor

	Given I open an editor "Konto_in_korekonfig_fertig.kto.grp_sperr_verboten" from table "(Account):(Account)" with command "UPDATE" for record "FERTKO119" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	# fehlermeldung 3278
	Then saving the current editor throws the exception
	"""
	Sperre nicht möglich, da das Objekt in einer Fertigungskontengruppe verwendet wird. Es kommt in der Fertigungskontengruppe 119 vor.
	"""
    And I close the current editor

	Given I open an editor "Konto_sperr_rdiff_kto_pruef" from table "(Account):(Account)" with command "VIEW" for record "FERTKO119" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor


Scenario: Sperrverbot Konto in Anlagenbuchhaltungskonfiguration prüfen
	Given I open an editor "Konto_in_std_kontier_sperr_verboten" from table "(Account):(Account)" with command "UPDATE" for record "68950" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	Then saving the current editor throws the exception "3324"
    And I close the current editor

	Given I open an editor "Konto_sperr_rdiff_kto_pruef" from table "(Account):(Account)" with command "VIEW" for record "68950" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor


Scenario: Sperrverbot Konto in beliebiger Fertigungskontengruppe
 # in beliebiger steuerregel
	Given I open an editor "Konto_in_steueregel_dann_sperr_verboten" from table "(Account):(Account)" with command "UPDATE" for record "14050" 	
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"

	# fehlermeldung 3523
	# bei einer änderung der identnummer der steuerregel muss diese stelle leider mitgepflegt werden :(
	# wenn es unterträglich wird kann man aus der datei ein template machen und müsste vorher die passende identnummer selektien 
	#  (edpexport) und in die fehlermeldungsvorlage eintragen.
	 
	Then saving the current editor throws the exception
	"""
	Sperre nicht möglich, da das Objekt in einer Steuerregel verwendet wird. Es kommt in der Steuerregel 6008 vor.
	"""
    And I close the current editor

	Given I open an editor "Konto_sperr_sts_kto_pruef" from table "(Account):(Account)" with command "VIEW" for record "14050" 	
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor

Scenario: Konto aus leer gesperrt neu anlegen
	Given I open an editor "Konto neu1" from table "(Account):(Account)" with command "NEW" for record "" 	
	And I set field "nummer" to "475632"
	And I set field "such" to "leerneu"
	And I set field "name" to "aus leer gleich gesperrt"
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
    And I save the current editor

	# hat das anlegen und sperren auch wirklich geklappt..?
	Given I open an editor "Konto_neu1_pruef" from table "(Account):(Account)" with command "VIEW" for record "475632" 	
    Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor
	
Scenario: Konto als Kopie gesperrt neu anlegen
	Given I open an editor "Konto kopie1" from table "(Account):(Account)" with command "COPY" for record "44000" 	
	And I set field "nummer" to "475633"
	And I set field "such" to "copyneu"
	And I set field "name" to "in kopie gleich gesperrt"
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
    And I save the current editor

	# hat das anlegen und sperren auch wirklich geklappt..?
	Given I open an editor "Konto_neu1_pruef" from table "(Account):(Account)" with command "VIEW" for record "475633" 	
    Then field "sperrkonfigurationneu" has value "Standard-Kontosperre"
    And I close the current editor
