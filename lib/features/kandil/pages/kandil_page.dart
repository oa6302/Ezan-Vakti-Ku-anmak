import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';
import '../data/kandil_data.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class KandilPage extends StatelessWidget {
  const KandilPage({super.key});

  static List<(ContentItem, DateTime)> _upcoming(int count) {
    final pool = ContentService.instance.getPool(ContentType.kandil);
    final now = DateTime.now();
    final result = <(ContentItem, DateTime)>[];
    final startHijriYear =
        (now.difference(DateTime(622, 7, 16)).inDays / 354.367).floor();
    for (var y = startHijriYear; y <= startHijriYear + 2; y++) {
      for (final item in pool) {
        final month = (item.extra?['hijriMonth'] as int?) ?? 1;
        final day = (item.extra?['hijriDay'] as int?) ?? 1;
        try {
          final g = hijriToGregorian(y, month, day);
          if (g.isAfter(now)) result.add((item, g));
        } catch (_) {}
      }
    }
    result.sort((a, b) => a.$2.compareTo(b.$2));
    return result.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Kandil & Ozel Gunler',
            style: TextStyle(
                color: _navy, fontSize: 17, fontWeight: FontWeight.w900)),
      ),
      body: ListenableBuilder(
        listenable: ContentService.instance,
        builder: (context, _) {
          final events = _upcoming(15);
          return ListView(
            padding: const EdgeInsets.all(14),
            children: [
              _hero(),
              const SizedBox(height: 14),
              if (events.isEmpty)
                _empty()
              else ...[
                _nextEventCard(events.first),
                const SizedBox(height: 14),
                _upcomingList(context, events.skip(1).toList()),
              ],
              const SizedBox(height: 14),
              _infoBox(),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.deep(),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
            ),
            child: const Icon(Icons.star_rounded, color: _gold, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mubarek Gunler',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Kandil, bayram ve ozel geceler.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextEventCard((ContentItem, DateTime) item) {
    final e = item.$1;
    final date = item.$2;
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    final emoji = (e.extra?['emoji'] as String?) ?? '';

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFDF8F3), Color(0xFFF5EDE0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _gold.withValues(alpha: 0.4), width: 2),
            boxShadow: AppShadows.colored(_gold, alpha: 0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _gold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('SIRADAKI',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                  ),
                  const Spacer(),
                  Text(diff == 0 ? 'BUGUN' : '$diff gun kaldi',
                      style: const TextStyle(
                          color: _navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (emoji.isNotEmpty)
                    Text(emoji, style: const TextStyle(fontSize: 40)),
                  if (emoji.isNotEmpty) const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.baslik,
                            style: const TextStyle(
                                color: _navy,
                                fontSize: 20,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(e.icerik,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: _gold, size: 16),
                    const SizedBox(width: 10),
                    Text('${date.day}.${date.month}.${date.year}',
                        style: const TextStyle(
                            color: _navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: AdminEditOverlay(item: e),
        ),
      ],
    );
  }

  Widget _upcomingList(
      BuildContext context, List<(ContentItem, DateTime)> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.event_note_rounded,
                    color: _navy, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('Yaklasan Gunler',
                  style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _eventTile(item)),
        ],
      ),
    );
  }

  Widget _eventTile((ContentItem, DateTime) item) {
    final e = item.$1;
    final date = item.$2;
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    final emoji = (e.extra?['emoji'] as String?) ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: emoji.isNotEmpty
                      ? Text(emoji, style: const TextStyle(fontSize: 22))
                      : const Icon(Icons.star_rounded,
                          color: _gold, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.baslik,
                        style: const TextStyle(
                            color: _navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text('${date.day}.${date.month}.${date.year}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: diff < 7
                      ? _green.withValues(alpha: 0.12)
                      : const Color(0xFFF3F6FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$diff gun',
                    style: TextStyle(
                        color: diff < 7 ? _green : Colors.black54,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: AdminEditOverlay(item: e),
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: const Center(
        child: Text('Yaklasan ozel gun bulunamadi',
            style: TextStyle(color: Colors.black54, fontSize: 13)),
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _gold, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tarihler yaklasik hesaplanir. Kesin tarihler icin Diyanet Isleri Baskanligi takvimini esas aliniz.',
              style: TextStyle(color: _navy, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}