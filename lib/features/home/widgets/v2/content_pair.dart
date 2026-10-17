import 'package:flutter/material.dart';
import '../../../../app/content_service.dart';
import '../../../../widgets/admin_edit_overlay.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);

class ContentPair extends StatelessWidget {
  const ContentPair({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ListenableBuilder(
        listenable: ContentService.instance,
        builder: (context, _) {
          final hadis = ContentService.instance
                  .getForDay(ContentType.hadis, dayOfYear) ??
              ContentService.instance.fallback(ContentType.hadis);
          final tefekkur = ContentService.instance
                  .getForDay(ContentType.tefekkur, dayOfYear) ??
              ContentService.instance.fallback(ContentType.tefekkur);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LightCard(item: hadis),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DarkCard(item: tefekkur),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LightCard extends StatelessWidget {
  final ContentItem item;
  const _LightCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1F8),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        color: _navy, size: 14),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Gunun Hadisi',
                        style: TextStyle(
                            color: _navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  '"${item.icerik}"',
                  style: const TextStyle(
                      color: _navy,
                      fontSize: 12.5,
                      height: 1.5,
                      fontWeight: FontWeight.w600),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                item.altIcerik ?? item.kaynak ?? '',
                style: TextStyle(
                    color: _navy.withValues(alpha: 0.55),
                    fontSize: 10,
                    fontStyle: FontStyle.italic),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: AdminEditOverlay(item: item),
        ),
      ],
    );
  }
}

class _DarkCard extends StatelessWidget {
  final ContentItem item;
  const _DarkCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A2E4A), Color(0xFF0A1F44)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20, bottom: -20,
                child: Icon(Icons.auto_awesome_rounded,
                    size: 120, color: Colors.white.withValues(alpha: 0.06)),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _gold.withValues(alpha: 0.4), width: 1),
                          ),
                          child: const Icon(Icons.auto_awesome_rounded,
                              color: _gold, size: 14),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Bugunun Tefekkuru',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        '"${item.icerik}"',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            height: 1.5,
                            fontWeight: FontWeight.w600),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chevron_right_rounded,
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: AdminEditOverlay(item: item),
        ),
      ],
    );
  }
}