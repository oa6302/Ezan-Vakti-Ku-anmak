import 'package:flutter/material.dart';

class Dua {
  final String baslik;
  final String kategori;
  final String arapca;
  final String okunusu;
  final String anlami;
  final String kaynak;
  final IconData ikon;
  final Color renk;

  const Dua({
    required this.baslik,
    required this.kategori,
    required this.arapca,
    required this.okunusu,
    required this.anlami,
    required this.kaynak,
    required this.ikon,
    required this.renk,
  });
}

const List<Dua> duaHavuzu = [
  Dua(
    baslik: 'Ilim Duasi',
    kategori: 'Genel',
    arapca: 'Rabbi zidni ilma',
    okunusu: 'Rabbi zidni ilma',
    anlami: 'Rabbim, bana ilim artir.',
    kaynak: 'Taha, 114',
    ikon: Icons.menu_book_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Dunya-Ahiret Duasi',
    kategori: 'Genel',
    arapca:
        'Rabbena atina fid-dunya haseneten ve fil-ahireti haseneten ve kina azaben-nar',
    okunusu:
        'Rabbena atina fid-dunya haseneten ve fil-ahireti haseneten ve kina azaben-nar',
    anlami:
        'Rabbimiz, bize dunyada da iyilik ver, ahirette de iyilik ver. Bizi ates azabindan koru.',
    kaynak: 'Bakara, 201',
    ikon: Icons.auto_awesome_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Bagislanma Duasi',
    kategori: 'Genel',
    arapca: 'Rabbena la tuahizna in nesina ev ahta na',
    okunusu: 'Rabbena la tuahizna in nesina ev ahta na',
    anlami: 'Rabbimiz, unutur veya yanilirsak bizi sorumlu tutma.',
    kaynak: 'Bakara, 286',
    ikon: Icons.favorite_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Gonul Ferahligi Duasi',
    kategori: 'Sabah',
    arapca: 'Rabbisrah li sadri ve yessir li emri',
    okunusu: 'Rabbisrah li sadri ve yessir li emri',
    anlami: 'Rabbim, gogsumu genislet ve isimi kolaylastir.',
    kaynak: 'Taha, 25-26',
    ikon: Icons.wb_sunny_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Seytandan Siginma Duasi',
    kategori: 'Genel',
    arapca:
        'Rabbi euzu bike min hemezatis-seyatin ve euzu bike rabbi en yahdurun',
    okunusu:
        'Rabbi euzu bike min hemezatis-seyatin ve euzu bike rabbi en yahdurun',
    anlami:
        'Rabbim, seytanlarin kiskirtmasindan sana siginirim. Onlarin yanima gelmelerinden de sana siginirim.',
    kaynak: 'Muminun, 97-98',
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Dua(
    baslik: 'Tevhid Duasi',
    kategori: 'Sikinti',
    arapca: 'La ilahe illa ente subhaneke inni kuntu minez-zalimin',
    okunusu: 'La ilahe illa ente subhaneke inni kuntu minez-zalimin',
    anlami:
        'Senden baska ilah yoktur. Sen yucesin. Ben kendine yazik edenlerden oldum.',
    kaynak: 'Enbiya, 87',
    ikon: Icons.brightness_2_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Tevekkul Duasi',
    kategori: 'Genel',
    arapca: 'Hasbunallahu ve nimel vekil',
    okunusu: 'Hasbunallahu ve nimel vekil',
    anlami: 'Allah bize kafidir. O ne guzel vekildir.',
    kaynak: 'Al-i Imran, 173',
    ikon: Icons.anchor_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Hastalik Duasi',
    kategori: 'Sifa',
    arapca: 'Rabbi enni messeniyed-durru ve ente erhamur-rahimin',
    okunusu: 'Rabbi enni messeniyed-durru ve ente erhamur-rahimin',
    anlami:
        'Rabbim, bana gercekten zarar dokundu. Sen merhametlilerin en merhametlisisin.',
    kaynak: 'Enbiya, 83',
    ikon: Icons.healing_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Anne-Baba Duasi',
    kategori: 'Aile',
    arapca: 'Rabbigfir li ve li valideyye ve lil-muminine yevme yekumul-hisab',
    okunusu: 'Rabbigfir li ve li valideyye ve lil-muminine yevme yekumul-hisab',
    anlami:
        'Rabbim, hesabin gorulecegi gun beni, anne-babami ve butun muminleri bagisla.',
    kaynak: 'Ibrahim, 41',
    ikon: Icons.family_restroom_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Aile Duasi',
    kategori: 'Aile',
    arapca:
        'Rabbena heb lena min ezvacina ve zurriyyatina kurrate ayunin vecalna lil-muttakine imama',
    okunusu:
        'Rabbena heb lena min ezvacina ve zurriyyatina kurrate ayunin vecalna lil-muttakine imama',
    anlami:
        'Rabbimiz, eslerimizden ve cocuklarimizdan bize goz aydinligi ver. Bizi takva sahiplerine imam yap.',
    kaynak: 'Furkan, 74',
    ikon: Icons.people_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Sukur Duasi',
    kategori: 'Sukur',
    arapca:
        'Rabbi evzini en eskura nimetteke ve en amele salihan terdahu ve edhilni bi rahmetike fi ibadikes-salihin',
    okunusu: 'Rabbi evzini en eskura nimetteke ve en amele salihan terdahu',
    anlami:
        'Rabbim, bana verdigin nimetlere sukretmeyi ve senin razi olacagin salih ameller islemeyi ilham et.',
    kaynak: 'Neml, 19',
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Tevbe Duasi',
    kategori: 'Tevbe',
    arapca:
        'Rabbena zalemna enfusena ve in lem tagfir lena ve terhamna le nekunnenne minel-hasirin',
    okunusu:
        'Rabbena zalemna enfusena ve in lem tagfir lena ve terhamna le nekunnenne minel-hasirin',
    anlami:
        'Rabbimiz, biz kendimize zulmettik. Eger bizi bagislamaz ve bize merhamet etmezsen, mutlaka ziyana ugrayanlardan oluruz.',
    kaynak: 'Araf, 23',
    ikon: Icons.autorenew_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Sabah Duasi',
    kategori: 'Sabah',
    arapca:
        'Allahumme bike asbahna ve bike emseyna ve bike nahya ve bike nemutu ve ileyken-nusur',
    okunusu:
        'Allahumme bike asbahna ve bike emseyna ve bike nahya ve bike nemutu ve ileyken-nusur',
    anlami:
        'Allahim, senin sayende sabaha erdik, senin sayende aksama ereriz. Senin sayende yasar, senin sayende oluruz. Donus sanadir.',
    kaynak: 'Tirmizi, Deavat, 13',
    ikon: Icons.wb_sunny_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Aksam Duasi',
    kategori: 'Aksam',
    arapca:
        'Allahumme bike emseyna ve bike asbahna ve bike nahya ve bike nemutu ve ileykel-masir',
    okunusu:
        'Allahumme bike emseyna ve bike asbahna ve bike nahya ve bike nemutu ve ileykel-masir',
    anlami:
        'Allahim, senin sayende aksama erdik, senin sayende sabaha ereriz. Senin sayende yasar, senin sayende oluruz. Donus sanadir.',
    kaynak: 'Tirmizi, Deavat, 13',
    ikon: Icons.nights_stay_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Sikinti Duasi',
    kategori: 'Sikinti',
    arapca:
        'La ilahe illallahul-azimul-halim, la ilahe illallahu rabbul-arsil-azim',
    okunusu:
        'La ilahe illallahul-azimul-halim, la ilahe illallahu rabbul-arsil-azim',
    anlami:
        'Azim ve Halim olan Allahtan baska ilah yoktur. Buyuk arsin Rabbi olan Allahtan baska ilah yoktur.',
    kaynak: 'Buhari, Deavat, 27',
    ikon: Icons.self_improvement_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Dua(
    baslik: 'Hayirli Is Duasi',
    kategori: 'Genel',
    arapca: 'Allahumme inni eselukel-huda vet-tuka vel-afafe vel-gina',
    okunusu: 'Allahumme inni eselukel-huda vet-tuka vel-afafe vel-gina',
    anlami:
        'Allahim, senden hidayet, takva, iffet ve gonul zenginligi istiyorum.',
    kaynak: 'Muslim, Zikir, 72',
    ikon: Icons.lightbulb_outline_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Selam Duasi',
    kategori: 'Genel',
    arapca:
        'Allahumme entes-selamu ve minkes-selam, tebarekte ya zel-celali vel-ikram',
    okunusu:
        'Allahumme entes-selamu ve minkes-selam, tebarekte ya zel-celali vel-ikram',
    anlami:
        'Allahim, sen selamsin, selamet sendendir. Ey azamet ve ikram sahibi, sen ne yucesin.',
    kaynak: 'Muslim, Mesacid, 135',
    ikon: Icons.spa_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Salavat',
    kategori: 'Genel',
    arapca: 'Allahumme salli ve sellim ala nebiyyina Muhammed',
    okunusu: 'Allahumme salli ve sellim ala nebiyyina Muhammed',
    anlami: 'Allahim, Peygamberimiz Muhammede salat ve selam et.',
    kaynak: 'Ahzab, 56',
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Dua(
    baslik: 'Sifa Duasi',
    kategori: 'Sifa',
    arapca: 'Ezhibil-bese rabben-nas, veşfi enteş-şafi, la şifae illa şifauk',
    okunusu: 'Ezhibil-bese rabben-nas, veşfi enteş-şafi, la şifae illa şifauk',
    anlami:
        'Ey insanlarin Rabbi, sikintiyi gider ve sifa ver. Sifa veren sensin. Senin sifandan baska sifa yoktur.',
    kaynak: 'Buhari, Merda, 20',
    ikon: Icons.healing_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Afiyet Duasi',
    kategori: 'Genel',
    arapca:
        'Allahumme afini fi bedeni, Allahumme afini fi semi, Allahumme afini fi basari',
    okunusu:
        'Allahumme afini fi bedeni, Allahumme afini fi semi, Allahumme afini fi basari',
    anlami:
        'Allahim, bedenime afiyet ver. Allahim, kulagima afiyet ver. Allahim, gozume afiyet ver.',
    kaynak: 'Ebu Davud, Edeb, 101',
    ikon: Icons.health_and_safety_rounded,
    renk: Color(0xFFC9A961),
  ),
];

/// Bugunun duasini dondurur (yilin gunu % havuz uzunlugu)
Dua gununDuasi() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  return duaHavuzu[dayOfYear % duaHavuzu.length];
}
