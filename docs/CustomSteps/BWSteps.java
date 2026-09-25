/*-----------------------------------------------------------------------------
 * Modul Name       : BWSteps.java
 * Verwendung       : Bewertung
 * Autor            : sih
 * Verantwortlich   : sih
 * Kontrolle        : wane, carue
 *---------------------------------------------------------------------------*/

package de.abas.erp.cucumber.bewertung;

import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;
import de.abas.ceks.jedp.EDPEditor;

public class BWSteps {

	private ERPTestContext context;
	private GeneralERPStepDefs mysteps;

	public BWSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		this.context = context;
		mysteps = new GeneralERPStepDefs(context, handler, helper);
	}

	/**
	 * Step: Given I open an editor "([^\"]*)" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
	 *
	 * Creates a CostEntriesSuggestion.
	 *
	 * CUCU-94
	 */
	@Given("^I create a CostEntriesSuggestion \"([^\"]*)\" with type of cost entry \"([^\"]*)\" for startdate \"([^\"]*)\" until enddate \"([^\"]*)\"$")
	public void i_create_a_CostEntriesSuggestion_with_type_of_cost_entry_for_startdate_until_enddate(String Suchname, String TypeOfCostEntry, String startdate, String enddate) throws Throwable {
		mysteps.setUp(context.currentScenario);
		boolean bStartDatumlb = true;
		boolean bStartDatumfk = true;
		boolean bStartDatumlbue = true;
		boolean bStartDatumfkue = true;

		// Ist das entsprechende Startdatum gesetzt?
		mysteps.i_open_an_editor_from_table_with_command_for_record("TERM", "(Company):(FinancialDates)", "VIEW", "TERM", "");
		EDPEditor editor = context.getCurrentEditor();

		if (editor.getFieldVal("klbmindat").equals("")) {
			bStartDatumlb = false;
		}

		if (editor.getFieldVal("rmmindat").equals("")) {
			bStartDatumfk = false;
		}

		if (editor.getFieldVal("kuemindat").equals("")) {
			bStartDatumlbue = false;
		}

		if (editor.getFieldVal("rmuemindat").equals("")) {
			bStartDatumfkue = false;
		}

		mysteps.I_close_the_editor();

		mysteps.i_open_an_editor_from_table_with_command_for_record(Suchname, "(CostEntriesSuggestion):(CostEntriesSuggestion)", "NEW", "", "");
		mysteps.I_set_field_to("kosart", TypeOfCostEntry);
		mysteps.I_set_field_to("adat", startdate);
		mysteps.I_set_field_to("edat", enddate);
		mysteps.I_set_field_to("such", Suchname);
		mysteps.i_press_button("kosvor");

		int zeilen = context.getCurrentEditor().getRowCount();
		if (zeilen >= 1) {
			boolean buchen = false;
			for (int zeile = 1; zeile <= zeilen && !buchen; zeile++) {
				if (context.getCurrentEditor().getFieldVal(zeile, "buchen").equals("ja")) {
					buchen = true;
				}
			}

			// Verbuchen, nur wenn es wirklich etwas zu verbuchen gibt
			if (buchen) {
				mysteps.i_set_dialog_answer_for("Ja", "2324");
			} else {
				mysteps.i_set_dialog_answer_for("Ja", "9402");
			}

			if (TypeOfCostEntry.equals("Verbuchung Lagerbestand") && !bStartDatumlb ||
					TypeOfCostEntry.equals("Verbuchung Fertigungskosten") && !bStartDatumfk ||
					TypeOfCostEntry.equals("Verbuchung Bestand unfertige Erzeugnisse") && !bStartDatumlbue ||
					TypeOfCostEntry.equals("Verbuchung Fertigungskosten unfertige Erzeugnisse") && !bStartDatumfkue) {
				mysteps.i_set_dialog_answer_for("1", "7332");
			}
			mysteps.i_save_the_current_editor();
		} else {
			mysteps.I_close_the_editor();
		}
	}


	/**
	 * Step: Given I create CostEntriesSuggestions \"([^\"]*)\" with all types of cost entry for startdate \"([^\"]*)\" until enddate \"([^\"]*)\" with Command Revalue"
	 *
	 * Create CostEntriesSuggestions for all types of cost entry.
	 *
	 * CUCU-95
	 */
	@Given("^I create CostEntriesSuggestions \"([^\"]*)\" with all types of cost entry for startdate \"([^\"]*)\" until enddate \"([^\"]*)\" with Command Revalue$")
	public void i_create_CostEntriesSuggestions_with_all_types_of_cost_entry_for_startdate_until_enddate_with_Command_Revalue(
			String Suchname, String startdate, String enddate) throws Throwable {
		/*
		 * Step-Beschreibung:
		 * ==================
		 * mit diesem Step werden Kostenbuchungsvorschlaege (KBV) fuer alle Arten der Kostenbuchungen
		 * (es gibt 4 davon) erzeugt und zwar nur dann, wenn es wirklich was zu verbuchen gibt.
		 * Vorher wird 'Nachbewerten' ausgefuehrt.
		 *
		 * Wenn ein KBV fuer eine bestimmte Art der Kostenbuchungen zum ersten Mal
		 * im System aufgerufen wird, dann wird auch das Startdatum fuer die Art
		 * im Termindatensatz gesetzt/eingetragen.
		 */

		mysteps.setUp(context.currentScenario);
		boolean bStartDatumlb = true;    // Startdatum fuer Kostenbuchungen (Lagerbestand)
		boolean bStartDatumfk = true;    // Startdatum fuer Kostenbuchungen (Fertigungskosten)
		boolean bStartDatumlbue = true;  // Startdatum fuer Kostenbuchungen (Bestand unfertige Erzeugnisse)
		boolean bStartDatumfkue = true;  // Startdatum fuer Kostenbuchungen (Fertigungskosten unfertiger Erzeugnisse)

		// Ist das entsprechende Startdatum gesetzt?
		mysteps.i_open_an_editor_from_table_with_command_for_record("TERM", "(Company):(FinancialDates)", "VIEW", "TERM", "");
		EDPEditor editor = context.getCurrentEditor();
		if (editor.getFieldVal("klbmindat").equals("")) {
			bStartDatumlb = false;
		}
		if (editor.getFieldVal("rmmindat").equals("")) {
			bStartDatumfk = false;
		}
		if (editor.getFieldVal("kuemindat").equals("")) {
			bStartDatumlbue = false;
		}
		if (editor.getFieldVal("rmuemindat").equals("")) {
			bStartDatumfkue = false;
		}
		mysteps.I_close_the_editor();

		// Nachbewerten ausfueren
		i_run_revaluation();

		String TypesOfCostEntry[] = {
				"Verbuchung Lagerbestand",
				"Verbuchung Bestand unfertige Erzeugnisse",
				"Verbuchung Fertigungskosten",
				"Verbuchung Fertigungskosten unfertige Erzeugnisse"};

		for (int art = 0; art < 4; art++) {
			mysteps.i_open_an_editor_from_table_with_command_for_record(Suchname,
					"(CostEntriesSuggestion):(CostEntriesSuggestion)", "NEW", "", "");
			mysteps.I_set_field_to("kosart", TypesOfCostEntry[art]);
			mysteps.I_set_field_to("adat", startdate);
			mysteps.I_set_field_to("edat", enddate);
			mysteps.I_set_field_to("such", Suchname);
			mysteps.i_press_button("kosvor");

			int zeilen = context.getCurrentEditor().getRowCount();
			if (zeilen >= 1) {
				boolean buchen = false; // ob es verbuchbare Zeile gibt
				for (int zeile = 1; zeile <= zeilen && !buchen; zeile++) {
					if (context.getCurrentEditor().getFieldVal(zeile, "buchen").equals("ja")) {
						buchen = true;
					}
				}

				// Verbuchen, nur wenn es wirklich etwas zu verbuchen gibt
				if (buchen) {
					mysteps.i_set_dialog_answer_for("Ja", "2324");
				} else {
					mysteps.i_set_dialog_answer_for("Ja", "9402");
				}

				if (art == 0 && !bStartDatumlb
						|| art == 1 && !bStartDatumlbue
						|| art == 2 && !bStartDatumfk
						|| art == 3 && !bStartDatumfkue) {
					mysteps.i_set_dialog_answer_for("1", "7332");
				}
				mysteps.i_save_the_current_editor();
			}

			mysteps.I_close_the_editor();
		}
	}


	/**
	 * Step: And I run Revaluation
	 *
	 * Startet das Tippkommando Nachbewerten und schließt anschließend den geöffneten Editor
	 *
	 * CUCU-61
	 */
	@And("^I run Revaluation$")
	public void i_run_revaluation() throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.an_editor_for_tip_command("Nachbewerten", "(Revalue)", "");
		mysteps.I_close_the_editor();
	}

	/**
	 * Step: Given I open latest Valuation "" for Product "" and valuation transaction "" with command ""
	 *
	 * Oeffnet die aktuelle (lebendige) Bewertung für einen Artikel und
	 * Bewertungsvorgang (Lagerjournaleintrag) mit dem angegebenen Kommando
	 *
	 * CUCU-142
	 */
	@Given("^I open latest Valuation \"([^\"]*)\" for Product \"([^\"]*)\" and valuation transaction \"([^\"]*)\" with command \"([^\"]*)\"$")
	public void i_open_valuation_for_product_ppsrefid(String editor, String product, String journal, String command) throws Throwable {
		mysteps.setUp(context.currentScenario);

		EDPEditor journEditor = context.editorMap.get(journal);
		String ppsrefid = journEditor.getEditRef();

		String select_record = "$,,artikel^such==" + product + ";ppsrefid==" + ppsrefid + ";@ablageart=lebendig;";
		mysteps.i_open_an_editor_from_table_with_command_for_record(editor, "(Valuation):(Valuation)", command, select_record, "");
	}
}


