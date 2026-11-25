// Claude Code Stop: tur bitince degisen dosyalarda hizli kontrol. Hata varsa Claude durmaz, duzeltir.
const path = require('path');
const { spawnSync } = require('child_process');

let girdi = '';
process.stdin.on('data', (c) => (girdi += c));
process.stdin.on('end', () => {
  try { if (JSON.parse(girdi).stop_hook_active) return; } catch { /* bos girdi */ }
  const kok = path.resolve(__dirname, '..', '..', '..');
  const r = spawnSync('sh', ['android/hooks/proje_kontrol.sh'], { cwd: kok, encoding: 'utf8', timeout: 120000 });
  if (r.status === 1) {
    const ozet = String(r.stdout).split(/\r?\n/).filter((s) => /\[HATA\]/.test(s)).slice(0, 8).join('\n');
    process.stdout.write(JSON.stringify({ decision: 'block', reason: 'Kural karti ihlali (KURALLAR.md):\n' + ozet }));
  }
});
