// Senkronizasyon testi: ortak durum degisince ilgili ekranlar guncelleniyor mu?
// (FAZLAR.md Bitti Kriteri 2)
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/favorites_service.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/favorites_mini_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/header_v2.dart';
import 'package:nur_pusulasi/features/prayer/data/prayer_service.dart';
import 'package:nur_pusulasi/app/app_settings.dart';
import 'package:nur_pusulasi/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'yardimci/fontlar.dart';

void main() {
  late AppState appState;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await gercekFontlariYukle();
    SharedPreferences.setMockInitialValues({});
    appState = AppState();
    await appState.load();
    await ContentService.instance.load();
    await FavoritesService.instance.load();
  });

  Widget sar(Widget w) => ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'),
          locale: const Locale('tr'),
          supportedLocales: const [Locale('tr'), Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(body: SingleChildScrollView(child: w)),
        ),
      );

  test('Ilk acilista ana sayfa sekmesi secili', () {
    expect(appState.lastTab, 2);
  });

  test('Ilce secilince vakitler ilce koordinatindan hesaplanir', () async {
    final s = PrayerService();
    final il = await s.calculateForLocation(city: 'Van');
    // Van/Ercis: il merkezinden ~90 km kuzey, vakitler farkli olmali
    final ilce = await s.calculateForLocation(
        city: 'Van', lat: 39.0287, lng: 43.3594, label: 'Ercis, Van');
    expect(il, isNotNull);
    expect(ilce, isNotNull);
    expect(ilce!.times.values.first, isNot(il!.times.values.first));
  });

  testWidgets('Sehir/ilce degisince baslik guncellenir', (tester) async {
    await appState.setCity('Ankara');
    await tester.pumpWidget(sar(const HomeHeaderV2()));
    await tester.pump();
    expect(find.textContaining('Ankara'), findsWidgets);

    await appState.setCity('Ankara',
        district: 'Çankaya', lat: 39.9179, lng: 32.8627);
    await tester.pump();
    expect(find.textContaining('Çankaya, Ankara'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('Favori eklenince ana sayfa favori karti guncellenir',
      (tester) async {
    await FavoritesService.instance.clear();
    await tester.pumpWidget(sar(const FavoritesMiniCard()));
    await tester.pump();
    final once = FavoritesService.instance.count;

    final pool = ContentService.instance.getPool(ContentType.values.first);
    final item = pool.isNotEmpty
        ? pool.first
        : ContentService.instance.fallback(ContentType.values.first);
    await FavoritesService.instance.toggle(item);
    await tester.pump();

    expect(FavoritesService.instance.count, once + 1);
    expect(find.text('${once + 1}'), findsWidgets);

    await FavoritesService.instance.toggle(item);
    await tester.pump();
    expect(FavoritesService.instance.count, once);
  });

  testWidgets('Dil degisince alt menu ve Daha Fazla ekrani cevrilir',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: const NurPusulasiApp(),
    ));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Pusula'), findsOneWidget);
    expect(find.text('Daha Fazla'), findsWidgets);

    AppSettings.instance.locale.value = const Locale('en');
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Compass'), findsOneWidget);
    expect(find.text('More'), findsWidgets);

    AppSettings.instance.locale.value = const Locale('tr');
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });
}
