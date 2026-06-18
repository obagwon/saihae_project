import 'package:flutter/material.dart';

import '../app/theme.dart';

enum RoundedButtonVariant { primary, secondary, tonal, ghost }

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final RoundedButtonVariant variant;
  final bool isFullWidth;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.variant = RoundedButtonVariant.primary,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _colorsForVariant();
    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? colors.$1,
      foregroundColor: foregroundColor ?? colors.$2,
      disabledBackgroundColor: AppColors.softBeige,
      disabledForegroundColor: AppColors.textLight,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.button),
        side: BorderSide(color: colors.$3),
      ),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: foregroundColor ?? colors.$2,
            fontWeight: FontWeight.w800,
          ),
    );

    final button = icon == null
        ? ElevatedButton(onPressed: onPressed, style: style, child: Text(text))
        : ElevatedButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: 20),
            label: Text(text),
          );

    if (!isFullWidth) return button;

    return SizedBox(width: double.infinity, child: button);
  }

  (Color, Color, Color) _colorsForVariant() {
    switch (variant) {
      case RoundedButtonVariant.primary:
        return (AppColors.navy, AppColors.white, AppColors.navy);
      case RoundedButtonVariant.secondary:
        return (AppColors.white, AppColors.textDark, AppColors.line);
      case RoundedButtonVariant.tonal:
        return (AppColors.blush, AppColors.navy, AppColors.softPink);
      case RoundedButtonVariant.ghost:
        return (Colors.transparent, AppColors.textBrown, Colors.transparent);
    }
  }
}
