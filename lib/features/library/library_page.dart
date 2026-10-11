import 'package:flutter/material.dart';
import 'package:nur_pusulasi/core/widgets/simple_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage(
        icon: Icons.auto_stories_rounded,
         title: 'İlim ve Hikmet Kütüphanesi',
        subtitle:
             'Vecizeler, Osmanlıca rika, Kur’an kıssaları ve doğrulanmış kaynaklar.',
        items: [
          'Osmanlıca rika vecizeleri',
          'Türkçe vecizeler',
           'Kur’an kıssaları',
          'İslam tarihi',
          'Kaydedilenler'
        ],
      );
}
