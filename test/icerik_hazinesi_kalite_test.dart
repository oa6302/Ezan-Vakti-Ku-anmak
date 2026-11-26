// Dua Hazinesi, Risale dersleri ve Vecize detaylari kalite kontrolu
// (standartlar/DUA_STANDARDI.md, RISALE_STANDARDI.md, VECIZE_STANDARDI.md).
// Olculebilen maddeler test edilir; dinî dogruluk insan incelemesi ister.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';

List<Map<String, dynamic>> _oku(String p) =>
    (jsonDecode(File(p).readAsStringSync()) as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

final _arapHarf = RegExp(r'[؀-ۿ]');
final _latinHarf = RegExp(r'[A-Za-zçğışöüÇĞİŞÖÜ]');

void main() {
  group('Dua Hazinesi', () {
    final dualar = _oku(duaHazinesiVarligi).map(DuaKaydi.fromJson).toList();
    test('Benzersiz kimlik',
        () => expect(dualar.map((d) => d.id).toSet().length, dualar.length));
    for (final d in dualar) {
      group(d.id, () {
        test('Arapca metin Arap harfli (Latin degil)', () {
          expect(_arapHarf.hasMatch(d.arapca), isTrue);
          expect(_latinHarf.hasMatch(d.arapca), isFalse);
        });
        test('Okunus, anlam ve kaynak dolu', () {
          for (final s in [d.okunus, d.anlam, d.kaynak]) {
            expect(s.trim(), isNotEmpty);
          }
        });
        test('Hadis ise numara ve sihhat belirtilmis', () {
          if (d.sinif == DuaSinifi.sahihHadis || d.sinif == DuaSinifi.hadis) {
            expect(d.hadisNo.trim(), isNotEmpty);
            expect(d.sihhat.trim(), isNotEmpty);
          }
        });
        test('Ezber parcalari metni eksiksiz kapsar', () {
          expect(d.parcalar, isNotEmpty);
          String sade(String s) => s.replaceAll(RegExp(r'[\s،,]'), '');
          expect(sade(d.parcalar.map((p) => p.arapca).join()), sade(d.arapca));
        });
      });
    }
  });

  group('Risale-i Nur dersleri', () {
    final dersler =
        _oku(risaleDersleriVarligi).map(RisaleDersi.fromJson).toList();
    for (final d in dersler) {
      group(d.id, () {
        test(
            'Govde 2.800-3.200 karakter',
            () => expect(d.govde.length, inInclusiveRange(2800, 3200),
                reason: '${d.govde.length}'));
        test('Dua Arapca + okunus + anlam + kaynak', () {
          expect(_arapHarf.hasMatch(d.dua.arapca), isTrue);
          for (final s in [d.dua.okunus, d.dua.anlam, d.dua.kaynak]) {
            expect(s.trim(), isNotEmpty);
          }
        });
        test('Risale perspektifinde eser adi ve kaynaklar', () {
          expect(d.kaynaklar.any((k) => k.contains('Said Nursî')), isTrue);
        });
        test('Risale perspektifindeki birebir alintilar dogrulanmis metinde',
            () {
          final dogrulanmis = [
            ..._oku('assets/content/gunluk_vecizeler.json')
                .map((v) => v['latin'] as String),
            ..._oku('assets/content/gunluk_risale.json')
                .map((v) => v['latin'] as String),
          ];
          for (final m in RegExp('“([^”]+)”').allMatches(d.risalePerspektifi)) {
            expect(dogrulanmis.any((t) => t.contains(m.group(1)!)), isTrue,
                reason: 'Dogrulanmamis alinti: ${m.group(1)}');
          }
        });
        test('Mini sinav ve tefekkur sorusu', () {
          expect(
              d.sinav.length + d.dogruYanlis.length, greaterThanOrEqualTo(3));
          for (final s in d.sinav) {
            expect(s.dogru, inInclusiveRange(0, s.secenekler.length - 1));
          }
          expect(d.tefekkurSorusu.trim(), endsWith('?'));
        });
      });
    }
  });

  group('Vecize detaylari', () {
    final detaylar =
        _oku(vecizeDetaylariVarligi).map(VecizeDetayi.fromJson).toList();
    for (final d in detaylar) {
      group(d.latin, () {
        test(
            'Govde 2.800-3.200 karakter',
            () => expect(d.govde.length, inInclusiveRange(2800, 3200),
                reason: '${d.govde.length}'));
        test('Kaynak eser ve bolum belirtilmis, sayfa uydurulmamis', () {
          expect(d.kaynakEser, contains(','));
          expect(d.kaynakEser.toLowerCase(), isNot(contains('sayfa')));
        });
        test('Muhasebe, tatbik ve dua', () {
          expect(d.muhasebe.length, greaterThanOrEqualTo(2));
          expect(d.tatbik.length, greaterThanOrEqualTo(2));
          expect(_arapHarf.hasMatch(d.dua.arapca), isTrue);
          expect(d.dua.kaynak.trim(), isNotEmpty);
        });
      });
    }
  });
}
