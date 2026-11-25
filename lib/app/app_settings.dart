import 'package:flutter/material.dart';

/// Uygulama geneli ayarlar (dil + font) icin reactive state.
class AppSettings {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  /// Aktif locale (tr / en / ar)
  final ValueNotifier<Locale> locale = ValueNotifier(const Locale('tr'));

  /// Aktif Arapca font stili (rika / matbu)
  final ValueNotifier<String> fontStyle = ValueNotifier('matbu');

  /// Arapca seciliyse RTL aktif
  bool get isRtl => locale.value.languageCode == 'ar';
}
