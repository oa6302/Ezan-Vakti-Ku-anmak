import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/theme.dart';
import 'package:nur_pusulasi/features/growth/daily_goals_page.dart';
import 'package:nur_pusulasi/features/growth/gratitude_journal_page.dart';
import 'package:nur_pusulasi/features/growth/reading_plan_page.dart';
import 'package:nur_pusulasi/features/growth/weekly_progress_page.dart';
import 'package:nur_pusulasi/features/profile/saved_items_page.dart';
import 'package:nur_pusulasi/features/common/menu_detail_page.dart';
import 'package:nur_pusulasi/features/admin/admin_gate_page.dart';
import 'package:nur_pusulasi/features/admin/content_archive_page.dart';

class SimplePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> items;
  const SimplePage(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.items});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Nur Pusulası')),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [navy, navyDeep]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: navy.withValues(alpha: .2),
                      blurRadius: 18,
                      offset: const Offset(0, 8))
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, color: Colors.white, size: 35),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 18),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                    child: ListTile(
                  leading: const CircleAvatar(
                      backgroundColor: pale,
                      child: Icon(Icons.auto_awesome_rounded, color: red)),
                  title: Text(item,
                      style: const TextStyle(
                          color: navy, fontWeight: FontWeight.w800)),
                  trailing:
                      const Icon(Icons.chevron_right_rounded, color: navy),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => item == 'Günlük hedefler'
                            ? const DailyGoalsPage()
                            : item == 'Şükür defteri'
                                ? const GratitudeJournalPage()
                                : item == 'Okuma planım'
                                    ? const ReadingPlanPage()
                                    : item == 'Haftalık ilerleme'
                                        ? const WeeklyProgressPage()
                                        : item == 'Kaydedilenler'
                                            ? const SavedItemsPage()
                                            : item == 'Admin Paneli'
                                                ? const AdminGatePage()
                                                : item == 'İçerik arşivi'
                                                    ? const ContentArchivePage()
: MenuDetailPage(item: item),
                      ),
                    );
                  },
                )),
              )),
        ]),
      );
}
