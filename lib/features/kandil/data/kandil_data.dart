class KandilEvent {
  final String ad;
  final int hijriMonth;
  final int hijriDay;
  final String aciklama;
  final String emoji;
  const KandilEvent({
    required this.ad,
    required this.hijriMonth,
    required this.hijriDay,
    required this.aciklama,
    required this.emoji,
  });
}

const List<KandilEvent> kandilEvents = [
  KandilEvent(ad: 'Regaib Kandili', hijriMonth: 7, hijriDay: 1, aciklama: 'Recep ayının ilk cuma gecesi', emoji: '🌙'),
  KandilEvent(ad: 'Mirac Kandili', hijriMonth: 7, hijriDay: 27, aciklama: 'Mirac mucizesi gecesi', emoji: '✨'),
  KandilEvent(ad: 'Berat Kandili', hijriMonth: 8, hijriDay: 15, aciklama: 'Bagislanma gecesi', emoji: '🕯'),
  KandilEvent(ad: 'Ramazan Baslangici', hijriMonth: 9, hijriDay: 1, aciklama: 'Oruç ayinin baslangici', emoji: '🌙'),
  KandilEvent(ad: 'Kadir Gecesi', hijriMonth: 9, hijriDay: 27, aciklama: 'Bin aydan hayirli gece', emoji: '⭐'),
  KandilEvent(ad: 'Ramazan Bayrami', hijriMonth: 10, hijriDay: 1, aciklama: 'Bayram namazi ve sevinç', emoji: '🎉'),
  KandilEvent(ad: 'Arefe Gunu', hijriMonth: 12, hijriDay: 9, aciklama: 'Hac ve oruç gunu', emoji: '🕋'),
  KandilEvent(ad: 'Kurban Bayrami', hijriMonth: 12, hijriDay: 10, aciklama: 'Kurban ve bayram', emoji: '🐑'),
  KandilEvent(ad: 'Asure Gunu', hijriMonth: 1, hijriDay: 10, aciklama: 'Oruç ve paylasma', emoji: '🥣'),
  KandilEvent(ad: 'Mevlid Kandili', hijriMonth: 3, hijriDay: 12, aciklama: 'Peygamberimizin dogumu', emoji: '🌹'),
];

/// Basit hicri->miladi donusum (yaklasik +-1 gun).
/// Kuveyt algoritmasi.
DateTime hijriToGregorian(int hYear, int hMonth, int hDay) {
  final jd = _hijriToJD(hYear, hMonth, hDay);
  return _jdToGregorian(jd);
}

int _hijriToJD(int year, int month, int day) {
  return ((11 * year + 3) ~/ 30) +
      (354 * year) +
      (30 * month) -
      ((month - 1) ~/ 2) +
      day +
      1948440 -
      385;
}

DateTime _jdToGregorian(int jd) {
  var l = jd + 68569;
  final n = (4 * l) ~/ 146097;
  l = l - ((146097 * n + 3) ~/ 4);
  final i = (4000 * (l + 1)) ~/ 1461001;
  l = l - ((1461 * i) ~/ 4) + 31;
  final j = (80 * l) ~/ 2447;
  final d = l - ((2447 * j) ~/ 80);
  l = j ~/ 11;
  final m = j + 2 - (12 * l);
  final y = 100 * (n - 49) + i + l;
  return DateTime(y, m, d);
}

List<(KandilEvent, DateTime)> upcomingEvents(int count) {
  final now = DateTime.now();
  final result = <(KandilEvent, DateTime)>[];
  // Yaklasik mevcut hicri yil
  final startHijriYear =
      (now.difference(DateTime(622, 7, 16)).inDays / 354.367).floor();
  for (var y = startHijriYear; y <= startHijriYear + 2; y++) {
    for (final e in kandilEvents) {
      try {
        final g = hijriToGregorian(y, e.hijriMonth, e.hijriDay);
        if (g.isAfter(now)) {
          result.add((e, g));
        }
      } catch (_) {}
    }
  }
  result.sort((a, b) => a.$2.compareTo(b.$2));
  return result.take(count).toList();
}