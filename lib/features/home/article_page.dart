import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../data/models/content_item.dart';

class ArticlePage extends StatelessWidget {
  final ContentItem item;
  final String tag;

  const ArticlePage({super.key, required this.item, this.tag = 'MAKALE'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(tag,
            style: const TextStyle(
                color: navy, fontSize: 14, fontWeight: FontWeight.w900,
                letterSpacing: 1)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_rounded, color: red),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kaydedilenler bölümüne eklendi.')),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık görseli
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E4A6F), Color(0xFF0F1E36)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_stories_rounded,
                          color: Colors.white, size: 40),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(item.kategori.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                    ),
                  ),
                ],
              ),
            ),
            // Başlık
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(item.baslik,
                  style: const TextStyle(
                      color: navy,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.25)),
            ),
            // Meta
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      color: Colors.black45, size: 14),
                  const SizedBox(width: 4),
                  Text('${(item.metin.length / 200).ceil()} dk okuma',
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 12)),
                  const SizedBox(width: 16),
                  const Icon(Icons.person_outline_rounded,
                      color: Colors.black45, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(item.kaynak,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            // Ana metin
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(item.metin,
                  style: const TextStyle(
                      color: navy,
                      fontSize: 16,
                      height: 1.8)),
            ),
            const SizedBox(height: 24),
            // Tefekkür kutusu
            if (item.tefekkur.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6FA),
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(
                      left: BorderSide(color: red, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline_rounded,
                            color: red, size: 18),
                        SizedBox(width: 6),
                        Text('TEFEKKÜR',
                            style: TextStyle(
                                color: navy,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(item.tefekkur,
                        style: const TextStyle(
                            color: navy, fontSize: 14, height: 1.7)),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Kaynak
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KAYNAK',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1)),
                  const SizedBox(height: 6),
                  Text(item.kaynak,
                      style: const TextStyle(
                          color: navy, fontSize: 13, height: 1.6)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}