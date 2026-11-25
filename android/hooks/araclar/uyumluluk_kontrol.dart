// U1-U5 uyumluluk. dart run uyumluluk_kontrol.dart <kok> [degisen dosyalar...]
// Dosya verilirse sadece ilgili bolum calisir. Cikis: 0 temiz, 1 hata, 2 uyari.
import 'dart:convert';
import 'dart:io';

var hatalar = 0, uyarilar = 0;
void hata(String m) { hatalar++; stdout.writeln('  [HATA] $m'); }
void uyari(String m) { uyarilar++; stdout.writeln('  [UYARI] $m'); }
late String kok;
File dosya(String p) => File('$kok/$p');
String ad(FileSystemEntity f) => f.uri.pathSegments.last;
bool bomVar(List<int> b) => b.length >= 3 && b[0] == 0xEF && b[1] == 0xBB && b[2] == 0xBF;

void main(List<String> args) {
  kok = args.isNotEmpty ? args.first : '.';
  final d = args.skip(1).map((e) => e.replaceAll('\\', '/')).toList();
  bool ilgili(bool Function(String) f) => d.isEmpty || d.any(f);

  if (ilgili((f) => f == 'pubspec.yaml' || f.startsWith('assets/fonts/'))) u1Pubspec();
  if (ilgili((f) => f.startsWith('assets/content/') && f.endsWith('.json'))) {
    u2Json(d.isEmpty ? null : d.where((f) => f.startsWith('assets/content/') && f.endsWith('.json')));
  }
  if (ilgili((f) => f.startsWith('lib/l10n/') && f.endsWith('.arb'))) u3L10n();
  if (ilgili((f) => f.startsWith('android/'))) u4Android(d.where((f) => f.endsWith('.kt')));
  exit(hatalar > 0 ? 1 : (uyarilar > 0 ? 2 : 0));
}

/// U1 pubspec font/asset yollari diskte olmali
void u1Pubspec() {
  var assetBlok = false;
  for (final s in dosya('pubspec.yaml').readAsLinesSync()) {
    final t = s.trim();
    final font = RegExp(r'^-?\s*asset:\s*(\S+)').firstMatch(t)?.group(1);
    if (font != null) {
      if (!dosya(font).existsSync()) hata('U1 font yok: $font');
      continue;
    }
    if (RegExp(r'^\s{2,}assets:\s*$').hasMatch(s)) { assetBlok = true; continue; }
    if (!assetBlok) continue;
    final p = RegExp(r'^-\s*(\S+)').firstMatch(t)?.group(1);
    if (p == null) { if (t.isNotEmpty && !t.startsWith('#')) assetBlok = false; continue; }
    final var_ = p.endsWith('/') ? Directory('$kok/$p').existsSync() : dosya(p).existsSync();
    if (!var_) hata('U1 asset yok: $p');
  }
}

/// U2 icerik JSON gecerli + BOM'suz
void u2Json(Iterable<String>? sadece) {
  final liste = sadece?.map(dosya) ??
      Directory('$kok/assets/content').listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
  for (final f in liste) {
    if (!f.existsSync()) continue;
    final b = f.readAsBytesSync();
    if (bomVar(b)) uyari('U5 BOM: ${ad(f)}');
    try {
      jsonDecode(utf8.decode(bomVar(b) ? b.sublist(3) : b));
    } on FormatException catch (e) {
      hata('U2 bozuk JSON ${ad(f)}: ${e.message}');
    }
  }
}

/// U3 ARB anahtarlari app_tr.arb ile ayni
void u3L10n() {
  Set<String> k(File f) => (jsonDecode(f.readAsStringSync()) as Map).keys
      .cast<String>().where((e) => !e.startsWith('@')).toSet();
  final sablon = dosya('lib/l10n/app_tr.arb');
  if (!sablon.existsSync()) return;
  final temel = k(sablon);
  for (final f in Directory('$kok/lib/l10n').listSync().whereType<File>()) {
    if (!f.path.endsWith('.arb') || ad(f) == 'app_tr.arb') continue;
    try {
      final a = k(f);
      final eksik = temel.difference(a), fazla = a.difference(temel);
      if (eksik.isNotEmpty) uyari('U3 ${ad(f)} eksik: ${eksik.take(5).join(',')}');
      if (fazla.isNotEmpty) hata('U3 ${ad(f)} fazla anahtar: ${fazla.take(5).join(',')}');
    } catch (e) {
      hata('U3 ${ad(f)} okunamadi: $e');
    }
  }
}

/// U4 namespace = MainActivity paketi, JDK17; U5 .kt BOM
void u4Android(Iterable<String> ktDegisen) {
  final g = dosya('android/app/build.gradle.kts');
  if (!g.existsSync()) return;
  final gs = g.readAsStringSync();
  final ns = RegExp(r'namespace\s*=\s*"([^"]+)"').firstMatch(gs)?.group(1);
  if (!gs.contains('VERSION_17')) uyari('U4 Java hedefi 17 degil');
  final kt = Directory('$kok/android/app/src/main/kotlin');
  if (!kt.existsSync()) return;
  for (final f in kt.listSync(recursive: true).whereType<File>()) {
    if (!f.path.endsWith('.kt')) continue;
    final b = f.readAsBytesSync();
    final rel = f.path.replaceAll('\\', '/').split('$kok/'.replaceAll('\\', '/')).last;
    if (bomVar(b) && (ktDegisen.isEmpty || ktDegisen.contains(rel))) uyari('U5 BOM: ${ad(f)}');
    if (ad(f) == 'MainActivity.kt' && ns != null) {
      final p = RegExp(r'^﻿?package\s+([\w.]+)', multiLine: true)
          .firstMatch(utf8.decode(b, allowMalformed: true))?.group(1);
      if (p != ns) hata('U4 MainActivity paketi ($p) != namespace ($ns)');
    }
  }
}
