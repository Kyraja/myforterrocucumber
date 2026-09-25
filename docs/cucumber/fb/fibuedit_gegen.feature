@persistant
Feature: Edit of the contraAccount in manual booking
Background:
Given I set the fake date to "02.01.2003"

Scenario: Edit 


# Manuelle Buchungen: Gegenkonto bei einer Personenkontenbuchung

    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
  	And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor


   Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for record "1"   
	Then field "gegen" has value "44000,38050" in row 1
    Then field "gegen" has value "K 1" in row 2
    Then field "gegen" has value "K 1" in row 3
    And I close the current editor
 
  # Manuelle Buchungen: gegen1 editieren / gegenfix editieren
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "gegen1" to "44000" in row 2
    And I set field "gegen1" to "k 1" in row 2
    Then field "gegenfix" has value "ja" in row 2
    And I set field "gegenfix" to "nein" in row 2
    Then field "gegen1" has value "" in row 2
    Then field "gegen2" has value "" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    
 # Manuelle Buchungen: gegen2 editieren, so dass eine L�cke entsteht  
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "gegen2" to "54000" in row 2
    Then saving the current editor throws the exception "10179"
    And I close the current editor
    
 # Manuelle Buchungen: gegen1 mit nicht in der Buchung vorhandenem Konto editieren  
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "gegen1" to "54000" in row 2
    Then saving the current editor throws the exception "10305"
    And I close the current editor    
 
   # Manuelle Buchungen: gegen1 leeren nachdem es automatisch gef�llt wurde und dann mit neuem Wert setzen
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "gegen1" to "K 1" in row 2
    Then field "gegenfix" has value "ja" in row 2  
    And I set field "gegen1" to "" in row 2
    Then field "gegenfix" has value "nein" in row 2  
    And I set field "gegenfix" to "ja" in row 2
    Then saving the current editor throws the exception "10306"
    And I set field "gegen1" to "K 1" in row 2
    Then field "gegenfix" has value "ja" in row 2    
    And I set field "gegen2" to "44000" in row 2
    Then field "gegenfix" has value "ja" in row 2    
    And I set field "gegen2" to "" in row 2
    Then field "gegenfix" has value "ja" in row 2   
    And I set field "gegen1" to "" in row 2
    Then field "gegenfix" has value "nein" in row 2    
    And I set field "gegen1" to "44000" in row 2
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
      
	# überpr�fen des manuell gesetzen Feldes    
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for record "3"   
    Then field "gegen1" has value "44000" in row 2
    And I close the current editor
       
    # Manuelle Buchungen: gegen1 manuell setzen
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "02400" in row 1
    And I set field "ewsbetr" to "10" in row 1
    And I set field "gegen1" to "03990" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "02500" in row 2
    And I set field "ewsbetr" to "10" in row 2
    And I set field "gegen1" to "03990" in row 2
    And I create a new row at the end of the table
    And I set field "konto" to "03990" in row 3
    And I set field "ewhbetr" to "20" in row 3
    And I set field "gegen1" to "02400" in row 3
    And I set field "gegen2" to "02500" in row 3
    And I create a new row at the end of the table   
    And I set field "konto" to "02600" in row 4
    And I set field "ewsbetr" to "15" in row 4
    And I set field "gegen1" to "03992" in row 4
    And I create a new row at the end of the table
    And I set field "konto" to "03992" in row 5
    And I set field "ewhbetr" to "15" in row 5
    And I set field "gegen1" to "02600" in row 5
    And I set field "gegen2" to "02600" in row 5
    Then saving the current editor throws the exception "1534"
    And I set field "gegen2" to "" in row 5
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
      
     # Manuelle Buchungen (5): Buchung neu mit Vorlage
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "COPY" for record "4"
    And I create a new row at the end of the table
    And I set field "konto" to "02700" in row 6
    And I set field "ewsbetr" to "10" in row 6
    And I set field "gegen1" to "03990" in row 6
    And I create a new row at the end of the table
    And I set field "konto" to "03990" in row 7
    And I set field "ewhbetr" to "10" in row 7
    And I set field "gegen1" to "02700" in row 7
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor
     
    # Manuelle Buchungen (6) mit Steuererg�nzung
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "K 1" in row 1
    And I set field "gegen1" to "44000" in row 1
    And I set field "gegen2" to "43000" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "10" in row 2
    And I set field "kstelle" to "100" in row 2
    And I set field "gegen1" to "K 1" in row 2
    And I create a new row at the end of the table
    And I set field "konto" to "43000" in row 3
    And I set field "kstelle" to "100" in row 3
    And I set field "ewsbetr" to "15" in row 3
    And I set field "gegen1" to "K 1" in row 3
    And I respond with answer "Ja" to the dialog with id "1941"
    And I save the current editor
    
    # Manuelle Buchungen (6), Gegenkonten ändern 
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "6"
    And I set field "gegen1" to "43000" in row 2
    Then field "gegenfix" has value "ja" in row 2
    And I set field "gegen1" to "44000" in row 3
    Then field "gegenfix" has value "ja" in row 3
    And I respond with answer "ja" to the dialog with id "583"
    And I save the current editor
  
  	# Ueberpruefen der geaenderten Felder 
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for record "6"   
    Then field "gegen1" has value "43000" in row 2
    Then field "gegenfix" has value "ja" in row 2
    Then field "gegen1" has value "44000" in row 3
    Then field "gegenfix" has value "ja" in row 3
    And I close the current editor
      
    # Manuelle Buchungen (6), Gegenkonten ändern 
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "6"
    And I set field "gegen1" to "" in row 2
    And I set field "gegen1" to "" in row 3
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor  
 
   	# Ueberpruefen der geaenderten Felder 
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for record "6"   
    Then field "gegen1" has value "K 1" in row 2
    Then field "gegenfix" has value "nein" in row 2
    Then field "gegen1" has value "K 1" in row 3
    Then field "gegenfix" has value "nein" in row 3
    And I close the current editor
      
    # Manuelle Buchungen (5) - Sachkontobuchung, Gegenkonten ändern 
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "5"
    And I set field "gegen2" to "" in row 2
    Then field "gegenfix" has value "ja" in row 2
    And I set field "gegen1" to "" in row 4
    And I set field "gegen2" to "" in row 4
    Then field "gegenfix" has value "nein" in row 4
    And I respond with answer "ja" to the dialog with id "583"
    And I save the current editor
    
   # Ueberpruefen der geaenderten Felder 
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for record "5"   
    Then field "gegen1" has value "03990" in row 2
    Then field "gegen2" has value "" in row 2
    Then field "gegenfix" has value "ja" in row 2
    Then field "gegen1" has value "03990" in row 4
    Then field "gegen2" has value "03992" in row 4
    Then field "gegenfix" has value "nein" in row 4
    And I close the current editor
    
    #
    # And I'm logged in with password "annette"
    Scenario: Wartungseingriff: editieren von Konten in einer Buchung
    Given I'm logged in with password "annette"
    # ändern der manuellen Buchung 4 (mit manuell gesetzten Gegenkonten) in Wartung, führt zu einer Fehlermeldung, da die Gegenkonten nicht geändert werden
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "4"
    And I set field "konto" to "03990" in row 4
    Then saving the current editor throws the exception "10305"
#    And I set field "gegen1" to "03990" in row 5
#    And I respond with answer "Ja" to the dialog with id "583"
    And I close the current editor
    
    # ändern der manuellen Buchung 6 (ohne manuell gesetzten Gegenkonten) in Wartung
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "6"
    And I set field "konto" to "18100" in row 1
    And I respond with answer "Ja" to the dialog with id "583"
    And I save the current editor
    
    
    Scenario: Dauerbuchungen
    Given I'm logged in with password "sy"
    # Editieren von Dauerbuchungsvorlagen
    # Manuelle Buchungen: gegen1 leeren nachdem es automatisch gef�llt wurde und dann mit neuem Wert setzen
    Given I open an editor "Buchung" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "k 1" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "44000" in row 2
    And I set field "ewhbetr" to "100" in row 2
    And I set field "kstelle" to "100" in row 2
    And I respond with answer "Ja" to the dialog with id "7709"
    And I save the current editor
    # Dauerbuchungsvorlagen ansehen: Gegenkonten sitzen
    Given I open an editor "Buchung" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "VIEW" for record "1"
    Then field "gegen" has value "44000,38050" in row 1
    Then field "gegen" has value "K 1" in row 2
    Then field "gegen" has value "K 1" in row 3
    And I close the current editor
    # Dauerbuchungsvorlagen ändern: Gegenkonten entfernt
    Given I open an editor "Buchung" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "UPDATE" for record "1"
    Then field "gegen" has value "" in row 1
    Then field "gegen" has value "" in row 2
    Then field "gegen" has value "" in row 3
    And I close the current editor
    # Dauerbuchungsvorlagen ansehen: Gegenkonten sitzen (neu ermittelt)
    Given I open an editor "Buchung" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "VIEW" for record "1"
    Then field "gegen" has value "44000,38050" in row 1
    Then field "gegen" has value "K 1" in row 2
    Then field "gegen" has value "K 1" in row 3
    And I close the current editor
    # Dauerbuchung gegen1 manuell setzen
    Given I open an editor "Buchung" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "02400" in row 1
    And I set field "ewsbetr" to "10" in row 1
    And I set field "gegen1" to "03990" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "02500" in row 2
    And I set field "ewsbetr" to "10" in row 2
    And I set field "gegen1" to "03990" in row 2
    And I create a new row at the end of the table
    And I set field "konto" to "03990" in row 3
    And I set field "ewhbetr" to "20" in row 3
    And I set field "gegen1" to "02400" in row 3
    And I set field "gegen2" to "02500" in row 3
    And I create a new row at the end of the table   
    And I set field "konto" to "02600" in row 4
    And I set field "ewsbetr" to "15" in row 4
    And I set field "gegen1" to "03992" in row 4
    And I create a new row at the end of the table
    And I set field "konto" to "03992" in row 5
    And I set field "ewhbetr" to "15" in row 5
    And I set field "gegen1" to "02600" in row 5
    And I set field "gegen2" to "02600" in row 5
    Then saving the current editor throws the exception "1534"
    And I set field "gegen2" to "" in row 5
    And I respond with answer "Ja" to the dialog with id "7709"
    And I save the current editor
    # Dauerbuchungsvorlagen ansehen: Gegenkonten sitzen (neu ermittelt)
    Given I open an editor "Buchung" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "VIEW" for record "2"
    Then field "gegen1" has value "03990" in row 1
    Then field "gegen2" has value "" in row 1
    Then field "gegenfix" has value "ja" in row 1
    Then field "gegen1" has value "03990" in row 2
    Then field "gegen2" has value "" in row 2
    Then field "gegenfix" has value "ja" in row 2
    Then field "gegen1" has value "02400" in row 3
    Then field "gegen2" has value "02500" in row 3
    Then field "gegenfix" has value "ja" in row 3
    Then field "gegen1" has value "03992" in row 4
    Then field "gegen2" has value "" in row 4
    Then field "gegenfix" has value "ja" in row 4
    Then field "gegen1" has value "02600" in row 5
    Then field "gegen2" has value "" in row 5
     Then field "gegenfix" has value "ja" in row 5
    And I close the current editor
    
    # Dauerbuchung mit Sachkonten, gegen-Felder automatisch f�llen
    Given I open an editor "Buchung" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "konto" to "02400" in row 1
    And I set field "ewsbetr" to "10" in row 1
    And I create a new row at the end of the table
    And I set field "konto" to "02500" in row 2
    And I set field "ewsbetr" to "10" in row 2
    And I create a new row at the end of the table
    And I set field "konto" to "03990" in row 3
    And I set field "ewhbetr" to "20" in row 3
    And I create a new row at the end of the table   
    And I set field "konto" to "02600" in row 4
    And I set field "ewsbetr" to "15" in row 4
    And I create a new row at the end of the table
    And I set field "konto" to "03992" in row 5
    And I set field "ewhbetr" to "15" in row 5
    And I respond with answer "Ja" to the dialog with id "7709"
    And I save the current editor
    # Ergebnis überpr�fen
    Given I open an editor "Buchung" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "VIEW" for record "3"
    Then field "gegen1" has value "03990" in row 1
    Then field "gegen2" has value "03992" in row 1
    Then field "gegenfix" has value "nein" in row 1
    Then field "gegen1" has value "03990" in row 2
    Then field "gegen2" has value "03992" in row 2
    Then field "gegenfix" has value "nein" in row 2
    Then field "gegen1" has value "02400" in row 3
    Then field "gegen2" has value "02500" in row 3
    Then field "gegen3" has value "02600" in row 3
    Then field "gegenfix" has value "nein" in row 3
    Then field "gegen1" has value "03990" in row 4
    Then field "gegen2" has value "03992" in row 4
    Then field "gegenfix" has value "nein" in row 4
    Then field "gegen1" has value "02400" in row 5
    Then field "gegen2" has value "02500" in row 5
    Then field "gegen3" has value "02600" in row 5
     Then field "gegenfix" has value "nein" in row 5
    And I close the current editor
    
Scenario: automatischeBuchungen
#
# Einkaufs Rechnung anlegen und verbuchen
#
	Given I open an editor "rechnung-012" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
	And I set field "lief" to "1"
	And I set field "num4" to "001-RE"
	And I set field "fakt" to "ja"
	And I set field "ueb" to "nein"
	And I set field "vom" to "31.1.2002"
	And I set field "budat" to "31.1.2002"
	And I set field "ueb" to "ja"
	And I create a new row at the end of the table
	And I set field "artex" to "E1" in row 1
	And I set field "mge" to "012" in row 1
	And I set field "preis" to "012" in row 1
	And I set field "kstelle" to "100" in row 1
	And I respond with answer "Ja" to the dialog with id "4841"
	And I save the current editor
	And I close the current editor
# REWE-2440 : Editieren aller Buchungszeilen führt zu einer Diagnosemeldung	
    Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "UPDATE" for record "7"
    And I set field "gegen1" to "54000" in row 1
    Then field "gegenfix" has value "ja" in row 1
    And I set field "gegen1" to "L 1" in row 2
    Then field "gegenfix" has value "ja" in row 2
    And I set field "gegen1" to "L 1" in row 3
    Then field "gegenfix" has value "ja" in row 3
    And I respond with answer "ja" to the dialog with id "583"
    And I save the current editor


