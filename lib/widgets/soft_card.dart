import 'package:flutter/material.dart';

import '../app/theme.dart';

class SoftCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool hasShadow;
  final Color? borderColor;

  const SoftCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.borderRadius = 24,
    this.hasShadow = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white.withOpacity(.94),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? AppColors.line.withOpacity(.62)),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: const Color(0xFF9B6D55).withOpacity(0.10),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(.9),
                  blurRadius: 0,
                  offset: const Offset(0, 1),
                ),
              ]
            : [],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: card,
    );
  }
}
