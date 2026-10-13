import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cocuk profili — ebeveyn takibi icin.
class Child {
  final String id;
  final String name;
  final int age;
  final String emoji;
  final DateTime createdAt;

  const Child({
    required this.id,
    required this.name,
    required this.age,
    required this.emoji,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'emoji': emoji,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json['id'] as String,
    name: json['name'] as String,
    age: json['age'] as int,
    emoji: json['emoji'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

/// Cocugun ogrenme adimi kaydi.
class ChildProgress {
  final String childId;
  final String dersId;
  final bool completed;
  final DateTime? completedAt;
  const ChildProgress({
    required this.childId,
    required this.dersId,
    required this.completed,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
    'childId': childId,
    'dersId': dersId,
    'completed': completed,
    'completedAt': completedAt?.toIso8601String(),
  };

  factory ChildProgress.fromJson(Map<String, dynamic> json) => ChildProgress(
    childId: json['childId'] as String,
    dersId: json['dersId'] as String,
    completed: json['completed'] as bool? ?? false,
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'] as String)
        : null,
  );
}

/// Cocuklar icin basitlestirilmis ogrenme adimlari.
class ChildLesson {
  final String id;
  final String baslik;
  final String aciklama;
  final String emoji;
  const ChildLesson({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.emoji,
  });
}

const List<ChildLesson> childLessons = [
  ChildLesson(
    id: 'abdest',
    baslik: 'Abdest Almayı Öğrendim',
    aciklama: 'Elleri, yüzü, kolları yıkamayı öğrendim',
    emoji: '💧',
  ),
  ChildLesson(
    id: 'fatiha',
    baslik: 'Fâtiha\'yı Ezberledim',
    aciklama: 'Namazın ilk suresini ezberledim',
    emoji: '📖',
  ),
  ChildLesson(
    id: 'ihlas',
    baslik: 'İhlâs\'ı Ezberledim',
    aciklama: 'Kısa ve güzel bir sureyi öğrendim',
    emoji: '⭐',
  ),
  ChildLesson(
    id: 'rekat',
    baslik: 'Rekâtları Öğrendim',
    aciklama: 'Hangi namaz kaç rekât biliyorum',
    emoji: '🔢',
  ),
  ChildLesson(
    id: 'namaz_2',
    baslik: '2 Rekât Namaz Kıldım',
    aciklama: 'İlk kez tek başıma namaz kıldım',
    emoji: '🕌',
  ),
  ChildLesson(
    id: 'sabah',
    baslik: 'Sabah Namazını Öğrendim',
    aciklama: 'Sabah namazının nasıl kılındığını biliyorum',
    emoji: '🌅',
  ),
  ChildLesson(
    id: 'bes_vakit',
    baslik: 'Beş Vakti Öğrendim',
    aciklama: 'Sabah, öğle, ikindi, akşam, yatsı',
    emoji: '🕐',
  ),
  ChildLesson(
    id: 'dua',
    baslik: 'Namaz Dualarını Öğrendim',
    aciklama: 'Sübhâneke, Tahiyyat, Salli-Bârik',
    emoji: '🤲',
  ),
  ChildLesson(
    id: 'cemaat',
    baslik: 'Cemaatle Namaz Kıldım',
    aciklama: 'Aile ile birlikte namaz kıldım',
    emoji: '👨‍👩‍👧',
  ),
];

class FamilyTracker {
  static const _childrenKey = 'family_children_v1';
  static const _progressKey = 'family_progress_v1';

  Future<List<Child>> children() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_childrenKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Child.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addChild(Child c) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await children();
    list.add(c);
    await prefs.setString(
        _childrenKey, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<void> removeChild(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await children();
    list.removeWhere((c) => c.id == id);
    await prefs.setString(
        _childrenKey, jsonEncode(list.map((e) => e.toJson()).toList()));
    // Progress de sil
    final all = await _allProgress();
    all.removeWhere((p) => p.childId == id);
    await _saveProgress(all);
  }

  Future<List<ChildProgress>> _allProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_progressKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ChildProgress.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveProgress(List<ChildProgress> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _progressKey, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<Map<String, bool>> childProgress(String childId) async {
    final all = await _allProgress();
    final map = <String, bool>{};
    for (final l in childLessons) {
      final p = all.where((e) => e.childId == childId && e.dersId == l.id);
      map[l.id] = p.isNotEmpty && p.first.completed;
    }
    return map;
  }

  Future<void> setCompleted(String childId, String dersId, bool value) async {
    final all = await _allProgress();
    all.removeWhere((p) => p.childId == childId && p.dersId == dersId);
    all.add(ChildProgress(
      childId: childId,
      dersId: dersId,
      completed: value,
      completedAt: value ? DateTime.now() : null,
    ));
    await _saveProgress(all);
  }

  Future<int> completedCount(String childId) async {
    final map = await childProgress(childId);
    return map.values.where((v) => v).length;
  }
}