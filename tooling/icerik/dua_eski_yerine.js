// Eski dua_havuzu*.dart yerine: hadis metninden bas..son arasi AYNEN kesilen dualar.
// node dua_eski_yerine.js <hadis_dizini> <gunluk_dualar.json> <cikti.json>
// [edisyon:hadithnumber, bas, son, baslik, kategori, buyukHarf]
const fs = require('fs');
const [dizin, mevcutYol, cikti] = process.argv.slice(2);
const G = require('path').resolve(dizin) + '/';
const AD = { 'tur-bukhari': 'Buhârî', 'tur-muslim': 'Müslim', 'tur-tirmidhi': 'Tirmizî', 'tur-abudawud': 'Ebû Dâvûd', 'tur-nasai': 'Nesâî', 'tur-ibnmajah': 'İbn Mâce' };
const S = [
  ['tur-bukhari:6346', 'Azim ve halim', "Göklerin, yerin ve yüce arşın rabbi olan Allah'tan başka ilah yoktur", 'Sıkıntı Anında Dua', 'Sıkıntı'],
  ['tur-bukhari:6316', 'Allahım! Kalbime', 'bana nur bahşet!', 'Nur Duası', 'Hidayet'],
  ['tur-bukhari:6312', 'Bizi öldürdükten sonra', "Allah'a hamdolsun", 'Uyanınca Okunan Dua', 'Uyku'],
  ['tur-bukhari:614', 'Bu tam çağrının', 'eriştir.', 'Ezandan Sonra Dua', 'Namaz'],
  ['tur-bukhari:1032', "Allah'ım, faydalı", 'olsun!', 'Yağmur Yağarken Dua', 'Yağmur'],
  ['tur-muslim:471', 'Allâhım! Ey Rabbimiz!', 'fayda verecek değildir.', 'Rükûdan Doğrulurken Dua', 'Namaz'],
  ['tur-muslim:483', "Allah'ım günahımın", 'bana bağışla', 'Secdede Bağışlanma Duası', 'Namaz'],
  ['tur-muslim:484', "Allah'ım, seni tesbîh", 'mağfiret eyle!', 'Rükû ve Secdede Dua', 'Namaz'],
  ['tur-muslim:770', "Allah'ım! Ey Cebrail", 'hidâyet eylersin!', 'Gece Namazına Başlarken Dua', 'Namaz'],
  ['tur-muslim:918#2127', "Biz Allah'ınız", 'daha hayırlısını ihsan eyle', 'Musibet Anında Dua', 'Sabır'],
  ['tur-tirmidhi:3243', 'Allah bize yeter', 'güvenip dayanmışız', 'Tevekkül Duası', 'Tevekkül'],
  ['tur-tirmidhi:3391', 'Allah’ım senin izin ve yardımınla sabahladık', 'dönüşümüzde sanadır', 'Sabah Duası', 'Sabah'],
  ['tur-tirmidhi:3391', 'Allah’ım senin izin ve yardımınla akşama', 'dönüşümüzde sanadır.', 'Akşam Duası', 'Akşam'],
  ['tur-tirmidhi:3394', 'Allah’ım irademi', 'Nebie iman ettim.', 'Yatarken Okunan Dua', 'Uyku'],
  ['tur-tirmidhi:3483', 'Allah’ım bana faydalı', 'şerrinden de koru.', 'Hayra Yönelme Duası', 'Hidayet'],
  ['tur-tirmidhi:3531', 'Ey Allah’ım ben nefsime', 'acıyansın.', 'Namazda Bağışlanma Duası', 'Namaz'],
  ['tur-tirmidhi:3589', 'Allah’ım bu akşam ezanı', 'bağışlamanı dilerim.', 'Akşam Ezanında Dua', 'Akşam'],
  ['tur-tirmidhi:972', 'Allah’ın adıyla sana zarar', 'şifalar versin', 'Hastaya Okunan Dua', 'Şifa'],
  ['tur-tirmidhi:3437', 'Allah’ın yarattığı', 'sığınırım.', 'Bir Yere Konaklarken Dua', 'Yolculuk'],
  ['tur-tirmidhi:3388', 'İsmi anılıp', 'Allah adıyla', 'Sabah ve Akşam Korunma Duası', 'Korunma'],
  ['tur-tirmidhi:2140', 'Ey kalpleri halden hale', 'sabit kıl', 'Kalbin Sebatı İçin Dua', 'İman'],
  ['tur-tirmidhi:3401', 'Vücuduma sıhhat', 'izin veren Allah’a hamdolsun.', 'Uyanınca Hamd Duası', 'Uyku'],
  ['tur-tirmidhi:55', 'Ben inanır ve şâhidlik', 'temizlenenlerden eyle.', 'Abdestten Sonra Dua', 'Abdest'],
  ['tur-tirmidhi:3426', 'Allah’ın adıyla Allah’a güvendim', 'izni iledir', 'Evden Çıkarken Dua', 'Ev'],
  ['tur-abudawud:781', "Ey Allah'ım benimle", '(günahlardan) temizle', 'Namaza Başlarken Dua', 'Namaz'],
  ['tur-abudawud:1427', 'Allahım ! Senin gazabından', 'öylesin.', 'Vitir Namazında Dua', 'Namaz'],
  ['tur-abudawud:1512', 'Ey Allahım! Selâm sensin', 'ihsan sahibi', 'Namazdan Sonra Dua', 'Namaz'],
  ['tur-abudawud:3108', 'Ey Allahım hayat benim', 'canımı al', 'Hayırlı Ömür Duası', 'Sabır'],
  ['tur-abudawud:3106', 'Ulu Allah ve arşın', 'dilerim.', 'Hasta Ziyaretinde Dua', 'Şifa'],
  ['tur-abudawud:2357', 'susuzluk gitti', 'ecir hâsıl oldu', 'İftar Duası', 'Oruç', 1],
  ['tur-abudawud:4225', "Allah'ım! bana hidâyet ver", 'beni doğrult', 'Hidayet ve Doğruluk Duası', 'Hidayet'],
  ['tur-abudawud:5049', "Ey Allah'ım, senin isminle", 'dirilirim', 'Uyumadan Önce Dua', 'Uyku'],
  ['tur-abudawud:5054', "Allah'ım! Adınla", 'yüksek meclise koy!', 'Yatağa Girerken Dua', 'Uyku'],
  ['tur-nasai:334', 'Allah’ım hata', 'temizle, yıka.', 'Günahlardan Arınma Duası', 'Bağışlanma'],
  ['tur-ibnmajah:771', "Allah'ın adıyla. Selam", 'bana aç.', 'Mescide Girerken Dua', 'Mescid'],
  ['tur-ibnmajah:925', "Allah'ım! Ben Senden yararlı", 'dilerim.', 'Sabah Namazından Sonra Dua', 'Sabah'],
  ['tur-ibnmajah:1269', 'Allahım! Bize akibeti', 'yağmur ver.', 'Yağmur Duası', 'Yağmur'],
  ['tur-ibnmajah:1356', "Allah'ım! Bana mağfiret", 'afiyet ver.', 'Gece Kalkınca Dua', 'Gece'],
  ['tur-ibnmajah:1383', "Allah'ım! Hakkımda hayırlısını", "razı kıl.", 'İstihâre Duası', 'İstihâre'],
  ['tur-ibnmajah:3820', 'Allahım, beni o kimselerden', 'istiğfar ederler.', 'İhlâs ve İstiğfar Duası', 'Bağışlanma'],
  ['tur-ibnmajah:3831', 'Allahım! Ey yedi göğün', 'zenginleştir.', 'Borçtan Kurtulma Duası', 'Rızık'],
  ['tur-ibnmajah:3839', 'Allahım! İşlediğimin', 'sığınırım.', 'Yapılan ve Yapılmayan Şerden Sığınma', 'Sığınma'],
  ['tur-ibnmajah:3871', 'Allahım! Ben senden dünyada', 'sana sığınırım.', 'Sabah ve Akşam Âfiyet Duası', 'Âfiyet'],
  ['tur-muslim:974#2256', "Selâm mü'min", 'sizlere katılacağız', 'Kabir Ziyaretinde Dua', 'Kabir'],
  ['tur-abudawud:5058', 'Bana yeten', 'sana sığınırım', 'Yatarken Hamd Duası', 'Uyku'],
  ['tur-bukhari:6230', 'Bütün selamlar, dualar', 'salih kullarına olsun', 'Tahiyyât (Teşehhüd)', 'Namaz'],
  ['tur-tirmidhi:2060', 'Her ikinizi de', 'sığındırırım.', 'Çocuklar İçin Korunma Duası', 'Çocuk'],
];
const cache = {}; const out = []; const hata = [];
const mevcut = JSON.parse(fs.readFileSync(mevcutYol, 'utf8'));
const mk = new Set(mevcut.map(d => d.anlam));
for (const [ref, bas, son, baslik, kategori, buyuk] of S) {
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
  const g = (h.grades || []).find(x => /^(sahih|hasan)/i.test(x.grade));
  if (!['tur-bukhari', 'tur-muslim'].includes(ed) && !g) { hata.push(ref + ' derece yok'); continue; }
  if (mk.has(anlam)) { hata.push(ref + ' mevcut'); continue; }
  const kaynakNo = ed === 'tur-muslim' ? Math.floor(h.arabicnumber) : h.hadithnumber;
  out.push({ baslik, kategori, anlam, kaynak: `${AD[ed]}, ${kaynakNo}`, sihhat: g ? `${g.grade} (${g.name})` : `Sahih (${AD[ed]})`,
    metinKaynagi: `fawazahmed0/hadith-api (${ed})` });
}
fs.writeFileSync(cikti, JSON.stringify(out, null, 1));
console.log('eklendi', out.length, 'hata', hata);
for (const d of out) console.log(`- ${d.kaynak} | ${d.baslik} | ${d.anlam}`);
