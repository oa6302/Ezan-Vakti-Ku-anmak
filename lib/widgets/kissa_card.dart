import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';
import 'package:nur_pusulasi/features/kissa/pages/kissa_kutuphanesi_page.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _borderSoft = Color(0xFFE9EEF5);

class KissaCard extends StatelessWidget {
  const KissaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final k = ContentService.instance.getForDay(ContentType.kissa, dayOfYear) ??
        ContentService.instance.fallback(ContentType.kissa);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _borderSoft),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                _selamlama(),
                Positioned(
                  top: 0,
                  right: 0,
                  child: AdminEditOverlay(item: k),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _dekoratifAyrac(),
            const SizedBox(height: 16),
            _header(k),
            const SizedBox(height: 14),
            _kaynakBadge(k),
            const SizedBox(height: 14),
            _metinOnizleme(k),
            const SizedBox(height: 12),
            _hisseBox(k),
            const SizedBox(height: 14),
            _kelimeler(k),
            const SizedBox(height: 14),
            _altAksiyonlar(context, k),
          ],
        ),
      ),
    );
  }

  Widget _selamlama() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.brightness_2_rounded,
                color: _gold.withValues(alpha: 0.7), size: 14),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _gold.withValues(alpha: 0.18),
                    _gold.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                    color: _gold.withValues(alpha: 0.4), width: 1.5),
              ),
              child: const Icon(Icons.wb_twilight_rounded,
                  color: _gold, size: 22),
            ),
            const SizedBox(width: 8),
            Icon(Icons.brightness_2_rounded,
                color: _gold.withValues(alpha: 0.7), size: 14),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mosque_rounded,
                color: _navy.withValues(alpha: 0.3), size: 12),
            const SizedBox(width: 6),
            const Text('ESSELAMU ALEYKUM',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.6)),
            const SizedBox(width: 6),
            Icon(Icons.mosque_rounded,
                color: _navy.withValues(alpha: 0.3), size: 12),
          ],
        ),
        const SizedBox(height: 3),
        const Text('ve Rahmetullahi ve Berekatuhu',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _gold,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6)),
      ],
    );
  }

  Widget _dekoratifAyrac() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _borderSoft)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_rounded,
                  color: _gold.withValues(alpha: 0.6), size: 12),
              const SizedBox(width: 4),
              Icon(Icons.menu_book_rounded,
                  color: _gold.withValues(alpha: 0.5), size: 14),
              const SizedBox(width: 4),
              Icon(Icons.auto_awesome_rounded,
                  color: _gold.withValues(alpha: 0.6), size: 12),
            ],
          ),
        ),
        Expanded(child: Container(height: 1, color: _borderSoft)),
      ],
    );
  }

  Widget _header(ContentItem k) {
    return Column(
      children: [
        const Text('BUGUNUN KISSASI',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black45,
                fontSize: 10,
                letterSpacing: 2.4,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        // Baslik + ikon cercevesinde
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ContentService.instance.colorFor(k).withValues(alpha: 0.18),
                    ContentService.instance.colorFor(k).withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                    color: ContentService.instance.colorFor(k).withValues(alpha: 0.4), width: 1.5),
              ),
              child: Icon(ContentService.instance.iconFor(k), color: ContentService.instance.colorFor(k), size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(k.baslik,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: _navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2)),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _gold.withValues(alpha: 0.10),
                border: Border.all(
                    color: _gold.withValues(alpha: 0.3), width: 1),
              ),
              child: const Icon(Icons.bookmark_rounded,
                  color: _gold, size: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kaynakBadge(ContentItem k) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _gold.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _gold.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_outline_rounded,
                color: _gold, size: 12),
            const SizedBox(width: 6),
            Icon(Icons.library_books_rounded,
                color: _gold.withValues(alpha: 0.7), size: 11),
            const SizedBox(width: 6),
            Text((k.kaynak ?? ''),
                style: const TextStyle(
                    color: _gold,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3)),
          ],
        ),
      ),
    );
  }

  Widget _metinOnizleme(ContentItem k) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: ContentService.instance.colorFor(k).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ContentService.instance.colorFor(k).withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: ContentService.instance.colorFor(k).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.auto_stories_rounded,
                    color: ContentService.instance.colorFor(k), size: 12),
              ),
              const SizedBox(width: 8),
              const Text('KISSA',
                  style: TextStyle(
                      color: _navy,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6)),
              const SizedBox(width: 8),
              Icon(Icons.schedule_rounded,
                  color: _navy.withValues(alpha: 0.4), size: 11),
              const SizedBox(width: 4),
              Text('${_okumaSuresi(k.icerik)} dk',
                  style: TextStyle(
                      color: _navy.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.format_quote_rounded,
                  color: ContentService.instance.colorFor(k).withValues(alpha: 0.4), size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(k.icerik,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: _navy,
                        fontSize: 13,
                        height: 1.7,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hisseBox(ContentItem k) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _gold.withValues(alpha: 0.12),
            _gold.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: _gold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb_rounded,
                    color: Colors.white, size: 11),
              ),
              const SizedBox(width: 8),
              const Text('HISSE',
                  style: TextStyle(
                      color: _navy,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text((k.altIcerik ?? ''),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 13,
                  height: 1.7,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _kelimeler(ContentItem k) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: const <String>[].map((kelime) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _navy.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _navy.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.label_outline_rounded,
                  color: _navy.withValues(alpha: 0.5), size: 11),
              const SizedBox(width: 5),
              Text(kelime,
                  style: const TextStyle(
                      color: _navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _altAksiyonlar(BuildContext context, ContentItem k) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) => const KissaKutuphanesiPage()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _navy.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _navy.withValues(alpha: 0.12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.library_books_rounded,
                        color: _navy, size: 14),
                    SizedBox(width: 6),
                    Text('Kutuphane',
                        style: TextStyle(
                            color: _navy,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) => const KissaKutuphanesiPage()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_navy, const Color(0xFF05132B)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.auto_stories_rounded,
                        color: Color(0xFFC9A961), size: 14),
                    SizedBox(width: 6),
                    Text('Tum Kissalar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static int _okumaSuresi(String metin) {
    final kelime = metin.split(' ').length;
    return (kelime / 200).ceil().clamp(1, 15);
  }
}