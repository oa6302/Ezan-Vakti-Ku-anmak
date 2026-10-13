import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/combo_data.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);
const _red = Color(0xFFB71C1C);

class ComboPage extends StatefulWidget {
  const ComboPage({super.key});
  @override
  State<ComboPage> createState() => _ComboPageState();
}

class _ComboPageState extends State<ComboPage> {
  final List<ComboStep> _zincir = namazSonrasiZincir;
  int _stepIndex = 0;
  int _count = 0;
  int _totalCombos = 0;
  int _totalZikir = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalCombos = prefs.getInt('combos_done') ?? 0;
      _totalZikir = prefs.getInt('combos_zikir') ?? 0;
    });
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('combos_done', _totalCombos);
    await prefs.setInt('combos_zikir', _totalZikir);
  }

  void _tap() {
    HapticFeedback.lightImpact();
    final step = _zincir[_stepIndex];
    setState(() {
      _count++;
      _totalZikir++;
    });
    if (_count >= step.target) {
      HapticFeedback.mediumImpact();
      if (_stepIndex < _zincir.length - 1) {
        setState(() {
          _stepIndex++;
          _count = 0;
        });
      } else {
        setState(() {
          _done = true;
          _totalCombos++;
        });
      }
    }
    _saveStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Zikir Zinciri',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: _done ? _doneView() : _workView(),
    );
  }

  Widget _workView() {
    final step = _zincir[_stepIndex];
    final progress = _count / step.target;
    final overall = (_stepIndex + progress) / _zincir.length;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _statsRow(),
        const SizedBox(height: 14),
        _overallBar(overall),
        const SizedBox(height: 20),
        _tapCircle(step, progress),
        const SizedBox(height: 20),
        _stepList(),
      ],
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _statBox('Zincir', '$_totalCombos', _gold)),
        const SizedBox(width: 10),
        Expanded(child: _statBox('Toplam', '$_totalZikir', _red)),
      ],
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 10)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _overallBar(double progress) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${(progress * 100).round()}%',
              style: const TextStyle(
                  color: _gold, fontSize: 14, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE9EEF5),
              valueColor: const AlwaysStoppedAnimation<Color>(_gold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tapCircle(ComboStep step, double progress) {
    return Center(
      child: SizedBox(
        width: 260, height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 240, height: 240,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: _navy.withValues(alpha: 0.08),
                valueColor: const AlwaysStoppedAnimation<Color>(_gold),
                strokeCap: StrokeCap.round,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _tap,
                child: Container(
                  width: 200, height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [_navy, _navyDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$_count',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              height: 1)),
                      Text('/ ${step.target}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(step.zikir,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: _gold,
                                fontSize: 13,
                                fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(height: 6),
                      const Text('DOKUN',
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              letterSpacing: 2)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepList() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Zincir Adımları',
              style: TextStyle(
                  color: _navy, fontSize: 13, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...List.generate(_zincir.length, (i) {
            final s = _zincir[i];
            final done = i < _stepIndex;
            final active = i == _stepIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: done ? _green : (active ? _gold : Colors.grey[300]),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: done
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14)
                          : Text('${i + 1}',
                              style: TextStyle(
                                  color: active ? Colors.white : Colors.grey[600],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.zikir,
                            style: TextStyle(
                                color: active ? _navy : Colors.black54,
                                fontSize: 13,
                                fontWeight: active
                                    ? FontWeight.w900
                                    : FontWeight.w600)),
                        Text('${s.target} kere · ${s.meaning}',
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _doneView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_rounded, color: _gold, size: 64),
            const SizedBox(height: 24),
            const Text('Zikir Zinciri Tamam!',
                style: TextStyle(
                    color: _navy, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Text('Toplam $_totalZikir zikir · $_totalCombos. tam zincir',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black54, fontSize: 13, height: 1.6)),
            const SizedBox(height: 30),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _navy,
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 16),
              ),
              onPressed: () => setState(() {
                _stepIndex = 0;
                _count = 0;
                _done = false;
              }),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Yeniden Başla'),
            ),
          ],
        ),
      ),
    );
  }
}