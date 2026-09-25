# Vorschlag: Protokollstruktur fuer Arbeitspakete

## Ziel
Dieser Vorschlag definiert einen einheitlichen Aufbau fuer Arbeitspaket-Protokolle im abas-Cucumber-Umfeld.
Der Fokus liegt auf:
- klarer Fachlichkeit
- sauberer technischer Umsetzbarkeit
- direkt testbaren Abnahmekriterien
- guter Grundlage fuer spaetere AI-gestuetzte Erstellung aus Meeting-Transkripten

## Warum diese Struktur
- Kollegen verstehen den Inhalt schnell (gleiches Muster in jedem AP).
- Entwicklung und Test erhalten klare, referenzierbare Anforderungen.
- Cucumber-Szenarien lassen sich nachvollziehbar aus den Kriterien ableiten.
- Transkripte koennen spaeter automatisiert in diese Struktur ueberfuehrt werden.

## Empfohlener Aufbau pro Arbeitspaket

## 1. Beschreibung
### 1.1 Metadaten
- AP-ID
- Titel
- Version
- Status
- Owner
- Datum

### 1.2 Ziel und Nutzen
- Kurzbeschreibung in 3-5 Saetzen
- Fachlicher Mehrwert und Problembezug

### 1.3 Scope
- Scope In: Was ist Teil des AP
- Scope Out: Was gehoert explizit nicht dazu

### 1.4 Ist/Soll
- Ist-Zustand: aktuelles Verhalten
- Soll-Zustand: gewuenschtes Verhalten

### 1.5 Business Rules
- BR-001, BR-002, ...
- Jede Regel eindeutig, pruefbar, ohne Mehrdeutigkeit

### 1.6 Offene Punkte
- Offene Fragen
- Annahmen
- Abhaengigkeiten

## 2. Technische Anpassung
### 2.1 Betroffene Objekte
- Datenbanken
- Masken/Editoren
- Infosysteme
- Rollen/Berechtigungen

### 2.2 Umsetzung
- Datenmodell (Felder, Typen, Defaults, Validierungen)
- UI-Aenderungen (Pflichtfelder, Sichtbarkeit, Reihenfolge)
- Prozesslogik (Trigger, Folgeaktionen)

### 2.3 Fehler- und Grenzfaelle
- erwartete Fehlermeldungen
- Gegenpruefungen
- Edge Cases

### 2.4 Betrieb
- Logging/Audit
- Rollout-Hinweise
- Fallback bei Problemen

## 3. Abnahmekriterien
### 3.1 Kriterienliste
- AC-001, AC-002, ...
- Pro Kriterium: Vorbedingung, Aktion, Erwartung

### 3.2 Szenario-Mapping
- Zuordnung je Kriterium zu Testfall-ID (SC-001, SC-002, ...)
- Jede AC-ID sollte mindestens ein Szenario haben

### 3.3 Definition of Done
- fachlich freigegeben
- testbar dokumentiert
- negative Faelle enthalten

## Mini-Beispiel (ausgefuellt)

### AP-0123: Pflichtfeld Kostenstelle bei Service-Auftrag

### 1. Beschreibung
- Ziel: Service-Auftraege duerfen nur mit gepflegter Kostenstelle freigegeben werden.
- Scope In: Auftragserfassung und Freigabeprozess.
- Scope Out: Historische Auftraege und Altmigration.
- BR-001: Bei Auftragsart Service ist Kostenstelle Pflicht.
- BR-002: Bei Auftragsart Standard bleibt Kostenstelle optional.

### 2. Technische Anpassung
- Feld kostenstelle wird bei Auftragsart Service als Pflicht validiert.
- Validierung erfolgt clientseitig und serverseitig.
- Fehlermeldung mit Feldfokus bei fehlender Kostenstelle.

### 3. Abnahmekriterien
- AC-001 -> SC-001: Service-Auftrag ohne Kostenstelle kann nicht freigegeben werden.
- AC-002 -> SC-002: Service-Auftrag mit Kostenstelle wird freigegeben.
- AC-003 -> SC-003: Standard-Auftrag ohne Kostenstelle bleibt freigabefaehig.

## Vorschlag fuer Transkript-zu-Protokoll (spaeter)

## Leitlinie fuer Meetings
Damit AI gut extrahieren kann, sollten Aussagen bewusst markiert werden:
- Regel: ...
- Ausnahme: ...
- Akzeptanz: ...
- Nicht im Scope: ...
- Entscheidung: ...
- Offen: ...

## Empfohlenes AI-Zielformat
Aus dem Transkript werden automatisch erzeugt:
- Metadaten
- Abschnitt 1 (Beschreibung)
- Abschnitt 2 (Technische Anpassung)
- Abschnitt 3 (Abnahmekriterien)
- Szenario-Mapping fuer Cucumber

## Einfuehrungsplan im Team
1. Zwei Pilot-Arbeitspakete mit dieser Struktur dokumentieren.
2. Review mit Beratung, Entwicklung und Test durchfuehren.
3. Wording und Unterkapitel finalisieren.
4. Danach als Teamstandard festlegen.
5. Anschliessend AI-Extraktion aus Transkripten als naechsten Schritt aufsetzen.

## Fazit
Die 1/2/3-Struktur (Beschreibung, Technische Anpassung, Abnahmekriterien) ist fuer euer Setup optimal, wenn sie einheitlich und mit IDs genutzt wird. Damit habt ihr sowohl bessere Teamkommunikation als auch eine belastbare Basis fuer spaetere Automatisierung mit AI.
