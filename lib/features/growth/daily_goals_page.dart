import 'dart:convert';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme.dart';
import '../../app/shadows.dart';

class DailyGoalsPage extends StatefulWidget {
  const DailyGoalsPage({super.key});

  @override
  State<DailyGoalsPage> createState() => _DailyGoalsPageState();
}

class _Goal {
  final String id;
  final String title;
  bool isCompleted;

  _Goal({required this.id, required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'isCompleted': isCompleted};
  factory _Goal.fromJson(Map<String, dynamic> json) => _Goal(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'] ?? false,
      );
}

class _DailyGoalsPageState extends State<DailyGoalsPage> {
  List<_Goal> _goals = [];
  bool _isLoading = true;
  String _todayDate = '';

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  // Verileri yükle ve gün kontrolü yap
  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    _todayDate = "${now.year}-${now.month}-${now.day}";

    final savedDate = prefs.getString('goals_date');
    final savedGoalsStr = prefs.getString('daily_goals');

    setState(() {
      if (savedDate == _todayDate && savedGoalsStr != null) {
        // Bugünün verisi varsa yükle
        final List decoded = jsonDecode(savedGoalsStr);
        _goals = decoded.map((e) => _Goal.fromJson(e)).toList();
      } else {
        // Yeni gün: Başlangıç hedeflerini yükle
        _goals = [
          _Goal(
              id: '1', title: AppLocalizations.of(context).uiSabahNamaziniKil),
          _Goal(id: '2', title: AppLocalizations.of(context).uiOgleNamaziniKil),
          _Goal(
              id: '3', title: AppLocalizations.of(context).uiIkindiNamaziniKil),
          _Goal(
              id: '4', title: AppLocalizations.of(context).uiAksamNamaziniKil),
          _Goal(
              id: '5', title: AppLocalizations.of(context).uiYatsiNamaziniKil),
          _Goal(
              id: '6',
              title: AppLocalizations.of(context).uiGunlukKurAnOkumasi),
          _Goal(id: '7', title: 'Günlük zikir/istiğfar et'),
        ];
        _saveGoals(prefs); // Yeni günü kaydet
      }
      _isLoading = false;
    });
  }

  // Verileri kaydet
  Future<void> _saveGoals([SharedPreferences? prefs]) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    final str = jsonEncode(_goals.map((e) => e.toJson()).toList());
    await p.setString('daily_goals', str);
    await p.setString('goals_date', _todayDate);
  }

  // Durum değiştir
  void _toggleGoal(int index) {
    setState(() {
      _goals[index].isCompleted = !_goals[index].isCompleted;
    });
    _saveGoals();
  }

  // Yeni hedef ekle
  void _addGoal() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kKartYuzeyi,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context).uiYeniHedefEkle,
            style: TextStyle(color: kAnaLacivert, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).uiOrn10SayfaKitap,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kAnaTurkuaz, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).uiIptal2,
                style: TextStyle(color: kIkincilMetin)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kAnaTurkuaz,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _goals.add(_Goal(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: controller.text.trim()));
                });
                _saveGoals();
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context).uiEkle2,
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kArkaPlan,
        body: Center(child: CircularProgressIndicator(color: kAnaTurkuaz)),
      );
    }

    int completedCount = _goals.where((g) => g.isCompleted).length;
    double progress = _goals.isEmpty ? 0 : completedCount / _goals.length;

    return Scaffold(
      backgroundColor: kArkaPlan,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).dailyGoals,
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
            // İlerleme Kartı
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kAnaLacivert,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.medium(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).uiBugunkuManevYolculugun,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .uiFTamamlandi(completedCount, _goals.length),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '%${(progress * 100).round()}',
                        style: const TextStyle(
                            color: kAnaTurkuaz,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(kAnaTurkuaz),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).uiBugununHedefleri,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: kAnaMetin),
            ),
            const SizedBox(height: 12),

            // Hedef Listesi
            ..._goals.asMap().entries.map((entry) {
              int index = entry.key;
              _Goal goal = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: kKartYuzeyi,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppShadows.soft(),
                  border: Border.all(
                    color: goal.isCompleted
                        ? kAnaTurkuaz.withValues(alpha: 0.5)
                        : kKenarlik,
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _toggleGoal(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            goal.isCompleted
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color:
                                goal.isCompleted ? kAnaTurkuaz : kYardimciMetin,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              goal.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: goal.isCompleted
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                                color: goal.isCompleted
                                    ? kIkincilMetin
                                    : kAnaMetin,
                                decoration: goal.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Yeni Hedef Ekle Butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addGoal,
                icon: const Icon(Icons.add_rounded),
                label: Text(AppLocalizations.of(context).uiYeniHedefEkle),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kAnaLacivert,
                  side: const BorderSide(color: kAnaLacivert, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
