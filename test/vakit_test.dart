// Namaz vakti dogrulugu (Diyanet yontemi). Saat dilimine bagli olmasin diye
// mutlak saat yerine vakitler arasi sure ve sira kontrol edilir.
import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/features/prayer/data/prayer_service.dart';

void main() {
  final s = PrayerService();
  final tarih = DateTime(2026, 11, 27);

  test('Vakitler dogru sirada', () async {
    final r = (await s.calculateForLocation(city: 'İstanbul', date: tarih))!;
    final t = r.times;
    final sira = ['Imsak', 'Gunes', 'Ogle', 'Ikindi', 'Aksam', 'Yatsi'];
    for (var i = 1; i < sira.length; i++) {
      expect(t[sira[i]]!.isAfter(t[sira[i - 1]]!), isTrue,
          reason: '${sira[i]} > ${sira[i - 1]}');
    }
  });

  test('Ikindi asr-i evvel (Diyanet), asr-i sani degil', () async {
    final t =
        (await s.calculateForLocation(city: 'İstanbul', date: tarih))!.times;
    final dk = t['Ikindi']!.difference(t['Ogle']!).inMinutes;
    // Istanbul, kasim sonu: asr-i evvel ~2s35dk, asr-i sani ~3s05dk sonra.
    expect(dk, inInclusiveRange(140, 165), reason: 'Ogle->Ikindi $dk dk');
  });

  test('Aksam gunes batimina temkinli, yatsi aksamdan sonra', () async {
    final t =
        (await s.calculateForLocation(city: 'İstanbul', date: tarih))!.times;
    final gunduz = t['Aksam']!.difference(t['Gunes']!).inMinutes;
    // 41K enlemde kasim sonu gunduz ~9s25dk (+temkin)
    expect(gunduz, inInclusiveRange(550, 590));
    expect(t['Yatsi']!.difference(t['Aksam']!).inMinutes,
        inInclusiveRange(70, 100));
  });
}
