import 'package:flutter/material.dart';
import 'package:nur_pusulasi/core/widgets/simple_page.dart';

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage(
        icon: Icons.track_changes_rounded,
        title: 'Kişisel Manevi Pusula',
        subtitle:
             'Kendi hedeflerini belirle, günlük takibini yap ve şükür notlarını kaydet.',
        items: [
          'Günlük hedefler',
           'Şükür defteri',
           'Okuma planım',
           'Haftalık ilerleme'
        ],
      );
}
