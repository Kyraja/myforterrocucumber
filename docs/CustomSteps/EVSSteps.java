package de.abas.erp.cucumber.ekvkservice;

import cucumber.api.java.en.Given;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;
import de.abas.ceks.jedp.EDPEditor;

public class EVSSteps {

	private ERPTestContext context;
	private GeneralERPStepDefs mysteps;

	public EVSSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		this.context = context;
		mysteps = new GeneralERPStepDefs(context, handler, helper);
	}

	/**
	 * Step: I create a SalesOrder "([^\"]*)" for customer "([^\"]*)" with product "([^\"]*)" and quantity "([^\"]*) and price ([^\"]*)"
	 *
	 * Creates a standard salesorder with one position for specific customer, product and quantitiy.
	 * EditorName and Searchword are equal
	 *
	 * CUCU-106
	 *
	 */
	@Given("I create a SalesOrder \"([^\"]*)\" for customer \"([^\"]*)\" with product \"([^\"]*)\" and quantity \"([^\"]*)\" and price \"([^\"]*)\"$")
	public void i_create_a_SalesOrder_for_customer_with_product_and_quantity_and_price(String EditorName, String Customer, String Product, String Quantity, String Price) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record(EditorName, "(Sales):(SalesOrder)", "NEW", "", "");
		mysteps.I_set_field_to("kunde", Customer);
		mysteps.I_set_field_to("such", EditorName);
		mysteps.I_set_field_to("kenn", EditorName);
		mysteps.i_create_a_new_row_at_the_end_of_the_table();
		mysteps.I_set_field_to_in_row("artex", Product, "1");
		mysteps.I_set_field_to_in_row("mge", Quantity, "1");
		if( Price != "") {
			mysteps.I_set_field_to_in_row("preis", Price, "1");
		}
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I create a SalesOrder "([^\"]*)" for customer "([^\"]*)" with product "([^\"]*)" and quantity "([^\"]*)"
	 *
	 * Creates a standard salesorder with one position for specific customer, product and quantitiy.
	 * EditorName and Searchword are equal
	 */
	@Given("^I create a SalesOrder \"([^\"]*)\" for customer \"([^\"]*)\" with product \"([^\"]*)\" and quantity \"([^\"]*)\"$")
	public void i_create_a_SalesOrder_for_customer_with_product_and_quantity(String EditorName, String Customer, String Product, String Quantity) throws Throwable {
		i_create_a_SalesOrder_for_customer_with_product_and_quantity_and_price(EditorName, Customer, Product, Quantity, "");
	}

	/**
	 * Step: I create a PurchaseOrder "([^\"]*)" for vendor "([^\"]*)" with product "([^\"]*)" and quantity "([^\"]*)" and price "([^\"]*)"$")
	 *       I create a SalesOrder "([^\"]*)" for customer "([^\"]*)" with product "([^\"]*)" and quantity "([^\"]*)"
	 *
	 * Creates a standard purchaseorder with one position for specific vendor, product and quantitiy and price.
	 * EditorName and Searchword and kenn are equal
	 *
	 * CUCU-107
	 * CUCU-108
	 *
	 */
	@Given("^I create a PurchaseOrder \"([^\"]*)\" for vendor \"([^\"]*)\" with product \"([^\"]*)\" and quantity \"([^\"]*)\" and price \"([^\"]*)\"$")
	public void i_create_a_PurchaseOrder_for_vendor_with_product_and_quantity_and_price(String EditorName, String Vendor, String Product, String Quantity, String Price) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record(EditorName, "(Purchasing):(PurchaseOrder)", "NEW", "", "");
		mysteps.I_set_field_to("lief", Vendor);
		mysteps.I_set_field_to("such", EditorName);
		mysteps.I_set_field_to("kenn", EditorName);
		mysteps.i_create_a_new_row_at_the_end_of_the_table();
		mysteps.I_set_field_to_in_row("artex", Product, "1");
		mysteps.I_set_field_to_in_row("mge", Quantity, "1");
		if( Price != "") {
			mysteps.I_set_field_to_in_row("preis", Price, "1");
		}
		mysteps.i_save_the_current_editor();
	}

	/**
	 *  Siehe i_create_a_PurchaseOrder_for_vendor_with_product_and_quantity_and_price
	*/
	@Given("^I create a PurchaseOrder \"([^\"]*)\" for vendor \"([^\"]*)\" with product \"([^\"]*)\" and quantity \"([^\"]*)\"$")
	public void i_create_a_PurchaseOrder_for_vendor_with_product_and_quantity(String EditorName, String Vendor, String Product, String Quantity) throws Throwable {
		i_create_a_PurchaseOrder_for_vendor_with_product_and_quantity_and_price(EditorName, Vendor, Product, Quantity, "");
	}

	/**
	 * Step: I deliver the SalesOrder "([^\"]*)" with PackingSlip "([^\"]*)")
	 *
	 * Creates a PackingSlip to SalesOrder-Editor <EditorId> (Command DELIVERY)
	 * delivers complete quantities
	 * Sets such = Suchname and ueb=ja -> Packingslip posted
	 * Editorname = Suchname
	 *
	 * CUCU-109
	 */
	@Given("^I deliver the SalesOrder \"([^\"]*)\" with PackingSlip \"([^\"]*)\"$")
	public void i_deliver_the_SalesOrder_with_PackingSlip(String EditorId, String Suchname) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor(Suchname, "(Sales):(SalesOrder)", "DELIVERY", EditorId);
		mysteps.I_set_field_to("ueb", "ja");
		mysteps.I_set_field_to("such", Suchname);
		mysteps.I_set_field_to("kenn", Suchname);
		EDPEditor editor= context.getCurrentEditor();
		for( int rowNo = 1; rowNo <= editor.getRowCount(); rowNo++) {
			editor.setFieldVal(rowNo, "mge", editor.getFieldVal(rowNo, "ofmge"));
		}
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I deliver the PurchaseOrder "([^\"]*)" with PackingSlip "([^\"]*)")
	 *
	 * Creates a PackingSlip to PurchaseOrder-Editor <EditorId> (Command DELIVERY)
	 * delivers complete quantities
	 * Sets such = Suchname and ueb=ja -> Packingslip posted
	 * Editorname = Suchname
	 *
	 *CUCU-110
	 */
	@Given("I deliver the PurchaseOrder {string} with PackingSlip {string}")
	public void i_deliver_the_PurchaseOrder_with_PackingSlip(String EditorId, String Suchname) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor(Suchname, "(Purchasing):(PurchaseOrder)", "DELIVERY", EditorId);
		mysteps.I_set_field_to("ueb", "ja");
		mysteps.I_set_field_to("such", Suchname);
		mysteps.I_set_field_to("kenn", Suchname);
		mysteps.I_set_field_to("ebeleg", Suchname);
		mysteps.I_set_field_to("vom", ".");
		mysteps.I_set_field_to("tterm", ".");
		mysteps.I_set_field_to("budat", ".");
		EDPEditor editor= context.getCurrentEditor();
		for( int rowNo = 1; rowNo <= editor.getRowCount(); rowNo++) {
			editor.setFieldVal(rowNo, "mge", editor.getFieldVal(rowNo, "ofmge"));
		}
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I invoice the PackingSlip "([^\"]*)" with Invoice "([^\"]*)"
	 *
	 * Creates a Invoice to a PackingSlip-Editor <EditorId> (Command INVOICE)
	 * invoices the complete Packingslip
	 * Sets such = Suchname and ueb=ja -> Invoice posted
	 * Editorname = Suchname
	 *
	 * CUCU-111
	 */
	@Given("^I invoice the PackingSlip \"([^\"]*)\" with Invoice \"([^\"]*)\"$")
	public void i_invoice_the_PackingSlip_with_Invoice(String EditorId, String Suchname) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor(Suchname, "(Sales):(PackingSlip)", "INVOICE", EditorId);
		mysteps.I_set_field_to("ueb", "ja");
		mysteps.I_set_field_to("such", Suchname);
		mysteps.I_set_field_to("kenn", Suchname);
		mysteps.I_set_field_to("tterm", ".");
		mysteps.I_set_field_to("budat", ".");
		mysteps.i_set_dialog_answer_for("Ja", "4841");
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I return the PackingSlip "([^\"]*)" with ReturnPackingSlip "([^\"]*)"
	 *
	 * Creates a ReturnPackingSlip to Sales PackingSlip-Editor <EditorId> (Command RETURN)
	 * re-delivers complete quantities
	 * Sets such = Suchname and ueb=ja -> Packingslip posted
	 * Editorname = Suchname
	 *
	 * CUCU-112
	 */
	@Given("^I return the PackingSlip \"([^\"]*)\" with ReturnPackingSlip \"([^\"]*)\"$")
	public void i_return_the_PackingSlip_with_ReturnPackingSlip(String EditorId, String Suchname) throws Throwable {
		mysteps.setUp(context.currentScenario);
		
		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor(Suchname, "(Sales):(PackingSlip)", "RETURN", EditorId);
		mysteps.I_set_field_to("ueb", "ja");
		mysteps.I_set_field_to("such", Suchname);
		mysteps.I_set_field_to("kenn", Suchname);
		EDPEditor editor= context.getCurrentEditor();
		for( int rowNo = 1; rowNo <= editor.getRowCount(); rowNo++) {
			editor.setFieldVal(rowNo, "mge", editor.getFieldVal(rowNo, "ofmge"));
		}			
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I return the PurchasingPackingSlip "([^\"]*)" with ReturnPackingSlip "([^\"]*)"
	 *
	 * Creates a ReturnPackingSlip to Purchasing PackingSlip-Editor <EditorId> (Command RETURN)
	 * re-delivers complete quantities
	 * Sets such = Suchname and ueb=ja -> Packingslip posted
	 * Editorname = Suchname
	 *
	 * CUCU-113
	 */
	@Given("^I return the PurchasingPackingSlip \"([^\"]*)\" with ReturnPackingSlip \"([^\"]*)\"$")
	public void i_return_the_PurchasingPackingSlip_with_ReturnPackingSlip(String EditorId, String Suchname) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor(Suchname, "(Purchasing):(PackingSlip)", "RETURN", EditorId);
		mysteps.I_set_field_to("ueb", "ja");
		mysteps.I_set_field_to("such", Suchname);
		mysteps.I_set_field_to("kenn", Suchname);
		mysteps.I_set_field_to("ebeleg", Suchname);
		mysteps.I_set_field_to("vom", ".");
		mysteps.I_set_field_to("tterm", ".");
		mysteps.I_set_field_to("budat", ".");
		EDPEditor editor= context.getCurrentEditor();
		for( int rowNo = 1; rowNo <= editor.getRowCount(); rowNo++) {
			editor.setFieldVal(rowNo, "mge", editor.getFieldVal(rowNo, "ofmge"));
		}
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I reverse the ReturnPackingSlip "([^\"]*)"
	 *
	 * Do a reverse (complete) to the ReturnPackingSlip with <EditorId>
	 *
	 *
	 *     CUCU-114
	 */
	@Given("^I reverse the ReturnPackingSlip \"([^\"]*)\"$")
	public void i_reverse_the_ReturnPackingSlip(String EditorId) throws Throwable {
		i_reverse_the_PackingSlip(EditorId);
	}
	
	/**
	 * Step: I reverse the PackingSlip "([^\"]*)"
	 *
	 * Do a reverse (complete) to the PackingSlip with <EditorId>
	 *
	 *     CUCU-115
	 */
	@Given("^I reverse the PackingSlip \"([^\"]*)\"$")
	public void i_reverse_the_PackingSlip(String EditorId) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor("step_rev_ret", "(Sales):(PackingSlip)", "REVERSAL", EditorId);	
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I reverse the PurchasingPackingSlip "([^\"]*)"
	 *
	 * Do a reverse (complete) to the PackingSlip with <EditorId>
	 *
	 *     CUCU-116
	 */
	@Given("^I reverse the PurchasingPackingSlip \"([^\"]*)\"$")
	public void i_reverse_the_PurchasingPackingSlip(String EditorId) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor("step_rev_ret", "(Purchasing):(PackingSlip)", "REVERSAL", EditorId);	
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I reverse the Invoice "([^\"]*)"
	 *
	 * Do a reverse (complete) to the Invoice with <EditorId>
	 *
	 *     CUCU-117
	 */
	@Given("^I reverse the Invoice \"([^\"]*)\"$")
	public void i_reverse_the_Invoice(String EditorId) throws Throwable {
		mysteps.setUp(context.currentScenario);

		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor("step_rev_inv", "(Sales):(Invoice)", "REVERSAL", EditorId);	
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I create a ServiceProduct \"([^\"]*)\" for product \"([^\"]*)\" and Lot \"([^\"]*)\"
	 *
	 * Creates a ServiceProduct for a specific product and lot (charge)
	 * Sets such = namepr = Editorname
	 *
	 */
	@Given("I create a ServiceProduct \"([^\"]*)\" for Product \"([^\"]*)\" and Lot \"([^\"]*)\"")
	public void i_create_a_ServiceProduct_for_product_and_lot(String EditorName, String Product, String Lot) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_open_an_editor_from_table_with_command_for_record(EditorName, "(ServiceProduct):(ServiceProduct)", "NEW", "", "");
		mysteps.I_set_field_to("such", EditorName);
		mysteps.I_set_field_to("namebspr", EditorName);
		mysteps.I_set_field_to("artikel", Product);
		if( Lot != "") {
			mysteps.I_set_field_to("charge", Lot);
		}
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: I create a ServiceProduct \"([^\"]*)\" for Product \"([^\"]*)\"
	 *
	 * Creates a ServiceProduct for a specific product
	 * Sets such = namepr = Editorname
	 *
	 */
	@Given("I create a ServiceProduct \"([^\"]*)\" for Product \"([^\"]*)\"")
	public void i_create_a_ServiceProduct_for_product(String EditorName, String Product) throws Throwable {
		i_create_a_ServiceProduct_for_product_and_lot(EditorName, Product,"");
	}

	/**
	 * Step: I create a ServiceProduct \"([^\"]*)\" for Product \"([^\"]*)\" and Lot with editor id \"([^\"]*)\"
	 *
	 * Creates a ServiceProduct for a specific product and lot (charge)
	 * Lot is identified with Editor ID
	 * Sets such = namepr = Editorname
	 *
	 */
	@Given("I create a ServiceProduct \"([^\"]*)\" for Product \"([^\"]*)\" and Lot with editor id \"([^\"]*)\"")
	public void i_create_a_ServiceProduct_for_product_and_lot_with_editor_id(String EditorName, String Product, String LotEditorID) throws Throwable  {
		mysteps.setUp(context.currentScenario);
		String refLot = mysteps.getActiveReference(LotEditorID, null, context);
		mysteps.i_open_an_editor_from_table_with_command_for_record(EditorName, "(ServiceProduct):(ServiceProduct)", "NEW", "", "");
		mysteps.I_set_field_to("such", EditorName);
		mysteps.I_set_field_to("namebspr", EditorName);
		mysteps.I_set_field_to("artikel", Product);
	    mysteps.I_set_field_to("charge", refLot);
		mysteps.i_save_the_current_editor();
	}

}
