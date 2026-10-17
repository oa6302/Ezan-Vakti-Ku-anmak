import 'package:flutter/material.dart';
import 'package:nur_pusulasi/widgets/daily_content_card.dart';
import '../widgets/prayer_times_widget.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);

class VakitlerPage extends StatelessWidget {
  const VakitlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const months = [
      'Ocak', 'Subat', 'Mart', 'Nisan', 'Mayis', 'Haziran',
      'Temmuz', 'Agustos', 'Eylul', 'Ekim', 'Kasim', 'Aralik',
    ];
    const days = [
      'Pazartesi', 'Sali', 'Carsamba', 'Persembe',
      'Cuma', 'Cumartesi', 'Pazar',
    ];
    final dateStr =
        '${now.day} ${months[now.month - 1]} ${now.year} - ${days[now.weekday - 1]}';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Vakitler',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 30),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Icon(Icons.today_rounded, color: _gold, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(dateStr,
                      style: const TextStyle(
                          color: _navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PrayerTimesWidget(),
          const SizedBox(height: 16),
          const DailyContentCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}