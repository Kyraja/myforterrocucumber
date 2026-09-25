# Aufnahme-Checkliste fuer AI-Extraktion

## Ziel
Diese Checkliste stellt sicher, dass Meeting-Transkripte spaeter automatisch in ein AP-Protokoll und Cucumber-Szenarien ueberfuehrt werden koennen.

## Pflichtangaben je Thema
- AP-ID und Titel klar nennen.
- Scope In und Scope Out explizit sagen.
- Fachregel mit Marker ansagen: "Regel: ..."
- Ausnahme mit Marker ansagen: "Ausnahme: ..."
- Abnahme mit Marker ansagen: "Akzeptanz: ..."
- Offene Punkte mit Marker ansagen: "Offen: ..."
- Entscheidung mit Marker ansagen: "Entscheidung: ..."
- Verantwortlich + Termin nennen.

## Empfohlene Sprecher-Marker
- Fachbereich:
- Beratung:
- Entwicklung:
- Test:

## Satzschablonen (sprechen wie ein Formular)
- "Regel: Bei Auftragsart Service ist Kostenstelle Pflicht."
- "Ausnahme: Bei Auftragsart Standard ist das Feld optional."
- "Akzeptanz: Ohne Kostenstelle darf nicht freigegeben werden."
- "Nicht im Scope: Historische Daten werden nicht migriert."
- "Entscheidung: Validierung serverseitig und clientseitig."

## Extraktions-Output (Zielfelder)
- AP-Metadaten
- Beschreibung (Ist/Soll, Scope, BR-IDs)
- Technische Anpassung
- Abnahmekriterien (AC-IDs)
- Szenario-Mapping (SC-IDs)
- Risiken / offene Punkte

## Qualitaetsregeln fuer Audio/Transkript
- Pro Aussage nur ein Sachverhalt.
- Keine Pronomen ohne Referenz ("das", "dieses Feld") vermeiden.
- Feldnamen, Masken, Datenbanken vollstaendig aussprechen.
- Entscheidungen immer wiederholen und bestaetigen lassen.
