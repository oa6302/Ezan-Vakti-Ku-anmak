// Secili gun + program icin icerik formu: taslak / yayimla / onizle.
// Yalniz hedef tarihin hucresi yazilir; baska gun ve programlar degismez.
import 'package:flutter/material.dart';

import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/gunluk_plan.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/widgets/nur_kart.dart';

import 'gunluk_yonetim_page.dart'
    show programAdi, programIkonu, kissaIcerigi, arsivdenSec;

/// Form alani: ContentItem'daki yeri ve etiketi.
enum _Alan { baslik, icerik, altIcerik, arapca, kaynak, kategori, hakikat }

class _AlanTanimi {
  final _Alan alan;
  final String Function(AppLocalizations) etiket;
  final bool zorunlu;
  final bool rtl;
  final int satir;
  const _AlanTanimi(this.alan, this.etiket,
      {this.zorunlu = false, this.rtl = false, this.satir = 1});
}

/// Her programin kendi alanlari (kartlarin okudugu yerlerle ayni).
List<_AlanTanimi> _alanlar(ContentType p) => switch (p) {
      ContentType.vecize => [
          _AlanTanimi(_Alan.altIcerik, (t) => t.ypAlanOsmanlica,
              zorunlu: true, rtl: true, satir: 3),
          _AlanTanimi(_Alan.icerik, (t) => t.ypAlanLatin,
              zorunlu: true, satir: 3),
          _AlanTanimi(_Alan.kaynak, (t) => t.ypAlanKaynak, zorunlu: true),
          _AlanTanimi(_Alan.hakikat, (t) => t.ypAlanHakikat, satir: 4),
          _AlanTanimi(_Alan.kategori, (t) => t.ypAlanKategori),
        ],
      ContentType.ayet => [
          _AlanTanimi(_Alan.arapca, (t) => t.ypAlanArapca,
              zorunlu: true, rtl: true, satir: 3),
          _AlanTanimi(_Alan.altIcerik, (t) => t.ypAlanMeal,
              zorunlu: true, satir: 4),
          _AlanTanimi(_Alan.kaynak, (t) => t.ypAlanKaynak, zorunlu: true),
          _AlanTanimi(_Alan.hakikat, (t) => t.ypAlanHakikat, satir: 3),
          _AlanTanimi(_Alan.kategori, (t) => t.ypAlanKategori),
        ],
      ContentType.hadis => [
          _AlanTanimi(_Alan.icerik, (t) => t.ypAlanHadisMetni,
              zorunlu: true, satir: 5),
          _AlanTanimi(_Alan.kaynak, (t) => t.ypAlanKaynak, zorunlu: true),
          _AlanTanimi(_Alan.altIcerik, (t) => t.ypAlanNumara),
          _AlanTanimi(_Alan.hakikat, (t) => t.ypAlanHakikat, satir: 3),
          _AlanTanimi(_Alan.kategori, (t) => t.ypAlanKategori),
        ],
      ContentType.dua => [
          _AlanTanimi(_Alan.baslik, (t) => t.ypAlanBaslik, zorunlu: true),
          _AlanTanimi(_Alan.arapca, (t) => t.ypAlanArapca, rtl: true, satir: 3),
          _AlanTanimi(_Alan.icerik, (t) => t.ypAlanOkunus, satir: 3),
          _AlanTanimi(_Alan.altIcerik, (t) => t.ypAlanAnlam,
              zorunlu: true, satir: 4),
          _AlanTanimi(_Alan.kaynak, (t) => t.ypAlanKaynak, zorunlu: true),
          _AlanTanimi(_Alan.kategori, (t) => t.ypAlanKategori),
        ],
      ContentType.risale => [
          _AlanTanimi(_Alan.baslik, (t) => t.ypAlanBaslik, zorunlu: true),
          _AlanTanimi(_Alan.arapca, (t) => t.ypAlanOsmanlica,
              rtl: true, satir: 3),
          _AlanTanimi(_Alan.icerik, (t) => t.ypAlanMetin,
              zorunlu: true, satir: 6),
          _AlanTanimi(_Alan.kaynak, (t) => t.ypAlanKaynak, zorunlu: true),
          _AlanTanimi(_Alan.hakikat, (t) => t.ypAlanHakikat, satir: 4),
          _AlanTanimi(_Alan.kategori, (t) => t.ypAlanKategori),
        ],
      _ => const [],
    };

String _oku(ContentItem? i, _Alan a) {
  if (i == null) return '';
  return switch (a) {
        _Alan.baslik => i.baslik,
        _Alan.icerik => i.icerik,
        _Alan.altIcerik => i.altIcerik,
        _Alan.arapca => i.arapca,
        _Alan.kaynak => i.kaynak,
        _Alan.kategori => i.kategori,
        _Alan.hakikat => i.extra?['hakikat']?.toString(),
      } ??
      '';
}

class PlanDuzenlePage extends StatefulWidget {
  final ContentType program;
  final DateTime tarih;
  final ContentItem? baslangic;

  /// true: [tarih] gunundeki mevcut plan kaydi duzenleniyor.
  final bool mevcutKayit;
  const PlanDuzenlePage(
      {super.key,
      required this.program,
      required this.tarih,
      this.baslangic,
      this.mevcutKayit = false});

  @override
  State<PlanDuzenlePage> createState() => _PlanDuzenlePageState();
}

class _PlanDuzenlePageState extends State<PlanDuzenlePage> {
  final _form = GlobalKey<FormState>();
  late final Map<_Alan, TextEditingController> _k = {
    for (final a in _Alan.values)
      a: TextEditingController(text: _oku(widget.baslangic, a))
  };
  late DateTime _yayinTarihi = GunlukPlanServisi.gun(widget.tarih);
  String? _kissaId;
  bool _kaydediliyor = false;

  @override
  void initState() {
    super.initState();
    _kissaId = widget.baslangic?.extra?['kissaId']?.toString();
  }

  @override
  void dispose() {
    for (final c in _k.values) {
      c.dispose();
    }
    super.dispose();
  }

  ContentItem _icerik() {
    final p = widget.program;
    final anahtar = GunlukPlanServisi.tarihAnahtari(_yayinTarihi);
    if (p == ContentType.kissa) {
      final k = islamiKissalar.firstWhere((k) => k.id == _kissaId);
      final i = kissaIcerigi(k);
      return ContentItem(
          id: 'plan_${p.key}_$anahtar',
          type: p,
          baslik: i.baslik,
          icerik: i.icerik,
          kaynak: i.kaynak,
          kategori: i.kategori,
          custom: true,
          extra: i.extra,
          guncellenme: DateTime.now());
    }
    String v(_Alan a) => _k[a]!.text.trim();
    String? bos(String s) => s.isEmpty ? null : s;
    final baslik = switch (p) {
      ContentType.ayet => v(_Alan.kaynak),
      ContentType.hadis || ContentType.vecize => v(_Alan.kategori).isEmpty
          ? programAdi(AppLocalizations.of(context), p)
          : v(_Alan.kategori),
      _ => v(_Alan.baslik),
    };
    return ContentItem(
      id: 'plan_${p.key}_$anahtar',
      type: p,
      baslik: baslik,
      icerik: p == ContentType.ayet ? v(_Alan.arapca) : v(_Alan.icerik),
      altIcerik: bos(v(_Alan.altIcerik)),
      arapca: p == ContentType.hadis ? null : bos(v(_Alan.arapca)),
      kaynak: bos(v(_Alan.kaynak)),
      kategori: bos(v(_Alan.kategori)),
      custom: true,
      dogrulandi: false,
      kaynakTuru: KaynakTuru.elle,
      guncellenme: DateTime.now(),
      extra: {
        if (v(_Alan.hakikat).isNotEmpty) 'hakikat': v(_Alan.hakikat),
      },
    );
  }

  bool _gecerli() {
    if (widget.program == ContentType.kissa) return _kissaId != null;
    return _form.currentState?.validate() ?? false;
  }

  Future<void> _kaydet(ContentStatus durum) async {
    final t = AppLocalizations.of(context);
    if (!_gecerli()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.ypZorunlu)));
      return;
    }
    final plan = GunlukPlanServisi.instance;
    final p = widget.program;
    final hedef = _yayinTarihi;
    final kaynakGun = GunlukPlanServisi.gun(widget.tarih);
    final tasiniyor = !DateUtils.isSameDay(hedef, kaynakGun);

    // Hedef gunde baska kayit varsa: bilincli karar
    if ((tasiniyor || !widget.mevcutKayit) && plan.kayit(p, hedef) != null) {
      final secim = await showDialog<String>(
        context: context,
        builder: (c) => AlertDialog(
          content: Text(t.ypMevcutVar),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c), child: Text(t.ypVazgec)),
            TextButton(
                onPressed: () => Navigator.pop(c, 'duzenle'),
                child: Text(t.ypMevcutuDuzenle)),
            FilledButton(
                onPressed: () => Navigator.pop(c, 'yaz'),
                child: Text(t.ypUzerineYaz)),
          ],
        ),
      );
      if (!mounted || secim == null) return;
      if (secim == 'duzenle') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => PlanDuzenlePage(
                program: p,
                tarih: hedef,
                baslangic: plan.kayit(p, hedef)!.icerik,
                mevcutKayit: true),
          ),
        );
        return;
      }
    }

    final icerik = _icerik();
    // Ayni metin baska gunlerde kullaniliyorsa bilgi ver, bilincli devam
    final ayni = plan.ayniMetinTarihleri(p, icerik.icerik,
        haric: GunlukPlanServisi.tarihAnahtari(hedef));
    if (ayni.isNotEmpty && p != ContentType.kissa) {
      final devam = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          content: Text('${t.ypAyniMetin}\n${ayni.take(6).join(', ')}'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: Text(t.ypVazgec)),
            FilledButton(
                onPressed: () => Navigator.pop(c, true),
                child: Text(t.ypKaydet)),
          ],
        ),
      );
      if (!mounted || devam != true) return;
    }

    setState(() => _kaydediliyor = true);
    final mesaj = ScaffoldMessenger.of(context);
    try {
      await plan.kaydet(p, hedef, icerik, durum);
      // Yayin tarihi degistirildiyse eski gunun kaydi tasinir
      if (tasiniyor && widget.mevcutKayit) await plan.sil(p, kaynakGun);
      if (!mounted) return;
      mesaj.showSnackBar(SnackBar(content: Text(t.ypKaydedildi)));
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _kaydediliyor = false);
      mesaj.showSnackBar(SnackBar(content: Text(t.ypKayitHatasi)));
    }
  }

  Future<void> _tarihSec() async {
    final d = await showDatePicker(
        context: context,
        initialDate: _yayinTarihi,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100, 12, 31));
    if (d != null && mounted) setState(() => _yayinTarihi = d);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final ml = MaterialLocalizations.of(context);
    final p = widget.program;
    return Scaffold(
      backgroundColor: NurRenk.gri,
      appBar: AppBar(title: Text(programAdi(t, p))),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            NurKart(
              onTap: _tarihSec,
              child: NurKartBasligi(
                ikon: Icons.event_rounded,
                baslik: t.ypYayinTarihi,
                altBaslik: ml.formatFullDate(_yayinTarihi),
                sag: const Icon(Icons.edit_calendar_rounded,
                    color: NurRenk.kirmizi),
              ),
            ),
            const SizedBox(height: 14),
            if (p == ContentType.kissa)
              _kissaSecici(t)
            else
              for (final a in _alanlar(p)) ...[
                TextFormField(
                  controller: _k[a.alan],
                  minLines: a.satir,
                  maxLines: a.satir == 1 ? 1 : a.satir + 6,
                  textDirection: a.rtl ? TextDirection.rtl : null,
                  textAlign: a.rtl ? TextAlign.right : TextAlign.start,
                  style: a.rtl
                      ? const TextStyle(fontFamily: 'Matbu', fontSize: 20)
                      : null,
                  decoration: InputDecoration(
                    labelText: '${a.etiket(t)}${a.zorunlu ? ' *' : ''}',
                    alignLabelWithHint: a.satir > 1,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => a.zorunlu && (v ?? '').trim().isEmpty
                      ? t.ypZorunlu
                      : null,
                ),
                const SizedBox(height: 12),
              ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
          child: Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  if (_gecerli()) onizlemeGoster(context, p, _icerik());
                },
                icon: const Icon(Icons.visibility_rounded),
                label: Text(t.ypOnizle),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    _kaydediliyor ? null : () => _kaydet(ContentStatus.taslak),
                icon: const Icon(Icons.save_outlined),
                label: Text(t.ypTaslakKaydet),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: NurRenk.kirmizi),
                onPressed: _kaydediliyor
                    ? null
                    : () => _kaydet(ContentStatus.yayinlandi),
                icon: const Icon(Icons.publish_rounded),
                label: Text(t.ypYayimla),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _kissaSecici(AppLocalizations t) {
    final secili = islamiKissalar.where((k) => k.id == _kissaId);
    return NurKart(
      onTap: () async {
        final s = await arsivdenSec(context, ContentType.kissa);
        if (s != null && mounted) {
          setState(() => _kissaId = s.extra?['kissaId']?.toString());
        }
      },
      child: NurKartBasligi(
        ikon: Icons.history_edu_rounded,
        baslik: secili.isEmpty ? t.ypKissaSec : secili.first.baslik,
        altBaslik: secili.isEmpty ? null : secili.first.kaynak,
        sag: const Icon(Icons.search_rounded, color: NurRenk.kirmizi),
      ),
    );
  }
}

/// Kullanici kart diliyle onizleme (RTL metin, kaynak, kart duzeni).
void onizlemeGoster(BuildContext context, ContentType p, ContentItem i) {
  final t = AppLocalizations.of(context);
  final rtl = (p == ContentType.vecize ? i.altIcerik : i.arapca) ?? '';
  final ana = switch (p) {
    ContentType.ayet || ContentType.dua => i.altIcerik ?? '',
    _ => i.icerik,
  };
  final hakikat = i.extra?['hakikat']?.toString() ?? '';
  showDialog<void>(
    context: context,
    builder: (c) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: NurKart(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NurKartBasligi(
                ikon: programIkonu(p),
                baslik: programAdi(t, p).toUpperCase(),
                altBaslik: i.baslik,
                sag: IconButton(
                    onPressed: () => Navigator.pop(c),
                    icon: const Icon(Icons.close_rounded)),
              ),
              const SizedBox(height: 14),
              if (rtl.trim().isNotEmpty) ...[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'Matbu',
                          fontSize: 22,
                          height: 1.7,
                          color: NurRenk.lacivert)),
                ),
                const SizedBox(height: 12),
              ],
              if (p == ContentType.dua && i.icerik.trim().isNotEmpty) ...[
                Text(i.icerik,
                    style: const TextStyle(fontStyle: FontStyle.italic)),
                const SizedBox(height: 8),
              ],
              Text(ana, style: const TextStyle(fontSize: 15, height: 1.5)),
              if (hakikat.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(hakikat,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF475569))),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text('— ${i.kaynak ?? ''}',
                    style: const TextStyle(
                        color: NurRenk.kirmizi, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
