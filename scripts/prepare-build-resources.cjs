const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const outDir = path.join(root, 'build');
const legacyResourcesDir = path.join(root, 'build', 'resources');
const managedFiles = [
  'settings.json',
  'cucumbergnerator-settings.example.json',
  'default-learnings.json',
  'README-settings.txt',
];

function ensureDir(dirPath) {
  fs.mkdirSync(dirPath, { recursive: true });
}

function writeText(destRel, content) {
  const dest = path.join(outDir, destRel);
  ensureDir(path.dirname(dest));
  fs.writeFileSync(dest, content, 'utf8');
  console.log(`[prepare-build-resources] wrote: build/${destRel}`);
}

function copyFile(srcRel, destName) {
  const src = path.join(root, srcRel);
  const dest = path.join(outDir, destName);
  if (!fs.existsSync(src)) {
    console.warn(`[prepare-build-resources] missing: ${srcRel}`);
    return false;
  }
  fs.copyFileSync(src, dest);
  console.log(`[prepare-build-resources] copied: ${srcRel} -> build/${destName}`);
  return true;
}

function main() {
  // Cleanup old layout from previous versions.
  fs.rmSync(legacyResourcesDir, { recursive: true, force: true });

  // Do not delete the whole build dir to avoid removing cucumbergenerator.exe.
  for (const name of managedFiles) {
    fs.rmSync(path.join(outDir, name), { recursive: true, force: true });
  }

  ensureDir(outDir);

  // Flat package for direct "shared settings folder" selection in the app.
  // Keep only settings-related starter files here (no subfolders, no i18n).
  const copied = [
    copyFile('src/resources/settings/recommended-settings.json', 'user-settings.json'),
    copyFile('src/resources/settings/default-settings.json', 'default-settings.json'),
    copyFile('src/resources/learning/default-learnings.json', 'default-learnings.json'),
  ].filter(Boolean).length;

  writeText(
    'README-settings.txt',
    [
      'cucumbergnerator build resources',
      '',
      'These files are intended to live directly in build/ and can be used as shared settings folder content.',
      '',
      'Included files (flat in build/):',
      '- user-settings.json: initial settings for your shared settings folder',
      '- default-settings.json: app code defaults (edit + rebuild to change fallback values)',
      '- default-learnings.json: starter learning seed data',
      '',
      'i18n note:',
      '- language JSON files are bundled into the app build (.exe via dist) and are not needed here.',
      '',
    ].join('\n'),
  );

  console.log(`[prepare-build-resources] done. Files copied: ${copied}`);
}

main();
