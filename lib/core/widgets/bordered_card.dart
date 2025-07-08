import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

class BorderedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool showHoverEffect;

  const BorderedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(ContextSpacing.md),
    this.margin = const EdgeInsets.only(bottom: ContextSpacing.md),
    this.borderColor,
    this.backgroundColor,
    this.showHoverEffect = true,
  });

  @override
  State<BorderedCard> createState() => _BorderedCardState();
}

class _BorderedCardState extends State<BorderedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: widget.borderColor ?? ContextColors.border,
      end: ContextColors.borderDark,
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

  void _handleHoverChange(bool isHovered) {
    if (!widget.showHoverEffect || widget.onTap == null) return;

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: MouseRegion(
        onEnter: (_) => _handleHoverChange(true),
        onExit: (_) => _handleHoverChange(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _borderColorAnimation,
            builder: (context, child) {
              return Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? ContextColors.background,
                  border: Border.all(
                    color: _borderColorAnimation.value ?? 
                           (widget.borderColor ?? ContextColors.border),
                    width: 2.0,
                  ),
                ),
                child: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}
