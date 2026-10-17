import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/content_service.dart';
import '../../app/favorites_service.dart';
class ContentCard extends StatelessWidget {
  final IconData icon;
  final String tag;
  final String title;
  final String description;
  final String source;
  final String reflection;
  final Color accent;

  const ContentCard({
    super.key,
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
    required this.source,
    required this.reflection,
    required this.accent,
  });

  Future<void> _saveFavorite(BuildContext context) async {
    final item = ContentItem(
      id: 'content_card_${title.hashCode}_${tag.hashCode}',
      type: ContentType.vecize,
      baslik: title,
      icerik: description,
      altIcerik: reflection.isEmpty ? null : reflection,
      kaynak: source,
      kategori: tag,
      durum: ContentStatus.yayinlandi,
    );
    final added = await FavoritesService.instance.toggle(item);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(added
            ? 'Favorilere eklendi'
            : 'Favorilerden cikarildi'),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              backgroundColor: Colors.white,
              builder: (sheetContext) => SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: accent, size: 34),
                      const SizedBox(height: 14),
                      Text(
                        tag,
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        description,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Kaynak',
                        style: TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        source,
                        style: const TextStyle(height: 1.6, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TEFEKKÜR',
                              style: TextStyle(
                                color: navy,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reflection,
                              style: const TextStyle(height: 1.7),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _saveFavorite(context),
                          icon: const Icon(Icons.bookmark_add_rounded),
                          label: const Text('Favorilere Ekle'),
                          style: FilledButton.styleFrom(
                            backgroundColor: red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: const Text('Kapat'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag,
                        style: TextStyle(
                          color: accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: accent),
              ],
            ),
          ),
        ),
      );
}