// 🌿 Risale-i Nur Hakikatleri: kategoriler, ders detayi ve mini sinav
// (standartlar/RISALE_STANDARDI.md)
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';

import 'ortak.dart';

class RisaleDersleriPage extends StatelessWidget {
  const RisaleDersleriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌿 Risale-i Nur Hakikatleri')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          for (final k in RisaleKategori.values)
            Builder(builder: (context) {
              final liste =
                  risaleDersleri.where((d) => d.kategori == k).toList();
              return Card(
                child: ExpansionTile(
                  leading: Text(k.emoji, style: const TextStyle(fontSize: 24)),
                  title: Text(k.ad,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(
                      liste.isEmpty ? 'Hazırlanıyor' : '${liste.length} ders'),
                  children: [
                    for (final d in liste)
                      ListTile(
                        title: Text(d.baslik),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (_) => RisaleDersPage(ders: d))),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class RisaleDersPage extends StatelessWidget {
  final RisaleDersi ders;
  const RisaleDersPage({super.key, required this.ders});

  @override
  Widget build(BuildContext context) {
    final d = ders;
    return Scaffold(
      appBar: AppBar(title: Text(d.kategori.ad)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text('✨ ${d.baslik}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900, color: hazineLacivert)),
          HazineBolum(baslik: '❓ Düşündüren Giriş', metin: d.giris),
          HazineBolum(baslik: '📖 Hakikatin Açıklaması', metin: d.aciklama),
          HazineBolum(
              baslik: '🔍 Risale-i Nur Perspektifi',
              metin: d.risalePerspektifi,
              renk: const Color(0xFF6A4C93)),
          HazineBolum(
              baslik: '🌌 Kâinattan Bir Delil',
              metin: d.kainattanDelil,
              renk: const Color(0xFF1565C0)),
          HazineBolum(
              baslik: '💡 Hakikatin Penceresi',
              metin: d.hikmet,
              renk: const Color(0xFFB38A3E)),
          HazineBolum(baslik: '🪞 Kendimize Bakalım', metin: d.kendimize),
          HazineBolum(
              baslik: '🌱 Hayata Yansıması',
              metin: d.hayat,
              renk: const Color(0xFF2E7D32)),
          KisaDuaBlogu(d.dua),
          HazineBolum(
              baslik: '⭐ Akılda Kalacak Ders',
              metin: d.ders,
              renk: hazineKirmizi),
          HazineBolum(baslik: '❓ Tefekkür Sorusu', metin: d.tefekkurSorusu),
          if (d.kavramlar.isNotEmpty)
            HazineBolum(
              baslik: '🔑 Önemli Kavramlar',
              cocuk: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final k in d.kavramlar) Chip(label: Text(k))],
              ),
            ),
          MiniSinav(sorular: d.sinav, dogruYanlis: d.dogruYanlis),
          HazineBolum(
              baslik: '📚 Kaynaklar',
              metin: d.kaynaklar.map((k) => '• $k').join('\n'),
              renk: const Color(0xFF5D4037)),
        ],
      ),
    );
  }
}
