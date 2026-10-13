import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../prayer/data/prayer_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const months = ['Ocak','Şubat','Mart','Nisan','Mayıs','Haziran','Temmuz','Ağustos','Eylül','Ekim','Kasım','Aralık'];
    const days = ['Pazartesi','Salı','Çarşamba','Perşembe','Cuma','Cumartesi','Pazar'];
    final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}';
    final dayStr = days[now.weekday - 1];
    final greeting = now.hour < 12 ? 'Hayırlı sabahlar' : now.hour < 18 ? 'Hayırlı gündüzler' : 'Hayırlı akşamlar';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [navy, navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: const Icon(Icons.access_time_filled_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('5 Vakit Namaz',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                        Text('Namazla huzura, ibadetle huşuya',
                            style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(greeting, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 3),
              const Text('5 Vakit Namaz Kullanıcısı',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 13),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text('$dateStr · $dayStr',
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const _LivePrayerBadge(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LivePrayerBadge extends StatefulWidget {
  const _LivePrayerBadge();

  @override
  State<_LivePrayerBadge> createState() => _LivePrayerBadgeState();
}

class _LivePrayerBadgeState extends State<_LivePrayerBadge> {
  final _service = PrayerService();
  PrayerTimeResult? _result;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    // Her dakika güncelle
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(minutes: 1));
      if (!mounted) return false;
      if (mounted) setState(() {});
      return true;
    });
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('prayer_city_v2') ?? 'İstanbul';
    final result = await _service.calculateForCity(city);
    if (!mounted) return;
    setState(() {
      _result = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const SizedBox(
          width: 14, height: 14,
          child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2),
        ),
      );
    }

    if (_result == null || _result!.nextPrayerName == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time_filled_rounded, color: Colors.white70, size: 13),
            SizedBox(width: 5),
            Text('Vakit alınamadı', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      );
    }

    final name = _result!.nextPrayerName!;
    final time = _result!.nextPrayerTime!;
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: red.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_filled_rounded, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text('$name $timeStr',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
