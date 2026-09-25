# *****************************************************************************
#  Name             : steuer_ustvaformular_plausi_002_sammelpositionen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Plausis in USTVA-Formular ueberwachen
#
#
# *****************************************************************************
@persistent
Feature: steuer_ustvaformular_plausi_002_sammelpositionen.feature
Background: Plausis in USTVA-Formular ueberwachen


Scenario: einpaar Positionen anlegen

Given I open an editor "sts" from table "(TaxCode):(TaxCode)" with command "COPY" for record "1"
And I set field "nummer" to "91" in row 0
And I set field "ustland" to "TSCHECHIEN" in row 0
And I save the current editor
And I close the current editor


Given I open an editor "position" from table "(Evaluation):(ItemNumber)" with command "NEW" for record ""
And I set field "nummer" to "091" in row 0
And I set field "such" to "P0091" in row 0
And I set field "meldungsnr" to "91" in row 0
And I set field "postyp" to "Mwst-Bemessung" in row 0
And I set field "namebspr" to "TESTDATEN" in row 0
And I set field "ev" to "Verkauf" in row 0
And I set field "ustland" to "TSCHECHIEN" in row 0
And I set field "w2ist" to "CZK" in row 0
And I create a new row at the end of the table
And I set field "sts" to "91" in row 1
And I save the current editor
And I close the current editor


# =========================================================================================


Scenario: einpaar SP anlegen

Given I open an editor "sammelpos0" from table "(Evaluation):(CollectiveItem)" with command "NEW" for record ""
And I set field "nummer" to "081SA" in row 0
And I set field "such" to "SA081" in row 0
And I set field "meldungsnr" to "81" in row 0
And I create a new row at the end of the table
And I set field "ustpos" to "81" in row 1
And I save the current editor
And I close the current editor

# mehrzeilige SP
Given I open an editor "sammelpos1" from table "(Evaluation):(CollectiveItem)" with command "NEW" for record ""
And I set field "nummer" to "181SA" in row 0
And I set field "such" to "SA181" in row 0
And I set field "meldungsnr" to "81" in row 0
And I create a new row at the end of the table
And I set field "ustpos" to "81" in row 1
And I create a new row at the end of the table
And I set field "ustpos" to "50" in row 2
And I set field "ustposanteil" to "-1" in row 2
And I save the current editor
And I close the current editor

Given I open an editor "sammelpos2" from table "(Evaluation):(CollectiveItem)" with command "NEW" for record ""
And I set field "nummer" to "091SA" in row 0
And I set field "such" to "SA091" in row 0
And I set field "postyp" to "VSt-Bemessung" in row 0
And I set field "ev" to "Einkauf" in row 0
And I set field "meldungsnr" to "91" in row 0
And I create a new row at the end of the table
And I set field "ustpos" to "91" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "sammelpos3" from table "(Evaluation):(CollectiveItem)" with command "NEW" for record ""
And I set field "nummer" to "281SA" in row 0
And I set field "such" to "SA281" in row 0
And I set field "meldungsnr" to "81" in row 0
And I create a new row at the end of the table
And I set field "ustpos" to "81" in row 1
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Geloeschte/abgelegte Sammelposition im Formular


# USt-Formular auf den aktuellen Jahr bringen
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
#
# Kontrolle in der Zeile 1
Then field "bempos" has value "81" in row 1
Then field "bemgr" has value "1460385.00" in row 1
Then field "stsatz" has value "19.00" in row 1
Then field "stpos" has value "200" in row 1
Then field "stbetr" has value "277473.15" in row 1
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "277473.22" in row 1
Then field "tstdiff" has value "-0.07" in row 1
#
# Kontrolle; in SP ist nur P81 drin -> deswegen muessen die Werte gleich sein
And I set field "bempos" to "081SA" in row 1
And I press button "berech"
Then field "bempos" has value "081SA" in row 1
Then field "bemgr" has value "1460385.00" in row 1
Then field "stsatz" has value "19.00" in row 1
Then field "stpos" has value "200" in row 1
Then field "stbetr" has value "277473.15" in row 1
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "277473.22" in row 1
Then field "tstdiff" has value "-0.07" in row 1
#
And I save the current editor
And I close the current editor


Given I'm logged in with password "annette"
Given I enable the flag 71
# SP 081SA abgelegen
Given I execute FOP "XDELSP"
Given I disable the flag 71
Given I'm logged in with password "sy"


# USt-Formular im Zeigen
Given I open an editor "formular_view1" from table "(Evaluation):(AdvanceVATReturn)" with command "VIEW" for record "2011"
# Kontrolle in der Zeile 1
Then field "bempos" has value "+081SA" in row 1
Then field "bemgr" has value "1460385.00" in row 1
Then field "stsatz" has value "19.00" in row 1
Then field "stpos" has value "200" in row 1
Then field "stbetr" has value "277473.15" in row 1
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "277473.22" in row 1
Then field "tstdiff" has value "0.00" in row 1
And I close the current editor

# USt-Formular im Aendern
Given I open an editor "formular_update1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
# Kontrolle in der Zeile 1
Then field "bempos" has value "+081SA" in row 1
Then field "bemgr" has value "1460385.00" in row 1
Then field "stsatz" has value "19.00" in row 1
Then field "stpos" has value "200" in row 1
Then field "stbetr" has value "277473.15" in row 1
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "277473.22" in row 1
Then field "tstdiff" has value "0.00" in row 1
#
And I press button "berech"
#
# Button "Berechne Formular" hat abgelegte SP nicht bemerkt
Then field "bemgr" has value "1460385.00" in row 1
Then field "stsatz" has value "19.00" in row 1
Then field "stpos" has value "200" in row 1
Then field "stbetr" has value "277473.15" in row 1
Then field "kpos" has value "581" in row 1
Then field "kpbetr" has value "277473.22" in row 1
#
# Versuch mit abgelegter Position in der Tabelle abzuspeichern
And saving the current editor throws the exception "4959"
#
# abgelegte Position aus der Tabelle loeschen
And I set field "bempos" to "" in row 1
Then field "bempos" is empty in row 1
And I save the current editor
And I close the current editor

# USt-Formular im Aendern
Given I open an editor "formular_update2" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
Then field "bempos" is empty in row 1
# Versuch eine abgelegte SP einzutragen
Then setting field "bempos" to "+081SA" in row 1 throws the exception "1361"
#
Then field "bempos" is empty in row 1
Then field "bemgr" has value "0.00" in row 1
# muesste "stsatz" eigentlich leer sein
Then field "stsatz" has value "19.00" in row 1
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Geaenderte Sammelposition im Formular

# USt-Formular auf den aktuellen Jahr bringen
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
#
And I set field "bempos" to "091SA" in row 12
And I press button "berech"
And I save the current editor
And I close the current editor


Given I open an editor "sammelpos_update" from table "(Evaluation):(CollectiveItem)" with command "UPDATE" for record "091SA"
Then field "nummer" has value "091SA" in row 0
Then field "postyp" has value "VSt-Bemessung" in row 0
Then field "ev" has value "E" in row 0
Then field "meldungsnr" has value "91" in row 0
Then field "ustland" has value "DEUTSCHLAND" in row 0
# zuerst Tabelle leeren
And I set field "ustpos" to "" in row 1
# Aenderungen
And I set field "such" to "SA091B" in row 0
And I set field "meldungsnr" to "091" in row 0
And I set field "such" to "SA091B" in row 0
And I set field "ev" to "Verkauf" in row 0
And I set field "postyp" to "Mwst-Bemessung" in row 0
And I set field "ustland" to "TSCHECHIEN" in row 0
And I set field "w2ist" to "CZK" in row 0
#
And I set field "ustpos" to "091" in row 1
And I save the current editor
And I close the current editor


# USt-Formular im Zeigen
Given I open an editor "formular_view1" from table "(Evaluation):(AdvanceVATReturn)" with command "VIEW" for record "2011"
# Kontrolle in der Zeile 12
Then field "bempos" has value "091SA" in row 12
Then field "bemgr" has value "0.00" in row 12
And I close the current editor


# USt-Formular im Aendern
Given I open an editor "formular_update1" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
# Kontrolle in der Zeile 12
Then field "bempos" has value "091SA" in row 12
Then field "bemgr" has value "0.00" in row 12
And I press button "berech"
#
And saving the current editor throws the exception "1058"
And I set field "bempos" to "91" in row 12
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Waehrung im Formular aendern

# USt-Formular
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
#
And I set field "waehr" to "CZK"
# hier passiert nix
And I press button "berech"
#
And saving the current editor throws the exception "1052"
And I set field "waehr" to "EUR"
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Sammelposition ohne Meldungsnummer im Formular; Fehlerzustand

# USt-Formular auf den aktuellen Jahr bringen
Given I open an editor "formular_update" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "."
And I set field "gendjahr" to "."
And I set field "ganmon" to "1"
And I set field "gendmon" to "12"
And I press button "berech"
#
And I set field "bempos" to "281SA" in row 1
And I press button "berech"
And I save the current editor
And I close the current editor


Given I'm logged in with password "annette"
Given I enable the flag 71
# SP 281SA -> Meldungsnummer loeschen
Given I execute FOP "XUPDATESP"
Given I disable the flag 71
Given I'm logged in with password "sy"


# USt-Formular
Given I open an editor "formular_view" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "2011"
And I press button "berech"
# fehlerhafte SP wird nicht entdeckt
And I save the current editor
And I close the current editor
# =========================================================================================


