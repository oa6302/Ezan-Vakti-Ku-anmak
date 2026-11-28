// Risale-i Nur / Hakikat bolumunun veri katmani: konular, kulliyat ve
// dogrulanmis Risale metinleri (gunluk_risale + gunluk_vecizeler). Metinler
// risale.online'dan aynen alinmistir; burada yalniz siniflandirilir.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'icerik_hazinesi.dart';

/// Hakikat konulari. Gorunen ad l10n'dadir (hakikat_metinleri.dart).
enum HakikatKonusu {
  iman(Icons.wb_twilight_rounded, r'îmân|iman'),
  tevhid(Icons.all_inclusive_rounded, r'tevhîd|vahdet|vâhid|ehad|birlik'),
  esma(Icons.auto_awesome_rounded, r'esmâ|ism-i|isim|isimler'),
  kuran(Icons.menu_book_rounded, r'kur’ân|kur.an|furkân'),
  nubuvvet(Icons.brightness_7_rounded,
      r'resûl|nübüvvet|peygamber|risâlet|ahmediye|muhammed'),
  ahiret(Icons.nights_stay_rounded,
      r'âhiret|haşir|haşr|cennet|cehennem|kabir|kabr|mevt|ölüm|ebed'),
  kader(Icons.balance_rounded, r'kader|kazâ|cüz’-i ihtiyârî|irâde'),
  ruhKalpNefis(Icons.favorite_rounded, r'rûh|kalb|nefs|vicdân|latîfe'),
  insanKainat(Icons.public_rounded, r'insan|kâinât|âlem'),
  ibadet(Icons.mosque_rounded, r'namaz|ibâdet|ubûdiyet|duâ|zikr|oruc'),
  sukurSabir(Icons.volunteer_activism_rounded,
      r'şükr|şükür|sabr|sabır|tevekkül|kanâat'),
  ihlasUhuvvet(Icons.handshake_rounded, r'ihlâs|uhuvvet|muhabbet|kardeş'),
  genclikAhlak(Icons.emoji_people_rounded, r'gençlik|genç|ahlâk|edeb|helâl'),
  musibet(Icons.healing_rounded, r'musîbet|hastalık|elem|belâ|ihtiyârlık'),
  tabiat(Icons.eco_rounded, r'tabiat|bahar|ağaç|çiçek|nebât|hayvan|zerre');

  const HakikatKonusu(this.ikon, this.desen);
  final IconData ikon;
  final String desen;

  RegExp get regex => RegExp(desen, caseSensitive: false);

  static HakikatKonusu? ara(String ad) {
    for (final k in values) {
      if (k.name == ad) return k;
    }
    return null;
  }
}

/// Eski kategoriden konu (kayitta `konular` yoksa).
HakikatKonusu _kategoridenKonu(RisaleKategori k) => switch (k) {
      RisaleKategori.iman => HakikatKonusu.iman,
      RisaleKategori.kuran => HakikatKonusu.kuran,
      RisaleKategori.ahiret => HakikatKonusu.ahiret,
      RisaleKategori.nefis => HakikatKonusu.ruhKalpNefis,
      RisaleKategori.kainat => HakikatKonusu.insanKainat,
      RisaleKategori.ibadet => HakikatKonusu.ibadet,
      RisaleKategori.risaleler => HakikatKonusu.iman,
    };

extension RisaleDersiKonu on RisaleDersi {
  List<HakikatKonusu> get hakikatKonulari {
    final l = konular.map(HakikatKonusu.ara).whereType<HakikatKonusu>();
    return l.isEmpty ? [_kategoridenKonu(kategori)] : l.toList();
  }

  /// Kaynaklardaki Risale-i Nur eserleri (sayfa uydurulmaz).
  List<String> get risaleKaynaklari => [
        for (final k in kaynaklar)
          if (k.contains('Said Nursî')) k.split('Said Nursî, ').last
      ];
}

/// Dogrulanmis Risale-i Nur metni (pasaj veya vecize).
class RisaleMetni {
  final String latin;
  final String osmanlica;
  final String eser;
  final String bolum;
  final bool vecize;
  const RisaleMetni(
      {required this.latin,
      required this.osmanlica,
      required this.eser,
      required this.bolum,
      required this.vecize});

  factory RisaleMetni.fromJson(Map<String, dynamic> j, {bool vecize = false}) =>
      RisaleMetni(
        latin: j['latin'] as String? ?? '',
        osmanlica: j['osmanlica'] as String? ?? '',
        eser: j['eser'] as String? ?? '',
        bolum: j['bolum'] as String? ?? '',
        vecize: vecize,
      );

  String get kaynak => bolum.isEmpty ? eser : '$eser · $bolum';
}

class KulliyatEseri {
  final String id;
  final String ad;
  final bool risale; // eser icindeki bir risale mi
  final String konum;
  final String tanitim;
  final String anaKonu;
  final List<String> meseleler;
  final List<HakikatKonusu> konular;
  final String eser; // risale metinlerindeki eser adi
  final String bolum; // bolum on eki, '|' ile coklu (bos = tum eser)
  final List<String> anahtarlar; // ders kaynaklarinda aranir

  const KulliyatEseri({
    required this.id,
    required this.ad,
    required this.risale,
    required this.konum,
    required this.tanitim,
    required this.anaKonu,
    required this.meseleler,
    required this.konular,
    required this.eser,
    required this.bolum,
    required this.anahtarlar,
  });

  factory KulliyatEseri.fromJson(Map<String, dynamic> j) => KulliyatEseri(
        id: j['id'] as String? ?? '',
        ad: j['ad'] as String? ?? '',
        risale: j['tur'] == 'risale',
        konum: j['konum'] as String? ?? '',
        tanitim: j['tanitim'] as String? ?? '',
        anaKonu: j['anaKonu'] as String? ?? '',
        meseleler: List<String>.from(j['meseleler'] as List? ?? const []),
        konular: [
          for (final k in j['konular'] as List? ?? const [])
            if (HakikatKonusu.ara('$k') != null) HakikatKonusu.ara('$k')!
        ],
        eser: j['eser'] as String? ?? '',
        bolum: j['bolum'] as String? ?? '',
        anahtarlar: List<String>.from(j['anahtarlar'] as List? ?? const []),
      );

  /// [bolum] '|' ile ayrilmis birden fazla on ek olabilir.
  bool metniKapsar(RisaleMetni m) =>
      m.eser.startsWith(eser) &&
      (bolum.isEmpty || bolum.split('|').any(m.bolum.startsWith));

  bool dersiKapsar(RisaleDersi d) => d.kaynaklar.any((k) =>
      k.contains('Said Nursî') &&
      anahtarlar.any((a) => k.toLowerCase().contains(a.toLowerCase())));
}

const risaleKulliyatVarligi = 'assets/content/risale_kulliyat.json';
const _risaleMetinVarligi = 'assets/content/gunluk_risale.json';
const _vecizeVarligi = 'assets/content/gunluk_vecizeler.json';

final List<KulliyatEseri> risaleKulliyati = [];
final List<RisaleMetni> risaleMetinleri = [];

/// Yerel varliklardan okur (internet gerekmez). Tekrar cagrilinca yeniden okumaz.
Future<void> hakikatVerisiniYukle({bool zorla = false}) async {
  if (risaleKulliyati.isNotEmpty && !zorla) return;
  Future<List> oku(String p) async =>
      jsonDecode(await rootBundle.loadString(p)) as List;
  Map<String, dynamic> m(e) => Map<String, dynamic>.from(e as Map);
  final kulliyat = (await oku(risaleKulliyatVarligi))
      .map((e) => KulliyatEseri.fromJson(m(e)));
  final pasaj =
      (await oku(_risaleMetinVarligi)).map((e) => RisaleMetni.fromJson(m(e)));
  final vecize = (await oku(_vecizeVarligi))
      .map((e) => RisaleMetni.fromJson(m(e), vecize: true));
  risaleKulliyati
    ..clear()
    ..addAll(kulliyat);
  risaleMetinleri
    ..clear()
    ..addAll(pasaj)
    ..addAll(vecize);
}

/// Bir konuyla ilgili dogrulanmis metinler (anahtar kelime eslesmesi).
List<RisaleMetni> konuMetinleri(HakikatKonusu k, {int sinir = 12}) =>
    risaleMetinleri
        .where((m) => k.regex.hasMatch(m.latin))
        .take(sinir)
        .toList();

String _sade(String s) => s
    .toLowerCase()
    .replaceAll(RegExp('[âáà]'), 'a')
    .replaceAll(RegExp('[îí]'), 'i')
    .replaceAll(RegExp('[ûú]'), 'u')
    .replaceAll(RegExp('[‘’\'`]'), '')
    .replaceAll('ā', 'a')
    .replaceAll('İ', 'i')
    .replaceAll('I', 'ı');

/// Arama: Turkce buyuk/kucuk harf ve sapkalari yok sayar.
bool aramaEslesir(String metin, String sorgu) {
  final s = _sade(sorgu.trim());
  if (s.isEmpty) return true;
  final m = _sade(metin);
  return s.split(RegExp(r'\s+')).every(m.contains);
}
