import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

class JobPerksRow extends StatelessWidget {
  final List<String> perks;

  const JobPerksRow({
    super.key,
    required this.perks,
  });

  IconData _getIconForPerk(String perk) {
    final lowercasePerk = perk.toLowerCase();
    
    if (lowercasePerk.contains('health') || lowercasePerk.contains('insurance')) {
      return Icons.health_and_safety_rounded;
    } else if (lowercasePerk.contains('pto') || lowercasePerk.contains('vacation')) {
      return Icons.beach_access_rounded;
    } else if (lowercasePerk.contains('401k') || lowercasePerk.contains('retirement')) {
      return Icons.savings_rounded;
    } else if (lowercasePerk.contains('gym') || lowercasePerk.contains('fitness')) {
      return Icons.fitness_center_rounded;
    } else if (lowercasePerk.contains('remote') || lowercasePerk.contains('work from home')) {
      return Icons.home_work_rounded;
    } else if (lowercasePerk.contains('meal') || lowercasePerk.contains('food')) {
      return Icons.restaurant_rounded;
    } else if (lowercasePerk.contains('visa') || lowercasePerk.contains('sponsor')) {
      return Icons.flight_takeoff_rounded;
    } else if (lowercasePerk.contains('stock') || lowercasePerk.contains('equity')) {
      return Icons.trending_up_rounded;
    } else if (lowercasePerk.contains('education') || lowercasePerk.contains('tuition')) {
      return Icons.school_rounded;
    } else if (lowercasePerk.contains('parental') || lowercasePerk.contains('family')) {
      return Icons.family_restroom_rounded;
    }
    
    return Icons.star_rounded;
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
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: perks.map((perk) {
            return Container(
              constraints: const BoxConstraints(minWidth: 140),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.neutralLight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                    ),
                    child: Icon(
                      _getIconForPerk(perk),
                      size: 24,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    perk,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
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
