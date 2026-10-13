import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyLocale = 'app_locale';
  static const _keyFontStyle = 'arabic_font_style';

  static Future<Locale?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocale);
    if (code == null) return null;
    return Locale(code);
  }

  static Future<void> saveLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, code);
  }

  /// 'rika' veya 'matbu'
  static Future<String> loadFontStyle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFontStyle) ?? 'matbu';
  }

  static Future<void> saveFontStyle(String style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFontStyle, style);
  }
}