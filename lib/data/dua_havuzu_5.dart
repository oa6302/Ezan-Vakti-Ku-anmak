import 'package:flutter/material.dart';
import 'dua_havuzu.dart';

/// 365 gun icin ek dualar (Bolum 5: 98-117)
const List<Dua> duaHavuzu5 = [
  Dua(
    baslik: 'Sabah Kalkinca Sukur',
    kategori: 'Sabah',
    arapca: 'Elhamdulillahillezi ahyana bade ma ematena ve ileyhin-nusur',
    okunusu: 'Elhamdulillahillezi ahyana bade ma ematena ve ileyhin nusur',
    anlami: 'Bizi oldurdukten sonra dirilten Allaha hamdolsun. Donus Onadir.',
    kaynak: 'Buhari, Deavat, 7',
    ikon: Icons.wb_sunny_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Aynaya Bakinca',
    kategori: 'Sabah',
    arapca: 'Allahumme hassin halki ve husn-i huluki',
    okunusu: 'Allahumme hassin halki ve husn-i huluki',
    anlami: 'Allahim, yaratilisimi ve ahlakimi guzellestir.',
    kaynak: "Ibni Sunni, Amelu'l-Yevm ve'l-Leyl, 156",
    ikon: Icons.person_outline_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Yola Cikinca',
    kategori: 'Yolculuk',
    arapca: 'Bismillahi tevekkeltu alallah',
    okunusu: 'Bismillahi tevekkeltu alallah',
    anlami: 'Allahin adiyla cikiyorum. Allaha tevekkul ettim.',
    kaynak: 'Ebu Davud, Edeb, 102',
    ikon: Icons.directions_walk_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Arac Girince',
    kategori: 'Yolculuk',
    arapca: 'Subhanellezi sahhara lena haza ve ma kunna lehu mukrinin',
    okunusu: 'Subhanellezi sahhara lena haza ve ma kunna lehu mukrinin',
    anlami:
        'Bunu bizim hizmetimize veren Allahi tesbih ederim. Yoksa biz buna guc yetiremezdik.',
    kaynak: 'Zuhruf, 13',
    ikon: Icons.directions_car_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Yagmur Yaginca',
    kategori: 'Tabiat',
    arapca: 'Allahumme sayyiben nafian',
    okunusu: 'Allahumme sayyiben nafian',
    anlami: 'Allahim, bunu faydali bir yagmur kil.',
    kaynak: 'Buhari, Istiska, 11',
    ikon: Icons.water_drop_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Gok Gurleyince',
    kategori: 'Tabiat',
    arapca:
        "Subhanellezi yusebbihu'r-ra'du bi hamdihi vel melaiketu min hifetihi",
    okunusu:
        "Subhanellezi yusebbihur-ra'du bi hamdihi vel melaiketu min hifetihi",
    anlami:
        'Gok gurultusu ve melekler Onun korkusundan tesbih ederken Allahi tesbih ederim.',
    kaynak: 'Muvatta, Istiska, 5',
    ikon: Icons.thunderstorm_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Ruzgar Cikinca',
    kategori: 'Tabiat',
    arapca:
        'Allahumme inni eseluke hayraha ve hayra ma fiha ve hayra ma ursilet bih',
    okunusu:
        'Allahumme inni eseluke hayraha ve hayra ma fiha ve hayra ma ursilet bih',
    anlami:
        'Allahim, bu ruzgarin hayrini, icindeki hayri ve onunla gonderilen hayri istiyorum.',
    kaynak: 'Muslim, Istiska, 15',
    ikon: Icons.air_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Hasta Ziyaretinde',
    kategori: 'Sifa',
    arapca: "Es'elullahel-azime rabbe'l-arsil-azimi en yesfiyek",
    okunusu: "Es'elullahel azime rabbel arsil azimi en yesfiyek",
    anlami:
        'Buyuk arsin Rabbi olan yuce Allahtan sana sifa vermesini diliyorum.',
    kaynak: 'Tirmizi, Tibb, 32',
    ikon: Icons.local_hospital_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Sifa Bulunca',
    kategori: 'Sifa',
    arapca: "Elhamdulillahillezi afani ve lem yec'al li maraz",
    okunusu: "Elhamdulillahillezi afani ve lem yec'al li maraz",
    anlami: 'Bana sifa veren ve hastaligimi devam ettirmeyen Allaha hamdolsun.',
    kaynak: 'Buhari, Marda, 20',
    ikon: Icons.favorite_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Sikintidan Kurtulunca',
    kategori: 'Sukur',
    arapca: 'Elhamdulillahillezi neccani minke ve cealena ala gayrika kadirain',
    okunusu:
        'Elhamdulillahillezi neccani minke ve cealena ala gayrika kadirain',
    anlami:
        'Beni senden kurtaran ve bizi senden baskasina muhtac etmeyen Allaha hamdolsun.',
    kaynak: 'Tirmizi, Deavat, 55',
    ikon: Icons.check_circle_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Cuma Gunu Salavat',
    kategori: 'Cuma',
    arapca:
        'Allahumme salli ve sellim ala seyyidina Muhammedin ve ala alihi ve sahbihi ecmein',
    okunusu:
        'Allahumme salli ve sellim ala seyyidina Muhammedin ve ala alihi ve sahbihi ecmein',
    anlami:
        'Allahim, Efendimiz Muhammede, ailesine ve butun ashabina salat ve selam et.',
    kaynak: 'Ahzab, 56',
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Kandil Gecesi',
    kategori: 'Kandil',
    arapca: "Allahumme inneke afuvvun kerimun tuhibbul-afve fa'fu anni",
    okunusu: "Allahumme inneke afuvvun kerimun tuhibbul afve fa'fu anni",
    anlami:
        'Allahim, sen affedici ve comertsin. Affetmeyi seversin. Beni affet.',
    kaynak: 'Tirmizi, Deavat, 84',
    ikon: Icons.auto_awesome_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Kadir Gecesi',
    kategori: 'Kandil',
    arapca: "Allahumme inneke afuvvun kerimun tuhibbul-afve fa'fu anni",
    okunusu: "Allahumme inneke afuvvun kerimun tuhibbul afve fa'fu anni",
    anlami: 'Allahim, sen affedicisin, affetmeyi seversin, beni affet.',
    kaynak: 'Tirmizi, Deavat, 84',
    ikon: Icons.nights_stay_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Arefe Gunu',
    kategori: 'Hac',
    arapca:
        'La ilahe illallahu vahdehu la serike leh lehul-mulku ve lehul-hamdu ve huve ala kulli seyin kadir',
    okunusu:
        'La ilahe illallahu vahdehu la serike leh lehul mulku ve lehul hamdu ve huve ala kulli seyin kadir',
    anlami:
        'Allahtan baska ilah yoktur. O birdir, ortagi yoktur. Mulku Onun, hamd Onundur.',
    kaynak: 'Tirmizi, Deavat, 123',
    ikon: Icons.landscape_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Kurban Bayrami',
    kategori: 'Bayram',
    arapca: 'Bismillahi Allahu ekber. Allahumme tekabbel minni',
    okunusu: 'Bismillahi Allahu ekber. Allahumme tekabbel minni',
    anlami: 'Allahin adiyla, Allah en buyuktur. Allahim, benden kabul buyur.',
    kaynak: 'Muslim, Edahi, 19',
    ikon: Icons.celebration_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Ramazan Baslangici',
    kategori: 'Ramazan',
    arapca:
        'Allahumme ehillehu aleyna bil-yumni vel-imani ves-selameti vel-islam',
    okunusu:
        'Allahumme ehillehu aleyna bil yumni vel imani ves selameti vel islam',
    anlami: 'Allahim, bu ayi bize bereket, iman, selamet ve Islam uzere getir.',
    kaynak: 'Tirmizi, Deavat, 53',
    ikon: Icons.nights_stay_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Iftar Acarken',
    kategori: 'Ramazan',
    arapca: "Zehebez-zama'u vebtelletil-uruku ve sebetel-ecru in saallah",
    okunusu: "Zehebez zama'u vebtelletil uruku ve sebetel ecru in saallah",
    anlami: 'Susuzluk gitti, damarlar isladi, insallah mukafat da gerceklesti.',
    kaynak: 'Ebu Davud, Savm, 22',
    ikon: Icons.restaurant_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Dua(
    baslik: 'Sahurda',
    kategori: 'Ramazan',
    arapca: 'Bismillahi ve ala bereketillah',
    okunusu: 'Bismillahi ve ala bereketillah',
    anlami: 'Allahin adiyla ve Allahin bereketiyle.',
    kaynak: 'Ebu Davud, Et`ime, 15',
    ikon: Icons.nightlight_round,
    renk: Color(0xFF0A1F44),
  ),
  Dua(
    baslik: 'Kurban Keserken',
    kategori: 'Kurban',
    arapca: 'Bismillahi vallahu ekber. Allahumme haze minke ve ileyke',
    okunusu: 'Bismillahi vallahu ekber. Allahumme haze minke ve ileyke',
    anlami: 'Allahin adiyla, Allah en buyuktur. Allahim bu senden ve sanadir.',
    kaynak: 'Muslim, Edahi, 19',
    ikon: Icons.agriculture_rounded,
    renk: Color(0xFFC9A961),
  ),
  Dua(
    baslik: 'Vefat Haberi Alinca',
    kategori: 'Ahiret',
    arapca:
        "Inna lillahi ve inna ileyhi raciun. Allahumme'curni fi musibeti ve ehlif li hayran minha",
    okunusu:
        "Inna lillahi ve inna ileyhi raciun. Allahumme'curni fi musibeti ve ehlif li hayran minha",
    anlami:
        'Muhakkak biz Allah iciniz ve Ona donuyoruz. Allahim, bu musibetimde bana ecir ver ve bana daha hayirlisini nasip et.',
    kaynak: 'Muslim, Cenaiz, 3',
    ikon: Icons.local_florist_rounded,
    renk: Color(0xFF0A1F44),
  ),
];
