import 'package:flutter/material.dart';
import 'islami_kissalar.dart';
import 'islami_kissalar_peygamberler.dart';

/// Son Peygamber doneminden 15 kissa.
const List<Kissa> siyerKissalari = [
  Kissa(
    baslik: 'Hira Magarasinda Ilk Vahiy',
    kaynak: 'Buhari, Bedul Vahy, 1',
    metin: 'Peygamberimiz (s.a.v.) kirk yasinda Hira magarasinda inzivaya cekildi. Bir gece Cebrail geldi ve "Oku!" dedi. Peygamberimiz (s.a.v.): "Ben okuma bilmem" dedi. Cebrail onu uc kez sikti, sonra "Yaratan Rabbinin adiyla oku" ayetini okudu. Peygamberimiz (s.a.v.) titreyerek eve dondu: "Beni ortun" dedi.',
    hisse: 'Vahiy, insanligin karanligini aydinlatan ilk isiktir. Okumak, imanin baslangicidir.',
    anahtarKelimeler: ['Vahiy', 'Hira', 'Ikra'],
    ikon: Icons.menu_book_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Hatice (r.anha) ve Ilk Destek',
    kaynak: 'Buhari, Bedul Vahy, 1',
    metin: 'Peygamberimiz (s.a.v.) titreyerek eve geldiginde Hz. Hatice (r.anha) onu sakinlestirdi: "Korkma! Allah seni asla utandirmaz. Sen akrabalarini gozetirsin, dogru soylersin, yolda kalana yardim edersin." Sonra amcasinin oglu Varaka`ya goturdu. Varaka: "Bu, Musa`ya gelen Namus`tur" dedi.',
    hisse: 'Es, en yakin yol arkadasidir. Ilk destek, en kiymetli destektir.',
    anahtarKelimeler: ['Hatice', 'Destek', 'Vahiy'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Ilk Muslumanlar',
    kaynak: 'Ibn Hisam, Siret',
    metin: 'Islam daveti gizli basladi. Ilk musluman Hz. Hatice (r.anha), sonra Hz. Ebubekir (r.a.), Hz. Ali (r.a.), Zeyd bin Harise oldu. Hz. Ebubekir (r.a.), daveti yaymaya basladi: Osman, Talha, Zubeyr, Abdurrahman bin Avf musluman oldu. Ilk muslumanlar, toplumun en guvenilir kisileriydi.',
    hisse: 'Hakki kabul eden, toplumun en erdemli kisileridir. Imanda ilk olmak, en buyuk sereftir.',
    anahtarKelimeler: ['Ilk Muslumanlar', 'Ebubekir', 'Davet'],
    ikon: Icons.group_add_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Boykot Yillari',
    kaynak: 'Ibn Hisam, Siret',
    metin: 'Kureys, Muslumanlara 3 yil boykot uyguladi. Hasimogullari vadisine cekildi. Yiyecek bulunmuyordu, cocuklar acliktan aglardi. Peygamberimiz (s.a.v.) ve ailesi bu zulme sabretti. Sonunda Kureys`in kendi vicdani boykotu kaldirdi. Aktif direnis, sabirla olur.',
    hisse: 'Zulme sabir, en buyuk direnistir. Boykot gunleri, imanin sinaviydi.',
    anahtarKelimeler: ['Boykot', 'Sabir', 'Zulm'],
    ikon: Icons.hourglass_bottom_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Taif Yolculugu',
    kaynak: 'Buhari, Bedul Vahy',
    metin: 'Peygamberimiz (s.a.v.), Mekke`de teblige izin bulamayinca Taif`e gitti. Taif liderleri onu taslatti. Cocuklar arkasindan tas attilar. Peygamberimiz (s.a.v.) ayaklari kan icinde Taif`ten cikti. Cebrail: "Emret, Taif`i yerle bir edeyim" dedi. Peygamberimiz (s.a.v.): "Hayir, belki nesillerinden iman edenler olur" dedi.',
    hisse: 'Teblig, en zor anda bile beddua degil, dua ve sabirdir.',
    anahtarKelimeler: ['Taif', 'Sabir', 'Teblig'],
    ikon: Icons.terrain_rounded,
    renk: Color(0xFF6B4A2A),
  ),
  Kissa(
    baslik: 'Isra ve Mirac',
    kaynak: 'Isra, 1',
    metin: 'Peygamberimiz (s.a.v.) bir gece Mescid-i Haram`dan Mescid-i Aksa`ya goturuldu. Oradan Sidretul Munteha`ya yukseltildi. Bes vakit namaz farz kilindi. Donuste Kureys: "Inanmayiz" dedi. Hz. Ebubekir (r.a.): "O soylediyse dogrudur" dedi. O gunden sonra "Siddik" oldu.',
    hisse: 'Mucize, iman eden icin delil; inkar eden icin bahanedir. Ebubekir, tasdik etti.',
    anahtarKelimeler: ['Mirac', 'Namaz', 'Siddik'],
    ikon: Icons.auto_awesome_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Akabe Biatleri',
    kaynak: 'Buhari, Menakib, 26',
    metin: 'Medine`den gelen heyetler Akabe`de Peygamberimiz (s.a.v.)le bulustu. Birinci Akabe`de 12 kisi biat etti. Ikinci Akabe`de 73 kisi. Peygamberimiz (s.a.v.): "Beni koruyacaginiza dair soz verin" dedi. Medineliler: "Bizden ne istersen veririz" dediler. Hicretin yolu acildi.',
    hisse: 'Biat, soz vermekten otedir; canla, malla, kalple baglanmaktir.',
    anahtarKelimeler: ['Akabe', 'Biat', 'Medine'],
    ikon: Icons.handshake_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hicret Yolculugu',
    kaynak: 'Buhari, Menakib, 45',
    metin: 'Peygamberimiz (s.a.v.) ve Hz. Ebubekir (r.a.) Medine`ye hicret etti. Kureys onlari ariyordu. Sevr Magarasina saklandilar. Ebubekir: "Yakalanirsak?" dedi. Peygamberimiz (s.a.v.): "Uzulme, Allah bizimle beraber" dedi. Bir guvercin yumurtladi, bir orumcek ag ordu. Mucize, Rabb`in korumasiydi.',
    hisse: 'Hicret, yeri degistirmek degil; kalbi Rabbe baglamaktir.',
    anahtarKelimeler: ['Hicret', 'Sevr', 'Ebubekir'],
    ikon: Icons.flight_takeoff_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Mescid-i Nebevi Insasi',
    kaynak: 'Buhari, Salat, 48',
    metin: 'Medine`ye varinca ilk is Mescid-i Nebevi`yi insa etti. Tuğlalari Peygamberimiz (s.a.v.) de tasidi. Sahabiler: "Ya Resulullah, sen yorulma" dediler. Peygamberimiz (s.a.v.): "Ben de sizinle calisirim" dedi. Mescid, hurma kütükleriyle yapildi. Suffa ehli ilim ogrendi.',
    hisse: 'Liderlik, emretmek degil; omuz omuza calismaktir. Mescid, ilk musluman universitesi oldu.',
    anahtarKelimeler: ['Mescid', 'Insaa', 'Liderlik'],
    ikon: Icons.mosque_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Bedir Savasi',
    kaynak: 'Al-i Imran, 123-125',
    metin: 'Bedir`de 313 musluman, 1000 müsrike karsi savasti. Muslumanlar az, müsrikler kalabalikti. Peygamberimiz (s.a.v.): "Allahim, bize yardim et" diye dua etti. Yuce Allah bin melekle yardim etti. Muslumanlar kazandi. Ayet: "Bedir`de siz zayifken Allah size yardim etti."',
    hisse: 'Zafer, kalabalikla degil, imanla ve Allah`in yardimiyla gelir.',
    anahtarKelimeler: ['Bedir', 'Zafer', 'Melek'],
    ikon: Icons.flag_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Uhud Sehadetleri',
    kaynak: 'Al-i Imran, 121-128',
    metin: 'Uhud`da muslumanlar baslangicta ustun oldu. Ama okcularin yerinden ayrilmasiyla duzen bozuldu. Hz. Hamza (r.a.) sehid edildi. Peygamberimiz (s.a.v.) yaralandi. Musab bin Umeyr sehid oldu. Ama muslumanlar sabretti, geri cekilmedi. Ayet: "Sabredin, muhakkak ki Allah sabredenlerle beraberdir."',
    hisse: 'Yenilgi gorunse de, sabreden galip gelir. Uhud, sabrin ve fedakarligin dersidir.',
    anahtarKelimeler: ['Uhud', 'Hamza', 'Sabir'],
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hendek Savunmasi',
    kaynak: 'Ahzab, 9-25',
    metin: 'Mekke müsrikleri 10.000 kisilik orduyla Medine`ye saldirdi. Sahabe Selman-i Farisi`nin teklifiyle Medine`nin cevresine hendek kazildi. Kusatma bir ay surdu. Soguk, aclik, yorgunluk... Sonunda Yuce Allah bir firtina gonderdi. Dusman ordusu dagildi.',
    hisse: 'Tedbir, tevekkulun bir parcasidir. Hendek, aklin ve imanin birlikteligidir.',
    anahtarKelimeler: ['Hendek', 'Selman', 'Tedbir'],
    ikon: Icons.foundation_rounded,
    renk: Color(0xFF1B5E7A),
  ),
  Kissa(
    baslik: 'Hudeybiye Antlasmasi',
    kaynak: 'Fetih, 1-3',
    metin: 'Peygamberimiz (s.a.v.) umre icin Mekke`ye gitti. Kureys izin vermedi. Hudeybiye`de antlasma yapildi. Sartlar muslumanlarin aleyhine gorundu. Sahabiler uzuldu. Ama Yuce Allah: "Muhakkak biz sana apaçik bir fetih verdik" buyurdu. Iki yil sonra Mekke fethedildi.',
    hisse: 'Bazen gorunen yenilgi, gercek zaferdir. Sabir, en buyuk kazanci getirir.',
    anahtarKelimeler: ['Hudeybiye', 'Fetih', 'Sabir'],
    ikon: Icons.description_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Mekke Fethi',
    kaynak: 'Buhari, Megazi, 52',
    metin: 'Peygamberimiz (s.a.v.) 10.000 kisilik orduyla Mekke`ye girdi. Kabe`yi putlardan temizledi. Kureys korkuyordu. Peygamberimiz (s.a.v.): "Bugun size kizginlik yok. Gidin, serbestsiniz" dedi. Kan dokulmedi, intikam alinmadi. Mekke, Islama kavustu.',
    hisse: 'Gerçek zafer, intikam degil; affetmektir. Fetih, kalpleri kazanmaktir.',
    anahtarKelimeler: ['Fetih', 'Af', 'Kabe'],
    ikon: Icons.emoji_events_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Veda Hutbesi',
    kaynak: 'Buhari, Menasik, 132',
    metin: 'Peygamberimiz (s.a.v.) veda haccinda 100.000 sahabiye hitap etti: "Ey insanlar! Kanlariniz, mallariniz, namuslariniz haramdir. Rabbiniz birdir, babaniz birdir. Arab`in Arap olmayana ustunlugu yoktur; ustunluk takvadadir. Size iki emanet birakiyorum: Kuran ve Sunnet."',
    hisse: 'Veda hutbesi, insan haklarinin ilk evrensel beyannamesidir. Takva, ustunluk ölçüsüdür.',
    anahtarKelimeler: ['Veda', 'Hutbe', 'Takva'],
    ikon: Icons.record_voice_over_rounded,
    renk: Color(0xFF0A1F44),
  ),
];

/// Tum kissalar (45 + 15 = 60)
List<Kissa> tumKissalar3() {
  return [...islamiKissalar, ...peygamberKissalari, ...siyerKissalari];
}

/// Bugunun kissasi - 60 havuzdan secilir
Kissa bugununKissasi3() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  final all = tumKissalar3();
  return all[dayOfYear % all.length];
}