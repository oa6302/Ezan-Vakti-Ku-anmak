import 'package:adhan_dart/adhan_dart.dart';
import 'turkish_cities.dart';

/// Namaz vakti sonucu
class PrayerTimeResult {
  final String cityName;
  final DateTime date;
  final Map<String, DateTime> times; // imsak, gunes, ogle, ikindi, aksam, yatsi
  final String calculationMethod;
  final String madhab;

  PrayerTimeResult({
    required this.cityName,
    required this.date,
    required this.times,
    this.calculationMethod = 'Diyanet (yaklaşım)',
    this.madhab = 'Hanefi',
  });

  /// Sıradaki namazın adı
  String? get nextPrayerName {
    final now = DateTime.now();
    final sorted = times.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    for (final e in sorted) {
      if (e.key == 'Güneş') continue; // Güneş vakit değil
      if (e.value.isAfter(now)) return e.key;
    }
    return null;
  }

  /// Sıradaki namazın saati
  DateTime? get nextPrayerTime {
    final name = nextPrayerName;
    return name == null ? null : times[name];
  }

  /// Sıradaki namaza kalan süre (dakika)
  int? get minutesToNext {
    final next = nextPrayerTime;
    if (next == null) return null;
    return next.difference(DateTime.now()).inMinutes;
  }

  /// Kalan süre metni
  String get remainingText {
    final mins = minutesToNext;
    if (mins == null) return '';
    if (mins < 0) return 'Vakit girdi';
    if (mins < 60) return '$mins dk';
    final h = mins ~/ 60;
    final m = mins % 60;
    return '${h}s ${m}dk';
  }
}

/// 100% offline namaz vakti hesaplama servisi.
/// adhan_dart (astronomik hesaplama) kullanır.
class PrayerService {
  /// Şehir adına göre vakit hesaplar.
  Future<PrayerTimeResult?> calculateForCity(String cityName,
      {DateTime? date}) async {
    final city = findCity(cityName);
    if (city == null) return null;
    return _calculate(city.lat, city.lng, city.name, date);
  }

  /// Koordinata göre vakit hesaplar (konum izni verildiğinde).
  Future<PrayerTimeResult?> calculateForCoordinates(
      double lat, double lng, String label,
      {DateTime? date}) async {
    return _calculate(lat, lng, label, date);
  }

  PrayerTimeResult _calculate(
      double lat, double lng, String label, DateTime? date) {
    final targetDate = date ?? DateTime.now();
    final coordinates = Coordinates(lat, lng);

    // Diyanet yöntemi (adhan_dart'ın Türkiye yaklaşımı)
    final params = CalculationMethodParameters.turkiye();
    params.madhab = Madhab.hanafi;

    final prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: targetDate,
      calculationParameters: params,
      precision: true,
    );

    // Yerel saat dilimine göre DateTime üret
    DateTime local(DateTime utc) {
      final offset = targetDate.timeZoneOffset;
      return utc.add(offset);
    }

    final times = <String, DateTime>{
      'İmsak': local(prayerTimes.fajr),
      'Güneş': local(prayerTimes.sunrise),
      'Öğle': local(prayerTimes.dhuhr),
      'İkindi': local(prayerTimes.asr),
      'Akşam': local(prayerTimes.maghrib),
      'Yatsı': local(prayerTimes.isha),
    };

    return PrayerTimeResult(
      cityName: label,
      date: targetDate,
      times: times,
      calculationMethod: 'Diyanet (yaklaşım)',
      madhab: 'Hanefi',
    );
  }
}
