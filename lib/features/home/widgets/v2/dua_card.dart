import 'package:flutter/material.dart';
import '../../../../app/shadows.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);

class DuaCard extends StatelessWidget {
  const DuaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            height: 140,
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
            child: const Center(
              child: Text(
                'رَبِّ',
                style: TextStyle(
                  fontSize: 48,
                  color: _gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
                      const Text('Günün Duası',
                          style: TextStyle(
                              color: _navy,
                              fontSize: 14,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Sabah Duası',
                            style: TextStyle(
                                color: _navy, fontSize: 9)),
                      ),
                      const Spacer(),
                      const Icon(Icons.bookmark_border_rounded,
                          color: _red, size: 18),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'رَبِّ زِدْنِي عِلْمًا',
                    style: TextStyle(
                        fontSize: 20,
                        color: _navy,
                        fontWeight: FontWeight.w600,
                        height: 1.5),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '"Rabbim, bana ilim artır."',
                    style: TextStyle(
                        color: _navy,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 4),
                  const Text('(Tâhâ, 114)',
                      style: TextStyle(
                          color: Colors.black45, fontSize: 10)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: _navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 18),
                    ),
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
