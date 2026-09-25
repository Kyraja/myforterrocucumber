# *****************************************************************************
#  Name           : ref_koedit_aenderbar.feature
#  Autor          : Gisela Koehne
#  Verantwortlich : uo
#  Kontrolle      : hc
#  Funktion       : Editieren des Sachkontenstammes, Änderbarkeitsregeln            
#
# *****************************************************************************
@persistent
Feature: REWE-2464
Background:
Given I set the fake date to "31.12.2002"
Scenario: Aenderbarkeit beim Anzeigen eines Sachkontos sy
Given I open an editor "Konto_1" from table "(Account):(Account)" with command "VIEW" for record "18100"
# �nderbarkeit it-Felder
Then field "nummer" is not modifiable
Then field "such" is not modifiable
# �nderbarkeit Anwendungsfelder
Then field "selbukreis" is modifiable
Then field "gjahr" is not modifiable
Then field "bgjahr" is modifiable
Then field "saldo" is not modifiable
Then field "vortrag" is not modifiable
Then field "ivkz" is modifiable
Then field "pvkz" is modifiable
Then field "exbukr1" is not modifiable
Then field "exbukr2" is not modifiable
Then field "exbukr3" is not modifiable
Then field "exbukr4" is not modifiable
Then field "exbukr5" is not modifiable
# VKZ-Skips
Then field "s1" is not modifiable
Then field "s2" is not modifiable
Then field "s3" is not modifiable
Then field "s4" is not modifiable
Then field "s5" is not modifiable
Then field "s6" is not modifiable
Then field "s7" is not modifiable
Then field "s8" is not modifiable
Then field "s9" is not modifiable
Then field "s10" is not modifiable
Then field "s11" is not modifiable
Then field "s12" is not modifiable
Then field "s13" is not modifiable
Then field "s14" is not modifiable
Then field "s15" is not modifiable
Then field "sollneugj1" is not modifiable
Then field "sollneugj2" is not modifiable
Then field "sollneugj3" is not modifiable
Then field "h1" is not modifiable
Then field "h2" is not modifiable
Then field "h3" is not modifiable
Then field "h4" is not modifiable
Then field "h5" is not modifiable
Then field "h6" is not modifiable
Then field "h7" is not modifiable
Then field "h8" is not modifiable
Then field "h9" is not modifiable
Then field "h10" is not modifiable
Then field "h11" is not modifiable
Then field "h12" is not modifiable
Then field "h13" is not modifiable
Then field "h14" is not modifiable
Then field "h15" is not modifiable
Then field "hn1" is not modifiable
Then field "hn2" is not modifiable
Then field "hn3" is not modifiable
Then field "avortrag" is not modifiable
Then field "svjahr" is not modifiable
Then field "hvjahr" is not modifiable
#
Then field "gjneu" is not modifiable
Then field "gjakt" is not modifiable
Then field "gjalt" is not modifiable
Then field "gjalt2" is not modifiable
Then field "gjalt3" is not modifiable
#
Then field "wneu" is not modifiable
Then field "wakt" is not modifiable
Then field "walt" is not modifiable
Then field "asakt" is not modifiable
Then field "esakt" is not modifiable
Then field "esneu" is not modifiable
#
Then field "verd" is not modifiable
Then field "ev" is not modifiable
Then field "bu" is not modifiable
Then field "gv" is not modifiable
Then field "umsatz" is not modifiable
Then field "karta" is not modifiable
Then field "kstelle" is not modifiable
Then field "w2ist" is not modifiable
Then field "w2gjahr" is not modifiable
Then field "w2asaldo" is not modifiable
Then field "stata" is not modifiable
Then field "ustva" is not modifiable
#
Then field "kenn" is not modifiable
Then field "bem" is not modifiable
Then field "bukenn" is not modifiable
Then field "kvstart" is not modifiable
Then field "kvz" is not modifiable
Then field "kvrel" is not modifiable
Then field "kost" is not modifiable
Then field "hkost" is not modifiable
Then field "mwaehr" is not modifiable
Then field "bwaehr" is modifiable
#
Then field "ktostrgl" is not modifiable
Then field "strgl" is not modifiable
Then field "sts" is not modifiable
Then field "steuersts" is not modifiable
Then field "laart" is not modifiable
#
Then field "koart" is not modifiable
Then field "dvkto" is not modifiable
Then field "dvktoauto" is not modifiable
#
Then field "oprel" is not modifiable
Then field "zaform" is not modifiable
Then field "zasammler" is not modifiable
Then field "zasammelart" is not modifiable
Then field "zagr" is not modifiable
Then field "zaland" is not modifiable
Then field "sepauci" is not modifiable
Then field "zaverfahren" is not modifiable
#
Then field "vrgktotsch" is not modifiable
Then field "reregeln2" is not modifiable
Then field "ohnebu" is not modifiable
Then field "bverb" is not modifiable
Then field "autokbpfa" is not modifiable
Then field "zaraum" is not modifiable
Then field "bkexkl" is not modifiable
Then field "delbkvb" is not modifiable
Then field "chart" is not modifiable
Then field "chvkz" is modifiable
Then field "chagj" is modifiable
Then field "chegj" is modifiable
Then field "chistz" is modifiable
Then field "chplanz" is modifiable
Then field "lqkategorie" is not modifiable
And I close the current editor

Scenario: Aenderbarkeit beim Anlegen eines Sachkontos sy
Given I'm logged in with password "sy"
Given I open an editor "Konto_1" from table "(Account):(Account)" with command "NEW" for record ""
# �nderbarkeit it-Felder
Then field "nummer" is modifiable
Then field "such" is modifiable
# �nderbarkeit Anwendungsfelder
Then field "selbukreis" is modifiable
Then field "gjahr" is modifiable
Then field "bgjahr" is modifiable
Then field "saldo" is not modifiable
Then field "vortrag" is not modifiable
Then field "ivkz" is not modifiable
Then field "pvkz" is not modifiable
Then field "exbukr1" is modifiable
Then field "exbukr2" is modifiable
Then field "exbukr3" is modifiable
Then field "exbukr4" is modifiable
Then field "exbukr5" is modifiable
# VKZ-Skips
Then field "s1" is not modifiable
Then field "s2" is not modifiable
Then field "s3" is not modifiable
Then field "s4" is not modifiable
Then field "s5" is not modifiable
Then field "s6" is not modifiable
Then field "s7" is not modifiable
Then field "s8" is not modifiable
Then field "s9" is not modifiable
Then field "s10" is not modifiable
Then field "s11" is not modifiable
Then field "s12" is not modifiable
Then field "s13" is not modifiable
Then field "s14" is not modifiable
Then field "s15" is not modifiable
Then field "sollneugj1" is not modifiable
Then field "sollneugj2" is not modifiable
Then field "sollneugj3" is not modifiable
Then field "h1" is not modifiable
Then field "h2" is not modifiable
Then field "h3" is not modifiable
Then field "h4" is not modifiable
Then field "h5" is not modifiable
Then field "h6" is not modifiable
Then field "h7" is not modifiable
Then field "h8" is not modifiable
Then field "h9" is not modifiable
Then field "h10" is not modifiable
Then field "h11" is not modifiable
Then field "h12" is not modifiable
Then field "h13" is not modifiable
Then field "h14" is not modifiable
Then field "h15" is not modifiable
Then field "hn1" is not modifiable
Then field "hn2" is not modifiable
Then field "hn3" is not modifiable
Then field "avortrag" is not modifiable
Then field "svjahr" is not modifiable
Then field "hvjahr" is not modifiable
#
Then field "gjneu" is not modifiable
Then field "gjakt" is not modifiable
Then field "gjalt" is not modifiable
Then field "gjalt2" is not modifiable
Then field "gjalt3" is not modifiable
#
Then field "wneu" is not modifiable
Then field "wakt" is not modifiable
Then field "walt" is not modifiable
Then field "asakt" is not modifiable
Then field "esakt" is not modifiable
Then field "esneu" is not modifiable
#
Then field "verd" is modifiable
Then field "ev" is modifiable
Then field "bu" is modifiable
Then field "gv" is modifiable
Then field "umsatz" is modifiable
Then field "karta" is modifiable
Then field "kstelle" is modifiable
Then field "w2ist" is modifiable
Then field "w2gjahr" is modifiable
Then field "w2asaldo" is modifiable
Then field "stata" is modifiable
Then field "ustva" is not modifiable
#
Then field "kenn" is modifiable
Then field "bem" is modifiable
Then field "bukenn" is modifiable
Then field "kvstart" is not modifiable
Then field "kvz" is not modifiable
Then field "kvrel" is modifiable
Then field "kost" is not modifiable
Then field "hkost" is not modifiable
Then field "mwaehr" is modifiable
Then field "bwaehr" is modifiable
#
Then field "ktostrgl" is not modifiable
Then field "strgl" is not modifiable
Then field "sts" is not modifiable
Then field "steuersts" is not modifiable
Then field "laart" is not modifiable
#
Then field "koart" is not modifiable
Then field "dvkto" is modifiable
Then field "dvktoauto" is modifiable
#
Then field "oprel" is modifiable
Then field "zaform" is modifiable
Then field "zasammler" is modifiable
Then field "zasammelart" is modifiable
Then field "zagr" is modifiable
Then field "zaland" is modifiable
Then field "sepauci" is modifiable
Then field "zaverfahren" is modifiable
#
Then field "vrgktotsch" is not modifiable
Then field "reregeln2" is not modifiable
Then field "ohnebu" is modifiable
Then field "bverb" is modifiable
Then field "autokbpfa" is modifiable
Then field "zaraum" is modifiable
Then field "bkexkl" is modifiable
Then field "delbkvb" is modifiable
Then field "chart" is modifiable
Then field "chvkz" is modifiable
Then field "chagj" is modifiable
Then field "chegj" is modifiable
Then field "chistz" is modifiable
Then field "chplanz" is modifiable
Then field "lqkategorie" is modifiable
# Initialisierung
Then field "bu" has value "ja"
#
# Setzen Felder
And I set field "nummer" to "10X"
And I set field "such" to "K_10X"
And I set field "namebspr" to "Konto 10X"
#
And I save the current editor
And I close the current editor
#
Scenario: Aenderbarkeit beim Anlegen eines Sachkontos Wartung
Given I'm logged in with password "annette"
Given I open an editor "Konto_2" from table "(Account):(Account)" with command "NEW" for record ""
# �nderbarkeit it-Felder
Then field "nummer" is modifiable
Then field "such" is modifiable
# �nderbarkeit Anwendungsfelder
Then field "selbukreis" is modifiable
Then field "gjahr" is modifiable
Then field "bgjahr" is modifiable
Then field "saldo" is not modifiable
Then field "vortrag" is not modifiable
Then field "ivkz" is not modifiable
Then field "pvkz" is not modifiable
Then field "exbukr1" is modifiable
Then field "exbukr2" is modifiable
Then field "exbukr3" is modifiable
Then field "exbukr4" is modifiable
Then field "exbukr5" is modifiable
# VKZ-Skips
Then field "s1" is not modifiable
Then field "s2" is not modifiable
Then field "s3" is not modifiable
Then field "s4" is not modifiable
Then field "s5" is not modifiable
Then field "s6" is not modifiable
Then field "s7" is not modifiable
Then field "s8" is not modifiable
Then field "s9" is not modifiable
Then field "s10" is not modifiable
Then field "s11" is not modifiable
Then field "s12" is not modifiable
Then field "s13" is not modifiable
Then field "s14" is not modifiable
Then field "s15" is not modifiable
Then field "sollneugj1" is not modifiable
Then field "sollneugj2" is not modifiable
Then field "sollneugj3" is not modifiable
Then field "h1" is not modifiable
Then field "h2" is not modifiable
Then field "h3" is not modifiable
Then field "h4" is not modifiable
Then field "h5" is not modifiable
Then field "h6" is not modifiable
Then field "h7" is not modifiable
Then field "h8" is not modifiable
Then field "h9" is not modifiable
Then field "h10" is not modifiable
Then field "h11" is not modifiable
Then field "h12" is not modifiable
Then field "h13" is not modifiable
Then field "h14" is not modifiable
Then field "h15" is not modifiable
Then field "hn1" is not modifiable
Then field "hn2" is not modifiable
Then field "hn3" is not modifiable
Then field "avortrag" is not modifiable
Then field "svjahr" is not modifiable
Then field "hvjahr" is not modifiable
#
Then field "gjneu" is not modifiable
Then field "gjakt" is not modifiable
Then field "gjalt" is not modifiable
Then field "gjalt2" is not modifiable
Then field "gjalt3" is not modifiable
#
Then field "wneu" is not modifiable
Then field "wakt" is not modifiable
Then field "walt" is not modifiable
Then field "asakt" is not modifiable
Then field "esakt" is not modifiable
Then field "esneu" is not modifiable
#
Then field "verd" is modifiable
Then field "ev" is modifiable
Then field "bu" is modifiable
Then field "gv" is modifiable
Then field "umsatz" is modifiable
Then field "karta" is modifiable
Then field "kstelle" is modifiable
Then field "w2ist" is modifiable
Then field "w2gjahr" is modifiable
Then field "w2asaldo" is modifiable
Then field "stata" is modifiable
Then field "ustva" is not modifiable
#
Then field "kenn" is modifiable
Then field "bem" is modifiable
Then field "bukenn" is modifiable
Then field "kvstart" is not modifiable
Then field "kvz" is not modifiable
Then field "kvrel" is modifiable
Then field "kost" is not modifiable
Then field "hkost" is not modifiable
Then field "mwaehr" is modifiable
Then field "bwaehr" is modifiable
#
Then field "ktostrgl" is not modifiable
Then field "strgl" is not modifiable
Then field "sts" is not modifiable
Then field "steuersts" is not modifiable
Then field "laart" is not modifiable
#
Then field "koart" is not modifiable
Then field "dvkto" is modifiable
Then field "dvktoauto" is modifiable
#
Then field "oprel" is modifiable
Then field "zaform" is modifiable
Then field "zasammler" is modifiable
Then field "zasammelart" is modifiable
Then field "zagr" is modifiable
Then field "zaland" is modifiable
Then field "sepauci" is modifiable
Then field "zaverfahren" is modifiable
#
Then field "vrgktotsch" is not modifiable
Then field "reregeln2" is not modifiable
Then field "ohnebu" is modifiable
Then field "bverb" is modifiable
Then field "autokbpfa" is modifiable
Then field "zaraum" is modifiable
Then field "bkexkl" is modifiable
Then field "delbkvb" is modifiable
Then field "chart" is modifiable
Then field "chvkz" is modifiable
Then field "chagj" is modifiable
Then field "chegj" is modifiable
Then field "chistz" is modifiable
Then field "chplanz" is modifiable
Then field "lqkategorie" is modifiable
# Initialisierung
Then field "bu" has value "ja"
# Setzen Felder
And I set field "nummer" to "20X"
And I set field "such" to "K_20X"
And I set field "namebspr" to "Konto 20X"
#
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit beim Aendern eines Sachkontos sy
Given I'm logged in with password "sy"
Given I open an editor "Konto_3" from table "(Account):(Account)" with command "UPDATE" for record "K_10X"
# �nderbarkeit it-Felder
Then field "nummer" is not modifiable
Then field "such" is modifiable
# �nderbarkeit Anwendungsfelder
Then field "selbukreis" is modifiable
Then field "gjahr" is modifiable
Then field "bgjahr" is modifiable
Then field "saldo" is not modifiable
Then field "vortrag" is not modifiable
Then field "ivkz" is modifiable
Then field "pvkz" is modifiable
Then field "exbukr1" is modifiable
Then field "exbukr2" is modifiable
Then field "exbukr3" is modifiable
Then field "exbukr4" is modifiable
Then field "exbukr5" is modifiable
# VKZ-Skips
Then field "s1" is not modifiable
Then field "s2" is not modifiable
Then field "s3" is not modifiable
Then field "s4" is not modifiable
Then field "s5" is not modifiable
Then field "s6" is not modifiable
Then field "s7" is not modifiable
Then field "s8" is not modifiable
Then field "s9" is not modifiable
Then field "s10" is not modifiable
Then field "s11" is not modifiable
Then field "s12" is not modifiable
Then field "s13" is not modifiable
Then field "s14" is not modifiable
Then field "s15" is not modifiable
Then field "sollneugj1" is not modifiable
Then field "sollneugj2" is not modifiable
Then field "sollneugj3" is not modifiable
Then field "h1" is not modifiable
Then field "h2" is not modifiable
Then field "h3" is not modifiable
Then field "h4" is not modifiable
Then field "h5" is not modifiable
Then field "h6" is not modifiable
Then field "h7" is not modifiable
Then field "h8" is not modifiable
Then field "h9" is not modifiable
Then field "h10" is not modifiable
Then field "h11" is not modifiable
Then field "h12" is not modifiable
Then field "h13" is not modifiable
Then field "h14" is not modifiable
Then field "h15" is not modifiable
Then field "hn1" is not modifiable
Then field "hn2" is not modifiable
Then field "hn3" is not modifiable
Then field "avortrag" is not modifiable
Then field "svjahr" is not modifiable
Then field "hvjahr" is not modifiable
#
Then field "gjneu" is not modifiable
Then field "gjakt" is not modifiable
Then field "gjalt" is not modifiable
Then field "gjalt2" is not modifiable
Then field "gjalt3" is not modifiable
#
Then field "wneu" is not modifiable
Then field "wakt" is not modifiable
Then field "walt" is not modifiable
Then field "asakt" is not modifiable
Then field "esakt" is not modifiable
Then field "esneu" is not modifiable
#
Then field "verd" is modifiable
Then field "ev" is modifiable
Then field "bu" is not modifiable
Then field "gv" is not modifiable
Then field "umsatz" is modifiable
Then field "karta" is modifiable
Then field "kstelle" is not modifiable
Then field "w2ist" is modifiable
Then field "w2gjahr" is modifiable
Then field "w2asaldo" is modifiable
Then field "stata" is modifiable
Then field "ustva" is not modifiable
#
Then field "kenn" is modifiable
Then field "bem" is modifiable
Then field "bukenn" is modifiable
Then field "kvstart" is not modifiable
Then field "kvz" is not modifiable
Then field "kvrel" is modifiable
Then field "kost" is not modifiable
Then field "hkost" is not modifiable
Then field "mwaehr" is modifiable
Then field "bwaehr" is modifiable
#
Then field "ktostrgl" is not modifiable
Then field "strgl" is not modifiable
Then field "sts" is not modifiable
Then field "steuersts" is not modifiable
Then field "laart" is not modifiable
#
Then field "koart" is not modifiable
Then field "dvkto" is modifiable
Then field "dvktoauto" is modifiable
#
Then field "oprel" is modifiable
Then field "zaform" is modifiable
Then field "zasammler" is modifiable
Then field "zasammelart" is modifiable
Then field "zagr" is modifiable
Then field "zaland" is modifiable
Then field "sepauci" is modifiable
Then field "zaverfahren" is modifiable
#
Then field "vrgktotsch" is not modifiable
Then field "reregeln2" is not modifiable
Then field "ohnebu" is modifiable
Then field "bverb" is modifiable
Then field "autokbpfa" is modifiable
Then field "zaraum" is modifiable
Then field "bkexkl" is modifiable
Then field "delbkvb" is modifiable
Then field "chart" is modifiable
Then field "chvkz" is modifiable
Then field "chagj" is modifiable
Then field "chegj" is modifiable
Then field "chistz" is modifiable
Then field "chplanz" is modifiable
Then field "lqkategorie" is modifiable
# Initialisierung
Then field "bu" has value "ja"
#
# Setzen Felder
And setting field "nummer" to "10X" in row 0 throws the exception "203"
And I set field "such" to "K_10X"
And I set field "namebspr" to "Konto 10X"
#
And I save the current editor
And I close the current editor
#
Scenario: Aenderbarkeit beim Aendern eines Sachkontos Wartung
Given I'm logged in with password "annette"
Given I open an editor "Konto_4" from table "(Account):(Account)" with command "UPDATE" for record "K_20X"
# �nderbarkeit it-Felder
Then field "nummer" is modifiable
Then field "such" is modifiable
# �nderbarkeit Anwendungsfelder
Then field "selbukreis" is modifiable
Then field "gjahr" is modifiable
Then field "bgjahr" is modifiable
Then field "saldo" is not modifiable
Then field "vortrag" is not modifiable
Then field "ivkz" is modifiable
Then field "pvkz" is modifiable
Then field "exbukr1" is modifiable
Then field "exbukr2" is modifiable
Then field "exbukr3" is modifiable
Then field "exbukr4" is modifiable
Then field "exbukr5" is modifiable
# VKZ-Skips
Then field "s1" is not modifiable
Then field "s2" is not modifiable
Then field "s3" is not modifiable
Then field "s4" is not modifiable
Then field "s5" is not modifiable
Then field "s6" is not modifiable
Then field "s7" is not modifiable
Then field "s8" is not modifiable
Then field "s9" is not modifiable
Then field "s10" is not modifiable
Then field "s11" is not modifiable
Then field "s12" is not modifiable
Then field "s13" is not modifiable
Then field "s14" is not modifiable
Then field "s15" is not modifiable
Then field "sollneugj1" is not modifiable
Then field "sollneugj2" is not modifiable
Then field "sollneugj3" is not modifiable
Then field "h1" is not modifiable
Then field "h2" is not modifiable
Then field "h3" is not modifiable
Then field "h4" is not modifiable
Then field "h5" is not modifiable
Then field "h6" is not modifiable
Then field "h7" is not modifiable
Then field "h8" is not modifiable
Then field "h9" is not modifiable
Then field "h10" is not modifiable
Then field "h11" is not modifiable
Then field "h12" is not modifiable
Then field "h13" is not modifiable
Then field "h14" is not modifiable
Then field "h15" is not modifiable
Then field "hn1" is not modifiable
Then field "hn2" is not modifiable
Then field "hn3" is not modifiable
Then field "avortrag" is not modifiable
Then field "svjahr" is not modifiable
Then field "hvjahr" is not modifiable
#
Then field "gjneu" is not modifiable
Then field "gjakt" is not modifiable
Then field "gjalt" is not modifiable
Then field "gjalt2" is not modifiable
Then field "gjalt3" is not modifiable
#
Then field "wneu" is not modifiable
Then field "wakt" is not modifiable
Then field "walt" is not modifiable
Then field "asakt" is not modifiable
Then field "esakt" is not modifiable
Then field "esneu" is not modifiable
#
Then field "verd" is modifiable
Then field "ev" is modifiable
Then field "bu" is modifiable
Then field "gv" is modifiable
Then field "umsatz" is modifiable
Then field "karta" is modifiable
Then field "kstelle" is not modifiable
Then field "w2ist" is modifiable
Then field "w2gjahr" is modifiable
Then field "w2asaldo" is modifiable
Then field "stata" is modifiable
Then field "ustva" is not modifiable
#
Then field "kenn" is modifiable
Then field "bem" is modifiable
Then field "bukenn" is modifiable
Then field "kvstart" is not modifiable
Then field "kvz" is not modifiable
Then field "kvrel" is modifiable
Then field "kost" is not modifiable
Then field "hkost" is not modifiable
Then field "mwaehr" is modifiable
Then field "bwaehr" is modifiable
#
Then field "ktostrgl" is not modifiable
Then field "strgl" is not modifiable
Then field "sts" is not modifiable
Then field "steuersts" is not modifiable
Then field "laart" is not modifiable
#
Then field "koart" is not modifiable
Then field "dvkto" is modifiable
Then field "dvktoauto" is modifiable
#
Then field "oprel" is modifiable
Then field "zaform" is modifiable
Then field "zasammler" is modifiable
Then field "zasammelart" is modifiable
Then field "zagr" is modifiable
Then field "zaland" is modifiable
Then field "sepauci" is modifiable
Then field "zaverfahren" is modifiable
#
Then field "vrgktotsch" is not modifiable
Then field "reregeln2" is not modifiable
Then field "ohnebu" is modifiable
Then field "bverb" is modifiable
Then field "autokbpfa" is modifiable
Then field "zaraum" is modifiable
Then field "bkexkl" is modifiable
Then field "delbkvb" is modifiable
Then field "chart" is modifiable
Then field "chvkz" is modifiable
Then field "chagj" is modifiable
Then field "chegj" is modifiable
Then field "chistz" is modifiable
Then field "chplanz" is modifiable
Then field "lqkategorie" is modifiable
# Initialisierung
Then field "bu" has value "ja"
# Setzen Felder
And I set field "nummer" to "20X1"
And I set field "such" to "K_20X"
And I set field "namebspr" to "Konto 20X"
#
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten kokvstart
Given I'm logged in with password "sy"
Given I open an editor "Konto_5" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "30X1"
And I set field "such" to "K_30X"
And I set field "namebspr" to "Konto 30X"
#
And I set field "kvrel" to "ja"
Then field "kvstart" is modifiable
#
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten koev
Given I open an editor "Konto_6" from table "(Account):(Account)" with command "UPDATE" for record "K_30X"
Then field "ev" is modifiable
And I set field "ev" to "Einkauf"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_7" from table "(Account):(Account)" with command "UPDATE" for record "K_30X"
Then field "ev" is not modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_8" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "40X1"
And I set field "such" to "K_40X"
And I set field "namebspr" to "Konto 40X"
And I set field "stata" to "Euro-"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_9" from table "(Account):(Account)" with command "UPDATE" for record "K_40X"
Then field "ev" is not modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_10" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "50X1"
And I set field "such" to "K_50X"
And I set field "namebspr" to "Konto 50X"
And I set field "ev" to "Einkauf"
And I set field "karta" to "Kasse"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_11" from table "(Account):(Account)" with command "UPDATE" for record "K_50X"
Then field "ev" is modifiable
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten kokart
Given I open an editor "Konto_12" from table "(Account):(Account)" with command "UPDATE" for record "K_40X"
Then field "karta" is not modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_13" from table "(Account):(Account)" with command "UPDATE" for record "K_50X"
Then field "karta" is not modifiable
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten Konten_anlegen
Given I open an editor "Konto_14" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "60X1"
And I set field "such" to "K_60X"
And I set field "namebspr" to "Konto 60X"
And I set field "karta" to "Bankkonto"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_15" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "70X1"
And I set field "such" to "K_70X"
And I set field "namebspr" to "Konto 70X"
And I set field "stata" to "Kostenrechnung"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_16" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "80X1"
And I set field "such" to "K_80X"
And I set field "namebspr" to "Konto 80X"
And I set field "bu" to "nein"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_16" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "90X1"
And I set field "such" to "K_90X"
And I set field "namebspr" to "Konto 90X"
And I set field "bu" to "nein"
And I set field "gv" to "ja"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_17" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "100X1"
And I set field "such" to "K_100X"
And I set field "namebspr" to "Konto 100X"
And I set field "bu" to "ja"
And I set field "gv" to "ja"
And I set field "ev" to "Einkauf"
And I set field "stata" to "Euro"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_18" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "101X1"
And I set field "such" to "K_101X"
And I set field "namebspr" to "Konto 101X"
And I set field "bu" to "ja"
And I set field "gv" to "nein"
And I set field "ev" to "Einkauf"
And I set field "karta" to "Bank"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_18" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "102X1"
And I set field "such" to "K_102X"
And I set field "namebspr" to "Konto 102X"
And I set field "bu" to "ja"
And I set field "gv" to "nein"
And I set field "ev" to "Einkauf"
And I set field "karta" to "Anlage"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_19" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "103X1"
And I set field "such" to "K_103X"
And I set field "namebspr" to "Konto 103X"
And I set field "bu" to "ja"
And I set field "gv" to "nein"
And I set field "ev" to "Einkauf"
And I set field "karta" to "Steuer"
And I set field "steuersts" to "1"
And I save the current editor
And I close the current editor

Given I open an editor "Konto_20" from table "(Account):(Account)" with command "NEW" for record ""
And I set field "nummer" to "104X1"
And I set field "such" to "K_104X"
And I set field "namebspr" to "Konto 104X"
And I set field "bu" to "ja"
And I set field "gv" to "ja"
And I set field "ev" to "Verkauf"
And I set field "kost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "44000" in row 1
And I set field "koartvon" to "01.01.02" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "Konto_30" from table "(Account):(Account)" with command "UPDATE" for record "K_60X"
Then field "karta" is modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_31" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
Then field "karta" is modifiable
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten kostat
Given I open an editor "Konto_32" from table "(Account):(Account)" with command "UPDATE" for record "K_40X"
Then field "stata" is not modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_33" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
Then field "stata" is not modifiable
And I save the current editor
And I close the current editor

Given I'm logged in with password "annette"
Given I open an editor "Konto_34" from table "(Account):(Account)" with command "UPDATE" for record "K_40X"
Then field "stata" is modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_35" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
Then field "stata" is not modifiable
And I save the current editor
And I close the current editor

Given I'm logged in with password "sy"

Scenario: Aenderbarkeit Sachkonten w2
Given I open an editor "Konto_36" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
Then field "w2ist" is not modifiable
Then field "w2gjahr" is not modifiable
Then field "w2asaldo" is not modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_37" from table "(Account):(Account)" with command "UPDATE" for record "K_80X"
Then field "w2ist" is modifiable
Then field "w2gjahr" is not modifiable
Then field "w2asaldo" is not modifiable
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten kokost
Given I open an editor "Konto_38" from table "(Account):(Account)" with command "UPDATE" for record "K_30X"
Then field "kost" is not modifiable
And setting field "kost" to "ja" in row 0 throws the exception "1893"
Then field "hkost" is not modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_39" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
Then field "kost" is modifiable
Then field "hkost" is modifiable
And I save the current editor
And I close the current editor

Given I open an editor "Konto_40" from table "(Account):(Account)" with command "UPDATE" for record "K_90X"
Then field "kost" is not modifiable
Then field "hkost" is modifiable
And setting field "kost" to "ja" in row 0 throws the exception "1822"
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten kstelle
Given I open an editor "Konto_41" from table "(Account):(Account)" with command "UPDATE" for record "K_50X"
Then field "kstelle" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_41" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
Then field "kstelle" is modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_43" from table "(Account):(Account)" with command "UPDATE" for record "K_80X"
Then field "kstelle" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_44" from table "(Account):(Account)" with command "UPDATE" for record "K_90X"
Then field "kstelle" is modifiable
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten vrgktotsch
Given I open an editor "Konto_45" from table "(Account):(Account)" with command "UPDATE" for record "K_50X"
Then field "vrgktotsch" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_46" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
Then field "vrgktotsch" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_47" from table "(Account):(Account)" with command "UPDATE" for record "K_80X"
Then field "vrgktotsch" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_48" from table "(Account):(Account)" with command "UPDATE" for record "K_100X"
Then field "vrgktotsch" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_48" from table "(Account):(Account)" with command "UPDATE" for record "K_101X"
Then field "vrgktotsch" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_48" from table "(Account):(Account)" with command "UPDATE" for record "K_102X"
Then field "vrgktotsch" is modifiable
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Sachkonten ktostrgl_steuersts
Given I open an editor "Konto_45" from table "(Account):(Account)" with command "UPDATE" for record "K_50X"
Then field "ktostrgl" is modifiable
Then field "steuersts" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_46" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
Then field "ktostrgl" is not modifiable
Then field "steuersts" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_47" from table "(Account):(Account)" with command "UPDATE" for record "K_80X"
Then field "ktostrgl" is not modifiable
Then field "steuersts" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_48" from table "(Account):(Account)" with command "UPDATE" for record "K_100X"
Then field "ktostrgl" is not modifiable
Then field "steuersts" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_49" from table "(Account):(Account)" with command "UPDATE" for record "K_101X"
Then field "ktostrgl" is modifiable
Then field "steuersts" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_50" from table "(Account):(Account)" with command "UPDATE" for record "K_102X"
Then field "ktostrgl" is modifiable
Then field "steuersts" is not modifiable
And I save the current editor
And I close the current editor
Given I open an editor "Konto_51" from table "(Account):(Account)" with command "UPDATE" for record "K_103X"
Then field "ktostrgl" is not modifiable
Then field "steuersts" is modifiable
And I save the current editor
And I close the current editor

Scenario: Aenderbarkeit Tabelle
Given I open an editor "Konto_52" from table "(Account):(Account)" with command "UPDATE" for record "K_50X"
And creating a new row at position 1 throws the exception "1092"
And I save the current editor
And I close the current editor
Given I open an editor "Konto_53" from table "(Account):(Account)" with command "UPDATE" for record "K_70X"
And creating a new row at position 1 throws the exception "2869"
And I save the current editor
And I close the current editor
Given I open an editor "Konto_54" from table "(Account):(Account)" with command "UPDATE" for record "K_80X"
And creating a new row at position 1 throws the exception "1279"
And I save the current editor
And I close the current editor
Given I open an editor "Konto_55" from table "(Account):(Account)" with command "UPDATE" for record "K_90X"
And creating a new row at position 1 throws the exception "3823"
And I save the current editor
And I close the current editor
Given I open an editor "Konto_56" from table "(Account):(Account)" with command "UPDATE" for record "K_104X"
And I create a new row at the end of the table
Then field "zkoart" is modifiable in row 1
Then field "koartvon" is modifiable in row 1
Then field "koartbis" is modifiable in row 1
Then field "pkkoartvon" is not modifiable in row 1
Then field "pkkoartbis" is not modifiable in row 1
And I save the current editor
And I close the current editor
#


