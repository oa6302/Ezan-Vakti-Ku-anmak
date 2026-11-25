import 'package:flutter/material.dart';
import 'dua_havuzu.dart';

/// 365 gun icin ek dualar (Bolum 2: 51-75)
/// Kaynaklar: Kuran ayetleri, Buhari, Muslim, Tirmizi, Ebu Davud
const List<Dua> duaHavuzu3 = [
  Dua(
    baslik: 'Seytanin Vesvesesinden Siginma',
    kategori: 'Koruma',
    arapca:
        'Rabbi euzu bike min hemezatis-seyatin ve euzu bike rabbi en yahdurun',
    okunusu:
        'Rabbi euzu bike min hemezatis seyatin ve euzu bike rabbi en yahdurun',
    anlami:
        'Rabbim, seytanlarin kiskirtmalarindan sana siginirim. Onlarin yanima gelmelerinden de sana siginirim.',
    kaynak: 'Muminun, 97-98',
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Dua(
    baslik: 'Iman Artirma Duasi',
    kategori: 'Iman',
    arapca: 'Rabbena amenna faktubna meas-sahidin',
    okunusu: 'Rabbena amenna faktubna meas sahidin',
    anlami: 'Rabbimiz, biz iman ettik. Bizi sahitlerle beraber yaz.',
    kaynak: 'Maide, 83',
    ikon: Icons.favorite_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Bagislanma ve Merhamet Duasi',
    kategori: 'Tevbe',
    arapca:
        'Rabbena zalemna enfusena ve in lem tagfir lena ve terhamna le nekunnenne minel-hasirin',
    okunusu:
        'Rabbena zalemna enfusena ve in lem tagfir lena ve terhamna le nekunnenne minel hasirin',
    anlami:
        'Rabbimiz, biz kendimize zulmettik. Eger bizi bagislamaz ve bize merhamet etmezsen, mutlaka ziyana ugrayanlardan oluruz.',
    kaynak: 'Araf, 23',
    ikon: Icons.autorenew_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Dunya-Ahiret Iyilik Duasi',
    kategori: 'Genel',
    arapca:
        'Rabbena atina fid-dunya haseneten ve fil-ahireti haseneten ve kina azaben-nar',
    okunusu:
        'Rabbena atina fid dunya haseneten ve fil ahireti haseneten ve kina azaben nar',
    anlami:
        'Rabbimiz, bize dunyada da iyilik ver, ahirette de iyilik ver. Bizi ates azabindan koru.',
    kaynak: 'Bakara, 201',
    ikon: Icons.auto_awesome_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Sukur Duasi',
    kategori: 'Sukur',
    arapca: 'Rabbi evzini en eskura nimetteke ve en amele salihan terdahu',
    okunusu: 'Rabbi evzini en eskura nimetteke ve en amele salihan terdahu',
    anlami:
        'Rabbim, bana verdigin nimetlere sukretmeyi ve senin razi olacagin salih ameller islemeyi ilham et.',
    kaynak: 'Neml, 19',
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Salih Kul Olma Duasi',
    kategori: 'Genel',
    arapca: 'Rabbena efrig aleyna sabren ve teveffena muslimin',
    okunusu: 'Rabbena efrig aleyna sabren ve teveffena muslimin',
    anlami:
        'Rabbimiz, uzerimize sabir yagdir ve bizi musluman olarak vefat ettir.',
    kaynak: 'Araf, 126',
    ikon: Icons.self_improvement_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Nur Duasi',
    kategori: 'Hidayet',
    arapca:
        'Rabbena etmim lena nurana vagfir lena inneke ala kulli seyin kadir',
    okunusu:
        'Rabbena etmim lena nurana vagfir lena inneke ala kulli seyin kadir',
    anlami:
        'Rabbimiz, nurumuzu tamamla ve bizi bagisla. Suphesiz sen her seye kadirsin.',
    kaynak: 'Tahrim, 8',
    ikon: Icons.light_mode_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Cennete Girme Duasi',
    kategori: 'Cennet',
    arapca: 'Rabbena edhilna fi rahmetike ve ente erhamur-rahimin',
    okunusu: 'Rabbena edhilna fi rahmetike ve ente erhamur rahimin',
    anlami:
        'Rabbimiz, bizi rahmetine dahil et. Sen merhametlilerin en merhametlisisin.',
    kaynak: 'Muminun, 118',
    ikon: Icons.park_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Namaz Kilanlardan Olma',
    kategori: 'Namaz',
    arapca: 'Rabbic alni mukimes-salati ve min zurriyyeti',
    okunusu: 'Rabbic alni mukimes salati ve min zurriyyeti',
    anlami:
        'Rabbim, beni ve soyumdan gelenleri namazi devamli kilanlardan eyle.',
    kaynak: 'Ibrahim, 40',
    ikon: Icons.mosque_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Seytandan Korunma (Sabah-Aksam)',
    kategori: 'Koruma',
    arapca: 'Euzu bi kelimatillahit-tammati min serri ma halak',
    okunusu: 'Euzu bi kelimatillahit tammati min serri ma halak',
    anlami:
        'Allahin eksiksiz kelimeleriyle yarattiklarinin serrinden Allaha siginirim.',
    kaynak: 'Muslim, Zikir, 54',
    ikon: Icons.brightness_2_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Sabah-Aksam Emniyet Duasi',
    kategori: 'Sabah',
    arapca: 'Bismillahillezi la yedurru maasmihi seyun fil-ardi ve la fis-sema',
    okunusu:
        'Bismillahillezi la yedurru maasmihi seyun fil ardi ve la fis sema',
    anlami:
        'Adi anildiginda yerde ve gokte hicbir seyin zarar veremeyecegi Allahin adiyla.',
    kaynak: 'Ebu Davud, Edeb, 101',
    ikon: Icons.shield_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Kalbi Sabit Kilma',
    kategori: 'Kalp',
    arapca: 'Ya mukallibel-kulub sebbit kalbi ala dinike',
    okunusu: 'Ya mukallibel kulub sebbit kalbi ala dinike',
    anlami: 'Ey kalpleri ceviren Allah, kalbimi dinin uzere sabit kil.',
    kaynak: 'Tirmizi, Deavat, 89',
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Sifa ve Afiyet Duasi',
    kategori: 'Sifa',
    arapca: 'Allahumme afini fi bedeni ve afini fi semi ve afini fi basari',
    okunusu: 'Allahumme afini fi bedeni ve afini fi semi ve afini fi basari',
    anlami:
        'Allahim, bedenime afiyet ver, kulagima afiyet ver, gozume afiyet ver.',
    kaynak: 'Ebu Davud, Edeb, 101',
    ikon: Icons.health_and_safety_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Iki Cihanda Afiyet Duasi',
    kategori: 'Genel',
    arapca: 'Allahumme inni eselukel-afve vel-afiyete fid-dunya vel-ahireti',
    okunusu: 'Allahumme inni eselukel afve vel afiyete fid dunya vel ahireti',
    anlami: 'Allahim, senden dunyada ve ahirette af ve afiyet istiyorum.',
    kaynak: 'Ebu Davud, Edeb, 110',
    ikon: Icons.verified_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Kotu Ahlaktan Siginma',
    kategori: 'Kalp',
    arapca: 'Allahumme inni euzu bike min suil-huluki vel-amali vel-ehva',
    okunusu: 'Allahumme inni euzu bike min suil huluki vel amali vel ehva',
    anlami:
        'Allahim, kotu ahlaktan, kotu amellerden ve kotu arzulardan sana siginirim.',
    kaynak: 'Tirmizi, Deavat, 126',
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Dua(
    baslik: 'Hidayet ve Takva Duasi',
    kategori: 'Hidayet',
    arapca: 'Allahumme inni eselukel-huda vet-tuka vel-afafe vel-gina',
    okunusu: 'Allahumme inni eselukel huda vet tuka vel afafe vel gina',
    anlami:
        'Allahim, senden hidayet, takva, iffet ve gonul zenginligi istiyorum.',
    kaynak: 'Muslim, Zikir, 72',
    ikon: Icons.light_mode_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Kalbimizi Nurlandir',
    kategori: 'Kalp',
    arapca: 'Allahumme nevvir kalbi ve nevvir basari',
    okunusu: 'Allahumme nevvir kalbi ve nevvir basari',
    anlami: 'Allahim, kalbimi ve gorme uzuvlarimi nurlandir.',
    kaynak: 'Tirmizi, Deavat, 30',
    ikon: Icons.brightness_high_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Saglik ve Afiyet Duasi',
    kategori: 'Sifa',
    arapca: 'Allahumme inni eselukel-afiyete fi dunyaya vel-ahirah',
    okunusu: 'Allahumme inni eselukel afiyete fi dunyaya vel ahireh',
    anlami: 'Allahim, senden dunyada ve ahirette afiyet dilerim.',
    kaynak: 'Ibn Mace, Dua, 5',
    ikon: Icons.health_and_safety_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Borclardan Kurtulma',
    kategori: 'Rizik',
    arapca: 'Allahumme inni euzu bike minel-galebeti ved-deyni ve kahrir-rical',
    okunusu:
        'Allahumme inni euzu bike minel galebeti ved deyni ve kahrir rical',
    anlami:
        'Allahim, maglubiyetten, borctan ve insanlarin kahretmesinden sana siginirim.',
    kaynak: 'Nesai, Isti`aze, 15',
    ikon: Icons.savings_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Tembellikten Siginma',
    kategori: 'Genel',
    arapca:
        'Allahumme inni euzu bike minel-aczi vel-keseli vel-cubni vel-buhul',
    okunusu:
        'Allahumme inni euzu bike minel aczi vel keseli vel cubni vel buhul',
    anlami:
        'Allahim, acizlikten, tembellikten, korkakliktan ve cimrilikten sana siginirim.',
    kaynak: 'Buhari, Deavat, 36',
    ikon: Icons.timer_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Sevap ve Bereket Duasi',
    kategori: 'Rizik',
    arapca: 'Allahumme barik lena fi emvalina ve evladina',
    okunusu: 'Allahumme barik lena fi emvalina ve evladina',
    anlami: 'Allahim, mallarimiza ve evlatlarimiza bereket ver.',
    kaynak: 'Buhari, Nikah, 46',
    ikon: Icons.agriculture_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Kotu Kaderden Korunma',
    kategori: 'Koruma',
    arapca: 'Allahumme inni euzu bike min suil-kadai ve suil-huluki vel-amal',
    okunusu: 'Allahumme inni euzu bike min suil kadai ve suil huluki vel amal',
    anlami:
        'Allahim, kotu kaderden, kotu ahlaktan ve kotu amelden sana siginirim.',
    kaynak: 'Tirmizi, Deavat, 92',
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Dua(
    baslik: 'Kuran ile Hidayet',
    kategori: 'Kuran',
    arapca:
        'Allahumme inni eseluke bi rahmetike elleti vesiat kulle sey`in en tagfir li',
    okunusu:
        'Allahumme inni eseluke bi rahmetike elleti vesiat kulle seyin en tagfir li',
    anlami: 'Allahim, her seyi kusatan rahmetinle beni bagislamani dilerim.',
    kaynak: 'Ibn Mace, Edeb, 2',
    ikon: Icons.menu_book_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Uzuvlarin Afiyeti',
    kategori: 'Sifa',
    arapca:
        'Allahumme inni euzu bike min zevail-ni`metike ve tebedduli afiyetike',
    okunusu:
        'Allahumme inni euzu bike min zevail nimetike ve tebedduli afiyetike',
    anlami:
        'Allahim, nimetinin yok olmasindan ve afiyetinin degismesinden sana siginirim.',
    kaynak: 'Muslim, Zikir, 74',
    ikon: Icons.health_and_safety_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Ihlasla Amel Duasi',
    kategori: 'Ihlas',
    arapca: 'Allahumme inni eseluke amelen salihan ve kalben halisan',
    okunusu: 'Allahumme inni eseluke amelen salihan ve kalben halisan',
    anlami: 'Allahim, senden salih bir amel ve halis bir kalp istiyorum.',
    kaynak: 'Tirmizi, Zuhd, 30',
    ikon: Icons.spa_rounded,
    renk: Color(0xFFC9A961),
  ),
];
