# Arbeitspaket-Protokoll — Vorlage

> **Anleitung für den Berater vor Ort:**
> Abschnitt 0 und 1 werden *während* des Kundentermins ausgefüllt.
> Abschnitt 2 (Technisch) kann sofort mitgeschrieben werden, wenn technische Details besprochen werden.
> Abschnitt 3 (Abnahmekriterien) wird im Termin angelegt und nach dem Termin finalisiert.
> Abschnitt 4 (Freigabe) unterschreibt der Kunde.
>
> **Sprache im Meeting:** Aussagen bewusst markieren:
> - `Regel:` … → wird zu Business Rule (BR)
> - `Ausnahme:` … → Negativfall / Edge Case
> - `Akzeptanz:` … → wird zu Abnahmekriterium (AC)
> - `Nicht im Scope:` … → Scope Out
> - `Entscheidung:` … → offener Punkt geklärt
> - `Offen:` … → offener Punkt ungeklärt

---

## 0. Schnellerfassung (vor Ort)

| | |
|---|---|
| **AP-ID** | AP-0000 |
| **Titel** | [Kurztitel – 5 Wörter max.] |
| **Kunde** | [Kundenname] |
| **Berater** | [Name] |
| **Datum / Ort** | [TT.MM.JJJJ / Ort] |
| **Teilnehmer** | [Namen] |
| **Priorität** | ☐ Prio 1 – muss vor Echtstart ☐ Prio 2 – kann vor Echtstart ☐ Prio 3 – nach Echtstart |
| **Version** | 0.1 |
| **Status** | ☐ Entwurf ☐ Review ☐ Freigegeben |

### Notizen / Stichpunkte aus dem Termin

> *(Freitext – schnell mitschreiben, Marker nutzen)*

```
Regel: 
Ausnahme: 
Akzeptanz: 
Nicht im Scope: 
Offen: 
Entscheidung: 
```

---

## 1. Fachliche Beschreibung *(für den Kunden)*

### 1.1 Ziel und Nutzen

> *3–5 Sätze: Was soll erreicht werden? Welches Problem wird gelöst?*

[Beschreibung]

### 1.2 Ist-Zustand

> *Wie verhält sich das System heute?*

[Beschreibung]

### 1.3 Soll-Zustand

> *Wie soll es nach der Umsetzung funktionieren?*

[Beschreibung]

### 1.4 Scope

| In Scope | Out of Scope |
|---|---|
| [Was ist enthalten] | [Was ist ausgeschlossen] |
| | |

### 1.5 Fachliche Regeln (Business Rules)

| BR-ID | Regel | Ausnahme |
|---|---|---|
| BR-001 | [Regel in einem klaren Satz] | [Ausnahme oder –] |
| BR-002 | | |

### 1.6 Offene Punkte

| OP-ID | Frage / Thema | Verantwortlich | Termin | Status |
|---|---|---|---|---|
| OP-001 | | | | ☐ offen ☐ geklärt |

---

## 2. Technische Umsetzung *(intern / Generator-relevant)*

> *Dieser Abschnitt kann parallel im Termin ausgefüllt werden, wenn technische Details besprochen werden.*

### 2.1 Betroffene abas-Objekte

| Typ | Name | DB-Kürzel / Infosystem-ID | Bemerkung |
|---|---|---|---|
| Datenbank | [z.B. Kundenstamm] | [z.B. 0:1, P0:1] | |
| Maske/Editor | [z.B. Verkaufsauftrag] | [z.B. AUF] | |
| Infosystem | [z.B. Auftragsübersicht] | [z.B. eis0001] | |
| Rolle | [z.B. Vertrieb] | [z.B. vk] | |

### 2.2 Neue und geänderte Felder

> *Jede Zeile entspricht einem Feld-Schritt im Generator (feldSetzen / feldPrüfen / feldLeer).*

| Feld-ID | Feldbezeichnung (fachlich) | DB/Maske | Feldname (technisch) | Typ | Pflicht? | Default | Validierung / Regel-Ref |
|---|---|---|---|---|---|---|---|
| F-001 | [z.B. Kostenstelle] | AUF | [z.B. ykostenstelle] | Text | Ja (BR-001) | – | Pflicht wenn Auftragsart = Service |
| F-002 | | | | | | | |

### 2.3 Prozess- und UI-Logik

| Schritt | Trigger | Aktion / Verhalten | Betrifft Feld/Maske |
|---|---|---|---|
| S-001 | [z.B. Speichern] | [z.B. Validierung Pflichtfeld] | F-001 |
| S-002 | | | |

### 2.4 Fehlermeldungen und Grenzfälle

| EF-ID | Situation | Erwartete Meldung / Reaktion | Ref |
|---|---|---|---|
| EF-001 | [z.B. Speichern ohne Kostenstelle] | [z.B. Fehlermeldung "Feld Kostenstelle ist Pflicht"] | BR-001 |

### 2.5 Nicht-funktionale Anforderungen

- **Berechtigungen:** [Rollen, die das Feature nutzen/nicht nutzen dürfen]
- **Logging/Audit:** [Anforderungen oder –]
- **Performance:** [Anforderungen oder –]
- **Rollout:** [Deployment-Besonderheiten, Reihenfolge]
- **Fallback:** [Vorgehen bei Problemen]

---

## 3. Abnahmekriterien

> *Jedes AC sollte direkt einem Gherkin-Szenario (SC) entsprechen.*
> *Given = Vorbedingung, When = Aktion, Then = Erwartetes Ergebnis*

### 3.1 Kriterienliste

| AC-ID | Beschreibung (fachlich) | Given (Vorbedingung) | When (Aktion) | Then (Erwartetes Ergebnis) | Negativfall / Edge Case | Prio | Testtyp | SC-ID |
|---|---|---|---|---|---|---|---|---|
| AC-001 | [Pflichtfeld greift bei Service-Auftrag] | Der Benutzer hat einen Service-Auftrag geöffnet und keine Kostenstelle gefüllt | Er speichert den Auftrag | Eine Fehlermeldung erscheint, der Auftrag wird nicht gespeichert | – | High | Smoke | SC-001 |
| AC-002 | [Service-Auftrag mit Kostenstelle speicherbar] | Kostenstelle ist gefüllt | Er speichert | Auftrag wird gespeichert | – | High | Smoke | SC-002 |
| AC-003 | [Standard-Auftrag ohne Kostenstelle bleibt freigabefähig] | Standard-Auftragsart, keine Kostenstelle | Er speichert | Kein Fehler, Auftrag gespeichert | – | Medium | Regression | SC-003 |

### 3.2 Gherkin-Mapping

> *Zuordnung AC → Feature-Datei + Szenarioname (wird nach Generierung ausgefüllt)*

| AC-ID | SC-ID | Feature-Datei | Szenarioname |
|---|---|---|---|
| AC-001 | SC-001 | [z.B. auf/kostenstelle.feature] | [z.B. Service-Auftrag ohne Kostenstelle wird abgelehnt] |
| AC-002 | SC-002 | | |
| AC-003 | SC-003 | | |

### 3.3 Definition of Done

- [ ] Alle ACs haben mindestens ein SC-Mapping
- [ ] Mindestens ein Negativfall / Grenzfall dokumentiert
- [ ] Felddefinitionen (Abschnitt 2.2) vollständig für alle betroffenen Felder
- [ ] Offene Punkte (Abschnitt 1.6) alle geklärt oder explizit zurückgestellt
- [ ] Fachbereich hat freigegeben (Abschnitt 4)

---

## 4. Kundenfreigabe

> *Dieser Abschnitt bestätigt, dass Kunde und Berater den fachlichen Inhalt gemeinsam abgestimmt haben.*
> *Die technische Umsetzung (Abschnitt 2) und die Gherkin-Szenarien werden separat abgenommen.*

### 4.1 Freigabe Fachkonzept

Hiermit bestätigen wir, dass der fachliche Inhalt dieses Arbeitspaketes (Abschnitte 1 und 3.1) korrekt und vollständig ist.

| | Kunde | Berater |
|---|---|---|
| **Name** | | |
| **Datum** | | |
| **Unterschrift** | | |

### 4.2 Abnahme nach Umsetzung

Hiermit bestätigen wir, dass alle Abnahmekriterien (Abschnitt 3) erfolgreich getestet wurden.

| | Kunde | Berater |
|---|---|---|
| **Name** | | |
| **Datum** | | |
| **Unterschrift** | | |

### 4.3 Offene Punkte bei Abnahme

| AC-ID | Befund | Maßnahme | Verantwortlich | Termin |
|---|---|---|---|---|
| | | | | |

---

## Anhang: Verwendung mit dem Cucumber Generator

> *Wie Abschnitt 2 auf den Generator gemappt wird:*

| AP-Block | Generator-Feld | Beispiel |
|---|---|---|
| 2.1 → Maske/Editor | `editorName` im Schritt `editorOeffnen` | `"Verkaufsauftrag"` |
| 2.1 → DB-Kürzel | `tableRef` | `"AUF"` |
| 2.2 → Feldname (technisch) | `fieldName` in `feldSetzen` / `feldPrüfen` | `"ykostenstelle"` |
| 2.2 → Wert | `value` in `FieldValue` | `"K-100"` |
| 3.1 → Given | `Given`-Schritt: `editorOeffnen` + vorbereitende `feldSetzen` | |
| 3.1 → When | `When`-Schritt: `editorSpeichern` oder `buttonDrücken` | |
| 3.1 → Then | `Then`-Schritt: `feldPrüfen` / `exceptionSpeichern` / `boxMeldung` | |
| 3.1 → Negativfall | Separates Szenario mit `exceptionSpeichern` oder `exceptionFeld` | |
