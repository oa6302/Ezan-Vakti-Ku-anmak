import 'package:flutter/material.dart';
import 'package:nur_pusulasi/widgets/nur_kart.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_card_wrapper.dart';

class DailyVerseCard extends StatelessWidget {
  const DailyVerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ListenableBuilder(
        listenable: ContentService.instance,
        builder: (context, _) {
          final now = DateTime.now();
          final dailyRecord =
              ContentService.instance.getDailyRecordForDate(now);
          final dailyAyet = dailyRecord?.extra?['ayet']?.toString() ??
              dailyRecord?.icerik ??
              '';
          final hasDailyVerse = dailyAyet.trim().isNotEmpty &&
              !ContentService.instance.planliMi(ContentType.ayet, now);
          final poolItem =
              ContentService.instance.getDailyPoolItem(ContentType.ayet, now);
          final item = hasDailyVerse ? dailyRecord : poolItem;
          if (item == null) return const SizedBox.shrink();

          final tarih =
              '${now.day.toString().padLeft(2, "0")}.${now.month.toString().padLeft(2, "0")}.${now.year}';
          final konu = dailyRecord?.extra?['gunKonu']?.toString() ??
              dailyRecord?.baslik ??
              'Günün Ayeti';
          final ayet = hasDailyVerse
              ? dailyAyet
              : (poolItem?.altIcerik ?? poolItem?.icerik ?? '');
          final kaynak = hasDailyVerse
              ? (dailyRecord?.extra?['ayetKaynak']?.toString() ??
                  dailyRecord?.kaynak ??
                  '')
              : (poolItem?.kaynak ?? poolItem?.baslik ?? '');
          final ayetArapca = hasDailyVerse
              ? (dailyRecord?.extra?['ayetArapca']?.toString() ?? '')
              : (poolItem?.arapca ?? poolItem?.icerik ?? '');
          final ayetTefsir =
              dailyRecord?.extra?['ayetTefsir']?.toString() ?? '';

          return AdminCaptureCard(
            item: item,
            shareText: 'Günün Ayeti: $ayet\n$kaynak',
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 58),
              decoration: NurKartStili.kutu(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFC8102E),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x330A1F44),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Color(0x55FFFFFF),
                                blurRadius: 4,
                                offset: Offset(-2, -2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: Color(0xFF142747),
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context).verseOfDay,
                          style: TextStyle(
                            color: Color(0xFF142747),
                            shadows: [
                              Shadow(
                                  color: Color(0x99000000),
                                  blurRadius: 9,
                                  offset: Offset(0, 4)),
                              Shadow(
                                  color: Color(0x55000000),
                                  blurRadius: 3,
                                  offset: Offset(0, 2)),
                            ],
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(tarih,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xFF64748B),
                            shadows: [
                              Shadow(
                                  color: Color(0x99000000),
                                  blurRadius: 9,
                                  offset: Offset(0, 4)),
                              Shadow(
                                  color: Color(0x55000000),
                                  blurRadius: 3,
                                  offset: Offset(0, 2)),
                            ],
                            fontSize: 11,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(
                      konu,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        shadows: [
                          Shadow(
                              color: Color(0x99000000),
                              blurRadius: 9,
                              offset: Offset(0, 4)),
                          Shadow(
                              color: Color(0x55000000),
                              blurRadius: 3,
                              offset: Offset(0, 2)),
                        ],
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (ayetArapca.trim().isNotEmpty) ...[
                      Text(ayetArapca,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xFF142747),
                              shadows: [
                                Shadow(
                                    color: Color(0x99000000),
                                    blurRadius: 9,
                                    offset: Offset(0, 4)),
                                Shadow(
                                    color: Color(0x55000000),
                                    blurRadius: 3,
                                    offset: Offset(0, 2)),
                              ],
                              fontSize: 20,
                              height: 1.9)),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      ayet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF142747),
                        shadows: [
                          Shadow(
                              color: Color(0x99000000),
                              blurRadius: 9,
                              offset: Offset(0, 4)),
                          Shadow(
                              color: Color(0x55000000),
                              blurRadius: 3,
                              offset: Offset(0, 2)),
                        ],
                        fontSize: 15,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (ayetTefsir.trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context).uiKisaTefsir,
                          style: TextStyle(
                              color: Color(0xFF142747),
                              shadows: [
                                Shadow(
                                    color: Color(0x99000000),
                                    blurRadius: 9,
                                    offset: Offset(0, 4)),
                                Shadow(
                                    color: Color(0x55000000),
                                    blurRadius: 3,
                                    offset: Offset(0, 2)),
                              ],
                              fontSize: 11,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(ayetTefsir,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: Color(0xFF334155),
                              shadows: [
                                Shadow(
                                    color: Color(0x99000000),
                                    blurRadius: 9,
                                    offset: Offset(0, 4)),
                                Shadow(
                                    color: Color(0x55000000),
                                    blurRadius: 3,
                                    offset: Offset(0, 2)),
                              ],
                              fontSize: 13,
                              height: 1.5)),
                    ],
                    Text(
                      kaynak,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        shadows: [
                          Shadow(
                              color: Color(0x99000000),
                              blurRadius: 9,
                              offset: Offset(0, 4)),
                          Shadow(
                              color: Color(0x55000000),
                              blurRadius: 3,
                              offset: Offset(0, 2)),
                        ],
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
