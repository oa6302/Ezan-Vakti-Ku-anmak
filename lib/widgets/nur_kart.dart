// Ortak kart dili: kirmizi - beyaz - lacivert, modern ikon rozeti, derin golge.
// Ana sayfa kartlari ve yonetim paneli ayni bilesenleri kullanir.
import 'package:flutter/material.dart';

import 'package:nur_pusulasi/app/theme.dart';

class NurRenk {
  static const lacivert = kAnaLacivert;
  static const koyuLacivert = kKoyuLacivert;
  static const kirmizi = Color(0xFFC8102E);
  static const yumusakKirmizi = Color(0xFFFCE8EB);
  static const beyaz = Colors.white;
  static const gri = kArkaPlan;
  static const kenar = kKenarlik;
}

class NurKartStili {
  static const derinGolge = <BoxShadow>[
    BoxShadow(
        color: Color(0x38142747),
        blurRadius: 32,
        spreadRadius: -6,
        offset: Offset(0, 18)),
    BoxShadow(color: Color(0x14142747), blurRadius: 6, offset: Offset(0, 2)),
  ];

  static BoxDecoration kutu({double yaricap = 24, bool koyu = false}) =>
      BoxDecoration(
        color: koyu ? null : NurRenk.beyaz,
        gradient: koyu
            ? const LinearGradient(
                colors: [NurRenk.koyuLacivert, NurRenk.lacivert],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)
            : null,
        borderRadius: BorderRadius.circular(yaricap),
        border:
            Border.all(color: koyu ? const Color(0x33FFFFFF) : NurRenk.kenar),
        boxShadow: derinGolge,
      );
}

/// Kirmizi zemin uzerinde beyaz ikonlu yuvarlak rozet.
class NurIkonRozeti extends StatelessWidget {
  final IconData ikon;
  final double boyut;
  final Color renk;
  const NurIkonRozeti(this.ikon,
      {super.key, this.boyut = 40, this.renk = NurRenk.kirmizi});

  @override
  Widget build(BuildContext context) => Container(
        width: boyut,
        height: boyut,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [renk, Color.lerp(renk, Colors.black, 0.25)!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          boxShadow: [
            BoxShadow(
                color: renk.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Icon(ikon, color: Colors.white, size: boyut * 0.52),
      );
}

/// Lacivert baslik serit: rozet + baslik (+ sag tarafta istege bagli ogeler).
class NurKartBasligi extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final String? altBaslik;
  final Widget? sag;
  final bool koyuZemin;
  const NurKartBasligi(
      {super.key,
      required this.ikon,
      required this.baslik,
      this.altBaslik,
      this.sag,
      this.koyuZemin = false});

  @override
  Widget build(BuildContext context) {
    final renk = koyuZemin ? Colors.white : NurRenk.lacivert;
    return Row(children: [
      NurIkonRozeti(ikon, boyut: 36),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(baslik,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: renk,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    fontSize: 13.5)),
            if (altBaslik != null && altBaslik!.isNotEmpty)
              Text(altBaslik!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: renk.withValues(alpha: 0.7), fontSize: 11.5)),
          ],
        ),
      ),
      if (sag != null) sag!,
    ]);
  }
}

/// Beyaz, derin golgeli, yuvarlak kart.
class NurKart extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool koyu;
  const NurKart(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16),
      this.onTap,
      this.koyu = false});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: NurKartStili.kutu(koyu: koyu),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
}
