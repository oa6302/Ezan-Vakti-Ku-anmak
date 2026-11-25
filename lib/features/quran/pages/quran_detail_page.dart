import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nur_pusulasi/app/arabic_text.dart';
import 'package:nur_pusulasi/app/app_settings.dart';
import '../data/quran_models.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class QuranDetailPage extends StatefulWidget {
  final Sure sure;
  const QuranDetailPage({super.key, required this.sure});
  @override
  State<QuranDetailPage> createState() => _QuranDetailPageState();
}

class _QuranDetailPageState extends State<QuranDetailPage> {
  bool _isFavorite = false;
  double _fontSize = 16;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('quran_favs') ?? [];
    setState(() {
      _isFavorite = favs.contains(widget.sure.id);
      _fontSize = prefs.getDouble('quran_font_size') ?? 16;
    });
  }

  Future<void> _toggleFav() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('quran_favs') ?? [];
    if (_isFavorite) {
      favs.remove(widget.sure.id);
    } else {
      favs.add(widget.sure.id);
    }
    await prefs.setStringList('quran_favs', favs);
    setState(() => _isFavorite = !_isFavorite);
  }

  Future<void> _changeFont(double delta) async {
    final v = (_fontSize + delta).clamp(12.0, 24.0);
    setState(() => _fontSize = v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('quran_font_size', v);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.sure;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: Text(s.ad,
            style: const TextStyle(
                color: _navy, fontSize: 16, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: _isFavorite ? _red : _navy,
            ),
            onPressed: _toggleFav,
            tooltip: _isFavorite ? 'Favorilerden çıkar' : 'Favorilere ekle',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _header(s),
          const SizedBox(height: 14),
          _fontController(),
          const SizedBox(height: 14),
          _arapcaCard(s),
          const SizedBox(height: 12),
          _okunusCard(s),
          const SizedBox(height: 12),
          _mealCard(s),
          if (s.fazilet.isNotEmpty) ...[
            const SizedBox(height: 12),
            _faziletCard(s),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _header(Sure s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, Color(0xFF05132B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: _gold, width: 1.5),
                ),
                child: Text('${s.numarasi}',
                    style: const TextStyle(
                        color: _gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.ad,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(s.anlami,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _chip('${s.ayetSayisi} âyet', Icons.format_list_numbered_rounded),
              const SizedBox(width: 8),
              _chip(s.inisYeri, Icons.location_on_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 13),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _fontController() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.text_fields_rounded, color: _navy, size: 18),
          const SizedBox(width: 10),
          const Text('Yazı boyutu',
              style: TextStyle(
                  color: _navy, fontSize: 13, fontWeight: FontWeight.w700)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.remove_rounded, color: _navy),
            onPressed: () => _changeFont(-1),
            tooltip: 'Küçült',
          ),
          Text('${_fontSize.round()}',
              style: const TextStyle(
                  color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: _navy),
            onPressed: () => _changeFont(1),
            tooltip: 'Büyüt',
          ),
        ],
      ),
    );
  }

  Widget _arapcaCard(Sure s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: _gold, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book_rounded, color: _gold, size: 16),
              SizedBox(width: 6),
              Text('ARAPÇA',
                  style: TextStyle(
                      color: _gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<String>(
            valueListenable: AppSettings.instance.fontStyle,
            builder: (context, fontStyle, _) => ArabicText(
              s.arapca,
              rika: fontStyle == 'rika',
              fontSize: _fontSize + 4,
              color: _navy,
              height: 2.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _okunusCard(Sure s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: _navy.withValues(alpha: 0.5), width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.record_voice_over_rounded, color: _navy, size: 16),
              SizedBox(width: 6),
              Text('OKUNUŞ',
                  style: TextStyle(
                      color: _navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 12),
          Text(s.okunus,
              style: TextStyle(
                  fontSize: _fontSize - 1,
                  color: _navy,
                  height: 1.8,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _mealCard(Sure s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: _green, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.translate_rounded, color: _green, size: 16),
              SizedBox(width: 6),
              Text('MEAL',
                  style: TextStyle(
                      color: _green,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 12),
          Text(s.meal,
              style: TextStyle(
                  fontSize: _fontSize - 1, color: Colors.black87, height: 1.8)),
        ],
      ),
    );
  }

  Widget _faziletCard(Sure s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: _gold, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(s.fazilet,
                style:
                    const TextStyle(color: _navy, fontSize: 12, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
