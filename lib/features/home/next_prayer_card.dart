import 'package:flutter/material.dart';
import '../../app/theme.dart';

class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({super.key});
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: red.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.access_time_filled_rounded,
                    color: red, size: 28)),
            const SizedBox(width: 13),
            const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('NAMAZ VAKİTLERİ',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  SizedBox(height: 4),
                  Text('Şehrini seçerek vakitleri ayarla',
                      style: TextStyle(
                          fontSize: 16,
                          color: navy,
                          fontWeight: FontWeight.w800)),
                  Text('Canlı vakit hesabı henüz bağlanmadı',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ])),
            const Icon(Icons.chevron_right_rounded, color: navy),
          ]),
        ),
      );
}