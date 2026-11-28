import 'package:flutter/material.dart';
import 'package:nur_pusulasi/widgets/nur_kart.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import '../../../../app/content_service.dart';
import '../../../../widgets/admin_card_wrapper.dart';
import 'dua_detay_page.dart';

const _navy = Color(0xFF142747);
const _red = Color(0xFFC8102E);

class DuaCard extends StatelessWidget {
  const DuaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ContentService.instance,
      builder: (context, _) {
        final now = DateTime.now();
        final daily = ContentService.instance.getDailyRecordForDate(now);
        final dailyExtra = daily?.extra ?? {};
        final hasDailyDua = !ContentService.instance
                .planliMi(ContentType.dua, now) &&
            ((dailyExtra['duaArapca']?.toString().trim().isNotEmpty ?? false) ||
                (dailyExtra['duaAnlam']?.toString().trim().isNotEmpty ??
                    false) ||
                (dailyExtra['duaOkunus']?.toString().trim().isNotEmpty ??
                    false));
        final poolDua =
            ContentService.instance.getDailyPoolItem(ContentType.dua, now);
        final dua = hasDailyDua ? daily : poolDua;
        if (dua == null) return const SizedBox.shrink();

        final extra = dua.extra ?? {};
        final duaBaslik = hasDailyDua
            ? (extra['duaBaslik']?.toString() ?? dua.baslik)
            : dua.baslik;
        final duaArapca = hasDailyDua
            ? (extra['duaArapca']?.toString() ?? '')
            : (dua.arapca ?? '');
        final duaAnlam = hasDailyDua
            ? (extra['duaAnlam']?.toString() ?? '')
            : (dua.altIcerik ?? '');
        final duaKaynak = hasDailyDua
            ? (extra['duaKaynak']?.toString() ?? '')
            : (dua.kaynak ?? '');
        final duaKategori = hasDailyDua
            ? (extra['duaKategori']?.toString() ?? 'Genel')
            : (dua.kategori ?? 'Genel');

        return AdminCaptureCard(
          item: dua,
          shareText: 'Günün Duası: $duaBaslik\n$duaAnlam\n($duaKaynak)',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => DuaDetayPage(dua: dua)),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.only(bottom: 48),
                decoration: NurKartStili.kutu(),
                child: Row(
                  children: [
                    Container(
                      width: 110,
                      height: 150,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF365879), Color(0xFF193653)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: const Color(0xFFFCE8EB),
                              width: 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x66000000),
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Color(0x66FFFFFF),
                                blurRadius: 5,
                                offset: Offset(-2, -2),
                              ),
                            ],
                          ),
                          child: Icon(
                            ContentService.instance.iconFor(dua),
                            color: _navy,
                            size: 42,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(AppLocalizations.of(context).duaOfDay,
                                    style: TextStyle(
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
                                        color: _navy,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: ContentService.instance
                                        .colorFor(dua)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(duaKategori,
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
                                          color: ContentService.instance
                                              .colorFor(dua),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700)),
                                ),
                                const Spacer(),
                                const Icon(Icons.bookmark_border_rounded,
                                    color: _red, size: 18),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(duaBaslik,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                                    color: _navy,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            Text(duaArapca,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                    fontSize: 13,
                                    color: _navy.withValues(alpha: 0.85),
                                    fontWeight: FontWeight.w600,
                                    height: 1.5)),
                            const SizedBox(height: 4),
                            Text(duaAnlam,
                                textAlign: TextAlign.justify,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
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
                                    color: _navy,
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    height: 1.4)),
                            const SizedBox(height: 4),
                            Text('($duaKaynak)',
                                style: const TextStyle(shadows: [
                                  Shadow(
                                      color: Color(0x99000000),
                                      blurRadius: 9,
                                      offset: Offset(0, 4)),
                                  Shadow(
                                      color: Color(0x55000000),
                                      blurRadius: 3,
                                      offset: Offset(0, 2)),
                                ], color: Colors.black45, fontSize: 10)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    AppLocalizations.of(context).uiIcerikHavuzu,
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
                                        color:
                                            Colors.black.withValues(alpha: 0.4),
                                        fontSize: 9)),
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: _navy,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.play_arrow_rounded,
                                      color: Colors.white, size: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
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
