import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nur_pusulasi/app/theme.dart';

class ContentArchivePage extends StatefulWidget {
  const ContentArchivePage({super.key});

  @override
  State<ContentArchivePage> createState() => _ContentArchivePageState();
}

class _ContentArchivePageState extends State<ContentArchivePage> {
  static const String _storageKey = 'nur_pusulasi_content_library_v1';
  static const List<String> _categories = [
    'Tümü', 'Tefekkür', 'Türkçe vecizeler', 'Dua ve zikir',
    'Kısa sureler', 'Ayet', 'Hadis', 'Kur’an kıssaları',
    'İslam tarihi', 'Osmanlıca rika vecizeleri'
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  String _category = 'Tümü';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    final result = <Map<String, dynamic>>[];

    if (saved != null) {
      try {
        for (final raw in jsonDecode(saved) as List<dynamic>) {
          final item = Map<String, dynamic>.from(raw as Map);
          if (item['published'] == true && item['verified'] == true) {
            result.add(item);
          }
        }
      } catch (_) {
        // Hatalı kayıt arşivin çökmesine neden olmaz.
      }
    }

    if (!mounted) return;
    setState(() {
      _items = result;
      _loading = false;
    });
  }

  Future<void> _copyBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey) ?? '[]';

    await Clipboard.setData(ClipboardData(text: raw));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('JSON yedeği panoya kopyalandı. Güvenli bir dosyaya yapıştırıp saklayabilirsin.'),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = _items.where((item) {
      final matchesCategory =
          _category == 'Tümü' || item['category'] == _category;
      final searchable = [
        item['title']?.toString() ?? '',
        item['body']?.toString() ?? '',
        item['source']?.toString() ?? '',
      ].join(' ').toLowerCase();

      return matchesCategory && (query.isEmpty || searchable.contains(query));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İçerik arşivi'),
        actions: [
          IconButton(
            tooltip: 'JSON yedeğini panoya kopyala',
            onPressed: _copyBackup,
            icon: const Icon(Icons.copy_all_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_rounded),
                          hintText: 'Başlık, metin veya kaynak ara',
                          suffixIcon: IconButton(
                            onPressed: _searchController.clear,
                            icon: const Icon(Icons.clear_rounded),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                        ),
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _category = value ?? 'Tümü'),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${filtered.length} yayımlanmış içerik',
                          style: const TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Eşleşen yayımlanmış içerik bulunamadı. '
                              'Kaynak kontrolü tamamlanmış içerikleri Admin Paneli üzerinden yayımlayabilirsin.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.menu_book_rounded,
                                  color: red,
                                ),
                                title: Text(
                                  item['title']?.toString() ?? '',
                                  style: const TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                subtitle: Text(
                                  '${item['category']}\n${item['body']}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                isThreeLine: true,
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        item['title']?.toString() ?? '',
                                      ),
                                      content: SingleChildScrollView(
                                        child: SelectableText(
                                          '${item['body']}\n\nKaynak: ${item['source'] ?? 'Belirtilmemiş'}',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Kapat'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
