import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';
import 'package:job_tracker_app/core/widgets/app_button.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final Color? backgroundColor;
  final Color? borderColor;

  const ErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline_rounded,
    this.onRetry,
    this.retryButtonText,
    this.backgroundColor,
    this.borderColor,
  });

  factory ErrorStateWidget.network({
    Key? key,
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      key: key,
      title: 'Connection Error',
      message: 'Network connection failed. Please check your internet.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      retryButtonText: 'Retry',
      backgroundColor: AppColors.warningLight,
      borderColor: AppColors.warning,
    );
  }

  factory ErrorStateWidget.noResults({
    Key? key,
    String? customMessage,
  }) {
    return ErrorStateWidget(
      key: key,
      title: 'No Results Found',
      message: customMessage ?? 'No jobs found matching your criteria.',
      icon: Icons.search_off_rounded,
      backgroundColor: AppColors.neutralLight,
      borderColor: AppColors.border,
    );
  }

  factory ErrorStateWidget.generic({
    Key? key,
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      key: key,
      title: 'Something Went Wrong',
      message: customMessage ?? 'An unexpected error occurred.',
      onRetry: onRetry,
      retryButtonText: 'Try Again',
      backgroundColor: AppColors.warningLight,
      borderColor: AppColors.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final effectiveBackgroundColor = backgroundColor ?? AppColors.warningLight;
    final effectiveBorderColor = borderColor ?? AppColors.warning;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          border: Border.all(
            color: effectiveBorderColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: effectiveBorderColor.withAlpha(25),
                border: Border.all(
                  color: effectiveBorderColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: effectiveBorderColor,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                color: effectiveBorderColor,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: retryButtonText ?? 'Retry',
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
