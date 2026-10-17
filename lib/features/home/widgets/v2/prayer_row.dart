import 'package:flutter/material.dart';
import '../../../../app/shadows.dart';
import 'package:provider/provider.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
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
  String _city = '';
  bool _loading = false;

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
      debugPrint('PrayerRow: calculating for $_city');
      final r = await _service
          .calculateForCity(_city)
          .timeout(const Duration(seconds: 8));
      if (!mounted) return;
      debugPrint('PrayerRow: OK -> ${r?.times.length} vakit');
      setState(() => _result = r);
    } catch (e, st) {
      debugPrint('PrayerRow error: $e');
      debugPrint('Stack: $st');
      if (mounted) {
        setState(() => _result = null);
      }
    } finally {
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    if (r == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.medium(),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Namaz vakitleri yukleniyor...',
                style: TextStyle(
                    color: Color(0xFF0A1F44),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }
    final now = DateTime.now();
    final next = r.nextPrayerName;
    final items = r.times.entries.toList();
    final gunesDog = r.times['Gunes'];
    final gunesStr = gunesDog != null ? _t(gunesDog) : '--:--';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
              const Text('Bugunun Namaz Vakitleri',
                  style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w900)),
              const Spacer(),
              const Icon(Icons.wb_sunny_rounded,
                  color: Color(0xFFF59E0B), size: 14),
              const SizedBox(width: 4),
              Text('Gunes $gunesStr',
                  style: const TextStyle(
                      color: Color(0xFFF59E0B),
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: items.map((e) {
              final isNext = e.key == next;
              final isPast = e.value.isBefore(now);
              return Expanded(
                child: _PrayerTile(
                  name: e.key,
                  time: _t(e.value),
                  isNext: isNext,
                  isPast: isPast,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _t(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _PrayerTile extends StatelessWidget {
  final String name;
  final String time;
  final bool isNext;
  final bool isPast;
  const _PrayerTile({
    required this.name,
    required this.time,
    required this.isNext,
    required this.isPast,
  });

  IconData _icon() {
    switch (name) {
      case 'Imsak':
        return Icons.nights_stay_rounded;
      case 'Gunes':
        return Icons.wb_sunny_rounded;
      case 'Ogle':
        return Icons.wb_sunny_outlined;
      case 'Ikindi':
        return Icons.wb_twilight_rounded;
      case 'Aksam':
        return Icons.nights_stay_outlined;
      case 'Yatsi':
        return Icons.dark_mode_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = isNext ? _red : _navy;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: isNext ? _red.withValues(alpha: 0.06) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isNext
            ? Border.all(color: _red.withValues(alpha: 0.35), width: 1.2)
            : null,
      ),
      child: Column(
        children: [
          Icon(_icon(), color: activeColor, size: 22),
          const SizedBox(height: 8),
          Text(name,
              style: TextStyle(
                  color: activeColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(time,
              style: TextStyle(
                  color: activeColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          _statusDot(),
        ],
      ),
    );
  }

  Widget _statusDot() {
    if (isNext) {
      return Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          color: _red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _red.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.notifications_active_rounded,
            color: Colors.white, size: 12),
      );
    }
    if (isPast) {
      return Container(
        width: 20, height: 20,
        decoration: const BoxDecoration(
          color: _green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded,
            color: Colors.white, size: 14),
      );
    }
    return Container(
      width: 20, height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.grey.withValues(alpha: 0.4), width: 1.5),
      ),
    );
  }
}