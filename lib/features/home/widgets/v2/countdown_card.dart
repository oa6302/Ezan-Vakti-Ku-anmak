import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('prayer_city_v2') ?? 'İstanbul';
    final r = await _service.calculateForCity(city);
    if (!mounted) return;
    setState(() => _result = r);
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    if (r == null || r.nextPrayerName == null) {
      return const SizedBox.shrink();
    }
    final name = r.nextPrayerName!;
    final time = r.nextPrayerTime!;
    final remain = time.difference(DateTime.now());
    final timeStr = '${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}';
    final namazAdi = name == 'İmsak' ? 'Sabah' : name;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.centerLeft, end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: _navy.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
            ),
            child: const Icon(Icons.mosque_rounded, color: _gold, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Sonraki Namaz', style: TextStyle(color: _gold, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 6),
                Text('$namazAdi Namazı', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(timeStr, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          Container(width: 1, height: 60, color: Colors.white24),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Kalan Süre', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, color: _gold, size: 16),
                  const SizedBox(width: 6),
                  Text(_fmt(remain), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

