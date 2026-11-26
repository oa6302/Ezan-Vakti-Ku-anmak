import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import 'package:nur_pusulasi/features/prayer/data/turkish_cities.dart';
import 'package:nur_pusulasi/features/prayer/data/turkish_districts.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);

String _normalize(String value) {
  return value
      .replaceAll('Ä±', 'ı')
      .replaceAll('Ä°', 'İ')
      .replaceAll('Åž', 'Ş')
      .replaceAll('ÅŸ', 'ş')
      .replaceAll('Ã§', 'ç')
      .replaceAll('Ã‡', 'Ç')
      .replaceAll('Ã¶', 'ö')
      .replaceAll('Ã–', 'Ö')
      .replaceAll('Ã¼', 'ü')
      .replaceAll('Ãœ', 'Ü')
      .replaceAll('ÄŸ', 'ğ')
      .replaceAll('Äž', 'Ğ')
      .toLowerCase();
}

Future<void> showCityPicker(BuildContext context) async {
  final appState = context.read<AppState>();

  final selectedCity = await showModalBottomSheet<TurkishCity>(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _CityPickerSheet(current: appState.city),
  );

  if (selectedCity == null || !context.mounted) return;

  final districts = turkishDistricts
      .where((d) => _normalize(d.cityName) == _normalize(selectedCity.name))
      .toList();

  if (districts.isEmpty) {
    await appState.setCity(
      selectedCity.name,
      lat: selectedCity.lat,
      lng: selectedCity.lng,
    );
    return;
  }

  final district = await showModalBottomSheet<TurkishDistrict>(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _DistrictPickerSheet(
      cityName: selectedCity.name,
      current: appState.district,
      districts: districts,
    ),
  );

  if (district == null || !context.mounted) return;

  await appState.setCity(
    selectedCity.name,
    district: district.name,
    lat: district.lat,
    lng: district.lng,
  );
}

class _CityPickerSheet extends StatefulWidget {
  final String current;

  const _CityPickerSheet({required this.current});

  @override
  State<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<_CityPickerSheet> {
  final _ctrl = TextEditingController();
  late List<TurkishCity> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = turkishCities;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _filter(String q) {
    setState(() {
      if (q.isEmpty) {
        _filtered = turkishCities;
      } else {
        final lower = _normalize(q);
        _filtered = turkishCities
            .where((c) => _normalize(c.name).contains(lower))
            .toList();
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
                Row(
                  children: [
                    const Text(
                      'Konum Seç',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final message = await context
                          .read<AppState>()
                          .updateFromCurrentLocation();
                      if (!context.mounted) return;
                      if (message == null) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                    },
                    icon: const Icon(Icons.my_location_rounded),
                    label: const Text('GPS ile Konum Bul'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Manuel Seç',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _ctrl,
                  onChanged: _filter,
                  decoration: InputDecoration(
                    hintText: 'İl ara...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: _navy,
                    ),
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
                    color: selected ? _red : _navy,
                  ),
                  title: Text(
                    c.name,
                    style: TextStyle(
                      color: _navy,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DistrictPickerSheet extends StatefulWidget {
  final String cityName;
  final String current;
  final List<TurkishDistrict> districts;

  const _DistrictPickerSheet({
    required this.cityName,
    required this.current,
    required this.districts,
  });

  @override
  State<_DistrictPickerSheet> createState() => _DistrictPickerSheetState();
}

class _DistrictPickerSheetState extends State<_DistrictPickerSheet> {
  final _ctrl = TextEditingController();
  late List<TurkishDistrict> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.districts;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _filter(String q) {
    setState(() {
      if (q.isEmpty) {
        _filtered = widget.districts;
      } else {
        final lower = _normalize(q);
        _filtered = widget.districts
            .where((d) => _normalize(d.name).contains(lower))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.cityName} İlçeleri',
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ctrl,
                  onChanged: _filter,
                  decoration: InputDecoration(
                    hintText: 'İlçe ara...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: _navy,
                    ),
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
                final district = _filtered[i];
                final selected = district.name == widget.current;

                return ListTile(
                  leading: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.location_on_rounded,
                    color: selected ? _red : _navy,
                  ),
                  title: Text(
                    district.name,
                    style: TextStyle(
                      color: _navy,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, district),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
