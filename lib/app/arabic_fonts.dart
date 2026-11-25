import 'package:flutter/material.dart';

/// Arapca ve Osmanlica metinler icin font aileleri.
/// Rika: el yazisi hatti (Osmanlica belgeler, el yazmalari)
/// Matbu: basili hatti (kitap, gazete, matbaa)
class ArabicFonts {
  ArabicFonts._();

  static const rika = 'Rika';
  static const matbu = 'Matbu';

  /// Rika hatti ile Arapca metin
  static TextStyle rikaStyle({
    double fontSize = 20,
    Color color = const Color(0xFF0A1F44),
    FontWeight fontWeight = FontWeight.w500,
    double height = 2.0,
  }) =>
      TextStyle(
        fontFamily: rika,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      );

  /// Matbu hatti ile Arapca metin (Kur'an, dua, hadis)
  static TextStyle matbuStyle({
    double fontSize = 20,
    Color color = const Color(0xFF0A1F44),
    FontWeight fontWeight = FontWeight.w500,
    double height = 2.0,
  }) =>
      TextStyle(
        fontFamily: matbu,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      );
}
