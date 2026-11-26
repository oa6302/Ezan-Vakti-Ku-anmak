// 🌙 Dua Hazinesi: koleksiyonlar, dua detayi ve ezber (standartlar/DUA_STANDARDI.md)
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/data/icerik_hazinesi.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                              builder: (_) => DuaHazineDetayPage(dua: d))),
                    ),
                  ),
              ],
            ),
    );
  }
}

class DuaHazineDetayPage extends StatefulWidget {
  final DuaKaydi dua;
  const DuaHazineDetayPage({super.key, required this.dua});

  @override
  State<DuaHazineDetayPage> createState() => _DuaHazineDetayPageState();
}

class _DuaHazineDetayPageState extends State<DuaHazineDetayPage> {
  Set<int> _ezber = {};
  bool _testModu = false;
  final Set<int> _acik = {};
  String get _anahtar => 'ezber_${widget.dua.id}';

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  Future<void> _yukle() async {
    final p = await SharedPreferences.getInstance();
    final l = p.getStringList(_anahtar) ?? const [];
    if (mounted) setState(() => _ezber = l.map(int.parse).toSet());
  }

  Future<void> _degistir(int i) async {
    setState(() => _ezber.contains(i) ? _ezber.remove(i) : _ezber.add(i));
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_anahtar, _ezber.map((e) => '$e').toList());
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dua;
    final t = Theme.of(context).textTheme;
    final toplam = d.parcalar.length;
    return Scaffold(
      appBar: AppBar(title: Text(d.baslik, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 22,
                    offset: Offset(0, 10))
              ],
            ),
            child: ArapcaMetin(d.arapca, boyut: 24),
          ),
          HazineBolum(baslik: '🔤 Okunuşu', metin: d.okunus),
          HazineBolum(baslik: '📖 Anlamı', metin: d.anlam),
          HazineBolum(
            baslik: '📚 Kaynak ve Sınıf',
            renk: const Color(0xFF5D4037),
            metin: [
              'Sınıf: ${d.sinif.ad}',
              'Kaynak: ${d.kaynak}',
              if (d.hadisNo.isNotEmpty) 'Numara: ${d.hadisNo}',
              if (d.sihhat.isNotEmpty) 'Sıhhat: ${d.sihhat}',
            ].join('\n'),
          ),
          HazineBolum(baslik: '💡 Açıklama', metin: d.aciklama),
          if (toplam > 0)
            HazineBolum(
              baslik: '🧠 Ezber ($toplam parçadan ${_ezber.length})',
              renk: const Color(0xFF6A4C93),
              cocuk: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                      value: _ezber.length / toplam, minHeight: 6),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Test modu (Arapçayı gizle)'),
                    value: _testModu,
                    onChanged: (v) => setState(() {
                      _testModu = v;
                      _acik.clear();
                    }),
                  ),
                  for (final (i, p) in d.parcalar.indexed)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!_testModu || _acik.contains(i))
                              ArapcaMetin(p.arapca, boyut: 20)
                            else
                              OutlinedButton(
                                onPressed: () => setState(() => _acik.add(i)),
                                child: const Text('Hatırla, sonra göster'),
                              ),
                            const SizedBox(height: 6),
                            Text(p.okunus,
                                style: t.bodyMedium
                                    ?.copyWith(fontStyle: FontStyle.italic)),
                            if (p.anlam.isNotEmpty)
                              Text(p.anlam, style: t.bodySmall),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              title: const Text('Ezberledim'),
                              value: _ezber.contains(i),
                              onChanged: (_) => _degistir(i),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
