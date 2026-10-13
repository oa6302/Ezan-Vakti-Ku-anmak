import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _red = Color(0xFFB71C1C);
const _green = Color(0xFF2FAE7F);
const _gold = Color(0xFFC9A961);
const _bg = Color(0xFFF3F6FA);

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});
  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage>
    with SingleTickerProviderStateMixin {
  static const _key = 'nur_pusulasi_admin_items_v1';
  final _searchCtrl = TextEditingController();
  late TabController _tabCtrl;

  static const categories = [
    ('ayet', 'Ayet', Icons.menu_book_rounded, _navy),
    ('hadis', 'Hadis', Icons.link_rounded, _red),
    ('dua', 'Dua', Icons.pan_tool_alt_rounded, _gold),
    ('vecize', 'Vecize', Icons.format_quote_rounded, _green),
    ('risale', 'Risale', Icons.auto_stories_rounded, Color(0xFF6B4A2A)),
    ('kissa', 'Kıssa', Icons.history_edu_rounded, Color(0xFF2E4A6F)),
    ('zikir', 'Zikir', Icons.favorite_rounded, Color(0xFF7B1FA2)),
  ];

  List<Map<String, dynamic>> _items = [];
  String _filterCategory = 'all';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: categories.length + 1, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        setState(() => _filterCategory = _tabCtrl.index == 0
            ? 'all'
            : categories[_tabCtrl.index - 1].$1);
      }
    });
    _load();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _items = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } catch (_) {}
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_items));
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _items.where((i) {
      if (_filterCategory != 'all' && i['kategori'] != _filterCategory) {
        return false;
      }
      if (q.isEmpty) return true;
      final baslik = (i['baslik'] ?? '').toString().toLowerCase();
      final metin = (i['metin'] ?? '').toString().toLowerCase();
      return baslik.contains(q) || metin.contains(q);
    }).toList();
  }

  int _countOf(String cat) =>
      _items.where((i) => i['kategori'] == cat).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _header(),
          if (!_loading) ...[
            _searchBar(),
            _tabs(),
          ],
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _list(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(null),
        backgroundColor: _red,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni İçerik',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Panel',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900)),
                        Text('İçerik yönetim merkezi',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'PIN değiştir',
                    onPressed: _changePin,
                    icon: const Icon(Icons.lock_outline_rounded,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _statChip('${_items.length}', 'Toplam', _gold),
                  const SizedBox(width: 8),
                  _statChip('${_countOf('ayet') + _countOf('hadis')}', 'Ayet+Hadis', _green),
                  const SizedBox(width: 8),
                  _statChip('${_countOf('dua') + _countOf('vecize')}', 'Dua+Vecize', _red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.w900)),
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          hintText: 'Başlık veya metinde ara...',
          prefixIcon: Icon(Icons.search_rounded, color: _navy),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          _tabChip('Tümü', 'all', _items.length),
          ...categories.map((c) => _tabChip(c.$2, c.$1, _countOf(c.$1))),
        ],
      ),
    );
  }

  Widget _tabChip(String label, String catId, int count) {
    final active = _filterCategory == catId;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: active ? _navy : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _filterCategory = catId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: TextStyle(
                        color: active ? Colors.white : _navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white.withValues(alpha: 0.2)
                        : _navy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('$count',
                      style: TextStyle(
                          color: active ? Colors.white : _navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _list() {
    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _navy.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.inbox_rounded,
                  size: 48, color: _navy),
            ),
            const SizedBox(height: 16),
            const Text('Henüz içerik yok',
                style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Sağ alttaki + ile yeni içerik ekle',
                style: TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 100),
      itemCount: items.length,
      itemBuilder: (_, i) => _itemCard(items[i]),
    );
  }

  Widget _itemCard(Map<String, dynamic> item) {
    final cat = categories.firstWhere(
      (c) => c.$1 == item['kategori'],
      orElse: () => ('unknown', 'Diğer', Icons.help_rounded, Colors.grey),
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openEditor(item),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: cat.$4.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(cat.$3, color: cat.$4, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: cat.$4.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(cat.$2.toUpperCase(),
                                style: TextStyle(
                                    color: cat.$4,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1)),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: _red, size: 20),
                            tooltip: 'Sil',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _confirmDelete(item),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        (item['baslik'] ?? '').toString(),
                        style: const TextStyle(
                            color: _navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (item['metin'] ?? '').toString(),
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Map<String, dynamic> item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('İçeriği sil?'),
        content: Text('"${item['baslik']}" silinecek.'),
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
      setState(() => _items.remove(item));
      await _save();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('İçerik silindi'), backgroundColor: _red),
        );
      }
    }
  }

  Future<void> _openEditor(Map<String, dynamic>? existing) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditorSheet(existing: existing, categories: categories),
    );
    if (result == null) return;
    setState(() {
      if (existing != null) {
        final idx = _items.indexOf(existing);
        if (idx >= 0) _items[idx] = result;
      } else {
        _items.insert(0, result);
      }
    });
    await _save();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existing == null
              ? 'İçerik eklendi'
              : 'İçerik güncellendi'),
          backgroundColor: _green,
        ),
      );
    }
  }

  Future<void> _changePin() async {
    final ctrl = TextEditingController();
    final newPin = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('PIN Değiştir'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 8,
          decoration: const InputDecoration(
            labelText: 'Yeni PIN (en az 4 karakter)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal')),
          FilledButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    if (newPin == null || newPin.length < 4) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nur_pusulasi_admin_pin_v1', newPin);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('PIN güncellendi'), backgroundColor: _green),
      );
    }
  }
}

class _EditorSheet extends StatefulWidget {
  final Map<String, dynamic>? existing;
  final List<(String, String, IconData, Color)> categories;

  const _EditorSheet({required this.existing, required this.categories});

  @override
  State<_EditorSheet> createState() => _EditorSheetState();
}

class _EditorSheetState extends State<_EditorSheet> {
  late String _kategori;
  late TextEditingController _baslik;
  late TextEditingController _metin;
  late TextEditingController _kaynak;
  late TextEditingController _tefekkur;
  late TextEditingController _etiketler;

  @override
  void initState() {
    super.initState();
    final e = widget.existing ?? {};
    _kategori = (e['kategori'] ?? 'ayet').toString();
    _baslik = TextEditingController(text: (e['baslik'] ?? '').toString());
    _metin = TextEditingController(text: (e['metin'] ?? '').toString());
    _kaynak = TextEditingController(text: (e['kaynak'] ?? '').toString());
    _tefekkur = TextEditingController(text: (e['tefekkur'] ?? '').toString());
    _etiketler = TextEditingController(
        text: (e['etiketler'] is List)
            ? (e['etiketler'] as List).join(', ')
            : '');
  }

  @override
  void dispose() {
    _baslik.dispose();
    _metin.dispose();
    _kaynak.dispose();
    _tefekkur.dispose();
    _etiketler.dispose();
    super.dispose();
  }

  void _submit() {
    if (_baslik.text.trim().isEmpty || _metin.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Başlık ve metin zorunlu'),
            backgroundColor: _red),
      );
      return;
    }
    final etiketler = _etiketler.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final result = <String, dynamic>{
      'id': widget.existing?['id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      'kategori': _kategori,
      'baslik': _baslik.text.trim(),
      'metin': _metin.text.trim(),
      'kaynak': _kaynak.text.trim(),
      'tefekkur': _tefekkur.text.trim(),
      'etiketler': etiketler,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _navy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.existing == null
                          ? Icons.add_circle_rounded
                          : Icons.edit_rounded,
                      color: _navy, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.existing == null
                              ? 'Yeni İçerik'
                              : 'İçeriği Düzenle',
                          style: const TextStyle(
                              color: _navy,
                              fontSize: 17,
                              fontWeight: FontWeight.w900),
                        ),
                        const Text('Kaynak ve referans doğruluğuna dikkat et',
                            style: TextStyle(
                                color: Colors.black54, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: EdgeInsets.fromLTRB(
                    20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
                children: [
                  _label('Kategori'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.categories.map((c) {
                      final active = _kategori == c.$1;
                      return Material(
                        color: active
                            ? c.$4
                            : c.$4.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() => _kategori = c.$1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(c.$3,
                                    size: 16,
                                    color: active ? Colors.white : c.$4),
                                const SizedBox(width: 6),
                                Text(c.$2,
                                    style: TextStyle(
                                        color:
                                            active ? Colors.white : c.$4,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  _field('Başlık *', _baslik, maxLines: 1),
                  const SizedBox(height: 14),
                  _field('Metin *', _metin, maxLines: 5),
                  const SizedBox(height: 14),
                  _field('Kaynak', _kaynak,
                      maxLines: 1, hint: 'Örn. Bakara Suresi, 153. Ayet'),
                  const SizedBox(height: 14),
                  _field('Tefekkür', _tefekkur, maxLines: 3),
                  const SizedBox(height: 14),
                  _field('Etiketler (virgülle ayır)', _etiketler,
                      maxLines: 1, hint: 'sabır, namaz, dua'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _submit,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        widget.existing == null
                            ? 'İçeriği Ekle'
                            : 'Değişiklikleri Kaydet',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800),
                      ),
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

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          color: _navy, fontSize: 13, fontWeight: FontWeight.w800));

  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: _bg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}