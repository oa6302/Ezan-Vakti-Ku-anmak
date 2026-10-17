import 'package:flutter/material.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/header_v2.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/countdown_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/prayer_row.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/quick_grid.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/content_pair.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/dua_card.dart';
import 'package:nur_pusulasi/features/qibla/qibla_page.dart';
import 'package:nur_pusulasi/features/tesbih/tesbih_page.dart';
import 'package:nur_pusulasi/features/learn/pages/learn_page.dart';
import 'package:nur_pusulasi/features/journey/pages/journey_page.dart';
import 'package:nur_pusulasi/features/mood/pages/mood_page.dart';
import 'package:nur_pusulasi/features/reflection/pages/reflection_page.dart';
import 'package:nur_pusulasi/features/combo/pages/combo_page.dart';
import 'package:nur_pusulasi/features/khushu/pages/khushu_page.dart';
import 'package:nur_pusulasi/widgets/daily_content_card.dart';
import 'package:nur_pusulasi/widgets/kissa_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/risale_card.dart';
import 'package:nur_pusulasi/widgets/admin_mode_banner.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/vecize_card.dart';
import 'package:nur_pusulasi/features/growth/growth_page.dart';
import 'package:nur_pusulasi/features/growth/gratitude_journal_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openQuick(BuildContext context, String label) {
    Widget? page;
    switch (label) {
      case 'Kible':
      case 'KÄ±ble':
        page = const QiblaPage();
        break;
      case 'Tesbih':
        page = const TesbihPage();
        break;
      case 'Namaz Ogre':
      case 'Namaz Ã–ÄŸren':
        page = const LearnPage();
        break;
      case 'Yolculuk':
        page = const JourneyPage();
        break;
      case 'Ruh Halin':
        page = const MoodPage();
        break;
      case 'Tefekkur':
      case 'TefekkÃ¼r':
        page = const ReflectionPage();
        break;
      case 'Zikir Zinciri':
        page = const ComboPage();
        break;
      case 'Husu Takibi':
      case 'HuÅŸu Takibi':
        page = const KhushuPage();
        break;
      case 'Takip':
        page = const GrowthPage();
        break;
      case 'Sukur':
        page = const GratitudeJournalPage();
        break;
    }
    if (page != null) {
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page!));
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
                const AdminModeBanner(),
                // 1) NAMAZ BOLUMU (en ustte)
                const NextPrayerCountdown(),
                const SizedBox(height: 14),
                const PrayerRowV2(),
                const SizedBox(height: 14),
                // 2) GUNLUK ICERIK
                const DailyContentCard(),
                const SizedBox(height: 14),
                // 3) KISSA
                const KissaCard(),
                const SizedBox(height: 14),
                const RisaleCard(),
                const SizedBox(height: 14),
                const VecizeCard(),
                const SizedBox(height: 14),
                const ContentPair(),
                const SizedBox(height: 14),
                // 5) HIZLI ERISIM
                QuickGridV2(
                  onTap: (label) => _openQuick(context, label),
                ),
                const SizedBox(height: 14),
                // 6) GUNUN DUASI
                const DuaCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

