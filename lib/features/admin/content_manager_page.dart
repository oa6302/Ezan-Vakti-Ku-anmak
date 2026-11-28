import 'package:flutter/material.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
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
  static final List<ContentType> _yonetimTipleri =
      ContentType.values.where((t) => t != ContentType.tefekkur).toList();
  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String _query = '';
  ContentStatus? _durumFiltre;
  KaynakTuru? _kaynakFiltre;
  String _siralama = 'yeni'; // yeni | eski | baslik | durum

  @override
  void initState() {
    super.initState();
    final startIdx = widget.initialType != null
        ? _yonetimTipleri.indexOf(widget.initialType!)
        : 0;
    _tabCtrl = TabController(
      length: _yonetimTipleri.length,
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

  ContentType get _aktifTip => _yonetimTipleri[_tabCtrl.index];

  List<ContentItem> _filtrele(List<ContentItem> all) {
    final result = all.where((i) {
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        final ok = i.baslik.toLowerCase().contains(q) ||
            i.icerik.toLowerCase().contains(q) ||
            (i.kaynak ?? '').toLowerCase().contains(q) ||
            (i.kategori ?? '').toLowerCase().contains(q) ||
            (i.altIcerik ?? '').toLowerCase().contains(q);
        if (!ok) return false;
      }
      if (_durumFiltre != null && i.durum != _durumFiltre) return false;
      if (_kaynakFiltre != null && i.kaynakTuru != _kaynakFiltre) return false;
      return true;
    }).toList();

    switch (_siralama) {
      case 'baslik':
        result.sort((a, b) => a.baslik.compareTo(b.baslik));
        break;
      case 'durum':
        result.sort((a, b) => a.durum.index.compareTo(b.durum.index));
        break;
      case 'eski':
        result.sort((a, b) {
          final ad = a.guncellenme ?? DateTime(2000);
          final bd = b.guncellenme ?? DateTime(2000);
          return ad.compareTo(bd);
        });
        break;
      case 'yeni':
      default:
        result.sort((a, b) {
          final ad = a.guncellenme ?? DateTime(2000);
          final bd = b.guncellenme ?? DateTime(2000);
          return bd.compareTo(ad);
        });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          AppLocalizations.of(context).uiIcerikYonetimi2,
          style: TextStyle(
              color: _navy, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: AppLocalizations.of(context).uiTopluIslemler,
            icon: const Icon(Icons.more_vert_rounded, color: _navy),
            onSelected: (v) {
              if (v == 'publish') _publishAll();
              if (v == 'publish_filtered') _publishFiltered();
              if (v == 'delete_filtered') _deleteFiltered();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'publish',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.publish_rounded, color: _green),
                  title: Text(AppLocalizations.of(context)
                      .uiAktifSekmedekiTumunuYayinla),
                ),
              ),
              PopupMenuItem(
                value: 'publish_filtered',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.filter_alt_rounded, color: _green),
                  title: Text(
                      AppLocalizations.of(context).uiFiltrelenmisleriYayinla),
                ),
              ),
              PopupMenuItem(
                value: 'delete_filtered',
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.delete_sweep_rounded, color: _red),
                  title:
                      Text(AppLocalizations.of(context).uiFiltrelenmisleriSil),
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).uiAnaSayfadaKontrolEt,
            icon: const Icon(Icons.home_rounded, color: _navy),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).uiYedekAlJson,
            icon: const Icon(Icons.upload_file_rounded, color: _navy),
            onPressed: _exportAll,
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).uiYedektenYukleJson,
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
          tabs: _yonetimTipleri.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      body: Column(
        children: [
          _searchBar(),
          _filterRow(),
          _statsBar(),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: _yonetimTipleri.map(_buildList).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        onPressed: () => _openEditor(null, _aktifTip),
        icon: const Icon(Icons.add_rounded),
        label: Text(AppLocalizations.of(context).uiYeniEkle,
            style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // SEARCH + FILTER + STATS
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).uiBaslikIcerikKaynakVeya,
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _sortButton(),
        ],
      ),
    );
  }

  Widget _sortButton() {
    final icon = _siralama == 'baslik'
        ? Icons.sort_by_alpha_rounded
        : _siralama == 'durum'
            ? Icons.flag_rounded
            : _siralama == 'eski'
                ? Icons.schedule_rounded
                : Icons.history_rounded;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _showSortMenu,
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: _navy, size: 22),
        ),
      ),
    );
  }

  void _showSortMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(AppLocalizations.of(context).uiSiralama,
                  style: TextStyle(
                      color: _navy, fontWeight: FontWeight.w900, fontSize: 15)),
            ),
            _sortItem('yeni', 'En yeni', Icons.history_rounded),
            _sortItem('eski', 'En eski', Icons.schedule_rounded),
            _sortItem('baslik', 'Başlık (A-Z)', Icons.sort_by_alpha_rounded),
            _sortItem('durum', 'Durum', Icons.flag_rounded),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _sortItem(String key, String label, IconData icon) {
    final secili = _siralama == key;
    return ListTile(
      leading: Icon(icon, color: secili ? _green : _navy),
      title: Text(label,
          style: TextStyle(
              color: _navy,
              fontWeight: secili ? FontWeight.w900 : FontWeight.w600)),
      trailing: secili ? const Icon(Icons.check_rounded, color: _green) : null,
      onTap: () {
        setState(() => _siralama = key);
        Navigator.pop(context);
      },
    );
  }

  Widget _filterRow() {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          _filterChip(
            label: 'Tümü',
            secili: _durumFiltre == null && _kaynakFiltre == null,
            onTap: () => setState(() {
              _durumFiltre = null;
              _kaynakFiltre = null;
            }),
          ),
          const SizedBox(width: 6),
          ...ContentStatus.values.map((s) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _filterChip(
                label: s.label,
                secili: _durumFiltre == s,
                renk: _durumRenkFromStatus(s),
                onTap: () => setState(() => _durumFiltre = s),
              ),
            );
          }),
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            color: const Color(0xFFE9EEF5),
          ),
          ...KaynakTuru.values.map((k) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _filterChip(
                label: k.label.split(' ').first,
                secili: _kaynakFiltre == k,
                onTap: () => setState(() => _kaynakFiltre = k),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool secili,
    Color? renk,
    required VoidCallback onTap,
  }) {
    final c = renk ?? _navy;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: secili,
      onSelected: (_) => onTap(),
      selectedColor: c,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: secili ? Colors.white : _navy,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: secili ? c : const Color(0xFFE9EEF5),
        ),
      ),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
    );
  }

  Color _durumRenkFromStatus(ContentStatus s) {
    switch (s) {
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

  Widget _statsBar() {
    final tip = _aktifTip;
    final stats = ContentService.instance.stats(tip);
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(
                ContentService.instance.iconFor(
                    ContentItem(id: '', type: tip, baslik: '', icerik: '')),
                color: _navy.withValues(alpha: 0.6),
                size: 16),
            const SizedBox(width: 8),
            Text('${tip.label}:',
                style: const TextStyle(
                    color: _navy, fontSize: 12, fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            _statKutu('Toplam', stats['toplam'] ?? 0, _navy),
            const SizedBox(width: 6),
            _statKutu('Yayın', stats['yayinlandi'] ?? 0, _green),
            const SizedBox(width: 6),
            _statKutu('Taslak', stats['taslak'] ?? 0, Colors.grey),
            const SizedBox(width: 6),
            _statKutu('İnceleme', stats['incelemede'] ?? 0, _orange),
            const SizedBox(width: 6),
            _statKutu('Arşiv', stats['arsivlendi'] ?? 0, _red),
          ],
        ),
      ),
    );
  }

  Widget _statKutu(String label, int value, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: renk, fontSize: 9, fontWeight: FontWeight.w700)),
          const SizedBox(width: 4),
          Text('$value',
              style: TextStyle(
                  color: renk, fontSize: 11, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // EXPORT / IMPORT
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<void> _publishAll() async {
    final tip = _aktifTip;
    final pool = ContentService.instance.getPool(tip);
    await _publishList(pool, 'tümünü');
  }

  Future<void> _publishFiltered() async {
    final pool = ContentService.instance.getPool(_aktifTip);
    final filtered = _filtrele(pool);
    await _publishList(filtered, 'filtrelenmiş');
  }

  Future<void> _publishList(List<ContentItem> list, String etiket) async {
    final taslaklar =
        list.where((i) => i.durum != ContentStatus.yayinlandi).toList();
    if (taslaklar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).uiFYayinlanacakIcerikYok(etiket)),
          backgroundColor: _orange,
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context).uiFYayinla(etiket)),
        content: Text(AppLocalizations.of(context)
            .uiFIcerikYayinlanacakVeAna(taslaklar.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).uiIptal2),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _green),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).uiYayinla2),
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
        extra: item.extra,
      ));
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            AppLocalizations.of(context).uiFIcerikYayinlandi(taslaklar.length)),
        backgroundColor: _green,
      ),
    );
  }

  Future<void> _deleteFiltered() async {
    if (_aktifTip == ContentType.gunluk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context).ui365GunlukKayitlarKorunuyor)),
      );
      return;
    }
    final pool = ContentService.instance.getPool(_aktifTip);
    final filtered = _filtrele(pool);
    if (filtered.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).uiSilinecekIcerikYok),
          backgroundColor: _orange,
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context).uiFiltrelenmisleriSil2),
        content: Text(AppLocalizations.of(context)
            .uiFIcerikKaliciOlarakSilinecek(filtered.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).uiIptal2),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).adminDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;

    for (final item in filtered) {
      await ContentService.instance.remove(item.type, item.id);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            AppLocalizations.of(context).uiFIcerikSilindi(filtered.length)),
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
          content: Text(AppLocalizations.of(context).uiFYedekPanoyaKopyalandiKb(
              (json.length / 1024).toStringAsFixed(1))),
          backgroundColor: _green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).uiFHata(e)),
            backgroundColor: _red),
      );
    }
  }

  Future<void> _importPrompt() async {
    final ctrl = TextEditingController();
    final mode = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context).uiYedektenYukle),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).uiJsonYedeginiAsagiyaYapistirin,
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
            child: Text(AppLocalizations.of(context).uiIptal2),
          ),
          FilledButton.tonal(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.grey.shade300),
            onPressed: () => Navigator.pop(context, 'replace'),
            child: Text(AppLocalizations.of(context).uiUzerineYaz,
                style: TextStyle(color: _navy, fontWeight: FontWeight.w800)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _navy),
            onPressed: () => Navigator.pop(context, 'merge'),
            child: Text(AppLocalizations.of(context).uiBirlestir,
                style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );

    final raw = ctrl.text.trim();
    if (mode == null || raw.isEmpty) return;

    try {
      final count =
          await ContentService.instance.importFromJson(raw, mode: mode);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).uiFOgeEdildi(count, mode)),
          backgroundColor: _green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).uiFGecersizJson(e)),
            backgroundColor: _red),
      );
    }
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // LIST + BADGE
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Widget _buildList(ContentType type) {
    return ListenableBuilder(
      listenable: ContentService.instance,
      builder: (context, _) {
        final all = ContentService.instance.getPool(type);
        final filtered = _filtrele(all);
        if (type == ContentType.gunluk) {
          filtered.sort((a, b) {
            final ai = int.tryParse(a.id.replaceFirst('gunluk_', '')) ?? 999;
            final bi = int.tryParse(b.id.replaceFirst('gunluk_', '')) ?? 999;
            return ai.compareTo(bi);
          });
        }
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
                    all.isEmpty
                        ? 'Bu kategoride içerik yok. + ile ekleyin.'
                        : 'Filtreye uyan sonuç yok.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  if (all.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => setState(() {
                        _query = '';
                        _searchCtrl.clear();
                        _durumFiltre = null;
                        _kaynakFiltre = null;
                      }),
                      icon: const Icon(Icons.filter_alt_off_rounded),
                      label: Text(
                          AppLocalizations.of(context).uiFiltreleriTemizle),
                    ),
                  ],
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

  String _gorunenBaslik(ContentItem item) {
    if (item.type != ContentType.gunluk) return item.baslik;
    final sira = int.tryParse(item.id.replaceFirst('gunluk_', ''));
    return sira == null ? item.baslik : 'Gün ${sira + 1}';
  }

  Widget _itemTile(ContentItem item) {
    final durumRenk = _durumRengi(item);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7ECF4)),
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
                  _gorunenBaslik(item),
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
              if (item.type != ContentType.gunluk)
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
        style:
            TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
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
    if (item.type == ContentType.gunluk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .uiGunlukKayitlarSilinemezDuzenlemeye)),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context).uiSilinsinMi),
        content: Text(AppLocalizations.of(context).uiFSilinecek(item.baslik)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).uiIptal2),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).adminDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ContentService.instance.remove(item.type, item.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).uiSilindi),
        backgroundColor: _green,
      ),
    );
  }
}
