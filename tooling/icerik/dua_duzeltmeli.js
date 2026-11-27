// Ceviride bariz yazim hatasi olan sahih dualar: bas..son AYNEN kesilir, yalniz listelenen harf hatalari duzeltilir ve kayda "duzeltme" notu yazilir.
// node dua_eski_yerine.js <hadis_dizini> <gunluk_dualar.json> <cikti.json>
// [edisyon:hadithnumber, bas, son, baslik, kategori, buyukHarf]
const fs = require('fs');
const [dizin, mevcutYol, cikti] = process.argv.slice(2);
const G = require('path').resolve(dizin) + '/';
const AD = { 'tur-bukhari': 'Buhârî', 'tur-muslim': 'Müslim', 'tur-tirmidhi': 'Tirmizî', 'tur-abudawud': 'Ebû Dâvûd', 'tur-nasai': 'Nesâî', 'tur-ibnmajah': 'İbn Mâce' };
const S = [
  ['tur-abudawud:978', "Ey Allah'ım! İbrahim'i", 'şerifli ve ulusun.', 'Salavât-ı İbrâhîmiyye', 'Salavat', 0, [['haınd edilensin', 'hamd edilensin'], ['şerifli', 'şerefli']]],
  ['tur-abudawud:3201', "Allah'ım, dirimizi", 'sonra bizi sapıttırma', 'Cenaze Namazı Duası', 'Cenaze', 0, [['on(un vefatımdan', 'onun (vefatından)']]],
  ['tur-bukhari:2397', "Allah'ıml Günahtan", 'sana sığınırım', 'Günah ve Borçtan Sığınma', 'Sığınma', 0, [["Allah'ıml Günahtan", "Allah'ım! Günahtan"]]],
  ['tur-muslim:476', "Allah'ım sana göklerle", 'temiz pak eyle.', 'Rükûdan Sonra Hamd ve Arınma', 'Namaz', 0, [['temizlet Yârabbl', 'temizle! Yârabbi!']]],
  ['tur-muslim:2697', 'Allahım ! Beni affet', 'beni nzıklandır!', 'Af, Rahmet, Hidayet ve Rızık Duası', 'Rızık', 0, [['nzıklandır', 'rızıklandır'], ['Allahım !', 'Allahım!']]],
  ['tur-muslim:2720', 'Allahım! Bana işimin', 'şerden rahat kıl!', 'Din, Dünya ve Âhiretin Islahı Duası', 'Hidayet', 0, [['Mercüm', 'Merciim']]],
  ['tur-ibnmajah:898', 'Rabbim! Beni bağışla', '(m derecelerimi) yükselt.', 'İki Secde Arasında Dua', 'Namaz', 0, [['(m kırıklarımı)', '(kırıklarımı)'], ['(m derecelerimi)', '(derecelerimi)']]],
  ['tur-ibnmajah:3837', 'Allahım dört şeyden', "dua'dan.", 'Dört Şeyden Sığınma', 'Sığınma', 0, [['duynayan', 'duymayan']]],
  ['tur-ibnmajah:3851', 'Allahın! Ben', 'afiyet dilerim', 'Dünya ve Âhirette Âfiyet Duası', 'Âfiyet', 0, [['Allahın!', 'Allahım!']]],
  ['tur-abudawud:2770', "Allah'dan başka hakiki", 'hezimete uğratmıştır.', 'Yolculuktan Dönüş Duası', 'Yolculuk', 0, [['hamdedenle-riz', 'hamdedenleriz']]],
];
const cache = {}; const out = []; const hata = [];
const mevcut = JSON.parse(fs.readFileSync(mevcutYol, 'utf8'));
const mk = new Set(mevcut.map(d => d.anlam));
for (const [ref, bas, son, baslik, kategori, buyuk, duzelt] of S) {
  const [ed, noRaw] = ref.split(':'); const [no, hn] = noRaw.split('#');
  cache[ed] = cache[ed] || require(G + ed + '.json');
  const h = ed === 'tur-muslim'
    ? cache[ed].hadiths.find(x => hn ? String(x.hadithnumber) === hn : Math.floor(x.arabicnumber) === +no && x.text && x.text.includes(bas))
    : cache[ed].hadiths.find(x => String(x.hadithnumber) === no);
  const t = (h && h.text || '').replace(/\s+/g, ' ');
  const i = t.indexOf(bas), j = i < 0 ? -1 : t.indexOf(son, i);
  if (i < 0 || j < 0) { hata.push(ref + ' ' + bas); continue; }
  let anlam = t.slice(i, j + son.length).trim();
  if (buyuk) anlam = anlam[0].toLocaleUpperCase('tr') + anlam.slice(1);
  for (const [y, d] of duzelt || []) { if (!anlam.includes(y)) { hata.push(ref + ' duzeltme yok ' + y); } anlam = anlam.split(y).join(d); }
  const g = (h.grades || []).find(x => /^(sahih|hasan)/i.test(x.grade));
  if (!['tur-bukhari', 'tur-muslim'].includes(ed) && !g) { hata.push(ref + ' derece yok'); continue; }
  if (mk.has(anlam)) { hata.push(ref + ' mevcut'); continue; }
  const kaynakNo = ed === 'tur-muslim' ? Math.floor(h.arabicnumber) : h.hadithnumber;
  out.push({ baslik, kategori, anlam, kaynak: `${AD[ed]}, ${kaynakNo}`, sihhat: g ? `${g.grade} (${g.name})` : `Sahih (${AD[ed]})`,
    metinKaynagi: `fawazahmed0/hadith-api (${ed})`,
    ...(duzelt ? { duzeltme: 'Çeviri metnindeki yazım hatası düzeltildi: ' + duzelt.map(([y, d]) => `${y} → ${d}`).join('; ') } : {}) });
}
fs.writeFileSync(cikti, JSON.stringify(out, null, 1));
console.log('eklendi', out.length, 'hata', hata);
for (const d of out) console.log(`- ${d.kaynak} | ${d.baslik} | ${d.anlam}`);
