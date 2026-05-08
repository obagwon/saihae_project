import 'package:flutter/material.dart';

import '../app/theme.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool outlined;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ?? AppColors.blush;
    final Color fg = foregroundColor ?? AppColors.white;
    final style = ElevatedButton.styleFrom(
      backgroundColor: outlined ? AppColors.white : bg,
      foregroundColor: outlined ? (foregroundColor ?? AppColors.blushDark) : fg,
      disabledBackgroundColor: AppColors.softBeige,
      elevation: outlined ? 0 : 8,
      shadowColor: AppColors.blush.withOpacity(.24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: BorderSide(color: outlined ? AppColors.blush : Colors.transparent, width: 1.2),
      ),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
    );

    return SizedBox(
      width: double.infinity,
      child: icon == null
          ? ElevatedButton(onPressed: onPressed, style: style, child: Text(text))
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon, size: 18),
              label: Text(text),
            ),
    );
  }
}
