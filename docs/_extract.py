import pypdf, os
docs = r'd:\DEV\cucumbergenerator2\docs'
files = [f for f in os.listdir(docs) if f.lower().endswith('.pdf')]
out_dir = os.path.join(docs, 'extracted')
os.makedirs(out_dir, exist_ok=True)
for f in files:
    src = os.path.join(docs, f)
    out = os.path.join(out_dir, os.path.splitext(f)[0] + '.txt')
    if os.path.exists(out):
        print('Skip (exists):', out)
        continue
    try:
        r = pypdf.PdfReader(src)
        txt = []
        for i, page in enumerate(r.pages):
            txt.append(f'--- Page {i+1} ---\n' + (page.extract_text() or ''))
        with open(out, 'w', encoding='utf-8') as fp:
            fp.write('\n'.join(txt))
        print('Wrote', out, len('\n'.join(txt)), 'chars')
    except Exception as e:
        print('FAILED', f, '->', e)
