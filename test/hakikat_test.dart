// Risale-i Nur / Hakikat bolumu: veri, servis, egitim araclari ve sayfalar.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/hakikat_servisi.dart';
import 'package:nur_pusulasi/data/hakikat.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/features/admin/hakikat_yonetim_page.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/risale_card.dart';
import 'package:nur_pusulasi/features/hazine/hakikat/egitim.dart';
import 'package:nur_pusulasi/features/hazine/hakikat/hakikat_sayfalari.dart';
import 'package:nur_pusulasi/features/hazine/hakikat/risale_pasaj_page.dart';
import 'package:nur_pusulasi/features/hazine/risale_dersleri_page.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> _oku(String p) => [
      for (final e in jsonDecode(File(p).readAsStringSync()) as List)
        Map<String, dynamic>.from(e as Map)
    ];

final _dersler = _oku(risaleDersleriVarligi).map(RisaleDersi.fromJson).toList();

Widget _uygulama(Widget w) => MaterialApp(
      locale: const Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: w,
    );

Future<HakikatServisi> _servis({Map<String, Object> prefs = const {}}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final s = HakikatServisi.instance..testIcinSifirla();
  await s.yukle(varlik: _dersler);
  return s;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Veri', () {
    test('Her dersin konusu gecerli; her konuda en az bir ders var', () {
      for (final d in _dersler) {
        expect(d.konular, isNotEmpty, reason: d.id);
        for (final k in d.konular) {
          expect(HakikatKonusu.ara(k), isNotNull, reason: '${d.id}: $k');
        }
      }
      for (final k in HakikatKonusu.values) {
        expect(_dersler.any((d) => d.hakikatKonulari.contains(k)), isTrue,
            reason: k.name);
      }
    });

    test('toJson / fromJson geri donusu kayipsiz', () {
      for (final d in _dersler) {
        final y = RisaleDersi.fromJson(
            Map<String, dynamic>.from(jsonDecode(jsonEncode(d.toJson()))));
        expect(jsonEncode(y.toJson()), jsonEncode(d.toJson()), reason: d.id);
      }
    });

    test('Kimlikler benzersiz; konular alani olmayan eski kayit da calisir',
        () {
      expect(_dersler.map((d) => d.id).toSet().length, _dersler.length);
      final eski = RisaleDersi.fromJson({'id': 'x', 'kategori': 'ahiret'});
      expect(eski.hakikatKonulari, [HakikatKonusu.ahiret]);
    });

    test('Kulliyat kayitlari tam; kimlik benzersiz, metin uydurma yok', () {
      final k =
          _oku(risaleKulliyatVarligi).map(KulliyatEseri.fromJson).toList();
      expect(k.length, greaterThanOrEqualTo(18));
      expect(k.map((e) => e.id).toSet().length, k.length);
      final metinler = [
        ..._oku('assets/content/gunluk_risale.json')
            .map((m) => RisaleMetni.fromJson(m)),
        ..._oku('assets/content/gunluk_vecizeler.json')
            .map((m) => RisaleMetni.fromJson(m, vecize: true)),
      ];
      for (final e in k) {
        expect(e.tanitim.trim(), isNotEmpty, reason: e.id);
        expect(e.konular, isNotEmpty, reason: e.id);
        expect(e.tanitim, isNot(contains(RegExp(r'\bs\.\s*\d|sayfa \d'))),
            reason: 'sayfa numarasi uydurulmaz: ${e.id}');
        if (e.risale) expect(e.konum, isNotEmpty, reason: e.id);
      }
      // Ana eserlerin dogrulanmis metni var
      for (final id in [
        'sozler',
        'mektubat',
        'lemalar',
        'sualar',
        'hastalar'
      ]) {
        final e = k.firstWhere((x) => x.id == id);
        expect(metinler.where(e.metniKapsar), isNotEmpty, reason: id);
      }
    });

    test('Dua metinlerinde HTML kacis karakteri kalmadi', () {
      for (final f in [
        'assets/content/dua_hazinesi.json',
        'assets/content/gunluk_dualar.json',
        'assets/content/gunluk_ayetler.json',
        risaleDersleriVarligi,
      ]) {
        expect(File(f).readAsStringSync(), isNot(contains('&quot;')),
            reason: f);
      }
    });

    test('Arama Turkce harf ve sapkalari yok sayar', () {
      expect(aramaEslesir('Îmân hem nûrdur', 'iman nur'), isTrue);
      expect(aramaEslesir('İhlâs Risalesi', 'ihlas'), isTrue);
      expect(aramaEslesir('Sabır', 'şükür'), isFalse);
    });
  });

  group('Servis', () {
    test('Gunun Hakikati ayni gun sabit, ertesi gun degisir', () async {
      final s = await _servis();
      final a = s.gununHakikati(DateTime(2026, 11, 27, 8));
      final b = s.gununHakikati(DateTime(2026, 11, 27, 23, 59));
      final c = s.gununHakikati(DateTime(2026, 11, 28));
      expect(a!.id, b!.id);
      expect(c!.id, isNot(a.id));
      expect(s.arsiv(DateTime(2026, 11, 27), gun: 10).length, 10);
    });

    test('Plan yalniz kendi tarihini etkiler; taslak gosterilmez', () async {
      final s = await _servis();
      final gun = DateTime(2026, 12, 1);
      final ertesi = DateTime(2026, 12, 2);
      final once = s.gununHakikati(ertesi)!.id;
      await s.planla(gun, 'ders_010');
      expect(s.gununHakikati(gun)!.id, 'ders_010');
      expect(s.gununHakikati(ertesi)!.id, once);
      await s.durumDegistir('ders_010', HakikatDurumu.taslak);
      expect(s.gununHakikati(gun)!.id, isNot('ders_010'));
      expect(s.yayindakiler.any((d) => d.id == 'ders_010'), isFalse);
    });

    test('Duzenleme varligi bozmaz; geri alinabilir; yeni kayit taslak',
        () async {
      final s = await _servis();
      final d = s.bul('ders_001')!;
      final yeni = RisaleDersi.fromJson({...d.toJson(), 'baslik': 'Degisti'});
      await s.kaydetDers(yeni);
      expect(s.bul('ders_001')!.baslik, 'Degisti');
      expect(_dersler.first.baslik, isNot('Degisti'));
      await s.duzenlemeyiGeriAl('ders_001');
      expect(s.bul('ders_001')!.baslik, d.baslik);

      final id = s.yeniId();
      expect(s.bul(id), isNull);
      await s.kaydetDers(
          RisaleDersi.fromJson({...d.toJson(), 'id': id, 'baslik': 'Yeni'}),
          yeniDurum: HakikatDurumu.taslak);
      expect(s.durum(id), HakikatDurumu.taslak);
      expect(s.yayindakiler.any((x) => x.id == id), isFalse);
      await s.sil(id);
      expect(s.bul(id), isNull);
    });

    test('Okuyucu durumu kapatip acinca korunur', () async {
      final s = await _servis();
      await s.favoriDegistir('ders_002');
      await s.sonraOkuDegistir('ders_003');
      await s.tamamlandiDegistir('ders_004');
      await s.ilerlemeKaydet('ders_005', 0.6);
      await s.testSonucu('ders_005', 67);
      await s.yaziOlcegiAyarla(1.2);
      await s.planla(DateTime(2027, 1, 1), 'ders_006');
      final ham = (await SharedPreferences.getInstance())
          .getString('nur_pusulasi_hakikat_v1')!;

      final y = await _servis(prefs: {'nur_pusulasi_hakikat_v1': ham});
      expect(y.favoriMi('ders_002'), isTrue);
      expect(y.sonraOkuMu('ders_003'), isTrue);
      expect(y.tamamlandiMi('ders_004'), isTrue);
      expect(y.ilerleme('ders_005'), closeTo(0.6, 0.001));
      expect(y.testPuani('ders_005'), 67);
      expect(y.yaziOlcegi, closeTo(1.2, 0.001));
      expect(y.gununHakikati(DateTime(2027, 1, 1))!.id, 'ders_006');
      await y.favoriDegistir('ders_002');
      expect(y.favoriMi('ders_002'), isFalse);
    });

    test('Bozuk kayit uygulamayi dusurmez', () async {
      final s = await _servis(prefs: {'nur_pusulasi_hakikat_v1': '{bozuk'});
      expect(s.yayindakiler.length, _dersler.length);
    });
  });

  group('Egitim', () {
    test('Bosluk sorusu ozet cumlesindeki kavramdan uretilir', () {
      var uretilen = 0;
      for (final d in _dersler) {
        final b = BoslukSorusu.uret(d, _dersler);
        if (b == null) continue;
        uretilen++;
        expect(b.secenekler, contains(b.cevap));
        expect('${b.once}${b.cevap}${b.sonra}', d.ders);
        expect(b.secenekler.toSet().length, b.secenekler.length);
      }
      expect(uretilen, greaterThan(10));
    });

    testWidgets('Yanlis cevapta dogru cevap ve gerekce gosterilir', (t) async {
      await _servis();
      final d = _dersler.first;
      await t.pumpWidget(_uygulama(Scaffold(
          body: SingleChildScrollView(
              child: HakikatTesti(ders: d, kaydet: false)))));
      final s = d.sinav.first;
      final yanlis = s.secenekler[(s.dogru + 1) % s.secenekler.length];
      await t.tap(find.text(yanlis));
      await t.pump();
      expect(find.textContaining('Doğru cevap: ${s.secenekler[s.dogru]}'),
          findsOneWidget);
      expect(find.textContaining('Dersin özü'), findsWidgets);
    });
  });

  group('Sayfalar', () {
    setUpAll(() async {
      risaleDersleri
        ..clear()
        ..addAll(_dersler);
      await hakikatVerisiniYukle();
    });
    setUp(() async {
      await _servis();
    });

    testWidgets('Ana ekran: Gunun Hakikati, konular ve kulliyat', (t) async {
      await t.binding.setSurfaceSize(const Size(420, 2400));
      await t.pumpWidget(_uygulama(const RisaleDersleriPage()));
      await t.pumpAndSettle();
      expect(find.text('Günün Hakikati'), findsOneWidget);
      expect(find.text('Detaylı incele'), findsOneWidget);
      expect(
          find.text('Peygamberlik ve Hz. Muhammed (s.a.v.)'), findsOneWidget);
      expect(find.text('Risale-i Nur Külliyatı'), findsWidgets);
      expect(t.takeException(), isNull);
      await t.binding.setSurfaceSize(null);
    });

    testWidgets('Tablet genisliginde tasma yok', (t) async {
      await t.binding.setSurfaceSize(const Size(1100, 2400));
      await t.pumpWidget(_uygulama(const RisaleDersleriPage()));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
      await t.binding.setSurfaceSize(null);
    });

    testWidgets('Detay: bolumler, favori ve tamamlandi kaydi', (t) async {
      await t.binding.setSurfaceSize(const Size(420, 900));
      final d = _dersler.firstWhere((x) => x.id == 'ders_034');
      await t.pumpWidget(_uygulama(RisaleDersPage(ders: d)));
      await t.pumpAndSettle();
      expect(find.text(d.baslik), findsWidgets);
      for (final b in [
        'Tefekkür Kapısı',
        'Risale-i Nur Perspektifi',
        'Kâinattan Deliller',
        'Hikmet Penceresi',
        'Kaynaklar',
      ]) {
        await t.scrollUntilVisible(find.textContaining(b), 300,
            scrollable: find.byType(Scrollable).first);
        expect(find.textContaining(b), findsWidgets, reason: b);
      }
      await t.tap(find.byTooltip('Favorilere ekle'));
      await t.pump();
      expect(HakikatServisi.instance.favoriMi(d.id), isTrue);
      await t.scrollUntilVisible(find.text('Tamamlandı olarak işaretle'), 400,
          scrollable: find.byType(Scrollable).first);
      await t.tap(find.text('Tamamlandı olarak işaretle'));
      await t.pump();
      expect(HakikatServisi.instance.tamamlandiMi(d.id), isTrue);
      expect(t.takeException(), isNull);
      await t.binding.setSurfaceSize(null);
    });

    testWidgets('Arama kavram ve konu ile bulur', (t) async {
      await t.pumpWidget(_uygulama(const HakikatAramaPage(ilkSorgu: 'ihlas')));
      await t.pumpAndSettle();
      expect(find.text('İhlası Kazandıran Ölümü Düşünmek'), findsOneWidget);
    });

    testWidgets('Bos konu yerine dogrulanmis metin gosterir', (t) async {
      HakikatServisi.instance.durumDegistir('ders_034', HakikatDurumu.arsiv);
      await t.pumpWidget(
          _uygulama(const HakikatKonuPage(konu: HakikatKonusu.nubuvvet)));
      await t.pumpAndSettle();
      expect(find.textContaining('henüz hakikat dersi yok'), findsOneWidget);
      expect(find.text('İlgili Risale-i Nur metinleri'), findsOneWidget);
    });

    testWidgets('Yonetim: tarih ve liste; duzenleyici kaydeder', (t) async {
      await t.binding.setSurfaceSize(const Size(420, 1600));
      await t.pumpWidget(
          _uygulama(HakikatYonetimPage(tarih: DateTime(2026, 11, 27))));
      await t.pumpAndSettle();
      expect(find.text('2026-11-27'), findsOneWidget);
      await t.tap(find.byIcon(Icons.chevron_right_rounded).first);
      await t.pump();
      expect(find.text('2026-11-28'), findsOneWidget);

      await t.pumpWidget(_uygulama(Builder(
          builder: (c) => TextButton(
              onPressed: () => Navigator.push(
                  c,
                  MaterialPageRoute<void>(
                      builder: (_) => const HakikatDuzenlePage())),
              child: const Text('ac')))));
      await t.tap(find.text('ac'));
      await t.pumpAndSettle();
      await t.enterText(find.widgetWithText(TextFormField, 'Başlık'), 'Deneme');
      await t.enterText(
          find.widgetWithText(TextFormField, 'Öğrenilen Hakikat'), 'Öz');
      await t.tap(find.text('Kaydet'));
      await t.pumpAndSettle();
      final yeni =
          HakikatServisi.instance.tumu.where((d) => d.baslik == 'Deneme');
      expect(yeni, hasLength(1));
      expect(
          HakikatServisi.instance.durum(yeni.first.id), HakikatDurumu.taslak);
      await t.binding.setSurfaceSize(null);
    });
  });

  group('Ana sayfa Risale-i Nur karti', () {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await ContentService.instance.load();
      risaleDersleri
        ..clear()
        ..addAll(_dersler);
      await hakikatVerisiniYukle();
    });
    setUp(() async {
      await _servis();
    });

    testWidgets('Devamini oku pasajin tamamini uygulama icinde acar',
        (t) async {
      await t.binding.setSurfaceSize(const Size(420, 1400));
      await t.pumpWidget(_uygulama(
          const Scaffold(body: SingleChildScrollView(child: RisaleCard()))));
      await t.pumpAndSettle();
      expect(find.text('Devamını oku'), findsOneWidget);
      expect(find.text('Hakikati keşfet'), findsOneWidget);
      expect(find.text('Günün Hakikati'), findsOneWidget);
      final r = ContentService.instance
          .getDailyPoolItem(ContentType.risale, DateTime.now())!;
      await t.tap(find.text('Devamını oku'));
      await t.pumpAndSettle();
      expect(find.byType(RisalePasajPage), findsOneWidget);
      expect(find.text(r.icerik), findsOneWidget);
      expect(find.text('Eserden aynen'), findsOneWidget);
      await t.tap(find.text('Osmanlıca'));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
      await t.binding.setSurfaceSize(null);
    });

    testWidgets('Hakikati kesfet Hakikat bolumunu acar', (t) async {
      await t.binding.setSurfaceSize(const Size(420, 1400));
      await t.pumpWidget(_uygulama(
          const Scaffold(body: SingleChildScrollView(child: RisaleCard()))));
      await t.pumpAndSettle();
      await t.tap(find.text('Hakikati keşfet'));
      await t.pumpAndSettle();
      expect(find.byType(RisaleDersleriPage), findsOneWidget);
      expect(find.text('Hakikat Konuları'), findsOneWidget);
      await t.binding.setSurfaceSize(null);
    });

    test('Okuma suresi ve metin konulari', () {
      expect(okumaDakikasi('kelime ' * 50), 1);
      expect(okumaDakikasi('kelime ' * 400), 3);
      expect(metinKonulari('Îmân ve Kur’ân ve îmân'),
          containsAllInOrder([HakikatKonusu.iman, HakikatKonusu.kuran]));
    });
  });
}
