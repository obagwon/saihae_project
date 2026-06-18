import 'package:flutter/material.dart';

import '../app/theme.dart';

class SoftCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool hasShadow;

  const SoftCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(22),
    this.onTap,
    this.borderRadius = 28,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.72),
        ),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ]
            : [],
      ),
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: card,
    );
  }
}
