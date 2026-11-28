// vecize_cikar.js adaylarindan 365 gunluk vecize secer (tek basina anlamli, tanim kalibi).
// node vecize_sec.js <adaylar.json> <cikti.json> [--liste]   (--liste: inceleme icin yazdir)
const fs = require('fs');
const [girdi, cikti, mod] = process.argv.slice(2);
const aday = JSON.parse(fs.readFileSync(girdi, 'utf8'));
const KAVRAM = /(îmân|iman|kur’ân|hakîkat|ubûdiyet|ibâdet|şükür|şükr|sabır|sabr|kalb|rûh|saâdet|saadet|nûr|âhiret|dünyâ|dünya|mevt|ölüm|duâ|ihlâs|tevekkül|rızâ|ilim|ilm|ma‘rifet|muhabbet|zikr|merhamet|şefkat|hayat|ecel|kabir|kabr|cennet|ömür|ömr|gaflet|nefs|tevbe|istiğfâr|namaz|fakr|acz|tefekkür|kâinât|esmâ|Allâh|Cenâb-ı Hakk|hidâyet|dalâlet|takvâ|ihsan|ahlâk|edeb|sünnet|haşir|ezel|ebed|beka|fânî|lezzet|elem|ümit|ümîd|me’yus|hürriyet|adâlet|hak|insan)/gi;
const TANIM = /(dır|dir|dur|dür|tır|tir|tur|tür|dar|der)\.$/i;
const ZAMIR = /\b(o|onu|ona|onun|onlar|onları|onların|bu|bunu|buna|bunun|bunlar|şu|şunu|şuna|şunun|kendi|kendisi|ise|hâlbuki|halbuki|yoksa|dahi|demek|öyle|böyle|mezkûr|sâbık|evvelki)\b/gi;
const BAGLAM = /(birinci|ikinci|üçüncü|dördüncü|beşinci|söz’|sözler|mektub|levha|mebhas|mes’ele|nokta|risâle|âyet-i kerîme|şu âyet|bu âyet|zikrettiğimiz|denilen|mezkûr|yukarıda|aşağıda|misâl|temsîl|hikâye|nev‘dir|kısımdır|kısım|vecihle|vecih|cihetle)/i;
const SEN = /\b(sen|sana|seni|senin|siz|size|sizin)\b/gi;
const KOTU_BAS = /^(ama|mâdem|çünki|zîrâ|bil ki|biri|bir kısmı|diğeri|hepsi|lâsiyyemâ|şâyet|bâhusûs|güyâ|âdetâ|bununla|ikisi|ekseri|kezâ|nasıl ki|yani|ayrı|zâten|o halde|ancak|fakat|lâkin|ve|elbette o|işte|evet|hem|birinci|ikinci|üçüncü|dördüncü|beşinci|altıncı|yedinci|sekizinci|dokuzuncu|onuncu|edildiği|olduğu|olan|eden|ettiği|gibi|kadar|için|diye|deyip|deyince|olup|ederek|hiç bir cihetle|kısm-ı|mâşâallâh)/i;
const puan = a => {
  const k = new Set((a.latin.match(KAVRAM) || []).map(x => x.toLowerCase())).size;
  const z = (a.latin.match(ZAMIR) || []).length, s = (a.latin.match(SEN) || []).length;
  let p = k * 3 + (TANIM.test(a.latin) ? 5 : 0) - z * 4 - s * 2 - Math.max(0, a.kelime - 14);
  if (KOTU_BAS.test(a.latin) || BAGLAM.test(a.latin)) p -= 20;
  if (!TANIM.test(a.latin) && /(eder|eyler|olur|verir|ister|bulur|gider|gelir).$/.test(a.latin)) p -= 3;
  return p;
};
const sirali = aday.map(a => ({ ...a, puan: puan(a) })).filter(a => a.puan >= 5).sort((a, b) => b.puan - a.puan);
const sayfa = new Set(), eser = {}, secilen = [], metin = new Set();
const SINIR = { 'Sözler': 140, 'Mektûbât': 110, "Lem'alar": 110, "Şuâ'lar": 100, 'Asâ-yı Mûsâ': 70 };
for (const a of sirali) {
  const k = a.eserId + ':' + a.sayfa;
  const m = a.latin.toLocaleLowerCase('tr').replace(/[^a-zçğıöşü]/g, '').slice(0, 40);
  if (metin.has(m)) continue; metin.add(m);
  if (sayfa.has(k) || (eser[a.eser] || 0) >= SINIR[a.eser]) continue;
  sayfa.add(k); eser[a.eser] = (eser[a.eser] || 0) + 1; secilen.push(a);
  if (secilen.length >= 520) break;
}
if (mod === '--liste') { secilen.forEach((a, i) => console.log(i, a.puan, a.eser[0] + a.sayfa, a.latin)); process.exit(0); }
const ELENEN = new Set((fs.existsSync(cikti + '.elenen') ? fs.readFileSync(cikti + '.elenen', 'utf8') : '').split(/\s+/).filter(Boolean).map(Number));
const KATEGORI = [[/îmân|iman|hidâyet|dalâlet/i, 'İman'], [/kur’ân/i, "Kur'an"], [/ubûdiyet|ibâdet|namaz|duâ|zikr/i, 'İbadet'],
  [/âhiret|cennet|haşir|kabir|kabr|mevt|ölüm|ecel|ebed|beka/i, 'Ahiret'], [/şükr|şükür|sabr|sabır|tevekkül|rızâ/i, 'Şükür ve Sabır'],
  [/kalb|rûh|nefs|gaflet|ihlâs|tevbe/i, 'Kalp ve Nefis'], [/ilim|ilm|ma‘rifet|tefekkür|kâinât|esmâ/i, 'Marifet'],
  [/muhabbet|merhamet|şefkat|ahlâk|edeb|adâlet|hak/i, 'Ahlak'], [/dünyâ|dünya|hayat|ömür|ömr|fânî|lezzet|elem/i, 'Dünya ve Hayat']];
const kat = l => (KATEGORI.find(([r]) => r.test(l)) || [0, 'Hakikat'])[1];
const son = secilen.filter((_, i) => !ELENEN.has(i)).slice(0, 365);
// Sirayi karistir: ardisik gunlerde ayni eser gelmesin
const kuyruk = {}; for (const a of son) (kuyruk[a.eser] ??= []).push(a);
const sira = []; while (sira.length < son.length) for (const e of Object.keys(kuyruk)) if (kuyruk[e].length) sira.push(kuyruk[e].shift());
fs.writeFileSync(cikti, JSON.stringify(sira.map((a, i) => ({ gun: i + 1, latin: a.latin, osmanlica: a.osmanlica,
  eser: a.eser, sayfa: a.sayfa, kaynak: `Bedîüzzaman Said Nursî, ${a.eser}`, kategori: kat(a.latin),
  metinKaynagi: 'risale.online (Osmanlıca kelime kelime Latince karşılıklı metin)' })), null, 1) + '\n');
console.log('secilen', sira.length, JSON.stringify(eser));
