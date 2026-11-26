// Gercek cihaz/emulator testi: uygulama aciliyor, her sekme ve "Daha Fazla"
// altindaki her sayfa hatasiz aciliyor mu?
//   flutter test integration_test -d emulator-5554
//   (giris bilgileri: --dart-define-from-file=android/hooks/test_bilgileri.json)
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nur_pusulasi/main.dart' as uygulama;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> bekle(WidgetTester t, [int ms = 1500]) async {
    for (var i = 0; i < ms ~/ 250; i++) {
      await t.pump(const Duration(milliseconds: 250));
    }
  }

  testWidgets('Uygulama, sekmeler ve Daha Fazla sayfalari', (t) async {
    uygulama.main();
    await bekle(t, 4000);
    expect(t.takeException(), isNull, reason: 'Acilis');

    // Alt menu: Pusula, Takip, Kutuphane, Daha Fazla, Ana sayfa (orta)
    for (final sekme in ['Pusula', 'Takip', 'Kütüphane', 'Daha Fazla']) {
      await t.tap(find.text(sekme).last);
      await bekle(t);
      expect(t.takeException(), isNull, reason: 'Sekme: $sekme');
    }
    await t.tap(find.byIcon(Icons.mosque_rounded).last);
    await bekle(t);
    expect(t.takeException(), isNull, reason: 'Ana sayfa');

    // Daha Fazla altindaki her sayfaya gir, geri don
    await t.tap(find.text('Daha Fazla').last);
    await bekle(t);
    const sayfalar = [
      'Huşu Takibi',
      'Namaz Öğren',
      'Ruh Halin',
      'Manevi Yolculuk',
      'Şükür Defteri',
      'Dil ve Yazı Stili',
      'Bildirim Ayarları',
      'Akıllı Asistan',
      'Admin Panel',
    ];
    for (final ad in sayfalar) {
      final hedef = find.text(ad);
      await t.scrollUntilVisible(hedef, 200,
          scrollable: find.byType(Scrollable).last);
      await t.tap(hedef);
      await bekle(t);
      expect(t.takeException(), isNull, reason: 'Sayfa: $ad');
      // Sistem geri tusu (ozel basligi olan sayfalarda da calisir)
      await t.binding.handlePopRoute();
      await bekle(t, 750);
      expect(find.text('Daha Fazla'), findsWidgets, reason: 'Geri: $ad');
    }
  });
}
