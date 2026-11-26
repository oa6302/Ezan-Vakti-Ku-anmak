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

  test('Uygulama gunluk havuzlari bu listelerden kurar; her gun farkli',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await ContentService.instance.load();
    expect(ContentService.instance.getPool(ContentType.ayet).length, 365);
    expect(ContentService.instance.getPool(ContentType.hadis).length, 365);
    final yil =
        List.generate(365, (i) => DateTime(2026, 1, 1).add(Duration(days: i)));
    final gunluk = yil
        .map((d) =>
            ContentService.instance.getDailyPoolItem(ContentType.ayet, d)!.id)
        .toSet();
    expect(gunluk.length, 365);
  });
}
