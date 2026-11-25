class ContentItem {
  final String id;
  final String kategori;
  final String baslik;
  final String metin;
  final String kaynak;
  final String tefekkur;
  final List<String> etiketler;

  const ContentItem({
    required this.id,
    required this.kategori,
    required this.baslik,
    required this.metin,
    required this.kaynak,
    required this.tefekkur,
    required this.etiketler,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] as String? ?? '',
      kategori: json['kategori'] as String? ?? '',
      baslik: json['baslik'] as String? ?? '',
      metin: json['metin'] as String? ?? '',
      kaynak: json['kaynak'] as String? ?? '',
      tefekkur: json['Tefekkür'] as String? ?? '',
      etiketler: (json['etiketler'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kategori': kategori,
        'baslik': baslik,
        'metin': metin,
        'kaynak': kaynak,
        'Tefekkür': tefekkur,
        'etiketler': etiketler,
      };

  bool matches(String query) {
    final q = query.toLowerCase();

    return baslik.toLowerCase().contains(q) ||
        metin.toLowerCase().contains(q) ||
        kategori.toLowerCase().contains(q) ||
        tefekkur.toLowerCase().contains(q) ||
        etiketler.any((e) => e.toLowerCase().contains(q));
  }
}
