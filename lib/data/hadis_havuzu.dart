/// Hadis havuzu — kategori bazli, ~45 hadis.
class Hadis {
  final String baslik;
  final String metin;
  final String kaynakRef;
  final String kitap;
  final String kategori;
  const Hadis({
    required this.baslik,
    required this.metin,
    required this.kaynakRef,
    required this.kitap,
    required this.kategori,
  });
}

const List<Hadis> hadisHavuzu = [
  // ═══ IMAN ═══
  Hadis(baslik: 'Ameller Niyete Gore', metin: 'Ameller ancak niyetlere goredir. Herkese ancak niyet ettigi sey vardir.', kaynakRef: 'Buhari, Bedul-Vahy, 1', kitap: 'Buhari', kategori: 'Iman'),
  Hadis(baslik: 'Imanin Tadi', metin: 'Kim Allahi Rab, Islami din, Muhammedi peygamber olarak kabul edip razi olursa imanin tadini alir.', kaynakRef: 'Muslim, Iman, 56', kitap: 'Muslim', kategori: 'Iman'),
  Hadis(baslik: 'Helal ve Haram', metin: 'Helal apacik, haram apaciktir. Ikisi arasinda supheli seyler vardir. Kim supheli seylerden kacinirsa dinini ve namusunu korumus olur.', kaynakRef: 'Buhari, Iman, 39', kitap: 'Buhari', kategori: 'Iman'),
  Hadis(baslik: 'Imanin 70 Subesi', metin: 'Iman yetmis kusur subedir. En ustun olani La ilahe illallah demek, en asagisi yoldan engel kaldirmaktir. Utanmak da imandandir.', kaynakRef: 'Buhari, Iman, 3', kitap: 'Buhari', kategori: 'Iman'),
  Hadis(baslik: 'Muslumanin Tanimi', metin: 'Musluman, elinden ve dilinden Muslumanlarin emin oldugu kimsedir. Muhacir de Allahin yasaklarindan uzak duran kimsedir.', kaynakRef: 'Buhari, Iman, 4', kitap: 'Buhari', kategori: 'Iman'),

  // ═══ IBADET ═══
  Hadis(baslik: 'Namaz Dinin Diregi', metin: 'Namaz dinin diregidir. Kim onu kilarca dinini ayakta tutar, kim de onu terk ederse dinini yikar.', kaynakRef: 'Beyhaki, Suab', kitap: 'Beyhaki', kategori: 'Ibadet'),
  Hadis(baslik: 'Namaz ile Kufur Arasi', metin: 'Kisi ile kufur arasinda namazi terk etmek vardir.', kaynakRef: 'Muslim, Iman, 134', kitap: 'Muslim', kategori: 'Ibadet'),
  Hadis(baslik: 'Oruc Kalkandir', metin: 'Oruc bir kalkandir. Oruclu kimse kotu soz soylemesin, cahillik etmesin. Biri kendisine sataşirsa "Ben orucluyum" desin.', kaynakRef: 'Nesai, Siyam, 41', kitap: 'Nesai', kategori: 'Ibadet'),
  Hadis(baslik: 'Sadaka Mali Eksiltmez', metin: 'Sadaka vermek mali eksiltmez. Af ile kulun serefi artar. Kim Allah icin tevazu gosterirse Allah onu yuceltir.', kaynakRef: 'Muslim, Birr, 69', kitap: 'Muslim', kategori: 'Ibadet'),
  Hadis(baslik: 'Bes Vakti Kilan Cennete Girer', metin: 'Bes vakit namazi kilan, orucu tutan, zekati veren ve Kabe`yi hacceden kimse cennete girer.', kaynakRef: 'Buhari, Hac, 1', kitap: 'Buhari', kategori: 'Ibadet'),
  Hadis(baslik: 'Zikir Nurdur', metin: 'Allahi cokca zikredin ki, kalpleriniz nur ile dolsun.', kaynakRef: 'Tirmizi, Dua, 3', kitap: 'Tirmizi', kategori: 'Ibadet'),

  // ═══ AHLAK ═══
  Hadis(baslik: 'Merhamet', metin: 'Allah, kullarina merhamet edendir. Yeryuzundekilere merhamet edin ki, gokyuzundekiler de size merhamet etsin.', kaynakRef: 'Buhari, Edeb, 18', kitap: 'Buhari', kategori: 'Ahlak'),
  Hadis(baslik: 'Komsuluk Hakki', metin: 'Komsusu ac iken tok yatan, bizden degildir.', kaynakRef: 'Buhari, Edeb, 112', kitap: 'Buhari', kategori: 'Ahlak'),
  Hadis(baslik: 'Guleryuz Sadakadir', metin: 'Kardesine gulumsemen bir sadakadir.', kaynakRef: 'Tirmizi, Birr, 36', kitap: 'Tirmizi', kategori: 'Ahlak'),
  Hadis(baslik: 'Dogruluk Cennete Goturur', metin: 'Dogruluk iyilige, iyilik cennete goturur. Kisi dogru soyler, dogru olani arar da sonunda Allah katinda siddik olarak yazilir.', kaynakRef: 'Buhari, Edeb, 69', kitap: 'Buhari', kategori: 'Ahlak'),
  Hadis(baslik: 'Emanete Riayet', metin: 'Emanete riayet etmeyenin imani yoktur. Sozunde durmayanin dini yoktur.', kaynakRef: 'Ahmed bin Hanbel', kitap: 'Ahmed bin Hanbel', kategori: 'Ahlak'),
  Hadis(baslik: 'Ofke Ani', metin: 'Bir kimse ofkelendiginde ayakta ise otursun. Ofke gecmezse uzansin.', kaynakRef: 'Ebu Davud, Edeb, 4', kitap: 'Ebu Davud', kategori: 'Ahlak'),
  Hadis(baslik: 'Hasetten Sakinin', metin: 'Hasetten sakinin. Zira haset, atesin odunu yedigi gibi iyilikleri yer bitirir.', kaynakRef: 'Ebu Davud, Edeb, 44', kitap: 'Ebu Davud', kategori: 'Ahlak'),
  Hadis(baslik: 'Giybet', metin: 'Giybet, kardesinin arkasindan hosuna gitmeyecek seyi soylemendir. Eger soyledigin onda varsa giybet, yoksa iftira olur.', kaynakRef: 'Muslim, Birr, 70', kitap: 'Muslim', kategori: 'Ahlak'),
  Hadis(baslik: 'Yalan Imana Aykiri', metin: 'Yalan soylemek imana aykiridir. Mumin her seyi yapabilir, ama hainlik ve yalan soyleyemez.', kaynakRef: 'Buhari, Edeb, 69', kitap: 'Buhari', kategori: 'Ahlak'),
  Hadis(baslik: 'Munafigin Uc Alâmeti', metin: 'Munafigin uc alâmeti vardir: Konustugunda yalan soyler, soz verdiginde sozunde durmaz, emanet edildiginde hiyanet eder.', kaynakRef: 'Buhari, Iman, 33', kitap: 'Buhari', kategori: 'Ahlak'),
  Hadis(baslik: 'Tevazu Yuceltir', metin: 'Kim Allah icin alcakgonullu olursa, Allah onu yuceltir.', kaynakRef: 'Muslim, Birr, 69', kitap: 'Muslim', kategori: 'Ahlak'),
  Hadis(baslik: 'Sabir ve Zafer', metin: 'Sabreden muzaffer olur, acele eden mahrum kalir.', kaynakRef: 'Buhari, Edeb, 20', kitap: 'Buhari', kategori: 'Ahlak'),

  // ═══ AILE ═══
  Hadis(baslik: 'Anne Baba Hakki', metin: 'Bir adam: "Ey Allahin Resulu, en cok kime iyilik edeyim?" dedi. Resulullah: "Annene, annene, annene, sonra babana" buyurdu.', kaynakRef: 'Buhari, Edeb, 2', kitap: 'Buhari', kategori: 'Aile'),
  Hadis(baslik: 'Cennet Annelerin Ayagi Altinda', metin: 'Cennet annelerin ayaklari altindadir.', kaynakRef: 'Nesai, Cihat, 6', kitap: 'Nesai', kategori: 'Aile'),
  Hadis(baslik: 'Sila-i Rahim Rizki Artirir', metin: 'Kim rizkinin genislemesini ve ecelinin uzamasini isterse sila-i rahim yapsin.', kaynakRef: 'Buhari, Edeb, 12', kitap: 'Buhari', kategori: 'Aile'),
  Hadis(baslik: 'Aileye Karsi En Hayirli', metin: 'En hayirliniz, ailesine karsi en hayirli olaninizdir.', kaynakRef: 'Tirmizi, Rada, 11', kitap: 'Tirmizi', kategori: 'Aile'),
  Hadis(baslik: 'Cocuga Ikram', metin: 'Cocugunuza ikram edin ve edebini guzel yapin.', kaynakRef: 'Ibn Mace, Edeb, 3', kitap: 'Ibn Mace', kategori: 'Aile'),

  // ═══ ILIM ═══
  Hadis(baslik: 'Ilim Yolu', metin: 'Kim ilim tahsil etmek icin bir yola girerse, Allah ona cennete giden yolu kolaylastirir.', kaynakRef: 'Muslim, Zikir, 2699', kitap: 'Muslim', kategori: 'Ilim'),
  Hadis(baslik: 'Ilim Ogrenmek Farz', metin: 'Ilim ogrenmek her Musluman uzerine farzdir.', kaynakRef: 'Ibn Mace, Mukaddime, 17', kitap: 'Ibn Mace', kategori: 'Ilim'),
  Hadis(baslik: 'Alimler Varisler', metin: 'Alimler peygamberlerin varisleridir. Peygamberler ne dinar ne dirhem birakmadilar, ilim biraktilar.', kaynakRef: 'Ebu Davud, Ilim, 1', kitap: 'Ebu Davud', kategori: 'Ilim'),
  Hadis(baslik: 'Bilgiyi Saklamak', metin: 'Kim bir ilim ogrenir de onu saklarsa, kiyamet gunu atesten gem vurulur.', kaynakRef: 'Tirmizi, Ilim, 3', kitap: 'Tirmizi', kategori: 'Ilim'),

  // ═══ SOSYAL ═══
  Hadis(baslik: 'Komsu Hukuku', metin: 'Komsusunun serrinden emin olmadigi kimse cennete giremez.', kaynakRef: 'Muslim, Iman, 73', kitap: 'Muslim', kategori: 'Sosyal'),
  Hadis(baslik: 'Misafire Ikram', metin: 'Allaha ve ahiret gunune iman eden misafirine ikram etsin.', kaynakRef: 'Buhari, Edeb, 31', kitap: 'Buhari', kategori: 'Sosyal'),
  Hadis(baslik: 'Selami Yayin', metin: 'Selami aranizda yayin ki muhabbetiniz artsin.', kaynakRef: 'Muslim, Iman, 93', kitap: 'Muslim', kategori: 'Sosyal'),
  Hadis(baslik: 'Yetim Himayesi', metin: 'Ben ve yetimi himaye eden, cennette su iki parmak gibi beraberiz.', kaynakRef: 'Buhari, Edeb, 24', kitap: 'Buhari', kategori: 'Sosyal'),
  Hadis(baslik: 'Mumin Muminin Aynasi', metin: 'Mumin, muminin aynasidir. Mumin muminin kardesidir; onun zararini onler, arkasindan korur.', kaynakRef: 'Ebu Davud, Edeb, 49', kitap: 'Ebu Davud', kategori: 'Sosyal'),
  Hadis(baslik: 'Yardim Eden Yardim Gorur', metin: 'Kim bir muminin dunya sikintisini giderirse, Allah da onun kiyamet sikintilarindan birini giderir.', kaynakRef: 'Muslim, Zikir, 2699', kitap: 'Muslim', kategori: 'Sosyal'),

  // ═══ KALP ═══
  Hadis(baslik: 'Kalbin Islahi', metin: 'Dikkat edin! Vucutta bir et parcasi vardir; o duzelirse butun vucut duzelir, o bozulursa butun vucut bozulur. Bilin ki o, kalptir.', kaynakRef: 'Buhari, Iman, 39', kitap: 'Buhari', kategori: 'Kalp'),
  Hadis(baslik: 'Sukur Nimete Vesile', metin: 'Sukreden, nimeti artmis olarak bulur. Nimete sukur eden, onu kaybetmekten emin olur.', kaynakRef: 'Ibrahim, 7', kitap: 'Kuran', kategori: 'Kalp'),
  Hadis(baslik: 'Kalp Katiligi', metin: 'Fakirlikten korkmayin; bolluk sizi azdirmasin. Kalp katiligi cookluktan olur.', kaynakRef: 'Tirmizi, Zuhd, 1', kitap: 'Tirmizi', kategori: 'Kalp'),
  Hadis(baslik: 'Niyet Amelin Ruhu', metin: 'Muminin niyeti amelinden hayirlidir.', kaynakRef: 'Taberani', kitap: 'Taberani', kategori: 'Kalp'),
  Hadis(baslik: 'Haya Imandandir', metin: 'Haya imandandir, iman da cennettedir. Haya yoksa iman da yoktur.', kaynakRef: 'Tirmizi, Birr, 37', kitap: 'Tirmizi', kategori: 'Kalp'),
  Hadis(baslik: 'Kin ve Nefret', metin: 'Kin ve nefret kalbi karartir. Affeden kulun serefi artar.', kaynakRef: 'Muslim, Birr, 69', kitap: 'Muslim', kategori: 'Kalp'),

  // ═══ AHIRET ═══
  Hadis(baslik: 'Dunya Ahiretin Tarlasi', metin: 'Dunya ahiretin tarlasidir. Burada ektigini orada bicersin.', kaynakRef: 'Munavi, Feyzul-Kadir', kitap: 'Munavi', kategori: 'Ahiret'),
  Hadis(baslik: 'Kabir Bahcesi', metin: 'Kabir, ya cennet bahcelerinden bir bahce ya da cehennem cukurlarindan bir cukurdur.', kaynakRef: 'Tirmizi, Kiyamet, 26', kitap: 'Tirmizi', kategori: 'Ahiret'),
  Hadis(baslik: 'Zerre Kadar Iyilik', metin: 'Kim zerre kadar hayir islerse onu gorur, kim zerre kadar ser islerse onu gorur.', kaynakRef: 'Zilzal, 7-8', kitap: 'Kuran', kategori: 'Ahiret'),
  Hadis(baslik: 'Hesap Gunu', metin: 'Kiyamet gunu hic kimseye zerre kadar haksizlik edilmez.', kaynakRef: 'Enbiya, 47', kitap: 'Kuran', kategori: 'Ahiret'),
  Hadis(baslik: 'Cennet Nimeti', metin: 'Cennette hicbir gozun gormedigi, hicbir kulagin duymadigi, hicbir kalbin hatirlamadigi nimetler vardir.', kaynakRef: 'Buhari, Bedul-Halk, 8', kitap: 'Buhari', kategori: 'Ahiret'),
];