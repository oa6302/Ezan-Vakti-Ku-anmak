import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/theme.dart';
import 'package:nur_pusulasi/core/widgets/content_card.dart';
import 'package:nur_pusulasi/core/widgets/simple_page.dart';
import 'package:nur_pusulasi/data/content_repository.dart';
import 'package:nur_pusulasi/data/models/content_item.dart';
import 'package:nur_pusulasi/features/growth/daily_goals_page.dart';
import 'package:nur_pusulasi/features/growth/gratitude_journal_page.dart';
import 'package:nur_pusulasi/features/growth/reading_plan_page.dart';
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
          SliverToBoxAdapter(
            child: HomeHeader(
              onNotificationTap: () => _openSimple(
                context,
                icon: Icons.notifications_active_rounded,
                title: 'Bildirimler',
                subtitle: 'Günlük manevi rutinini takip et.',
                items: const [
                  'Günlük hedefler',
                  'Şükür defteri',
                  'Okuma planım',
                  'Haftalık ilerleme',
                ],
              ),
              onProfileTap: () {},
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
            sliver: SliverList.list(children: [
              // === Günün Tefekkürü (JSON'dan) ===
              _DailyReflectionFromJson(),
              const SizedBox(height: 18),

              // === Günlük Hedefler ===
              DailyGoalsWidget(
                completed: 2,
                total: 5,
                goals: const [
                  DailyGoal(title: 'Günlük zikirleri tamamla', completed: true),
                  DailyGoal(title: 'En az 30 dakika kitap oku', completed: true),
                  DailyGoal(title: '5 vakit namazını kıl', completed: false),
                  DailyGoal(title: 'Günün duasını oku', completed: false),
                  DailyGoal(title: 'Kendine vakit ayır', completed: false),
                ],
                onSeeAll: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const DailyGoalsPage()),
                ),
              ),
              const SizedBox(height: 18),

              // === Hızlı Erişim ===
              QuickAccessGrid(
                items: const [
                  QuickAccessItem(
                      icon: Icons.pan_tool_alt_rounded,
                      label: 'Dua',
                      color: Color(0xFF10264B)),
                  QuickAccessItem(
                      icon: Icons.favorite_rounded,
                      label: 'Zikir',
                      color: Color(0xFFD91E36)),
                  QuickAccessItem(
                      icon: Icons.menu_book_rounded,
                      label: 'Kısa Sureler',
                      color: Color(0xFF2E4A6F)),
                  QuickAccessItem(
                      icon: Icons.auto_stories_rounded,
                      label: 'Kıssalar',
                      color: Color(0xFF2FAE7F)),
                  QuickAccessItem(
                      icon: Icons.explore_rounded,
                      label: 'Vecizeler',
                      color: Color(0xFFC9A961)),
                  QuickAccessItem(
                      icon: Icons.calendar_month_rounded,
                      label: 'Okuma Planı',
                      color: Color(0xFF10264B)),
                  QuickAccessItem(
                      icon: Icons.track_changes_rounded,
                      label: 'Günlük Hedefler',
                      color: Color(0xFF2FAE7F)),
                  QuickAccessItem(
                      icon: Icons.bookmark_rounded,
                      label: 'Kaydedilenler',
                      color: Color(0xFF2E4A6F)),
                  QuickAccessItem(
                      icon: Icons.folder_special_rounded,
                      label: 'İçerik Arşivi',
                      color: Color(0xFFD91E36)),
                  QuickAccessItem(
                      icon: Icons.settings_rounded,
                      label: 'Profil',
                      color: Color(0xFF1F2937)),
                ],
                onTap: (item) => _openQuick(context, item),
                onSeeAll: () => _openSimple(
                  context,
                  icon: Icons.grid_view_rounded,
                  title: 'Tüm Özellikler',
                  subtitle: 'Uygulamadaki tüm bölümlere buradan ulaşabilirsin.',
                  items: const [
                    'Kıble pusulası',
                    'Namaz vakitleri',
                    'Sesli kıssalar',
                    'Dua ve zikir',
                    'Kısa sureler',
                    'Şükür defteri',
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // === Son Okunanlar + Kaydedilenler (2 sütun) ===
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _MiniInfoCard(
                      icon: Icons.menu_book_rounded,
                      title: 'Son Okunanlar',
                      subtitle: 'İslami Hayatta Başarı',
                      detail: '5 dk okuma · %65',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => const ReadingPlanPage()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniInfoCard(
                      icon: Icons.bookmark_rounded,
                      title: 'Kaydedilenler',
                      subtitle: 'Gönül İklimi',
                      detail: '12 kayıt',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => const SavedItemsPage()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // === Pusulaya Sor (arama) ===
              const VoiceGuideCard(),
              const SizedBox(height: 18),

              // === Günün Ayeti ve Hadisi ===
              const _SectionTitle(
                  icon: Icons.wb_sunny_rounded,
                  title: 'Günün Manevi Pusulası',
                  subtitle: 'Bir ayet, bir hikmet, bir adım'),
              const SizedBox(height: 12),
              _ContentFromJson(
                  category: 'ayetler',
                  tag: 'GÜNÜN AYETİ',
                  accent: navy,
                  icon: Icons.menu_book_rounded),
              const SizedBox(height: 12),
              _ContentFromJson(
                  category: 'hadisler',
                  tag: 'GÜNÜN HADİSİ',
                  accent: red,
                  icon: Icons.link_rounded),
              const SizedBox(height: 24),

              const Text(
                'Not: Bu başlangıç sürümündeki dinî içerikler örnek arayüz verileridir. Yayına çıkmadan önce güvenilir kaynaklardan doğrulanmalıdır.',
                style: TextStyle(
                    color: Colors.black54, fontSize: 11, height: 1.5),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _openSimple(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> items,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SimplePage(
            icon: icon, title: title, subtitle: subtitle, items: items),
      ),
    );
  }

  void _openQuick(BuildContext context, QuickAccessItem item) {
    if (item.label == 'Kaydedilenler') {
      Navigator.push(context,
          MaterialPageRoute<void>(builder: (_) => const SavedItemsPage()));
      return;
    }
    if (item.label == 'Günlük Hedefler') {
      Navigator.push(context,
          MaterialPageRoute<void>(builder: (_) => const DailyGoalsPage()));
      return;
    }
    if (item.label == 'Okuma Planı') {
      Navigator.push(context,
          MaterialPageRoute<void>(builder: (_) => const ReadingPlanPage()));
      return;
    }
    if (item.label == 'Zikir') {
      Navigator.push(context,
          MaterialPageRoute<void>(builder: (_) => const GratitudeJournalPage()));
      return;
    }
    _openSimple(
      context,
      icon: item.icon,
      title: item.label,
      subtitle: 'Bu bölüm için içerikler hazırlanıyor.',
      items: const [],
    );
  }
}

// ==== JSON'dan günün tefekkürü ====
class _DailyReflectionFromJson extends StatefulWidget {
  @override
  State<_DailyReflectionFromJson> createState() =>
      _DailyReflectionFromJsonState();
}

class _DailyReflectionFromJsonState extends State<_DailyReflectionFromJson> {
  final ContentRepository _repo = LocalContentRepository();
  late Future<List<ContentItem>> _future;

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
        final items = snapshot.data ?? const [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()));
        }
        if (items.isEmpty) return const SizedBox.shrink();
        final item = items.first;
        return DailyReflectionCard(
          tag: 'Günün Tefekkürü',
          title: item.baslik,
          excerpt: item.metin,
          author: item.kaynak,
          onSave: () => _save(item),
          onTap: () => _detail(item),
        );
      },
    );
  }

  void _save(ContentItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kaydedilenler bölümüne eklendi.')),
    );
  }

  void _detail(ContentItem item) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ContentCard(
          icon: Icons.auto_awesome_rounded,
          tag: 'TEFEKKÜR',
          title: item.baslik,
          description: item.metin,
          source: item.kaynak,
          reflection: item.tefekkur,
          accent: navy,
        ),
      ),
    );
  }
}

// ==== Günün ayeti / hadisi ====
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
        final items = snapshot.data ?? const [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 80, child: Center(child: CircularProgressIndicator()));
        }
        if (items.isEmpty) return const SizedBox.shrink();
        final item = items.first;
        return ContentCard(
          icon: widget.icon,
          tag: widget.tag,
          title: item.baslik,
          description: item.metin,
          source: item.kaynak,
          reflection: item.tefekkur,
          accent: widget.accent,
        );
      },
    );
  }
}

// ==== Bölüm başlığı ====
class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: navy.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: navy)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}

// ==== Küçük bilgi kartı (Son Okunanlar / Kaydedilenler) ====
class _MiniInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String detail;
  final VoidCallback? onTap;

  const _MiniInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.detail,
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEDF1F7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: navy, size: 16),
                  const SizedBox(width: 6),
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
                      color: Colors.black38, size: 16),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      navy.withValues(alpha: 0.85),
                      navyDeep.withValues(alpha: 0.95)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child:
                      Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(height: 10),
              Text(subtitle,
                  style: const TextStyle(
                      color: navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(detail,
                  style: const TextStyle(
                      color: Colors.black45, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}