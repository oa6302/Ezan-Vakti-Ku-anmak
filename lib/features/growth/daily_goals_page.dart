import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nur_pusulasi/app/theme.dart';

class DailyGoalsPage extends StatefulWidget {
  const DailyGoalsPage({super.key});

  @override
  State<DailyGoalsPage> createState() => _DailyGoalsPageState();
}

class _DailyGoalsPageState extends State<DailyGoalsPage> {
  static const String _storageKey = 'nur_pusulasi_daily_goals_v1';

  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _goals = [];
  bool _loading = true;

  int get _completed =>
      _goals.where((goal) => goal['done'] == true).length;

  Future<void> _loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);

      if (saved != null) {
        final decoded = jsonDecode(saved) as List<dynamic>;
        _goals = decoded
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
    } catch (_) {
      _goals = [];
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_goals));
  }

  Future<void> _addGoal() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _goals.add({'title': text, 'done': false});
      _controller.clear();
    });

    await _saveGoals();
  }

  Future<void> _toggleGoal(int index, bool value) async {
    setState(() => _goals[index]['done'] = value);
    await _saveGoals();
  }

  Future<void> _deleteGoal(int index) async {
    setState(() => _goals.removeAt(index));
    await _saveGoals();
  }

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _goals.isEmpty ? 0.0 : _completed / _goals.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Günlük hedefler')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [navy, navyDeep],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: navy.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.track_changes_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Küçük adımlar, kalıcı gelişim.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_completed / ${_goals.length} hedef tamamlandı',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 9,
                          backgroundColor: Colors.white24,
                          color: red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Yeni hedef belirle',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addGoal(),
                  decoration: InputDecoration(
                    hintText: 'Örn. 10 dakika kitap okumak',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: pale),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _addGoal,
                      tooltip: 'Hedef ekle',
                      icon: const Icon(
                        Icons.add_circle_rounded,
                        color: red,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Bugünkü hedeflerin',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                if (_goals.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(22),
                      child: Column(
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            color: red,
                            size: 38,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Henüz hedef eklemedin.',
                            style: TextStyle(
                              color: navy,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'İlk hedefini yaz ve gelişim yolculuğuna başla.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(_goals.length, (index) {
                    final goal = _goals[index];
                    final done = goal['done'] == true;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 9),
                      child: CheckboxListTile(
                        value: done,
                        activeColor: red,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          goal['title']?.toString() ?? '',
                          style: TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w700,
                            decoration:
                                done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        secondary: IconButton(
                          tooltip: 'Hedefi sil',
                          onPressed: () => _deleteGoal(index),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: red,
                          ),
                        ),
                        onChanged: (value) =>
                            _toggleGoal(index, value ?? false),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                const Text(
                  'Hedeflerin bu cihazda saklanır. Uygulama yeniden açıldığında kayıtların yüklenir.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
    );
  }
}
