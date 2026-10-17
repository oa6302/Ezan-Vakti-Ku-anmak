import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Nur Pusulasi merkezi durum yoneticisi.
/// Tum sayfalar bu sinif uzerinden ortak veriyi okur/yazar.
/// Tek kaynak: SharedPreferences + bellek ici cache.
class AppState extends ChangeNotifier {
  // ─── SharedPreferences anahtarlari ───
  static const kBirthDate     = 'user_birth_date';
  static const kUserName      = 'user_name';
  static const kCity          = 'prayer_city_v2';
  static const kLat           = 'prayer_lat_v2';
  static const kLng           = 'prayer_lng_v2';
  static const kNotifEnabled  = 'notif_enabled';
  static const kThemeMode     = 'theme_mode_v2';
  static const kLastTab       = 'last_tab_index';

  // ─── Bellek ici alanlar ───
  DateTime?   _birthDate;
  String      _userName      = '';
  String      _city          = 'Istanbul';
  double?     _lat;
  double?     _lng;
  bool        _notifEnabled  = true;
  ThemeMode   _themeMode     = ThemeMode.light;
  int         _lastTab       = 0;
  bool        _ready         = false;

  // ─── Getter'lar ───
  DateTime? get birthDate    => _birthDate;
  String    get userName     => _userName;
  String    get city         => _city;
  String    get cityAscii    => _toAscii(_city);
  double?   get lat          => _lat;
  double?   get lng          => _lng;
  bool      get notifEnabled => _notifEnabled;
  ThemeMode get themeMode    => _themeMode;
  int       get lastTab      => _lastTab;
  bool      get ready        => _ready;

  /// Dogum tarihinden yas hesaplar.
  int? get ageYears {
    if (_birthDate == null) return null;
    final now = DateTime.now();
    var a = now.year - _birthDate!.year;
    if (now.month < _birthDate!.month ||
        (now.month == _birthDate!.month && now.day < _birthDate!.day)) {
      a--;
    }
    return a;
  }

  /// Selamlama icin ilk isim.
  String get greetingName =>
      _userName.trim().isEmpty ? '' : _userName.trim().split(' ').first;

  // ─── Yukleme ───
  Future<void> load() async {
    final p = await SharedPreferences.getInstance();

    final bIso = p.getString(kBirthDate);
    if (bIso != null) _birthDate = DateTime.tryParse(bIso);

    _userName     = p.getString(kUserName)  ?? '';
    _city         = p.getString(kCity)      ?? 'Istanbul';
    _lat          = p.getDouble(kLat);
    _lng          = p.getDouble(kLng);
    _notifEnabled = p.getBool(kNotifEnabled) ?? true;
    _lastTab      = p.getInt(kLastTab)       ?? 0;

    switch (p.getString(kThemeMode)) {
      case 'dark':   _themeMode = ThemeMode.dark;   break;
      case 'system': _themeMode = ThemeMode.system; break;
      default:       _themeMode = ThemeMode.light;
    }

    _ready = true;
    notifyListeners();
  }

  // ─── Setter'lar (her biri aninda notify + kalici yaz) ───
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

  Future<void> setCity(String c, {double? lat, double? lng}) async {
    _city = c;
    if (lat != null) _lat = lat;
    if (lng != null) _lng = lng;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(kCity, c);
    if (lat != null) await p.setDouble(kLat, lat);
    if (lng != null) await p.setDouble(kLng, lng);
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
        .replaceAll('İ', 'I')
        .replaceAll('ı', 'i')
        .replaceAll('Ş', 'S')
        .replaceAll('ş', 's')
        .replaceAll('Ğ', 'G')
        .replaceAll('ğ', 'g')
        .replaceAll('Ü', 'U')
        .replaceAll('ü', 'u')
        .replaceAll('Ö', 'O')
        .replaceAll('ö', 'o')
        .replaceAll('Ç', 'C')
        .replaceAll('ç', 'c');
  }
}