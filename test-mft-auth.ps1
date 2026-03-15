# ============================================================
# MyForterro API Auth Test Script
# Testet Token-Abruf, Tenant-Liste und Modell-Liste
# ============================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$ClientId,

    [Parameter(Mandatory=$true)]
    [string]$ClientSecret,

    [string]$Application = "",

    [string]$TokenUrl = "https://integration-myforterro-core.fcs-dev.eks.forterro.com/connect/token",

    [string]$ApiBase = "https://integration-myforterro-api.fcs-dev.eks.forterro.com"
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " MyForterro API Auth Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Token-URL:    $TokenUrl"
Write-Host "API Base:     $ApiBase"
Write-Host "Client ID:    $ClientId"
Write-Host "Client Secret: $('*' * [Math]::Min($ClientSecret.Length, 8))..."
if ($Application) { Write-Host "Application:  $Application" }
Write-Host ""

# ── Schritt 1: Token holen ────────────────────────────────────

Write-Host "--- Schritt 1: Token anfordern ---" -ForegroundColor Yellow

$body = @{
    grant_type    = "client_credentials"
    client_id     = $ClientId
    client_secret = $ClientSecret
}
if ($Application) {
    $body.application = $Application
}

Write-Host "POST $TokenUrl"
Write-Host "Body: grant_type=client_credentials, client_id=$ClientId, application=$Application"

try {
    $tokenResponse = Invoke-RestMethod -Uri $TokenUrl -Method Post -Body $body -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop
    $token = $tokenResponse.access_token
    $expiresIn = $tokenResponse.expires_in

    Write-Host "[OK] Token erhalten!" -ForegroundColor Green
    Write-Host "  Token-Typ:   $($tokenResponse.token_type)"
    Write-Host "  Laeuft ab in: $expiresIn Sekunden"
    Write-Host "  Token (erste 50 Zeichen): $($token.Substring(0, [Math]::Min(50, $token.Length)))..."
    Write-Host ""

    # JWT Payload dekodieren (mittlerer Teil)
    $parts = $token.Split('.')
    if ($parts.Length -ge 2) {
        $payload = $parts[1]
        # Base64url -> Base64
        $payload = $payload.Replace('-', '+').Replace('_', '/')
        switch ($payload.Length % 4) {
            2 { $payload += '==' }
            3 { $payload += '=' }
        }
        try {
            $decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($payload))
            $jwt = $decoded | ConvertFrom-Json
            Write-Host "  JWT Claims:" -ForegroundColor Cyan
            Write-Host "    sub:    $($jwt.sub)"
            Write-Host "    aud:    $($jwt.aud)"
            Write-Host "    iss:    $($jwt.iss)"
            Write-Host "    scope:  $($jwt.scope)"
            if ($jwt.'mf:app_id') { Write-Host "    mf:app_id:  $($jwt.'mf:app_id')" }
            if ($jwt.'mf:uid') { Write-Host "    mf:uid:     $($jwt.'mf:uid')" }
            if ($jwt.role) { Write-Host "    role:       $($jwt.role)" }
            Write-Host ""
        } catch {
            Write-Host "  (JWT konnte nicht dekodiert werden)" -ForegroundColor DarkGray
        }
    }
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = ""
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        $reader.Close()
    }
    Write-Host "[FEHLER] Token-Anfrage fehlgeschlagen!" -ForegroundColor Red
    Write-Host "  Status: $statusCode"
    Write-Host "  Body:   $errorBody"
    Write-Host ""
    Write-Host "Moegliche Ursachen:" -ForegroundColor Yellow
    Write-Host "  - client_id ist falsch (Kennung der MyForterro-Anwendung pruefen)"
    Write-Host "  - client_secret ist falsch (Geheimnis erneuern in 'Danger Zone')"
    Write-Host "  - application ist falsch (Kennung der Zielanwendung pruefen)"
    exit 1
}

$headers = @{
    Authorization = "Bearer $token"
}

# ── Schritt 2: Tenants abrufen ────────────────────────────────

Write-Host "--- Schritt 2: Tenant-Liste abrufen ---" -ForegroundColor Yellow
Write-Host "GET $ApiBase/v1/admin/tenants"

try {
    $tenantsResponse = Invoke-RestMethod -Uri "$ApiBase/v1/admin/tenants" -Method Get -Headers $headers -ErrorAction Stop

    if ($tenantsResponse -is [array] -and $tenantsResponse.Length -gt 0) {
        Write-Host "[OK] $($tenantsResponse.Length) Tenant(s) gefunden:" -ForegroundColor Green
        foreach ($t in $tenantsResponse) {
            Write-Host "  - tenantId: $($t.tenantId)  slug: $($t.slug)"
        }
        $tenantId = $tenantsResponse[0].tenantId
        Write-Host ""
        Write-Host "  Verwende ersten Tenant: $tenantId" -ForegroundColor Cyan
    } else {
        Write-Host "[WARNUNG] Keine Tenants gefunden oder leere Antwort." -ForegroundColor Yellow
        Write-Host "  Response: $($tenantsResponse | ConvertTo-Json -Depth 3)"
        Write-Host "  Gib eine Tenant-ID manuell ein oder pruefe die Berechtigungen."
        $tenantId = ""
    }
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "[WARNUNG] Tenant-Abfrage fehlgeschlagen (Status $statusCode)" -ForegroundColor Yellow
    Write-Host "  Das ist normal wenn keine Admin-Berechtigung vorliegt."
    Write-Host "  Tenant-ID muss dann manuell eingegeben werden."
    $tenantId = ""
}

Write-Host ""

if (-not $tenantId) {
    Write-Host "Kein Tenant verfuegbar - Modell-Abfrage wird uebersprungen." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " Ergebnis: Token OK, Tenants nicht verfuegbar" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    exit 0
}

# ── Schritt 3: Modelle abrufen ────────────────────────────────

Write-Host "--- Schritt 3: Modell-Liste abrufen ---" -ForegroundColor Yellow

$modelHeaders = @{
    Authorization  = "Bearer $token"
    "MFT-Tenant-Id" = $tenantId
}

Write-Host "GET $ApiBase/v1/ai/inference/openai/models"
Write-Host "  MFT-Tenant-Id: $tenantId"

try {
    $modelsResponse = Invoke-RestMethod -Uri "$ApiBase/v1/ai/inference/openai/models" -Method Get -Headers $modelHeaders -ErrorAction Stop

    $modelList = $modelsResponse.data
    if ($modelList -and $modelList.Length -gt 0) {
        Write-Host "[OK] $($modelList.Length) Modell(e) verfuegbar:" -ForegroundColor Green
        foreach ($m in $modelList) {
            Write-Host "  - $($m.id)  (owned_by: $($m.owned_by))"
        }
    } else {
        Write-Host "[WARNUNG] Keine Modelle gefunden." -ForegroundColor Yellow
        Write-Host "  Response: $($modelsResponse | ConvertTo-Json -Depth 3)"
    }
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = ""
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        $reader.Close()
    }
    Write-Host "[FEHLER] Modell-Abfrage fehlgeschlagen!" -ForegroundColor Red
    Write-Host "  Status: $statusCode"
    Write-Host "  Body:   $errorBody"
}

Write-Host ""

# ── Schritt 4: Test-Chat (optional) ──────────────────────────

if ($modelList -and $modelList.Length -gt 0) {
    $testModel = $modelList[0].id
    Write-Host "--- Schritt 4: Test-Chat mit $testModel ---" -ForegroundColor Yellow

    $chatBody = @{
        model    = $testModel
        messages = @(
            @{ role = "user"; content = "Antworte nur mit: OK" }
        )
    } | ConvertTo-Json -Depth 3

    Write-Host "POST $ApiBase/v1/ai/inference/openai/chat/completions"

    try {
        $chatResponse = Invoke-RestMethod -Uri "$ApiBase/v1/ai/inference/openai/chat/completions" -Method Post -Headers $modelHeaders -Body $chatBody -ContentType "application/json" -ErrorAction Stop

        $answer = $chatResponse.choices[0].message.content
        Write-Host "[OK] Antwort: $answer" -ForegroundColor Green
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorBody = ""
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $errorBody = $reader.ReadToEnd()
            $reader.Close()
        }
        Write-Host "[FEHLER] Chat fehlgeschlagen!" -ForegroundColor Red
        Write-Host "  Status: $statusCode"
        Write-Host "  Body:   $errorBody"
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Test abgeschlossen" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verwendung im cucumbergnerator:" -ForegroundColor Cyan
Write-Host "  Client ID:     $ClientId"
Write-Host "  Client Secret: (gespeichert)"
if ($tenantId) { Write-Host "  Tenant ID:     $tenantId" }
Write-Host ""
