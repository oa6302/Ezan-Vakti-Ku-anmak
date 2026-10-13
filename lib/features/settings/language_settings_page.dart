import 'package:flutter/material.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import '../../app/settings_service.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});
  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String _currentLocale = 'tr';
  String _currentFont = 'matbu';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loc = await SettingsService.loadLocale();
    final font = await SettingsService.loadFontStyle();
    if (mounted) {
      setState(() {
        _currentLocale = loc?.languageCode ?? 'tr';
        _currentFont = font;
      });
    }
  }

  Future<void> _setLocale(String code) async {
    await SettingsService.saveLocale(code);
    setState(() => _currentLocale = code);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_localeLabel(code)} seçildi"),
          backgroundColor: _green,
        ),
      );
    }
  }

  Future<void> _setFont(String style) async {
    await SettingsService.saveFontStyle(style);
    setState(() => _currentFont = style);
  }

  String _localeLabel(String code) {
    switch (code) {
      case 'tr': return 'Türkçe';
      case 'en': return 'English';
      case 'ar': return 'العربية';
      default: return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: Text("${t.language} & ${t.fontStyle}",
            style: const TextStyle(
                color: _navy, fontSize: 16, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _sectionHeader(t.language, Icons.language_rounded),
          const SizedBox(height: 10),
          _localeTile('tr', 'Türkçe', 'Türkiye', '🇹🇷'),
          _localeTile('en', 'English', 'English', '🇬🇧'),
          _localeTile('ar', 'العربية', 'العربية', '🇸🇦'),
          const SizedBox(height: 24),
          _sectionHeader(t.fontStyle, Icons.text_fields_rounded),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _gold.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: _gold, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Arapça ve Osmanlıca metinler için yazı stili',
                    style: TextStyle(color: _navy, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _fontTile('rika', 'Rika (El yazısı)', 'الرقعة — El yazması hat'),
          _fontTile('matbu', 'Matbu (Basılı)', 'المطبوع — Kitap ve matbaa hattı'),
          const SizedBox(height: 24),
          _previewCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _navy.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: _navy, size: 20),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                color: _navy, fontSize: 15, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _localeTile(String code, String label, String sub, String flag) {
    final active = _currentLocale == code;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: active
            ? Border.all(color: _navy, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _setLocale(code),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                              color: _navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      Text(sub,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ),
                if (active)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: _green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fontTile(String id, String label, String sample) {
    final active = _currentFont == id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: active
            ? Border.all(color: _gold, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _setFont(id),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_navy, Color(0xFF05132B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'بسم',
                      style: TextStyle(
                        fontFamily: id == 'rika' ? 'Rika' : 'Matbu',
                        color: _gold,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                              color: _navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      Text(sample,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ),
                if (active)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: _gold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _previewCard() {
    final fontFamily = _currentFont == 'rika' ? 'Rika' : 'Matbu';
    return Container(
      padding: const EdgeInsets.all(18),
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
            children: const [
              Icon(Icons.visibility_rounded, color: _gold, size: 18),
              SizedBox(width: 8),
              Text('ÖNİZLEME',
                  style: TextStyle(
                      color: _gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 14),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 26,
                color: Colors.white,
                height: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Rahmân ve Rahîm olan Allah\'ın adıyla',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}