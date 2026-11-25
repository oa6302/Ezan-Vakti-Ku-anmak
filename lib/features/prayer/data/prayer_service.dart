import 'package:adhan_dart/adhan_dart.dart';
import 'turkish_cities.dart';

class PrayerTimeResult {
  final String cityName;
  final DateTime date;
  final Map<String, DateTime> times;
  final String calculationMethod;
  final String madhab;

  PrayerTimeResult({
    required this.cityName,
    required this.date,
    required this.times,
    this.calculationMethod = 'Diyanet (yaklasim)',
    this.madhab = 'Hanefi',
  });

  String? get nextPrayerName {
    final now = DateTime.now();
    final sorted = times.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    for (final e in sorted) {
      if (e.key == 'Gunes') continue;
      if (e.value.isAfter(now)) return e.key;
    }
    return times.containsKey('Imsak') ? 'Imsak' : null;
  }

  DateTime? get nextPrayerTime {
    final name = nextPrayerName;
    if (name == null) return null;
    final t = times[name];
    if (t == null) return null;
    if (t.isAfter(DateTime.now())) return t;
    return t.add(const Duration(days: 1));
  }

  int? get minutesToNext {
    final next = nextPrayerTime;
    if (next == null) return null;
    return next.difference(DateTime.now()).inMinutes;
  }

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

class PrayerService {
  Future<PrayerTimeResult?> calculateForCity(String cityName,
      {DateTime? date}) async {
    // 1) Orijinal isimle dene (İstanbul)
    var city = findCity(cityName);

    // 2) ASCII fold ile dene (Istanbul → İstanbul)
    if (city == null) {
      final fold = _asciiFold(cityName);
      for (final c in turkishCities) {
        if (_asciiFold(c.name) == fold) {
          city = c;
          break;
        }
      }
    }

    if (city == null) return null;
    return _calculate(city.lat, city.lng, city.name, date);
  }

  Future<PrayerTimeResult?> calculateForCoordinates(
      double lat, double lng, String label,
      {DateTime? date}) async {
    return _calculate(lat, lng, label, date);
  }

  PrayerTimeResult _calculate(
      double lat, double lng, String label, DateTime? date) {
    final targetDate = date ?? DateTime.now();
    final coordinates = Coordinates(lat, lng);

    final params = CalculationMethodParameters.turkiye();
    params.madhab = Madhab.hanafi;

    final prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: targetDate,
      calculationParameters: params,
      precision: true,
    );

    // adhan_dart UTC doner, toLocal() ile yerel saate cevir
    final times = <String, DateTime>{
      'Imsak': prayerTimes.fajr.toLocal(),
      'Gunes': prayerTimes.sunrise.toLocal(),
      'Ogle': prayerTimes.dhuhr.toLocal(),
      'Ikindi': prayerTimes.asr.toLocal(),
      'Aksam': prayerTimes.maghrib.toLocal(),
      'Yatsi': prayerTimes.isha.toLocal(),
    };

    return PrayerTimeResult(
      cityName: label,
      date: targetDate,
      times: times,
      calculationMethod: 'Diyanet (yaklasim)',
      madhab: 'Hanefi',
    );
  }

  static String _asciiFold(String s) {
    return s
        .replaceAll('İ', 'I')
        .replaceAll('ı', 'i')
        .replaceAll('Ş', 'S')
        .replaceAll('ş', 's')
        .replaceAll('Ğ', 'G')
        .replaceAll('ğ', 'g')
        .replaceAll('Ü', 'U')
        .replaceAll('ü', 'u')
        .replaceAll('Ö', 'O')
        .replaceAll('ö', 'o')
        .replaceAll('Ç', 'C')
        .replaceAll('ç', 'c')
        .toLowerCase();
  }
}
