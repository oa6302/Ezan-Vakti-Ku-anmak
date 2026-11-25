import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'quran_models.dart';

class QuranService {
  static final QuranService _i = QuranService._();
  factory QuranService() => _i;
  QuranService._();

  List<KuranKategori>? _cache;

  Future<List<KuranKategori>> load() async {
    if (_cache != null) return _cache!;
    try {
      final raw = await rootBundle.loadString('assets/content/kuran.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final list = (map['kategoriler'] as List<dynamic>)
          .map((e) => KuranKategori.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache = list;
      return list;
    } catch (_) {
      return [];
    }
  }

  void clearCache() => _cache = null;
}
