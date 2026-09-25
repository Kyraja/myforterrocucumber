# Cucumbergenerator Learnings

Lokale Wissensbasis fuer bestaetigte KI-Learnings pro Workspace.
Stand: 2026-07-31T05:53:10.748Z

## Kurzuebersicht
- [rule] Globalregel Tests: Positions-Storno bzw. DELETE nach Prozesskontext (confirmed)
- [rule] Globalregel Tests: Bewegungsdaten kontextbezogen bereinigen (confirmed)
- [rule] Globalregel Tests: Wiedervorlage nur bei Angebot/Rahmenauftrag (confirmed)
- [rule] Suchwort (confirmed)

## Daten (maschinell)
```json
[
  {
    "id": "std-bdd-transactions-delete-or-position-storno",
    "title": "Globalregel Tests: Positions-Storno bzw. DELETE nach Prozesskontext",
    "summary": "Offene EK/VK-Restmengen ueber Positions-Storno/Abschlusskennzeichen bereinigen; sonstige offene Prozessbelege koennen bei passendem Kontext ueber command \"DELETE\" entfernt werden.",
    "comment": "Nur anwenden, wenn der Prozesskontext diese Art der Bereinigung fachlich erlaubt.",
    "keywords": [
      "positions-storno",
      "delete",
      "ek",
      "vk",
      "restmenge"
    ],
    "category": "rule",
    "scope": "general",
    "usage": "tests-global",
    "confirmed": true,
    "acceptedCount": 1,
    "rejectedCount": 0,
    "sourcePath": "domain/bdd-cleanup",
    "createdAt": "2026-07-30T11:41:04.440Z",
    "updatedAt": "2026-07-30T11:41:04.440Z"
  },
  {
    "id": "std-bdd-transactions-cleanup-contextual",
    "title": "Globalregel Tests: Bewegungsdaten kontextbezogen bereinigen",
    "summary": "Wenn ein erzeugter Bewegungsbeleg im selben Szenario nicht weiterverwendet wird, muss ein fachlicher Bereinigungsschritt enthalten sein (final weiterverarbeiten, REVERSAL oder passender Abschluss). Keine offenen Prozessbelege stehen lassen.",
    "comment": "Betrifft fachliche Testsauberkeit in EK/VK-Prozessketten.",
    "keywords": [
      "bewegungsdaten",
      "cleanup",
      "reversal",
      "prozessbeleg",
      "offen"
    ],
    "category": "rule",
    "scope": "general",
    "usage": "tests-global",
    "confirmed": true,
    "acceptedCount": 1,
    "rejectedCount": 0,
    "sourcePath": "domain/bdd-cleanup",
    "createdAt": "2026-07-30T11:41:04.440Z",
    "updatedAt": "2026-07-30T11:41:04.440Z"
  },
  {
    "id": "std-bdd-wiedervorlage-offer-framework-only",
    "title": "Globalregel Tests: Wiedervorlage nur bei Angebot/Rahmenauftrag",
    "summary": "Wiedervorlage-bezogene Bereinigung (z. B. Wiedervorlage-Datum entfernen) nur dann einplanen, wenn der Vorgangstyp Angebot oder Rahmenauftrag ist und das Konzept dies verlangt.",
    "comment": "Nicht pauschal auf alle Belegarten anwenden.",
    "keywords": [
      "wiedervorlage",
      "angebot",
      "rahmenauftrag",
      "datum"
    ],
    "category": "rule",
    "scope": "general",
    "usage": "tests-global",
    "confirmed": true,
    "acceptedCount": 1,
    "rejectedCount": 0,
    "sourcePath": "domain/bdd-cleanup",
    "createdAt": "2026-07-30T11:41:04.440Z",
    "updatedAt": "2026-07-30T11:41:04.440Z"
  },
  {
    "id": "b26d4849-aa7a-4252-a5c8-ca5458e49f65",
    "title": "Suchwort",
    "summary": "Alle Suchwörter sind immer in Großbuchstaben zu haben und MÜSSEN immer mit einem Buchstaben starten",
    "keywords": [],
    "category": "rule",
    "scope": "general",
    "usage": "tests-global",
    "confirmed": true,
    "acceptedCount": 0,
    "rejectedCount": 0,
    "createdAt": "2026-07-30T11:42:26.465Z",
    "updatedAt": "2026-07-31T05:53:10.531Z"
  }
]
```
