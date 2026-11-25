import 'package:flutter/material.dart';
import '../data/quran_api_service.dart';
import 'quran_full_detail_page.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);

class QuranFullPage extends StatefulWidget {
  const QuranFullPage({super.key});
  @override
  State<QuranFullPage> createState() => _QuranFullPageState();
}

class _QuranFullPageState extends State<QuranFullPage> {
  final _service = QuranApiService();
  List<ApiChapter> _chapters = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool force = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final list = await _service.fetchChapters(forceRefresh: force);
    if (!mounted) return;
    setState(() {
      _chapters = list;
      _loading = false;
      _error =
          list.isEmpty ? 'Baglanti kurulamadi. Interneti kontrol edin.' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Kurani Kerim',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: _navy),
            onPressed: () => _load(force: true),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _errorView()
              : _listView(),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, color: _navy, size: 64),
            const SizedBox(height: 16),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _navy, fontSize: 14)),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: _navy),
              onPressed: () => _load(force: true),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listView() {
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: _chapters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _tile(_chapters[i]),
    );
  }

  Widget _tile(ApiChapter ch) {
    final place = ch.revelationPlace == 'makkah' ? 'Mekke' : 'Medine';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (_) => QuranFullDetailPage(chapter: ch)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_navy, Color(0xFF05132B)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('${ch.id}',
                      style: const TextStyle(
                          color: _gold,
                          fontSize: 14,
                          fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ch.translatedName.isEmpty
                          ? ch.nameSimple
                          : ch.translatedName,
                      style: const TextStyle(
                          color: _navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text('${ch.versesCount} ayet - $place',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 11)),
                  ],
                ),
              ),
              Text(ch.nameArabic,
                  style: const TextStyle(
                      color: _navy,
                      fontSize: 22,
                      fontFamily: 'Matbu',
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
