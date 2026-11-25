import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/content_item.dart';

class LocalJsonSource {
  static const List<String> categories = [
    'ayetler',
    'hadisler',
    'dualar',
    'zikirler',
    'kissalar',
    'vecizeler',
  ];

  final Map<String, List<ContentItem>> _cache = {};

  Future<List<ContentItem>> loadCategory(String category) async {
    if (_cache.containsKey(category)) return _cache[category]!;
    try {
      final raw = await rootBundle.loadString('assets/content/$category.json');
      final decoded = jsonDecode(raw);
      final list = (decoded as List<dynamic>)
          .map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache[category] = list;
      return list;
    } catch (_) {
      _cache[category] = const [];
      return const [];
    }
  }

  Future<List<ContentItem>> loadAll() async {
    final all = <ContentItem>[];
    for (final cat in categories) {
      all.addAll(await loadCategory(cat));
    }
    return all;
  }

  void clearCache() => _cache.clear();
}
