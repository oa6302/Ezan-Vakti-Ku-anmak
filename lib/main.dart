import 'package:flutter/material.dart';

import 'app/theme.dart';
import 'features/home/home_page.dart';
import 'features/library/library_page.dart';
import 'features/profile/saved_items_page.dart';
import 'features/profile/profile_page.dart';
import 'features/prayer/prayer_page.dart';
import 'features/growth/growth_page.dart';
import 'features/growth/daily_goals_page.dart';
import 'features/admin/content_archive_page.dart';

void main() => runApp(const NurPusulasiApp());

class NurPusulasiApp extends StatelessWidget {
  const NurPusulasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5 Vakit Namaz',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  static const Color _navy = Color(0xFF10264B);
  static const Color _red = Color(0xFFD91E36);

  static const List<Widget> _pages = [
    HomePage(),
    LibraryPage(),
    SavedItemsPage(),
    ProfilePage(),
  ];

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _showQuickActions() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hızlı İşlemler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.flag_rounded,
                title: 'Günlük Hedefler',
                subtitle: 'Günlük manevi hedeflerini takip et',
                onTap: () => Navigator.pop(sheetContext, 'goals'),
              ),
              _ActionTile(
                icon: Icons.access_time_rounded,
                title: 'Namaz Vakitleri',
                subtitle: 'Namaz ve ibadet bölümünü aç',
                onTap: () => Navigator.pop(sheetContext, 'prayer'),
              ),
              _ActionTile(
                icon: Icons.trending_up_rounded,
                title: 'Kişisel Gelişim',
                subtitle: 'Gelişim ve ilerleme içerikleri',
                onTap: () => Navigator.pop(sheetContext, 'growth'),
              ),
              _ActionTile(
                icon: Icons.menu_book_rounded,
                title: 'İçerik Arşivi',
                subtitle: 'Uygulamadaki içeriklere göz at',
                onTap: () => Navigator.pop(sheetContext, 'archive'),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted || choice == null) return;

    final Widget? page = switch (choice) {
      'goals' => const DailyGoalsPage(),
      'prayer' => const PrayerPage(),
      'growth' => const GrowthPage(),
      'archive' => const ContentArchivePage(),
      _ => null,
    };

    if (page != null) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => page),
      );
    }
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final selected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _selectTab(index),
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 62,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 23,
                color: selected ? _red : const Color(0xFF8993A5),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? _navy : const Color(0xFF8993A5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 58,
        height: 58,
        child: FloatingActionButton(
          heroTag: 'main_navigation_plus',
          onPressed: _showQuickActions,
          backgroundColor: _red,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 34),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 16,
        shadowColor: _navy.withValues(alpha: 0.12),
        surfaceTintColor: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 7,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Ana Sayfa',
              ),
              _navItem(
                index: 1,
                icon: Icons.explore_rounded,
                label: 'Keşfet',
              ),
              const SizedBox(width: 66),
              _navItem(
                index: 2,
                icon: Icons.bookmark_rounded,
                label: 'Kaydedilenler',
              ),
              _navItem(
                index: 3,
                icon: Icons.person_rounded,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 3),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: const Color(0xFF10264B)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF10264B),
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

