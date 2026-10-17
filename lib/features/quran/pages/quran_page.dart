import 'package:flutter/material.dart';
import '../data/quran_models.dart';
import '../data/quran_service.dart';
import 'quran_detail_page.dart';
import 'quran_full_page.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});
  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<KuranKategori> _kategoriler = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final k = await QuranService().load();
    if (!mounted) return;
    setState(() {
      _kategoriler = k;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Kur\'an Kütüphanesi',
            style: TextStyle(color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _kategoriler.isEmpty
              ? const Center(child: Text('İçerik yüklenemedi'))
              : ListView(
                  padding: const EdgeInsets.all(14),
                  children: [
                    _hero(),
                    const SizedBox(height: 16),
                    _tamKuranBanner(context),
                    const SizedBox(height: 16),
                    ..._kategoriler.map((k) => _kategoriSection(k)),
                    const SizedBox(height: 20),
                  ],
                ),
    );
  }

  Widget _tamKuranBanner(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const QuranFullPage()),
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF0D3D12)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B5E20).withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: _gold, width: 1.5),
                ),
                child: const Icon(Icons.auto_stories_rounded,
                    color: _gold, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tam Kur\'an-i Kerim',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 4),
                    Text('114 sure - Arapca + Diyanet Meali',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('114',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w900)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded,
                        color: Colors.black87, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, Color(0xFF05132B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 1.5),
            ),
            child: const Icon(Icons.menu_book_rounded, color: _gold, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kur\'an-ı Kerim',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Kısa sureler · Arapça · Okunuş · Meal',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kategoriSection(KuranKategori k) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_stories_rounded, color: _navy, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(k.baslik,
                        style: const TextStyle(
                            color: _navy, fontSize: 15, fontWeight: FontWeight.w900)),
                    Text(k.altbaslik,
                        style: const TextStyle(color: Colors.black54, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${k.sureler.length} sure',
                    style: const TextStyle(
                        color: _red, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
        ...k.sureler.map((s) => _sureCard(s)),
      ],
    );
  }

  Widget _sureCard(Sure s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => QuranDetailPage(sure: s)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_navy, Color(0xFF1A3A5C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('${s.numarasi}',
                        style: const TextStyle(
                            color: _gold,
                            fontSize: 15,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.ad,
                          style: const TextStyle(
                              color: _navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 4, color: _red.withValues(alpha: 0.7)),
                          const SizedBox(width: 6),
                          Text('${s.ayetSayisi} âyet · ${s.inisYeri}',
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 11)),
                          const SizedBox(width: 6),
                          Icon(Icons.circle, size: 4, color: _red.withValues(alpha: 0.7)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(s.anlami,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 11),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.black26, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}