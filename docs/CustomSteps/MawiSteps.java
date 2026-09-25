/*-----------------------------------------------------------------------------
 * Modul Name       : MawiSteps.java
 * Verwendung       : Individuelle Steps fuer die Materialwirtschaft
 * Autor            : carue
 * Verantwortlich   : carue
 * Kontrolle        : ak
 *---------------------------------------------------------------------------*/
package de.abas.erp.cucumber.mawi;
import java.io.IOException;
// fuer queries
import java.util.List;
import java.util.Map;

import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.stepDefs.InfosystemStepDefs;
import de.abas.acceptanceTests.stepDefs.QueryStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;
import de.abas.ceks.jedp.EDPEditor;
import de.abas.erp.cucumber.common.CommonCustomedSteps;

public class MawiSteps {

	private ERPTestContext context;
	private GeneralERPStepDefs mysteps;
	private InfosystemStepDefs myinfosteps;
	private QueryStepDefs myqueries;
	private CommonCustomedSteps mycustomedsteps;

    private String tableName = "undef";
    private String fields = "GIVEN_UNDEFINED_FIELD_LIST_NAME";
    private String searchCriteria = "";
	
	// liste lt. ak bw2-1017 oder -688..
    // !! es koennen andere Feldlisten hinzugefuegt werden - vgl. unten!!
    private String bewertungslagermengen1 ="artikel,lgruppe,platz,gebeinh,gebf,gebmge,charge,verw,projekt,lffert,lj,orig,verfdat,bewmge,bewlj,beworig,bewdat";
    private String bewertungslagermengen2 = "";
    // bewertungslagermengen3 entspricht bewertungslagermengen1 aber die Verweisangabe erfolgt mit Datensatz-ID anstatt Suchwort
    private String bewertungslagermengen3 ="artikel,lgruppe,platz,gebeinh,gebf,gebmge,charge,verw,projekt,lffert,lj^id ,orig^id,verfdat,bewmge,bewlj^id,beworig^id,bewdat";
    private String bewertungslagermengen_searchCriteria1 = ";@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,verw,gebmge.rueckw,lj^id;";
    private String bewertungslagermengen_searchCriteria2 = ";@ordnung=artikel,lgruppe.rueckw,platz.rueckw,charge,projekt,verw,gebmge.rueckw,lj^id;";

	// liste lt. ak bw2-1017 oder -688..
    // !! es koennen andere Feldlisten hinzugefuegt werden - vgl. unten!!

	// nur LJ-Saetze ohne Zeilen selektieren
    private String ljfeldliste0_oh_zei ="budat,artikel,platz,lgruppe,buart,ursache,detursache,mge,me,leme,rueckmge,rueckgmge,mpr,verw,fert,projekt,vorgang,bsres,gmge,lj,ekumlag,rueckorig,storniert,stornolj,ozeilen,vorgang^such,ebeleg";
	private String ljfeldliste0_searchCriteria_oh_zei = ";ozeilen==0;@ordnung=id,erfass,zaehler;@zeilen=nein";

	// hiermit werden alle saetze mit und ohne zeilen mit allen zeileninhalten selektiert: 
	private String ljfeldliste1 ="zn,budat,artikel,platz,lgruppe,buart,ursache,detursache,mge,me,leme,rueckmge,rueckgmge,mpr,verw,fert,projekt,vorgang,bsres,gmge,lj,ekumlag,rueckorig,storniert,stornolj,1:vcharge,1:ncharge,1:mge,1:lj,1:verfdat,1:bewlj,1:bewmge,1:bewdat,1:orig,1:beworig,ozeilen,vorgang^such,ebeleg";
	private String ljfeldliste1_searchCriteria = ";@ordnung=id,erfass,zaehler,zn";

	// nur LJ-Saetze mit Zeilen selektieren
	private String ljfeldliste2_mit_zei ="zn,budat,artikel,platz,lgruppe,buart,ursache,detursache,mge,me,leme,rueckmge,rueckgmge,mpr,verw,fert,projekt,vorgang,bsres,gmge,lj,ekumlag,rueckorig,storniert,stornolj,1:vcharge,1:ncharge,1:mge,1:lj,1:verfdat,1:bewlj,1:bewmge,1:bewdat,1:orig,1:beworig,ozeilen,vorgang^such,ebeleg";
	private String ljfeldliste2_searchCriteria_mit_zei = ";ozeilen>0;@ordnung=id,erfass,zaehler,zn;@zeilen=ja";

	// LJ-Saetze ohne Zeilen sortiert nach den uebergebenen Kriterien
	private String ljfeldliste1_oh_zei = ljfeldliste0_oh_zei;
	private String ljfeldliste1_searchCriteria_oh_zei = ";ozeilen==0;@zeilen=nein";

	// Artikelmengen selektieren
	private String artikelmengenfeldliste1 ="kosn^such,darta,gjahr,zm1,zm2,zm3,zm4,zm5,zm6,zm7,zm8,zm9,zm10,zm11,zm12,am1,am2,am3,am4,am5,am6,am7,am8,am9,am10,am11,am12";
	private String artikelmengen_searchCriteria1 = "@ordnung=kosn^such";

	public MawiSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		this.context = context;
		mysteps = new GeneralERPStepDefs(context, handler, helper);
		myinfosteps = new InfosystemStepDefs(context);
		myqueries = new QueryStepDefs(context, helper);
		mycustomedsteps = new CommonCustomedSteps(context, handler, helper);
	}

	/*
	Step: And I set stock quantity to zero for product "([^"]*)" on storage location "([^"]*)" with document "([^"]*)"

	Fuehrt eine Bestandskorrektur auf 0 fuer einen bestimmten Artikel auf einem Lagerplatz durch und setzt den Beleg.
	Es werden alle Zeilen auf 0 gesetzt, die fuer diesen Artikel in dieser Lagergruppe gelistet sind.
	Wird kein Beleg eingetragen, wird LEEREN gesetzt.
	
	Bei einer Bestandskorrektur wird der Artikel auch aus den Beh�ltern gebucht. Ist nur der Artikel im Beh�lter gewesen,
	ist der Beh�lter danach leer.

	CUCU-119

	 */

	@And("^I set stock quantity to zero for product \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\"$")
	public void i_set_stock_qtyzero_with_document(String productName, String location, String beleg) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.an_editor_for_tip_command("Bestandskorrektur", "(SInventory)", "");
		mysteps.I_set_field_to("artikel", productName);

		if (beleg.isEmpty()) {
			mysteps.I_set_field_to("beleg", "LEEREN");
		} else {
			mysteps.I_set_field_to("beleg", beleg);
		}

		mysteps.I_set_field_to("beldat", ".");
		mysteps.I_set_field_to_in_row("platz", location, "1");

		EDPEditor myEditor = this.context.getCurrentEditor();

		for(int i = 1; i <= myEditor.getRowCount(); i++) {
			mysteps.I_set_field_to_in_row("mge", "0", Integer.toString(i));
		}

		mysteps.i_save_the_current_editor();
	}

	@And("^I set stock quantity to zero for product \"([^\"]*)\" on storage location \"([^\"]*)\"$")
	public void i_set_stock_qtyzero(String productName, String location) throws Throwable {
		i_set_stock_qtyzero_with_document(productName, location, "");
	}

	/* Step: And I create a Lot "([^"]*)" for product "([^"]*)"

	Erstellt eien neue Charge fuer das angegeben Produkt.
	Suchwort und Externe Chargennummer werden auf den Chargennamen gesetzt, den man im Step angibt.

	CUCU-120

	 */

	@And("^I create a Lot \"([^\"]*)\" for Product \"([^\"]*)\"$")
	public void create_lot_for_product(String editor, String productName) throws Throwable {
		mysteps.setUp(context.currentScenario);
		editor = editor.trim();
		mysteps.i_open_an_editor_from_table_with_command_for_record(editor, "(Lots):(Lots)", "NEW", "", "");
		mysteps.I_set_field_to("such", editor);
		mysteps.I_set_field_to("artikel", productName.trim());
		mysteps.I_set_field_to("exnum", editor);
		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: And I post a receipt via manual stock adjustment for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\" and price \"([^\"]*)\"
	 *
	 * Bucht ueber das Tippkommando Lbuchung (Lagerbuchung) einen Zugang fuer
	 *  - den angegebene Artikel
	 *  - in angegebener Menge
	 *  - auf den angegebenen Platz
	 *  - zum angegebenen Preis (moegliche Eingaben: leer, 0, ungleich 0; wobei leer bedeutet: bewerte die zugebuchte Menge mit dem mpr, falls dieser ungleich null ist, sonst mit dem Wert 1
	 *
	 * CUCU-121
	 */
	@And("^I post a receipt via manual stock adjustment for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\" and price \"([^\"]*)\"$")
	public void i_post_receipt_manualstockadj_product_qty_location_document_price(String productName, String quantity, String location, String document, String price) throws Throwable {
		i_post_receipt_manualstockadjustment_intern("Lbuch" + document, productName, quantity, location, document, price, "");
	}

	/**
	 * Step: And I post a receipt via manual stock adjustment \"([^\"]*)\" for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\" and price \"([^\"]*)\"
	 *
	 * Bucht ueber das Tippkommando Lbuchung (Lagerbuchung) einen Zugang fuer
	 *  - den angegebenen Editornamen
	 *  - den angegebene Artikel
	 *  - in angegebener Menge
	 *  - auf den angegebenen Platz
	 *  - zum angegebenen Preis (moegliche Eingaben: leer, 0, ungleich 0; wobei leer bedeutet: bewerte die zugebuchte Menge mit dem mpr, falls dieser ungleich null ist, sonst mit dem Wert 1
	 *
	 * CUCU-121
	 */
	@And("^I post a receipt via manual stock adjustment \"([^\"]*)\" for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\" and price \"([^\"]*)\"$")
	public void i_post_receipt_manualstockadj_product_qty_location_document_price(String editorName, String productName, String quantity, String location, String document, String price) throws Throwable {
		i_post_receipt_manualstockadjustment_intern(editorName, productName, quantity, location, document, price, "");
	}

	/**
	 * Step: And I post a receipt via manual stock adjustment for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\"
	 *
	 * Bucht ueber das Tippkommando Lbuchung (Lagerbuchung) einen Zugang fuer
	 *  - den angegebene Artikel
	 *  - in angegebener Menge
	 *  - auf den angegebenen Platz
	 *  - Preis leer
	 *
	 * CUCU-121
	 */
	@And("^I post a receipt via manual stock adjustment for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\"$")
	public void i_post_receipt_manualstockadj_product_qty_location_document(String productName, String quantity, String location, String document) throws Throwable {
		i_post_receipt_manualstockadjustment_intern("Lbuch" + document, productName, quantity, location, document, "", "");
	}

	/**
	 * Step: And I post an issue via manual stock adjustment \"([^\"]*)\" for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\"
	 *
	 * Bucht ueber das Tippkommando Lbuchung (Lagerbuchung) einen Abgang fuer
	 *  - den angegebenen Editornamen
	 *  - den angegebene Artikel
	 *  - in angegebener Menge
	 *  - auf den angegebenen Platz
	 *
	 * CUCU-210
	 */
	@And("^I post an issue via manual stock adjustment \"([^\"]*)\" for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\"$")
	public void i_post_issue_manualstockadj_product_qty_location_document(String editorName, String productName, String quantity, String location, String document) throws Throwable {
		i_post_issue_manualstockadjustment_intern(editorName, productName, quantity, location, document);
	}

	/**
	 * Step: And I post a receipt via manual stock adjustment \"([^\"]*)\" for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\"
	 *
	 * Bucht ueber das Tippkommando Lbuchung (Lagerbuchung) einen Zugang fuer
	 *  - den angegebenen Editornamen
	 *  - den angegebene Artikel
	 *  - in angegebener Menge
	 *  - auf den angegebenen Platz
	 *  - Preis leer
	 *
	 * CUCU-121
	 */
	@And("^I post a receipt via manual stock adjustment \"([^\"]*)\" for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\"$")
	public void i_post_receipt_manualstockadj_product_qty_location_document(String editorName, String productName, String quantity, String location, String document) throws Throwable {
		i_post_receipt_manualstockadjustment_intern(editorName, productName, quantity, location, document, "", "");
	}

	/**
	 * Step: And I post a receipt via manual stock adjustment for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\ and Container \"([^\"]*)\"
	 *
	 * Bucht ueber das Tippkommando Lbuchung (Lagerbuchung) einen Zugang fuer
	 *  - den angegebene Artikel
	 *  - in angegebener Menge
	 *  - auf den angegebenen Platz
	 *  - in den angegebenen Behaelter
	 *  - Preis leer
	 *
	 * CUCU-121
	 */
	@And("^I post a receipt via manual stock adjustment for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\" and Container \"([^\"]*)\"$")
	public void i_post_receipt_manualstockadj_product_qty_location_document_container(String productName, String quantity, String location, String document, String container) throws Throwable {
		i_post_receipt_manualstockadjustment_intern("Lbuch" + document, productName, quantity, location, document, "", container);
	}

	private void i_post_receipt_manualstockadjustment_intern(String editorName, String productName, String quantity, String location, String document, String price, String container)  throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.an_editor_for_tip_command(editorName, "Lbuchung", "");
		EDPEditor editor = context.getCurrentEditor();
		mysteps.I_set_field_to("artikel", productName);
		mysteps.I_set_field_to("buart",     "Zugang");
		mysteps.I_set_field_to("beldat", ".");

		if (document.isEmpty()) {
			mysteps.I_set_field_to("beleg", "Zugang");
		} else {
			mysteps.I_set_field_to("beleg", document);
		}

		if (price.isEmpty()) {
			double mprvalue = Double.parseDouble(editor.getFieldVal("artikel^mpr"));
			if (mprvalue == 0) {
				mysteps.I_set_field_to("wert", "1");
			} else {
				mysteps.I_set_field_to("wert", String.valueOf(mprvalue));
			}
		} else {
			mysteps.I_set_field_to("wert", price);
		}

		mysteps.I_set_field_to_in_row("mge", quantity, "1");
		mysteps.I_set_field_to_in_row("platz2", location, "1");
		mysteps.I_set_field_to_in_row("behaelter", container, "1");

		mysteps.i_save_the_current_editor();
	}

	private void i_post_issue_manualstockadjustment_intern(String editorName, String productName, String quantity, String location, String document)  throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.an_editor_for_tip_command(editorName, "Lbuchung", "");
		mysteps.I_set_field_to("artikel", productName);
		mysteps.I_set_field_to("buart",     "Abgang");
		mysteps.I_set_field_to("beldat", ".");
		mysteps.I_set_field_to("beleg", document);

		mysteps.I_set_field_to_in_row("mge", quantity, "1");
		mysteps.I_set_field_to_in_row("platz", location, "1");

		mysteps.i_save_the_current_editor();
	}

	/**
	 * Selektiert und prueft Lagerplatzmengen in Cucu-Skripten. Format lt. nameOfFieldlist
	 * Erzeugung ueber Datei mit ... And I export ... to output file    moeglich, s. unten
	 * 
	 * Im Vgl. zu Templates koennen mehrere Datensaetze gemeinsam selektiert werden.
	 * Im Vgl. zum Infosystem BESTAND sind die Ausgaben hiermit unabhaengig von dem Infosystem.
	 * Feld bewmge ist im IS zB nicht vorhanden (konnte nicht ausgegeben werden) 
	 * KOMMANDO ERWEITERBAR UM WEITERE FELDLISTEN!
	 *
	 * CUCU-122
	 */
	@Given("^I query \"([^\"]*)\" from stock quantities where \"([^\"]*)\"$")
	public void i_query_from_stock_quantities_where(String nameOfFieldlist, String givenSearchCriteria) throws Throwable {
	    i_prepare_this_tableName_fields_searchCriteria_for_stock_quantities(nameOfFieldlist, givenSearchCriteria);	    
	    // fuellt offenbar die private rowList in myqueries
	    myqueries.i_query_from_table_where(this.fields, this.tableName, this.searchCriteria);
	}

	/**
	 * Prueft Queryergebnis gegen Vorgabe aus dem Cucumberskript,  
	 * basiert auf "Then table has values"
	 *
	 * CUCU-123
	 */
	@Then("^stock quantities has values$")
	public void stock_quantities_has_values(List<Map<String, String>> table) throws Throwable {	
		// zum abgleich wird offenbar die private rowList aus myqueries verwendet
		myqueries.query_has_values(table);	
	}

	/**
	 * Prueft Queryergebnis auf 0 Treffer.  
	 * basiert auf "Then table has no hits"
	 *
	 * CUCU-124
	 */
	@Then("^stock quantity is zero$")
	public void stock_quantity_is_zero() throws Throwable {
		myqueries.query_has_values();  // prueft intern die dortige rowList	
	}

	/**
	 * Selektiert Lagerplatzmengen in Cucu-Skripten und gibt diese lt. Format nameOfFieldlist
	 * in die gewuenscht Datei (nach verzeichn. cucumber/refs) aus.
	 * Dabei wird die Ausgabebreite der Tabelle wird minimiert und es wird rechtsbuendig formatiert.
	 * 
	 * Im Vgl. zu Templates koennen mehrere Datensaetze gemeinsam selektiert werden.
	 * Im Vgl. zum Infosystem BESTAND sind die Ausgaben hiermit unabhaengig von dem Infosystem.
	 * Feld bewmge ist im IS zB nicht vorhanden (konnte nicht ausgegeben werden)
	 *  
	 * KOMMANDO ERWEITERBAR UM WEITERE FELDLISTEN!
	 *
	 * CUCU-125
	 */
	@And("^I export \"([^\"]*)\" from stock quantities where \"([^\"]*)\" to output file \"([^\"]*)\"$")
	public void i_export_from_stock_quantities_where_to_file(String nameOfFieldlist, String givenSearchCriteria, String fileName) throws Throwable {
	    i_prepare_this_tableName_fields_searchCriteria_for_stock_quantities(nameOfFieldlist, givenSearchCriteria);	    
	    mycustomedsteps.i_export_from_table_where_to_file(this.fields, this.tableName, 
	    		this.searchCriteria, fileName);	
	}	

	/**
	 * Stellt die 3 Klassenvariablen mit fuer die selektion passenden werten bereit.
	 * @return this.tableName
	 * @return this.fields
	 * @return this.searchCriteria
	 * 
	 * !! Uebergeordnete KOMMANDOS SIND ERWEITERBAR UM WEITERE FELDLISTEN !!
	 * 
	 * schoener waere natuerlich wenn eine klasse mit den 3 werten als return zurueckgegeben werden wuerde.
	 * mangels zeit erstmal nicht gemacht.
 	 */
	private void i_prepare_this_tableName_fields_searchCriteria_for_stock_quantities(String nameOfFieldlist, String givenSearchCriteria) throws Throwable {
	    this.tableName = "(StorageQuantity):(LocationQuantityElement)";
	    this.fields = "GIVEN_UNDEFINED_FIELD_LIST_NAME";
	    this.searchCriteria = "";
	    
	    if (nameOfFieldlist.equals("bewertungslagermengen1")) {
		    this.fields = this.bewertungslagermengen1;
		    this.searchCriteria = givenSearchCriteria + this.bewertungslagermengen_searchCriteria1;
	    } else if (nameOfFieldlist.equals("bewertungslagermengen2")) {
	    	this.fields = this.bewertungslagermengen1;
	    	this.searchCriteria = givenSearchCriteria + this.bewertungslagermengen_searchCriteria2;
	    } else if (nameOfFieldlist.equals("bewertungslagermengen3")) {
	    	this.fields = this.bewertungslagermengen3;
	    	this.searchCriteria = givenSearchCriteria + this.bewertungslagermengen_searchCriteria1;
	    } else {
	    	throw new IOException(this.fields + " you must use a defined fieldlist name!");
	    }
	}

	/**
	 * Selektiert Lagerjournalsaetze in Cucu-Skripten und gibt diese lt. dem Format, Zeilenbedingung
	 * und Sortierung lt. nameOfFieldlist
	 * in die gewuenschte Datei (nach verzeichn. cucumber/refs) aus.
	 * Bereits 3 Feldlisten fuer LJ vordefiniert.
	 * KOMMANDO ERWEITERBAR UM WEITERE FELDLISTEN!
	 *
	 * CUCU-126
	 */
	@And("^I export \"([^\"]*)\" from stock journal where \"([^\"]*)\" to output file \"([^\"]*)\"$")
	public void i_export_from_stock_journal_where_to_file(String nameOfFieldlist, String searchCriteria, String fileName) throws Throwable {
	    String tableName = "(Journal):(Journal)";
	    String fields = "GIVEN_UNDEFINED_FIELD_LIST_NAME";
	    
	    if (nameOfFieldlist.equals("ljfeldliste0_oh_zei")) {
		    fields = ljfeldliste0_oh_zei;
		    searchCriteria = searchCriteria	+ ljfeldliste0_searchCriteria_oh_zei;
	    } else if (nameOfFieldlist.equals("ljfeldliste1_oh_zei")) {
		   fields = ljfeldliste1;
		   searchCriteria = searchCriteria	+ ljfeldliste1_searchCriteria_oh_zei;
	    } else if (nameOfFieldlist.equals("ljfeldliste1")) {
		   fields = ljfeldliste1;
		   searchCriteria = searchCriteria	+ ljfeldliste1_searchCriteria;
	    } else if (nameOfFieldlist.equals("ljfeldliste2_mit_zei")) {
		   fields = ljfeldliste2_mit_zei;
		   searchCriteria = searchCriteria	+ ljfeldliste2_searchCriteria_mit_zei;
		} else {
	    	throw new IOException(fields + " you must use a defined fieldlist name!");
	    }
	    
	    mycustomedsteps.i_export_from_table_where_to_file(fields, tableName, searchCriteria, fileName);	
	}	
	
	/**
	 * Selektiert Artikelmengenverkehrszahlen (Zugaenge/Abgaenge) in Cucu-Skripten und gibt diese lt. dem Format, Zeilenbedingung
	 * und Sortierung lt. nameOfFieldlist
	 * in die gewuenschte Datei (nach verzeichn. cucumber/refs) aus.
	 * KOMMANDO ERWEITERBAR UM WEITERE FELDLISTEN!
	 *
	 * CUCU-127
	 */
	@And("^I export \"([^\"]*)\" from part_receipts_and_issues where \"([^\"]*)\" to output file \"([^\"]*)\"$")
	public void i_export_from_part_receipts_and_issues_where_to_file(String nameOfFieldlist, String searchCriteria, String fileName) throws Throwable {
	    String tableName = "(Part):(ReceiptsAndIssues)";
	    String fields = "GIVEN_UNDEFINED_FIELD_LIST_NAME";
	    
	    if (nameOfFieldlist.equals("artikelmengenfeldliste1")) {
		    fields = artikelmengenfeldliste1;
		    searchCriteria = searchCriteria	+ artikelmengen_searchCriteria1;
		} else {
	    	throw new IOException(fields + " you must use a defined fieldlist name!");
	    }
	    
	    mycustomedsteps.i_export_from_table_where_to_file(fields, tableName, searchCriteria, fileName);
	}


	/**
	 *  Step: And I transfer stock quantity of "([^"]*)" for product "([^"]*)" from location "([^"]*)" to "([^"]*)" with document "([^"]*)"
	 *
	 * Fuehrt ueber das Tippkommando Lbuchung (Lagerbuchung) eine Umbuchung fuer den angegeben Artikel, in angegebener Menge durch.
	 * Zu- und Abgangslagerplatz werden ebenfalls angegeben.
	 * Wird kein Beleg angegeben, wird Umbuchung eingetragen.
	 *
	 * CUCU-128
	 */
	@And("^I transfer stock quantity of \"([^\"]*)\" for product \"([^\"]*)\" from location \"([^\"]*)\" to \"([^\"]*)\" with document \"([^\"]*)\"$")
	public void i_transfer_qty_for_product_from_location_document(String quantity, String productName, String fromlocation, String tolocation, String document) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.an_editor_for_tip_command("Lagerbuchung", "Lbuchung", "");
		mysteps.I_set_field_to("artikel", productName);
		mysteps.I_set_field_to("buart",     "Umbuchung");
		mysteps.I_set_field_to("beldat", ".");
		mysteps.I_set_field_to_in_row("mge", quantity, "1");
		mysteps.I_set_field_to_in_row("platz", fromlocation, "1");
		mysteps.I_set_field_to_in_row("platz2", tolocation, "1");

		if (document.isEmpty()) {
			mysteps.I_set_field_to("beleg", "Umbuchung");
		} else {
			mysteps.I_set_field_to("beleg", document);
		}

		mysteps.i_save_the_current_editor();
	}

	/**
	 * Step: And I transfer stock quantity of "([^"]*)" "([^"]*)" for product "([^"]*)" from location "([^"]*)" to "([^"]*)" with document "([^"]*)"
	 *
	 * Fuehrt ueber das Tippkommando Lbuchung (Lagerbuchung) eine Umbuchung fuer den angegeben Artikel, in angegebener Menge und Einheit durch.
	 * Zu- und Abgangslagerplatz werden ebenfalls angegeben.
	 * Wird kein Beleg angegeben, wird Umbuchung eingetragen.
	 *
	 * CUCU-128
	 */
	@And("^I transfer stock quantity of \"([^\"]*)\" \"([^\"]*)\" for product \"([^\"]*)\" from location \"([^\"]*)\" to \"([^\"]*)\" with document \"([^\"]*)\"$")
	public void i_transfer_qty_for_product_from_location_document(String quantity, String unit, String productName, String fromlocation, String tolocation, String document) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.an_editor_for_tip_command("Lagerbuchung", "Lbuchung", "");
		mysteps.I_set_field_to("artikel", productName);
		mysteps.I_set_field_to("buart",     "Umbuchung");
		mysteps.I_set_field_to("beldat", ".");
		mysteps.I_set_field_to_in_row("mge", quantity, "1");
		mysteps.I_set_field_to_in_row("ze", unit, "1");
		mysteps.I_set_field_to_in_row("platz", fromlocation, "1");
		mysteps.I_set_field_to_in_row("platz2", tolocation, "1");

		if (document.isEmpty()) {
			mysteps.I_set_field_to("beleg", "Umbuchung");
		} else {
			mysteps.I_set_field_to("beleg", document);
		}

		mysteps.i_save_the_current_editor();
	}

	/**
	 * Platzmengenelemente fuer Artikel und Platz selektieren.
	 *
	 * Ergebnisse abfragen mit:
	 * "Then query has values" oder "Then query has no hits"
	 * 
	 * Bei diesem Step werden standardmaessig die Felder "gebmge,gebeinh,gebf,lj^id,orig^id,bewmge,bewlj^id,beworig^id"
	 * an die Query uebergeben.
	 *
	 * CUCU-129
	 */
	@Given("^I query StorageQuantity for Product \"([^\"]*)\" on Location \"([^\"]*)\"$")
	public void i_query_storage_quantity_for_product_location(String product, String location) throws Throwable {
		String select_fields = "gebmge,gebeinh,gebf,lj^id,orig^id,bewmge,bewlj^id,beworig^id";
		
		this.i_query_fields_from_storage_quantity_for_product_location(select_fields, product, location);
	}

	/**
	 * Platzmengenelemente fuer Artikel und Platz selektieren.
	 *
	 * Ergebnisse abfragen mit:
	 * "Then query has values" oder "Then query has no hits"
	 *
	 * CUCU-168
	 */
	@Given("^I query \"([^\"]*)\" from StorageQuantity for Product \"([^\"]*)\" on Location \"([^\"]*)\"$")
	public void i_query_fields_from_storage_quantity_for_product_location(String select_fields, String product, String location) throws Throwable {
		String select_record = "artikel==" + product + ";platz==" + location + ";";
		myqueries.i_query_from_table_where(select_fields, "(StorageQuantity):(LocationQuantityElement)", select_record);
	}
	
	/**
	 * Lagergruppenelemente fuer Artikel und Lagergruppe selektieren.
	 *
	 * Ergebnisse abfragen mit:
	 * "Then query has values" oder "Then query has no hits"
	 *
	 * CUCU-132
	 */
	@Given("^I query StorageQuantity for Product \"([^\"]*)\" in WarehouseGroup \"([^\"]*)\"$")
	public void i_query_storage_quantity_for_product_whgroup(String product, String whgroup) throws Throwable {
		String select_record = "artikel==" + product + ";lgruppe==" + whgroup + ";";
		String select_fields = "gebmge";
		myqueries.i_query_from_table_where(select_fields, "(StorageQuantity):(WarehouseGroupQuantityElement)", select_record);
	}

	/**
	 * Artikelmengenelemente fuer Artikel selektieren.
	 * 
	 * Ergebnisse abfragen mit:
	 * "Then query has values" oder "Then query has no hits"
	 *
	 * CUCU-133
	 */
	@Given("^I query StorageQuantity for Product \"([^\"]*)\"$")
	public void i_open_storage_quantity_for_product(String product) throws Throwable {
		String select_record = "artikel==" + product + ";";
		String select_fields = "gebmge";
		myqueries.i_query_from_table_where(select_fields, "(StorageQuantity):(ProductQuantityElement)", select_record);
	}




/**
	 * Step: And I post an issue via manual stock adjustment for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\" and price \"([^\"]*)\"
	 * <p>
	 * Bucht �ber das Tippkommando Lbuchung (Lagerbuchung) einen Abgang f�r
	 * - den angegebene Artikel
	 * - in angegebener Menge
	 * - auf den angegebenen Platz
	 * - zum angegebenen Preis (moegliche Eingaben: leer, 0, ungleich 0; wobei leer bedeutet: bewerte die zugebuchte Menge mit dem mpr, falls dieser ungleich null ist, sonst mit dem Wert 0
	 * <p>
	 * CUCU-??
	 */
	@And("^I post an issue via manual stock adjustment for product \"([^\"]*)\" and quantity \"([^\"]*)\" on storage location \"([^\"]*)\" with document \"([^\"]*)\"$")
	public void i_post_issue_manualstockadj_product_qty_location_document_price(String productName, String quantity, String location, String document) throws Throwable {
		i_post_issue_manualstockadjustment_intern(productName, quantity, location, document);
	}

	private void i_post_issue_manualstockadjustment_intern(String productName, String quantity, String location, String document) throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.an_editor_for_tip_command("Lagerbuchung", "Lbuchung", "");
		EDPEditor editor = context.getCurrentEditor();
		mysteps.I_set_field_to("artikel", productName);
		mysteps.I_set_field_to("buart", "Abgang");
		mysteps.I_set_field_to("beldat", ".");

		if (document.isEmpty()) {
			mysteps.I_set_field_to("beleg", "Abgang");
		} else {
			mysteps.I_set_field_to("beleg", document);
		}

//		if (price.isEmpty()) {
//			double mprvalue = Double.parseDouble(editor.getFieldVal("mpr"));
//			if (mprvalue == 0) {
//				mysteps.I_set_field_to("wert", "0");
//			} else {
//				mysteps.I_set_field_to("wert", editor.getFieldVal("mpr"));
//			}
//		} else {
//			mysteps.I_set_field_to("wert", price);
//		}

		mysteps.I_set_field_to_in_row("mge", quantity, "1");
		mysteps.I_set_field_to_in_row("platz", location, "1");

		mysteps.i_save_the_current_editor();
	}
}
