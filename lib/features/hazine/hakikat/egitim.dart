// Hakikat sayfasindaki ogrenme araclari. Sorular dersin kendi verisinden
// uretilir (soru, kavram, ozet); disaridan uydurma bilgi eklenmez.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/hakikat_servisi.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';

import 'hakikat_ortak.dart';

const _yesil = Color(0xFF2E7D32);
const _kirmizi = Color(0xFFB71C1C);

Widget _secenek(String metin,
    {required bool secili,
    required bool? dogru,
    required VoidCallback? onTap}) {
  final renk = !secili
      ? HkRenk.kenar
      : dogru == null
          ? HkRenk.lacivert
          : dogru
              ? _yesil
              : _kirmizi;
  return Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Material(
      color: secili ? renk.withValues(alpha: 0.08) : Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: renk, width: secili ? 1.6 : 1),
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(child: Text(metin, style: const TextStyle(height: 1.35))),
            if (secili && dogru != null)
              Icon(dogru ? Icons.check_circle : Icons.cancel, color: renk),
          ]),
        ),
      ),
    ),
  );
}

class _Aciklama extends StatelessWidget {
  final bool dogru;
  final String dogruCevap;
  final String ozet;
  const _Aciklama(
      {required this.dogru, required this.dogruCevap, required this.ozet});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final r = dogru ? _yesil : _kirmizi;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: r.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: r.withValues(alpha: 0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(dogru ? '✓ ${t.hkDogru}' : t.hkDogruCevap(dogruCevap),
            style: TextStyle(color: r, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('${t.hkGerekce}: $ozet',
            style: const TextStyle(fontSize: 13, height: 1.5)),
      ]),
    );
  }
}

/// Coktan secmeli + dogru/yanlis; her cevapta gerekce, sonunda puan kaydi.
class HakikatTesti extends StatefulWidget {
  final RisaleDersi ders;
  final bool kaydet;
  const HakikatTesti({super.key, required this.ders, this.kaydet = true});
  @override
  State<HakikatTesti> createState() => _HakikatTestiState();
}

class _HakikatTestiState extends State<HakikatTesti> {
  final Map<int, int> _mc = {};
  final Map<int, bool> _dy = {};

  int get _toplam => widget.ders.sinav.length + widget.ders.dogruYanlis.length;
  int get _cevaplanan => _mc.length + _dy.length;
  int get _dogruSayisi =>
      _mc.entries
          .where((e) => widget.ders.sinav[e.key].dogru == e.value)
          .length +
      _dy.entries
          .where((e) => widget.ders.dogruYanlis[e.key].dogru == e.value)
          .length;

  void _cevaplandi() {
    setState(() {});
    if (_cevaplanan == _toplam && widget.kaydet) {
      HakikatServisi.instance
          .testSonucu(widget.ders.id, (_dogruSayisi * 100 / _toplam).round());
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.ders;
    if (_toplam == 0) return const SizedBox.shrink();
    final t = AppLocalizations.of(context);
    final ts = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final (i, s) in d.sinav.indexed) ...[
        const SizedBox(height: 12),
        Text('${i + 1}. ${s.soru}', style: ts.titleSmall),
        for (final (j, sec) in s.secenekler.indexed)
          _secenek(sec,
              secili: _mc[i] == j,
              dogru: _mc.containsKey(i) ? j == s.dogru : null,
              onTap: _mc.containsKey(i)
                  ? null
                  : () {
                      _mc[i] = j;
                      _cevaplandi();
                    }),
        if (_mc.containsKey(i))
          _Aciklama(
              dogru: _mc[i] == s.dogru,
              dogruCevap:
                  s.secenekler[s.dogru.clamp(0, s.secenekler.length - 1)],
              ozet: d.ders),
      ],
      for (final (i, q) in d.dogruYanlis.indexed) ...[
        const SizedBox(height: 14),
        Text('${d.sinav.length + i + 1}. ${q.ifade}', style: ts.titleSmall),
        Row(children: [
          for (final cevap in [true, false])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _secenek(cevap ? t.hkDogru : t.hkYanlis,
                    secili: _dy[i] == cevap,
                    dogru: _dy.containsKey(i) ? cevap == q.dogru : null,
                    onTap: _dy.containsKey(i)
                        ? null
                        : () {
                            _dy[i] = cevap;
                            _cevaplandi();
                          }),
              ),
            ),
        ]),
        if (_dy.containsKey(i))
          _Aciklama(
              dogru: _dy[i] == q.dogru,
              dogruCevap: q.dogru ? t.hkDogru : t.hkYanlis,
              ozet: d.ders),
      ],
      if (_cevaplanan == _toplam) ...[
        const SizedBox(height: 12),
        Row(children: [
          Icon(Icons.emoji_events_rounded,
              color: _dogruSayisi == _toplam ? HkRenk.altin : Colors.black45),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
                  _dogruSayisi == _toplam
                      ? '${t.hkTestSonuc(_dogruSayisi, _toplam)} · ${t.hkTebrik}'
                      : t.hkTestSonuc(_dogruSayisi, _toplam),
                  style: const TextStyle(fontWeight: FontWeight.w800))),
          TextButton(
              onPressed: () => setState(() {
                    _mc.clear();
                    _dy.clear();
                  }),
              child: Text(t.hkYenidenDene)),
        ]),
      ],
    ]);
  }
}

/// Bosluk doldurma soru verisi: dersin ozetindeki bir kavram bosaltilir.
class BoslukSorusu {
  final String once;
  final String sonra;
  final String cevap;
  final List<String> secenekler;
  const BoslukSorusu(this.once, this.sonra, this.cevap, this.secenekler);

  /// Ozet cumlesinde gecen ilk kavram; yoksa null (soru gosterilmez).
  static BoslukSorusu? uret(RisaleDersi d, List<RisaleDersi> havuz) {
    final cumle = d.ders;
    final kucuk = cumle.toLowerCase();
    for (final k in d.kavramlar) {
      final i = kucuk.indexOf(k.toLowerCase());
      if (k.length < 3 || i < 0) continue;
      final digerleri = <String>{
        ...d.kavramlar.where((x) => x != k),
        for (final o in havuz)
          if (o.id != d.id) ...o.kavramlar,
      }.where((x) => !kucuk.contains(x.toLowerCase())).toList()
        ..sort();
      final yanlis = <String>{
        for (var j = 0; j < digerleri.length && j < 3; j++)
          digerleri[(d.id.hashCode.abs() + j * 7) % digerleri.length]
      }.toList();
      final sec = [cumle.substring(i, i + k.length), ...yanlis]
        ..sort((a, b) => a.hashCode.compareTo(b.hashCode));
      return BoslukSorusu(cumle.substring(0, i), cumle.substring(i + k.length),
          cumle.substring(i, i + k.length), sec);
    }
    return null;
  }
}

class BoslukDoldurma extends StatefulWidget {
  final BoslukSorusu soru;
  const BoslukDoldurma({super.key, required this.soru});
  @override
  State<BoslukDoldurma> createState() => _BoslukDoldurmaState();
}

class _BoslukDoldurmaState extends State<BoslukDoldurma> {
  String? _secim;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = widget.soru;
    final dogru = _secim == null ? null : _secim == s.cevap;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t.hkBoslukYonerge, style: const TextStyle(color: Colors.black54)),
      const SizedBox(height: 8),
      Text.rich(TextSpan(
          style: const TextStyle(fontSize: 15.5, height: 1.6),
          children: [
            TextSpan(text: s.once),
            TextSpan(
                text: _secim ?? ' ______ ',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: dogru == null
                        ? HkRenk.altin
                        : dogru
                            ? _yesil
                            : _kirmizi)),
            TextSpan(text: s.sonra),
          ])),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final o in s.secenekler)
          ChoiceChip(
            label: Text(o),
            selected: _secim == o,
            onSelected: (_) => setState(() => _secim = o),
          ),
      ]),
      if (dogru == false) ...[
        const SizedBox(height: 6),
        Text(t.hkDogruCevap(s.cevap),
            style:
                const TextStyle(color: _kirmizi, fontWeight: FontWeight.w700)),
      ],
      if (dogru == true) ...[
        const SizedBox(height: 6),
        Text('✓ ${t.hkDogru}',
            style: const TextStyle(color: _yesil, fontWeight: FontWeight.w700)),
      ],
    ]);
  }
}

/// Basligi ozuyle eslestirme (bu ders + ayni konudan en fazla 3 ders).
class HakikatEslestirme extends StatefulWidget {
  final List<RisaleDersi> dersler;
  const HakikatEslestirme({super.key, required this.dersler});
  @override
  State<HakikatEslestirme> createState() => _HakikatEslestirmeState();
}

class _HakikatEslestirmeState extends State<HakikatEslestirme> {
  final Map<String, String> _eslesme = {}; // baslik id -> ozet id
  String? _secili;
  bool _kontrol = false;

  late final List<RisaleDersi> _ozetler = List.of(widget.dersler)
    ..sort((a, b) => b.ders.length.compareTo(a.ders.length));

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tamam = _eslesme.length == widget.dersler.length;
    final dogruSayisi = _eslesme.entries.where((e) => e.key == e.value).length;
    Color renk(String baslikId) => !_kontrol
        ? HkRenk.lacivert
        : _eslesme[baslikId] == baslikId
            ? _yesil
            : _kirmizi;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(t.hkEslestirYonerge, style: const TextStyle(color: Colors.black54)),
      const SizedBox(height: 8),
      for (final d in widget.dersler)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Material(
            color: _secili == d.id
                ? HkRenk.altin.withValues(alpha: 0.15)
                : HkRenk.kirikBeyaz,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: renk(d.id).withValues(alpha: 0.5))),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _kontrol ? null : () => setState(() => _secili = d.id),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.baslik,
                          style: TextStyle(
                              fontWeight: FontWeight.w800, color: renk(d.id))),
                      if (_eslesme[d.id] case final o?)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                              '→ ${widget.dersler.firstWhere((x) => x.id == o).ders}',
                              style: const TextStyle(fontSize: 12.5)),
                        )
                      else if (_secili == d.id)
                        Text('↓ ${t.hkSec}',
                            style: const TextStyle(
                                fontSize: 12, color: HkRenk.altin)),
                    ]),
              ),
            ),
          ),
        ),
      const Divider(height: 24),
      for (final o in _ozetler)
        if (!_eslesme.containsValue(o.id))
          _secenek(o.ders,
              secili: false,
              dogru: null,
              onTap: _secili == null
                  ? null
                  : () => setState(() {
                        _eslesme[_secili!] = o.id;
                        _secili = null;
                      })),
      const SizedBox(height: 10),
      Row(children: [
        if (_kontrol)
          Expanded(
              child: Text(
                  dogruSayisi == widget.dersler.length
                      ? t.hkTebrik
                      : t.hkTestSonuc(dogruSayisi, widget.dersler.length),
                  style: const TextStyle(fontWeight: FontWeight.w800)))
        else
          const Spacer(),
        if (!_kontrol)
          FilledButton(
              onPressed: tamam ? () => setState(() => _kontrol = true) : null,
              child: Text(t.hkKontrolEt))
        else
          TextButton(
              onPressed: () => setState(() {
                    _eslesme.clear();
                    _kontrol = false;
                  }),
              child: Text(t.hkYenidenDene)),
      ]),
    ]);
  }
}
