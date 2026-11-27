// 365 gunluk ayet ve hadis listeleri: eksiksiz, benzersiz, kaynakli ve uygulamada kullaniliyor.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> _oku(String p) =>
    (jsonDecode(File(p).readAsStringSync()) as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

final _arap = RegExp(r'[؀-ۿ]');

void main() {
  final ayetler = _oku('assets/content/gunluk_ayetler.json');
  final hadisler = _oku('assets/content/gunluk_hadisler.json');

  test('365 ayet: gun sirasi, benzersiz, Arapca + meal + kaynak', () {
    expect(ayetler.length, 365);
    expect(ayetler.map((a) => a['gun']).toList(),
        List.generate(365, (i) => i + 1));
    expect(ayetler.map((a) => a['anahtar']).toSet().length, 365);
    for (final a in ayetler) {
      expect(_arap.hasMatch(a['arapca'] as String), isTrue,
          reason: '${a['anahtar']}');
      expect((a['meal'] as String).length, greaterThan(30));
      expect(a['kaynak'], matches(RegExp(r', \d+/\d+$')));
    }
  });

  test('365 hadis: gun sirasi, benzersiz numara, metin + kaynak + sihhat', () {
    expect(hadisler.length, 365);
    expect(hadisler.map((h) => h['gun']).toList(),
        List.generate(365, (i) => i + 1));
    expect(hadisler.map((h) => h['numara']).toSet().length, 365);
    for (final h in hadisler) {
      expect((h['metin'] as String).length, greaterThan(60));
      expect((h['kaynak'] as String).trim(), isNotEmpty);
      expect((h['sihhat'] as String).trim(), isNotEmpty);
    }
  });

  test('Gunluk dualar: kaynak + sihhat; hadis dualarinda Arapca yok', () {
    final dualar = _oku('assets/content/gunluk_dualar.json');
    expect(dualar.length, greaterThanOrEqualTo(285));
    // Yazim duzeltmesi yapilan her kayit neyin duzeltildigini soyler
    for (final d in dualar.where((d) => d.containsKey('duzeltme'))) {
      expect(d['duzeltme'], contains('→'), reason: d['kaynak'] as String);
    }
    expect(dualar.map((d) => d['gun']).toList(),
        List.generate(dualar.length, (i) => i + 1));
    expect(dualar.map((d) => d['anlam']).toSet().length, dualar.length);
    for (final d in dualar) {
      expect((d['anlam'] as String).length, greaterThan(20));
      expect((d['kaynak'] as String).trim(), isNotEmpty);
      expect((d['sihhat'] as String).trim(), isNotEmpty);
      final kuran = d['sihhat'] == "Kur'an-ı Kerîm";
      expect(_arap.hasMatch((d['arapca'] as String?) ?? ''), kuran,
          reason: d['kaynak'] as String);
    }
  });

  test('Gunluk dualar: Peygamber duasi olmayan rivayetler alinmaz', () {
    // Elle incelendi: tabiin/sahabenin kisisel duasi, recez veya ozel durum.
    const disarida = {
      'Buhârî, 3743', // Alkame'nin kisisel duasi
      'Buhârî, 6278', // ayni olay
      'Buhârî, 6148', // Amir'in recezi
      'Müslim, 1802', // ayni recez
      'Tirmizî, 3527', // bir adamin duasi
      'Tirmizî, 1092', // ozel durum duasi
    };
    final dualar = _oku('assets/content/gunluk_dualar.json');
    for (final d in dualar) {
      expect(disarida.contains(d['kaynak']), isFalse,
          reason: '${d['kaynak']}: ${d['baslik']}');
    }
  });

  test('Gunluk Risale pasajlari: aynen, eser + bolum + Osmanlica', () {
    final r = _oku('assets/content/gunluk_risale.json');
    expect(r.length, greaterThanOrEqualTo(30));
    for (final x in r) {
      final l = x['latin'] as String;
      expect(l.length, inInclusiveRange(260, 720));
      expect(RegExp(r'^[A-ZÇĞİÖŞÜÂÎÛ]').hasMatch(l), isTrue, reason: l);
      expect(_arap.hasMatch(x['osmanlica'] as String), isTrue);
      expect((x['eser'] as String).isNotEmpty && x['sayfa'] is int, isTrue);
    }
  });

  test('Uygulama gunluk havuzlari bu listelerden kurar; her gun farkli',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await ContentService.instance.load();
    expect(ContentService.instance.getPool(ContentType.ayet).length, 365);
    expect(ContentService.instance.getPool(ContentType.hadis).length, 365);
    expect(
        ContentService.instance
            .getPool(ContentType.hadis)
            .every((h) => (h.arapca ?? '').isEmpty),
        isTrue);
    // Dua havuzu yalniz dogrulanmis kayitlardan; eski dua_havuzu*.dart girmez
    final dua = ContentService.instance.getPool(ContentType.dua);
    expect(dua.length, greaterThanOrEqualTo(285));
    expect(
        dua.any((d) => (d.extra?['aciklama'] ?? '')
            .toString()
            .startsWith('Çeviri metnindeki')),
        isTrue);
    expect(dua.every((d) => d.dogrulandi && d.id.startsWith('gdua_')), isTrue);
    expect(ContentService.instance.getPool(ContentType.vecize).length, 365);
    expect(ContentService.instance.getPool(ContentType.vecize).first.icerik,
        'Îmân hem nûrdur, hem kuvvettir.');
    final yil =
        List.generate(365, (i) => DateTime(2026, 1, 1).add(Duration(days: i)));
    final gunluk = yil
        .map((d) =>
            ContentService.instance.getDailyPoolItem(ContentType.ayet, d)!.id)
        .toSet();
    expect(gunluk.length, 365);
  });
}
