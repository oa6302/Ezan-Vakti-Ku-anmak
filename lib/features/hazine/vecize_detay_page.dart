// Gunun Vecizesi detay sayfasi (standartlar/VECIZE_STANDARDI.md, madde 5).
// Vecizenin Osmanlica ve Latin metni degistirilmeden gosterilir.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';

import 'ortak.dart';

class VecizeDetayPage extends StatelessWidget {
  final String osmanlica;
  final String latin;
  final VecizeDetayi detay;
  const VecizeDetayPage(
      {super.key,
      required this.osmanlica,
      required this.latin,
      required this.detay});

  @override
  Widget build(BuildContext context) {
    final d = detay;
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Günün Vecizesi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // 1-3: Asil metin, harf aktarimi, kaynak (kart renkleri korunur)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 26,
                    offset: Offset(0, 12))
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: hazineKirmizi,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('VECİZENİN ASLI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                  child: ArapcaMetin(osmanlica, boyut: 24),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(latin,
                      textAlign: TextAlign.center,
                      style: t.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700, height: 1.5)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  color: hazineLacivert,
                  padding: const EdgeInsets.all(12),
                  child: Text('📚 ${d.kaynakEser}',
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
          HazineBolum(baslik: '💎 Hakikatin Derinliği', metin: d.hakikat),
          HazineBolum(
              baslik: '🔍 Risale-i Nur Perspektifi',
              metin: d.risalePerspektifi,
              renk: const Color(0xFF6A4C93)),
          HazineBolum(
              baslik: '🌱 Hayattan Örnekler',
              metin: d.hayattanOrnekler,
              renk: const Color(0xFF2E7D32)),
          HazineBolum(
              baslik: '🌌 Kâinattan Deliller',
              metin: d.kainattanDeliller,
              renk: const Color(0xFF1565C0)),
          HazineBolum(
              baslik: '💡 İmanî Kazanım',
              metin: d.imaniKazanim,
              renk: const Color(0xFFB38A3E)),
          HazineBolum(
              baslik: '🪞 Nefs Muhasebesi',
              metin: d.muhasebe.map((s) => '• $s').join('\n')),
          HazineBolum(
              baslik: '✅ Günlük Hayata Tatbik',
              metin: d.tatbik.map((s) => '• $s').join('\n'),
              renk: const Color(0xFF2E7D32)),
          KisaDuaBlogu(d.dua),
          HazineBolum(
              baslik: '⭐ Öğrenilen Temel Ders',
              metin: d.temelDers,
              renk: hazineKirmizi),
          MiniSinav(sorular: d.degerlendirme),
        ],
      ),
    );
  }
}
