import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/data/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('JSON icerikleri okunabiliyor mu?', () async {
    final repo = LocalContentRepository();

    final ayetler = await repo.byCategory('ayetler');
    expect(ayetler.length, 3);
    expect(ayetler.first.baslik, 'Sabır ve Namaz');

    final dualar = await repo.byCategory('dualar');
    expect(dualar.length, 2);

    final all = await repo.all();
    expect(all.length >= 6, true);

    final sonuc = await repo.search('sabır');
    expect(sonuc.isNotEmpty, true);
  });
}