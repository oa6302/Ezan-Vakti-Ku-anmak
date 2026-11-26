import 'package:flutter_test/flutter_test.dart';
import 'package:nur_pusulasi/data/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Tum kategoriler yukleniyor mu?', () async {
    final repo = LocalContentRepository();

    final ayetler = await repo.byCategory('ayetler');
    expect(ayetler.length, greaterThanOrEqualTo(15));

    final hadisler = await repo.byCategory('hadisler');
    expect(hadisler.length, greaterThanOrEqualTo(10));

    final dualar = await repo.byCategory('dualar');
    expect(dualar.length, greaterThanOrEqualTo(12));

    final vecizeler = await repo.byCategory('vecizeler');
    expect(vecizeler.length, greaterThanOrEqualTo(10));

    final kissalar = await repo.byCategory('kissalar');
    expect(kissalar.length, greaterThanOrEqualTo(5));

    final zikirler = await repo.byCategory('zikirler');
    expect(zikirler.length, greaterThanOrEqualTo(5));

    final all = await repo.all();
    expect(all.length, greaterThanOrEqualTo(57));
  });
}
