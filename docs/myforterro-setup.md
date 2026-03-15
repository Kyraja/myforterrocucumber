# MyForterro API — Einrichtung & Konfiguration

## Voraussetzungen

1. Zugang zu **MyForterro** (https://myforterro.com oder Integration-Umgebung)
2. Berechtigung zum Erstellen von Anwendungen

---

## Schritt 1: Anwendung in MyForterro erstellen

1. In MyForterro einloggen
2. Schnellzugriff **"Neue Anwendung erstellen"** starten
3. Formular ausfuellen:
   - **Name:** `cucumbergnerator` (oder beliebiger Name)
   - **Status:** In der Produktion
   - **Startmethode:** Eindeutige Start-URL
   - Restliche Felder leer lassen
4. **Wichtig:** Bei der Validierung werden **Client ID** und **Client Secret** angezeigt.
   Diese Werte sofort notieren — das Secret wird nur einmalig angezeigt!

> Falls das Secret verloren geht: In der Anwendung unter "Danger Zone" > "Das Geheimnis erneuern"

5. Der Anwendung die Rolle **"User"** oder **"Admin"** zuweisen (fuer das AI-Modul erforderlich)
6. Falls noetig: Eine **API-Lizenz** in MyForterro zuweisen

---

## Schritt 2: Credentials im cucumbergnerator eingeben

1. cucumbergnerator oeffnen
2. Oben rechts auf **"Nicht eingeloggt"** klicken
3. **Client ID** und **Client Secret** eingeben
4. **"Einloggen"** klicken

Nach erfolgreichem Login:
- Die verfuegbaren **Tenants** werden automatisch geladen
- Der erste Tenant wird automatisch ausgewaehlt
- Die verfuegbaren **KI-Modelle** werden fuer den ausgewaehlten Tenant geladen

---

## Schritt 3: Tenant und Modell waehlen

- **Tenant:** Ueber das Dropdown den gewuenschten Tenant auswaehlen
  - Falls die Tenant-Liste nicht geladen werden kann (fehlende Admin-Berechtigung):
    Tenant-ID manuell eingeben
- **Modell:** Das gewuenschte KI-Modell auswaehlen (z.B. `gpt-4o`, `claude-sonnet-4`, `gemini-2.5-flash`)

---

## Erweiterte Einstellungen

Unter **"Erweitert"** im Login-Formular:

| Einstellung | Standard (Integration) | Produktion |
|---|---|---|
| Token-URL | `https://integration-myforterro-core.fcs-dev.eks.forterro.com/connect/token` | `https://core.myforterro.com/connect/token` |
| API Base URL | `https://integration-myforterro-api.fcs-dev.eks.forterro.com` | `https://myforterro-api.forterro.com` |
| Zielanwendung | *(optional — wird automatisch aus Tenant-Auswahl gesetzt)* | |

---

## Token-Verhalten

- Token wird automatisch im Browser gespeichert (localStorage)
- Gueltigkeitsdauer: **1 Stunde**
- Bei Ablauf wird automatisch ein neuer Token geholt (kein erneutes Einloggen noetig)
- Client ID und Secret bleiben gespeichert bis zum Ausloggen
- Alle Einstellungen (Tenant, Modell) bleiben nach Browser-Neustart erhalten

---

## Test-Script (PowerShell)

Zum Testen der Credentials ohne den cucumbergnerator:

```powershell
# Einfach
.\test-mft-auth.ps1 -ClientId "deine-client-id" -ClientSecret "dein-secret"

# Mit Zielanwendung
.\test-mft-auth.ps1 -ClientId "deine-client-id" -ClientSecret "dein-secret" -Application "ziel-app-id"

# Produktion
.\test-mft-auth.ps1 -ClientId "deine-client-id" -ClientSecret "dein-secret" -TokenUrl "https://core.myforterro.com/connect/token" -ApiBase "https://myforterro-api.forterro.com"
```

Das Script testet:
1. Token-Abruf (inkl. JWT-Claims Anzeige)
2. Tenant-Liste
3. Modell-Liste
4. Test-Chat mit dem ersten verfuegbaren Modell

---

## Troubleshooting

| Fehler | Ursache | Loesung |
|---|---|---|
| `invalid_client` | Client ID nicht gefunden | Client ID in MyForterro pruefen |
| `invalid_client` (Secret) | Client Secret falsch | Secret in "Danger Zone" erneuern |
| 403 bei Tenants | Keine Admin-Berechtigung | Tenant-ID manuell eingeben |
| 403 bei KI-Anfragen | Fehlende Rolle oder Lizenz | Rolle "User" und AI-Modul in MyForterro aktivieren |
| Keine Modelle | AI-Modul nicht aktiviert | In MyForterro unter Anwendung > Module > AI aktivieren |
| Token abgelaufen | Token aelter als 1 Stunde | Wird automatisch erneuert; bei Fehler: Ausloggen + Einloggen |

---

## Technische Details

### API-Endpunkte

| Endpunkt | Methode | Beschreibung |
|---|---|---|
| `/connect/token` | POST | OAuth2 Token (client_credentials) |
| `/v1/admin/tenants` | GET | Tenant-Liste |
| `/v1/ai/inference/openai/models` | GET | Verfuegbare Modelle |
| `/v1/ai/inference/openai/chat/completions` | POST | Chat Completion (OpenAI-kompatibel) |

### HTTP-Header

```
Authorization: Bearer <token>
MFT-Tenant-Id: <tenant-id>
Content-Type: application/json
```

### OAuth2 Token-Request

```
POST /connect/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&client_id=<anwendungs-id>
&client_secret=<anwendungs-geheimnis>
&application=<zielanwendungs-id>   (optional)
```
