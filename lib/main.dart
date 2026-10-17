import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/theme.dart';
import 'app/settings_service.dart';
import 'app/app_settings.dart';
import 'app/state/app_state.dart';
import 'app/content_service.dart';
import 'app/favorites_service.dart';
import 'app/admin_session.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'features/home/home_page.dart';
import 'features/prayer/namazim_page.dart';
import 'features/quran/pages/quran_page.dart';
import 'features/notifications/data/notification_service.dart';
import 'features/notifications/notification_settings_page.dart';
import 'features/settings/language_settings_page.dart';
import 'features/journey/pages/journey_page.dart';
import 'features/mood/pages/mood_page.dart';
import 'features/reflection/pages/reflection_page.dart';
import 'features/combo/pages/combo_page.dart';
import 'features/khushu/pages/khushu_page.dart';
import 'features/hifz/pages/hifz_page.dart';
import 'features/hijri/pages/hijri_page.dart';
import 'features/prayer/pages/vakitler_page.dart';
import 'features/growth/gratitude_journal_page.dart';
import 'features/kandil/pages/kandil_page.dart';
import 'features/family/pages/family_page.dart';
import 'features/assistant/pages/assistant_page.dart';
import 'features/admin/admin_gate_page.dart';
import 'features/profile/saved_items_page.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  final appState = AppState();
  await appState.load();

  // Icerik servisini yukle (kissa, dua, vecize havuzlari)
  await ContentService.instance.load();
      await FavoritesService.instance.load();
  await AdminSession.instance.load();

  runApp(
    ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: const NurPusulasiApp(),
    ),
  );
}

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
          title: '5 Vakit Namaz',
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
  String _lastCity = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshNotifications());
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
    final city = context.watch<AppState>().city;
    if (city.isNotEmpty && city != _lastCity) {
      final isFirst = _lastCity.isEmpty;
      _lastCity = city;
      // Ilk yukleme degil, gercek sehir degisimi
      if (!isFirst) {
        _refreshNotifications();
      }
    }
  }

  Future<void> _refreshNotifications() async {
    if (!mounted) return;
    final appState = context.read<AppState>();
    if (appState.notifEnabled) {
      await NotificationService().scheduleAll(city: appState.city);
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
            children: const [
          HomePage(),
          VakitlerPage(),
          NamazimPage(),
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
          _tile(context, Icons.favorite_rounded, 'Huşu Takibi',
              'Kalp huzurunu fark et',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const KhushuPage()))),
          _tile(context, Icons.auto_awesome_rounded, 'Zikir Zinciri',
              '33+33+33+1 otomatik akış',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const ComboPage()))),
          _tile(context, Icons.psychology_alt_rounded, 'Namaz Sonrası Tefekkür',
              '30 saniyelik kalp muhasebesi',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const ReflectionPage()))),
          _tile(context, Icons.self_improvement_rounded, 'Ruh Halin',
              'Kalbin ne söylüyorsa',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const MoodPage()))),
          _tile(context, Icons.auto_awesome_rounded, 'Manevi Yolculuk',
              'Isı haritası · Seri · Seviye',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const JourneyPage()))),
          _tile(context, Icons.volunteer_activism_rounded, 'Sukur Defteri',
              'Nimeti fark et, kalbi besle',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const GratitudeJournalPage()))),
          _tile(context, Icons.language_rounded, 'Dil ve Yazı Stili',
              'Türkçe · English · العربية',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const LanguageSettingsPage()))),
          _tile(context, Icons.notifications_active_rounded, 'Bildirim Ayarları',
              'Vakit hatırlatmaları',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const NotificationSettingsPage()))),
          _tile(context, Icons.psychology_rounded, 'Akıllı Asistan',
              'Kaynaklı soru-cevap',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const AssistantPage()))),
          _tile(context, Icons.family_restroom_rounded, 'Aile Modu',
              'Çocuklarla namaz öğren',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const FamilyPage()))),
          _tile(context, Icons.star_rounded, 'Kandil & Özel Günler',
              'Yaklaşan mübarek geceler',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const KandilPage()))),
          _tile(context, Icons.calendar_month_rounded, 'Hicri Yaşam Çizgisi',
              'Kaç Ramazan yaşadın?',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const HijriPage()))),
          _tile(context, Icons.mic_rounded, 'Sesli Ezber Kontrolü',
              'Ezberini sesli test et',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const HifzPage()))),
          _tile(context, Icons.bookmark_rounded, 'Favorilerim',
              'Kaydettigin icerikler',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const SavedItemsPage()))),
          _tile(context, Icons.admin_panel_settings_rounded, 'Admin Paneli',
              'Icerik havuzlarini yonet (PIN: 2580)',
              () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (_) => const AdminGatePage()))),
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
