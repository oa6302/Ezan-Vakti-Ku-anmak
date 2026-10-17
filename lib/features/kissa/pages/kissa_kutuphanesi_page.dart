import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';
import 'package:nur_pusulasi/widgets/favorite_button.dart';
import 'package:nur_pusulasi/features/kissa/pages/kissa_detail_page.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _borderSoft = Color(0xFFE9EEF5);

class KissaKutuphanesiPage extends StatefulWidget {
  const KissaKutuphanesiPage({super.key});
  @override
  State<KissaKutuphanesiPage> createState() => _KissaKutuphanesiPageState();
}

class _KissaKutuphanesiPageState extends State<KissaKutuphanesiPage> {
  final _search = TextEditingController();
  String _query = '';
  int _kategori = 0;

  static const _kategoriler = [
    'Tumu',
    'Peygamberler',
    'Siyer',
    'Kadin Sahabiler',
    'Genc Sahabiler',
    'Sahabe',
  ];

  List<ContentItem> _liste() {
    final all = ContentService.instance.getPool(ContentType.kissa);
    switch (_kategori) {
      case 1:
        return all.where((k) => k.id.startsWith('peyg_')).toList();
      case 2:
        return all.where((k) => k.id.startsWith('siyer_')).toList();
      case 3:
        return all.where((k) => k.id.startsWith('kadin_')).toList();
      case 4:
        return all.where((k) => k.id.startsWith('genc_')).toList();
      case 5:
        return all
            .where((k) =>
                k.id.startsWith('kissa_') ||
                k.id.startsWith('k6_') ||
                k.id.startsWith('k7_'))
            .toList();
      default:
        return all;
    }
  }

  List<ContentItem> _filtreli() {
    final q = _query.toLowerCase().trim();
    if (q.isEmpty) return _liste();
    return _liste().where((k) {
      return k.baslik.toLowerCase().contains(q) ||
          k.icerik.toLowerCase().contains(q) ||
          (k.kaynak ?? '').toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ContentService.instance,
      builder: (context, _) {
        final liste = _filtreli();
        return Scaffold(
          backgroundColor: const Color(0xFFF3F6FA),
          appBar: AppBar(
            title: const Text('Kissa Kutuphanesi',
                style: TextStyle(
                    color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: TextField(
                  controller: _search,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Kissa ara...',
                    prefixIcon: const Icon(Icons.search_rounded, color: _navy),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _search.clear();
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
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: _kategoriler.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final secili = _kategori == i;
                    return ChoiceChip(
                      label: Text(_kategoriler[i]),
                      selected: secili,
                      onSelected: (_) => setState(() => _kategori = i),
                      selectedColor: _navy,
                      labelStyle: TextStyle(
                        color: secili ? Colors.white : _navy,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: secili ? _navy : _borderSoft,
                        ),
                      ),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: liste.isEmpty
                    ? const Center(
                        child: Text('Kissa bulunamadi',
                            style: TextStyle(color: Colors.black54)),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                        itemCount: liste.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _KissaTile(
                          k: liste[i],
                          onChanged: () => setState(() {}),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KissaTile extends StatelessWidget {
  final ContentItem k;
  final VoidCallback? onChanged;
  const _KissaTile({required this.k, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final renk = ContentService.instance.colorFor(k);
    final ikon = ContentService.instance.iconFor(k);
    return Stack(
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (_) => KissaDetailPage(kissa: k)),
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderSoft),
                boxShadow: [
                  BoxShadow(
                    color: _navy.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          renk.withValues(alpha: 0.18),
                          renk.withValues(alpha: 0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: renk.withValues(alpha: 0.35), width: 1.5),
                    ),
                    child: Icon(ikon, color: renk, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(k.baslik,
                            style: const TextStyle(
                                color: _navy,
                                fontSize: 14,
                                fontWeight: FontWeight.w900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.bookmark_outline_rounded,
                                color: _gold.withValues(alpha: 0.8), size: 11),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(k.kaynak ?? '',
                                  style: const TextStyle(
                                      color: _gold,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.black26, size: 22),
                ],
              ),
            ),
          ),
        ),
        Positioned(top: 6, left: 6, child: FavoriteBadge(item: k, size: 16)),
          Positioned(
          top: 6,
          right: 6,
          child: AdminEditOverlay(item: k, onChanged: onChanged),
        ),
      ],
    );
  }
}