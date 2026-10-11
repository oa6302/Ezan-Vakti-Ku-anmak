import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nur_pusulasi/app/theme.dart';

class AdminContentPage extends StatefulWidget {
  const AdminContentPage({super.key});

  @override
  State<AdminContentPage> createState() => _AdminContentPageState();
}

class _AdminContentPageState extends State<AdminContentPage> {
  static const _key = 'nur_pusulasi_content_library_v1';
  static const _categories = <String>[
    'Tefekkür', 'Türkçe vecizeler', 'Dua ve zikir', 'Kısa sureler',
    'Ayet', 'Hadis', 'Kur’an kıssaları', 'İslam tarihi',
    'Osmanlıca rika vecizeleri'
  ];

  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String _filter = 'Tümü';

  static List<Map<String, dynamic>> _starterItems() => [
    {
      'id': 'starter_1', 'category': 'Tefekkür',
      'title': 'Küçük iyiliklerin kıymeti',
      'body': 'Her iyiliğin büyük ve görünür olması gerekmez. Güzel bir söz, içten bir teşekkür ve kimse görmeden yapılan bir yardım da insanın hayatına anlam katar.',
      'source': 'Özgün editoryal içerik', 'verified': true, 'published': true
    },
    {
      'id': 'starter_2', 'category': 'Tefekkür',
      'title': 'Sabır ve gayret',
      'body': 'Sabır yalnızca beklemek değildir; doğru bildiğin yolda, şartlar zorlaştığında da ölçülü ve kararlı biçimde gayret etmektir.',
      'source': 'Özgün editoryal içerik', 'verified': true, 'published': true
    },
    {
      'id': 'starter_3', 'category': 'Tefekkür',
      'title': 'Şükür üzerine düşünce',
      'body': 'Sahip olduklarını fark etmek, eksiklerini inkâr etmek değildir. Şükür, nimeti görürken sorumluluğu da unutmamaktır.',
      'source': 'Özgün editoryal içerik', 'verified': true, 'published': true
    },
    {
      'id': 'starter_4', 'category': 'Türkçe vecizeler',
      'title': 'Güzel söz',
      'body': 'Güzel söz, gönül incitmeden hakikati anlatabilme gayretidir.',
      'source': 'Özgün söz; tarihî kişiye atfedilmez', 'verified': true, 'published': true
    },
    {
      'id': 'starter_5', 'category': 'Türkçe vecizeler',
      'title': 'İlim ve tevazu',
      'body': 'İlim arttıkça insanın bilmediklerini fark etmesi de artar.',
      'source': 'Özgün söz; tarihî kişiye atfedilmez', 'verified': true, 'published': true
    },
    {
      'id': 'starter_6', 'category': 'Dua ve zikir',
      'title': 'Dua içeriği ekleyin',
      'body': 'Yayımlamadan önce dua metnini, anlamını ve varsa rivayet kaynağını güvenilir bir kaynakla karşılaştırın.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_7', 'category': 'Kısa sureler',
      'title': 'Sure metni ekleyin',
      'body': 'Arapça metni, okunuşu ve meali güvenilir bir mushaf ve meal kaynağıyla doğruladıktan sonra ekleyin.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_8', 'category': 'Ayet',
      'title': 'Ayet metni ekleyin',
      'body': 'Sure ve ayet numarasını, Arapça metni ve meal bilgisini güvenilir kaynaktan doğrulayarak ekleyin.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_9', 'category': 'Hadis',
      'title': 'Hadis metni ekleyin',
      'body': 'Hadis metnini, tercümesini ve kaynak bilgisini kontrol edin. Derecelendirme konusunda yetkin kaynaklardan doğrulama yapmadan yayımlamayın.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_10', 'category': 'Kur’an kıssaları',
      'title': 'Kıssa içeriği ekleyin',
      'body': 'Kıssanın ilgili sure ve ayetlerini belirleyin; tefsir açıklamalarını ayet metninden ayrı sunun ve kaynaklarını kaydedin.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_11', 'category': 'İslam tarihi',
      'title': 'Tarih konusu ekleyin',
      'body': 'Tarihî olayın tarihini, kişilerini ve anlatımını güvenilir tarih kaynaklarıyla kontrol ederek ekleyin.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_12', 'category': 'Osmanlıca rika vecizeleri',
      'title': 'Rika metni ekleyin',
      'body': 'Görseli, özgün yazımı, günümüz harfleriyle aktarımı ve anlamını kontrol ettikten sonra yayımlayın.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == null) {
      _items = _starterItems();
      await _save();
    } else {
      try {
        _items = (jsonDecode(saved) as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } catch (_) {
        _items = _starterItems();
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_items));
  }

  Future<void> _edit({Map<String, dynamic>? item}) async {
    final title = TextEditingController(text: item?['title']?.toString() ?? '');
    final body = TextEditingController(text: item?['body']?.toString() ?? '');
    final source = TextEditingController(text: item?['source']?.toString() ?? '');
    String category = _categories.contains(item?['category'])
        ? item!['category'] as String : _categories.first;
    bool verified = item?['verified'] == true;
    bool published = item?['published'] == true;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(item == null ? 'Yeni içerik' : 'İçeriği düzenle'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) { if (v != null) setDialogState(() => category = v); },
                  ),
                  TextField(controller: title, decoration: const InputDecoration(labelText: 'Başlık')),
                  TextField(
                    controller: body,
                    minLines: 4,
                    maxLines: 8,
                    decoration: const InputDecoration(labelText: 'İçerik metni'),
                  ),
                  TextField(controller: source, decoration: const InputDecoration(labelText: 'Kaynak / not')),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Kaynak kontrolü tamamlandı'),
                    value: verified,
                    onChanged: (v) => setDialogState(() => verified = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Yayımla'),
                    subtitle: const Text('Doğrulanmamış metni yayımlamaman önerilir.'),
                    value: published,
                    onChanged: (v) => setDialogState(() => published = v),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Vazgeç')),
            FilledButton(
              onPressed: () {
                if (title.text.trim().isEmpty || body.text.trim().isEmpty) return;
                Navigator.pop(dialogContext, {
                  'id': item?['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
                  'category': category,
                  'title': title.text.trim(),
                  'body': body.text.trim(),
                  'source': source.text.trim(),
                  'verified': verified,
                  'published': published,
                });
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    title.dispose();
    body.dispose();
    source.dispose();

    if (result == null || !mounted) return;
    setState(() {
      final index = _items.indexWhere((e) => e['id'] == result['id']);
      if (index >= 0) {
        _items[index] = result;
      } else {
        _items.insert(0, result);
      }
    });
    await _save();
  }

  Future<void> _delete(Map<String, dynamic> item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('İçerik silinsin mi?'),
        content: Text('"${item['title']}" kalıcı olarak silinecek.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Vazgeç')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sil')),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _items.removeWhere((e) => e['id'] == item['id']));
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filter == 'Tümü'
        ? _items
        : _items.where((e) => e['category'] == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
        actions: [
          IconButton(
            tooltip: 'Yönetici PIN’ini değiştir',
            icon: const Icon(Icons.lock_reset_rounded),
            onPressed: _changePin,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('İçerik ekle'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_items.length} içerik • ${_items.where((e) => e['published'] == true).length} yayımlanmış',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _filter,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Kategori filtresi'),
                        items: ['Tümü', ..._categories].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _filter = v ?? 'Tümü'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: visible.isEmpty
                      ? const Center(child: Text('Bu kategoride içerik yok. + düğmesiyle ekleyin.'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final item = visible[index];
                            final published = item['published'] == true;
                            final verified = item['verified'] == true;
                            return Card(
                              child: ListTile(
                                isThreeLine: true,
                                leading: Icon(
                                  published && verified ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                                  color: published && verified ? Colors.green : red,
                                ),
                                title: Text(item['title']?.toString() ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w800)),
                                subtitle: Text(
                                  '${item['category']} • ${published ? 'Yayında' : 'Taslak'} • ${verified ? 'Kontrol edildi' : 'Kaynak kontrolü gerekli'}\n${item['body']}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (v) {
                                    if (v == 'edit') _edit(item: item);
                                    if (v == 'delete') _delete(item);
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                                    PopupMenuItem(value: 'delete', child: Text('Sil')),
                                  ],
                                ),
                                onTap: () => _edit(item: item),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Future<void> _changePin() async {
    final controller = TextEditingController();
    final newPin = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yönetici PIN’ini değiştir'),
        content: TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 12,
          decoration: const InputDecoration(labelText: 'Yeni PIN (en az 4 karakter)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().length >= 4) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: const Text('Değiştir'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (newPin == null || newPin.length < 4) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nur_pusulasi_admin_pin_v1', newPin);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN bu cihazda güncellendi.')),
      );
    }
  }
}
