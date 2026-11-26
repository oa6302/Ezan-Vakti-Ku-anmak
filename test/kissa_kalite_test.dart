// Kissa yayin oncesi kalite kontrolu (icerik standardi, madde 8).
// Olculebilen maddeler: uzunluk, bolumler, ders sayisi, kaynak, tekrar,
// kategori, dua kaynagi. Dinî dogruluk insan incelemesi gerektirir.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';

void main() {
  final ham = jsonDecode(File(kissaVarligi).readAsStringSync()) as List;
  final kissalar = ham
      .map((e) => Kissa.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();

  test('Kissa listesi bos degil', () => expect(kissalar, isNotEmpty));

  for (final k in kissalar) {
    group('${k.id} ${k.baslik}', () {
      test('1. Govde 2.800-3.200 karakter (baslik ve kaynak haric)', () {
        expect(k.govde.length, inInclusiveRange(2800, 3200),
            reason: '${k.govde.length} karakter');
      });
      test('Sablonun tum bolumleri dolu', () {
        for (final b in {
          'giris': k.giris,
          'anlatim': k.metin,
          'hikmet': k.hakikat,
          'bugun': k.hayat,
          'sorgula': k.sorgula,
          'dua': k.dua,
          'onemliMesaj': k.hisse,
        }.entries) {
          expect(b.value.trim(), isNotEmpty, reason: '${b.key} bos');
        }
      });
      test('En az 3 ders', () => expect(k.dersler.length, greaterThanOrEqualTo(3)));
      test('2. Kaynak var', () => expect(k.kaynaklar, isNotEmpty));
      test('Sorgula bir soru', () => expect(k.sorgula.trim(), endsWith('?')));
      test('Kimlik ve kategori gecerli', () {
        expect(k.id, matches(RegExp(r'^kissa_\d{3}$')));
        expect(ham.firstWhere((e) => e['id'] == k.id)['kategori'],
            k.kategori.name);
      });
    });
  }

  test('7. Tekrar yok (kimlik ve baslik benzersiz)', () {
    expect(kissalar.map((k) => k.id).toSet().length, kissalar.length);
    expect(kissalar.map((k) => k.baslik.toLowerCase()).toSet().length,
        kissalar.length);
  });

  test('Kaynakli dua, kaynagi belirtilmis', () {
    for (final k in kissalar) {
      if (!k.ozgunDua) expect(k.duaKaynak.trim().length, greaterThan(3));
    }
  });
}
