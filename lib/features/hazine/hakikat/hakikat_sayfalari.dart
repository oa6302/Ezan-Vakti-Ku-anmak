// Hakikat alt sayfalari: konu, liste, arama, arsiv, kulliyat ve eser detayi.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/hakikat_servisi.dart';
import 'package:nur_pusulasi/data/hakikat.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';

import 'hakikat_ortak.dart';

Scaffold _iskelet(String baslik, List<Widget> cocuklar,
        {List<Widget>? eylem}) =>
    Scaffold(
      backgroundColor: HkRenk.kirikBeyaz,
      appBar: AppBar(title: Text(baslik), actions: eylem),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          HkGovde(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: cocuklar)),
        ],
      ),
    );

class HakikatKonuPage extends StatelessWidget {
  final HakikatKonusu konu;
  const HakikatKonuPage({super.key, required this.konu});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: HakikatServisi.instance,
      builder: (context, _) {
        final liste = HakikatServisi.instance.yayindakiler
            .where((d) => d.hakikatKonulari.contains(konu))
            .toList();
        final metinler = konuMetinleri(konu, sinir: liste.isEmpty ? 12 : 4);
        return _iskelet(konuAdi(t, konu), [
          Row(children: [
            HkIkonRozeti(konu.ikon, boyut: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Text(t.hkHakikatSayisi(liste.length),
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: HkRenk.lacivert)),
            ),
          ]),
          const SizedBox(height: 14),
          if (liste.isEmpty)
            HkKart(child: HkBosDurum(t.hkKonuBos))
          else
            for (final d in liste) HakikatSatiri(ders: d),
          if (metinler.isNotEmpty) ...[
            HkBolumBasligi(t.hkIlgiliMetinler),
            for (final m in metinler) RisaleMetinKarti(m),
          ],
        ]);
      },
    );
  }
}

class HakikatListePage extends StatelessWidget {
  final String baslik;
  final List<RisaleDersi> liste;
  const HakikatListePage(
      {super.key, required this.baslik, required this.liste});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: HakikatServisi.instance,
      builder: (context, _) => _iskelet(baslik, [
        if (liste.isEmpty)
          HkKart(child: HkBosDurum(t.hkBos))
        else
          for (final d in liste) HakikatSatiri(ders: d),
      ]),
    );
  }
}

class HakikatArsivPage extends StatelessWidget {
  const HakikatArsivPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final arsiv = HakikatServisi.instance.arsiv(DateTime.now());
    return _iskelet(t.hkArsivBaslik, [
      if (arsiv.isEmpty) HkKart(child: HkBosDurum(t.hkIcerikYok)),
      for (final (i, (gun, d)) in arsiv.indexed)
        HakikatSatiri(
            ders: d,
            ust: i == 0
                ? t.hkBugun
                : MaterialLocalizations.of(context).formatMediumDate(gun)),
    ]);
  }
}

class HakikatAramaPage extends StatefulWidget {
  final String ilkSorgu;
  const HakikatAramaPage({super.key, this.ilkSorgu = ''});
  @override
  State<HakikatAramaPage> createState() => _HakikatAramaPageState();
}

class _HakikatAramaPageState extends State<HakikatAramaPage> {
  late final _ctrl = TextEditingController(text: widget.ilkSorgu);
  HakikatKonusu? _konu;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final q = _ctrl.text;
    final dersler = HakikatServisi.instance.yayindakiler.where((d) {
      if (_konu != null && !d.hakikatKonulari.contains(_konu)) return false;
      if (q.trim().isEmpty) return _konu != null;
      final alan = [
        d.baslik,
        d.govde,
        d.kavramlar.join(' '),
        d.kaynaklar.join(' '),
        for (final k in d.hakikatKonulari) konuAdi(t, k),
        for (final e in risaleKulliyati)
          if (e.dersiKapsar(d)) e.ad,
      ].join(' ');
      return aramaEslesir(alan, q);
    }).toList();
    final eserler = q.trim().isEmpty
        ? const <KulliyatEseri>[]
        : risaleKulliyati
            .where((e) => aramaEslesir(
                '${e.ad} ${e.konum} ${e.tanitim} ${e.anaKonu} ${e.meseleler.join(' ')}',
                q))
            .toList();
    final metinler = q.trim().length < 3
        ? const <RisaleMetni>[]
        : risaleMetinleri
            .where((m) =>
                (_konu == null || _konu!.regex.hasMatch(m.latin)) &&
                aramaEslesir('${m.latin} ${m.kaynak}', q))
            .take(30)
            .toList();
    final bos = dersler.isEmpty && eserler.isEmpty && metinler.isEmpty;
    return Scaffold(
      backgroundColor: HkRenk.kirikBeyaz,
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: widget.ilkSorgu.isEmpty,
          textInputAction: TextInputAction.search,
          decoration:
              InputDecoration(hintText: t.hkAraIpucu, border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          if (_ctrl.text.isNotEmpty)
            IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () => setState(_ctrl.clear)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          HkGovde(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                              label: Text(t.hkTumu),
                              selected: _konu == null,
                              onSelected: (_) => setState(() => _konu = null)),
                        ),
                        for (final k in HakikatKonusu.values)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                                avatar: Icon(k.ikon, size: 16),
                                label: Text(konuAdi(t, k)),
                                selected: _konu == k,
                                onSelected: (_) => setState(
                                    () => _konu = _konu == k ? null : k)),
                          ),
                      ],
                    ),
                  ),
                  if (bos && (q.isNotEmpty || _konu != null))
                    HkBosDurum(t.hkSonucYok, ikon: Icons.search_off_rounded),
                  if (dersler.isNotEmpty) ...[
                    HkBolumBasligi(t.hkHakikatler),
                    for (final d in dersler) HakikatSatiri(ders: d),
                  ],
                  if (eserler.isNotEmpty) ...[
                    HkBolumBasligi(t.hkKulliyat),
                    for (final e in eserler) _EserSatiri(eser: e),
                  ],
                  if (metinler.isNotEmpty) ...[
                    HkBolumBasligi(t.hkRisaleMetinleri),
                    for (final m in metinler) RisaleMetinKarti(m),
                  ],
                ]),
          ),
        ],
      ),
    );
  }
}

class KulliyatPage extends StatelessWidget {
  const KulliyatPage({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final eserler = risaleKulliyati.where((e) => !e.risale).toList();
    final risaleler = risaleKulliyati.where((e) => e.risale).toList();
    return _iskelet(t.hkKulliyat, [
      if (risaleKulliyati.isEmpty) HkKart(child: HkBosDurum(t.hkIcerikYok)),
      if (eserler.isNotEmpty) HkBolumBasligi(t.hkEserler),
      for (final e in eserler) _EserSatiri(eser: e),
      if (risaleler.isNotEmpty) HkBolumBasligi(t.hkRisaleler),
      for (final e in risaleler) _EserSatiri(eser: e),
    ]);
  }
}

class _EserSatiri extends StatelessWidget {
  final KulliyatEseri eser;
  const _EserSatiri({required this.eser});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final n = risaleMetinleri.where(eser.metniKapsar).length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HkKart(
        padding: const EdgeInsets.all(14),
        onTap: () => Navigator.push(context,
            MaterialPageRoute<void>(builder: (_) => EserDetayPage(eser: eser))),
        child: Row(children: [
          HkIkonRozeti(eser.risale
              ? Icons.article_rounded
              : Icons.collections_bookmark_rounded),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(eser.ad,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: HkRenk.lacivert)),
              if (eser.konum.isNotEmpty)
                Text(eser.konum,
                    style: const TextStyle(fontSize: 12, color: HkRenk.altin)),
              Text(t.hkMetinSayisi(n),
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded),
        ]),
      ),
    );
  }
}

class EserDetayPage extends StatefulWidget {
  final KulliyatEseri eser;
  const EserDetayPage({super.key, required this.eser});
  @override
  State<EserDetayPage> createState() => _EserDetayPageState();
}

class _EserDetayPageState extends State<EserDetayPage> {
  String? _bolum;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final e = widget.eser;
    final metinler = risaleMetinleri.where(e.metniKapsar).toList();
    final bolumler = <String>{
      for (final m in metinler)
        if (m.bolum.isNotEmpty) m.bolum.split(' · ').first
    }.toList();
    final gosterilen = _bolum == null
        ? metinler.take(20).toList()
        : metinler.where((m) => m.bolum.startsWith(_bolum!)).toList();
    final dersler =
        HakikatServisi.instance.yayindakiler.where(e.dersiKapsar).toList();
    return _iskelet(e.ad, [
      HkKart(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (e.konum.isNotEmpty) ...[
            Text(t.hkKonum,
                style: const TextStyle(
                    fontSize: 12,
                    color: HkRenk.altin,
                    fontWeight: FontWeight.w700)),
            Text(e.konum, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
          ],
          Text(t.hkTanitim,
              style: const TextStyle(
                  fontSize: 12,
                  color: HkRenk.altin,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(e.tanitim, style: const TextStyle(height: 1.6)),
          const SizedBox(height: 10),
          Text(t.hkAnaKonu,
              style: const TextStyle(
                  fontSize: 12,
                  color: HkRenk.altin,
                  fontWeight: FontWeight.w700)),
          Text(e.anaKonu, style: const TextStyle(height: 1.5)),
          if (e.meseleler.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(t.hkMeseleler,
                style: const TextStyle(
                    fontSize: 12,
                    color: HkRenk.altin,
                    fontWeight: FontWeight.w700)),
            for (final m in e.meseleler)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text('• $m', style: const TextStyle(height: 1.45)),
              ),
          ],
          if (e.konular.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final k in e.konular)
                ActionChip(
                  avatar: Icon(k.ikon, size: 16),
                  label:
                      Text(konuAdi(t, k), style: const TextStyle(fontSize: 12)),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => HakikatKonuPage(konu: k))),
                ),
            ]),
          ],
        ]),
      ),
      if (dersler.isNotEmpty) ...[
        HkBolumBasligi(t.hkHakikatler),
        for (final d in dersler) HakikatSatiri(ders: d),
      ],
      HkBolumBasligi(t.hkRisaleMetinleri),
      Text(t.hkKaynakNotu,
          style: const TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 8),
      if (bolumler.length > 1)
        Wrap(spacing: 6, runSpacing: 6, children: [
          ChoiceChip(
              label: Text(t.hkTumu),
              selected: _bolum == null,
              onSelected: (_) => setState(() => _bolum = null)),
          for (final b in bolumler)
            ChoiceChip(
                label: Text(b),
                selected: _bolum == b,
                onSelected: (_) => setState(() => _bolum = b)),
        ]),
      const SizedBox(height: 8),
      if (gosterilen.isEmpty) HkKart(child: HkBosDurum(t.hkIcerikYok)),
      for (final m in gosterilen) RisaleMetinKarti(m),
    ]);
  }
}
