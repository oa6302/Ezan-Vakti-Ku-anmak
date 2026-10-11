import 'package:flutter/material.dart';

import 'app/theme.dart';
import 'features/home/home_page.dart';
import 'features/library/library_page.dart';
import 'features/growth/growth_page.dart';
import 'features/prayer/prayer_page.dart';
import 'features/profile/profile_page.dart';

void main() => runApp(const NurPusulasiApp());

class NurPusulasiApp extends StatelessWidget {
  const NurPusulasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nur Pusulası',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final pages = const [
    HomePage(),
    PrayerPage(),
    LibraryPage(),
    GrowthPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        indicatorColor: red.withValues(alpha: .12),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_rounded), label: 'Ana Sayfa'),
          NavigationDestination(
              icon: Icon(Icons.access_time_filled_rounded), label: 'İbadet'),
          NavigationDestination(
              icon: Icon(Icons.auto_stories_rounded), label: 'Kütüphane'),
          NavigationDestination(
              icon: Icon(Icons.track_changes_rounded), label: 'Gelişim'),
          NavigationDestination(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}