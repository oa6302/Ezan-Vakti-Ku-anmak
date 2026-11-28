// Dua ezberi: 1) oku ve tekrar et, 2) hafizadan hatirla (aralikli tekrar
// kaydi), 3) bosluk doldur, 4) eslestir. Metinler ortali; Arapca RTL.
// Sorular yalniz duanin kendi parcalarindan uretilir.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/dua_ezber_servisi.dart';
import 'package:nur_pusulasi/app/gunluk_plan.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';

import 'dua_gorunum.dart';
import 'dua_okuma_page.dart';

const _yesil = Color(0xFF2E7D32);
const _kirmizi = Color(0xFFB71C1C);

class DuaEzberPage extends StatefulWidget {
  final DuaGorunum dua;
  const DuaEzberPage({super.key, required this.dua});
  @override
  State<DuaEzberPage> createState() => _DuaEzberPageState();
}

class _DuaEzberPageState extends State<DuaEzberPage> {
  late final List<EzberParcasi> _p = ezberParcalari(widget.dua);
  final Map<int, int> _tekrar = {};
  int _hatirlaSira = 0;
  bool _hatirlaAcik = false;
  final Map<int, bool> _hatirlaSonuc = {};
  DuaEzberServisi get _ez => DuaEzberServisi.instance;

  @override
  void initState() {
    super.initState();
    _ez.yukle().then((_) => _ez.eskiKaydiAktar(widget.dua.id));
  }

  bool get _eslesmeVar =>
      _p.where((x) => _sol(x).isNotEmpty && x.anlam.isNotEmpty).length >= 2;

  String _sol(EzberParcasi x) => x.arapca.isNotEmpty ? x.arapca : x.okunus;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final sekmeler = [
      (Icons.repeat_rounded, t.dkAdimOku),
      (Icons.psychology_rounded, t.dkAdimHatirla),
      (Icons.edit_note_rounded, t.dkAdimBosluk),
      if (_eslesmeVar) (Icons.compare_arrows_rounded, t.dkAdimEslestir),
    ];
    return ListenableBuilder(
      listenable: _ez,
      builder: (context, _) {
        final p = _ez.geceModu ? DuaPalet.gece : DuaPalet.gunduz;
        return DefaultTabController(
          length: sekmeler.length,
          child: Scaffold(
            backgroundColor: p.zemin,
            appBar: AppBar(
              backgroundColor: p.zemin,
              foregroundColor: p.metin,
              surfaceTintColor: Colors.transparent,
              title: Text('${t.dkEzberBaslik} · ${widget.dua.baslik}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: p.metin, fontSize: 15)),
              bottom: TabBar(
                isScrollable: true,
                labelColor: p.altin,
                unselectedLabelColor: p.ikincil,
                indicatorColor: p.altin,
                tabs: [
                  for (final (i, (ikon, ad)) in sekmeler.indexed)
                    Tab(icon: Icon(ikon, size: 20), text: '${i + 1}. $ad'),
                ],
              ),
            ),
            body: TabBarView(children: [
              _sayfa(p, _okuTekrar(t, p)),
              _sayfa(p, _hatirla(t, p)),
              _sayfa(p, _BoslukDoldur(parcalar: _p, palet: p)),
              if (_eslesmeVar)
                _sayfa(p, _Eslestir(parcalar: _p, palet: p, sol: _sol)),
            ]),
          ),
        );
      },
    );
  }

  Widget _sayfa(DuaPalet p, Widget c) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680), child: c)),
        ],
      );

  Widget _parcaMetni(DuaPalet p, EzberParcasi x, {bool arapcaGizli = false}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (x.arapca.isNotEmpty && !arapcaGizli)
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(x.arapca,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: arapcaYaziTipi(),
                    fontSize: _ez.arapcaBoyut,
                    height: 2.0,
                    color: p.metin)),
          ),
        if (x.okunus.isNotEmpty && !arapcaGizli) ...[
          const SizedBox(height: 6),
          Text(x.okunus,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: p.metin,
                  fontSize: _ez.okunusBoyut - 2,
                  fontStyle: FontStyle.italic,
                  height: 1.5)),
        ],
        if (x.anlam.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(x.anlam,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: p.ikincil, fontSize: _ez.anlamBoyut - 2, height: 1.5)),
        ],
      ]);

  BoxDecoration _kutu(DuaPalet p) => BoxDecoration(
        color: p.kart,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.kenar),
      );

  Widget _ilerleme(AppLocalizations t, DuaPalet p) {
    final k = _ez.kayit(widget.dua.id);
    final tarih = k.sonrakiTekrar == null
        ? null
        : MaterialLocalizations.of(context).formatMediumDate(
            GunlukPlanServisi.anahtardanTarih(k.sonrakiTekrar!));
    return Column(children: [
      LinearProgressIndicator(
          value: _p.isEmpty ? 0 : k.parcalar.length / _p.length,
          minHeight: 6,
          borderRadius: BorderRadius.circular(6),
          color: p.altin,
          backgroundColor: p.kenar),
      const SizedBox(height: 6),
      Text(
          [
            _ez.tamamlandiMi(widget.dua.id, _p.length)
                ? t.dkEzberTamam
                : t.dkIlerleme(k.parcalar.length, _p.length),
            if (tarih != null) t.dkSonrakiTekrar(tarih),
          ].join(' · '),
          textAlign: TextAlign.center,
          style: TextStyle(color: p.ikincil, fontSize: 12.5)),
      const SizedBox(height: 12),
    ]);
  }

  Widget _okuTekrar(AppLocalizations t, DuaPalet p) {
    final k = _ez.kayit(widget.dua.id);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _ilerleme(t, p),
      if (_p.length == 1)
        Text(t.dkParcaYok,
            textAlign: TextAlign.center, style: TextStyle(color: p.ikincil)),
      for (final (i, x) in _p.indexed)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: _kutu(p),
          child: Column(children: [
            Text(t.dkParca(i + 1, _p.length),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: p.altin,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1)),
            const SizedBox(height: 8),
            _parcaMetni(p, x),
            const SizedBox(height: 10),
            Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  OutlinedButton.icon(
                    onPressed: (_tekrar[i] ?? 0) >= 3
                        ? null
                        : () =>
                            setState(() => _tekrar[i] = (_tekrar[i] ?? 0) + 1),
                    icon: const Icon(Icons.replay_rounded, size: 18),
                    label: Text(
                        '${t.dkTekrarEt} · ${t.dkTekrar(_tekrar[i] ?? 0)}'),
                  ),
                  FilterChip(
                    selected: k.parcalar.contains(i),
                    onSelected: (_) => _ez.parcaDegistir(widget.dua.id, i),
                    label: Text(t.dkEzberledim),
                    avatar: k.parcalar.contains(i)
                        ? const Icon(Icons.check_rounded, size: 16)
                        : null,
                  ),
                ]),
          ]),
        ),
    ]);
  }

  Widget _hatirla(AppLocalizations t, DuaPalet p) {
    final bitti = _hatirlaSira >= _p.length;
    if (bitti) {
      final basarili = _hatirlaSonuc.length == _p.length &&
          !_hatirlaSonuc.containsValue(false);
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _ilerleme(t, p),
        Icon(basarili ? Icons.emoji_events_rounded : Icons.refresh_rounded,
            size: 48, color: basarili ? p.altin : p.ikincil),
        const SizedBox(height: 8),
        Text(basarili ? t.dkTekrarBasarili : t.dkTekrarBasarisiz,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: p.metin, fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: () async {
            await _ez.tekrarYapildi(widget.dua.id, basarili: basarili);
            if (!mounted) return;
            setState(() {
              _hatirlaSira = 0;
              _hatirlaSonuc.clear();
              _hatirlaAcik = false;
            });
          },
          child: Text(t.dkTekrarSonuc),
        ),
      ]);
    }
    final x = _p[_hatirlaSira];
    final ipucu =
        x.arapca.isNotEmpty ? (x.anlam.isNotEmpty ? x.anlam : x.okunus) : '';
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _ilerleme(t, p),
      Text(t.dkParca(_hatirlaSira + 1, _p.length),
          textAlign: TextAlign.center,
          style: TextStyle(color: p.altin, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: _kutu(p),
        child: Column(children: [
          if (ipucu.isNotEmpty) ...[
            Text(ipucu,
                textAlign: TextAlign.center,
                style: TextStyle(color: p.ikincil, height: 1.5)),
            const SizedBox(height: 12),
          ],
          if (_hatirlaAcik)
            _parcaMetni(p, x)
          else
            OutlinedButton.icon(
              onPressed: () => setState(() => _hatirlaAcik = true),
              icon: const Icon(Icons.visibility_rounded),
              label: Text(
                  '${t.dkGizliMetin.split('·').first.trim()} · ${t.dkGoster}'),
            ),
        ]),
      ),
      const SizedBox(height: 14),
      if (_hatirlaAcik)
        Row(children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: _kirmizi),
              onPressed: () => setState(() {
                _hatirlaSonuc[_hatirlaSira] = false;
                _hatirlaSira++;
                _hatirlaAcik = false;
              }),
              child: Text(t.dkTekrarGerek, textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _yesil),
              onPressed: () => setState(() {
                _hatirlaSonuc[_hatirlaSira] = true;
                _hatirlaSira++;
                _hatirlaAcik = false;
              }),
              child: Text(t.dkBiliyorum, textAlign: TextAlign.center),
            ),
          ),
        ]),
    ]);
  }
}

/// Her parcanin en uzun kelimesi bosaltilir; secenekler diger parcalardan.
class _BoslukDoldur extends StatefulWidget {
  final List<EzberParcasi> parcalar;
  final DuaPalet palet;
  const _BoslukDoldur({required this.parcalar, required this.palet});
  @override
  State<_BoslukDoldur> createState() => _BoslukDoldurState();
}

class _BoslukDoldurState extends State<_BoslukDoldur> {
  final Map<int, String> _secim = {};

  static String _metin(EzberParcasi x) => x.arapca.isNotEmpty
      ? x.arapca
      : (x.okunus.isNotEmpty ? x.okunus : x.anlam);

  static List<String> _kelimeler(String s) =>
      s.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  static String _temiz(String w) =>
      w.replaceAll(RegExp(r'''[.,;:!?“”"'()«»،؛]'''), '');

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = widget.palet;
    final havuz = <String>{
      for (final x in widget.parcalar)
        for (final w in _kelimeler(_metin(x)))
          if (_temiz(w).length > 2) _temiz(w)
    }.toList()
      ..sort();
    final sorular = <Widget>[];
    for (final (i, x) in widget.parcalar.indexed) {
      final metin = _metin(x);
      final k = _kelimeler(metin);
      if (k.length < 3) continue;
      var hedef = 0;
      for (var j = 1; j < k.length; j++) {
        if (_temiz(k[j]).length > _temiz(k[hedef]).length) hedef = j;
      }
      final cevap = _temiz(k[hedef]);
      if (cevap.length < 2) continue;
      final digerleri = havuz.where((w) => w != cevap).toList();
      final secenek = <String>{
        cevap,
        for (var j = 0; j < digerleri.length && j < 3; j++)
          digerleri[(i * 5 + j * 7) % digerleri.length],
      }.toList()
        ..sort();
      final rtl = x.arapca.isNotEmpty;
      final secili = _secim[i];
      final dogru = secili == null ? null : secili == cevap;
      final cumle = [
        for (var j = 0; j < k.length; j++)
          j == hedef ? (secili ?? '_____') : k[j]
      ].join(' ');
      sorular.add(Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: p.kart,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: dogru == null
                    ? p.kenar
                    : dogru
                        ? _yesil
                        : _kirmizi)),
        child: Column(children: [
          Directionality(
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            child: Text(cumle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: rtl ? arapcaYaziTipi() : null,
                    fontSize: rtl ? 24 : 16,
                    height: rtl ? 2.0 : 1.6,
                    color: p.metin)),
          ),
          const SizedBox(height: 10),
          Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in secenek)
                  ChoiceChip(
                    label: Text(s,
                        style: TextStyle(
                            fontFamily: rtl ? arapcaYaziTipi() : null,
                            fontSize: rtl ? 18 : 14)),
                    selected: secili == s,
                    onSelected: (_) => setState(() => _secim[i] = s),
                  ),
              ]),
          if (dogru == false) ...[
            const SizedBox(height: 6),
            Text(t.dkDogrusu(cevap),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: _kirmizi, fontWeight: FontWeight.w700)),
          ],
          if (dogru == true) ...[
            const SizedBox(height: 6),
            Text('✓ ${t.dkDogru}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: _yesil, fontWeight: FontWeight.w700)),
          ],
        ]),
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(t.dkBoslukYonerge,
          textAlign: TextAlign.center, style: TextStyle(color: p.ikincil)),
      const SizedBox(height: 12),
      if (sorular.isEmpty)
        Text(t.dkParcaYok,
            textAlign: TextAlign.center, style: TextStyle(color: p.ikincil))
      else
        ...sorular,
      if (_secim.isNotEmpty)
        TextButton(
            onPressed: () => setState(_secim.clear), child: Text(t.dkYeniden)),
    ]);
  }
}

/// Parca (Arapca/okunus) ile anlamini eslestirme.
class _Eslestir extends StatefulWidget {
  final List<EzberParcasi> parcalar;
  final DuaPalet palet;
  final String Function(EzberParcasi) sol;
  const _Eslestir(
      {required this.parcalar, required this.palet, required this.sol});
  @override
  State<_Eslestir> createState() => _EslestirState();
}

class _EslestirState extends State<_Eslestir> {
  final Map<int, int> _eslesme = {};
  int? _secili;
  bool _kontrol = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = widget.palet;
    final l = [
      for (final (i, x) in widget.parcalar.indexed)
        if (widget.sol(x).isNotEmpty && x.anlam.isNotEmpty) i
    ].take(6).toList();
    final sag = [...l]..sort((a, b) => widget.parcalar[b].anlam.length
        .compareTo(widget.parcalar[a].anlam.length));
    Color renk(int i) => !_kontrol
        ? (_secili == i ? p.altin : p.kenar)
        : (_eslesme[i] == i ? _yesil : _kirmizi);
    final dogru = _eslesme.entries.where((e) => e.key == e.value).length;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(t.dkEslestirYonerge,
          textAlign: TextAlign.center, style: TextStyle(color: p.ikincil)),
      const SizedBox(height: 12),
      for (final i in l)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _kontrol ? null : () => setState(() => _secili = i),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: p.kart,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: renk(i), width: 1.4)),
              child: Column(children: [
                Directionality(
                  textDirection: widget.parcalar[i].arapca.isNotEmpty
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Text(widget.sol(widget.parcalar[i]),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: widget.parcalar[i].arapca.isNotEmpty
                              ? arapcaYaziTipi()
                              : null,
                          fontSize:
                              widget.parcalar[i].arapca.isNotEmpty ? 22 : 15,
                          height: 1.8,
                          color: p.metin)),
                ),
                if (_eslesme[i] case final j?)
                  Text('→ ${widget.parcalar[j].anlam}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: p.ikincil, fontSize: 13)),
              ]),
            ),
          ),
        ),
      Divider(color: p.kenar, height: 24),
      for (final j in sag)
        if (!_eslesme.containsValue(j))
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: p.metin,
                  side: BorderSide(color: p.kenar),
                  padding: const EdgeInsets.all(12)),
              onPressed: _secili == null
                  ? null
                  : () => setState(() {
                        _eslesme[_secili!] = j;
                        _secili = null;
                      }),
              child:
                  Text(widget.parcalar[j].anlam, textAlign: TextAlign.center),
            ),
          ),
      const SizedBox(height: 8),
      if (_kontrol)
        Text(dogru == l.length ? '✓ ${t.dkDogru}' : '$dogru/${l.length}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: dogru == l.length ? _yesil : _kirmizi,
                fontWeight: FontWeight.w800)),
      Center(
        child: _kontrol
            ? TextButton(
                onPressed: () => setState(() {
                      _eslesme.clear();
                      _kontrol = false;
                    }),
                child: Text(t.dkYeniden))
            : FilledButton(
                onPressed: _eslesme.length == l.length
                    ? () => setState(() => _kontrol = true)
                    : null,
                child: Text(t.dkKontrol)),
      ),
    ]);
  }
}
