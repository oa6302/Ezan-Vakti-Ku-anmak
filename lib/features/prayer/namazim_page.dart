import 'package:flutter/material.dart';
import 'data/prayer_tracker.dart';
import 'widgets/prayer_times_widget.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _green = Color(0xFF2FAE7F);
const _gold = Color(0xFFC9A961);

class NamazimPage extends StatefulWidget {
  const NamazimPage({super.key});
  @override
  State<NamazimPage> createState() => _NamazimPageState();
}

class _NamazimPageState extends State<NamazimPage> {
  final _tracker = PrayerTracker();
  DateTime _selectedDate = DateTime.now();
  Map<String, PrayerStatus> _statuses = {};
  List<int> _weekly = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final statuses = await _tracker.getDayStatus(_selectedDate);
    final weekly = await _tracker.getWeeklyCounts(DateTime.now());
    if (!mounted) return;
    setState(() {
      _statuses = statuses;
      _weekly = weekly;
      _loading = false;
    });
  }

  Future<void> _changeDay(int days) async {
    setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));
    await _load();
  }

  Future<void> _setStatus(String vakit, PrayerStatus status) async {
    await _tracker.setStatus(_selectedDate, vakit, status);
    await _load();
  }

  Future<void> _showStatusPicker(String vakit) async {
    final current = _statuses[vakit] ?? PrayerStatus.bos;
    final selected = await showModalBottomSheet<PrayerStatus>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$vakit Namazı',
                  style: const TextStyle(
                      color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Text('Kişisel kaydın — dilediğin zaman değiştirebilirsin.',
                  style: TextStyle(color: Colors.black54, fontSize: 12)),
              const SizedBox(height: 16),
              _statusTile('Kıldım', PrayerStatus.kilindi, Icons.check_circle_rounded, _green, current),
              _statusTile('Cemaatle kıldım', PrayerStatus.cemaatle, Icons.groups_rounded, _gold, current),
              _statusTile('Sonra kılacağım', PrayerStatus.kaza, Icons.schedule_rounded, _red, current),
              _statusTile('Kaydı sil', PrayerStatus.bos, Icons.delete_outline_rounded, Colors.grey, current),
            ],
          ),
        ),
      ),
    );
    if (selected != null) await _setStatus(vakit, selected);
  }

  Widget _statusTile(String label, PrayerStatus status, IconData icon, Color color, PrayerStatus current) {
    final selected = current == status;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label,
          style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w600)),
      trailing: selected ? Icon(Icons.check_circle_rounded, color: color) : null,
      onTap: () => Navigator.pop(context, status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _isSameDay(_selectedDate, DateTime.now());
    final completed = _statuses.values
        .where((s) => s == PrayerStatus.kilindi || s == PrayerStatus.cemaatle)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Namazım',
            style: TextStyle(color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: _navy),
            tooltip: 'Tüm kayıtları sil',
            onPressed: _confirmClearAll,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _dayNavigator(isToday),
                const SizedBox(height: 14),
                _progressCard(completed),
                const SizedBox(height: 14),
                ...PrayerTracker.vakitler.map((v) => _vakitRow(v)),
                const SizedBox(height: 18),
                _weeklyChart(),
                const SizedBox(height: 18),
                const PrayerTimesWidget(),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _confirmClearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tüm kayıtları sil?'),
        content: const Text('Namaz takip kayıtların tamamen silinecek. Bu işlem geri alınamaz.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _tracker.clearAll();
      await _load();
    }
  }

  Widget _dayNavigator(bool isToday) {
    const months = ['Ocak','Şubat','Mart','Nisan','Mayıs','Haziran','Temmuz','Ağustos','Eylül','Ekim','Kasım','Aralık'];
    final dateStr = '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: _navy),
            onPressed: () => _changeDay(-1),
          ),
          Expanded(
            child: Column(
              children: [
                Text(isToday ? 'Bugün' : 'Geçmiş',
                    style: const TextStyle(color: Colors.black54, fontSize: 11)),
                const SizedBox(height: 2),
                Text(dateStr,
                    style: const TextStyle(
                        color: _navy, fontSize: 15, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: _navy),
            onPressed: isToday ? null : () => _changeDay(1),
          ),
        ],
      ),
    );
  }

  Widget _progressCard(int completed) {
    final pct = (completed / 5 * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, Color(0xFF05132B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70, height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70, height: 70,
                  child: CircularProgressIndicator(
                    value: pct / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(_gold),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text('$pct%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Günlük İlerleme',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text('$completed / 5 vakit',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                const Text("Bu bir ibadet kaydıdır; kabulü Allah'a aittir.",
                    style: TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vakitRow(String vakit) {
    final status = _statuses[vakit] ?? PrayerStatus.bos;
    Color color;
    IconData icon;
    String label;
    switch (status) {
      case PrayerStatus.kilindi:
        color = _green; icon = Icons.check_circle_rounded; label = 'Kılındı';
        break;
      case PrayerStatus.cemaatle:
        color = _gold; icon = Icons.groups_rounded; label = 'Cemaatle';
        break;
      case PrayerStatus.kaza:
        color = _red; icon = Icons.schedule_rounded; label = 'Sonra';
        break;
      case PrayerStatus.bos:
        color = Colors.grey; icon = Icons.radio_button_unchecked; label = 'Kayıt yok';
        break;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(vakit,
            style: const TextStyle(
                color: _navy, fontSize: 15, fontWeight: FontWeight.w800)),
        subtitle: Text(label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
          onTap: () => _showStatusPicker(vakit),
        ),
      ),
    );
  }

  Widget _weeklyChart() {
    const days = ['Pt','Sa','Ça','Pe','Cu','Ct','Pz'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Haftalık İlerleme',
              style: TextStyle(
                  color: _navy, fontSize: 15, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Son 7 günde kıldığın vakit sayısı',
              style: TextStyle(color: Colors.black54, fontSize: 11)),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final count = _weekly.length > i ? _weekly[i] : 0;
                final ratio = count / 5;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('$count',
                          style: const TextStyle(
                              color: _navy, fontSize: 10, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 80 * ratio + 4,
                        decoration: BoxDecoration(
                          gradient: count > 0
                              ? const LinearGradient(
                                  colors: [_navy, Color(0xFF1A3A5C)],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                )
                              : null,
                          color: count == 0 ? const Color(0xFFE9EEF5) : null,
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
}
