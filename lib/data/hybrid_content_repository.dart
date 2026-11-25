import 'dart:developer' as dev;
import 'models/content_item.dart';
import 'sources/local_json_source.dart';
import 'sources/remote_json_source.dart';

/// Hem yerel assets hem de HTTP sunucudan icerik cekebilir.
/// Oncelik: remote (varsa) -> local (fallback).
/// _useRemote false yapilirsa tamamen offline.
class HybridContentRepository {
  final LocalJsonSource _local = LocalJsonSource();
  final RemoteJsonSource _remote = RemoteJsonSource();
  final bool _useRemote;

  HybridContentRepository({bool useRemote = true}) : _useRemote = useRemote;

  Future<List<ContentItem>> byCategory(String category) async {
    if (_useRemote) {
      final remote = await _remote.loadCategory(category);
      if (remote != null && remote.isNotEmpty) {
        dev.log('Remote: $category (${remote.length})', name: 'repo');
        return remote;
      }
    }
    return _local.loadCategory(category);
  }

  Future<List<ContentItem>> all() async {
    final all = <ContentItem>[];
    for (final cat in LocalJsonSource.categories) {
      all.addAll(await byCategory(cat));
    }
    return all;
  }

  Future<ContentItem?> byId(String id) async {
    final items = await all();
    for (final i in items) {
      if (i.id == id) return i;
    }
    return null;
  }

  Future<List<ContentItem>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final items = await all();
    return items.where((item) => item.matches(q)).toList();
  }

  Future<bool> saveRemote(String category, List<ContentItem> items) async {
    return _remote.saveCategory(
      category,
      items.map((e) => e.toJson()).toList(),
    );
  }

  void refresh() => _local.clearCache();
}
