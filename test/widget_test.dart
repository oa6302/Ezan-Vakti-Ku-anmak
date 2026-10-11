import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/main.dart';

void main() {
  testWidgets('Nur Pusulasi ana arayuzu aciliyor', (WidgetTester tester) async {
    await tester.pumpWidget(const NurPusulasiApp());
    await tester.pump();

    expect(find.text('Ana Sayfa'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
