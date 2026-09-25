/*-----------------------------------------------------------------------------
 * Modul Name       : ContainerSteps.java
 * Verwendung       : Individuelle Steps fuer Behaelter
 * Autor            : carue
 * Verantwortlich   : carue
 * Kontrolle        : drpf
 *---------------------------------------------------------------------------*/
package de.abas.erp.cucumber.behaelter;

import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import de.abas.acceptanceTests.stepDefs.*;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;

public class ContainerSteps {

	private GeneralERPStepDefs mysteps;
	private ERPTestContext context;

	public ContainerSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		this.context = context;
		mysteps = new GeneralERPStepDefs(context, handler, helper);
	}

	/**
	 * Step: Then Container from editor \"([^\"]*)\" is empty
	 *
	 * Prueft anhand folgender Bedingungen, ob der angegebene
	 * Behaeltereditor leer ist und schliesst danach den Editor:
	 *  - Statusfeld "behstatusaz" ist leer
	 *  - Feld "behleer" ist gesetzt
	 *  - Tabelle hat keine Zeilen
	 *
	 *  CUCU-88
	 *
	 */
	@Then("^Container from editor \"([^\"]*)\" is empty$")
	public void container_from_editor_is_empty(String editor) throws Throwable {
		mysteps.setUp(context.currentScenario);
		editor = editor.trim();
		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor(editor, "(Container):(ContainerShell)", "VIEW", editor);
		mysteps.field_is_empty("behstatusaz");
		mysteps.field_has_value("behleer", "ja");
		mysteps.field_is_empty("platz");
		mysteps.the_table_has_rows(0);
		mysteps.I_close_the_editor();
	}

	/**
	 * Step: Then Container \"([^\"]*)\" is empty
	 *
	 * Prueft anhand folgender Bedingungen, ob der angegebene
	 * Behaelter leer ist und schliesst danach den Editor:
	 *  - Statusfeld "behstatusaz" ist leer
	 *  - Feld "behleer" ist gesetzt
	 *  - Tabelle hat keine Zeilen
	 *
	 * Dabei kann der Behaelter anhand Suchwort oder Nummer
	 * angegeben werden.
	 *
	 * CUCU-89
	 *
	 */
	@Then("^Container \"([^\"]*)\" is empty$")
	public void container_for_record_is_empty(String record) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_open_an_editor_from_table_with_command_for_record2(record.trim(), "(Container):(ContainerShell)", "VIEW", record);
		mysteps.field_is_empty("behstatusaz");
		mysteps.field_has_value("behleer", "ja");
		mysteps.the_table_has_rows(0);
		mysteps.I_close_the_editor();
	}

	/**
	 * Step: And I create a Container \"([^\"]*)\" for packaging material \"([^\"]*)\" and search word \"([^\"]*)\"
	 *
	 * Legt einen neuen Behaelter mit angegebenem Packmittel und Suchwort an.
	 * Laesst man das Packmittel leer, wird automatisch der KLT verwendet.
	 * Laesst man das Suchwort leer, wird automatisch das Suchwort des Packmittels gesetzt.
	 *
	 * CUCU-90
	 *
	 */
	@And("^I create a Container \"([^\"]*)\" for packaging material \"([^\"]*)\" and search word \"([^\"]*)\"$")
	public void create_container_for_packaging_material_and_search_word(String editor, String packMat, String searchWord) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_open_an_editor_from_table_with_command_for_record2(editor.trim(), "(Container):(ContainerShell)", "NEW", "");
		mysteps.I_set_field_to("such", searchWord.trim());
		mysteps.I_set_field_to("exbehnum", searchWord.trim());

		if (packMat.equals("")) {
			packMat = "KLT";
		}

		mysteps.I_set_field_to("packm", packMat);
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: And I create a Container \"([^\"]*)\" for packaging material \"([^\"]*)\"
	 *
	 * Legt einen neuen Behaelter mit angegebenem Packmittel.
	 * Laesst man das Packmittel leer, wird automatisch der KLT verwendet.
	 * Als Suchwort wird der Name des Editors verwendet
	 *
	 * CUCU-90
	 *
	 */
	@And("^I create a Container \"([^\"]*)\" for packaging material \"([^\"]*)\"$")
	public void create_container_for_packaging_material(String editor, String packMat) throws Throwable {
		create_container_for_packaging_material_and_search_word(editor, packMat, editor);
	}

	/**
	 * Step: And I create a Container \"([^\"]*)\" for packaging material \"([^\"]*)\" if condition is \"([^\"]*)\"
	 *
	 * Legt einen neuen Behaelter mit angegebenem Packmittel an, wenn die Bedingung = "ja" ist.
	 * Dies ist vor allem in Verbindung mit Scenaio Outline und einer Parametrisierung der strCondition sinnvoll
	 * Als Suchwort wird der Name des Editors verwendet
	 *
	 * CUCU-91
	 *
	 */
	@And("^I create a Container \"([^\"]*)\" for packaging material \"([^\"]*)\" if condition is \"([^\"]*)\"$")
	public void i_create_container_for_packaging_material_if_condition_is(String EditorId, String strPackingMaterial, String strCondition) throws Throwable {
		if(!strCondition.equals("ja") ) {
			return;
		}
		create_container_for_packaging_material_and_search_word(EditorId, strPackingMaterial , EditorId);
	}

	/**
	 * Step: And I set status of Container \"([^\"]*)\" to empty
	 *
	 * Aktiviert einen Behaelter wieder, der
	 * außer Haus war (Status "Ruecklieferung" oder "Geliefert"),
	 * indem der behstatus auf leer gesetzt wird.
	 *
	 * CUCU-93
	 */
	@And("^I set status of Container \"([^\"]*)\" to empty$")
	public void i_set_status_of_container_to_empty(String editor) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor("reactivate", "(Container):(ContainerShell)", "UPDATE", editor);
		mysteps.I_set_field_to("behstatusaz", "");
		mysteps.i_save_the_current_editor();
	}
}
