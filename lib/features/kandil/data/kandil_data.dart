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
  // ═══ RECEP ═══
  KandilEvent(
    ad: 'Regaib Kandili',
    hijriMonth: 7,
    hijriDay: 1,
    aciklama: 'Recep ayinin ilk cuma gecesi',
    emoji: '🌙',
  ),
  KandilEvent(
    ad: 'Mirac Kandili',
    hijriMonth: 7,
    hijriDay: 27,
    aciklama: 'Mirac mucizesi gecesi',
    emoji: '✨',
  ),
  // ═══ SABAN ═══
  KandilEvent(
    ad: 'Berat Kandili',
    hijriMonth: 8,
    hijriDay: 15,
    aciklama: 'Bagislanma gecesi',
    emoji: '🕯',
  ),
  // ═══ RAMAZAN ═══
  KandilEvent(
    ad: 'Ramazan Baslangici',
    hijriMonth: 9,
    hijriDay: 1,
    aciklama: 'Oruc ayinin baslangici',
    emoji: '🌙',
  ),
  KandilEvent(
    ad: 'Kadir Gecesi',
    hijriMonth: 9,
    hijriDay: 27,
    aciklama: 'Bin aydan hayirli gece',
    emoji: '⭐',
  ),
  // ═══ SEVVAL ═══
  KandilEvent(
    ad: 'Ramazan Bayrami',
    hijriMonth: 10,
    hijriDay: 1,
    aciklama: 'Bayram namazi ve sevinc',
    emoji: '🎉',
  ),
  // ═══ ZILHICCE ═══
  KandilEvent(
    ad: 'Arefe Gunu',
    hijriMonth: 12,
    hijriDay: 9,
    aciklama: 'Hac ve oruc gunu',
    emoji: '🕋',
  ),
  KandilEvent(
    ad: 'Kurban Bayrami',
    hijriMonth: 12,
    hijriDay: 10,
    aciklama: 'Kurban ve bayram',
    emoji: '🐏',
  ),
  // ═══ MUHARREM ═══
  KandilEvent(
    ad: 'Asure Gunu',
    hijriMonth: 1,
    hijriDay: 10,
    aciklama: 'Oruc ve paylasma',
    emoji: '🥣',
  ),
  // ═══ REBIULEVVEL ═══
  KandilEvent(
    ad: 'Mevlid Kandili',
    hijriMonth: 3,
    hijriDay: 12,
    aciklama: 'Peygamberimizin dogumu',
    emoji: '🌹',
  ),
];

// ═══════════════════════════════════════════════════════════
// HICRI -> MILADI DONUSUM
// ═══════════════════════════════════════════════════════════
//
// Kuveyt algoritmasi (KACST) kullanilir. Turkiye Diyanet takvimi
// ile olan ortalama fark +1 gundur. Bu yuzden turkiyeOffset
// parametresi ile ayarlanabilir.
//
// Test degerleri (2024-2025):
//   1 Rebiulevvel 1446  -> TR: 4 Eylul 2024   (Kuveyt: 3 Eylul)
//   1 Ramazan 1446      -> TR: 1 Mart 2025    (Kuveyt: 28 Subat)
//   1 Sevval 1446       -> TR: 30 Mart 2025   (Kuveyt: 29 Mart)
//   10 Zilhicce 1446    -> TR: 6 Haziran 2025 (Kuveyt: 5 Haziran)
//
// ═══════════════════════════════════════════════════════════

/// Turkiye Diyanet takvimi icin varsayilan offset (gun).
/// Kuveyt algoritmasina gore +1 gun ileri.
const int turkiyeOffset = 1;

/// Hicri -> Miladi (Kuveyt algoritmasi, offset olmadan).
DateTime hijriToGregorian(int hYear, int hMonth, int hDay) {
  final jd = _hijriToJD(hYear, hMonth, hDay);
  return _jdToGregorian(jd);
}

/// Hicri -> Miladi (Turkiye Diyanet yaklasimi).
/// [offset] ile ince ayar yapilabilir (default +1 gun).
DateTime hijriToGregorianTR(
  int hYear,
  int hMonth,
  int hDay, {
  int offset = turkiyeOffset,
}) {
  final base = hijriToGregorian(hYear, hMonth, hDay);
  return base.add(Duration(days: offset));
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

/// Yaklasik mevcut hicri yil.
int _approxHijriYear(DateTime now) {
  return (now.difference(DateTime(622, 7, 16)).inDays / 354.367).floor();
}

/// Gelecek [count] kandil/bayram olayini dondurur.
/// Turkiye offset'i uygulanir.
List<(KandilEvent, DateTime)> upcomingEvents(int count) {
  final now = DateTime.now();
  final result = <(KandilEvent, DateTime)>[];
  final startHijriYear = _approxHijriYear(now);
  for (var y = startHijriYear; y <= startHijriYear + 2; y++) {
    for (final e in kandilEvents) {
      try {
        final g = hijriToGregorianTR(y, e.hijriMonth, e.hijriDay);
        if (g.isAfter(now)) {
          result.add((e, g));
        }
      } catch (_) {}
    }
  }
  result.sort((a, b) => a.$2.compareTo(b.$2));
  return result.take(count).toList();
}

/// Bugun kandil mi? (Buyuk kandil/bayram)
/// Arefe ve Ramazan Baslangici dahil.
(KandilEvent, DateTime)? todayEvent() {
  final now = DateTime.now();
  for (final e in kandilEvents) {
    for (var y = _approxHijriYear(now) - 1;
        y <= _approxHijriYear(now) + 1;
        y++) {
      final g = hijriToGregorianTR(y, e.hijriMonth, e.hijriDay);
      if (g.year == now.year && g.month == now.month && g.day == now.day) {
        return (e, g);
      }
    }
  }
  return null;
}
