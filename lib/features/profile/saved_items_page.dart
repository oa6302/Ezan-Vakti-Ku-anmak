import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/favorites_service.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _red = Color(0xFFB71C1C);
const _green = Color(0xFF2FAE7F);

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({super.key});
  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  final _search = TextEditingController();
  String _query = '';
  ContentType? _filtreType;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<FavoriteItem> _filtered() {
    var list = FavoritesService.instance.search(_query);
    if (_filtreType != null) {
      list = list.where((e) => e.type == _filtreType).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Favorilerim',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
        actions: [
          ListenableBuilder(
            listenable: FavoritesService.instance,
            builder: (context, _) {
              if (FavoritesService.instance.count == 0) {
                return const SizedBox.shrink();
              }
              return IconButton(
                tooltip: 'Tumunu sil',
                icon: const Icon(Icons.delete_sweep_rounded, color: _red),
                onPressed: _clearAll,
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: FavoritesService.instance,
        builder: (context, _) {
          final all = FavoritesService.instance.all;
          if (all.isEmpty) return _empty();
          final list = _filtered();
          return Column(
            children: [
              _searchBar(),
              _filtreRow(),
              _statsBar(),
              Expanded(
                child: list.isEmpty
                    ? _emptyResult()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (_, i) => _favTile(list[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _gold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bookmark_border_rounded,
                  color: _gold, size: 56),
            ),
            const SizedBox(height: 20),
            const Text('Henuz favori eklenmedi',
                style: TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text(
              'Kartlardaki  📌  ikonuna dokunarak\nicerikleri buraya kaydedebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54, fontSize: 12, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64, color: _navy.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            const Text('Sonuc bulunamadi.',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                _search.clear();
                setState(() {
                  _query = '';
                  _filtreType = null;
                });
              },
              icon: const Icon(Icons.filter_alt_off_rounded),
              label: const Text('Filtreleri temizle'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: TextField(
        controller: _search,
        onChanged: (v) => setState(() => _query = v.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Favorilerde ara...',
          prefixIcon: const Icon(Icons.search_rounded, color: _navy),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    _search.clear();
                    setState(() => _query = '');
                  },
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _filtreRow() {
    final counts = FavoritesService.instance.countsByType();
    final types = ContentType.values
        .where((t) => (counts[t] ?? 0) > 0)
        .toList();
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          _chip(
            label: 'Tumu (${FavoritesService.instance.count})',
            secili: _filtreType == null,
            onTap: () => setState(() => _filtreType = null),
          ),
          const SizedBox(width: 6),
          ...types.map((t) {
            final cnt = counts[t] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _chip(
                label: '${t.label} ($cnt)',
                secili: _filtreType == t,
                onTap: () => setState(() => _filtreType = t),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool secili,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: secili,
      onSelected: (_) => onTap(),
      selectedColor: _navy,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: secili ? Colors.white : _navy,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: secili ? _navy : const Color(0xFFE9EEF5),
        ),
      ),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _statsBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bookmark_rounded, color: _red, size: 16),
          const SizedBox(width: 8),
          Text('${FavoritesService.instance.count} favori',
              style: const TextStyle(
                  color: _navy, fontSize: 12, fontWeight: FontWeight.w900)),
          const Spacer(),
          const Icon(Icons.info_outline_rounded,
              color: Colors.black38, size: 12),
          const SizedBox(width: 4),
          const Text('Kaydetmek icin 📌',
              style: TextStyle(color: Colors.black54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _favTile(FavoriteItem f) {
    final color = _typeColor(f.type);
    final icon = _typeIcon(f.type);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showDetail(f),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE9EEF5)),
          ),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(f.type.label,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 6),
                        Text(_fmtDate(f.savedAt),
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(f.baslik,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: _navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(f.icerik,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                            height: 1.4)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_remove_rounded,
                    color: _red, size: 20),
                tooltip: 'Favoriden cikar',
                onPressed: () async {
                  await FavoritesService.instance.remove(f.id);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favoriden cikarildi'),
                      duration: Duration(milliseconds: 1200),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(FavoriteItem f) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _typeColor(f.type).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(f.type.label,
                        style: TextStyle(
                            color: _typeColor(f.type),
                            fontSize: 10,
                            fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(width: 8),
                  if (f.kategori != null)
                    Text(f.kategori!,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 11)),
                  const Spacer(),
                  Text(_fmtDate(f.savedAt),
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 14),
              Text(f.baslik,
                  style: const TextStyle(
                      color: _navy,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      height: 1.3)),
              const SizedBox(height: 14),
              if (f.arapca != null && f.arapca!.trim().isNotEmpty) ...[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(f.arapca!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          height: 2.0,
                          fontFamily: 'Matbu',
                          color: _navy)),
                ),
                const SizedBox(height: 12),
              ],
              Text(f.icerik,
                  style: const TextStyle(
                      color: _navy, fontSize: 14, height: 1.7)),
              if (f.altIcerik != null && f.altIcerik!.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _gold.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('HISSE / ANLAM',
                          style: TextStyle(
                              color: _navy,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2)),
                      const SizedBox(height: 8),
                      Text(f.altIcerik!,
                          style: const TextStyle(
                              color: _navy,
                              fontSize: 13,
                              height: 1.6)),
                    ],
                  ),
                ),
              ],
              if (f.kaynak != null && f.kaynak!.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.bookmark_outline_rounded,
                        color: _gold.withValues(alpha: 0.8), size: 12),
                    const SizedBox(width: 4),
                    Text(f.kaynak!,
                        style: const TextStyle(
                            color: _gold,
                            fontSize: 11,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _typeColor(ContentType t) {
    switch (t) {
      case ContentType.kissa:
        return _navy;
      case ContentType.dua:
        return _gold;
      case ContentType.vecize:
        return _green;
      case ContentType.hadis:
        return _red;
      case ContentType.tefekkur:
        return const Color(0xFF6B4A2A);
      case ContentType.ayet:
        return const Color(0xFF1F4E79);
      case ContentType.gunluk:
        return const Color(0xFFEA580C);
      case ContentType.risale:
        return _red;
      case ContentType.kandil:
        return _gold;
      case ContentType.mood:
        return const Color(0xFF4A6B8A);
      case ContentType.cocukDersi:
        return _green;
    }
  }

  IconData _typeIcon(ContentType t) {
    switch (t) {
      case ContentType.kissa:
        return Icons.history_edu_rounded;
      case ContentType.dua:
        return Icons.pan_tool_alt_rounded;
      case ContentType.vecize:
        return Icons.format_quote_rounded;
      case ContentType.hadis:
        return Icons.link_rounded;
      case ContentType.tefekkur:
        return Icons.self_improvement_rounded;
      case ContentType.ayet:
        return Icons.menu_book_rounded;
      case ContentType.gunluk:
        return Icons.calendar_today_rounded;
      case ContentType.risale:
        return Icons.auto_stories_rounded;
      case ContentType.kandil:
        return Icons.star_rounded;
      case ContentType.mood:
        return Icons.emoji_emotions_rounded;
      case ContentType.cocukDersi:
        return Icons.child_care_rounded;
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  Future<void> _clearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tum favoriler silinsin mi?'),
        content: Text(
            '${FavoritesService.instance.count} favori kalici olarak silinecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Iptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await FavoritesService.instance.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tum favoriler silindi'),
        backgroundColor: _green,
      ),
    );
  }
}