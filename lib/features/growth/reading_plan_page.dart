import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nur_pusulasi/app/theme.dart';

class ReadingPlanPage extends StatefulWidget {
  const ReadingPlanPage({super.key});

  @override
  State<ReadingPlanPage> createState() => _ReadingPlanPageState();
}

class _ReadingPlanPageState extends State<ReadingPlanPage> {
  static const String _storageKey = 'nur_pusulasi_reading_plan_v1';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final List<Map<String, dynamic>> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved != null) {
        final decoded = jsonDecode(saved) as List<dynamic>;
        _books.addAll(decoded.map(
          (item) => Map<String, dynamic>.from(item as Map),
        ));
      }
    } catch (_) {
      // Kayıt okunamazsa ekran kullanılabilir kalır.
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_books));
  }

  Future<void> _addBook() async {
    final title = _titleController.text.trim();
    final total = int.tryParse(_totalController.text.trim());

    if (title.isEmpty || total == null || total < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Eser adını ve 1 veya daha fazla sayfa hedefini gir.'),
        ),
      );
      return;
    }

    setState(() {
      _books.insert(0, {
        'title': title,
        'total': total,
        'read': 0,
      });
      _titleController.clear();
      _totalController.clear();
    });

    try {
      await _persist();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt yapılamadı.')),
        );
      }
    }
  }

  Future<void> _changeRead(int index, int delta) async {
    final book = _books[index];
    final total = book['total'] as int;
    final current = book['read'] as int;
    final updated = (current + delta).clamp(0, total);

    setState(() => book['read'] = updated);

    try {
      await _persist();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İlerleme kaydedilemedi.')),
        );
      }
    }
  }

  Future<void> _deleteBook(int index) async {
    final removed = _books.removeAt(index);
    setState(() {});

    try {
      await _persist();
    } catch (_) {
      _books.insert(index, removed);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silme işlemi başarısız oldu.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = _books.where(
      (book) => (book['read'] as int) >= (book['total'] as int),
    ).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Okuma planım')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [navy, navyDeep]),
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
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'İlim yolculuğunda istikrar, küçük adımlarla kurulur.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_books.length} eser • $completed tamamlanan okuma',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Okuma hedefi ekle',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Eser veya kitap adı',
                    hintText: 'Örn. Sözler',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _totalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Toplam sayfa hedefi',
                    hintText: 'Örn. 300',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addBook,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Okuma planına ekle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Okuma listen',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                if (_books.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(22),
                      child: Text(
                        'Henüz eser eklemedin. İlk okuma hedefini yukarıdan oluştur.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...List.generate(_books.length, (index) {
                    final book = _books[index];
                    final total = book['total'] as int;
                    final read = book['read'] as int;
                    final progress = read / total;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_stories_rounded,
                                  color: red,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    book['title']?.toString() ?? '',
                                    style: const TextStyle(
                                      color: navy,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Eseri sil',
                                  onPressed: () => _deleteBook(index),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: pale,
                                color: red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$read / $total sayfa • ${(progress * 100).round()}%',
                              style: const TextStyle(
                                color: navy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: read > 0
                                      ? () => _changeRead(index, -1)
                                      : null,
                                  child: const Icon(Icons.remove_rounded),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: read < total
                                      ? () => _changeRead(index, 1)
                                      : null,
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('1 sayfa okudum'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: navy,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                if (read >= total) ...[
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 10),
                const Text(
                  'Okuma planın bu cihazda saklanır.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
    );
  }
}
