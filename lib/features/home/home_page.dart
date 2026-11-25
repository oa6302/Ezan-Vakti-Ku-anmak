import 'package:flutter/material.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/header_v2.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/countdown_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/prayer_row.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/quick_grid.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/favorites_mini_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/content_pair.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/daily_verse_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/dua_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/kissa_365_card.dart';
import 'package:nur_pusulasi/features/qibla/qibla_page.dart';
import 'package:nur_pusulasi/features/learn/pages/learn_page.dart';
import 'package:nur_pusulasi/features/journey/pages/journey_page.dart';
import 'package:nur_pusulasi/features/mood/pages/mood_page.dart';
import 'package:nur_pusulasi/features/combo/pages/combo_page.dart';
import 'package:nur_pusulasi/features/khushu/pages/khushu_page.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/risale_card.dart';
import 'package:nur_pusulasi/widgets/admin_mode_banner.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/vecize_card.dart';
import 'package:nur_pusulasi/features/growth/growth_page.dart';
import 'package:nur_pusulasi/features/growth/gratitude_journal_page.dart';
import 'package:nur_pusulasi/features/assistant/pages/assistant_page.dart';
import 'package:nur_pusulasi/features/family/pages/family_page.dart';
import 'package:nur_pusulasi/features/kandil/pages/kandil_page.dart';
import 'package:nur_pusulasi/features/hijri/pages/hijri_page.dart';
import 'package:nur_pusulasi/features/hifz/pages/hifz_page.dart';
import 'package:nur_pusulasi/features/profile/saved_items_page.dart';
import 'package:nur_pusulasi/features/kissa/pages/kissa_kutuphanesi_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openQuick(BuildContext context, String label) {
    Widget? page;
    switch (label) {
      case 'Kıble':
        page = const QiblaPage();
        break;
      case 'Tesbih':
        page = const ComboPage();
        break;
      case 'Takip':
        page = const GrowthPage();
        break;
      case 'Namaz Ogre': // ⚠️ Türkçe karakter kontrolü için aşağıdaki nota bak
        page = const LearnPage();
        break;
      case 'Manevi Yolculuk':
        page = const JourneyPage();
        break;
      case 'Ruh Halin':
        page = const MoodPage();
        break;
      case 'Huşu Takibi':
        page = const KhushuPage();
        break;
      case 'Kıssalar':
        page = const KissaKutuphanesiPage();
        break;
      case 'Şükür':
        page = const GratitudeJournalPage();
        break;
      case 'Akıllı Asistan':
        page = const AssistantPage();
        break;
      case 'Aile Modu':
        page = const FamilyPage();
        break;
      case 'Kandil & Özel Günler':
        page = const KandilPage();
        break;
      case 'Hicri Yaşam Çizgisi':
        page = const HijriPage();
        break;
      case 'Sesli Ezber Kontrolü':
        page = const HifzPage();
        break;
      case 'Favorilerim':
        page = const SavedItemsPage();
        break;
    }

    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => page!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      body: Column(
        children: [
          const HomeHeaderV2(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 14, bottom: 100),
              children: [
                AdminModeBanner(),
                SizedBox(height: 8),
                FavoritesMiniCard(),
                SizedBox(height: 6),

                // 1) NAMAZ BÖLÜMÜ
                NextPrayerCountdown(),
                SizedBox(height: 14),
                PrayerRowV2(),
                SizedBox(height: 14),

                // 2) HIZLI ER���M
                QuickGridV2(
                  onTap: (label) => _openQuick(context, label),
                ),
                const SizedBox(height: 14),

                // 2) GÜNLÜK İÇERİK
                DailyVerseCard(),
                SizedBox(height: 14),

                // 4) İÇERİK ÇİFTİ
                ContentPair(),
                SizedBox(height: 14),

                // 5) RİSALE
                RisaleCard(),
                SizedBox(height: 14),

                // 6) VECİZE
                VecizeCard(),
                SizedBox(height: 14),

                // 7) DUA
                DuaCard(),
                const SizedBox(height: 14),
                const Kissa365Card(),
                SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
