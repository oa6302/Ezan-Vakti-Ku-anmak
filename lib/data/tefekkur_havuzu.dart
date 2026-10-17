/// Tefekkur havuzu — gunluk dusunce ve muhasebe.
class Tefekkur {
  final String baslik;
  final String metin;
  final String kategori;
  const Tefekkur({
    required this.baslik,
    required this.metin,
    required this.kategori,
  });
}

const List<Tefekkur> tefekkurHavuzu = [
  Tefekkur(baslik: 'Yeni Gun', metin: 'Her yeni gun, Allaha sukur icin yeni bir imkandir. Dun gecti, yarin gelmedi, elimizde sadece bugun var.', kategori: 'Sabah'),
  Tefekkur(baslik: 'Kalbin Aynasi', metin: 'Kalbin aynasi temiz olursa, Rabbini her yerde gorur. Kalp paslanirsa, hicbir sey gorunmez.', kategori: 'Kalp'),
  Tefekkur(baslik: 'Zamanin Kiymeti', metin: 'Zaman, hayatin ta kendisidir. Onu nasil gecirdigin, kim oldugunu gosterir. En kiymetli hazineni harcadigin yere dikkat et.', kategori: 'Zaman'),
  Tefekkur(baslik: 'Dunya ve Ahiret', metin: 'Dunya ahiretin tarlasidir. Burada ektigin, orada bicilecektir. Bugun ektigin tohuma dikkat et.', kategori: 'Ahiret'),
  Tefekkur(baslik: 'Imtihan', metin: 'Hayat bir imtihandir; her nefes bir soru, her an bir cevaptir. Kul, verdigi cevaplarla ya yucelir ya duser.', kategori: 'Imtihan'),
  Tefekkur(baslik: 'Sukur Kapisi', metin: 'Sahip oldugun her nimet, senin gormedigin binlerce mahrumun hayalidir. Sukret, artacaktir.', kategori: 'Sukur'),
  Tefekkur(baslik: 'Sabir Aynasi', metin: 'Sabir, aciyi yutar; ama yuregi buyutur. Hicbir sabir bosa gitmez.', kategori: 'Sabir'),
  Tefekkur(baslik: 'Tevekkul', metin: 'Tevekkul, sebeplere sarildiktan sonra sonucu Allaha birakmaktir. Tembellik degil, teslimiyettir.', kategori: 'Tevekkul'),
  Tefekkur(baslik: 'Nefs Muhasebesi', metin: 'Her aksam nefsini sorgula: Bugun ne yaptim? Kime iyilik ettim? Kime haksizlik ettim? Yarin nasil daha iyi olurum?', kategori: 'Muhasebe'),
  Tefekkur(baslik: 'Dua Kapisi', metin: 'Dua, kulun Rabbine en yakin oldugu andir. Eller acilinca gokler acilir.', kategori: 'Dua'),
  Tefekkur(baslik: 'Tovbe', metin: 'Tovbe, kirilan kalbin tamiridir. Kim tovbe ederse, gecmis kiriklar Rabb katinda affa ugrar.', kategori: 'Tovbe'),
  Tefekkur(baslik: 'Ahiret Yolcusu', metin: 'Dunya bir yolculuk, ahiret menzildir. Yolcu, azikla yol alir. Amelin en hayirli aziktir.', kategori: 'Ahiret'),
  Tefekkur(baslik: 'Ilim Isigi', metin: 'Ilim, kalbin kandilidir. Kandilsiz kalp, karanlikta yol arar.', kategori: 'Ilim'),
  Tefekkur(baslik: 'Kalp Huzuru', metin: 'Huzur, sahip olmakta degil; sahip olduklarini fark etmektir. Zikir, huzurun anahtaridir.', kategori: 'Huzur'),
  Tefekkur(baslik: 'Olum Uyanis', metin: 'Olum, bir kapidan gecmektir. Onu hatirlayan, dunyaya baglanmaz; onu unutan, sonsuzluga hazirlik yapmaz.', kategori: 'Olum'),
  Tefekkur(baslik: 'Seytan ve Nefs', metin: 'Seytan vesvese verir, nefs arzu eder. Kul, ikisini de dinlemek zorunda degildir. Kalp, secme hakkina sahiptir.', kategori: 'Nefs'),
  Tefekkur(baslik: 'Ibadet Lezzeti', metin: 'Ibadetin zorluguna bakma; kabul edilme sevincine bak. Kul, Rabbinin huzurunda oldugunu bilse, secde bitmesin ister.', kategori: 'Ibadet'),
  Tefekkur(baslik: 'Cennet Ozlemi', metin: 'Cennet, hicbir gozun gormedigi, hicbir kulagin duymadigi nimetlerin yurdudur. Ona talip olan, dunyaya aldanmaz.', kategori: 'Cennet'),
  Tefekkur(baslik: 'Cehennem Korkusu', metin: 'Cehennem, kulun kendi tercihinin sonucudur. Onu hatirlayan, gunaha yaklasmaz.', kategori: 'Ahiret'),
  Tefekkur(baslik: 'Ihlas', metin: 'Ihlas, yalniz Allah rizasi icin yapmaktir. Kul, gosterisi birakinca, az ameli bile buyuk olur.', kategori: 'Ihlas'),
];