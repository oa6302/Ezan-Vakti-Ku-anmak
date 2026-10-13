import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const months = ['Ocak','Şubat','Mart','Nisan','Mayıs','Haziran','Temmuz','Ağustos','Eylül','Ekim','Kasım','Aralık'];
    const days = ['Pazartesi','Salı','Çarşamba','Perşembe','Cuma','Cumartesi','Pazar'];
    final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}';
    final dayStr = days[now.weekday - 1];
    final greeting = now.hour < 12 ? 'Hayırlı sabahlar' : now.hour < 18 ? 'Hayırlı gündüzler' : 'Hayırlı akşamlar';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [navy, navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: const Icon(Icons.explore_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('5 Vakit Namaz',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                        Text('Namazla huzura, ibadetle huşuya',
                            style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(greeting, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 3),
              const Text('Nur Pusulası Kullanıcısı',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 13),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text('$dateStr · $dayStr',
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_filled_rounded, color: Colors.white70, size: 13),
                        SizedBox(width: 5),
                        Text('İkindi 16:43', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
