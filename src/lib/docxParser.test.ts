import { describe, it, expect, vi } from 'vitest';
import type { ParseProfile } from '../types/gherkin';

// Mock mammoth — we don't need real .docx parsing in tests
vi.mock('mammoth', () => ({
  default: {
    convertToHtml: vi.fn(),
  },
}));

// Mock docx — not needed for parsing tests
vi.mock('docx', () => ({}));

import mammoth from 'mammoth';
import { parseDocx } from './docxParser';
import { DEFAULT_PARSE_PROFILE } from './parseProfile';

const mockMammoth = vi.mocked(mammoth.convertToHtml);

function mockFile(): File {
  return new File(['dummy'], 'test.docx', { type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' });
}

/** Profile without technicalSectionKeywords — tests legacy splitting behavior */
const FLAT_PROFILE: ParseProfile = {
  ...DEFAULT_PARSE_PROFILE,
  splitting: { headingLevels: [1, 2], technicalSectionKeywords: [] },
};

// ── Legacy behavior (no technical section filter) ───────────

describe('parseDocx — flat profile (no technical section)', () => {
  it('parses a document with two H2 sections into two features', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Kundenklassifizierung</h2>
        <p>Datenbank: V-00-01</p>
        <p>Testbenutzer: sy</p>
        <p>Szenario: Feld setzen</p>
        <p>Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW</p>
        <p>Aktion: Feld setzen: ykat = "A"</p>
        <p>Ergebnis: Feld pruefen: ykat = "A"</p>
        <h2>Artikelgewicht</h2>
        <p>Datenbank: P2:1</p>
        <p>Szenario: Gewicht pruefen</p>
        <p>Vorbedingung: Editor oeffnen: Artikel, P2:1, VIEW, Datensatz 123</p>
        <p>Ergebnis: Feld nicht leer: ygewicht</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);

    expect(result.features).toHaveLength(2);
    expect(result.features[0].feature.name).toBe('Kundenklassifizierung');
    expect(result.features[0].feature.testUser).toBe('sy');
    expect(result.features[0].feature.scenarios).toHaveLength(1);
    expect(result.features[0].feature.scenarios[0].steps).toHaveLength(3);

    expect(result.features[1].feature.name).toBe('Artikelgewicht');
    expect(result.features[1].feature.scenarios).toHaveLength(1);
  });

  it('uses heading as feature name when no Feature: keyword present', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h1>Mein Feature</h1>
        <p>Szenario: Test</p>
        <p>Vorbedingung: Etwas</p>
        <p>Ergebnis: Etwas anderes</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Mein Feature');
  });

  it('prefers explicit Feature: keyword over heading', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Ueberschrift</h2>
        <p>Feature: Expliziter Name</p>
        <p>Szenario: Test</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Expliziter Name');
  });

  it('skips preamble content before first heading', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <p>Dieses Dokument enthaelt Testszenarien.</p>
        <p>Bitte ignorieren Sie diese Einleitung.</p>
        <h2>Echtes Feature</h2>
        <p>Szenario: Test</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Echtes Feature');
  });

  it('treats entire document as one section if no headings found', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <p>Feature: Ohne Ueberschrift</p>
        <p>Szenario: Test</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Ohne Ueberschrift');
  });

  it('returns empty result for empty document', async () => {
    mockMammoth.mockResolvedValue({ value: '', messages: [] });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);
    expect(result.features).toHaveLength(0);
  });

  it('includes validation issues per feature', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Unvollstaendig</h2>
        <p>Szenario: Nur Aktion</p>
        <p>Aktion: Editor speichern</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);

    expect(result.features).toHaveLength(1);
    const issues = result.features[0].validation;

    // Should have warnings for missing Given and Then
    expect(issues.some((i) => i.level === 'warning' && i.message.includes('Einstiegspunkt'))).toBe(true);
    expect(issues.some((i) => i.level === 'warning' && i.message.includes('Pruefung'))).toBe(true);
  });

  it('respects custom profile keywords', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Custom</h2>
        <p>Testfall: Benutzerdefiniert</p>
        <p>Voraussetzung: Editor oeffnen: Kunde, 0:1, NEW</p>
        <p>Erwartung: Feld pruefen: ykat = "A"</p>
      `,
      messages: [],
    });

    const customProfile: ParseProfile = {
      id: 'custom',
      name: 'Custom',
      keywords: {
        feature: ['Feature', 'Merkmal'],
        database: ['Datenbank'],
        testUser: ['Testbenutzer'],
        tags: ['Tags'],
        description: ['Beschreibung'],
        scenario: ['Szenario', 'Testfall'],
        comment: ['Kommentar'],
      },
      stepKeywords: {
        precondition: ['Vorbedingung', 'Voraussetzung'],
        action: ['Aktion'],
        result: ['Ergebnis', 'Erwartung'],
        and: ['Und'],
        but: ['Aber'],
      },
      splitting: { headingLevels: [1, 2], technicalSectionKeywords: [] },
      customActions: [],
    };

    const result = await parseDocx(mockFile(), customProfile);

    expect(result.features).toHaveLength(1);
    const scenario = result.features[0].feature.scenarios[0];
    expect(scenario.name).toBe('Benutzerdefiniert');
    expect(scenario.steps).toHaveLength(2);
    expect(scenario.steps[0].keyword).toBe('Given');
    expect(scenario.steps[1].keyword).toBe('Then');
  });

  it('splits on H3 when configured', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h3>Feature Eins</h3>
        <p>Szenario: Test A</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
        <h3>Feature Zwei</h3>
        <p>Szenario: Test B</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
      `,
      messages: [],
    });

    const profileH3: ParseProfile = {
      ...DEFAULT_PARSE_PROFILE,
      id: 'h3',
      name: 'H3 Split',
      splitting: { headingLevels: [3], technicalSectionKeywords: [] },
    };

    const result = await parseDocx(mockFile(), profileH3);

    expect(result.features).toHaveLength(2);
    expect(result.features[0].feature.name).toBe('Feature Eins');
    expect(result.features[1].feature.name).toBe('Feature Zwei');
  });
});

// ── Technical section behavior (Technische Umsetzung) ───────

describe('parseDocx — with technicalSectionKeywords (default profile)', () => {
  it('extracts features only from chapters with "Technische Umsetzung"', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Kundenklassifizierung</h2>
        <p>Allgemeine Beschreibung des Features.</p>
        <h3>Technische Umsetzung</h3>
        <p>Datenbank: V-00-01</p>
        <p>Testbenutzer: sy</p>
        <p>Szenario: Feld setzen</p>
        <p>Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW</p>
        <p>Aktion: Feld setzen: ykat = "A"</p>
        <p>Ergebnis: Feld pruefen: ykat = "A"</p>
        <h2>Allgemeiner Prozess</h2>
        <p>Hier steht nur eine allgemeine Prozessbeschreibung.</p>
        <p>Keine technische Umsetzung noetig.</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile());

    // Only the chapter with "Technische Umsetzung" is parsed
    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Kundenklassifizierung');
    expect(result.features[0].feature.testUser).toBe('sy');
    expect(result.features[0].feature.scenarios).toHaveLength(1);
    expect(result.features[0].feature.scenarios[0].name).toBe('Feld setzen');

    // Skipped chapter is reported
    expect(result.skippedChapters).toHaveLength(1);
    expect(result.skippedChapters[0].sourceHeading).toBe('Allgemeiner Prozess');
  });

  it('skips chapters without "Technische Umsetzung" and reports them', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Kapitel ohne Technik</h2>
        <p>Nur allgemeine Infos hier.</p>
        <h2>Noch ein Kapitel</h2>
        <p>Auch nur allgemeine Infos.</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile());
    expect(result.features).toHaveLength(0);
    expect(result.skippedChapters).toHaveLength(2);
    expect(result.skippedChapters[0].sourceHeading).toBe('Kapitel ohne Technik');
    expect(result.skippedChapters[1].sourceHeading).toBe('Noch ein Kapitel');
  });

  it('uses content before tech section as Feature description', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h1>Artikelgewicht</h1>
        <p>Fuer den Versand muss das Gewicht gepflegt werden.</p>
        <p>Das Feld ygewicht wird hinzugefuegt.</p>
        <h3>Technische Umsetzung</h3>
        <p>Datenbank: P2:1</p>
        <p>Szenario: Gewicht pruefen</p>
        <p>Vorbedingung: Editor oeffnen: Artikel, P2:1, VIEW, Datensatz 123</p>
        <p>Ergebnis: Feld nicht leer: ygewicht</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile());

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Artikelgewicht');
    expect(result.features[0].feature.description).toContain('Versand');
  });

  it('handles multiple chapters with tech sections', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Feature A</h2>
        <p>Beschreibung A</p>
        <h3>Technische Umsetzung</h3>
        <p>Szenario: Test A</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
        <h2>Feature B</h2>
        <p>Beschreibung B</p>
        <h3>Technische Umsetzung</h3>
        <p>Szenario: Test B</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
        <h2>Kein Test noetig</h2>
        <p>Nur Prosa.</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile());

    expect(result.features).toHaveLength(2);
    expect(result.features[0].feature.name).toBe('Feature A');
    expect(result.features[1].feature.name).toBe('Feature B');

    expect(result.skippedChapters).toHaveLength(1);
    expect(result.skippedChapters[0].sourceHeading).toBe('Kein Test noetig');
  });

  it('recognizes tech section as bold paragraph', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Mein Feature</h2>
        <p>Allgemeine Info.</p>
        <p><strong>Technische Umsetzung</strong></p>
        <p>Szenario: Test</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile());

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Mein Feature');
    expect(result.features[0].feature.scenarios).toHaveLength(1);
  });

  it('handles custom technical section keyword', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Custom Chapter</h2>
        <p>General info.</p>
        <h3>Technical Implementation</h3>
        <p>Szenario: Test</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
      `,
      messages: [],
    });

    const englishProfile: ParseProfile = {
      ...DEFAULT_PARSE_PROFILE,
      splitting: {
        headingLevels: [1, 2],
        technicalSectionKeywords: ['Technical Implementation'],
      },
    };

    const result = await parseDocx(mockFile(), englishProfile);

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Custom Chapter');
  });

  it('handles Word tables without errors', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Feature mit Tabelle</h2>
        <p>Beschreibung mit einer Tabelle:</p>
        <table>
          <tr><th>Feld</th><th>Wert</th></tr>
          <tr><td>ykundenkategorie</td><td>A-Kunde</td></tr>
          <tr><td>ygewicht</td><td>12.5</td></tr>
        </table>
        <h3>Technische Umsetzung</h3>
        <p>Szenario: Tabellen-Test</p>
        <p>Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW</p>
        <p>Ergebnis: Feld pruefen: ykundenkategorie = "A-Kunde"</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile());

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Feature mit Tabelle');
    // Table content doesn't crash the parser; feature is still extracted
    expect(result.features[0].feature.scenarios).toHaveLength(1);
  });

  it('handles tables inside tech section without crash', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Feature</h2>
        <p>Allgemein.</p>
        <h3>Technische Umsetzung</h3>
        <table>
          <tr><td>Feld</td><td>Erwartung</td></tr>
          <tr><td>yname</td><td>Mueller</td></tr>
        </table>
        <p>Szenario: Test</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile());

    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.scenarios).toHaveLength(1);
  });
});

// ── sourceText preservation ─────────────────────────────────

describe('parseDocx — sourceText', () => {
  it('preserves original section text for AI input (technical section path)', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Kundenklassifizierung</h2>
        <p>Neues Feld im Kundenstamm fuer Kategorisierung.</p>
        <h3>Technische Umsetzung</h3>
        <p>Datenbank: V-00-01</p>
        <p>Szenario: Feld setzen</p>
        <p>Vorbedingung: Editor oeffnen: Kundenstamm, P0:1, NEW</p>
        <p>Ergebnis: Feld pruefen: ykat = "A"</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile());

    expect(result.features).toHaveLength(1);
    const pkg = result.features[0];
    // sourceText should contain the original heading and content
    expect(pkg.sourceText).toContain('Kundenklassifizierung');
    expect(pkg.sourceText).toContain('Neues Feld im Kundenstamm');
    expect(pkg.sourceText).toContain('Datenbank: V-00-01');
  });

  it('preserves original section text (flat profile / legacy path)', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>My English Feature</h2>
        <p>This feature adds weight tracking for shipping.</p>
        <p>Szenario: Weight check</p>
        <p>Vorbedingung: Something</p>
        <p>Ergebnis: Something else</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);

    expect(result.features).toHaveLength(1);
    const pkg = result.features[0];
    expect(pkg.sourceText).toContain('My English Feature');
    expect(pkg.sourceText).toContain('weight tracking for shipping');
  });

  it('preserves original text for no-headings fallback', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <p>Feature: Direkt ohne Ueberschrift</p>
        <p>Szenario: Test</p>
        <p>Vorbedingung: X</p>
        <p>Ergebnis: Y</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), FLAT_PROFILE);

    expect(result.features).toHaveLength(1);
    expect(result.features[0].sourceText).toContain('Feature: Direkt ohne Ueberschrift');
  });
});

// ── Einführungskonzept profile (contentEndKeywords + kundeField) ──

import { EINFUEHRUNGSKONZEPT_PROFILE } from './parseProfile';

describe('parseDocx — Einführungskonzept profile (box field extraction)', () => {
  it('extracts kundeField from "Realisierung" row in box table', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Kapitel Eins</h2>
        <p>Hier steht der Anforderungstext mit genug Inhalt fuer den Test.</p>
        <table>
          <tr><td>Realisierung</td><td>Kunde</td></tr>
          <tr><td>Prioritaet</td><td>Hoch</td></tr>
        </table>
        <p>Auswirkungen der Customization/Extension</p>
        <p>Rest</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), EINFUEHRUNGSKONZEPT_PROFILE);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].kundeField).toBe('Kunde');
  });

  it('extracts kundeField "abas" from "Realisierung durch" row', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Kapitel Zwei</h2>
        <p>Anforderungstext mit genug Inhalt.</p>
        <table>
          <tr><td>Realisierung durch</td><td>abas</td></tr>
        </table>
        <p>Auswirkungen der Customization</p>
        <p>Rest</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), EINFUEHRUNGSKONZEPT_PROFILE);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].kundeField).toBe('abas');
  });

  it('falls back to "Kunde" label when no Realisierung row exists', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Legacy Kapitel</h2>
        <p>Anforderungstext hier.</p>
        <table>
          <tr><td>Kunde</td><td>Firma XYZ</td></tr>
          <tr><td>Prioritaet</td><td>Mittel</td></tr>
        </table>
        <p>Auswirkungen der Customization/Extension</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), EINFUEHRUNGSKONZEPT_PROFILE);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].kundeField).toBe('Firma XYZ');
  });

  it('prefers Realisierung over Kunde label', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Beides</h2>
        <p>Anforderungstext hier.</p>
        <table>
          <tr><td>Kunde</td><td>Firma ABC</td></tr>
          <tr><td>Realisierung</td><td>Berater</td></tr>
        </table>
        <p>Auswirkungen der Customization/Extension</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), EINFUEHRUNGSKONZEPT_PROFILE);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].kundeField).toBe('Berater');
  });

  it('extracts aufwandField from "Aufwand" row', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Mit Aufwand</h2>
        <p>Anforderungstext hier.</p>
        <table>
          <tr><td>Realisierung</td><td>Kunde</td></tr>
          <tr><td>Aufwand</td><td>2 Tage</td></tr>
          <tr><td>Prioritaet</td><td>Hoch</td></tr>
        </table>
        <p>Auswirkungen der Customization/Extension</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), EINFUEHRUNGSKONZEPT_PROFILE);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].kundeField).toBe('Kunde');
    expect(result.features[0].aufwandField).toBe('2 Tage');
  });

  it('extracts aufwandField with variant label "Geschaetzter Aufwand"', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Variante</h2>
        <p>Anforderungstext hier.</p>
        <table>
          <tr><td>Realisierung durch</td><td>abas</td></tr>
          <tr><td>Geschaetzter Aufwand</td><td>4h</td></tr>
        </table>
        <p>Auswirkungen der Customization</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), EINFUEHRUNGSKONZEPT_PROFILE);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].kundeField).toBe('abas');
    expect(result.features[0].aufwandField).toBe('4h');
  });

  it('extracts from column-based table (header row + data row)', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Spalten-Layout</h2>
        <p>Anforderungstext fuer spaltenbasierte Tabelle.</p>
        <table>
          <tr>
            <th>Priorität</th><th>Realisierung</th><th>Dauer (ca./h)</th>
            <th>QS (ca./h)</th><th>Kunde (ca./h)</th><th>Bereich</th>
          </tr>
          <tr>
            <td>1</td><td>Kunde</td><td>1,00</td>
            <td>0,00</td><td>1,00</td><td>Admin</td>
          </tr>
        </table>
        <p>Auswirkungen der Customization/Extension</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), EINFUEHRUNGSKONZEPT_PROFILE);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].kundeField).toBe('Kunde');
    expect(result.features[0].aufwandField).toBe('1,00');
  });

  it('extracts "abas" from column-based table', async () => {
    mockMammoth.mockResolvedValue({
      value: `
        <h2>Intern</h2>
        <p>Anforderungstext intern.</p>
        <table>
          <tr>
            <th>Priorität</th><th>Realisierung</th><th>Dauer (ca./h)</th>
          </tr>
          <tr>
            <td>2</td><td>abas</td><td>3,50</td>
          </tr>
        </table>
        <p>Auswirkungen der Customization/Extension</p>
      `,
      messages: [],
    });

    const result = await parseDocx(mockFile(), EINFUEHRUNGSKONZEPT_PROFILE);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].kundeField).toBe('abas');
    expect(result.features[0].aufwandField).toBe('3,50');
  });
});
