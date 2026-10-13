import 'package:flutter/material.dart';
import '../../../../app/shadows.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);

class VecizeCard extends StatelessWidget {
  const VecizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDF8F3), Color(0xFFF5EDE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.3), width: 1),
        boxShadow: AppShadows.colored(_gold, alpha: 0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst kısım: başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.format_quote_rounded, color: _gold, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('VECİZE',
                    style: TextStyle(
                        color: _gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_border_rounded,
                      color: _gold, size: 14),
                ),
              ],
            ),
          ),
          // Osmanlıca metin (üstte)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _navy.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                right: BorderSide(color: _gold.withValues(alpha: 0.4), width: 3),
              ),
            ),
            child: const Text(
              'بِلسِنِزْ كِى قَلْبْلَرْ اَنَجَقْ اَللهِى اَنْمَقْلَهْ حُضُورْ بُولُورْ',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 16,
                color: _navy,
                fontWeight: FontWeight.w600,
                height: 1.9,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Türkçe meal (altta)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '"Bilesiniz ki kalpler ancak Allah\'ı anmakla huzur bulur."',
              style: const TextStyle(
                  color: _navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 10),
          // Kaynak
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                Container(width: 20, height: 1, color: _gold),
                const SizedBox(width: 8),
                const Text('Ra\'d Suresi, 28. Ayet',
                    style: TextStyle(
                        color: _navy, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

