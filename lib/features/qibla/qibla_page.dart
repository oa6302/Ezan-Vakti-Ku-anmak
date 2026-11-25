import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import '../prayer/data/turkish_cities.dart';
import '../prayer/data/turkish_districts.dart';
import '../../widgets/city_picker_sheet.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

// Kabe koordinatlari
const double _kabeLat = 21.4225;
const double _kabeLng = 39.8262;

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});
  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _heading;
  double? _qiblaBearing;
  double _lat = 41.0082;
  double _lng = 28.9784;
  String _cityName = 'İstanbul';
  bool _sensorAvailable = true;
  bool _locationGranted = false;
  bool _loading = true;
  bool _showMap = false;
  StreamSubscription<CompassEvent>? _sub;
  late AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = context.read<AppState>();
    _appState.addListener(_onAppStateChanged);
    _init();
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    _sub?.cancel();
    super.dispose();
  }

  void _onAppStateChanged() {
    if (!mounted) return;

    double? lat;
    double? lng;

    if (_appState.district.isNotEmpty) {
      for (final d in turkishDistricts) {
        if (d.cityName == _appState.city &&
            d.name == _appState.district) {
          lat = d.lat;
          lng = d.lng;
          break;
        }
      }
    }

    if (lat == null || lng == null) {
      final city = findCity(_appState.city);
      if (city != null) {
        lat = city.lat;
        lng = city.lng;
      }
    }

    lat ??= _appState.lat;
    lng ??= _appState.lng;

    if (lat == null || lng == null) return;

    setState(() {
      _cityName = _appState.locationName;
      _lat = lat!;
      _lng = lng!;
      _qiblaBearing = _calculateQibla(_lat, _lng);
      _locationGranted = false;
    });
  }

  Future<void> _init() async {
    final appState = context.read<AppState>();
    _cityName = appState.locationName;

    // Manuel il/ilçe seçiminde kayıtlı eski koordinatlar yerine
    // seçilen yerin kendi koordinatlarını kullan.
    if (appState.district.isNotEmpty) {
      final district = turkishDistricts.where((d) =>
          d.cityName == appState.city &&
          d.name == appState.district).firstOrNull;

      if (district != null) {
        _lat = district.lat;
        _lng = district.lng;
      } else if (appState.lat != null && appState.lng != null) {
        _lat = appState.lat!;
        _lng = appState.lng!;
      }
    } else {
      final city = findCity(appState.city);
      if (city != null) {
        _lat = city.lat;
        _lng = city.lng;
      } else if (appState.lat != null && appState.lng != null) {
        _lat = appState.lat!;
        _lng = appState.lng!;
      }
    }

    _qiblaBearing = _calculateQibla(_lat, _lng);

    final compassStream =
        (Platform.isAndroid || Platform.isIOS) ? FlutterCompass.events : null;

    if (compassStream == null) {
      _sensorAvailable = false;
    } else {
      _sub = compassStream.listen((event) {
        if (mounted && event.heading != null) {
          setState(() => _heading = event.heading);
        }
      }, onError: (_) {
        if (mounted) setState(() => _sensorAvailable = false);
      });
    }

    if (mounted) setState(() => _loading = false);
  }
  double _calculateQibla(double lat, double lng) {
    final phiK = _kabeLat * math.pi / 180.0;
    final lambdaK = _kabeLng * math.pi / 180.0;
    final phi = lat * math.pi / 180.0;
    final lambda = lng * math.pi / 180.0;
    final dLambda = lambdaK - lambda;
    final y = math.sin(dLambda);
    final x =
        math.cos(phi) * math.tan(phiK) - math.sin(phi) * math.cos(dLambda);
    final bearing = math.atan2(y, x) * 180.0 / math.pi;
    return (bearing + 360.0) % 360.0;
  }

  Future<void> _requestLocation() async {
    try {
      final perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        setState(() {
          _locationGranted = true;
          _lat = pos.latitude;
          _lng = pos.longitude;
          _cityName = 'Konum';
          _qiblaBearing = _calculateQibla(_lat, _lng);
        });
      }
    } catch (_) {}
  }

  Future<void> _pickCity() async {
    await showCityPicker(context);

    if (!mounted) return;

    final appState = context.read<AppState>();
    double? lat;
    double? lng;

    if (appState.district.isNotEmpty) {
      for (final d in turkishDistricts) {
        if (d.cityName == appState.city &&
            d.name == appState.district) {
          lat = d.lat;
          lng = d.lng;
          break;
        }
      }
    }

    if (lat == null || lng == null) {
      final city = findCity(appState.city);
      if (city != null) {
        lat = city.lat;
        lng = city.lng;
      }
    }

    lat ??= appState.lat;
    lng ??= appState.lng;

    if (lat == null || lng == null) return;

    setState(() {
      _cityName = appState.locationName;
      _lat = lat!;
      _lng = lng!;
      _qiblaBearing = _calculateQibla(_lat, _lng);
      _locationGranted = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final heading = _heading ?? 0;
    final qibla = _qiblaBearing ?? 0;
    final delta = ((qibla - heading) + 360) % 360;
    final aligned = delta < 5 || delta > 355;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Kıble Pusulası',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _locationBar(),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _showMap = false),
                        icon: const Icon(Icons.explore_rounded),
                        label: const Text('Pusula'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_showMap ? _navy : Colors.white,
                          foregroundColor: !_showMap ? Colors.white : _navy,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: _navy),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _showMap = true),
                        icon: const Icon(Icons.map_rounded),
                        label: const Text('Harita'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _showMap ? _red : Colors.white,
                          foregroundColor: _showMap ? Colors.white : _navy,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: _red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (_showMap)
                  _mapView()
                else ...[
                  if (!_sensorAvailable)
                    _noSensor()
                  else ...[
                    _compass(heading, qibla, aligned),
                    const SizedBox(height: 20),
                    _statusCard(heading, qibla, delta, aligned),
                  ],
                  const SizedBox(height: 20),
                  _infoCard(),
                ],
              ],
            ),
    );
  }

  Widget _mapView() {
    final userPoint = LatLng(_lat, _lng);
    final kaabaPoint = LatLng(_kabeLat, _kabeLng);

    return Column(
      children: [
        Container(
          height: 430,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _navy.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                (_lat + _kabeLat) / 2,
                (_lng + _kabeLng) / 2,
              ),
              initialZoom: 3.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'nur_pusulasi',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [userPoint, kaabaPoint],
                    color: _red,
                    strokeWidth: 4,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userPoint,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: _navy,
                      size: 42,
                    ),
                  ),
                  Marker(
                    point: kaabaPoint,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.mosque_rounded,
                      color: _red,
                      size: 38,
                    ),
                  ),
                ],
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('© OpenStreetMap contributors'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _navy.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded, color: _navy),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _cityName,
                  style: const TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: _red),
              const SizedBox(width: 8),
              const Text(
                'Kâbe',
                style: TextStyle(
                  color: _red,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Kırmızı çizgi konumunuz ile Kâbe arasındaki yönü gösterir.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _locationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: _red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_cityName,
                    style: const TextStyle(
                        color: _navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                Text(
                    '${_lat.toStringAsFixed(2)}°N, ${_lng.toStringAsFixed(2)}°E',
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 11)),
              ],
            ),
          ),
          if (!_locationGranted)
            TextButton.icon(
              onPressed: _requestLocation,
              icon: const Icon(Icons.my_location_rounded, size: 16),
              label: const Text('Konumum', style: TextStyle(fontSize: 12)),
            ),
          IconButton(
            onPressed: _pickCity,
            icon:
                const Icon(Icons.location_city_rounded, color: _navy, size: 20),
            tooltip: 'Şehir seç',
          ),
        ],
      ),
    );
  }

  Widget _compass(double heading, double qibla, bool aligned) {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ana daire
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: aligned
                    ? [_green.withValues(alpha: 0.15), Colors.white]
                    : [_navy.withValues(alpha: 0.08), Colors.white],
              ),
              border: Border.all(
                color: aligned ? _green : _navy.withValues(alpha: 0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (aligned ? _green : _navy).withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // Yon harfleri (sabit, cihaz yonune gore donuyor)
          Transform.rotate(
            angle: -heading * math.pi / 180,
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                children: [
                  _directionLabel('K', 0),
                  _directionLabel('D', 90),
                  _directionLabel('G', 180),
                  _directionLabel('B', 270),
                ],
              ),
            ),
          ),
          // Kıble oku (sabit, hedef yonde donuyor)
          Transform.rotate(
            angle: (qibla - heading) * math.pi / 180,
            child: SizedBox(
              width: 260,
              height: 260,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _gold,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: _gold.withValues(alpha: 0.5),
                            blurRadius: 12),
                      ],
                    ),
                    child: const Icon(Icons.mosque_rounded,
                        color: Colors.white, size: 22),
                  ),
                  Expanded(
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_gold, _gold.withValues(alpha: 0.1)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Merkez ok
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: aligned ? _green : _navy,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
          // Derece gosterge
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _navy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${heading.round()}°',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _directionLabel(String label, double angle) {
    final rad = (angle - 90) * math.pi / 180;
    final x = 130 + 120 * math.cos(rad);
    final y = 130 + 120 * math.sin(rad);
    return Positioned(
      left: x - 10,
      top: y - 10,
      child: Text(label,
          style: const TextStyle(
              color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
    );
  }

  Widget _statusCard(double heading, double qibla, double delta, bool aligned) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statBox('Cihaz Yönü', '${heading.round()}°',
                    Icons.screen_rotation_rounded, _navy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statBox('Kıble Açısı', '${qibla.round()}°',
                    Icons.mosque_rounded, _gold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: aligned
                  ? _green.withValues(alpha: 0.1)
                  : _red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: aligned
                    ? _green.withValues(alpha: 0.4)
                    : _red.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  aligned
                      ? Icons.check_circle_rounded
                      : Icons.rotate_right_rounded,
                  color: aligned ? _green : _red,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    aligned
                        ? 'Kıbleye yönelmiş durumdasınız.'
                        : 'Telefonu ${delta.round()}° ${delta < 180 ? "sağa" : "sola"} çevirin.',
                    style: TextStyle(
                        color: aligned ? _green : _red,
                        fontSize: 13,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _noSensor() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: const [
          Icon(Icons.sensors_off_rounded, color: _red, size: 48),
          SizedBox(height: 12),
          Text('Pusula sensörü bulunamadı',
              style: TextStyle(
                  color: _navy, fontSize: 16, fontWeight: FontWeight.w900)),
          SizedBox(height: 8),
          Text(
            'Bu cihazda manyetik pusula sensörü yok veya izin verilmedi.\n\n'
            'Kıble açısı hesaplandı, ancak cihaz yönü gösterilemiyor.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline_rounded, color: _gold, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Kıble açısı, Kâbe koordinatları (21.42°N, 39.83°E) ile konumunuz arasındaki büyük daire hesabıyla bulunur. '
              'Pusula doğruluğu için telefonu metal nesnelerden uzak tutun ve 8 çizerek kalibre edin.',
              style: TextStyle(color: _navy, fontSize: 11, height: 1.5),
            ),
          ),
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
  final _c = TextEditingController();
  late List<TurkishCity> _filtered;
  @override
  void initState() {
    super.initState();
    _filtered = turkishCities;
  }

  @override
  void dispose() {
    _c.dispose();
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
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, ctrl) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Şehir Seç',
                    style: TextStyle(
                        color: _navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                TextField(
                  controller: _c,
                  onChanged: _filter,
                  decoration: InputDecoration(
                    hintText: 'Şehir ara...',
                    prefixIcon: const Icon(Icons.search_rounded, color: _navy),
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
              controller: ctrl,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final sel = c.name == widget.current;
                return ListTile(
                  leading: Icon(
                      sel
                          ? Icons.check_circle_rounded
                          : Icons.location_city_rounded,
                      color: sel ? _red : _navy),
                  title: Text(c.name,
                      style: TextStyle(
                          color: _navy,
                          fontWeight: sel ? FontWeight.w900 : FontWeight.w600)),
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


