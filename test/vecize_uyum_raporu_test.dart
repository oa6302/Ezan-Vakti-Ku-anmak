// Vecize Osmanlica-Latin uyum raporu (standartlar/VECIZE_STANDARDI.md, madde 3).
// Mevcut kayitlar silinmez; uyumsuzlar rapora yazilir. Detay sayfasi olan
// (standarda yukseltilmis) vecizeler ise birebir uyumlu olmak zorundadir.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/data/vecize_havuzu.dart';

void main() {
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
    for (final d in detaylar) {
      final v = vecizeHavuzu.where((x) => x.latin == d.latin);
      expect(v, isNotEmpty, reason: 'Havuzda yok: ${d.latin}');
      expect(osmanlicaLatinUyumsuzluklari(v.first.osmanlica, v.first.latin),
          isEmpty,
          reason: d.latin);
    }
  });
}
