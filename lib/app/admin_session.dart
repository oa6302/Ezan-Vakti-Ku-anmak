import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Admin oturum durumu (app-wide, kalici)
class AdminSession extends ChangeNotifier {
  static final AdminSession instance = AdminSession._internal();
  AdminSession._internal();

  static const _key = 'nur_pusulasi_admin_session_v1';

  bool _isAdmin = false;
  DateTime? _loginTime;

  bool get isAdmin => _isAdmin;
  DateTime? get loginTime => _loginTime;

  /// Uygulama acilirken cagrilir
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isAdmin = prefs.getBool(_key) ?? false;
    if (_isAdmin) {
      final ts = prefs.getInt('${_key}_time');
      if (ts != null) {
        _loginTime = DateTime.fromMillisecondsSinceEpoch(ts);
      }
    }
    notifyListeners();
  }

  Future<void> login() async {
    _isAdmin = true;
    _loginTime = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    await prefs.setInt('${_key}_time', _loginTime!.millisecondsSinceEpoch);
    notifyListeners();
  }

  Future<void> logout() async {
    _isAdmin = false;
    _loginTime = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove('${_key}_time');
    notifyListeners();
  }
}