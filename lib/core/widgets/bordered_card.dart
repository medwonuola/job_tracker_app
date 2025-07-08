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

class _BorderedCardState extends State<BorderedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? ContextColors.background,
              border: Border.all(
                color: widget.borderColor ?? 
                    (_isHovered && widget.onTap != null && widget.showHoverEffect
                        ? ContextColors.borderDark
                        : ContextColors.border),
                width: 2.0,
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
