import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

class JobPerksRow extends StatelessWidget {
  final List<String> perks;

  const JobPerksRow({
    super.key,
    required this.perks,
  });

  static const Map<String, IconData> _perkIcons = {
    'Visa sponsorship': Icons.language,
    '401k matching': Icons.savings,
    '4-day work week': Icons.work_history,
    'Generous PTO': Icons.beach_access,
    'Parental leave': Icons.family_restroom,
    'Tuition reimbursement': Icons.school,
    'Health insurance': Icons.health_and_safety,
    'Remote work': Icons.home,
    'Flexible schedule': Icons.schedule,
    'Stock options': Icons.trending_up,
    'Gym membership': Icons.fitness_center,
    'Free meals': Icons.restaurant,
  };

  IconData _getIconForPerk(String perk) {
    return _perkIcons[perk] ?? Icons.star;
  }

  @override
  Widget build(BuildContext context) {
    if (perks.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits & Perks',
          style: textTheme.labelLarge?.copyWith(
            color: ContextColors.textPrimary,
          ),
        ),
        const SizedBox(height: ContextSpacing.sm),
        Wrap(
          spacing: ContextSpacing.sm,
          runSpacing: ContextSpacing.sm,
          children: perks.map((perk) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ContextSpacing.sm,
                vertical: ContextSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: ContextColors.accent.withAlpha(38),
                border: Border.all(
                  color: ContextColors.accent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForPerk(perk),
                    size: 16,
                    color: ContextColors.textPrimary,
                  ),
                  const SizedBox(width: ContextSpacing.xs),
                  Text(
                    perk,
                    style: textTheme.bodySmall?.copyWith(
                      color: ContextColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
