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
  /// Son N günün tamamlanan vakit sayısı.
  /// Index 0 = N-1 gün önce, index N-1 = bugün.
  Future<List<int>> getLastNDays(int n) async {
    final all = await _loadAll();
    final result = <int>[];
    final today = DateTime.now();
    for (var i = n - 1; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      final key = _dateKey(d);
      var count = 0;
      for (final v in vakitler) {
        final r = all['${key}_$v'];
        if (r != null &&
            (r.status == PrayerStatus.kilindi ||
                r.status == PrayerStatus.cemaatle)) {
          count++;
        }
      }
      result.add(count);
    }
    return result;
  }

  /// Toplam tamamlanan vakit sayısı (tüm geçmiş).
  Future<int> getTotalCompleted() async {
    final all = await _loadAll();
    var count = 0;
    for (final r in all.values) {
      if (r.status == PrayerStatus.kilindi || r.status == PrayerStatus.cemaatle) {
        count++;
      }
    }
    return count;
  }

  /// Toplam kayıtlı gün sayısı.
  Future<int> getTotalActiveDays() async {
    final all = await _loadAll();
    final days = <String>{};
    for (final r in all.values) {
      if (r.status == PrayerStatus.kilindi || r.status == PrayerStatus.cemaatle) {
        days.add(r.date);
      }
    }
    return days.length;
  }

  /// Şu anki kesintisiz seri (gün). Bugün dahil.
  Future<int> getCurrentStreak() async {
    final all = await _loadAll();
    var streak = 0;
    final today = DateTime.now();
    for (var i = 0; i < 365; i++) {
      final d = today.subtract(Duration(days: i));
      final key = _dateKey(d);
      var hasAny = false;
      for (final v in vakitler) {
        final r = all['${key}_$v'];
        if (r != null &&
            (r.status == PrayerStatus.kilindi ||
                r.status == PrayerStatus.cemaatle)) {
          hasAny = true;
          break;
        }
      }
      if (hasAny) {
        streak++;
      } else {
        if (i == 0) continue; // Bugün henüz kayıt yoksa seriyi kesme
        break;
      }
    }
    return streak;
  }

  /// En uzun kesintisiz seri (tüm geçmiş).
  Future<int> getLongestStreak() async {
    final all = await _loadAll();
    final activeDays = <DateTime>{};
    for (final r in all.values) {
      if (r.status == PrayerStatus.kilindi || r.status == PrayerStatus.cemaatle) {
        final parts = r.date.split('-');
        if (parts.length == 3) {
          activeDays.add(DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          ));
        }
      }
    }
    if (activeDays.isEmpty) return 0;
    final sorted = activeDays.toList()..sort();
    var longest = 1;
    var current = 1;
    for (var i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }
    return longest;
  }

  /// Ayın günlerine göre tamamlanan sayılar (1..31).
  Future<Map<int, int>> getMonthHeatmap(DateTime month) async {
    final all = await _loadAll();
    final prefix = month.year.toString() +
        '-' +
        month.month.toString().padLeft(2, '0') +
        '-';
    final result = <int, int>{};
    for (final r in all.values) {
      if (r.date.startsWith(prefix)) {
        if (r.status == PrayerStatus.kilindi ||
            r.status == PrayerStatus.cemaatle) {
          final day = int.tryParse(r.date.substring(8)) ?? 0;
          result[day] = (result[day] ?? 0) + 1;
        }
      }
    }
    return result;
  }



  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}