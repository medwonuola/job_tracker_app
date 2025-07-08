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
  final bool isExpanded;

  const ContextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ContextButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  @override
  State<ContextButton> createState() => _ContextButtonState();
}

class _ContextButtonState extends State<ContextButton>
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
      case ContextButtonVariant.outline:
        return Colors.transparent;
      case ContextButtonVariant.success:
        return ContextColors.success;
      case ContextButtonVariant.warning:
        return ContextColors.warning;
      case ContextButtonVariant.primary:
        return ContextColors.accent;
    }
  }

  Color _getHoverBackgroundColor() {
    switch (widget.variant) {
      case ContextButtonVariant.outline:
        return Colors.transparent;
      case ContextButtonVariant.success:
        return ContextColors.success.withValues(alpha: 0.9);
      case ContextButtonVariant.warning:
        return ContextColors.warning.withValues(alpha: 0.9);
      case ContextButtonVariant.primary:
        return ContextColors.borderDark;
    }
  }

  Color _getForegroundColor() {
    if (widget.variant == ContextButtonVariant.outline) {
      return ContextColors.textPrimary;
    }
    
    if (widget.variant == ContextButtonVariant.primary) {
      return _isHovered ? ContextColors.accent : ContextColors.textPrimary;
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
                    return ContextColors.neutralLight;
                  }
                  return _backgroundColorAnimation.value ?? _getNormalBackgroundColor();
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return ContextColors.neutral;
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
                  vertical: ContextSpacing.md,
                  horizontal: ContextSpacing.lg,
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
        color: ContextColors.textPrimary,
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
        const SizedBox(width: ContextSpacing.xs),
        Text(widget.label),
      ],
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
