import 'package:flutter/material.dart';
import 'package:nur_pusulasi/widgets/nur_kart.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_card_wrapper.dart';
import 'package:nur_pusulasi/app/hakikat_servisi.dart';
import 'package:nur_pusulasi/features/hazine/hakikat/hakikat_ortak.dart'
    show hakikatAc;
import 'package:nur_pusulasi/features/hazine/hakikat/risale_pasaj_page.dart';
import 'package:nur_pusulasi/features/hazine/risale_dersleri_page.dart';

const _red = Color(0xFFC8102E);

class RisaleCard extends StatelessWidget {
  const RisaleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ContentService.instance,
      builder: (context, _) {
        final now = DateTime.now();
        final daily = ContentService.instance.getDailyRecordForDate(now);
        final dailyExtra = daily?.extra ?? {};
        final dailyMetin = dailyExtra['risaleHakikat']?.toString() ?? '';
        final poolRisale =
            ContentService.instance.getDailyPoolItem(ContentType.risale, now);
        final hasDailyRisale = dailyMetin.trim().isNotEmpty &&
            !ContentService.instance.planliMi(ContentType.risale, now);
        final r = hasDailyRisale ? daily! : poolRisale;
        if (r == null) return const SizedBox.shrink();

        final extra = r.extra ?? {};
        final risaleMetin = hasDailyRisale ? dailyMetin : r.icerik;
        final risaleAlinti = hasDailyRisale
            ? (extra['risaleAlinti']?.toString() ?? '')
            : r.icerik;
        final risaleEser = hasDailyRisale
            ? (extra['risaleEser']?.toString() ?? '')
            : r.kaynak ?? r.baslik;
        final risaleBolum = hasDailyRisale
            ? (extra['risaleBolum']?.toString() ?? '')
            : (r.kategori ?? '');
        final rawKeywords = hasDailyRisale ? extra['anahtarKelimeler'] : null;
        final anahtarKelimeler = rawKeywords is List
            ? rawKeywords
                .map((e) => e.toString())
                .where((e) => e.trim().isNotEmpty)
                .take(4)
                .toList()
            : <String>[];

        final t = AppLocalizations.of(context);
        void devaminiOku() => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) => RisalePasajPage(
                      baslik: r.baslik,
                      metin: risaleMetin,
                      alinti: risaleAlinti,
                      osmanlica: hasDailyRisale ? '' : (r.arapca ?? ''),
                      eser: risaleEser,
                      bolum: risaleBolum,
                      aynen: !hasDailyRisale && r.dogrulandi,
                    )));
        void kesfet() => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) => const RisaleDersleriPage()));
        final gunun = HakikatServisi.instance.gununHakikati(now);

        return AdminCaptureCard(
          item: r,
          lightFavorite: true,
          isDark: false,
          shareText:
              '${r.baslik}\n\n${risaleAlinti.isNotEmpty ? risaleAlinti : risaleMetin}\n\n— $risaleEser${risaleBolum.isNotEmpty ? " • $risaleBolum" : ""}',
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: NurKartStili.kutu(),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: devaminiOku,
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(Icons.auto_stories_rounded,
                            size: 140, color: Color(0xFFC8102E)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 54),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                    AppLocalizations.of(context).uiRisaleINur,
                                    style: TextStyle(
                                        color: Colors.white,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1)),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chevron_right_rounded,
                                    color: Color(0xFF142747), size: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            r.baslik,
                            style: const TextStyle(
                                color: Color(0xFF142747),
                                shadows: [
                                  Shadow(
                                      color: Color(0x30000000),
                                      blurRadius: 5,
                                      offset: Offset(0, 2)),
                                ],
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            risaleMetin,
                            style: const TextStyle(
                                color: Color(0xFF536174),
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
                                height: 1.5),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          if (hasDailyRisale &&
                              risaleAlinti.trim().isNotEmpty) ...[
                            Text(
                              '“$risaleAlinti”',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color(0xFF26364D),
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
                                  fontStyle: FontStyle.italic,
                                  height: 1.5),
                            ),
                            if (risaleEser.trim().isNotEmpty ||
                                risaleBolum.trim().isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                [risaleEser, risaleBolum]
                                    .where((v) => v.trim().isNotEmpty)
                                    .join(' • '),
                                style: const TextStyle(
                                    color: Color(0xFF687386),
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
                                    fontSize: 10),
                              ),
                            ],
                            const SizedBox(height: 12),
                          ],
                          if (anahtarKelimeler.isNotEmpty) ...[
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                for (final k in anahtarKelimeler)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCE8EB),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(k,
                                        style: const TextStyle(
                                            color: Color(0xFF142747),
                                            fontSize: 10)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (gunun != null)
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => hakikatAc(context, gunun),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F6FB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0x55D6B36A)),
                                ),
                                child: Row(children: [
                                  const Icon(Icons.wb_sunny_rounded,
                                      color: Color(0xFFC9A961), size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(t.hkGununHakikati,
                                              style: const TextStyle(
                                                  color: Color(0xFFB08A3E),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900)),
                                          Text(gunun.baslik,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Color(0xFF142747),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800)),
                                        ]),
                                  ),
                                  const Icon(Icons.chevron_right_rounded,
                                      color: Color(0xFF142747), size: 18),
                                ]),
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF142747),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10)),
                                onPressed: devaminiOku,
                                icon: const Icon(Icons.menu_book_rounded,
                                    size: 17),
                                label: Text(t.hkDevaminiOku,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: _red,
                                    side: const BorderSide(color: _red),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10)),
                                onPressed: kesfet,
                                icon:
                                    const Icon(Icons.explore_rounded, size: 17),
                                label: Text(t.hkHakikatiKesfet,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFCE8EB),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  !hasDailyRisale && r.dogrulandi
                                      ? t.hkAynen
                                      : t.uiRisaleINurDan,
                                  style: TextStyle(
                                      color: Color(0xFF142747),
                                      shadows: [
                                        Shadow(
                                            color: Color(0x30000000),
                                            blurRadius: 3,
                                            offset: Offset(0, 1)),
                                      ],
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.access_time_rounded,
                                  color: Color(0xFF7A8492), size: 12),
                              const SizedBox(width: 4),
                              Text(t.hkOkumaSuresi(okumaDakikasi(risaleMetin)),
                                  style: TextStyle(
                                      color: Color(0xFF7A8492),
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
                                      fontSize: 10)),
                            ],
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
