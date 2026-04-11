/**
 * Static (non-AI) guidelines checker for FOP source files.
 *
 * Implements a subset of the official abas FOP coding guidelines as local
 * rules that run instantly without an API call.  The AI agent (`buildFopGuidelinesPrompt`)
 * handles the semantic checks that require code understanding; this module
 * covers the purely syntactic/structural ones.
 *
 * Rules checked:
 * 1. `noabbrev` present in interpreter directive
 * 2. No German command keywords (`.weiter`, `.formel`, etc.)
 * 3. Variable naming convention (`xt`/`xi`/`xb`/`xd`/`xv`/`xp` prefixes)
 * 4. Header block present (`Autor`/`Funktion`)
 * 5. File not excessively long (> 500 lines)
 * 6. All field accesses use a buffer prefix
 * 7. EFOP file naming convention (`S[NNNN].[FIELD].[EVENT].FO2`)
 * 8. FOP located in an `ow*`-workspace folder
 * 9. Reference variables in sub-FOP context use conditional declare guard
 *
 * The letter grade is derived from finding counts via {@link scoreFromFindings}.
 */
import type { FopFile, GuidelineFinding, GuidelinesResult } from '../types/fop';

type Severity = 'error' | 'warning' | 'info';

/** Convenience factory for a local `GuidelineFinding`. */
function finding(rule: string, line: number, severity: Severity, message: string): GuidelineFinding {
  return { rule, line, severity, message, source: 'local' };
}

/**
 * Derive a letter grade from the finding counts.
 * Any error → F; warnings and info degrade from A toward D based on thresholds.
 */
function scoreFromFindings(findings: GuidelineFinding[]): GuidelinesResult['score'] {
  const errors = findings.filter(f => f.severity === 'error').length;
  const warnings = findings.filter(f => f.severity === 'warning').length;
  const infos = findings.filter(f => f.severity === 'info').length;
  if (errors > 0) return 'F';
  if (warnings >= 5 || infos >= 10) return 'D';
  if (warnings >= 3 || infos >= 7) return 'C';
  if (warnings >= 2 || infos >= 4) return 'B';
  return 'A';
}

/**
 * Run all static guideline rules against a parsed FOP file.
 *
 * This function is synchronous and fast — suitable for running on every file
 * load without user-perceptible delay.  The `source: 'local'` tag on every
 * finding distinguishes these results from AI-generated findings.
 *
 * @param fop - Fully parsed FOP file to check
 * @returns Letter grade and ordered list of findings
 */
export function checkGuidelinesLocal(fop: FopFile): GuidelinesResult {
  const findings: GuidelineFinding[] = [];

  // Rule 1: noabbrev missing
  if (!fop.hasNoabbrev) {
    findings.push(finding('noabbrev-missing', 1, 'warning',
      fop.interpreterMode === 'german'
        ? 'Interpreter-Direktive fehlt "noabbrev"'
        : 'Interpreter directive missing "noabbrev"'));
  }

  // Rule 2: English commands preferred
  for (let i = 0; i < fop.rawLines.length; i++) {
    const line = fop.rawLines[i].trim().toLowerCase();
    if (line.startsWith('.weiter') || line.startsWith('.formel') || line.startsWith('.zuweisen') || line.startsWith('.ende') || line.startsWith('.eingabe')) {
      findings.push(finding('german-commands', i + 1, 'warning',
        'German command used — prefer English (.continue/.formula/.assign/.end/.input)'));
      break; // Only flag once per file
    }
  }

  // Rule 3: Variable naming convention
  for (const v of fop.variables) {
    if (!v.followsNamingConvention && !v.name.startsWith('x')) {
      findings.push(finding('naming-convention', v.declaredAtLine, 'warning',
        `Variable "${v.name}" does not follow naming convention (xt/xi/xb/xd/xv/xp prefix)`));
    }
  }

  // Rule 4: Header missing
  if (!fop.header.author && !fop.header.function) {
    findings.push(finding('header-missing', 1, 'warning',
      'FOP header block missing (Autor/Funktion/Ablauf)'));
  }

  // Rule 5: File too long
  if (fop.rawLines.length > 500) {
    findings.push(finding('file-too-long', 1, 'info',
      `FOP has ${fop.rawLines.length} lines — consider splitting into subroutines`));
  }

  // Rule 6: Buffer prefix missing (M|field vs field)
  for (const ref of fop.maskReferences) {
    if (!ref.buffer || ref.buffer.length === 0) {
      findings.push(finding('buffer-prefix-missing', ref.line, 'error',
        `Field "${ref.field}" used without buffer prefix (use M|${ref.field})`));
    }
  }

  // Rule 7: Naming — EFOP file naming convention S[NNNN].[FIELD].[EVENT]
  const filename = fop.filename.replace(/\.[^.]+$/, '');
  const isEfop = !filename.startsWith('IS.') && !filename.startsWith('SUB.') && !filename.startsWith('CRON.') && !filename.startsWith('SER.');
  if (isEfop && !/^S\d{4}\./i.test(filename)) {
    findings.push(finding('naming-convention-file', 1, 'info',
      `EFOP filename "${fop.filename}" does not follow convention S[NNNN].[FIELD].[EVENT].FO2`));
  }

  // Rule 8: ow-workspace prefix
  const pathParts = fop.relativePath.split('/');
  if (pathParts.length > 1 && !pathParts[0].startsWith('ow') && !pathParts[0].startsWith('is') && !pathParts[0].startsWith('fb')) {
    findings.push(finding('ow-workspace', 1, 'info',
      `FOP not in ow*-workspace folder (found: ${pathParts[0]})`));
  }

  // Rule 9: Conditional declare in sub-FOPs
  if (fop.subprogramCalls.length > 0 || fop.filename.includes('SUB.')) {
    for (const v of fop.variables) {
      if (!v.conditionalDeclare && !v.isPrimitive) {
        findings.push(finding('conditional-declare', v.declaredAtLine, 'warning',
          `Variable "${v.name}" declared without guard (? _F|defined()) in potential sub-FOP context`));
        break; // Only first occurrence
      }
    }
  }

  return {
    score: scoreFromFindings(findings),
    findings,
  };
}
