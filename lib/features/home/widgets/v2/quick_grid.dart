import 'package:flutter/material.dart';

const _navy = Color(0xFF0A1F44);

class QuickGridV2 extends StatelessWidget {
  final void Function(String label)? onTap;
  const QuickGridV2({super.key, this.onTap});

  static const items = [
    ('Kıble', 'Yönünü bul', Icons.explore_rounded),
    ('Namaz Öğren', 'Adım adım rehber', Icons.menu_book_rounded),
    ('Namaz Takibi', 'Bugün: 2/5', Icons.calendar_today_rounded),
    ('Kütüphane', 'Kur\'an, dua, hadis', Icons.library_books_rounded),
    ('Tesbih', 'Zikir sayacı', Icons.favorite_rounded),
    ('Şükür Defteri', 'Günlük notlar', Icons.edit_note_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.95,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap?.call(item.$1),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEDF1F7)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: _navy.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.$3, color: _navy, size: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(item.$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: _navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(item.$2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 9),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
