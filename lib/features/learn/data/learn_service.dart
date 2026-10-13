import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'learn_models.dart';

class LearnService {
  static final LearnService _i = LearnService._();
  factory LearnService() => _i;
  LearnService._();

  List<LearnSection>? _cache;

  Future<List<LearnSection>> load() async {
    if (_cache != null) return _cache!;
    try {
      final raw = await rootBundle.loadString('assets/content/namaz_ogrenme.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final list = (map['bolumler'] as List<dynamic>)
          .map((e) => LearnSection.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache = list;
      return list;
    } catch (_) {
      return [];
    }
  }

  void clearCache() => _cache = null;
}