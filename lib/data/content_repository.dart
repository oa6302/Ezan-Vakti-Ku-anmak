import 'models/content_item.dart';
import 'sources/local_json_source.dart';

abstract class ContentRepository {
  Future<List<ContentItem>> byCategory(String category);
  Future<List<ContentItem>> all();
  Future<ContentItem?> byId(String id);
  Future<List<ContentItem>> search(String query);
  void refresh();
}

class LocalContentRepository implements ContentRepository {
  final LocalJsonSource _source = LocalJsonSource();

  @override
  Future<List<ContentItem>> byCategory(String category) =>
      _source.loadCategory(category);

  @override
  Future<List<ContentItem>> all() => _source.loadAll();

  @override
  Future<ContentItem?> byId(String id) async {
    final items = await _source.loadAll();
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<ContentItem>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final items = await _source.loadAll();
    return items.where((item) => item.matches(q)).toList();
  }

  @override
  void refresh() => _source.clearCache();
}