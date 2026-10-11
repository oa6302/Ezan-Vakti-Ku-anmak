import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nur_pusulasi/app/theme.dart';

class WeeklyProgressPage extends StatefulWidget {
  const WeeklyProgressPage({super.key});

  @override
  State<WeeklyProgressPage> createState() => _WeeklyProgressPageState();
}

class _WeeklyProgressPageState extends State<WeeklyProgressPage> {
  Map<String, dynamic> _summary = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    int goalCount = 0;
    int goalsDone = 0;
    int bookCount = 0;
    int pagesRead = 0;
    int pagesTotal = 0;

    try {
      final raw = prefs.getString('nur_pusulasi_daily_goals_v1');
      if (raw != null) {
        final goals = (jsonDecode(raw) as List<dynamic>);
        goalCount = goals.length;
        goalsDone = goals.where((g) => g['done'] == true).length;
      }
    } catch (_) {}

    try {
      final raw = prefs.getString('nur_pusulasi_reading_plan_v1');
      if (raw != null) {
        final books = jsonDecode(raw) as List<dynamic>;
        bookCount = books.length;
        for (final item in books) {
          final book = Map<String, dynamic>.from(item as Map);
          pagesRead += (book['read'] as num?)?.toInt() ?? 0;
          pagesTotal += (book['total'] as num?)?.toInt() ?? 0;
        }
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _summary = {
        'goalCount': goalCount,
        'goalsDone': goalsDone,
        'bookCount': bookCount,
        'pagesRead': pagesRead,
        'pagesTotal': pagesTotal,
      };
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalCount = _summary['goalCount'] as int? ?? 0;
    final goalsDone = _summary['goalsDone'] as int? ?? 0;
    final pagesRead = _summary['pagesRead'] as int? ?? 0;
    final pagesTotal = _summary['pagesTotal'] as int? ?? 0;
    final goalProgress = goalCount == 0 ? 0.0 : goalsDone / goalCount;
    final readingProgress =
        pagesTotal == 0 ? 0.0 : (pagesRead / pagesTotal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Haftalık ilerleme'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            onPressed: () {
              setState(() => _loading = true);
              _load();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [navy, navyDeep]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.insights_rounded,
                          color: Colors.white, size: 36),
                      SizedBox(height: 12),
                      Text(
                        'Gelişim, istikrarlı adımlarla büyür.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Hedeflerini ve okuma planını gözden geçir.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _ProgressSummaryCard(
                  icon: Icons.track_changes_rounded,
                  title: 'Günlük hedefler',
                  detail: '$goalsDone / $goalCount hedef tamamlandı',
                  progress: goalProgress,
                ),
                _ProgressSummaryCard(
                  icon: Icons.menu_book_rounded,
                  title: 'Okuma planı',
                  detail: '$pagesRead / $pagesTotal sayfa okundu',
                  progress: readingProgress,
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.auto_stories_rounded, color: red),
                    title: const Text('Okuma listen'),
                    subtitle: Text('${_summary['bookCount'] ?? 0} eser kayıtlı'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Not: Bu ekran mevcut kayıtların özetini gösterir. Geçmiş günlere ait haftalık istatistik için ayrıca günlük etkinlik geçmişi tutulmalıdır.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
    );
  }
}

class _ProgressSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final double progress;

  const _ProgressSummaryCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text('${(progress * 100).round()}%'),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: pale,
                  color: red,
                ),
              ),
              const SizedBox(height: 8),
              Text(detail),
            ],
          ),
        ),
      );
}
