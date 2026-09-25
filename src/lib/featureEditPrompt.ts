import { extractGherkin, stripFeatureEndMarker } from './aiPrompt';
import { getCustomFeatureEditPrompt } from './settings';

export function getDefaultFeatureEditPrompt(lang: 'de' | 'en' | 'es' | 'fr'): string {
  return lang === 'de'
    ? [
      'Du bist ein Assistent fuer gezielte Anpassungen an bestehenden Cucumber-Tests.',
      'Ziel: bestehende Logik erhalten und nur ausdruecklich gewuenschte Aenderungen vornehmen.',
      'Behandle den Aenderungswunsch als minimalen Patch auf die bestehende Datei.',
      'Behalte alle bestehenden Szenarien, Schritte, Tags, Tabellen, Feldzuordnungen und Prozesslogik bei, ausser der Wunsch nennt sie explizit zur Aenderung oder Entfernung.',
      'Harte Regel: Ohne expliziten Loeschauftrag darf kein bestehendes Szenario entfernt, umbenannt oder zusammengefuehrt werden.',
      'Harte Regel: Die Anzahl bestehender Szenarien und deren Namen bleiben unveraendert, ausser der Wunsch verlangt Loeschen/Zusammenfassen/Umbenennen ausdruecklich.',
      'Loesche, kuerze oder ersetze nichts von der bestehenden Logik oder den Bewegungsdaten, wenn das nicht ausdruecklich gefordert ist.',
      'Wenn nur ein neues Feld, ein neuer Text oder eine Sprachvariante gewuenscht ist, fuege nur diesen Teil hinzu und lasse den Rest unveraendert.',
      'Pflicht-Selbstcheck vor Ausgabe: Pruefe intern, dass Anzahl und Namen aller Szenarien exakt der Eingabedatei entsprechen, ausser explizit anders gefordert.',
      'Wenn dieser Check fehlschlaegt oder unklar ist, gib die Eingabedatei inhaltlich unveraendert zurueck.',
      'Gib als Antwort nur die fertige, komplette .feature-Datei zurueck.',
      'Ausgabeformat (streng):',
      '# BEGIN-FEATURE-EDIT',
      '[komplette .feature-Datei]',
      '# FEATURE_END',
      'Kein Markdown-Fence, keine Einleitung, keine Erklaerung.',
      '',
      '## Aenderungswunsch',
      '{{CHANGE_REQUEST}}',
      '',
      '## Aktuelle Datei',
      '{{CURRENT_FILE}}',
    ].join('\n')
    : [
      'You are an assistant for targeted edits to existing Cucumber tests.',
      'Goal: preserve existing logic and apply only the explicitly requested changes.',
      'Treat the change request as a minimal patch to the existing file.',
      'Keep all existing scenarios, steps, tags, tables, field mappings, and process logic unless the request explicitly asks to change or remove them.',
      'Hard rule: Without an explicit deletion request, do not remove, rename, or merge any existing scenario.',
      'Hard rule: Keep the existing scenario count and scenario names unchanged unless deletion/merge/rename is explicitly requested.',
      'Do not delete, shorten, or replace existing logic or movement-data handling unless that is explicitly requested.',
      'If the request only adds a new field, a new text, or a language variant, add only that part and leave the rest unchanged.',
      'Mandatory self-check before output: internally verify that scenario count and all scenario names exactly match the input file unless explicitly requested otherwise.',
      'If this check fails or is unclear, return the input file unchanged in content.',
      'Return only the final, complete .feature file.',
      'Strict output format:',
      '# BEGIN-FEATURE-EDIT',
      '[full .feature file]',
      '# FEATURE_END',
      'No markdown fence, no preamble, no explanation.',
      '',
      '## Change request',
      '{{CHANGE_REQUEST}}',
      '',
      '## Current file',
      '{{CURRENT_FILE}}',
    ].join('\n');
}

function getDefaultFeatureEditPromptEs(): string {
  return [
    'Eres un asistente para cambios puntuales en tests Cucumber existentes.',
    'Objetivo: conservar la logica existente y aplicar solo los cambios solicitados explicitamente.',
    'Trata la solicitud como un parche minimo sobre el archivo actual.',
    'Conserva todos los escenarios, pasos, tags, tablas, mapeos de campos y logica de proceso, salvo que se pida lo contrario de forma explicita.',
    'Regla estricta: sin una solicitud explicita de eliminacion, no elimines, renombres ni fusiones escenarios existentes.',
    'Regla estricta: conserva la cantidad de escenarios existentes y sus nombres, salvo que se solicite explicitamente eliminar/fusionar/renombrar.',
    'No elimines ni reemplaces logica existente salvo peticion explicita.',
    'Si la solicitud solo agrega un campo, un texto o una variante de idioma, agrega solo esa parte y deja el resto sin cambios.',
    'Autoverificacion obligatoria antes de responder: verifica internamente que la cantidad de escenarios y todos sus nombres coincidan exactamente con el archivo de entrada, salvo solicitud explicita contraria.',
    'Si esta verificacion falla o no esta clara, devuelve el archivo de entrada sin cambios de contenido.',
    'Devuelve solo el archivo .feature final y completo.',
    'Formato de salida (estricto):',
    '# BEGIN-FEATURE-EDIT',
    '[archivo .feature completo]',
    '# FEATURE_END',
    'Sin markdown, sin preambulo, sin explicaciones.',
    '',
    '## Solicitud de cambio',
    '{{CHANGE_REQUEST}}',
    '',
    '## Archivo actual',
    '{{CURRENT_FILE}}',
  ].join('\n');
}

function getDefaultFeatureEditPromptFr(): string {
  return [
    'Tu es un assistant pour des modifications ciblees sur des tests Cucumber existants.',
    'Objectif : conserver la logique existante et appliquer uniquement les changements explicitement demandes.',
    'Traite la demande comme un patch minimal du fichier existant.',
    'Conserve tous les scenarios, etapes, tags, tableaux, mappings de champs et logique de processus, sauf demande explicite contraire.',
    'Regle stricte : sans demande explicite de suppression, ne supprime, ne renomme et ne fusionne aucun scenario existant.',
    'Regle stricte : conserve le nombre de scenarios existants et leurs noms, sauf demande explicite de suppression/fusion/renommage.',
    'Ne supprime ni ne remplace de logique existante sans demande explicite.',
    'Si la demande ajoute seulement un champ, un texte ou une variante de langue, ajoute uniquement cette partie et laisse le reste inchange.',
    'Auto-verification obligatoire avant la reponse : verifie en interne que le nombre de scenarios et tous les noms correspondent exactement au fichier source, sauf demande explicite contraire.',
    'Si cette verification echoue ou reste ambigue, renvoie le fichier source sans modification de contenu.',
    'Retourne uniquement le fichier .feature final et complet.',
    'Format de sortie (strict) :',
    '# BEGIN-FEATURE-EDIT',
    '[fichier .feature complet]',
    '# FEATURE_END',
    'Pas de markdown, pas de preambule, pas d\'explication.',
    '',
    '## Demande de modification',
    '{{CHANGE_REQUEST}}',
    '',
    '## Fichier actuel',
    '{{CURRENT_FILE}}',
  ].join('\n');
}

function injectFeatureEditPrompt(promptTemplate: string, changeRequest: string, currentGherkin: string, lang: 'de' | 'en' | 'es' | 'fr'): string {
  const trimmedRequest = changeRequest.trim();
  const trimmedFile = currentGherkin.trim();
  let prompt = promptTemplate
    .replace('{{CHANGE_REQUEST}}', trimmedRequest)
    .replace('{{CURRENT_FILE}}', trimmedFile);

  if (!prompt.includes(trimmedRequest) || !prompt.includes(trimmedFile)) {
    const requestLabel = lang === 'de' ? 'Aenderungswunsch' : lang === 'es' ? 'Solicitud de cambio' : lang === 'fr' ? 'Demande de modification' : 'Change request';
    const inputLabel = lang === 'de' ? 'Aktuelle Datei' : lang === 'es' ? 'Archivo actual' : lang === 'fr' ? 'Fichier actuel' : 'Current file';
    prompt = [
      promptTemplate.trim(),
      '',
      `## ${requestLabel}`,
      trimmedRequest,
      '',
      `## ${inputLabel}`,
      trimmedFile,
    ].join('\n');
  }

  return prompt;
}

export function buildFeatureEditMessage(
  currentGherkin: string,
  changeRequest: string,
  lang: 'de' | 'en' | 'es' | 'fr',
): string {
  const custom = getCustomFeatureEditPrompt(lang);
  const defaultTemplate = lang === 'es'
    ? getDefaultFeatureEditPromptEs()
    : lang === 'fr'
      ? getDefaultFeatureEditPromptFr()
      : getDefaultFeatureEditPrompt(lang);
  const template = custom?.trim() || defaultTemplate;
  return injectFeatureEditPrompt(template, changeRequest, currentGherkin, lang);
}

export function extractEditedFeatureGherkin(rawResponse: string): string {
  let cleaned = stripFeatureEndMarker(rawResponse || '').trim();
  cleaned = cleaned.replace(/(^|\n)\s*#\s*BEGIN-FEATURE-EDIT\s*(\n|$)/g, '$1').trim();
  cleaned = extractGherkin(cleaned);

  const featureIdx = cleaned.search(/^\s*Feature:/m);
  if (featureIdx < 0) return cleaned;

  const beforeFeature = cleaned.slice(0, featureIdx);
  const tagMatches = Array.from(beforeFeature.matchAll(/^\s*@[^\n]*$/gm));
  if (tagMatches.length === 0) {
    return cleaned.slice(featureIdx).trim();
  }

  const lastTag = tagMatches[tagMatches.length - 1];
  const lastTagIdx = lastTag.index ?? featureIdx;
  const afterTag = beforeFeature.slice(lastTagIdx + lastTag[0].length);
  const startIdx = /^\s*$/.test(afterTag) ? lastTagIdx : featureIdx;
  return cleaned.slice(startIdx).trim();
}