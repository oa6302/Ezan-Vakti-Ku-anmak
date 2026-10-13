import '../../../data/models/content_item.dart';

class AssistantMatch {
  final ContentItem item;
  final double score;
  const AssistantMatch({required this.item, required this.score});
}

class AssistantEngine {
  static String normalize(String s) {
    return s.toLowerCase()
        .replaceAll('â', 'a').replaceAll('î', 'i').replaceAll('û', 'u')
        .replaceAll('ç', 'c').replaceAll('ğ', 'g').replaceAll('ı', 'i')
        .replaceAll('ö', 'o').replaceAll('ş', 's').replaceAll('ü', 'u')
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static const _stop = {
    've', 'ile', 'bir', 'bu', 'su', 'o', 'ne', 'nasil', 'nedir',
    'icin', 'da', 'de', 'ki', 'mi', 'mu', 'mı', 'mü', 'ise',
    'the', 'a', 'an', 'and', 'or', 'to', 'of', 'in', 'is', 'it',
  };

  static List<AssistantMatch> search(String query, List<ContentItem> items) {
    final q = normalize(query);
    if (q.isEmpty) return [];

    final words = q
        .split(' ')
        .where((w) => w.length > 2 && !_stop.contains(w))
        .toList();
    if (words.isEmpty) return [];

    final results = <AssistantMatch>[];

    for (final item in items) {
      final baslik = normalize(item.baslik);
      final metin = normalize(item.metin);
      final kaynak = normalize(item.kaynak);
      final kategori = normalize(item.kategori);
      final tefekkur = normalize(item.tefekkur);
      final etiketler = item.etiketler.map(normalize).join(' ');

      var score = 0.0;
      for (final w in words) {
        if (baslik.contains(w)) score += 5.0;
        if (etiketler.contains(w)) score += 4.0;
        if (kategori.contains(w)) score += 3.0;
        if (metin.contains(w)) score += 2.0;
        if (tefekkur.contains(w)) score += 1.5;
        if (kaynak.contains(w)) score += 1.0;
      }

      for (final w in words) {
        final count = RegExp(RegExp.escape(w)).allMatches(metin).length;
        if (count > 1) score += (count - 1) * 0.5;
      }

      if (score > 0) {
        results.add(AssistantMatch(item: item, score: score / words.length));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(5).toList();
  }

  static const Map<String, String> _hazir = {
    'namaz': 'Namaz hakkında detaylı bilgiye "Namaz Öğren" bölümünden ulaşabilirsin.',
    'abdest': 'Abdest alınışı "Namaz Öğren → Abdest" bölümünde adım adım anlatılmıştır.',
    'kuran': 'Kur\'an okumak için "Kütüphane → Kısa Sureler" bölümünü kullan.',
    'vakit': 'Namaz vakitleri ana sayfadaki vakit çizelgesinde gösterilir.',
    'kible': 'Kıble yönü için ana sayfa → Hızlı Erişim → Kıble.',
  };

  static String? hazirCevap(String query) {
    final q = normalize(query);
    for (final e in _hazir.entries) {
      if (q.contains(e.key)) return e.value;
    }
    return null;
  }
}