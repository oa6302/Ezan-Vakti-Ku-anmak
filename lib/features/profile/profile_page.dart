import 'package:flutter/material.dart';
import 'package:nur_pusulasi/core/widgets/simple_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const SimplePage(
        icon: Icons.settings_rounded,
        title: 'Profil ve Ayarlar',
        subtitle:
            'Kişisel tercihler, gizlilik, hatırlatmalar ve uygulama ayarları.',
        items: [
          'Şehir ve vakit ayarları',
          'Bildirimler',
          'Seslendirme',
          'Yedekleme ve gizlilik',
          'Üyelik',
          'İçerik arşivi',
          'Admin Paneli',
        ],
      );
}
