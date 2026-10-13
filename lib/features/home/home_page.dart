import 'package:flutter/material.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/header_v2.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/countdown_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/prayer_row.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/content_pair.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/quick_grid.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/vecize_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/risale_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/dua_card.dart';
import 'package:nur_pusulasi/features/qibla/qibla_page.dart';
import 'package:nur_pusulasi/features/tesbih/tesbih_page.dart';
import 'package:nur_pusulasi/features/learn/pages/learn_page.dart';
import 'package:nur_pusulasi/features/quran/pages/quran_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openQuick(BuildContext context, String label) {
    Widget? page;
    switch (label) {
      case 'Kıble':
        page = const QiblaPage();
        break;
      case 'Tesbih':
        page = const TesbihPage();
        break;
      case 'Namaz Öğren':
        page = const LearnPage();
        break;
      case 'Kütüphane':
        page = const QuranPage();
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
                const NextPrayerCountdown(),
                const SizedBox(height: 14),
                const PrayerRowV2(),
                const SizedBox(height: 14),
                const ContentPair(),
                const SizedBox(height: 14),
                QuickGridV2(
                  onTap: (label) => _openQuick(context, label),
                ),
                const SizedBox(height: 14),
                const VecizeCard(),
                const SizedBox(height: 14),
                const RisaleCard(),
                const SizedBox(height: 14),
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