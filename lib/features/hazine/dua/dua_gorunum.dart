// Dua okuma ekraninin ortak modeli: Dua Hazinesi kaydi (DuaKaydi) ve gunluk
// dua (ContentItem) ayni ekranda gosterilir. Yalniz mevcut alanlar kullanilir;
// olmayan bolum (hikmet, ne zaman okunur) gosterilmez, uydurulmaz.
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';

class DuaGorunum {
  final String id;
  final String baslik;
  final String kategori;
  final String arapca;
  final String okunus;
  final String anlam;
  final String kaynak;
  final String sinif;
  final String numara;
  final String sihhat;
  final String aciklama;
  final String hikmet;
  final String neZaman;
  final List<EzberParcasi> parcalar;
  final ContentItem favori;

  const DuaGorunum({
    required this.id,
    required this.baslik,
    required this.kategori,
    required this.arapca,
    required this.okunus,
    required this.anlam,
    required this.kaynak,
    this.sinif = '',
    this.numara = '',
    this.sihhat = '',
    this.aciklama = '',
    this.hikmet = '',
    this.neZaman = '',
    this.parcalar = const [],
    required this.favori,
  });

  factory DuaGorunum.kayittan(DuaKaydi d) => DuaGorunum(
        id: d.id,
        baslik: d.baslik,
        kategori: d.koleksiyon.ad,
        arapca: d.arapca,
        okunus: d.okunus,
        anlam: d.anlam,
        kaynak: d.kaynak,
        sinif: d.sinif.ad,
        numara: d.hadisNo,
        sihhat: d.sihhat,
        aciklama: d.aciklama,
        parcalar: d.parcalar,
        favori: ContentItem(
          id: 'dua_hz_${d.id}',
          type: ContentType.dua,
          baslik: d.baslik,
          icerik: d.okunus.isNotEmpty ? d.okunus : d.anlam,
          altIcerik: d.anlam,
          arapca: d.arapca,
          kaynak: d.kaynak,
          kategori: d.koleksiyon.ad,
          durum: ContentStatus.yayinlandi,
        ),
      );

  /// Gunluk dua: Kur'an dualarinda Arapca + okunus, hadis dualarinda yalniz meal.
  factory DuaGorunum.icerikten(ContentItem c) {
    final e = c.extra ?? const {};
    String al(String k, String? v) => (e[k]?.toString() ?? v ?? '').trim();
    final anlam = al('duaAnlam', c.altIcerik);
    var okunus = al('duaOkunus', c.icerik);
    if (okunus == anlam) okunus = '';
    return DuaGorunum(
      id: c.id,
      baslik: al('duaBaslik', c.baslik),
      kategori: al('duaKategori', c.kategori),
      arapca: al('duaArapca', c.arapca),
      okunus: okunus,
      anlam: anlam.isEmpty ? c.icerik : anlam,
      kaynak: al('duaKaynak', c.kaynak),
      sihhat: '${e['sihhat'] ?? ''}',
      aciklama: '${e['aciklama'] ?? ''}',
      favori: c,
    );
  }

  /// Panoya ve metin paylasimina giden tam metin.
  String get duzMetin => [
        baslik,
        if (arapca.isNotEmpty) arapca,
        if (okunus.isNotEmpty) okunus,
        if (anlam.isNotEmpty) anlam,
        if (kaynak.isNotEmpty) '— $kaynak',
      ].join('\n\n');
}

/// Ezber parcalari: kayittaki parcalar; yoksa Arapca (4 kelime) veya anlam
/// (cumle/virgul) parcalari. Metin degistirilmez, yalniz bolunur.
List<EzberParcasi> ezberParcalari(DuaGorunum d) {
  if (d.parcalar.isNotEmpty) return d.parcalar;
  List<String> grupla(List<String> kelime, int n) => [
        for (var i = 0; i < kelime.length; i += n)
          kelime.sublist(i, (i + n).clamp(0, kelime.length)).join(' ')
      ];
  if (d.arapca.trim().isNotEmpty) {
    final k = d.arapca.trim().split(RegExp(r'\s+'));
    return [for (final p in grupla(k, 4)) EzberParcasi(p, '', '')];
  }
  final cumle = d.anlam
      .split(RegExp(r'(?<=[.!?,;])\s+'))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
  return [for (final c in cumle) EzberParcasi('', '', c)];
}
