import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nur_pusulasi/app/theme.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({super.key});

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  static const _storageKey = 'nur_pusulasi_saved_items_v1';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  List<Map<String, String>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null) {
        _items = (jsonDecode(raw) as List<dynamic>).map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return <String, String>{
            'title': map['title']?.toString() ?? '',
            'text': map['text']?.toString() ?? '',
            'date': map['date']?.toString() ?? '',
          };
        }).toList();
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_items));
  }

  Future<void> _add() async {
    final title = _titleController.text.trim();
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kaydetmek için bir metin yaz.')),
      );
      return;
    }

    final now = DateTime.now();
    final date =
        '${now.day.toString().padLeft(2, '0')}.'
        '${now.month.toString().padLeft(2, '0')}.'
        '${now.year}';

    setState(() {
      _items.insert(0, {
        'title': title.isEmpty ? 'Kaydedilen not' : title,
        'text': text,
        'date': date,
      });
      _titleController.clear();
      _textController.clear();
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

  Future<void> _delete(int index) async {
    final removed = _items.removeAt(index);
    setState(() {});
    try {
      await _persist();
    } catch (_) {
      _items.insert(index, removed);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Kaydedilenler')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [navy, navyDeep]),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'Sana anlamlı gelen sözleri ve kişisel notlarını burada sakla.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Başlık (isteğe bağlı)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _textController,
                    minLines: 3,
                    maxLines: 6,
                    maxLength: 2000,
                    decoration: const InputDecoration(
                      labelText: 'Kaydedilecek metin',
                      hintText: 'Vecize, düşünce veya kişisel not...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _add,
                      icon: const Icon(Icons.bookmark_add_rounded),
                      label: const Text('Kaydet'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Kayıtların (${_items.length})',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_items.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Henüz kaydedilmiş metin yok.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...List.generate(_items.length, (index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(
                            Icons.bookmark_rounded,
                            color: red,
                          ),
                          title: Text(
                            item['title'] ?? '',
                            style: const TextStyle(
                              color: navy,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${item['date'] ?? ''}\n${item['text'] ?? ''}',
                            ),
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Sil',
                            onPressed: () => _delete(index),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: red,
                            ),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 10),
                  const Text(
                    'Kayıtlar bu cihazda saklanır.',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
      );
}
