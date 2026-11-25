import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import '../../prayer/data/prayer_tracker.dart';
import '../widgets/year_heatmap.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key});
  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  final _tracker = PrayerTracker();
  List<int> _daily = [];
  int _total = 0;
  int _activeDays = 0;
  int _streak = 0;
  int _longest = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final daily = await _tracker.getLastNDays(365);
    final total = await _tracker.getTotalCompleted();
    final active = await _tracker.getTotalActiveDays();
    final streak = await _tracker.getCurrentStreak();
    final longest = await _tracker.getLongestStreak();
    if (!mounted) return;
    setState(() {
      _daily = daily;
      _total = total;
      _activeDays = active;
      _streak = streak;
      _longest = longest;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Manevi Yolculuk',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _heroCard(),
                const SizedBox(height: 14),
                _statsRow(),
                const SizedBox(height: 14),
                YearHeatmap(daily: _daily),
                const SizedBox(height: 14),
                _monthCard(),
                const SizedBox(height: 14),
                _milestoneCard(),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _heroCard() {
    final level = _levelName(_total);
    final progress = _levelProgress(_total);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.deep(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: _gold, width: 2),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: _gold, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Yolculuk Seviyesi',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(level,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$_total vakit',
                    style: const TextStyle(
                        color: _gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(_gold),
            ),
          ),
          const SizedBox(height: 6),
          Text('${(progress * 100).round()}% · Sonraki seviyeye',
              style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statBox('Seri', '$_streak', 'gün',
              Icons.local_fire_department_rounded, _red),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statBox(
              'En Uzun', '$_longest', 'gün', Icons.emoji_events_rounded, _gold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statBox('Aktif', '$_activeDays', 'gün',
              Icons.calendar_today_rounded, _green),
        ),
      ],
    );
  }

  Widget _statBox(
      String label, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.w900)),
          Text(unit,
              style: const TextStyle(color: Colors.black54, fontSize: 10)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: _navy, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _monthCard() {
    // Son 30 günün ortalaması
    final last30 =
        _daily.length >= 30 ? _daily.sublist(_daily.length - 30) : _daily;
    final totalLast30 = last30.fold(0, (a, b) => a + b);
    final avg = last30.isEmpty ? 0.0 : totalLast30 / last30.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month_rounded,
                    color: _navy, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('Son 30 Gün',
                  style: TextStyle(
                      color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                    'Ortalama', avg.toStringAsFixed(1), 'vakit/gün', _green),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _miniStat('Toplam', '$totalLast30', 'vakit', _navy),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 10)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: TextStyle(
                      color: color, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(unit,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _milestoneCard() {
    const milestones = [50, 100, 250, 500, 1000, 2500, 5000];
    final next = milestones.firstWhere((m) => m > _total, orElse: () => 10000);
    final progress = _total / next;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flag_rounded, color: _gold, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('Sonraki Hedef',
                  style: TextStyle(
                      color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
              const Spacer(),
              Text('$_total / $next',
                  style: const TextStyle(
                      color: _navy, fontSize: 12, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFE9EEF5),
              valueColor: const AlwaysStoppedAnimation<Color>(_gold),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            next - _total > 0
                ? '${next - _total} vakit daha kaydet, bir sonraki seviyeye geç.'
                : 'Tebrikler! Sonraki hedefe ulaştın.',
            style: const TextStyle(
                color: Colors.black54, fontSize: 11, height: 1.5),
          ),
        ],
      ),
    );
  }

  String _levelName(int total) {
    if (total < 25) return 'Yolun Başında';
    if (total < 100) return 'Kararlı Yolcu';
    if (total < 250) return 'İstikrarlı';
    if (total < 500) return 'Sabırlı';
    if (total < 1000) return 'İhlâslı';
    if (total < 2500) return 'Vefalı';
    if (total < 5000) return 'Nurlu';
    return 'Altın Yolcu';
  }

  double _levelProgress(int total) {
    const levels = [0, 25, 100, 250, 500, 1000, 2500, 5000, 10000];
    for (var i = 0; i < levels.length - 1; i++) {
      if (total < levels[i + 1]) {
        return (total - levels[i]) / (levels[i + 1] - levels[i]);
      }
    }
    return 1.0;
  }
}
