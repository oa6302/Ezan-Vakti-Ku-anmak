// Gorsel kontrol: ana sayfa kartlari ve yonetim paneli PNG olarak build/ekran/ altina yazilir.
// Calistirma: flutter test test/ekran_goruntusu_test.dart --dart-define=EKRAN=true
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/app/admin_session.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/favorites_service.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import 'package:nur_pusulasi/app/theme.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';
import 'package:nur_pusulasi/features/admin/gunluk_yonetim_page.dart';
import 'package:nur_pusulasi/features/home/home_page.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'yardimci/fontlar.dart';

const _calistir = bool.fromEnvironment('EKRAN');

void main() {
  late AppState appState;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await gercekFontlariYukle();
    SharedPreferences.setMockInitialValues({});
    appState = AppState();
    await appState.load();
    await ContentService.instance.load();
    await kissalariYukle();
    await icerikHazinesiniYukle();
    await FavoritesService.instance.load();
    await AdminSession.instance.load();
  });

  Future<void> cek(WidgetTester tester, String ad, Widget sayfa,
      {double kaydir = 0, int adet = 1}) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.6;
    addTearDown(tester.view.reset);
    final anahtar = GlobalKey();
    await tester.pumpWidget(ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: RepaintBoundary(
        key: anahtar,
        child: MaterialApp(
          theme: buildAppTheme(),
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: sayfa,
        ),
      ),
    ));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
    for (var n = 0; n < adet; n++) {
      if (n > 0 || kaydir > 0) {
        await tester.drag(find.byType(Scrollable).first, Offset(0, -kaydir));
        for (var i = 0; i < 4; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
      }
      await tester.runAsync(() async {
        final r = anahtar.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
        final img = await r.toImage(pixelRatio: 1);
        final b = await img.toByteData(format: ui.ImageByteFormat.png);
        File('build/ekran/${ad}_$n.png')
          ..createSync(recursive: true)
          ..writeAsBytesSync(b!.buffer.asUint8List());
      });
    }
  }

  testWidgets(
      'Ana sayfa', (t) => cek(t, 'ana', const HomePage(), kaydir: 0, adet: 1),
      skip: !_calistir);
  testWidgets('Ana sayfa kartlar',
      (t) => cek(t, 'kartlar', const HomePage(), kaydir: 700, adet: 5),
      skip: !_calistir);
  testWidgets('Yonetim paneli',
      (t) => cek(t, 'panel', const GunlukYonetimPage(), kaydir: 0, adet: 1),
      skip: !_calistir);
}
