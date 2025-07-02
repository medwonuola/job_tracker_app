import 'package:flutter/material.dart';
import 'package:job_tracker_app/theme/d3x_colors.dart';
import 'package:job_tracker_app/theme/d3x_spacing.dart';

enum D3XButtonVariant { primary, secondary, outline }

class D3XButton extends StatelessWidget {
  final D3XButtonVariant variant;
  final String label;
  final VoidCallback? onPressed;

  const D3XButton({
    super.key,
    this.variant = D3XButtonVariant.primary,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isEnabled = onPressed != null;

    Color backgroundColor;
    Color textColor;
    BorderSide borderSide;

    switch (variant) {
      case D3XButtonVariant.primary:
        backgroundColor = D3XColors.brandSecondary;
        textColor = D3XColors.textPrimary;
        borderSide = BorderSide.none;
        break;
      case D3XButtonVariant.secondary:
        backgroundColor = D3XColors.brandAccent;
        textColor = D3XColors.textPrimary;
        borderSide = BorderSide.none;
        break;
      case D3XButtonVariant.outline:
        backgroundColor = Colors.transparent;
        textColor = D3XColors.brandSecondary;
        borderSide =
            const BorderSide(color: D3XColors.brandSecondary, width: 2);
        break;
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: textColor.withOpacity(0.5),
        disabledBackgroundColor: backgroundColor.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(
          vertical: D3XSpacing.sm,
          horizontal: D3XSpacing.lg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D3XSpacing.sm),
          side: borderSide,
        ),
        textStyle: textTheme.labelLarge,
        elevation: 0,
      ),
      child: Text(label),
    );
  }
}
