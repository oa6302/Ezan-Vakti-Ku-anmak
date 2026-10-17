import 'dart:async';
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

class _NextPrayerCountdownState extends State<NextPrayerCountdown> {
  final _service = PrayerService();
  PrayerTimeResult? _result;
  Timer? _timer;
  String _city = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final c = context.read<AppState>().city;
    final safe = c.trim().isEmpty ? 'Istanbul' : c;
    if (safe != _city || _result == null) {
      _city = safe;
      _load();
    }
  }

  Future<void> _load() async {
    if (_loading) return;
    _loading = true;
    try {
      debugPrint('Countdown: calculating for $_city');
      final r = await _service
          .calculateForCity(_city)
          .timeout(const Duration(seconds: 8));
      if (!mounted) return;
      debugPrint('Countdown: OK -> ${r?.nextPrayerName}');
      setState(() => _result = r);
    } catch (e, st) {
      debugPrint('Countdown error: $e');
      debugPrint('Stack: $st');
      if (mounted) {
        setState(() => _result = null);
      }
    } finally {
      _loading = false;
    }
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
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
              width: 24, height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 14),
            Text('$_city vakitleri yukleniyor...',
                style: const TextStyle(
                    color: Color(0xFF0A1F44),
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.deep(),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58, height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _gold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _gold.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.mosque_rounded,
                          color: _gold, size: 30),
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
                            child: const Text('Sonraki Namaz',
                                style: TextStyle(
                                    color: _gold,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(height: 6),
                          Text('$namazAdi Namazi',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900)),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _gold.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${_fmt(remain)} kaldi',
                          style: const TextStyle(
                              color: _gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.white.withValues(alpha: 0.15),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('"Namaz, muminin\n   miracidir."',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('(Tirmizi, Salat, 1)',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}