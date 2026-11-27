// Risale-i Nur / Hakikat yonetimi: tarih secimi (bugun otomatik, gunluk plan
// anahtariyla ayni), Gunun Hakikati planlama, kayit ekleme/duzenleme/onizleme,
// taslak-yayinda-arsiv durumlari. Her kayit benzersiz id; bir tarihin plani
// baska tarihi etkilemez.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/gunluk_plan.dart';
import 'package:nur_pusulasi/app/hakikat_servisi.dart';
import 'package:nur_pusulasi/data/hakikat.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/features/hazine/hakikat/hakikat_ortak.dart';
import 'package:nur_pusulasi/features/hazine/risale_dersleri_page.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/widgets/nur_kart.dart';

class HakikatYonetimPage extends StatefulWidget {
  final DateTime? tarih;
  const HakikatYonetimPage({super.key, this.tarih});
  @override
  State<HakikatYonetimPage> createState() => _HakikatYonetimPageState();
}

class _HakikatYonetimPageState extends State<HakikatYonetimPage> {
  late DateTime _gun = GunlukPlanServisi.gun(widget.tarih ?? DateTime.now());
  late final Future<void> _hazir = hakikatHazirla();
  final _ara = TextEditingController();
  HakikatDurumu? _filtre;

  HakikatServisi get _s => HakikatServisi.instance;

  @override
  void dispose() {
    _ara.dispose();
    super.dispose();
  }

  void _bildir(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _tarihSec() async {
    final g = await showDatePicker(
      context: context,
      initialDate: _gun,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (g != null && mounted) setState(() => _gun = GunlukPlanServisi.gun(g));
  }

  Future<void> _planSec(AppLocalizations t) async {
    final secim = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(t.hkPlanSec),
        children: [
          for (final d in _s.yayindakiler)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, d.id),
              child: Text('${d.baslik}  ·  ${d.id}'),
            ),
        ],
      ),
    );
    if (secim == null) return;
    await _s.planla(_gun, secim);
    _bildir(t.hkKaydedildi);
  }

  Future<void> _duzenle(RisaleDersi? d) async {
    await Navigator.push(context,
        MaterialPageRoute<void>(builder: (_) => HakikatDuzenlePage(ders: d)));
  }

  void _onizle(RisaleDersi d) => Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (_) => RisaleDersPage(ders: d, onizleme: true)));

  Future<void> _sil(AppLocalizations t, RisaleDersi d) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(d.baslik),
        content: Text(t.hkSilOnay),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t.hkVazgec)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(t.hkSil)),
        ],
      ),
    );
    if (ok == true) await _s.sil(d.id);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: NurRenk.gri,
      appBar: AppBar(
        title: Text(t.hkYonetim),
        actions: [
          IconButton(
              tooltip: t.hkYeni,
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _duzenle(null)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _duzenle(null),
        icon: const Icon(Icons.add_rounded),
        label: Text(t.hkYeni),
      ),
      body: FutureBuilder<void>(
        future: _hazir,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListenableBuilder(
              listenable: _s, builder: (context, _) => _govde(t));
        },
      ),
    );
  }

  Widget _govde(AppLocalizations t) {
    final planli = _s.planliId(_gun);
    final gunun = _s.gununHakikati(_gun);
    final q = _ara.text;
    final liste = _s.tumu
        .where((d) =>
            (_filtre == null || _s.durum(d.id) == _filtre) &&
            aramaEslesir('${d.baslik} ${d.id} ${d.kaynaklar.join(' ')}', q))
        .toList();
    final tarihYazi = MaterialLocalizations.of(context).formatFullDate(_gun);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        NurKart(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () => setState(
                      () => _gun = _gun.subtract(const Duration(days: 1)))),
              Expanded(
                child: InkWell(
                  onTap: _tarihSec,
                  child: Column(children: [
                    Text(tarihYazi,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: NurRenk.lacivert)),
                    Text(GunlukPlanServisi.tarihAnahtari(_gun),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ]),
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () =>
                      setState(() => _gun = _gun.add(const Duration(days: 1)))),
            ]),
            const Divider(),
            Row(children: [
              const Icon(Icons.wb_sunny_rounded, color: HkRenk.altin),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(t.hkGununHakikati,
                      style: const TextStyle(fontWeight: FontWeight.w800))),
              _Cip(
                  metin: planli != null && gunun?.id == planli
                      ? t.hkPlanli
                      : t.hkPlanOtomatik,
                  renk: planli != null && gunun?.id == planli
                      ? const Color(0xFF2E7D32)
                      : Colors.blueGrey),
            ]),
            const SizedBox(height: 6),
            Text(gunun?.baslik ?? t.hkIcerikYok,
                style: const TextStyle(fontSize: 16, height: 1.35)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 4, children: [
              FilledButton.icon(
                  onPressed: () => _planSec(t),
                  icon: const Icon(Icons.event_available_rounded, size: 18),
                  label: Text(t.hkPlanSec)),
              if (planli != null)
                OutlinedButton(
                    onPressed: () => _s.planla(_gun, null),
                    child: Text(t.hkPlanKaldir)),
              if (gunun != null)
                TextButton(
                    onPressed: () => _onizle(gunun), child: Text(t.hkOnizle)),
            ]),
          ]),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _ara,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: t.hkAra,
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 6, children: [
          ChoiceChip(
              label: Text(t.hkTumu),
              selected: _filtre == null,
              onSelected: (_) => setState(() => _filtre = null)),
          for (final d in HakikatDurumu.values)
            ChoiceChip(
                label: Text(durumAdiHk(t, d)),
                selected: _filtre == d,
                onSelected: (_) => setState(() => _filtre = d)),
        ]),
        const SizedBox(height: 8),
        for (final d in liste) _satir(t, d),
      ],
    );
  }

  Widget _satir(AppLocalizations t, RisaleDersi d) {
    final durum = _s.durum(d.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NurKart(
        padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
        onTap: () => _duzenle(d),
        child: Row(children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d.baslik,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Wrap(spacing: 6, runSpacing: 4, children: [
                _Cip(metin: durumAdiHk(t, durum), renk: durumRengiHk(durum)),
                if (_s.duzenlendiMi(d.id))
                  _Cip(metin: t.hkDuzenlendi, renk: HkRenk.altin),
                Text(d.id,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black45)),
              ]),
            ]),
          ),
          PopupMenuButton<String>(
            onSelected: (v) async {
              switch (v) {
                case 'duzenle':
                  await _duzenle(d);
                case 'onizle':
                  _onizle(d);
                case 'yayinla':
                  await _s.durumDegistir(d.id, HakikatDurumu.yayinda);
                case 'taslak':
                  await _s.durumDegistir(d.id, HakikatDurumu.taslak);
                case 'arsiv':
                  await _s.durumDegistir(d.id, HakikatDurumu.arsiv);
                case 'geri':
                  await _s.duzenlemeyiGeriAl(d.id);
                case 'sil':
                  await _sil(t, d);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'duzenle', child: Text(t.hkDuzenle)),
              PopupMenuItem(value: 'onizle', child: Text(t.hkOnizle)),
              if (durum != HakikatDurumu.yayinda)
                PopupMenuItem(value: 'yayinla', child: Text(t.hkYayinla)),
              if (durum != HakikatDurumu.taslak)
                PopupMenuItem(value: 'taslak', child: Text(t.hkTaslakYap)),
              if (durum != HakikatDurumu.arsiv)
                PopupMenuItem(value: 'arsiv', child: Text(t.hkArsivle)),
              if (_s.duzenlendiMi(d.id))
                PopupMenuItem(value: 'geri', child: Text(t.hkGeriAl)),
              PopupMenuItem(value: 'sil', child: Text(t.hkSil)),
            ],
          ),
        ]),
      ),
    );
  }
}

class _Cip extends StatelessWidget {
  final String metin;
  final Color renk;
  const _Cip({required this.metin, required this.renk});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: renk.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: renk.withValues(alpha: 0.5))),
        child: Text(metin,
            style: TextStyle(
                color: renk, fontSize: 11, fontWeight: FontWeight.w700)),
      );
}

// ───────────────────────── Duzenleyici ─────────────────────────

class HakikatDuzenlePage extends StatefulWidget {
  final RisaleDersi? ders;
  const HakikatDuzenlePage({super.key, this.ders});
  @override
  State<HakikatDuzenlePage> createState() => _HakikatDuzenlePageState();
}

class _SoruAlani {
  final soru = TextEditingController();
  final secenek = TextEditingController();
  final dogru = TextEditingController(text: '1');
  void dispose() {
    soru.dispose();
    secenek.dispose();
    dogru.dispose();
  }
}

class _HakikatDuzenlePageState extends State<HakikatDuzenlePage> {
  final _form = GlobalKey<FormState>();
  late final String _id = widget.ders?.id ?? HakikatServisi.instance.yeniId();
  late final Map<String, TextEditingController> _c = {
    for (final k in _govdeAlanlari) k: TextEditingController(),
    for (final k in [
      'baslik',
      'kavram',
      'kaynak',
      'duaAr',
      'duaOk',
      'duaAn',
      'duaKa',
      'dy'
    ])
      k: TextEditingController(),
  };
  final List<_SoruAlani> _sorular = [_SoruAlani(), _SoruAlani(), _SoruAlani()];
  late RisaleKategori _kategori = widget.ders?.kategori ?? RisaleKategori.iman;
  late final Set<HakikatKonusu> _konular = {
    ...?widget.ders?.hakikatKonulari,
  };
  bool _dyDogru = true;

  static const _govdeAlanlari = [
    'giris',
    'aciklama',
    'risalePerspektifi',
    'kainattanDelil',
    'hayat',
    'hikmet',
    'kendimize',
    'tefekkurSorusu',
    'ders',
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.ders;
    if (d != null) {
      final j = d.toJson();
      for (final k in _govdeAlanlari) {
        _c[k]!.text = '${j[k] ?? ''}';
      }
      _c['baslik']!.text = d.baslik;
      _c['kavram']!.text = d.kavramlar.join(', ');
      _c['kaynak']!.text = d.kaynaklar.join('\n');
      _c['duaAr']!.text = d.dua.arapca;
      _c['duaOk']!.text = d.dua.okunus;
      _c['duaAn']!.text = d.dua.anlam;
      _c['duaKa']!.text = d.dua.kaynak;
      for (final (i, s) in d.sinav.take(3).indexed) {
        _sorular[i].soru.text = s.soru;
        _sorular[i].secenek.text = s.secenekler.join('\n');
        _sorular[i].dogru.text = '${s.dogru + 1}';
      }
      if (d.dogruYanlis.isNotEmpty) {
        _c['dy']!.text = d.dogruYanlis.first.ifade;
        _dyDogru = d.dogruYanlis.first.dogru;
      }
    }
    for (final k in _govdeAlanlari) {
      _c[k]!.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    for (final s in _sorular) {
      s.dispose();
    }
    super.dispose();
  }

  List<String> _satirlar(String k) => _c[k]!
      .text
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  RisaleDersi _olustur() => RisaleDersi(
        id: _id,
        kategori: _kategori,
        baslik: _c['baslik']!.text.trim(),
        giris: _c['giris']!.text.trim(),
        aciklama: _c['aciklama']!.text.trim(),
        risalePerspektifi: _c['risalePerspektifi']!.text.trim(),
        kainattanDelil: _c['kainattanDelil']!.text.trim(),
        hikmet: _c['hikmet']!.text.trim(),
        kendimize: _c['kendimize']!.text.trim(),
        hayat: _c['hayat']!.text.trim(),
        dua: KisaDua(_c['duaAr']!.text.trim(), _c['duaOk']!.text.trim(),
            _c['duaAn']!.text.trim(), _c['duaKa']!.text.trim()),
        ders: _c['ders']!.text.trim(),
        tefekkurSorusu: _c['tefekkurSorusu']!.text.trim(),
        kavramlar: _c['kavram']!
            .text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        kaynaklar: _satirlar('kaynak'),
        sinav: [
          for (final s in _sorular)
            if (s.soru.text.trim().isNotEmpty)
              () {
                final sec = s.secenek.text
                    .split('\n')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                final no = (int.tryParse(s.dogru.text.trim()) ?? 1) - 1;
                return CoktanSecmeli(s.soru.text.trim(), sec,
                    sec.isEmpty ? 0 : no.clamp(0, sec.length - 1));
              }(),
        ],
        dogruYanlis: [
          if (_c['dy']!.text.trim().isNotEmpty)
            DogruYanlis(_c['dy']!.text.trim(), _dyDogru),
        ],
        konular: [for (final k in _konular) k.name],
      );

  Future<void> _kaydet(AppLocalizations t, {HakikatDurumu? durum}) async {
    if (!(_form.currentState?.validate() ?? false)) return;
    final s = HakikatServisi.instance;
    await s.kaydetDers(_olustur(),
        yeniDurum:
            durum ?? (widget.ders == null ? HakikatDurumu.taslak : null));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.hkKaydedildi)));
    Navigator.pop(context);
  }

  String _etiket(AppLocalizations t, String k) => switch (k) {
        'giris' => t.hkTefekkurKapisi,
        'aciklama' => t.hkAciklama,
        'risalePerspektifi' => t.hkPerspektif,
        'kainattanDelil' => t.hkKainattan,
        'hayat' => t.hkGunlukHayat,
        'hikmet' => t.hkHikmet,
        'kendimize' => t.hkSorgula,
        'tefekkurSorusu' => t.hkUygula,
        _ => t.hkOgrenilen,
      };

  Widget _alan(String etiket, TextEditingController c,
          {int satir = 4,
          String? Function(String?)? dogrula,
          bool rtl = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: c,
          minLines: 1,
          maxLines: satir,
          textDirection: rtl ? TextDirection.rtl : null,
          validator: dogrula,
          decoration: InputDecoration(
              labelText: etiket,
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    String? zorunlu(String? v) => (v ?? '').trim().isEmpty ? t.hkZorunlu : null;
    final govde = _govdeAlanlari.map((k) => _c[k]!.text.trim()).join('\n');
    final uygun = govde.length >= 2800 && govde.length <= 3200;
    final kaynaklar = _satirlar('kaynak');
    return Scaffold(
      backgroundColor: NurRenk.gri,
      appBar: AppBar(
        title: Text(widget.ders == null ? t.hkYeni : t.hkDuzenle),
        actions: [
          IconButton(
            tooltip: t.hkOnizle,
            icon: const Icon(Icons.visibility_rounded),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) =>
                        RisaleDersPage(ders: _olustur(), onizleme: true))),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () => _kaydet(t), child: Text(t.hkKaydet))),
            const SizedBox(width: 10),
            Expanded(
                child: FilledButton(
                    onPressed: () => _kaydet(t, durum: HakikatDurumu.yayinda),
                    child: Text(t.hkYayinla))),
          ]),
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            HkGovde(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(t.hkKaynakUyari,
                        style: const TextStyle(
                            color: Color(0xFFB26A00),
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Text(_id,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black45)),
                    const SizedBox(height: 6),
                    _alan(t.hkAlanBaslik, _c['baslik']!,
                        satir: 2, dogrula: zorunlu),
                    DropdownButtonFormField<RisaleKategori>(
                      initialValue: _kategori,
                      isExpanded: true,
                      decoration: InputDecoration(
                          labelText: t.hkAlanKategori,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      items: [
                        for (final k in RisaleKategori.values)
                          DropdownMenuItem(
                              value: k,
                              child:
                                  Text(k.ad, overflow: TextOverflow.ellipsis)),
                      ],
                      onChanged: (k) =>
                          setState(() => _kategori = k ?? _kategori),
                    ),
                    HkBolumBasligi(t.hkKonular),
                    Wrap(spacing: 6, runSpacing: 6, children: [
                      for (final k in HakikatKonusu.values)
                        FilterChip(
                          label: Text(konuAdi(t, k),
                              style: const TextStyle(fontSize: 12)),
                          selected: _konular.contains(k),
                          onSelected: (v) => setState(
                              () => v ? _konular.add(k) : _konular.remove(k)),
                        ),
                    ]),
                    HkBolumBasligi(t.hkIlgiliEserler),
                    Wrap(spacing: 6, runSpacing: 6, children: [
                      for (final e in risaleKulliyati)
                        () {
                          final satir =
                              'Bediüzzaman Said Nursî, ${e.konum.isEmpty ? e.ad : e.konum.split(' (').first.replaceAll(' · ', ', ')}';
                          final secili = kaynaklar.contains(satir);
                          return FilterChip(
                            label: Text(e.ad,
                                style: const TextStyle(fontSize: 12)),
                            selected: secili,
                            onSelected: (v) => setState(() {
                              final l = _satirlar('kaynak');
                              v ? l.add(satir) : l.remove(satir);
                              _c['kaynak']!.text = l.join('\n');
                            }),
                          );
                        }(),
                    ]),
                    const SizedBox(height: 16),
                    Text(t.hkKarakter(govde.length),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: uygun
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFB26A00))),
                    const SizedBox(height: 8),
                    for (final k in _govdeAlanlari)
                      _alan(_etiket(t, k), _c[k]!,
                          satir: k == 'tefekkurSorusu' || k == 'ders' ? 3 : 10,
                          dogrula: k == 'ders' ? zorunlu : null),
                    _alan(t.hkAlanKavram, _c['kavram']!, satir: 2),
                    _alan(t.hkAlanKaynak, _c['kaynak']!, satir: 8),
                    HkBolumBasligi(t.hkDua),
                    _alan(t.hkAlanDuaArapca, _c['duaAr']!, satir: 4, rtl: true),
                    _alan(t.hkAlanDuaOkunus, _c['duaOk']!, satir: 3),
                    _alan(t.hkAlanDuaAnlam, _c['duaAn']!, satir: 4),
                    _alan(t.hkAlanDuaKaynak, _c['duaKa']!, satir: 1),
                    HkBolumBasligi(t.hkMiniTest),
                    for (final (i, s) in _sorular.indexed) ...[
                      _alan(t.hkAlanSoru(i + 1), s.soru, satir: 2),
                      _alan(t.hkAlanSecenek, s.secenek, satir: 5),
                      _alan(t.hkAlanDogruNo, s.dogru, satir: 1),
                    ],
                    _alan(t.hkAlanDY, _c['dy']!, satir: 2),
                    SwitchListTile(
                      value: _dyDogru,
                      onChanged: (v) => setState(() => _dyDogru = v),
                      title: Text(t.hkAlanDYDogru),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
