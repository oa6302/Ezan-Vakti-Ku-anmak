import 'package:flutter/material.dart';
import 'islami_kissalar.dart';

/// Peygamberler doneminden 15 kissa.
const List<Kissa> peygamberKissalari = [
  Kissa(
    baslik: 'Hz. Adem (a.s.) ve Tevbe',
    kaynak: 'Bakara, 37; Araf, 23',
    metin: 'Hz. Adem (a.s.), yasak meyveyi yedikten sonra yeryuzune indirildi. Ama Yuce Allah onu terk etmedi. Adem, Rabbinden kelimeler aldi: "Rabbimiz, biz kendimize zulmettik. Eger bizi bagislamazsan, mutlaka ziyana ugrayanlardan oluruz" dedi. Rab, tevbesini kabul etti.',
    hisse: 'Insan hata yapar; ama tevbe kapisi her zaman acik. Dusmek ayip degil, kalkmamak ayiptir.',
    anahtarKelimeler: ['Tevbe', 'Adem', 'Magfiret'],
    ikon: Icons.eco_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Nuh (a.s.) ve Gemi',
    kaynak: 'Hud, 37-48',
    metin: 'Hz. Nuh (a.s.) 950 yil kavmini Islama davet etti. Kavmi alay etti. Nuh, Rabbinden gemi yapmasini istedi. Gemi su uzerinde yuzerken ogul, babasina: "Ben daglara siginacagim" dedi. Nuh: "Bugun Allahin emrinden ancak O`nun merhamet ettigi kurtulur" dedi. Ogul boguldu.',
    hisse: 'Hidayet, neseple degil; imanla olur. Nuh`un oglu, Nuh`un imanini secmedi; boylece helak oldu.',
    anahtarKelimeler: ['Tufan', 'Gemi', 'Hidayet'],
    ikon: Icons.sailing_rounded,
    renk: Color(0xFF1B5E7A),
  ),
  Kissa(
    baslik: 'Hz. Ibrahim (a.s.) ve Ates',
    kaynak: 'Enbiya, 68-70',
    metin: 'Hz. Ibrahim (a.s.), putlari kirdigi icin Nemrut onu atese attirdi. Ates bir anda yesil bir bahceye dondu. Ibrahim: "Rabbim bana kafidir" dedi. Yuce Allah atese: "Ey ates, Ibrahim`e serin ve selamet ol" buyurdu.',
    hisse: 'Kul Rabbine guvenirse, ates bile bahceye doner. Korku, imanla yok olur.',
    anahtarKelimeler: ['Ates', 'Ibrahim', 'Tevhid'],
    ikon: Icons.local_fire_department_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Ismail (a.s.) ve Kurban',
    kaynak: 'Saffat, 102-107',
    metin: 'Hz. Ibrahim (a.s.) ruyasinda oglu Ismail`i kurban etmesi emredildi. Ismail: "Babacigim, sana emredileni yap; insallah beni sabredenlerden bulacaksin" dedi. Tam o anda Yuce Allah bir koc kurbayin gonderdi. Ismail kurtuldu.',
    hisse: 'Teslimiyet, en zor anda bile "Rabbim en iyisini bilir" diyebilmektir.',
    anahtarKelimeler: ['Kurban', 'Teslimiyet', 'Ismail'],
    ikon: Icons.pets_rounded,
    renk: Color(0xFF6B4A2A),
  ),
  Kissa(
    baslik: 'Hz. Yakub (a.s.) ve Sabir',
    kaynak: 'Yusuf, 83-86',
    metin: 'Hz. Yakub (a.s.), oglu Yusuf`u kaybetti. Yillarca agladi, gozleri kor oldu. Ogullari: "Yusuf`u anmayi birak" dediler. Yakub: "Ben tasa ve huznu sadece Allaha arz ederim. Sizin bilmediginizi Allah`tan biliyorum" dedi. Sonunda Yusuf`a kavustu.',
    hisse: 'Sabir, kaybetmemek degil; kaybederken de Rabbe siginmaktir.',
    anahtarKelimeler: ['Sabir', 'Yakub', 'Hasret'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Yusuf (a.s.) ve Kuyu',
    kaynak: 'Yusuf, 9-20',
    metin: 'Kardesleri Hz. Yusuf (a.s.)`u kuyuya attilar. Kervan onu Misir`a goturdu, kole olarak satti. Zuleyha iftirada bulundu, Yusuf zindana atildi. Ama Rabb`i unutmayan Yusuf, Misir`in hazinedari oldu. Kardeslerini affetti: "Bugun size kizma yok" dedi.',
    hisse: 'Haksizliga ugrayan kul, Rabbine siginirsa, o haksizlik onun yukselmesine vesile olur.',
    anahtarKelimeler: ['Yusuf', 'Zindan', 'Af'],
    ikon: Icons.water_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Eyyub (a.s.) ve Sabir',
    kaynak: 'Enbiya, 83-84',
    metin: 'Hz. Eyyub (a.s.)`un mallari gitti, cocuklari vefat etti, kendisi agir hastalandi. Yillarca sabretti. Hic isyan etmedi. Sonunda: "Rabbim, bana zarar dokundu; sen merhametlilerin en merhametlisisin" dedi. Yuce Allah onu sifaya kavusturdu.',
    hisse: 'Sabir, sikintinin kalkmasini beklemek degil; sikintinin icinde Rabbe yakin olmaktir.',
    anahtarKelimeler: ['Sabir', 'Hastalik', 'Sifa'],
    ikon: Icons.healing_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Musa (a.s.) ve Deniz',
    kaynak: 'Suara, 63-66',
    metin: 'Hz. Musa (a.s.), Israilogullarini Misir`dan cikardi. Firavun ordusuyla pesine dustu. Denize vardiklarinda kavmi: "Yakalandik" dedi. Musa: "Hayir, Rabbim benimle beraber, bana yol gosterecektir" dedi. Deniz yarildi, Israilogullari kurtuldu, Firavun boguldu.',
    hisse: 'Cikissiz gibi gorunen anda, kul Rabbe guvenirse, deniz yol olur.',
    anahtarKelimeler: ['Musa', 'Firavun', 'Kurtulus'],
    ikon: Icons.waves_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Harun (a.s.) ve Kardeslik',
    kaynak: 'Taha, 29-36',
    metin: 'Hz. Musa (a.s.), kardesi Harun`u kendine vezir istedi. Harun, Musa`nin yaninda Firavun`a gitti, Israilogullarina rehberlik etti. Kardesler birlikte mucadele etti. Inananlar, Harun`un dilinden Tevhid`i duydu.',
    hisse: 'Kardeslik, ortak dava icin omuz omuza olmaktir.',
    anahtarKelimeler: ['Kardeslik', 'Harun', 'Musa'],
    ikon: Icons.people_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Davud (a.s.) ve Adalet',
    kaynak: 'Sad, 21-26',
    metin: 'Hz. Davud (a.s.), hem padisah hem peygamberdi. Bir gun iki kisi davasini ona getirdi. Davud hukmu verdi. Sonra anladi ki bu bir imtihandi. Rabbinden af diledi, secdeye kapandi. Yuce Allah onu bagisladi ve: "Ey Davud, biz seni yeryuzunde halife yaptik; insanlar arasinda adaletle hukmet" buyurdu.',
    hisse: 'Adalet, tarafli olmadiginda guven verir. Yonetici, Rabbine hesap verecegini bilmelidir.',
    anahtarKelimeler: ['Adalet', 'Davud', 'Halife'],
    ikon: Icons.balance_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Suleyman (a.s.) ve Karinca',
    kaynak: 'Neml, 18-19',
    metin: 'Hz. Suleyman (a.s.)`in ordusu karinca vadisine geldi. Bir karinca: "Yuvalariniza girin, Suleyman ve ordusu farkinda olmadan sizi ezmesin" dedi. Suleyman bu sozu duydu ve gulumserdi: "Rabbim, beni nimetlerine sukredebilecegim sekilde yonlendir" dedi.',
    hisse: 'Yonetici, en kucuk canlinin bile hakkini gozetmelidir. Suleyman, karincanin sesini duydu.',
    anahtarKelimeler: ['Suleyman', 'Karinca', 'Hikmet'],
    ikon: Icons.bug_report_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Yunus (a.s.) ve Balik',
    kaynak: 'Saffat, 139-144',
    metin: 'Hz. Yunus (a.s.), kavmini birakip gitti. Gemiye bindi, kura cikti, denize atildi. Balik onu yuttu. Karanlikta: "Senden baska ilah yok, sen yucesin, ben zalimlerden oldum" dedi. Yuce Allah onu kurtardi.',
    hisse: 'Zorluk, kulun Rabbe donecegi yerdir. Yunus`un kurtulusu, tevbesiyle geldi.',
    anahtarKelimeler: ['Yunus', 'Balik', 'Tevbe'],
    ikon: Icons.set_meal_rounded,
    renk: Color(0xFF1B5E7A),
  ),
  Kissa(
    baslik: 'Hz. Zekeriyya (a.s.) ve Dua',
    kaynak: 'Meryem, 2-11',
    metin: 'Hz. Zekeriyya (a.s.), yaslandiginda cocugu olmasi icin Rabbe yalvardi. "Rabbim, bana katindan temiz bir nesil bagisla" dedi. Yuce Allah ona Yahya`yi mujdeledi. Zekeriyya: "Rabbim, bana alamet ver" dedi. Alamet: uc gun konusamamakti.',
    hisse: 'Dua, imkansiz gorunen anda bile Rabbe siginmaktir. Allah, kulunun duasini duyar.',
    anahtarKelimeler: ['Dua', 'Zekeriyya', 'Mucize'],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Yahya (a.s.) ve Sehadet',
    kaynak: 'Meryem, 12-15',
    metin: 'Hz. Yahya (a.s.), kucuk yasta hikmet verildi. Kitabi kuvvetle tuttu. Anne-babasina iyi davrandi. Zamanin zalim hukumdari, iffetli bir kadini istedi. Yahya: "Bu haramdir" dedi. Hukumdar onu sehid etti. Yahya, bu yolda canini verdi.',
    hisse: 'Hakki soylemek, bazen cana mal olur. Yahya, hakk`i savunmaktan vazgecmedi.',
    anahtarKelimeler: ['Sehadet', 'Yahya', 'Iffet'],
    ikon: Icons.local_florist_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Isa (a.s.) ve Mucizeler',
    kaynak: 'Al-i Imran, 45-59',
    metin: 'Hz. Isa (a.s.), babasiz dunyaya geldi. Besikte konustu. Annesine: "Ben Allah`in kuluyum, bana kitap verdi, beni peygamber yapti" dedi. Oluleri diriltti, korleri iyilestirdi, camurdan kus yapti. Sonunda Yuce Allah onu kendi katina yukseltti.',
    hisse: 'Mucize, Rabbin izniyle olur. Kul ne kadar buyuk olsa da, Rabbin kulu olmaya devam eder.',
    anahtarKelimeler: ['Isa', 'Mucize', 'Meryem'],
    ikon: Icons.auto_awesome_rounded,
    renk: Color(0xFFC9A961),
  ),
];

/// Tum kissalar (mevcut 30 + yeni 15 = 45)
List<Kissa> tumKissalar() {
  return [...islamiKissalar, ...peygamberKissalari];
}

/// Bugunun kissasi - toplam havuzdan secilir
Kissa bugununKissasi2() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  final all = tumKissalar();
  return all[dayOfYear % all.length];
}