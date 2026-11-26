import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/app_settings.dart';
import 'package:nur_pusulasi/widgets/admin_card_wrapper.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/features/hazine/vecize_detay_page.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _orange = Color(0xFFB58D4A);

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

    return ListenableBuilder(
      listenable: Listenable.merge(
          [ContentService.instance, AppSettings.instance.fontStyle]),
      builder: (context, _) {
        final vecize =
            ContentService.instance.getDailyPoolItem(ContentType.vecize, now) ??
                ContentService.instance.fallback(ContentType.vecize);

        final lang = Localizations.localeOf(context).languageCode;
        final isAr = lang == 'ar';
        final isEn = lang == 'en';
        final isRika = AppSettings.instance.fontStyle.value == 'rika';
        final arabicFont = isRika ? 'Rika' : 'Matbu';
        final ottomanSize = isAr ? 26.0 : (isEn ? 18.0 : 22.0);
        final latinSize = isAr ? 12.0 : (isEn ? 15.0 : 13.0);
        final title = switch (lang) {
          'en' => 'VERSE OF THE DAY',
          'ar' => 'حكمة اليوم',
          _ => 'GÜNÜN VECİZESİ',
        };

        // Dokununca, standarda yukseltilmis vecizenin detay sayfasi acilir
        final detay = vecizeDetaylari[vecize.icerik];
        return GestureDetector(
          onTap: detay == null
              ? null
              : () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => VecizeDetayPage(
                          osmanlica: vecize.altIcerik ?? '',
                          latin: vecize.icerik,
                          detay: detay))),
          child: AdminCaptureCard(
            item: vecize,
            shareText:
                '${vecize.icerik}\n\n— ${vecize.kaynak ?? "Bedîüzzaman Said Nursî"}',
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xFFFFF8EA),
                  Color(0xFFF3EBD9),
                  Color(0xFFFFFCF5)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD7C18E), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 28,
                    offset: Offset(0, 12),
                  ),
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 56),
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
                        child: Text(
                          title,
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
                    if ((vecize.altIcerik ?? '').trim().isNotEmpty)
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          vecize.altIcerik!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ottomanSize,
                            height: 2.1,
                            fontFamily: arabicFont,
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
                      style: TextStyle(
                        color: _navy,
                        fontSize: latinSize,
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
                            (vecize.kaynak ?? 'BEDÎÜZZAMAN SAİD NURSÎ'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
          ),
        );
      },
    );
  }
}
