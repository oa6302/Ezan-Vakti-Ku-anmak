// Claude Code PostToolUse (Edit|Write): yazilan dosyayi kural kartina gore kontrol eder.
// Hata -> decision:block (Claude duzeltir). Temiz -> tek satir "karta uygun mu?" sorusu.
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

let girdi = '';
process.stdin.on('data', (c) => (girdi += c));
process.stdin.on('end', () => {
  let f;
  try { f = JSON.parse(girdi).tool_input.file_path; } catch { return; }
  if (!f || !fs.existsSync(f)) return;
  const kok = path.resolve(__dirname, '..', '..', '..');
  const rel = path.relative(kok, f).replace(/\\/g, '/');
  if (rel.startsWith('..') || rel.startsWith('android/hooks/') || rel.startsWith('.claude/')) return;

  const sorun = [];
  const buf = fs.readFileSync(f);
  const metin = buf.toString('utf8');
  if (/(^|\/)(key\.properties|local\.properties|\.env(\..*)?|test_bilgileri\.json)$|\.(jks|keystore|pem)$/.test(rel)) return; // gizli dosyanin kendisi: icerik raporlanmaz
  if (/(storePassword|keyPassword)\s*=|AIza[0-9A-Za-z_-]{35}|ghp_[0-9A-Za-z]{36}|-----BEGIN [A-Z ]*PRIVATE KEY-----/.test(metin)) sorun.push('G1 gizli bilgi');
  if (/^(<<<<<<<|>>>>>>>)( |$)|^=======$/m.test(metin)) sorun.push('G6 catisma isareti');
  if (buf[0] === 0xef && buf[1] === 0xbb && buf[2] === 0xbf) sorun.push('U5 BOM');
  if (/\.(json|arb)$/.test(rel)) { try { JSON.parse(metin.replace(/^﻿/, '')); } catch (e) { sorun.push('U2 bozuk JSON: ' + e.message); } }

  if (/^(lib|test)\/.*\.dart$/.test(rel) && !rel.startsWith('lib/l10n/app_localizations')) {
    try {
      execSync(`dart analyze "${rel}"`, { cwd: kok, stdio: 'pipe', timeout: 60000 });
    } catch (e) {
      const satirlar = String(e.stdout || '').split(/\r?\n/).filter((s) => /^\s*(error|warning)/.test(s)).slice(0, 5).map((s) => s.trim());
      if (satirlar.length) sorun.push('U8 analyze: ' + satirlar.join(' | '));
    }
  }

  if (sorun.length) {
    process.stdout.write(JSON.stringify({ decision: 'block', reason: `${rel}: ${sorun.join('; ')} -> android/hooks/KURALLAR.md` }));
  } else {
    process.stdout.write(JSON.stringify({
      hookSpecificOutput: { hookEventName: 'PostToolUse',
        additionalContext: `KART ${rel}: otomatik kontrol temiz. Kurala uygun mu? (U3 metin arb'da, U8 mounted/deprecated, T1 test bilgisi dosyadan, G1 gizli yok)` },
    }));
  }
});
