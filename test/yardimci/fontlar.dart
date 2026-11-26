// Testlerde gercek fontlari yukler (sahte tasma uyarilarini onler).
import 'dart:io';

import 'package:flutter/services.dart';

/// Test fontu (Ahem) gercek fonttan ~2 kat genis; sahte tasma uyarisi vermesin diye
/// Flutter SDK'daki Roboto + Material ikonlari + uygulama fontlari yuklenir.
Future<void> gercekFontlariYukle() async {
  // flutter_tester: <sdk>/bin/cache/artifacts/engine/<platform>/flutter_tester
  final exe = Platform.resolvedExecutable.replaceAll('\\', '/');
  final i = exe.indexOf('/bin/cache/');
  final sdk = Platform.environment['FLUTTER_ROOT'] ??
      (i > 0 ? exe.substring(0, i) : '');
  final dizin = '$sdk/bin/cache/artifacts/material_fonts';
  Future<void> yukle(String aile, List<String> dosyalar) async {
    final l = FontLoader(aile);
    for (final d in dosyalar) {
      final f = File(d);
      if (f.existsSync()) {
        l.addFont(Future.value(ByteData.sublistView(f.readAsBytesSync())));
      }
    }
    await l.load();
  }

  await yukle('Roboto', [
    '$dizin/roboto-regular.ttf',
    '$dizin/roboto-medium.ttf',
    '$dizin/roboto-bold.ttf',
    '$dizin/roboto-black.ttf'
  ]);
  await yukle('MaterialIcons', ['$dizin/materialicons-regular.otf']);
  await yukle('Rika', ['assets/fonts/ArefRuqaa-Regular.ttf']);
  await yukle('Matbu', ['assets/fonts/Amiri-Regular.ttf']);
}
