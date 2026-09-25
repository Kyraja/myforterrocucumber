const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const ts = require('typescript');

const repoRoot = path.resolve(__dirname, '..');
const sourceFile = path.join(repoRoot, 'src', 'i18n', 'translations.ts');
const outDir = path.join(repoRoot, 'src', 'resources', 'i18n');

function loadTranslations() {
  const source = fs.readFileSync(sourceFile, 'utf8');
  const transpiled = ts.transpileModule(source, {
    compilerOptions: {
      module: ts.ModuleKind.CommonJS,
      target: ts.ScriptTarget.ES2020,
    },
  }).outputText;

  const moduleRef = { exports: {} };
  const sandbox = {
    module: moduleRef,
    exports: moduleRef.exports,
    require,
    console,
  };
  vm.createContext(sandbox);
  vm.runInContext(transpiled, sandbox, { filename: sourceFile });
  return {
    translations: sandbox.module.exports.translations,
    extraTranslations: sandbox.module.exports.extraTranslations || {},
  };
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`, 'utf8');
}

function main() {
  const { translations, extraTranslations } = loadTranslations();
  if (!translations || typeof translations !== 'object') {
    throw new Error('Could not load translations object from src/i18n/translations.ts');
  }

  fs.mkdirSync(outDir, { recursive: true });

  const de = translations.de;
  const en = translations.en;
  const es = extraTranslations.es || en;
  const fr = extraTranslations.fr || en;

  if (!de || !en || !es || !fr) {
    throw new Error('Expected de/en/es/fr translations.');
  }

  writeJson(path.join(outDir, 'de.json'), de);
  writeJson(path.join(outDir, 'en.json'), en);
  writeJson(path.join(outDir, 'es.json'), es);
  writeJson(path.join(outDir, 'fr.json'), fr);

  const keyList = Object.keys(de).sort();
  writeJson(path.join(outDir, 'keys.json'), keyList);

  console.log(`Exported ${keyList.length} translation keys to ${outDir}`);
}

main();
