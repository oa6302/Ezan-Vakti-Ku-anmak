import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class QuickAccessItem {
  final IconData icon;
  final String label;
  final Color color;
  const QuickAccessItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class QuickAccessGrid extends StatelessWidget {
  final List<QuickAccessItem> items;
  final void Function(QuickAccessItem item)? onTap;
  final VoidCallback? onSeeAll;

  const QuickAccessGrid({
    super.key,
    required this.items,
    this.onTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: navy, size: 20),
              const SizedBox(width: 6),
              const Text('Hızlı Erişim',
                  style: TextStyle(
                      color: navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w900)),
              const Spacer(),
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                ),
                child: const Row(
                  children: [
                    Text('Tümünü Gör',
                        style: TextStyle(
                            color: navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded, color: navy, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) => _GridItem(
              item: items[i],
              onTap: () => onTap?.call(items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final QuickAccessItem item;
  final VoidCallback onTap;
  const _GridItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEDF1F7)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.color, size: 18),
              ),
              const SizedBox(height: 5),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: navy,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1.15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}