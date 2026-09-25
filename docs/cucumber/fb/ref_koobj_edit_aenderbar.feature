
# *****************************************************************************
#  Name           : ref_koobj_edit_aenderbar.feature
#  Autor          : Gisela Koehne
#  Verantwortlich : gk
#  Kontrolle      : hc
#  Funktion       : Editieren des Sachkontenstammes.                
#
# *****************************************************************************
@persistent
Feature: REWE-2485
Background:
Given I set the fake date to "31.12.2002"
Scenario: Aenderbarkeit beim Anlegen einer Kostenstelle sy
Given I'm logged in with password "sy"

Scenario: Aenderbarkeit beim Zeigen einer Kostenstelle 
Given I open an editor "KSt_1" from table "(Account):(CostCenter)" with command "VIEW" for record "101"
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
Then field "bu" is not modifiable
Then field "gv" is not modifiable

#
Then field "hilfsks" is not modifiable
Then field "verant" is not modifiable
Then field "manam" is not modifiable
Then field "umlab" is not modifiable
Then field "bereich" is not modifiable
Then field "umdef" is not modifiable
Then field "umlzu" is not modifiable
Then field "izuschlag" is modifiable
Then field "pzuschlag" is modifiable
Then field "fpkv" is modifiable
#
Then field "bab" is not modifiable
Then field "bezug" is not modifiable
Then field "ftext" is not modifiable
Then field "ftext2" is not modifiable
Then field "kenn" is not modifiable
Then field "bem" is not modifiable
Then field "bukenn" is not modifiable
#
Then field "sald" is not modifiable
Then field "fikv" is modifiable
Then field "gpkv" is modifiable
Then field "gikv" is modifiable
Then field "gpkv" is modifiable
#
Then field "umlage" is not modifiable
Then field "mwaehr" is not modifiable
Then field "bwaehr" is modifiable
Then field "ivkv" is modifiable
Then field "pfixabw" is modifiable
#
Then field "kverd1" is not modifiable
Then field "kverd2" is not modifiable
Then field "kverd3" is not modifiable
Then field "kverd4" is not modifiable
Then field "kverd5" is not modifiable
#
Then field "bgivkz" is modifiable
Then field "bgpvkz" is modifiable
Then field "bgivkz1" is modifiable
Then field "bgpvkz1" is modifiable
Then field "bgivkz2" is modifiable
Then field "bgpvkz2" is modifiable
Then field "bgivkz3" is modifiable
Then field "bgpvkz3" is modifiable
Then field "bgivkz4" is modifiable
Then field "bgpvkz4" is modifiable
Then field "bgivkz5" is modifiable
Then field "bgpvkz5" is modifiable
#
Then field "einh" is not modifiable
Then field "einh1" is not modifiable
Then field "einh2" is not modifiable
Then field "einh3" is not modifiable
Then field "einh4" is not modifiable
Then field "einh5" is not modifiable
#
Then field "bez1" is not modifiable
Then field "bez2" is not modifiable
Then field "bez3" is not modifiable
Then field "bez4" is not modifiable
Then field "bez5" is not modifiable
#
# Skipfelder Abkürzungen => Schema
#
Then field "abk1" is not modifiable
Then field "abk2" is not modifiable
Then field "abk3" is not modifiable
Then field "abk4" is not modifiable
Then field "abk5" is not modifiable
#
Then field "sald1" is not modifiable
Then field "sald2" is not modifiable
Then field "sald3" is not modifiable
Then field "sald4" is not modifiable
Then field "sald5" is not modifiable
#
Then field "abk" is not modifiable
Then field "vabw" is modifiable
Then field "babw" is modifiable
Then field "sopr" is modifiable
Then field "soge" is modifiable
Then field "pfpr" is modifiable
Then field "pfge" is modifiable
Then field "pppr" is modifiable
#
Then field "ppge" is modifiable
Then field "ipr" is modifiable
Then field "ige" is modifiable
Then field "rest" is not modifiable
Then field "iizuschlag" is modifiable
Then field "ipzuschlag" is modifiable
#
Then field "reregeln2" is not modifiable
Then field "ohnebu" is not modifiable
#
Then field "anmon" is not modifiable
Then field "endmon" is not modifiable
Then field "agjahr" is not modifiable
Then field "egjahr" is not modifiable
#
Then field "kikum" is not modifiable
Then field "kpfixkum" is not modifiable
Then field "kppropkum" is not modifiable
Then field "kskum" is not modifiable
Then field "ksiakum" is not modifiable
Then field "ksirkum" is not modifiable
#
Then field "kumerrechnen" is not modifiable
#
And I close the current editor

Scenario: Aenderbarkeit beim Anlegen einer Kostenstelle sy
Given I'm logged in with password "sy"
Given I open an editor "KSt_1" from table "(Account):(CostCenter)" with command "NEW" for record ""
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
Then field "bu" is modifiable
Then field "gv" is modifiable

#
Then field "hilfsks" is modifiable
Then field "verant" is modifiable
Then field "manam" is not modifiable
Then field "umlab" is modifiable
Then field "bereich" is modifiable
Then field "umdef" is not modifiable
Then field "umlzu" is modifiable
Then field "izuschlag" is not modifiable
Then field "pzuschlag" is not modifiable
Then field "fpkv" is not modifiable
#
Then field "bab" is modifiable
Then field "bezug" is modifiable
Then field "ftext" is modifiable
Then field "ftext2" is modifiable
Then field "kenn" is modifiable
Then field "bem" is modifiable
Then field "bukenn" is modifiable
#
Then field "sald" is not modifiable
Then field "fikv" is not modifiable
Then field "gpkv" is not modifiable
Then field "gikv" is not modifiable
Then field "gpkv" is not modifiable
#
Then field "umlage" is modifiable
Then field "mwaehr" is modifiable
Then field "bwaehr" is modifiable
Then field "ivkv" is not modifiable
Then field "pfixabw" is not modifiable
#
Then field "kverd1" is modifiable
Then field "kverd2" is modifiable
Then field "kverd3" is modifiable
Then field "kverd4" is modifiable
Then field "kverd5" is modifiable
#
Then field "bgivkz" is not modifiable
Then field "bgpvkz" is not modifiable
Then field "bgivkz1" is not modifiable
Then field "bgpvkz1" is not modifiable
Then field "bgivkz2" is not modifiable
Then field "bgpvkz2" is not modifiable
Then field "bgivkz3" is not modifiable
Then field "bgpvkz3" is not modifiable
Then field "bgivkz4" is not modifiable
Then field "bgpvkz4" is not modifiable
Then field "bgivkz5" is not modifiable
Then field "bgpvkz5" is not modifiable
#
Then field "einh" is not modifiable
Then field "einh1" is not modifiable
Then field "einh2" is not modifiable
Then field "einh3" is not modifiable
Then field "einh4" is not modifiable
Then field "einh5" is not modifiable
#
Then field "bez1" is modifiable
Then field "bez2" is modifiable
Then field "bez3" is modifiable
Then field "bez4" is modifiable
Then field "bez5" is modifiable
#
# Skipfelder Abkürzungen => Schema
#
Then field "abk1" is not modifiable
Then field "abk2" is not modifiable
Then field "abk3" is not modifiable
Then field "abk4" is not modifiable
Then field "abk5" is not modifiable
#
Then field "sald1" is not modifiable
Then field "sald2" is not modifiable
Then field "sald3" is not modifiable
Then field "sald4" is not modifiable
Then field "sald5" is not modifiable
#
Then field "abk" is not modifiable
Then field "vabw" is not modifiable
Then field "babw" is not modifiable
Then field "sopr" is not modifiable
Then field "soge" is not modifiable
Then field "pfpr" is not modifiable
Then field "pfge" is not modifiable
Then field "pppr" is not modifiable
#
Then field "ppge" is not modifiable
Then field "ipr" is not modifiable
Then field "ige" is not modifiable
Then field "rest" is not modifiable
Then field "iizuschlag" is not modifiable
Then field "ipzuschlag" is not modifiable
#
Then field "reregeln2" is not modifiable
Then field "ohnebu" is modifiable
#
Then field "anmon" is modifiable
Then field "endmon" is modifiable
Then field "agjahr" is modifiable
Then field "egjahr" is modifiable
#
Then field "kikum" is not modifiable
Then field "kpfixkum" is not modifiable
Then field "kppropkum" is not modifiable
Then field "kskum" is not modifiable
Then field "ksiakum" is not modifiable
Then field "ksirkum" is not modifiable
#
Then field "kumerrechnen" is not modifiable
#
Then field "bu" has value "ja"
And I set field "bu" to "nein"
Then field "bezug" is not modifiable
Then field "bez1" is not modifiable
Then field "bez2" is not modifiable
Then field "bez3" is not modifiable
Then field "bez4" is not modifiable
Then field "bez5" is not modifiable
Then field "umlzu" is not modifiable
Then field "umlab" is not modifiable
Then field "kumerrechnen" is modifiable
#
And I close the current editor
#
Scenario: Aenderbarkeit beim Aendern einer Kostenstelle sy
Given I'm logged in with password "sy"
Given I open an editor "KSt_2" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
Then field "nummer" is not modifiable
Then field "bu" is not modifiable
Then field "gv" is not modifiable
And I close the current editor
#
Scenario: Aenderbarkeit beim Aendern einer Kostenstelle annette
Given I'm logged in with password "annette"
Given I open an editor "KSt_2" from table "(Account):(CostCenter)" with command "UPDATE" for record "100"
Then field "nummer" is modifiable
Then field "bu" is modifiable
Then field "gv" is modifiable
And I close the current editor
#
Scenario: Aenderbarkeit bei einem Kostentraeger
Given I open an editor "Ktr_1" from table "(Account):(CostObject)" with command "NEW" for record ""
# Aenderbarkeit it-Felder
Then field "nummer" is modifiable
Then field "such" is modifiable
# Aenderbarkeit Anwendungsfelder
Then field "selbukreis" is modifiable
Then field "gjahr" is modifiable
Then field "bgjahr" is modifiable
Then field "saldo" is not modifiable
Then field "vortrag" is not modifiable
Then field "ivkz" is not modifiable
Then field "pvkz" is not modifiable
# Aenderbarkeit VKZ-Skips
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
Then field "gekotr" is modifiable
Then field "bu" is modifiable
Then field "bu" is modifiable
Then field "gv" is modifiable
#
Then field "aufart" is modifiable
Then field "erlgrp" is modifiable
Then field "erledigt" is modifiable
Then field "storniertam" is modifiable
Then field "fmeld" is modifiable
Then field "fbuch" is modifiable
Then field "konto" is modifiable
Then field "ftext" is modifiable
Then field "ftext2" is modifiable
Then field "kenn" is modifiable
Then field "bem" is modifiable
Then field "bukenn" is modifiable
Then field "mwaehr" is modifiable
Then field "ohnebu" is modifiable
Then field "anmon" is modifiable
Then field "endmon" is modifiable
Then field "agjahr" is modifiable
Then field "egjahr" is modifiable
#
Then field "kikum" is not modifiable
Then field "kpfixkum" is not modifiable
Then field "kppropkum" is not modifiable
Then field "kskum" is not modifiable
Then field "ksiakum" is not modifiable
Then field "ksirkum" is not modifiable
#
Then field "kumerrechnen" is not modifiable
#
Then field "bu" has value "ja"
And I set field "bu" to "nein"
Then field "kumerrechnen" is modifiable
And I close the current editor
#
Scenario: Aenderbarkeit beim Aendern eines Kostentraegers sy
Given I'm logged in with password "sy"
Given I open an editor "KTr_2" from table "(Account):(CostObject)" with command "UPDATE" for record "100000"
Then field "nummer" is not modifiable
Then field "bu" is not modifiable
Then field "gekotr" is not modifiable
Then field "gv" is not modifiable
And I close the current editor
#
Scenario: Aenderbarkeit beim Aendern eines Kostentraegers annette
Given I'm logged in with password "annette"
Given I open an editor "KTr_3" from table "(Account):(CostObject)" with command "UPDATE" for record "100000"
Then field "nummer" is modifiable
Then field "bu" is modifiable
Then field "gekotr" is modifiable
Then field "gv" is modifiable
And I close the current editor
#
