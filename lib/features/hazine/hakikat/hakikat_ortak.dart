// Hakikat bolumunun ortak renkleri ve bilesenleri (lacivert, beyaz, kirik
// beyaz, altin). Metinler l10n'dan gelir.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/hakikat_servisi.dart';
import 'package:nur_pusulasi/data/hakikat.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../ortak.dart';
import '../risale_dersleri_page.dart';

class HkRenk {
  static const lacivert = hazineLacivert;
  static const altin = hazineAltin;
  static const kirikBeyaz = Color(0xFFFAF7F0);
  static const kenar = Color(0xFFE8E1D3);
}

String konuAdi(AppLocalizations t, HakikatKonusu k) => switch (k) {
      HakikatKonusu.iman => t.hkKonuIman,
      HakikatKonusu.tevhid => t.hkKonuTevhid,
      HakikatKonusu.esma => t.hkKonuEsma,
      HakikatKonusu.kuran => t.hkKonuKuran,
      HakikatKonusu.nubuvvet => t.hkKonuNubuvvet,
      HakikatKonusu.ahiret => t.hkKonuAhiret,
      HakikatKonusu.kader => t.hkKonuKader,
      HakikatKonusu.ruhKalpNefis => t.hkKonuRuh,
      HakikatKonusu.insanKainat => t.hkKonuInsan,
      HakikatKonusu.ibadet => t.hkKonuIbadet,
      HakikatKonusu.sukurSabir => t.hkKonuSukur,
      HakikatKonusu.ihlasUhuvvet => t.hkKonuIhlas,
      HakikatKonusu.genclikAhlak => t.hkKonuGenclik,
      HakikatKonusu.musibet => t.hkKonuMusibet,
      HakikatKonusu.tabiat => t.hkKonuTabiat,
    };

String durumAdiHk(AppLocalizations t, HakikatDurumu d) => switch (d) {
      HakikatDurumu.taslak => t.hkDurumTaslak,
      HakikatDurumu.yayinda => t.hkDurumYayinda,
      HakikatDurumu.arsiv => t.hkDurumArsiv,
    };

Color durumRengiHk(HakikatDurumu d) => switch (d) {
      HakikatDurumu.taslak => const Color(0xFFB26A00),
      HakikatDurumu.yayinda => const Color(0xFF2E7D32),
      HakikatDurumu.arsiv => Colors.blueGrey,
    };

/// Genis ekranda okunakli genislik; telefonda tam genislik.
class HkGovde extends StatelessWidget {
  final Widget child;
  const HkGovde({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860), child: child),
      );
}

/// Kirik beyaz zeminli, ince altin kenarli kart.
class HkKart extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color renk;
  const HkKart(
      {super.key,
      required this.child,
      this.onTap,
      this.padding = const EdgeInsets.all(16),
      this.renk = Colors.white});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: renk,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HkRenk.kenar),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14142747), blurRadius: 18, offset: Offset(0, 6))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
}

class HkBolumBasligi extends StatelessWidget {
  final String metin;
  final Widget? sag;
  const HkBolumBasligi(this.metin, {super.key, this.sag});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 22, 2, 10),
        child: Row(children: [
          Container(width: 4, height: 20, color: HkRenk.altin),
          const SizedBox(width: 10),
          Expanded(
            child: Text(metin,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: HkRenk.lacivert)),
          ),
          if (sag != null) sag!,
        ]),
      );
}

class HkIkonRozeti extends StatelessWidget {
  final IconData ikon;
  final double boyut;
  const HkIkonRozeti(this.ikon, {super.key, this.boyut = 40});
  @override
  Widget build(BuildContext context) => Container(
        width: boyut,
        height: boyut,
        decoration: BoxDecoration(
          color: HkRenk.lacivert,
          borderRadius: BorderRadius.circular(boyut * 0.32),
        ),
        child: Icon(ikon, color: HkRenk.altin, size: boyut * 0.55),
      );
}

class HkBosDurum extends StatelessWidget {
  final String metin;
  final IconData ikon;
  const HkBosDurum(this.metin,
      {super.key, this.ikon = Icons.auto_stories_outlined});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        child: Column(children: [
          Icon(ikon, size: 44, color: HkRenk.altin),
          const SizedBox(height: 10),
          Text(metin,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, height: 1.5)),
        ]),
      );
}

void hakikatAc(BuildContext context, RisaleDersi d) => Navigator.push(
    context, MaterialPageRoute<void>(builder: (_) => RisaleDersPage(ders: d)));

/// Liste satiri: baslik, konu, ilerleme ve tamamlandi isareti.
class HakikatSatiri extends StatelessWidget {
  final RisaleDersi ders;
  final String? ust;
  const HakikatSatiri({super.key, required this.ders, this.ust});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = HakikatServisi.instance;
    final konu = ders.hakikatKonulari.first;
    final tamam = s.tamamlandiMi(ders.id);
    final oran = s.ilerleme(ders.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HkKart(
        padding: const EdgeInsets.all(14),
        onTap: () => hakikatAc(context, ders),
        child: Row(children: [
          HkIkonRozeti(konu.ikon),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(ust ?? konuAdi(t, konu),
                  style: const TextStyle(
                      fontSize: 11.5,
                      color: HkRenk.altin,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(ders.baslik,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: HkRenk.lacivert,
                      height: 1.3)),
              if (oran > 0 && !tamam) ...[
                const SizedBox(height: 6),
                LinearProgressIndicator(
                    value: oran,
                    minHeight: 3,
                    color: HkRenk.altin,
                    backgroundColor: HkRenk.kenar),
              ],
            ]),
          ),
          const SizedBox(width: 8),
          Icon(tamam ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
              color: tamam ? const Color(0xFF2E7D32) : Colors.black38,
              semanticLabel: tamam ? t.hkTamamlandi : null),
        ]),
      ),
    );
  }
}

/// Dogrulanmis Risale-i Nur metni: Latince, istenirse Osmanlica (RTL).
class RisaleMetinKarti extends StatefulWidget {
  final RisaleMetni metin;
  const RisaleMetinKarti(this.metin, {super.key});
  @override
  State<RisaleMetinKarti> createState() => _RisaleMetinKartiState();
}

class _RisaleMetinKartiState extends State<RisaleMetinKarti> {
  bool _osmanlica = false;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final m = widget.metin;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HkKart(
        renk: HkRenk.kirikBeyaz,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            const Icon(Icons.format_quote_rounded, color: HkRenk.altin),
            const SizedBox(width: 6),
            Expanded(
                child: Text(m.kaynak,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: HkRenk.lacivert))),
            if (m.osmanlica.isNotEmpty)
              FilterChip(
                label: Text(t.hkOsmanlica),
                selected: _osmanlica,
                onSelected: (v) => setState(() => _osmanlica = v),
              ),
          ]),
          const SizedBox(height: 8),
          SelectableText(m.latin,
              style: const TextStyle(fontSize: 15.5, height: 1.7)),
          if (_osmanlica) ...[
            const Divider(height: 22),
            ArapcaMetin(m.osmanlica, boyut: 21),
          ],
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              tooltip: t.hkPaylas,
              icon: const Icon(Icons.share_rounded, size: 20),
              onPressed: () => metinPaylas('“${m.latin}”\n— ${m.kaynak}'),
            ),
          ),
        ]),
      ),
    );
  }
}

Future<void> metinPaylas(String metin) async {
  try {
    await SharePlus.instance.share(ShareParams(text: metin));
  } catch (e) {
    debugPrint('Paylasim acilamadi: $e');
  }
}

/// Paylasim metni: baslik, ozet ve kaynak (kesilmez; metin olarak gider).
String hakikatPaylasimMetni(RisaleDersi d, AppLocalizations t) => [
      '✨ ${d.baslik}',
      '',
      d.ders,
      '',
      d.giris,
      '',
      '${t.hkKaynaklar}: ${d.kaynaklar.join('; ')}',
    ].join('\n');
