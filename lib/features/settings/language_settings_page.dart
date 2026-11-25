import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import '../../app/settings_service.dart';
import '../../app/app_settings.dart';
import 'package:provider/provider.dart';
import '../../app/state/app_state.dart';

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
  String? _widgetBackgroundPath;

  @override
  void initState() {
    super.initState();
    _load();
    _loadWidgetBackground();
  }

  Future<void> _load() async {
    await SettingsService.loadAll();
    if (mounted) {
      setState(() {
        _currentLocale = AppSettings.instance.locale.value.languageCode;
        _currentFont = AppSettings.instance.fontStyle.value;
      });
    }
  }

  Future<void> _setLocale(String code) async {
    await SettingsService.saveLocale(code);
    setState(() => _currentLocale = code);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_localeLabel(code)} seÃ§ildi"),
          backgroundColor: _green,
        ),
      );
    }
  }

  Future<void> _setFont(String style) async {
    await SettingsService.saveFontStyle(style);
    setState(() => _currentFont = style);
  }

  Future<void> _loadWidgetBackground() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('widget_background_path');
    if (mounted) {
      setState(() => _widgetBackgroundPath =
          path != null && File(path).existsSync() ? path : null);
    }
  }

  Future<void> _pickWidgetBackground() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (picked == null) return;

      final directory = await getApplicationSupportDirectory();
      final extension = picked.path.contains('.')
          ? picked.path.split('.').last.toLowerCase()
          : 'jpg';

      final destination =
          '${directory.path}/widget_background.$extension';

      final savedFile = await File(picked.path).copy(destination);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('widget_background_path', savedFile.path);

      await const MethodChannel('nur_pusulasi/widgets').invokeMethod<void>(
        'setBackground',
        <String, String>{'path': savedFile.path},
      );

      if (!mounted) return;
      setState(() => _widgetBackgroundPath = savedFile.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Widget fotoğrafı güncellendi.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fotoğraf seçilemedi: $error')),
      );
    }
  }

  Future<void> _resetWidgetBackground() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('widget_background_path');

      await const MethodChannel('nur_pusulasi/widgets').invokeMethod<void>(
        'setBackground',
        <String, String>{'path': ''},
      );

      if (!mounted) return;
      setState(() => _widgetBackgroundPath = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Varsayılan arka plana dönüldü.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İşlem başarısız: $error')),
      );
    }
  }

  Widget _widgetBackgroundSection() {
    final path = _widgetBackgroundPath;
    final hasImage = path != null && File(path).existsSync();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 135,
              width: double.infinity,
              child: hasImage
                  ? Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text('Fotoğraf önizlemesi açılamadı'),
                      ),
                    )
                  : Container(
                      color: _navy,
                      child: const Center(
                        child: Icon(
                          Icons.mosque_rounded,
                          color: _gold,
                          size: 48,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hasImage
                ? 'Kişisel fotoğrafın seçili'
                : 'Henüz kişisel fotoğraf seçilmedi',
            style: const TextStyle(
              color: _navy,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _pickWidgetBackground,
              icon: const Icon(Icons.photo_library_rounded),
              label: const Text('Galeriden fotoğraf seç'),
              style: FilledButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          if (hasImage)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _resetWidgetBackground,
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Varsayılan arka plana dön'),
                style: TextButton.styleFrom(foregroundColor: _navy),
              ),
            ),
        ],
      ),
    );
  }
  List<Widget> _themeTiles(BuildContext context) {
    final current = context.watch<AppState>().themeMode;
    return [
      _themeTile(context, ThemeMode.light, 'Aydinlik', Icons.wb_sunny_rounded,
          current),
      _themeTile(
          context, ThemeMode.dark, 'Karanlik', Icons.nightlight_round, current),
      _themeTile(context, ThemeMode.system, 'Sistem',
          Icons.settings_brightness_rounded, current),
    ];
  }

  Widget _themeTile(BuildContext context, ThemeMode mode, String label,
      IconData icon, ThemeMode current) {
    final secili = current == mode;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: secili ? _gold : Colors.black.withValues(alpha: 0.06),
          width: secili ? 1.6 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _navy.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _navy, size: 20),
        ),
        title: Text(label,
            style: const TextStyle(
                color: _navy, fontSize: 14, fontWeight: FontWeight.w800)),
        trailing: secili
            ? const Icon(Icons.check_circle_rounded, color: _green, size: 22)
            : const Icon(Icons.circle_outlined,
                color: Colors.black26, size: 22),
        onTap: () async {
          await context.read<AppState>().setThemeMode(mode);
        },
      ),
    );
  }

  String _localeLabel(String code) {
    switch (code) {
      case 'tr':
        return 'TÃ¼rkÃ§e';
      case 'en':
        return 'English';
      case 'ar':
        return 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©';
      default:
        return code;
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
          _sectionHeader('Tema', Icons.dark_mode_rounded),
          const SizedBox(height: 10),
          ..._themeTiles(context),
          const SizedBox(height: 22),
          _sectionHeader('Widget arka planı', Icons.wallpaper_rounded),
          const SizedBox(height: 10),
          _widgetBackgroundSection(),
          const SizedBox(height: 22),
          _sectionHeader(t.language, Icons.language_rounded),
          const SizedBox(height: 10),
          _localeTile('tr', 'TÃ¼rkÃ§e', 'TÃ¼rkiye', 'ğŸ‡¹ğŸ‡·'),
          _localeTile('en', 'English', 'English', 'ğŸ‡¬ğŸ‡§'),
          _localeTile('ar', 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©', 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©', 'ğŸ‡¸ğŸ‡¦'),
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
                    'ArapÃ§a ve OsmanlÄ±ca metinler iÃ§in yazÄ± stili',
                    style: TextStyle(color: _navy, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _fontTile('rika', 'Rika (El yazÄ±sÄ±)', 'Ø§Ù„Ø±Ù‚Ø¹Ø© â€” El yazmasÄ± hat'),
          _fontTile(
              'matbu', 'Matbu (BasÄ±lÄ±)', 'Ø§Ù„Ù…Ø·Ø¨ÙˆØ¹ â€” Kitap ve matbaa hattÄ±'),
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
                  width: 50,
                  height: 50,
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
                      'Ø¨Ø³Ù…',
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
              Text('Ã–NÄ°ZLEME',
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
              'Ø¨ÙØ³Ù’Ù…Ù Ø§Ù„Ù„ÙÙ‘Ù‡Ù Ø§Ù„Ø±ÙÙ‘Ø­Ù’Ù…ÙÙ†Ù Ø§Ù„Ø±ÙÙ‘Ø­ÙÙŠÙ…Ù',
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
            'RahmÃ¢n ve RahÃ®m olan Allah\'Ä±n adÄ±yla',
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

