import 'package:flutter/material.dart';

import '../app/theme.dart';

enum SoftCardTone { surface, hero, blush, sky, lavender, peach, mint, notice }

class SoftCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool hasShadow;
  final SoftCardTone tone;

  const SoftCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.onTap,
    this.borderRadius = AppRadii.card,
    this.hasShadow = true,
    this.tone = SoftCardTone.surface,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? _toneColor(),
        borderRadius: radius,
        border: Border.all(color: _borderColor()),
        boxShadow: hasShadow ? AppShadows.soft : [],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: card,
      ),
    );
  }

  Color _toneColor() {
    switch (tone) {
      case SoftCardTone.surface:
        return AppColors.white;
      case SoftCardTone.hero:
        return AppColors.warmIvory;
      case SoftCardTone.blush:
        return AppColors.blush;
      case SoftCardTone.sky:
        return AppColors.sky;
      case SoftCardTone.lavender:
        return AppColors.lavender;
      case SoftCardTone.peach:
        return AppColors.softPeach;
      case SoftCardTone.mint:
        return AppColors.mint;
      case SoftCardTone.notice:
        return AppColors.white.withValues(alpha: 0.72);
    }
  }

  Color _borderColor() {
    if (tone == SoftCardTone.notice || backgroundColor == AppColors.white) {
      return AppColors.line.withValues(alpha: 0.7);
    }

    return AppColors.white.withValues(alpha: 0.72);
  }
}
