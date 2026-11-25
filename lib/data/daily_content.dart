import 'package:flutter/material.dart';

class DailyContent {
  final String gunKonu;
  final String ayet;
  final String ayetKaynak;
  final String hadis;
  final String hadisKaynak;
  final String vecize;
  final String vecizeModern;
  final String vecizeKaynak;
  final String risaleHakikat;
  final String ayetArapca;
  final String ayetTefsir;
  final String risaleAlinti;
  final String risaleEser;
  final String risaleBolum;
  final String duaBaslik;
  final String duaArapca;
  final String duaOkunus;
  final String duaAnlam;
  final String duaKaynak;
  final String duaKategori;
  final List<String> anahtarKelimeler;
  final IconData ikon;
  final Color renk;

  const DailyContent({
    required this.gunKonu,
    required this.ayet,
    required this.ayetKaynak,
    required this.hadis,
    required this.hadisKaynak,
    required this.vecize,
    required this.vecizeModern,
    required this.vecizeKaynak,
    required this.risaleHakikat,
    this.ayetArapca = '',
    this.ayetTefsir = '',
    this.risaleAlinti = '',
    this.risaleEser = '',
    this.risaleBolum = '',
    this.duaBaslik = '',
    this.duaArapca = '',
    this.duaOkunus = '',
    this.duaAnlam = '',
    this.duaKaynak = '',
    this.duaKategori = '',
    required this.anahtarKelimeler,
    required this.ikon,
    required this.renk,
  });
}

const List<DailyContent> gunlukIcerikler = [
];

DailyContent bugununIcerigi() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  final all = [...gunlukIcerikler, ...ekIcerikler];
  return all[dayOfYear % all.length];
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// EK ICERIKLER (15 â†’ 25 hedefi)
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
const List<DailyContent> ekIcerikler = [
  DailyContent(
    gunKonu: 'Hidayet',
    ayet: '"Muhakkak ki sen, dogru yola iletiyorsun."',
    ayetKaynak: 'Sura, 52',
    hadis: '"Ben kalpleri ceviren Allaha hamdolsun."',
    hadisKaynak: 'Muslim, Kadir, 17',
    vecize: 'Hidayet, kalbe inen nurdur.',
    vecizeModern: 'Hidayet, kalbe dogan isiktir.',
    vecizeKaynak: 'Lemalar',
    risaleHakikat:
        'Hidayet, kulun secimiyle Rabbin lutfunun bulusmasidir. Kul adim atar, Rabb yol acar.',
    anahtarKelimeler: ['Hidayet', 'Nur', 'Kalp'],
    ikon: Icons.light_mode_rounded,
    renk: Color(0xFFC9A961),
  ),
  DailyContent(
    gunKonu: 'Ihlas',
    ayet: '"De ki: Ben sadece sizin gibi bir insanim."',
    ayetKaynak: 'Kehf, 110',
    hadis: '"Ameller ancak niyetlere goredir."',
    hadisKaynak: 'Buhari, Bedul Vahy, 1',
    vecize: 'Ihlas, ameli Allah icin yapmaktir.',
    vecizeModern: 'Ihlas, isleri sadece Allah icin yapmaktir.',
    vecizeKaynak: 'Ihlas Risalesi',
    risaleHakikat:
        'Ihlas, kalbin tek sahibe yonelisidir. Riya, kalbi bulandirir; ihlas, kalbi berrak tutar.',
    anahtarKelimeler: ['Ihlas', 'Niyet', 'Riza'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFB71C1C),
  ),
  DailyContent(
    gunKonu: 'Cennet',
    ayet: '"Rabbinin magfiretine kosun."',
    ayetKaynak: 'Al-i Imran, 133',
    hadis: '"Cennette gozlerin gormedigi nimetler vardir."',
    hadisKaynak: 'Buhari, Bedul Halk, 8',
    vecize: 'Cennet, imanin neticesidir.',
    vecizeModern: 'Cennet, imanin oduludur.',
    vecizeKaynak: 'Sozler',
    risaleHakikat:
        'Cennet, Rabbin rahmetinin tezahurudur. Kul, Rabbine iman ederse, ahirette onu en guzel karsilik bekler.',
    anahtarKelimeler: ['Cennet', 'Nimet', 'Rahmet'],
    ikon: Icons.park_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  DailyContent(
    gunKonu: 'Hesap',
    ayet: '"Kim zerre kadar iyilik yaparsa onu gorur."',
    ayetKaynak: 'Zilzal, 7-8',
    hadis: '"Kul, kiyamet gununde dort seyden sorguya cekilecek."',
    hadisKaynak: 'Tirmizi, Sifatul Kiyame, 1',
    vecize: 'Hesap, dunyanin sonudur.',
    vecizeModern: 'Hesap, dunyanin bitisidir.',
    vecizeKaynak: 'Sozler, 32. Soz',
    risaleHakikat:
        'Hesap, kulun Rabbine verdigi hesaptir. Her ameli, her sozu, her niyeti kayda gecmistir.',
    anahtarKelimeler: ['Hesap', 'Amel', 'Kiyamet'],
    ikon: Icons.gavel_rounded,
    renk: Color(0xFF0A1F44),
  ),
  DailyContent(
    gunKonu: 'Tevazu',
    ayet: '"Yeryuzunde kibirlenerek yurume."',
    ayetKaynak: 'Lokman, 18',
    hadis: '"Kim Allah icin tevazu gosterirse, Allah onu yuceltir."',
    hadisKaynak: 'Muslim, Birr, 69',
    vecize: 'Tevazu, haddini bilmektir.',
    vecizeModern: 'Tevazu, sinirini bilmektir.',
    vecizeKaynak: 'Lemalar',
    risaleHakikat:
        'Tevazu, kuculmek degil; gercek buyuklugu tanimaktir. Kibir, kulun kendiyle sarhoslugudur.',
    anahtarKelimeler: ['Tevazu', 'Kibir', 'Edep'],
    ikon: Icons.spa_rounded,
    renk: Color(0xFFC9A961),
  ),
  DailyContent(
    gunKonu: 'Af',
    ayet: '"Onlar affetsinler ve hosgorsu olsunlar."',
    ayetKaynak: 'Nur, 22',
    hadis: '"Kim bir muslumanin ayibini orterse, Allah da onun ayibini orter."',
    hadisKaynak: 'Muslim, Birr, 58',
    vecize: 'Af, kalbin en buyuk zaferidir.',
    vecizeModern: 'Affetmek, kalbin en buyuk zaferidir.',
    vecizeKaynak: 'Lemalar',
    risaleHakikat:
        'Af, karsilikli alisverisin otesindedir. Kul affederse, Rabb affeder. Kin, kalbi karartir; af, kalbi nurlandirir.',
    anahtarKelimeler: ['Af', 'Hosgoru', 'Kalp'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  DailyContent(
    gunKonu: 'Dua',
    ayet: '"Bana dua edin, size icabet edeyim."',
    ayetKaynak: 'Mumin, 60',
    hadis: '"Dua, ibadetin ozudur."',
    hadisKaynak: 'Tirmizi, Deavat, 1',
    vecize: 'Dua, kulun Rabbine arzidir.',
    vecizeModern: 'Dua, kulun Rabbine yonelisidir.',
    vecizeKaynak: 'Sozler, 23. Soz',
    risaleHakikat:
        'Dua, Rab ile kul arasinda en samimi koprudur. Kul dilerse, Rabb verir. Dua, kaderi degistirir; Rabbin izniyle.',
    anahtarKelimeler: ['Dua', 'Ibadet', 'Rab'],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFFC9A961),
  ),
  DailyContent(
    gunKonu: 'Cihad',
    ayet: '"Allah yolunda hakkini vererek cihad edin."',
    ayetKaynak: 'Hac, 78',
    hadis: '"En buyuk cihad, nefse karsi olandir."',
    hadisKaynak: 'Tirmizi, Fedailul Cihad, 2',
    vecize: 'Cihad, nefse karsi savastir.',
    vecizeModern: 'Cihad, insanin kendi nefsiyle savasmasidir.',
    vecizeKaynak: 'Lemalar',
    risaleHakikat:
        'Cihad, sadece kilicla degil; kalemle, ilimle, sabirla olur. Kul, nefsine karsi savasirsa, Rabb ona yardim eder.',
    anahtarKelimeler: ['Cihad', 'Nefs', 'Sabir'],
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  DailyContent(
    gunKonu: 'Adalet',
    ayet: '"Muhakkak ki Allah adaleti emreder."',
    ayetKaynak: 'Nahl, 90',
    hadis: '"Hak sahibine hakkini verin."',
    hadisKaynak: 'Buhari, Hibe, 20',
    vecize: 'Adalet, kendiyle yuzlesmektir.',
    vecizeModern: 'Adalet, kendinle yuzlesmektir.',
    vecizeKaynak: 'Isaratul Ijaz',
    risaleHakikat:
        'Adalet, tarafli olmadiginda guven verir. Yonetici, kendi aleyhine karar verse bile adaletten sasmamalidir.',
    anahtarKelimeler: ['Adalet', 'Hak', 'Yonetici'],
    ikon: Icons.gavel_rounded,
    renk: Color(0xFF0A1F44),
  ),
  DailyContent(
    gunKonu: 'Tesekkur',
    ayet: '"Sukrederseniz elbette size nimetimi artiririm."',
    ayetKaynak: 'Ibrahim, 7',
    hadis: '"Insanlara tesekkur etmeyen, Allaha da sukretmez."',
    hadisKaynak: 'Ebu Davud, Edeb, 11',
    vecize: 'Tesekkur, nimeti fark etmektir.',
    vecizeModern: 'Tesekkur, nimeti gormektir.',
    vecizeKaynak: 'Sozler, 27. Soz',
    risaleHakikat:
        'Tesekkur, kalbin sukrudur; sadece dilde kalmaz. Kul tesekkur ederse, Rabb nimetini artirir.',
    anahtarKelimeler: ['Tesekkur', 'Nimet', 'Kul'],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFF2FAE7F),
  ),
];

