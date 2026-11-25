import 'package:flutter/material.dart';
import 'dua_havuzu.dart';

/// 365 gun icin ek dualar (Bolum 3: 76-95)
const List<Dua> duaHavuzu4 = [
  Dua(
      baslik: 'Sukur Yemek Sonrasi',
      kategori: 'Yemek',
      arapca: 'Elhamdulillahi rabbil alemin',
      okunusu: 'Elhamdulillahi rabbil alemin',
      anlami: 'Alemlerin Rabbi Allaha hamdolsun.',
      kaynak: 'Buhari, Et`ime, 54',
      ikon: Icons.restaurant_menu_rounded,
      renk: Color(0xFF2FAE7F)),
  Dua(
      baslik: 'Uyku Oncesi Koruma',
      kategori: 'Aksam',
      arapca: 'Bismike Allahumme emutu ve ahya',
      okunusu: 'Bismike Allahumme emutu ve ahya',
      anlami: 'Allahim, senin adinla olur ve yasarim.',
      kaynak: 'Buhari, Deavat, 7',
      ikon: Icons.nights_stay_rounded,
      renk: Color(0xFF0A1F44)),
  Dua(
      baslik: 'Uyanma Sukru',
      kategori: 'Sabah',
      arapca: 'Elhamdulillahillezi redde aleyye ruhi ve afani fi bedeni',
      okunusu: 'Elhamdulillahillezi redde aleyye ruhi ve afani fi bedeni',
      anlami:
          'Ruhumu bana geri veren ve bedenime afiyet bahseden Allaha hamdolsun.',
      kaynak: 'Tirmizi, Deavat, 1',
      ikon: Icons.wb_sunny_rounded,
      renk: Color(0xFFC9A961)),
  Dua(
      baslik: 'Abdest Sonrasi',
      kategori: 'Namaz',
      arapca:
          'Eshedu en la ilahe illallahu vahdehu la serike leh ve eshedu enne Muhammeden abduhu ve resuluh',
      okunusu:
          'Eshedu en la ilahe illallahu vahdehu la serike leh ve eshedu enne Muhammeden abduhu ve resuluh',
      anlami:
          'Allahtan baska ilah olmadigina, O`nun bir ve ortaksiz olduguna sahitlik ederim. Muhammed`in O`nun kulu ve resulu olduguna da sahitlik ederim.',
      kaynak: 'Muslim, Taharet, 17',
      ikon: Icons.water_drop_rounded,
      renk: Color(0xFF2FAE7F)),
  Dua(
      baslik: 'Ezan Sonrasi',
      kategori: 'Namaz',
      arapca: 'Allahumme rabbe hazihid-da`vetit-tammeti ves-salatil-kaimeti',
      okunusu: 'Allahumme rabbe hazihid davetit tammeti ves salatil kaimeti',
      anlami: 'Ey bu eksiksiz davetin ve kilinacak namazin Rabbi olan Allahim.',
      kaynak: 'Buhari, Ezan, 8',
      ikon: Icons.campaign_rounded,
      renk: Color(0xFFC9A961)),
  Dua(
      baslik: 'Evden Cikis (Tam)',
      kategori: 'Genel',
      arapca:
          'Bismillahi tevekkeltu alallah la havle ve la kuvvete illa billah',
      okunusu:
          'Bismillahi tevekkeltu alallah la havle ve la kuvvete illa billah',
      anlami:
          'Allahin adiyla ciktim. Allaha tevekkul ettim. Guc kuvvet ancak Allahin izniyledir.',
      kaynak: 'Tirmizi, Deavat, 34',
      ikon: Icons.exit_to_app_rounded,
      renk: Color(0xFF0A1F44)),
  Dua(
      baslik: 'Kabir Azabindan Siginma',
      kategori: 'Ahiret',
      arapca:
          'Allahumme inni euzu bike min azabil-kabri ve min fitnetil-mesihid-deccal',
      okunusu:
          'Allahumme inni euzu bike min azabil kabri ve min fitnetil mesihid deccal',
      anlami:
          'Allahim, kabir azabindan ve Mesih Deccal`in fitnesinden sana siginirim.',
      kaynak: 'Muslim, Mesacid, 128',
      ikon: Icons.shield_rounded,
      renk: Color(0xFFB71C1C)),
  Dua(
      baslik: 'Namazda Fatiha Sonrasi',
      kategori: 'Namaz',
      arapca: 'Allahumme inni eselukel-huda vet-tuka vel-afafe vel-gina',
      okunusu: 'Allahumme inni eselukel huda vet tuka vel afafe vel gina',
      anlami:
          'Allahim, senden hidayet, takva, iffet ve gonul zenginligi isterim.',
      kaynak: 'Muslim, Zikir, 72',
      ikon: Icons.mosque_rounded,
      renk: Color(0xFFC9A961)),
  Dua(
      baslik: 'Gunah Islemekten Korunma',
      kategori: 'Tevbe',
      arapca:
          'Allahumme inni euzu bike minel-kufri vel-fakri ve min azabil-kabr',
      okunusu:
          'Allahumme inni euzu bike minel kufri vel fakri ve min azabil kabr',
      anlami:
          'Allahim, kufurden, fakirlikten ve kabir azabindan sana siginirim.',
      kaynak: 'Ebu Davud, Vitr, 32',
      ikon: Icons.shield_rounded,
      renk: Color(0xFFB71C1C)),
  Dua(
      baslik: 'Hidayet Uzere Olme',
      kategori: 'Hidayet',
      arapca: 'Allahumme inni eseluke hasenel-hatimeti',
      okunusu: 'Allahumme inni eseluke hasenel hatimeti',
      anlami: 'Allahim, senden guzel bir son (husn-u hatime) diliyorum.',
      kaynak: 'Buhari, Deavat, 22',
      ikon: Icons.light_mode_rounded,
      renk: Color(0xFFC9A961)),
  Dua(
      baslik: 'Hastalikta Sabir',
      kategori: 'Sifa',
      arapca: 'Allahumme inni eselukel-afve vel-afiyete fi dinya ve dini',
      okunusu: 'Allahumme inni eselukel afve vel afiyete fi dinya ve dini',
      anlami: 'Allahim, dunyamda ve dinimde af ve afiyet dilerim.',
      kaynak: 'Ebu Davud, Edeb, 110',
      ikon: Icons.health_and_safety_rounded,
      renk: Color(0xFF2FAE7F)),
  Dua(
      baslik: 'Korku Aninda',
      kategori: 'Sikinti',
      arapca: 'Hasbunallahu ve ni`mel vekil',
      okunusu: 'Hasbunallahu ve nimel vekil',
      anlami: 'Allah bize kafidir. O ne guzel vekildir.',
      kaynak: 'Al-i Imran, 173',
      ikon: Icons.anchor_rounded,
      renk: Color(0xFF0A1F44)),
  Dua(
      baslik: 'Sabir ve Zafer',
      kategori: 'Genel',
      arapca:
          'Rabbenâ efrig aleynâ sabren ve sebbit ekdâmenâ vensurnâ alel-kavmil-kâfirîn',
      okunusu:
          'Rabbena efrig aleyna sabren ve sebbit ekdamena vensurna alel kavmil kafirin',
      anlami:
          'Rabbimiz, uzerimize sabir yagdir, ayaklarimizi saglam tut ve kafirler topluluguna karsi bize yardim et.',
      kaynak: 'Bakara, 250',
      ikon: Icons.flash_on_rounded,
      renk: Color(0xFFB71C1C)),
  Dua(
      baslik: 'Kuran Okuma Niyeti',
      kategori: 'Kuran',
      arapca: 'Rabbena tekabbel minna inneke entes-semiul-alim',
      okunusu: 'Rabbena tekabbel minna inneke entes semiul alim',
      anlami: 'Rabbimiz, bizden kabul buyur. Suphesiz sen isitensin, bilensin.',
      kaynak: 'Bakara, 127',
      ikon: Icons.menu_book_rounded,
      renk: Color(0xFF2FAE7F)),
  Dua(
      baslik: 'Cennet Nimetleri',
      kategori: 'Cennet',
      arapca: 'Rabbena ve atina ma veadtena ala rusulike',
      okunusu: 'Rabbena ve atina ma veadtena ala rusulike',
      anlami:
          'Rabbimiz, peygamberlerin araciligiyla bize vaad ettiklerini ver.',
      kaynak: 'Al-i Imran, 194',
      ikon: Icons.park_rounded,
      renk: Color(0xFF2FAE7F)),
  Dua(
      baslik: 'Kotu Arkadastan Korunma',
      kategori: 'Koruma',
      arapca: 'Allahumme inni euzu bike min suil-cari ve suil-halit',
      okunusu: 'Allahumme inni euzu bike min suil cari ve suil halit',
      anlami: 'Allahim, kotu komsudan ve kotu arkadastan sana siginirim.',
      kaynak: 'Buhari, Deavat, 37',
      ikon: Icons.shield_rounded,
      renk: Color(0xFFB71C1C)),
  Dua(
      baslik: 'Yemekte Bereket',
      kategori: 'Yemek',
      arapca: 'Allahumme barik lena fihi ve et`imna hayran minhu',
      okunusu: 'Allahumme barik lena fihi ve etimna hayran minhu',
      anlami:
          'Allahim, bu yemekte bize bereket ver ve bundan daha hayirlisini yedir.',
      kaynak: 'Tirmizi, Deavat, 55',
      ikon: Icons.agriculture_rounded,
      renk: Color(0xFFC9A961)),
  Dua(
      baslik: 'Uzuntu ve Keder',
      kategori: 'Sikinti',
      arapca:
          'Allahumme inni euzu bike minel-hemmi vel-hazen vel-aczi vel-kesel',
      okunusu:
          'Allahumme inni euzu bike minel hemmi vel hazen vel aczi vel kesel',
      anlami:
          'Allahim, kaygidan, uzuntuden, acizlikten ve tembellikten sana siginirim.',
      kaynak: 'Buhari, Deavat, 36',
      ikon: Icons.cloud_off_rounded,
      renk: Color(0xFFB71C1C)),
  Dua(
      baslik: 'Zulme Ugramaktan Korunma',
      kategori: 'Koruma',
      arapca: 'Allahumme inni euzu bike minel-cubni vel-buhl',
      okunusu: 'Allahumme inni euzu bike minel cubni vel buhl',
      anlami: 'Allahim, korkakliktan ve cimrilikten sana siginirim.',
      kaynak: 'Buhari, Cihad, 74',
      ikon: Icons.shield_rounded,
      renk: Color(0xFFB71C1C)),
  Dua(
      baslik: 'Kul Hakki Odeme',
      kategori: 'Tevbe',
      arapca: 'Allahumme inni euzu bike min mesail-il-ahlak',
      okunusu: 'Allahumme inni euzu bike min mesailil ahlak',
      anlami: 'Allahim, kotu ahlaktan sana siginirim.',
      kaynak: 'Buhari, Cihad, 96',
      ikon: Icons.autorenew_rounded,
      renk: Color(0xFF2FAE7F)),
  Dua(
      baslik: 'Son Nefeste Iman',
      kategori: 'Hidayet',
      arapca: 'Ya mukallibel-kulub sebbit kalbi ala dinike',
      okunusu: 'Ya mukallibel kulub sebbit kalbi ala dinike',
      anlami:
          'Ey kalpleri evirip ceviren Allah, kalbimi dinin uzerinde sabit kil.',
      kaynak: 'Tirmizi, Deavat, 89',
      ikon: Icons.favorite_rounded,
      renk: Color(0xFFC9A961)),
];
