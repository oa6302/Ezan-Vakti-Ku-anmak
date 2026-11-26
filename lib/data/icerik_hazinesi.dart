// Dua Hazinesi, Risale-i Nur dersleri ve Vecize detaylari (standartlar/ klasoru).
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

// ───────────────────────── Ortak ─────────────────────────

/// Ezberlenebilir parca: Arapca/Osmanlica, okunus, anlam.
class EzberParcasi {
  final String arapca;
  final String okunus;
  final String anlam;
  const EzberParcasi(this.arapca, this.okunus, this.anlam);
  factory EzberParcasi.fromJson(Map<String, dynamic> j) => EzberParcasi(
      j['arapca'] as String? ?? '',
      j['okunus'] as String? ?? '',
      j['anlam'] as String? ?? '');
}

/// Kaynagi dogrulanmis kisa dua (ders ve vecize sonlarinda).
class KisaDua {
  final String arapca;
  final String okunus;
  final String anlam;
  final String kaynak;
  const KisaDua(this.arapca, this.okunus, this.anlam, this.kaynak);
  factory KisaDua.fromJson(Map<String, dynamic> j) => KisaDua(
      j['arapca'] as String? ?? '',
      j['okunus'] as String? ?? '',
      j['anlam'] as String? ?? '',
      j['kaynak'] as String? ?? '');
}

class CoktanSecmeli {
  final String soru;
  final List<String> secenekler;
  final int dogru;
  const CoktanSecmeli(this.soru, this.secenekler, this.dogru);
  factory CoktanSecmeli.fromJson(Map<String, dynamic> j) => CoktanSecmeli(
      j['soru'] as String? ?? '',
      List<String>.from(j['secenekler'] as List? ?? const []),
      j['dogru'] as int? ?? 0);
}

class DogruYanlis {
  final String ifade;
  final bool dogru;
  const DogruYanlis(this.ifade, this.dogru);
  factory DogruYanlis.fromJson(Map<String, dynamic> j) =>
      DogruYanlis(j['ifade'] as String? ?? '', j['dogru'] as bool? ?? false);
}

List<T> _liste<T>(dynamic v, T Function(Map<String, dynamic>) f) =>
    (v as List? ?? const [])
        .map((e) => f(Map<String, dynamic>.from(e as Map)))
        .toList();

// ───────────────────────── Dua Hazinesi ─────────────────────────

enum DuaKoleksiyonu {
  kuran('Kur\'an Duaları', '📖', 'Ayetler ve peygamber duaları'),
  peygamber('Peygamber Duaları', '🌹', 'Sünnetten dualar'),
  sahabe('Sahabe Duaları', '🕌', 'Ashabın dua ve niyazları'),
  risale('Risale-i Nur', '🌿', 'Münacatlar ve tefekkür'),
  cevsen('Cevşenü\'l-Kebîr', '🤲', '100 bölüm, anlam ve ezber'),
  meshur('Meşhur Dualar', '🌺', 'Hizbler ve münacatlar'),
  salavat('Salavatlar', '💐', 'Peygamberimize salat ve selam'),
  zikir('Zikir ve Tesbihat', '📿', 'Günlük zikirler'),
  alim('Âlimlerin Münacatları', '📚', 'İslam büyüklerinin niyazları'),
  gunluk('Günlük Hayat Duaları', '☀️', 'Sabah, akşam, yemek, yolculuk'),
  ihtiyac('Hastalık, Sıkıntı ve İhtiyaç', '🩺', 'Şifa ve dert duaları');

  const DuaKoleksiyonu(this.ad, this.emoji, this.aciklama);
  final String ad;
  final String emoji;
  final String aciklama;
}

/// Kaynak siniflandirmasi (Dua Hazinesi standardi, madde 6).
enum DuaSinifi {
  kuranAyeti('Kur\'an ayeti'),
  sahihHadis('Sahih hadis duası'),
  hadis('Hadis duası (derecesi belirtildi)'),
  sahabe('Sahabe duası'),
  alimMunacati('Âlim ve mutasavvıf münacatı'),
  gelenek('Gelenekte meşhur dua'),
  tartismali('Rivayet durumu tartışmalı');

  const DuaSinifi(this.ad);
  final String ad;
}

T _enumAra<T extends Enum>(List<T> v, String? ad, T vars) =>
    v.firstWhere((e) => e.name == ad, orElse: () => vars);

class DuaKaydi {
  final String id;
  final DuaKoleksiyonu koleksiyon;
  final DuaSinifi sinif;
  final String baslik;
  final String arapca;
  final String okunus;
  final String anlam;
  final String kaynak; // Sure/ayet veya hadis kitabi + bolum
  final String hadisNo;
  final String sihhat;
  final String aciklama; // Ne zaman okunur, fazileti (kaynakli)
  final List<EzberParcasi> parcalar;

  const DuaKaydi({
    required this.id,
    required this.koleksiyon,
    required this.sinif,
    required this.baslik,
    required this.arapca,
    required this.okunus,
    required this.anlam,
    required this.kaynak,
    this.hadisNo = '',
    this.sihhat = '',
    this.aciklama = '',
    this.parcalar = const [],
  });

  factory DuaKaydi.fromJson(Map<String, dynamic> j) => DuaKaydi(
        id: j['id'] as String? ?? '',
        koleksiyon: _enumAra(DuaKoleksiyonu.values, j['koleksiyon'] as String?,
            DuaKoleksiyonu.gunluk),
        sinif: _enumAra(
            DuaSinifi.values, j['sinif'] as String?, DuaSinifi.tartismali),
        baslik: j['baslik'] as String? ?? '',
        arapca: j['arapca'] as String? ?? '',
        okunus: j['okunus'] as String? ?? '',
        anlam: j['anlam'] as String? ?? '',
        kaynak: j['kaynak'] as String? ?? '',
        hadisNo: j['hadisNo'] as String? ?? '',
        sihhat: j['sihhat'] as String? ?? '',
        aciklama: j['aciklama'] as String? ?? '',
        parcalar: _liste(j['parcalar'], EzberParcasi.fromJson),
      );
}

// ───────────────────────── Risale-i Nur dersleri ─────────────────────────

enum RisaleKategori {
  iman('İman Hakikatleri', '🌌'),
  kuran('Kur\'an Hakikatleri', '🌱'),
  ahiret('Ahiret ve Ölüm', '🌙'),
  nefis('İnsan ve Nefis', '❤️'),
  kainat('Kâinat ve Tefekkür', '🌍'),
  ibadet('İbadet ve Kulluk', '🕌'),
  risaleler('Risale-i Nur\'dan Hakikatler', '🌿');

  const RisaleKategori(this.ad, this.emoji);
  final String ad;
  final String emoji;
}

class RisaleDersi {
  final String id;
  final RisaleKategori kategori;
  final String baslik;
  final String giris; // ❓ Dusunduren giris
  final String aciklama; // 📖 Hakikatin aciklamasi
  final String risalePerspektifi; // 🔍
  final String kainattanDelil; // 🌌
  final String hikmet; // 💡 Hakikatin penceresi
  final String kendimize; // 🪞
  final String hayat; // 🌱
  final KisaDua dua; // 🤲
  final String ders; // ⭐ Akilda kalacak ders
  final String tefekkurSorusu; // ❓
  final List<String> kavramlar;
  final List<String> kaynaklar; // 📚
  final List<CoktanSecmeli> sinav;
  final List<DogruYanlis> dogruYanlis;

  const RisaleDersi({
    required this.id,
    required this.kategori,
    required this.baslik,
    required this.giris,
    required this.aciklama,
    required this.risalePerspektifi,
    required this.kainattanDelil,
    required this.hikmet,
    required this.kendimize,
    required this.hayat,
    required this.dua,
    required this.ders,
    required this.tefekkurSorusu,
    this.kavramlar = const [],
    this.kaynaklar = const [],
    this.sinav = const [],
    this.dogruYanlis = const [],
  });

  /// Standartta sayilan govde (baslik, dua, sinav ve kaynak haric).
  String get govde => [
        giris,
        aciklama,
        risalePerspektifi,
        kainattanDelil,
        hikmet,
        kendimize,
        hayat,
        ders,
        tefekkurSorusu
      ].join('\n');

  factory RisaleDersi.fromJson(Map<String, dynamic> j) => RisaleDersi(
        id: j['id'] as String? ?? '',
        kategori: _enumAra(RisaleKategori.values, j['kategori'] as String?,
            RisaleKategori.iman),
        baslik: j['baslik'] as String? ?? '',
        giris: j['giris'] as String? ?? '',
        aciklama: j['aciklama'] as String? ?? '',
        risalePerspektifi: j['risalePerspektifi'] as String? ?? '',
        kainattanDelil: j['kainattanDelil'] as String? ?? '',
        hikmet: j['hikmet'] as String? ?? '',
        kendimize: j['kendimize'] as String? ?? '',
        hayat: j['hayat'] as String? ?? '',
        dua:
            KisaDua.fromJson(Map<String, dynamic>.from(j['dua'] as Map? ?? {})),
        ders: j['ders'] as String? ?? '',
        tefekkurSorusu: j['tefekkurSorusu'] as String? ?? '',
        kavramlar: List<String>.from(j['kavramlar'] as List? ?? const []),
        kaynaklar: List<String>.from(j['kaynaklar'] as List? ?? const []),
        sinav: _liste(j['sinav'], CoktanSecmeli.fromJson),
        dogruYanlis: _liste(j['dogruYanlis'], DogruYanlis.fromJson),
      );
}

// ───────────────────────── Vecize detaylari ─────────────────────────

/// Mevcut vecize kartina (vecize_havuzu.dart) eklenen detay. Vecizenin kendisi
/// (Osmanlica + Latin) degismez; eslesme Latin metinle yapilir.
class VecizeDetayi {
  final String latin; // vecize_havuzu'ndaki Latin metinle birebir ayni
  final String kaynakEser; // Eser, bolum (sayfa uydurulmaz)
  final String hakikat;
  final String risalePerspektifi;
  final String hayattanOrnekler;
  final String kainattanDeliller;
  final String imaniKazanim;
  final List<String> muhasebe;
  final List<String> tatbik;
  final KisaDua dua;
  final String temelDers;
  final List<CoktanSecmeli> degerlendirme;

  const VecizeDetayi({
    required this.latin,
    required this.kaynakEser,
    required this.hakikat,
    required this.risalePerspektifi,
    required this.hayattanOrnekler,
    required this.kainattanDeliller,
    required this.imaniKazanim,
    required this.muhasebe,
    required this.tatbik,
    required this.dua,
    required this.temelDers,
    this.degerlendirme = const [],
  });

  String get govde => [
        hakikat,
        risalePerspektifi,
        hayattanOrnekler,
        kainattanDeliller,
        imaniKazanim,
        ...muhasebe,
        ...tatbik,
        temelDers
      ].join('\n');

  factory VecizeDetayi.fromJson(Map<String, dynamic> j) => VecizeDetayi(
        latin: j['latin'] as String? ?? '',
        kaynakEser: j['kaynakEser'] as String? ?? '',
        hakikat: j['hakikat'] as String? ?? '',
        risalePerspektifi: j['risalePerspektifi'] as String? ?? '',
        hayattanOrnekler: j['hayattanOrnekler'] as String? ?? '',
        kainattanDeliller: j['kainattanDeliller'] as String? ?? '',
        imaniKazanim: j['imaniKazanim'] as String? ?? '',
        muhasebe: List<String>.from(j['muhasebe'] as List? ?? const []),
        tatbik: List<String>.from(j['tatbik'] as List? ?? const []),
        dua:
            KisaDua.fromJson(Map<String, dynamic>.from(j['dua'] as Map? ?? {})),
        temelDers: j['temelDers'] as String? ?? '',
        degerlendirme: _liste(j['degerlendirme'], CoktanSecmeli.fromJson),
      );
}

/// Osmanlica-Latin kelime uyumu (Vecize standardi, madde 3 ve 10).
/// Latin metin Osmanlicanin harf aktarimi olmali; sadelestirme tespit edilirse
/// uyumsuz kelime ciftleri doner. Sezgiseldir: kelime sayisi + ilk harf eslesmesi.
List<String> osmanlicaLatinUyumsuzluklari(String osmanlica, String latin) {
  final temizO = osmanlica.replaceAll(RegExp(r'[«»"“”!?.,;:،؛؟()\-]'), ' ');
  final o = temizO.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  final temizL = latin
      .toLowerCase()
      .replaceAll(RegExp(r'[«»"“”!?.,;:()]'), ' ')
      .replaceAll('’', "'");
  // Izafet ekleri (-i, -ı, -u, -ü, -yi) Osmanlicada ayri yazilmaz
  final l = temizL
      .split(RegExp(r'[\s\-]+'))
      .where(
          (w) => w.isNotEmpty && !{'i', 'ı', 'u', 'ü', 'yi', 'yı'}.contains(w))
      .toList();
  final sorunlar = <String>[];
  if (o.length != l.length) {
    sorunlar.add('kelime sayısı: Osmanlıca ${o.length}, Latin ${l.length}');
  }
  const harf = {
    'ا': 'aeıioöuüâîû',
    'آ': 'aâ',
    'أ': 'aeıioöuüâîû',
    'إ': 'aeıioöuüâîû',
    'ع': 'aeıioöuüâîû',
    'ب': 'bp',
    'پ': 'p',
    'ت': 'td',
    'ث': 's',
    'ج': 'c',
    'چ': 'ç',
    'ح': 'h',
    'خ': 'h',
    'د': 'dt',
    'ذ': 'z',
    'ر': 'r',
    'ز': 'z',
    'ژ': 'j',
    'س': 's',
    'ش': 'ş',
    'ص': 's',
    'ض': 'zd',
    'ط': 'td',
    'ظ': 'z',
    'غ': 'gğ',
    'ف': 'f',
    'ق': 'k',
    'ك': 'kgnğ',
    'ک': 'kgnğ',
    'گ': 'gğ',
    'ڭ': 'n',
    'ل': 'l',
    'م': 'm',
    'ن': 'n',
    'و': 'voöuüû',
    'ه': 'haeıâ',
    'ی': 'yiıeaöî',
    'ي': 'yiıea',
  };
  for (var i = 0; i < o.length && i < l.length; i++) {
    final ilk = o[i].characters.first;
    final beklenen = harf[ilk];
    if (beklenen == null) continue;
    final latinIlk = l[i].characters.first;
    if (!beklenen.contains(latinIlk)) sorunlar.add('${o[i]} ≠ ${l[i]}');
  }
  return sorunlar;
}

extension on String {
  Iterable<String> get characters => runes.map(String.fromCharCode);
}

// ───────────────────────── Yukleme ─────────────────────────

const duaHazinesiVarligi = 'assets/content/dua_hazinesi.json';
const risaleDersleriVarligi = 'assets/content/risale_dersleri.json';
const vecizeDetaylariVarligi = 'assets/content/vecize_detaylari.json';

final List<DuaKaydi> duaHazinesi = [];
final List<RisaleDersi> risaleDersleri = [];
final Map<String, VecizeDetayi> vecizeDetaylari = {};

Future<void> icerikHazinesiniYukle() async {
  Future<List> oku(String p) async =>
      jsonDecode(await rootBundle.loadString(p)) as List;
  Map<String, dynamic> m(e) => Map<String, dynamic>.from(e as Map);
  duaHazinesi
    ..clear()
    ..addAll(
        (await oku(duaHazinesiVarligi)).map((e) => DuaKaydi.fromJson(m(e))));
  risaleDersleri
    ..clear()
    ..addAll((await oku(risaleDersleriVarligi))
        .map((e) => RisaleDersi.fromJson(m(e))));
  vecizeDetaylari
    ..clear()
    ..addEntries((await oku(vecizeDetaylariVarligi)).map((e) {
      final d = VecizeDetayi.fromJson(m(e));
      return MapEntry(d.latin, d);
    }));
}
