import 'dart:convert';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme.dart';
import '../../app/shadows.dart';

class WeeklyProgressPage extends StatefulWidget {
  const WeeklyProgressPage({super.key});

  @override
  State<WeeklyProgressPage> createState() => _WeeklyProgressPageState();
}

class _WeeklyProgressPageState extends State<WeeklyProgressPage> {
  bool _isLoading = true;
  int _completedGoals = 0;
  int _totalGoals = 0;
  int _gratitudeCount = 0;
  int _readPages = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Günlük Hedefleri Oku
    final goalsStr = prefs.getString('daily_goals');
    if (goalsStr != null) {
      final List decoded = jsonDecode(goalsStr);
      _totalGoals = decoded.length;
      _completedGoals = decoded.where((g) => g['isCompleted'] == true).length;
    }

    // 2. Şükür Notlarını Oku
    final gratitudeStr = prefs.getString('gratitude_entries');
    if (gratitudeStr != null) {
      final List decoded = jsonDecode(gratitudeStr);
      _gratitudeCount = decoded.length;
    }

    // 3. Okunan Sayfa Sayısını Oku
    final booksStr = prefs.getString('reading_books');
    if (booksStr != null) {
      final List decoded = jsonDecode(booksStr);
      _readPages = decoded.fold<int>(
          0, (sum, item) => sum + ((item['readPages'] as num? ?? 0).toInt()));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
          backgroundColor: kArkaPlan,
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: kArkaPlan,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).uiHaftalikIlerleme,
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kKartYuzeyi,
        foregroundColor: kAnaLacivert,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Karşılama Alanı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kAnaLacivert, Color(0xFF1E3A6E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.medium(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.insights_rounded,
                      color: Colors.white70, size: 32),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).uiManeviYolculukOzetin,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).uiKucukAdimlarDuzenliBir3,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).uiBuHaftaninVerileri,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: kAnaMetin),
            ),
            const SizedBox(height: 16),

            // İstatistik Kartları
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tamamlanan Hedef',
                    '$_completedGoals / $_totalGoals',
                    Icons.track_changes_rounded,
                    kAnaTurkuaz,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Şükür Notu',
                    '$_gratitudeCount',
                    Icons.edit_note_rounded,
                    kBasariYesili,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Okunan Sayfa',
                    '$_readPages',
                    Icons.menu_book_rounded,
                    kZarifBordo,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kKartYuzeyi,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kKenarlik),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            color: kYardimciMetin, size: 28),
                        SizedBox(height: 12),
                        Text(AppLocalizations.of(context).uiDevamEt,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kAnaMetin)),
                        SizedBox(height: 4),
                        Text(AppLocalizations.of(context).uiHarikaGidiyorsun,
                            style:
                                TextStyle(fontSize: 12, color: kIkincilMetin)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Yönlendirme Notu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kAnaTurkuaz.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: kAnaTurkuaz),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)
                          .uiVerilerinizDigerModullerdekiHedefler,
                      style: TextStyle(
                          fontSize: 12, color: kAnaLacivert, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kKartYuzeyi,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.soft(),
        border: Border.all(color: kKenarlik),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(value,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: kAnaMetin)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(fontSize: 13, color: kIkincilMetin)),
        ],
      ),
    );
  }
}
