import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimes {
  final String city;
  final DateTime date;
  final Map<String, String> times; // imsak, gunes, ogle, ikindi, aksam, yatsi

  PrayerTimes({
    required this.city,
    required this.date,
    required this.times,
  });

  String? get nextPrayerName {
    final now = DateTime.now();
    final entries = times.entries.toList();
    for (final e in entries) {
      final parts = e.value.split(':');
      if (parts.length != 2) continue;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      final t = DateTime(now.year, now.month, now.day, h, m);
      if (t.isAfter(now)) return e.key;
    }
    return entries.isEmpty ? null : entries.first.key;
  }

  String? get nextPrayerTime => nextPrayerName == null ? null : times[nextPrayerName!];
}

class PrayerService {
  static const _base = 'https://api.aladhan.com/v1/timingsByCity';

  Future<PrayerTimes?> fetch({
    required String city,
    String country = 'Turkey',
    int method = 13, // Diyanet
  }) async {
    try {
      final now = DateTime.now();
      final url = Uri.parse(
        '$_base?city=$city&country=$country&method=$method'
        '&date=${now.day}-${now.month}-${now.year}',
      );
      final res = await http.get(url).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      final timings = data['data']['timings'] as Map<String, dynamic>;
      return PrayerTimes(
        city: city,
        date: now,
        times: {
          'İmsak': (timings['Fajr'] ?? '').toString().substring(0, 5),
          'Güneş': (timings['Sunrise'] ?? '').toString().substring(0, 5),
          'Öğle': (timings['Dhuhr'] ?? '').toString().substring(0, 5),
          'İkindi': (timings['Asr'] ?? '').toString().substring(0, 5),
          'Akşam': (timings['Maghrib'] ?? '').toString().substring(0, 5),
          'Yatsı': (timings['Isha'] ?? '').toString().substring(0, 5),
        },
      );
    } catch (_) {
      return null;
    }
  }
}