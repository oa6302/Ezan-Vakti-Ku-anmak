import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../data/prayer_service.dart';

class PrayerTimesWidget extends StatefulWidget {
  const PrayerTimesWidget({super.key});

  @override
  State<PrayerTimesWidget> createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  final _service = PrayerService();
  PrayerTimes? _times;
  bool _loading = true;
  String _city = 'Istanbul';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _city = prefs.getString('prayer_city') ?? 'Istanbul';
    setState(() => _loading = true);
    final t = await _service.fetch(city: _city);
    if (!mounted) return;
    setState(() {
      _times = t;
      _loading = false;
    });
  }

  Future<void> _changeCity() async {
    final controller = TextEditingController(text: _city);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Şehir Seç'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Örn. Istanbul, Ankara, Izmir',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal')),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Kaydet')),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayer_city', result);
    _city = result;
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [navy, navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 8),
              const Text('Namaz Vakitleri',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
              const Spacer(),
              TextButton.icon(
                onPressed: _changeCity,
                icon: const Icon(Icons.location_on_rounded,
                    color: Colors.white70, size: 16),
                label: Text(_city,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                  child: CircularProgressIndicator(color: Colors.white)),
            )
          else if (_times == null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text('Vakitler alınamadı',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _load,
                    style: FilledButton.styleFrom(backgroundColor: red),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            )
          else ...[
            if (_times!.nextPrayerName != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_rounded,
                        color: Color(0xFFFFD8DE), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Sıradaki: ${_times!.nextPrayerName} · ${_times!.nextPrayerTime}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: _times!.times.entries.map((e) {
                final isNext = e.key == _times!.nextPrayerName;
                return Container(
                  decoration: BoxDecoration(
                    color: isNext
                        ? red.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(e.key,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(e.value,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}