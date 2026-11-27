// Dua okuma ayarlari (yazi boyutlari, gece modu) ve ezber takibi: ezberlenen
// parcalar, tekrar seviyesi, son ve sonraki tekrar tarihi (aralikli tekrar).
// Eski 'ezber_<id>' kayitlari ilk okumada aktarilir, silinmez.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'gunluk_plan.dart';

class DuaEzberKaydi {
  final Set<int> parcalar;
  final int seviye; // basarili tekrar sayisi
  final String? sonTekrar; // YYYY-MM-DD
  final String? sonrakiTekrar;
  const DuaEzberKaydi(
      {this.parcalar = const {},
      this.seviye = 0,
      this.sonTekrar,
      this.sonrakiTekrar});

  Map<String, dynamic> toJson() => {
        'parcalar': parcalar.toList(),
        'seviye': seviye,
        'sonTekrar': sonTekrar,
        'sonrakiTekrar': sonrakiTekrar,
      };

  factory DuaEzberKaydi.fromJson(Map<String, dynamic> j) => DuaEzberKaydi(
        parcalar: {
          for (final e in j['parcalar'] as List? ?? const []) (e as num).toInt()
        },
        seviye: (j['seviye'] as num?)?.toInt() ?? 0,
        sonTekrar: j['sonTekrar'] as String?,
        sonrakiTekrar: j['sonrakiTekrar'] as String?,
      );
}

class DuaEzberServisi extends ChangeNotifier {
  static final DuaEzberServisi instance = DuaEzberServisi._();
  DuaEzberServisi._();

  static const _anahtar = 'nur_pusulasi_dua_ezber_v1';

  /// Basarili tekrardan sonra beklenecek gunler (seviye sirasiyla).
  static const araliklar = [1, 3, 7, 14, 30];

  /// Bu seviyeye ulasan ve tum parcalari ezberlenen dua tamamlanmis sayilir.
  static const tamamSeviye = 3;

  final Map<String, DuaEzberKaydi> _kayit = {};
  double arapcaBoyut = 28;
  double okunusBoyut = 19;
  double anlamBoyut = 17;
  bool geceModu = false;
  bool _yuklendi = false;

  Future<void> yukle({bool zorla = false}) async {
    if (_yuklendi && !zorla) return;
    final p = await SharedPreferences.getInstance();
    _kayit.clear();
    final ham = p.getString(_anahtar);
    if (ham != null) {
      try {
        final j = Map<String, dynamic>.from(jsonDecode(ham) as Map);
        Map<String, dynamic>.from(j['kayit'] as Map? ?? const {}).forEach(
            (k, v) => _kayit[k] =
                DuaEzberKaydi.fromJson(Map<String, dynamic>.from(v as Map)));
        arapcaBoyut = ((j['arapcaBoyut'] as num?) ?? 28).toDouble();
        okunusBoyut = ((j['okunusBoyut'] as num?) ?? 19).toDouble();
        anlamBoyut = ((j['anlamBoyut'] as num?) ?? 17).toDouble();
        geceModu = j['geceModu'] as bool? ?? false;
      } catch (e) {
        debugPrint('Dua ezber kaydi okunamadi: $e');
      }
    }
    _yuklendi = true;
    notifyListeners();
  }

  Future<void> _kaydet() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
        _anahtar,
        jsonEncode({
          'kayit': {for (final e in _kayit.entries) e.key: e.value.toJson()},
          'arapcaBoyut': arapcaBoyut,
          'okunusBoyut': okunusBoyut,
          'anlamBoyut': anlamBoyut,
          'geceModu': geceModu,
        }));
    notifyListeners();
  }

  /// Eski surumdeki `ezber_<id>` listesini (varsa) bir kez aktarir.
  Future<void> eskiKaydiAktar(String id) async {
    if (_kayit.containsKey(id)) return;
    final p = await SharedPreferences.getInstance();
    final eski = p.getStringList('ezber_$id');
    if (eski == null || eski.isEmpty) return;
    _kayit[id] = DuaEzberKaydi(
        parcalar: {for (final e in eski) int.tryParse(e) ?? -1}..remove(-1));
    await _kaydet();
  }

  DuaEzberKaydi kayit(String id) => _kayit[id] ?? const DuaEzberKaydi();

  Future<void> parcaDegistir(String id, int i) async {
    final k = kayit(id);
    final s = {...k.parcalar};
    if (!s.remove(i)) s.add(i);
    _kayit[id] = DuaEzberKaydi(
        parcalar: s,
        seviye: k.seviye,
        sonTekrar: k.sonTekrar,
        sonrakiTekrar: k.sonrakiTekrar ??
            GunlukPlanServisi.tarihAnahtari(
                DateTime.now().add(const Duration(days: 1))));
    await _kaydet();
  }

  /// Tekrar sonucu: basariliysa seviye artar, degilse basa doner.
  Future<void> tekrarYapildi(String id,
      {required bool basarili, DateTime? simdi}) async {
    final k = kayit(id);
    final bugun = GunlukPlanServisi.gun(simdi ?? DateTime.now());
    final seviye = basarili ? k.seviye + 1 : 0;
    final gun = araliklar[(seviye - 1).clamp(0, araliklar.length - 1)];
    _kayit[id] = DuaEzberKaydi(
      parcalar: k.parcalar,
      seviye: seviye,
      sonTekrar: GunlukPlanServisi.tarihAnahtari(bugun),
      sonrakiTekrar:
          GunlukPlanServisi.tarihAnahtari(bugun.add(Duration(days: gun))),
    );
    await _kaydet();
  }

  bool tekrarZamaniMi(String id, {DateTime? simdi}) {
    final s = kayit(id).sonrakiTekrar;
    if (s == null) return false;
    final bugun = GunlukPlanServisi.tarihAnahtari(simdi ?? DateTime.now());
    return s.compareTo(bugun) <= 0;
  }

  bool tamamlandiMi(String id, int parcaSayisi) {
    final k = kayit(id);
    return parcaSayisi > 0 &&
        k.parcalar.length >= parcaSayisi &&
        k.seviye >= tamamSeviye;
  }

  /// Ezberine baslanmis tum dualar.
  Iterable<String> get baslananlar => _kayit.entries
      .where((e) => e.value.parcalar.isNotEmpty || e.value.seviye > 0)
      .map((e) => e.key);

  Future<void> boyutAyarla(
      {double? arapca, double? okunus, double? anlam}) async {
    if (arapca != null) arapcaBoyut = arapca.clamp(20, 44);
    if (okunus != null) okunusBoyut = okunus.clamp(14, 30);
    if (anlam != null) anlamBoyut = anlam.clamp(13, 28);
    await _kaydet();
  }

  Future<void> geceModuDegistir() async {
    geceModu = !geceModu;
    await _kaydet();
  }

  @visibleForTesting
  void testIcinSifirla() {
    _kayit.clear();
    arapcaBoyut = 28;
    okunusBoyut = 19;
    anlamBoyut = 17;
    geceModu = false;
    _yuklendi = false;
  }
}
