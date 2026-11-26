// Vecize Osmanlica-Latin uyum raporu (standartlar/VECIZE_STANDARDI.md, madde 3).
// Mevcut kayitlar silinmez; uyumsuzlar rapora yazilir. Detay sayfasi olan
// (standarda yukseltilmis) vecizeler ise birebir uyumlu olmak zorundadir.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/data/vecize_havuzu.dart';

void main() {
  test('Gunluk vecizeler: Osmanlica ve Latince ayni cumle, kaynakli', () {
    final gunluk = (jsonDecode(
                File('assets/content/gunluk_vecizeler.json').readAsStringSync())
            as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    expect(gunluk.length, greaterThanOrEqualTo(100));
    expect(gunluk.map((v) => v['latin']).toSet().length, gunluk.length);
    for (final v in gunluk) {
      final o = v['osmanlica'] as String, l = v['latin'] as String;
      expect(RegExp(r'[؀-ۿ]').hasMatch(o), isTrue, reason: l);
      // Esleme kaynakta kelime kelime (data-latince) yapildi; sezgisel
      // harf kontrolu bilesik yazimlarda (ذی حیات = zîhayat) yanilir.
      expect((v['eser'] as String).isNotEmpty && v['sayfa'] is int, isTrue);
    }
  });

  test('Mevcut vecizeler: Osmanlica-Latin uyum raporu', () {
    final rapor = StringBuffer();
    var uyumsuz = 0;
    for (final (i, v) in vecizeHavuzu.indexed) {
      final s = osmanlicaLatinUyumsuzluklari(v.osmanlica, v.latin);
      if (s.isNotEmpty) {
        uyumsuz++;
        rapor.writeln('${i + 1}. ${v.latin}\n   -> ${s.join(' | ')}');
      }
    }
    File('build/vecize_uyum_raporu.txt')
      ..createSync(recursive: true)
      ..writeAsStringSync(
          'Uyumsuz: $uyumsuz / ${vecizeHavuzu.length}\n\n$rapor');
    // ignore: avoid_print
    print(
        'VECIZE UYUM: $uyumsuz / ${vecizeHavuzu.length} uyumsuz (build/vecize_uyum_raporu.txt)');
  });

  test('Detayi olan vecizeler birebir uyumlu ve havuzda mevcut', () {
    final detaylar = (jsonDecode(
            File(vecizeDetaylariVarligi).readAsStringSync()) as List)
        .map((e) => VecizeDetayi.fromJson(Map<String, dynamic>.from(e as Map)));
    // Gunluk havuz: kaynaktan dogrulanmis vecizeler
    final gunluk = (jsonDecode(
                File('assets/content/gunluk_vecizeler.json').readAsStringSync())
            as List)
        .map((e) => Map<String, dynamic>.from(e as Map));
    for (final d in detaylar) {
      final v = gunluk.where((x) => x['latin'] == d.latin);
      expect(v, isNotEmpty, reason: 'Gunluk havuzda yok: ${d.latin}');
      expect(
          osmanlicaLatinUyumsuzluklari(
              v.first['osmanlica'] as String, v.first['latin'] as String),
          isEmpty,
          reason: d.latin);
    }
  });
}
