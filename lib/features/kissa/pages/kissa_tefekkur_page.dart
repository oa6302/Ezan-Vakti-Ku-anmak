import 'package:flutter/material.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/features/kissa/widgets/kissa_paylasim_butonlari.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';

class KissaTefekkurPage extends StatelessWidget {
  final Kissa kissa;

  const KissaTefekkurPage({
    super.key,
    required this.kissa,
  });

  Widget _bolum({
    required BuildContext context,
    required String baslik,
    required String metin,
    required IconData ikon,
    required Color renk,
  }) {
    if (metin.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: renk.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, color: renk, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  baslik,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: renk,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            metin,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final renk = kissa.renk;
    final tefekkurVar = kissa.hakikat.trim().isNotEmpty ||
        kissa.fitrat.trim().isNotEmpty ||
        kissa.iman.trim().isNotEmpty ||
        kissa.hayat.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).uiZamanimizaBakanYonu),
        centerTitle: true,
        actions: [
          KissaPaylasimButonlari(
            kissa: kissa,
            tefekkurOdakli: true,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  renk,
                  Color.lerp(renk, Colors.black, 0.28)!,
                ],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFFE8C77A),
                  size: 35,
                ),
                const SizedBox(height: 13),
                Text(
                  AppLocalizations.of(context).uiKissaninZamanimizaBakanYonu,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE8C77A),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  kissa.baslik,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)
                      .uiGecmisinHadisesindenBugununIman,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _bolum(
            context: context,
            baslik: 'Hakikatin penceresi',
            metin: kissa.hakikat,
            ikon: Icons.auto_awesome_rounded,
            renk: const Color(0xFFB58A35),
          ),
          _bolum(
            context: context,
            baslik: 'Fıtratımıza bakan yönü',
            metin: kissa.fitrat,
            ikon: Icons.favorite_outline_rounded,
            renk: const Color(0xFF278A75),
          ),
          _bolum(
            context: context,
            baslik: 'İmanî ders',
            metin: kissa.iman,
            ikon: Icons.mosque_rounded,
            renk: const Color(0xFF4169A1),
          ),
          _bolum(
            context: context,
            baslik: 'Bugünkü hayatımıza yansıması',
            metin: kissa.hayat,
            ikon: Icons.wb_sunny_outlined,
            renk: const Color(0xFFB87939),
          ),
          if (!tefekkurVar)
            _bolum(
              context: context,
              baslik: 'Kıssadan hisse',
              metin: kissa.hisse,
              ikon: Icons.bookmark_outline_rounded,
              renk: renk,
            ),
          if (!tefekkurVar)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Text(
                AppLocalizations.of(context).uiTefekkurHazirlaniyor,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              color: const Color(0xFFE8C77A).withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).uiKendimizeSoralim,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  AppLocalizations.of(context).uiTefekkurSoru,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.65,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            AppLocalizations.of(context).uiFKaynak(kissa.kaynak),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).uiTefekkurNot,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
