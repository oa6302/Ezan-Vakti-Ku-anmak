
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nur_pusulasi/features/prayer/data/turkish_districts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const kBirthDate = 'user_birth_date';
  static const kUserName = 'user_name';
  static const kCity = 'prayer_city_v2';
  static const kLat = 'prayer_lat_v2';
  static const kLng = 'prayer_lng_v2';
  static const kDistrict = 'prayer_district_v1';
  static const kNotifEnabled = 'notif_enabled';
  static const kThemeMode = 'theme_mode_v2';
  static const kLastTab = 'last_tab_index';

  DateTime? _birthDate;
  String _userName = '';
  String _city = 'Istanbul';
  String _district = '';
  double? _lat;
  double? _lng;
  bool _notifEnabled = true;
  ThemeMode _themeMode = ThemeMode.light;
  int _lastTab = 0;
  bool _ready = false;

  DateTime? get birthDate => _birthDate;
  String get userName => _userName;
  String get city => _city;
  String get district => _district;
  String get locationName =>
      _district.isEmpty ? _city : '$_district, $_city';
  String get cityAscii => _toAscii(_city);
  double? get lat => _lat;
  double? get lng => _lng;
  bool get notifEnabled => _notifEnabled;
  ThemeMode get themeMode => _themeMode;
  int get lastTab => _lastTab;
  bool get ready => _ready;

  int? get ageYears {
    if (_birthDate == null) return null;
    final now = DateTime.now();
    var a = now.year - _birthDate!.year;
    if (now.month < _birthDate!.month ||
        (now.month == _birthDate!.month &&
            now.day < _birthDate!.day)) {
      a--;
    }
    return a;
  }

  String get greetingName =>
      _userName.trim().isEmpty ? '' : _userName.trim().split(' ').first;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();

    final bIso = p.getString(kBirthDate);
    if (bIso != null) {
      _birthDate = DateTime.tryParse(bIso);
    }

    _userName = p.getString(kUserName) ?? '';
    _city = p.getString(kCity) ?? 'Istanbul';
    _district = p.getString(kDistrict) ?? '';
    _lat = p.getDouble(kLat);
    _lng = p.getDouble(kLng);
    _notifEnabled = p.getBool(kNotifEnabled) ?? true;
    _lastTab = p.getInt(kLastTab) ?? 0;

    switch (p.getString(kThemeMode)) {
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
    }

    _ready = true;
    notifyListeners();
  }

  Future<String?> updateFromCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return 'Telefonun konum servisi kapalı. Lütfen GPS konumunu açın.';
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return 'Konum izni verilmedi. Telefon ayarlarından uygulamaya konum izni verin.';
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      const earthRadius = 6371.0;
      TurkishDistrict? nearest;
      var nearestDistance = double.infinity;

      for (final district in turkishDistricts) {
        final dLat = (district.lat - position.latitude) * math.pi / 180;
        final dLng = (district.lng - position.longitude) * math.pi / 180;
        final a = math.pow(math.sin(dLat / 2), 2) +
            math.cos(position.latitude * math.pi / 180) *
                math.cos(district.lat * math.pi / 180) *
                math.pow(math.sin(dLng / 2), 2);
        final distance = 2 * earthRadius *
            math.atan2(math.sqrt(a), math.sqrt(1 - a));

        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearest = district;
        }
      }

      if (nearest == null || nearestDistance > 50) {
        return 'Bulunduğunuz konuma uygun ilçe bulunamadı. Manuel seçim yapabilirsiniz.';
      }

      await setCity(
        _fixTurkishText(nearest.cityName),
        district: _fixTurkishText(nearest.name),
        lat: position.latitude,
        lng: position.longitude,
      );

      return null;
    } catch (e) {
      return 'Konum alınamadı: $e';
    }
  }

  static String _fixTurkishText(String value) {
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
        .replaceAll('Äž', 'Ğ');
  }

  Future<void> setBirthDate(DateTime d) async {
    _birthDate = d;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(kBirthDate, d.toIso8601String());
  }

  Future<void> setUserName(String n) async {
    _userName = n;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(kUserName, n);
  }

  Future<void> setCity(
    String c, {
    double? lat,
    double? lng,
    String district = '',
  }) async {
    _city = c;
    _district = district;
    _lat = lat;
    _lng = lng;
    notifyListeners();

    final p = await SharedPreferences.getInstance();
    await p.setString(kCity, c);
    await p.setString(kDistrict, district);

    if (lat != null && lng != null) {
      await p.setDouble(kLat, lat);
      await p.setDouble(kLng, lng);
    } else {
      await p.remove(kLat);
      await p.remove(kLng);
    }
  }

  Future<void> setNotifEnabled(bool v) async {
    _notifEnabled = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool(kNotifEnabled, v);
  }

  Future<void> setThemeMode(ThemeMode m) async {
    _themeMode = m;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(kThemeMode, m.name);
  }

  Future<void> setLastTab(int i) async {
    _lastTab = i;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt(kLastTab, i);
  }

  static String _toAscii(String s) {
    return s
        .replaceAll('Ä°', 'I')
        .replaceAll('Ä±', 'i')
        .replaceAll('Å', 'S')
        .replaceAll('Ä', 'G')
        .replaceAll('Ãœ', 'U')
        .replaceAll('Ã¼', 'u')
        .replaceAll('Ã–', 'O')
        .replaceAll('Ã¶', 'o')
        .replaceAll('Ã‡', 'C')
        .replaceAll('Ã§', 'c');
  }
}



