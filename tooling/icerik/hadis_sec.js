// 365 gunluk hadis: Nevevi 42 + Buhari secili bolumler. Metin ve numara kaynaktan.
// node hadis_sec.js <cikti.json>
const fs = require('fs');
const tb = require('./tur-bukhari.json'), ab = require('./ara-bukhari.json');
const tn = require('./tur-nawawi.json'), an = require('./ara-nawawi.json');
const arapB = new Map(ab.hadiths.map(h => [h.hadithnumber, h.text]));
const arapN = new Map(an.hadiths.map(h => [h.hadithnumber, h.text]));

// Buhari bolumleri: kitap no -> [Turkce kitap adi, tema, hedef sayi]
const BOLUM = {
  78: ['Edeb', 'Ahlak ve Adab', 84], 81: ['Rikâk', 'Kalbi Yumuşatan Hadisler', 57],
  80: ['Daavât', 'Dua ve Zikir', 20], 3: ['İlim', 'İlim', 28], 2: ['Îmân', 'İman', 18],
  24: ['Zekât', 'Zekât ve İnfak', 30], 30: ['Savm', 'Oruç', 25], 8: ['Salât', 'Namaz', 30],
  23: ['Cenâiz', 'Ölüm ve Ahiret', 15], 61: ['Menâkıb', 'Peygamberimiz', 16],
  62: ['Fezâilü Ashâbi\'n-Nebî', 'Sahabe', 14], 82: ['Kader', 'Kader ve Tevekkül', 8],
};
// Gunluk kartta baglamsiz okunmaya uygun olmayan konular (fikhi ayrintilar)
const ELE = /(hayız|cünüp|cenabet|zina|recm|kırbaç|cariye|köle|domuz|idrar|dışkı|boşa|nikâh|cima|şarap|içki|öldürd|kafir|müşrik)/i;
const uygun = t => t && t.length >= 80 && t.length <= 480 && /[\"“]/.test(t) &&
  /(buyurdu|buyururken|dedi|söyledi|şöyle)/.test(t) && !ELE.test(t) &&
  (t.match(/rivayet ett/g) || []).length <= 1;

const kayit = [];
// Nevevi Kirk Hadis (hepsi)
for (const h of tn.hadiths) {
  if (!h.text || !h.text.trim()) continue;
  const ar = arapN.get(h.hadithnumber) || '';
  kayit.push({ tema: 'Kırk Hadis', metin: h.text.trim(), arapca: ar.length <= 1200 ? ar : '',
    kaynak: `Nevevî, Kırk Hadis, ${h.hadithnumber}`, numara: `Nevevî ${h.hadithnumber}`,
    sihhat: 'Nevevî\'nin seçtiği hadisler (asıl kaynakları metnin sonunda belirtilir)' });
}
const tekil = new Set();
const anahtar = t => t.replace(/[^a-zçğıöşü]/gi, '').toLowerCase().slice(20, 90);
const kuyruk = {};
for (const h of tb.hadiths) {
  const b = BOLUM[h.reference && h.reference.book];
  if (!b || !uygun(h.text)) continue;
  const a = anahtar(h.text); if (tekil.has(a)) continue; tekil.add(a);
  (kuyruk[b[1]] ??= []).push({ tema: b[1], metin: h.text.trim(),
    arapca: (arapB.get(h.hadithnumber) || '').length <= 900 ? arapB.get(h.hadithnumber) : '',
    kaynak: `Buhârî, ${b[0]}`, numara: `Buhârî ${h.hadithnumber}`, sihhat: 'Sahih (Buhârî)' });
}
for (const b of Object.values(BOLUM)) kuyruk[b[1]] = (kuyruk[b[1]] || []).slice(0, b[2]);
// Round-robin dagitim (Kirk Hadis her 9 gunde bir)
const temalar = Object.keys(kuyruk); const nev = [...kayit]; const sonuc = [];
let ti = 0;
while (sonuc.length < 365 && (nev.length || temalar.some(t => kuyruk[t].length))) {
  if (sonuc.length % 9 === 0 && nev.length) { sonuc.push(nev.shift()); continue; }
  for (let d = 0; d < temalar.length; d++) {
    const t = temalar[(ti++) % temalar.length];
    if (kuyruk[t].length) { sonuc.push(kuyruk[t].shift()); break; }
  }
  if (!temalar.some(t => kuyruk[t].length) && nev.length) sonuc.push(nev.shift());
}
const cikti = sonuc.slice(0, 365).map((h, i) => ({ gun: i + 1, ...h,
  metinKaynagi: 'fawazahmed0/hadith-api (Türkçe ve Arapça baskılar)' }));
fs.writeFileSync(process.argv[2], JSON.stringify(cikti, null, 1) + '\n');
const sayim = {}; for (const h of cikti) sayim[h.tema] = (sayim[h.tema] || 0) + 1;
console.log('secilen', cikti.length, JSON.stringify(sayim));
