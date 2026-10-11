import 'package:flutter/material.dart';
import 'package:nur_pusulasi/core/widgets/simple_page.dart';

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage(
        icon: Icons.mosque_rounded,
        title: 'İbadet Rehberi',
         subtitle: 'Namaz vakitleri, kıble pusulası, sureler, dua ve zikir.',
        items: [
          'Namaz vakitleri',
          'Kıble pusulası',
          'Kısa sureler',
          'Dua ve zikir',
          'Kişisel namaz takibi'
        ],
      );
}
