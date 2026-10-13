import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/theme.dart';
import 'app/settings_service.dart';
import 'l10n/app_localizations.dart';
import 'features/home/home_page.dart';
import 'features/prayer/namazim_page.dart';
import 'features/quran/pages/quran_page.dart';
import 'features/notifications/data/notification_service.dart';
import 'features/notifications/notification_settings_page.dart';
import 'features/settings/language_settings_page.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const NurPusulasiApp());
}

class NurPusulasiApp extends StatefulWidget {
  const NurPusulasiApp({super.key});
  @override
  State<NurPusulasiApp> createState() => _NurPusulasiAppState();
}

class _NurPusulasiAppState extends State<NurPusulasiApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final loc = await SettingsService.loadLocale();
    if (mounted) setState(() => _locale = loc);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5 Vakit Namaz',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
        Locale('ar'),
      ],
      locale: _locale,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNotifications();
    }
  }

  Future<void> _refreshNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('prayer_city_v2') ?? 'İstanbul';
    final enabled = prefs.getBool('notif_enabled') ?? true;
    if (enabled) {
      await NotificationService().scheduleAll(city: city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      body: IndexedStack(
        index: _index,
        children: const [
          HomePage(),
          _PlaceholderTab(label: 'Vakitler', icon: Icons.access_time_rounded),
          NamazimPage(),
          QuranPage(),
          _SettingsHub(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        current: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  final IconData icon;
  const _PlaceholderTab({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: Text(label,
            style: const TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: _navy.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text('$label yakında',
                style: const TextStyle(
                    color: _navy, fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _SettingsHub extends StatelessWidget {
  const _SettingsHub();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Daha Fazla',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _tile(context, Icons.language_rounded, 'Dil ve Yazı Stili',
              'Türkçe · English · العربية',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const LanguageSettingsPage()))),
          _tile(context, Icons.notifications_active_rounded, 'Bildirim Ayarları',
              'Vakit hatırlatmaları',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const NotificationSettingsPage()))),
          _tile(context, Icons.info_outline_rounded, 'Uygulama Hakkında',
              'Sürüm 1.0.0 · 5 Vakit Namaz',
              () => showAboutDialog(
                    context: context,
                    applicationName: '5 Vakit Namaz',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(Icons.mosque_rounded,
                        color: _gold, size: 48),
                    children: const [
                      Text(
                          'Namaz merkezli ibadet rehberi. Tüm veriler cihazınızda saklanır.'),
                    ],
                  )),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _navy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: _navy, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: _navy,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 11)),
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

class _BottomNav extends StatelessWidget {
  final int current;
  final void Function(int) onTap;
  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  _navItem(0, Icons.home_rounded, 'Ana Sayfa'),
                  _navItem(1, Icons.access_time_rounded, 'Vakitler'),
                  const SizedBox(width: 70),
                  _navItem(3, Icons.menu_book_rounded, 'Kütüphane'),
                  _navItem(4, Icons.more_horiz_rounded, 'Daha Fazla'),
                ],
              ),
              Positioned(
                top: -28,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(2),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [_navy, Color(0xFF05132B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: _gold, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: _navy.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.mosque_rounded,
                          color: _gold, size: 32),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, String label) {
    final active = current == i;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(i),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 22,
                  color: active ? _red : Colors.grey[400]),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                      fontSize: 9.5,
                      color: active ? _red : Colors.grey[500],
                      fontWeight: active ? FontWeight.w800 : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}