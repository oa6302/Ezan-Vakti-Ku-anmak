import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();
  static const _navy = Color(0xFF0A1F44);

  static List<BoxShadow> soft() => [
    BoxShadow(
      color: _navy.withValues(alpha: 0.10),
      blurRadius: 14,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> medium() => [
    BoxShadow(
      color: _navy.withValues(alpha: 0.18),
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: _navy.withValues(alpha: 0.22),
      blurRadius: 40,
      offset: const Offset(0, 20),
      spreadRadius: -4,
    ),
  ];

  static List<BoxShadow> deep() => [
    BoxShadow(
      color: _navy.withValues(alpha: 0.20),
      blurRadius: 14,
      offset: const Offset(0, 6),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: _navy.withValues(alpha: 0.28),
      blurRadius: 36,
      offset: const Offset(0, 18),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: _navy.withValues(alpha: 0.32),
      blurRadius: 72,
      offset: const Offset(0, 32),
      spreadRadius: 4,
    ),
  ];

  static List<BoxShadow> colored(Color color, {double alpha = 0.45}) => [
    BoxShadow(
      color: color.withValues(alpha: alpha * 0.6),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: color.withValues(alpha: alpha),
      blurRadius: 40,
      offset: const Offset(0, 20),
      spreadRadius: 2,
    ),
  ];
}