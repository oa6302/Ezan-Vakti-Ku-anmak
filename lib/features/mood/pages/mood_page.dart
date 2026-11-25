import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';
import 'package:nur_pusulasi/widgets/favorite_button.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});
  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  ContentItem? _selected;
  String? _historyHint;

  @override
  void initState() {
    super.initState();
    _loadLast();
  }

  Future<void> _loadLast() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('last_mood');
    if (id == null) return;
    final pool = ContentService.instance.getPool(ContentType.mood);
    if (pool.isEmpty) return;
    final m = pool.firstWhere((i) => i.id == id, orElse: () => pool.first);
    if (mounted) {
      final emoji = (m.extra?['emoji'] as String?) ?? '';
      setState(() => _historyHint = 'Son sectigin: $emoji ${m.baslik}');
    }
  }

  Future<void> _select(ContentItem m) async {
    setState(() => _selected = m);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_mood', m.id);
    await prefs.setString('last_mood_time', DateTime.now().toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Ruh Halin',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: ListenableBuilder(
        listenable: ContentService.instance,
        builder: (context, _) {
          return _selected == null ? _picker() : _suggestions(_selected!);
        },
      ),
    );
  }

  Widget _picker() {
    final pool = ContentService.instance.getPool(ContentType.mood);
    if (pool.isEmpty) {
      return const Center(
        child: Text('Ruh hali icerigi eklenmemis.',
            style: TextStyle(color: Colors.black54)),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _hero(),
        const SizedBox(height: 14),
        if (_historyHint != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, color: _green, size: 16),
                const SizedBox(width: 8),
                Text(_historyHint!,
                    style: const TextStyle(
                        color: _navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        const Text('Su an nasil hissediyorsun?',
            style: TextStyle(
                color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        const Text('Sana uygun ayet, hadis ve dua onerelim.',
            style: TextStyle(color: Colors.black54, fontSize: 11)),
        const SizedBox(height: 14),
        ...pool.map((m) => _moodTile(m)),
        const SizedBox(height: 20),
      ],
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
            ),
            child: const Icon(Icons.self_improvement_rounded,
                color: _gold, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ruh Haline Gore',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Kalbin ne söylüyorsa, ona uygun rehberlik.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _moodTile(ContentItem m) {
    final color = ContentService.instance.colorFor(m);
    final emoji = (m.extra?['emoji'] as String?) ?? '';
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.medium(),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _select(m),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: color.withValues(alpha: 0.25), width: 1),
                      ),
                      child: Center(
                        child: emoji.isNotEmpty
                            ? Text(emoji, style: const TextStyle(fontSize: 26))
                            : Icon(Icons.emoji_emotions_rounded,
                                color: color, size: 26),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.baslik,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 3),
                          Text(m.icerik,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: color, size: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [FavoriteButton(item: m), AdminEditOverlay(item: m)]),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _suggestionsOf(ContentItem m) {
    final raw = m.extra?['suggestions'];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  Widget _suggestions(ContentItem m) {
    final color = ContentService.instance.colorFor(m);
    final suggestions = _suggestionsOf(m);
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _selectedHeader(m, color, suggestions.length),
        const SizedBox(height: 14),
        ...suggestions.map((s) => _suggestionCard(s, color, m)),
        const SizedBox(height: 14),
        _footerNote(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _selectedHeader(ContentItem m, Color color, int count) {
    final emoji = (m.extra?['emoji'] as String?) ?? '';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.colored(color, alpha: 0.35),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: emoji.isNotEmpty
                  ? Text(emoji, style: const TextStyle(fontSize: 28))
                  : const Icon(Icons.emoji_emotions_rounded,
                      color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.baslik,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('$count oneri',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selected = null),
            icon: const Icon(Icons.swap_horiz_rounded,
                color: Colors.white, size: 24),
            tooltip: 'Baska ruh hali',
          ),
        ],
      ),
    );
  }

  Widget _suggestionCard(
      Map<String, dynamic> s, Color color, ContentItem parent) {
    final tip = (s['tip'] ?? '').toString();
    final title = (s['title'] ?? '').toString();
    final text = (s['text'] ?? '').toString();
    final source = (s['source'] ?? '').toString();

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.medium(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(tip,
                        style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                  ),
                  const Spacer(),
                  const Icon(Icons.bookmark_border_rounded,
                      color: Colors.black26, size: 18),
                ],
              ),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      height: 1.3)),
              const SizedBox(height: 10),
              Text(text,
                  style: const TextStyle(
                      color: Colors.black87, fontSize: 13, height: 1.7)),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(color: _gold, width: 3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.book_outlined, color: _gold, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(source,
                          style: const TextStyle(
                              color: _navy,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: AdminEditOverlay(item: parent),
        ),
      ],
    );
  }

  Widget _footerNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _gold, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Bu oneriler kisisel rehberlik amaclidir. Dini hukum gerektiren konularda ehil bir alime danisiniz.',
              style: TextStyle(color: _navy, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
