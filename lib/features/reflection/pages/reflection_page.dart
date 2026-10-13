import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import '../data/reflection_data.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);
const _red = Color(0xFFB71C1C);

class ReflectionPage extends StatefulWidget {
  final String vakit;
  const ReflectionPage({super.key, this.vakit = 'Bu Namaz'});
  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  static const _key = 'reflection_entries_v1';
  final _noteCtrl = TextEditingController();
  late ReflectionQuestion _question;
  String _mood = '';
  int _step = 0; // 0=soru, 1=sonuc

  @override
  void initState() {
    super.initState();
    _question = reflectionQuestions[
        DateTime.now().millisecondsSinceEpoch % reflectionQuestions.length];
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_mood.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    List<dynamic> list = [];
    if (raw != null) {
      try { list = jsonDecode(raw) as List<dynamic>; } catch (_) {}
    }
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    list.insert(0, ReflectionEntry(
      date: dateStr,
      vakit: widget.vakit,
      mood: _mood,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      timestamp: now,
    ).toJson());
    // Son 200 kayit
    if (list.length > 200) list = list.sublist(0, 200);
    await prefs.setString(_key, jsonEncode(list));
    if (mounted) setState(() => _step = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Namaz Sonrası Tefekkür',
            style: TextStyle(
                color: _navy, fontSize: 17, fontWeight: FontWeight.w900)),
      ),
      body: _step == 0 ? _questionStep() : _doneStep(),
    );
  }

  Widget _questionStep() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _hero(),
        const SizedBox(height: 20),
        _questionCard(),
        const SizedBox(height: 20),
        _moodRow(),
        const SizedBox(height: 20),
        _noteCard(),
        const SizedBox(height: 20),
        _saveButton(),
        const SizedBox(height: 20),
      ],
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
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
            ),
            child: const Icon(Icons.psychology_alt_rounded,
                color: _gold, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.vakit,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 2),
                const Text('30 saniyelik tefekkür',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                const Text('Yargılamadan, sadece kalbini dinle.',
                    style: TextStyle(color: Colors.white60, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.medium(),
        border: Border(
          left: BorderSide(color: _gold, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('TEFEKKÜR SORUSU',
                style: TextStyle(
                    color: _gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2)),
          ),
          const SizedBox(height: 14),
          Text(_question.question,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.4)),
          const SizedBox(height: 10),
          Text(_question.hint,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  height: 1.6,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _moodRow() {
    const options = [
      ('huzurlu', '😌', 'Huzurlu', _green),
      ('normal', '🙂', 'Normal', _gold),
      ('dagink', '😔', 'Dağınık', _red),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bu namazda kalbin nasıldı?',
            style: TextStyle(
                color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        const Text('Kendi kalbini kontrol et, kimse görmeyecek.',
            style: TextStyle(color: Colors.black54, fontSize: 11)),
        const SizedBox(height: 12),
        Row(
          children: options.map((o) {
            final active = _mood == o.$1;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() => _mood = o.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: active ? o.$4 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: active ? o.$4 : const Color(0xFFEDF1F7),
                          width: active ? 2 : 1,
                        ),
                        boxShadow: active
                            ? AppShadows.colored(o.$4, alpha: 0.3)
                            : AppShadows.soft(),
                      ),
                      child: Column(
                        children: [
                          Text(o.$2,
                              style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text(o.$3,
                              style: TextStyle(
                                  color: active ? Colors.white : _navy,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _noteCard() {
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
                child: const Icon(Icons.edit_note_rounded,
                    color: _navy, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('İstersen bir not ekle',
                  style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w900)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('İsteğe bağlı',
                    style: TextStyle(
                        color: _gold,
                        fontSize: 9,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Kalbinin sesini yaz...',
              filled: true,
              fillColor: const Color(0xFFF3F6FA),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    final enabled = _mood.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: enabled ? _navy : Colors.grey[300],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: enabled ? _save : null,
        icon: const Icon(Icons.check_circle_rounded),
        label: const Text('Kaydet',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _doneStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _green.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: _green, size: 56),
            ),
            const SizedBox(height: 24),
            const Text('Allah kabul etsin',
                style: TextStyle(
                    color: _navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            const Text(
              'Tefekkür kaydın cihazında saklandı.\nKimseyle paylaşılmaz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _navy,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}