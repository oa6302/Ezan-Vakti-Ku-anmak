import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/favorites_service.dart';
import 'package:nur_pusulasi/features/profile/saved_items_page.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _red = Color(0xFFB71C1C);

/// Ana sayfada favoriler varsa gorunen mini kart.
class FavoritesMiniCard extends StatelessWidget {
  const FavoritesMiniCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final count = FavoritesService.instance.count;
        if (count == 0) return const SizedBox.shrink();

        final counts = FavoritesService.instance.countsByType();
        // En cok favori olan 3 tipi goster
        final sorted = counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final topTypes = sorted.take(3).toList();

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SavedItemsPage()),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFFF8F8), Color(0xFFF4E9EC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE3C8D0)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x55000000),
                      blurRadius: 28,
                      offset: Offset(0, 12))
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7E9ED),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _gold.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(Icons.bookmark_rounded,
                        color: _red, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Favorilerim',
                                style: TextStyle(
                                    shadows: const [
                                      Shadow(
                                          color: Color(0x99000000),
                                          blurRadius: 9,
                                          offset: Offset(0, 4)),
                                      Shadow(
                                          color: Color(0x55000000),
                                          blurRadius: 3,
                                          offset: Offset(0, 2)),
                                    ],
                                    color: _navy,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('$count',
                                  style: TextStyle(
                                      shadows: const [
                                        Shadow(
                                            color: Color(0x99000000),
                                            blurRadius: 9,
                                            offset: Offset(0, 4)),
                                        Shadow(
                                            color: Color(0x55000000),
                                            blurRadius: 3,
                                            offset: Offset(0, 2)),
                                      ],
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...topTypes.asMap().entries.map((e) {
                              if (e.key > 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text('•',
                                      style: TextStyle(shadows: const [
                                        Shadow(
                                            color: Color(0x99000000),
                                            blurRadius: 9,
                                            offset: Offset(0, 4)),
                                        Shadow(
                                            color: Color(0x55000000),
                                            blurRadius: 3,
                                            offset: Offset(0, 2)),
                                      ], color: _navy, fontSize: 10)),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                            ...topTypes.map((e) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(
                                    '${e.key.label} (${e.value})',
                                    style: TextStyle(
                                        shadows: const [
                                          Shadow(
                                              color: Color(0x99000000),
                                              blurRadius: 9,
                                              offset: Offset(0, 4)),
                                          Shadow(
                                              color: Color(0x55000000),
                                              blurRadius: 3,
                                              offset: Offset(0, 2)),
                                        ],
                                        color: _navy,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: _navy, size: 22),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
