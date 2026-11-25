import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import '../data/family_data.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class ChildDetailPage extends StatefulWidget {
  final Child child;
  const ChildDetailPage({super.key, required this.child});
  @override
  State<ChildDetailPage> createState() => _ChildDetailPageState();
}

class _ChildDetailPageState extends State<ChildDetailPage> {
  final _tracker = FamilyTracker();
  Map<String, bool> _progress = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await _tracker.childProgress(widget.child.id);
    if (!mounted) return;
    setState(() {
      _progress = p;
      _loading = false;
    });
  }

  Future<void> _toggle(ContentItem lesson) async {
    final current = _progress[lesson.id] ?? false;
    await _tracker.setCompleted(widget.child.id, lesson.id, !current);
    await _load();
    if (mounted && !current) {
      final emoji = (lesson.extra?['emoji'] as String?) ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '$emoji ${widget.child.name} "${lesson.baslik}" adimini tamamladi!'),
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
        title: Row(
          children: [
            Text(widget.child.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(widget.child.name,
                style: const TextStyle(
                    color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListenableBuilder(
              listenable: ContentService.instance,
              builder: (context, _) {
                final lessons =
                    ContentService.instance.getPool(ContentType.cocukDersi);
                final done =
                    lessons.where((l) => _progress[l.id] == true).length;
                final total = lessons.length;
                final pct = total == 0 ? 0 : (done * 100 / total).round();

                return ListView(
                  padding: const EdgeInsets.all(14),
                  children: [
                    _progressCard(done, total, pct),
                    const SizedBox(height: 14),
                    if (lessons.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppShadows.medium(),
                        ),
                        child: const Center(
                          child: Text('Henuz ders eklenmemis.',
                              style: TextStyle(color: Colors.black54)),
                        ),
                      )
                    else
                      ...lessons.map((l) => _lessonTile(l)),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
    );
  }

  Widget _progressCard(int done, int total, int pct) {
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
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: pct / 100,
                    strokeWidth: 7,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(_gold),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text('%$pct',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.child.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('$done / $total adim tamamlandi',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                const Text('Her tamamlanan adim bir kutlama',
                    style: TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lessonTile(ContentItem l) {
    final done = _progress[l.id] ?? false;
    final emoji = (l.extra?['emoji'] as String?) ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium(),
        border: done
            ? Border.all(color: _green.withValues(alpha: 0.4), width: 2)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _toggle(l),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: done
                        ? _green.withValues(alpha: 0.15)
                        : _gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: done
                        ? const Icon(Icons.check_circle_rounded,
                            color: _green, size: 28)
                        : (emoji.isNotEmpty
                            ? Text(emoji, style: const TextStyle(fontSize: 26))
                            : Icon(Icons.school_rounded,
                                color: _gold, size: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.baslik,
                          style: TextStyle(
                              color: _navy,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              decoration:
                                  done ? TextDecoration.lineThrough : null)),
                      const SizedBox(height: 3),
                      Text(l.icerik,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: done ? _green : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: done ? _green : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                  ),
                  child: done
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 16)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
