// Ana sayfadaki Risale-i Nur kartinin "Devamini oku" sayfasi: pasajin tamami
// (Latince + istenirse Osmanlica), kaynak, paylasim ve pasajla ilgili hakikatler.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/hakikat_servisi.dart';
import 'package:nur_pusulasi/data/hakikat.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';

import '../ortak.dart';
import '../risale_dersleri_page.dart';
import 'hakikat_ortak.dart';
import 'hakikat_sayfalari.dart';

/// Metindeki anahtar kelimelere gore en cok eslesen konular (en fazla 3).
List<HakikatKonusu> metinKonulari(String metin) {
  final say = {
    for (final k in HakikatKonusu.values) k: k.regex.allMatches(metin).length
  }..removeWhere((_, v) => v == 0);
  final l = say.keys.toList()..sort((a, b) => say[b]!.compareTo(say[a]!));
  return l.take(3).toList();
}

/// Yaklasik okuma suresi (dakika, en az 1): ~180 kelime/dk.
int okumaDakikasi(String metin) =>
    (metin.split(RegExp(r'\s+')).length / 180).ceil().clamp(1, 60);

class RisalePasajPage extends StatefulWidget {
  final String baslik;
  final String metin;
  final String alinti;
  final String osmanlica;
  final String eser;
  final String bolum;
  final bool aynen;
  const RisalePasajPage({
    super.key,
    required this.baslik,
    required this.metin,
    this.alinti = '',
    this.osmanlica = '',
    this.eser = '',
    this.bolum = '',
    this.aynen = false,
  });

  @override
  State<RisalePasajPage> createState() => _RisalePasajPageState();
}

class _RisalePasajPageState extends State<RisalePasajPage> {
  late final Future<void> _hazir = hakikatHazirla();
  bool _osmanlica = false;

  String get _kaynak =>
      [widget.eser, widget.bolum].where((v) => v.trim().isNotEmpty).join(' · ');

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final w = widget;
    final paylas = [
      w.baslik,
      '',
      w.alinti.isNotEmpty ? '“${w.alinti}”' : w.metin,
      if (_kaynak.isNotEmpty) '— $_kaynak',
    ].join('\n');
    return Scaffold(
      backgroundColor: HkRenk.kirikBeyaz,
      appBar: AppBar(
        title: Text(t.uiRisaleINur),
        actions: [
          IconButton(
              tooltip: t.hkPaylas,
              icon: const Icon(Icons.share_rounded),
              onPressed: () => metinPaylas(paylas)),
        ],
      ),
      body: FutureBuilder<void>(
        future: _hazir,
        builder: (context, snap) {
          final hazir = snap.connectionState == ConnectionState.done;
          final konular = metinKonulari('${w.metin} ${w.alinti}');
          final s = HakikatServisi.instance;
          final ilgili = !hazir
              ? const <RisaleDersi>[]
              : s.yayindakiler
                  .where((d) => d.hakikatKonulari.any(konular.contains))
                  .take(3)
                  .toList();
          final gunun = hazir ? s.gununHakikati(DateTime.now()) : null;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
            children: [
              HkGovde(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(w.baslik,
                          style: const TextStyle(
                              fontSize: 22,
                              height: 1.3,
                              fontWeight: FontWeight.w900,
                              color: HkRenk.lacivert)),
                      const SizedBox(height: 6),
                      Text(
                          [
                            if (_kaynak.isNotEmpty) _kaynak,
                            t.hkOkumaSuresi(okumaDakikasi(w.metin)),
                          ].join(' · '),
                          style: const TextStyle(
                              fontSize: 12.5, color: Colors.black54)),
                      const SizedBox(height: 14),
                      HkKart(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    if (w.aynen)
                                      Chip(
                                        avatar: const Icon(
                                            Icons.verified_rounded,
                                            size: 16,
                                            color: Color(0xFF2E7D32)),
                                        label: Text(t.hkAynen,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    if (w.osmanlica.trim().isNotEmpty)
                                      FilterChip(
                                        label: Text(t.hkOsmanlica),
                                        selected: _osmanlica,
                                        onSelected: (v) =>
                                            setState(() => _osmanlica = v),
                                      ),
                                  ]),
                              const SizedBox(height: 8),
                              SelectableText(w.metin,
                                  style: const TextStyle(
                                      fontSize: 16.5, height: 1.8)),
                              if (w.alinti.trim().isNotEmpty &&
                                  w.alinti.trim() != w.metin.trim()) ...[
                                const SizedBox(height: 12),
                                SelectableText('“${w.alinti}”',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15,
                                        height: 1.6,
                                        color: HkRenk.lacivert)),
                              ],
                              if (_osmanlica) ...[
                                const Divider(height: 26),
                                ArapcaMetin(w.osmanlica, boyut: 22),
                              ],
                              if (w.aynen) ...[
                                const SizedBox(height: 12),
                                Text(t.hkKaynakNotu,
                                    style: const TextStyle(
                                        fontSize: 11.5, color: Colors.black54)),
                              ],
                            ]),
                      ),
                      if (konular.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(spacing: 6, runSpacing: 6, children: [
                          for (final k in konular)
                            ActionChip(
                              avatar: Icon(k.ikon, size: 16),
                              label: Text(konuAdi(t, k),
                                  style: const TextStyle(fontSize: 12)),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (_) =>
                                          HakikatKonuPage(konu: k))),
                            ),
                        ]),
                      ],
                      if (ilgili.isNotEmpty) ...[
                        HkBolumBasligi(t.hkIlgiliHakikatler),
                        for (final d in ilgili) HakikatSatiri(ders: d),
                      ],
                      if (gunun != null && !ilgili.contains(gunun)) ...[
                        HkBolumBasligi(t.hkGununHakikati),
                        HakikatSatiri(ders: gunun),
                      ],
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                            backgroundColor: HkRenk.lacivert,
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (_) => const RisaleDersleriPage())),
                        icon: const Icon(Icons.explore_rounded),
                        label: Text(t.hkHakikatiKesfet),
                      ),
                    ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
