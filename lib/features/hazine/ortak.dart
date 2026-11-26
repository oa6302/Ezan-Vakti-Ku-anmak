// Dua, Risale ve Vecize sayfalarinin ortak bilesenleri.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/app_settings.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';

const hazineLacivert = Color(0xFF0A1F44);
const hazineKirmizi = Color(0xFFB71C1C);
const hazineAltin = Color(0xFFC9A961);

/// Basligi ikonlu, yumusak zeminli bolum karti. Metin bossa gizlenir.
class HazineBolum extends StatelessWidget {
  final String baslik;
  final String metin;
  final Color renk;
  final Widget? cocuk;
  const HazineBolum(
      {super.key,
      required this.baslik,
      this.metin = '',
      this.renk = hazineLacivert,
      this.cocuk});

  @override
  Widget build(BuildContext context) {
    if (metin.trim().isEmpty && cocuk == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: renk.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(baslik,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: renk, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          if (metin.trim().isNotEmpty)
            SelectableText(metin,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(height: 1.7)),
          if (cocuk != null) cocuk!,
        ],
      ),
    );
  }
}

/// Arapca / Osmanlica metin: sagdan sola, harekeli, secili yazi stiliyle.
class ArapcaMetin extends StatelessWidget {
  final String metin;
  final double boyut;
  final Color renk;
  const ArapcaMetin(this.metin,
      {super.key, this.boyut = 24, this.renk = hazineLacivert});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppSettings.instance.fontStyle,
      builder: (context, stil, _) => Directionality(
        textDirection: TextDirection.rtl,
        child: SelectableText(
          metin,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: stil == 'rika' ? 'Rika' : 'Matbu',
              fontSize: boyut,
              height: 1.9,
              color: renk),
        ),
      ),
    );
  }
}

/// Kaynakli kisa dua blogu (Arapca + okunus + anlam + kaynak).
class KisaDuaBlogu extends StatelessWidget {
  final KisaDua dua;
  const KisaDuaBlogu(this.dua, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return HazineBolum(
      baslik: '🤲 Dua ve Münacat',
      renk: const Color(0xFF00695C),
      cocuk: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ArapcaMetin(dua.arapca, boyut: 22),
          const SizedBox(height: 8),
          Text(dua.okunus,
              style: t.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 6),
          Text(dua.anlam, style: t.bodyLarge?.copyWith(height: 1.6)),
          const SizedBox(height: 6),
          Text('📚 ${dua.kaynak}',
              style: t.bodySmall?.copyWith(color: Colors.black54)),
        ],
      ),
    );
  }
}

/// Mini sinav: coktan secmeli + dogru/yanlis. Dokununca sonuc gosterir.
class MiniSinav extends StatefulWidget {
  final List<CoktanSecmeli> sorular;
  final List<DogruYanlis> dogruYanlis;
  const MiniSinav(
      {super.key, this.sorular = const [], this.dogruYanlis = const []});

  @override
  State<MiniSinav> createState() => _MiniSinavState();
}

class _MiniSinavState extends State<MiniSinav> {
  final Map<int, int> _secim = {};
  final Map<int, bool> _dy = {};

  Widget _secenek(String metin, bool secili, bool dogru, VoidCallback onTap) {
    final renk = !secili
        ? Colors.black12
        : dogru
            ? const Color(0xFF2E7D32)
            : hazineKirmizi;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Material(
        color: secili ? renk.withValues(alpha: 0.10) : Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: renk),
            borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(child: Text(metin)),
              if (secili)
                Icon(dogru ? Icons.check_circle : Icons.cancel, color: renk),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sorular.isEmpty && widget.dogruYanlis.isEmpty) {
      return const SizedBox.shrink();
    }
    final t = Theme.of(context).textTheme;
    return HazineBolum(
      baslik: '📝 Kısa Değerlendirme',
      renk: const Color(0xFF6A4C93),
      cocuk: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, s) in widget.sorular.indexed) ...[
            const SizedBox(height: 10),
            Text('${i + 1}. ${s.soru}', style: t.titleSmall),
            for (final (j, sec) in s.secenekler.indexed)
              _secenek(sec, _secim[i] == j, j == s.dogru,
                  () => setState(() => _secim[i] = j)),
          ],
          for (final (i, d) in widget.dogruYanlis.indexed) ...[
            const SizedBox(height: 12),
            Text('D/Y: ${d.ifade}', style: t.titleSmall),
            Row(children: [
              for (final cevap in [true, false])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _secenek(cevap ? 'Doğru' : 'Yanlış', _dy[i] == cevap,
                        cevap == d.dogru, () => setState(() => _dy[i] = cevap)),
                  ),
                ),
            ]),
          ],
        ],
      ),
    );
  }
}
