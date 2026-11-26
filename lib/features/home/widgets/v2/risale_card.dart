import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_card_wrapper.dart';

const _red = Color(0xFF397B76);

const _deepShadow = [
  BoxShadow(
    color: Color(0x38345C58),
    blurRadius: 28,
    offset: Offset(0, 12),
  ),
];

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
        final hasDailyRisale = dailyMetin.trim().isNotEmpty;
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

        return AdminCaptureCard(
          item: r,
          lightFavorite: true,
          isDark: false,
          shareText:
              '${r.baslik}\n\n${risaleAlinti.isNotEmpty ? risaleAlinti : risaleMetin}\n\n— $risaleEser${risaleBolum.isNotEmpty ? " • $risaleBolum" : ""}',
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color(0xFFE9F2F0),
                Color(0xFFDCEBE7),
                Color(0xFFF8FAF6)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF9FC5BA),
                width: 1.4,
              ),
              boxShadow: _deepShadow,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.auto_stories_rounded,
                        size: 140, color: Color(0xFFD6B36A)),
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
                            child: const Text('RİSALE-İ NUR',
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
                                color: Color(0xFF0A1F44), size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        r.baslik,
                        style: const TextStyle(
                            color: Color(0xFF0A1F44),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      if (risaleAlinti.trim().isNotEmpty) ...[
                        Text(
                          '“$risaleAlinti”',
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
                      _RisaleInfografik(
                        konu: extra['gunKonu']?.toString() ?? r.baslik,
                        anahtarKelimeler: anahtarKelimeler,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF0CF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Risale-i Nur’dan ilhamla',
                              style: TextStyle(
                                  color: Color(0xFF0A1F44),
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
                          const Text('5 dk okuma',
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
        );
      },
    );
  }
}

class _RisaleInfografik extends StatelessWidget {
  final String konu;
  final List<String> anahtarKelimeler;

  const _RisaleInfografik({
    required this.konu,
    required this.anahtarKelimeler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6B36A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GÜNÜN İMAN-KÜFÜR MUVÂZENESİ',
            style: TextStyle(
              color: Color(0xFF0A1F44),
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
            ),
          ),
          const SizedBox(height: 5),
          Text(
            konu,
            style: const TextStyle(
              color: Color(0xFF0A1F44),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (anahtarKelimeler.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: anahtarKelimeler.map((kelime) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBC2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    kelime,
                    style: const TextStyle(
                      color: Color(0xFF0A1F44),
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
                      fontSize: 9,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MuvazeneTarafi(
                  baslik: 'İMAN PERSPEKTİFİ',
                  aciklama:
                      'Varlığı yaratılış, gaye ve sorumluluk bağı içinde değerlendirir.',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MuvazeneTarafi(
                  baslik: 'NATÜRALİST PERSPEKTİF',
                  aciklama:
                      'Olayları tabiat ve gözlemlenebilir süreçler üzerinden açıklar.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MuvazeneTarafi extends StatelessWidget {
  final String baslik;
  final String aciklama;

  const _MuvazeneTarafi({
    required this.baslik,
    required this.aciklama,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6F3),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0x55D6B36A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(
              color: Color(0xFF0A1F44),
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
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            aciklama,
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
              fontSize: 9,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
