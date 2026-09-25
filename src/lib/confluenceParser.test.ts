import { describe, it, expect } from 'vitest';
import { parseConfluenceHtml, extractHtmlFromMime, decodeQuotedPrintable } from './confluenceParser';

// ── quoted-printable decoding ────────────────────────────────

describe('decodeQuotedPrintable', () => {
  it('decodes =XX hex sequences', () => {
    expect(decodeQuotedPrintable('=3D')).toBe('=');
    expect(decodeQuotedPrintable('a=20b')).toBe('a b');
  });

  it('removes soft line breaks', () => {
    expect(decodeQuotedPrintable('hello=\nworld')).toBe('helloworld');
    expect(decodeQuotedPrintable('hello=\r\nworld')).toBe('helloworld');
  });

  it('decodes UTF-8 sequences', () => {
    // =C3=BC = ü in UTF-8 (but our decoder produces latin1 chars, which is fine for HTML entity context)
    const result = decodeQuotedPrintable('Bez=C3=BCglich');
    expect(result).toContain('glich');
  });
});

// ── MIME extraction ──────────────────────────────────────────

describe('extractHtmlFromMime', () => {
  it('returns plain HTML as-is', () => {
    const html = '<html><body><h1>Test</h1></body></html>';
    expect(extractHtmlFromMime(html)).toBe(html);
  });

  it('extracts HTML from MIME document', () => {
    const mime = `Content-Type: multipart/related;
\tboundary="----=_Part_72"

------=_Part_72
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Location: file:///C:/exported.html

<html>
<body><h1>Test =3D OK</h1></body>
</html>
------=_Part_72`;

    const result = extractHtmlFromMime(mime);
    expect(result).toContain('<html>');
    expect(result).toContain('Test = OK');
    expect(result).not.toContain('=3D');
  });
});

// ── Confluence HTML parsing ──────────────────────────────────

describe('parseConfluenceHtml', () => {
  it('parses h4 headings with pipe-separated format into features', () => {
    const html = `
      <html><body>
        <h2>Stammdaten</h2>
        <h4>Kurztext | V-12-03 | P12:3</h4>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>254</td></tr>
          <tr><td>such</td><td>ANEUTRAL</td></tr>
          <tr><td>namebspr</td><td>Sehr geehrte Damen und Herren</td></tr>
        </table>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);
    expect(result.features).toHaveLength(1);

    const pkg = result.features[0];
    const feature = pkg.feature;
    expect(feature.name).toBe('Kurztext (V-12-03)');
    expect(feature.description).toContain('V-12-03');
    expect(feature.description).toContain('P12:3');
    // Scenarios stay empty — tests come from the AI response, not rule-based generation
    expect(feature.scenarios).toHaveLength(0);

    // Table data is forwarded via sourceText so the AI has full context
    expect(pkg.sourceText).toContain('nummer');
    expect(pkg.sourceText).toContain('254');
    expect(pkg.sourceText).toContain('ANEUTRAL');
    expect(pkg.sourceText).toContain('namebspr');
  });

  it('parses multiple h4 sections into separate features', () => {
    const html = `
      <html><body>
        <h2>Stammdaten</h2>
        <h4>Kurztext | V-12-03 | P12:3</h4>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>254</td></tr>
          <tr><td>such</td><td>ANEUTRAL</td></tr>
        </table>
        <h4>Zusatzposition | V-02-04 | P2:4</h4>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>14</td></tr>
          <tr><td>such</td><td>VERPACKUNG</td></tr>
        </table>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);
    expect(result.features).toHaveLength(2);
    expect(result.features[0].feature.name).toContain('Kurztext');
    expect(result.features[1].feature.name).toContain('Zusatzposition');
  });

  it('captures h4 headings without pipe format as freetext if text exists', () => {
    const html = `
      <html><body>
        <h4>Just a plain heading</h4>
        <p>Hier steht eine Prozessbeschreibung die als Fließtext importiert werden soll.</p>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);
    expect(result.features).toHaveLength(1);
    expect(result.features[0].feature.name).toBe('Just a plain heading');
    expect(result.features[0].feature.description).toContain('Prozessbeschreibung');
    expect(result.features[0].feature.scenarios).toHaveLength(0);
  });

  it('captures h2 freetext sections as features', () => {
    const html = `
      <html><body>
        <h1>Testdokument</h1>
        <h2>Angebotsprozess</h2>
        <p>Der Angebotsprozess beginnt mit der Erfassung der Kundenanfrage.</p>
        <p>Danach wird ein Angebot im System angelegt und an den Kunden versendet.</p>
        <h2>Stammdaten</h2>
        <h4>Kurztext | V-12-03 | P12:3</h4>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>254</td></tr>
        </table>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);
    // h2 "Angebotsprozess" with text + h4 table section
    expect(result.features).toHaveLength(2);

    const freetext = result.features[0];
    expect(freetext.feature.name).toBe('Angebotsprozess');
    expect(freetext.feature.description).toContain('Kundenanfrage');
    expect(freetext.feature.scenarios).toHaveLength(0);
    expect(freetext.headingLevel).toBe(2);

    const table = result.features[1];
    expect(table.feature.name).toContain('Kurztext');
    expect(table.feature.scenarios).toHaveLength(0);
    expect(table.sourceText).toContain('nummer');
    expect(table.sourceText).toContain('254');
  });

  it('captures h3 freetext sections as features', () => {
    const html = `
      <html><body>
        <h2>Prozesse</h2>
        <h3>Rechnungsstellung</h3>
        <p>Die Rechnung wird automatisch aus dem Lieferschein erstellt.</p>
        <p>Der Rechnungsbetrag wird aus den Positionen berechnet.</p>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);
    // h3 "Rechnungsstellung" has text → becomes a feature
    const rechnungFeature = result.features.find(f => f.feature.name === 'Rechnungsstellung');
    expect(rechnungFeature).toBeDefined();
    expect(rechnungFeature!.feature.description).toContain('Rechnung');
    expect(rechnungFeature!.headingLevel).toBe(3);
  });

  it('handles mixed document: tables + freetext at different levels', () => {
    const html = `
      <html><body>
        <h1>001 - Angebot bis Rechnung</h1>
        <h2>Stammdaten</h2>
        <h3>Schicht 1</h3>
        <h4>Kurztext | V-12-03 | P12:3</h4>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>254</td></tr>
          <tr><td>such</td><td>ANEUTRAL</td></tr>
        </table>
        <h2>Prozess Angebot</h2>
        <p>Ein Angebot wird fuer den Kunden 70001 erstellt.</p>
        <p>Position 1: Artikel TESTARTKEL, Menge 10 Stueck.</p>
        <h3>Angebot drucken</h3>
        <p>Nach Freigabe wird das Angebot gedruckt und versendet.</p>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);

    // Table-based feature — no rule-based scenarios, table content in sourceText
    const tableFeature = result.features.find(f => f.feature.name.includes('Kurztext'));
    expect(tableFeature).toBeDefined();
    expect(tableFeature!.feature.scenarios).toHaveLength(0);
    expect(tableFeature!.sourceText).toContain('nummer');
    expect(tableFeature!.sourceText).toContain('254');

    // Freetext h2 feature
    const angebotFeature = result.features.find(f => f.feature.name === 'Prozess Angebot');
    expect(angebotFeature).toBeDefined();
    expect(angebotFeature!.feature.description).toContain('70001');

    // Freetext h3 feature
    const druckenFeature = result.features.find(f => f.feature.name === 'Angebot drucken');
    expect(druckenFeature).toBeDefined();
    expect(druckenFeature!.feature.description).toContain('gedruckt');
  });

  it('handles tables with Tabellenfeld sections', () => {
    const html = `
      <html><body>
        <h4>Zahlungsbedingung | V-12-08 | P12:8</h4>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>203</td></tr>
          <tr><td>such</td><td>Z30N</td></tr>
          <tr><th>Tabellenfeld</th><th>Wert</th></tr>
          <tr><td>frist</td><td>30</td></tr>
        </table>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);
    expect(result.features).toHaveLength(1);

    // No scenarios — but table field content must be preserved in sourceText
    // so the AI has everything it needs to generate tests.
    expect(result.features[0].feature.scenarios).toHaveLength(0);
    const src = result.features[0].sourceText;
    expect(src).toContain('frist');
    expect(src).toContain('30');
  });

  it('builds correct TOC with structure/package/skipped entries', () => {
    const html = `
      <html><body>
        <h1>001 - Angebot bis Rechnung</h1>
        <h2>Stammdaten</h2>
        <h3>Schicht 1</h3>
        <h4>Kurztext | V-12-03 | P12:3</h4>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>254</td></tr>
        </table>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);
    expect(result.toc).toHaveLength(4);
    expect(result.toc[0]).toEqual({ text: '001 - Angebot bis Rechnung', level: 1, kind: 'structure' });
    expect(result.toc[1]).toEqual({ text: 'Stammdaten', level: 2, kind: 'structure' });
    expect(result.toc[2]).toEqual({ text: 'Schicht 1', level: 3, kind: 'structure' });
    expect(result.toc[3].kind).toBe('package');
  });

  it('returns empty result for empty document', () => {
    const result = parseConfluenceHtml('<html><body></body></html>');
    expect(result.features).toHaveLength(0);
    expect(result.skippedChapters).toHaveLength(0);
  });

  it('handles multiple tables under one h4 as one feature with one scenario', () => {
    const html = `
      <html><body>
        <h4>Region | V-97-01 | PS97:1</h4>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>72</td></tr>
          <tr><td>such</td><td>DEUTSCHLAND</td></tr>
        </table>
        <table>
          <tr><th>Kopffeld</th><th>Wert</th></tr>
          <tr><td>nummer</td><td>73</td></tr>
          <tr><td>such</td><td>FRANKREICH</td></tr>
        </table>
      </body></html>
    `;

    const result = parseConfluenceHtml(html);
    expect(result.features).toHaveLength(1);
    // No rule-based scenarios — both variants must end up in sourceText so the AI can pick them up
    expect(result.features[0].feature.scenarios).toHaveLength(0);
    const src = result.features[0].sourceText;
    expect(src).toContain('DEUTSCHLAND');
    expect(src).toContain('FRANKREICH');
  });
});
