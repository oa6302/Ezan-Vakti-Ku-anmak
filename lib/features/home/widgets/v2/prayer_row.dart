import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import '../../../prayer/data/prayer_service.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFD9853B);
const _green = Color(0xFF2FAE7F);

class PrayerRowV2 extends StatefulWidget {
  const PrayerRowV2({super.key});
  @override
  State<PrayerRowV2> createState() => _PrayerRowV2State();
}

class _PrayerRowV2State extends State<PrayerRowV2> {
  final _service = PrayerService();
  PrayerTimeResult? _result;
  String _konumAnahtari = '';
  int _loadGeneration = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Il, ilce veya GPS degisince yeniden hesapla (tek kaynak: AppState)
    final s = context.watch<AppState>();
    final anahtar = '${s.city}|${s.lat}|${s.lng}';
    if (anahtar != _konumAnahtari || _result == null) {
      _konumAnahtari = anahtar;
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
      debugPrint('PrayerRow error: $e');
      debugPrint('Stack: $st');
      if (mounted && generation == _loadGeneration) {
        setState(() => _result = null);
      }
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    if (r == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFF9FBFE), Color(0xFFEAF1F8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFD2DFEC)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x26334B67),
                blurRadius: 24,
                offset: Offset(0, 10)),
            BoxShadow(
                color: Color(0xAAFFFFFF), blurRadius: 5, offset: Offset(0, -2))
          ],
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
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
    final vakitSirasi = ['Imsak', 'Ogle', 'Ikindi', 'Aksam', 'Yatsi'];
    final items = vakitSirasi
        .where((key) => r.times.containsKey(key))
        .map((key) => MapEntry(key, r.times[key]!))
        .toList();
    final gunesDog = r.times['Gunes'];
    final gunesStr = gunesDog != null ? _t(gunesDog) : '--:--';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFF9FBFE), Color(0xFFEAF1F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD2DFEC)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x26334B67), blurRadius: 24, offset: Offset(0, 10)),
          BoxShadow(
              color: Color(0xAAFFFFFF), blurRadius: 5, offset: Offset(0, -2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Bugünün Namaz Vakitleri',
                  style: TextStyle(
                      color: _navy, fontSize: 15, fontWeight: FontWeight.w900)),
              const Spacer(),
              const Icon(Icons.wb_sunny_rounded,
                  color: Color(0xFFF59E0B), size: 14),
              const SizedBox(width: 4),
              Text('Güneş $gunesStr',
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

  String _displayName(String name) {
    switch (name) {
      case 'Imsak':
        return 'İmsak';
      case 'Ogle':
        return 'Öğle';
      case 'Ikindi':
        return 'İkindi';
      case 'Aksam':
        return 'Akşam';
      case 'Yatsi':
        return 'Yatsı';
      default:
        return name;
    }
  }

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
          Text(_displayName(name),
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
        width: 20,
        height: 20,
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
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: _green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
      );
    }
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(color: Colors.grey.withValues(alpha: 0.4), width: 1.5),
      ),
    );
  }
}
