import 'package:flutter/material.dart';
import '../../../../app/shadows.dart';

const _navy = Color(0xFF0A1F44);

class QuickGridV2 extends StatelessWidget {
  final void Function(String label)? onTap;
  const QuickGridV2({super.key, this.onTap});

  static const items = [
    ('Kible', 'Yonunu bul', Icons.explore_rounded, Color(0xFF0A1F44)),
    ('Namaz Ogre', 'Adim adim rehber', Icons.menu_book_rounded, Color(0xFF1B5E7A)),
    ('Tesbih', 'Zikir sayaci', Icons.favorite_rounded, Color(0xFFB71C1C)),
    ('Takip', 'Gunluk kayit', Icons.calendar_today_rounded, Color(0xFF0A1F44)),
    ('Sukur', 'Gunluk notlar', Icons.edit_note_rounded, Color(0xFF2FAE7F)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.medium(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          return Expanded(
            child: _QuickItem(
              label: item.$1,
              subtitle: item.$2,
              icon: item.$3,
              color: item.$4,
              onTap: () => onTap?.call(item.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuickItem extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: color.withValues(alpha: 0.25), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: _navy,
                      fontSize: 10,
                      fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 1),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black45, fontSize: 8),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
