import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'content_service.dart';

/// Favori icerik kaydi — ContentItem'in hafifletilmis kopyasi.
class FavoriteItem {
  final String id;          // ContentItem.id (tip prefixli: kissa_, dua_ vs.)
  final ContentType type;
  final String baslik;
  final String icerik;
  final String? altIcerik;
  final String? kaynak;
  final String? kategori;
  final String? arapca;
  final DateTime savedAt;

  const FavoriteItem({
    required this.id,
    required this.type,
    required this.baslik,
    required this.icerik,
    this.altIcerik,
    this.kaynak,
    this.kategori,
    this.arapca,
    required this.savedAt,
  });

  factory FavoriteItem.fromContentItem(ContentItem item) => FavoriteItem(
        id: item.id,
        type: item.type,
        baslik: item.baslik,
        icerik: item.icerik,
        altIcerik: item.altIcerik,
        kaynak: item.kaynak,
        kategori: item.kategori,
        arapca: item.arapca,
        savedAt: DateTime.now(),
      );

  /// ContentItem'a geri donustur (detay sayfasi icin).
  ContentItem toContentItem() => ContentItem(
        id: id,
        type: type,
        baslik: baslik,
        icerik: icerik,
        altIcerik: altIcerik,
        kaynak: kaynak,
        kategori: kategori,
        arapca: arapca,
        durum: ContentStatus.yayinlandi,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.key,
        'baslik': baslik,
        'icerik': icerik,
        'altIcerik': altIcerik,
        'kaynak': kaynak,
        'kategori': kategori,
        'arapca': arapca,
        'savedAt': savedAt.toIso8601String(),
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> j) => FavoriteItem(
        id: j['id'] ?? '',
        type: ContentType.values.firstWhere(
          (t) => t.key == j['type'],
          orElse: () => ContentType.kissa,
        ),
        baslik: j['baslik'] ?? '',
        icerik: j['icerik'] ?? '',
        altIcerik: j['altIcerik'],
        kaynak: j['kaynak'],
        kategori: j['kategori'],
        arapca: j['arapca'],
        savedAt: j['savedAt'] != null
            ? DateTime.tryParse('${j['savedAt']}') ?? DateTime.now()
            : DateTime.now(),
      );
}

class FavoritesService extends ChangeNotifier {
  static final FavoritesService instance = FavoritesService._internal();
  FavoritesService._internal();

  static const _prefsKey = 'nur_pusulasi_favorites_v1';

  final List<FavoriteItem> _items = [];
  bool _loaded = false;
  bool get isLoaded => _loaded;
  int get count => _items.length;
  List<FavoriteItem> get all => List.unmodifiable(_items);

  Future<void> load() async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final list = jsonDecode(raw) as List<dynamic>;
        _items.clear();
        for (final j in list) {
          if (j is Map) {
            _items.add(FavoriteItem.fromJson(Map<String, dynamic>.from(j)));
          }
        }
        _items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      }
    } catch (e) {
      debugPrint('FavoritesService.load: $e');
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _items.map((e) => e.toJson()).toList();
      await prefs.setString(_prefsKey, jsonEncode(list));
    } catch (e) {
      debugPrint('FavoritesService._persist: $e');
    }
  }

  /// Belirli bir icerik favori mi?
  bool isFavorite(String id) => _items.any((e) => e.id == id);

  /// Belirli bir ContentItem favori mi?
  bool isFavoriteItem(ContentItem item) => isFavorite(item.id);

  /// Favoriye ekle / cikar. Donus: eklenmis ise true.
  Future<bool> toggle(ContentItem item) async {
    final idx = _items.indexWhere((e) => e.id == item.id);
    if (idx >= 0) {
      _items.removeAt(idx);
      await _persist();
      notifyListeners();
      return false;
    }
    _items.insert(0, FavoriteItem.fromContentItem(item));
    await _persist();
    notifyListeners();
    return true;
  }

  Future<void> remove(String id) async {
    _items.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> clear() async {
    _items.clear();
    await _persist();
    notifyListeners();
  }

  /// Tip bazli filtre.
  List<FavoriteItem> byType(ContentType type) =>
      _items.where((e) => e.type == type).toList();

  /// Arama.
  List<FavoriteItem> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return _items.where((e) {
      return e.baslik.toLowerCase().contains(q) ||
          e.icerik.toLowerCase().contains(q) ||
          (e.kaynak ?? '').toLowerCase().contains(q) ||
          (e.kategori ?? '').toLowerCase().contains(q);
    }).toList();
  }

  /// Tip bazli sayilar.
  Map<ContentType, int> countsByType() {
    final m = <ContentType, int>{};
    for (final e in _items) {
      m[e.type] = (m[e.type] ?? 0) + 1;
    }
    return m;
  }
}