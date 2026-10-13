import 'package:flutter/material.dart';

/// Tum uygulamada kullanilan derin golge tanimlari.
/// Tutarli bir gorsel dil olusturur.
class AppShadows {
  AppShadows._();

  static const _navy = Color(0xFF0A1F44);

  /// Kucuk kartlar icin hafif golge
  static List<BoxShadow> soft() => [
    BoxShadow(
      color: _navy.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Ana kartlar icin orta seviye derin golge
  static List<BoxShadow> medium() => [
    BoxShadow(
      color: _navy.withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 1,
    ),
    BoxShadow(
      color: _navy.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Kahraman kartlar (gradient header, countdown vs.) icin derin golge
  static List<BoxShadow> deep() => [
    BoxShadow(
      color: _navy.withValues(alpha: 0.18),
      blurRadius: 32,
      offset: const Offset(0, 14),
      spreadRadius: 2,
    ),
    BoxShadow(
      color: _navy.withValues(alpha: 0.08),
      blurRadius: 14,
      offset: const Offset(0, 6),
    ),
  ];

  /// Renkli golge (yesil/kirmizi karti icin)
  static List<BoxShadow> colored(Color color, {double alpha = 0.35}) => [
    BoxShadow(
      color: color.withValues(alpha: alpha),
      blurRadius: 24,
      offset: const Offset(0, 10),
      spreadRadius: 1,
    ),
    BoxShadow(
      color: color.withValues(alpha: alpha * 0.4),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}