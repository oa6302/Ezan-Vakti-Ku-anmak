// Kur'an dualari -> dua_hazinesi.json (koleksiyon: kuran). Metin ve meal api.quran.com'dan.
// Her kayit: [baslik, kim, ayetler, baslangic kelimesi (harf cevirisi basi; bos = ayetin tamami)]
// node kuran_dualari.js ../../assets/content/dua_hazinesi.json
const fs = require('fs');
const DUALAR = [
  ['Hidayet Duası (Fâtiha)', 'Her rekâtta okunan', ['1:6', '1:7'], ''],
  ['Kabul Duası', 'Hz. İbrâhîm ve Hz. İsmâil', ['2:127'], 'rabbanā'],
  ['Müslüman Bir Nesil Duası', 'Hz. İbrâhîm ve Hz. İsmâil', ['2:128'], 'rabbanā'],
  ['Emin Bir Şehir Duası', 'Hz. İbrâhîm', ['2:126'], 'rabbi'],
  ['Dünya ve Ahiret Güzelliği', 'Müminlerin duası', ['2:201'], 'rabbanā'],
  ['Sabır ve Sebat Duası', 'Tâlût\'un askerleri', ['2:250'], 'rabbanā'],
  ['Bağışlanma ve Teslimiyet', 'Müminlerin duası', ['2:285'], "ghuf'rānaka"],
  ['Bakara Sûresinin Son Duası', 'Müminlerin duası', ['2:286'], 'rabbanā'],
  ['Kalbin Kaymaması Duası', 'İlimde derinleşenler', ['3:8'], 'rabbanā'],
  ['Mahşer Gününe İman', 'İlimde derinleşenler', ['3:9'], 'rabbanā'],
  ['İman Edenlerin Bağışlanma Duası', 'Takva sahipleri', ['3:16'], 'rabbanā'],
  ['Mülkün Sahibine Yakarış', 'Peygamberimize öğretilen', ['3:26', '3:27'], 'allāhumma'],
  ['Salih Evlat Duası', 'Hz. Zekeriyyâ', ['3:38'], 'rabbi'],
  ['Şahitlerle Yazılma Duası', 'Havariler', ['3:53'], 'rabbanā'],
  ['Günahların Bağışlanması ve Sebat', 'Peygamberlerle savaşan müminler', ['3:147'], 'rabbanā'],
  ['Allah Bize Yeter', 'Uhud sonrası müminler', ['3:173'], 'ḥasbunā'],
  ['Kâinatı Tefekkür Edenlerin Duası', 'Akıl sahipleri', ['3:191', '3:192'], 'rabbanā'],
  ['İman Çağrısına Uyanların Duası', 'Akıl sahipleri', ['3:193', '3:194'], 'rabbanā'],
  ['Şahitlerle Beraber Yaz', 'Hakkı tanıyan Hristiyanlar', ['5:83'], 'rabbanā'],
  ['Gökten Sofra Duası', 'Hz. Îsâ', ['5:114'], 'allāhumma'],
  ['Tövbe Duası', 'Hz. Âdem ve Havvâ', ['7:23'], 'rabbanā'],
  ['Zalimlerle Beraber Kılma', 'A\'râf ehli', ['7:47'], 'rabbanā'],
  ['Hak ile Hüküm Ver', 'Hz. Şuayb', ['7:89'], 'rabbanā'],
  ['Sabır ve Müslüman Olarak Ölüm', 'Firavun\'un sihirbazları', ['7:126'], 'rabbanā'],
  ['Kardeşimle Beraber Bağışla', 'Hz. Mûsâ', ['7:151'], 'rabbi'],
  ['Sen Bizim Velimizsin', 'Hz. Mûsâ', ['7:155', '7:156'], 'anta'],
  ['Allah Bana Yeter', 'Peygamberimize öğretilen', ['9:129'], 'ḥasbiya'],
  ['Zalimlere Fitne Kılma', 'Hz. Mûsâ\'nın kavmi', ['10:85', '10:86'], 'rabbanā'],
  ['Bilmediğimi İstemekten Sığınma', 'Hz. Nûh', ['11:47'], 'rabbi'],
  ['Salihlere Kat', 'Hz. Yûsuf', ['12:101'], 'rabbi'],
  ['Zindan Duası', 'Hz. Yûsuf', ['12:33'], 'rabbi'],
  ['Güvenli Şehir ve Puta Tapmaktan Koruma', 'Hz. İbrâhîm', ['14:35'], 'rabbi'],
  ['Namazı Devamlı Kılanlardan Eyle', 'Hz. İbrâhîm', ['14:40', '14:41'], 'rabbi'],
  ['Anne-Baba Duası', 'Müminlere öğretilen', ['17:24'], 'rabbi'],
  ['Doğrulukla Girip Çıkma Duası', 'Peygamberimize öğretilen', ['17:80'], 'rabbi'],
  ['Rahmet ve Doğru Yol Duası', 'Ashâb-ı Kehf', ['18:10'], 'rabbanā'],
  ['Göğsümü Genişlet', 'Hz. Mûsâ', ['20:25', '20:26', '20:27', '20:28'], 'rabbi'],
  ['İlmimi Artır', 'Peygamberimize öğretilen', ['20:114'], 'rabbi'],
  ['Hastalık ve Dert Duası', 'Hz. Eyyûb', ['21:83'], 'annī'],
  ['Sıkıntıdan Kurtuluş Duası', 'Hz. Yûnus', ['21:87'], 'lā'],
  ['Beni Yalnız Bırakma', 'Hz. Zekeriyyâ', ['21:89'], 'rabbi'],
  ['Bereketli Bir Yere İndir', 'Hz. Nûh', ['23:29'], 'rabbi'],
  ['Şeytanın Vesveselerinden Sığınma', 'Peygamberimize öğretilen', ['23:97', '23:98'], 'rabbi'],
  ['İman Ettik, Bağışla', 'Müminlerin duası', ['23:109'], 'rabbanā'],
  ['Bağışla ve Merhamet Et', 'Peygamberimize öğretilen', ['23:118'], 'rabbi'],
  ['Cehennem Azabını Uzaklaştır', 'Rahmân\'ın kulları', ['25:65', '25:66'], 'rabbanā'],
  ['Göz Aydınlığı Bir Aile', 'Rahmân\'ın kulları', ['25:74'], 'rabbanā'],
  ['Hikmet ve Salihlerle Beraberlik', 'Hz. İbrâhîm', ['26:83', '26:84', '26:85'], 'rabbi'],
  ['Şükre Muvaffak Kıl', 'Hz. Süleyman', ['27:19'], 'rabbi'],
  ['Nefsime Zulmettim', 'Hz. Mûsâ', ['28:16'], 'rabbi'],
  ['Zalimlerden Kurtar', 'Hz. Mûsâ', ['28:21'], 'rabbi'],
  ['İndireceğin Her Hayra Muhtacım', 'Hz. Mûsâ', ['28:24'], 'rabbi'],
  ['Bozgunculara Karşı Yardım', 'Hz. Lût', ['29:30'], 'rabbi'],
  ['Salih Bir Evlat Bağışla', 'Hz. İbrâhîm', ['37:100'], 'rabbi'],
  ['Meleklerin Müminler İçin Duası', 'Arşı taşıyan melekler', ['40:7', '40:8'], 'rabbanā'],
  ['Azabı Bizden Kaldır', 'Müminlerin duası', ['44:12'], 'rabbanā'],
  ['Kırk Yaş Duası', 'Olgunluğa erişen mümin', ['46:15'], 'rabbi'],
  ['Kardeşlerimizi Bağışla', 'Sonra gelen müminler', ['59:10'], 'rabbanā'],
  ['Sana Tevekkül Ettik', 'Hz. İbrâhîm ve beraberindekiler', ['60:4', '60:5'], 'rabbanā'],
  ['Nurumuzu Tamamla', 'Müminlerin duası', ['66:8'], 'rabbanā'],
  ['Katında Bir Ev Yap', 'Firavun\'un hanımı Âsiye', ['66:11'], 'rabbi'],
  ['Yenildim, Yardım Et', 'Hz. Nûh', ['54:10'], 'annī'],
  ['Anne-Baba ve Müminler İçin Bağışlanma', 'Hz. Nûh', ['71:28'], 'rabbi'],
  // 2026-11-27 eklenenler (kimlikler sira ile verildigi icin sona eklenir)
  ['Musibet Anında İstirca', 'Sabredenler', ['2:156'], 'innā'],
  ['Mazlumların Kurtuluş Duası', 'Mazlum müminler', ['4:75'], 'rabbanā'],
  ['Tövbe Edip Sana Döndüm', 'Hz. Mûsâ', ['7:143'], "sub'ḥānaka"],
  ['Yola Çıkarken Besmele', 'Hz. Nûh', ['11:41'], "bis'mi"],
  ['Gizliyi ve Açığı Bilen Rabbe', 'Hz. İbrâhîm', ['14:38'], 'rabbanā'],
  ['Hamd ve Tekbir', 'Peygamberimize öğretilen', ['17:111'], 'l-ḥamdu'],
  ['Mâşâallah, Kuvvet Ancak Allah\'ındır', 'Bağ sahibine öğüt', ['18:39'], 'mā'],
  ['Hak ile Hükmet', 'Peygamberimize öğretilen', ['21:112'], 'rabbi'],
  ['Yalanlayanlara Karşı Yardım', 'Hz. Nûh', ['23:26'], 'rabbi'],
  ['Zalimler Arasında Bırakma', 'Peygamberimize öğretilen', ['23:93', '23:94'], 'rabbi'],
  ['Ailemi Kurtar', 'Hz. Lût', ['26:169'], 'rabbi'],
  ['Bağışla ve Mülk Ver', 'Hz. Süleyman', ['38:35'], 'rabbi'],
  ['Göklerin ve Yerin Yaratıcısına', 'Peygamberimize öğretilen', ['39:46'], 'l-lahuma'],
  ['İşimi Allah\'a Havale Ediyorum', 'Firavun ailesinden mümin', ['40:44'], 'ufawwiḍu'],
  ['Binek Duası', 'Müminlere öğretilen', ['43:13', '43:14'], "sub'ḥāna"],
  ['Felak Sûresi ile Sığınma', 'Peygamberimize öğretilen', ['113:1', '113:2', '113:3', '113:4', '113:5'], ''],
  ['Nâs Sûresi ile Sığınma', 'Peygamberimize öğretilen', ['114:1', '114:2', '114:3', '114:4', '114:5', '114:6'], ''],
  ['Hamd ve Yardım Dileme (Fâtiha)', 'Her rekâtta okunan', ['1:2', '1:3', '1:4', '1:5'], ''],
  ['Âyetü\'l-Kürsî', 'Zikir olarak okunan', ['2:255'], ''],
  ['Tevhide Şahitlik', 'Allah, melekler ve ilim sahipleri', ['3:18'], ''],
  ['Bizi Buna Eriştiren Allah\'a Hamd', 'Cennet ehli', ['7:43'], "l-ḥamdu"],
  ['Cennet Ehlinin Tesbihi', 'Cennet ehli', ['10:10'], "sub'ḥānaka"],
  ['Rabbime Tevekkül Ettim', 'Hz. Hûd', ['11:56'], 'innī'],
  ['Başarım Ancak Allah\'ladır', 'Hz. Şuayb', ['11:88'], 'tawfīqī'],
  ['Allah En İyi Koruyandır', 'Hz. Yakub', ['12:64'], 'fal-lahu'],
  ['Derdimi Allah\'a Arz Ederim', 'Hz. Yakub', ['12:86'], 'innamā'],
  ['Nesli İçin Dua', 'Hz. İbrâhîm', ['14:37'], 'rabbanā'],
  ['Evlat İçin Hamd', 'Hz. İbrâhîm', ['14:39'], 'l-ḥamdu'],
  ['Diriliş Günü Rezil Etme', 'Hz. İbrâhîm', ['26:87', '26:88', '26:89'], 'walā'],
  ['Hamd ve Seçilmiş Kullara Selam', 'Peygamberimize öğretilen', ['27:59'], 'quli'],
  ['Salavat Ayeti', 'Müminlere emredilen', ['33:56'], ''],
  ['Hüznü Gideren Allah\'a Hamd', 'Cennet ehli', ['35:34'], 'l-ḥamdu'],
  ['Rabbini Tesbih', 'Sûrenin sonu', ['37:180', '37:181', '37:182'], ''],
  ['Kötülüklerden Koru', 'Arşı taşıyan melekler', ['40:9'], 'waqihimu'],
  ['Evvel ve Âhir Olan Allah', 'Hadîd sûresinin başı', ['57:1', '57:2', '57:3'], ''],
  ['Esmâü\'l-Hüsnâ Ayetleri', 'Haşr sûresinin sonu', ['59:22', '59:23', '59:24'], ''],
  ['İhlâs Sûresi', 'Tevhid sûresi', ['112:1', '112:2', '112:3', '112:4'], ''],
  // 2026-11-27 (2): hazinede olmayan dua ayetleri
  ['Peygamber Gönder Duası', 'Hz. İbrâhîm ve Hz. İsmâil', ['2:129'], 'rabbanā'],
  ['Adağımı Kabul Et', 'Hz. Meryem\'in annesi', ['3:35'], 'rabbi'],
  ['Sana Dua Edip Mahrum Kalmadım', 'Hz. Zekeriyyâ', ['19:4', '19:5', '19:6'], 'rabbi'],
  ['Zalimlerden Kurtaran Allah\'a Hamd', 'Hz. Nûh', ['23:28'], 'l-ḥamdu'],
  ['Beni ve Müminleri Kurtar', 'Hz. Nûh', ['26:117', '26:118'], 'rabbi'],
  ['Üstün Kılan Allah\'a Hamd', 'Hz. Dâvûd ve Hz. Süleyman', ['27:15'], 'l-ḥamdu'],
  ['Suçlulara Arka Çıkmam', 'Hz. Mûsâ', ['28:17'], 'rabbi'],
  ['Doğru Yola İletilme Ümidi', 'Hz. Mûsâ', ['28:22'], 'asā'],
  ['Sıkıntıda Rabbine Niyaz', 'Hz. Eyyûb', ['38:41'], 'annī'],
  ['Vaadini Yerine Getiren Allah\'a Hamd', 'Cennet ehli', ['39:74'], 'l-ḥamdu'],
];

const SURE = require('./ayet_cek_sureler.js');
const bekle = ms => new Promise(r => setTimeout(r, ms));
async function ayet(key) {
  for (let d = 0; d < 4; d++) {
    try {
      const r = await fetch(`https://api.quran.com/api/v4/verses/by_key/${key}?words=true&word_fields=text_uthmani&language=tr&translations=77`);
      if (!r.ok) throw new Error(r.status);
      return (await r.json()).verse;
    } catch (e) { await bekle(800 * (d + 1)); }
  }
  throw new Error('cekilemedi ' + key);
}
// Ingilizce harf cevirisini Turkce imlaya yaklastirir (tecvid yerine gecmez).
function turkce(tr, sonKelime) {
  let s = tr.toLowerCase().replace(/'/g, '');
  s = s.replace(/^l-(t|th|d|dh|r|z|s|sh|ṣ|ḍ|ṭ|ẓ|l|n)/, (m, h) => h + '-' + h);
  s = s.replace(/sh/g, 'ş').replace(/kh/g, 'H').replace(/dh/g, 'z').replace(/th/g, 's').replace(/gh/g, 'ğ')
    .replace(/j/g, 'c').replace(/w/g, 'v').replace(/q/g, 'K').replace(/ʿ|ʾ/g, "'")
    .replace(/ḥ/g, 'H').replace(/ṣ/g, 'S').replace(/ḍ/g, 'D').replace(/ṭ/g, 'T').replace(/ẓ/g, 'Z');
  // Kalin harflerden sonra a/i kalin; digerlerinde a -> e
  s = s.replace(/([HKSDTZğr'])?(a|i)/g, (m, h, v) => (h ? h : '') + (h ? (v === 'i' ? 'ı' : 'a') : (v === 'a' ? 'e' : 'i')));
  s = s.replace(/ā/g, 'â').replace(/ī/g, 'î').replace(/ū/g, 'û');
  s = s.toLowerCase().replace(/k/g, 'k');
  if (sonKelime) s = s.replace(/(un|in|an|u|i|ı|e|a)$/, '');
  return s;
}
const ARAP_DISI = /\b(the|of|and|to|is|who|with|from|for)\b/i;
(async () => {
  const kayitlar = [];
  for (const [i, [baslik, kim, keys, bas]] of DUALAR.entries()) {
    const kelimeler = []; const mealler = [];
    for (const k of keys) {
      const v = await ayet(k);
      mealler.push(v.translations[0].text.replace(/<[^>]+>/g, '').replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&amp;/g, '&').replace(/\s+/g, ' ').trim());
      let w = v.words.filter(x => x.char_type_name === 'word');
      if (bas && k === keys[0]) {
        const n = t => (t || '').toLowerCase().replace(/^(wa|fa)(?=.)/, '').replace(/^l-/, 'al').normalize('NFD').replace(/[̀-ͯ'ʿʾ-]/g, '').replace(/[aeiou]/g, '').replace(/(.)\1+/g, '$1');
        const tam = t => (t || '').toLowerCase().replace(/^(wa|fa)(?=.)/, '').replace(/^l-/, 'al').normalize('NFD').replace(/['ʿʾ-]/g, '');
        let j = w.findIndex(x => tam(x.transliteration.text) === tam(bas));
        if (j < 0) j = w.findIndex(x => n(x.transliteration.text) === n(bas));
        if (j < 0) throw new Error(`${k}: '${bas}' bulunamadi`);
        w = w.slice(j);
      }
      kelimeler.push(...w);
    }
    const parca = [];
    for (let p = 0; p < kelimeler.length; p += 4) {
      const g = kelimeler.slice(p, p + 4);
      const anlam = g.map(x => (x.translation.text || '').trim()).filter(a => a && !ARAP_DISI.test(a)).join(' · ');
      parca.push({ arapca: g.map(x => x.text_uthmani).join(' '),
        okunus: g.map((x, n) => turkce(x.transliteration.text, p + n === kelimeler.length - 1)).join(' '),
        anlam: anlam ? 'Kelime kelime: ' + anlam : '' });
    }
    const [s1, a1] = keys[0].split(':').map(Number); const aSon = keys[keys.length - 1].split(':')[1];
    kayitlar.push({
      id: `dua_k${String(i + 1).padStart(3, '0')}`, koleksiyon: 'kuran', sinif: 'kuranAyeti', baslik,
      arapca: parca.map(p => p.arapca).join(' '),
      okunus: parca.map(p => p.okunus).join(' ').replace(/^l-lehu?m+e/, 'Allâhumme').replace(/ l-leh([uie])/g, "'llâh$1").replace(/^./, c => c.toUpperCase()),
      anlam: mealler.join(' '),
      kaynak: `${SURE[s1 - 1]}, ${s1}/${a1}${keys.length > 1 ? '-' + aSon : ''}`,
      aciklama: `${kim} duası. Anlam, ayetin Diyanet mealidir; okunuş otomatik harf çevirisidir, tecvid için Arapça metin esas alınmalıdır. Metin: api.quran.com (Uthmani).`,
      parcalar: parca,
    });
    process.stdout.write(`\r${i + 1}/${DUALAR.length}`);
  }
  const hedef = process.argv[2];
  const mevcut = JSON.parse(fs.readFileSync(hedef, 'utf8')).filter(d => !String(d.id).startsWith('dua_k'));
  fs.writeFileSync(hedef, JSON.stringify([...mevcut, ...kayitlar], null, 1) + '\n');
  console.log('\nkuran duasi:', kayitlar.length, 'toplam:', mevcut.length + kayitlar.length);
})();
