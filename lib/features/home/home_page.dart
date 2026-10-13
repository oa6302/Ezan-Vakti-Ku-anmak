import 'package:flutter/material.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/header_v2.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/countdown_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/prayer_row.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/content_pair.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/quick_grid.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/vecize_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/risale_card.dart';
import 'package:nur_pusulasi/features/home/widgets/v2/dua_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              children: const [
                NextPrayerCountdown(),
                SizedBox(height: 14),
                PrayerRowV2(),
                SizedBox(height: 14),
                ContentPair(),
                SizedBox(height: 14),
                QuickGridV2(),
                SizedBox(height: 14),
                VecizeCard(),
                SizedBox(height: 14),
                RisaleCard(),
                SizedBox(height: 14),
                DuaCard(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
