import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class DailyGoal {
  final String title;
  final bool completed;
  const DailyGoal({required this.title, required this.completed});
}

class DailyGoalsWidget extends StatelessWidget {
  final int completed;
  final int total;
  final List<DailyGoal> goals;
  final VoidCallback? onSeeAll;

  const DailyGoalsWidget({
    super.key,
    required this.completed,
    required this.total,
    required this.goals,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0 : (completed * 100 / total).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes_rounded, color: navy, size: 22),
              const SizedBox(width: 8),
              const Text('Günlük Hedefler',
                  style: TextStyle(
                      color: navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
              const Spacer(),
              Text('$completed / $total tamamlandı',
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              InkWell(
                onTap: onSeeAll,
                child: const Icon(Icons.chevron_right_rounded,
                    color: navy, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: pct / 100,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFFE9EEF5),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2FAE7F)),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('%$pct',
                            style: const TextStyle(
                                color: navy,
                                fontSize: 20,
                                fontWeight: FontWeight.w900)),
                        const Text('İlerleme',
                            style: TextStyle(
                                color: Colors.black45, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    for (final g in goals) ...[
                      _GoalRow(goal: g),
                      const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  final DailyGoal goal;
  const _GoalRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: goal.completed ? const Color(0xFF2FAE7F) : Colors.transparent,
            border: Border.all(
              color: goal.completed
                  ? const Color(0xFF2FAE7F)
                  : const Color(0xFFCBD5E1),
              width: 1.5,
            ),
            shape: BoxShape.circle,
          ),
          child: goal.completed
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(goal.title,
              style: TextStyle(
                  color: goal.completed ? navy : Colors.black87,
                  fontSize: 12,
                  fontWeight: goal.completed ? FontWeight.w600 : FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        Text(
          goal.completed ? 'Tamamlandı' : 'Bekliyor',
          style: TextStyle(
              color: goal.completed
                  ? const Color(0xFF2FAE7F)
                  : Colors.black38,
              fontSize: 10,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}