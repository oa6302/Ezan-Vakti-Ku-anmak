import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KhushuEntry {
  final String date;
  final String vakit;
  final int level;
  final DateTime timestamp;
  const KhushuEntry({
    required this.date,
    required this.vakit,
    required this.level,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'vakit': vakit,
        'level': level,
        'timestamp': timestamp.toIso8601String(),
      };

  factory KhushuEntry.fromJson(Map<String, dynamic> json) => KhushuEntry(
        date: json['date'] as String,
        vakit: json['vakit'] as String,
        level: json['level'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class KhushuTracker {
  static const _key = 'khushu_entries_v1';

  static const levelLabels = [
    'Dağınık',
    'Zayıf',
    'Orta',
    'İyi',
    'Derin',
  ];

  static const levelEmojis = ['😔', '😐', '🙂', '😊', '🤲'];

  Future<List<KhushuEntry>> all() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => KhushuEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> add(KhushuEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await all();
    list.insert(0, entry);
    if (list.length > 500) list.removeRange(500, list.length);
    await prefs.setString(
        _key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<double> average() async {
    final list = await all();
    if (list.isEmpty) return 0;
    final sum = list.fold<int>(0, (a, b) => a + b.level);
    return sum / list.length;
  }

  Future<List<double>> lastNDaysAverage(int days) async {
    final list = await all();
    final result = <double>[];
    final today = DateTime.now();
    for (var i = days - 1; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      final dayEntries = list.where((e) => e.date == key).toList();
      if (dayEntries.isEmpty) {
        result.add(0);
      } else {
        final sum = dayEntries.fold<int>(0, (a, b) => a + b.level);
        result.add(sum / dayEntries.length);
      }
    }
    return result;
  }

  Future<Map<int, int>> distribution() async {
    final list = await all();
    final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final e in list) {
      dist[e.level] = (dist[e.level] ?? 0) + 1;
    }
    return dist;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
