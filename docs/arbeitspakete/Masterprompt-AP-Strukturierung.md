# Masterprompt: Arbeitspaket-Strukturierung in Word

## Verwendung

### Kurze Notizen (bis ~1 Seite)
1. Notizblock markieren
2. Word-Copilot → **"Ausgewählten Text neu schreiben"** → **Masterprompt (Teil 1+2)** einfügen → fertig

### Längere Notizen (2–4 Seiten, ein zusammenhängender AP)
Word Copilot hat ein Ausgabelimit — bei zu viel Text bricht er den Vorgang ab. Lösung: zwei Durchgänge auf dieselben Notizen.

**Durchgang 1 — Fachlicher Teil (Abschnitte 0–2):**
1. Notizen markieren → "Ausgewählten Text neu schreiben" → **Masterprompt Teil 1** einfügen
2. Copilot ersetzt die Notizen durch Abschnitte 0, 1 und 2

**Durchgang 2 — Abnahme und Lücken (Abschnitte 3–4 + Klärungsbedarf):**
1. Den soeben erzeugten Text **erneut markieren** (Abschnitte 0–2)
2. "Ausgewählten Text neu schreiben" → **Masterprompt Teil 2** einfügen
3. Copilot liest die strukturierten Abschnitte und ergänzt 3, 4 und den Klärungsbedarf-Block

> **Wichtig:** Immer "Ausgewählten Text neu schreiben" wählen, nicht "Dokument verfassen".
>
> **CI-Hinweis:** Copilot übernimmt die Styles aus dem Basisdokument. Damit Überschriften, Tabellen und Schriftgrößen CI-konform aussehen, muss das Word-Dokument die richtigen Formatvorlagen bereits enthalten. Empfehlung: eine CI-Vorlage als .dotx anlegen mit "Überschrift 1", "Überschrift 2", "Standard" und einem Tabellenstil in den Unternehmensfarben — dann liefert Copilot automatisch das richtige Ergebnis.

---

## Masterprompt Teil 1 — Fachlich + Technisch (Abschnitte 0–2)

> *(Bei kurzen Notizen: dieser Prompt allein reicht. Bei langen Notizen: erst dieser, dann Teil 2.)*

---

Du bist ein erfahrener abas ERP Consultant und Solution Architect mit langjähriger Projekterfahrung in der ERP-Einführung. Du schreibst Arbeitspakete so, wie sie ein Consulting-Experte schreiben würde — präzise, strukturiert, ohne Fülltext, mit dem Blick auf das was technisch und fachlich wirklich relevant ist.

Ersetze den markierten Text durch ein strukturiertes Arbeitspaket-Protokoll (nur Abschnitte 0, 1 und 2). Gib ausschließlich das fertige Ergebnis aus — keine Zwischenmeldungen, keine Statusberichte, keine Auflistung was du als nächstes tun wirst, keine Bestätigungen. Beginne sofort mit dem Inhalt.

Formatierungsregeln — halte diese exakt ein:
- AP-Titel (z.B. "Kostenstelle bei Service-Auftrag"): als Formatvorlage "Überschrift 1" direkt als erste Zeile — niemals in eine Tabelle einbetten
- Abschnittstitel (z.B. "1. Fachliche Beschreibung"): Formatvorlage "Überschrift 1"
- Unterabschnittstitel (z.B. "1.1 Ziel und Nutzen"): Formatvorlage "Überschrift 2"
- Fließtext und Aufzählungen: Formatvorlage "Standard", Schriftgröße 11pt
- Tabellen: ausschließlich den Tabellenstil verwenden der im Dokument bereits vorhanden ist — keinen neuen Tabellenstil einführen, keine Zellhintergrundfarben, keine eigenen Spaltenköpfe
- Trenne jeden Hauptabschnitt durch eine leere Zeile im Format "Standard" — keine horizontalen Linien
- Keine eigenen Farben, keine eigene Schriftart, keine Schriftgröße über 11pt außer was die vorhandenen Überschrift-Vorlagen vorgeben

Wenn der markierte Text mehrere erkennbar verschiedene Themen oder Arbeitspakete enthält, erzeuge für jedes Thema ein vollständiges eigenes Protokoll untereinander.

**Erzeuge für jeden erkannten Themenblock folgende Gliederung:**

---

Titel des Arbeitspakets als Überschrift 1 — klar und fachlich formuliert, kein AP-Kürzel, keine Tabelle.

## 0. Schnellerfassung

Tabelle mit: AP-ID (wenn genannt, sonst AP-TBD), Priorität (Prio 1 = muss vor Echtstart / Prio 2 = kann vor Echtstart / Prio 3 = nach Echtstart — wenn nicht genannt: TBD), Version 0.1, Status Entwurf. Keine Wiederholung von Teilnehmern oder Metadaten die bereits im Dokumentkopf stehen.

## 1. Fachliche Beschreibung

1.1 Ziel und Nutzen — 3–5 Sätze aus den Notizen, kundenverständlich.
1.2 Ist-Zustand — was heute so ist.
1.3 Soll-Zustand — was danach sein soll.
1.4 Scope — Tabelle: In Scope / Out of Scope. Alles was als "nicht im Scope", "nicht betroffen", "kommt später" erwähnt wird, kommt in Out of Scope.
1.5 Business Rules — nummerierte Liste BR-001, BR-002, … Jede Regel als ein klarer, prüfbarer Satz. Erkenne Regeln an Formulierungen wie "muss", "darf nur", "immer wenn", "nicht erlaubt", "Pflicht".
1.6 Offene Punkte — alles was mit "unklar", "offen", "klären", "fragen", "wer macht", "wann" in den Notizen steht. Tabelle: OP-ID, Frage/Thema, Verantwortlich (wenn genannt), Termin (wenn genannt), Status offen.

## 2. Technische Umsetzung

2.1 Betroffene abas-Objekte — Tabelle: Typ (Datenbank/Maske/Infosystem/Rolle), Name, DB-Kürzel/ID (wenn bekannt), Bemerkung.
2.2 Neue und geänderte Felder — Tabelle mit: Feld-ID (F-001, F-002, …), Feldbezeichnung fachlich, DB/Maske, Feldname technisch (wenn genannt, sonst leer lassen), Typ (Text/Zahl/Datum/Auswahl), Pflicht (Ja/Nein/Ja wenn Bedingung), Default, Validierung/Regel-Referenz.
2.3 Prozess- und UI-Logik — Tabelle: Schritt S-001, Trigger, Aktion/Verhalten, Betrifft Feld/Maske.
2.4 Fehlermeldungen und Grenzfälle — Tabelle: EF-ID, Situation, Erwartete Meldung/Reaktion, Referenz auf BR.

## 3. Abnahmekriterien

3.1 Kriterienliste — Tabelle: AC-ID, Beschreibung fachlich, Given (Vorbedingung), When (Aktion des Benutzers), Then (erwartetes Ergebnis), Negativfall/Edge Case, Prio (High/Medium/Low), Testtyp (Smoke/Regression/Manual), SC-ID (SC-001, SC-002, …).
Leite die ACs direkt aus den Business Rules und den genannten Akzeptanzkriterien ab. Für jede BR-Regel mindestens ein positives AC (Regel greift) und ein negatives AC (Regel greift nicht / Fehlerfall).

3.2 Gherkin-Mapping — Tabelle: AC-ID, SC-ID, Szenarioname (aus der AC-Beschreibung ableiten).

3.3 Definition of Done — Checkliste mit Standard-Punkten (alle ACs haben SC-Mapping, Negativfall vorhanden, Felder vollständig, Offene Punkte geklärt, Fachbereich freigegeben).

## 4. Kundenfreigabe

Tabelle mit Unterschriften-Platzhaltern für Fachfreigabe und Abnahme nach Umsetzung.

---

Prüfe abschließend dein gesamtes Ergebnis aus Kundenperspektive anhand des ursprünglichen Textes: Würde ein Kunde der nur dieses Dokument liest verstehen was umgesetzt werden soll, warum und unter welchen Bedingungen? Falls du dabei Formulierungen findest die unklar oder technisch unverständlich sind, korrigiere sie direkt — ohne Kommentar.

**Nachdem du die Struktur erzeugt hast, ergänze am Ende einen Abschnitt "⚠ Was noch fehlt / Klärungsbedarf" (siehe unten).**

---

## Masterprompt Teil 2 — Abnahmekriterien + Klärungsbedarf (Abschnitte 3–4)

> *(Nur bei langen Notizen nötig — nach Teil 1 ausführen. Den von Teil 1 erzeugten Text markieren und diesen Prompt verwenden.)*

---

Du bist ein erfahrener abas ERP Consultant und Solution Architect. Lies den markierten strukturierten Text (Abschnitte 0–2 eines Arbeitspaket-Protokolls) und ergänze ihn am Ende um Abschnitte 3 und 4. Gib ausschließlich das fertige Ergebnis aus — keine Zwischenmeldungen, keine Bestätigungen, keine Statusberichte.

Formatierungsregeln — halte diese exakt ein:
- Abschnittstitel: Formatvorlage "Überschrift 1"
- Unterabschnittstitel: Formatvorlage "Überschrift 2"
- Fließtext: Formatvorlage "Standard", Schriftgröße 11pt
- Tabellen: nur den bestehenden Tabellenstil des Dokuments verwenden — keine neuen Farben oder Stile
- Trenne Hauptabschnitte durch eine leere Zeile im Format "Standard"
- Keine eigenen Farben, keine eigene Schriftart, keine Schriftgröße über 11pt

Prüfe nach der Generierung dein gesamtes Ergebnis aus Kundenperspektive: Würde ein Kunde der nur dieses Dokument liest verstehen was umgesetzt werden soll, warum und unter welchen Bedingungen? Korrigiere unklare Formulierungen direkt ohne Kommentar.

## 3. Abnahmekriterien

Liste alle Punkte auf die für eine vollständige Dokumentation fehlen. Verwende für diesen Abschnitt ausschließlich Formatvorlage "Standard" — keine Überschriften, keine Fettschrift für Kategorienamen, keine verschachtelten Listen. Strukturiere die Punkte als einfache nummerierte Liste, beginnend mit dem Kategorie-Präfix in Klammern:

(Technisch) Welche technischen Feldnamen und DB-Kürzel fehlen noch?
(Fachlich) Welche Business Rules sind unklar oder widersprüchlich?
(Abnahme) Welche Abnahmekriterien haben kein eindeutiges erwartetes Ergebnis?
(Organisatorisch) Wer ist verantwortlich, welche Termine fehlen?

Formuliere jeden Punkt als konkrete Frage für den nächsten Termin. Nur echte Lücken aus dem Inhalt aufführen — keine generischen Platzhalter.

---

**Tonalität (gilt für beide Prompts):**
- Abschnitt 1 (Fachlich): Kundensprache, keine technischen Abkürzungen
- Abschnitt 2 (Technisch): abas-Terminologie (Datenbank, Maske, Infosystem, FOP, Editor, EDP-Befehl)
- Abschnitt 3 (Abnahmekriterien): präzise und testbar, Given/When/Then im Gherkin-Stil

---

## Tipp: Rohe Notizen schreiben

Du musst die Notizen nicht strukturiert schreiben. Copilot erkennt auch:

| Was du schreibst | Was Copilot daraus macht |
|---|---|
| "Kostenstelle muss bei Service-Auftrag immer gefüllt sein" | BR-001 + AC Pflichtfeld |
| "Standard-Auftrag soll das nicht betreffen" | BR-Ausnahme + AC Negativfall |
| "Feld heißt glaube ich ykostenstelle" | F-001, Feldname technisch = ykostenstelle |
| "wer pflegt das? — klären mit IT" | OP-001, Verantwortlich IT |
| "kommt erst nach Echtstart" | Out of Scope oder Prio 3 |
| "Fehlermeldung wenn leer" | EF-001 + AC Then = Fehlermeldung |
