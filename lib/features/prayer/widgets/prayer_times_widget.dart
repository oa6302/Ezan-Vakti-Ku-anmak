import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../data/prayer_service.dart';
import '../data/turkish_cities.dart';

class PrayerTimesWidget extends StatefulWidget {
  const PrayerTimesWidget({super.key});

  @override
  State<PrayerTimesWidget> createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  final _service = PrayerService();
  PrayerTimeResult? _result;
  bool _loading = true;
  String _city = 'İstanbul';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _city = prefs.getString('prayer_city_v2') ?? 'İstanbul';
    setState(() => _loading = true);

    final result = await _service.calculateForCity(_city);
    if (!mounted) return;
    setState(() {
      _result = result;
      _loading = false;
    });
  }

  Future<void> _selectCity() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CityPicker(current: _city),
    );
    if (selected == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayer_city_v2', selected);
    _city = selected;
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
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text('Namaz Vakitleri',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900)),
              const Spacer(),
              InkWell(
                onTap: _selectCity,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(_city,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(width: 2),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.white70, size: 16),
                    ],
                  ),
                ),
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
          else if (_result == null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text('Vakit hesaplanamadi',
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
            // Sıradaki vakit kartı
            if (_result!.nextPrayerName != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sıradaki: ${_result!.nextPrayerName}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      _result!.remainingText,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            // 6 vakit grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: _result!.times.entries.map((e) {
                final isNext = e.key == _result!.nextPrayerName;
                final timeStr =
                    '${e.value.hour.toString().padLeft(2, '0')}:${e.value.minute.toString().padLeft(2, '0')}';
                return Container(
                  decoration: BoxDecoration(
                    color: isNext
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(e.key,
                          style: TextStyle(
                              color: isNext ? navy : Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(timeStr,
                          style: TextStyle(
                              color: isNext ? navy : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: Colors.white54, size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${_result!.calculationMethod} · ${_result!.madhab} · Çevrimdışı hesaplama',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CityPicker extends StatefulWidget {
  final String current;
  const _CityPicker({required this.current});

  @override
  State<_CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<_CityPicker> {
  final _searchCtrl = TextEditingController();
  late List<TurkishCity> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = turkishCities;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter(String q) {
    setState(() {
      if (q.isEmpty) {
        _filtered = turkishCities;
      } else {
        final lower = q.toLowerCase();
        _filtered =
            turkishCities.where((c) => c.name.toLowerCase().contains(lower)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Şehir Seç',
                    style: TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchCtrl,
                  onChanged: _filter,
                  decoration: InputDecoration(
                    hintText: 'Şehir ara...',
                    prefixIcon: const Icon(Icons.search_rounded, color: navy),
                    filled: true,
                    fillColor: const Color(0xFFF3F6FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final selected = c.name == widget.current;
                return ListTile(
                  leading: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.location_city_rounded,
                    color: selected ? red : navy,
                  ),
                  title: Text(c.name,
                      style: TextStyle(
                          color: navy,
                          fontWeight:
                              selected ? FontWeight.w900 : FontWeight.w600)),
                  trailing: selected
                      ? const Icon(Icons.check_rounded, color: red)
                      : null,
                  onTap: () => Navigator.pop(context, c.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
