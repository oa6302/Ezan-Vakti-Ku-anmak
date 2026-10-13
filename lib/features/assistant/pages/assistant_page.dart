import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import 'package:nur_pusulasi/data/hybrid_content_repository.dart';
import '../data/assistant_engine.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});
  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final _ctrl = TextEditingController();
  final _repo = HybridContentRepository();
  List<AssistantMatch> _results = [];
  String? _hazir;
  String _query = '';
  bool _loading = false;
  bool _searched = false;

  static const _oneri = [
    'sabır nedir?',
    'namazda ne okunur?',
    'şükür hakkında ayet',
    'abdest nasıl alınır?',
    'tevekkül anlamı',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    if (q.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _query = q;
      _searched = true;
      _hazir = AssistantEngine.hazirCevap(q);
    });
    final all = await _repo.all();
    final found = AssistantEngine.search(q, all);
    if (!mounted) return;
    setState(() {
      _results = found;
      _loading = false;
    });
  }

  void _pickOneri(String s) {
    _ctrl.text = s;
    _search(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Akıllı Asistan',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _hero(),
          const SizedBox(height: 14),
          _searchBar(),
          const SizedBox(height: 12),
          if (!_searched) _oneriWrap(),
          const SizedBox(height: 14),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_searched) _resultsView(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.deep(),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
            ),
            child: const Icon(Icons.psychology_rounded,
                color: _gold, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kaynaklı Rehber',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Sorunu içerikler arasında ara.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium(),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _navy),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _ctrl,
              decoration: const InputDecoration(
                hintText: 'Örn. sabır, şükür, abdest...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              onSubmitted: _search,
            ),
          ),
          IconButton(
            onPressed: () => _search(_ctrl.text),
            icon: const Icon(Icons.send_rounded, color: _gold),
          ),
        ],
      ),
    );
  }

  Widget _oneriWrap() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Örnek Sorular',
              style: TextStyle(
                  color: _navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _oneri
                .map((s) => Material(
                      color: const Color(0xFFF3F6FA),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _pickOneri(s),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Text(s,
                              style: const TextStyle(
                                  color: _navy, fontSize: 12)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _resultsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hazir != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates_rounded,
                    color: _green, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(_hazir!,
                      style: const TextStyle(
                          color: _navy, fontSize: 12, height: 1.5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (_results.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.medium(),
            ),
            child: Column(
              children: [
                const Icon(Icons.search_off_rounded,
                    color: Colors.black26, size: 40),
                const SizedBox(height: 10),
                Text('"$_query" için sonuç bulunamadı',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: _navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text(
                  'Farklı kelimelerle dene veya mevcut içerikleri gözden geçir.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 11),
                ),
              ],
            ),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('${_results.length} sonuç bulundu',
                style: const TextStyle(
                    color: _navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 10),
          ..._results.map((r) => _resultCard(r)),
        ],
      ],
    );
  }

  Widget _resultCard(AssistantMatch r) {
    final item = r.item;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(item.kategori.toUpperCase(),
                    style: const TextStyle(
                        color: _gold,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${(r.score * 10).toStringAsFixed(1)} puan',
                    style: const TextStyle(
                        color: _green,
                        fontSize: 9,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item.baslik,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(item.metin,
              style: const TextStyle(
                  color: Colors.black87, fontSize: 12, height: 1.6),
              maxLines: 4,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                  left: BorderSide(color: _gold, width: 3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.book_outlined,
                    color: _gold, size: 12),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(item.kaynak,
                      style: const TextStyle(
                          color: _navy,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}