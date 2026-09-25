/*-----------------------------------------------------------------------------
 * Modul Name       : DispoSteps.java
 * Verwendung       : Individuelle Steps fuer die Disposition
 * Autor            : carue
 * Verantwortlich   : carue
 * Kontrolle        : bheim
 *---------------------------------------------------------------------------*/
package de.abas.erp.cucumber.disposition;

import de.abas.erp.cucumber.common.CommonCustomedSteps;
import cucumber.api.java.en.And;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.stepDefs.InfosystemStepDefs;
import de.abas.acceptanceTests.stepDefs.QueryStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;
import de.abas.ceks.jedp.EDPEditor;
import de.abas.ceks.jedp.EDPQuery;
import de.abas.erp.cucumber.common.CommonCustomedSteps;


public class DispoSteps {

	private ERPTestContext context;
	private GeneralERPStepDefs mysteps;
	private InfosystemStepDefs myinfosteps;
	private QueryStepDefs myqueries;
	private CommonCustomedSteps mycustomedsteps;


//	public DispoSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
//	mysteps = new GeneralERPStepDefs(context, handler, helper);

	public DispoSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
	this.context = context;
	mysteps = new GeneralERPStepDefs(context, handler, helper);
	myinfosteps = new InfosystemStepDefs(context);
	myqueries = new QueryStepDefs(context, helper);
	mycustomedsteps = new CommonCustomedSteps(context, handler, helper);

	}

	/**
	 * Step: And I run Scheduling
	 *
	 * Startet die Disposition ueber das Tippkommando "Disposition"
	 * und schliesst anschliessend den geoeffneten Editor.
	 *
	 * CUCU-51
	 */
	@And("^I run Scheduling$")
	public void i_run_scheduling() throws Throwable {
		mysteps.an_editor_for_tip_command("Disposition", "(Scheduling)", "");
		mysteps.I_close_the_editor();
	}

	/* Oeffnet das Infosystem Beschaffungsstatus BSTATUS fuer eine im Step angegebene Position
		aus einem vorab angelegten Auftrag (Referenz ueber Editor).

		CUCU-130
	 */
	@And ("^I open the infosystem ProcurementStatus for position (\\d+|!lastRow) of SalesOrder from editor \"([^\"]*)\"$")
	public void i_open_procstatus_for_transaction_from_editor(String position, String editorName) throws Throwable {
		mysteps.setUp(context.currentScenario);
		EDPEditor vorgang = context.getEditorFor(context.currentScenario, editorName);
		int row = getRowFromString(position);

		String ref = vorgang.getEditRef();
		vorgang.beginView(ref);
		String zid = vorgang.getFieldVal(row, "id");
		zid.trim();
		vorgang.endEditCancel();

		myinfosteps.i_open_the_infosystem("BSTATUS");
		context.getCurrentEditor().setFieldVal("select", zid);
		context.getCurrentEditor().setFieldVal("bstart", "1");
	}

	/**
	 * Hilfsfunktion zum Bestimmen der Zeilennummer
	 *
	 * @param row
	 *            Angabe der Zeilennummer oder !lastRow oder eine andere
	 *            interpretierbare Zeilenangabe
	 */
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
