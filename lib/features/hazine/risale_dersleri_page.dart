// 🌿 Risale-i Nur / Hakikat: ana ekran (Gunun Hakikati, konular, kulliyat,
// ilerleme) ve hakikat detay sayfasi (standartlar/RISALE_STANDARDI.md).
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/hakikat_servisi.dart';
import 'package:nur_pusulasi/data/hakikat.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';

import 'hakikat/egitim.dart';
import 'hakikat/hakikat_ortak.dart';
import 'hakikat/hakikat_sayfalari.dart';
import 'ortak.dart';

/// Varliklar ve okuyucu durumu yuklu degilse yukler (internet gerekmez).
Future<void> hakikatHazirla() async {
  if (risaleDersleri.isEmpty) await icerikHazinesiniYukle();
  await hakikatVerisiniYukle();
  await HakikatServisi.instance.yukle();
}

class RisaleDersleriPage extends StatefulWidget {
  const RisaleDersleriPage({super.key});
  @override
  State<RisaleDersleriPage> createState() => _RisaleDersleriPageState();
}

class _RisaleDersleriPageState extends State<RisaleDersleriPage> {
  late final Future<void> _hazir = hakikatHazirla();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: HkRenk.kirikBeyaz,
      appBar: AppBar(
        title: Text(t.hkBaslik),
        actions: [
          IconButton(
            tooltip: t.hkAra,
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) => const HakikatAramaPage())),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _hazir,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListenableBuilder(
            listenable: HakikatServisi.instance,
            builder: (context, _) => _AnaIcerik(t: t),
          );
        },
      ),
    );
  }
}

class _AnaIcerik extends StatelessWidget {
  final AppLocalizations t;
  const _AnaIcerik({required this.t});

  @override
  Widget build(BuildContext context) {
    final s = HakikatServisi.instance;
    final tumu = s.yayindakiler;
    final gunun = s.gununHakikati(DateTime.now());
    final tamam = s.tamamlananlar.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        HkGovde(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _Afis(t: t),
            const SizedBox(height: 14),
            if (gunun != null)
              _GununKarti(ders: gunun, t: t)
            else
              HkKart(child: HkBosDurum(t.hkIcerikYok)),
            if (tumu.isNotEmpty) ...[
              const SizedBox(height: 14),
              HkKart(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.hkIlerleme(tamam, tumu.length),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: HkRenk.lacivert)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                          value: tamam / tumu.length,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(6),
                          color: HkRenk.altin,
                          backgroundColor: HkRenk.kenar),
                      const SizedBox(height: 12),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        _ListeCipi(
                            Icons.favorite_rounded, t.hkFavoriler, s.favoriler),
                        _ListeCipi(Icons.bookmark_rounded, t.hkSonraOku,
                            s.sonraOkunacaklar),
                        _ListeCipi(Icons.check_circle_rounded,
                            t.hkTamamlananlar, s.tamamlananlar),
                      ]),
                    ]),
              ),
            ],
            if (s.sonOkunanlar.isNotEmpty) ...[
              HkBolumBasligi(t.hkDevamEt),
              for (final d in s.sonOkunanlar.take(3)) HakikatSatiri(ders: d),
            ],
            HkBolumBasligi(t.hkKonular),
            LayoutBuilder(builder: (context, c) {
              // Kart genisligi en az ~165 px; yukseklik yazi olcegine gore.
              final sutun = (c.maxWidth / 165).floor().clamp(2, 5);
              final olcek = MediaQuery.textScalerOf(context).scale(1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: HakikatKonusu.values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: sutun,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 74 + 62 * olcek,
                ),
                itemBuilder: (context, i) {
                  final k = HakikatKonusu.values[i];
                  return _KonuKarti(
                      konu: k,
                      sayi: tumu
                          .where((d) => d.hakikatKonulari.contains(k))
                          .length,
                      t: t);
                },
              );
            }),
            HkBolumBasligi(t.hkKulliyat),
            HkKart(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const KulliyatPage())),
              child: Row(children: [
                const HkIkonRozeti(Icons.library_books_rounded, boyut: 48),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.hkKulliyat,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: HkRenk.lacivert)),
                        const SizedBox(height: 3),
                        Text(t.hkKulliyatAlt,
                            style: const TextStyle(color: Colors.black54)),
                      ]),
                ),
                const Icon(Icons.chevron_right_rounded),
              ]),
            ),
            if (s.enCokOkunanlar.isNotEmpty) ...[
              HkBolumBasligi(t.hkSikOkunan),
              for (final d in s.enCokOkunanlar) HakikatSatiri(ders: d),
            ],
          ]),
        ),
      ],
    );
  }
}

class _Afis extends StatelessWidget {
  final AppLocalizations t;
  const _Afis({required this.t});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [HkRenk.lacivert, Color(0xFF16305C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: HkRenk.altin.withValues(alpha: 0.5)),
        ),
        child: Row(children: [
          const Icon(Icons.light_mode_rounded, color: HkRenk.altin, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.hkBaslik,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(t.hkAltBaslik,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4)),
            ]),
          ),
        ]),
      );
}

class _GununKarti extends StatelessWidget {
  final RisaleDersi ders;
  final AppLocalizations t;
  const _GununKarti({required this.ders, required this.t});

  @override
  Widget build(BuildContext context) {
    final konu = ders.hakikatKonulari.first;
    final ozet = ders.giris.length > 190
        ? '${ders.giris.substring(0, 190).trimRight()}…'
        : ders.giris;
    return HkKart(
      onTap: () => hakikatAc(context, ders),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.wb_sunny_rounded, color: HkRenk.altin, size: 20),
          const SizedBox(width: 6),
          Text(t.hkGununHakikati,
              style: const TextStyle(
                  color: HkRenk.altin, fontWeight: FontWeight.w800)),
          const Spacer(),
          Flexible(
            child: Text(konuAdi(t, konu),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
        ]),
        const SizedBox(height: 10),
        Text(ders.baslik,
            style: const TextStyle(
                fontSize: 20,
                height: 1.3,
                fontWeight: FontWeight.w900,
                color: HkRenk.lacivert)),
        const SizedBox(height: 8),
        Text(ozet, style: const TextStyle(height: 1.55)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 4, children: [
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: HkRenk.lacivert),
            onPressed: () => hakikatAc(context, ders),
            icon: const Icon(Icons.menu_book_rounded, size: 18),
            label: Text(t.hkDetayliIncele),
          ),
          OutlinedButton.icon(
            onPressed: () => metinPaylas(hakikatPaylasimMetni(ders, t)),
            icon: const Icon(Icons.share_rounded, size: 18),
            label: Text(t.hkPaylas),
          ),
          TextButton.icon(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) => const HakikatArsivPage())),
            icon: const Icon(Icons.history_rounded, size: 18),
            label: Text(t.hkArsiv),
          ),
        ]),
      ]),
    );
  }
}

class _ListeCipi extends StatelessWidget {
  final IconData ikon;
  final String ad;
  final List<RisaleDersi> liste;
  const _ListeCipi(this.ikon, this.ad, this.liste);
  @override
  Widget build(BuildContext context) => ActionChip(
        avatar: Icon(ikon, size: 18, color: HkRenk.lacivert),
        label: Text('$ad (${liste.length})'),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) => HakikatListePage(baslik: ad, liste: liste))),
      );
}

class _KonuKarti extends StatelessWidget {
  final HakikatKonusu konu;
  final int sayi;
  final AppLocalizations t;
  const _KonuKarti({required this.konu, required this.sayi, required this.t});
  @override
  Widget build(BuildContext context) => HkKart(
        padding: const EdgeInsets.all(12),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) => HakikatKonuPage(konu: konu))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HkIkonRozeti(konu.ikon, boyut: 36),
          const SizedBox(height: 10),
          Text(konuAdi(t, konu),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: HkRenk.lacivert,
                  height: 1.25)),
          const SizedBox(height: 2),
          Text(t.hkHakikatSayisi(sayi),
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ]),
      );
}

// ───────────────────────── Detay ─────────────────────────

class RisaleDersPage extends StatefulWidget {
  final RisaleDersi ders;

  /// Yonetici onizlemesi: okuma kaydi ve test puani tutulmaz.
  final bool onizleme;
  const RisaleDersPage({super.key, required this.ders, this.onizleme = false});

  @override
  State<RisaleDersPage> createState() => _RisaleDersPageState();
}

class _RisaleDersPageState extends State<RisaleDersPage> {
  final _kaydirma = ScrollController();
  double _oran = 0;

  HakikatServisi get _s => HakikatServisi.instance;

  @override
  void initState() {
    super.initState();
    _oran = widget.onizleme ? 0 : _s.ilerleme(widget.ders.id);
    if (!widget.onizleme) _s.acildi(widget.ders.id);
    _kaydirma.addListener(_kaydirildi);
  }

  void _kaydirildi() {
    if (!_kaydirma.hasClients) return;
    final p = _kaydirma.position;
    if (p.maxScrollExtent <= 0) return;
    final o = (p.pixels / p.maxScrollExtent).clamp(0.0, 1.0);
    if ((o - _oran).abs() > 0.01) setState(() => _oran = o);
    if (!widget.onizleme) _s.ilerlemeKaydet(widget.ders.id, o);
  }

  @override
  void dispose() {
    _kaydirma
      ..removeListener(_kaydirildi)
      ..dispose();
    super.dispose();
  }

  Future<void> _yaziBoyutu(AppLocalizations t) => showModalBottomSheet<void>(
        context: context,
        builder: (_) => ListenableBuilder(
          listenable: _s,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(t.hkYaziBoyutu,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              Row(children: [
                const Text('A', style: TextStyle(fontSize: 13)),
                Expanded(
                  child: Slider(
                    value: _s.yaziOlcegi,
                    min: 0.85,
                    max: 1.5,
                    divisions: 13,
                    label: '${(_s.yaziOlcegi * 100).round()}%',
                    onChanged: _s.yaziOlcegiAyarla,
                  ),
                ),
                const Text('A', style: TextStyle(fontSize: 22)),
              ]),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final d = widget.ders;
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        final fav = _s.favoriMi(d.id);
        final sonra = _s.sonraOkuMu(d.id);
        return Scaffold(
          backgroundColor: HkRenk.kirikBeyaz,
          appBar: AppBar(
            title: Text(konuAdi(t, d.hakikatKonulari.first),
                overflow: TextOverflow.ellipsis),
            actions: [
              if (!widget.onizleme) ...[
                IconButton(
                  tooltip: fav ? t.hkFavoriCikar : t.hkFavoriEkle,
                  icon: Icon(fav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded),
                  onPressed: () => _s.favoriDegistir(d.id),
                ),
                IconButton(
                  tooltip: sonra ? t.hkSonraOkuCikar : t.hkSonraOkuEkle,
                  icon: Icon(sonra
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded),
                  onPressed: () => _s.sonraOkuDegistir(d.id),
                ),
              ],
              IconButton(
                tooltip: t.hkYaziBoyutu,
                icon: const Icon(Icons.format_size_rounded),
                onPressed: () => _yaziBoyutu(t),
              ),
              IconButton(
                tooltip: t.hkPaylas,
                icon: const Icon(Icons.share_rounded),
                onPressed: () => metinPaylas(hakikatPaylasimMetni(d, t)),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3),
              child: LinearProgressIndicator(
                  value: _oran,
                  minHeight: 3,
                  color: HkRenk.altin,
                  backgroundColor: Colors.transparent),
            ),
          ),
          body: MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                    MediaQuery.textScalerOf(context).scale(1) * _s.yaziOlcegi)),
            child: ListView(
              controller: _kaydirma,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
              children: [HkGovde(child: _detay(context, t, d))],
            ),
          ),
        );
      },
    );
  }

  Widget _detay(BuildContext context, AppLocalizations t, RisaleDersi d) {
    final havuz = _s.yayindakiler;
    final bosluk = BoslukSorusu.uret(d, havuz);
    final ayniKonu = [
      d,
      ...havuz.where((o) =>
          o.id != d.id &&
          o.hakikatKonulari.any(d.hakikatKonulari.contains) &&
          o.ders.isNotEmpty),
      ...havuz.where((o) =>
          o.id != d.id && !o.hakikatKonulari.any(d.hakikatKonulari.contains)),
    ].take(4).toList();
    final eserler =
        risaleKulliyati.where((e) => e.dersiKapsar(d)).toList(growable: false);
    final tamam = _s.tamamlandiMi(d.id);
    final puan = _s.testPuani(d.id);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(spacing: 6, runSpacing: 6, children: [
        for (final k in d.hakikatKonulari)
          Chip(
            avatar: Icon(k.ikon, size: 16, color: HkRenk.lacivert),
            label: Text(konuAdi(t, k), style: const TextStyle(fontSize: 12)),
            visualDensity: VisualDensity.compact,
          ),
      ]),
      const SizedBox(height: 8),
      Text(d.baslik,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: HkRenk.lacivert,
              height: 1.25)),
      if (!widget.onizleme && (_s.ilerleme(d.id) > 0 || puan != null))
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
              [
                if (_s.ilerleme(d.id) > 0)
                  t.hkOkundu((_s.ilerleme(d.id) * 100).round()),
                if (puan != null) t.hkEnIyiPuan(puan),
              ].join(' · '),
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ),
      HazineBolum(baslik: '🚪 ${t.hkTefekkurKapisi}', metin: d.giris),
      HazineBolum(baslik: '📖 ${t.hkAciklama}', metin: d.aciklama),
      HazineBolum(
        baslik: '🔍 ${t.hkPerspektif}',
        renk: const Color(0xFF6A4C93),
        cocuk: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _AlintiliMetin(d.risalePerspektifi),
          const SizedBox(height: 8),
          Text(t.hkPerspektifNot,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ]),
      ),
      HazineBolum(
          baslik: '🌌 ${t.hkKainattan}',
          metin: d.kainattanDelil,
          renk: const Color(0xFF1565C0)),
      HazineBolum(
          baslik: '🌱 ${t.hkGunlukHayat}',
          metin: d.hayat,
          renk: const Color(0xFF2E7D32)),
      HazineBolum(
          baslik: '💡 ${t.hkHikmet}', metin: d.hikmet, renk: HkRenk.altin),
      HazineBolum(baslik: '🪞 ${t.hkSorgula}', metin: d.kendimize),
      HazineBolum(
        baslik: '✅ ${t.hkUygula}',
        renk: const Color(0xFF00695C),
        cocuk: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(d.tefekkurSorusu,
              style: const TextStyle(fontSize: 15.5, height: 1.6)),
          if (!widget.onizleme)
            Material(
              type: MaterialType.transparency,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _s.gorevYapildiMi(d.id),
                onChanged: (_) => _s.gorevDegistir(d.id),
                title: Text(t.hkGorevYaptim),
              ),
            ),
        ]),
      ),
      if (d.dua.arapca.isNotEmpty || d.dua.anlam.isNotEmpty)
        HazineBolum(
          baslik: '🤲 ${t.hkDua}',
          renk: const Color(0xFF00695C),
          cocuk:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (d.dua.arapca.isNotEmpty) ArapcaMetin(d.dua.arapca, boyut: 22),
            if (d.dua.okunus.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(d.dua.okunus,
                  style: const TextStyle(fontStyle: FontStyle.italic)),
            ],
            const SizedBox(height: 6),
            Text(d.dua.anlam, style: const TextStyle(height: 1.6)),
            const SizedBox(height: 6),
            Text('📚 ${d.dua.kaynak}',
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      HazineBolum(
          baslik: '⭐ ${t.hkOgrenilen}', metin: d.ders, renk: hazineKirmizi),
      if (d.kavramlar.isNotEmpty)
        HazineBolum(
          baslik: '🔑 ${t.hkKavramlar}',
          cocuk: Wrap(spacing: 6, runSpacing: 6, children: [
            for (final k in d.kavramlar) Chip(label: Text(k)),
          ]),
        ),
      HazineBolum(
        baslik: '📝 ${t.hkSorular}',
        renk: const Color(0xFF6A4C93),
        cocuk:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t.hkMiniTest,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          HakikatTesti(ders: d, kaydet: !widget.onizleme),
          if (bosluk != null) ...[
            const Divider(height: 28),
            Text(t.hkBoslukDoldur,
                style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            BoslukDoldurma(soru: bosluk),
          ],
          if (ayniKonu.length >= 3) ...[
            const Divider(height: 28),
            Text(t.hkEslestir,
                style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            HakikatEslestirme(dersler: ayniKonu),
          ],
        ]),
      ),
      if (eserler.isNotEmpty)
        HazineBolum(
          baslik: '🏛️ ${t.hkIlgiliEserler}',
          cocuk: Wrap(spacing: 6, runSpacing: 6, children: [
            for (final e in eserler)
              ActionChip(
                label: Text(e.ad),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => EserDetayPage(eser: e))),
              ),
          ]),
        ),
      HazineBolum(
          baslik: '📚 ${t.hkKaynaklar}',
          metin: d.kaynaklar.map((k) => '• $k').join('\n'),
          renk: const Color(0xFF5D4037)),
      if (!widget.onizleme) ...[
        const SizedBox(height: 18),
        FilledButton.icon(
          style: FilledButton.styleFrom(
              backgroundColor:
                  tamam ? const Color(0xFF2E7D32) : HkRenk.lacivert,
              padding: const EdgeInsets.symmetric(vertical: 14)),
          onPressed: () => _s.tamamlandiDegistir(d.id),
          icon: Icon(tamam
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded),
          label: Text(tamam ? t.hkTamamlandi : t.hkTamamla),
        ),
      ],
    ]);
  }
}

/// Tirnak (“...”) icindeki aynen alintilar altin, italik; gerisi aciklama.
class _AlintiliMetin extends StatelessWidget {
  final String metin;
  const _AlintiliMetin(this.metin);
  @override
  Widget build(BuildContext context) {
    final parcalar = <TextSpan>[];
    var i = 0;
    for (final m in RegExp('“[^”]+”').allMatches(metin)) {
      if (m.start > i) {
        parcalar.add(TextSpan(text: metin.substring(i, m.start)));
      }
      parcalar.add(TextSpan(
          text: m.group(0),
          style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6A4C93))));
      i = m.end;
    }
    if (i < metin.length) parcalar.add(TextSpan(text: metin.substring(i)));
    return SelectableText.rich(TextSpan(
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
        children: parcalar));
  }
}
