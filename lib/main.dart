import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/features/qibla/qibla_page.dart';
import 'features/growth/growth_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/theme.dart';
import 'app/settings_service.dart';
import 'app/app_settings.dart';
import 'app/state/app_state.dart';
import 'app/widget_sync_service.dart';
import 'app/content_service.dart';
import 'app/favorites_service.dart';
import 'app/admin_session.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'features/home/home_page.dart';
import 'features/learn/pages/learn_page.dart';
import 'features/quran/pages/quran_page.dart';
import 'features/notifications/data/notification_service.dart';
import 'features/notifications/notification_settings_page.dart';
import 'features/settings/language_settings_page.dart';
import 'features/journey/pages/journey_page.dart';
import 'features/mood/pages/mood_page.dart';
import 'features/khushu/pages/khushu_page.dart';
import 'features/growth/gratitude_journal_page.dart';
import 'features/assistant/pages/assistant_page.dart';
import 'features/admin/admin_gate_page.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  // Bir servisin hatasi uygulamanin acilmasini engellemesin.
  await _guvenli('bildirim', () => NotificationService().init());
  await _guvenli('ayarlar', appState.load);
  // Icerik servisini yukle (kissa, dua, vecize havuzlari)
  await _guvenli('icerik', ContentService.instance.load);
  await _guvenli('favoriler', FavoritesService.instance.load);
  await _guvenli('admin', AdminSession.instance.load);

  runApp(
    ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: const NurPusulasiApp(),
    ),
  );
}

Future<void> _guvenli(String ad, Future<void> Function() is_) async {
  try {
    await is_();
  } catch (e, s) {
    debugPrint('Acilis hatasi ($ad): $e\n$s');
  }
}

/// Ana ekran widget'lari sadece mobil cihazlarda var (web/masaustunde yok).
bool get _mobil =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

class NurPusulasiApp extends StatefulWidget {
  const NurPusulasiApp({super.key});
  @override
  State<NurPusulasiApp> createState() => _NurPusulasiAppState();
}

class _NurPusulasiAppState extends State<NurPusulasiApp> {
  @override
  void initState() {
    super.initState();
    SettingsService.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: AppSettings.instance.locale,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'Ezan Vakti Kuşanmak',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: context.watch<AppState>().themeMode,
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
          locale: locale,
          builder: (context, child) {
            // Layout her zaman LTR; Arapca metinler ArabicText ile RTL
            return Directionality(
              textDirection: TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const MainShell(),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  String _lastLocationKey = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshNotifications();
    });
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted) return;

    final appState = context.watch<AppState>();
    final locationKey =
        '${appState.city}|${appState.district}|${appState.lat ?? ''}|${appState.lng ?? ''}';

    if (appState.city.isNotEmpty && locationKey != _lastLocationKey) {
      final isFirst = _lastLocationKey.isEmpty;
      _lastLocationKey = locationKey;

      if (!isFirst) {
        _refreshNotifications();
      }
    }
  }

  Future<void> _refreshNotifications() async {
    final appState = context.read<AppState>();
    // Namaz vakitleri ve gunun ayetini Android ana ekran widget'larina aktar.
    if (_mobil) {
      try {
        await WidgetSyncService.sync(appState);
      } catch (e) {
        debugPrint('Widget sync error: $e');
      }
    }

    if (!mounted || kIsWeb) return;
    if (appState.notifEnabled) {
      try {
        await NotificationService().scheduleAll(
          city: appState.city,
          latitude: appState.lat,
          longitude: appState.lng,
          locationLabel: appState.locationName,
        );
      } catch (e) {
        debugPrint('Bildirim planlama hatasi: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: IndexedStack(
            index: appState.lastTab,
            children: [
              QiblaPage(),
              GrowthPage(),
              HomePage(),
              QuranPage(),
              _SettingsHub(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        current: appState.lastTab,
        onTap: (i) => context.read<AppState>().setLastTab(i),
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
          _tile(
              context,
              Icons.favorite_rounded,
              'Huşu Takibi',
              'Kalp huzurunu fark et',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const KhushuPage()))),
          _tile(
              context,
              Icons.menu_book_rounded,
              'Namaz Öğre',
              'Adım adım rehber',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const LearnPage()))),
          _tile(
              context,
              Icons.self_improvement_rounded,
              'Ruh Halin',
              'Kalbin ne söylüyorsa',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const MoodPage()))),
          _tile(
              context,
              Icons.auto_awesome_rounded,
              'Manevi Yolculuk',
              'Isı haritası · Seri · Seviye',
              () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const JourneyPage()))),
          _tile(
              context,
              Icons.volunteer_activism_rounded,
              'Sukur Defteri',
              'Nimeti fark et, kalbi besle',
              () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const GratitudeJournalPage()))),
          _tile(
              context,
              Icons.language_rounded,
              'Dil ve Yazı Stili',
              'Türkçe · English · العربية',
              () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const LanguageSettingsPage()))),
          _tile(
              context,
              Icons.notifications_active_rounded,
              'Bildirim Ayarları',
              'Vakit hatırlatmaları',
              () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const NotificationSettingsPage()))),
          _tile(
              context,
              Icons.psychology_rounded,
              'Akıllı Asistan',
              'Kaynaklı soru-cevap',
              () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const AssistantPage()))),
          _tile(
              context,
              Icons.admin_panel_settings_rounded,
              'Admin Paneli',
              'Icerik havuzlarini yonet (PIN: 2580)',
              () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const AdminGatePage()))),
          _tile(
              context,
              Icons.info_outline_rounded,
              'Uygulama Hakkında',
              'Sürüm 1.0.0 · Ezan Vakti Kuşanmak',
              () => showAboutDialog(
                    context: context,
                    applicationName: 'Ezan Vakti Kuşanmak',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(Icons.mosque_rounded,
                        color: _gold, size: 48),
                    children: [
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
                  _navItem(0, Icons.explore_rounded, 'Pusula'),
                  _navItem(1, Icons.track_changes_rounded, 'Takip'),
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
                      width: 64,
                      height: 64,
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
              Icon(icon, size: 22, color: active ? _red : Colors.grey[400]),
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
