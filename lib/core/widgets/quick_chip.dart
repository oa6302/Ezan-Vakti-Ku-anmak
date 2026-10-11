import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/theme.dart';
import 'package:nur_pusulasi/core/widgets/simple_page.dart';
import 'package:nur_pusulasi/features/growth/gratitude_journal_page.dart';

class QuickChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const QuickChip({super.key, required this.icon, required this.text});

  void _open(BuildContext context) {
    if (text == 'Şükür defteri') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const GratitudeJournalPage(),
        ),
      );
      return;
    }

    final destination = switch (text) {
      'Kıble pusulası' => 'Kıble Pusulası',
      'Namaz vakitleri' => 'Namaz Vakitleri',
      'Sesli kıssalar' => 'Sesli Kıssalar',
      'Dua ve zikir' => 'Dua ve Zikir',
      'Kısa sureler' => 'Kısa Sureler',
      _ => text,
    };

    final description = switch (text) {
      'Kıble pusulası' =>
        'Canlı kıble yönü için cihaz sensörleri ve konum desteği gerekir. Bu sürüm henüz kıble hesabı yapmıyor.',
      'Namaz vakitleri' =>
        'Namaz vakitleri için şehir seçimi ve güvenilir hesaplama kaynağı gerekir. Canlı vakit verisi henüz bağlı değil.',
      'Sesli kıssalar' =>
        'Bu bölümde kaynakları doğrulanmış kıssa metinleri ve seslendirme sunulabilir.',
      'Dua ve zikir' =>
        'Günlük dua ve zikirlerini okuyabileceğin rehber bölümü.',
      'Kısa sureler' =>
        'Kısa surelerin Arapça metni, okunuşu ve doğrulanmış meali için rehber bölümü.',
      _ => 'Bu bölüm için içerikler hazırlanıyor.',
    };

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SimplePage(
          icon: icon,
          title: destination,
          subtitle: description,
          items: const [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _open(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E6EF)),
              boxShadow: [
                BoxShadow(
                  color: navy.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: red),
                const SizedBox(width: 7),
                Text(
                  text,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
