import 'package:flutter/material.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:nur_pusulasi/app/shadows.dart';

const _navy = Color(0xFF0A1F44);
const _green = Color(0xFF2FAE7F);
const _gold = Color(0xFFC9A961);

/// GitHub tarzı 365 günlük ısı haritası.
/// Sütun = hafta, satır = gün (Pzt..Paz)
class YearHeatmap extends StatelessWidget {
  final List<int> daily; // son N gün (eski -> yeni), değer 0..5
  final int days;
  final void Function(int daysAgo)? onDayTap;

  const YearHeatmap({
    super.key,
    required this.daily,
    this.days = 365,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    // Veriyi hafta sütunlarına böl
    final weeks = <List<int?>>[];
    // Bugünün hafta içi indeksi (Pazartesi=0)
    final today = DateTime.now();
    final todayWeekday = (today.weekday - 1) % 7;
    // Son gün (bugün) bu hafta içinde. Önce son haftayı doldur.
    final total = daily.length;
    // Kaç hafta sütunu?
    final weekCount = ((total + todayWeekday) / 7).ceil();

    // Baştan doldur
    for (var i = 0; i < total; i++) {
      final weekIndex = (i + (7 - todayWeekday - 1) % 7) ~/ 7;
      final dayIndex = (i + (7 - todayWeekday - 1) % 7) % 7;
      // weeks'i güvenli büyüt
      while (weeks.length <= weekIndex) {
        weeks.add(List<int?>.filled(7, null));
      }
      weeks[weekIndex][dayIndex] = daily[i];
    }

    // Boş sütunları da ekle (bugünün haftasına kadar)
    while (weeks.length < weekCount) {
      weeks.add(List<int?>.filled(7, null));
    }

    return Container(
      padding: const EdgeInsets.all(14),
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
                    const Icon(Icons.grid_view_rounded, color: _navy, size: 16),
              ),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context).uiYillikIsiHaritasi,
                  style: TextStyle(
                      color: _navy, fontSize: 14, fontWeight: FontWeight.w900)),
              const Spacer(),
              _legend(context),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _weekdayLabels(),
                const SizedBox(width: 6),
                for (var w = 0; w < weeks.length; w++) ...[
                  _weekColumn(weeks[w], w, weeks.length),
                  const SizedBox(width: 3),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: Colors.black45, size: 12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).uiHerKareBirGunu,
                  style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.5), fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weekdayLabels() {
    const labels = ['Pt', '', 'Ça', '', 'Cu', '', 'Pz'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 0),
        for (var i = 0; i < 7; i++)
          SizedBox(
            height: 15,
            child: Text(
              labels[i],
              style: const TextStyle(fontSize: 9, color: Colors.black45),
            ),
          ),
      ],
    );
  }

  Widget _weekColumn(List<int?> week, int weekIndex, int totalWeeks) {
    return Column(
      children: [
        for (var d = 0; d < 7; d++) ...[
          _dayCell(week[d], d, weekIndex, totalWeeks),
          const SizedBox(height: 2),
        ],
      ],
    );
  }

  Widget _dayCell(int? count, int dayIdx, int weekIdx, int totalWeeks) {
    final daysAgo = (totalWeeks - 1 - weekIdx) * 7 + (6 - dayIdx);
    final val = count ?? 0;

    Color color;
    if (count == null) {
      color = Colors.transparent;
    } else if (val == 0) {
      color = const Color(0xFFE9EEF5);
    } else if (val == 1) {
      color = _green.withValues(alpha: 0.25);
    } else if (val == 2) {
      color = _green.withValues(alpha: 0.45);
    } else if (val == 3) {
      color = _green.withValues(alpha: 0.65);
    } else if (val == 4) {
      color = _green.withValues(alpha: 0.85);
    } else {
      color = _green;
    }

    return GestureDetector(
      onTap:
          count != null && onDayTap != null ? () => onDayTap!(daysAgo) : null,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          border: count == 5 ? Border.all(color: _gold, width: 1) : null,
        ),
      ),
    );
  }

  Widget _legend(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context).uiAz,
            style: TextStyle(fontSize: 9, color: Colors.black45)),
        const SizedBox(width: 4),
        for (final a in [0.0, 0.25, 0.45, 0.65, 1.0]) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: a == 0
                  ? const Color(0xFFE9EEF5)
                  : _green.withValues(alpha: a),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 2),
        ],
        const SizedBox(width: 2),
        Text(AppLocalizations.of(context).uiCok,
            style: TextStyle(fontSize: 9, color: Colors.black45)),
      ],
    );
  }
}
