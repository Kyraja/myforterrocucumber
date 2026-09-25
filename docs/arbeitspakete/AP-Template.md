# AP-Template (CI-konform)

## Metadaten
- AP-ID: AP-0123
- Titel: [Kurzer Arbeitspaket-Titel]
- Version: 0.1
- Status: Entwurf
- Owner: [Name]
- Datum: 2026-07-31
- Quelle: [Konzept, Workshop, Transkript, Ticket]

## 1. Beschreibung
### Ziel und Nutzen
[3-5 Saetze zu Fachziel und Nutzen]

### Scope
- Scope In: [Was ist enthalten]
- Scope Out: [Was ist ausgeschlossen]

### Betroffene Objekte
- Datenbank: [z.B. P0:1]
- Maske/Editor: [z.B. Kundenstamm]
- Rollen: [z.B. sy, sb]

### Ist-Zustand
[Kurzbeschreibung]

### Soll-Zustand
[Kurzbeschreibung]

### Business Rules
- BR-001: [Regel 1]
- BR-002: [Regel 2]

### Annahmen und offene Punkte
- [Annahme / offene Frage]

## 2. Technische Anpassung
### Architektur/Konfiguration
[Welche Komponenten oder Einstellungen werden angepasst]

### Datenmodell
- Tabelle/Feld: [Name]
- Typ/Format: [Typ]
- Validierung/Default: [Regel]

### UI und Prozesslogik
- UI-Aenderung: [Beschreibung]
- Prozessschritt: [Beschreibung]
- Trigger/Folgeaktion: [Beschreibung]

### Fehler- und Grenzfaelle
- [Negativfall 1]
- [Negativfall 2]

### Nicht-funktional
- Performance: [Anforderung]
- Logging/Audit: [Anforderung]
- Berechtigungen: [Anforderung]

### Rollout und Fallback
- Deployment: [Vorgehen]
- Fallback: [Vorgehen]

## 3. Abnahmekriterien
| AC-ID | Kriterium | Vorbedingung | Aktion | Erwartetes Ergebnis | Negativfall | Prio | Testtyp | SC-ID |
|---|---|---|---|---|---|---|---|---|
| AC-001 | [Kriterium] | [Given] | [When] | [Then] | [Edge/Fehler] | High | Smoke | SC-001 |
| AC-002 | [Kriterium] | [Given] | [When] | [Then] | [Edge/Fehler] | Medium | Regression | SC-002 |

### Gherkin-Mapping
- SC-001 -> [Feature-Datei + Szenarioname]
- SC-002 -> [Feature-Datei + Szenarioname]

### Definition of Done
- [ ] Alle ACs haben mindestens ein SC-Mapping.
- [ ] Mindestens ein Negativszenario vorhanden.
- [ ] Fachbereich hat freigegeben.
