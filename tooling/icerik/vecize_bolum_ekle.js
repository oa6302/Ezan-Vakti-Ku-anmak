// gunluk_vecizeler.json kayitlarina risale.online fihristinden bolum basligi ekler (eser + sayfa -> bolum).
// node vecize_bolum_ekle.js <gunluk_vecizeler.json>
const fs = require('fs');
const API = 'https://risale.online/risale-api';
const ID = { 'Sözler': 17, 'Mektûbât': 13, "Lem'alar": 12, "Şuâ'lar": 18, 'Asâ-yı Mûsâ': 1, 'Mesnevî-i Nûriye': 14,
  "İşârâtü'l-İ'câz": 10, 'Muhâkemât': 22, 'Barla Lâhikası': 2, 'Kastamonu Lâhikası': 11 };
function duzle(d, ust = [], out = []) {
  for (const x of d || []) { const yol = [...ust, x.latince_baslik.trim()]; out.push({ sayfa: x.sayfa, yol: yol.slice(0, 2).join(' · ') }); duzle(x.alt_basliklar, yol, out); }
  return out;
}
(async () => {
  const p = process.argv[2]; const l = JSON.parse(fs.readFileSync(p, 'utf8'));
  const fih = {};
  for (const e of new Set(l.map(v => v.eser))) {
    const r = await fetch(`${API}/fihrist?eserid=${ID[e]}`, { headers: { 'User-Agent': 'icerik-dogrulama/1.0' } });
    const j = await r.json(); fih[e] = duzle(Array.isArray(j) ? j : j.data).sort((a, b) => a.sayfa - b.sayfa);
  }
  for (const v of l) { let b = ''; for (const x of fih[v.eser] || []) { if (x.sayfa <= v.sayfa) b = x.yol; else break; } v.bolum = b; }
  fs.writeFileSync(p, JSON.stringify(l, null, 1) + '\n');
  console.log(l.slice(0, 6).map(v => `${v.eser} · ${v.bolum} | ${v.latin.slice(0, 40)}`).join('\n'));
})();
