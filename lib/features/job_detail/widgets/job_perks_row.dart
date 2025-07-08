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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ContextSpacing.md),
          decoration: BoxDecoration(
            color: ContextColors.accent,
            border: Border.all(
              color: ContextColors.borderDark,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star,
                color: ContextColors.textPrimary,
              ),
              const SizedBox(width: ContextSpacing.sm),
              Text(
                'Benefits & Perks',
                style: textTheme.labelLarge?.copyWith(
                  color: ContextColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ContextSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(
              color: ContextColors.border,
              width: 2,
            ),
          ),
          child: Wrap(
            spacing: ContextSpacing.md,
            runSpacing: ContextSpacing.md,
            children: perks.map((perk) {
              return Container(
                padding: const EdgeInsets.all(ContextSpacing.md),
                decoration: BoxDecoration(
                  color: ContextColors.neutralLight,
                  border: Border.all(
                    color: ContextColors.border,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ContextSpacing.xs),
                      decoration: BoxDecoration(
                        color: ContextColors.accent,
                        border: Border.all(
                          color: ContextColors.borderDark,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getIconForPerk(perk),
                        size: 18,
                        color: ContextColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: ContextSpacing.sm),
                    Text(
                      perk,
                      style: textTheme.bodyMedium?.copyWith(
                        color: ContextColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
