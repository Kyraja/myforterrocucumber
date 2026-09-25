 @persistant
Feature: Deleting and Adding a Standard Chart of Account
Background:
Given I set the fake date to "2.2.2002"

Scenario: deleting_Standard_chart_of_account_sy
 
Given I open an editor "StCA1" from table "(Company):(StandardChartOfAccounts)" with command "DELETE" for record "FIBU"
And saving the current editor throws the exception "111"
And I close the current editor

Scenario: deleting_Standard_chart_of_account_w

Given I'm logged in with password "annette"
 
Given I open an editor "StCA2" from table "(Company):(StandardChartOfAccounts)" with command "DELETE" for record "FIBU"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: new_Standard_chart_of_account_w
 
Given I open an editor "StCA3" from table "(Company):(StandardChartOfAccounts)" with command "NEW" for record ""
    Then field "nummer" is modifiable
    Then field "such" is modifiable
    Then field "verbrdiff" is modifiable
    Then field "posnsammel" is modifiable
    Then field "ekposnsammel" is modifiable
    Then field "vkposnsammel" is modifiable
    
    Then field "verb" is modifiable
    Then field "ford" is modifiable
    Then field "sverb" is modifiable
    Then field "sford" is modifiable
    Then field "dkurs" is modifiable
    Then field "hdkurs" is modifiable
    Then field "drund" is modifiable
    Then field "hdrund" is modifiable
    
    Then field "fibuok" is not modifiable

    Then field "kasse" is modifiable
    Then field "hbkb" is modifiable
    Then field "aufw" is modifiable
    Then field "erlo" is modifiable
    Then field "verdku" is modifiable
    Then field "verdli" is modifiable
    Then field "verdma" is modifiable
    
    Then field "wgruppe" is modifiable    
    Then field "pgruppe" is modifiable    
    
    Then field "koeuro" is not modifiable
    Then field "kogveuro" is not modifiable
    Then field "kseuro" is not modifiable
    Then field "kteuro" is not modifiable
    Then field "strest" is not modifiable
    Then field "trrest" is not modifiable
    Then field "stsnull" is modifiable
    Then field "stseins" is not modifiable     
# Editierbarkeit Suchwortk�rzel     
    Then field "swaabg" is modifiable
    Then field "swaumb" is modifiable
    Then field "swbilktw" is modifiable
    Then field "swbewert" is modifiable
    Then field "swfl" is modifiable
    Then field "swilv" is modifiable
    Then field "swkimp" is modifiable
    Then field "sweuro" is modifiable   
    Then field "swek" is modifiable
    Then field "swvk" is modifiable
    Then field "swstd" is modifiable
    Then field "swstbu" is modifiable
    Then field "swfbbu" is modifiable
    Then field "swzv" is modifiable
    Then field "swcashen" is modifiable
    Then field "btvk" is modifiable  
    Then field "btek" is modifiable
    Then field "btzv" is modifiable
    Then field "btzvumbew" is modifiable
    Then field "btzvverr" is modifiable
    Then field "bgbewert" is modifiable
    Then field "bgeuro" is modifiable
    Then field "bgfl" is modifiable
    Then field "bgilv" is modifiable  
    Then field "swcashbo" is modifiable
    Then field "kokurz" is modifiable 

# Editierbarkeit Journalkennzeichen Kopf     
    Then field "jdikenn" is modifiable
    Then field "jdiname" is modifiable
    Then field "jekkenn" is modifiable
    Then field "jekname" is modifiable
    Then field "jvkkenn" is modifiable
    Then field "jvkname" is modifiable
    Then field "jkokenn" is modifiable
    Then field "jkoname" is modifiable   
    Then field "jilkenn" is modifiable
    Then field "jilname" is modifiable
    Then field "jkafaum" is modifiable
    Then field "jnafaum" is modifiable
    Then field "jkzu" is modifiable
    Then field "jnzu" is modifiable
    Then field "jkafa" is modifiable
    Then field "jnafa" is modifiable  
    Then field "jkahkab" is modifiable
    Then field "jnahkab" is modifiable
    Then field "jkafaab" is modifiable
    Then field "jnafaab" is modifiable
    Then field "jkahkum" is modifiable
    Then field "jnahkum" is modifiable
    Then field "jkzusch" is modifiable
    Then field "jnzusch" is modifiable  
    Then field "jkteilw" is modifiable
    Then field "jnteilw" is modifiable 
    
    Then field "jkzrueckl" is modifiable
    Then field "jnzrueckl" is modifiable
    Then field "jkarueckl" is modifiable
    Then field "jnarueckl" is modifiable
    Then field "jstkenn" is modifiable
    Then field "jstname" is modifiable
    Then field "jcakenn" is modifiable  
    Then field "jcaname" is modifiable
    Then field "jerkenn" is not modifiable    
    Then field "jername" is not modifiable       
                
    And saving the current editor throws the exception "440"

    Then setting field "aufw" to "16000" throws the exception "234"
    And I set field "aufw" to "54000"
    And saving the current editor throws the exception "1039"

    Then setting field "erlo" to "16000" throws the exception "259"        
    And I set field "erlo" to "44000"
    And saving the current editor throws the exception "57"    
    
    Then setting field "kasse" to "44000" throws the exception "260"    
    And I set field "kasse" to "18100"        
    And saving the current editor throws the exception "57"   
    
    Then setting field "dkurs" to "18100" throws the exception "234"
    And I set field "dkurs" to "68800"   
    And saving the current editor throws the exception "57"
    
    Then setting field "drund" to "18100" throws the exception "234"
    And I set field "drund" to "68820"   
    And saving the current editor throws the exception "57"
    
    Then setting field "hdkurs" to "18100" throws the exception "234"
    And I set field "hdkurs" to "48400"   
    And saving the current editor throws the exception "57"    
    
    Then setting field "hdrund" to "18100" throws the exception "234"
    And I set field "hdrund" to "48420"   
    And saving the current editor throws the exception "57"
    
    Then setting field "verdku" to "44000" throws the exception "62"
    And I set field "verdku" to "12000"   
    And saving the current editor throws the exception "57"
    
    Then setting field "verdli" to "44000" throws the exception "62"
    And I set field "verdli" to "33000"   
    And saving the current editor throws the exception "57"

    Then setting field "verdma" to "44000" throws the exception "62"
    And I set field "verdma" to "33000"   
    And saving the current editor throws the exception "57"

    Then setting field "verb" to "44000" throws the exception "62"
    And I set field "verb" to "33000"   
    And saving the current editor throws the exception "57"

    Then setting field "ford" to "44000" throws the exception "62"
    And I set field "ford" to "12000"   
    And saving the current editor throws the exception "601"
     
    And I set field "jdikenn" to "DI"   
    And saving the current editor throws the exception "6280"
      
    And I set field "swaabg" to "AUTOABG"     
    And saving the current editor throws the exception "6280"
     
    And I set field "swaumb" to "AUTOUMB"     
    And saving the current editor throws the exception "6280"
     
    And I set field "swaafa" to "AUTOAFA"     
    And saving the current editor throws the exception "6280"

    And I set field "swbilktw" to "BILKTW"     
    And saving the current editor throws the exception "6280"

    And I set field "swilv" to "K"     
    And saving the current editor throws the exception "6280"

    And I set field "swek" to "E"     
    And saving the current editor throws the exception "6280"

    And I set field "swvk" to "V"     
    And saving the current editor throws the exception "6280"

    And I set field "swstd" to "X"     
    And saving the current editor throws the exception "6280"

    And I set field "swstbu" to "K"     
    And saving the current editor throws the exception "6280"

    And I set field "swfbbu" to "B"     
    And saving the current editor throws the exception "6280"

    And I set field "swzv" to "Z"     
    And saving the current editor throws the exception "6280"

    And I set field "swcashen" to "KB"     
    And saving the current editor throws the exception "6280"
                                                                                    
    And I set field "btvk" to "RE"     
    And saving the current editor throws the exception "6280"
                                                                          
    And I set field "btek" to "RE"     
    And saving the current editor throws the exception "6280"

    And I set field "btekls" to "LS"
    And saving the current editor throws the exception "6280"

    And I set field "btzv" to "ZA"     
    And saving the current editor throws the exception "6280"
                                                                      
    And I set field "bgilv" to "ILV"     
    And saving the current editor throws the exception "6280"
                                                                      
    And I set field "swcashbo" to "K"     
    And saving the current editor throws the exception "6280"
                                                                      
    And I set field "kokurz" to "S"     
    And saving the current editor throws the exception "2528"
                                                                  
    And I set field "kokurz" to "S"     
    And saving the current editor throws the exception "2528"
                                                              
    And I set field "pgruppe" to "66"     
    And saving the current editor throws the exception "2527"
         
    And I set field "wgruppe" to "55"                                                                                                                
    And saving the current editor throws the exception "3882"    
 
    And I set field "kasse" to "16000"  
# Beim Kommando Neu k�nnen Zeilen eingef�gt und wieder gelöscht werden    
    And I create a new row at the end of the table
    And I delete row at position 1
    
    And I save the current editor
And I close the current editor


