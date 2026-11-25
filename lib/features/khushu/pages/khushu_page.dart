import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import '../data/khushu_tracker.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class KhushuPage extends StatefulWidget {
  final String vakit;
  const KhushuPage({super.key, this.vakit = 'Bu Namaz'});
  @override
  State<KhushuPage> createState() => _KhushuPageState();
}

class _KhushuPageState extends State<KhushuPage> {
  final _tracker = KhushuTracker();
  List<KhushuEntry> _entries = [];
  List<double> _weekly = [];
  Map<int, int> _dist = {};
  double _avg = 0;
  bool _loading = true;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final entries = await _tracker.all();
    final weekly = await _tracker.lastNDaysAverage(7);
    final dist = await _tracker.distribution();
    final avg = await _tracker.average();
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _weekly = weekly;
      _dist = dist;
      _avg = avg;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_selected == 0) return;
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await _tracker.add(KhushuEntry(
      date: dateStr,
      vakit: widget.vakit,
      level: _selected,
      timestamp: now,
    ));
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Huşu kaydı eklendi'),
          backgroundColor: _green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Huşu Takibi',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _hero(),
                const SizedBox(height: 14),
                _inputCard(),
                const SizedBox(height: 14),
                _statsRow(),
                const SizedBox(height: 14),
                _weeklyCard(),
                const SizedBox(height: 14),
                _distCard(),
                const SizedBox(height: 14),
                _infoBox(),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _hero() {
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
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
            ),
            child: const Icon(Icons.favorite_rounded, color: _gold, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kalp Huzuru',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Namazda kalbin neredeydi? Yargılamadan fark et.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputCard() {
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
          const Text('Bu namazda huşu seviyen?',
              style: TextStyle(
                  color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('1 = dağınık, 5 = derin',
              style: TextStyle(color: Colors.black54, fontSize: 11)),
          const SizedBox(height: 14),
          Row(
            children: List.generate(5, (i) {
              final level = i + 1;
              final active = _selected == level;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => setState(() => _selected = level),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: active
                              ? _gold.withValues(alpha: 0.15)
                              : const Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: active ? _gold : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(KhushuTracker.levelEmojis[i],
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text('$level',
                                style: TextStyle(
                                    color: active ? _gold : _navy,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (_selected > 0) ...[
            const SizedBox(height: 10),
            Center(
              child: Text(
                KhushuTracker.levelLabels[_selected - 1],
                style: const TextStyle(
                    color: _gold, fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _selected == 0 ? Colors.grey[300] : _navy,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _selected == 0 ? null : _save,
              icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
              label: const Text('Kaydet',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statBox('Ortalama', _avg.toStringAsFixed(1), '/ 5',
              Icons.trending_up_rounded, _gold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statBox('Kayıt', '${_entries.length}', 'toplam',
              Icons.history_rounded, _green),
        ),
      ],
    );
  }

  Widget _statBox(
      String label, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium(),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 10)),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(value,
                        style: TextStyle(
                            color: color,
                            fontSize: 20,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(width: 3),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(unit,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 9)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weeklyCard() {
    const days = ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz'];
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
          const Text('Haftalık Huşu',
              style: TextStyle(
                  color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Son 7 günde ortalama huşu seviyen',
              style: TextStyle(color: Colors.black54, fontSize: 11)),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final val = _weekly.length > i ? _weekly[i] : 0.0;
                final ratio = val / 5;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(val > 0 ? val.toStringAsFixed(1) : '-',
                          style: const TextStyle(
                              color: _navy,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 70 * ratio + 4,
                        decoration: BoxDecoration(
                          gradient: val > 0
                              ? const LinearGradient(
                                  colors: [_gold, Color(0xFFE0BE7A)],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                )
                              : null,
                          color: val == 0 ? const Color(0xFFE9EEF5) : null,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(days[i],
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 10)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _distCard() {
    const labels = ['Dağınık', 'Zayıf', 'Orta', 'İyi', 'Derin'];
    final total = _dist.values.fold<int>(0, (a, b) => a + b);
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
          const Text('Huşu Dağılımı',
              style: TextStyle(
                  color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          if (total == 0)
            const Text('Henüz kayıt yok',
                style: TextStyle(color: Colors.black54, fontSize: 12))
          else
            ...List.generate(5, (i) {
              final level = i + 1;
              final count = _dist[level] ?? 0;
              final ratio = total == 0 ? 0.0 : count / total;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(KhushuTracker.levelEmojis[i],
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 60,
                      child: Text(labels[i],
                          style: const TextStyle(color: _navy, fontSize: 11)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE9EEF5),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(_gold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text('$count',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: _navy,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _gold, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Huşu puanı kişisel farkındalık içindir. Namazın kabulü Allah'a aittir; düşük puan utanç değil, gelişim fırsatıdır.",
              style: TextStyle(color: _navy, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
