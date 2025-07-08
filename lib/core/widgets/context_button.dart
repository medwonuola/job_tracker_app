import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

enum ContextButtonVariant { primary, outline, success, warning }

class ContextButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ContextButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  const ContextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ContextButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<ContextButton> createState() => _ContextButtonState();
}

class _ContextButtonState extends State<ContextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return ContextColors.neutralLight;
              }
              
              switch (widget.variant) {
                case ContextButtonVariant.outline:
                  return Colors.transparent;
                case ContextButtonVariant.success:
                  return states.contains(WidgetState.pressed) || _isHovered
                      ? ContextColors.success.withValues(alpha: 0.9)
                      : ContextColors.success;
                case ContextButtonVariant.warning:
                  return states.contains(WidgetState.pressed) || _isHovered
                      ? ContextColors.warning.withValues(alpha: 0.9)
                      : ContextColors.warning;
                case ContextButtonVariant.primary:
                  return states.contains(WidgetState.pressed) || _isHovered
                      ? ContextColors.borderDark
                      : ContextColors.accent;
              }
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return ContextColors.neutral;
              }
              
              if (widget.variant == ContextButtonVariant.outline) {
                return ContextColors.textPrimary;
              }
              
              if (widget.variant == ContextButtonVariant.primary) {
                return states.contains(WidgetState.pressed) || _isHovered
                    ? ContextColors.accent
                    : ContextColors.textPrimary;
              }
              
              return Colors.white;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(),
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(
              color: _getBorderColor(),
              width: 2.0,
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(
              vertical: ContextSpacing.md,
              horizontal: ContextSpacing.lg,
            ),
          ),
          textStyle: WidgetStateProperty.all(textTheme.labelLarge),
        ),
        child: widget.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ContextColors.textPrimary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 18),
                    const SizedBox(width: ContextSpacing.xs),
                  ],
                  Text(widget.label),
                ],
              ),
      ),
    );
  }

  Color _getBorderColor() {
    switch (widget.variant) {
      case ContextButtonVariant.success:
        return ContextColors.success;
      case ContextButtonVariant.warning:
        return ContextColors.warning;
      case ContextButtonVariant.outline:
      case ContextButtonVariant.primary:
        return ContextColors.borderDark;
    }
  }
}
