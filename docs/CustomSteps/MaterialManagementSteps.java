/*-----------------------------------------------------------------------------
 * Modul Name       : MaterialManagementSteps.java
 * Verwendung       : Individuelle Steps fuer Materialmanagement
 * Autor            : carue
 * Verantwortlich   : carue
 * Kontrolle        : 
 *---------------------------------------------------------------------------*/
package de.abas.erp.cucumber.common;

import cucumber.api.java.en.And;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;
import de.abas.ceks.jedp.EDPEditor;

public class MaterialManagementSteps {

	private GeneralERPStepDefs mysteps;
	private ERPTestContext context;

	public MaterialManagementSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		this.context = context;
		this.mysteps = new GeneralERPStepDefs(context, handler, helper);
	}

	/**
	 * Step: And I press button for next product
	 *
	 * Button "Naechster Artikel" in der MZ druecken
	 *
	 * CUCU-2xx
	 */
	@And("^I press button for next product$")
	public void i_press_button_for_next_product() throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_press_to_open_a_subeditor_for("abv", "NextProduct");
		mysteps.i_close_the_current_subeditor_to_switch_back_to_the_parent_editor();
	}

	/**
	 * Step: And I press button for previous product
	 *
	 * Button "Vorheriger Artikel" in der MZ druecken
	 *
	 * CUCU-2xx
	 */
	@And("^I press button for previous product$")
	public void i_press_button_for_previous_product() throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_press_to_open_a_subeditor_for("abr", "PreviousProduct");
		mysteps.i_close_the_current_subeditor_to_switch_back_to_the_parent_editor();
	}
	
	/**
	 * Step: And I descend to a lower level of the BOM in row ""
	 *
	 * Button "Absteigen" in einer Zeile der AFL druecken
	 *
	 * CUCU-2xx
	 */
	@And("^I descend to a lower level of the BOM in row (\\d+|!lastRow)$")
	public void i_descend_to_lower_level_of_BOM_in_row(String row) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_press_in_row_to_open_a_subeditor_for("absteig", "descendBOM", row);;
		mysteps.i_close_the_current_subeditor_to_switch_back_to_the_parent_editor();
	}

	/**
	 * Step: And I ascend to a higer level of the BOM
	 *
	 * Button "Aufsteigen" in der AFL druecken
	 *
	 * CUCU-2xx
	 */
	@And("^I ascend to a higher level of the BOM$")
	public void i_ascend_to_higer_level_of_BOM() throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_press_to_open_a_subeditor_for("aufsteig", "ascendBOM");;
		mysteps.i_close_the_current_subeditor_to_switch_back_to_the_parent_editor();
	}
}

