import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _orange = Color(0xFFF5A623);
const _cream = Color(0xFFFFFBF3);

const _textShadow = [
  Shadow(color: Color(0x45000000), offset: Offset(0, 2), blurRadius: 6),
  Shadow(color: Color(0x30000000), offset: Offset(0, 4), blurRadius: 14),
];

const _arabicShadow = [
  Shadow(color: Color(0x38000000), offset: Offset(0, 1), blurRadius: 5),
  Shadow(color: Color(0x20000000), offset: Offset(0, 3), blurRadius: 10),
];

class VecizeCard extends StatelessWidget {
  const VecizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    return ListenableBuilder(
      listenable: ContentService.instance,
      builder: (context, _) {
        final vecize = ContentService.instance
                .getForDay(ContentType.vecize, dayOfYear) ??
            ContentService.instance.fallback(ContentType.vecize);

        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _cream,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _gold.withValues(alpha: 0.25)),
                boxShadow: [
                  BoxShadow(
                    color: _navy.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: _orange,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: _orange.withValues(alpha: 0.45),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Text(
                          'GUNUN VECIZESI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            shadows: _textShadow,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        (vecize.altIcerik ?? vecize.icerik),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 2.1,
                          fontFamily: 'Matbu',
                          color: _navy,
                          fontWeight: FontWeight.w500,
                          shadows: _arabicShadow,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      color: _gold.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      vecize.icerik,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 13,
                        height: 1.7,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        shadows: _textShadow,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 1,
                            color: _gold.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            (vecize.kaynak ?? 'BEDIUZZAMAN SAID NURSI'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.5,
                              shadows: _textShadow,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 24,
                            height: 1,
                            color: _gold.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: AdminEditOverlay(item: vecize),
            ),
          ],
        );
      },
    );
  }
}