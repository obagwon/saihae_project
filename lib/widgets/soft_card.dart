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
        boxShadow: hasShadow
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
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