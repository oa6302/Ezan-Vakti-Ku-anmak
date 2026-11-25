import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import '../data/family_data.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'child_detail_page.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);
const _red = Color(0xFFB71C1C);

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});
  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final _tracker = FamilyTracker();
  List<Child> _children = [];
  Map<String, int> _completed = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _tracker.children();
    final lessons = ContentService.instance.getPool(ContentType.cocukDersi);
    final ids = lessons.map((e) => e.id).toList();
    final completed = <String, int>{};
    for (final c in list) {
      completed[c.id] = await _tracker.completedCount(c.id, ids);
    }
    if (!mounted) return;
    setState(() {
      _children = list;
      _completed = completed;
      _loading = false;
    });
  }

  Future<void> _addChild() async {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    String emoji = '👦';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Çocuk Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  children: ['👦', '👧', '🧒', '👶', '🌟', '🦁']
                      .map((e) => GestureDetector(
                            onTap: () => setSt(() => emoji = e),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: emoji == e
                                    ? _gold.withValues(alpha: 0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      emoji == e ? _gold : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child:
                                  Text(e, style: const TextStyle(fontSize: 26)),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'İsim',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Yaş',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('İptal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _navy),
              onPressed: () {
                final n = nameCtrl.text.trim();
                final a = int.tryParse(ageCtrl.text.trim()) ?? 0;
                if (n.isEmpty || a <= 0) return;
                Navigator.pop(ctx, true);
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );

    if (ok == true) {
      final n = nameCtrl.text.trim();
      final a = int.tryParse(ageCtrl.text.trim()) ?? 0;
      if (n.isEmpty || a <= 0) return;
      await _tracker.addChild(Child(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: n,
        age: a,
        emoji: emoji,
        createdAt: DateTime.now(),
      ));
      await _load();
    }
  }

  Future<void> _removeChild(Child c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('${c.name} silinsin mi?'),
        content: const Text('Bu çocuğun tüm ilerleme kayıtları silinecek.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İptal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _tracker.removeChild(c.id);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Aile Modu',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addChild,
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Çocuk Ekle',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _hero(),
                const SizedBox(height: 14),
                if (_children.isEmpty)
                  _emptyState()
                else ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('Çocuklarım',
                        style: TextStyle(
                            color: _navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(height: 10),
                  ..._children.map((c) => _childCard(c)),
                ],
                const SizedBox(height: 80),
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
            child: const Icon(Icons.family_restroom_rounded,
                color: _gold, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ailece Öğrenelim',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Çocuklarını namazla tanıştır.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.child_care_rounded, color: _gold, size: 42),
          ),
          const SizedBox(height: 16),
          const Text('Henüz çocuk eklenmedi',
              style: TextStyle(
                  color: _navy, fontSize: 15, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text(
            'Çocuğunu ekle, adım adım namaz öğrenmesini takip et. 9 basit adım.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _childCard(Child c) {
    final done = _completed[c.id] ?? 0;
    final total =
        ContentService.instance.getPool(ContentType.cocukDersi).length;
    final progress = total == 0 ? 0.0 : done / total;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => ChildDetailPage(child: c),
              ),
            );
            _load();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child:
                            Text(c.emoji, style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name,
                              style: const TextStyle(
                                  color: _navy,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text('${c.age} yaş',
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: _red, size: 20),
                      onPressed: () => _removeChild(c),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE9EEF5),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(_green),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('$done / $total',
                        style: const TextStyle(
                            color: _navy,
                            fontSize: 12,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
