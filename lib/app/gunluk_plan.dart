// Tarih bazli yayin plani: her gun (YYYY-MM-DD) ve her program icin ayri kayit.
// Bir gunun/programin kaydi digerlerini asla degistirmez. Taslak ve gelecek
// tarihli kayitlar normal kullaniciya gosterilmez.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'content_service.dart';

/// Gunluk yonetilen programlar (ana sayfadaki gunluk kartlar).
const gunlukProgramlar = <ContentType>[
  ContentType.vecize,
  ContentType.ayet,
  ContentType.hadis,
  ContentType.dua,
  ContentType.kissa,
  ContentType.risale,
];

/// Admin ekraninda gosterilen durum.
enum PlanDurumu { otomatik, taslak, yayinlandi, planlandi, arsivlendi }

class PlanKaydi {
  final String tarih; // YYYY-MM-DD
  final ContentType program;
  final ContentItem icerik;
  final ContentStatus durum; // taslak | yayinlandi | arsivlendi
  final DateTime guncellenme;

  const PlanKaydi({
    required this.tarih,
    required this.program,
    required this.icerik,
    required this.durum,
    required this.guncellenme,
  });

  PlanKaydi kopya({ContentItem? icerik, ContentStatus? durum}) => PlanKaydi(
        tarih: tarih,
        program: program,
        icerik: icerik ?? this.icerik,
        durum: durum ?? this.durum,
        guncellenme: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'tarih': tarih,
        'program': program.key,
        'icerik': icerik.toJson(),
        'durum': durum.key,
        'guncellenme': guncellenme.toIso8601String(),
      };

  static PlanKaydi? fromJson(Map<String, dynamic> j) {
    final program = ContentType.values.where((t) => t.key == j['program']);
    final durum = ContentStatus.values.where((s) => s.key == j['durum']);
    if (program.isEmpty || durum.isEmpty || j['icerik'] is! Map) return null;
    return PlanKaydi(
      tarih: '${j['tarih']}',
      program: program.first,
      icerik: ContentItem.fromJson(Map<String, dynamic>.from(j['icerik'])),
      durum: durum.first,
      guncellenme:
          DateTime.tryParse('${j['guncellenme']}') ?? DateTime(2000, 1, 1),
    );
  }
}

class GunlukPlanServisi extends ChangeNotifier {
  static final GunlukPlanServisi instance = GunlukPlanServisi._();
  GunlukPlanServisi._();

  static const _anahtar = 'nur_pusulasi_gunluk_plan_v1';

  /// tarih -> program anahtari -> kayit
  final Map<String, Map<String, PlanKaydi>> _kayitlar = {};
  bool _yuklendi = false;
  bool get yuklendi => _yuklendi;

  /// Yerel takvim gunu anahtari; saat/saat dilimi kaymasi olmaz.
  static String tarihAnahtari(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static DateTime gun(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime anahtardanTarih(String a) {
    final p = a.split('-').map(int.parse).toList();
    return DateTime(p[0], p[1], p[2]);
  }

  /// [zorla] true ise kalici kayittan yeniden okur (Yenile butonu).
  Future<void> yukle({bool zorla = false}) async {
    if (_yuklendi && !zorla) return;
    final prefs = await SharedPreferences.getInstance();
    if (zorla) await prefs.reload();
    _kayitlar.clear();
    final ham = prefs.getString(_anahtar);
    if (ham != null) {
      try {
        for (final e in (jsonDecode(ham) as List)) {
          final k = PlanKaydi.fromJson(Map<String, dynamic>.from(e as Map));
          if (k != null) (_kayitlar[k.tarih] ??= {})[k.program.key] = k;
        }
      } catch (e) {
        debugPrint('gunluk plan okunamadi: $e');
      }
    }
    _yuklendi = true;
    notifyListeners();
    ContentService.instance.planDegisti();
  }

  Future<void> _yaz() async {
    final prefs = await SharedPreferences.getInstance();
    final liste = [
      for (final g in _kayitlar.values)
        for (final k in g.values) k.toJson()
    ];
    final ok = await prefs.setString(_anahtar, jsonEncode(liste));
    if (!ok) throw StateError('Plan kaydedilemedi');
    notifyListeners();
    ContentService.instance.planDegisti();
  }

  PlanKaydi? kayit(ContentType program, DateTime tarih) =>
      _kayitlar[tarihAnahtari(tarih)]?[program.key];

  /// Normal kullaniciya gosterilecek planli icerik: yalniz yayinlanmis ve
  /// tarihi gelmis (bugun veya gecmis) kayit.
  ContentItem? yayindaki(ContentType program, DateTime tarih,
      {DateTime? simdi}) {
    final k = kayit(program, tarih);
    if (k == null || k.durum != ContentStatus.yayinlandi) return null;
    if (gun(tarih).isAfter(gun(simdi ?? DateTime.now()))) return null;
    return k.icerik;
  }

  PlanDurumu durum(ContentType program, DateTime tarih, {DateTime? simdi}) {
    final k = kayit(program, tarih);
    if (k == null) return PlanDurumu.otomatik;
    switch (k.durum) {
      case ContentStatus.yayinlandi:
        return gun(tarih).isAfter(gun(simdi ?? DateTime.now()))
            ? PlanDurumu.planlandi
            : PlanDurumu.yayinlandi;
      case ContentStatus.arsivlendi:
        return PlanDurumu.arsivlendi;
      case ContentStatus.taslak:
      case ContentStatus.incelemede:
        return PlanDurumu.taslak;
    }
  }

  /// Yalniz [tarih]/[program] hucresini yazar.
  Future<void> kaydet(ContentType program, DateTime tarih, ContentItem icerik,
      ContentStatus durum) async {
    final a = tarihAnahtari(tarih);
    final onceki = _kayitlar[a]?[program.key];
    (_kayitlar[a] ??= {})[program.key] = PlanKaydi(
      tarih: a,
      program: program,
      icerik: icerik,
      durum: durum,
      guncellenme: DateTime.now(),
    );
    try {
      await _yaz();
    } catch (_) {
      // Basarisiz yazimda bellek eski haline doner (veri kaybi olmaz)
      if (onceki == null) {
        _kayitlar[a]!.remove(program.key);
      } else {
        _kayitlar[a]![program.key] = onceki;
      }
      rethrow;
    }
  }

  Future<void> durumDegistir(
      ContentType program, DateTime tarih, ContentStatus durum) async {
    final k = kayit(program, tarih);
    if (k == null) return;
    await kaydet(program, tarih, k.icerik, durum);
  }

  /// Kaydi kaldirir; o gun otomatik arsiv sirasina doner.
  Future<void> sil(ContentType program, DateTime tarih) async {
    final a = tarihAnahtari(tarih);
    final g = _kayitlar[a];
    if (g == null || g.remove(program.key) == null) return;
    if (g.isEmpty) _kayitlar.remove(a);
    await _yaz();
  }

  Iterable<PlanKaydi> get tumKayitlar =>
      _kayitlar.values.expand((g) => g.values);

  Map<String, PlanKaydi> gunKayitlari(DateTime tarih) =>
      Map.unmodifiable(_kayitlar[tarihAnahtari(tarih)] ?? const {});

  List<PlanKaydi> sonGuncellenenler([int adet = 5]) {
    final l = tumKayitlar.toList()
      ..sort((a, b) => b.guncellenme.compareTo(a.guncellenme));
    return l.take(adet).toList();
  }

  /// Ayni metin ayni program icin baska bir gunde kullanilmis mi?
  List<String> ayniMetinTarihleri(ContentType program, String metin,
      {String? haric}) {
    final m = metin.trim();
    if (m.isEmpty) return const [];
    return [
      for (final k in tumKayitlar)
        if (k.program == program &&
            k.tarih != haric &&
            k.icerik.icerik.trim() == m)
          k.tarih
    ]..sort();
  }

  @visibleForTesting
  void testIcinSifirla() {
    _kayitlar.clear();
    _yuklendi = false;
  }
}
