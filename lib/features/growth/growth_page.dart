import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/shadows.dart';
import 'daily_goals_page.dart';
import 'gratitude_journal_page.dart';
import 'reading_plan_page.dart';
import 'weekly_progress_page.dart';

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kArkaPlan,
      appBar: AppBar(
        title: const Text('Kişisel Manevi Pusula',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kKartYuzeyi,
        foregroundColor: kAnaLacivert,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMenuCard(
              context,
              title: 'Günlük Hedefler',
              subtitle: 'Bugünkü manevî yolculuğun',
              icon: Icons.track_changes_rounded,
              color: kAnaTurkuaz,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DailyGoalsPage())),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              title: 'Şükür Defteri',
              subtitle: 'Bir nimet için şükret ve kaydet',
              icon: Icons.edit_note_rounded,
              color: kBasariYesili,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GratitudeJournalPage())),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              title: 'Okuma Planım',
              subtitle: 'Küçük adımlar, düzenli bir gelişim',
              icon: Icons.menu_book_rounded,
              color: kZarifBordo,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ReadingPlanPage())),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              title: 'Haftalık İlerleme',
              subtitle: 'İlerlemeni görüntüle',
              icon: Icons.insights_rounded,
              color: kAnaLacivert,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const WeeklyProgressPage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kKartYuzeyi,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.medium(),
        border: Border.all(color: kKenarlik, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kAnaMetin,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: kIkincilMetin,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kYardimciMetin.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
