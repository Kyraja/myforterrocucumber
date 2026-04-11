// ============================================================
// Production server — serves dist/ and proxies API calls.
// CommonJS format for compatibility with @yao-pkg/pkg.
//
// Usage (standalone):  node server.cjs
// Usage (as exe):      cucumbergnerator.exe
// ============================================================

'use strict';

const http = require('node:http');
const https = require('node:https');
const fs = require('node:fs');
const path = require('node:path');
const { exec } = require('node:child_process');

const PORT = parseInt(process.env.PORT || '5173', 10);
const DIST = path.join(__dirname, 'dist');

// ── Proxy routes (same as vite.config.ts server.proxy) ──────

const PROXIES = {
  '/mft-auth': 'https://integration-myforterro-core.fcs-dev.eks.forterro.com',
  '/mft-api': 'https://integration-myforterro-api.fcs-dev.eks.forterro.com',
};

// ── MIME types for static files ─────────────────────────────

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
};

// ── Server ──────────────────────────────────────────────────

const server = http.createServer((req, res) => {
  const url = req.url || '/';

  // Check proxy routes
  for (const [prefix, target] of Object.entries(PROXIES)) {
    if (url.startsWith(prefix)) {
      return proxyRequest(req, res, prefix, target);
    }
  }

  // Serve static files from dist/
  serveStatic(req, res, url);
});

server.listen(PORT, () => {
  const url = `http://localhost:${PORT}/`;
  console.log(`\n  cucumbergnerator laeuft auf ${url}\n`);
  console.log('  Dieses Fenster offen lassen, solange die App laeuft.');
  console.log('  Zum Beenden: Ctrl+C oder Fenster schliessen.\n');

  // Auto-open browser
  const cmd =
    process.platform === 'win32' ? `start "" "${url}"` :
    process.platform === 'darwin' ? `open "${url}"` :
    `xdg-open "${url}"`;
  exec(cmd);
});

// ── Proxy handler ───────────────────────────────────────────

function proxyRequest(req, res, prefix, target) {
  const targetPath = req.url.slice(prefix.length) || '/';
  const targetUrl = new URL(targetPath, target);

  // Forward headers, but override host
  const headers = { ...req.headers, host: targetUrl.host };
  delete headers['connection'];

  const proxyReq = https.request(
    targetUrl,
    { method: req.method, headers },
    (proxyRes) => {
      // Strip www-authenticate so the browser doesn't show native auth dialog
      const responseHeaders = { ...proxyRes.headers };
      delete responseHeaders['www-authenticate'];

      res.writeHead(proxyRes.statusCode, responseHeaders);
      proxyRes.pipe(res);
    },
  );

  proxyReq.on('error', (err) => {
    res.writeHead(502, { 'Content-Type': 'text/plain' });
    res.end('Proxy error: ' + err.message);
  });

  req.pipe(proxyReq);
}

// ── Static file handler ─────────────────────────────────────

function serveStatic(_req, res, url) {
  // Strip query string
  const pathname = url.split('?')[0];

  let filePath = path.join(DIST, pathname === '/' ? 'index.html' : pathname);

  // SPA fallback: if file doesn't exist, serve index.html
  if (!fs.existsSync(filePath)) {
    filePath = path.join(DIST, 'index.html');
  }

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('Not found');
      return;
    }

    const ext = path.extname(filePath);
    const contentType = MIME[ext] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': contentType });
    res.end(data);
  });
}
