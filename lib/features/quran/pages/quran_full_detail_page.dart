import 'package:flutter/material.dart';
import '../data/quran_api_service.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);

class QuranFullDetailPage extends StatefulWidget {
  final ApiChapter chapter;
  const QuranFullDetailPage({super.key, required this.chapter});
  @override
  State<QuranFullDetailPage> createState() => _QuranFullDetailPageState();
}

class _QuranFullDetailPageState extends State<QuranFullDetailPage> {
  final _service = QuranApiService();
  List<ApiVerse> _verses = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final list = await _service.fetchVerses(widget.chapter.id);
    if (!mounted) return;
    setState(() {
      _verses = list;
      _loading = false;
      _error = list.isEmpty ? 'Ayetler yuklenemedi.' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.chapter.translatedName.isEmpty
        ? widget.chapter.nameSimple
        : widget.chapter.translatedName;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: Text(title,
            style: const TextStyle(
                color: _navy, fontSize: 16, fontWeight: FontWeight.w900)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _errorView()
              : _list(),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, color: _navy, size: 48),
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: _navy)),
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: _navy),
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _verses.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) return _header();
        return _card(_verses[i - 1]);
      },
    );
  }

  Widget _header() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, Color(0xFF05132B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(widget.chapter.nameArabic,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _gold,
                  fontSize: 30,
                  fontFamily: 'Matbu',
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            '${widget.chapter.translatedName} - ${widget.chapter.versesCount} ayet',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _card(ApiVerse v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              v.arabic,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 24,
                  height: 1.9,
                  fontFamily: 'Matbu',
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${v.verseNumber}',
                    style: const TextStyle(
                        color: _navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(v.turkish,
                    style: const TextStyle(
                        color: _navy, fontSize: 13, height: 1.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
