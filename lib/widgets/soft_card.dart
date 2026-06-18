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
    final palette = context.palette;
    final radius = BorderRadius.circular(borderRadius);
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _resolveColor(context),
        borderRadius: radius,
        border: Border.all(color: _borderColor(palette)),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: palette.shadow,
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ]
            : [],
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

  Color _resolveColor(BuildContext context) {
    final palette = context.palette;
    final color = backgroundColor;

    if (color == AppColors.white) return palette.card;
    if (color == AppColors.cream) return palette.background;
    if (color == AppColors.warmIvory) return palette.hero;
    if (color == AppColors.blush) return palette.blush;
    if (color == AppColors.sky) return palette.sky;
    if (color == AppColors.lavender) return palette.lavender;
    if (color == AppColors.softPeach) return palette.peach;
    if (color == AppColors.mint) return palette.mint;
    if (color == AppColors.softBeige) return palette.notice;

    return color ?? _toneColor(palette);
  }

  Color _toneColor(AppPalette palette) {
    switch (tone) {
      case SoftCardTone.surface:
        return palette.card;
      case SoftCardTone.hero:
        return palette.hero;
      case SoftCardTone.blush:
        return palette.blush;
      case SoftCardTone.sky:
        return palette.sky;
      case SoftCardTone.lavender:
        return palette.lavender;
      case SoftCardTone.peach:
        return palette.peach;
      case SoftCardTone.mint:
        return palette.mint;
      case SoftCardTone.notice:
        return palette.notice;
    }
  }

  Color _borderColor(AppPalette palette) {
    if (tone == SoftCardTone.notice || backgroundColor == AppColors.white) {
      return palette.line.withValues(alpha: 0.7);
    }

    return palette.line.withValues(alpha: 0.45);
  }
}
