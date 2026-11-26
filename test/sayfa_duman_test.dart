// Duman testi: her baslik sayfasi aciliyor, ilk karelerde hata firlatmiyor mu?
// Kurallar: android/hooks/KURALLAR.md (T4)
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'yardimci/fontlar.dart';
import 'package:nur_pusulasi/app/admin_session.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';
import 'package:nur_pusulasi/app/favorites_service.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import 'package:nur_pusulasi/features/admin/admin_gate_page.dart';
import 'package:nur_pusulasi/features/admin/content_manager_page.dart';
import 'package:nur_pusulasi/features/assistant/pages/assistant_page.dart';
import 'package:nur_pusulasi/features/combo/pages/combo_page.dart';
import 'package:nur_pusulasi/features/family/pages/family_page.dart';
import 'package:nur_pusulasi/features/growth/daily_goals_page.dart';
import 'package:nur_pusulasi/features/growth/gratitude_journal_page.dart';
import 'package:nur_pusulasi/features/growth/growth_page.dart';
import 'package:nur_pusulasi/features/growth/reading_plan_page.dart';
import 'package:nur_pusulasi/features/growth/weekly_progress_page.dart';
import 'package:nur_pusulasi/features/hifz/pages/hifz_page.dart';
import 'package:nur_pusulasi/features/hijri/pages/hijri_page.dart';
import 'package:nur_pusulasi/features/home/home_page.dart';
import 'package:nur_pusulasi/features/journey/pages/journey_page.dart';
import 'package:nur_pusulasi/features/kandil/pages/kandil_page.dart';
import 'package:nur_pusulasi/features/khushu/pages/khushu_page.dart';
import 'package:nur_pusulasi/features/kissa/pages/kissa_kutuphanesi_page.dart';
import 'package:nur_pusulasi/features/learn/pages/learn_page.dart';
import 'package:nur_pusulasi/features/mood/pages/mood_page.dart';
import 'package:nur_pusulasi/features/notifications/notification_settings_page.dart';
import 'package:nur_pusulasi/features/profile/saved_items_page.dart';
import 'package:nur_pusulasi/features/qibla/qibla_page.dart';
import 'package:nur_pusulasi/features/quran/pages/quran_full_page.dart';
import 'package:nur_pusulasi/features/quran/pages/quran_page.dart';
import 'package:nur_pusulasi/features/settings/language_settings_page.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sayfalar = <String, Widget Function()>{
  'Ana Sayfa': () => const HomePage(),
  'Kible': () => const QiblaPage(),
  'Takip (Growth)': () => const GrowthPage(),
  'Gunluk Hedefler': () => const DailyGoalsPage(),
  'Sukur Defteri': () => const GratitudeJournalPage(),
  'Okuma Plani': () => const ReadingPlanPage(),
  'Haftalik Ilerleme': () => const WeeklyProgressPage(),
  'Kutuphane (Kuran)': () => const QuranPage(),
  'Kuran Tam': () => const QuranFullPage(),
  'Kissa Kutuphanesi': () => const KissaKutuphanesiPage(),
  'Kissa Detay': () => KissaDetayPage(kissa: islamiKissalar.first),
  'Namaz Ogren': () => const LearnPage(),
  'Husu': () => const KhushuPage(),
  'Ruh Hali': () => const MoodPage(),
  'Manevi Yolculuk': () => const JourneyPage(),
  'Hifz': () => const HifzPage(),
  'Hicri Takvim': () => const HijriPage(),
  'Kandiller': () => const KandilPage(),
  'Aile': () => const FamilyPage(),
  'Combo': () => const ComboPage(),
  'Asistan': () => const AssistantPage(),
  'Kaydedilenler': () => const SavedItemsPage(),
  'Dil Ayarlari': () => const LanguageSettingsPage(),
  'Bildirim Ayarlari': () => const NotificationSettingsPage(),
  'Admin Giris': () => const AdminGatePage(),
  'Icerik Yonetimi': () => const ContentManagerPage(),
};

void main() {
  late AppState appState;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await gercekFontlariYukle();
    SharedPreferences.setMockInitialValues({});
    appState = AppState();
    await appState.load();
    await ContentService.instance.load();
    await kissalariYukle();
    await FavoritesService.instance.load();
    await AdminSession.instance.load();
  });

  // Her sayfa uc dilde: ceviriler genelde Turkceden uzun, tasma yakalanir.
  for (final dil in const ['tr', 'en', 'ar']) {
    for (final e in sayfalar.entries) {
      testWidgets('Sayfa aciliyor [$dil]: ${e.key}', (tester) async {
        tester.view.physicalSize = const Size(1080, 2340);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        // Hatanin kaynagi (dosya:satir) loga dussun
        final onceki = FlutterError.onError;
        FlutterError.onError = (d) {
          final yer = d.toString().split('\n').where((s) => s.contains('lib/'));
          debugPrint(
              'KAYNAK [$dil] ${e.key}: ${d.exceptionAsString().split('\n').first} @ ${yer.take(2).join(' ')}');
          onceki?.call(d);
        };

        await tester.pumpWidget(ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            theme: ThemeData(fontFamily: 'Roboto'),
            locale: Locale(dil),
            supportedLocales: const [Locale('tr'), Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: e.value(),
          ),
        ));
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 300));
        }
        FlutterError.onError = onceki;
        expect(tester.takeException(), isNull);
        expect(find.byType(Scaffold), findsWidgets);
        // Zamanlayici/animasyon sizmasin
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 2));
      });
    }
  }
}
