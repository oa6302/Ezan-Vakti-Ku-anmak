// Giris (yonetici PIN) testleri.
// Giris bilgileri android/hooks/test_bilgileri.json dosyasindan gelir:
//   flutter test --dart-define-from-file=android/hooks/test_bilgileri.json
// Dosya yoksa bu testler atlanir. Kurallar: android/hooks/KURALLAR.md (T1-T4)
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/app/admin_session.dart';
import 'package:nur_pusulasi/features/admin/admin_gate_page.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const adminPin = String.fromEnvironment('ADMIN_PIN');
const kayitliPin = String.fromEnvironment('ADMIN_PIN_KAYITLI');

void main() {
  final atla =
      adminPin.isEmpty ? 'test_bilgileri.json yok (ADMIN_PIN tanimsiz)' : null;

  setUp(() async {
    // Cihazda ozel PIN kayitliymis gibi davran (bos ise varsayilan PIN gecerli)
    SharedPreferences.setMockInitialValues({
      if (kayitliPin.isNotEmpty) 'nur_pusulasi_admin_pin_v1': kayitliPin,
    });
    await AdminSession.instance.logout();
  });

  Future<void> pinGir(WidgetTester tester, String pin) async {
    await tester.pumpWidget(const MaterialApp(
      locale: Locale('tr'),
      supportedLocales: [Locale('tr'), Locale('en'), Locale('ar')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AdminGatePage(),
    ));
    await tester.pump();
    await tester.enterText(find.byType(TextField), pin);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('Yanlis PIN reddedilir', (tester) async {
    await pinGir(tester, '${adminPin}9');
    expect(find.text('PIN yanlis. Tekrar deneyin.'), findsOneWidget);
    expect(AdminSession.instance.isAdmin, isFalse);
  }, skip: atla != null);

  testWidgets('Kayitli test PIN ile giris yapilir', (tester) async {
    await pinGir(tester, adminPin);
    expect(AdminSession.instance.isAdmin, isTrue);
  }, skip: atla != null);
}
