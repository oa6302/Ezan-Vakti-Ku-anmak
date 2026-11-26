// risale.online asil eserlerinden vecize adayi cumleleri cikarir.
// Osmanlica kelimeler ve Latince karsiliklari ayni span'dan (data-latince) alinir:
// iki metin birebir ayni cumledir, sadelestirme/tercume yoktur.
// node vecize_cikar.js <cikti_adaylar.json>
const fs = require('fs');
const API = 'https://risale.online/risale-api';
const ESERLER = process.env.ESERLER ? JSON.parse(process.env.ESERLER) : [[17, 'Sözler', 379], [13, 'Mektûbât', 515], [12, "Lem'alar", 419],
  [18, "Şuâ'lar", 628], [1, 'Asâ-yı Mûsâ', 318]];
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
  return [];
}
const BAGLAC = /^(ve|fakat|lâkin|lakin|çünkü|demek|evet|hem|işte|belki|madem|meselâ|mesela|hattâ|hatta|yani|ya|veya|sonra|şimdi|bu|şu|o|onun|bunun|şunun|bunlar|onlar|ey|elhâsıl|hâsılı|amma|eğer|ise|ki|nasıl|gibi|binaenaleyh|öyle|böyle|aynen|kezâlik|ondan|bundan|birinci|ikinci|üçüncü|dördüncü|beşinci|altıncı|yedinci|sekizinci|dokuzuncu|onuncu)$/i;
const YASAK = /[0-9()\[\]«»“”"]|hâşiye|sual|elcevap|risâle|mektup|kardeş|said|söz’|lem‘a|şuâ|aziz|sıddık|efendi|hüsrev|talebe|nur’un|nûr’un|sen |siz /i;
const YUKLEM = /(dır|dir|dur|dür|tır|tir|tur|tür|dar|der|lar|ler|maz|mez|ır|ir|ur|ür|ar|er)[.!]$/i;
function cumleler(html) {
  const tok = [];
  for (const m of html.matchAll(/<span class="kelime-grup ([^"]*)"([^>]*)>([^<]*)<\/span>/g)) {
    const lat = (m[2].match(/data-latince="([^"]*)"/) || [])[1];
    tok.push({ sinif: m[1], osm: m[3], lat: lat ?? null });
  }
  const out = []; let cur = [];
  for (const t of tok) {
    cur.push(t);
    if (t.lat === null && /^[.!?؟:]+$/.test(t.osm)) { out.push(cur); cur = []; }
  }
  return out;
}
function birlestir(c, alan) {
  let s = '';
  for (const t of c) {
    const noktalama = t.lat === null && /^[.,!?؟،:;]+$/.test(t.osm);
    const v = alan === 'osm' ? t.osm : (t.lat ?? t.osm.replace('،', ',').replace('؟', '?'));
    s += (noktalama || !s ? '' : ' ') + v;
  }
  return s.trim();
}
(async () => {
  const adaylar = []; const gorulen = new Set();
  for (const [id, ad, sayfa] of ESERLER) {
    for (let p = 1; p <= sayfa; p += ADIM) {
      const j = await al(`${API}/paragraf?eserid=${id}&ilksayfa=${p}&sonsayfa=${Math.min(sayfa, p + ADIM - 1)}&yazi=osmanlica`);
      for (const par of j || []) {
        for (const c of cumleler(par.osmanlica_html || '')) {
          if (c.some(t => /Kirmizi|Arabi/.test(t.sinif))) continue; // baslik, ayet/hadis ibaresi
          if (c.some(t => t.lat === null && !/^[.,!?؟،:;]+$/.test(t.osm))) continue;
          const kelime = c.filter(t => t.lat).length;
          if (kelime < 5 || kelime > 18) continue;
          const latin = birlestir(c, 'lat'), osmanlica = birlestir(c, 'osm');
          if (latin.length < 30 || latin.length > 150 || YASAK.test(latin)) continue;
          if (BAGLAC.test(latin.split(/[\s,]+/)[0])) continue;
          if (!YUKLEM.test(latin)) continue;
          const k = latin.toLocaleLowerCase('tr').replace(/[^a-zçğıöşüâîû]/g, '');
          if (gorulen.has(k)) continue; gorulen.add(k);
          adaylar.push({ eserId: id, eser: ad, sayfa: par.sayfa, latin: latin[0].toLocaleUpperCase('tr') + latin.slice(1), osmanlica, kelime });
        }
      }
      process.stdout.write(`\r${ad} ${Math.min(sayfa, p + ADIM - 1)}/${sayfa}  aday:${adaylar.length}   `);
      await bekle(400);
    }
  }
  fs.writeFileSync(process.argv[2], JSON.stringify(adaylar, null, 1));
  console.log('\naday', adaylar.length);
})();
