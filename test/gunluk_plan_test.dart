// Tarih bazli yonetim: gunler ve programlar birbirinden bagimsiz, taslak ve
// gelecek kayit kullaniciya gosterilmez, kayitlar kalici, panel bugunle acilir.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';
import 'package:nur_pusulasi/app/gunluk_plan.dart';
import 'package:nur_pusulasi/features/admin/gunluk_yonetim_page.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

ContentItem _dua(String ad) => ContentItem(
    id: 'test_$ad',
    type: ContentType.dua,
    baslik: ad,
    icerik: 'okunus $ad',
    altIcerik: 'anlam $ad',
    kaynak: 'Test');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final plan = GunlukPlanServisi.instance;
  final bugun = GunlukPlanServisi.gun(DateTime.now());
  final yarin = DateTime(bugun.year, bugun.month, bugun.day + 1);
  final dun = DateTime(bugun.year, bugun.month, bugun.day - 1);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    plan.testIcinSifirla();
    await ContentService.instance.load();
    await kissalariYukle();
    await plan.yukle();
  });

  test('Tarih anahtari YYYY-MM-DD, saat kaymasi yok', () {
    expect(GunlukPlanServisi.tarihAnahtari(DateTime(2026, 11, 26, 23, 59)),
        '2026-11-26');
    expect(
        GunlukPlanServisi.anahtardanTarih('2026-03-01'), DateTime(2026, 3, 1));
  });

  test('27 Kasim duasi 26 Kasim duasini degistirmez; programlar bagimsiz',
      () async {
    final g26 = DateTime(2026, 11, 26), g27 = DateTime(2026, 11, 27);
    await plan.kaydet(
        ContentType.dua, g26, _dua('a'), ContentStatus.yayinlandi);
    await plan.kaydet(
        ContentType.dua, g27, _dua('b'), ContentStatus.yayinlandi);
    await plan.kaydet(ContentType.hadis, g26,
        _dua('h').copyWithType(ContentType.hadis), ContentStatus.taslak);
    expect(plan.kayit(ContentType.dua, g26)!.icerik.baslik, 'a');
    expect(plan.kayit(ContentType.dua, g27)!.icerik.baslik, 'b');
    await plan.sil(ContentType.dua, g27);
    expect(plan.kayit(ContentType.dua, g26)!.icerik.baslik, 'a');
    expect(plan.kayit(ContentType.hadis, g26), isNotNull);
  });

  test('Taslak, arsiv ve gelecek tarihli kayit kullaniciya gosterilmez',
      () async {
    final simdi = DateTime(2026, 11, 26, 10);
    final g = DateTime(2026, 11, 26), g2 = DateTime(2026, 11, 27);
    await plan.kaydet(ContentType.dua, g, _dua('t'), ContentStatus.taslak);
    expect(plan.yayindaki(ContentType.dua, g, simdi: simdi), isNull);
    expect(plan.durum(ContentType.dua, g, simdi: simdi), PlanDurumu.taslak);
    await plan.durumDegistir(ContentType.dua, g, ContentStatus.arsivlendi);
    expect(plan.yayindaki(ContentType.dua, g, simdi: simdi), isNull);
    await plan.kaydet(ContentType.dua, g2, _dua('p'), ContentStatus.yayinlandi);
    expect(plan.durum(ContentType.dua, g2, simdi: simdi), PlanDurumu.planlandi);
    expect(plan.yayindaki(ContentType.dua, g2, simdi: simdi), isNull);
    // Tarihi gelince gorunur
    expect(plan.yayindaki(ContentType.dua, g2, simdi: g2)!.baslik, 'p');
  });

  test('Yayindaki plan ana sayfa kartinin kaynagina yansir', () async {
    final otomatik =
        ContentService.instance.otomatikGunlukKayit(ContentType.dua, bugun);
    await plan.kaydet(
        ContentType.dua, bugun, _dua('plan'), ContentStatus.yayinlandi);
    expect(
        ContentService.instance
            .getDailyPoolItem(ContentType.dua, bugun)!
            .baslik,
        'plan');
    expect(ContentService.instance.planliMi(ContentType.dua, bugun), isTrue);
    // Taslaga alininca arsiv sirasina doner
    await plan.durumDegistir(ContentType.dua, bugun, ContentStatus.taslak);
    expect(ContentService.instance.getDailyPoolItem(ContentType.dua, bugun)!.id,
        otomatik!.id);
    // Baska gunler etkilenmez
    expect(plan.kayit(ContentType.dua, dun), isNull);
  });

  test('Kayitlar uygulama yeniden acilinca korunur', () async {
    await plan.kaydet(
        ContentType.vecize, yarin, _dua('v'), ContentStatus.yayinlandi);
    plan.testIcinSifirla();
    await plan.yukle();
    expect(plan.kayit(ContentType.vecize, yarin)!.icerik.baslik, 'v');
    expect(plan.sonGuncellenenler().first.program, ContentType.vecize);
  });

  testWidgets('Panel bugunle acilir; sonraki/onceki gun ve Bugune Git',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.6;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(
      locale: Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: GunlukYonetimPage(),
    ));
    await tester.pumpAndSettle();
    final ctx = tester.element(find.byType(GunlukYonetimPage));
    final ml = MaterialLocalizations.of(ctx);
    // BUGUN ve SECILEN TARIH ayni gun
    expect(find.text(ml.formatFullDate(bugun)), findsNWidgets(2));
    await tester.tap(find.text('Sonraki Gün'));
    await tester.pumpAndSettle();
    expect(find.text(ml.formatFullDate(yarin)), findsOneWidget);
    expect(find.text('Gelecek gün · planla / taslak'), findsOneWidget);
    await tester.tap(find.text('Önceki Gün'));
    await tester.tap(find.text('Önceki Gün'));
    await tester.pumpAndSettle();
    expect(find.text(ml.formatFullDate(dun)), findsOneWidget);
    await tester.tap(find.text('Bugüne Git').first);
    await tester.pumpAndSettle();
    expect(find.text(ml.formatFullDate(bugun)), findsNWidgets(2));
    // Alti program karti
    for (final ad in [
      'Günün Vecizesi',
      'Günün Ayeti',
      'Günün Hadisi',
      'Günün Duası',
      'Günün Kıssası',
      'Risale-i Nur / Hakikat'
    ]) {
      await tester.scrollUntilVisible(find.text(ad), 300,
          scrollable: find.byType(Scrollable).first);
      expect(find.text(ad), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}

extension on ContentItem {
  ContentItem copyWithType(ContentType t) => ContentItem(
      id: id, type: t, baslik: baslik, icerik: icerik, kaynak: kaynak);
}
