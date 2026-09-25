# *****************************************************************************
#  Name           : individuelle_steps_testen.feature
#  Autor          : uo
#  Verantwortlich : uo
#  Funktion       : Test indiv. sripte
# *****************************************************************************

@persistent
Feature: Test indiv. mawi-sripte
Background:
Given I set the fake date to "02.01.1995"

Scenario: skript testen
# --- nur versuchsweise ---
Given I open an editor "out1" from table "(StorageQuantity):(LocationQuantity)" with command "VIEW" for search criteria "$,,artikel==E1;bestand<>0;platz==F1"
Then I fill template "storagequantity_ref_output1.ftl" and append it to output file "cucu_template_testweise.ref"
And I close the current editor

And I append "jodel3" to output file "append_to_file.ref" in cucu_refs_dir
And I append "jodel4" to output file "append_to_file.ref" in cucu_refs_dir

And I export "lgruppe,lager,platz,charge,projekt,verw,gebmge,lffert,bewmge" from table "(StorageQuantity):(LocationQuantityElement)" where "artikel==E1;gebmge<>0;@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,verw,gebmge.rueckw,lj^id" to output file "cucu_export_in_datei.ref"

And I delete file "cucu_ausgabe_stock_quantities.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==E1;gebmge<>0;platz<>`" to output file "cucu_ausgabe_stock_quantities.ref"

And I append "delete testen" to output file "cucu_delete_file_test_darf_nach_lauf_nicht_mehr_existieren.txt" in cucu_refs_dir
And I delete file "cucu_delete_file_test_darf_nach_lauf_nicht_mehr_existieren.txt" in cucu_refs_dir
#  im anschluss im testbett file prüfen, ob die datei noch da ist!

# datei ausserhalb im testbett erzeugen!
And I delete file "datei_zum_loeschen_ueber_cucu_delete_file.txt" in cucu_refs_dir
#  im anschluss im testbett file prüfen, ob die datei noch da ist!
