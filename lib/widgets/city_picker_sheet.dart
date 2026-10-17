import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import 'package:nur_pusulasi/features/prayer/data/turkish_cities.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);

Future<void> showCityPicker(BuildContext context) async {
  final appState = context.read<AppState>();
  final current = appState.city;

  final selected = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _CityPickerSheet(current: current),
  );

  if (selected == null) return;
  final city = findCity(selected);
  if (city == null) return;
  await appState.setCity(selected, lat: city.lat, lng: city.lng);
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
        final lower = q.toLowerCase();
        _filtered = turkishCities
            .where((c) => c.name.toLowerCase().contains(lower))
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
                const Text('Sehir Sec',
                    style: TextStyle(
                        color: _navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                TextField(
                  controller: _ctrl,
                  onChanged: _filter,
                  decoration: InputDecoration(
                    hintText: 'Sehir ara...',
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: _navy),
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
                  title: Text(c.name,
                      style: TextStyle(
                          color: _navy,
                          fontWeight: selected
                              ? FontWeight.w900
                              : FontWeight.w600)),
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