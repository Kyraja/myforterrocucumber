package de.abas.erp.cucumber.print;

import cucumber.api.java.en.Given;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;

public class PrintSteps {

	private ERPTestContext context;
	private GeneralERPStepDefs mysteps;

	public PrintSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		this.context = context;
		mysteps = new GeneralERPStepDefs(context, handler, helper);
	}

	// Normaler Druck
	@Given("I print layout \"([^\"]*)\" with printer \"([^\"]*)\" and filename \"([^\"]*)\" with quantity \"([^\"]*)\" and copies \"([^\"]*)\"")
	public void I_print_layout_with_printer(String layout, String printer, String filename, String quantity, String copies) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_press_in_row_to_open_a_subeditor_for("budruck2", "Druckdialog", "0");
		mysteps.I_set_field_to("layout", layout);
		mysteps.I_set_field_to("drucker", printer);
		mysteps.I_set_field_to("exemplare", quantity);
		mysteps.I_set_field_to("anzahl", copies);
		mysteps.I_set_field_to("datname", filename);
		mysteps.i_save_the_current_editor();
		mysteps.i_close_the_current_subeditor_to_switch_back_to_the_parent_editor();
	}

	@Given("I print layout \"([^\"]*)\" with printer \"([^\"]*)\" and filename \"([^\"]*)\"")
	public void I_print_layout_with_printer_and_filename(String layout, String printer, String filename) throws Throwable {
		I_print_layout_with_printer(layout, printer, filename, "!dontChange", "!dontChange");
	}

	@Given("I print layout \"([^\"]*)\" with filename \"([^\"]*)\"")
	public void I_print_layout_with_printer(String layout, String filename) throws Throwable {
		I_print_layout_with_printer(layout, "!dontChange", filename, "!dontChange", "!dontChange");
	}

	@Given("I print layout \"([^\"]*)\"")
	public void I_print_layout_with_printer(String layout) throws Throwable {
		I_print_layout_with_printer(layout, "!dontChange", "!dontChange", "!dontChange", "!dontChange");
	}

	// Druckvorschau
	@Given("I print preview for layout \"([^\"]*)\"")
	public void I_print_preview_for_layout(String layout) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_press_in_row_to_open_a_subeditor_for("budruck2", "Druckdialog", "0");
		mysteps.I_set_field_to("layout", layout);
		mysteps.i_press_button("buvorschau");
		mysteps.i_close_the_current_subeditor_to_switch_back_to_the_parent_editor();
	}

}
