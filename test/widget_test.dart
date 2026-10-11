import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/data/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('JSON icerikleri okunabiliyor mu?', () async {
    final repo = LocalContentRepository();

    final ayetler = await repo.byCategory('ayetler');
    expect(ayetler.length, greaterThanOrEqualTo(5));
    expect(ayetler.first.baslik, 'Sabır ve Namaz');

    final dualar = await repo.byCategory('dualar');
    expect(dualar.length, 2);

    final all = await repo.all();
    expect(all.length, greaterThanOrEqualTo(9));

    final sabir = await repo.search('sabır');
    expect(sabir.isNotEmpty, true);

    final imtihan = await repo.search('imtihan');
    expect(imtihan.isNotEmpty, true);
    expect(imtihan.first.baslik, 'İmtihan ve Sabır');

    final bos = await repo.search('');
    expect(bos.isEmpty, true);

    final yoksa = await repo.search('xyzkelime123');
    expect(yoksa.isEmpty, true);
  });
}