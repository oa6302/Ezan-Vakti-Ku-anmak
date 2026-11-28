// Premium dua okuma ekrani: butun ana metinler ortali (Arapca RTL), sabit
// sira (baslik > Arapca > okunus > anlam > kaynak > aciklama > hikmet >
// ne zaman > ezber > ilgili dualar), metin bazli yazi boyutu, gizle/goster,
// kopyala, gorsel/metin paylasim, favori ve gece modu.
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nur_pusulasi/app/app_settings.dart';
import 'package:nur_pusulasi/app/dua_ezber_servisi.dart';
import 'package:nur_pusulasi/app/favorites_service.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'dua_ezber_page.dart';
import 'dua_gorunum.dart';

/// Gunduz ve gece paleti (lacivert, beyaz, kirik beyaz, altin).
class DuaPalet {
  final Color zemin, kart, kenar, metin, ikincil, altin, lacivert;
  const DuaPalet._(this.zemin, this.kart, this.kenar, this.metin, this.ikincil,
      this.altin, this.lacivert);
  static const gunduz = DuaPalet._(
      Color(0xFFFAF7F0),
      Colors.white,
      Color(0xFFE8E1D3),
      Color(0xFF0A1F44),
      Color(0xFF5B6475),
      Color(0xFFB08A3E),
      Color(0xFF0A1F44));
  static const gece = DuaPalet._(
      Color(0xFF0B1630),
      Color(0xFF13234A),
      Color(0xFF24365E),
      Color(0xFFEDE6D6),
      Color(0xFFAFB6C6),
      Color(0xFFD8BC7A),
      Color(0xFF0A1F44));
}

String arapcaYaziTipi() =>
    AppSettings.instance.fontStyle.value == 'rika' ? 'Rika' : 'Matbu';

class DuaOkumaPage extends StatefulWidget {
  final DuaGorunum dua;

  /// Onceki/sonraki ve ilgili dualar icin ayni listedeki dualar.
  final List<DuaGorunum> liste;
  const DuaOkumaPage({super.key, required this.dua, this.liste = const []});

  @override
  State<DuaOkumaPage> createState() => _DuaOkumaPageState();
}

class _DuaOkumaPageState extends State<DuaOkumaPage> {
  final _gizli = <String>{}; // 'ar' | 'ok' | 'an'
  bool _paylasiliyor = false;
  DuaEzberServisi get _ez => DuaEzberServisi.instance;

  @override
  void initState() {
    super.initState();
    _ez.yukle().then((_) => _ez.eskiKaydiAktar(widget.dua.id));
  }

  int get _sira => widget.liste.indexWhere((d) => d.id == widget.dua.id);

  void _git(DuaGorunum d) => Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
          builder: (_) => DuaOkumaPage(dua: d, liste: widget.liste)));

  void _bildir(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _kopyala(AppLocalizations t) async {
    await Clipboard.setData(ClipboardData(text: widget.dua.duzMetin));
    _bildir(t.dkKopyalandi);
  }

  Future<void> _favori(AppLocalizations t) async {
    final eklendi = await FavoritesService.instance.toggle(widget.dua.favori);
    _bildir(eklendi ? t.dkKaydedildi : t.dkKaydiKaldir);
  }

  Future<void> _paylas(AppLocalizations t) async {
    final secim = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
              leading: const Icon(Icons.image_rounded),
              title: Text(t.dkGorselPaylas),
              onTap: () => Navigator.pop(ctx, true)),
          ListTile(
              leading: const Icon(Icons.notes_rounded),
              title: Text(t.dkMetinPaylas),
              onTap: () => Navigator.pop(ctx, false)),
        ]),
      ),
    );
    if (secim == null || !mounted) return;
    final kart = InheritedTheme.captureAll(
        context,
        MediaQuery(
          data: const MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Material(
                color: Colors.white,
                child: DuaPaylasimKarti(
                    dua: widget.dua,
                    kaynakEtiketi: t.dkKaynak,
                    uygulamaAdi: t.appTitle)),
          ),
        ));
    try {
      if (!secim) {
        await SharePlus.instance.share(ShareParams(text: widget.dua.duzMetin));
        return;
      }
      setState(() => _paylasiliyor = true);
      _bildir(t.dkGorselHazirlaniyor);
      final png = await ScreenshotController().captureFromLongWidget(
        kart,
        pixelRatio: 2.5,
        constraints: const BoxConstraints(maxWidth: 440, minWidth: 440),
        delay: const Duration(milliseconds: 120),
      );
      await SharePlus.instance.share(ShareParams(
        files: [
          XFile.fromData(png,
              mimeType: 'image/png',
              name: 'dua_${DateTime.now().millisecondsSinceEpoch}.png')
        ],
        text: kIsWeb ? null : widget.dua.baslik,
      ));
    } catch (e) {
      debugPrint('Dua paylasimi: $e');
      _bildir(t.dkPaylasimHata);
    } finally {
      if (mounted) setState(() => _paylasiliyor = false);
    }
  }

  Future<void> _ayarlar(AppLocalizations t) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => ListenableBuilder(
          listenable: _ez,
          builder: (context, _) {
            Widget kaydirici(String ad, double v, double min, double max,
                    void Function(double) f) =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$ad · ${v.round()}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Slider(
                      value: v,
                      min: min,
                      max: max,
                      divisions: (max - min).round(),
                      onChanged: f),
                ]);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(t.dkOkumaAyarlari,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  kaydirici(t.dkBoyutArapca, _ez.arapcaBoyut, 20, 44,
                      (v) => _ez.boyutAyarla(arapca: v)),
                  kaydirici(t.dkBoyutOkunus, _ez.okunusBoyut, 14, 30,
                      (v) => _ez.boyutAyarla(okunus: v)),
                  kaydirici(t.dkBoyutAnlam, _ez.anlamBoyut, 13, 28,
                      (v) => _ez.boyutAyarla(anlam: v)),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _ez.geceModu,
                    onChanged: (_) => _ez.geceModuDegistir(),
                    title: Text(t.dkGeceModu),
                    secondary: const Icon(Icons.dark_mode_rounded),
                  ),
                ]),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([_ez, FavoritesService.instance]),
      builder: (context, _) {
        final p = _ez.geceModu ? DuaPalet.gece : DuaPalet.gunduz;
        final d = widget.dua;
        final fav = FavoritesService.instance.isFavorite(d.favori.id);
        return Scaffold(
          backgroundColor: p.zemin,
          appBar: AppBar(
            backgroundColor: p.zemin,
            foregroundColor: p.metin,
            surfaceTintColor: Colors.transparent,
            title: Text(d.kategori.isEmpty ? t.dkKutuphane : d.kategori,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: p.metin, fontSize: 15)),
            actions: [
              IconButton(
                tooltip: t.dkGeceModu,
                icon: Icon(_ez.geceModu
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded),
                onPressed: _ez.geceModuDegistir,
              ),
              IconButton(
                tooltip: t.dkOkumaAyarlari,
                icon: const Icon(Icons.format_size_rounded),
                onPressed: () => _ayarlar(t),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _icerik(t, p, d, fav)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _icerik(AppLocalizations t, DuaPalet p, DuaGorunum d, bool fav) {
    final etiket = TextStyle(
        color: p.altin,
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4);
    Widget bolumEtiketi(String s, {String? gizKod}) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Text(s, textAlign: TextAlign.center, style: etiket)),
            if (gizKod != null)
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: _gizli.contains(gizKod) ? t.dkGoster : t.dkGizle,
                icon: Icon(
                    _gizli.contains(gizKod)
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    size: 18,
                    color: p.ikincil),
                onPressed: () => setState(() => _gizli.contains(gizKod)
                    ? _gizli.remove(gizKod)
                    : _gizli.add(gizKod)),
              ),
          ],
        );
    Widget gizlenebilir(String kod, Widget cocuk) => _gizli.contains(kod)
        ? InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _gizli.remove(kod)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: p.kenar)),
              child: Text(t.dkGizliMetin,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: p.ikincil, fontSize: 13)),
            ),
          )
        : cocuk;
    Widget ayirici() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(children: [
            Expanded(child: Divider(color: p.kenar, height: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.auto_awesome, size: 12, color: p.altin),
            ),
            Expanded(child: Divider(color: p.kenar, height: 1)),
          ]),
        );
    Widget kart(List<Widget> c) => Container(
          margin: const EdgeInsets.only(top: 14),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          decoration: BoxDecoration(
            color: p.kart,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: p.kenar),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14142747),
                  blurRadius: 18,
                  offset: Offset(0, 6))
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, children: c),
          ),
        );
    Widget ortaMetin(String s, {double boyut = 15, FontStyle? stil}) => Text(s,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: p.metin, fontSize: boyut, height: 1.65, fontStyle: stil));
    Widget yardimci(String baslik, String metin) => metin.trim().isEmpty
        ? const SizedBox.shrink()
        : kart([
            Text(baslik, textAlign: TextAlign.center, style: etiket),
            const SizedBox(height: 10),
            ortaMetin(metin),
          ]);

    final parcaSayisi = ezberParcalari(d).length;
    final ek = _ez.kayit(d.id);
    final sira = _sira;
    final ilgili = widget.liste
        .where((x) => x.id != d.id && x.kategori == d.kategori)
        .take(4)
        .toList();

    return [
      Text(t.dkKutuphane, textAlign: TextAlign.center, style: etiket),
      const SizedBox(height: 8),
      Text(d.baslik,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: p.metin,
              fontSize: 26,
              height: 1.25,
              fontWeight: FontWeight.w900)),
      if (d.kategori.isNotEmpty) ...[
        const SizedBox(height: 6),
        Text(d.kategori.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: p.ikincil, fontSize: 11.5, letterSpacing: 1.2)),
      ],
      // 2-4: Arapca, okunus, anlam ayni kartta, aralarinda baska icerik yok.
      kart([
        if (d.arapca.trim().isNotEmpty) ...[
          bolumEtiketi(t.dkArapca, gizKod: 'ar'),
          const SizedBox(height: 10),
          gizlenebilir(
              'ar',
              Directionality(
                textDirection: TextDirection.rtl,
                child: SelectableText(d.arapca,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: arapcaYaziTipi(),
                        fontSize: _ez.arapcaBoyut,
                        height: 2.05,
                        color: p.metin)),
              )),
          const SizedBox(height: 6),
          Text(t.dkArapcaNot,
              textAlign: TextAlign.center,
              style: TextStyle(color: p.ikincil, fontSize: 11)),
        ] else
          Text(t.dkYalnizMeal,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: p.ikincil, fontSize: 12, fontStyle: FontStyle.italic)),
        if (d.okunus.trim().isNotEmpty) ...[
          ayirici(),
          bolumEtiketi(t.dkOkunus, gizKod: 'ok'),
          const SizedBox(height: 8),
          gizlenebilir(
              'ok',
              SelectableText(d.okunus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: p.metin,
                      fontSize: _ez.okunusBoyut,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic))),
        ],
        if (d.anlam.trim().isNotEmpty) ...[
          ayirici(),
          bolumEtiketi(t.dkAnlam, gizKod: 'an'),
          const SizedBox(height: 8),
          gizlenebilir(
              'an',
              SelectableText(d.anlam,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: p.metin, fontSize: _ez.anlamBoyut, height: 1.7))),
        ],
      ]),
      // Eylemler
      Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(children: [
          for (final (ikon, ad, f) in [
            (Icons.copy_rounded, t.dkKopyala, () => _kopyala(t)),
            (
              Icons.ios_share_rounded,
              t.dkPaylas,
              _paylasiliyor ? null : () => _paylas(t)
            ),
            (
              fav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              t.dkKaydet,
              () => _favori(t)
            ),
          ])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: p.metin,
                      side: BorderSide(color: p.kenar),
                      backgroundColor: p.kart,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  onPressed: f,
                  icon: Icon(ikon, size: 18, color: p.altin),
                  label: Text(ad, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
        ]),
      ),
      // 5: Kaynak
      if (d.kaynak.trim().isNotEmpty)
        kart([
          Text(t.dkKaynak, textAlign: TextAlign.center, style: etiket),
          const SizedBox(height: 10),
          ortaMetin(d.kaynak, boyut: 15.5),
          if (d.sinif.isNotEmpty || d.numara.isNotEmpty || d.sihhat.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                  [
                    if (d.sinif.isNotEmpty) '${t.dkSinif}: ${d.sinif}',
                    if (d.numara.isNotEmpty) '${t.dkNumara}: ${d.numara}',
                    if (d.sihhat.isNotEmpty) '${t.dkSihhat}: ${d.sihhat}',
                  ].join('\n'),
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: p.ikincil, fontSize: 13, height: 1.6)),
            ),
        ]),
      // 6-8
      yardimci(t.dkAciklama, d.aciklama),
      yardimci(t.dkHikmet, d.hikmet),
      yardimci(t.dkNeZaman, d.neZaman),
      // 9: Ezber
      kart([
        Icon(Icons.psychology_alt_rounded, color: p.altin, size: 30),
        const SizedBox(height: 6),
        Text(t.dkEzber,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: p.metin, fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(t.dkEzberAlt,
            textAlign: TextAlign.center,
            style: TextStyle(color: p.ikincil, height: 1.5)),
        if (ek.parcalar.isNotEmpty || ek.seviye > 0) ...[
          const SizedBox(height: 12),
          LinearProgressIndicator(
              value: parcaSayisi == 0 ? 0 : ek.parcalar.length / parcaSayisi,
              minHeight: 6,
              borderRadius: BorderRadius.circular(6),
              color: p.altin,
              backgroundColor: p.kenar),
          const SizedBox(height: 6),
          Text(
              _ez.tamamlandiMi(d.id, parcaSayisi)
                  ? t.dkEzberTamam
                  : _ez.tekrarZamaniMi(d.id)
                      ? t.dkTekrarZamani
                      : t.dkIlerleme(ek.parcalar.length, parcaSayisi),
              textAlign: TextAlign.center,
              style: TextStyle(color: p.ikincil, fontSize: 12.5)),
        ],
        const SizedBox(height: 14),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: p.lacivert,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: p.altin.withValues(alpha: 0.6)))),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute<void>(builder: (_) => DuaEzberPage(dua: d))),
          child: Text(t.dkEzberBasla,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        ),
      ]),
      // 10: Ilgili dualar ve gecis
      if (sira >= 0 && widget.liste.length > 1)
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Row(children: [
            Expanded(
              child: TextButton.icon(
                onPressed: sira > 0 ? () => _git(widget.liste[sira - 1]) : null,
                icon: const Icon(Icons.chevron_left_rounded),
                label: Text(t.dkOnceki, overflow: TextOverflow.ellipsis),
              ),
            ),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: sira < widget.liste.length - 1
                      ? () => _git(widget.liste[sira + 1])
                      : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: Text(t.dkSonraki, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ]),
        ),
      if (ilgili.isNotEmpty)
        kart([
          Text(t.dkIlgili, textAlign: TextAlign.center, style: etiket),
          const SizedBox(height: 6),
          for (final x in ilgili)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(x.baslik,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: p.metin, fontWeight: FontWeight.w700)),
              subtitle: x.kaynak.isEmpty
                  ? null
                  : Text(x.kaynak,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: p.ikincil, fontSize: 12)),
              onTap: () => _git(x),
            ),
        ]),
    ];
  }
}

/// Paylasim gorseli: Arapca ustte, okunus ve anlam altta; hepsi ortali.
/// Yukseklik metne gore uzar (captureFromLongWidget), metin kesilmez.
class DuaPaylasimKarti extends StatelessWidget {
  final DuaGorunum dua;
  final String kaynakEtiketi;
  final String uygulamaAdi;
  const DuaPaylasimKarti(
      {super.key,
      required this.dua,
      required this.kaynakEtiketi,
      required this.uygulamaAdi});

  @override
  Widget build(BuildContext context) {
    const lacivert = Color(0xFF0A1F44);
    const altin = Color(0xFFC9A961);
    return Container(
      width: 440,
      color: const Color(0xFFFAF7F0),
      padding: const EdgeInsets.all(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: altin, width: 1.2),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            decoration: const BoxDecoration(
              color: lacivert,
              borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
            ),
            child: Text(dua.baslik,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.3)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
            child: Column(children: [
              if (dua.arapca.isNotEmpty) ...[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(dua.arapca,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: arapcaYaziTipi(),
                          fontSize: 27,
                          height: 2.0,
                          color: lacivert)),
                ),
                const SizedBox(height: 14),
              ],
              if (dua.okunus.isNotEmpty) ...[
                Text(dua.okunus,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16,
                        height: 1.55,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: lacivert)),
                const SizedBox(height: 12),
              ],
              Container(width: 60, height: 1.5, color: altin),
              const SizedBox(height: 12),
              Text(dua.anlam,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15.5, height: 1.65, color: Color(0xFF26364D))),
              if (dua.kaynak.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('$kaynakEtiketi · ${dua.kaynak}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF6B7385),
                        letterSpacing: 0.4)),
              ],
            ]),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE8E1D3))),
            ),
            child: Text(uygulamaAdi,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: altin,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 12)),
          ),
        ]),
      ),
    );
  }
}
