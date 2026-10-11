import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/theme.dart';
import 'package:nur_pusulasi/core/widgets/section_heading.dart';
import 'package:nur_pusulasi/core/widgets/content_list_view.dart';
import 'package:nur_pusulasi/core/widgets/simple_page.dart';
import 'package:nur_pusulasi/core/widgets/quick_chip.dart';
import 'package:nur_pusulasi/features/home/voice_guide_card.dart';
import 'package:nur_pusulasi/features/home/next_prayer_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Row(children: [
            CircleAvatar(
                backgroundColor: navy,
                child: Icon(Icons.explore_rounded, color: Colors.white)),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nur Pusulası',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: navy, fontSize: 19)),
              Text('Gününü hikmetle güzelleştir',
                  style: TextStyle(fontSize: 11, color: Colors.black54)),
            ]),
          ]),
          actions: [
            IconButton(
              tooltip: 'Bildirimler ve hatırlatmalar',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SimplePage(
                      icon: Icons.notifications_active_rounded,
                      title: 'Bildirimler',
                      subtitle: 'Günlük manevi rutinini takip et.',
                      items: [
                        'Günlük hedefler',
                        'Şükür defteri',
                        'Okuma planım',
                        'Haftalık ilerleme',
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_none_rounded))
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          sliver: SliverList.list(children: [
            const VoiceGuideCard(),
            const SizedBox(height: 16),
            const NextPrayerCard(),
            const SizedBox(height: 20),
            const SectionHeading(
                icon: Icons.wb_sunny_rounded,
                title: 'Günün manevi pusulası',
                subtitle: 'Bir ayet, bir hikmet, bir adım'),
            const SizedBox(height: 12),
            ContentListView(
              category: 'ayetler',
              accent: navy,
              icon: Icons.menu_book_rounded,
              tagPrefix: 'GÜNÜN AYETİ',
              maxItems: 1,
            ),
            const SizedBox(height: 12),
            ContentListView(
              category: 'hadisler',
              accent: red,
              icon: Icons.link_rounded,
              tagPrefix: 'GÜNÜN HADİSİ',
              maxItems: 1,
            ),
            const SizedBox(height: 12),
            ContentListView(
              category: 'vecizeler',
              accent: navy,
              icon: Icons.auto_awesome_rounded,
              tagPrefix: 'GÜNÜN TEFEKKÜRÜ',
              maxItems: 1,
            ),
            const SizedBox(height: 20),

            const SectionHeading(
                icon: Icons.grid_view_rounded,
                title: 'Hızlı erişim',
                subtitle: 'İhtiyacın olan rehber bir dokunuş uzağında'),
            const SizedBox(height: 12),
            const Wrap(spacing: 10, runSpacing: 10, children: [
              QuickChip(icon: Icons.explore, text: 'Kıble pusulası'),
              QuickChip(icon: Icons.mosque, text: 'Namaz vakitleri'),
              QuickChip(icon: Icons.headphones, text: 'Sesli kıssalar'),
              QuickChip(icon: Icons.favorite, text: 'Dua ve zikir'),
              QuickChip(icon: Icons.auto_stories, text: 'Kısa sureler'),
              QuickChip(icon: Icons.edit_note, text: 'Şükür defteri'),
            ]),
            const SizedBox(height: 24),
            const Text(
                'Not: Bu başlangıç sürümündeki dinî içerikler örnek arayüz verileridir. Yayına çıkmadan önce ayet, hadis, meal ve fıkıh içerikleri güvenilir kaynaklardan doğrulanmalıdır.',
                style: TextStyle(
                    color: Colors.black54, fontSize: 12, height: 1.5)),
          ]),
        ),
      ],
    );
  }
}
