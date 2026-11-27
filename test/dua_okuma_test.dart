// Premium dua okuma ve ezber ekrani: model, ezber servisi ve etkilesimler.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/dua_ezber_servisi.dart';
import 'package:nur_pusulasi/app/favorites_service.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/features/hazine/dua/dua_ezber_page.dart';
import 'package:nur_pusulasi/features/hazine/dua/dua_gorunum.dart';
import 'package:nur_pusulasi/features/hazine/dua/dua_okuma_page.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _kayitlar = [
  for (final e
      in jsonDecode(File('assets/content/dua_hazinesi.json').readAsStringSync())
          as List)
    DuaKaydi.fromJson(Map<String, dynamic>.from(e as Map))
];

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

ContentItem _hadisDuasi() => const ContentItem(
      id: 'gdua_test',
      type: ContentType.dua,
      baslik: 'Sığınma Duası',
      icerik: '',
      altIcerik:
          'Allah’ım! Beni günahlarımdan kar, dolu ve soğuk su ile temizle.',
      arapca: '',
      kaynak: 'Nesâî, 402',
      kategori: 'Sığınma',
      durum: ContentStatus.yayinlandi,
      extra: {'sihhat': 'Sahih'},
    );

Future<void> _hazirla({Map<String, Object> prefs = const {}}) async {
  SharedPreferences.setMockInitialValues(prefs);
  DuaEzberServisi.instance.testIcinSifirla();
  await DuaEzberServisi.instance.yukle();
  await FavoritesService.instance.load();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Model', () {
    test('Hazine kaydi tum alanlariyla eslenir', () {
      final k = _kayitlar.firstWhere((d) => d.parcalar.isNotEmpty);
      final g = DuaGorunum.kayittan(k);
      expect(g.arapca, k.arapca);
      expect(g.okunus, k.okunus);
      expect(g.anlam, k.anlam);
      expect(g.kaynak, k.kaynak);
      expect(ezberParcalari(g), k.parcalar);
      expect(g.favori.type, ContentType.dua);
    });

    test('Hadis duasi: Arapca ve okunus uydurulmaz, yalniz meal', () {
      final g = DuaGorunum.icerikten(_hadisDuasi());
      expect(g.arapca, isEmpty);
      expect(g.okunus, isEmpty);
      expect(g.anlam, contains('temizle'));
      expect(g.sihhat, 'Sahih');
    });

    test('Parcasiz duada bolme metni degistirmez', () {
      final g = DuaGorunum.icerikten(_hadisDuasi());
      final p = ezberParcalari(g);
      expect(p.map((x) => x.anlam).join(' '), g.anlam);
      final ar = DuaGorunum.kayittan(_kayitlar.first);
      final bos = DuaGorunum(
          id: 'x',
          baslik: 'x',
          kategori: '',
          arapca: ar.arapca,
          okunus: '',
          anlam: '',
          kaynak: '',
          favori: ar.favori);
      expect(ezberParcalari(bos).map((x) => x.arapca).join(' '),
          ar.arapca.trim().split(RegExp(r'\s+')).join(' '));
    });
  });

  group('Ezber servisi', () {
    test('Aralikli tekrar: 1, 3, 7 gun; basarisizlikta basa doner', () async {
      await _hazirla();
      final s = DuaEzberServisi.instance;
      final g = DateTime(2026, 11, 27);
      await s.tekrarYapildi('d', basarili: true, simdi: g);
      expect(s.kayit('d').sonrakiTekrar, '2026-11-28');
      await s.tekrarYapildi('d', basarili: true, simdi: g);
      expect(s.kayit('d').sonrakiTekrar, '2026-11-30');
      await s.tekrarYapildi('d', basarili: true, simdi: g);
      expect(s.kayit('d').sonrakiTekrar, '2026-12-04');
      expect(s.tekrarZamaniMi('d', simdi: DateTime(2026, 12, 4)), isTrue);
      expect(s.tekrarZamaniMi('d', simdi: DateTime(2026, 12, 3)), isFalse);
      await s.parcaDegistir('d', 0);
      expect(s.tamamlandiMi('d', 1), isTrue);
      await s.tekrarYapildi('d', basarili: false, simdi: g);
      expect(s.kayit('d').seviye, 0);
      expect(s.tamamlandiMi('d', 1), isFalse);
    });

    test('Eski ezber_<id> kaydi aktarilir; ayarlar kalici', () async {
      await _hazirla(prefs: {
        'ezber_dua_k001': ['0', '2']
      });
      final s = DuaEzberServisi.instance;
      await s.eskiKaydiAktar('dua_k001');
      expect(s.kayit('dua_k001').parcalar, {0, 2});
      await s.boyutAyarla(arapca: 34, okunus: 21, anlam: 18);
      await s.geceModuDegistir();
      final ham = (await SharedPreferences.getInstance())
          .getString('nur_pusulasi_dua_ezber_v1')!;
      await _hazirla(prefs: {'nur_pusulasi_dua_ezber_v1': ham});
      expect(s.kayit('dua_k001').parcalar, {0, 2});
      expect(s.arapcaBoyut, 34);
      expect(s.geceModu, isTrue);
    });
  });

  group('Ekran', () {
    final liste = [for (final k in _kayitlar.take(5)) DuaGorunum.kayittan(k)];

    testWidgets('Sira, ortali metin ve gizle/goster', (t) async {
      await _hazirla();
      await t.binding.setSurfaceSize(const Size(360, 2200));
      final d = liste[1];
      await t.pumpWidget(_uygulama(DuaOkumaPage(dua: d, liste: liste)));
      await t.pumpAndSettle();
      final etiketler = [
        'ARAPÇA METİN',
        'TÜRKÇE OKUNUŞU',
        'TÜRKÇE ANLAMI',
        'DUANIN KAYNAĞI'
      ];
      final y = [for (final e in etiketler) t.getTopLeft(find.text(e)).dy];
      for (var i = 1; i < y.length; i++) {
        expect(y[i], greaterThan(y[i - 1]), reason: etiketler[i]);
      }
      final anlam = t.widget<SelectableText>(find
          .byWidgetPredicate((w) => w is SelectableText && w.data == d.anlam));
      expect(anlam.textAlign, TextAlign.center);
      final ar = t.widget<SelectableText>(find
          .byWidgetPredicate((w) => w is SelectableText && w.data == d.arapca));
      expect(ar.textAlign, TextAlign.center);

      await t.tap(find.byTooltip('Gizle').first);
      await t.pump();
      expect(find.textContaining('Hatırlamaya çalış'), findsOneWidget);
      await t.tap(find.textContaining('Hatırlamaya çalış'));
      await t.pump();
      expect(find.textContaining('Hatırlamaya çalış'), findsNothing);
      expect(t.takeException(), isNull);
      await t.binding.setSurfaceSize(null);
    });

    testWidgets('Kopyala, kaydet, gece modu ve sonraki dua', (t) async {
      await _hazirla();
      await t.binding.setSurfaceSize(const Size(360, 2200));
      String? pano;
      t.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (c) async {
        if (c.method == 'Clipboard.setData') {
          pano = (c.arguments as Map)['text'] as String;
        }
        return null;
      });
      final d = liste[1];
      await t.pumpWidget(_uygulama(DuaOkumaPage(dua: d, liste: liste)));
      await t.pumpAndSettle();
      await t.tap(find.text('Kopyala'));
      await t.pump();
      expect(pano, contains(d.anlam));
      await t.tap(find.text('Kaydet'));
      await t.pump();
      expect(FavoritesService.instance.isFavorite(d.favori.id), isTrue);
      await t.tap(find.byTooltip('Gece okuma modu'));
      await t.pump();
      expect(DuaEzberServisi.instance.geceModu, isTrue);
      expect(t.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
          DuaPalet.gece.zemin);
      await t.ensureVisible(find.text('Sonraki dua'));
      await t.pumpAndSettle();
      await t.tap(find.text('Sonraki dua'));
      await t.pumpAndSettle();
      expect(find.text(liste[2].baslik), findsWidgets);
      await t.binding.setSurfaceSize(null);
    });

    testWidgets('Yalniz meal: dar ekranda tasma yok', (t) async {
      await _hazirla();
      await t.binding.setSurfaceSize(const Size(320, 1800));
      final g = DuaGorunum.icerikten(_hadisDuasi());
      await t.pumpWidget(_uygulama(DuaOkumaPage(dua: g)));
      await t.pumpAndSettle();
      expect(find.text('Bu duanın kaynağında yalnız meali verilmiştir.'),
          findsOneWidget);
      expect(find.text('ARAPÇA METİN'), findsNothing);
      expect(t.takeException(), isNull);
      await t.binding.setSurfaceSize(null);
    });

    testWidgets('Ezber: tekrar, ezberledim ve hatirlama kaydi', (t) async {
      await _hazirla();
      await t.binding.setSurfaceSize(const Size(380, 1600));
      final d = DuaGorunum.kayittan(
          _kayitlar.firstWhere((k) => k.parcalar.length >= 2));
      await t.pumpWidget(_uygulama(DuaEzberPage(dua: d)));
      await t.pumpAndSettle();
      await t.tap(find.text('Ezberledim').first);
      await t.pump();
      expect(DuaEzberServisi.instance.kayit(d.id).parcalar, {0});

      await t.ensureVisible(find.byIcon(Icons.psychology_rounded));
      await t.pumpAndSettle();
      await t.tap(find.byIcon(Icons.psychology_rounded));
      await t.pumpAndSettle();
      for (var i = 0; i < d.parcalar.length; i++) {
        await t.tap(find.byIcon(Icons.visibility_rounded));
        await t.pumpAndSettle();
        await t.tap(find.text('Hatırladım'));
        await t.pumpAndSettle();
      }
      expect(find.text('Bugünkü tekrar başarılı'), findsOneWidget);
      await t.tap(find.text('Bugünkü tekrarı kaydet'));
      await t.pumpAndSettle();
      expect(DuaEzberServisi.instance.kayit(d.id).seviye, 1);
      expect(t.takeException(), isNull);
      await t.binding.setSurfaceSize(null);
    });

    testWidgets('Paylasim karti uzun metni kesmeden cizer', (t) async {
      final uzun = DuaGorunum.kayittan(_kayitlar
          .reduce((a, b) => a.arapca.length > b.arapca.length ? a : b));
      await t.pumpWidget(_uygulama(SingleChildScrollView(
          child: DuaPaylasimKarti(
              dua: uzun, kaynakEtiketi: 'KAYNAK', uygulamaAdi: 'Nur'))));
      await t.pumpAndSettle();
      expect(find.text(uzun.anlam), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  });
}
