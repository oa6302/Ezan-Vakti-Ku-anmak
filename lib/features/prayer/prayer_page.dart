import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'widgets/prayer_times_widget.dart';

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('İbadet',
            style: TextStyle(
                color: navy, fontSize: 20, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PrayerTimesWidget(),
          SizedBox(height: 16),
          _ComingSoonCard(
            icon: Icons.explore_rounded,
            title: 'Kıble Pusulası',
            subtitle: 'Cihaz sensörleriyle kıble yönü',
          ),
          SizedBox(height: 12),
          _ComingSoonCard(
            icon: Icons.timer_rounded,
            title: 'Zikir Sayacı',
            subtitle: 'Dijital tesbih ve zikir takibi',
          ),
          SizedBox(height: 12),
          _ComingSoonCard(
            icon: Icons.menu_book_rounded,
            title: 'Kısa Sureler',
            subtitle: 'Arapça metin + Türkçe meal',
          ),
        ],
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ComingSoonCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF1F7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: navy, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.black38),
        ],
      ),
    );
  }
}