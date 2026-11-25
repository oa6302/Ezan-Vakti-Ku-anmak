import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nur_pusulasi/app/shadows.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import '../data/hijri_data.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

class HijriPage extends StatelessWidget {
  const HijriPage({super.key});

  Future<void> _pickBirth(BuildContext context) async {
    final state = context.read<AppState>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.birthDate ?? DateTime(now.year - 30),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Dogum tarihini sec',
    );
    if (picked == null) return;
    await state.setBirthDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final birth = state.birthDate;
    final journey = birth == null ? null : computeJourney(birth);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Hicri Yasam Cizgisi',
            style: TextStyle(
                color: _navy, fontSize: 17, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _hero(),
          const SizedBox(height: 14),
          if (birth == null)
            _birthPrompt(context)
          else ...[
            _hijriTodayCard(),
            const SizedBox(height: 14),
            _journeyCard(context, journey!),
            const SizedBox(height: 14),
          ],
          _specialDaysCard(),
          const SizedBox(height: 14),
          _infoBox(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.deep(),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
            ),
            child:
                const Icon(Icons.auto_awesome_rounded, color: _gold, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hicri Yolculuk',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Miladi zamani hicri bakisla gor.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _birthPrompt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.calendar_month_rounded,
                color: _gold, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('Dogum Tarihini Gir',
              style: TextStyle(
                  color: _navy, fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text(
            'Hicri takvimde kac gun, kac Ramazan, kac cuma yasadigini goreceksin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _navy,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => _pickBirth(context),
              icon:
                  const Icon(Icons.edit_calendar_rounded, color: Colors.white),
              label: const Text('Tarih Sec',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hijriTodayCard() {
    final now = DateTime.now();
    final h = gregorianToHijri(now);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDF8F3), Color(0xFFF5EDE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
        boxShadow: AppShadows.colored(_gold, alpha: 0.15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                const Icon(Icons.brightness_2_rounded, color: _gold, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BUGUN (HICRI)',
                    style: TextStyle(
                        color: _gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2)),
                const SizedBox(height: 6),
                Text(h.toString(),
                    style: const TextStyle(
                        color: _navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _journeyCard(BuildContext context, LifeJourney j) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    const Icon(Icons.timeline_rounded, color: _navy, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('Yasam Cizgin',
                  style: TextStyle(
                      color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
              const Spacer(),
              TextButton(
                onPressed: () => _pickBirth(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                ),
                child: const Text('Degistir', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _statRow(Icons.calendar_today_rounded, 'Yasadigin Gun',
              '${j.totalDays}', _green),
          const Divider(height: 20),
          _statRow(Icons.event_repeat_rounded, 'Yasadigin Yil',
              '${j.totalYears}', _navy),
          const Divider(height: 20),
          _statRow(Icons.nightlight_round, 'Yasadigin Ramazan',
              '${j.totalRamazans}', _gold),
          const Divider(height: 20),
          _statRow(
              Icons.mosque_rounded, 'Kildigin Cuma', '~${j.totalCumas}', _navy),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.hourglass_bottom_rounded,
                    color: _gold, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tahmini ${j.remainingRamazans} Ramazan daha yasayabilirsin (75 yas varsayimi).',
                    style: const TextStyle(
                        color: _navy, fontSize: 11, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  color: _navy, fontSize: 13, fontWeight: FontWeight.w700)),
        ),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _specialDaysCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.star_rounded, color: _gold, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('Onemli Hicri Gunler',
                  style: TextStyle(
                      color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          ...ozelGunler.map((g) => _specialDayTile(g)),
        ],
      ),
    );
  }

  Widget _specialDayTile(SpecialDay g) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: _gold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(g.ad,
                        style: const TextStyle(
                            color: _navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(g.tarih,
                          style: const TextStyle(
                              color: _gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(g.aciklama,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _gold, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hicri tarihler yaklasik hesaplanir. Resmi kandil ve bayram tarihleri icin Diyanet Isleri Baskanligi takvimini esas aliniz.',
              style: TextStyle(color: _navy, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
