import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class TesbihPage extends StatefulWidget {
  const TesbihPage({super.key});
  @override
  State<TesbihPage> createState() => _TesbihPageState();
}

class _TesbihPageState extends State<TesbihPage> {
  static const zikirler = [
    ('Sübhânallah', 33),
    ('Elhamdülillah', 33),
    ('Allahu Ekber', 33),
    ('Lâ ilâhe illallah', 100),
    ('Estağfirullah', 100),
    ('Sallallahu aleyhi ve sellem', 100),
    ('Lâ havle velâ kuvvete illâ billâh', 33),
  ];

  int _selectedIndex = 0;
  int _count = 0;
  int _totalToday = 0;
  bool _vibration = true;
  int _completed = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('tesbih_selected') ?? 0;
      _totalToday = prefs.getInt('tesbih_total_today') ?? 0;
      _vibration = prefs.getBool('tesbih_vibration') ?? true;
      _completed = prefs.getInt('tesbih_completed') ?? 0;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tesbih_selected', _selectedIndex);
    await prefs.setInt('tesbih_total_today', _totalToday);
    await prefs.setBool('tesbih_vibration', _vibration);
    await prefs.setInt('tesbih_completed', _completed);
  }

  void _tap() {
    if (_vibration) HapticFeedback.lightImpact();
    final target = zikirler[_selectedIndex].$2;
    setState(() {
      _count++;
      _totalToday++;
    });
    if (_count >= target) {
      if (_vibration) HapticFeedback.mediumImpact();
      setState(() {
        _completed++;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${zikirler[_selectedIndex].$1} tamamlandı (×$target)'),
            backgroundColor: _green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      Future<void>.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _count = 0);
      });
    }
    _save();
  }

  Future<void> _reset() async {
    setState(() => _count = 0);
    await _save();
  }

  Future<void> _resetTotal() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Günlük toplamı sıfırla?'),
        content: const Text('Bugünkü toplam zikir sayısı sıfırlanacak.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        _totalToday = 0;
        _completed = 0;
      });
      await _save();
    }
  }

  void _selectZikir(int? i) {
    if (i == null) return;
    setState(() {
      _selectedIndex = i;
      _count = 0;
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final zikir = zikirler[_selectedIndex];
    final target = zikir.$2;
    final progress = (_count / target).clamp(0.0, 1.0);
    final remaining = target - _count;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Tesbih',
            style: TextStyle(color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: Icon(_vibration ? Icons.vibration_rounded : Icons.volume_off_rounded,
                color: _navy),
            tooltip: _vibration ? 'Titreşim açık' : 'Titreşim kapalı',
            onPressed: () {
              setState(() => _vibration = !_vibration);
              _save();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: _navy),
            tooltip: 'Günlük toplamı sıfırla',
            onPressed: _resetTotal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _zikirSelector(),
            const SizedBox(height: 20),
            _counterCircle(progress, zikir.$1, remaining),
            const SizedBox(height: 20),
            _controls(),
            const SizedBox(height: 20),
            _statsRow(),
            const SizedBox(height: 14),
            _infoBox(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _zikirSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedIndex,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _navy),
          style: const TextStyle(color: _navy, fontSize: 14, fontWeight: FontWeight.w800),
          items: List.generate(zikirler.length, (i) {
            final z = zikirler[i];
            return DropdownMenuItem<int>(
              value: i,
              child: Text('${z.$1}  ·  ×${z.$2}',
                  style: const TextStyle(
                      color: _navy, fontSize: 14, fontWeight: FontWeight.w700)),
            );
          }),
          onChanged: _selectZikir,
        ),
      ),
    );
  }

  Widget _counterCircle(double progress, String label, int remaining) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: _navy.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(_green),
              strokeCap: StrokeCap.round,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _tap,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_navy, Color(0xFF05132B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _navy.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$_count',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 68,
                            fontWeight: FontWeight.w900,
                            height: 1)),
                    const SizedBox(height: 6),
                    Text(label,
                        style: const TextStyle(
                            color: _gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Kalan: $remaining',
                          style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                    const SizedBox(height: 8),
                    const Text('DOKUN',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 10, letterSpacing: 2)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconBtn(Icons.remove_rounded, 'Geri al', () {
          if (_count > 0) {
            setState(() => _count--);
            _save();
          }
        }),
        const SizedBox(width: 16),
        _iconBtn(Icons.refresh_rounded, 'Sıfırla', _reset),
      ],
    );
  }

  Widget _iconBtn(IconData icon, String tooltip, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(icon, color: _navy, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statBox('Bugün Toplam', '$_totalToday',
              Icons.calendar_today_rounded, _green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statBox('Tamamlanan', '$_completed',
              Icons.check_circle_rounded, _gold),
        ),
      ],
    );
  }

  Widget _statBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
                    style: const TextStyle(color: Colors.black54, fontSize: 10)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        color: color, fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
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
      child: Row(
        children: const [
          Icon(Icons.info_outline_rounded, color: _gold, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Namazlardan sonra 33 Sübhânallah + 33 Elhamdülillah + 33 Allahu Ekber çekmek sünnettir.',
              style: TextStyle(color: _navy, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}