import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

enum AppButtonVariant { primary, outline, success, warning }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _animationController;
  late final Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _backgroundColorAnimation = ColorTween(
      begin: _getNormalBackgroundColor(),
      end: _getHoverBackgroundColor(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ),);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getNormalBackgroundColor() {
    switch (widget.variant) {
      case AppButtonVariant.outline:
        return Colors.transparent;
      case AppButtonVariant.success:
        return AppColors.success;
      case AppButtonVariant.warning:
        return AppColors.warning;
      case AppButtonVariant.primary:
        return AppColors.accent;
    }
  }

  Color _getHoverBackgroundColor() {
    switch (widget.variant) {
      case AppButtonVariant.outline:
        return Colors.transparent;
      case AppButtonVariant.success:
        return AppColors.success.withValues(alpha: 0.9);
      case AppButtonVariant.warning:
        return AppColors.warning.withValues(alpha: 0.9);
      case AppButtonVariant.primary:
        return AppColors.borderDark;
    }
  }

  Color _getForegroundColor() {
    if (widget.variant == AppButtonVariant.outline) {
      return AppColors.textPrimary;
    }
    
    if (widget.variant == AppButtonVariant.primary) {
      return _isHovered ? AppColors.accent : AppColors.textPrimary;
    }
    
    return Colors.white;
  }

  void _handleHoverChange(bool isHovered) {
    setState(() => _isHovered = isHovered);

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => _handleHoverChange(true),
      onExit: (_) => _handleHoverChange(false),
      child: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return AppColors.neutralLight;
                  }
                  return _backgroundColorAnimation.value ?? _getNormalBackgroundColor();
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return AppColors.neutral;
                  }
                  return _getForegroundColor();
                },
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(),
              ),
              side: WidgetStateProperty.all<BorderSide>(
                BorderSide(color: _getBorderColor(), width: 2.0),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.lg,
                ),
              ),
              textStyle: WidgetStateProperty.all(textTheme.labelLarge),
            ),
            child: widget.isLoading ? _buildLoadingIndicator() : _buildButtonContent(),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildButtonContent() {
    if (widget.icon == null) {
      return Text(widget.label);
    }

    return Row(
      mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(widget.icon, size: 18),
        const SizedBox(width: AppSpacing.xs),
        Text(widget.label),
      ],
    );
  }

  Color _getBorderColor() {
    switch (widget.variant) {
      case AppButtonVariant.success:
        return AppColors.success;
      case AppButtonVariant.warning:
        return AppColors.warning;
      case AppButtonVariant.outline:
      case AppButtonVariant.primary:
        return AppColors.borderDark;
    }
  }
}
