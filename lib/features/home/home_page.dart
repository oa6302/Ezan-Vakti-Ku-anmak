import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/theme.dart';
import 'package:nur_pusulasi/core/widgets/simple_page.dart';
import 'package:nur_pusulasi/data/content_repository.dart';
import 'package:nur_pusulasi/data/models/content_item.dart';
import 'package:nur_pusulasi/features/growth/daily_goals_page.dart';
import 'package:nur_pusulasi/features/growth/gratitude_journal_page.dart';
import 'package:nur_pusulasi/features/growth/reading_plan_page.dart';
import 'package:nur_pusulasi/features/home/article_page.dart';
import 'package:nur_pusulasi/features/home/voice_guide_card.dart';
import 'package:nur_pusulasi/features/home/widgets/daily_goals_widget.dart';
import 'package:nur_pusulasi/features/home/widgets/daily_reflection_card.dart';
import 'package:nur_pusulasi/features/home/widgets/home_header.dart';
import 'package:nur_pusulasi/features/home/widgets/quick_access_grid.dart';
import 'package:nur_pusulasi/features/profile/saved_items_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: HomeHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 100),
            sliver: SliverList.list(children: [
              // === 1) Günün Tefekkürü (mockup: sol gradient + metin) ===
              _ReflectionBlock(),
              const SizedBox(height: 16),

              // === 2) Günlük Hedefler ===
              DailyGoalsWidget(
                completed: 3,
                total: 5,
                goals: const [
                  DailyGoal(title: 'Günlük zikirleri tamamla', completed: true),
                  DailyGoal(title: 'En az 30 dakika kitap oku', completed: true),
                  DailyGoal(title: '5 vakit namazını kıl', completed: true),
                  DailyGoal(title: 'Günün duasını oku', completed: false),
                  DailyGoal(title: 'Kendine vakit ayır', completed: false),
                ],
                onSeeAll: () => Navigator.push(context,
                    MaterialPageRoute<void>(builder: (_) => const DailyGoalsPage())),
              ),
              const SizedBox(height: 16),

              // === 3) Hızlı Erişim (5x2 grid) ===
              QuickAccessGrid(
                items: const [
                  QuickAccessItem(icon: Icons.pan_tool_alt_rounded, label: 'Dua', color: Color(0xFF10264B)),
                  QuickAccessItem(icon: Icons.favorite_rounded, label: 'Zikir', color: Color(0xFFD91E36)),
                  QuickAccessItem(icon: Icons.menu_book_rounded, label: 'Kısa Sureler', color: Color(0xFF2E4A6F)),
                  QuickAccessItem(icon: Icons.auto_stories_rounded, label: 'Kıssalar', color: Color(0xFF2FAE7F)),
                  QuickAccessItem(icon: Icons.explore_rounded, label: 'Vecizeler', color: Color(0xFFC9A961)),
                  QuickAccessItem(icon: Icons.calendar_month_rounded, label: 'Okuma Planı', color: Color(0xFF10264B)),
                  QuickAccessItem(icon: Icons.track_changes_rounded, label: 'Günlük Hedefler', color: Color(0xFF2FAE7F)),
                  QuickAccessItem(icon: Icons.bookmark_rounded, label: 'Kaydedilenler', color: Color(0xFF2E4A6F)),
                  QuickAccessItem(icon: Icons.folder_special_rounded, label: 'İçerik Arşivi', color: Color(0xFFD91E36)),
                  QuickAccessItem(icon: Icons.settings_rounded, label: 'Profil ve Ayarlar', color: Color(0xFF1F2937)),
                ],
                onTap: (item) => _openQuick(context, item),
                onSeeAll: () => _openSimple(context,
                    icon: Icons.grid_view_rounded,
                    title: 'Tüm Özellikler',
                    subtitle: 'Uygulamadaki tüm bölümlere buradan ulaş.',
                    items: const ['Kıble', 'Namaz', 'Kıssalar', 'Dualar']),
              ),
              const SizedBox(height: 16),

              // === 4) Son Okunanlar + Kaydedilen İçerikler ===
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _MiniInfoCard(
                      icon: Icons.menu_book_rounded,
                      title: 'Son Okunanlar',
                      subtitle: 'İslami Hayatta Başarı',
                      author: 'Mustafa İslamoğlu',
                      detail: '5 dk okuma · %65',
                      progress: 0.65,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute<void>(builder: (_) => const ReadingPlanPage())),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniInfoCard(
                      icon: Icons.bookmark_rounded,
                      title: 'Kaydedilen İçerikler',
                      subtitle: 'Gönül İklimi',
                      author: 'Prof. Dr. Mehmet Okuyan',
                      detail: '12 dk okuma',
                      progress: null,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute<void>(builder: (_) => const SavedItemsPage())),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // === 5) Pusulaya Sor ===
              const VoiceGuideCard(),
              const SizedBox(height: 16),

              // === 6) Günün Ayeti + Hadisi + Kıssa ===
              _ContentFromJson(
                  category: 'ayetler', tag: 'GÜNÜN AYETİ',
                  accent: navy, icon: Icons.menu_book_rounded),
              const SizedBox(height: 12),
              _ContentFromJson(
                  category: 'hadisler', tag: 'GÜNÜN HADİSİ',
                  accent: red, icon: Icons.link_rounded),
              const SizedBox(height: 12),
              _ContentFromJson(
                  category: 'kissalar', tag: 'GÜNÜN KISSASI',
                  accent: const Color(0xFF2FAE7F), icon: Icons.auto_stories_rounded),
              const SizedBox(height: 24),

              const Text(
                'Not: Bu içerikler örnek arayüz verileridir. Yayına çıkmadan önce güvenilir kaynaklardan doğrulanmalıdır.',
                style: TextStyle(color: Colors.black54, fontSize: 11, height: 1.5),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _openSimple(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required List<String> items}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SimplePage(
            icon: icon, title: title, subtitle: subtitle, items: items),
      ),
    );
  }

  void _openQuick(BuildContext context, QuickAccessItem item) {
    switch (item.label) {
      case 'Kaydedilenler':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (_) => const SavedItemsPage()));
        break;
      case 'Günlük Hedefler':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (_) => const DailyGoalsPage()));
        break;
      case 'Okuma Planı':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (_) => const ReadingPlanPage()));
        break;
      case 'Zikir':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (_) => const GratitudeJournalPage()));
        break;
      default:
        _openSimple(context,
            icon: item.icon,
            title: item.label,
            subtitle: 'Bu bölüm için içerikler hazırlanıyor.',
            items: const []);
    }
  }
}

// ==== Günün Tefekkürü bloğu (mockup: kart + sayfa noktaları) ====
class _ReflectionBlock extends StatefulWidget {
  @override
  State<_ReflectionBlock> createState() => _ReflectionBlockState();
}

class _ReflectionBlockState extends State<_ReflectionBlock> {
  final ContentRepository _repo = LocalContentRepository();
  late Future<List<ContentItem>> _future;
  // ignore: prefer_final_fields
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _future = _repo.byCategory('vecizeler');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContentItem>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 160, child: Center(child: CircularProgressIndicator()));
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) return const SizedBox.shrink();
        final item = items[_page % items.length];
        return Column(
          children: [
            DailyReflectionCard(
              tag: 'Günün Tefekkürü',
              title: item.baslik,
              excerpt: item.metin,
              author: item.kaynak,
              onSave: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kaydedildi.')),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (_) => ArticlePage(item: item, tag: 'TEFEKKÜR')),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(items.length > 5 ? 5 : items.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == (_page % 5) ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == (_page % 5) ? navy : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

// ==== Ayet / Hadis / Kıssa kartı (tıklayınca makale) ====
class _ContentFromJson extends StatefulWidget {
  final String category;
  final String tag;
  final Color accent;
  final IconData icon;
  const _ContentFromJson({
    required this.category,
    required this.tag,
    required this.accent,
    required this.icon,
  });

  @override
  State<_ContentFromJson> createState() => _ContentFromJsonState();
}

class _ContentFromJsonState extends State<_ContentFromJson> {
  final ContentRepository _repo = LocalContentRepository();
  late Future<List<ContentItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.byCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContentItem>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 80, child: Center(child: CircularProgressIndicator()));
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) return const SizedBox.shrink();
        final item = items.first;
        return _ModernCard(
          icon: widget.icon,
          tag: widget.tag,
          title: item.baslik,
          excerpt: item.metin,
          source: item.kaynak,
          accent: widget.accent,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) => ArticlePage(item: item, tag: widget.tag)),
          ),
        );
      },
    );
  }
}

// ==== Modern içerik kartı ====
class _ModernCard extends StatelessWidget {
  final IconData icon;
  final String tag;
  final String title;
  final String excerpt;
  final String source;
  final Color accent;
  final VoidCallback onTap;

  const _ModernCard({
    required this.icon,
    required this.tag,
    required this.title,
    required this.excerpt,
    required this.source,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: navy.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tag,
                        style: TextStyle(
                            color: accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(title,
                        style: const TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            height: 1.3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text(excerpt,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                            height: 1.35),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text(source,
                        style: TextStyle(
                            color: accent, fontSize: 10,
                            fontStyle: FontStyle.italic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ==== Küçük bilgi kartı (mockup: küçük görsel + başlık + progress) ====
class _MiniInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String author;
  final String detail;
  final double? progress;
  final VoidCallback? onTap;

  const _MiniInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.detail,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: navy.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: navy, size: 14),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            color: navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.black38, size: 14),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          navy.withValues(alpha: 0.85),
                          navyDeep.withValues(alpha: 0.95),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.menu_book_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subtitle,
                            style: const TextStyle(
                                color: navy,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                height: 1.25),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Text(author,
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 9),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(detail,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 9),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: const Color(0xFFE9EEF5),
                          valueColor: const AlwaysStoppedAnimation<Color>(navy),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('${(progress! * 100).round()}%',
                        style: const TextStyle(
                            color: navy,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}