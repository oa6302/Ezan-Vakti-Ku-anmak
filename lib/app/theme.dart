import 'package:flutter/material.dart';

const navy = Color(0xFF10264B);
const navyDeep = Color(0xFF09172F);
const red = Color(0xFFD91E36);
const pale = Color(0xFFF3F6FA);
const cream = Color(0xFFFDF8F3);
const gold = Color(0xFFC9A961);
const surfaceWhite = Color(0xFFFFFFFF);

// Dark mode renkleri
const darkBg = Color(0xFF0B1220);
const darkSurface = Color(0xFF131C2E);
const darkSurface2 = Color(0xFF1B263F);
const darkBorder = Color(0xFF2A3752);
const darkText = Color(0xFFE8EDF5);
const darkTextMuted = Color(0xFF9AA7BF);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F9FC),
    colorScheme: ColorScheme.fromSeed(
      seedColor: navy,
      brightness: Brightness.light,
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
    textTheme: withTextShadows(ThemeData.light().textTheme),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: navy,
      brightness: Brightness.dark,
      primary: gold,
      secondary: red,
      surface: darkSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkText,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: darkBorder, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerColor: darkBorder,
    iconTheme: const IconThemeData(color: darkText),
    textTheme: withTextShadows(
      ThemeData.dark().textTheme.copyWith(
        bodyMedium: const TextStyle(color: darkText),
        bodySmall: const TextStyle(color: darkTextMuted),
      ),
    ),
  );
}

// Global metin golgeleri (kullanici istegi)
const kTextShadowSoft = [
  Shadow(color: Color(0x25000000), offset: Offset(0, 1), blurRadius: 4),
];

const kTextShadowMedium = [
  Shadow(color: Color(0x38000000), offset: Offset(0, 2), blurRadius: 6),
  Shadow(color: Color(0x20000000), offset: Offset(0, 4), blurRadius: 10),
];

const kTextShadowDeep = [
  Shadow(color: Color(0x45000000), offset: Offset(0, 2), blurRadius: 6),
  Shadow(color: Color(0x30000000), offset: Offset(0, 5), blurRadius: 14),
];

/// TextTheme'in tum stillerine golge uygular
TextTheme withTextShadows(TextTheme base) {
  TextStyle? m(TextStyle? t, List<Shadow> shadows) =>
      t?.copyWith(shadows: shadows);

  return base.copyWith(
    // Buyuk basliklar - derin golge
    displayLarge: m(base.displayLarge, kTextShadowDeep),
    displayMedium: m(base.displayMedium, kTextShadowDeep),
    displaySmall: m(base.displaySmall, kTextShadowDeep),

    // Basliklar - orta golge
    headlineLarge: m(base.headlineLarge, kTextShadowMedium),
    headlineMedium: m(base.headlineMedium, kTextShadowMedium),
    headlineSmall: m(base.headlineSmall, kTextShadowMedium),

    // Title - orta golge
    titleLarge: m(base.titleLarge, kTextShadowMedium),
    titleMedium: m(base.titleMedium, kTextShadowMedium),
    titleSmall: m(base.titleSmall, kTextShadowMedium),

    // Body - hafif golge (okunabilirlik icin)
    bodyLarge: m(base.bodyLarge, kTextShadowSoft),
    bodyMedium: m(base.bodyMedium, kTextShadowSoft),
    bodySmall: m(base.bodySmall, kTextShadowSoft),

    // Label - cok hafif
    labelLarge: m(base.labelLarge, kTextShadowSoft),
    labelMedium: m(base.labelMedium, kTextShadowSoft),
    labelSmall: m(base.labelSmall, kTextShadowSoft),
  );
}