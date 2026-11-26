import 'package:flutter/material.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';
import 'package:nur_pusulasi/features/kissa/pages/kissa_kutuphanesi_page.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';

class Kissa365Card extends StatefulWidget {
  const Kissa365Card({super.key});

  @override
  State<Kissa365Card> createState() => _Kissa365CardState();
}

class _Kissa365CardState extends State<Kissa365Card> {
  final _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (islamiKissalar.isEmpty) {
      return const SizedBox.shrink();
    }

    final bugun = DateTime.now();
    final gunNo = bugun.difference(DateTime(bugun.year, 1, 1)).inDays;
    final kissa = islamiKissalar[gunNo % islamiKissalar.length];
    // Kartta kissanin baslangici; devami detay sayfasinda
    final ozet = kissa.baslangic.isNotEmpty ? kissa.baslangic : kissa.hisse;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFD0C79F), width: 1.2),
        gradient: const LinearGradient(
            colors: [Color(0xFFF0F0E4), Color(0xFFE4E4D0), Color(0xFFF8F5E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(
            color: Color(0x383F4934),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ============================================
          // 1) KART İÇERİĞİ (indirilecek / paylaşılacak alan)
          // ============================================
          RepaintBoundary(
            key: _repaintKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E8D8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          kissa.ikon,
                          color: const Color(0xFFE8C77A),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).uiGununKissasi,
                              style: TextStyle(
                                color: Color(0xFFE8C77A),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.3,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)
                                  .uiHerKissadaBirHikmet,
                              style: TextStyle(
                                color: Color(0xFF0A1F44),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.auto_stories_rounded,
                        color: Color(0xFF9B8751),
                        size: 23,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Başlık
                  Text(
                    kissa.baslik,
                    style: const TextStyle(
                      shadows: [
                        Shadow(
                            color: Color(0x55000000),
                            blurRadius: 7,
                            offset: Offset(0, 3)),
                        Shadow(
                            color: Color(0x22000000),
                            blurRadius: 2,
                            offset: Offset(0, 1)),
                      ],
                      color: Color(0xFF0A1F44),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      height: 1.4,
                    ),
                  ),

                  // Özet
                  if (ozet.trim().isNotEmpty) ...[
                    const SizedBox(height: 11),
                    Text(
                      ozet,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        shadows: [
                          Shadow(
                              color: Color(0x55000000),
                              blurRadius: 7,
                              offset: Offset(0, 3)),
                          Shadow(
                              color: Color(0x22000000),
                              blurRadius: 2,
                              offset: Offset(0, 1)),
                        ],
                        color: Color(0xFF26364D),
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),
                  ],
                  const SizedBox(height: 17),

                  // Kissadan Hisse
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF6),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          color: Color(0xFFE8C77A),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).uiKissadanHisse,
                                style: TextStyle(
                                  color: Color(0xFFE8C77A),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                kissa.hisse,
                                style: const TextStyle(
                                  shadows: [
                                    Shadow(
                                        color: Color(0x55000000),
                                        blurRadius: 7,
                                        offset: Offset(0, 3)),
                                    Shadow(
                                        color: Color(0x22000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1)),
                                  ],
                                  color: Color(0xFF0A1F44),
                                  fontSize: 13,
                                  height: 1.6,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),

                  // Kaynak
                  Text(
                    kissa.kaynak,
                    style: const TextStyle(
                      shadows: [
                        Shadow(
                            color: Color(0x55000000),
                            blurRadius: 7,
                            offset: Offset(0, 3)),
                        Shadow(
                            color: Color(0x22000000),
                            blurRadius: 2,
                            offset: Offset(0, 1)),
                      ],
                      color: Color(0xFF526078),
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================
          // 2) MODERN PİLL BAR (kartın içinde, ortada, derin gölgeli)
          // ============================================
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: CardOverlayActions(
                layout: CardActionLayout.modernBottom,
                isDark: false,
                repaintKey: _repaintKey,
                shareText:
                    '${kissa.baslik}\n\n${kissa.hisse}\n\n— ${kissa.kaynak}',
              ),
            ),
          ),

          // ============================================
          // 3) ALTIN CTA BUTONU
          // ============================================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Material(
              color: const Color(0xFFD8C58D),
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => KissaDetayPage(kissa: kissa),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).uiKissaDevaminiOku,
                          style: TextStyle(
                            color: Color(0xFF10264B),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF10264B),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ============================================
          // 4) FOOTER
          // ============================================
          Padding(
            padding: EdgeInsets.fromLTRB(20, 11, 20, 20),
            child: Center(
              child: Text(
                AppLocalizations.of(context).uiGecmisinHadisesindenBugununIman,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF526078),
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
