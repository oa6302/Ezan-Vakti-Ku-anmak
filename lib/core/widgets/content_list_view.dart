import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../data/hybrid_content_repository.dart';
import '../../data/models/content_item.dart';
import 'content_card.dart';

/// Bir kategoriden içerik çekip ContentCard listesi gösterir.
/// Örnek kullanım: ContentListView(category: 'ayetler', accent: navy)
class ContentListView extends StatefulWidget {
  final String category;
  final Color accent;
  final IconData icon;
  final String tagPrefix;
  final int maxItems;

  const ContentListView({
    super.key,
    required this.category,
    required this.accent,
    required this.icon,
    required this.tagPrefix,
    this.maxItems = 3,
  });

  @override
  State<ContentListView> createState() => _ContentListViewState();
}

class _ContentListViewState extends State<ContentListView> {
  final HybridContentRepository _repo = HybridContentRepository();
  late Future<List<ContentItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.byCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContentItem>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return _ErrorBox(message: 'İçerik yüklenemedi: ${snapshot.error}');
        }

        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return _EmptyBox(category: widget.category);
        }

        final shown = items.take(widget.maxItems).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < shown.length; i++) ...[
              ContentCard(
                icon: widget.icon,
                tag: '${widget.tagPrefix}: ${shown[i].kategori.toUpperCase()}',
                title: shown[i].baslik,
                description: shown[i].metin,
                source: shown[i].kaynak,
                reflection: shown[i].tefekkur,
                accent: widget.accent,
              ),
              if (i < shown.length - 1) const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String category;
  const _EmptyBox({required this.category});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: pale,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          const Icon(Icons.inbox_rounded, color: navy),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$category için henüz içerik yok. '
              'assets/content/$category.json dosyasına ekleyebilirsin.',
              style: const TextStyle(fontSize: 12, color: navy, height: 1.4),
            ),
          ),
        ]),
      );
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          const Icon(Icons.error_outline_rounded, color: red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: const TextStyle(fontSize: 12, color: red, height: 1.4)),
          ),
        ]),
      );
}