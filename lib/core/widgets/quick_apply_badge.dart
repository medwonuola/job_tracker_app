import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

class QuickApplyBadge extends StatelessWidget {
  final double size;
  final bool showText;

  const QuickApplyBadge({
    super.key,
    this.size = 24.0,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ContextColors.accent,
        shape: BoxShape.circle,
        border: Border.all(
          color: ContextColors.background,
          width: 2.0,
        ),
      ),
      child: Icon(
        Icons.flash_on,
        color: ContextColors.textPrimary,
        size: size * 0.6,
      ),
    );

    if (!showText) {
      return badge;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        const SizedBox(width: ContextSpacing.xs),
        Text(
          'Quick Apply',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ContextColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
