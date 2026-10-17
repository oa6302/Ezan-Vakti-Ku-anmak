import 'package:flutter/material.dart';
import '../../../../app/shadows.dart';
import '../../../../app/content_service.dart';
import '../../../../widgets/admin_edit_overlay.dart';
import 'dua_detay_page.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);

class DuaCard extends StatelessWidget {
  const DuaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    return ListenableBuilder(
      listenable: ContentService.instance,
      builder: (context, _) {
        final dua = ContentService.instance
                .getForDay(ContentType.dua, dayOfYear) ??
            ContentService.instance.fallback(ContentType.dua);

        return Stack(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => DuaDetayPage(dua: dua)),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppShadows.medium(),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 110,
                        height: 150,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0A1F44), Color(0xFF05132B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                              ContentService.instance.iconFor(dua),
                              color: _gold,
                              size: 44),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Gunun Duasi',
                                      style: TextStyle(
                                          color: _navy,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: ContentService.instance
                                          .colorFor(dua)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text((dua.kategori ?? 'Genel'),
                                        style: TextStyle(
                                            color: ContentService.instance
                                                .colorFor(dua),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.bookmark_border_rounded,
                                      color: _red, size: 18),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(dua.baslik,
                                  style: const TextStyle(
                                      color: _navy,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 6),
                              Text((dua.arapca ?? ''),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: _navy.withValues(alpha: 0.85),
                                      fontWeight: FontWeight.w600,
                                      height: 1.5)),
                              const SizedBox(height: 4),
                              Text((dua.altIcerik ?? ''),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: _navy,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      height: 1.4)),
                              const SizedBox(height: 4),
                              Text('(${(dua.kaynak ?? '')})',
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 10)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Icerik havuzu',
                                      style: TextStyle(
                                          color: Colors.black
                                              .withValues(alpha: 0.4),
                                          fontSize: 9)),
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(
                                      color: _navy,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: AdminEditOverlay(item: dua),
            ),
          ],
        );
      },
    );
  }
}