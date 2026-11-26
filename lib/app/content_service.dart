import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nur_pusulasi/app/gunluk_plan.dart';
import 'package:nur_pusulasi/data/dua_havuzu.dart';
import 'package:nur_pusulasi/data/vecize_havuzu.dart';
import 'package:nur_pusulasi/data/dua_havuzu_2.dart';
import 'package:nur_pusulasi/data/dua_havuzu_3.dart';
import 'package:nur_pusulasi/data/dua_havuzu_4.dart';
import 'package:nur_pusulasi/data/dua_havuzu_5.dart';
import 'package:nur_pusulasi/data/dua_havuzu_6.dart';
import 'package:nur_pusulasi/data/ayet_havuzu.dart';
import 'package:nur_pusulasi/data/ayet_havuzu_2.dart';
import 'package:nur_pusulasi/data/risale_havuzu.dart';
import 'package:nur_pusulasi/data/hadis_havuzu.dart';
import 'package:nur_pusulasi/data/daily_content_365.dart';
import 'package:nur_pusulasi/features/kandil/data/kandil_data.dart';
import 'package:nur_pusulasi/features/mood/data/mood_data.dart';
import 'package:nur_pusulasi/features/family/data/family_data.dart';

/// Icerik yayin durumu
enum ContentStatus { taslak, incelemede, yayinlandi, arsivlendi }

extension ContentStatusX on ContentStatus {
  String get key {
    switch (this) {
      case ContentStatus.taslak:
        return 'taslak';
      case ContentStatus.incelemede:
        return 'incelemede';
      case ContentStatus.yayinlandi:
        return 'yayinlandi';
      case ContentStatus.arsivlendi:
        return 'arsivlendi';
    }
  }

  String get label {
    switch (this) {
      case ContentStatus.taslak:
        return 'Taslak';
      case ContentStatus.incelemede:
        return 'Incelemede';
      case ContentStatus.yayinlandi:
        return 'Yayinlandi';
      case ContentStatus.arsivlendi:
        return 'Arsivlendi';
    }
  }
}

/// Kaynak turu
enum KaynakTuru { elle, diyanet, kuran, hadis, risale, aiDestekli }

extension KaynakTuruX on KaynakTuru {
  String get key {
    switch (this) {
      case KaynakTuru.elle:
        return 'elle';
      case KaynakTuru.diyanet:
        return 'diyanet';
      case KaynakTuru.kuran:
        return 'kuran';
      case KaynakTuru.hadis:
        return 'hadis';
      case KaynakTuru.risale:
        return 'risale';
      case KaynakTuru.aiDestekli:
        return 'ai_destekli';
    }
  }

  String get label {
    switch (this) {
      case KaynakTuru.elle:
        return 'Elle girildi';
      case KaynakTuru.diyanet:
        return 'Diyanet';
      case KaynakTuru.kuran:
        return 'Kuran';
      case KaynakTuru.hadis:
        return 'Hadis';
      case KaynakTuru.risale:
        return 'Risale-i Nur';
      case KaynakTuru.aiDestekli:
        return 'AI destekli (dogrulama gerekli)';
    }
  }
}

/// Tum kartlar icin ortak icerik tipi
enum ContentType {
  kissa,
  dua,
  vecize,
  hadis,
  tefekkur,
  ayet,
  gunluk,
  risale,
  kandil,
  mood,
  cocukDersi
}

extension ContentTypeKey on ContentType {
  String get key {
    switch (this) {
      case ContentType.kissa:
        return 'kissa';
      case ContentType.dua:
        return 'dua';
      case ContentType.vecize:
        return 'vecize';
      case ContentType.hadis:
        return 'hadis';
      case ContentType.tefekkur:
        return 'Tefekkür';
      case ContentType.ayet:
        return 'ayet';
      case ContentType.gunluk:
        return 'gunluk';
      case ContentType.risale:
        return 'risale';
      case ContentType.kandil:
        return 'kandil';
      case ContentType.mood:
        return 'mood';
      case ContentType.cocukDersi:
        return 'cocukDersi';
    }
  }

  String get label {
    switch (this) {
      case ContentType.kissa:
        return 'Kissa';
      case ContentType.dua:
        return 'Dua';
      case ContentType.vecize:
        return 'Vecize';
      case ContentType.hadis:
        return 'Hadis';
      case ContentType.tefekkur:
        return 'Tefekkür';
      case ContentType.ayet:
        return 'Ayet';
      case ContentType.gunluk:
        return 'Gunluk';
      case ContentType.risale:
        return 'Risale';
      case ContentType.kandil:
        return 'Kandil';
      case ContentType.mood:
        return 'Ruh Hali';
      case ContentType.cocukDersi:
        return 'Cocuk Dersi';
    }
  }
}

/// Tek bir icerik ogesi
class ContentItem {
  final String id;
  final ContentType type;
  final String baslik;
  final String icerik; // ana metin
  final String? altIcerik; // meal, anlam vb.
  final String? arapca; // varsa
  final String? kaynak; // Buhari, Muslim...
  final String? kategori;
  final bool custom; // admin tarafindan mi eklendi
  final ContentStatus durum; // taslak / yayinlandi / ...
  final bool dogrulandi; // kaynak dogrulanmis mi
  final String? kaynakURL; // varsa kaynak linki
  final KaynakTuru kaynakTuru;
  final DateTime? guncellenme;
  final Map<String, dynamic>? extra;

  const ContentItem({
    required this.id,
    required this.type,
    required this.baslik,
    required this.icerik,
    this.altIcerik,
    this.arapca,
    this.kaynak,
    this.kategori,
    this.custom = false,
    this.durum = ContentStatus.taslak,
    this.dogrulandi = false,
    this.kaynakURL,
    this.kaynakTuru = KaynakTuru.elle,
    this.guncellenme,
    this.extra,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.key,
        'baslik': baslik,
        'icerik': icerik,
        'altIcerik': altIcerik,
        'arapca': arapca,
        'kaynak': kaynak,
        'kategori': kategori,
        'custom': custom,
        'durum': durum.key,
        'dogrulandi': dogrulandi,
        'kaynakURL': kaynakURL,
        'kaynakTuru': kaynakTuru.key,
        'guncellenme': guncellenme?.toIso8601String(),
        'extra': extra,
      };

  factory ContentItem.fromJson(Map<String, dynamic> j) => ContentItem(
        id: j['id'] ?? '',
        type: ContentType.values.firstWhere(
          (t) => t.key == j['type'],
          orElse: () => ContentType.kissa,
        ),
        baslik: j['baslik'] ?? '',
        icerik: j['icerik'] ?? '',
        altIcerik: j['altIcerik'],
        arapca: j['arapca'],
        kaynak: j['kaynak'],
        kategori: j['kategori'],
        custom: j['custom'] ?? true,
        durum: ContentStatus.values.firstWhere(
          (s) => s.key == (j['durum'] ?? 'yayinlandi'),
          orElse: () => ContentStatus.yayinlandi,
        ),
        dogrulandi: j['dogrulandi'] ?? false,
        kaynakURL: j['kaynakURL'],
        kaynakTuru: KaynakTuru.values.firstWhere(
          (k) => k.key == (j['kaynakTuru'] ?? 'elle'),
          orElse: () => KaynakTuru.elle,
        ),
        extra: j['extra'] is Map
            ? Map<String, dynamic>.from(j['extra'] as Map)
            : null,
        guncellenme: j['guncellenme'] != null
            ? DateTime.tryParse('${j['guncellenme']}')
            : null,
      );
}

/// Tum kartlarin ortak icerik servisi
class ContentService extends ChangeNotifier {
  static final ContentService instance = ContentService._internal();
  ContentService._internal();

  static const _prefsKey = 'nur_pusulasi_content_service_v1';

  final Map<ContentType, List<ContentItem>> _pools = {};
  bool _loaded = false;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    _buildDefaults();
    await _gunlukHavuzlariYukle();
    await _overlayFromPrefs();
    _loaded = true;
    notifyListeners();
  }

  /// Yenile: varliklar ve kalici admin kayitlari bastan okunur.
  Future<void> yenidenYukle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _pools.clear();
    _loaded = false;
    await load();
  }

  /// Hardcoded havuzlardan default ContentItem listeleri olustur
  void _buildDefaults() {
    // KISSA havuzu
    _pools[ContentType.kissa] = <ContentItem>[];

    // DUA havuzu
    _pools[ContentType.dua] = [
      ...duaHavuzu.map((d) => ContentItem(
            id: 'dua_${d.baslik.hashCode}',
            type: ContentType.dua,
            baslik: d.baslik,
            icerik: d.okunusu,
            altIcerik: d.anlami,
            arapca: d.arapca,
            kaynak: d.kaynak,
            kategori: d.kategori,
          )),
      ...duaHavuzu2.map((d) => ContentItem(
            id: 'dua2_${d.baslik.hashCode}',
            type: ContentType.dua,
            baslik: d.baslik,
            icerik: d.okunusu,
            altIcerik: d.anlami,
            arapca: d.arapca,
            kaynak: d.kaynak,
            kategori: d.kategori,
          )),
      ...duaHavuzu3.map((d) => ContentItem(
            id: 'dua3_${d.baslik.hashCode}',
            type: ContentType.dua,
            baslik: d.baslik,
            icerik: d.okunusu,
            altIcerik: d.anlami,
            arapca: d.arapca,
            kaynak: d.kaynak,
            kategori: d.kategori,
          )),
      ...duaHavuzu4.map((d) => ContentItem(
            id: 'dua4_${d.baslik.hashCode}',
            type: ContentType.dua,
            baslik: d.baslik,
            icerik: d.okunusu,
            altIcerik: d.anlami,
            arapca: d.arapca,
            kaynak: d.kaynak,
            kategori: d.kategori,
          )),
      ...duaHavuzu5.map((d) => ContentItem(
            id: 'dua5_${d.baslik.hashCode}',
            type: ContentType.dua,
            baslik: d.baslik,
            icerik: d.okunusu,
            altIcerik: d.anlami,
            arapca: d.arapca,
            kaynak: d.kaynak,
            kategori: d.kategori,
          )),
      ...duaHavuzu6.map((d) => ContentItem(
            id: 'dua6_${d.baslik.hashCode}',
            type: ContentType.dua,
            baslik: d.baslik,
            icerik: d.okunusu,
            altIcerik: d.anlami,
            arapca: d.arapca,
            kaynak: d.kaynak,
            kategori: d.kategori,
          )),
    ];

    _pools[ContentType.vecize] = vecizeHavuzu
        .map((v) => ContentItem(
            // Sabit kimlik: nesne hashCode'u her acilista degisir, favoriler kaybolurdu
            id: 'vecize_${_kararliHash(v.latin)}',
            type: ContentType.vecize,
            baslik: v.kategori,
            icerik: v.latin,
            altIcerik: v.osmanlica,
            kaynak: 'BEDİÜZZAMAN SAİD NURSÎ',
            kategori: v.kategori,
            durum: ContentStatus.yayinlandi))
        .toList();

    // Digerleri bos baslar (admin ekleyebilir)
    // AYET havuzu (Diyanet meali + Arapca)
    _pools[ContentType.ayet] = [...ayetHavuzu, ...ayetHavuzu2]
        .map((a) => ContentItem(
              id: 'ayet_${a.id}',
              type: ContentType.ayet,
              baslik: a.kaynak,
              icerik: a.arapca,
              altIcerik: a.meal,
              kaynak: 'Diyanet Isleri Baskanligi Meali',
              kategori: a.sure,
              arapca: a.arapca,
              dogrulandi: true,
              durum: ContentStatus.yayinlandi,
              kaynakTuru: KaynakTuru.diyanet,
            ))
        .toList();

    // GUNLUK ICERIK havuzu
    final gunlukAll = gunluk365Icerikler;
    _pools[ContentType.gunluk] = List.generate(365, (i) {
      if (i < gunlukAll.length) {
        final g = gunlukAll[i];
        return ContentItem(
          id: 'gunluk_$i',
          type: ContentType.gunluk,
          baslik: g.gunKonu,
          icerik: g.ayet,
          altIcerik: g.hadis,
          kaynak: g.ayetKaynak,
          durum: ContentStatus.yayinlandi,
          extra: {
            'gunKonu': g.gunKonu,
            'kissa': '',
            'kissaKaynak': '',
            'ayet': g.ayet,
            'ayetKaynak': g.ayetKaynak,
            'hadis': g.hadis,
            'hadisKaynak': g.hadisKaynak,
            'vecize': g.vecize,
            'vecizeModern': g.vecizeModern,
            'vecizeKaynak': g.vecizeKaynak,
            'risaleHakikat': g.risaleHakikat,
            'ayetArapca': g.ayetArapca,
            'ayetTefsir': g.ayetTefsir,
            'risaleAlinti': g.risaleAlinti,
            'risaleEser': g.risaleEser,
            'risaleBolum': g.risaleBolum,
            'duaBaslik': g.duaBaslik,
            'duaArapca': g.duaArapca,
            'duaOkunus': g.duaOkunus,
            'duaAnlam': g.duaAnlam,
            'duaKaynak': g.duaKaynak,
            'duaKategori': g.duaKategori,
            'anahtarKelimeler': g.anahtarKelimeler,
          },
        );
      }
      final gun = 'Gün ${i + 1}';
      return ContentItem(
        id: 'gunluk_$i',
        type: ContentType.gunluk,
        baslik: gun,
        icerik: '',
        durum: ContentStatus.taslak,
        extra: {
          'gunKonu': gun,
          'kissa': '',
          'kissaKaynak': '',
          'ayet': '',
          'ayetKaynak': '',
          'hadis': '',
          'hadisKaynak': '',
          'vecize': '',
          'vecizeModern': '',
          'vecizeKaynak': '',
          'risaleHakikat': '',
          'ayetArapca': '',
          'ayetTefsir': '',
          'risaleAlinti': '',
          'risaleEser': '',
          'risaleBolum': '',
          'duaBaslik': '',
          'duaArapca': '',
          'duaOkunus': '',
          'duaAnlam': '',
          'duaKaynak': '',
          'duaKategori': '',
          'anahtarKelimeler': <String>[],
        },
      );
    });

    // RISALE havuzu
    _pools[ContentType.risale] = risaleHavuzu
        .map((r) => ContentItem(
              id: 'risale_${r.baslik.hashCode}',
              type: ContentType.risale,
              baslik: r.baslik,
              icerik: r.metin,
              kaynak: r.kaynak,
              kategori: r.kategori,
              durum: ContentStatus.yayinlandi,
              extra: {'emoji': r.emoji},
            ))
        .toList();

    _pools[ContentType.kandil] = [
      for (var i = 0; i < kandilEvents.length; i++)
        ContentItem(
          id: 'kandil_${i}_${kandilEvents[i].hijriMonth}_${kandilEvents[i].hijriDay}',
          type: ContentType.kandil,
          baslik: kandilEvents[i].ad,
          icerik: kandilEvents[i].aciklama,
          kategori: '${kandilEvents[i].hijriMonth}/${kandilEvents[i].hijriDay}',
          durum: ContentStatus.yayinlandi,
          extra: {
            'emoji': kandilEvents[i].emoji,
            'hijriMonth': kandilEvents[i].hijriMonth,
            'hijriDay': kandilEvents[i].hijriDay,
          },
        ),
    ];

    // MOOD havuzu
    _pools[ContentType.mood] = [
      for (final m in moods)
        ContentItem(
          id: 'mood_${m.id}',
          type: ContentType.mood,
          baslik: m.label,
          icerik: m.description,
          kategori: m.id,
          durum: ContentStatus.yayinlandi,
          extra: {
            'emoji': m.emoji,
            'colorValue': m.colorValue,
            'suggestions': m.suggestions
                .map((s) => {
                      'tip': s.tip,
                      'title': s.title,
                      'text': s.text,
                      'source': s.source,
                    })
                .toList(),
          },
        ),
    ];

    // COCUK DERSI havuzu (mevcut ilerleme id'leri korunur)
    _pools[ContentType.cocukDersi] = [
      for (final l in childLessons)
        ContentItem(
          id: l.id,
          type: ContentType.cocukDersi,
          baslik: l.baslik,
          icerik: l.aciklama,
          durum: ContentStatus.yayinlandi,
          extra: {'emoji': l.emoji},
        ),
    ];

    _pools[ContentType.hadis] = hadisHavuzu
        .map((h) => ContentItem(
              id: 'hadis_${h.baslik.hashCode}',
              type: ContentType.hadis,
              baslik: h.baslik,
              icerik: h.metin,
              arapca: null, // hadislerde yalniz meal gosterilir
              altIcerik: h.kaynakRef,
              kaynak: h.kitap,
              kategori: h.kategori,
              durum: ContentStatus.yayinlandi,
            ))
        .toList();
  }

  /// 365 gunluk, kaynaktan dogrulanmis ayet ve hadis listeleri (gun sirasiyla).
  /// Dosya okunamazsa eski havuz yedek olarak kalir.
  Future<void> _gunlukHavuzlariYukle() async {
    Future<List<Map<String, dynamic>>> oku(String p) async =>
        (jsonDecode(await rootBundle.loadString(p)) as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
    try {
      final ayetler = await oku('assets/content/gunluk_ayetler.json');
      if (ayetler.isNotEmpty) {
        _pools[ContentType.ayet] = ayetler
            .map((a) => ContentItem(
                  id: 'ayet_${a['anahtar']}',
                  type: ContentType.ayet,
                  baslik: a['kaynak'] as String,
                  icerik: a['arapca'] as String,
                  altIcerik: a['meal'] as String,
                  arapca: a['arapca'] as String,
                  kaynak: 'Diyanet İşleri Başkanlığı Meali',
                  kategori: a['tema'] as String,
                  dogrulandi: true,
                  durum: ContentStatus.yayinlandi,
                  kaynakTuru: KaynakTuru.diyanet,
                ))
            .toList();
      }
    } catch (e) {
      debugPrint('gunluk_ayetler: $e');
    }
    try {
      final hadisler = await oku('assets/content/gunluk_hadisler.json');
      if (hadisler.isNotEmpty) {
        _pools[ContentType.hadis] = hadisler
            .map((h) => ContentItem(
                  id: 'hadis_${_kararliHash(h['numara'] as String)}',
                  type: ContentType.hadis,
                  baslik: h['tema'] as String,
                  icerik: h['metin'] as String,
                  arapca: null, // hadislerde yalniz meal gosterilir
                  altIcerik: h['numara'] as String,
                  kaynak: h['kaynak'] as String,
                  kategori: h['tema'] as String,
                  dogrulandi: true,
                  durum: ContentStatus.yayinlandi,
                ))
            .toList();
      }
    } catch (e) {
      debugPrint('gunluk_hadisler: $e');
    }
    try {
      // Kaynagi dogrulanmis dualar once; eski dua kayitlari silinmez, arkada kalir
      final dualar = await oku('assets/content/gunluk_dualar.json');
      if (dualar.isNotEmpty) {
        final dogrulanmis = dualar
            .map((d) => ContentItem(
                  id: 'gdua_${_kararliHash('${d['kaynak']}|${d['anlam']}')}',
                  type: ContentType.dua,
                  baslik: d['baslik'] as String,
                  icerik: (d['okunus'] as String?) ?? '',
                  altIcerik: d['anlam'] as String,
                  arapca: (d['arapca'] as String?) ?? '',
                  kaynak: d['kaynak'] as String,
                  kategori: d['kategori'] as String?,
                  dogrulandi: true,
                  durum: ContentStatus.yayinlandi,
                  extra: {'sihhat': d['sihhat']},
                ))
            .toList();
        _pools[ContentType.dua] = [
          ...dogrulanmis,
          ...?_pools[ContentType.dua],
        ];
      }
    } catch (e) {
      debugPrint('gunluk_dualar: $e');
    }
    try {
      // Osmanlica ve Latince ayni kaynak cumlesinden (kelime kelime); eski
      // sadelestirilmis vecizeler vecize_havuzu.dart'ta korunur.
      final vecizeler = await oku('assets/content/gunluk_vecizeler.json');
      if (vecizeler.isNotEmpty) {
        _pools[ContentType.vecize] = vecizeler
            .map((v) => ContentItem(
                  id: 'vecize_${_kararliHash(v['latin'] as String)}',
                  type: ContentType.vecize,
                  baslik: v['kategori'] as String,
                  icerik: v['latin'] as String,
                  altIcerik: v['osmanlica'] as String,
                  kaynak:
                      'BEDÎÜZZAMAN SAİD NURSÎ · ${(v['eser'] as String).toUpperCase()}',
                  kategori: v['kategori'] as String,
                  dogrulandi: true,
                  kaynakTuru: KaynakTuru.risale,
                  durum: ContentStatus.yayinlandi,
                  extra: {'eser': v['eser'], 'sayfa': v['sayfa']},
                ))
            .toList();
      }
    } catch (e) {
      debugPrint('gunluk_vecizeler: $e');
    }
    try {
      // Asil eserlerden aynen pasajlar once; mevcut risale kayitlari korunur
      final pasajlar = await oku('assets/content/gunluk_risale.json');
      if (pasajlar.isNotEmpty) {
        _pools[ContentType.risale] = [
          ...pasajlar.map((r) => ContentItem(
                id: 'risale_${_kararliHash(r['latin'] as String)}',
                type: ContentType.risale,
                baslik: r['baslik'] as String,
                icerik: r['latin'] as String,
                arapca: r['osmanlica'] as String?,
                kaynak: r['eser'] as String,
                kategori: r['bolum'] as String,
                dogrulandi: true,
                kaynakTuru: KaynakTuru.risale,
                durum: ContentStatus.yayinlandi,
                extra: {'sayfa': r['sayfa']},
              )),
          ...?_pools[ContentType.risale],
        ];
      }
    } catch (e) {
      debugPrint('gunluk_risale: $e');
    }
  }

  /// SharedPreferences'taki override'lari yukle
  Future<void> _overlayFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in map.entries) {
        final type = ContentType.values.firstWhere(
          (t) => t.key == entry.key,
          orElse: () => ContentType.kissa,
        );

        if (type == ContentType.kissa) continue;
        final list = (entry.value as List)
            .map((j) => ContentItem.fromJson(Map<String, dynamic>.from(j)))
            .toList();
        // Sadece custom + silinmis ozel kayitlari degistir
        // (bu ornekte override mantigi: varsa direkt kullan)
        if (list.isNotEmpty) {
          final merged = List<ContentItem>.from(_pools[type] ?? []);
          for (final saved in list) {
            final index = merged.indexWhere((item) => item.id == saved.id);
            if (index >= 0) {
              merged[index] = saved;
            } else {
              merged.add(saved);
            }
          }
          _pools[type] = merged;
        }
      }
    } catch (e) {
      debugPrint('ContentService override parse: $e');
    }
  }

  /// Belirli tip icin gunluk icerik
  ContentItem? getForDay(ContentType type, int dayOfYear) {
    final pool = _pools[type];
    if (pool == null || pool.isEmpty) return null;
    return pool[dayOfYear % pool.length];
  }

  /// Tum havuz
  /// Bes gunluk kart icin ayni gunluk kaydi getirir; eksik gunlerde tekrar yapmaz.
  ContentItem? getDailyRecordForDate(DateTime date) {
    final pool = _pools[ContentType.gunluk];
    if (pool == null || pool.isEmpty) return null;
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final index = dayOfYear % pool.length;
    return pool[index];
  }

  /// Belirli bir içerik havuzundan tarihe göre dolu kayıt seçer.
  ContentItem? getDailyPoolItem(ContentType type, DateTime date) =>
      GunlukPlanServisi.instance.yayindaki(type, date) ??
      otomatikGunlukKayit(type, date);

  /// Admin plani olmadan arsiv sirasinin o gune verdigi kayit.
  bool planliMi(ContentType type, DateTime date) =>
      GunlukPlanServisi.instance.yayindaki(type, date) != null;

  /// Plan degisince kartlar yeniden cizilir.
  void planDegisti() => notifyListeners();

  ContentItem? otomatikGunlukKayit(ContentType type, DateTime date) {
    final pool = _pools[type];
    if (pool == null || pool.isEmpty) return null;
    final doluKayitlar = pool
        .where((item) =>
            item.icerik.trim().isNotEmpty ||
            (item.altIcerik?.trim().isNotEmpty ?? false) ||
            (item.arapca?.trim().isNotEmpty ?? false))
        .toList();
    if (doluKayitlar.isEmpty) return null;
    final gun = date.difference(DateTime(date.year, 1, 1)).inDays;
    return doluKayitlar[gun % doluKayitlar.length];
  }

  List<ContentItem> getPool(ContentType type) =>
      List.unmodifiable(_pools[type] ?? []);

  /// Admin: ekle veya guncelle
  Future<void> upsert(ContentItem item) async {
    final pool = _pools[item.type] ?? [];
    final idx = pool.indexWhere((i) => i.id == item.id);
    if (idx >= 0) {
      pool[idx] = item;
    } else {
      pool.add(item);
    }
    _pools[item.type] = pool;
    await _persist();
    notifyListeners();
  }

  /// Admin: sil
  Future<void> remove(ContentType type, String id) async {
    final pool = _pools[type] ?? [];
    pool.removeWhere((i) => i.id == id);
    _pools[type] = pool;
    await _persist();
    notifyListeners();
  }

  /// Admin: tum override'i sifirla (fabrika ayarlarina don)
  Future<void> reset(ContentType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    _pools.clear();
    _buildDefaults();
    await _persist();
    notifyListeners();
  }

  /// Prefs'a yaz
  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, dynamic>{};
    for (final entry in _pools.entries) {
      map[entry.key.key] = entry.value.map((e) => e.toJson()).toList();
    }
    await prefs.setString(_prefsKey, jsonEncode(map));
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Icon / Color helpers - kartlar bunlari kullanir
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  static const _kategoriIkon = <String, IconData>{
    'Sabah': Icons.wb_sunny_rounded,
    'Aksam': Icons.nights_stay_rounded,
    'Yemek': Icons.restaurant_rounded,
    'Namaz': Icons.mosque_rounded,
    'Kuran': Icons.menu_book_rounded,
    'Ahiret': Icons.local_florist_rounded,
    'Sifa': Icons.healing_rounded,
    'Tevbe': Icons.autorenew_rounded,
    'Hidayet': Icons.light_mode_rounded,
    'Rizik': Icons.agriculture_rounded,
    'Kalp': Icons.favorite_rounded,
    'Aile': Icons.family_restroom_rounded,
    'Karar': Icons.psychology_rounded,
    'Sikinti': Icons.self_improvement_rounded,
    'Koruma': Icons.shield_rounded,
    'Cennet': Icons.park_rounded,
    'Kandil': Icons.auto_awesome_rounded,
    'Cuma': Icons.favorite_rounded,
    'Hac': Icons.landscape_rounded,
    'Bayram': Icons.celebration_rounded,
    'Ilim': Icons.school_rounded,
    'Ihlas': Icons.spa_rounded,
    'Iman': Icons.verified_rounded,
    'Sukur': Icons.volunteer_activism_rounded,
    'Genel': Icons.auto_stories_rounded,
  };

  static const _kategoriRenk = <String, Color>{
    'Sabah': Color(0xFFC9A961),
    'Aksam': Color(0xFF0A1F44),
    'Yemek': Color(0xFF2FAE7F),
    'Namaz': Color(0xFF0A1F44),
    'Kuran': Color(0xFF2FAE7F),
    'Ahiret': Color(0xFF0A1F44),
    'Sifa': Color(0xFF2FAE7F),
    'Tevbe': Color(0xFF2FAE7F),
    'Hidayet': Color(0xFFC9A961),
    'Rizik': Color(0xFFC9A961),
    'Kalp': Color(0xFFC9A961),
    'Aile': Color(0xFF2FAE7F),
    'Karar': Color(0xFF0A1F44),
    'Sikinti': Color(0xFFB71C1C),
    'Koruma': Color(0xFFB71C1C),
    'Cennet': Color(0xFF2FAE7F),
    'Kandil': Color(0xFFC9A961),
    'Cuma': Color(0xFFC9A961),
    'Hac': Color(0xFFC9A961),
    'Bayram': Color(0xFF2FAE7F),
    'Ilim': Color(0xFFC9A961),
    'Ihlas': Color(0xFFC9A961),
    'Iman': Color(0xFF2FAE7F),
    'Sukur': Color(0xFFC9A961),
    'Genel': Color(0xFF0A1F44),
  };

  static const _typeDefaultIcon = <ContentType, IconData>{
    ContentType.kissa: Icons.history_edu_rounded,
    ContentType.dua: Icons.pan_tool_alt_rounded,
    ContentType.vecize: Icons.format_quote_rounded,
    ContentType.hadis: Icons.link_rounded,
    ContentType.gunluk: Icons.calendar_today_rounded,
    ContentType.risale: Icons.auto_stories_rounded,
    ContentType.kandil: Icons.star_rounded,
    ContentType.mood: Icons.self_improvement_rounded,
    ContentType.cocukDersi: Icons.child_care_rounded,
  };

  static const _typeDefaultColor = <ContentType, Color>{
    ContentType.kissa: Color(0xFF0A1F44),
    ContentType.dua: Color(0xFFC9A961),
    ContentType.vecize: Color(0xFF2FAE7F),
    ContentType.hadis: Color(0xFFB71C1C),
    ContentType.gunluk: Color(0xFFC9A961),
    ContentType.risale: Color(0xFFB71C1C),
    ContentType.kandil: Color(0xFFC9A961),
    ContentType.mood: Color(0xFF4A6B8A),
    ContentType.cocukDersi: Color(0xFF2FAE7F),
  };

  IconData iconFor(ContentItem item) {
    final kat = item.kategori;
    if (kat != null && _kategoriIkon.containsKey(kat)) {
      return _kategoriIkon[kat]!;
    }
    return _typeDefaultIcon[item.type] ?? Icons.auto_stories_rounded;
  }

  Color colorFor(ContentItem item) {
    if (item.type == ContentType.mood) {
      final v = item.extra?['colorValue'];
      if (v is int) return Color(v);
    }
    final kat = item.kategori;
    if (kat != null && _kategoriRenk.containsKey(kat)) {
      return _kategoriRenk[kat]!;
    }
    return _typeDefaultColor[item.type] ?? const Color(0xFF0A1F44);
  }
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Export / Import (JSON yedekleme)
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  /// Tum havuzlari JSON string olarak dondurur (yedek).
  String exportAllAsJson() {
    final map = <String, dynamic>{
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'pools': <String, dynamic>{},
    };
    for (final entry in _pools.entries) {
      map['pools'][entry.key.key] = entry.value.map((e) => e.toJson()).toList();
    }
    return jsonEncode(map);
  }

  /// JSON string'i iceri aktarir. mode = 'replace' veya 'merge'.
  /// Donus: eklenen + guncellenen oge sayisi.
  Future<int> importFromJson(String raw, {String mode = 'merge'}) async {
    final parsed = jsonDecode(raw) as Map<String, dynamic>;
    final pools = parsed['pools'] as Map<String, dynamic>?;
    if (pools == null) return 0;

    int changed = 0;
    for (final entry in pools.entries) {
      final type = ContentType.values.firstWhere(
        (t) => t.key == entry.key,
        orElse: () => ContentType.kissa,
      );

      if (type == ContentType.kissa) continue;
      final incoming = (entry.value as List)
          .map((j) => ContentItem.fromJson(Map<String, dynamic>.from(j)))
          .toList();

      if (mode == 'replace' && type != ContentType.gunluk) {
        _pools[type] = incoming;
        changed += incoming.length;
      } else {
        // merge: id'ye gore varsa guncelle, yoksa ekle
        final pool = List<ContentItem>.from(_pools[type] ?? []);
        for (final item in incoming) {
          final idx = pool.indexWhere((i) => i.id == item.id);
          if (idx >= 0) {
            pool[idx] = item;
            changed++;
          } else if (type != ContentType.gunluk) {
            pool.add(item);
            changed++;
          }
        }
        _pools[type] = pool;
      }
    }
    await _persist();
    notifyListeners();
    return changed;
  }

  /// Belirli tur icin export.
  String exportPoolAsJson(ContentType type) {
    final map = <String, dynamic>{
      'version': 1,
      'type': type.key,
      'exportedAt': DateTime.now().toIso8601String(),
      'items': (_pools[type] ?? []).map((e) => e.toJson()).toList(),
    };
    return jsonEncode(map);
  }

  /// Bir turun istatistikleri.
  Map<String, int> stats(ContentType type) {
    final pool = _pools[type] ?? [];
    return {
      'toplam': pool.length,
      'yayinlandi':
          pool.where((i) => i.durum == ContentStatus.yayinlandi).length,
      'taslak': pool.where((i) => i.durum == ContentStatus.taslak).length,
      'incelemede':
          pool.where((i) => i.durum == ContentStatus.incelemede).length,
      'arsivlendi':
          pool.where((i) => i.durum == ContentStatus.arsivlendi).length,
      'dogrulandi': pool.where((i) => i.dogrulandi).length,
      'dogrulanmadi': pool.where((i) => !i.dogrulandi).length,
    };
  }

  /// Gunluk icerik yoksa veya bos ise anlamli bir fallback
  ContentItem fallback(ContentType type) => ContentItem(
        id: 'fallback_${type.key}',
        type: type,
        baslik: type.label,
        icerik: 'Icerik yakinda eklenecek.',
      );
}

/// FNV-1a: platformdan ve calistirmadan bagimsiz, metinden turetilen kimlik.
String _kararliHash(String s) {
  var h = 0x811c9dc5;
  for (final c in s.codeUnits) {
    h ^= c;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h.toRadixString(16);
}
