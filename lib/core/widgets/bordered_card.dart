import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/theme/app_spacing.dart';

class BorderedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const BorderedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(ContextSpacing.md),
    this.margin = const EdgeInsets.only(bottom: ContextSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            border: Border.all(
              color: ContextColors.border,
              width: 2.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
