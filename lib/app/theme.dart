import 'package:flutter/material.dart';

const Color kAnaLacivert = Color(0xFF142747);
const Color kKoyuLacivert = Color(0xFF0B1736);
const Color kAnaTurkuaz = Color(0xFF2BAF95);
const Color kBasariYesili = Color(0xFF239B77);
const Color kZarifBordo = Color(0xFFB93A46);
const Color kArkaPlan = Color(0xFFF3F6FB);
const Color kKartYuzeyi = Color(0xFFFFFFFF);
const Color kAnaMetin = Color(0xFF17243B);
const Color kIkincilMetin = Color(0xFF64748B);
const Color kYardimciMetin = Color(0xFF8793A5);
const Color kKenarlik = Color(0xFFE5EAF2);

const navy = kAnaLacivert;
const navyDeep = kKoyuLacivert;
const red = kZarifBordo;
const pale = kArkaPlan;
const cream = Color(0xFFFDF8F3);
const gold = Color(0xFFC9A961);
const surfaceWhite = kKartYuzeyi;

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
    scaffoldBackgroundColor: kArkaPlan,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kAnaLacivert,
      brightness: Brightness.light,
      primary: kAnaLacivert,
      secondary: kAnaTurkuaz,
      surface: kKartYuzeyi,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kKartYuzeyi,
      foregroundColor: kAnaLacivert,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: kKartYuzeyi,
      elevation: 8,
      shadowColor: Color(0x14142747),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
    ),
    textTheme: withTextShadows(ThemeData.light().textTheme.apply(
          bodyColor: kAnaMetin,
          displayColor: kAnaMetin,
        )),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kAnaLacivert,
      brightness: Brightness.dark,
      primary: gold,
      secondary: kAnaTurkuaz,
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
        borderRadius: BorderRadius.circular(24),
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

TextTheme withTextShadows(TextTheme base) {
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(shadows: kTextShadowSoft),
    displayMedium: base.displayMedium?.copyWith(shadows: kTextShadowSoft),
    displaySmall: base.displaySmall?.copyWith(shadows: kTextShadowSoft),
    headlineLarge: base.headlineLarge?.copyWith(shadows: kTextShadowSoft),
    headlineMedium: base.headlineMedium?.copyWith(shadows: kTextShadowSoft),
    headlineSmall: base.headlineSmall?.copyWith(shadows: kTextShadowSoft),
    titleLarge: base.titleLarge?.copyWith(shadows: kTextShadowSoft),
    titleMedium: base.titleMedium?.copyWith(shadows: kTextShadowSoft),
    titleSmall: base.titleSmall?.copyWith(shadows: kTextShadowSoft),
  );
}
