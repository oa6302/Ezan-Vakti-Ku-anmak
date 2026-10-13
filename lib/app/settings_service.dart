import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_settings.dart';

class SettingsService {
  static const _keyLocale = 'app_locale';
  static const _keyFontStyle = 'arabic_font_style';

  static Future<void> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocale) ?? 'tr';
    final font = prefs.getString(_keyFontStyle) ?? 'matbu';
    AppSettings.instance.locale.value = Locale(code);
    AppSettings.instance.fontStyle.value = font;
  }

  static Future<void> saveLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, code);
    AppSettings.instance.locale.value = Locale(code);
  }

  static Future<void> saveFontStyle(String style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFontStyle, style);
    AppSettings.instance.fontStyle.value = style;
  }
}