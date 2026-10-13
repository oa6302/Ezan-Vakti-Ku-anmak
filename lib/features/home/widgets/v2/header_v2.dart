import 'package:flutter/material.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);

class HomeHeaderV2 extends StatelessWidget {
  const HomeHeaderV2({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const months = ['Ocak','Şubat','Mart','Nisan','Mayıs','Haziran','Temmuz','Ağustos','Eylül','Ekim','Kasım','Aralık'];
    const days = ['Pazartesi','Salı','Çarşamba','Perşembe','Cuma','Cumartesi','Pazar'];
    final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}, ${days[now.weekday - 1]}';
    final hicri = _approxHijri(now);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: -20, top: 30,
              child: Opacity(
                opacity: 0.08,
                child: Icon(Icons.mosque_rounded, size: 200, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: _gold, width: 1.5),
                        ),
                        child: const Icon(Icons.mosque_rounded, color: _gold, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('5 Vakit Namaz',
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.3)),
                            SizedBox(height: 2),
                            Text('İbadetle huzura, doğruya ve hayra...',
                              style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const _IconCircle(icon: Icons.notifications_none_rounded),
                          Positioned(
                            right: 2, top: 2,
                            child: Container(
                              width: 10, height: 10,
                              decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const _IconCircle(icon: Icons.settings_outlined),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, color: Colors.white70, size: 15),
                      SizedBox(width: 6),
                      Text('İstanbul, Türkiye',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 13),
                      const SizedBox(width: 5),
                      Text(dateStr, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 12, color: Colors.white24),
                      const SizedBox(width: 8),
                      Text(hicri, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(width: 4),
                      const Icon(Icons.info_outline_rounded, color: Colors.white38, size: 12),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _approxHijri(DateTime d) {
    final jd = _gregorianToJD(d.year, d.month, d.day);
    final hijriJD = jd - 1948439.5;
    final hijriYear = ((hijriJD / 354.367) + 1).floor();
    final dayInYear = hijriJD - ((hijriYear - 1) * 354.367);
    final hijriMonth = ((dayInYear / 29.53).floor() + 1).clamp(1, 12);
    final hijriDay = (dayInYear - (hijriMonth - 1) * 29.53).round().clamp(1, 30);
    const m = ['Muharrem','Safer','Rebiülevvel','Rebiülahir','Cemaziyelevvel','Cemaziyelahir','Recep','Şaban','Ramazan','Şevval','Zilkade','Zilhicce'];
    return '$hijriDay ${m[hijriMonth-1]} $hijriYear';
  }

  double _gregorianToJD(int y, int m, int d) {
    if (m <= 2) { y -= 1; m += 12; }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d + b - 1524.5;
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  const _IconCircle({required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.1),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: Colors.white, size: 18),
  );
}
