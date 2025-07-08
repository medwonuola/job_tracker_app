import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

class LoadingStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? color;
  final double? size;

  const LoadingStateWidget({
    super.key,
    this.message = 'Loading...',
    this.icon,
    this.color,
    this.size,
  });

  factory LoadingStateWidget.search() {
    return const LoadingStateWidget(
      message: 'Searching for jobs...',
      color: AppColors.accent,
    );
  }

  factory LoadingStateWidget.processing() {
    return const LoadingStateWidget(
      message: 'Processing...',
      color: AppColors.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.accent;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: effectiveColor.withAlpha(25),
                border: Border.all(
                  color: effectiveColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: effectiveColor,
                size: size ?? 48,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          CircularProgressIndicator(
            color: effectiveColor,
            strokeWidth: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
