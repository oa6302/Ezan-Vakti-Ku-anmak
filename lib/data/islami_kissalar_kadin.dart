import 'package:flutter/material.dart';
import 'islami_kissalar.dart';
import 'islami_kissalar_peygamberler.dart';
import 'islami_kissalar_siyer.dart';

const List<Kissa> kadinSahabilerKissalari = [
  Kissa(
    baslik: 'Hz. Hatice (r.anha): Ilk Destek',
    kaynak: 'Buhari, Bedul Vahy, 1',
    metin: 'Hz. Hatice (r.anha), Islam`in ilk muslumaniydi. Peygamberimiz (s.a.v.) vahiy aldiktan sonra titreyerek eve geldiginde: "Korkma, Allah seni asla utandirmaz" dedi. Butun malini Islam yolunda harcadi. Peygamberimiz (s.a.v.) onun icin: "O bana iman etti, insanlar beni inkar ederken" dedi.',
    hisse: 'Destek, en zor anda yaninda olandir. Hatice, imanin ilk annesidir.',
    anahtarKelimeler: ['Hatice', 'Destek', 'Iman'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Aise (r.anha): Ilmin Annesi',
    kaynak: 'Tirmizi, Menakib, 62',
    metin: 'Hz. Aise (r.anha), 2210 hadis rivayet etti. Sahabe, ona zor sorularini sorardi. "Bizim icin en bilgin kisi" derlerdi. Medine`nin en buyuk muallimesiydi. Kuran, fikih, siir, tib ogrendi. Nesillerin ilim annesidir.',
    hisse: 'Ilim, cinsiyet tanimaz; kalbin nurudur. Aise, Islam tarihinin en buyuk muallimidir.',
    anahtarKelimeler: ['Aise', 'Ilim', 'Hadis'],
    ikon: Icons.menu_book_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Fatima (r.anha): Iffet Ornegi',
    kaynak: 'Tirmizi, Menakib, 60',
    metin: 'Hz. Fatima (r.anha), el degirmeniyle un oguturdu. Bir gun Peygamberimiz (s.a.v.) ona hizmetci vermek istedi. Fatima: "Bana bir dua ogret, hizmetciden hayirlidir" dedi. Peygamberimiz (s.a.v.): "Yatarken 33 subhanallah, 33 elhamdulillah, 34 Allahuekber de" buyurdu.',
    hisse: 'Zahmet, lutuftan ustundur. Kul, Rabbine yaklasmak icin hizmetten vazgecmez.',
    anahtarKelimeler: ['Fatima', 'Iffet', 'Tesbih'],
    ikon: Icons.spa_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Hafsa (r.anha): Kuran Hafizi',
    kaynak: 'Buhari, Fedail, 4',
    metin: 'Hz. Hafsa (r.anha), Kuran`i ezberledi. Peygamberimiz (s.a.v.)in hanimlarindandir. Babasi Hz. Omer (r.a.)`dir. Ebubekir doneminde toplanan Kuran nushasi onun yaninda saklandi. O, Kurani Kerim`in koruyucusudur.',
    hisse: 'Kuran hafizligi, en buyuk sereftir. Hafsa, Kurani koruyan annedir.',
    anahtarKelimeler: ['Hafsa', 'Kuran', 'Hafiz'],
    ikon: Icons.book_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Ümmü Seleme (r.anha): Hikmet',
    kaynak: 'Buhari, Itisam, 2',
    metin: 'Hz. Ümmü Seleme (r.anha), akilli ve tedbirli bir hanimdi. Hudeybiye`de sahabiler uzulunce Peygamberimiz (s.a.v.)e: "Ya Resulullah, kurban kes, ihramdan cik" dedi. Peygamberimiz (s.a.v.) dedigini yapti. Sahabiler de ayni sekilde davrandi. Sorun çözüldü.',
    hisse: 'Hikmet, dogru zamanda dogru sozu soylemektir.',
    anahtarKelimeler: ['Ümmü Seleme', 'Hikmet', 'Tedbir'],
    ikon: Icons.psychology_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Zeyneb (r.anha) bint Cahs (r.anha): Tevazu',
    kaynak: 'Ahzab, 37',
    metin: 'Hz. Zeyneb (r.anha), Peygamberimiz (s.a.v.)in hanimiydi. El isi yaparak kazandigini fakirlere dagitirdi. "Ben Allah`a dua ederim, o bana verir; ben de dagitirim" derdi. Peygamberimiz (s.a.v.) onun icin: "Zeyneb, en hayirli hanimdir" buyurdu.',
    hisse: 'Veren el, alan elden ustundur. Tevazu, malin gercek sahibini hatirlamaktir.',
    anahtarKelimeler: ['Zeyneb', 'Tevazu', 'Infak'],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Sümeyye (r.anha): Ilk Sehid',
    kaynak: 'Ibn Hisam, Siret',
    metin: 'Hz. Sumeyye (r.anha), Islam`in ilk sehididir. Ebu Cehil onu kizgin kumlara yatirdi, iskence etti. Yagmur yagdi, azap biraz hafifledi ama kalbi imanla dolu kaldi. Bir mizrak saplandi; Sumeyye sehid oldu. Adi, Islam tarihine yazildi.',
    hisse: 'Imanin ilk sehidi bir kadindir. Feda, cinsiyet tanimaz; kalp tanir.',
    anahtarKelimeler: ['Sumeyye', 'Sehadet', 'Iman'],
    ikon: Icons.local_florist_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Nesibe (r.anha) (Ümmü Umare): Uhud',
    kaynak: 'Ibn Sad, Tabakat',
    metin: 'Uhud`da muslumanlar dagilinca Hz. Nesibe (r.anha), Peygamberimiz (s.a.v.)in etrafinda savasti. Kiliç salladi, ok atti, yaralandi. Peygamberimiz (s.a.v.): "Bugun Nesibe`nin makamini herkes gormeli" buyurdu. Onun evine bereket indi.',
    hisse: 'Cesaret, kadin erkek tanimaz. Nesibe, savas meydaninda kahraman oldu.',
    anahtarKelimeler: ['Nesibe', 'Uhud', 'Cesaret'],
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Rüveyde (r.anha) (Ümmü Habibe)',
    kaynak: 'Ahzab, 6',
    metin: 'Hz. Rüveyde (r.anha), Peygamberimiz (s.a.v.)in hanimiydi. Babasi Ebu Sufyan, Mekke`nin lideriydi. Rüveyde, Islam`a ilk girenlerdendi. Habesistan`a hicret etti, sonra Medine`ye dondu. Babasina ragmen imanindan donmedi.',
    hisse: 'Hidayet, neseple degil, kalple olur. Rüveyde, babasina ragmen imani secti.',
    anahtarKelimeler: ['Rüveyde', 'Hicret', 'Iman'],
    ikon: Icons.flight_takeoff_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Safiyye (r.anha): Soy Asaleti',
    kaynak: 'Buhari, Menakib, 13',
    metin: 'Hz. Safiyye (r.anha), Yahudi lideri Huyey`in kiziydi. Hayber`de esir alindi, musluman oldu. Peygamberimiz (s.a.v.) onu azat etti, hanimi yapti. Bir gun birisi onun Yahudi kokenini ima etti. Peygamberimiz (s.a.v.): "Sen peygamberin kizi olmayi secmissin" buyurdu.',
    hisse: 'Asalet, soy degil; imandir. Safiyye, imani soyuna tercih etti.',
    anahtarKelimeler: ['Safiyye', 'Asalet', 'Iman'],
    ikon: Icons.diamond_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Meymune (r.anha): Son Hanim',
    kaynak: 'Buhari, Nikah, 109',
    metin: 'Hz. Meymune (r.anha), Peygamberimiz (s.a.v.)in son hanimiydi. Mekke yaknlarinda vefat etti. Vefat ettiginde yaninda 80.000 dirhem vardi, hepsini dagitti. Kefenini bile sade tuttu. "Ben Rabbime sade gideyim" dedi.',
    hisse: 'Dunyadan sade gecmek, ahirete zengin gitmektir. Meymune, sade yasadi.',
    anahtarKelimeler: ['Meymune', 'Zuhd', 'Ahret'],
    ikon: Icons.wb_twilight_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Cüveyriye (r.anha): Bereket',
    kaynak: 'Buhari, Megazi, 43',
    metin: 'Hz. Cüveyriye (r.anha), Beni Mustalik esirlerindendi. Peygamberimiz (s.a.v.) onu azat etti, hanimi yapti. Sahabiler: "Peygamberimiz (s.a.v.)in akrabasi oldu, esirleri serbest birakalim" dediler. Yuzlerce esir serbest kaldi. Onun vesilesiyle bir kavim kurtuldu.',
    hisse: 'Bir iyilik, bin iyiligi dogurur. Cüveyriye, bir kavmin kurtulusuna vesile oldu.',
    anahtarKelimeler: ['Cüveyriye', 'Bereket', 'Hurriyet'],
    ikon: Icons.auto_awesome_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Ümmü Eymen (r.anha): Dadı',
    kaynak: 'Buhari, Menakib, 12',
    metin: 'Hz. Ümmü Eymen (r.anha), Peygamberimiz (s.a.v.)in dadisiydi. Onu cocuklugunda buyuttu. Sonra Medine`ye hicret etti. Peygamberimiz (s.a.v.) onun icin: "Bu, benim annemden sonra annemdir" buyurdu. Vefat ettiginde Peygamberimiz (s.a.v.) kabrine indi.',
    hisse: 'Hizmet, en buyuk ibadettir. Ümmü Eymen, imanin annesi oldu.',
    anahtarKelimeler: ['Ümmü Eymen', 'Hizmet', 'Vefa'],
    ikon: Icons.family_restroom_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Esma (r.anha) bint Ebu Bekir (r.anha)',
    kaynak: 'Buhari, Menakib, 47',
    metin: 'Hz. Esma (r.anha), Hz. Ebubekir (r.a.)`in kizi, Hz. Aise (r.anha)`nin kiz kardesiydi. Hicret sirasinda Peygamberimiz (s.a.v.) ve babasina yiyecek tasidi. Sevr magarasina giden yolu kapatmak icin kemerini ikiye boldu. "Zatun-nitakayn" (iki kemerli) diye anildi.',
    hisse: 'Fedakarlik, en zor anda ortaya cikar. Esma, kemerini bile paylasti.',
    anahtarKelimeler: ['Esma', 'Fedakarlik', 'Hicret'],
    ikon: Icons.sports_martial_arts_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Ümmü Süleym (r.anha): Cennet Mujdesi',
    kaynak: 'Buhari, Nikah, 35',
    metin: 'Hz. Ümmü Süleym (r.anha), Medine`nin ilk musluman kadinlarindandi. Ogullarindan birini kaybettiginde: "Ey Allah`im, bu cocugu bana sen verdin, simdi sen aldin. Bana sabir ver" dedi. Sonra kocasina hamile kaldi. Peygamberimiz (s.a.v.): "Ummu Suleym`e cenneti mujdeleyin" buyurdu.',
    hisse: 'Sabir, en zor anda bile Rabbe siginmaktir. Ümmü Süleym, cennetle mujdelendi.',
    anahtarKelimeler: ['Ümmü Süleym', 'Sabir', 'Cennet'],
    ikon: Icons.park_rounded,
    renk: Color(0xFF2FAE7F),
  ),
];

/// Tum kissalar (60 + 15 = 75)
List<Kissa> tumKissalar4() {
  return [
    ...islamiKissalar,
    ...peygamberKissalari,
    ...siyerKissalari,
    ...kadinSahabilerKissalari,
  ];
}

/// Bugunun kissasi - 75 havuzdan
Kissa bugununKissasi4() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  final all = tumKissalar4();
  return all[dayOfYear % all.length];
}