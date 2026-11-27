// 🌙 Dua Hazinesi: koleksiyonlar, dua detayi ve ezber (standartlar/DUA_STANDARDI.md)
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/dua_ezber_servisi.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';

import 'dua/dua_gorunum.dart';
import 'dua/dua_okuma_page.dart';
import 'ortak.dart';

class DuaHazinesiPage extends StatelessWidget {
  const DuaHazinesiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌙 Dua Hazinesi')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const DuaEzberOzeti(),
          const SizedBox(height: 8),
          for (final k in DuaKoleksiyonu.values)
            Builder(builder: (context) {
              final sayi = duaHazinesi.where((d) => d.koleksiyon == k).length;
              return Card(
                child: ListTile(
                  leading: Text(k.emoji, style: const TextStyle(fontSize: 26)),
                  title: Text(k.ad,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(sayi == 0
                      ? '${k.aciklama} · hazırlanıyor'
                      : '${k.aciklama} · $sayi dua'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => DuaListesiPage(koleksiyon: k))),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class DuaListesiPage extends StatelessWidget {
  final DuaKoleksiyonu koleksiyon;
  const DuaListesiPage({super.key, required this.koleksiyon});

  @override
  Widget build(BuildContext context) {
    final liste = duaHazinesi.where((d) => d.koleksiyon == koleksiyon).toList();
    return Scaffold(
      appBar: AppBar(title: Text('${koleksiyon.emoji} ${koleksiyon.ad}')),
      body: liste.isEmpty
          ? const Center(
              child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                  'Bu koleksiyon, kaynakları doğrulandıkça doldurulacak.',
                  textAlign: TextAlign.center),
            ))
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                for (final d in liste)
                  Card(
                    child: ListTile(
                      title: Text(d.baslik,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text('${d.sinif.ad} · ${d.kaynak}'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) =>
                                  DuaHazineDetayPage(dua: d, liste: liste))),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Dua Hazinesi kaydini premium okuma ekraninda acar.
class DuaHazineDetayPage extends StatelessWidget {
  final DuaKaydi dua;
  final List<DuaKaydi> liste;
  const DuaHazineDetayPage(
      {super.key, required this.dua, this.liste = const []});

  @override
  Widget build(BuildContext context) => DuaOkumaPage(
        dua: DuaGorunum.kayittan(dua),
        liste: [for (final d in liste) DuaGorunum.kayittan(d)],
      );
}

/// Ezber durumu: ogrenilen, tekrar bekleyen ve tamamlanan dualar (gercek kayit).
List<DuaGorunum> tumDualar() => [
      for (final d in duaHazinesi) DuaGorunum.kayittan(d),
      for (final c in ContentService.instance.getPool(ContentType.dua))
        DuaGorunum.icerikten(c),
    ];

class DuaEzberOzeti extends StatefulWidget {
  const DuaEzberOzeti({super.key});
  @override
  State<DuaEzberOzeti> createState() => _DuaEzberOzetiState();
}

class _DuaEzberOzetiState extends State<DuaEzberOzeti> {
  @override
  void initState() {
    super.initState();
    DuaEzberServisi.instance.yukle();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: DuaEzberServisi.instance,
      builder: (context, _) {
        final ez = DuaEzberServisi.instance;
        final baslanan = ez.baslananlar.toSet();
        final hepsi = {for (final d in tumDualar()) d.id: d};
        final liste = [
          for (final id in baslanan)
            if (hepsi[id] case final d?) d
        ];
        final tamam = liste
            .where((d) => ez.tamamlandiMi(d.id, ezberParcalari(d).length))
            .toList();
        final bekleyen = liste
            .where((d) => !tamam.contains(d) && ez.tekrarZamaniMi(d.id))
            .toList();
        final ogrenilen = liste
            .where((d) => !tamam.contains(d) && !bekleyen.contains(d))
            .toList();
        Widget kutu(String ad, List<DuaGorunum> l, IconData ikon) => Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => _EzberListesi(baslik: ad, liste: l))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(children: [
                    Icon(ikon, color: hazineAltin),
                    const SizedBox(height: 4),
                    Text('${l.length}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900)),
                    Text(ad,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12)),
                  ]),
                ),
              ),
            );
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Text(t.dkEzberDurumu,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: hazineLacivert)),
              const SizedBox(height: 6),
              if (liste.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(t.dkEzberBos,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54)),
                )
              else
                Row(children: [
                  kutu(t.dkOgrenilen, ogrenilen, Icons.school_rounded),
                  kutu(t.dkBekleyen, bekleyen, Icons.schedule_rounded),
                  kutu(t.dkTamamlanan, tamam, Icons.verified_rounded),
                ]),
            ]),
          ),
        );
      },
    );
  }
}

class _EzberListesi extends StatelessWidget {
  final String baslik;
  final List<DuaGorunum> liste;
  const _EzberListesi({required this.baslik, required this.liste});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(baslik)),
      body: liste.isEmpty
          ? Center(child: Text(t.dkEzberBos, textAlign: TextAlign.center))
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                for (final d in liste)
                  Card(
                    child: ListTile(
                      title: Text(d.baslik,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text(d.kaynak),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) =>
                                  DuaOkumaPage(dua: d, liste: liste))),
                    ),
                  ),
              ],
            ),
    );
  }
}
