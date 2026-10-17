import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'content_editor_page.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _red = Color(0xFFB71C1C);
const _green = Color(0xFF2FAE7F);
const _orange = Color(0xFFF5A623);

class ContentManagerPage extends StatefulWidget {
  final ContentType? initialType;
  const ContentManagerPage({super.key, this.initialType});

  @override
  State<ContentManagerPage> createState() => _ContentManagerPageState();
}

class _ContentManagerPageState extends State<ContentManagerPage>
    with SingleTickerProviderStateMixin {
  static const _types = [
    ContentType.kissa,
    ContentType.dua,
    ContentType.vecize,
    ContentType.hadis,
    ContentType.tefekkur,  ];

  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    final startIdx = widget.initialType != null
        ? _types.indexOf(widget.initialType!)
        : 0;
    _tabCtrl = TabController(
      length: _types.length,
      vsync: this,
      initialIndex: startIdx < 0 ? 0 : startIdx,
    );
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text(
          'Icerik Havuzlari',
          style: TextStyle(
              color: _navy, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Tumunu yayinla',
            icon: const Icon(Icons.publish_rounded, color: _green),
            onPressed: _publishAll,
          ),
          IconButton(
            tooltip: 'Ana sayfada kontrol et',
            icon: const Icon(Icons.home_rounded, color: _navy),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            tooltip: 'Yedek al (JSON)',
            icon: const Icon(Icons.upload_file_rounded, color: _navy),
            onPressed: _exportAll,
          ),
          IconButton(
            tooltip: 'Yedekten yukle (JSON)',
            icon: const Icon(Icons.file_download_rounded, color: _navy),
            onPressed: _importPrompt,
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          labelColor: _navy,
          unselectedLabelColor: Colors.black45,
          indicatorColor: _gold,
          indicatorWeight: 3,
          tabs: _types.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) =>
                  setState(() => _query = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Ara...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: _types.map(_buildList).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        onPressed: () => _openEditor(null, _types[_tabCtrl.index]),
        icon: const Icon(Icons.add_rounded),
        label: const Text('YENI EKLE',
            style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // EXPORT / IMPORT
  // ═══════════════════════════════════════════════════════════

  Future<void> _publishAll() async {
    final aktifType = _types[_tabCtrl.index];
    final pool = ContentService.instance.getPool(aktifType);
    final taslaklar =
        pool.where((i) => i.durum != ContentStatus.yayinlandi).toList();
    if (taslaklar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu kategoride yayinlanacak icerik yok.'),
          backgroundColor: _orange,
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tumunu yayinla?'),
        content: Text(
            '${taslaklar.length} icerik yayinlanacak ve ana sayfada gorunecek. Onayliyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Iptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _green),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yayinla'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    for (final item in taslaklar) {
      await ContentService.instance.upsert(ContentItem(
        id: item.id,
        type: item.type,
        baslik: item.baslik,
        icerik: item.icerik,
        altIcerik: item.altIcerik,
        arapca: item.arapca,
        kaynak: item.kaynak,
        kategori: item.kategori,
        custom: item.custom,
        durum: ContentStatus.yayinlandi,
        dogrulandi: item.dogrulandi,
        kaynakURL: item.kaynakURL,
        kaynakTuru: item.kaynakTuru,
        guncellenme: DateTime.now(),
      ));
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${taslaklar.length} icerik yayinlandi'),
        backgroundColor: _green,
      ),
    );
  }

  Future<void> _exportAll() async {
    try {
      final json = ContentService.instance.exportAllAsJson();
      await Clipboard.setData(ClipboardData(text: json));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Yedek panoya kopyalandi (${(json.length / 1024).toStringAsFixed(1)} KB).\nNot defterine yapistirip saklayin.'),
          backgroundColor: _green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e'), backgroundColor: _red),
      );
    }
  }

  Future<void> _importPrompt() async {
    final ctrl = TextEditingController();
    final mode = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Yedekten yukle'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'JSON yedegini asagiya yapistirin. "Birlestir" varsa gunceller, yoksa ekler. "Uzerine yaz" mevcut havuzu siler.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: '{"version":1,"pools":{...}}',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Iptal'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(backgroundColor: Colors.grey.shade300),
            onPressed: () => Navigator.pop(context, 'replace'),
            child: const Text('Uzerine Yaz',
                style: TextStyle(color: _navy, fontWeight: FontWeight.w800)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _navy),
            onPressed: () => Navigator.pop(context, 'merge'),
            child: const Text('Birlestir',
                style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );

    final raw = ctrl.text.trim();
    if (mode == null || raw.isEmpty) return;

    try {
      final count = await ContentService.instance
          .importFromJson(raw, mode: mode);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count oge $mode edildi'),
          backgroundColor: _green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gecersiz JSON: $e'), backgroundColor: _red),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // LIST + BADGE
  // ═══════════════════════════════════════════════════════════

  Widget _buildList(ContentType type) {
    return ListenableBuilder(
      listenable: ContentService.instance,
      builder: (context, _) {
        final all = ContentService.instance.getPool(type);
        final filtered = _query.isEmpty
            ? all
            : all
                .where((i) =>
                    i.baslik.toLowerCase().contains(_query) ||
                    i.icerik.toLowerCase().contains(_query))
                .toList();
        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded,
                      size: 64, color: _navy.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Text(
                    _query.isEmpty
                        ? 'Bu kategoride icerik yok. + ile ekleyin.'
                        : 'Sonuc bulunamadi.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 90),
          itemCount: filtered.length,
          itemBuilder: (_, i) => _itemTile(filtered[i]),
        );
      },
    );
  }

  Widget _itemTile(ContentItem item) {
    final durumRenk = _durumRengi(item);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ContentService.instance
                .colorFor(item)
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            ContentService.instance.iconFor(item),
            color: ContentService.instance.colorFor(item),
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.baslik,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: _navy, fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),
            _badge(durumRenk, item.durum.label),
            if (item.dogrulandi) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified_rounded, color: _green, size: 14),
            ],
          ],
        ),
        subtitle: Text(
          item.icerik.length > 70
              ? '${item.icerik.substring(0, 70)}...'
              : item.icerik,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: _navy, size: 20),
              onPressed: () => _openEditor(item, item.type),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: _red, size: 20),
              onPressed: () => _confirmDelete(item),
            ),
          ],
        ),
        onTap: () => _openEditor(item, item.type),
        ),
      ),
    );
  }

  Color _durumRengi(ContentItem item) {
    if (item.kaynakTuru == KaynakTuru.aiDestekli && !item.dogrulandi) {
      return _orange;
    }
    switch (item.durum) {
      case ContentStatus.yayinlandi:
        return _green;
      case ContentStatus.taslak:
        return Colors.grey;
      case ContentStatus.incelemede:
        return _orange;
      case ContentStatus.arsivlendi:
        return _red;
    }
  }

  Widget _badge(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: color, fontSize: 9, fontWeight: FontWeight.w700),
      ),
    );
  }

  Future<void> _openEditor(ContentItem? item, ContentType type) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContentEditorPage(
          initial: item,
          defaultType: type,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(ContentItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Silinsin mi?'),
        content: Text('"${item.baslik}" silinecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Iptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ContentService.instance.remove(item.type, item.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Silindi'),
        backgroundColor: _green,
      ),
    );
  }
}
