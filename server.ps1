$root = Join-Path $PSScriptRoot "dist"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:5173/")
$listener.Start()
Write-Host "Server laeuft auf http://localhost:5173 - Strg+C zum Beenden"

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $path = $context.Request.Url.LocalPath
    $filePath = Join-Path $root $path.Replace("/", "\")

    if (-not (Test-Path $filePath -PathType Leaf)) {
        $filePath = Join-Path $root "index.html"
    }

    $ext = [IO.Path]::GetExtension($filePath)
    $mime = switch ($ext) {
        ".html" { "text/html; charset=utf-8" }
        ".js"   { "application/javascript" }
        ".css"  { "text/css" }
        ".svg"  { "image/svg+xml" }
        ".png"  { "image/png" }
        ".ico"  { "image/x-icon" }
        default { "application/octet-stream" }
    }

    $bytes = [IO.File]::ReadAllBytes($filePath)
    $context.Response.ContentType = $mime
    $context.Response.ContentLength64 = $bytes.Length
    $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    $context.Response.Close()
}
