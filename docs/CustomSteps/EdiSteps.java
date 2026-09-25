package de.abas.erp.cucumber.edi;

import org.junit.Assert;

import cucumber.api.java.en.And;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.stepDefs.InfosystemStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;

public class EdiSteps {

	private ERPTestContext erpContext;
	private GeneralERPStepDefs mysteps;
	private InfosystemStepDefs myinfosteps;

	public EdiSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		erpContext = context;
		mysteps = new GeneralERPStepDefs(context, handler, helper);
		myinfosteps = new InfosystemStepDefs(context);
	}

	/**
	 * Step: And I import DELFOR
	 *
	 * Import von Lieferabrufen ueber das Infosystem "EDIIMPORT"
	 *
	 * CUCU-191
	 *
	 */
	@And("^I import DELFOR$")
	public void i_import_delfor() throws Throwable {
		start_ediimport_for_message("2101");
	}

	/**
	 * Step: And I import DELJIT
	 *
	 * Import von Feinabrufen ueber das Infosystem "EDIIMPORT"
	 *
	 * CUCU-197
	 *
	 */
	@And("^I import DELJIT$")
	public void i_import_deljit() throws Throwable {
		start_ediimport_for_message("2102");
	}

	/**
	 * Step: And I import DELPUS
	 *
	 * Import von Versandabrufen ueber das Infosystem "EDIIMPORT"
	 *
	 * CUCU-201
	 *
	 */
	@And("^I import DELPUS$")
	public void i_import_delpus() throws Throwable {
		start_ediimport_for_message("2104");
	}

	/**
	 * Step: And I import ORDERS
	 *
	 * Import von ORDERS ueber das Infosystem "EDIIMPORT"
	 *
	 * CUCU-198
	 *
	 */
	@And("^I import ORDERS$")
	public void i_import_orders() throws Throwable {
		start_ediimport_for_message("2105");
	}

	/**
	 * Step: And I import ORDCHG
	 *
	 * Import von ORDCHG ueber das Infosystem "EDIIMPORT"
	 *
	 * CUCU-203
	 *
	 */
	@And("^I import ORDCHG$")
	public void i_import_ordchg() throws Throwable {
		start_ediimport_for_message("2106");
	}

	/**
	 * Infosytem EDIIMPORT starten und Nachrichten importieren.
	 * Der Parameter messageid gibt an, um welche Nachricht
	 * es sich handelt.
	 */
	private void start_ediimport_for_message(String messageid) throws Throwable {
		mysteps.setUp(erpContext.currentScenario);
		myinfosteps.i_open_the_infosystem("EDIIMPORT");
		mysteps.I_set_field_to("edinachr", messageid);
		mysteps.i_press_button("bstart");
		mysteps.i_press_button("buimport");
		mysteps.I_close_the_editor();
	}
	

	/**
	 * Step: And I process DELFOR
	 *
	 * Verarbeitung von Lieferabrufen ueber das Infosystem "EDIIMPVER"
	 *
	 * CUCU-192
	 *
	 */
	@And("^I process DELFOR$")
	public void i_process_delfor() throws Throwable {
		start_ediimpver_for_message(true);
	}
	

	/**
	 * Step: And I process DELJIT
	 *
	 * Verarbeitung von Feinabrufen ueber das Infosystem "EDIIMPVER"
	 *
	 * CUCU-199
	 *
	 */
	@And("^I process DELJIT$")
	public void i_process_deljit() throws Throwable {
		start_ediimpver_for_message(true);
	}

	/**
	 * Step: And I process DELPUS
	 *
	 * Verarbeitung von Versandabrufen ueber das Infosystem "EDIIMPVER"
	 *
	 * CUCU-202
	 *
	 */
	@And("^I process DELPUS$")
	public void i_process_delpus() throws Throwable {
		start_ediimpver_for_message(true);
	}

	/**
	 * Step: And I process ORDERS
	 *
	 * Verarbeitung von ORDERS ueber das Infosystem "EDIIMPVER"
	 *
	 * CUCU-200
	 *
	 */
	@And("^I process ORDERS$")
	public void i_process_orders() throws Throwable {
		start_ediimpver_for_message(false);
	}

	/**
	 * Step: And I process ORDCHG
	 *
	 * Verarbeitung von ORDCHG ueber das Infosystem "EDIIMPVER"
	 *
	 * CUCU-204
	 *
	 */
	@And("^I process ORDCHG$")
	public void i_process_ordchg() throws Throwable {
		start_ediimpver_for_message(false);
	}

	/**
	 * Infosytem EDIIMPVER starten und Nachrichten verarbeiten.
	 * Parameter is_abruf ist true, wenn es sich um eine Abrufnachricht
	 * handelt. Ansonsten wird von einer Orders-Nachricht ausgegangen.
	 */
	private void start_ediimpver_for_message(boolean is_abruf) throws Throwable {
		mysteps.setUp(erpContext.currentScenario);
		myinfosteps.i_open_the_infosystem("EDIIMPVER");

		if (is_abruf) {
			mysteps.I_set_field_to("kbabrufe", "1");
		} else {
			mysteps.I_set_field_to("kborders", "1");
		}

		mysteps.I_set_field_to("kballekunden", "1");
		mysteps.i_press_button("kbuverarb");
		mysteps.I_close_the_editor();
	}

}
