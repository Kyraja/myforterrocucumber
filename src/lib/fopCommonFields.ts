/**
 * Lookup table mapping common abas ERP field abbreviations to their German
 * description strings.
 *
 * Used as the lowest-priority fallback in the FOP field resolver when a field
 * cannot be matched against an uploaded variable table.  The table covers the
 * most frequently occurring fields across standard abas databases (articles,
 * orders, customers, finance, stock, etc.) so that even without a variable
 * table many field accesses can still be given a human-readable name.
 *
 * All keys are lowercase; the lookup function normalizes before comparing.
 */

// Common abas ERP field names → German description
// Used as fallback when no variable table is available
export const COMMON_FIELDS: Record<string, string> = {
  // General
  'id': 'Datenbank-ID',
  'such': 'Suchbegriff',
  'nummer': 'Laufende Nummer',
  'datum': 'Datum',
  'zeit': 'Uhrzeit',
  'benutzer': 'Benutzer',
  'mandant': 'Mandant',
  'sprache': 'Sprache',
  // Names
  'namebspr': 'Name (Benutzersprache)',
  'namegrspr': 'Name (Grundsprache)',
  'name1': 'Name 1',
  'name2': 'Name 2',
  'name3': 'Name 3',
  // Mask/table
  'tzeilen': 'Anzahl Tabellenzeilen',
  'aktzeile': 'Aktuelle Zeilennummer',
  'grliste': 'Gruppenliste',
  'dnr': 'Datenbanknummer',
  // Article
  'kart': 'Artikelnummer',
  'kartname': 'Artikelbezeichnung',
  'kartmind': 'Mindestbestand',
  'kartle': 'Leistungseinheit',
  'kartvland': 'Versandland Artikel',
  'artgr': 'Artikelgruppe',
  'mindest': 'Mindestbestand',
  'le': 'Leistungseinheit',
  // Order / Sales
  'opart': 'Auftragsart',
  'vdn': 'Vorgangsnummer',
  'kdnr': 'Kundennummer',
  'lfdnr': 'Laufende Nummer',
  'pos': 'Positionsnummer',
  'menge': 'Menge',
  'preis': 'Preis',
  'betrag': 'Betrag',
  'rabatt': 'Rabatt',
  'waession': 'Währung (Session)',
  'waehr': 'Währung',
  'iwbu': 'Inlandswährungsbetrag',
  'awbu': 'Auslandswährungsbetrag',
  'iwges': 'Gesamtbetrag Inland',
  'awges': 'Gesamtbetrag Ausland',
  // Dates
  'liefdat': 'Lieferdatum',
  'belegdat': 'Belegdatum',
  'faellig': 'Fälligkeitsdatum',
  'vondat': 'Von-Datum',
  'bisdat': 'Bis-Datum',
  'gueltigbis': 'Gültig bis',
  // Status
  'status': 'Status',
  'freigabe': 'Freigabe',
  'gesperrt': 'Gesperrt',
  'aktiv': 'Aktiv',
  // Address
  'strasse': 'Straße',
  'plz': 'Postleitzahl',
  'ort': 'Ort',
  'land': 'Land',
  'inland': 'Inland',
  // Finance
  'konto': 'Sachkonto',
  'gegenkonto': 'Gegenkonto',
  'kostenstelle': 'Kostenstelle',
  'kostentraeger': 'Kostenträger',
  'steuerkz': 'Steuerkennzeichen',
  'mwst': 'Mehrwertsteuer',
  // Stock / Warehouse
  'lager': 'Lager',
  'lagerort': 'Lagerort',
  'bestand': 'Bestand',
  'reserviert': 'Reserviert',
  'verfuegbar': 'Verfügbar',
  // Purchase
  'liefnr': 'Lieferantennummer',
  'liefname': 'Lieferantenname',
  'bestnr': 'Bestellnummer',
  // Infosystem
  'arb': 'Arbeitsbereich',
  'bkopf': 'Berichtskopf-FOP',
  'bfuss': 'Berichtsfuß-FOP',
  'tab': 'Tabellen-FOP',
  'maskein': 'Maskeneintritt-FOP',
  'isref': 'Infosystem-Referenz',
  // Buffer/system
  'mehr': 'Weitere Datensätze vorhanden',
  'success': 'Erfolgreich',
  'evtvar': 'Event-Feld',
  'evtart': 'Event-Art',
  'evtkommd': 'Event-Kommando',
  // Text / description
  'text': 'Text',
  'bemerkung': 'Bemerkung',
  'kommentar': 'Kommentar',
  'beschreibung': 'Beschreibung',
  'info': 'Information',
  // Reference attributes
  'nummer_ref': 'Nummer (Referenz)',
  'such_ref': 'Suchbegriff (Referenz)',
  'id_ref': 'ID (Referenz)',
};

/**
 * Look up a field abbreviation in the common fields table (case-insensitive).
 *
 * @param fieldName - Technical field name as it appears in FOP source (e.g. `"kart"`)
 * @returns German description string, or `undefined` if not found
 */
export function lookupCommonField(fieldName: string): string | undefined {
  return COMMON_FIELDS[fieldName.toLowerCase()];
}
