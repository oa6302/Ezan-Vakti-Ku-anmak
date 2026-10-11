import 'package:flutter/material.dart';

const navy = Color(0xFF10264B);
const navyDeep = Color(0xFF09172F);
const red = Color(0xFFD91E36);
const pale = Color(0xFFF3F6FA);
const cream = Color(0xFFFDF8F3);
const gold = Color(0xFFC9A961);
const surfaceWhite = Color(0xFFFFFFFF);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF7F9FC),
    colorScheme: ColorScheme.fromSeed(
      seedColor: navy,
      primary: navy,
      secondary: red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: navy,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 7,
      shadowColor: navy.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      margin: EdgeInsets.zero,
    ),
  );
}