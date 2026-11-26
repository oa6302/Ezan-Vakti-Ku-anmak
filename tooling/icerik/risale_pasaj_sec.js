// risale_pasaj_cikar.js adaylarindan gunluk Risale pasajlari: baglamsiz baslayanlar,
// biyografik/siyasi ve mektup kisimlari elenir; ayni bolumden en fazla 2 pasaj.
// node risale_pasaj_sec.js <adaylar.json> <cikti.json>
const fs = require('fs');
const [girdi, cikti] = process.argv.slice(2);
const aday = JSON.parse(fs.readFileSync(girdi, 'utf8'));
const kucuk = s => s.toLocaleLowerCase('tr');
const KOTU_BAS = /^(ve|fakat|lâkin|çünkü|çünki|demek|evet|hem|işte|belki|madem|mâdem|meselâ|hattâ|yani|sonra|şimdi|bu|şu|o|onun|bunun|elhâsıl|hâsılı|amma|ama|eğer|ise|binaenaleyh|ondan|bundan|zîrâ|hususan|husûsan|bâhusûs|lâsiyyemâ|sâliklerinin|güyâ|kezâlik|aynen|öyle|böyle|nasıl|ikincisi|birincisi|üçüncüsü|diğeri|biri|bir kısmı|gerçi|gücenme|inşâallâh|merâk etmeyiniz|onlar)[\s,.!]/;
const YASAK = /(otuz bir mart|hükûmet|siyâset|siyaset|mahkeme|hapis|zindan|ehl-i siyâset|gazete|meclis|mebus|mebûs|vilâyet|kardeşlerim|kardeşim|üstâd|efendi|hazretleri’nin mektub|talebeler|şâkird|risâle-i nûr’un)/;
const ATIF = /(söz’de|söz’ün|söz’e|lem‘a’da|mektub’da|risâle-i nûr’da|risâlelerinde|risâlesinde|hâşiye|mezkûr|yukarıda|aşağıda|sâbıkan|evvelki|zikredilen)/;
const KOTU_BOLUM = /(hâşiye|mektub|lâhika|takrîz|fıkra|hâtime|ihtar|hüccet|müdâfaa|zeyl|tarihçe)/i;
// Elle incelendi: baglama muhtac / bolum ici atif / tarihce baslangiclari
const ELENEN_BAS = ['Ezcümle', 'Bir tebdîl-i mekândır', 'İkinci kısım', 'Hatta insaniyetin', 'Sizin zaman-ı', 'Kırk beş sene', 'Gördü ki', 'Sol tarafına', 'Başta Kur’ân', 'İkinci vecih', 'Hâlbuki', 'Gençlik Rehberi', 'Bir cihet kaldı', 'Buna kıyâsen', 'Yetmişlik', 'Ey sefâhet', 'Bir Müslüman', 'Risâle-i Nûr', 'Ey ikinci bozuk', 'On iki seneden', 'Kastamonu', 'Makam-ı istimâ', 'Ben âciz', 'Mefhûm-u', 'Sizler, ey', 'İkinci cereyân', 'Envâr-ı Muhammediye', 'Gāyet muhtelif', 'Ehl-i dalâlet gelsin', 'Gāyet cây-ı hayret'];
const secilen = []; const bolumSay = {}; const gorulen = new Set();
for (const a of aday) {
  const l = kucuk(a.latin);
  if (!/^[A-ZÇĞİÖŞÜÂÎÛ]/.test(a.latin) || ATIF.test(l)) continue;
  if (ELENEN_BAS.some(b => a.latin.startsWith(b))) continue;
  if (KOTU_BAS.test(l) || YASAK.test(l) || KOTU_BOLUM.test(a.bolum || '')) continue;
  const t = l.replace(/[^a-zçğıöşü]/g, '').slice(0, 60);
  if (gorulen.has(t)) continue; gorulen.add(t);
  const b = a.eser + '|' + a.bolum;
  if ((bolumSay[b] = (bolumSay[b] || 0) + 1) > 2) continue;
  secilen.push(a);
}
// Ardisik gunlerde farkli eser
const kuyruk = {}; for (const a of secilen) (kuyruk[a.eser] ??= []).push(a);
const sira = []; while (sira.length < secilen.length) for (const e of Object.keys(kuyruk)) if (kuyruk[e].length) sira.push(kuyruk[e].shift());
fs.writeFileSync(cikti, JSON.stringify(sira.slice(0, 365).map((a, i) => ({
  gun: i + 1, baslik: (a.bolum || a.eser).split(' · ')[0], bolum: a.bolum || '', eser: a.eser, sayfa: a.sayfa,
  latin: a.latin, osmanlica: a.osmanlica,
  metinKaynagi: 'risale.online (aynen; Osmanlıca kelime kelime Latince karşılıklı)' })), null, 1) + '\n');
const s = {}; for (const a of sira) s[a.eser] = (s[a.eser] || 0) + 1;
console.log('secilen', Math.min(365, sira.length), JSON.stringify(s));
