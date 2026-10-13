import 'package:flutter/material.dart';
import '../../../../app/shadows.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../prayer/data/prayer_service.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _green = Color(0xFF2FAE7F);

class PrayerRowV2 extends StatefulWidget {
  const PrayerRowV2({super.key});
  @override
  State<PrayerRowV2> createState() => _PrayerRowV2State();
}

class _PrayerRowV2State extends State<PrayerRowV2> {
  final _service = PrayerService();
  PrayerTimeResult? _result;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('prayer_city_v2') ?? 'İstanbul';
    final r = await _service.calculateForCity(city);
    if (!mounted) return;
    setState(() => _result = r);
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    if (r == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final next = r.nextPrayerName;
    final items = r.times.entries.toList();
    final gunesDog = r.times['Güneş'];
    final gunesStr = gunesDog != null ? _t(gunesDog) : '--:--';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Bugünün Namaz Vakitleri', style: TextStyle(color: _navy, fontSize: 15, fontWeight: FontWeight.w900)),
              const Spacer(),
              const Icon(Icons.wb_sunny_outlined, color: Color(0xFFF59E0B), size: 14),
              const SizedBox(width: 4),
              Text('Güneş Doğuşu $gunesStr',
                style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: items.map((e) {
              final isNext = e.key == next;
              final isPast = e.value.isBefore(now);
              final statusColor = isNext ? _red : (isPast ? _green : Colors.grey[300]!);
              return Expanded(child: _PrayerTile(
                name: e.key,
                time: _t(e.value),
                isNext: isNext,
                isPast: isPast,
                statusColor: statusColor,
              ));
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _t(DateTime d) => '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
}

class _PrayerTile extends StatelessWidget {
  final String name;
  final String time;
  final bool isNext;
  final bool isPast;
  final Color statusColor;
  const _PrayerTile({required this.name, required this.time, required this.isNext, required this.isPast, required this.statusColor});

  IconData _icon() {
    switch (name) {
      case 'İmsak': return Icons.nightlight_round;
      case 'Güneş': return Icons.wb_sunny_rounded;
      case 'Öğle': return Icons.wb_sunny_outlined;
      case 'İkindi': return Icons.wb_twilight;
      case 'Akşam': return Icons.nights_stay_outlined;
      case 'Yatsı': return Icons.dark_mode_rounded;
      default: return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: isNext ? _red.withValues(alpha: 0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isNext ? Border.all(color: _red.withValues(alpha: 0.4), width: 1.2) : null,
      ),
      child: Column(
        children: [
          Icon(_icon(), color: isNext ? _red : _navy, size: 18),
          const SizedBox(height: 6),
          Text(name, style: TextStyle(color: isNext ? _red : _navy, fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(time, style: TextStyle(color: isNext ? _red : _navy, fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          isNext
            ? const Icon(Icons.notifications_active_rounded, color: _red, size: 12)
            : (isPast
                ? const Icon(Icons.check_circle_rounded, color: _green, size: 12)
                : Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!, width: 1.5)))),
        ],
      ),
    );
  }
}
