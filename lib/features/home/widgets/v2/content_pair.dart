import 'package:flutter/material.dart';

class ContentPair extends StatelessWidget {
  const ContentPair({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _ModernPairCard(
              label: 'Günün Ayeti',
              source: 'İnşirah Suresi',
              text: '"Şüphesiz her zorlukla beraber bir kolaylık vardır."',
              reference: '(İnşirah, 5-6)',
              gradient: const [Color(0xFF1A3A2E), Color(0xFF0A1F1A)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ModernPairCard(
              label: 'Günün Hadisi',
              source: 'Tirmizî',
              text: '"Namaz, müminin miracıdır."',
              reference: '(Tirmizî, Salât, 1)',
              gradient: const [Color(0xFF6B4A2A), Color(0xFF2A1F12)],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernPairCard extends StatelessWidget {
  final String label;
  final String source;
  final String text;
  final String reference;
  final List<Color> gradient;

  const _ModernPairCard({
    required this.label,
    required this.source,
    required this.text,
    required this.reference,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15, bottom: -15,
            child: Opacity(
              opacity: 0.12,
              child: Icon(Icons.menu_book_rounded, size: 100, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_right_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(source,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.4),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis),
                ),
                Text(reference,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
