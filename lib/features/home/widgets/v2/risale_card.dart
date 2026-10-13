import 'package:flutter/material.dart';
import '../../../../app/shadows.dart';

const _red = Color(0xFFB71C1C);

class RisaleCard extends StatelessWidget {
  const RisaleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2E4A), Color(0xFF0A1F44)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.deep(),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20, top: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.auto_stories_rounded, size: 140, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('RİSALE-İ NUR',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_right_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Sabır ve Musibet Karşısında Dayanma',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      height: 1.3),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lem\'alar, İkinci Lem\'a: Hz. Eyyûb kıssası etrafındaki bahis',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Bediüzzaman Said Nursî',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time_rounded,
                        color: Colors.white54, size: 12),
                    const SizedBox(width: 4),
                    const Text('5 dk okuma',
                        style: TextStyle(
                            color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
