import 'package:flutter/material.dart';

const _navy = Color(0xFF0A1F44);

class QuickGridV2 extends StatelessWidget {
  final void Function(String label)? onTap;
  const QuickGridV2({super.key, this.onTap});

  static const items = [
    ('Tesbih', 'Zikir sayacı', Icons.fingerprint_rounded, Color(0xFFD91E36)),
    (
      'Kandil & \u00D6zel G\u00FCnler',
      'M\u00FCbarek geceler',
      Icons.nights_stay_rounded,
      Color(0xFFC09A45)
    ),
    (
      'Hicri Ya\u015Fam \u00C7izgisi',
      'Hicri takvim',
      Icons.calendar_month_rounded,
      Color(0xFF10264B)
    ),
    (
      'Sesli Ezber Kontrol\u00FC',
      'Ezberini test et',
      Icons.record_voice_over_rounded,
      Color(0xFFD91E36)
    ),
    ('Favorilerim', 'Kaydedilenler', Icons.bookmark_rounded, Color(0xFF10264B)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFFF8FAFD), Color(0xFFEAF0F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD4DFEC)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x29354C68), blurRadius: 26, offset: Offset(0, 11)),
          BoxShadow(
              color: Color(0xAAFFFFFF), blurRadius: 5, offset: Offset(0, -2))
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap?.call(item.$1),
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: item.$4.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: item.$4.withValues(alpha: 0.18)),
                    ),
                    child: Icon(item.$3, color: item.$4, size: 25),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.$1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _navy,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
