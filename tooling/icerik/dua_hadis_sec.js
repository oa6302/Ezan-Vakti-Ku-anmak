// 365 gunluk dua: Kur'an dualari (dua_hazinesi.json, kuran) + hadislerdeki dualar.
// Hadis dualari: Turkce metindeki tirnak icindeki dua cumlesi AYNEN alinir (meal);
// Arapca yok (yalniz meal). OCR bozuk metin ve sahih/hasen olmayanlar elenir.
// node dua_hadis_sec.js <hadis_dizini> <dua_hazinesi.json> <cikti.json>
const fs = require('fs'), path = require('path');
const [dizin, hazineYol, cikti] = process.argv.slice(2);
const KITAP = [
  ['tur-muslim', 'Müslim', null], ['tur-tirmidhi', 'Tirmizî', 'derece'],
  ['tur-abudawud', 'Ebû Dâvûd', 'derece'], ['tur-bukhari', 'Buhârî', null],
];
const BOZUK = /[a-zçğıöşü][!][a-zçğıöşü]|[a-zçğıöşü]I[a-zçğıöşü]|[a-zçğöşü]{2}ğz|\s[a-z]\s[a-z]\s|Fethu'l-Bari|Açıklaması/;
const BASLA = /(Ey Allah['’]ım|Allah['’]ım|Allahım|Allahümme)[!,]/;
// Anlati, kisiye ozel veya bozuk dua metni
const RED = /[«»<>¬()\[\]]|\s(dedi|derdi|diye|demiş|dediler|soracak|cevap|buyurdu|dedim)\b|bunların|bunlara|bu ikisin|onun için|onlara|onu |o'nu|kavmim|falan|ümmetim|şunları|bana yardım et!$/i;
// Dua fiili (yakaris) zorunlu
const YAKARIS = /(sığınırım|bağışla|affet|isterim|dilerim|ihsan|nasip|koru|hidayet|merhamet|kıl|eyle|ver|yardım et|mağfiret|razı|sabit)/i;
// Ozel ad (kisiye/olaya ozel dua) reddi: buyuk harfli kelimeler bu listede olmali
const IZINLI = /^(Allah|Allahım|Allah’ım|Allah'ım|Allahümme|Ey|Rabbim|Rabbimiz|Sen|Senin|Sana|Senden|Seni|Sensin|Cennet|Cehennem|Deccal|Deccâl|Mesih|Kur|İslam|İslâm|Muhammed|Kabir|Arş|Rahman|Rahîm|Rahim|Gafur|Kerim|Hayy|Kayyum|İlahım|İlah|O|Ben|Beni|Bana|Benim|Bizi|Bize|Biz|Hak|Kitab|Nebi|Peygamber|Resul)$/;
const ozelAdVar = d => d.split(/\s+/).slice(1).some(w => {
  const k = w.replace(/^[^A-Za-zÇĞİÖŞÜçğıöşüÂâÎîÛû]+|[^A-Za-zÇĞİÖŞÜçğıöşüÂâÎîÛû’']+$/g, '').split(/['’]/)[0];
  return /^[A-ZÇĞİÖŞÜÂÎÛ]/.test(k) && !IZINLI.test(k) && !/[.!?]$/.test('');
});
const uygunDerece = g => (g || []).some(x => /^(sahih|hasan)/i.test(x.grade || ''));
function duaCikar(t) {
  const m = BASLA.exec(t); if (!m) return null;
  const once = t.slice(0, m.index);
  let ac = Math.max(once.lastIndexOf('"'), once.lastIndexOf('“'));
  const ikiNokta = /[:-–]s*$/.test(once);
  if (ac < 0 && !ikiNokta) return null;
  if (ac < 0) ac = m.index;
  let son = t.slice(m.index).search(/["”]/);
  // Tirnaksiz (iki noktali) anlatimda dua, "dedi/derdi/diye" ile biter
  if (son < 0 && ikiNokta) son = t.slice(m.index).search(/s(diye|dedi|derdi|derlerdi|buyurdu)/);
  if (son < 0) return null;
  const dua = t.slice(m.index, m.index + son).trim().replace(/\s+/g, ' ');
  return { dua, baglam: t.slice(Math.max(0, ac - 160), ac) };
}
const BASLIK = [
  [/yat(ağ|ar|ma|tı|tığ|acağ)|uyu(du|ma|rken|yaca)|uyan|gece kalk/i, 'Yatarken ve Uyanırken Dua'], [/sabah/i, 'Sabah Duası'], [/akşam/i, 'Akşam Duası'],
  [/yolculu|sefer|bin(dı|ince|eğ)/i, 'Yolculuk Duası'], [/hasta|şifa|ağrı/i, 'Şifa Duası'],
  [/borç/i, 'Borçtan Kurtulma Duası'], [/keder|üzüntü|gam|sıkıntı|tasa/i, 'Sıkıntı Anında Dua'],
  [/istihâre|istihare/i, 'İstihâre Duası'], [/cenaze|ölü|kabr/i, 'Vefat Edenler İçin Dua'],
  [/yağmur|rüzgâr|rüzgar|bulut/i, 'Yağmur ve Rüzgâr Duası'], [/yemek ye|yemeğ|sofra|yediği|içtiği/i, 'Yemek Duası'],
  [/evinden çık|evden çık|evine gir|mescide gir|mescidden çık/i, 'Giriş ve Çıkış Duası'],
  [/namaz|secde|rükû|teşehhüd|selam ver|tekbir/i, 'Namazda Okunan Dua'],
];
const ICERIK = [
  [/bağışla|mağfiret|günah|af et|affet/i, 'Bağışlanma Duası'], [/sığın/i, 'Sığınma Duası'],
  [/hidayet|doğru yol|takva|iffet/i, 'Hidayet ve Takvâ Duası'], [/ilim|bilmediğim|faydalı/i, 'Faydalı İlim Duası'],
  [/kalb|kalp/i, 'Kalbin Sebatı İçin Dua'], [/rızık|zenginlik|bereket/i, 'Rızık ve Bereket Duası'],
  [/cennet|cehennem|ateş|kabir/i, 'Ahiret Duası'], [/hamd|şükür|şükr|övgü/i, 'Hamd ve Şükür Duası'],
  [/rahmet|merhamet/i, 'Rahmet Duası'], [/afiyet|âfiyet|sıhhat/i, 'Âfiyet Duası'],
];
const baslik = (dua, baglam) => (BASLIK.find(([r]) => r.test(baglam)) || ICERIK.find(([r]) => r.test(dua)) || [0, 'Peygamberimizin Duası'])[1];
const kategori = b => b.replace(/ (Duası|İçin Dua|Anında Dua|Okunan Dua|Dua)$/, '').replace(/^Namazda$/, 'Namaz');

// Elle incelendi: kisiye, kabileye, yere veya olaya ozel dualar (genel gunluk dua degil)
const ELENEN = new Set(['Tirmizî, 3762', 'Tirmizî, 3856', 'Tirmizî, 3902', 'Tirmizî, 3909', 'Tirmizî, 3914',
  'Tirmizî, 3922', 'Tirmizî, 3934', 'Ebû Dâvûd, 453', 'Ebû Dâvûd, 1551', 'Buhârî, 428', 'Buhârî, 1037',
  'Buhârî, 2877', 'Buhârî, 2937', 'Buhârî, 3034', 'Buhârî, 6334', 'Buhârî, 6335', 'Buhârî, 6378',
  'Buhârî, 7094', 'Buhârî, 7333']);
const hadisDualari = []; const tekil = new Set();
for (const [ed, ad, derece] of KITAP) {
  const f = path.join(dizin, ed + '.json'); if (!fs.existsSync(f)) continue;
  for (const h of require(path.resolve(f)).hadiths) {
    const t = (h.text || '').replace(/\s+/g, ' ');
    if (!t || BOZUK.test(t)) continue;
    if (derece && !uygunDerece(h.grades)) continue;
    const c = duaCikar(t); if (!c) continue;
    if (c.dua.length < 40 || c.dua.length > 520 || BOZUK.test(c.dua) || RED.test(c.dua) || !YAKARIS.test(c.dua)) continue;
    const k = c.dua.toLocaleLowerCase('tr').replace(/[^a-zçğıöşü]/g, '').slice(0, 60);
    if (tekil.has(k)) continue; tekil.add(k);
    const kaynak = `${ad}, ${ed === 'tur-muslim' ? Math.floor(h.arabicnumber) : h.hadithnumber}`;
    if (ELENEN.has(kaynak)) continue;
    const b = baslik(c.dua, c.baglam);
    const sihhat = derece ? (h.grades.find(x => /^(sahih|hasan)/i.test(x.grade)).grade + ' (' + h.grades.find(x => /^(sahih|hasan)/i.test(x.grade)).name + ')') : `Sahih (${ad})`;
    hadisDualari.push({ baslik: b, kategori: kategori(b), anlam: c.dua, kaynak: `${ad}, ${ed === 'tur-muslim' ? Math.floor(h.arabicnumber) : h.hadithnumber}`, sihhat,
      metinKaynagi: `fawazahmed0/hadith-api (${ed})` });
  }
}
const kuran = JSON.parse(fs.readFileSync(hazineYol, 'utf8')).filter(d => d.koleksiyon === 'kuran')
  .map(d => ({ baslik: d.baslik, kategori: "Kur'an Duası", arapca: d.arapca, okunus: d.okunus, anlam: d.anlam,
    kaynak: d.kaynak, sihhat: "Kur'an-ı Kerîm", metinKaynagi: 'api.quran.com · Diyanet meali', hazineId: d.id }));
// Karisik dagitim: her 5 gunden biri Kur'an duasi
const sonuc = []; let ki = 0, hi = 0;
while (sonuc.length < 365 && (ki < kuran.length || hi < hadisDualari.length)) {
  if ((sonuc.length % 5 === 0 && ki < kuran.length) || hi >= hadisDualari.length) sonuc.push(kuran[ki++]);
  else sonuc.push(hadisDualari[hi++]);
}
fs.writeFileSync(cikti, JSON.stringify(sonuc.map((d, i) => ({ gun: i + 1, ...d })), null, 1) + '\n');
const say = {}; for (const d of hadisDualari) say[d.kaynak.split(',')[0]] = (say[d.kaynak.split(',')[0]] || 0) + 1;
console.log('kuran', kuran.length, 'hadis', hadisDualari.length, JSON.stringify(say), '-> gun', sonuc.length);
