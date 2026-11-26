// api.quran.com'dan Uthmani metin + Diyanet meali (77) cekip 365 gunluk liste uretir.
// node ayet_cek.js <cikti.json>
const fs = require('fs');
const liste = require('./ayet_listesi.js');
const SURE = ['Fâtiha','Bakara','Âl-i İmrân','Nisâ','Mâide','En\'âm','A\'râf','Enfâl','Tevbe','Yûnus','Hûd','Yûsuf','Ra\'d','İbrâhîm','Hicr','Nahl','İsrâ','Kehf','Meryem','Tâhâ','Enbiyâ','Hac','Mü\'minûn','Nûr','Furkân','Şuarâ','Neml','Kasas','Ankebût','Rûm','Lokmân','Secde','Ahzâb','Sebe\'','Fâtır','Yâsîn','Sâffât','Sâd','Zümer','Mü\'min','Fussilet','Şûrâ','Zuhruf','Duhân','Câsiye','Ahkâf','Muhammed','Fetih','Hucurât','Kâf','Zâriyât','Tûr','Necm','Kamer','Rahmân','Vâkıa','Hadîd','Mücâdele','Haşr','Mümtehine','Saf','Cuma','Münâfikûn','Teğâbün','Talâk','Tahrîm','Mülk','Kalem','Hâkka','Meâric','Nûh','Cin','Müzzemmil','Müddessir','Kıyâmet','İnsân','Mürselât','Nebe\'','Nâziât','Abese','Tekvîr','İnfitâr','Mutaffifîn','İnşikâk','Bürûc','Târık','A\'lâ','Gâşiye','Fecr','Beled','Şems','Leyl','Duhâ','İnşirâh','Tîn','Alak','Kadir','Beyyine','Zilzâl','Âdiyât','Kâria','Tekâsür','Asr','Hümeze','Fîl','Kureyş','Mâûn','Kevser','Kâfirûn','Nasr','Tebbet','İhlâs','Felak','Nâs'];
const bekle = ms => new Promise(r => setTimeout(r, ms));
async function cek(key) {
  for (let deneme = 0; deneme < 4; deneme++) {
    try {
      const r = await fetch(`https://api.quran.com/api/v4/verses/by_key/${key}?translations=77&fields=text_uthmani`);
      if (!r.ok) throw new Error('HTTP ' + r.status);
      const v = (await r.json()).verse;
      const meal = v.translations[0].text.replace(/<sup[^>]*>.*?<\/sup>/g, '').replace(/<[^>]+>/g, '').replace(/\s+/g, ' ').trim();
      return { arapca: v.text_uthmani, meal };
    } catch (e) { await bekle(800 * (deneme + 1)); }
  }
  throw new Error('cekilemedi ' + key);
}
(async () => {
  const temaOf = {}; const sira = [];
  for (const [t, ks] of Object.entries(liste)) for (const k of ks) if (!temaOf[k]) { temaOf[k] = t; sira.push(k); }
  const veri = {};
  for (let i = 0; i < sira.length; i += 6) {
    await Promise.all(sira.slice(i, i + 6).map(async k => { veri[k] = await cek(k); }));
    process.stdout.write(`\r${Math.min(i + 6, sira.length)}/${sira.length}`);
  }
  console.log();
  // Uygun uzunluktakiler, temalara gore kuyruklar
  const kuyruk = {};
  for (const k of sira) {
    const m = veri[k].meal.length;
    if (m < 35 || m > 650) continue;
    (kuyruk[temaOf[k]] ??= []).push(k);
  }
  // Round-robin: ardisik gunler farkli tema
  const temalar = Object.keys(kuyruk); const secilen = [];
  while (secilen.length < 365 && temalar.some(t => kuyruk[t].length)) {
    for (const t of temalar) { if (kuyruk[t].length && secilen.length < 365) secilen.push(kuyruk[t].shift()); }
  }
  const cikti = secilen.map((k, i) => {
    const [s, a] = k.split(':').map(Number);
    return { gun: i + 1, anahtar: k, sure: SURE[s - 1], sureNo: s, ayetNo: a, tema: temaOf[k],
      arapca: veri[k].arapca, meal: veri[k].meal,
      kaynak: `${SURE[s - 1]}, ${s}/${a}`, metinKaynagi: 'api.quran.com (Uthmani) · Diyanet İşleri meali' };
  });
  fs.writeFileSync(process.argv[2], JSON.stringify(cikti, null, 1) + '\n');
  console.log('secilen', cikti.length, 'aday', sira.length);
})();
