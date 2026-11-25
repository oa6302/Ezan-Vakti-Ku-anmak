/// Risale-i Nur havuzu — 30 seckin pasaj.
/// Kaynak: Lem'alar, Sozler, Mektubat, Sualar, Isaratul-Icaz,
/// Mesnevi-i Nuriye, Emirdag Lahikasi.
class Risale {
  final String baslik;
  final String metin;
  final String kaynak;
  final String kategori;
  final String emoji;
  const Risale({
    required this.baslik,
    required this.metin,
    required this.kaynak,
    required this.kategori,
    this.emoji = '📖',
  });
}

const List<Risale> risaleHavuzu = [
  // ═══ TEVHID ═══
  Risale(
    baslik: 'Tevhid ve Vahdet',
    metin:
        'Vahdet, kesretin aynasidir. Her sey, Vahid-i Ehadin muhrunu tasir. Kainattaki butun intizam, birlik ve duzen, bir olan Allahin eseridir.',
    kaynak: 'Lemalar, 22. Lema',
    kategori: 'Tevhid',
    emoji: '☝️',
  ),
  Risale(
    baslik: 'Kainatin Dili',
    metin:
        'Her sey, lisan-i hal ile Rabbini tesbih eder. Yaprak, cicek, kus, dag, deniz — hepsi O\'nu anar. Insan, bu ilahi koroya katilmak icin yaratilmistir.',
    kaynak: 'Sozler, 33. Soz',
    kategori: 'Tevhid',
    emoji: '🌿',
  ),

  // ═══ NUBUVVET ═══
  Risale(
    baslik: 'Peygamberlik Hakikati',
    metin:
        'Nubuvvet, insanligin en buyuk nimetidir. Nebi, insanliga Rabbini tanittirir. Onsuz insan, karanlikta yol arar. Onun nuruyla yollar aydinlanir.',
    kaynak: 'Mektubat, 19. Mektup',
    kategori: 'Nubuvvet',
    emoji: '🌙',
  ),
  Risale(
    baslik: 'Sunnnetin Onemi',
    metin:
        'Sunnet, Islamin temelidir. Onu terk eden, dine yabancilasir. Her sunnet, bir nurdur; her bidat, bir zulumat.',
    kaynak: 'Lemalar, 11. Lema',
    kategori: 'Nubuvvet',
    emoji: '🕌',
  ),

  // ═══ HASIR (Ahiret) ═══
  Risale(
    baslik: 'Haşir ve Ahiret',
    metin:
        'Kabir, ya cennet bahcesi ya cehennem cukurudur. Olum, bir kapidan gecmektir. Onu hatirlayan, dunyaya baglanmaz; onu unutan, sonsuzluga hazirlik yapmaz.',
    kaynak: 'Lemalar, 27. Lema',
    kategori: 'Hasir',
    emoji: '🌅',
  ),
  Risale(
    baslik: 'Cennet Ozlemi',
    metin:
        'Cennet, hicbir gozun gormedigi, hicbir kulagin duymadigi, hicbir kalbin hatirlamadigi nimetlerin yurdudur. Ona talip olan, dunyaya aldanmaz.',
    kaynak: 'Sozler, 28. Soz',
    kategori: 'Hasir',
    emoji: '🌺',
  ),

  // ═══ IBADET ═══
  Risale(
    baslik: 'Namaz ve Mirac',
    metin:
        'Namaz, muminin miracidir. Kul, secdeye varinca Rabbine en yakin olur. Ibadetin zorluguna bakma; kabul edilme sevincine bak.',
    kaynak: 'Sozler, 9. Soz',
    kategori: 'Ibadet',
    emoji: '🕋',
  ),
  Risale(
    baslik: 'Ibadetin Ozunde Ihlas',
    metin:
        'Ibadetin ruhu ihlassir. Ihlassiz amel, ruhsuz bedendir. Kim riyakarliktan uzak durursa, az ameli bile cok kazanir.',
    kaynak: 'Lemalar, 20. Lema',
    kategori: 'Ibadet',
    emoji: '💎',
  ),
  Risale(
    baslik: 'Zikir ve Huzur',
    metin:
        'Zikir, kalbin gidasidir. Zikirsiz kalp, ac kalir. Kalpler, ancak Allahi anmakla huzur bulur.',
    kaynak: 'Mektubat, 28. Mektup',
    kategori: 'Ibadet',
    emoji: '📿',
  ),

  // ═══ AHLAK ═══
  Risale(
    baslik: 'Guzel Ahlak',
    metin:
        'Guzel ahlak, imanin meyvesidir. Ahlaki guzel olmayanin imani da zayiftir. Muminin mihengi, ahlakidir.',
    kaynak: 'Mektubat, 22. Mektup',
    kategori: 'Ahlak',
    emoji: '🌸',
  ),
  Risale(
    baslik: 'Sidk ve Dogruluk',
    metin:
        'Sidk, muminin kalesidir. Yalan ise nifakin kapisidir. Kim dogru olursa, Rabbine yaklasir; kim yalan soylerse, seytana yaklasir.',
    kaynak: 'Lemalar, 7. Lema',
    kategori: 'Ahlak',
    emoji: '⚖️',
  ),
  Risale(
    baslik: 'Husn-u Zan',
    metin:
        'Husn-u zan, muminin siaridir. Mumin, kardesini hayirla anar. Su-i zan, kalbi karartir; husn-u zan, kalbi nurlandirir.',
    kaynak: 'Mektubat, 21. Mektup',
    kategori: 'Ahlak',
    emoji: '💚',
  ),

  // ═══ SABIR ═══
  Risale(
    baslik: 'Sabir ve Musibet',
    metin:
        'Ey sabirsiz ruh! Bil ki, musibetler, buyuk makamlara ulasmak icin birer merdivendir. Hz. Eyyub (a.s.) gibi sabredenler, sonunda hem dunyada hem ahirette kazancli cikmislardir.',
    kaynak: 'Lemalar, 2. Lema',
    kategori: 'Sabir',
    emoji: '🌊',
  ),
  Risale(
    baslik: 'Sabir Aynasi',
    metin:
        'Sabir, aciyi yutar; ama yuregi buyutur. Hicbir sabir bosa gitmez. Sabir, zaferin anahtaridir; acele, hezimetin kapisidir.',
    kaynak: 'Lemalar, 2. Lema',
    kategori: 'Sabir',
    emoji: '🗝️',
  ),

  // ═══ SUKUR ═══
  Risale(
    baslik: 'Sukur ve Ziyadeleşme',
    metin:
        'Sukur, nimetin ziyadelesmesine vesiledir. Sukreden, nimetin kadrini bilir; nankor ise, nimeti kaybeder.',
    kaynak: 'Sozler, 25. Soz',
    kategori: 'Sukur',
    emoji: '🌻',
  ),
  Risale(
    baslik: 'Kanaat Hazinesi',
    metin:
        'Kanaat, tukenmez bir hazinedir. Iktisat eden, yokluktan korkmaz. Israf ise bereketi kacirir.',
    kaynak: 'Lemalar, 19. Lema',
    kategori: 'Sukur',
    emoji: '💛',
  ),

  // ═══ IHLAS ═══
  Risale(
    baslik: 'Ihlas ve Samimiyet',
    metin:
        'Ihlas, yalniz Allah rizasi icin yapmaktir. Kul, gosterisi birakinca, az ameli bile buyuk olur. Ihlasi kaybeden, butun amellerini kaybeder.',
    kaynak: 'Lemalar, 20. Lema',
    kategori: 'Ihlas',
    emoji: '💧',
  ),
  Risale(
    baslik: 'Riya ve Gosteris',
    metin:
        'Riya, sirkin kucuk kardesidir. Kim insanlarin gormesi icin amel ederse, Rabbine degil kullara kulluk yapmis olur.',
    kaynak: 'Lemalar, 20. Lema',
    kategori: 'Ihlas',
    emoji: '🚫',
  ),

  // ═══ ILIM ═══
  Risale(
    baslik: 'Ilim ve Marifet',
    metin:
        'Ilim, kalbin kandilidir. Kandilsiz kalp, karanlikta yol arar. Ilim, imanin nurudur; iman, ilmin temelidir.',
    kaynak: 'Isaratul-Icaz',
    kategori: 'Ilim',
    emoji: '📚',
  ),
  Risale(
    baslik: 'Kuran ve Ilim',
    metin:
        'Kuran, her asirda insanligin muallimidir. O, bir mucizedir; benzeri getirilemez. Onu okuyan, Rabbini tanir; anlayan, kainati cozer.',
    kaynak: 'Sozler, 25. Soz',
    kategori: 'Ilim',
    emoji: '📖',
  ),

  // ═══ KADER ═══
  Risale(
    baslik: 'Kader ve Irade',
    metin:
        'Kader, ilminin yazdigidir. Kadere iman, tevekkulu dogurur. Tevekkul, sebeplere sarildiktan sonra sonucu Allaha birakmaktir.',
    kaynak: 'Sozler, 26. Soz',
    kategori: 'Kader',
    emoji: '🛤️',
  ),

  // ═══ HASTALIK ═══
  Risale(
    baslik: 'Hastalik ve Sifa',
    metin:
        'Hastalik, zahiren bir musibet; hakikatte ise bir sifadir. Kul, hastaliginda acizligini anlar, Rabbine sigilir. Sabreden hastaya, sehit ecri gibi mukafat verilir.',
    kaynak: 'Lemalar, 25. Lema',
    kategori: 'Hastalik',
    emoji: '💊',
  ),

  // ═══ IKITISAT ═══
  Risale(
    baslik: 'Iktisat ve Bereket',
    metin:
        'Iktisat, bereketin anahtaridir. Israf, bereketi kacirir. Kul, iktisat ile hem dunya hem ahiret saadetini kazanir.',
    kaynak: 'Lemalar, 19. Lema',
    kategori: 'Iktisat',
    emoji: '🏺',
  ),

  // ═══ GENCILIK ═══
  Risale(
    baslik: 'Gencligin Kiymeti',
    metin:
        'Genclik, hem en buyuk nimet hem de en buyuk tehlike donemidir. Genclik sehvet ve gaflet girdabinda heba edilirse, ahiretin ebedi hayati kaybedilir.',
    kaynak: 'Genclik Rehberi',
    kategori: 'Genclik',
    emoji: '🌱',
  ),
  Risale(
    baslik: 'Genclik ve Ibadet',
    metin:
        'Genclik, ibadet ve tesekkurle gecirilirse, hem dunyada hem ahirette ebedi nimetler kazanilir. Genclik, yasliya gore daha kiymetlidir.',
    kaynak: 'Genclik Rehberi',
    kategori: 'Genclik',
    emoji: '🌟',
  ),

  // ═══ KARDESLIK ═══
  Risale(
    baslik: 'Muminler Kardestir',
    metin:
        'Muminler ancak kardestirler. Birbirlerine karsi merhametli, sefkatli, yardimsever olmalidir. Kardeslik, imanin geregidir.',
    kaynak: 'Mektubat, 22. Mektup',
    kategori: 'Kardeslik',
    emoji: '🤝',
  ),
  Risale(
    baslik: 'Uhuvvet ve Vahdet',
    metin:
        'Uhuvvet, Islam cemaatinin temelidir. Vahdet, kuvvettir. Ihtilaf, zaafiyettir. Muhabbet, kalplerin rabitasidir.',
    kaynak: 'Lemalar, 21. Lema',
    kategori: 'Kardeslik',
    emoji: '💞',
  ),

  // ═══ DUA ═══
  Risale(
    baslik: 'Dua ve Kulluk',
    metin:
        'Dua, kullugun ozudur. Dua, muminin silahidir. Kul, ellerini acinca, gokler acilir. Dua, kulun Rabbine en yakin oldugu andir.',
    kaynak: 'Mektubat, 28. Mektup',
    kategori: 'Dua',
    emoji: '🤲',
  ),

  // ═══ ASK VE MUHABBET ═══
  Risale(
    baslik: 'Muhabbet ve Ask',
    metin:
        'Muhabbet, mevcudatin rabita-i asliyesidir. Ask ve sevk, saadetin rabita-i esasisidir. Allah sevgisi, butun sevgilerin ustundedir.',
    kaynak: 'Mektubat, 29. Mektup',
    kategori: 'Muhabbet',
    emoji: '💖',
  ),

  // ═══ DUNYA ═══
  Risale(
    baslik: 'Dunya ve Ahiret Dengesi',
    metin:
        'Dunya bir handir; yolcu ise insandir. Dunya sevgisi, butun hatalarin basidir. Ahiret, ebedi yurttur; oraya hazirlik, en buyuk akilliliktir.',
    kaynak: 'Sozler, 32. Soz',
    kategori: 'Dunya',
    emoji: '⚖️',
  ),

  // ═══ AKHIRET HAZIRLIGI ═══
  Risale(
    baslik: 'Olum ve Ebedi Hayat',
    metin:
        'Olum, ebedi hayatin kapisidir. Onu hatirlayan, dunyaya baglanmaz. Olum, mumin icin bir terhistir; ahiret icin bir baslangictir.',
    kaynak: 'Lemalar, 27. Lema',
    kategori: 'Ahiret',
    emoji: '🌄',
  ),
];
