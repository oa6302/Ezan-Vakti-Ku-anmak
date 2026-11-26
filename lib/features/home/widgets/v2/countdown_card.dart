import 'dart:async';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/shadows.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import '../../../prayer/data/prayer_service.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);

class NextPrayerCountdown extends StatefulWidget {
  const NextPrayerCountdown({super.key});
  @override
  State<NextPrayerCountdown> createState() => _NextPrayerCountdownState();
}

class _NextPrayerCountdownState extends State<NextPrayerCountdown>
    with SingleTickerProviderStateMixin {
  final _service = PrayerService();
  PrayerTimeResult? _result;
  Timer? _timer;
  late final AnimationController _breath;
  String _konumAnahtari = '';
  String _konumAdi = '';
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breath.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Il, ilce veya GPS degisince yeniden hesapla (tek kaynak: AppState)
    final s = context.watch<AppState>();
    final anahtar = '${s.city}|${s.lat}|${s.lng}';
    if (anahtar != _konumAnahtari || _result == null) {
      _konumAnahtari = anahtar;
      _konumAdi = s.locationName;
      _load(s);
    }
  }

  Future<void> _load(AppState s) async {
    final generation = ++_loadGeneration;
    try {
      final r = await _service
          .calculateForLocation(
              city: s.city, lat: s.lat, lng: s.lng, label: s.locationName)
          .timeout(const Duration(seconds: 8));
      if (!mounted || generation != _loadGeneration) return;
      setState(() => _result = r);
    } catch (e, st) {
      debugPrint('Countdown error: $e');
      debugPrint('Stack: $st');
      if (mounted && generation == _loadGeneration) {
        setState(() => _result = null);
      }
    } finally {}
  }

  /// Saniye destekli format: "02:15:34"
  String _fmtFull(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// Vakite gore renk paleti
  Color _vakitRengi(String name) {
    switch (name) {
      case 'Imsak':
        return const Color(0xFF1F4E79); // gece lacivert
      case 'Ogle':
        return const Color(0xFFF59E0B); // ogle turuncu
      case 'Ikindi':
        return const Color(0xFFEA580C); // ikindi kizil-turuncu
      case 'Aksam':
        return const Color(0xFFB71C1C); // aksam kizil
      case 'Yatsi':
        return const Color(0xFF1A2E4A); // yatsi koyu lacivert
      default:
        return _gold;
    }
  }

  /// Onceki vakit -> simdiki ilerleme yuzdesi (0..1)
  double _progress(PrayerTimeResult r) {
    final now = DateTime.now();
    final entries = r.times.entries.where((e) => e.key != 'Gunes').toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    if (entries.isEmpty) return 0;

    // Simdiki vakit hangisi?
    DateTime? prevTime;
    DateTime? nextTime;
    for (var i = 0; i < entries.length; i++) {
      final t = entries[i].value;
      if (t.isAfter(now)) {
        nextTime = t;
        prevTime = i == 0 ? null : entries[i - 1].value;
        break;
      }
    }
    // Bugun hepsi gectiyse yarin Imsak
    if (nextTime == null) {
      nextTime = entries.first.value.add(const Duration(days: 1));
      prevTime = entries.last.value;
    }
    if (prevTime == null) return 0;
    final total = nextTime.difference(prevTime).inSeconds;
    final elapsed = now.difference(prevTime).inSeconds;
    if (total <= 0) return 0;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    if (r == null || r.nextPrayerName == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppShadows.medium(),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                  AppLocalizations.of(context)
                      .uiFVakitleriYukleniyor(_konumAdi),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xFF0A1F44),
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    }
    final name = r.nextPrayerName!;
    final time = r.nextPrayerTime!;
    final remain = time.difference(DateTime.now());
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    final namazAdi = name == 'Imsak' ? 'Sabah' : name;
    final renk = _vakitRengi(name);
    final progress = _progress(r);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_navy, _navyDeep, renk.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: renk.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Nefes alan ikon + progress ring
                      AnimatedBuilder(
                        animation: _breath,
                        builder: (context, _) {
                          final scale = 1.0 + (_breath.value * 0.06);
                          return SizedBox(
                            width: 68,
                            height: 68,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Progress ring
                                CustomPaint(
                                  size: const Size(68, 68),
                                  painter: _RingPainter(
                                    progress: progress,
                                    color: renk,
                                    bgColor:
                                        Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),
                                // Nefes alan cami ikonu
                                Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: renk.withValues(alpha: 0.18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: renk.withValues(alpha: 0.4),
                                          blurRadius: 14,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.mosque_rounded,
                                        color: _gold, size: 28),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                  AppLocalizations.of(context).nextPrayer,
                                  style: TextStyle(
                                      color: _gold,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(height: 6),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(
                                opacity: anim,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(anim),
                                  child: child,
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)
                                    .uiFNamazi(namazAdi),
                                key: ValueKey(namazAdi),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          color: Colors.white70, size: 15),
                      const SizedBox(width: 5),
                      Text(timeStr,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(width: 10),
                      // Canli saniye gostergesi (dar ekranda tasmasin)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: renk.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: renk.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: renk,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .uiFKaldi(_fmtFull(remain)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        fontFeatures: [
                                          FontFeature.tabularFigures(),
                                        ])),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white.withValues(alpha: 0.15),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppLocalizations.of(context).uiNamazMumininNMiracidir,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(AppLocalizations.of(context).uiTirmiziSalat1,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vakit ilerlemesini gosteren ring (custom painter)
class _RingPainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;
  final Color bgColor;
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 6) / 2;
    const strokeW = 3.0;

    // Arka plan
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..color = bgColor;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // 12 yonunden basla
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
