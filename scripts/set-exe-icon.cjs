// Stamps the Windows icon + version metadata onto the nexe-built .exe.
//
// Why a post-build step: nexe applies its --ico / --rc-* options only when it
// COMPILES Node from source. We use nexe's prebuilt base binary (no build
// toolchain required), which already carries nexe's default icon, so we set our
// own icon afterwards with `resedit`.
//
// Why this is safe (unlike with pkg): nexe locates its embedded bundle relative
// to the end of the file, so resedit growing the resource section does not break
// it. (pkg uses an absolute offset and DOES break — that was the earlier crash.)
//
// The icon is a fixed, committed file: build-assets/app.ico. To change the app
// icon, just replace that one file. No image conversion happens at build time.
const path = require('path');
const fs = require('fs');
const { execFileSync } = require('child_process');

const root = path.resolve(__dirname, '..');
const pkgJson = require(path.join(root, 'package.json'));

const icoPath = path.join(root, 'build-assets', 'app.ico');
const exePath = process.argv[2]
  ? path.resolve(process.argv[2])
  : path.join(root, 'build', 'cucumbergenerator.exe');
const tmpPath = exePath + '.tmp';

// resedit-cli restricts its `exports`, so reference the bin path directly.
const reseditCli = path.join(root, 'node_modules', 'resedit-cli', 'dist', 'cli.js');

// package.json version (e.g. "0.0.0") -> Windows 4-part "0.0.0.0"
const fileVersion = (pkgJson.version || '0.0.0')
  .split('-')[0]
  .split('.')
  .concat(['0', '0', '0', '0'])
  .slice(0, 4)
  .join('.');

if (!fs.existsSync(exePath)) {
  console.error(`[set-exe-icon] exe not found: ${exePath} — run the nexe build first.`);
  process.exit(1);
}
if (!fs.existsSync(icoPath)) {
  console.error(`[set-exe-icon] icon not found: ${icoPath}`);
  process.exit(1);
}

try {
  execFileSync(
    process.execPath,
    [
      reseditCli,
      '--in', exePath,
      '--out', tmpPath,
      '--icon', `1,${icoPath}`,
      '--product-name', 'abas Testgenerator',
      '--file-description', 'abas Testgenerator',
      '--company-name', 'Forterro',
      '--file-version', fileVersion,
      '--product-version', fileVersion,
    ],
    { stdio: 'inherit' },
  );
  fs.renameSync(tmpPath, exePath);
  console.log(`[set-exe-icon] icon + metadata applied to ${exePath}`);
} catch (err) {
  if (fs.existsSync(tmpPath)) {
    try { fs.unlinkSync(tmpPath); } catch { /* ignore */ }
  }
  console.error('[set-exe-icon] failed:', err.message || err);
  process.exit(1);
}
