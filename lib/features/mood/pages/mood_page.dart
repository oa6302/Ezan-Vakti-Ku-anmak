import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import '../data/mood_data.dart';

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
  Mood? _selected;
  String? _historyHint;

  @override
  void initState() {
    super.initState();
    _loadLast();
  }

  Future<void> _loadLast() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('last_mood');
    if (id != null && mounted) {
      final m = moods.firstWhere(
        (m) => m.id == id,
        orElse: () => moods.first,
      );
      setState(() => _historyHint = 'Son seçtiğin: ${m.emoji} ${m.label}');
    }
  }

  Future<void> _select(Mood m) async {
    setState(() => _selected = m);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_mood', m.id);
    await prefs.setString(
        'last_mood_time', DateTime.now().toIso8601String());
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
      body: _selected == null ? _picker() : _suggestions(_selected!),
    );
  }

  Widget _picker() {
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
        const Text('Şu an nasıl hissediyorsun?',
            style: TextStyle(
                color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        const Text('Sana uygun ayet, hadis ve dua önerelim.',
            style: TextStyle(color: Colors.black54, fontSize: 11)),
        const SizedBox(height: 14),
        ...moods.map((m) => _moodTile(m)),
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
            width: 56, height: 56,
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
                Text('Ruh Haline Göre',
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

  Widget _moodTile(Mood m) {
    final color = Color(m.colorValue);
    return Container(
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
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: color.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Center(
                    child: Text(m.emoji,
                        style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.label,
                          style: TextStyle(
                              color: color,
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(m.description,
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
    );
  }

  Widget _suggestions(Mood m) {
    final color = Color(m.colorValue);
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _selectedHeader(m, color),
        const SizedBox(height: 14),
        ...m.suggestions.map((s) => _suggestionCard(s, color)),
        const SizedBox(height: 14),
        _footerNote(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _selectedHeader(Mood m, Color color) {
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
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(m.emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('${m.suggestions.length} öneri',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selected = null),
            icon: const Icon(Icons.swap_horiz_rounded,
                color: Colors.white, size: 24),
            tooltip: 'Başka ruh hali',
          ),
        ],
      ),
    );
  }

  Widget _suggestionCard(MoodSuggestion s, Color color) {
    return Container(
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
                child: Text(s.tip,
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
          Text(s.title,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  height: 1.3)),
          const SizedBox(height: 10),
          Text(s.text,
              style: const TextStyle(
                  color: Colors.black87, fontSize: 13, height: 1.7)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  child: Text(s.source,
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
      child: Row(
        children: const [
          Icon(Icons.info_outline_rounded, color: _gold, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Bu öneriler kişisel rehberlik amaçlıdır. Dinî hüküm gerektiren konularda ehil bir âlime danışınız.',
              style: TextStyle(color: _navy, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}