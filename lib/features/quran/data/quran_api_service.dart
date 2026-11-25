import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuranApiService {
  static const _base = 'https://api.quran.com/api/v4';
  static const _translationId = 77;
  static const _chaptersKey = 'qapi_chapters_v1';
  static const _versesPrefix = 'qapi_verses_v1_';

  Future<List<ApiChapter>> fetchChapters({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (!forceRefresh) {
      final cached = prefs.getString(_chaptersKey);
      if (cached != null) {
        try {
          final list = jsonDecode(cached) as List;
          return list
              .map((e) => ApiChapter.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } catch (e) {
          debugPrint('cache parse: $e');
        }
      }
    }
    try {
      final res = await http.get(Uri.parse('$_base/chapters?language=tr'));
      if (res.statusCode != 200) return [];
      final data =
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      final list = (data['chapters'] as List)
          .map((e) => ApiChapter.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      await prefs.setString(
        _chaptersKey,
        jsonEncode(list.map((e) => e.toJson()).toList()),
      );
      return list;
    } catch (e) {
      debugPrint('fetchChapters: $e');
      return [];
    }
  }

  Future<List<ApiVerse>> fetchVerses(int chapter,
      {bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_versesPrefix$chapter';
    if (!forceRefresh) {
      final cached = prefs.getString(key);
      if (cached != null) {
        try {
          final list = jsonDecode(cached) as List;
          return list
              .map((e) => ApiVerse.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } catch (e) {
          debugPrint('verse cache: $e');
        }
      }
    }
    try {
      final urls = [
        '$_base/quran/verses/uthmani?chapter_number=$chapter',
        '$_base/quran/translations/$_translationId?chapter_number=$chapter',
      ];
      final results =
          await Future.wait(urls.map((u) => http.get(Uri.parse(u))));
      if (results[0].statusCode != 200 || results[1].statusCode != 200) {
        return [];
      }
      final arData =
          jsonDecode(utf8.decode(results[0].bodyBytes)) as Map<String, dynamic>;
      final trData =
          jsonDecode(utf8.decode(results[1].bodyBytes)) as Map<String, dynamic>;
      final arList = arData['verses'] as List;
      final trList = trData['translations'] as List;
      final n = arList.length < trList.length ? arList.length : trList.length;
      final verses = <ApiVerse>[];
      for (int i = 0; i < n; i++) {
        verses.add(ApiVerse(
          verseKey: '${arList[i]['verse_key']}',
          arabic: '${arList[i]['text_uthmani']}',
          turkish: '${trList[i]['text']}',
          verseNumber: i + 1,
        ));
      }
      await prefs.setString(
          key, jsonEncode(verses.map((e) => e.toJson()).toList()));
      return verses;
    } catch (e) {
      debugPrint('fetchVerses: $e');
      return [];
    }
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaptersKey);
    for (final k in prefs.getKeys().where((k) => k.startsWith(_versesPrefix))) {
      await prefs.remove(k);
    }
  }
}

class ApiChapter {
  final int id;
  final String nameArabic;
  final String nameSimple;
  final String translatedName;
  final int versesCount;
  final String revelationPlace;

  ApiChapter({
    required this.id,
    required this.nameArabic,
    required this.nameSimple,
    required this.translatedName,
    required this.versesCount,
    required this.revelationPlace,
  });

  factory ApiChapter.fromJson(Map<String, dynamic> j) => ApiChapter(
        id: j['id'] ?? 0,
        nameArabic: '${j['name_arabic'] ?? ''}',
        nameSimple: '${j['name_simple'] ?? ''}',
        translatedName:
            '${j['translated_name']?['name'] ?? j['name_simple'] ?? ''}',
        versesCount: j['verses_count'] ?? 0,
        revelationPlace: '${j['revelation_place'] ?? ''}',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_arabic': nameArabic,
        'name_simple': nameSimple,
        'translated_name': {'name': translatedName},
        'verses_count': versesCount,
        'revelation_place': revelationPlace,
      };
}

class ApiVerse {
  final String verseKey;
  final String arabic;
  final String turkish;
  final int verseNumber;

  ApiVerse({
    required this.verseKey,
    required this.arabic,
    required this.turkish,
    required this.verseNumber,
  });

  factory ApiVerse.fromJson(Map<String, dynamic> j) => ApiVerse(
        verseKey: '${j['verse_key'] ?? ''}',
        arabic: '${j['arabic'] ?? ''}',
        turkish: '${j['turkish'] ?? ''}',
        verseNumber: j['verse_number'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'verse_key': verseKey,
        'arabic': arabic,
        'turkish': turkish,
        'verse_number': verseNumber,
      };
}
