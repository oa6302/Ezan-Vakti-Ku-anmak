// Tarih bazli merkezi yonetim paneli: bugun otomatik secili, takvimden her gun
// secilebilir; secili gunun tum gunluk programlari tek ekranda yonetilir.
import 'package:flutter/material.dart';

import 'package:nur_pusulasi/app/admin_session.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/gunluk_plan.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/kissa_365_card.dart'
    show gununKissasi;
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/widgets/nur_kart.dart';

import 'content_manager_page.dart';
import 'hakikat_yonetim_page.dart';
import 'plan_duzenle_page.dart';

// ── Program ve durum yardimcilari ───────────────────────────────────────────
String programAdi(AppLocalizations t, ContentType p) => switch (p) {
      ContentType.vecize => t.ypProgVecize,
      ContentType.ayet => t.ypProgAyet,
      ContentType.hadis => t.ypProgHadis,
      ContentType.dua => t.ypProgDua,
      ContentType.kissa => t.ypProgKissa,
      ContentType.risale => t.ypProgRisale,
      _ => p.label,
    };

IconData programIkonu(ContentType p) => switch (p) {
      ContentType.vecize => Icons.format_quote_rounded,
      ContentType.ayet => Icons.menu_book_rounded,
      ContentType.hadis => Icons.forum_rounded,
      ContentType.dua => Icons.volunteer_activism_rounded,
      ContentType.kissa => Icons.history_edu_rounded,
      ContentType.risale => Icons.auto_stories_rounded,
      _ => Icons.article_rounded,
    };

String durumAdi(AppLocalizations t, PlanDurumu d) => switch (d) {
      PlanDurumu.otomatik => t.ypDurumOtomatik,
      PlanDurumu.taslak => t.ypDurumTaslak,
      PlanDurumu.yayinlandi => t.ypDurumYayinda,
      PlanDurumu.planlandi => t.ypDurumPlanli,
      PlanDurumu.arsivlendi => t.ypDurumArsiv,
    };

Color durumRengi(PlanDurumu d) => switch (d) {
      PlanDurumu.otomatik => const Color(0xFF94A3B8),
      PlanDurumu.taslak => const Color(0xFFE09B00),
      PlanDurumu.yayinlandi => const Color(0xFF1F9D6B),
      PlanDurumu.planlandi => const Color(0xFF2563EB),
      PlanDurumu.arsivlendi => const Color(0xFF7C6F92),
    };

/// Arsiv sirasinin o gune verdigi kayit (plan yoksa kullaniciya gosterilen).
ContentItem? otomatikIcerik(ContentType p, DateTime tarih) {
  if (p == ContentType.kissa) {
    if (islamiKissalar.isEmpty) return null;
    final gunNo = tarih.difference(DateTime(tarih.year, 1, 1)).inDays;
    final k = islamiKissalar[gunNo % islamiKissalar.length];
    return kissaIcerigi(k);
  }
  return ContentService.instance.otomatikGunlukKayit(p, tarih);
}

ContentItem kissaIcerigi(Kissa k) => ContentItem(
      id: 'kissa_${k.id}',
      type: ContentType.kissa,
      baslik: k.baslik,
      icerik: k.baslangic,
      kaynak: k.kaynak,
      kategori: k.kategori.ad,
      durum: ContentStatus.yayinlandi,
      extra: {'kissaId': k.id},
    );

/// Kullaniciya o gun gercekten gosterilen icerik.
ContentItem? gosterilenIcerik(ContentType p, DateTime tarih) {
  if (p == ContentType.kissa) {
    final k = gununKissasi(tarih);
    return k == null ? null : kissaIcerigi(k);
  }
  return ContentService.instance.getDailyPoolItem(p, tarih);
}

class GunlukYonetimPage extends StatefulWidget {
  const GunlukYonetimPage({super.key});

  @override
  State<GunlukYonetimPage> createState() => _GunlukYonetimPageState();
}

class _GunlukYonetimPageState extends State<GunlukYonetimPage> {
  late DateTime _secili = GunlukPlanServisi.gun(DateTime.now());
  late DateTime _ay = DateTime(_secili.year, _secili.month);
  bool _yukleniyor = true;

  final _plan = GunlukPlanServisi.instance;

  @override
  void initState() {
    super.initState();
    _ilkYukleme();
  }

  Future<void> _ilkYukleme() async {
    await ContentService.instance.load();
    await _plan.yukle();
    if (!mounted) return;
    setState(() => _yukleniyor = false);
  }

  DateTime get _bugun => GunlukPlanServisi.gun(DateTime.now());

  void _sec(DateTime d) => setState(() {
        _secili = GunlukPlanServisi.gun(d);
        _ay = DateTime(_secili.year, _secili.month);
      });

  Future<void> _yenile() async {
    final t = AppLocalizations.of(context);
    final mesaj = ScaffoldMessenger.of(context);
    setState(() => _yukleniyor = true);
    await ContentService.instance.yenidenYukle();
    await _plan.yukle(zorla: true);
    if (!mounted) return;
    setState(() => _yukleniyor = false);
    mesaj.showSnackBar(SnackBar(content: Text(t.ypYenilendi)));
  }

  Future<void> _tarihSec() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _secili,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100, 12, 31),
      currentDate: _bugun,
    );
    if (d != null && mounted) _sec(d);
  }

  void _anaSayfa() => Navigator.of(context).popUntil((r) => r.isFirst);

  Future<void> _cikis() async {
    await AdminSession.instance.logout();
    if (!mounted) return;
    _anaSayfa();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: NurRenk.gri,
      appBar: AppBar(
        title: Text(t.ypBaslik,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
              tooltip: t.ypYenile,
              onPressed: _yukleniyor ? null : _yenile,
              icon: const Icon(Icons.refresh_rounded)),
          IconButton(
              tooltip: t.ypAnaSayfa,
              onPressed: _anaSayfa,
              icon: const Icon(Icons.home_rounded)),
        ],
      ),
      bottomNavigationBar: _altMenu(t),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : ListenableBuilder(
              listenable: Listenable.merge([_plan, ContentService.instance]),
              builder: (context, _) => ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _tarihBasligi(t),
                  const SizedBox(height: 12),
                  _gunGezinme(t),
                  const SizedBox(height: 14),
                  _takvim(t),
                  const SizedBox(height: 16),
                  _ozet(t),
                  const SizedBox(height: 20),
                  Text(t.ypGununProgramlari.toUpperCase(),
                      style: const TextStyle(
                          color: NurRenk.lacivert,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 10),
                  for (final p in gunlukProgramlar) ...[
                    _ProgramKarti(
                        key: ValueKey(
                            '${GunlukPlanServisi.tarihAnahtari(_secili)}_${p.key}'),
                        program: p,
                        tarih: _secili),
                    const SizedBox(height: 12),
                  ],
                  _hakikatKarti(t),
                  const SizedBox(height: 12),
                  _digerModuller(t),
                ],
              ),
            ),
    );
  }

  Widget _altMenu(AppLocalizations t) {
    Widget dugme(IconData i, String ad, VoidCallback? f) => Expanded(
          child: InkWell(
            onTap: f,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(i, color: NurRenk.lacivert),
                const SizedBox(height: 2),
                Text(ad,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 11, color: NurRenk.lacivert)),
              ]),
            ),
          ),
        );
    return Material(
      color: Colors.white,
      elevation: 12,
      child: SafeArea(
        top: false,
        child: Row(children: [
          dugme(Icons.home_rounded, t.ypAnaSayfa, _anaSayfa),
          dugme(Icons.today_rounded, t.ypBugunGit, () => _sec(_bugun)),
          dugme(
              Icons.refresh_rounded, t.ypYenile, _yukleniyor ? null : _yenile),
          dugme(Icons.dashboard_customize_rounded, t.ypDigerModuller, () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) => const ContentManagerPage()));
          }),
          dugme(Icons.logout_rounded, t.ypCikis, _cikis),
        ]),
      ),
    );
  }

  Widget _tarihBasligi(AppLocalizations t) {
    final ml = MaterialLocalizations.of(context);
    final fark = _secili.compareTo(_bugun);
    final etiket =
        fark == 0 ? t.ypBugunEtiket : (fark < 0 ? t.ypGecmis : t.ypGelecek);
    const beyaz = TextStyle(color: Colors.white);
    return NurKart(
      koyu: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const NurIkonRozeti(Icons.event_available_rounded, boyut: 34),
          const SizedBox(width: 10),
          Text(t.ypBugun,
              style: beyaz.copyWith(
                  fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        ]),
        const SizedBox(height: 6),
        Text(ml.formatFullDate(_bugun),
            style: beyaz.copyWith(fontSize: 20, fontWeight: FontWeight.w700)),
        const Divider(color: Color(0x33FFFFFF), height: 22),
        Text(t.ypSeciliTarih,
            style: beyaz.copyWith(
                color: Colors.white70, fontSize: 11.5, letterSpacing: 1)),
        const SizedBox(height: 2),
        Text(ml.formatFullDate(_secili),
            style: beyaz.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: fark == 0 ? NurRenk.kirmizi : const Color(0x26FFFFFF),
              borderRadius: BorderRadius.circular(20)),
          child: Text(etiket, style: beyaz.copyWith(fontSize: 12)),
        ),
      ]),
    );
  }

  Widget _gunGezinme(AppLocalizations t) {
    Widget d(IconData i, String ad, VoidCallback f) => OutlinedButton.icon(
          onPressed: f,
          icon: Icon(i, size: 18),
          label: Text(ad),
          style: OutlinedButton.styleFrom(
              foregroundColor: NurRenk.lacivert,
              backgroundColor: Colors.white,
              side: const BorderSide(color: NurRenk.kenar)),
        );
    return Wrap(spacing: 8, runSpacing: 8, children: [
      d(Icons.chevron_left_rounded, t.ypOncekiGun,
          () => _sec(_secili.subtract(const Duration(days: 1)))),
      FilledButton.icon(
        onPressed: () => _sec(_bugun),
        icon: const Icon(Icons.today_rounded, size: 18),
        label: Text(t.ypBugunGit),
        style: FilledButton.styleFrom(backgroundColor: NurRenk.kirmizi),
      ),
      d(Icons.chevron_right_rounded, t.ypSonrakiGun,
          () => _sec(DateTime(_secili.year, _secili.month, _secili.day + 1))),
      d(Icons.calendar_month_rounded, t.ypTakvimdenSec, _tarihSec),
    ]);
  }

  Widget _takvim(AppLocalizations t) {
    final ml = MaterialLocalizations.of(context);
    final ilk = ml.firstDayOfWeekIndex; // 0 = pazar
    final gunSayisi = DateUtils.getDaysInMonth(_ay.year, _ay.month);
    final bas = (DateTime(_ay.year, _ay.month).weekday % 7 - ilk + 7) % 7;
    final hucreler = <Widget>[
      for (var i = 0; i < 7; i++)
        Center(
          child: Text(ml.narrowWeekdays[(i + ilk) % 7],
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B))),
        ),
      for (var i = 0; i < bas; i++) const SizedBox.shrink(),
      for (var g = 1; g <= gunSayisi; g++)
        _gunHucresi(DateTime(_ay.year, _ay.month, g)),
    ];
    return NurKart(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(children: [
        Row(children: [
          IconButton(
              tooltip: t.ypAyGeri,
              onPressed: () =>
                  setState(() => _ay = DateTime(_ay.year, _ay.month - 1)),
              icon: const Icon(Icons.chevron_left_rounded)),
          Expanded(
            child: Text(ml.formatMonthYear(_ay),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: NurRenk.lacivert,
                    fontSize: 15)),
          ),
          IconButton(
              tooltip: t.ypAyIleri,
              onPressed: () =>
                  setState(() => _ay = DateTime(_ay.year, _ay.month + 1)),
              icon: const Icon(Icons.chevron_right_rounded)),
        ]),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.92,
          children: hucreler,
        ),
        const SizedBox(height: 6),
        Wrap(spacing: 10, runSpacing: 4, children: [
          for (final d in PlanDurumu.values)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: durumRengi(d), shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(durumAdi(t, d), style: const TextStyle(fontSize: 11)),
            ]),
        ]),
      ]),
    );
  }

  Widget _gunHucresi(DateTime d) {
    final secili = DateUtils.isSameDay(d, _secili);
    final bugun = DateUtils.isSameDay(d, _bugun);
    final gecmis = d.isBefore(_bugun);
    final kayitlar = _plan.gunKayitlari(d);
    final noktalar = [
      for (final p in gunlukProgramlar)
        if (kayitlar.containsKey(p.key)) durumRengi(_plan.durum(p, d))
    ];
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _sec(d),
        child: Container(
          decoration: BoxDecoration(
            color: secili ? NurRenk.lacivert : null,
            borderRadius: BorderRadius.circular(10),
            border: bugun ? Border.all(color: NurRenk.kirmizi, width: 2) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${d.day}',
                  style: TextStyle(
                      fontWeight:
                          bugun || secili ? FontWeight.w800 : FontWeight.w500,
                      color: secili
                          ? Colors.white
                          : (gecmis
                              ? const Color(0xFF94A3B8)
                              : NurRenk.lacivert))),
              const SizedBox(height: 2),
              SizedBox(
                height: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final r in noktalar.take(6))
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        decoration:
                            BoxDecoration(color: r, shape: BoxShape.circle),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ozet(AppLocalizations t) {
    final bugun = _bugun;
    final cs = ContentService.instance;
    final toplam = gunlukProgramlar.fold<int>(
        0,
        (s, p) =>
            s +
            (p == ContentType.kissa
                ? islamiKissalar.length
                : cs.getPool(p).length));
    final bugunDurum = [
      for (final p in gunlukProgramlar) _plan.durum(p, bugun)
    ];
    final planli = _plan.tumKayitlar
        .where((k) =>
            k.durum == ContentStatus.yayinlandi &&
            GunlukPlanServisi.anahtardanTarih(k.tarih).isAfter(bugun))
        .length;
    final taslakGun = _plan.tumKayitlar
        .where((k) => k.durum == ContentStatus.taslak)
        .map((k) => k.tarih)
        .toSet()
        .length;
    Widget kutu(IconData i, String ad, int n) => SizedBox(
          width: 150,
          child: NurKart(
            padding: const EdgeInsets.all(12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              NurIkonRozeti(i, boyut: 30),
              const SizedBox(height: 8),
              Text('$n',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: NurRenk.lacivert)),
              Text(ad,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 11.5, color: Color(0xFF64748B))),
            ]),
          ),
        );
    final son = _plan.sonGuncellenenler();
    final ml = MaterialLocalizations.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 10, runSpacing: 10, children: [
        kutu(Icons.inventory_2_rounded, t.ypToplamIcerik, toplam),
        kutu(Icons.check_circle_rounded, t.ypBugunYayinda,
            bugunDurum.where((d) => d == PlanDurumu.yayinlandi).length),
        kutu(Icons.edit_note_rounded, t.ypBugunTaslak,
            bugunDurum.where((d) => d == PlanDurumu.taslak).length),
        kutu(Icons.schedule_send_rounded, t.ypPlanlanan, planli),
        kutu(Icons.pending_actions_rounded, t.ypTaslakGunler, taslakGun),
      ]),
      const SizedBox(height: 12),
      NurKart(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NurKartBasligi(
              ikon: Icons.update_rounded, baslik: t.ypSonGuncellenen),
          const SizedBox(height: 8),
          if (son.isEmpty)
            Text(t.ypKayitYok,
                style: const TextStyle(color: Color(0xFF64748B))),
          for (final k in son)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(programIkonu(k.program), color: NurRenk.lacivert),
              title: Text(
                  k.icerik.baslik.isEmpty
                      ? programAdi(t, k.program)
                      : k.icerik.baslik,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              subtitle: Text(
                  '${programAdi(t, k.program)} · ${ml.formatMediumDate(GunlukPlanServisi.anahtardanTarih(k.tarih))}'),
              trailing: _DurumCipi(
                  durum: _plan.durum(
                      k.program, GunlukPlanServisi.anahtardanTarih(k.tarih))),
              onTap: () => _sec(GunlukPlanServisi.anahtardanTarih(k.tarih)),
            ),
        ]),
      ),
    ]);
  }

  Widget _hakikatKarti(AppLocalizations t) => NurKart(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) => HakikatYonetimPage(tarih: _secili))),
        child: NurKartBasligi(
          ikon: Icons.light_mode_rounded,
          baslik: t.hkYonetim,
          altBaslik: t.hkYonetimAlt,
          sag: const Icon(Icons.chevron_right_rounded),
        ),
      );

  Widget _digerModuller(AppLocalizations t) => NurKart(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) => const ContentManagerPage())),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NurKartBasligi(
            ikon: Icons.dashboard_customize_rounded,
            baslik: t.ypDigerModuller,
            altBaslik: t.ypModulYonetimi,
            sag: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.mosque_rounded, size: 18, color: NurRenk.kirmizi),
            const SizedBox(width: 8),
            Expanded(
                child: Text(t.ypEzanVakitleri,
                    style: const TextStyle(fontSize: 12.5))),
          ]),
        ]),
      );
}

class _DurumCipi extends StatelessWidget {
  final PlanDurumu durum;
  const _DurumCipi({required this.durum});

  @override
  Widget build(BuildContext context) {
    final r = durumRengi(durum);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
          color: r.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: r.withValues(alpha: 0.5))),
      child: Text(durumAdi(AppLocalizations.of(context), durum),
          style:
              TextStyle(color: r, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

/// Secili gunde tek bir programin durumu ve islemleri.
class _ProgramKarti extends StatelessWidget {
  final ContentType program;
  final DateTime tarih;
  const _ProgramKarti({super.key, required this.program, required this.tarih});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final plan = GunlukPlanServisi.instance;
    final kayit = plan.kayit(program, tarih);
    final durum = plan.durum(program, tarih);
    final gosterilen = gosterilenIcerik(program, tarih);
    final ml = MaterialLocalizations.of(context);

    Future<void> islem(Future<void> Function() f) async {
      final m = ScaffoldMessenger.of(context);
      try {
        await f();
        m.showSnackBar(SnackBar(content: Text(t.ypKaydedildi)));
      } catch (_) {
        m.showSnackBar(SnackBar(content: Text(t.ypKayitHatasi)));
      }
    }

    void duzenle(ContentItem? baslangic, {bool mevcut = false}) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => PlanDuzenlePage(
              program: program,
              tarih: tarih,
              baslangic: baslangic,
              mevcutKayit: mevcut),
        ),
      );
    }

    Future<void> sil() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(t.ypSil),
          content: Text(t.ypSilOnay),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: Text(t.ypVazgec)),
            FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: NurRenk.kirmizi),
                onPressed: () => Navigator.pop(c, true),
                icon: const Icon(Icons.delete_rounded),
                label: Text(t.ypSil)),
          ],
        ),
      );
      if (ok == true) await islem(() => plan.sil(program, tarih));
    }

    Widget d(IconData i, String ad, VoidCallback f, {bool vurgu = false}) =>
        vurgu
            ? FilledButton.icon(
                onPressed: f,
                icon: Icon(i, size: 17),
                label: Text(ad),
                style: FilledButton.styleFrom(
                    backgroundColor: NurRenk.lacivert,
                    visualDensity: VisualDensity.compact))
            : OutlinedButton.icon(
                onPressed: f,
                icon: Icon(i, size: 17),
                label: Text(ad),
                style: OutlinedButton.styleFrom(
                    foregroundColor: NurRenk.lacivert,
                    visualDensity: VisualDensity.compact));

    return NurKart(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        NurKartBasligi(
          ikon: programIkonu(program),
          baslik: programAdi(t, program),
          altBaslik: kayit != null
              ? '${t.ypSonGuncelleme}: ${ml.formatMediumDate(kayit.guncellenme)}'
              : t.ypOtomatikAciklama,
          sag: _DurumCipi(durum: durum),
        ),
        const SizedBox(height: 10),
        if (kayit != null)
          Text(
              kayit.icerik.baslik.isNotEmpty
                  ? kayit.icerik.baslik
                  : kayit.icerik.icerik,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(
          '${t.ypGosterilen}: ${gosterilen == null ? t.ypIcerikYok : (gosterilen.baslik.isNotEmpty ? gosterilen.baslik : gosterilen.icerik)}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          d(Icons.visibility_rounded, t.ypOnizle, () {
            final i = kayit?.icerik ?? gosterilen;
            if (i != null) onizlemeGoster(context, program, i);
          }),
          if (kayit != null)
            d(Icons.edit_rounded, t.ypDuzenle,
                () => duzenle(kayit.icerik, mevcut: true), vurgu: true)
          else
            d(Icons.add_rounded, t.ypYeniIcerik, () => duzenle(null),
                vurgu: true),
          d(Icons.inventory_2_rounded, t.ypArsivdenSec, () async {
            final s = await arsivdenSec(context, program);
            if (s != null && context.mounted) duzenle(s, mevcut: kayit != null);
          }),
          if (kayit != null && kayit.durum != ContentStatus.yayinlandi)
            d(
                Icons.publish_rounded,
                t.ypYayimla,
                () => islem(() => plan.durumDegistir(
                    program, tarih, ContentStatus.yayinlandi))),
          if (kayit != null && kayit.durum == ContentStatus.yayinlandi)
            d(
                Icons.edit_note_rounded,
                t.ypTaslagaAl,
                () => islem(() =>
                    plan.durumDegistir(program, tarih, ContentStatus.taslak))),
          if (kayit != null && kayit.durum != ContentStatus.arsivlendi)
            d(
                Icons.archive_rounded,
                t.ypArsivle,
                () => islem(() => plan.durumDegistir(
                    program, tarih, ContentStatus.arsivlendi))),
          if (kayit != null) d(Icons.delete_outline_rounded, t.ypSil, sil),
        ]),
      ]),
    );
  }
}

/// Programin arsivinden (havuz / kissa kutuphanesi) arama ile secim.
Future<ContentItem?> arsivdenSec(BuildContext context, ContentType program) {
  final t = AppLocalizations.of(context);
  final tumu = program == ContentType.kissa
      ? islamiKissalar.map(kissaIcerigi).toList()
      : ContentService.instance.getPool(program).toList();
  return showModalBottomSheet<ContentItem>(
    context: context,
    isScrollControlled: true,
    builder: (c) {
      var sorgu = '';
      return StatefulBuilder(builder: (c, ss) {
        final q = sorgu.toLowerCase();
        final liste = q.isEmpty
            ? tumu
            : tumu
                .where((i) =>
                    '${i.baslik} ${i.icerik} ${i.kaynak ?? ''} ${i.kategori ?? ''}'
                        .toLowerCase()
                        .contains(q))
                .toList();
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(c).size.height * 0.8,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      labelText: '${t.ypAra} · ${programAdi(t, program)}'),
                  onChanged: (v) => ss(() => sorgu = v),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: liste.length,
                  itemBuilder: (c, i) {
                    final it = liste[i];
                    return ListTile(
                      leading:
                          Icon(programIkonu(program), color: NurRenk.lacivert),
                      title: Text(it.baslik.isNotEmpty ? it.baslik : it.icerik,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                          [it.kategori, it.kaynak]
                              .whereType<String>()
                              .where((e) => e.isNotEmpty)
                              .join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.pop(c, it),
                    );
                  },
                ),
              ),
            ]),
          ),
        );
      });
    },
  );
}
