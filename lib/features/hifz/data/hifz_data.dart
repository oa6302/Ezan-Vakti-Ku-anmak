/// Ezber dogrulama icin sure listesi (ozet).
/// Tam Arapca metin Kur'an modulundan gelir; burada
/// okunus (latin) uzerinden karsilastirma yapiyoruz.
class HifzSure {
  final String id;
  final String ad;
  final List<String> kelimeler; // okunus kelimeleri

  const HifzSure({
    required this.id,
    required this.ad,
    required this.kelimeler,
  });
}

const List<HifzSure> hifzSureler = [
  HifzSure(
    id: 'ihlas',
    ad: 'İhlâs',
    kelimeler: [
      'kul',
      'huvallahu',
      'ehad',
      'allahus',
      'samed',
      'lem',
      'yelid',
      've',
      'lem',
      'yuled',
      've',
      'lem',
      'yekun',
      'lehu',
      'kufuven',
      'ehad'
    ],
  ),
  HifzSure(
    id: 'felak',
    ad: 'Felak',
    kelimeler: [
      'kul',
      'euzu',
      'birabbil',
      'felak',
      'min',
      'serri',
      'ma',
      'halak',
      've',
      'min',
      'serri',
      'gasikin',
      'iza',
      'vekab',
      've',
      'min',
      'serrin',
      'neffasati',
      'fil',
      'ukad',
      've',
      'min',
      'serri',
      'hasidin',
      'iza',
      'hased'
    ],
  ),
  HifzSure(
    id: 'nas',
    ad: 'Nâs',
    kelimeler: [
      'kul',
      'euzu',
      'birabbin',
      'nas',
      'melikin',
      'nas',
      'ilahin',
      'nas',
      'min',
      'serril',
      'vesvasil',
      'hannas',
      'ellezi',
      'yuvesvisu',
      'fi',
      'sudurin',
      'nas',
      'minel',
      'cinneti',
      'ven',
      'nas'
    ],
  ),
  HifzSure(
    id: 'kevser',
    ad: 'Kevser',
    kelimeler: [
      'inna',
      'atayna',
      'kel',
      'kevser',
      'fesalli',
      'lirabbike',
      'venhar',
      'inne',
      'sanieke',
      'huvel',
      'ebter'
    ],
  ),
  HifzSure(
    id: 'asr',
    ad: 'Asr',
    kelimeler: [
      'vel',
      'asr',
      'innel',
      'insane',
      'lefi',
      'husr',
      'illellezine',
      'amenu',
      've',
      'amilus',
      'salihati',
      've',
      'tevasav',
      'bil',
      'hakki',
      've',
      'tevasav',
      'bis',
      'sabr'
    ],
  ),
];

/// STT sonucu ile hedef kelimeleri karsilastir.
/// Basit benzerlik: dogru sirayla eslesen kelime sayisi / toplam.
double compareWords(String recognized, List<String> target) {
  if (target.isEmpty) return 0;

  // Turkce karakterleri normalize et, kucuk harfe cevir
  String norm(String s) {
    return s
        .toLowerCase()
        .replaceAll('â', 'a')
        .replaceAll('î', 'i')
        .replaceAll('û', 'u')
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u')
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();
  }

  final heard = norm(recognized)
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  final targetNorm = target.map(norm).toList();

  // Levenshtein benzeri kaba eslesme: her hedef kelime icin
  // duyulan listede en yakin kelimeyi bul
  var matched = 0;
  var hIndex = 0;
  for (final t in targetNorm) {
    var found = false;
    for (var j = hIndex; j < heard.length && j < hIndex + 3; j++) {
      if (heard[j] == t || heard[j].startsWith(t) || t.startsWith(heard[j])) {
        matched++;
        hIndex = j + 1;
        found = true;
        break;
      }
    }
    if (!found) hIndex++;
  }

  return matched / target.length;
}
