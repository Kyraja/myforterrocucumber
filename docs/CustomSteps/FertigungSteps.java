/*-----------------------------------------------------------------------------
 * Modul Name       : FertigungSteps.java
 * Verwendung       : Individuelle Steps fuer die Fertigung
 * Autor            : carue
 * Verantwortlich   : carue
 * Kontrolle        : amk, drpf
 *---------------------------------------------------------------------------*/
package de.abas.erp.cucumber.fertigungbde;

import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.EditorHandler;
import de.abas.ceks.jedp.EDPEditor;

public class FertigungSteps {

	private ERPTestContext context;
	private GeneralERPStepDefs mysteps;
	private static String value;

	public FertigungSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		this.context = context;
		mysteps = new GeneralERPStepDefs(context, handler, helper);
	}

	/**
	 * Step: And I save workorder number from WorkOrderSuggestion in row (\\d+|!lastRow)
	 *
	 * Must only be called from table (Purchasing):(WorkOrderSuggestions)
	 * Saves the value if field "banummer" from (filed) workorder suggestion
	 *
	 * @throws NotAWorkOrderException when called from any other table
	 *
	 * CUCU-37
	 */
	@And("^I save workorder number from WorkOrderSuggestion in row (\\d+|!lastRow)$")
	public void i_save_wonumber_from_wosuggestion_in_row(String row) throws Throwable {
		EDPEditor myEditor = this.context.currentEditor;

		/* Not a workorder suggestion */
		if (myEditor.getEditDatabaseNr() != 4
			&& myEditor.getEditGroupNr() != 11) {
			throw new NotAWorkOrderException("Editor is not a workorder suggestion");
		}

		value = myEditor.getFieldVal(getRowFromString(row), "banummer");
		value.trim();
	}

	/**
	 * Step: I create a WorkOrder \"([^\"]*)\" for Product \"([^\"]*)\" with quantity \"([^\"]*)\" and search word \"([^\"]*)\"$"
	 *
	 * Create and release a standard work order suggestion with a specific product, quantitiy and search word
	 * to create a work order.
	 *
	 * CUCU-217
	 *
	 */
	@Given("^I create a WorkOrder \"([^\"]*)\" for Product \"([^\"]*)\" with quantity \"([^\"]*)\" and search word \"([^\"]*)\"$")
	public void i_create_a_WorkOrder_with_quantity_and_searchword(String editorName, String product, String quantity, String searchword) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record(editorName, "(Purchasing):(WorkOrderSuggestions)", "NEW", "", "");
		mysteps.i_create_a_new_row_at_the_end_of_the_table();
		mysteps.I_set_field_to_in_row("artikel", product, "1");
		mysteps.I_set_field_to_in_row("mge", quantity, "1");
		mysteps.I_set_field_to_in_row("bisuch", editorName, "1");
		mysteps.I_set_field_to_in_row("mfreig", "ja", "1");
		mysteps.I_set_field_to_in_row("bisuch", searchword, "1");
		mysteps.i_press_to_open_a_subeditor_for("freig", "Freigabe");
		mysteps.i_close_the_current_subeditor_to_switch_back_to_the_parent_editor();
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: And I set WorkSlip to (!alive|!filed) workorder number in row (\\d+|!lastRow)
	 *
	 * Sets field "barmex" in current editor to saved workorder number (filed or alive)
	 *
	 * CUCU-118
	 */
	@And("^I set WorkSlip to (!alive|!filed) workorder number in row (\\d+|!lastRow)$")
	public void i_set_field_to_filed_wonumber_in_row(String is_filed, String row) throws Throwable {
		String filed_value = value;

		if (is_filed.equals("!filed")) {
			filed_value = "+" + value;
		}

		this.context.currentEditor.setFieldVal(getRowFromString(row), "barmex", filed_value);
	}

	/* Hilfsfunktion zum Bestimmen der Zeilennummer */
	private int getRowFromString(String row) {
		if (row.equals("!lastRow")) {
			return this.context.currentEditor.getRowCount();
		}

		if (row.equals("")) {
			return 0;
		}

		return Integer.parseInt(row);
	}
}

class NotAWorkOrderException extends Exception
{
	private static final long serialVersionUID  = 1L;

	public NotAWorkOrderException(String message) {
		super("\n" + message);
	}
}
