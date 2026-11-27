// Risale-i Nur / Hakikat: okuyucu durumu (favori, sonra oku, tamamlanan,
// ilerleme, test sonucu, son okunanlar, yazi boyutu) ve yonetici katmani
// (ozel/duzenlenmis kayit, yayin durumu, tarihe gore Gunun Hakikati).
// Varliktaki dersler hic degistirilmez; duzenlemeler ayri kayit olarak saklanir.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/icerik_hazinesi.dart';
import 'gunluk_plan.dart';

enum HakikatDurumu { taslak, yayinda, arsiv }

class HakikatServisi extends ChangeNotifier {
  static final HakikatServisi instance = HakikatServisi._();
  HakikatServisi._();

  static const _anahtar = 'nur_pusulasi_hakikat_v1';

  final Set<String> _favori = {};
  final Set<String> _sonraOku = {};
  final Map<String, String> _tamamlanan = {}; // id -> YYYY-MM-DD
  final Map<String, double> _ilerleme = {}; // id -> 0..1 (en yuksek)
  final Map<String, int> _testPuani = {}; // id -> en iyi yuzde
  final Map<String, int> _okunma = {}; // id -> acilma sayisi (yerel)
  final Map<String, String> _gorev = {}; // id -> son yapildigi gun
  final List<String> _sonOkunan = [];
  double _yaziOlcegi = 1.0;

  final Map<String, Map<String, dynamic>> _ozel = {}; // id -> ders json
  final Map<String, HakikatDurumu> _durum = {};
  final Map<String, String> _plan = {}; // YYYY-MM-DD -> id
  final Set<String> _silinen = {};

  List<RisaleDersi> _varlik = const [];
  bool _yuklendi = false;

  /// [varlik] verilmezse yuklenmis risaleDersleri kullanilir (testte enjekte edilir).
  Future<void> yukle({List<RisaleDersi>? varlik, bool zorla = false}) async {
    _varlik = varlik ?? List.of(risaleDersleri);
    if (_yuklendi && !zorla) return;
    final prefs = await SharedPreferences.getInstance();
    if (zorla) await prefs.reload();
    _temizle();
    final ham = prefs.getString(_anahtar);
    if (ham != null) {
      try {
        final j = Map<String, dynamic>.from(jsonDecode(ham) as Map);
        Iterable<String> l(String k) =>
            (j[k] as List? ?? const []).map((e) => '$e');
        Map<String, dynamic> m(String k) =>
            Map<String, dynamic>.from(j[k] as Map? ?? const {});
        _favori.addAll(l('favori'));
        _sonraOku.addAll(l('sonraOku'));
        _sonOkunan.addAll(l('sonOkunan'));
        _silinen.addAll(l('silinen'));
        m('tamamlanan').forEach((k, v) => _tamamlanan[k] = '$v');
        m('ilerleme').forEach((k, v) => _ilerleme[k] = (v as num).toDouble());
        m('testPuani').forEach((k, v) => _testPuani[k] = (v as num).toInt());
        m('okunma').forEach((k, v) => _okunma[k] = (v as num).toInt());
        m('plan').forEach((k, v) => _plan[k] = '$v');
        m('gorev').forEach((k, v) => _gorev[k] = '$v');
        m('ozel')
            .forEach((k, v) => _ozel[k] = Map<String, dynamic>.from(v as Map));
        m('durum').forEach((k, v) {
          final d = HakikatDurumu.values.where((x) => x.name == v);
          if (d.isNotEmpty) _durum[k] = d.first;
        });
        _yaziOlcegi = ((j['yaziOlcegi'] as num?) ?? 1.0).toDouble();
      } catch (e) {
        debugPrint('Hakikat kaydi okunamadi: $e');
      }
    }
    _yuklendi = true;
    notifyListeners();
  }

  void _temizle() {
    for (final c in [_favori, _sonraOku, _silinen]) {
      c.clear();
    }
    for (final c in [
      _tamamlanan,
      _ilerleme,
      _testPuani,
      _okunma,
      _gorev,
      _plan,
      _ozel,
      _durum
    ]) {
      c.clear();
    }
    _sonOkunan.clear();
    _yaziOlcegi = 1.0;
  }

  Future<void> _kaydet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _anahtar,
        jsonEncode({
          'favori': _favori.toList(),
          'sonraOku': _sonraOku.toList(),
          'sonOkunan': _sonOkunan,
          'silinen': _silinen.toList(),
          'tamamlanan': _tamamlanan,
          'ilerleme': _ilerleme,
          'testPuani': _testPuani,
          'okunma': _okunma,
          'plan': _plan,
          'gorev': _gorev,
          'ozel': _ozel,
          'durum': {for (final e in _durum.entries) e.key: e.value.name},
          'yaziOlcegi': _yaziOlcegi,
        }));
    notifyListeners();
  }

  // ───────────── Icerik (yonetici katmani uygulanmis) ─────────────

  bool varliktaMi(String id) => _varlik.any((d) => d.id == id);

  /// Tum kayitlar (taslak/arsiv dahil, silinenler haric).
  List<RisaleDersi> get tumu {
    final l = <RisaleDersi>[];
    for (final d in _varlik) {
      if (_silinen.contains(d.id)) continue;
      final o = _ozel[d.id];
      l.add(o == null ? d : RisaleDersi.fromJson(o));
    }
    for (final e in _ozel.entries) {
      if (!varliktaMi(e.key) && !_silinen.contains(e.key)) {
        l.add(RisaleDersi.fromJson(e.value));
      }
    }
    return l;
  }

  /// Varliktaki dersler varsayilan olarak yayinda; yeni kayitlar taslak.
  HakikatDurumu durum(String id) =>
      _durum[id] ??
      (varliktaMi(id) ? HakikatDurumu.yayinda : HakikatDurumu.taslak);

  List<RisaleDersi> get yayindakiler =>
      tumu.where((d) => durum(d.id) == HakikatDurumu.yayinda).toList();

  RisaleDersi? bul(String id) {
    for (final d in tumu) {
      if (d.id == id) return d;
    }
    return null;
  }

  bool duzenlendiMi(String id) => varliktaMi(id) && _ozel.containsKey(id);

  String yeniId() {
    final say = tumu.length + _silinen.length + 1;
    var i = say;
    String id() => 'hakikat_${i.toString().padLeft(3, '0')}';
    while (bul(id()) != null || _silinen.contains(id())) {
      i++;
    }
    return id();
  }

  Future<void> kaydetDers(RisaleDersi d, {HakikatDurumu? yeniDurum}) async {
    _ozel[d.id] = d.toJson();
    _silinen.remove(d.id);
    if (yeniDurum != null) _durum[d.id] = yeniDurum;
    await _kaydet();
  }

  Future<void> durumDegistir(String id, HakikatDurumu d) async {
    _durum[id] = d;
    if (d != HakikatDurumu.yayinda) {
      _plan.removeWhere((_, v) => v == id);
    }
    await _kaydet();
  }

  /// Varliktaki kayit icin yapilan duzenlemeyi geri alir.
  Future<void> duzenlemeyiGeriAl(String id) async {
    _ozel.remove(id);
    await _kaydet();
  }

  /// Ozel kayit tamamen silinir; varliktaki kayit gizlenir (geri alinabilir).
  Future<void> sil(String id) async {
    if (varliktaMi(id)) {
      _silinen.add(id);
    } else {
      _ozel.remove(id);
      _durum.remove(id);
    }
    _plan.removeWhere((_, v) => v == id);
    await _kaydet();
  }

  // ───────────── Gunun Hakikati ─────────────

  String? planliId(DateTime tarih) =>
      _plan[GunlukPlanServisi.tarihAnahtari(tarih)];

  Future<void> planla(DateTime tarih, String? id) async {
    final a = GunlukPlanServisi.tarihAnahtari(tarih);
    if (id == null) {
      _plan.remove(a);
    } else {
      _plan[a] = id;
    }
    await _kaydet();
  }

  /// Planlanan ve yayindaki kayit; yoksa tarihe bagli sabit secim.
  /// Ayni gun icinde degismez. Icerik yoksa null.
  RisaleDersi? gununHakikati(DateTime tarih) {
    final l = yayindakiler..sort((a, b) => a.id.compareTo(b.id));
    if (l.isEmpty) return null;
    final p = planliId(tarih);
    if (p != null) {
      for (final d in l) {
        if (d.id == p) return d;
      }
    }
    final gun = DateTime.utc(tarih.year, tarih.month, tarih.day)
        .difference(DateTime.utc(2024, 1, 1))
        .inDays;
    return l[gun % l.length];
  }

  /// Bugunden geriye [gun] gunun hakikatleri (arsiv).
  List<(DateTime, RisaleDersi)> arsiv(DateTime bugun, {int gun = 30}) {
    final b = GunlukPlanServisi.gun(bugun);
    return [
      for (var i = 0; i < gun; i++)
        if (gununHakikati(b.subtract(Duration(days: i))) case final d?)
          (b.subtract(Duration(days: i)), d)
    ];
  }

  // ───────────── Okuyucu durumu ─────────────

  bool favoriMi(String id) => _favori.contains(id);
  bool sonraOkuMu(String id) => _sonraOku.contains(id);
  bool tamamlandiMi(String id) => _tamamlanan.containsKey(id);
  double ilerleme(String id) => _ilerleme[id] ?? 0;
  int? testPuani(String id) => _testPuani[id];
  double get yaziOlcegi => _yaziOlcegi;

  List<RisaleDersi> _idlerden(Iterable<String> ids) => [
        for (final id in ids)
          if (bul(id) case final d?)
            if (durum(d.id) == HakikatDurumu.yayinda) d
      ];

  List<RisaleDersi> get favoriler => _idlerden(_favori);
  List<RisaleDersi> get sonraOkunacaklar => _idlerden(_sonraOku);
  List<RisaleDersi> get tamamlananlar => _idlerden(_tamamlanan.keys);
  List<RisaleDersi> get sonOkunanlar => _idlerden(_sonOkunan);

  /// Bu cihazda en cok acilanlar (gercek yerel sayac; sahte veri yok).
  List<RisaleDersi> get enCokOkunanlar {
    final s = _okunma.entries.where((e) => e.value > 1).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return _idlerden(s.map((e) => e.key)).take(5).toList();
  }

  Future<void> favoriDegistir(String id) async {
    if (!_favori.remove(id)) _favori.add(id);
    await _kaydet();
  }

  Future<void> sonraOkuDegistir(String id) async {
    if (!_sonraOku.remove(id)) _sonraOku.add(id);
    await _kaydet();
  }

  Future<void> tamamlandiDegistir(String id, {DateTime? simdi}) async {
    if (_tamamlanan.remove(id) == null) {
      _tamamlanan[id] =
          GunlukPlanServisi.tarihAnahtari(simdi ?? DateTime.now());
      _sonraOku.remove(id);
    }
    await _kaydet();
  }

  bool gorevYapildiMi(String id, {DateTime? simdi}) =>
      _gorev[id] == GunlukPlanServisi.tarihAnahtari(simdi ?? DateTime.now());

  Future<void> gorevDegistir(String id, {DateTime? simdi}) async {
    if (gorevYapildiMi(id, simdi: simdi)) {
      _gorev.remove(id);
    } else {
      _gorev[id] = GunlukPlanServisi.tarihAnahtari(simdi ?? DateTime.now());
    }
    await _kaydet();
  }

  Future<void> acildi(String id) async {
    _sonOkunan
      ..remove(id)
      ..insert(0, id);
    if (_sonOkunan.length > 20) _sonOkunan.removeLast();
    _okunma[id] = (_okunma[id] ?? 0) + 1;
    await _kaydet();
  }

  Future<void> ilerlemeKaydet(String id, double oran) async {
    final o = oran.clamp(0.0, 1.0);
    if (o <= (_ilerleme[id] ?? 0) + 0.04) return; // gereksiz yazma yok
    _ilerleme[id] = o;
    await _kaydet();
  }

  Future<void> testSonucu(String id, int yuzde) async {
    if (yuzde <= (_testPuani[id] ?? -1)) return;
    _testPuani[id] = yuzde;
    await _kaydet();
  }

  Future<void> yaziOlcegiAyarla(double o) async {
    _yaziOlcegi = o.clamp(0.85, 1.5);
    await _kaydet();
  }

  @visibleForTesting
  void testIcinSifirla() {
    _temizle();
    _yuklendi = false;
  }
}
