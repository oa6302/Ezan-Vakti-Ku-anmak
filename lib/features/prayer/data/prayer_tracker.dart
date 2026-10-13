import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum PrayerStatus { kilindi, cemaatle, kaza, bos }

class PrayerRecord {
  final String date;
  final String vakit;
  final PrayerStatus status;
  final String? note;
  const PrayerRecord({
    required this.date,
    required this.vakit,
    required this.status,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'vakit': vakit,
    'status': status.name,
    'note': note,
  };

  factory PrayerRecord.fromJson(Map<String, dynamic> json) => PrayerRecord(
    date: json['date'] as String,
    vakit: json['vakit'] as String,
    status: PrayerStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => PrayerStatus.bos,
    ),
    note: json['note'] as String?,
  );
}

class PrayerTracker {
  static const _key = 'prayer_tracker_v1';
  static const vakitler = ['Sabah', 'Öğle', 'İkindi', 'Akşam', 'Yatsı'];

  Future<Map<String, PrayerRecord>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final map = <String, PrayerRecord>{};
      for (final e in list) {
        final r = PrayerRecord.fromJson(e as Map<String, dynamic>);
        map['${r.date}_${r.vakit}'] = r;
      }
      return map;
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveAll(Map<String, PrayerRecord> map) async {
    final prefs = await SharedPreferences.getInstance();
    final list = map.values.map((r) => r.toJson()).toList();
    await prefs.setString(_key, jsonEncode(list));
  }

  String _dateKey(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<PrayerStatus> getStatus(DateTime date, String vakit) async {
    final all = await _loadAll();
    final r = all['${_dateKey(date)}_$vakit'];
    return r?.status ?? PrayerStatus.bos;
  }

  Future<Map<String, PrayerStatus>> getDayStatus(DateTime date) async {
    final all = await _loadAll();
    final result = <String, PrayerStatus>{};
    for (final v in vakitler) {
      result[v] = all['${_dateKey(date)}_$v']?.status ?? PrayerStatus.bos;
    }
    return result;
  }

  Future<void> setStatus(DateTime date, String vakit, PrayerStatus status, {String? note}) async {
    final all = await _loadAll();
    final key = '${_dateKey(date)}_$vakit';
    if (status == PrayerStatus.bos) {
      all.remove(key);
    } else {
      all[key] = PrayerRecord(date: _dateKey(date), vakit: vakit, status: status, note: note);
    }
    await _saveAll(all);
  }

  Future<int> countCompleted(DateTime date) async {
    final day = await getDayStatus(date);
    return day.values.where((s) => s == PrayerStatus.kilindi || s == PrayerStatus.cemaatle).length;
  }

  Future<List<int>> getWeeklyCounts(DateTime endDate) async {
    final result = <int>[];
    for (var i = 6; i >= 0; i--) {
      final d = endDate.subtract(Duration(days: i));
      result.add(await countCompleted(d));
    }
    return result;
  }

  Future<Map<String, int>> getMonthlySummary(DateTime month) async {
    final all = await _loadAll();
    final summary = <String, int>{'kilindi': 0, 'cemaatle': 0, 'kaza': 0};
    final prefix = '${month.year}-${month.month.toString().padLeft(2, '0')}-';
    for (final r in all.values) {
      if (r.date.startsWith(prefix)) {
        if (r.status == PrayerStatus.kilindi) summary['kilindi'] = summary['kilindi']! + 1;
        if (r.status == PrayerStatus.cemaatle) summary['cemaatle'] = summary['cemaatle']! + 1;
        if (r.status == PrayerStatus.kaza) summary['kaza'] = summary['kaza']! + 1;
      }
    }
    return summary;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}