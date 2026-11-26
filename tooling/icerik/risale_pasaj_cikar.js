// 365 gunluk Risale-i Nur pasaji: asil eserlerden AYNEN paragraf (Latince + Osmanlica),
// eser ve bolum basligi fihristten. Kisaltma/sadelestirme yok.
// node risale_pasaj_cikar.js <cikti.json>
const fs = require('fs');
const API = 'https://risale.online/risale-api';
const ESERLER = process.env.ESERLER ? JSON.parse(process.env.ESERLER) : [[17, 'Sözler', 379], [13, 'Mektûbât', 515], [12, "Lem'alar", 419], [18, "Şuâ'lar", 628], [1, 'Asâ-yı Mûsâ', 318]];
const ADIM = 10;
const bekle = ms => new Promise(r => setTimeout(r, ms));
async function al(url) {
  for (let d = 0; d < 5; d++) {
    try {
      const r = await fetch(url, { headers: { 'User-Agent': 'icerik-dogrulama/1.0' } });
      if (!r.ok) throw new Error(r.status);
      return await r.json();
    } catch (e) { await bekle(2000 * (d + 1)); }
  }
  return null;
}
// Fihristi duz liste: [{sayfa, yol:'Yirmi Üçüncü Söz · Birinci Mebhas'}]
function duzle(dugum, ust = [], out = []) {
  for (const x of dugum || []) {
    const yol = [...ust, x.latince_baslik.trim()];
    out.push({ sayfa: x.sayfa, yol: yol.slice(0, 2).join(' · ') });
    duzle(x.alt_basliklar, yol, out);
  }
  return out;
}
const KAVRAM = /(îmân|kur’ân|hakîkat|ubûdiyet|ibâdet|şükür|şükr|sabır|sabr|kalb|rûh|saâdet|nûr|âhiret|dünya|mevt|ölüm|duâ|ihlâs|tevekkül|ma‘rifet|muhabbet|zikr|merhamet|şefkat|hayat|ecel|kabir|cennet|ömür|gaflet|nefs|namaz|acz|fakr|tefekkür|kâinât|esmâ|Allâh|Cenâb-ı Hak|hidâyet|haşir|ebed|bekā|fânî|lezzet|elem|insan)/gi;
const KOTU = /^(ve|fakat|lâkin|çünki|demek|evet|hem|işte|belki|madem|mâdem|meselâ|hattâ|yani|sonra|şimdi|bu|şu|o|onun|bunun|elhâsıl|hâsılı|amma|ama|eğer|ise|binaenaleyh|ondan|bundan|zîrâ|el-cevap|elcevap|sual|ikinci|üçüncü|dördüncü|beşinci|altıncı|yedinci|sekizinci|dokuzuncu|onuncu|birinci|aziz|sevgili|kardeşlerim|azîz)\b/i;
const YASAK = /[0-9«»]|hâşiye|kardeşim|kardeşler|said|üstad|üstâd|talebe|mektup|efendi|hüsrev|mahkeme|hapis|ceza|risâle-i nûr’un|nûr şâkird|şâkirdler/i;
function tokenlar(html) {
  const t = [];
  for (const m of html.matchAll(/<span class="kelime-grup ([^"]*)"([^>]*)>([^<]*)<\/span>/g)) {
    const lat = (m[2].match(/data-latince="([^"]*)"/) || [])[1];
    t.push({ sinif: m[1], osm: m[3], lat: lat ?? null });
  }
  return t;
}
function birlestir(tok, alan) {
  let s = '';
  for (const t of tok) {
    const noktalama = t.lat === null && /^[.,!?؟،:;]+$/.test(t.osm);
    const v = alan === 'osm' ? t.osm : (t.lat ?? t.osm.replace(/،/g, ',').replace(/؟/g, '?'));
    s += (noktalama || !s ? '' : ' ') + v;
  }
  return s.replace(/\s+/g, ' ').trim();
}
(async () => {
  const adaylar = [];
  for (const [id, ad, sayfa] of ESERLER) {
    const fih = await al(`${API}/fihrist?eserid=${id}`);
    const bolumler = duzle(Array.isArray(fih) ? fih : (fih && fih.data) || []).sort((a, b) => a.sayfa - b.sayfa);
    const bolum = s => { let b = ''; for (const x of bolumler) { if (x.sayfa <= s) b = x.yol; else break; } return b; };
    for (let p = 1; p <= sayfa; p += ADIM) {
      const j = await al(`${API}/paragraf?eserid=${id}&ilksayfa=${p}&sonsayfa=${Math.min(sayfa, p + ADIM - 1)}&yazi=osmanlica`) || [];
      for (const par of j) {
        const tok = tokenlar(par.osmanlica_html || '');
        if (!tok.length || tok.some(t => /Kirmizi|Arabi/.test(t.sinif))) continue;
        if (tok.some(t => t.lat === null && !/^[.,!?؟،:;]+$/.test(t.osm))) continue;
        const latin = birlestir(tok, 'lat');
        if (latin.length < 260 || latin.length > 720 || !/[.!]$/.test(latin)) continue;
        if (KOTU.test(latin) || YASAK.test(latin)) continue;
        const kavram = new Set((latin.match(KAVRAM) || []).map(x => x.toLowerCase())).size;
        if (kavram < 3) continue;
        adaylar.push({ eserId: id, eser: ad, sayfa: par.sayfa, bolum: bolum(par.sayfa), latin,
          osmanlica: birlestir(tok, 'osm'), puan: kavram });
      }
      process.stdout.write(`\r${ad} ${Math.min(sayfa, p + ADIM - 1)}/${sayfa} aday:${adaylar.length}   `);
      await bekle(400);
    }
  }
  fs.writeFileSync(process.argv[2], JSON.stringify(adaylar, null, 1));
  console.log('\naday', adaylar.length);
})();
