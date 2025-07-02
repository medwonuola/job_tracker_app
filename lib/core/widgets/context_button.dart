import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

enum ContextButtonVariant { primary, outline }

class ContextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ContextButtonVariant variant;

  const ContextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ContextButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (variant == ContextButtonVariant.outline) {
              return Colors.transparent;
            }
            if (states.contains(MaterialState.pressed)) {
              return ContextColors.textPrimary;
            }
            return ContextColors.accent;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (variant == ContextButtonVariant.outline) {
              return ContextColors.textPrimary;
            }
            if (states.contains(MaterialState.pressed)) {
              return ContextColors.accent;
            }
            return ContextColors.textPrimary;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        side: MaterialStateProperty.all<BorderSide>(
          const BorderSide(color: ContextColors.borderDark, width: 2.0),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(
            vertical: ContextSpacing.md,
            horizontal: ContextSpacing.lg,
          ),
        ),
        textStyle: MaterialStateProperty.all(textTheme.labelLarge),
      ),
      child: Text(label),
    );
  }
}
