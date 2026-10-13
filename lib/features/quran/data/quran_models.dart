class Sure {
  final String id;
  final String ad;
  final int numarasi;
  final int ayetSayisi;
  final String inisYeri;
  final String anlami;
  final String arapca;
  final String okunus;
  final String meal;
  final String fazilet;

  const Sure({
    required this.id,
    required this.ad,
    required this.numarasi,
    required this.ayetSayisi,
    required this.inisYeri,
    required this.anlami,
    required this.arapca,
    required this.okunus,
    required this.meal,
    required this.fazilet,
  });

  factory Sure.fromJson(Map<String, dynamic> j) => Sure(
    id: j['id'] as String? ?? '',
    ad: j['ad'] as String? ?? '',
    numarasi: j['numarasi'] as int? ?? 0,
    ayetSayisi: j['ayetSayisi'] as int? ?? 0,
    inisYeri: j['inisYeri'] as String? ?? '',
    anlami: j['anlami'] as String? ?? '',
    arapca: j['arapca'] as String? ?? '',
    okunus: j['okunus'] as String? ?? '',
    meal: j['meal'] as String? ?? '',
    fazilet: j['fazilet'] as String? ?? '',
  );
}

class KuranKategori {
  final String id;
  final String baslik;
  final String altbaslik;
  final List<Sure> sureler;

  const KuranKategori({
    required this.id,
    required this.baslik,
    required this.altbaslik,
    required this.sureler,
  });

  factory KuranKategori.fromJson(Map<String, dynamic> j) => KuranKategori(
    id: j['id'] as String? ?? '',
    baslik: j['baslik'] as String? ?? '',
    altbaslik: j['altbaslik'] as String? ?? '',
    sureler: (j['sureler'] as List<dynamic>? ?? [])
        .map((e) => Sure.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}