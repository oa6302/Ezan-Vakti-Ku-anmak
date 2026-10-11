import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class DailyReflectionCard extends StatelessWidget {
  final String tag;
  final String title;
  final String excerpt;
  final String author;
  final VoidCallback? onSave;
  final VoidCallback? onTap;

  const DailyReflectionCard({
    super.key,
    this.tag = 'Günün Tefekkürü',
    required this.title,
    required this.excerpt,
    required this.author,
    this.onSave,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Görsel yerine gradient + ikon (resim sonra eklenebilir)
          Container(
            width: 130,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E4A6F), Color(0xFF0F1E36)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_stories_rounded,
                        color: Colors.white, size: 30),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: navy.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.menu_book_rounded,
                            color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(tag,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // İçerik
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          height: 1.25),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(excerpt,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          height: 1.5),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded,
                          color: Colors.black45, size: 13),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(author,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: onSave,
                        icon: const Icon(Icons.bookmark_add_rounded, size: 16),
                        label: const Text('Kaydet',
                            style: TextStyle(fontSize: 12)),
                        style: FilledButton.styleFrom(
                          backgroundColor: red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: onTap,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Row(
                          children: [
                            Text('Detayları Gör',
                                style: TextStyle(
                                    color: navy,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right_rounded,
                                color: navy, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}