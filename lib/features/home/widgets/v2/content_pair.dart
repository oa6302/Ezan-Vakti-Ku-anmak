import 'package:flutter/material.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import '../../../../app/content_service.dart';
import '../../../../widgets/admin_card_wrapper.dart';

class ContentPair extends StatelessWidget {
  const ContentPair({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ListenableBuilder(
        listenable: ContentService.instance,
        builder: (context, _) {
          final daily = ContentService.instance.getDailyRecordForDate(now);
          final extra = daily?.extra ?? {};
          final dailyHadis =
              extra['hadis']?.toString() ?? daily?.altIcerik ?? '';
          final hasDailyHadis = dailyHadis.trim().isNotEmpty &&
              !ContentService.instance.planliMi(ContentType.hadis, now);
          final poolHadis =
              ContentService.instance.getDailyPoolItem(ContentType.hadis, now);

          final ContentItem? hadis = hasDailyHadis
              ? ContentItem(
                  id: '${daily!.id}_hadis',
                  type: ContentType.hadis,
                  baslik: daily.baslik,
                  icerik: dailyHadis,
                  kaynak:
                      extra['hadisKaynak']?.toString() ?? daily.kaynak ?? '',
                  durum: ContentStatus.yayinlandi,
                )
              : poolHadis;

          if (hadis == null) return const SizedBox.shrink();
          return _LightCard(item: hadis);
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
    final arabic = item.arapca ?? '';

    return AdminCaptureCard(
      item: item,
      shareText: '"${item.icerik}"\n${item.kaynak ?? ""}',
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 54),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFFF0E2), Color(0xFFFFE5C8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE6B77E), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26334A62),
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF0A1F44),
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).hadithOfDay,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0A1F44),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        AppLocalizations.of(context).uiPeygamberimizinSAV,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0A1F44),
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (arabic.trim().isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCF8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    arabic,
                    textAlign: TextAlign.center,
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
                      color: Color(0xFF0A1F44),
                      fontSize: 21,
                      height: 1.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            Text(
              AppLocalizations.of(context).uiHadisISerif,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0A1F44),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '"${item.icerik}"',
              textAlign: TextAlign.center,
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
                color: Color(0xFF172B4D),
                fontSize: 14,
                height: 1.65,
                fontWeight: FontWeight.w600,
              ),
            ),
            if ((item.kaynak ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 13),
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    color: Color(0xFF0A1F44),
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.kaynak!,
                      textAlign: TextAlign.center,
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
                        color: Color(0xFF718096),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
